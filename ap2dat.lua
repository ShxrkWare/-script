---@diagnostic disable: undefined-global
 
math.randomseed(tick())
 
local library = loadstring(syn.request({
    Method = "GET",
    Url = "https://wednesday.wtf/ars/library.lua"
}).Body)()
 
local cheat = {
    aimbot = {
        info = {},
    },
    visuals = {
        info = {},
        tracers = {},
        zombies = {},
        events = {},
        chams = {}
    },
    guns = {
        restore = {},
        data = {},
    },
    objects = {},
}
 
if (getgenv().cheat) then
    for _, object in next, getgenv().cheat.objects do
        object:Remove()
 
        object = nil
    end
 
    getgenv().cheat = nil
end
 
local old_library = library
 
getgenv().library = library
getgenv().cheat = cheat
 
cheat.draw = function(class, properties)
    local object = Drawing.new(class)
 
    for property, value in pairs(properties) do
        object[property] = value
    end
 
    cheat.objects[#cheat.objects + 1] = object
 
    return object
end
 
cheat.lerp = function(a,b,c)
    return a + (b-a) * c
end
 
cheat.bezier = function(p0,p1,p2,p3,t)
    local l1 = cheat.lerp(p0, p1, t)
    local l2 = cheat.lerp(p1, p2, t)
    local l3 = cheat.lerp(p2, p3, t)
 
    local a = cheat.lerp(l1, l2, t)
    local b = cheat.lerp(l2, l3, t)
 
    local cubic = cheat.lerp(a, b, t)
 
    return cubic
end
 
local physics = {}
 
-- Local variable bypass..?
(function()
	local sort			=table.sort
	local atan2			=math.atan2
	local inf			=math.huge
	local cos			=math.cos
	local sin			=math.sin
	local setmetatable	=setmetatable
	local tick			=tick
	local dot			=Vector3.new().Dot
 
	local function rootreals4(a,b,c,d,e)
		local x0,x1,x2,x3
		local m10=3*a
		local m0=-b/(4*a)
		local m4=c*c-3*b*d+12*a*e
		local m6=(b*b/(4*a)-2/3*c)/a
		local m9=((b*(4*c-b*b/a))/a-(8*d))/a
		local m5=c*(2*c*c-9*b*d-72*a*e)+27*a*d*d+27*b*b*e
		local m11=m5*m5-4*m4*m4*m4
		local m7
		if m11<0 then--Optimize
			local th=atan2((-m11)^0.5,m5)/3
			local m=((m5*m5-m11)/4)^(1/6)
			m7=(m4/m+m)/m10*cos(th)
		else--MAY NEED CASE FOR WHEN 2*c*c*c-9*b*c*d+27*a*d*d+27*b*b*e-72*a*c*e+((2*c*c*c-9*b*c*d+27*a*d*d+27*b*b*e-72*a*c*e)^2-4*(c*c-3*b*d+12*a*e)^3)^(1/2)=0
			local m8=(m5+m11^0.5)/2
			m8=m8<0 and -(-m8)^(1/3) or m8^(1/3)
			m7=(m4/m8+m8)/m10
		end
		local m2=2*m6-m7
		--print("m2",m2,0)
		local m12=m6+m7
		if m12<0 then
			local m3i=m9/(4*(-m12)^0.5)
			local m13=(m3i*m3i+m2*m2)^(1/4)*cos(atan2(m3i,m2)/2)/2
			--In order
			x0=m0-m13
			x1=m0-m13
			x2=m0+m13
			x3=m0+m13
		else
			local m1=m12^0.5
			--print("m1",m1,0)
			local m3=m9/(4*m1)
			--print("m3",m3,0)
			local m14=m2-m3
			local m15=m2+m3
			if m14<0 then
				x0=m0-m1/2
				x1=m0-m1/2
			else
				local m16=m14^0.5
				x0=m0-(m1+m16)/2
				x1=m0-(m1-m16)/2
			end
			if m15<0 then
				x2=m0+m1/2
				x3=m0+m1/2
			else
				local m17=m15^0.5
				x2=m0+(m1-m17)/2
				x3=m0+(m1+m17)/2
			end
			--bubble sort lel
			if x1<x0 then x0,x1=x1,x0 end
			if x2<x1 then x1,x2=x2,x1 end
			if x3<x2 then x2,x3=x3,x2 end
			if x1<x0 then x0,x1=x1,x0 end
			if x2<x1 then x1,x2=x2,x1 end
			if x1<x0 then x0,x1=x1,x0 end
		end
		return x0,x1,x2,x3
	end
 
	local function rootreals3(a,b,c,d)
		local x0,x1,x2
		local d0=b*b-3*a*c
		local d1=2*b*b*b+27*a*a*d-9*a*b*c
		local d=d1*d1-4*d0*d0*d0
		local m0=-1/(3*a)
		if d<0 then
			local cr,ci=d1/2,(-d)^0.5/2
			local th=atan2(ci,cr)/3
			local m=(cr*cr+ci*ci)^(1/6)
			local cr,ci=m*cos(th),m*sin(th)
			local m1=(1+d0/(m*m))/2
			local m2=(cr*d0+(cr-2*b)*m*m)/(6*a*m*m)
			local m3=ci*(d0+m*m)/(2*3^0.5*a*m*m)
			x0=-(b+cr*(1+d0/(m*m)))/(3*a)
			x1=m2-m3
			x2=m2+m3
		else
			local c3=(d1+d^0.5)/2
			c=c3<0 and -(-c3)^(1/3) or c3^(1/3)
			x0=m0*(b+c+d0/c)
			x1=m0*(b-(c*c+d0)/(2*c))
			x2=x1
		end
		if x1<x0 then x0,x1=x1,x0 end
		if x2<x1 then x1,x2=x2,x1 end
		if x1<x0 then x0,x1=x1,x0 end
		return x0,x1,x2
	end
 
	local function rootreals2(a,b,c)
		local p=-b/(2*a)
		local q2=p*p-c/a
		if 0<q2 then
			local q=q2^0.5
			return p-q,p+q
		else
			return p,p
		end
	end
 
	local solvemoar
 
	local function solve(a,b,c,d,e)
		if a*a<1e-32 then
			return solve(b,c,d,e)
		elseif e then
			if e*e<1e-32 then
				return solvemoar(a,b,c,d)
			elseif b*b<1e-12 and d*d<1e-12 then
				local roots={}
				local found={}
				local r0,r1=solve(a,c,e)
				if r0 then
					if r0>0 then
						local x=r0^0.5
						roots[#roots+1]=-x
						roots[#roots+1]=x
					elseif r0*r0<1e-32 then
						roots[#roots+1]=0
					end
				end
				if r1 then
					if r1>0 then
						local x=r1^0.5
						roots[#roots+1]=-x
						roots[#roots+1]=x
					elseif r1*r1<1e-32 then
						roots[#roots+1]=0
					end
				end
				sort(roots)
				return unpack(roots)
			else
				local roots={}
				local found={}
				local x0,x1,x2,x3=rootreals4(a,b,c,d,e)
				local d0,d1,d2=rootreals3(4*a,3*b,2*c,d)
				local m0,m1,m2,m3,m4=-inf,d0,d1,d2,inf
				local l0,l1,l2,l3,l4=a*inf,(((a*d0+b)*d0+c)*d0+d)*d0+e,(((a*d1+b)*d1+c)*d1+d)*d1+e,(((a*d2+b)*d2+c)*d2+d)*d2+e,a*inf
				if (l0<=0)==(0<=l1) then
                    if (not roots[#roots + 1]) then
                        return
                    end
 
					roots[#roots+1]=x0
					found[x0]=true
				end
				if (l1<=0)==(0<=l2) and not found[x1] then
					roots[#roots+1]=x1
					found[x1]=true
				end
				if (l2<=0)==(0<=l3) and not found[x2] then
					roots[#roots+1]=x2
					found[x2]=true
				end
				if (l3<=0)==(0<=l4) and not found[x3] then
					roots[#roots+1]=x3
				end
				return unpack(roots)
			end
		elseif d then
			if d*d<1e-32 then
				return solvemoar(a,b,c)
			elseif b*b<1e-12 and c*c<1e-12 then
				local p=d/a
				return p<0 and (-p)^(1/3) or -p^(1/3)
			else
				local roots={}
				local found={}
				local x0,x1,x2=rootreals3(a,b,c,d)
				local d0,d1=rootreals2(3*a,2*b,c)
				local l0,l1,l2,l3=-a*inf,((a*d0+b)*d0+c)*d0+d,((a*d1+b)*d1+c)*d1+d,a*inf
				if (l0<=0)==(0<=l1) then
					roots[#roots+1]=x0
					found[x0]=true
				end
				if (l1<=0)==(0<=l2) and not found[x1] then
					roots[#roots+1]=x1
					found[x1]=true
				end
				if (l2<=0)==(0<=l3) and not found[x2] then
					roots[#roots+1]=x2
				end
				return unpack(roots)
			end
		elseif c then
			local p=-b/(2*a)
			local q2=p*p-c/a
			if 0<q2 then
				local q=q2^0.5
				return p-q,p+q
			elseif q2==0 then
				return p
			end
		elseif b then
			if a*a>1e-32 then
				return -b/a
			end
		end
	end
 
	function solvemoar(a,b,c,d,e)
		local roots={solve(a,b,c,d,e)}
		local good=true
		for i=1,#roots do
			if roots[i]==0 then
				good=false
				break
			end
		end
		if good then
			roots[#roots+1]=0
			sort(roots)
		end
		return unpack(roots)
	end
 
    function physics.time_to_hit(tp, ps, sp, g)
        local d = (tp - sp).Magnitude
 
        return ps / g + math.sqrt(2 * d / g + ps ^ 2 / g ^ 2) -- It feels like cheating to use ^ as pow & not xor lol
    end
 
	function physics.trajectory(pp,pv,pa,tp,tv,ta,s)
		local rp=tp-pp
		local rv=tv-pv
		local ra=ta-pa
		local t0,t1,t2,t3=solve(
			dot(ra,ra)/4,
			dot(ra,rv),
			dot(ra,rp)+dot(rv,rv)-s*s,
			2*dot(rp,rv),
			dot(rp,rp)
		)
		if t0 and t0>0 then
			return ra*t0/2+tv+rp/t0,t0
		elseif t1 and t1>0 then
			return ra*t1/2+tv+rp/t1,t1
		elseif t2 and t2>0 then
			return ra*t2/2+tv+rp/t2,t2
		elseif t3 and t3>0 then
			return ra*t3/2+tv+rp/t3,t3
		end
	end
end)()
 
local framework = require(game:GetService("ReplicatedFirst").Framework) -- Mother of all modules
 
local modules = {
    ["steppers"] = framework.require("Classes", "Steppers"),
    ["interface"] = framework.require("Libraries", "Interface"),
    ["keybinds"] = framework.require("Libraries", "Keybinds"),
    ["raycasting"] = framework.require("Libraries", "Raycasting"),
    ["stepped_springs"] = framework.require("Classes", "SteppedSprings"),
    ["maids"] = framework.require("Classes", "Maids"),
    ["springs"] = framework.require("Classes", "Springs"),
    ["old_springs"] = framework.require("Classes", "OldSprings"),
    ["signals"] = framework.require("Classes", "Signals"),
    ["resources"] = framework.require("Libraries", "Resources"),
    ["characters_require"] = framework.require("Classes", "Characters"),
    ["lighting_require"] = framework.require("Libraries", "Lighting"),
    ["camera"] = framework.require("Libraries", "Cameras"),
    ["world"] = framework.require("Libraries", "World"),
    ["gun_builder"] = framework.require("Libraries", "GunBuilder"),
    ["network"] = framework.require("Libraries", "Network"),
    ["item_data"] = framework.require("Configs", "ItemData"),
    ["bullets"] = framework.require("Libraries", "Bullets"),
    ["players_require"] = framework.require("Classes", "Players")
}
 
-- CENSORED
 
local function copy_table(tbl) -- lua.org
    local type = typeof(tbl)
    local copy = {}
 
    if (type == "table") then
        for key, value in next, tbl, nil do
            copy[copy_table(key)] = copy_table(value)
        end
 
        setmetatable(copy, copy_table(getmetatable(tbl)))
    else
        copy = tbl
    end
 
    return copy
end
 
cheat.guns.data = (function()
    local copy = {}
 
    for key, value in next, framework.require("Configs", "ItemData") do
        if (value["Type"] == "Firearm") then
            copy[key] = value
        end
    end
 
    return copy
end)()
 
for key, value in next, cheat.guns.data do
    if (value["Type"] ~= "Firearm") then
        cheat.guns.data[key] = nil
    end
end
 
cheat.guns.restore = copy_table(cheat.guns.data)
 
local function mod_guns(property, multiplier, parent)
    for gun_name, gun in next, cheat.guns.data do
        if (typeof(multiplier) == "table") then
            if (parent and gun[parent]) then
                setreadonly(gun[parent], false)
                setreadonly(gun[parent][property], false)
 
                gun[parent][property] = (not multiplier["data"] and cheat.guns.restore[gun_name][parent][property]) or multiplier["data"]
 
                setreadonly(gun[parent], true)
                setreadonly(gun[parent][property], true)
            elseif (gun[property]) then
                setreadonly(gun, false)
                setreadonly(gun[property], false)
 
                gun[property] = (not multiplier["data"] and cheat.guns.restore[gun_name][property]) or multiplier["data"]
 
                setreadonly(gun, true)
                setreadonly(gun[property], true)
            end
 
            continue
        end
 
        if (parent and gun[parent]) then
            setreadonly(gun[parent], false)
 
            gun[parent][property] = (multiplier ~= -1 and cheat.guns.restore[gun_name][parent][property] * multiplier) or cheat.guns.restore[gun_name][parent][property]
 
            setreadonly(gun[parent], true)
        elseif (gun[property]) then
            setreadonly(gun, false)
 
            gun[property] = (multiplier ~= -1 and cheat.guns.restore[gun_name][property] * multiplier) or cheat.guns.restore[gun_name][property]
 
            setreadonly(gun, true)
        end
    end
end
 
local local_player = game:GetService("Players").LocalPlayer
local current_camera = game:GetService("Workspace").CurrentCamera
 
local random_title_list = {
    "🐛",
    "🐞",
    "🔥",
    "🔫",
    "🔪",
    "🔨",
    "🔧",
    "🔩",
    "🔗",
    "🔖",
    "😱",
    "😈",
    "😎",
    "😍",
    "😘",
    "😗",
    "😙",
}
 
local random_title = random_title_list[math.random(1, #random_title_list)]
 
local window = {
    ["main"] = library:new_window(random_title.. " NgThanhDat - AP2 HAX ".. random_title),
    ["tabs"] = {},
    ["sections"] = {},
    ["indicators"] = {},
}
 
window["tabs"]["aimbot"] = window.main:new_tab("Aimbot")
window["tabs"]["visuals"] = window.main:new_tab("Visuals")
window["tabs"]["misc"] = window.main:new_tab("Miscellaneous")
window["tabs"]["settings"] = window.main:new_tab("Settings")
 
library:apply_settings(window["tabs"]["settings"])
 
window["sections"]["aimbot_main"] = window.tabs.aimbot:new_group("Main", false)
 
window.sections["aimbot_main"]:new_checkbox("aimbot_enabled", {
    text = "Enabled",
    default = false,
})
 
window["sections"]["aimbot_hitboxes"] = window.tabs.aimbot:new_group("Hitboxes", true)
 
window.sections["aimbot_hitboxes"]:new_list("aimbot_hitboxes", {
    text =  "Hitbox Selection",
    values = {
        "Head",
        "Torso",
        "Arms",
        "Legs",
    },
    multi = true,
    default = {
        "Head",
    }
})
 
window["sections"]["aimbot_mouse"] = window.tabs.aimbot:new_group("Mouse", true)
 
window.sections["aimbot_mouse"]:new_checkbox("aimbot_mouse_enabled", {
    text =  "Mouse Aimbot",
    default = false
}):add_keybind("aimbot_mouse_enabled_hold", {
    mode = "Hold",
    default = "MouseButton2"
})
 
window.sections["aimbot_mouse"]:new_slider("aimbot_mouse_fov", {
    text = "Mouse FOV",
    min = 0,
    max = 180,
    decimals = 1,
    suffix = "°",
    default = 0
})
 
window.sections["aimbot_mouse"]:new_slider("aimbot_mouse_smoothing", {
    text = "Mouse Smoothing",
    min = 0.0,
    max = 1.0,
    decimals = 2,
    default = 0.1,
    suffix = "s"
})
 
window.sections["aimbot_mouse"]:new_slider("aimbot_mouse_jitter", {
    text = "Mouse Jitter",
    min = 0,
    max = 0.2,
    decimals = 2,
    default = 0,
    suffix = "s"
})
 
window["sections"]["aimbot_silent"] = window.tabs.aimbot:new_group("Silent", true)
 
window.sections["aimbot_silent"]:new_checkbox("aimbot_silent_enabled", {
    text = "Silent Aimbot",
    default = false
}):add_keybind("aimbot_silent_enabled_hold", {
    mode = "Hold",
    default = "MouseButton2"
})
 
window.sections["aimbot_silent"]:new_checkbox("aimbot_silent_magic_bullets", {
    text = "Silent Magic Bullets",
    default = false
}):add_keybind("aimbot_silent_magic_bullets_hold", {
    mode = "Hold",
    default = Enum.KeyCode.E
})
 
window.sections["aimbot_silent"]:new_slider("aimbot_silent_fov", {
    text = "Silent FOV",
    min = 0,
    max = 180,
    decimals = 1,
    suffix = "°",
    default = 0
})
 
window.sections["aimbot_silent"]:new_slider("aimbot_silent_magic_bullet_depth", {
    text = "Magic Bullet Depth",
    min = 0,
    max = 7,
    decimals = 0,
    suffix = " studs",
    default = 5
})
 
window.sections["aimbot_silent"]:new_slider("aimbot_silent_hitchance", {
    text = "Silent Hitchance",
    min = 0,
    max = 100,
    decimals = 1,
    suffix = "%",
    default = 100
})
 
window.sections["aimbot_silent"]:new_slider("aimbot_silent_accuracy", {
    text = "Silent Accuracy",
    min = 0,
    max = 100,
    decimals = 1,
    suffix = "%",
    default = 100
})
 
window["sections"]["aimbot_distance"] = window.tabs.aimbot:new_group("Distance", false)
 
window.sections["aimbot_distance"]:new_slider("aimbot_player_max_distance", {
    text = "Player Distance",
    min = 0,
    max = 2500,
    decimals = 1,
    default = 2000
})
 
window["sections"]["visuals_main"] = window.tabs.visuals:new_group("Main", false)
 
window.sections["visuals_main"]:new_checkbox("visuals_enabled", {
    text = "Enabled",
    default = false
}):add_keybind("visuals_enabled_toggle", {
    mode = "Toggle",
    default = nil
})
 
window["sections"]["visuals_distance"] = window.tabs.visuals:new_group("Distance", false)
 
window.sections["visuals_distance"]:new_slider("visuals_player_max_distance", {
    text = "Player Distance",
    min = 0,
    max = 10000,
    decimals = 0,
    default = 2000,
    suffix = " studs"
})
 
window.sections["visuals_distance"]:new_slider("visuals_boss_max_distance", {
    text = "Boss Distance",
    min = 0,
    max = 10000,
    decimals = 0,
    default = 2000,
    suffix = " studs"
})
 
window.sections["visuals_distance"]:new_slider("visuals_event_max_distance", {
    text = "Event Distance",
    min = 0,
    max = 10000,
    decimals = 0,
    default = 2000,
    suffix = " studs"
})
 
window["sections"]["visuals_preference"] = window.tabs.visuals:new_group("Preference", false)
 
window.sections["visuals_preference"]:new_list("visuals_preferred_measurement", {
    text = "Preferred Measurement",
    values = {
        "Roblox",
        "Imperial",
        "Metric",
    },
    default = "Roblox"
})
 
window.sections["visuals_preference"]:new_list("visuals_preferred_boxes", {
    text = "Preferred Boxes",
    values = {
        "Static",
        "Dynamic"
    },
    default = "Dynamic",
})
 
window["sections"]["visuals_players"] = window.tabs.visuals:new_group("Players", true)
 
window.sections["visuals_players"]:new_checkbox("visuals_boxes", {
    text = "Boxes",
    default = false
}):add_colorpicker("visuals_boxes_color", {
    text = "Box Color",
    default = {
        color = Color3.fromRGB(255, 255, 255),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_checkbox("visuals_skeletons", {
    text = "Skeletons",
    default = false
}):add_colorpicker("visuals_skeletons_color", {
    text = "Skeletons Color",
    default = {
        color = Color3.fromRGB(255, 255, 255),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_checkbox("visuals_health_bars", {
    text = "Health Bars",
    default = false
}):add_colorpicker("visuals_health_bars_color", {
    text = "Health Bar Color",
    default = {
        color = Color3.fromRGB(0, 255, 0),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_checkbox("visuals_health_bars_boost", {
    text = "Health Bars Boost",
}):add_colorpicker("visuals_health_bars_boost_color", {
    text = "Health Bar Color",
    default = {
        color = Color3.fromRGB(0, 175, 0),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_checkbox("visuals_health_bar_text", {
    text = "Health Bar Text",
    default = false
}):add_colorpicker("visuals_health_bar_text_color", {
    text = "Health Bar Text Color",
    default = {
        color = Color3.fromRGB(0, 0, 0),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_checkbox("visuals_names", {
    text = "Names",
    default = false
}):add_colorpicker("visuals_names_color", {
    text = "Names Color",
    default = {
        color = Color3.fromRGB(0, 0, 0),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_checkbox("visuals_display_names", {
    text = "Display Names",
    default = false
})
 
window.sections["visuals_players"]:new_checkbox("visuals_active_weapon", {
    text = "Active Weapon",
    default = false
}):add_colorpicker("visuals_active_weapon_color", {
    text = "Active Weapon Color",
    default = {
        color = Color3.fromRGB(0, 0, 0),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_checkbox("visuals_distance", {
    text = "Distance",
    default = false
}):add_colorpicker("visuals_distance_color", {
    text = "Distance Color",
    default = {
        color = Color3.fromRGB(0, 0, 0),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_checkbox("visuals_oof_arrows", {
    text = "Out Of View Arrows",
    default = false
}):add_colorpicker("visuals_oof_arrows_color", {
    text = "Out Of View Arrows Color",
    default = {
        color = Color3.fromRGB(255, 255, 255),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_slider("visuals_oof_arrows_radius", {
    text = "Arrows Radius",
    min = 100,
    max = 400,
    decimals = 0,
    default = 100,
    suffix = "px"
})
 
window.sections["visuals_players"]:new_checkbox("visuals_view_tracer", {
    text = "View Tracer",
    default = false
}):add_colorpicker("visuals_view_tracer_color", {
    text = "View Tracer Color",
    default = {
        color = Color3.fromRGB(79, 220, 255),
        transparency = 0
    }
})
 
window.sections["visuals_players"]:new_slider("visuals_view_tracer_length", {
    text = "Tracer Length",
    min = 0,
    max = 100,
    decimals = 1,
    default = 10,
    suffix = " studs"
})
 
window["sections"]["visuals_chams"] = window.tabs.visuals:new_group("Chams", true)
 
window.sections["visuals_chams"]:new_checkbox("visuals_visible_chams", {
    text = "Visible Chams",
    default = false
}):add_colorpicker("visuals_visible_chams_color", {
    text = "Visible Chams Color",
    default = {
        color = Color3.fromRGB(255, 0, 0),
        transparency = 0
    }
})
 
window.sections["visuals_chams"]:new_checkbox("visuals_occluded_chams", {
    text = "Occluded Chams",
    default = false
}):add_colorpicker("visuals_occluded_chams_color", {
    text = "Occluded Chams Color",
    default = {
        color = Color3.fromRGB(79, 220, 255),
        transparency = 0
    }
})
 
window.sections["visuals_chams"]:new_checkbox("visuals_outline_chams", {
    text = "Outline Chams",
    default = false
}):add_colorpicker("visuals_outline_chams_color", {
    text = "Outline Chams Color",
    default = {
        color = Color3.fromRGB(255, 255, 255),
        transparency = 0
    }
})
 
window["sections"]["visuals_bosses"] = window.tabs.visuals:new_group("Bosses", true)
 
window.sections["visuals_bosses"]:new_checkbox("visuals_boss_boxes", {
    text = "Boxes",
    default = false
}):add_colorpicker("visuals_boss_boxes_color", {
    text = "Box Color",
    default = {
        color = Color3.fromRGB(255, 255, 255),
        transparency = 0
    }
})
 
window.sections["visuals_bosses"]:new_checkbox("visuals_boss_names", {
    text = "Names",
    default = false
}):add_colorpicker("visuals_boss_names_color", {
    text = "Names Color",
    default = {
        color = Color3.fromRGB(0, 0, 0),
        transparency = 0
    }
})
 
window["sections"]["visuals_events"] = window.tabs.visuals:new_group("Events", true)
 
window.sections["visuals_events"]:new_checkbox("visuals_event_names", {
    text = "Names",
    default = false
}):add_colorpicker("visuals_event_names_color", {
    text = "Event Color",
    default = {
        color = Color3.fromRGB(0, 0, 0),
        transparency = 0
    }
})
 
window["sections"]["visuals_bullets"] = window.tabs.visuals:new_group("Bullets", false)
 
window.sections["visuals_bullets"]:new_checkbox("visuals_bullet_tracers", {
    text = "Bullet Tracers",
    default = false
}):add_colorpicker("visuals_bullet_tracers_color", {
    text = "Tracer Color",
    default = {
        color = Color3.fromRGB(255, 255, 255),
        transparency = 0
    }
})
 
window.sections["visuals_bullets"]:new_checkbox("visuals_bullet_tracers_face_camera", {
    text = "Tracers Face Camera",
    default = false
})
 
window.sections["visuals_bullets"]:new_list("visuals_bullet_tracers_texture", {
    text = "Tracers Type",
    values = {
        "Lightning",
        "Smoke"
    },
    default = "Lightning"
})
 
window.sections["visuals_bullets"]:new_slider("visuals_bullet_tracers_thickness", {
    text = "Tracer Thickness",
    min = 0,
    max = 1,
    decimals = 1,
    default = 0.2,
    suffix = " studs"
})
 
window["sections"]["visuals_local"] = window.tabs.visuals:new_group("Local", false)
 
window.sections["visuals_local"]:new_checkbox("visuals_mouse_fov", {
    text = "Mouse FOV",
    default = false
}):add_colorpicker("visuals_mouse_fov_color", {
    text = "Mouse FOV Color",
    default = {
        color = Color3.fromRGB(255, 255, 255),
        transparency = 0
    } 
})
 
window.sections["visuals_local"]:new_checkbox("visuals_silent_fov", {
    text = "Silent FOV",
    default = false
}):add_colorpicker("visuals_silent_fov_color", {
    text = "Silent FOV Color",
    default = {
        color = Color3.fromRGB(79, 220, 255),
        transparency = 0
    }
})
 
window.sections["visuals_local"]:new_checkbox("visuals_crosshair", {
    text = "Crosshair",
    default = false
}):add_colorpicker("visuals_crosshair_color", {
    text = "Crosshair Color",
    default = {
        color = Color3.fromRGB(255, 255, 255),
        transparency = 0
    }
})
 
window.sections["visuals_local"]:new_checkbox("visuals_crosshair_rotate", {
    text = "Crosshair Rotate",
    default = false
})
 
window.sections["visuals_local"]:new_slider("visuals_crosshair_width", {
    text = "Crosshair Width",
    min = 0,
    max = 10,
    decimals = 0,
    default = 3,
    suffix = "px"
})
 
window["sections"]["visuals_lighting"] = window.tabs.visuals:new_group("Lighting", true)
 
window.sections["visuals_lighting"]:new_checkbox("misc_full_bright", {
    text = "Full Bright",
    default = false
})
 
window["sections"]["misc_main"] = window.tabs.misc:new_group("Main", false)
 
window.sections["misc_main"]:new_checkbox("misc_enabled", {
    text = "Enabled",
    default = false
})
 
window["sections"]["misc_movement"] = window.tabs.misc:new_group("Movement", true)
 
window.sections["misc_movement"]:new_checkbox("misc_fly", {
    text = "Fly",
    default = false
}):add_keybind("misc_fly_toggle", {
    mode = "Toggle",
    default = Enum.KeyCode.G
})
 
window.sections["misc_movement"]:new_slider("misc_fly_speed", {
    text = "Fly Speed",
    min = 0,
    max = 1000,
    decimals = 1,
    default = 10,
    suffix = " stud/s"
})
 
window.sections["misc_movement"]:new_checkbox("misc_speed", {
    text = "Speed",
    default = false
}):add_keybind("misc_speed_toggle", {
    mode = "Toggle",
    default = Enum.KeyCode.H
})
 
window.sections["misc_movement"]:new_slider("misc_speed_velocity", {
    text = "Speed Velocity",
    min = 0,
    max = 1000,
    decimals = 1,
    default = 10,
    suffix = " stud/s"
})
 
window.sections["misc_movement"]:new_checkbox("misc_jitter_fix", {
    text = "Jitter Fix",
    default = false,
    unsafe = true
})
 
window["sections"]["misc_spoof"] = window.tabs.misc:new_group("Spoof Status", true)
 
window.sections["misc_spoof"]:new_checkbox("misc_spoof_status", {
    text = "Spoof Status",
    default = false
})
 
window.sections["misc_spoof"]:new_checkbox("misc_spoof_falling", {
    text = "Spoof Falling",
    default = false
})
 
window["sections"]["misc_zombies"] = window.tabs.misc:new_group("Zombies", true)
 
window.sections["misc_zombies"]:new_checkbox("misc_zombie_freezer", {
    text = "Zombie Freezer",
    default = false
})
 
window.sections["misc_zombies"]:new_checkbox("misc_zombie_remover", {
    text = "Zombie Remover",
    default = false
})
 
window.sections["misc_zombies"]:new_list("misc_zombie_remover_mode", {
    text = "Zombie Remover Mode",
    values = {
        "Delete",
        "Teleport"
    },
    default = "Delete"
})
 
window.sections["misc_zombies"]:new_checkbox("misc_zombie_circle", {
    text = "Zombie Circle",
    default = false
})
 
window.sections["misc_zombies"]:new_slider("misc_zombie_circle_radius", {
    text = "Zombie Radius",
    min = 7,
    max = 100,
    decimals = 1,
    default = 10,
    suffix = " studs"
})
 
window.sections["misc_zombies"]:new_slider("misc_zombie_circle_speed", {
    text = "Zombie Speed",
    min = 1,
    max = 10000,
    decimals = 1,
    default = 500,
    suffix = " rpm"
})
 
window["sections"]["misc_bosses"] = window.tabs.misc:new_group("Bosses", true)
 
window.sections["misc_bosses"]:new_checkbox("misc_boss_freezer", {
    text = "Boss Freezer",
    default = false
})
 
window["sections"]["misc_animations"] = window.tabs.misc:new_group("Animations", false)
 
window.sections["misc_animations"]:new_list("misc_animation_category", {
    text = "Animation Category",
    values = (function()
        local values = {}
 
        for _, category in next, game:GetService("ReplicatedStorage").Assets.Animations:GetChildren() do
            values[#values + 1] = category.Name
        end
 
        return values
    end)(),
    default = "Idle",
    callback = function(value)
        if (not value or value == "") then
            return
        end
 
        options["misc_animation"]:set_values((function()
            local values = {}
 
            for _, category in next, game:GetService("ReplicatedStorage").Assets.Animations[value]:GetChildren() do
                values[#values + 1] = category.Name
            end
 
            return values
        end)())
 
        options["misc_animation"]:set_value("")
    end
})
 
window.sections["misc_animations"]:new_list("misc_animation", {
    text = "Animation",
    values = {},
    default = ""
})
 
window.sections["misc_animations"]:new_slider("misc_animation_duration", {
    text = "Animation Duration",
    min = 0,
    max = 300,
    decimals = 1,
    default = 60,
    suffix = "s"
})
 
window.sections["misc_animations"]:new_button({
    text = "Play Animation",
    callback = function()
        task.spawn(function()
            local animation_category = flags["misc_animation_category"]
            local animation_name = flags["misc_animation"]
            local duration = flags["misc_animation_duration"]
 
            if (not animation_category or animation_category == "") then
                return
            end
 
            if (not animation_name or animation_name == "") then
                return
            end
 
            local animation = game:GetService("ReplicatedStorage").Assets.Animations[animation_category][animation_name]
 
            if (not game:GetService("Players").LocalPlayer.Character) then
                return
            end
 
            local animator = game:GetService("Players").LocalPlayer.Character.Humanoid.Animator
 
            if (not animation) then
                return
            end
 
            if (not animator) then
                return
            end
 
            local loaded_animation = animator:LoadAnimation(animation)
 
            modules["players_require"]:get().Character.Animator:PlayAnimationReplicated(animation_category.. ".".. animation_name)
 
            task.wait(duration > 0 and duration or loaded_animation.Length)
 
            if (not modules["players_require"]:get().Character) then
                return
            end
 
            modules["players_require"]:get().Character.Animator:StopAnimationReplicated(animation_category.. ".".. animation_name, true)
        end)
    end
}):add_keybind("misc_animation_bind", {
    mode = "Toggle",
    default = Enum.KeyCode.LeftAlt,
    callback = function()
        task.spawn(function()
            local animation_category = flags["misc_animation_category"]
            local animation_name = flags["misc_animation"]
            local duration = flags["misc_animation_duration"]
 
            if (not animation_category or animation_category == "") then
                return
            end
 
            if (not animation_name or animation_name == "") then
                return
            end
 
            local animation = game:GetService("ReplicatedStorage").Assets.Animations[animation_category][animation_name]
 
            if (not game:GetService("Players").LocalPlayer.Character) then
                return
            end
 
            local animator = game:GetService("Players").LocalPlayer.Character.Humanoid.Animator
 
            if (not animation) then
                return
            end
 
            if (not animator) then
                return
            end
 
            local loaded_animation = animator:LoadAnimation(animation)
 
            modules["players_require"]:get().Character.Animator:PlayAnimationReplicated(animation_category.. ".".. animation_name)
 
            task.wait(duration > 0 and duration or loaded_animation.Length)
 
            if (not modules["players_require"]:get().Character) then
                return
            end
 
            modules["players_require"]:get().Character.Animator:StopAnimationReplicated(animation_category.. ".".. animation_name, true)
        end)
    end
})
 
window["sections"]["misc_gun_mods"] = window.tabs.misc:new_group("Gun Mods", false)
 
window.sections["misc_gun_mods"]:new_checkbox("misc_enabled_weapon_mods", {
    text = "Enabled",
    default = false
})
 
window.sections["misc_gun_mods"]:new_checkbox("misc_spread_mod_enabled", {
    text = "No Spread",
    default = false
})
 
window.sections["misc_gun_mods"]:new_checkbox("misc_firemode_all", {
    text = "All Firemodes",
    default = false,
    callback = function(value)
        if (flags["misc_enabled"] and flags["misc_enabled_weapon_mods"]) then
            if (value) then
                mod_guns("FireModes", { data = {"Semiautomatic", "Automatic", "Burst"} }, nil)
            else
                mod_guns("FireModes", {}, nil)
            end
        end
    end
})
 
window.sections["misc_gun_mods"]:new_checkbox("misc_recoil_mod_enabled", {
    text = "Recoil Modifier",
    default = false,
    callback = function(value)
        if (flags["misc_enabled"] and flags["misc_enabled_weapon_mods"] and value) then
            local recoil = flags["misc_weapon_recoil"]
 
            mod_guns("KickUpBounce", recoil, "RecoilData")
            mod_guns("KickUpForce", recoil, "RecoilData")
            mod_guns("KickUpSpeed", recoil, "RecoilData")
            mod_guns("KickUpGunInfluence", recoil, "RecoilData")
            mod_guns("KickUpCameraInfluence", recoil, "RecoilData")
            mod_guns("RaiseInfluence", recoil, "RecoilData")
            mod_guns("RaiseBounce", recoil, "RecoilData")
            mod_guns("RaiseSpeed", recoil, "RecoilData")
            mod_guns("RaiseForce", recoil, "RecoilData")
            mod_guns("ShiftGunInfluence", recoil, "RecoilData")
            mod_guns("ShiftBounce", recoil, "RecoilData")
            mod_guns("ShiftCameraInfluence", recoil, "RecoilData")
            mod_guns("ShiftForce", recoil, "RecoilData")
        else
            mod_guns("KickUpBounce", -1, "RecoilData")
            mod_guns("KickUpForce", -1, "RecoilData")
            mod_guns("KickUpSpeed", -1, "RecoilData")
            mod_guns("KickUpGunInfluence", -1, "RecoilData")
            mod_guns("KickUpCameraInfluence", -1, "RecoilData")
            mod_guns("RaiseInfluence", -1, "RecoilData")
            mod_guns("RaiseBounce", -1, "RecoilData")
            mod_guns("RaiseSpeed", -1, "RecoilData")
            mod_guns("RaiseForce", -1, "RecoilData")
            mod_guns("ShiftGunInfluence", -1, "RecoilData")
            mod_guns("ShiftBounce", -1, "RecoilData")
            mod_guns("ShiftCameraInfluence", -1, "RecoilData")
            mod_guns("ShiftForce", -1, "RecoilData")
        end
    end
})
 
window.sections["misc_gun_mods"]:new_slider("misc_weapon_recoil", {
    text = "Multiplier",
    min = 0,
    max = 1,
    decimals = 2,
    default = 1,
    suffix = "x",
    callback = function(value)
        if (flags["misc_enabled"] and flags["misc_enabled_weapon_mods"] and flags["misc_recoil_mod_enabled"]) then
            mod_guns("KickUpBounce", value, "RecoilData")
            mod_guns("KickUpForce", value, "RecoilData")
            mod_guns("KickUpSpeed", value , "RecoilData")
            mod_guns("KickUpGunInfluence", value, "RecoilData")
            mod_guns("KickUpCameraInfluence", value, "RecoilData")
            mod_guns("RaiseInfluence", value, "RecoilData")
            mod_guns("RaiseBounce", value, "RecoilData")
            mod_guns("RaiseSpeed", value , "RecoilData")
            mod_guns("RaiseForce", value, "RecoilData")
            mod_guns("ShiftGunInfluence", value, "RecoilData")
            mod_guns("ShiftBounce", value, "RecoilData")
            mod_guns("ShiftCameraInfluence", value, "RecoilData")
            mod_guns("ShiftForce", value, "RecoilData")
        end
    end
})
 
-- window.sections["misc_gun_mods"]:new_slider({
--     Text = "Weapon Fire Rate",
--     flag = "misc_weapon_fire_rate",
--     Min = 1,
--     Max = 10,
--     Rounding = .1,
--     Default = 1,
--     suffix = "x",
--     callback = function()
--         if (Toggles["misc_enabled"] and Toggles["misc_enabled_weapon_mods"] and Toggles["misc_recoil_mod_enabled"]) then
--             mod_guns("FireRate", Toggles["misc_weapon_fire_rate"], "FireConfig")
--         end
--     end
-- })
 
-- window.sections["misc_gun_mods"]:new_checkbox({
--     Text = "Fire Burst Modifier",
--     flag = "misc_fire_burst_mod_enabled",
--     callback = function()
--         if (Toggles["misc_enabled"] and Toggles["misc_enabled_weapon_mods"] and Toggles["misc_fire_burst_mod_enabled"]) then
--             mod_guns("BurstCount", Toggles["misc_weapon_burst_count"], "FireConfig")
--         else
--             mod_guns("BurstCount", -1, "FireConfig")
--         end
--     end
-- })
 
-- window.sections["misc_gun_mods"]:new_slider({
--     Text = "Weapon Burt Count",
--     flag = "misc_weapon_burst_count",
--     Min = 3,
--     Max = 10,
--     Rounding = 1,
--     Default = 3,
--     suffix = "x",
--     callback = function()
--         if (Toggles["misc_enabled"] and Toggles["misc_enabled_weapon_mods"] and Toggles["misc_fire_burst_mod_enabled"]) then
--             mod_guns("BurstCount", Toggles["misc_weapon_burst_count"], "FireConfig")
--         end
--     end
-- })
 
window["sections"]["misc_teleports"] = window.tabs.misc:new_group("Teleports", false)
 
window.sections["misc_teleports"]:new_list("misc_corpses", {
    text = "Corpses",
    values = (function()
        local filtered_corpses = {}
 
        for _, corpse in next, game:GetService("Workspace").Corpses:GetChildren() do
            if (corpse.Name ~= "Zombie") then
                table.insert(filtered_corpses, corpse.Name)
            end
        end
 
        return filtered_corpses
    end)(),
    default = "",
    callback = function(value)
        if (not value) then return end
 
        if (flags["misc_enabled"]) then
            local corpse = game:GetService("Workspace").Corpses:FindFirstChild(value)
 
            if (corpse) then
                local character = local_player.Character
 
                if (character) then
                    local humanoid = character:FindFirstChild("HumanoidRootPart")
                    local corpse_humanoid = corpse:FindFirstChild("HumanoidRootPart")
 
                    if (humanoid and corpse_humanoid) then
                        cheat.teleport_bypass = true
 
                        repeat task.wait() until cheat.teleport_bypass_ran
 
                        -- CENSORED
 
                        cheat.teleport_bypass = false
                    end
                end
            end
        end
    end,
    ignore = true
})
 
window.sections["misc_teleports"]:new_list("misc_players", {
    text = "Players",
    values = (function()
        local filtered_people = {}
 
        for _, person in next, game:GetService("Players"):GetPlayers() do
            if (person ~= local_player) then
                table.insert(filtered_people, person.Name)
            end
        end
 
        return filtered_people
    end)(),
    default = "",
    callback = function(value)
        if (not value) then return end
 
        if (flags["misc_enabled"]) then
            local player = game:GetService("Players"):FindFirstChild(value)
 
            if (player) then
                local character = local_player.Character
 
                if (character and player.Character) then
                    local humanoid = character:FindFirstChild("HumanoidRootPart")
                    local player_humanoid = player.Character:FindFirstChild("HumanoidRootPart")
 
                    if (humanoid and player_humanoid) then
                        cheat.teleport_bypass = true
 
                        repeat task.wait() until cheat.teleport_bypass_ran
 
                        -- CENSORED
 
                        cheat.teleport_bypass = false
                    end
                end
            end
        end
    end,
    ignore = true
})
 
window.sections["misc_teleports"]:new_list("misc_places", {
    text = "Places",
    values = (function()
        local filtered_locations = {}
 
        for _, location in next, game:GetService("Workspace").Locations:GetChildren() do
            table.insert(filtered_locations, location.Name)
        end
 
        return filtered_locations
    end)(),
    default = "",
    callback = function(value)
        if (not value) then return end
 
        if (flags["misc_enabled"]) then
            local location = game:GetService("Workspace").Locations:FindFirstChild(value)
 
            if (location) then
                local character = local_player.Character
 
                if (character) then
                    local humanoid = character:FindFirstChild("HumanoidRootPart")
 
                    if (humanoid) then
                        cheat.teleport_bypass = true
 
                        repeat task.wait() until cheat.teleport_bypass_ran
 
                        -- CENSORED
 
                        cheat.teleport_bypass = false
                    end
                end
            end
        end
    end,
    ignore = true
})
 
function cheat:safe_call(func)
    pcall(func, function()
       return false
    end)
 
    return true
end
 
local connections = {}
 
local function corpse_remove()
    if (not getgenv().library or getgenv().library ~= old_library) then
        connections["corpse_remove"]:Disconnect()
 
        return
    end
 
    getgenv().options["misc_corpses"]:set_values((function()
        local filtered_corpses = {}
 
        for _, corpse in next, game:GetService("Workspace").Corpses:GetChildren() do
            if (corpse.Name ~= "Zombie") then
                table.insert(filtered_corpses, corpse.Name)
            end
        end
 
        return filtered_corpses
    end)())
end
 
connections["corpse_remove"] = game:GetService("Workspace").Corpses.ChildRemoved:Connect(function() cheat:safe_call(corpse_remove) end)
 
local function player_removing()
    if (not getgenv().library or getgenv().library ~= old_library) then
        connections["player_removing"]:Disconnect()
 
        return
    end
 
    getgenv().options["misc_players"]:set_values((function()
        local filtered_people = {}
 
        for _, person in next, game:GetService("Players"):GetPlayers() do
            if (person ~= local_player) then
                table.insert(filtered_people, person.Name)
            end
        end
 
        return filtered_people
    end)())
end
 
connections["player_removing"] = game:GetService("Players").PlayerRemoving:Connect(function() cheat:safe_call(player_removing) end)
 
local function corpse_added()
    if (not getgenv().library or getgenv().library ~= old_library) then
        connections["corpse_added"]:Disconnect()
 
        return
    end
 
    getgenv().options["misc_corpses"]:set_values((function()
        local filtered_corpses = {}
 
        for _, corpse in next, game:GetService("Workspace").Corpses:GetChildren() do
            if (corpse.Name ~= "Zombie") then
                table.insert(filtered_corpses, corpse.Name)
            end
        end
 
        return filtered_corpses
    end)())
end
 
connections["corpse_added"] = game:GetService("Workspace").Corpses.ChildAdded:Connect(function() cheat:safe_call(corpse_added) end)
 
local function player_added()
    if (not getgenv().library or getgenv().library ~= old_library) then
        connections["player_added"]:Disconnect()
 
        return
    end
 
    getgenv().options["misc_players"]:set_values((function()
        local filtered_people = {}
 
        for _, person in next, game:GetService("Players"):GetPlayers() do
            if (person ~= local_player) then
                table.insert(filtered_people, person.Name)
            end
        end
 
        return filtered_people
    end)())
end
 
connections["player_added"] = game:GetService("Players").PlayerAdded:Connect(function() cheat:safe_call(player_added) end)
 
function cheat:detour(name, loc, func)
    local old_function = nil
 
    -- HACK: Saves usless local variable
    if (cheat:safe_call(function()
        old_function = loc[name]
 
        loc[name] = newcclosure(function(...)
            if (not getgenv().library or getgenv().library ~= old_library) then
                loc[name] = old_function
 
                return old_function(...)
            end
 
            return func(old_function, ...)
        end)
    end)) then
        -- library:Notify("Detoured " .. name, 1)
    else
        error("Failed to detour " .. name)
    end
end
 
function cheat:render_stepped(priority, func, unload)
    game:GetService("RunService"):BindToRenderStep(tostring(func), priority, function()
        if (not getgenv().library or getgenv().library ~= old_library) then
            game:GetService("RunService"):UnbindFromRenderStep(tostring(func))
 
            if (unload) then
                unload()
            end
 
            return
        end
 
       func()
    end)
end
 
function cheat:heart_beat(func, unload)
    local connection
 
    connection = game:GetService("RunService").Heartbeat:Connect(function(delta)
        if (not getgenv().library or getgenv().library ~= old_library) then
            connection:Disconnect()
 
            if (unload) then
                unload()
            end
 
            return
        end
 
        func(delta)
    end)
end
 
local function calculate_box(player)
    -- Fixes the red dot causing boxes to be much bigger than they should be
    if (player.Character:FindFirstChild("Equipped")) then
        local equipped = player.Character.Equipped:GetDescendants()
 
        for _, part in next, equipped do
            if (string.find(part.Name, "Laser")) then
                part.Position = player.Character:FindFirstChild("Head").Position
            end
        end
    end
 
    if (flags["visuals_preferred_boxes"] == "Dynamic") then
        local position = player.Character:GetBoundingBox()
        local size = player.Character:GetExtentsSize()
 
        local maxs = (position * CFrame.new(size / 2)).Position
        local mins = (position * CFrame.new(size / -2)).Position
 
        local points = {
            Vector3.new(mins.X, mins.Y, mins.Z),
            Vector3.new(mins.X, maxs.Y, mins.Z),
            Vector3.new(maxs.X, maxs.Y, mins.Z),
            Vector3.new(maxs.X, mins.Y, mins.Z),
            Vector3.new(maxs.X, maxs.Y, maxs.Z),
            Vector3.new(mins.X, maxs.Y, maxs.Z),
            Vector3.new(mins.X, mins.Y, maxs.Z),
            Vector3.new(maxs.X, mins.Y, maxs.Z)
        };
 
        local visible = true
 
        for idx, point in next, points do
            points[idx], visible = current_camera:WorldToViewportPoint(point)
        end
 
        if (not visible) then
            return
        end
 
        local left = math.huge
        local right = 0
        local top = math.huge
        local bottom = 0
 
        for _, point in next, points do
            if (point.X < left) then
                left = point.X
            end
 
            if (point.X > right) then
                right = point.X
            end
 
            if (point.Y < top) then
                top = point.Y
            end
 
            if (point.Y > bottom) then
                bottom = point.Y
            end
        end
 
        return {
            ["X"] = math.floor(left),
            ["Y"] = math.floor(top),
            ["W"] = math.floor(right - left),
            ["H"] = math.floor(bottom - top)
        }
    else
        local camera_cframe = current_camera.CFrame
        local player_parts = player.Character
 
        if (not player_parts) then return end
 
        local torso_cframe = player_parts.HumanoidRootPart.CFrame
        local matrix_top = (torso_cframe.Position + Vector3.new(0, 0.3, 0)) + (torso_cframe.UpVector * 1.5) + camera_cframe.UpVector
        local matrix_bottom = (torso_cframe.Position + Vector3.new(0, 0.4, 0)) - (torso_cframe.UpVector * 3)
 
        local top, top_is_visible = current_camera:WorldToViewportPoint(matrix_top)
        local bottom, bottom_is_visible = current_camera:WorldToViewportPoint(matrix_bottom)
 
        if (not top_is_visible and not bottom_is_visible) then return end
 
        local width = math.floor(math.abs(top.X - bottom.X))
        local height = math.floor(math.max(math.abs(bottom.Y - top.Y), width * 0.6))
        local box_size = Vector2.new(math.floor(math.max(height / 1.7, width * 1.8)), height)
        local box_position = Vector2.new(math.floor(top.X * 0.5 + bottom.X * 0.5 - box_size.X * 0.5), math.floor(math.min(top.Y, bottom.Y)))
 
        return {
            ["X"] = box_position.X,
            ["Y"] = box_position.Y,
            ["W"] = box_size.X,
            ["H"] = box_size.Y
        }
    end
end
 
local squad_list = {}
 
cheat:render_stepped(0, function(delta)
    current_camera = game:GetService("Workspace").CurrentCamera
 
    squad_list = {}
 
    for _, template in next, local_player.PlayerGui["Interface Main"].PlayerList.MainList.SquadList.ScrollingFrame:GetChildren() do
        if (template.Name == "SquadTemplate") then
            local player_name = template.NameButton.NameLabelBin.NameLabel.text
 
            squad_list[player_name] = true
        end
    end
end)
 
cheat:render_stepped(1, function(delta)
    for _, player in next, game:GetService("Players"):GetPlayers() do
        local skeleton_order = {
            ["LeftFoot"] = "LeftLowerLeg",
            ["LeftLowerLeg"] = "LeftUpperLeg",
            ["LeftUpperLeg"] = "LowerTorso",
 
            ["RightFoot"] = "RightLowerLeg",
            ["RightLowerLeg"] = "RightUpperLeg",
            ["RightUpperLeg"] = "LowerTorso",
 
            ["LeftHand"] = "LeftLowerArm",
            ["LeftLowerArm"] = "LeftUpperArm",
            ["LeftUpperArm"] = "UpperTorso",
 
            ["RightHand"] = "RightLowerArm",
            ["RightLowerArm"] = "RightUpperArm",
            ["RightUpperArm"] = "UpperTorso",
 
            ["LowerTorso"] = "UpperTorso",
            ["UpperTorso"] = "Head"
        }
 
        if (player == local_player) then
            continue
        end
 
        if (not player.Character) then
            if (cheat.visuals.info[player.Name]) then
                for _, object in next, cheat.visuals.info[player.Name] do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (not local_player.Character) then
            if (cheat.visuals.info[player.Name]) then
                for _, object in next, cheat.visuals.info[player.Name] do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (squad_list[player.Name]) then
            if (cheat.visuals.info[player.Name]) then
                for _, object in next, cheat.visuals.info[player.Name] do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        local character = player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local stats = character:FindFirstChild("Stats")
 
        if (not humanoid or not stats) then
            if (cheat.visuals.info[player.Name]) then
                for _, object in next, cheat.visuals.info[player.Name] do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (humanoid.Health <= 0) then
            if (cheat.visuals.info[player.Name]) then
                for _, object in next, cheat.visuals.info[player.Name] do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (not character:FindFirstChild("HumanoidRootPart") or not local_player.Character:FindFirstChild("HumanoidRootPart")) then
            if (cheat.visuals.info[player.Name]) then
                for _, object in next, cheat.visuals.info[player.Name] do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if ((character.HumanoidRootPart.Position - local_player.Character.HumanoidRootPart.Position).Magnitude > flags["visuals_player_max_distance"]) then
            if (cheat.visuals.info[player.Name]) then
                for _, object in next, cheat.visuals.info[player.Name] do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        local box = calculate_box(player)
        local info = cheat.visuals.info[player.Name]
 
        if (not flags["visuals_enabled"] and not flags["visuals_enabled_toggle"].state) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (not info) then
            cheat.visuals.info[player.Name] = {}
 
            cheat.visuals.info[player.Name]["box_outside"] = cheat.draw("Square", {
                Color = Color3.new(0, 0, 0),
                Thickness = 1,
                Transparency = math.clamp(-(flags["visuals_boxes_color"].transparency) + 1 - 0.5, 0, 1),
                Filled = false
            })
 
            cheat.visuals.info[player.Name]["box"] = cheat.draw("Square", {
                Color = flags["visuals_boxes_color"].color,
                Thickness = 1,
                Transparency = -(flags["visuals_boxes_color"].transparency) + 1,
                Filled = false
            })
 
            cheat.visuals.info[player.Name]["box_inside"] = cheat.draw("Square", {
                Color = Color3.new(0, 0, 0),
                Thickness = 1,
                Transparency = math.clamp(-(flags["visuals_boxes_color"].transparency) + 1 - 0.5, 0, 1),
                Filled = false
            })
 
            cheat.visuals.info[player.Name]["health_bar_outside"] = cheat.draw("Square", {
                Color = Color3.new(0, 0, 0),
                Thickness = 1,
                Transparency = math.clamp(-(flags["visuals_health_bars_color"].transparency) + 1 - 0.5, 0, 1),
                Filled = true
            })
 
            cheat.visuals.info[player.Name]["health_bar"] = cheat.draw("Square", {
                Color = flags["visuals_health_bars_color"].color,
                Thickness = 1,
                Transparency = -(flags["visuals_health_bars_color"].transparency) + 1,
                Filled = true
            })
 
            cheat.visuals.info[player.Name]["health_bar_boost"] = cheat.draw("Square", {
                Color = flags["visuals_health_bars_boost_color"].color,
                Thickness = 1,
                Transparency = math.clamp(-(flags["visuals_health_bars_boost_color"].transparency) + 1 - 0.5, 0, 1),
                Filled = true
            })
 
            cheat.visuals.info[player.Name]["health_bar_text"] = cheat.draw("Text", {
                Color = Color3.new(1, 1, 1),
                OutlineColor = flags["visuals_health_bar_text_color"].color,
                Center = false,
                Outline = true,
                Size = 13,
                Transparency = -(flags["visuals_health_bar_text_color"].transparency) + 1,
                Font = 2
            })
 
            cheat.visuals.info[player.Name]["name"] = cheat.draw("Text", {
                Color = Color3.new(1, 1, 1),
                OutlineColor = flags["visuals_names_color"].color,
                Center = true,
                Outline = true,
                Size = 13,
                Transparency = math.clamp(-(flags["visuals_names_color"].transparency) + 1 - 0.5, 0, 1),
                Font = 2
            })
 
            cheat.visuals.info[player.Name]["active_weapon"] = cheat.draw("Text", {
                Color = Color3.new(1, 1, 1),
                OutlineColor = flags["visuals_active_weapon_color"].color,
                Center = true,
                Outline = true,
                Size = 13,
                Transparency = -(flags["visuals_active_weapon_color"].transparency) + 1,
                Font = 2
            })
 
            cheat.visuals.info[player.Name]["view_tracer"] = cheat.draw("Line", {
                Color = flags["visuals_view_tracer_color"].color,
                Transparency = -(flags["visuals_view_tracer_color"].transparency) + 1,
                Visible = false
            })
 
            cheat.visuals.info[player.Name]["distance"] = cheat.draw("Text", {
                Color = Color3.new(1, 1, 1),
                OutlineColor = flags["visuals_distance_color"].color,
                Center = true,
                Outline = true,
                Size = 13,
                Transparency = -(flags["visuals_distance_color"].transparency) + 1,
                Font = 2
            })
 
            cheat.visuals.info[player.Name]["oof_arrow"] = cheat.draw("Triangle", {
                Color = flags["visuals_oof_arrows_color"].color,
                Thickness = 1,
                Transparency = -(flags["visuals_oof_arrows_color"].transparency) + 1,
                Filled = true
            })
 
            cheat.visuals.info[player.Name]["oof_arrow_outside"] = cheat.draw("Triangle", {
                Color = Color3.new(0, 0, 0),
                Thickness = 1,
                Transparency = -(flags["visuals_oof_arrows_color"].transparency) + 1,
                Filled = false,
            })
 
            for required, _ in next, skeleton_order do
                cheat.visuals.info[player.Name]["skeleton_".. required] = cheat.draw("Line", {
                    Color = flags["visuals_skeletons_color"].color,
                    Transparency = -(flags["visuals_skeletons_color"].transparency) + 1,
 
                    Visible = false
                })
            end
 
            info = cheat.visuals.info[player.Name]
        end
 
        if (box) then
            if (flags["visuals_boxes"]) then
                info["box_outside"].Position = Vector2.new(box.X - 1, box.Y - 1)
                info["box_outside"].Size = Vector2.new(box.W + 2, box.H + 2)
                info["box_outside"].Transparency = math.clamp(1 - 0.5, 0, 1)
                info["box_outside"].Visible = true
 
                info["box"].Position = Vector2.new(box.X, box.Y)
                info["box"].Size = Vector2.new(box.W, box.H)
                info["box"].Transparency = 1
                info["box"].Color = flags["visuals_boxes_color"].color
                info["box"].Visible = true
 
                info["box_inside"].Position = Vector2.new(box.X + 1, box.Y + 1)
                info["box_inside"].Size = Vector2.new(box.W - 2, box.H - 2)
                info["box_inside"].Transparency = math.clamp(1 - 0.5, 0, 1)
                info["box_inside"].Visible = true
            else
                if (info["box"]) then
                    info["box"].Visible = false
                end
 
                if (info["box_inside"]) then
                    info["box_inside"].Visible = false
                end
 
                if (info["box_outside"]) then
                    info["box_outside"].Visible = false
                end
            end
 
            if (flags["visuals_health_bars"]) then
                local health_fraction = math.floor(stats.Health.Base.Value) / 100
 
                local health_size = math.floor(box.H * health_fraction)
                local health_position = math.floor((box.Y + box.H) - health_size)
 
                local hue, saturation, value = flags["visuals_health_bars_color"].color:ToHSV()
                local health_color = math.abs(hue - ((120 / 360) * (-(health_fraction) + 1))) -- fix negative underflow of hue
 
                info["health_bar_outside"].Position = Vector2.new(box.X - 6, box.Y - 1)
                info["health_bar_outside"].Size = Vector2.new(4, box.H + 2)
                info["health_bar_outside"].Transparency = math.clamp(-(flags["visuals_health_bars_color"].transparency) + 1 - 0.5, 0, 1)
                info["health_bar_outside"].Visible = true
 
                info["health_bar"].Position = Vector2.new(box.X - 5, health_position)
                info["health_bar"].Size = Vector2.new(2, health_size)
                info["health_bar"].Transparency = -(flags["visuals_health_bars_color"].transparency) + 1
                info["health_bar"].Color = Color3.fromHSV(health_color, saturation, value)
                info["health_bar"].Visible = true
 
                if (stats.Health.Base.Value <= 90) then
                    if (flags["visuals_health_bar_text"]) then
                        info["health_bar_text"].Position = Vector2.new(box.X - 7 - info["health_bar_text"].TextBounds.X, health_position - info["health_bar_text"].TextBounds.Y / 2)
                        info["health_bar_text"].Color = Color3.fromHSV(health_color, saturation, value)
                        info["health_bar_text"].OutlineColor = flags["visuals_health_bar_text_color"].color
                        info["health_bar_text"].Transparency = -(flags["visuals_health_bar_text_color"].transparency) + 1
                        info["health_bar_text"].Text = tostring(math.ceil(stats.Health.Base.Value))
                        info["health_bar_text"].Visible = true
                    else
                        info["health_bar_text"].Visible = false
                    end
                else
                    info["health_bar_text"].Visible = false
                end
            else
                if (info["health_bar_outside"]) then
                    info["health_bar_outside"].Visible = false
                end
 
                if (info["health_bar"]) then
                    info["health_bar"].Visible = false
                end
 
                if (info["health_bar_text"]) then
                    info["health_bar_text"].Visible = false
                end
            end
 
            if (flags["visuals_health_bars_boost"] and flags["visuals_health_bars"]) then
                local health_fraction = math.floor(stats.Health.Bonus.Value) / 50
 
                local health_size = math.floor(box.H * health_fraction)
                local health_position = math.floor((box.Y + box.H) - health_size)
 
                info["health_bar_boost"].Position = Vector2.new(box.X - 5, health_position)
                info["health_bar_boost"].Size = Vector2.new(2, health_size)
                info["health_bar_boost"].Transparency = -(flags["visuals_health_bars_boost_color"].transparency) + 1
                info["health_bar_boost"].Color = flags["visuals_health_bars_boost_color"].color
                info["health_bar_boost"].Visible = true
 
                if (stats.Health.Bonus.Value > 1) then
                    if (flags["visuals_health_bar_text"]) then
                        info["health_bar_text"].Position = Vector2.new(box.X - 7 - info["health_bar_text"].TextBounds.X, health_position - info["health_bar_text"].TextBounds.Y / 2)
                        info["health_bar_text"].Color = Color3.new(255, 255, 255)
                        info["health_bar_text"].OutlineColor = flags["visuals_health_bar_text_color"].color
                        info["health_bar_text"].Transparency = -(flags["visuals_health_bar_text_color"].transparency) + 1
                        info["health_bar_text"].Text = tostring(math.ceil(stats.Health.Base.Value + stats.Health.Bonus.Value))
                        info["health_bar_text"].Visible = true
                    else
                        info["health_bar_text"].Visible = false
                    end
                else
                    if (stats.Health.Base.Value > 90) then
                        info["health_bar_text"].Visible = false
                    end
                end
            else
                if (info["health_bar_boost"]) then
                    info["health_bar_boost"].Visible = false
                end
            end
 
            if (flags["visuals_names"]) then
                info["name"].Position = Vector2.new(box.X + (box.W / 2), box.Y - 5 - info["name"].TextBounds.Y)
                info["name"].OutlineColor = flags["visuals_names_color"].color
                info["name"].Transparency = -(flags["visuals_names_color"].transparency) + 1
                info["name"].Text = (flags["visuals_display_names"] and player.DisplayName) or player.Name
                info["name"].Visible = true
            else
                if (info["name"]) then
                    info["name"].Visible = false
                end
            end
 
            local bottom_offset = 0
 
            if (flags["visuals_active_weapon"]) then
                local weapon = player.Character.Animator.EquippedItem.ItemName.Value ~= "" and player.Character.Animator.EquippedItem.ItemName.Value or "Hands"
 
                info["active_weapon"].Position = Vector2.new(box.X + (box.W / 2), box.Y + box.H + 3 + bottom_offset)
                info["active_weapon"].OutlineColor = flags["visuals_active_weapon_color"].color
                info["active_weapon"].Transparency = -(flags["visuals_active_weapon_color"].transparency) + 1
                info["active_weapon"].Text = weapon
                info["active_weapon"].Visible = true
 
                bottom_offset += info["active_weapon"].TextBounds.Y + 3
            else
                if (info["active_weapon"]) then
                    info["active_weapon"].Visible = false
                end
            end
 
            if (flags["visuals_view_tracer"]) then
                local camera_direction = player.Character.Head.CFrame.lookVector * flags["visuals_view_tracer_length"]
 
                local parameters = RaycastParams.new()
 
                parameters.FilterDescendantsInstances = {current_camera, local_player.Character}
                parameters.FilterType = Enum.RaycastFilterType.Blacklist
 
                local result = game:GetService("Workspace"):Raycast(player.Character.Head.Position, camera_direction, parameters)
 
                if (result) then
                    local head_position, visible = current_camera:WorldToViewportPoint(player.Character.Head.Position)
                    local hit_position, visible_hit = current_camera:WorldToViewportPoint(result.Position)
 
                    if (not visible or not visible_hit) then
                        info["view_tracer"].Visible = false
                    else
                        info["view_tracer"].From = Vector2.new(head_position.X, head_position.Y)
                        info["view_tracer"].To = Vector2.new(hit_position.X, hit_position.Y)
 
                        info["view_tracer"].Color = flags["visuals_view_tracer_color"].color
                        info["view_tracer"].Transparency = -(flags["visuals_view_tracer_color"].transparency) + 1
                        info["view_tracer"].Visible = true
                    end
                else
                    local head_position, visible = current_camera:WorldToViewportPoint(player.Character.Head.Position)
                    local hit_position, visible_hit = current_camera:WorldToViewportPoint(player.Character.Head.Position + camera_direction)
 
                    if (not visible or not visible_hit) then
                        info["view_tracer"].Visible = false
                    else
                        info["view_tracer"].From = Vector2.new(head_position.X, head_position.Y)
                        info["view_tracer"].To = Vector2.new(hit_position.X, hit_position.Y)
 
                        info["view_tracer"].Color = flags["visuals_view_tracer_color"].color
                        info["view_tracer"].Transparency = -(flags["visuals_view_tracer_color"].transparency) + 1
                        info["view_tracer"].Visible = true
                    end
                end
            else
            if (info["view_tracer"]) then
                    info["view_tracer"].Visible = false
                end
            end
 
            if (flags["visuals_distance"]) then
                local localization_division = {
                    ["Roblox"] = 1,
                    ["Imperial"] = 3.265, -- Really rough estimate
                    ["Metric"] = 3.333 -- Rough estimate
                }
 
                local localization_suffix = {
                    ["Roblox"] = "s",
                    ["Imperial"] = "y",
                    ["Metric"] = "m"
                }
 
                local distance = math.floor((player.Character.HumanoidRootPart.Position - local_player.Character.HumanoidRootPart.Position).Magnitude / localization_division[flags["visuals_preferred_measurement"]])
 
                info["distance"].Position = Vector2.new(box.X + (box.W / 2), box.Y + box.H + 3 + bottom_offset)
                info["distance"].OutlineColor = flags["visuals_distance_color"].color
                info["distance"].Transparency = -(flags["visuals_distance_color"].transparency) + 1
                info["distance"].Text = "["..tostring(distance).. localization_suffix[flags["visuals_preferred_measurement"]].."]"
                info["distance"].Visible = true
 
                bottom_offset += info["distance"].TextBounds.Y + 3
            else
                if (info["distance"]) then
                    info["distance"].Visible = false
                end
            end
 
            if (flags["visuals_skeletons"]) then
                for _, part in next, character:GetChildren() do
                    local parent_part = skeleton_order[part.Name]
 
                    if (not parent_part) then continue end
 
                    local part_position, on_screen_start = current_camera:WorldToViewportPoint(part.Position)
                    local parent_part_position, on_screen_end = current_camera:WorldToViewportPoint(character:FindFirstChild(parent_part).Position)
 
                    info["skeleton_".. part.Name].From = Vector2.new(part_position.X, part_position.Y)
                    info["skeleton_".. part.Name].To = Vector2.new(parent_part_position.X, parent_part_position.Y)
 
                    info["skeleton_".. part.Name].Color = flags["visuals_skeletons_color"].color
                    info["skeleton_".. part.Name].Transparency = -(flags["visuals_skeletons_color"].transparency) + 1
 
                    info["skeleton_".. part.Name].Visible = true
                end
            else
                for required, _ in next, skeleton_order do
                    if (info["skeleton_".. required]) then
                        info["skeleton_".. required].Visible = false
                    end
                end
            end
 
            if (info["oof_arrow"]) then
                info["oof_arrow"].Visible = false
            end
 
            if (info["oof_arrow_outside"]) then
                info["oof_arrow_outside"].Visible = false
            end
        else
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            if (flags["visuals_oof_arrows"]) then
                local fix_ratio = 450 / flags["visuals_oof_arrows_radius"]
 
                local relative = current_camera.CFrame:PointToObjectSpace(player.Character.HumanoidRootPart.Position)
                local middle = current_camera.ViewportSize / 2
 
                local degree = math.deg(math.atan2(-relative.Y, relative.X)) * math.pi / 180
 
                local end_pos = middle + (Vector2.new(math.cos(degree), math.sin(degree))) * flags["visuals_oof_arrows_radius"]
                local end_pos_a = middle + (Vector2.new(math.cos(degree + math.rad(2 * fix_ratio)), math.sin(degree + math.rad(2 * fix_ratio)))) * flags["visuals_oof_arrows_radius"]
                local end_pos_c = middle + (Vector2.new(math.cos(degree - math.rad(2 * fix_ratio)), math.sin(degree - math.rad(2 * fix_ratio)))) * flags["visuals_oof_arrows_radius"]
 
                local difference = middle - end_pos
 
                info["oof_arrow"].PointA = end_pos_a
                info["oof_arrow"].PointB = end_pos + (-difference.Unit * 15)
                info["oof_arrow"].PointC = end_pos_c
 
                info["oof_arrow"].Visible = true
                info["oof_arrow"].Color = flags["visuals_oof_arrows_color"].color
                info["oof_arrow"].Transparency = -(flags["visuals_oof_arrows_color"].transparency) + 1
 
                info["oof_arrow_outside"].PointA = end_pos_a
                info["oof_arrow_outside"].PointB = end_pos + (-difference.Unit * 16)
                info["oof_arrow_outside"].PointC = end_pos_c
 
                info["oof_arrow_outside"].Visible = true
                info["oof_arrow_outside"].Color = Color3.new(0, 0, 0)
                info["oof_arrow_outside"].Transparency = -(flags["visuals_oof_arrows_color"].transparency) + 1
            end
        end
    end
 
    for player, _ in next, cheat.visuals.info do
        if (not game:GetService("Players"):FindFirstChild(player)) then
            for _, object in next, cheat.visuals.info[player] do
                object:Remove()
            end
 
            cheat.visuals.info[player] = nil
        end
    end
end)
 
cheat:render_stepped(1, function(delta)
    for _, zombie in next, game:GetService("Workspace").Zombies.Mobs:GetChildren() do
        local info = cheat.visuals.zombies[zombie.Name]
 
        if (not zombie:FindFirstChild("HumanoidRootPart")) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (not local_player.Character) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if ((zombie.HumanoidRootPart.Position - local_player.Character.HumanoidRootPart.Position).Magnitude > flags["visuals_boss_max_distance"]) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        -- HACK: What the fuck
        local box = calculate_box({["Character"] = zombie})
 
        if ((not flags["visuals_enabled"] and not flags["visuals_enabled_toggle"].state) or not box) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (not zombie:FindFirstChild("Equipment")) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (#zombie.Equipment:GetChildren() == 0) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        local found_gun = false
 
        for _, child in next, zombie.Equipment:GetChildren() do
            if (child.Name:find("Firearm")) then
                found_gun = true
                break
            end
        end
 
        if (not found_gun) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (not info) then
            cheat.visuals.zombies[zombie.Name] = {}
 
            cheat.visuals.zombies[zombie.Name]["box_outside"] = cheat.draw("Square", {
                Color = Color3.new(0, 0, 0),
                Thickness = 1,
                Transparency = math.clamp(1 - 0.5, 0, 1),
                Filled = false
            })
 
            cheat.visuals.zombies[zombie.Name]["box"] = cheat.draw("Square", {
                Color = flags["visuals_boss_boxes_color"].color,
                Thickness = 1,
                Transparency = 1,
                Filled = false
            })
 
            cheat.visuals.zombies[zombie.Name]["box_inside"] = cheat.draw("Square", {
                Color = Color3.new(0, 0, 0),
                Thickness = 1,
                Transparency = math.clamp(-(flags["visuals_boss_boxes_color"].transparency) + 1 - 0.5, 0, 1),
                Filled = false
            })
 
            cheat.visuals.zombies[zombie.Name]["name"] = cheat.draw("Text", {
                Color = Color3.new(1, 1, 1),
                OutlineColor = flags["visuals_boss_names_color"].color,
                Center = true,
                Outline = true,
                Size = 13,
                Transparency = -(flags["visuals_boss_names_color"].transparency) + 1,
                Font = 2
            })
 
            info = cheat.visuals.zombies[zombie.Name]
        end
 
        if (flags["visuals_boss_boxes"]) then
            info["box_outside"].Position = Vector2.new(box.X - 1, box.Y - 1)
            info["box_outside"].Size = Vector2.new(box.W + 2, box.H + 2)
            info["box_outside"].Transparency = math.clamp(-(flags["visuals_boss_boxes_color"].transparency) + 1 - 0.5, 0, 1)
            info["box_outside"].Visible = true
 
            info["box"].Position = Vector2.new(box.X, box.Y)
            info["box"].Size = Vector2.new(box.W, box.H)
            info["box"].Transparency = -(flags["visuals_boss_boxes_color"].transparency) + 1
            info["box"].Color = flags["visuals_boss_boxes_color"].color
            info["box"].Visible = true
 
            info["box_inside"].Position = Vector2.new(box.X + 1, box.Y + 1)
            info["box_inside"].Size = Vector2.new(box.W - 2, box.H - 2)
            info["box_inside"].Transparency = math.clamp(-(flags["visuals_boss_boxes_color"].transparency) + 1 - 0.5, 0, 1)
            info["box_inside"].Visible = true
        else
            if (info["box"]) then
                info["box"].Visible = false
            end
 
            if (info["box_inside"]) then
                info["box_inside"].Visible = false
            end
 
            if (info["box_outside"]) then
                info["box_outside"].Visible = false
            end
        end
 
        if (flags["visuals_boss_names"]) then
            info["name"].Position = Vector2.new(box.X + (box.W / 2), box.Y - 5 - info["name"].TextBounds.Y)
            info["name"].OutlineColor = flags["visuals_boss_names_color"].color
            info["name"].Transparency = -(flags["visuals_boss_names_color"].transparency) + 1
            info["name"].Text = zombie.Name
            info["name"].Visible = true
        else
            if (info["name"]) then
                info["name"].Visible = false
            end
        end
    end
 
    for zombie, _ in next, cheat.visuals.zombies do
        if (not game:GetService("Workspace").Zombies.Mobs:FindFirstChild(zombie)) then
            for _, object in next, cheat.visuals.zombies[zombie] do
                object:Remove()
            end
 
            cheat.visuals.zombies[zombie] = nil
        end
    end
end)
 
cheat:render_stepped(1, function(delta)
    for _, event in next, game:GetService("Workspace").Map.Shared.Randoms:GetChildren() do
        local info = cheat.visuals.events[event.Name]
 
        if (not event:IsA("CFrameValue")) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (not local_player.Character) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if ((event.Value.Position - local_player.Character.HumanoidRootPart.Position).Magnitude > flags["visuals_event_max_distance"]) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if ((not flags["visuals_enabled"] and not flags["visuals_enabled_toggle"].state)) then
            if (info) then
                for _, object in next, info do
                    object.Visible = false
                end
            end
 
            continue
        end
 
        if (not info) then
            cheat.visuals.events[event.Name] = {}
 
            cheat.visuals.events[event.Name]["name"] = cheat.draw("Text", {
                Color = Color3.new(1, 1, 1),
                OutlineColor = flags["visuals_event_names_color"].color,
                Center = true,
                Outline = true,
                Size = 13,
                Transparency = -(flags["visuals_event_names_color"].transparency) + 1,
                Font = 2
            })
 
            info = cheat.visuals.events[event.Name]
        end
 
        local event_w2s, on_screen = current_camera:WorldToViewportPoint(event.Value.Position)
 
        if (flags["visuals_event_names"] and on_screen) then
            info["name"].Position = Vector2.new(event_w2s.X, event_w2s.Y - 5 - info["name"].TextBounds.Y)
            info["name"].OutlineColor = flags["visuals_event_names_color"].color
            info["name"].Transparency = -(flags["visuals_event_names_color"].transparency) + 1
            info["name"].Text = event.Name:gsub("%u", function(c, ...) return " " .. c end):sub(2, -3)
            info["name"].Visible = true
        else
            if (info["name"]) then
                info["name"].Visible = false
            end
        end
    end
 
    for event, _ in next, cheat.visuals.events do
        if (not game:GetService("Workspace").Map.Shared.Randoms:FindFirstChild(event)) then
            for _, object in next, cheat.visuals.events[event] do
                object:Remove()
            end
 
            cheat.visuals.events[event] = nil
        end
    end
end)
 
cheat:render_stepped(2, function(delta)
    local screen_size = current_camera.ViewportSize
    local info = cheat.visuals["self"]
 
    if (not info) then
        cheat.visuals["self"] = {
            ["mouse_fov"] = cheat.draw("Circle", {
                Color = flags["visuals_mouse_fov_color"].color,
                Thickness = 1,
                Transparency = -(flags["visuals_mouse_fov_color"].transparency) + 1,
                Filled = false,
                NumSides = 50,
            }),
 
            ["silent_fov"] = cheat.draw("Circle", {
                Color = flags["visuals_silent_fov_color"].color,
                Thickness = 1,
                Transparency = -(flags["visuals_silent_fov_color"].transparency) + 1,
                Filled = false,
                NumSides = 50,
            }),
 
            ["crosshair_outline"] = {
                ["path_1"] = cheat.draw("Line", {
                    Color = Color3.new(0, 0, 0),
                    Thickness = 3,
                    Transparency = math.clamp(-(flags["visuals_crosshair_color"].transparency) + 1 - 0.5, 0, 1),
                    ZIndex = 1,
                }),
 
                ["path_2"] = cheat.draw("Line", {
                    Color = Color3.new(0, 0, 0),
                    Thickness = 3,
                    Transparency = math.clamp(-(flags["visuals_crosshair_color"].transparency) + 1 - 0.5, 0, 1),
                    ZIndex = 1,
                })
            },
 
            ["crosshair"] = {
                ["path_1"] = cheat.draw("Line", {
                    Color = flags["visuals_crosshair_color"].color,
                    Thickness = 1,
                    Transparency = -(flags["visuals_crosshair_color"].transparency) + 1,
                    ZIndex = 2,
                }),
 
                ["path_2"] = cheat.draw("Line", {
                    Color = flags["visuals_crosshair_color"].color,
                    Thickness = 1,
                    Transparency = -(flags["visuals_crosshair_color"].transparency) + 1,
                    ZIndex = 2,
                })
            },
        }
 
        info = cheat.visuals["self"]
    end
 
    if (not flags["visuals_enabled"]) then
        if (info["mouse_fov"]) then
            info["mouse_fov"].Visible = false
        end
 
        if (info["silent_fov"]) then
            info["silent_fov"].Visible = false
        end
 
        if (info["crosshair"]) then
            info["crosshair"]["path_1"].Visible = false
            info["crosshair"]["path_2"].Visible = false
 
            info["crosshair_outline"]["path_1"].Visible = false
            info["crosshair_outline"]["path_2"].Visible = false
        end
 
        return
    end
 
    if (flags["visuals_mouse_fov"]) then
        info["mouse_fov"].Visible = true
        info["mouse_fov"].Position = screen_size / 2
        --current_camera.FieldOfView
        info["mouse_fov"].Radius = (math.tan(math.rad(flags["aimbot_mouse_fov"])) / math.tan(math.rad(70)) * screen_size.X) * (70 / current_camera.FieldOfView)
        info["mouse_fov"].Color = flags["visuals_mouse_fov_color"].color
        info["mouse_fov"].Transparency = -(flags["visuals_mouse_fov_color"].transparency) + 1
    else
        if (info["mouse_fov"]) then
            info["mouse_fov"].Visible = false
        end
    end
 
    if (flags["visuals_crosshair"]) then
        local function solve_path_1(t)
            return Vector2.new(screen_size.X / 2, screen_size.Y / 2) + Vector2.new(math.sin(t) * flags["visuals_crosshair_width"], math.cos(t) * flags["visuals_crosshair_width"])
        end
 
        local function solve_path_2(t)
            return Vector2.new(screen_size.X / 2, screen_size.Y / 2) + Vector2.new(-math.sin(t) * flags["visuals_crosshair_width"], -math.cos(t) * flags["visuals_crosshair_width"])
        end
 
        local function solve_path_3(t)
            return Vector2.new(screen_size.X / 2, screen_size.Y / 2) + Vector2.new(math.sin(t + math.rad(90)) * flags["visuals_crosshair_width"], math.cos(t + math.rad(90)) * flags["visuals_crosshair_width"])
        end
 
        local function solve_path_4(t)
            return Vector2.new(screen_size.X / 2, screen_size.Y / 2) + Vector2.new(-math.sin(t + math.rad(90)) * flags["visuals_crosshair_width"], -math.cos(t + math.rad(90)) * flags["visuals_crosshair_width"])
        end
 
        local current_rotation = not flags["visuals_crosshair_rotate"] and 0 or tick() * 1000 / 1000
 
        info["crosshair"]["path_1"].Visible = true
        info["crosshair"]["path_1"].From = solve_path_1(current_rotation)
        info["crosshair"]["path_1"].To = solve_path_2(current_rotation)
        info["crosshair"]["path_1"].Color = flags["visuals_crosshair_color"].color
        info["crosshair"]["path_1"].Transparency = -(flags["visuals_crosshair_color"].transparency) + 1
 
        info["crosshair"]["path_2"].Visible = true
        info["crosshair"]["path_2"].From = solve_path_3(current_rotation)
        info["crosshair"]["path_2"].To = solve_path_4(current_rotation)
        info["crosshair"]["path_2"].Color = flags["visuals_crosshair_color"].color
        info["crosshair"]["path_2"].Transparency = -(flags["visuals_crosshair_color"].transparency) + 1
 
        info["crosshair_outline"]["path_1"].Visible = true
        info["crosshair_outline"]["path_1"].From = solve_path_1(current_rotation)
        info["crosshair_outline"]["path_1"].To = solve_path_2(current_rotation)
        info["crosshair_outline"]["path_1"].Color = Color3.new(0, 0, 0)
        info["crosshair_outline"]["path_1"].Transparency = math.clamp(-(flags["visuals_crosshair_color"].transparency) + 1 - 0.5, 0, 1)
 
        info["crosshair_outline"]["path_2"].Visible = true
        info["crosshair_outline"]["path_2"].From = solve_path_3(current_rotation)
        info["crosshair_outline"]["path_2"].To = solve_path_4(current_rotation)
        info["crosshair_outline"]["path_2"].Color = Color3.new(0, 0, 0)
        info["crosshair_outline"]["path_2"].Transparency = math.clamp(-(flags["visuals_crosshair_color"].transparency) + 1 - 0.5, 0, 1)
    else
        if (info["crosshair"]) then
            info["crosshair"]["path_1"].Visible = false
            info["crosshair"]["path_2"].Visible = false
 
            info["crosshair_outline"]["path_1"].Visible = false
            info["crosshair_outline"]["path_2"].Visible = false
        end
    end
 
    if (flags["visuals_silent_fov"]) then
        info["silent_fov"].Visible = true
        info["silent_fov"].Position = screen_size / 2
        info["silent_fov"].Radius = (math.tan(math.rad(flags["aimbot_silent_fov"])) / math.tan(math.rad(70)) * screen_size.X) * (70 / current_camera.FieldOfView)
        info["silent_fov"].Color = flags["visuals_silent_fov_color"].color
        info["silent_fov"].Transparency = -(flags["visuals_silent_fov_color"].transparency) + 1
    else
        if (info["silent_fov"]) then
            info["silent_fov"].Visible = false
        end
    end
end)
 
cheat:heart_beat(function(delta)
    for _, player in next, game:GetService("Players"):GetPlayers() do
        local info = cheat.visuals.chams[player.Name]
 
        if (player == local_player) then
            if (info) then
                for _, object in next, info do
                    object:Destroy()
                end
 
                cheat.visuals.chams[player.Name] = nil
            end
 
            continue
        end
 
        if (not player.Character) then
            if (info) then
                for _, object in next, info do
                    object:Destroy()
                end
 
                cheat.visuals.chams[player.Name] = nil
            end
 
            continue
        end
 
        local character = player.Character
 
        if (not local_player.Character) then
            if (info) then
                for _, object in next, info do
                    object:Destroy()
                end
 
                cheat.visuals.chams[player.Name] = nil
            end
 
            continue
        end
 
 
        if (squad_list[player.Name]) then
            if (info) then
                for _, object in next, info do
                    object:Destroy()
                end
 
                cheat.visuals.chams[player.Name] = nil
            end
 
            continue
        end
 
        if (not character:FindFirstChild("HumanoidRootPart") or not local_player.Character:FindFirstChild("HumanoidRootPart")) then
            if (info) then
                for _, object in next, info do
                    object:Destroy()
                end
 
                cheat.visuals.chams[player.Name] = nil
            end
 
            continue
        end
 
        if (not flags["visuals_enabled"]) then
            if (info) then
                for _, object in next, info do
                    object:Destroy()
                end
 
                cheat.visuals.chams[player.Name] = nil
            end
 
            continue
        end
 
        if ((character.HumanoidRootPart.Position - local_player.Character.HumanoidRootPart.Position).Magnitude > flags["visuals_player_max_distance"]) then
            if (info) then
                for _, object in next, info do
                    object:Destroy()
                end
 
                cheat.visuals.chams[player.Name] = nil
            end
 
            continue
        end
 
        if (not info) then
            cheat.visuals.chams[player.Name] = {}
 
            cheat.visuals.chams[player.Name]["highlight"] = Instance.new("Highlight", character)
            cheat.visuals.chams[player.Name]["highlight"].Name = "🐛"
            cheat.visuals.chams[player.Name]["highlight"].FillTransparency = 0.55 -- Perfect ratio between transparency and color
            cheat.visuals.chams[player.Name]["highlight"].Adornee = character
            cheat.visuals.chams[player.Name]["highlight"].Enabled = false
 
            info = cheat.visuals.chams[player.Name]
        end
 
        local camera_direction = (character.HumanoidRootPart.Position - current_camera.CFrame.Position)
 
        local parameters = RaycastParams.new()
 
        parameters.FilterDescendantsInstances = {current_camera, local_player.Character}
        parameters.FilterType = Enum.RaycastFilterType.Blacklist
 
        local result = game:GetService("Workspace"):Raycast(current_camera.CFrame.Position, camera_direction, parameters)
 
        if (flags["visuals_visible_chams"] and result and result.Instance and result.Instance:IsDescendantOf(character)) then
            for _, object in next, info do
                if (object:IsA("Highlight")) then
                    object.Enabled = true
 
                    object.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    object.FillColor = flags["visuals_visible_chams_color"].color
                    object.FillTransparency = flags["visuals_visible_chams_color"].transparency
                    object.OutlineColor = flags["visuals_outline_chams_color"].color
                    object.OutlineTransparency = (flags["visuals_outline_chams"] and flags["visuals_outline_chams_color"].transparency) or 1
                end
            end
 
            continue
        end
 
        if (flags["visuals_occluded_chams"]) then
            for _, object in next, info do
                if (object:IsA("Highlight")) then
                    object.Enabled = true
 
                    object.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    object.FillColor = flags["visuals_occluded_chams_color"].color
                    object.FillTransparency = flags["visuals_occluded_chams_color"].transparency
                    object.OutlineColor = flags["visuals_outline_chams_color"].color
                    object.OutlineTransparency = (flags["visuals_outline_chams"] and flags["visuals_outline_chams_color"].transparency) or 1
                end
            end
 
            continue
        end
 
        for _, object in next, info do
            if (object:IsA("Highlight")) then
                object.Enabled = false
            end
        end
    end
 
    for player, _ in next, cheat.visuals.chams do
        if (not game:GetService("Players"):FindFirstChild(player)) then
            for _, object in next, cheat.visuals.chams[player] do
                object:Destroy()
            end
 
            cheat.visuals.chams[player] = nil
        end
    end
end)
 
cheat:heart_beat(function(delta)
    local texture_map = {
        ["Lightning"] = "rbxassetid://446111271",
        ["Smoke"] = "rbxassetid://3517446796"
    }
 
    for timestamp, tracer in next, cheat.visuals.tracers do
        if (not tracer.object) then
            if (not game:GetService("Workspace"):FindFirstChild("Beams")) then
                local beams = Instance.new("Folder", game:GetService("Workspace"))
                beams.Name = "Beams"
            end
 
            tracer.object = Instance.new("Part", game:GetService("Workspace")["Beams"])
            tracer.object.Name = "🐛"
            tracer.object.Anchored = true
            tracer.object.Size = Vector3.new(0.1, 0.1, (tracer["end"] - tracer["start"]).Magnitude)
            tracer.object.CFrame = CFrame.lookAt(tracer["start"], tracer["end"]) + (tracer["end"] - tracer["start"]) / 2
            tracer.object.Transparency = 1
            tracer.object.CanCollide = false
 
            local attachment_1 = Instance.new("Attachment", tracer.object)
            attachment_1.Name = "🐛_1"
            attachment_1.Position = Vector3.new(0, 0, -tracer.object.Size.Z / 2)
 
            local attachment_2 = Instance.new("Attachment", tracer.object)
            attachment_2.Name = "🐛_2"
            attachment_2.Position = Vector3.new(0, 0, tracer.object.Size.Z / 2)
 
            local beam = Instance.new("Beam", tracer.object)
            beam.Name = "🐛"
            beam.Attachment0 = attachment_1
            beam.Attachment1 = attachment_2
            beam.FaceCamera = flags["visuals_bullet_tracers_face_camera"]
            beam.Brightness = 1
            beam.LightEmission = 1
            beam.LightInfluence = 0
            beam.Texture = texture_map[flags["visuals_bullet_tracers_texture"]]
            beam.TextureLength = 1
            beam.TextureMode = Enum.TextureMode.Stretch
            beam.TextureSpeed = 0.7
            beam.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.1, 0),
                NumberSequenceKeypoint.new(0.9, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            beam.Width0 = flags["visuals_bullet_tracers_thickness"] / 10
            beam.Width1 = flags["visuals_bullet_tracers_thickness"] / 10
 
            beam.Color = ColorSequence.new(flags["visuals_bullet_tracers_color"].color)
            beam.Brightness = 1
        end
 
        if (os.clock() - timestamp > 3) then
            tracer.object:Destroy()
 
            cheat.visuals.tracers[timestamp] = nil
 
            continue
        end
 
        if (not flags["visuals_bullet_tracers"] or not flags["visuals_enabled"]) then
            tracer.object:Destroy()
 
            cheat.visuals.tracers[timestamp] = nil
 
            continue
        end
 
        tracer.object:FindFirstChild("🐛").Width0 = flags["visuals_bullet_tracers_thickness"]
        tracer.object:FindFirstChild("🐛").Width1 = flags["visuals_bullet_tracers_thickness"]
 
        tracer.object:FindFirstChild("🐛").Color = ColorSequence.new(flags["visuals_bullet_tracers_color"].color)
        tracer.object:FindFirstChild("🐛").Brightness = (-(flags["visuals_bullet_tracers_color"].transparency) + 1) * 2
        tracer.object:FindFirstChild("🐛").Texture = texture_map[flags["visuals_bullet_tracers_texture"]]
 
    end
end)
 
cheat:heart_beat(function(delta)
    local function find_target()
        local closest_fov = math.huge
        local closest_player = nil
 
        for _, player in next, game:GetService("Players"):GetPlayers() do
            if (player == local_player) then continue end
 
            if (not player.Character) then continue end
            if (not local_player.Character) then continue end
            if (not player.Character:FindFirstChild("HumanoidRootPart")) then continue end
 
            if (flags["aimbot_player_max_distance"] < (player.Character.HumanoidRootPart.Position - local_player.Character.HumanoidRootPart.Position).Magnitude) then
                continue
            end
 
            local fov = (math.deg(math.acos(current_camera.CFrame.LookVector:Dot((player.Character.HumanoidRootPart.Position - current_camera.CFrame.Position).Unit))))
 
            if (fov < closest_fov) then
                closest_fov = fov
                closest_player = player
            end
        end
 
        return closest_player, closest_fov
    end
 
    local function find_hitbox(player, max_fov)
        local fixed_names = {
            ["LeftFoot"] = "Legs",
            ["LeftLowerLeg"] = "Legs",
            ["LeftUpperLeg"] = "Legs",
 
            ["RightFoot"] = "Legs",
            ["RightLowerLeg"] = "Legs",
            ["RightUpperLeg"] = "Legs",
 
            ["LeftHand"] = "Arms",
            ["LeftLowerArm"] = "Arms",
            ["LeftUpperArm"] = "Arms",
 
            ["RightHand"] = "Arms",
            ["RightLowerArm"] = "Arms",
            ["RightUpperArm"] = "Arms",
 
            ["LowerTorso"] = "Torso",
            ["UpperTorso"] = "Torso",
 
            ["Head"] = "Head"
        }
 
        local closest_fov = max_fov
        local closest_hitbox = nil
 
        for _, hitbox in next, player.Character:GetChildren() do
            if (fixed_names[hitbox.Name] and table.find(flags["aimbot_hitboxes"], fixed_names[hitbox.Name])) then
                local fov = math.deg(math.acos(current_camera.CFrame.LookVector:Dot((hitbox.Position - current_camera.CFrame.Position).Unit)))
 
                if (fov < closest_fov) then
                    closest_fov = fov
                    closest_hitbox = hitbox
                end
            end
        end
 
        return closest_hitbox
    end
 
    if (not flags["aimbot_enabled"]) then return end
    if (not local_player.Character) then return end
 
    local player_children = local_player.Character.Equipped:GetChildren()
 
    if (#player_children < 1) then return end
 
    local closest_player, closest_fov = find_target()
    local gun_info = modules.item_data[player_children[1].Name:gsub("Mod%d+", "")]
 
    if (not gun_info) then
        error("[Aimbot] Gun not found: " .. player_children[1])
        cheat.aimbot.silent_angle = nil
 
        return
    end
 
    if (not player_children[1]:FindFirstChild("Muzzle")) then
        cheat.aimbot.silent_angle = nil
 
        return
    end
 
    if (not closest_player) then
        cheat.aimbot.silent_angle = nil
 
        return
    end
 
    if (squad_list[closest_player.Name]) then
        cheat.aimbot.silent_angle = nil
 
        return
    end
 
    local screen_center = current_camera.ViewportSize / 2
 
    if (not cheat.aimbot.info[closest_player.Name]) then
        cheat.aimbot.info[closest_player.Name] = {
           last_position = closest_player.Character.HumanoidRootPart.Position
        }
 
        cheat.aimbot.silent_angle = nil
 
        return
    end
 
    local player_origin = closest_player.Character.HumanoidRootPart.Position
 
    if ((flags["aimbot_mouse_enabled"] or flags["aimbot_mouse_enabled_hold"].state) and closest_fov < flags["aimbot_mouse_fov"]) then
        if (cheat.aimbot.last_target == closest_player.Name and cheat.aimbot.progress < 1) then
            cheat.aimbot.progress += delta / (flags["aimbot_mouse_smoothing"] + math.random(0, flags["aimbot_mouse_jitter"] * 100) / 100)
        else
            cheat.aimbot.progress = 0
            cheat.aimbot.last_target = closest_player.Name
        end
 
        local origin = player_children[1].Muzzle.Position
        local part = find_hitbox(closest_player, flags["aimbot_mouse_fov"])
 
        if (part) then
            local time_to_hit = physics.time_to_hit(part.Position, gun_info.FireConfig.MuzzleVelocity, origin, -(game:GetService("Workspace").Gravity / 2))
            local velocity = (player_origin - cheat.aimbot.info[closest_player.Name].last_position) * (1 / delta)
            local target = part.Position + (velocity * time_to_hit)
 
            local delta_time_to_hit = physics.time_to_hit(target, gun_info.FireConfig.MuzzleVelocity, origin, -(game:GetService("Workspace").Gravity / 2))
            local delta_velocity = (player_origin - cheat.aimbot.info[closest_player.Name].last_position) * (1 / delta_time_to_hit)
            local delta_target = part.Position + (delta_velocity * delta_time_to_hit)
 
            local curve = physics.trajectory(origin, Vector3.new(), Vector3.new(0, -(game:GetService("Workspace").Gravity / 2), 0), delta_target, Vector3.new(), Vector3.new(), gun_info.FireConfig.MuzzleVelocity)
 
            if (curve) then
                local predicited_position = origin + curve
                local w2s = current_camera:WorldToViewportPoint(predicited_position)
 
                mousemoverel(((w2s.X - screen_center.X) / 2) * cheat.bezier(0, 1.1, 1, 1, cheat.aimbot.progress), ((w2s.Y - screen_center.Y) / 2) * cheat.bezier(0, 1.1, 1, 1, cheat.aimbot.progress))
            end
        end
    else
        cheat.aimbot.progress = 0
    end
 
    if ((flags["aimbot_silent_enabled"] or flags["aimbot_silent_enabled_hold"].state) and closest_fov < flags["aimbot_silent_fov"]) then
        if (flags["aimbot_silent_hitchance"] < math.random(0, 100)) then
            cheat.aimbot.silent_angle = nil
 
            return
        end
 
        local origin = player_children[1].Muzzle.Position
 
        local part = find_hitbox(closest_player, flags["aimbot_silent_fov"])
 
        if (flags["aimbot_silent_magic_bullets"] or flags["aimbot_silent_magic_bullets_hold"].state) then
            origin += player_children[1].Muzzle.CFrame.LookVector * math.clamp((player_children[1].Muzzle.Position - closest_player.Character.HumanoidRootPart.Position).Magnitude, 0, flags["aimbot_silent_magic_bullet_depth"])
 
            cheat.aimbot.silent_origin = origin
        else
            cheat.aimbot.silent_origin = nil
        end
 
        if (part) then
            local time_to_hit = physics.time_to_hit(part.Position, gun_info.FireConfig.MuzzleVelocity, origin, -(game:GetService("Workspace").Gravity / 2))
            local velocity = (player_origin - cheat.aimbot.info[closest_player.Name].last_position) * (1 / delta)
            local target = part.Position + (velocity * time_to_hit)
 
            local delta_time_to_hit = physics.time_to_hit(target, gun_info.FireConfig.MuzzleVelocity, origin, -(game:GetService("Workspace").Gravity / 2))
            local delta_velocity = (player_origin - cheat.aimbot.info[closest_player.Name].last_position) * (1 / delta_time_to_hit)
            local delta_target = part.Position + (delta_velocity * delta_time_to_hit)
 
            local curve = physics.trajectory(origin, Vector3.new(), Vector3.new(0, -(game:GetService("Workspace").Gravity / 2), 0), delta_target, Vector3.new(), Vector3.new(), gun_info.FireConfig.MuzzleVelocity)
 
            if (curve) then
                local current_spread = (math.random(0, -(flags["aimbot_silent_accuracy"]) + 100) / 100) * 5
 
                local predicited_position = origin + curve + Vector3.new(current_spread, current_spread, current_spread)
 
                cheat.aimbot.silent_angle = (predicited_position - origin).Unit
            else
                cheat.aimbot.silent_angle = nil
                cheat.aimbot.silent_origin = nil
            end
        else
            cheat.aimbot.silent_angle = nil
            cheat.aimbot.silent_origin = nil
        end
    else
        cheat.aimbot.silent_angle = nil
        cheat.aimbot.silent_origin = nil
    end
 
    cheat.aimbot.info[closest_player.Name].last_position = player_origin
end)
 
cheat:heart_beat(function(delta)
    setsimulationradius(math.huge)
 
    if (not flags["misc_enabled"]) then
        return
    end
 
    if (not local_player.Character) then
        return
    end
 
    if (not local_player.Character:FindFirstChild("HumanoidRootPart")) then
        return
    end
 
    local owned_zombies = {}
    local owned_bosses = {}
 
    for _, zombie in next, game:GetService("Workspace").Zombies.Mobs:GetChildren() do
        if (zombie.PrimaryPart and isnetworkowner(zombie.PrimaryPart)) then
            if (zombie:FindFirstChild("Equipment")) then
                local found_gun = false
 
                for _, child in next, zombie.Equipment:GetChildren() do
                    if (child.Name:find("Firearm")) then
                        found_gun = true
                        break
                    end
                end
 
                if (found_gun) then
                    owned_bosses[#owned_bosses + 1] = zombie
 
                    continue
                end
            end
 
            owned_zombies[#owned_zombies + 1] = zombie
        end
    end
 
    if (flags["misc_zombie_circle"]) then
        for i = 360 / #owned_zombies, 360, 360 / #owned_zombies do
            local current_rotation = math.rad((i + tick() * flags["misc_zombie_circle_speed"]) % 360)
 
            local x = local_player.Character.HumanoidRootPart.Position.X + math.cos(current_rotation) * flags["misc_zombie_circle_radius"]
            local z = local_player.Character.HumanoidRootPart.Position.Z + math.sin(current_rotation) * flags["misc_zombie_circle_radius"]
 
            local location = math.ceil(#owned_zombies * (i / 360))
 
            local zombie = owned_zombies[location]
 
            if (not zombie) then
                break
            end
 
            zombie.PrimaryPart.CFrame = CFrame.new(x, local_player.Character.HumanoidRootPart.Position.Y, z) * CFrame.Angles(0, 0, 0)
        end
    end
 
    for _, zombie in next, owned_zombies do
        if (flags["misc_zombie_remover"]) then
            if (flags["misc_zombie_remover_mode"] == "Delete") then
                zombie.PrimaryPart.CFrame = CFrame.new(0, -1000, 0)
            else
                local did_teleport = false
 
                repeat
                    local random_player = game:GetService("Players"):GetPlayers()[math.random(1, #game:GetService("Players"):GetPlayers())]
 
                    if (random_player ~= local_player and random_player.Character and random_player.Character:FindFirstChild("HumanoidRootPart") and not squad_list[random_player.Name]) then
                        zombie.PrimaryPart.CFrame = random_player.Character.HumanoidRootPart.CFrame
                        did_teleport = true
                    end
                until did_teleport
            end
        end
 
        zombie.HumanoidRootPart.Anchored = flags["misc_zombie_freezer"]
    end
 
    for _, boss in next, owned_bosses do
        boss.HumanoidRootPart.Anchored = flags["misc_boss_freezer"]
    end
end)
 
cheat:heart_beat(function(delta)
    if (not flags["misc_enabled"]) then
        return
    end
 
    if (not local_player.Character) then
        cheat.bypass = false
 
        return
    end
 
    if (not local_player.Character:FindFirstChild("HumanoidRootPart")) then
        cheat.bypass = false
 
        return
    end
 
    if (cheat.teleport_bypass) then
        local_player.Character.HumanoidRootPart.Velocity = Vector3.zero
    end
 
    if (flags["misc_fly"] or flags["misc_fly_toggle"].state) then
        cheat.bypass = true
 
        if (not cheat.bypass_ran) then
            return
        end
 
        local_player.Character.HumanoidRootPart.Velocity = Vector3.zero
 
        local is_key_down = game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D)
 
        if (is_key_down) then
            local_player.Character.HumanoidRootPart.CFrame += Vector3.new(local_player.Character.Humanoid.MoveDirection.X * flags["misc_fly_speed"] * delta, current_camera.CFrame.LookVector.Y * (flags["misc_fly_speed"] / 2) * delta, local_player.Character.Humanoid.MoveDirection.Z * flags["misc_fly_speed"] * delta)
        end
    elseif (flags["misc_speed"] or flags["misc_speed_toggle"].state) then
        cheat.bypass = true
 
        if (not cheat.bypass_ran) then
            return
        end
 
        local_player.Character.HumanoidRootPart.Velocity *= Vector3.new(0, 1, 0)
 
        local is_key_down = game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) or game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D)
 
        if (is_key_down) then
            local_player.Character.HumanoidRootPart.CFrame += Vector3.new(local_player.Character.Humanoid.MoveDirection.X * flags["misc_speed_velocity"] * delta, 0, local_player.Character.Humanoid.MoveDirection.Z * flags["misc_speed_velocity"] * delta)
        end
    else
        cheat.bypass = false
    end
end)
 
cheat:heart_beat(function(delta)
    if (not flags["visuals_enabled"]) then
        return
    end
 
    if (flags["misc_full_bright"]) then
        game:GetService("Lighting").ClockTime = 12
    end
end)
 
local rewrite_functions = {}
 
local function find_functions()
    -- 20 bajillion times faster than looping through all of gc.
    table.foreach(getupvalues(modules["bullets"]["Fire"]), function(_, func)
        if (typeof(func) ~= "function") then return end
 
        local info = getinfo(func).name
 
        if (info == "getSpredAngle") then
            rewrite_functions["get_spread_angle"] = func
        end
 
        if (info == "getSpreadVector") then
            rewrite_functions["get_spread_vector"] = func
        end
 
        if (info == "castLocalBullet") then
            rewrite_functions["cast_local_bullet"] = func
        end
 
        if (info == "getFireImpulse") then
            rewrite_functions["get_fire_impulse"] = func
        end
 
        if (info == "playShootSound") then
            rewrite_functions["play_shoot_sound"] = func
        end
 
        if (info == "impactEffects") then
            rewrite_functions["impact_effects"] = func
        end
 
        if (info == "drawTracerPath") then
            rewrite_functions["draw_tracer_path"] = func
        end
    end)
end
 
repeat
    find_functions()
    task.wait()
until rewrite_functions["get_spread_angle"] and rewrite_functions["get_spread_vector"] and rewrite_functions["cast_local_bullet"] and rewrite_functions["get_fire_impulse"] and rewrite_functions["play_shoot_sound"] and rewrite_functions["impact_effects"] and rewrite_functions["draw_tracer_path"]
 
getgenv().distance = 1
 
-- CENSORED 
 
cheat:detour("Send", modules["network"], function(original, self, event_name, ...)
    local arguments = {...}
 
    if (event_name == "Bullet Fired") then
        for _, bullet in next, (typeof(arguments[5]) == "table" and arguments[5]) or arguments[4] do
            cheat.visuals.tracers[os.clock()] = {
                ["start"] = arguments[2],
                ["end"] = bullet["Position"]
            }
        end
    end
 
    if (event_name == "Set Character State") then
        if (flags["misc_enabled"]) then
            if (arguments[1] == "Falling" and flags["misc_spoof_falling"]) then
                arguments[1] = "Sitting"
            end
 
            if ((arguments[1] == "Walking" or "Running" or "SprintSwimming") and flags["misc_spoof_status"]) then
                arguments[1] = "Sitting"
            end
 
            if (cheat.bypass or cheat.teleport_bypass) then
                arguments[1] = "Climbing"
            end
        end
    end
 
    local original_return = original(self, event_name, unpack(arguments))
 
    if (not flags["misc_jitter_fix"]) then
        if (event_name == "Set Character State" and cheat.bypass and arguments[1] == "Climbing") then
            cheat.bypass_ran = true
        elseif (arguments[1] ~= "Climbing") then
            cheat.bypass_ran = false
        end
    else
        cheat.bypass_ran = cheat.bypass
    end
 
    if (event_name == "Set Character State" and cheat.teleport_bypass and arguments[1] == "Climbing") then
        cheat.teleport_bypass_ran = true
    elseif (arguments[1] ~= "Climbing") then
        cheat.teleport_bypass_ran = false
    else
        cheat.teleport_bypass_ran = cheat.teleport_bypass
    end
 
    return original_return
end)
