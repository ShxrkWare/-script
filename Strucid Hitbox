-- loop
game:GetService("RunService").Stepped:Connect(function()
    -- gets all players in the server
    for _, player in next, game:GetService("Players"):GetPlayers() do
        -- checks if the player found was not the local player, so the local player doesnt get his hitbox extended
        if player ~= game:GetService("Players").LocalPlayer then
            -- finds humanoid root part, then changes transparecy and can collide so you can walk through the hitbox and it wont be wonky
            if player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character["HumanoidRootPart"].CanCollide = false
                player.Character["HumanoidRootPart"].Transparency = 0.5
            end
            
            -- changes the humanoidrootpart size (basically the main code)
            if player.Character["HumanoidRootPart"].Size ~= Vector3.new(20, 20, 20) then
                player.Character["HumanoidRootPart"].Size = Vector3.new(20, 20, 20)
            end
        end
    end
end)
