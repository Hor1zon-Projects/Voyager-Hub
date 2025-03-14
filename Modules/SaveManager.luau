-- SaveManager.lua
-- Don't expect much comments, its 5 hours and I'm tired.
-- (Why didn't you hide this?) There are many, MANY SaveManagers out there.

local SaveManager = {}
local HttpService = cloneref(game:GetService("HttpService")) -- Just in case.

-- checking if executor isn't shitty
if typeof(copyfunction) == "function" then
    local isfolder_copy, isfile_copy, listfiles_copy =
        copyfunction(isfolder), copyfunction(isfile), copyfunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder) return select(2, pcall(isfolder_copy, folder)) or false end
        isfile = function(file) return select(2, pcall(isfile_copy, file)) or false end
        listfiles = function(folder) return select(2, pcall(listfiles_copy, folder)) or {} end
    end
end

-- Save Managee Properties.
SaveManager.Folder = "Voyager" -- Oh remi why didn't you make a function to change this? BECAUSE IT'S MINE.
SaveManager.SubFolder = nil
SaveManager.FileName = "config.json"

if not isfolder(SaveManager.Folder) then makefolder(SaveManager.Folder) end

function SaveManager:SetSubFolder(Name)
    self.SubFolder = Name and Name:gsub("[^%w%._-]", "_") or nil
    if self.SubFolder and not isfolder(self.Folder .. "/" .. self.SubFolder) then
        makefolder(self.Folder .. "/" .. self.SubFolder)
    end
end

--\\ Save, Load, etc functions \\--

function SaveManager:Load()
    local filePath = self:GetFilePath()
    if not isfile(filePath) then return {} end

    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)

    if not success then
        warn("[" .. SaveManager.Folder ..  " - Save Manager] Failed to load data, creating backup & resetting:", data)
        writefile(filePath .. ".backup", readfile(filePath))
        return {}
    end

    return data
end


function SaveManager:Save(flags)
    local filePath = self:GetFilePath()

    if self.SubFolder and not isfolder(self.Folder .. "/" .. self.SubFolder) then
        makefolder(self.Folder .. "/" .. self.SubFolder)
    end

    local success, err = pcall(function()
        writefile(filePath, HttpService:JSONEncode(flags))
    end)

    if not success then
        warn("[" .. SaveManger.Folder .. "- Save Manager] Save Error:", err)
        return false
    end

    return true
end

function SaveManager:Delete()
    local filePath = self:GetFilePath()
    if isfile(filePath) then delfile(filePath) end
end

-- Debug Stuff

function SaveManager:ListConfigs()
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

-- Except this
function SaveManager:GetFilePath()
    local path = self.Folder
    if self.SubFolder then path = path .. "/" .. self.SubFolder end
    return path .. "/" .. self.FileName
end

return SaveManager
    
