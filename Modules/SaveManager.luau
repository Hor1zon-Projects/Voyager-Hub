-- SaveManager.lua
-- I'm dead inside.

local SaveManager = {}
local HttpService = cloneref(game:GetService("HttpService")) -- just in case.

-- new check thing
local function safe_pcall(func, ...)
    local success, result = pcall(func, ...)
    return success and result or nil
end

local isfolder_supported = safe_pcall(isfolder, "test") ~= nil
local isfile_supported = safe_pcall(isfile, "test.txt") ~= nil
local makefolder_supported = safe_pcall(makefolder, "test") ~= nil
local writefile_supported = safe_pcall(writefile, "test.txt", "test") ~= nil
local readfile_supported = safe_pcall(readfile, "test.txt") ~= nil
local listfiles_supported = safe_pcall(listfiles, "test") ~= nil

SaveManager.Folder = "Voyager"
SaveManager.SubFolder = nil
SaveManager.FileName = "config.json"

if isfolder_supported and makefolder_supported and not isfolder(SaveManager.Folder) then
    makefolder(SaveManager.Folder)
end

function SaveManager:SetSubFolder(Name)
    self.SubFolder = Name and Name:gsub("[^%w%._-]", "_") or nil
    local folderPath = self.Folder .. "/" .. (self.SubFolder or "")

    if makefolder_supported and self.SubFolder and not isfolder(folderPath) then
        makefolder(folderPath)
    end
end

function SaveManager:Load()
    if not isfile_supported or not readfile_supported then return {} end

    local filePath = self:GetFilePath()
    if not isfile(filePath) then return {} end

    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)

    if not success then
        warn("[" .. SaveManager.Folder .. " - Save Manager] Failed to load data, creating backup & resetting:", data)
        if writefile_supported then
            writefile(filePath .. ".backup", readfile(filePath))
        end
        return {}
    end

    return data
end

function SaveManager:Save(flags)
    if not isfile_supported or not writefile_supported then return false end

    local filePath = self:GetFilePath()

    local folderPath = self.Folder .. "/" .. (self.SubFolder or "")
    if makefolder_supported and self.SubFolder and not isfolder(folderPath) then
        makefolder(folderPath)
    end

    local success, err = pcall(function()
        writefile(filePath, HttpService:JSONEncode(flags))
    end)

    if not success then
        warn("[" .. SaveManager.Folder .. " - Save Manager] Save Error:", err)
        return false
    end

    return true
end

function SaveManager:Delete()
    if not isfile_supported then return end
    local filePath = self:GetFilePath()
    if isfile(filePath) then delfile(filePath) end
end

function SaveManager:ListConfigs()
    if not listfiles_supported then return {} end

    local path = self.Folder
    if self.SubFolder then path = path .. "/" .. self.SubFolder end
    if not isfolder(path) then return {} end

    local files = listfiles(path)
    local configs = {}

    for _, file in ipairs(files) do
        if file:match("%.json$") then
            table.insert(configs, file:match("([^/]+)%.json$"))
        end
    end

    return configs
end

function SaveManager:GetFilePath()
    local path = self.Folder
    if self.SubFolder then path = path .. "/" .. self.SubFolder end
    return path .. "/" .. self.FileName
end

return SaveManager
