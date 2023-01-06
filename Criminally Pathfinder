Debug = true
function Debug(...)
    if Debug then
        print(...)
    end
end

-- Covering problematic meshparts with parts so navmesh works better

for i,v in pairs(workspace:GetDescendants()) do
    if v:IsA("MeshPart") and (v.MeshId == "rbxassetid://6507305991" or v.MeshId == "rbxassetid://7555262504" or v.MeshId == "rbxassetid://7603957648" or v.MeshId == "rbxassetid://6507305956") then
        local CLP = Instance.new("Part")
        CLP.Anchored = true
        CLP.Position = v.Position
        CLP.Orientation = v.Orientation
        CLP.Size = v.Size
        CLP.Parent = workspace
        CLP.Transparency = 0.5
        CLP.Color = Color3.new(1, 0.568627, 0)
    end
    if v.Name == "BarbedWire" then
        v:Destroy()
    end
    if v:IsA("Part") and v.Size.Y == 13 and v.Color == Color3.fromRGB(17, 17, 17) and v.Material == Enum.Material.Metal then
        v:Destroy()
    end
end

-- Part to stop from trying to walk up railings on tower (Breaks the pathing for some reason)

-- local BlockingPart = Instance.new("Part")
-- BlockingPart.Position = Vector3.new(-4460.05, 64.9998, -800.67)
-- BlockingPart.Size = Vector3.new(1, 123.1, 23.7)
-- BlockingPart.Orientation = Vector3.new(0, 0, 0)
-- BlockingPart.Parent = workspace
-- BlockingPart.Color = Color3.new(1, 0.568627, 0)
-- BlockingPart.Transparency = 0.5
-- BlockingPart.Anchored = true

local ScreenGui = Instance.new("ScreenGui"); local StatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"); ScreenGui.ResetOnSpawn = false; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; ScreenGui.DisplayOrder = 1000; StatusLabel.Parent = ScreenGui; StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
StatusLabel.BackgroundTransparency = 1.000; StatusLabel.Position = UDim2.new(0.5, -190, 0.553361773, -25); StatusLabel.Size = UDim2.new(0, 380, 0, 29); StatusLabel.Font = Enum.Font.Code; StatusLabel.Text = "Loading autofarm..."; StatusLabel.TextColor3 = Color3.fromRGB(252, 255, 69)
StatusLabel.TextScaled = false; StatusLabel.TextSize = 20; StatusLabel.TextStrokeTransparency = 0.000; StatusLabel.TextWrapped = false

--//

local LocalizationService = game:GetService("LocalizationService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")

local function Status(Status)
    StatusLabel.Text = Status
end

BREAKMODE = "Lockpick" -- {Lockpick, Crowbar}
ONSEEN = "Stop" -- {Stop, Ignore}

local Safes = workspace.Map.BredMakurz
local SafeTypes = {"MediumSafe","SmallSafe","Register"}

--\\

local LockSprint = false
local PathfindingService = game:GetService("PathfindingService")
local Character = LocalPlayer.Character
local PlayerMod = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerMod:GetControls()
local CurrentlyPathing = false
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TweenI = TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
local VisualFolder = Instance.new("Folder",workspace)
local CurrentWaypoint = nil
VisualFolder.Name = "PathVisuals"

CurrentPath = nil

--/

local function UpdateVisualPoint(Point,Remove,Color)
	task.spawn(function()
		if Remove == true then
			TweenService:Create(Point,TweenI,{Color3 = Color3.new(0.454902, 0.454902, 0.454902)}):Play()
			TweenService:Create(Point,TweenI,{Transparency = 1}):Play()
			wait(1)
			Point.Parent:Destroy()
		else
			TweenService:Create(Point,TweenI,{Color3 = Color}):Play()
		end end)
end

local WalkTrack = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(LocalPlayer.Character.Animate.walk1.WalkAnim1)
local RunTrack = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(LocalPlayer.Character.Animate.run1.RunAnim1)
WalkTrack.Looped = true
RunTrack.Looped = true

local function Walk(bool)
    if bool and LockSprint == false then
        WalkTrack:Play(0.5,2,0.8)
    else
        WalkTrack:Stop(0.5)
    end
end

local function Run(bool)
    if bool and LockSprint then
        if WalkTrack.IsPlaying == true then
            Walk(false)
        end
        RunTrack:Play(0.5,3,1.2)
    else
        RunTrack:Stop(0.5)
    end
end

LockSprint = true

task.spawn(function()
    while wait() do
        LockSprint = true
        LocalPlayer.Character.Humanoid.WalkSpeed = 25
        wait(17)
        --LocalPlayer.Character.Humanoid.WalkSpeed = 12
        LockSprint = false
        wait(10)
    end
end)

-- local StaminaVal = 0
-- local SprintDB = false
-- game:GetService("ReplicatedStorage").Events2.StaminaChange.Event:Connect(function(Value,Max)
--     StaminaVal = math.floor(Value)
--     if StaminaVal > 70 and SprintDB == false then
--         task.spawn(function()
--             LockSprint = true
--             SprintDB = true
--             repeat wait() until StaminaVal < 10
--             SprintDB = false
--         end)
--     end
-- end)

local function FakeAnimationHandler()
    RunService.Heartbeat:Connect(function()
        local Velocity = LocalPlayer.Character.Torso.Velocity.Magnitude
        if Velocity > 0.1 and Velocity < 10 and WalkTrack.IsPlaying == false and LockSprint == false then
            Walk(true)
            Run(false)
        elseif Velocity > 10 and RunTrack.IsPlaying == false and LockSprint == true then
            Run(true)
            Walk(false)
        elseif Velocity < 0.1 and (WalkTrack.IsPlaying == true or RunTrack.IsPlaying == true) then
            Walk(false)
            Run(false)
        end
    end)
end

local function CreateVisualPoint(Position)
	local A = Instance.new("Part")
	local B = Instance.new("SelectionSphere")
	A.Anchored = true
	A.CanCollide = false
	A.Size = Vector3.new(0.001,0.001,0.001)
	A.Position = Position + Vector3.new(0,2,0)
	A.Transparency = 1
	A.Parent = VisualFolder
	A.Name = tostring(Position)
	B.Transparency = 1
	B.Parent = A
	B.Adornee = A
	B.Color3 = Color3.new(1, 0, 0.0156863)
	TweenService:Create(B,TweenI,{Transparency = 0}):Play()
end

local function checkVisibility()
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {player.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.IgnoreWater = true
			local result = workspace:Raycast(player.Character.Head.Position, (LocalPlayer.Character.PrimaryPart.Position - player.Character.Head.Position).Unit * 70)
			if result and result.Instance:IsDescendantOf(LocalPlayer.Character) then
				return true
			end
		end
	end
	return false
end

local function CanPathTo(Position)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 4,
        AgentCanJump = true,
        AgentCanClimb = true
    })

    local success, errorMessage = pcall(function()
        path:ComputeAsync(Character.HumanoidRootPart.Position,Position)
    end)

	--CurrentPath = PathfindService:FindPathAsync(Character.HumanoidRootPart.Position,CoordinateFrame.Position)
	if success and path.Status == Enum.PathStatus.Success then
        for i,v in pairs(path:GetWaypoints()) do
			CreateVisualPoint(v.Position)
		end
        return true
	end
    return false
end

local function Path2CFrame(CoordinateFrame)
	
	CurrentlyPathing = false
	
	for i,v in pairs(VisualFolder:GetChildren()) do
		UpdateVisualPoint(v.SelectionSphere,true)
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	Controls:Disable()
	-- Method 1 - Roblox pathfinding service

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 4,
        AgentCanJump = true,
        AgentCanClimb = true
    })

    local success, errorMessage = pcall(function()
        path:ComputeAsync(Character.HumanoidRootPart.Position,CoordinateFrame.Position)
    end)

	--CurrentPath = PathfindService:FindPathAsync(Character.HumanoidRootPart.Position,CoordinateFrame.Position)
	if success and path.Status == Enum.PathStatus.Success then
		CurrentPath = path

		CurrentlyPathing = true
		
		for i,v in pairs(CurrentPath:GetWaypoints()) do
			CreateVisualPoint(v.Position)
		end
		
		spawn(function()
			local TimesFailed = 0
            local TotalTimesFailed = 0
			while task.wait(0.5) and CurrentlyPathing == true do
				

				if TimesFailed == 2 then
                    repeat wait() until not checkVisibility()
					Debug("[!] Attempt to get unstuck failed, teleporting to next waypoint.")
					Character:PivotTo(CFrame.new(CurrentWaypoint.Position + Vector3.new(0,4,0)))
					Humanoid.WalkToPoint = CurrentWaypoint.Position
					TimesFailed = 0
				end
				
				if (Character.HumanoidRootPart.Velocity).Magnitude < 0.07 then
					Humanoid.WalkToPoint = CurrentWaypoint.Position
					task.wait(0.2)
					if (Character.HumanoidRootPart.Velocity).Magnitude < 0.07 then -- Double check
                        local targetPosition = CurrentWaypoint.Position
                        local characterPosition = game.Players.LocalPlayer.Character.PrimaryPart.Position
                        local dx = targetPosition.X - characterPosition.X
                        local dz = targetPosition.Z - characterPosition.Z
                        local distance = math.sqrt(dx*dx + dz*dz)
                        if distance < 3 and not checkVisibility() then
                            Debug("[!] Stuck, Teleporting to next waypoint.")
                            Character:PivotTo(CFrame.new(CurrentWaypoint.Position + Vector3.new(0,4,0)))
                            Humanoid.WalkToPoint = CurrentWaypoint.Position
                            TimesFailed = 0
                        else
                            TimesFailed = TimesFailed + 1
                            TotalTimesFailed = TotalTimesFailed + 1
                            Debug("[!] Stuck, attempting to jump.")
                            Humanoid.Jump = true
                            wait()
                            Humanoid.WalkToPoint = CurrentWaypoint.Position
                        end
					end
				else
					TimesFailed = 0
				end
				
			end
		end) -- should be seperate thread but keeps yielding next loop? (SOLVED, jumping cancels moveto)
		
		for i,v in pairs(CurrentPath:GetWaypoints()) do

			UpdateVisualPoint(VisualFolder[tostring(v.Position)].SelectionSphere,false,Color3.new(0.0980392, 1, 0))
			
			CurrentWaypoint = v
			Humanoid.WalkToPoint = v.Position

			Debug("[Debug] WalkToPoint set to ",v.Position)

			repeat task.wait() until (Character.HumanoidRootPart.Position - v.Position).Magnitude < 3.8
			
			if CurrentPath:GetWaypoints()[i+1] ~= nil and CurrentPath:GetWaypoints()[i+1].Action == Enum.PathWaypointAction.Jump then
				task.spawn(function()
					task.wait(0.1)
					Humanoid.Jump = true
				end)
			end

			UpdateVisualPoint(VisualFolder[tostring(v.Position)].SelectionSphere,true)

		end
		Status("Pathing complete!")
		CurrentlyPathing = false
		Controls:Enable()
        return true
	else
		CurrentlyPathing = false
		Status("[!] Method 1 failed. Utilizing fallback.")
        wait(1)
		-- Method 2 - Custom pathfinding (Slow)
        -- did not actually implement this lol, might add A* later.
        return false
	end
end

-- click to move basically ^

local function checkRaycastObstruction(startPos, endPos)
    
    local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
	local result = workspace:Raycast(startPos, endPos - startPos, raycastParams)

	-- Check if the raycast hit anything
	if result then
		-- Return the hit object and the hit position
		return result.Instance, result.Position
	else
		-- Return nil if the raycast did not hit anything
		return nil
	end
end

local function GetClosest(instances, origin)
    -- Initialize variables for the closest instance and distance
    local closestInstance = nil
    local closestDistance = math.huge
  
    -- Iterate through all the instances in the table
    for _, instance in pairs(instances) do
      -- Calculate the distance between the origin and the current instance
      local distance = (origin.Position - instance.PosPart.Position).magnitude
  
      -- If the distance is smaller than the current closest distance,
      -- update the closest instance and distance
      if distance < closestDistance then
        closestInstance = instance
        closestDistance = distance
      end
    end
  
    -- Return the closest instance
    return closestInstance
end

local function IsBroken(Safe)
    if Safe:FindFirstChild("Values") and Safe.Values.Broken.Value == false then
        return false
    end
    return true
end

local function OpenDoor(DoorModel)
    
    if DoorModel.Values.Open.Value == false then

        if DoorModel.Values.CanLock.Value == true and DoorModel.Values.Locked.Value == true then
            local args = {
                [1] = "Unlock",
                [2] = DoorModel.Lock
            }
            
            DoorModel.Events.Toggle:FireServer(unpack(args))   
        end

        wait(0.5)

        local ClosestKnob

        if (DoorModel.Knob1.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < (DoorModel.Knob2.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude then
            ClosestKnob = DoorModel.Knob1
        else
            ClosestKnob = DoorModel.Knob2
        end

        local args = {
            [1] = "Open",
            [2] = ClosestKnob
        }
        
        DoorModel.Events.Toggle:FireServer(unpack(args))  
        
        wait(0.5)
    end

end

local function LockPickSafe(Safe)
    if not IsBroken(Safe) and LocalPlayer.Character:FindFirstChild("Lockpick") or LocalPlayer.Backpack:FindFirstChild("Lockpick") then
        if Safe.Name:find("Register") then
            
        else
            local Lockpick
        if LocalPlayer.Character:FindFirstChild("Lockpick") then 
            Lockpick = LocalPlayer.Character:FindFirstChild("Lockpick")
        elseif LocalPlayer.Backpack:FindFirstChild("Lockpick") then
            LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Lockpick"))
            Lockpick = LocalPlayer.Character:FindFirstChild("Lockpick")
        end
        
        local args = {
            [1] = "S",
            [2] = Safe,
            [3] = "s"
        }
        
        local v34 = Lockpick.Remote:InvokeServer(unpack(args))

        wait()
        
        local args = {
            [1] = "D",
            [2] = Safe,
            [3] = "s",
            [4] = v34
        }
        
        game:GetService("Players").LocalPlayer.Character.Lockpick.Remote:InvokeServer(unpack(args))
        

        local args = {
            [1] = "C"
        }
        
        Lockpick.Remote:InvokeServer(unpack(args))
        end
    end
end

local function GetClosestSafe()
    local ActiveSafes = {}
    local PathsFound = 0
    for Index,Safe in pairs(Safes:GetChildren()) do
        Status("Computing paths... " .. tostring(math.floor(100 * (Index / #Safes:GetChildren()))) .. "% | " .. tostring(PathsFound) .. " Found.")
        if IsBroken(Safe) == false and Safe.PosPart and Safe.PosPart.Position.Y > -38 and CanPathTo(Safe.PosPart.Position) then
            PathsFound = PathsFound + 1
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 34)
            table.insert(ActiveSafes,Safe)
        end
    end
    VisualFolder:ClearAllChildren()
    StatusLabel.TextColor3 = Color3.fromRGB(252, 255, 69)
    return GetClosest(ActiveSafes,LocalPlayer.Character.HumanoidRootPart)
end

-- Main loop

task.defer(FakeAnimationHandler)


local function GetRegister(Studs)
    local Part;
    for _, v in ipairs(game:GetService("Workspace").Map.BredMakurz:GetChildren()) do
        if v:FindFirstChild("MainPart") and string.find(v.Name, "Register") and v:FindFirstChild("Values").Broken.Value == false then
            local Distance = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChild("MainPart").Position).Magnitude
            if Distance < Studs then
                Studs = Distance
                Part = v:FindFirstChild("MainPart")
            end
        end
    end
    return Part
end

local AutoBreakRegisterCoolDown = false
local CashCoolDown = false

local SpoofTable = {
    WalkSpeed = 16,
    JumpPower = 50
}

-- // __newindex hook
local __newindex
__newindex = hookmetamethod(game, "__newindex", function(t, k, v)
    -- // Make sure it's trying to set our humanoid's ws/jp
    if (not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower")) and LockSprint == true then
        -- // Add values to spoof table
        SpoofTable[k] = v
        -- // Disallow the set
        return
    end
    
    -- //
    return __newindex(t, k, v)
end)

for i,v in pairs(getgc(true)) do
    if typeof(v) == 'table' and typeof(rawget(v, 'A')) == "function" then
        v.A = function()

        end
    end
    if typeof(v) == 'table' and typeof(rawget(v, 'B')) == "function" then
        v.B = function()

        end
    end
    if typeof(v) == 'table' and rawget(v, 'GP') then
        v.GP = function()

        end
    end
    if typeof(v) == 'table' and rawget(v, 'EN') then
        v.EN = function()

        end
    end
end

while wait() do
    Status("Computing paths...")
    local TargetSafe = GetClosestSafe()
    if TargetSafe then
        Status("Pathfinding to " .. TargetSafe.Name)
        Path2CFrame(TargetSafe.PosPart.CFrame)
        
        if TargetSafe.Name:find("Register") then
            if LocalPlayer.Character:FindFirstChild("Fists") then
                local ClosestRegister = GetRegister(10)
                if ClosestRegister and not AutoBreakRegisterCoolDown then
                    AutoBreakRegisterCoolDown = true
                    local AutoBreakRegisterValue = game:GetService("ReplicatedStorage").Events["XMHH.1"]:InvokeServer("\240\159\154\168", tick(), game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool"), "DZDRRRKI", ClosestRegister.Parent, "Register")
                    game:GetService("ReplicatedStorage").Events["XMHH2.1"]:FireServer("\240\159\154\168", tick(), game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool"), "2389ZFX33", AutoBreakRegisterValue, false, game:GetService("Players").LocalPlayer.Character["Right Arm"], ClosestRegister, ClosestRegister.Parent, ClosestRegister.Position, ClosestRegister.Position)
                    wait(0.5)
                    AutoBreakRegisterCoolDown = false
                end
            else
                LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack.Fists)
                local ClosestRegister = GetRegister(10)
                if ClosestRegister and not AutoBreakRegisterCoolDown then
                    AutoBreakRegisterCoolDown = true
                    local AutoBreakRegisterValue = game:GetService("ReplicatedStorage").Events["XMHH.1"]:InvokeServer("\240\159\154\168", tick(), game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool"), "DZDRRRKI", ClosestRegister.Parent, "Register")
                    game:GetService("ReplicatedStorage").Events["XMHH2.1"]:FireServer("\240\159\154\168", tick(), game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool"), "2389ZFX33", AutoBreakRegisterValue, false, game:GetService("Players").LocalPlayer.Character["Right Arm"], ClosestRegister, ClosestRegister.Parent, ClosestRegister.Position, ClosestRegister.Position)
                    wait(0.5)
                    AutoBreakRegisterCoolDown = false
                end
            end
            wait(2)
            local CashToGet = {}
            for i, v in pairs(game:GetService("Workspace").Filter.SpawnedBread:GetChildren()) do
                if game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    if (TargetSafe.PosPart.Position - v.Position).Magnitude < 20 then
                        table.insert(CashToGet,v)
                    end
                end
            end
            for i, v in pairs(CashToGet) do
                if game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    game:GetService("ReplicatedStorage").Events.CZDPZUS:FireServer(v)
                    wait(1.5)
                end
            end
            game:GetService("Players").LocalPlayer.Character.Humanoid:UnequipTools()
        else
            LockPickSafe(TargetSafe)
            wait(2)
            local CashToGet = {}
            for i, v in pairs(game:GetService("Workspace").Filter.SpawnedBread:GetChildren()) do
                if game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    if (TargetSafe.PosPart.Position - v.Position).Magnitude < 20 then
                        table.insert(CashToGet,v)
                    end
                end
            end
            for i, v in pairs(CashToGet) do
                if game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    game:GetService("ReplicatedStorage").Events.CZDPZUS:FireServer(v)
                    wait(1.5)
                end
            end
            game:GetService("Players").LocalPlayer.Character.Humanoid:UnequipTools()
        end
    end
end








-- task.spawn(function()
--     while wait() do
--         if LocalPlayer.Character:FindFirstChild("Fists") then
--             local ClosestRegister = GetRegister(10)
--             if ClosestRegister and not AutoBreakRegisterCoolDown then
--                 AutoBreakRegisterCoolDown = true
--                 local AutoBreakRegisterValue = game:GetService("ReplicatedStorage").Events["XMHH.1"]:InvokeServer("\240\159\154\168", tick(), game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool"), "DZDRRRKI", ClosestRegister.Parent, "Register")
--                 game:GetService("ReplicatedStorage").Events["XMHH2.1"]:FireServer("\240\159\154\168", tick(), game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool"), "2389ZFX33", AutoBreakRegisterValue, false, game:GetService("Players").LocalPlayer.Character["Right Arm"], ClosestRegister, ClosestRegister.Parent, ClosestRegister.Position, ClosestRegister.Position)
--                 wait(0.5)
--                 AutoBreakRegisterCoolDown = false
--             end
--         end
--     end
-- end)
