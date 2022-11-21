if _G.PredictionVal == nil then
	_G.PredictionVal = 0.19
end

local events = game:GetService("ReplicatedStorage").Communication.Events
local functions = game:GetService("ReplicatedStorage").Communication.Functions
for i,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v,"Remote") then
        v.Remote.Name = v.Name
    end
end
local oldnamecall; oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod();
  
    if (method == "Kick" or method == "kick") and self == game.Players.LocalPlayer then
        return;
    end
  
    return oldnamecall(self, unpack(args))
end)
game.CollectionService:AddTag(game:GetService("Workspace").Map,'CAMERA_COLLISION_IGNORE_LIST')
if _G.Wallbang == nil then
    _G.Wallbang = true
end
if _G.Wallbang then
    game.CollectionService:AddTag(game:GetService("Workspace").Map,'RANGED_CASTER_IGNORE_LIST')
end
local LocalPlayer = game.Players.LocalPlayer
local ARROW
local shot = false
local arrowsshooted = 0
local predicted
local silentaim = true
local Players = game.Players
local mouse = LocalPlayer:GetMouse()
local function getClosestToMouse() -- got this from cheese bcuz im too lazy again and yes he got from devforum
    local player, nearestDistance = nil, math.huge*9e9
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local root, visible = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if visible then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(root.X, root.Y)).Magnitude

                if distance < nearestDistance then
                    nearestDistance = distance
                    player = v
                end
            end
        end
    end
    return player
end
if _G.NoSpread == nil then
    _G.NoSpread = true
end
if _G.NoRecoil == nil then
    _G.NoRecoil = true
end
if _G.NoGravity == nil then
    _G.NoGravity = true
end
if _G.InfDistance == nil then
    _G.InfDistance = true
end
if _G.ShootAfterCharge == nil then
    _G.ShootAfterCharge = true
end
for i,v in pairs(getgc(true)) do
    if typeof(v) == 'table' and rawget(v,'maxSpread') then
        if _G.NoSpread then
            v.maxSpread = 0
        end
        if _G.NoRecoil then
            v.recoilYMin = 0
            v.recoilZMin = 0
            v.recoilXMin = 0
            v.recoilYMax = 0
            v.recoilZMax = 0
            v.recoilXMax = 0
        end
        if _G.NoGravity then
            v.gravity = Vector3.new(0,0,0)
        end
        if _G.InfDistance then
            v.maxDistance = 999999
        end
        if _G.ShootAfterCharge then
            v.startShootingAfterCharge = true
        end
    end
end
local box = Instance.new("SelectionBox",workspace)
workspace.EffectsJunk.ChildAdded:Connect(function(p)
    task.wait() -- yields to prevent some shit lol!
    if LocalPlayer.Character:FindFirstChildOfClass("Tool") == nil then
        shot = false
        return
    end
    local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if Tool:FindFirstChild("ClientAmmo") == nil then
        shot = false
        return
    end
    if (shot and p:IsA("MeshPart") and p:FindFirstChild("Tip") ~= nil) then
        ARROW = p
        box.Adornee = p
        shot = false
    end
end)

for i,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v,"shoot") then
        local Old = v.shoot
        v.shoot = function(tbl)
            shot = true
            arrowsshooted = tbl.shotIdx
            return Old(tbl)
        end
    end
    
    if typeof(v) == "table" and rawget(v,"calculateFireDirection") then
        old = v.calculateFireDirection
        v.calculateFireDirection = function(p3,p4,p5,p6)
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool:FindFirstChild("ClientAmmo") == nil then
                return old(p3,p4,p5,p6)
            end
            if (shot and silentaim) then
                if not predicted then
                    return old(p3,p4,p5,p6)
                else
                    return predicted
                end
            end
            return old(p3,p4,p5,p6)
        end
    end
end
if _G.HitPart == nil then
    _G.HitPart = "Head"
end
local Parts = {"Head","HumanoidRootPart","Torso","Left Leg","Right Leg","Left Arm","Right Arm"}
for i,v in pairs(Parts) do
    if _G.HitPart ~= v then
        _G.HitPart = "Head"
    end
end
firehit = function(character,arrow)
    local fakepos = character[_G.HitPart].Position + Vector3.new(math.random(1,5),math.random(1,5),math.random(1,5))
    local args = {
        [1] = LocalPlayer.Character:FindFirstChildOfClass("Tool"),
        [2] = character[_G.HitPart],
        [3] = fakepos,
        [4] = character[_G.HitPart].CFrame:ToObjectSpace(CFrame.new(fakepos)),
        [5] = fakepos * Vector3.new(math.random(1,5),math.random(1,5),math.random(1,5)),
        [6] = tostring(arrowsshooted)
    }
    game:GetService("ReplicatedStorage").Communication.Events.RangedHit:FireServer(unpack(args))
end
local bruh = Instance.new("SelectionBox",workspace)
bruh.Color3 = Color3.fromRGB(163, 61, 54)
local M = game.Players.LocalPlayer:GetMouse()
local Cam = game.Workspace.CurrentCamera
-- dev forum
function WorldToScreen(Pos)
    local point = Cam.CoordinateFrame:pointToObjectSpace(Pos)
    local aspectRatio = M.ViewSizeX / M.ViewSizeY
    local hfactor = math.tan(math.rad(Cam.FieldOfView) / 2)
    local wfactor = aspectRatio*hfactor

    local x = (point.x/point.z) / -wfactor
    local y = (point.y/point.z) /  hfactor

    return Vector2.new(M.ViewSizeX * (0.5 + 0.5 * x), M.ViewSizeY * (0.5 + 0.5 * y))
end
local closest
local Prediction
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Aiming = Instance.new("TextLabel")
local Position = Instance.new("TextLabel")
local PredictionV = Instance.new("TextLabel")

--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
Frame.Position = UDim2.new(0.100260414, 0, 0.349072516, 0)
Frame.Size = UDim2.new(0, 10, 0, 10)

UICorner.CornerRadius = UDim.new(10, 10)
UICorner.Parent = Frame

Aiming.Name = "Aiming"
Aiming.Parent = Frame
Aiming.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Aiming.BackgroundTransparency = 1.000
Aiming.BorderColor3 = Color3.fromRGB(27, 42, 53)
Aiming.Position = UDim2.new(-9.5, 0, 1.99999988, 0)
Aiming.Size = UDim2.new(0, 200, 0, 11)
Aiming.Font = Enum.Font.SpecialElite
Aiming.Text = "Aiming At: None"
Aiming.TextColor3 = Color3.fromRGB(255, 255, 255)
Aiming.TextSize = 14.000

Position.Name = "Position"
Position.Parent = Frame
Position.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Position.BackgroundTransparency = 1.000
Position.BorderColor3 = Color3.fromRGB(27, 42, 53)
Position.Position = UDim2.new(-9.5, 0, 3.99999988, 0)
Position.Size = UDim2.new(0, 200, 0, 11)
Position.Font = Enum.Font.SpecialElite
Position.Text = "Position: None"
Position.TextColor3 = Color3.fromRGB(255, 255, 255)
Position.TextSize = 14.000

PredictionV.Name = "PredictionV"
PredictionV.Parent = Frame
PredictionV.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PredictionV.BackgroundTransparency = 1.000
PredictionV.BorderColor3 = Color3.fromRGB(27, 42, 53)
PredictionV.Position = UDim2.new(-9.5, 0, 5.99999988, 0)
PredictionV.Size = UDim2.new(0, 200, 0, 11)
PredictionV.Font = Enum.Font.SpecialElite
PredictionV.Text = "Prediction Value: ".._G.PredictionVal
PredictionV.TextColor3 = Color3.fromRGB(255, 255, 255)
PredictionV.TextSize = 14.000

UIStroke.Thickness = 2
UIStroke.Parent = Frame
if _G.Percent == nil then
    _G.Percent = 100
end
if _G.InstantCharge == nil then
    _G.InstantCharge = true
end
if _G.HitDistance == nil then
    _G.HitDistance = 15
end
local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/juywvm/ui-libs/main/RB_IMGUI_V2_SEXXYY/source.lua"))()

local window1 = engine.new({
    text = "Ngdat Hax",
    size = UDim2.new(300, 200),
})

window1.open()

local tab1 = window1.new({
    text = "Main stuff",
})

local label1 = tab1.new("label", {
    text = "this is a cool tab",
    color = Color3.new(1, 0, 0),
})

local switch1 = tab1.new("slientaim", {
    text = "Slient Aim";
})
switch1.set(false)
switch1.event:Connect(function(bool)
    slientaim = bool
end)

local slider1 = tab1.new("slider", {
    text = "Hit Percent",
    color = Color3.new(0.8, 0.5, 0),
    min = 1,
    max = 100,
    value = 600.1,
    rounding = 1,
})
slider1.event:Connect(function(x)
    _G.HitPercent = x
end)
slider1.set(420.69)


local switch1 = tab1.new("_G.Spread", {
    text = "No Spread";
})
switch1.set(false)
switch1.event:Connect(function(bool)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            if bool then
                v.maxSpread = 0
            else
                v.maxSpread = 0.35
            end
        end
    end
end)

local slider1 = tab1.new("slider", {
    text = "Hit Distance",
    color = Color3.new(0.8, 0.5, 0),
    min = 5,
    max = 15,
    value = 600.1,
    rounding = 1,
})
slider1.event:Connect(function(x)
    _G.HitDistance = x
end)
slider1.set(15)


local switch1 = tab1.new("_G.NoGravity", {
    text = "No Gravity";
})
switch1.set(false)
switch1.event:Connect(function(bool)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            if val then
                v.gravity = Vector3.new(0,0,0)
            else
                v.gravity = Vector3.new(0,-10,0)
            end
        end
    end
end)

local switch1 = tab1.new("_G.InfDistance", {
    text = "Inf Distance";
})
switch1.set(false)
switch1.event:Connect(function(bool)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            if bool then
                v.maxDistance = 999999
            else
                v.maxDistance = 1000
            end
        end
    end
end)

local switch1 = tab1.new("_G.ShootAfterCharge", {
    text = "Shoot after charge";
})
switch1.set(false)
switch1.event:Connect(function(bool)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'maxSpread') then
            v.startShootingAfterCharge = bool
        end
    end
end)
local switch1 = tab1.new("slientaim", {
    text = "No reload cancel";
})
switch1.set(false)
switch1.event:Connect(function(bool)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v,'cancelReload') then
            if oldcancel == nil then
                oldcancel = v.cancelReload
            end
            
            if bool then
                v.cancelReload = function(e)
                   return
                end
            else
                v.cancelReload = oldcancel
            end
        end
    end
end)

local switch1 = tab1.new("_G.Wallbang", {
    text = "Wallbang";
})
switch1.set(false)
switch1.event:Connect(function(bool)
    if bool then
        game.CollectionService:AddTag(game:GetService("Workspace").Map,'RANGED_CASTER_IGNORE_LIST')
    else
        game.CollectionService:RemoveTag(game:GetService("Workspace").Map,'RANGED_CASTER_IGNORE_LIST')
    end
end)

local dropdown1 = tab1.new("dropdown", {
    text = "Hit Part",
})
dropdown1.new("head")
dropdown1.new("HumanoidRootPart")
dropdown1.new("Torso")
dropdown1.new("Left leg")
dropdown1.new("Right Leg")
dropdown1.new("Left Arm")
dropdown1.new("Right Arm")
dropdown1.event:Connect(function(name)
    _G.HitPart = name
end)

folder1.open()
while wait() do
    pcall(function()
        local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if Tool:FindFirstChild("ClientAmmo") == nil then
            return
        end
        closest = getClosestToMouse()
        if closest then
            bruh.Adornee = closest.Character
            Aiming.Text = "Aiming At: "..closest.Name
            PredictionV.Text = "Prediction Value: ".._G.PredictionVal
            Prediction = closest.Character.Head.CFrame + (closest.Character.Head.Velocity * _G.PredictionVal + Vector3.new(0, .1, 0))
            predicted = (CFrame.lookAt(Tool.Contents.Handle.FirePoint.WorldCFrame.Position, Prediction.Position)).LookVector * 30;
            Position.Text = "Position: "..Prediction.Position.X..", "..Prediction.Y..", "..Prediction.Y
            local Vec = WorldToScreen(Prediction.Position)
            Frame.Position = UDim2.new(0,Vec.X,0,Vec.Y)
        end
        if (ARROW and silentaim) then
            if closest then
                if (ARROW.Position - closest.Character.HumanoidRootPart.Position).Magnitude <= _G.HitDistance then
                    if _G.Percent == 100 then
                        firehit(closest.Character,ARROW)
                        ARROW = nil
                        shot = false
                    elseif _G.Percent ~= 100 then
                        local percent = math.random(1,100)
                        
                        if percent >= Percent then
                            firehit(closest.Character,ARROW)
                            ARROW = nil
                            shot = false
                        end
                    end
                end
            end
        end
        
        if LocalPlayer.Character then
            if (LocalPlayer.Character:FindFirstChild('Longbow') and _G.InstantCharge) then
                for i,v in pairs(getconnections(Tool.ChargeProgressClient:GetPropertyChangedSignal("Value"))) do
                    v:Disable()
                end            
                Tool.ChargeProgressClient.Value = 1
            end
        end
    end)
end
