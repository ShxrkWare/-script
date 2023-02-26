local input
local key = loadstring(game:HttpGet('https://pastebin.com/raw/XUfQzb46'))()


funciton begin()
    rconsoleprint('@@WHITE@@')
    rconsolename("Anime Adventure Freeze Mob - Key System")
    rconsoleprint("Key Inbox NG THANH DAT \n")
    rconsoleprint("Enter Key: ")
    input = rconsoleinput()


    if input == key then
        rconsoleclear()
        rconsoleprint('@@LIGHT_GREEN@@')
        rconsolename("Anime Adventure - Main Script")
        rconsoleprint("Xin Chào!\n")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ShxrkWare/-script/main/aaxs.lua"))()

    elseif input ~= key then
        rconsoleprint("@@RED@@")
        rconsoleprint("Hoan Thanh Nhap Key\n")
        rconsolename("Key Sai Roi Djt Me May!")
        wait(2)
        rconsoleclear()
        begin()
    end
end


begin()