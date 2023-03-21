local NPCS = {}

    for i, v in pairs(game:GetService("Workspace").EnemyNPCs:GetDescendants()) do
        if v:IsA "Model" and v:FindFirstChild("HumanoidRootPart") then
            if not table.find(NPCS, tostring(v)) then
            table.insert(NPCS, tostring(v))
        end
    end
end



local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "NtdHub | Anime Lost Simulator [Update1]",
   LoadingTitle = "Script Loadings",
   LoadingSubtitle = "by Ng Thanh Dat",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Ntd Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD.
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Ntd Hub",
      Subtitle = "Key System",
      Note = "Join the discord to get key!",
      FileName = "ntdsystem",
      SaveKey = true,
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = "datdev"
   }
})

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image
local Toggle = Tab:CreateToggle({
   Name = "Auto Swing",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
     a = Value
     while a do task.wait()
        game:GetService("ReplicatedStorage").Remotes.attack:FireServer()
        end
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Auto Mob",
   CurrentValue = false,
   Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
     b = Value
     while b do task.wait()
                    pcall(function()
                    
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getNPC().UpperTorso.CFrame
            end)
        end
   end,
})

local Dropdown = Tab:CreateDropdown({
   Name = "Select Mob",
   Options = NPCS
   CurrentOption = "Option 1"
   Flag = "Dropdown1", 
   Callback = function(Option)
       getgenv().mobname = Option
   end,
})

local Button = Tab:CreateButton({
   Name = "Refesh Mob",
   Callback = function()
     table.clear(NPCS)
            for i, v in pairs(game:GetService("Workspace").EnemyNPCs:GetDescendants()) do
                if v:IsA "Model" and v:FindFirstChild("HumanoidRootPart") then
                    if not table.find(NPCS, tostring(v)) then
                        table.insert(NPCS, tostring(v))
                        ii:SetOptions(NPCS)
                    end
                end
            end
        end
    }
)
})

local function getNPC()
    local dist, thing = math.huge
    for i, v in pairs(game:GetService("Workspace").EnemyNPCs:GetDescendants()) do
        if v:IsA "Model" and v:FindFirstChild("HumanoidRootPart") and v.Name == mobname then
            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Parent.Position).magnitude
            if mag < dist then
                dist = mag
                thing = v
            end
        end
    end
    return thing
end



