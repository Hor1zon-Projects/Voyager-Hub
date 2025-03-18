--UICreator.luau
local UICreator = {}
local TweenService = game:GetService("TweenService")

--// This is my take on Creator Module. (Original from: Wind UI, by .ftgs)

UICreator.DefaultProperties = {
    ScreenGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = "Sibling",
    },Frame = {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.new(1,1,1),
    },TextLabel = {
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        Text = "",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 14,
    },ImageLabel = {
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    },ImageButton = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        AutoButtonColor = false,
    },
}

function UICreator.New(Name, Properties, Children)
    assert(typeof(Name) == "string", "Name must be a string")
    local Object = Instance.new(Name)

    local DefaultProps = UICreator.DefaultProperties[Name] or {}

    for PropName, Value in pairs(DefaultProps) do
        Object[PropName] = Value
    end

    if Properties then
        for PropName, Value in pairs(Properties) do
            Object[PropName] = Value
        end
    end

    if Children then
        for _, Child in pairs(Children) do
            Child.Parent = Object
        end
    end

    return Object
end


function Creator.Tween(Object, Time, Properties, ...)
    assert(Object and Time and Properties, "Invalid arguments to Tween")
    return TweenService:Create(Object, TweenInfo.new(Time, ...), Properties)
end


return UICreator
