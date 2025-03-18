
# Save Manager

A module that handles **Save Files**, this module organizes the files properly. This is based on another save mananger but my take on it, I forgot which it is, but just in case I'ma open source it.

**SOME LINES ARE ONLY FOR VOYAGER [LITE]. FORK/EDIT IF YOU WANT TO USE THIS.**


## **Usage**

```luau
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hor1zon-Projects/Voyager-Hub/refs/heads/main/Modules/SaveManager.luau"))()

SaveManager:SetSubFolder("NameHere")
print(SaveManager:ListConfigs())
local Flags = SavaManager:Load()

Flags.Example = true

SaveManager:Save(Flags)

task.wait(10)
SaveManager:Delete() --// Used for debugging or smth.

```

