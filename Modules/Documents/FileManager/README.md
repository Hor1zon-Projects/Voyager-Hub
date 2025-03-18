
# File Manager

A module that handles custom files / site files, this makes it even more easier to use. Supports multiple executors, and organizes the files properly on the device's storage.

**SOME LINES ARE ONLY FOR VOYAGER [LITE]. FORK/EDIT IF YOU WANT TO USE THIS.**


## **Usage**

*I know, I know. It's a bad example but you get it.*

```luau
local FileManager = loadstring(game:HttpGet"https://raw.githubusercontent.com/Hor1zon-Projects/Voyager-Hub/refs/heads/main/Modules/FileManager.luau")()
local UI = -- ur UI

UI.Logo = FileManager:SetFile("Example","https://www.ikea.com/us/en/images/products/blahaj-soft-toy-baby-shark__0716615_pe730956_s5.jpg?f=xl", "jpg.")
```

