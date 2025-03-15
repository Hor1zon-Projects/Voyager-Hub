-- FileManager.lua
local FileManager = {}

FileManager.BaseFolder = "Voyager" -- just in case
FileManager.AssetsFolder = FileManager.BaseFolder .. "/assets"

if not isfolder(FileManager.BaseFolder) then makefolder(FileManager.BaseFolder) end
if not isfolder(FileManager.AssetsFolder) then makefolder(FileManager.AssetsFolder) end

-- vvv Useless
--[[function FileManager.CheckFile(filePath)
    if not isfile(filePath) then
        writefile(filePath, defaultContent or "")
        warn("[Voyager] Created missing file:", filePath)
    end
    return filePath
end--]]

--// Functions
function FileManager:SetFile(fileName,fileUrl,fileExtension) -- Lazy
    if not isfile(filePath) then
        FileManager.DownloadFile(fileName,fileUrl,fileExtension)
    end
    FileManager.GetAsset(fileName, fileExtension)
end

function FileManager.DownloadFile(fileName, fileUrl, fileExtension)
    assert(fileName, "File name is required.")
    assert(fileUrl, "File URL is required.")
    fileExtension = fileExtension or ".png"

    local filePath = FileManager.AssetsFolder .. "/" .. fileName .. fileExtension

    if isfile(filePath) then
        return filePath
    end

    local success, result = pcall(function()
        return game:HttpGet(fileUrl, true)
    end)

    if success and result then
        writefile(filePath, result)
        return filePath
    else
        warn("[Voyager] Failed to download file:", result)
        return nil
    end
end

function FileManager.GetAsset(fileName, fileExtension)
    fileExtension = fileExtension or ".png"
    local filePath = FileManager.AssetsFolder .. "/" .. fileName .. fileExtension

    if isfile(filePath) then
        return getsynasset(filePath) or getcustomasset(filePath) or warn("[Voyager] Executor not supported")
    else
        warn("[Voyager] File not found:", filePath)
        return nil
    end
end

return FileManager
