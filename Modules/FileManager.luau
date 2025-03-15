-- FileManager.luau
local FileManager = {}

FileManager.BaseFolder = "Voyager" -- already created by save manager but just in-case.
FileManager.AssetsFolder = FileManager.BaseFolder .. "/assets"

if not isfolder(FileManager.BaseFolder) then makefolder(FileManager.BaseFolder) end
if not isfolder(FileManager.AssetsFolder) then makefolder(FileManager.AssetsFolder) end

--// Functions
function FileManager.DownloadImage(imageName, imageUrl)
    assert(imageName, "Image name is required.")
    assert(imageUrl, "Image URL is required.")

    local filePath = FileManager.AssetsFolder .. "/" .. imageName .. ".png"

    if isfile(filePath) then
        return filePath
    end

    local success, result = pcall(function()
        return game:HttpGet(imageUrl, true)
    end)

    if success and result then
        writefile(filePath, result)
        return filePath
    else
        warn("[Voyager] Failed to download image:", result)
        return nil
    end
end

function FileManager.GetImageAsset(imageName)
    local filePath = FileManager.AssetsFolder .. "/" .. imageName .. ".png"

    if isfile(filePath) then
        return getsynasset(filePath) or getcustomasset(filePath) or warn("EXECUTOR NOT SUPPORTED.")
    else
        warn("[Voyager] Image not found:", imageName)
        return nil
    end
end

return FileManager
