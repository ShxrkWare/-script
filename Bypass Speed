local gt = getrawmetatable(game)
local old = gt.__index
setreadonly(gt,false)

gt.__index = newcclosure(function(self,key,...)
    if tostring(self) == "Humanoid" and tostring(key) == "WalkSpeed" then
        return
    end
    return old(self,key,...)
end)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
