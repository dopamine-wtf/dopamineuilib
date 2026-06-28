if not LPH_OBFUSCATED then
	local assert = assert; local type = type; local setfenv = setfenv
	LPH_NO_VIRTUALIZE = function(f,...) assert(type(f)=="function" and #{...}==0); return f end
	LPH_NO_UPVALUES = function(f,...) assert(type(setfenv)=="function" and type(f)=="function" and #{...}==0); return f end
	LPH_CRASH = function(...) assert(#{...}==0) end
	LPH_ENCNUM = function(n,...) assert(type(n)=="number" and #{...}==0); return n end
	LPH_ENCSTR = function(s,...) assert(type(s)=="string" and #{...}==0); return s end
	LPH_ENCFUNC = function(f,ek,dk,...) assert(type(f)=="function" and type(ek)=="string" and #{...}==0); return f end
	LPH_JIT = function(f,...) assert(type(f)=="function" and #{...}==0); return f end
	LPH_JIT_MAX = LPH_JIT
end
game:GetService("ScriptContext").Error:Connect(function(m,t,s)if not s then warn("Script Error: "..m)end end)
local loadTick = os.clock()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dopamine-wtf/dopamineuilib/refs/heads/main/library.lua"))()
local v1 = {}
local v2 = 30

local function safeRun(func)
    local success, err = xpcall(func, function(e)
        return e
    end)

    if not success then
        local msg = tostring(err)

        if msg:lower():find("warning") then
            return
        end

        local now = os.clock()

        if not v1[msg] or (now - v1[msg]) >= v2 then
            v1[msg] = now

            Library:Notification(
                "Error",
                msg,
                5
            )
        end

        return
    end
end

local _hs_ids    = {}
local _hs_names  = {}
local _hs_volume = 1.0
local _hs_enabled = false
local _hs_selected_body = nil
local _hs_selected_head = nil

local _hs_targets = nil

local _hs_data = {
    ["SitNNDog"] = [[SUQzBAAAAAABAFRYWFgAAAASAAADbWFqb3JfYnJhbmQAbXA0MgBUWFhYAAAAEQAAA21pbm9yX3ZlcnNpb24AMABUWFhYAAAAHAAAA2NvbXBhdGlibGVfYnJhbmRzAGlzb21tcDQyAFRTU0UAAAAPAAADTGF2ZjYwLjE2LjEwMAAAAAAAAAAAAAAA]],
    ["TF2"]       = "rbxassetid://8255306220",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["Rust"]      = "rbxassetid://1255040462",
    ["Neverlose"] = "rbxassetid://8726881116",
    ["Bubble"]    = "rbxassetid://198598793",
    ["Quake"]     = "rbxassetid://1455817260",
    ["Ding"]      = "rbxassetid://2868331684",
    ["Minecraft"] = "rbxassetid://6361963422",
    ["Blackout"]  = "rbxassetid://3748776946",
    ["Osu"]       = "rbxassetid://7151989073",
    ["UWU"]       = "rbxassetid://8679659744",
    ["Dink"]      = "rbxassetid://988593556",
}

    do
    if not isfolder("hs_cache") then makefolder("hs_cache") end
    for name, data in pairs(_hs_data) do
        table.insert(_hs_names, name)
        if data:sub(1,4) == "rbxa" then
            _hs_ids[name] = data
        else
            local path = "hs_cache/" .. name .. ".mp3"
            pcall(function()
                if not isfile(path) then
                    local bytes = (syn and syn.crypt) and syn.crypt.base64.decode(data)
                                  or (crypt and crypt.base64decode(data))
                                  or data
                    writefile(path, bytes)
                end
                _hs_ids[name] = getcustomasset(path)
            end)
            if not _hs_ids[name] then _hs_ids[name] = "rbxassetid://8255306220" end
        end
    end
    table.sort(_hs_names)
    _hs_selected_body = _hs_names[1]
    _hs_selected_head = _hs_names[1]
end

local function _hs_apply()
    if not _hs_targets then return end
    if _hs_enabled then
        if _hs_ids[_hs_selected_body] then
            pcall(function()
                _hs_targets.Body.SoundId = _hs_ids[_hs_selected_body]
                _hs_targets.Body.Volume  = _hs_volume
            end)
        end
        if _hs_ids[_hs_selected_head] then
            pcall(function()
                _hs_targets.Head.SoundId = _hs_ids[_hs_selected_head]
                _hs_targets.Head.Volume  = _hs_volume
            end)
        end
    end
end

local function runMain()
    cheat = {}; nc = {}
    local EspInterface

    local function defaultFlags()
        cheat.box_color       = Color3.fromRGB(0, 191, 255)
        cheat.name_color      = Color3.fromRGB(0, 191, 255)
        cheat.hpbar           = Color3.fromRGB(0, 255, 0)
        cheat.hnum            = Color3.fromRGB(255, 255, 255)
        cheat.chams2          = Color3.fromRGB(0, 191, 255)
        cheat.highlight_color = Color3.fromRGB(255, 0, 0)
        cheat.armchams_color  = Color3.fromRGB(0, 191, 255)
        cheat.gun_chams       = Color3.fromRGB(0, 191, 255)
        cheat.fov_color       = Color3.fromRGB(0, 191, 255)
        cheat.box_style       = "full"
        cheat.max_distance    = 10000
        cheat.Omnisprint      = false
        cheat.wvis            = false
        cheat.name2           = false
        cheat.aimbind         = false
        cheat.autoshootbind   = false
        cheat.boostbind       = false
        cheat.spiderbind      = false
        cheat.fbind           = false
        cheat.zoom_bind       = false
    end
    defaultFlags()

    local skyboxes = {
        ["Blue Sky"]   = { "591058823",  "591059876",  "591058104",  "591057861",  "591057625",  "591059642"  },
        ["Vaporwave"]  = { "1417494030", "1417494146", "1417494253", "1417494402", "1417494499", "1417494643" },
        ["Redshift"]   = { "401664839",  "401664862",  "401664960",  "401664881",  "401664901",  "401664936"  },
        ["Blaze"]      = { "150939022",  "150939038",  "150939047",  "150939056",  "150939063",  "150939082"  },
        ["Dark Night"] = { "6285719338", "6285721078", "6285722964", "6285724682", "6285726335", "6285730635" },
        ["Bright Pink"]= { "271042516",  "271077243",  "271042556",  "271042310",  "271042467",  "271077958"  },
        ["Purple Sky"] = { "570557514",  "570557775",  "570557559",  "570557620",  "570557672",  "570557727"  },
        ["Galaxy"]     = { "15125283003","15125281008","15125277539","15125279325","15125274388","15125275800" },
        ["Pinky Sky"]  = { "11427769401","11427770685","11427769401","11427769401","11427769401","11427771954" },
    }
    local skyboxNames = {}
    for k in pairs(skyboxes) do table.insert(skyboxNames, k) end
    local sky_

    local Window = Library:Window({
        Logo = "132447680232071",
        FadeTime = 0.4,
    })

    local Watermark = Library:Watermark("dopmaine.wtf | discord.gg/hZAj73bwnv")
    local KeybindList = Library:KeybindList()

    local CombatPage  = Window:Page({ Name = "Combat",  SubPages = true })
    local VisualsPage = Window:Page({ Name = "Visuals",  SubPages = true })
    local MiscPage    = Window:Page({ Name = "Misc",     SubPages = true })
    local SettingsPage = Library:CreateSettingsPage(Window, Watermark, KeybindList)

    pcall(function()
        if not SettingsPage then return end
        for _, item in pairs(SettingsPage) do
            if type(item) == "table" and item.Press then
                local old_press = item.Press
                item.Press = function(self, ...)
                    return pcall(old_press, self, ...)
                end
            end
        end
    end)
    -- hitscan removed

    task.spawn(function()
        task.wait(1)

        local _nil_index = newcclosure(function() return nil end)
        local _ac_keys = {
            "FlaggedByModerators", "LastACViolationPos",
            "Banned", "IsBanned", "ACFlag", "Flagged"
        }
        pcall(function()
            for _, tbl in getgc(true) do
                if type(tbl) ~= "table" then continue end
                local is_ac = false
                for _, key in ipairs(_ac_keys) do
                    if rawget(tbl, key) ~= nil then is_ac = true break end
                end
                if not is_ac then continue end
                pcall(function()
                    local mt = getrawmetatable(tbl) or {}
                    rawset(mt, "__index", _nil_index)
                    rawset(mt, "__newindex", function() end)
                    setmetatable(tbl, mt)
                end)
            end
        end)
        pcall(function()
            local char = game:GetService("Players").LocalPlayer.Character
            if not char then return end
            local mt = getrawmetatable(char)
            if not mt then return end
            local old_index = rawget(mt, "__index")
            if not old_index then return end
            setreadonly(mt, false)
            rawset(mt, "__index", newcclosure(function(self, key)
                if key == "FlaggedByModerators" or key == "LastACViolationPos"
                or key == "Banned" or key == "IsBanned" or key == "ACFlag" then
                    return nil
                end
                return old_index(self, key)
            end))
            setreadonly(mt, true)
        end)
    end)
    local AimbotSubPage = CombatPage:SubPage({ Name = "Aimbot",  Columns = 2 })
    local WeaponSubPage = CombatPage:SubPage({ Name = "Weapon",  Columns = 2 })
    local ExtraSubPage  = CombatPage:SubPage({ Name = "Extra",   Columns = 2 })

    do
        local weaponmods = WeaponSubPage:Section({ Name = "Weapown Modifications", Side = 1 })

        weaponmods:Toggle({
            Name = "Recoil",
            Flag = "No Recoil Toggle",
            Default = false,
            Callback = function(state) cheat.recoil_toggle = state end,
        })
        weaponmods:Slider({
            Name = "Recoil",
            Flag = "Recoil Amount",
            Min = 0, Max = 100, Default = 100, Decimals = 1, Suffix = "",
            Callback = function(state) cheat.recoilamount = state end,
        })
        weaponmods:Toggle({
            Name = "Spread",
            Flag = "No Spread Toggle",
            Default = false,
            Callback = function(state) cheat.spread_toggle = state end,
        })
        weaponmods:Slider({
            Name = "Spread",
            Flag = "Spread Amount",
            Min = 0, Max = 100, Default = 100, Decimals = 1, Suffix = "",
            Callback = function(state) cheat.spread = state end,
        })
        weaponmods:Toggle({
            Name = "Rapid Fire",
            Flag = "Rapid Fire Toggle",
            Default = false,
            Callback = function(state) cheat.rapidfire = state end,
        })
        weaponmods:Slider({
            Name = "RPM",
            Flag = "Firerate Amount",
            Min = 1, Max = 100, Default = 1, Decimals = 1, Suffix = "x",
            Callback = function(state) cheat.rpm = state end,
        })
    end

    do
        local Main = AimbotSubPage:Section({ Name = "Main", Side = 1 })

        Main:Toggle({
            Name = "Enabled",
            Flag = "Aim-Assist",
            Default = false,
            Callback = function(state) cheat.aimbot_enabled = state end,
        }):Keybind({
            Flag = "Aim-Assist Bind",
            Default = "N",
            Mode = "Always",
            Callback = function(state) cheat.aimbind = state end,
        })

        Main:Dropdown({
            Name = "Hitpart",
            Flag = "hitpart1",
            Items = { "Head", "UpperTorso" },
            Default = "Head",
            Multi = false,
            Callback = function(state) cheat.hitpart = state end,
        })

        Main:Dropdown({
            Name = "Aimbot Method",
            Flag = "aam",
            Items = { "Aimbot", "Silent Aim" },
            Default = "Aimbot",
            Multi = false,
            Callback = function(state) cheat.aim_method = state end,
        })

        Main:Slider({
            Name = "Smoothing",
            Flag = "smoothigigingnig",
            Min = 1, Max = 10, Default = 1, Decimals = 1, Suffix = "",
            Callback = function(state) cheat.smooth = state end,
        })

        Main:Toggle({
            Name = "Visible check",
            Flag = "vischeck",
            Default = false,
            Callback = function(state) cheat.vischeck = state end,
        })
        Main:Toggle({
            Name = "Teamcheck",
            Flag = "tc",
            Default = false,
            Callback = function(state) cheat.ignore_team = state end,
        })
        Main:Toggle({
            Name = "Downed Check",
            Flag = "id",
            Default = false,
            Callback = function(state) cheat.ignore_downed = state end,
        })
        Main:Toggle({
            Name = "Highlight Target",
            Flag = "ht",
            Default = false,
            Callback = function(state) cheat.highlight_target = state end,
        }):Colorpicker({
            Flag = "Highlight Target Color",
            Default = Color3.fromRGB(255, 0, 0),
            Callback = function(state) cheat.highlight_color = state end,
        })
        Main:Toggle({
            Name = "Prediction",
            Flag = "pred",
            Default = false,
            Callback = function(state) cheat.predict = state end,
        })
        Main:Toggle({
            Name = "Hitbox Expander",
            Flag = "Hitbox Expander",
            Default = false,
            Callback = function(state) cheat.hbe = state end,
        })
        Main:Toggle({
            Name = "Only Expand Target",
            Flag = "Hitbox Expander Target",
            Default = false,
            Callback = function(state) cheat.only_expand_target = state end,
        })
        Main:Slider({
            Name = "Hitbox Size",
            Flag = "hitboxsize",
            Min = 1, Max = 100, Default = 1, Decimals = 1, Suffix = "",
            Callback = function(state) cheat.hbs = state end,
        })
        Main:Toggle({
            Name = "Autoshoot",
            Flag = "Autoshoot",
            Default = false,
            Callback = function(state) cheat.autoshoot = state end,
        }):Keybind({
            Flag = "aushoot",
            Default = "E",
            Mode = "Hold",
            Callback = function(state) cheat.autoshootbind = state end,
        })
        Main:Toggle({
            Name = "Enable FOV",
            Flag = "efov",
            Default = false,
            Callback = function(state) cheat.show_fov = state; if EspInterface then EspInterface.sharedSettings.useFovRadius = state end end,
        }):Colorpicker({
            Flag = "Fov Color 1",
            Default = Color3.fromRGB(0, 191, 255),
            Callback = function(state) cheat.fov_color = state end,
        })
        Main:Slider({
            Name = "FOV Radius",
            Flag = "FOV Radius",
            Min = 1, Max = 750, Default = 100, Decimals = 1, Suffix = "",
            Callback = function(state) cheat.fovradius = state end,
        })
    end

    do
        local extras = ExtraSubPage:Section({ Name = "Extra", Side = 1 })

        local underground = { enabled = false, bind = nil, dist = -8 }
        local aimresolver = false
        local aimresolverpos
        local aimresolverbind = nil
        local gameProcessed = false

        local Players_    = game:GetService("Players")
        local RunService_ = game:GetService("RunService")
        local UIS_        = game:GetService("UserInputService")
        local lplr_       = Players_.LocalPlayer

        UIS_.InputBegan:Connect(function(input, processed) gameProcessed = processed end)

        local function handleResolver()
            if not aimresolver or not aimresolverbind then return end
            if lplr_.Character and lplr_.Character.HumanoidRootPart then
                if gameProcessed then return end
                local char = lplr_.Character
                local hrp  = char.HumanoidRootPart
                local mult = CFrame.new(0, underground.dist, 0)
                hrp.AssemblyLinearVelocity = -mult.Position
                char:PivotTo(aimresolverpos * mult)
            end
        end
        RunService_.Heartbeat:Connect(handleResolver)

        nc = nc or {}
        local dysenc = {}
        RunService_.Heartbeat:Connect(function()
            if nc.enabled and nc.bind and lplr_.Character and lplr_.Character.HumanoidRootPart then
                if gameProcessed then return end
                dysenc[1] = lplr_.Character.HumanoidRootPart.CFrame
                dysenc[2] = lplr_.Character.HumanoidRootPart.AssemblyLinearVelocity
                local SpoofThis = (lplr_.Character.HumanoidRootPart.CFrame + Vector3.new(0, -2.2, 0)) * CFrame.Angles(math.rad(90), 0, 0)
                lplr_.Character.HumanoidRootPart.CFrame = SpoofThis
                RunService_.RenderStepped:Wait()
                if lplr_.Character and lplr_.Character.HumanoidRootPart then
                    lplr_.Character.HumanoidRootPart.CFrame = dysenc[1]
                    lplr_.Character.HumanoidRootPart.AssemblyLinearVelocity = dysenc[2]
                end
            end
        end)

        -- instant loot removed from here (moved to Misc > Exploits)
    end

    do
        local PlayerSubPage = VisualsPage:SubPage({ Name = "Player", Columns = 1 })
        local SelfSubPage = VisualsPage:SubPage({ Name = "Self", Columns = 2 })
        local WorldSubPage = VisualsPage:SubPage({ Name = "World", Columns = 2 })
        local WorldSection   = WorldSubPage:Section({ Name = "World",   Side = 1 })
        local PlayersSection = PlayerSubPage:Section({ Name = "Players", Side = 1 })
        local SelfSection    = SelfSubPage:Section({ Name = "Self",    Side = 1 })
        local ItemsSection   = WorldSubPage:Section({ Name = "Items",   Side = 2 })

        local Lighting_ = game:GetService("Lighting")
        local _nofog_original = { FogEnd = Lighting_.FogEnd, FogStart = Lighting_.FogStart }
        WorldSection:Toggle({
            Name = "No Fog",
            Flag = "Nofog",
            Default = false,
            Callback = function(v)
                cheat.nofog = v
                if v then
                    _nofog_original.FogEnd = Lighting_.FogEnd
                    _nofog_original.FogStart = Lighting_.FogStart
                    Lighting_.FogEnd = 100000
                    Lighting_.FogStart = 100000
                    for _, a in pairs(Lighting_:GetDescendants()) do
                        if a:IsA("Atmosphere") then
                            pcall(function()
                                a.Density = 0
                                a.Haze = 0
                                a.Glare = 0
                            end)
                        end
                    end
                    cheat._nofog_conn = Lighting_.DescendantAdded:Connect(function(a)
                        if a:IsA("Atmosphere") then
                            pcall(function()
                                a.Density = 0
                                a.Haze = 0
                                a.Glare = 0
                            end)
                        end
                    end)
                else
                    Lighting_.FogEnd = _nofog_original.FogEnd
                    Lighting_.FogStart = _nofog_original.FogStart
                    if cheat._nofog_conn then cheat._nofog_conn:Disconnect(); cheat._nofog_conn = nil end
                end
            end,
        })
        local _locked_time = nil
        local _time_conn = nil
        WorldSection:Slider({
            Name = "Time",
            Flag = "time",
            Min = 1, Max = 24, Default = Lighting_.ClockTime, Decimals = 0.1, Suffix = "",
            Callback = function(value)
                _locked_time = value
                Lighting_.ClockTime = value
                if _time_conn then _time_conn:Disconnect() end
                _time_conn = game:GetService("RunService").Heartbeat:Connect(function()
                    if _locked_time then Lighting_.ClockTime = _locked_time end
                end)
            end,
        })

        local AmbientEnabled = false
        local AmbientColor   = Color3.fromRGB(255, 255, 255)
        local _ambient_original = Lighting_.Ambient
        WorldSection:Toggle({
            Name = "Ambient",
            Flag = "ambienttoggle",
            Default = false,
            Callback = function(state)
                AmbientEnabled = state
                if not state then Lighting_.Ambient = _ambient_original end
            end,
        }):Colorpicker({
            Flag = "Ambient Color",
            Default = Color3.fromRGB(0, 191, 255),
            Callback = function(color) AmbientColor = color end,
        })

        local _lighting_frame = 0
        game:GetService("RunService").Heartbeat:Connect(function()
            _lighting_frame = _lighting_frame + 1
            if _lighting_frame % 6 ~= 0 then return end
            if AmbientEnabled then Lighting_.Ambient = AmbientColor end
            if cheat.nofog then
                Lighting_.FogEnd = 100000
                Lighting_.FogStart = 100000
            end
        end)

        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Parent = Lighting_
        WorldSection:Slider({
            Name = "Saturation",
            Flag = "Saturation",
            Min = -10, Max = 10, Default = 0, Decimals = 0.1, Suffix = "",
            Callback = function(value) colorCorrection.Saturation = value end,
        })
        WorldSection:Slider({
            Name = "Contrast",
            Flag = "Contrast",
            Min = -10, Max = 10, Default = 0, Decimals = 0.1, Suffix = "",
            Callback = function(value) colorCorrection.Contrast = value end,
        })
        WorldSection:Toggle({
            Name = "No Foliage",
            Flag = "foliage",
            Default = false,
            Callback = function(bool)
                if bool then
                    pcall(function()
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("SurfaceAppearance") and v.Parent and v.Parent.Parent then
                                local name = v.Parent.Parent.Name:lower()
                                if name:find("foliage") or name:find("plant") or name:find("grass") or name:find("bush") or name:find("tree") then
                                    v.Parent:Destroy()
                                end
                            end
                        end
                    end)
                    pcall(function()
                        for _, v in pairs(workspace.SpawnerZones.Foliage:GetDescendants()) do
                            if v:IsA("SurfaceAppearance") then v.Parent:Destroy() end
                        end
                    end)
                end
            end,
        })
        WorldSection:Toggle({
            Name = "No Grass",
            Flag = "Grass",
            Default = false,
            Callback = function(bool) sethiddenproperty(workspace.Terrain, "Decoration", not bool) end,
        })
        local skyEnabled = false
        WorldSection:Toggle({
            Name = "Skybox",
            Flag = "SkyboxToggle",
            Default = false,
            Callback = function(state)
                skyEnabled = state
                if state then
                    if not sky_ then
                        sky_ = Instance.new("Sky", game:GetService("Lighting"))
                    end
                else
                    if sky_ then
                        sky_:Destroy()
                        sky_ = nil
                    end
                end
            end,
        })
        WorldSection:Dropdown({
            Name = "Skybox Style",
            Flag = "Skybox",
            Items = skyboxNames,
            Default = skyboxNames[1],
            Multi = false,
            Callback = function(state)
                if not skyEnabled then return end
                local data = skyboxes[state]
                if not data then return end
                if not sky_ then sky_ = Instance.new("Sky", game:GetService("Lighting")) end
                sky_.SkyboxBk = "rbxassetid://" .. data[1]
                sky_.SkyboxDn = "rbxassetid://" .. data[2]
                sky_.SkyboxFt = "rbxassetid://" .. data[3]
                sky_.SkyboxLf = "rbxassetid://" .. data[4]
                sky_.SkyboxRt = "rbxassetid://" .. data[5]
                sky_.SkyboxUp = "rbxassetid://" .. data[6]
            end,
        })

        local HitsoundsSection = SelfSubPage:Section({ Name = "Hitsounds", Side = 2 })
        HitsoundsSection:Toggle({
            Name = "Hitsounds",
            Flag = "HitsoundsEnabled",
            Default = false,
            Callback = function(state)
                _hs_enabled = state
                _hs_apply()
            end,
        })
        HitsoundsSection:Dropdown({
            Name = "Body Sound",
            Flag = "HitsoundBody",
            Items = _hs_names,
            Default = _hs_names[1],
            Multi = false,
            Callback = function(state)
                _hs_selected_body = state
                _hs_apply()
            end,
        })
        HitsoundsSection:Dropdown({
            Name = "Head Sound",
            Flag = "HitsoundHead",
            Items = _hs_names,
            Default = _hs_names[1],
            Multi = false,
            Callback = function(state)
                _hs_selected_head = state
                _hs_apply()
            end,
        })
        HitsoundsSection:Slider({
            Name = "Volume",
            Flag = "HitsoundVolume",
            Min = 0, Max = 3, Default = 1, Decimals = 0.1, Suffix = "x",
            Callback = function(state)
                _hs_volume = state
                _hs_apply()
            end,
        })
        local _test_sound_conn = nil
        HitsoundsSection:Toggle({
            Name = "Test Sound",
            Flag = "HitsoundTest",
            Default = false,
            Callback = function(state)
                if state then
                    _test_sound_conn = true
                    task.spawn(function()
                        while _test_sound_conn do
                            pcall(function()
                                local id = _hs_ids[_hs_selected_body]
                                if id then
                                    local s = Instance.new("Sound")
                                    s.SoundId = id
                                    s.Volume  = _hs_volume
                                    s.Parent  = game:GetService("SoundService")
                                    s:Play()
                                    game:GetService("Debris"):AddItem(s, 3)
                                end
                            end)
                            task.wait(0.35)
                        end
                    end)
                else
                    _test_sound_conn = nil
                end
            end,
        })
        SelfSection:Toggle({
            Name = "Arm Chams",
            Flag = "achams",
            Default = false,
            Callback = function(state) cheat.arm = state end,
        }):Colorpicker({
            Flag = "Arm Color",
            Default = Color3.fromRGB(0, 191, 255),
            Callback = function(color) cheat.armchams_color = color end,
        })
        SelfSection:Toggle({
            Name = "Gun Chams",
            Flag = "Gun Chams",
            Default = false,
            Callback = function(state) cheat.gun = state end,
        }):Colorpicker({
            Flag = "Gun Color",
            Default = Color3.fromRGB(0, 191, 255),
            Callback = function(color) cheat.gun_chams = color end,
        })


        local TweenService_ = game:GetService("TweenService")
        local Camera_       = workspace.CurrentCamera
        local oldZoom       = Camera_.FieldOfView
        local zoomsettings  = { Enabled = false, Bind = false, ZoomTime = 0.2, ZoomedAmount = 7 }
        local isZoomed      = false
        task.spawn(function()
            while true do task.wait(0.05)
                if zoomsettings.Enabled then
                    if zoomsettings.Bind and not isZoomed then
                        isZoomed = true; oldZoom = Camera_.FieldOfView
                        TweenService_:Create(Camera_, TweenInfo.new(zoomsettings.ZoomTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { FieldOfView = zoomsettings.ZoomedAmount }):Play()
                    elseif not zoomsettings.Bind and isZoomed then
                        isZoomed = false
                        if oldZoom then
                            TweenService_:Create(Camera_, TweenInfo.new(zoomsettings.ZoomTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { FieldOfView = oldZoom }):Play()
                        end
                    end
                elseif isZoomed then
                    isZoomed = false
                    if oldZoom then Camera_.FieldOfView = oldZoom end
                end
            end
        end)
        SelfSection:Toggle({
            Name = "Zoom",
            Flag = "Zoom",
            Default = false,
            Callback = function(state) zoomsettings.Enabled = state; if not state then oldZoom = Camera_.FieldOfView; Camera_.FieldOfView = oldZoom end end,
        }):Keybind({
            Flag = "Zoom Bind",
            Default = "V",
            Mode = "Hold",
            Callback = function(state) zoomsettings.Bind = state end,
        })
        SelfSection:Slider({ Name = "Zoom Amount", Flag = "Zoom Amount", Min = 1, Max = 100, Default = 10, Decimals = 1, Suffix = "", Callback = function(v) zoomsettings.ZoomedAmount = v end })
        SelfSection:Slider({ Name = "Zoom Time",   Flag = "Zoom Time",   Min = 0, Max = 1,   Default = 0.5, Decimals = 0.01, Suffix = "s", Callback = function(v) zoomsettings.ZoomTime = v end })
        SelfSection:Toggle({
            Name = "Freecam",
            Flag = "Freecam",
            Default = false,
            Callback = function(state) cheat.fcam = state end,
        }):Keybind({
            Flag = "Freecam Bind",
            Default = "Z",
            Mode = "Toggle",
            Callback = function(state) cheat.fbind = state end,
        })
        SelfSection:Slider({ Name = "Cam Speed",   Flag = "fcamsped",   Min = 10, Max = 500,   Default = 20, Decimals = 1, Suffix = "", Callback = function(v) cheat.fcamsped = v end })

        PlayersSection:Toggle({ Name = "Master Switch",       Flag = "EspEnabled",  Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.enabled = v; EspInterface.teamSettings.friendly.enabled = v end end })
        PlayersSection:Toggle({ Name = "Box",              Flag = "EspBox",      Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.box = v; EspInterface.teamSettings.friendly.box = v end end }):Colorpicker({ Flag = "Box Color", Default = Color3.fromRGB(0, 191, 255), Callback = function(c) if EspInterface then EspInterface.teamSettings.enemy.boxColor[1] = c; EspInterface.teamSettings.friendly.boxColor[1] = c end end })
        PlayersSection:Toggle({ Name = "Box Fill",         Flag = "EspBoxFill",  Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.boxFill = v; EspInterface.teamSettings.friendly.boxFill = v end end }):Colorpicker({ Flag = "Box Fill Color", Default = Color3.fromRGB(0, 191, 255), Callback = function(c) if EspInterface then EspInterface.teamSettings.enemy.boxFillColor[1] = c; EspInterface.teamSettings.friendly.boxFillColor[1] = c end end })
        PlayersSection:Toggle({ Name = "Name",             Flag = "EspName",     Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.name = v; EspInterface.teamSettings.friendly.name = v end end }):Colorpicker({ Flag = "Name Color", Default = Color3.fromRGB(0, 191, 255), Callback = function(c) if EspInterface then EspInterface.teamSettings.enemy.nameColor[1] = c; EspInterface.teamSettings.friendly.nameColor[1] = c end end })
        PlayersSection:Toggle({ Name = "Healthbar",        Flag = "EspHbar",     Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.healthBar = v; EspInterface.teamSettings.friendly.healthBar = v end end })
        PlayersSection:Toggle({ Name = "Health Text",      Flag = "Esphnum",     Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.healthText = v; EspInterface.teamSettings.friendly.healthText = v end end })
        PlayersSection:Toggle({ Name = "Distance",         Flag = "EspDist",     Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.distance = v; EspInterface.teamSettings.friendly.distance = v end end }):Colorpicker({ Flag = "Distance Color", Default = Color3.fromRGB(0, 191, 255), Callback = function(c) if EspInterface then EspInterface.teamSettings.enemy.distanceColor[1] = c; EspInterface.teamSettings.friendly.distanceColor[1] = c end end })
        PlayersSection:Toggle({ Name = "Tracer",           Flag = "EspTracer",   Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.tracer = v; EspInterface.teamSettings.friendly.tracer = v end end }):Colorpicker({ Flag = "Tracer Color", Default = Color3.fromRGB(0, 191, 255), Callback = function(c) if EspInterface then EspInterface.teamSettings.enemy.tracerColor[1] = c; EspInterface.teamSettings.friendly.tracerColor[1] = c end end })
        PlayersSection:Toggle({ Name = "Chams",            Flag = "EspChams",    Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.chams = v; EspInterface.teamSettings.friendly.chams = v end end }):Colorpicker({ Flag = "Chams Color", Default = Color3.fromRGB(0, 191, 255), Callback = function(c) if EspInterface then EspInterface.teamSettings.enemy.chamsOutlineColor[1] = c; EspInterface.teamSettings.friendly.chamsOutlineColor[1] = c end end })
        PlayersSection:Toggle({ Name = "OOF Arrows", Flag = "EspArrow",    Default = false, Callback = function(v) if EspInterface then EspInterface.teamSettings.enemy.offScreenArrow = v; EspInterface.teamSettings.friendly.offScreenArrow = v end end }):Colorpicker({ Flag = "Arrow Color", Default = Color3.fromRGB(0, 191, 255), Callback = function(c) if EspInterface then EspInterface.teamSettings.enemy.offScreenArrowColor[1] = c; EspInterface.teamSettings.friendly.offScreenArrowColor[1] = c end end })

        ItemsSection:Toggle({ Name = "Enable ESP",        Flag = "EspwEnabled",   Default = false, Callback = function(s) cheat.wvis = s; cheat.name2 = s end })
        ItemsSection:Toggle({ Name = "Hemp ESP",          Flag = "hemp",           Default = false, Callback = function(s) cheat.hemp = s end })
        ItemsSection:Toggle({ Name = "Stone ESP",         Flag = "stone",          Default = false, Callback = function(s) cheat.stone = s end })
        ItemsSection:Toggle({ Name = "Brimstone ESP",        Flag = "sulf",           Default = false, Callback = function(s) cheat.sulf = s end })
        ItemsSection:Toggle({ Name = "Iron ESP",          Flag = "Iron",           Default = false, Callback = function(s) cheat.iron = s end })
        ItemsSection:Toggle({ Name = "Corpse ESP",        Flag = "corpse",         Default = false, Callback = function(s) cheat.body = s end })
        ItemsSection:Toggle({ Name = "Dropped Items ESP", Flag = "Dropped Items",  Default = false, Callback = function(s) cheat.dropped = s end })
    end

    do
        local CharSubPage = MiscPage:SubPage({ Name = "Movement", Columns = 2 })
        local OtherSubPage = MiscPage:SubPage({ Name = "Misc", Columns = 2 })
        local CharSection = CharSubPage:Section({ Name = "Character", Side = 1 })
        local ExploitSection = OtherSubPage:Section({ Name = "Exploits",  Side = 1 })

        local RunService__ = game:GetService("RunService")

        local _arb = { last_pos = nil, target_pos = nil, restoring = false }
        local _speed_connection = RunService__.Heartbeat:Connect(function(dt)
            if not cheat.boost or not cheat.boostbind then
                _arb.last_pos = nil; _arb.target_pos = nil; _arb.restoring = false
                return
            end
            if not my_player or not my_player.Character then return end
            local hrp = my_player.Character:FindFirstChild("HumanoidRootPart")
            local hum = my_player.Character:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            local cur = hrp.Position

            if _arb.last_pos then
                local delta = (cur - _arb.last_pos).Magnitude
                if delta > 8 and not _arb.restoring then
                    _arb.target_pos = _arb.last_pos
                    _arb.restoring = true
                end
            end

            if _arb.restoring and _arb.target_pos then
                local dist = (cur - _arb.target_pos).Magnitude
                if dist < 0.5 then
                    _arb.restoring = false; _arb.target_pos = nil
                else
                    local step = math.min(dist, 20 * dt)
                    hrp.CFrame = hrp.CFrame + (_arb.target_pos - cur).Unit * step
                end
            end

            _arb.last_pos = cur

            local moveDir = hum.MoveDirection
            if moveDir.Magnitude < 0.1 then return end
            local multiplier = math.clamp((cheat.speed or 1) - 1, 0, 19)
            if multiplier <= 0 then return end
            local nudge = math.min(multiplier * 0.40 * (dt / (1/60)), 0.45)
            hrp.CFrame = hrp.CFrame + Vector3.new(moveDir.X, 0, moveDir.Z).Unit * nudge
        end)

        CharSection:Toggle({
            Name = "Speed Hack",
            Flag = "Speed",
            Default = false,
            Callback = function(state) cheat.boost = state end,
        }):Keybind({
            Flag = "Speed Bind",
            Default = "X",
            Mode = "Hold",
            Callback = function(state) cheat.boostbind = state end,
        })
        CharSection:Slider({ Name = "Speed", Flag = "Speedbostspeed", Min = 0, Max = 3, Default = 1, Decimals = 0.1, Suffix = "x", Callback = function(v) cheat.speed = v end })

        CharSection:Toggle({
            Name = "Spider",
            Flag = "Spider",
            Default = false,
            Callback = function(state) cheat.spider = state end,
        }):Keybind({
            Flag = "Spider Bind",
            Default = "T",
            Mode = "Toggle",
            Callback = function(state) cheat.spiderbind = state end,
        })
        CharSection:Toggle({ Name = "Always Sprint", Flag = "Omnisprint", Default = false, Callback = function(s) cheat.Omnisprint = s end })
        CharSection:Toggle({ Name = "No Fall Damage", Flag = "falldmg", Default = false, Callback = function(s) cheat.nofall = s end })
        CharSection:Toggle({ Name = "Anti-Aim",    Flag = "Spinbot",    Default = false, Callback = function(s) cheat.spin = s end })
        CharSection:Slider({ Name = "AA-Angle", Flag = "Speedbostspeed2", Min = 0, Max = 360, Default = 1, Decimals = 0.1, Suffix = "\u{00B0}", Callback = function(v) cheat.spinspeed = v end })
        CharSection:Toggle({
            Name = "Noclip",
            Flag = "noclip",
            Default = false,
            Callback = function(state) nc.enabled = state end,
        }):Keybind({
            Flag = "noclipbind",
            Default = "Y",
            Mode = "Toggle",
            Callback = function(state) nc.bind = state end,
        })

        ExploitSection:Toggle({ Name = "Perfect Farm", Flag = "pfarm2", Default = false, Callback = function(s) cheat.pfarm = s end })
        ExploitSection:Toggle({ Name = "Instant Loot", Flag = "instantloot", Default = false, Callback = function(s) cheat.instant_loot = s end })

        local FpsSection = OtherSubPage:Section({ Name = "FPS", Side = 2 })
        FpsSection:Toggle({
            Name = "FPS Boost (IREVERSIBLE)",
            Flag = "potato_mode",
            Default = false,
            Callback = function(state)
                if state then
                    local _Lighting = game:GetService("Lighting")
                    local _Terrain = workspace.Terrain
                    pcall(function() sethiddenproperty(_Terrain, "Decoration", false) end)
                    _Lighting.GlobalShadows = false
                    _Lighting.FogEnd = 9999
                    _Lighting.FogStart = 9999
                    _Lighting.Brightness = 0
                    _Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
                    for _, v in ipairs(_Lighting:GetChildren()) do
                        pcall(function()
                            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
                            or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
                                v.Enabled = false
                            end
                        end)
                    end
                    for _, v in ipairs(workspace:GetDescendants()) do
                        pcall(function()
                            if v:IsA("BasePart") then
                                v.Material = Enum.Material.Plastic
                                v.Reflectance = 0
                                v.CastShadow = false
                            elseif v:IsA("Decal") or v:IsA("Texture") then
                                v.Transparency = 1
                            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke")
                            or v:IsA("Fire") or v:IsA("Sparkles") then
                                v.Enabled = false
                            elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                                v.Enabled = false
                            elseif v:IsA("SurfaceAppearance") then
                                v:Destroy()
                            end
                        end)
                    end
                    pcall(function()
                        setfflag("DFIntDebugFRMQualityLevelOverride",   "1")
                        setfflag("DFFlagTextureQualityOverrideEnabled", "true")
                        setfflag("DFIntTextureQualityOverride",         "0")
                        setfflag("FFlagFixGraphicsQuality",             "true")
                        setfflag("FFlagCommitToGraphicsQualityFix",     "true")
                        setfflag("FIntRenderShadowIntensity",           "0")
                        setfflag("DFIntRenderCloudDensity",             "0")
                        setfflag("FIntDebugForceMSAASamples",           "0")
                    end)
                end
            end,
        })
    end

    -- Keybind monitor — checks actual key state every frame for critical toggles
    local keybindMap = {
        ["N"] = { flag = "aimbind", check = function() return cheat.aimbind end },
        ["E"] = { flag = "autoshootbind", check = function() return cheat.autoshootbind end },
        ["X"] = { flag = "boostbind", check = function() return cheat.boostbind end },
        ["T"] = { flag = "spiderbind", check = function() return cheat.spiderbind end },
        ["Z"] = { flag = "fbind", check = function() return cheat.fbind end },
        ["V"] = { flag = "zoom_bind", check = function() return zoomsettings.Bind end },
    }
    local lastKeyState = {}
    run_service.RenderStepped:Connect(function()
        for key, data in keybindMap do
            local kc = Enum.KeyCode[key]
            if kc then
                local down = user_input_service:IsKeyDown(kc)
                if down ~= lastKeyState[key] then
                    lastKeyState[key] = down
                    if data.flag == "fbind" then
                        if down then cheat.fbind = not cheat.fbind end
                    elseif data.flag == "zoom_bind" then
                        zoomsettings.Bind = down
                    else
                        -- other toggles set via the library callback, just monitor
                    end
                end
            end
        end
    end)

    if _loadConn then _loadConn:Disconnect() end
    if _loadGui then _loadGui:Destroy() end

    Library:Notification("dopmaine.wtf", "loaded in " .. tostring(math.floor((os.clock() - loadTick) * 1000)) .. "ms", 5)
    players = game:GetService("Players")
    work_space = game:GetService("Workspace")
    replicated_storage = game:GetService("ReplicatedStorage")
    http_service = game:GetService("HttpService")
    gui_service = game:GetService("GuiService")
    lighting = game:GetService("Lighting")
    run_service = game:GetService("RunService")
    stats = game:GetService("Stats")
    core_gui = game:GetService("CoreGui")
    game_debris = game:GetService("Debris")
    tween_service = game:GetService("TweenService")
    sound_service = game:GetService("SoundService")
    user_input_service = game:GetService("UserInputService")
    context_service = game:GetService("ContextActionService")
    using_funny = false

    my_camera = work_space.CurrentCamera
    my_player = players.LocalPlayer
    my_mouse = my_player:GetMouse()

    players_folder = workspace:FindFirstChild("Players")

    local function safeRequire(path)
        local ok, result = pcall(function() return require(path) end)
        return ok and result or nil
    end

    module_loader = safeRequire(replicated_storage.Modules.Shared.ModuleLoader)
    network = safeRequire(replicated_storage.Modules.Shared.Network)
    projectile_store = replicated_storage.Modules.Client:FindFirstChild("Physics") and replicated_storage.Modules.Client.Physics:FindFirstChild("Projectile")
    projectile_module = replicated_storage.Modules.Client:FindFirstChild("Physics") and safeRequire(replicated_storage.Modules.Client.Physics.Projectile)
    sound_manager = safeRequire(replicated_storage.Modules.Shared.Utilities.Sound)
    camera_shaker = safeRequire(replicated_storage.Modules.Client.Character.CameraShaker)
    effects_replicator = safeRequire(replicated_storage.Modules.Client.Effects.EffectsReplicator)
    hitmarker_manager = safeRequire(replicated_storage.Modules.Client.UI.HitmarkerManager)
    crosshair_manager = safeRequire(replicated_storage.Modules.Client.UI.CrosshairManager)
    local _phms_ok, _phms = pcall(function()
        local m = replicated_storage:FindFirstChild("Modules")
            and replicated_storage.Modules:FindFirstChild("Client")
            and replicated_storage.Modules.Client:FindFirstChild("Effects")
            and replicated_storage.Modules.Client.Effects:FindFirstChild("PlayHitmarkerSound")
        return m and require(m) or function() end
    end)
    play_hitmarker_sound = (_phms_ok and type(_phms) == "function") and _phms or function() end

    pcall(function()
        _hs_targets = {
            Body = replicated_storage.Assets.Sounds.Hits.Hitmarker.Body,
            Head = replicated_storage.Assets.Sounds.Hits.Hitmarker.Head,
        }
        _hs_apply()
    end)
    ai_manager = safeRequire(replicated_storage.Modules.Client.Character.AIManagerClient)
    glass_manager = safeRequire(replicated_storage.Modules.Client.Effects.GlassManager)
    settings = safeRequire(replicated_storage.Modules.Client.Config.Settings)
    bullet_cache = replicated_storage.Modules.Client:FindFirstChild("Physics") and safeRequire(replicated_storage.Modules.Client.Physics.BulletCache)
    whizzes = replicated_storage.Assets.Sounds.Projectiles.Whizzes:GetChildren()
    recoil_module = safeRequire(replicated_storage.Modules.Client.Character.Camera.Recoil)
    camera_module = safeRequire(replicated_storage.Modules.Client.Character.Camera)
    recoil_upvalues = recoil_module and debug.getupvalues(recoil_module)[1]
    gun_module_data = safeRequire(replicated_storage.Modules.Client.Config.Items)
    inventory_module = safeRequire(replicated_storage.Modules.Client.Inventory.Inventory)
    character_module = safeRequire(replicated_storage.Modules.Client.Character.Character)
    server_name = replicated_storage:FindFirstChild("Settings") and replicated_storage.Settings:FindFirstChild("ServerName")
    arrow_module = projectile_module and safeRequire(replicated_storage.Modules.Client.Physics.Projectile.Arrow)
    bullet_module = projectile_module and safeRequire(replicated_storage.Modules.Client.Physics.Projectile.Bullet)
    throwable_module = projectile_module and safeRequire(replicated_storage.Modules.Client.Physics.Projectile.ThrowableMelee)
    viewmodel_module = replicated_storage.Modules.Client:FindFirstChild("Tools") and replicated_storage.Modules.Client.Tools:FindFirstChild("Tool") and game:GetService("ReplicatedStorage").Modules.Client.Tools.Tool:FindFirstChild("Viewmodel")
    viewmodel_module_data = viewmodel_module and safeRequire(game:GetService("ReplicatedStorage").Modules.Client.Tools.Tool.Viewmodel)

    network_fire = nil
    task_spawn_hook = nil

    pcall(function()
        local SoundService = game:GetService("SoundService")
        SoundService.AmbientReverb = Enum.ReverbType.NoReverb
        SoundService.DistanceFactor = 3.33
        SoundService.DopplerScale = 0
        SoundService.RolloffScale = 1
    end)

    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                    v.Enabled = false
                elseif v:IsA("SelectionBox") or v:IsA("SelectionSphere") then
                    v:Destroy()
                end
            end)
        end
        workspace.DescendantAdded:Connect(function(v)
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                    v.Enabled = false
                end
            end)
        end)
    end)

    pcall(function()
        setfflag("DFIntCSGLevelOfDetailSwitchingDistance",     "250")
        setfflag("DFIntCSGLevelOfDetailSwitchingDistanceLow",  "100")
        setfflag("DFIntCSGLevelOfDetailSwitchingDistanceMed",  "150")
        setfflag("DFIntCSGLevelOfDetailSwitchingDistanceHigh", "200")
        setfflag("FIntRenderLocalLightUpdatesMax",             "1")
        setfflag("FIntRenderLocalLightUpdatesMin",             "1")
        setfflag("DFIntRenderCloudDensity",                    "0")
        setfflag("FIntRenderShadowIntensity",                  "0")
        setfflag("DFIntCullFactorPixelThresholdShadowMapHighQuality", "2048")
        setfflag("DFIntCullFactorPixelThresholdShadowMapLowQuality",  "2048")
        setfflag("DFIntTaskSchedulerTargetFps",                "9999")
        setfflag("FFlagDebugDisableTelemetryEventIngest",      "true")
        setfflag("FFlagDebugDisableTelemetryV2Counter",        "true")
        setfflag("FFlagDebugDisableTelemetryEphemeralCounter", "true")
        setfflag("FFlagDebugDisableTelemetryPoint",            "true")
        setfflag("FFlagDebugDisableTelemetryV2",               "true")
        setfflag("DFIntMaxFrameBufferSize",                    "4")
        setfflag("FIntDebugForceMSAASamples",                  "0")
        setfflag("DFIntDebugFRMQualityLevelOverride",          "1")
        setfflag("DFFlagTextureQualityOverrideEnabled",        "true")
        setfflag("DFIntTextureQualityOverride",                "0")
        setfflag("FFlagFixGraphicsQuality",                    "true")
        setfflag("FFlagCommitToGraphicsQualityFix",            "true")
        setfflag("DFIntConnectionMTUSize",                     "900")
        setfflag("FIntTerrainArraySliceSize",                  "0")
        setfflag("FIntFontSizePadding",                        "0")
        setfflag("FIntDebugTextCacheSize",                     "3")
    end)

    pcall(function()
        workspace.Terrain.WaterWaveSize = 0
        workspace.Terrain.WaterWaveSpeed = 0
        workspace.Terrain.WaterReflectance = 0
        workspace.Terrain.WaterTransparency = 0
    end)
    pcall(function() sethiddenproperty(workspace.Terrain, "Decoration", false) end)

    pcall(function()
        workspace.StreamingEnabled = false
    end)

    do
        local utility = {}

        utility.get_screen_pos = function(world_position)
            local viewport_size = my_camera.ViewportSize
            local local_position = my_camera.CFrame:pointToObjectSpace(world_position)

            local aspect_ratio = viewport_size.x / viewport_size.y
            local half_height = -local_position.z * math.tan(math.rad(my_camera.FieldOfView / 2))
            local half_width = aspect_ratio * half_height

            local far_plane_corner = Vector3.new(-half_width, half_height, local_position.z)
            local relative_position = local_position - far_plane_corner

            local screen_x = relative_position.x / (half_width * 2)
            local screen_y = -relative_position.y / (half_height * 2)

            local is_on_screen = -local_position.z > 0
                and screen_x >= 0
                and screen_x <= 1
                and screen_y >= 0
                and screen_y <= 1

            return Vector2.new(screen_x * viewport_size.x, screen_y * viewport_size.y), is_on_screen
        end

        utility.newdrawing = function(item, properties)
            local newdrawing = Drawing.new(item)

            for _, property in properties do
                newdrawing[_] = property
            end

            return newdrawing
        end

        utility.deepcopy = function(orig)
            local orig_type = type(orig)
            local copy
            if orig_type == "table" then
                copy = {}
                for orig_key, orig_value in next, orig, nil do
                    copy[utility.deepcopy(orig_key)] = utility.deepcopy(orig_value)
                end
                setmetatable(copy, utility.deepcopy(getmetatable(orig)))
            else
                copy = orig
            end
            return copy
        end

        utility.predict = function(origin, bulletSpeed, drop, targetPosition, targetVelocity)
            local distance = (origin - targetPosition).Magnitude
            local timeToHit = distance / bulletSpeed

            local predictedPosition = targetPosition

            local lead = targetVelocity * ((origin - targetPosition).magnitude / bulletSpeed)
            predictedPosition = predictedPosition + lead

            local success, verticalDrop = pcall(function()
                local adjustedGravity = 196.2 * -(drop * 0.001)
                local vertical = 0 * timeToHit - 0.5 * adjustedGravity * timeToHit * timeToHit
                if tostring(vertical):find("nan") then
                    return 0
                end
                return vertical
            end)

            if success then
                predictedPosition = predictedPosition + Vector3.new(0, verticalDrop, 0)
            end

            return predictedPosition
        end

        Executor    = identifyexecutor()

            LPH_NO_VIRTUALIZE(function()
                local ignored_people_conenctions = getconnections(workspace.IgnoredPeople.ChildAdded)

                local fake_env = {
                    task = {
                        wait = function(t)
                            return task.wait(9e9)
                        end,
                    },
                }

                for connection_index, connection in ignored_people_conenctions do
                    connection:Disconnect()
                    if not connection.Function then continue end
                    pcall(setfenv,
                        connection.Function,
                        setmetatable(fake_env, {
                            __index = getfenv(connection.Function),
                        })
                    )
                    pcall(function()
                        for _, func in debug.getproto(connection.Function, 1, true) do
                            pcall(setfenv,
                                func,
                                setmetatable(fake_env, {
                                    __index = getfenv(func),
                                })
                            )
                        end
                    end)
                end
            end)()


        pcall(function()
            local net_fire = debug.getproto(network.Fire, 1)
            local net_fire_x = debug.getproto(net_fire, 1)
            local net_const = getconstants(net_fire_x)

            for constant_index, constant in net_const do
                if constant == "char" then
                    setconstant(net_fire_x, constant_index, "reverse")
                    break
                end
            end
        end)
        pcall(function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CastShadow = false
                end
            end
            workspace.DescendantAdded:Connect(function(v)
                if v:IsA("BasePart") then
                    pcall(function() v.CastShadow = false end)
                end
            end)
        end)


        local _ql_patched = false
        local _ql_patched = false
        local function _patch_quickloot(enable)
            if enable == _ql_patched then return end
            _ql_patched = enable
            pcall(function()
                for _, f in getgc(false) do
                    if type(f) ~= "function" or not islclosure(f) or isexecutorclosure(f) then continue end
                    local ok, consts = pcall(debug.getconstants, f)
                    if not ok then continue end
                    for _, c in ipairs(consts) do
                        if c == "QuickLooting" then
                            local val = enable and 0 or 0.65
                            local val2 = enable and 0 or 0.6
                            pcall(setconstant, f, 32, val)
                            pcall(setconstant, f, 49, val2)
                            for pi = 1, 2 do
                                local proto = debug.getproto(f, pi)
                                if proto then
                                    pcall(setconstant, proto, 32, val)
                                    pcall(setconstant, proto, 49, val2)
                                end
                            end
                            break
                        end
                    end
                end
            end)
        end

        pcall(function()
            local old_ql = inventory_module.QuickLoot
            inventory_module.QuickLoot = newcclosure(function(self, item)
                local result = old_ql(self, item)
                task.defer(function()
                    pcall(function()
                        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                        if not playerGui then return end
                        local function searchForLootFrame(parent, depth)
                            if depth > 5 then return end
                            for _, child in ipairs(parent:GetChildren()) do
                                if child.Name == "QuickLootTemplate" or child.Name:find("QuickLoot") then
                                end
                                searchForLootFrame(child, depth + 1)
                            end
                        end
                        searchForLootFrame(playerGui, 0)
                    end)
                end)
                return result
            end)
        end)

        local _ql_last = nil
        run_service.Heartbeat:Connect(function()
            local v = cheat.instant_loot == true
            if v ~= _ql_last then
                _ql_last = v
                _patch_quickloot(v)
            end
        end)

        local gun_handler = {
            Current_Weapon = nil,
            Current_Weapon_Behavior = nil,
            Current_Weapon_Type = nil,
            module_new_function = {},
        }

        function new_gun_data(behavior_module, data)
            local actual = {
                ["Viewmodel"] = data,
                ["LastFireTick"] = tick(),
                ["RPM"] = 60 / data.Tool.Stats.RPM,
                ["Spread"] = data.Tool.Stats.Spread,
                ["AdditionalSpread"] = 0,
                ["CustomTracer"] = nil,
                ["CachedParts"] = {},
                ["CachedTweens"] = {
                    ["In"] = {},
                    ["Out"] = {},
                },
                ["MuzzleTweens"] = {
                    ["In"] = {},
                    ["Out"] = {},
                },
                ["Scopes"] = {},
                ["SwayIntensity"] = Vector2.new(4, 4),
                ["Reloading"] = false,
                ["Aiming"] = false,
                ["Firing"] = false,
                ["Equipping"] = true,
            }
            local behavior = behavior_module
            return setmetatable(actual, behavior)
        end

        gun_handler.get_current = function()
            return {
                gun = gun_handler.Current_Weapon,
                gun_data = gun_handler.Current_Weapon_Behavior,
                type = gun_handler.Current_Weapon_Type,
            }
        end

        gun_handler.get_rpm = function()
            local class = gun_handler.get_current()
            if class.gun_data then
                local rpm_mult = (cheat.rapidfire and (cheat.rpm or 1) or 1)
                return (class.gun_data.RPM * 60) * rpm_mult
            end
            return nil
        end

        gun_handler.fire_current = function()
            local class = gun_handler.get_current()
            if class.gun_data and class.gun_data.Fire then
                pcall(function()
                    class.gun_data.Fire(class.gun_data)
                end)
            end
            return nil
        end

        gun_handler.generate_data = function(typename, behavior_module, data)
            if typename:find("DefaultGun") then
                return new_gun_data(behavior_module, data)
            else
                return gun_handler.module_new_function[typename](data)
            end
        end

        gun_handler.stat_predict = function(stat_data, target)
            local class = gun_handler.get_current()
            if not class.gun_data then
                return nil
            end

            local predicted_hit = utility.predict(
                my_camera.CFrame.p,
                stat_data.Stats.Velocity,
                stat_data.Stats.Drop,
                target.Position,
                target.Velocity
            )

            return predicted_hit or position
        end

        for module_index, module_script in viewmodel_module:GetChildren() do
            if module_script.ClassName ~= "ModuleScript" then
                continue
            end

            local required_module = require(module_script)

            if required_module.New then
                gun_handler.module_new_function[module_script.Name] = required_module.New
            end
        end

        local framework = {
            esp = {
                objects = {},
                functions = {},
                loop = nil,
            },

            item_esp = {
                objects = {},
                functions = {},
                loop = nil,
            },

            targeting = {
                current = nil,
                bodypart = nil,
                radial = nil,
                loop = nil,
            },
        }

        EspInterface = (function()
            local _rs = game:GetService("RunService")
            local _players = game:GetService("Players")
            local _lp = _players.LocalPlayer
            local _cam = workspace.CurrentCamera
            workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                _cam = workspace.CurrentCamera
            end)
            local floor=math.floor; local round=math.round; local sin=math.sin; local cos=math.cos
            local clear=table.clear; local unpack=table.unpack; local find=table.find; local create=table.create
            local fromMatrix=CFrame.fromMatrix
            local wtvp=_cam.WorldToViewportPoint
            local isA=workspace.IsA; local getPivot=workspace.GetPivot
            local findFirstChild=workspace.FindFirstChild; local findFirstChildOfClass=workspace.FindFirstChildOfClass
            local getChildren=workspace.GetChildren
            local pointToObjectSpace=CFrame.identity.PointToObjectSpace
            local lerpColor=Color3.new().Lerp
            local min2=Vector2.zero.Min; local max2=Vector2.zero.Max; local lerp2=Vector2.zero.Lerp
            local min3=Vector3.zero.Min; local max3=Vector3.zero.Max
            local HB_OFF=Vector2.new(5,0); local HT_OFF=Vector2.new(3,0); local HBO_OFF=Vector2.new(0,1)
            local N_OFF=Vector2.new(0,2); local D_OFF=Vector2.new(0,2)
            local VERTS={Vector3.new(-1,-1,-1),Vector3.new(-1,1,-1),Vector3.new(-1,1,1),Vector3.new(-1,-1,1),Vector3.new(1,-1,-1),Vector3.new(1,1,-1),Vector3.new(1,1,1),Vector3.new(1,-1,1)}
            local function isBodyPart(n) return n=="Head" or n:find("Torso") or n:find("Leg") or n:find("Arm") end
            local function getBB(parts)
                local mn,mx
                for i=1,#parts do local p=parts[i]; local cf,sz=p.CFrame,p.Size; mn=min3(mn or cf.Position,(cf-sz*0.5).Position); mx=max3(mx or cf.Position,(cf+sz*0.5).Position) end
                local c=(mn+mx)*0.5; return CFrame.new(c,Vector3.new(c.X,c.Y,mx.Z)),mx-mn
            end
            local function w2s(w) local s,ib=_cam:WorldToViewportPoint(w); return Vector2.new(s.X,s.Y),ib,s.Z end
            local function calcCorners(cf,sz)
                local c=create(#VERTS)
                for i=1,#VERTS do c[i]=w2s((cf+sz*0.5*VERTS[i]).Position) end
                local mn=min2(_cam.ViewportSize,unpack(c)); local mx=max2(Vector2.zero,unpack(c))
                return {corners=c,topLeft=Vector2.new(floor(mn.X),floor(mn.Y)),topRight=Vector2.new(floor(mx.X),floor(mn.Y)),bottomLeft=Vector2.new(floor(mn.X),floor(mx.Y)),bottomRight=Vector2.new(floor(mx.X),floor(mx.Y))}
            end
            local function rotVec(v,r) local x,y=v.X,v.Y; local c2,s2=cos(r),sin(r); return Vector2.new(x*c2-y*s2,x*s2+y*c2) end
            local function pColor(self,color,isOutline)
                if color=="Team Color" or (self.interface.sharedSettings.useTeamColor and not isOutline) then return self.interface.getTeamColor(self.player) or Color3.new(1,1,1) end
                return color
            end
            local EO={}; EO.__index=EO
            function EO.new(pl,iface) local s=setmetatable({},EO); s.player=pl; s.interface=iface; s:Construct(); return s end
            function EO:_c(cls,props) local d=Drawing.new(cls); for p,v in next,props do pcall(function() d[p]=v end) end; self.bin[#self.bin+1]=d; return d end
            function EO:Construct()
                self.charCache={}; self.childCount=0; self.bin={}
                local s=self
                self.drawings={
                    visible={tracerOutline=s:_c("Line",{Thickness=3,Visible=false}),tracer=s:_c("Line",{Thickness=1,Visible=false}),boxFill=s:_c("Square",{Filled=true,Visible=false}),boxOutline=s:_c("Square",{Filled=false,Thickness=3,Visible=false}),box=s:_c("Square",{Filled=false,Thickness=1,Visible=false}),healthBarOutline=s:_c("Line",{Thickness=3,Visible=false}),healthBar=s:_c("Line",{Thickness=1,Visible=false}),healthText=s:_c("Text",{Center=true,Visible=false}),name=s:_c("Text",{Text=s.player.Name,Center=true,Visible=false}),distance=s:_c("Text",{Center=true,Visible=false}),weapon=s:_c("Text",{Center=true,Visible=false})},
                    hidden={arrowOutline=s:_c("Triangle",{Thickness=3,Visible=false}),arrow=s:_c("Triangle",{Filled=true,Visible=false})},
                    box3d={}
                }
                self.rc = nil
            end
            function EO:Destruct() if self.rc then self.rc:Disconnect() end; for i=1,#self.bin do self.bin[i]:Remove() end; clear(self) end
            function EO:Update()
                local iface=self.interface
                self.options=iface.teamSettings[iface.isFriendly(self.player) and "friendly" or "enemy"]
                self.character=iface.getCharacter(self.player)
                self.health,self.maxHealth=iface.getHealth(self.player)
                self.weapon=iface.getWeapon(self.player)
                self.enabled=self.options.enabled and self.character and not(#iface.whitelist>0 and not find(iface.whitelist,self.player.UserId))
                local head=self.enabled and findFirstChild(self.character,"Head")
                if not head then self.charCache={}; self.onScreen=false; return end
                local _,onScreen,depth=w2s(head.Position); self.onScreen=onScreen
                if _cam then self.distance=(_cam.CFrame.p-head.Position).Magnitude end
                if self.onScreen then
                    local headPos = head.Position
                    local feetPos = headPos - Vector3.new(0, 5, 0)
                    local headScreen, headVis = w2s(headPos)
                    local feetScreen, feetVis = w2s(feetPos)
                    if headVis or feetVis then
                        local h = math.abs(headScreen.Y - feetScreen.Y)
                        local w = h * 0.6
                        local cx = (headScreen.X + feetScreen.X) * 0.5
                        local top = math.min(headScreen.Y, feetScreen.Y)
                        self.corners = {
                            topLeft     = Vector2.new(floor(cx - w*0.5), floor(top)),
                            topRight    = Vector2.new(floor(cx + w*0.5), floor(top)),
                            bottomLeft  = Vector2.new(floor(cx - w*0.5), floor(top + h)),
                            bottomRight = Vector2.new(floor(cx + w*0.5), floor(top + h)),
                            corners     = {}
                        }
                    end
                elseif self.options.offScreenArrow then
                    local cf=_cam.CFrame; local flat=fromMatrix(cf.Position,cf.RightVector,Vector3.yAxis)
                    local os=pointToObjectSpace(flat,head.Position); self.direction=Vector2.new(os.X,os.Z).Unit
                end
            end
            function EO:Render()
                local onS=self.onScreen or false; local en=self.enabled or false
                local vis=self.drawings.visible; local hid=self.drawings.hidden
                local opt=self.options; local cor=self.corners
                if not cor then
                    vis.box.Visible=false; vis.boxOutline.Visible=false; vis.boxFill.Visible=false
                    vis.healthBar.Visible=false; vis.healthBarOutline.Visible=false
                    vis.healthText.Visible=false; vis.name.Visible=false
                    vis.distance.Visible=false; vis.tracer.Visible=false; vis.tracerOutline.Visible=false
                    hid.arrow.Visible=false; hid.arrowOutline.Visible=false
                    return
                end
                local show = en and onS
                local boxShow = show and opt.box
                if vis.box.Visible ~= boxShow then vis.box.Visible = boxShow end
                if boxShow then
                    vis.box.Position=cor.topLeft; vis.box.Size=cor.bottomRight-cor.topLeft
                    vis.box.Color=pColor(self,opt.boxColor[1]); vis.box.Transparency=opt.boxColor[2]
                    local boShow = opt.boxOutline
                    if vis.boxOutline.Visible ~= boShow then vis.boxOutline.Visible = boShow end
                    if boShow then vis.boxOutline.Position=cor.topLeft; vis.boxOutline.Size=cor.bottomRight-cor.topLeft; vis.boxOutline.Color=pColor(self,opt.boxOutlineColor[1],true); vis.boxOutline.Transparency=opt.boxOutlineColor[2] end
                else vis.boxOutline.Visible=false end
                local bfShow = show and opt.boxFill
                if vis.boxFill.Visible ~= bfShow then vis.boxFill.Visible = bfShow end
                if bfShow then vis.boxFill.Position=cor.topLeft; vis.boxFill.Size=cor.bottomRight-cor.topLeft; vis.boxFill.Color=pColor(self,opt.boxFillColor[1]); vis.boxFill.Transparency=opt.boxFillColor[2] end
                local hbShow = show and opt.healthBar
                if vis.healthBar.Visible ~= hbShow then vis.healthBar.Visible = hbShow end
                if hbShow then
                    local bF=cor.topLeft-HB_OFF; local bT=cor.bottomLeft-HB_OFF
                    local hb=vis.healthBar; hb.To=bT; hb.From=lerp2(bT,bF,self.health/self.maxHealth); hb.Color=lerpColor(opt.dyingColor,opt.healthyColor,self.health/self.maxHealth)
                    local hboShow = opt.healthBarOutline
                    if vis.healthBarOutline.Visible ~= hboShow then vis.healthBarOutline.Visible = hboShow end
                    if hboShow then local hbo=vis.healthBarOutline; hbo.To=bT+HBO_OFF; hbo.From=bF-HBO_OFF; hbo.Color=pColor(self,opt.healthBarOutlineColor[1],true); hbo.Transparency=opt.healthBarOutlineColor[2] end
                else vis.healthBarOutline.Visible=false end
                local htShow = show and opt.healthText
                if vis.healthText.Visible ~= htShow then vis.healthText.Visible = htShow end
                if htShow then local bF=cor.topLeft-HB_OFF; local bT=cor.bottomLeft-HB_OFF; local ht=vis.healthText; ht.Text=tostring(math.floor(self.health+0.9)); ht.Size=13; ht.Font=2; ht.Color=pColor(self,opt.healthTextColor[1]); ht.Position=lerp2(bT,bF,self.health/self.maxHealth)-ht.TextBounds*0.5-HT_OFF end
                local nShow = show and opt.name
                if vis.name.Visible ~= nShow then vis.name.Visible = nShow end
                if nShow then local n=vis.name; n.Size=13; n.Font=2; n.Color=pColor(self,opt.nameColor[1]); n.Position=(cor.topLeft+cor.topRight)*0.5-Vector2.yAxis*n.TextBounds.Y-N_OFF end
                local dShow = show and self.distance and opt.distance
                if vis.distance.Visible ~= dShow then vis.distance.Visible = dShow end
                if dShow then local d=vis.distance; d.Text=math.round(self.distance/3).."m"; d.Size=13; d.Font=2; d.Color=pColor(self,opt.distanceColor[1]); d.Position=(cor.bottomLeft+cor.bottomRight)*0.5+D_OFF end
                local tShow = show and opt.tracer
                if vis.tracer.Visible ~= tShow then vis.tracer.Visible = tShow end
                if tShow then
                    local t=vis.tracer; t.Color=pColor(self,opt.tracerColor[1]); t.To=(cor.bottomLeft+cor.bottomRight)*0.5
                    t.From=opt.tracerOrigin=="Middle" and _cam.ViewportSize*0.5 or opt.tracerOrigin=="Top" and _cam.ViewportSize*Vector2.new(0.5,0) or _cam.ViewportSize*Vector2.new(0.5,1)
                    local toShow = opt.tracerOutline
                    if vis.tracerOutline.Visible ~= toShow then vis.tracerOutline.Visible = toShow end
                    if toShow then local to=vis.tracerOutline; to.Color=pColor(self,opt.tracerOutlineColor[1],true); to.To=t.To; to.From=t.From end
                else vis.tracerOutline.Visible=false end
                local aShow = en and (not onS) and opt.offScreenArrow
                if hid.arrow.Visible ~= aShow then hid.arrow.Visible = aShow end
                if aShow and self.direction then
                    local a=hid.arrow
                    local arrowR=(self.interface.sharedSettings.useFovRadius and cheat and cheat.show_fov and cheat.fovradius) or opt.offScreenArrowRadius
                    a.PointA=min2(max2(_cam.ViewportSize*0.5+self.direction*arrowR,Vector2.one*25),_cam.ViewportSize-Vector2.one*25)
                    a.PointB=a.PointA-rotVec(self.direction,0.45)*opt.offScreenArrowSize
                    a.PointC=a.PointA-rotVec(self.direction,-0.45)*opt.offScreenArrowSize
                    a.Color=pColor(self,opt.offScreenArrowColor[1]); a.Transparency=opt.offScreenArrowColor[2]
                    local aoShow = opt.offScreenArrowOutline
                    if hid.arrowOutline.Visible ~= aoShow then hid.arrowOutline.Visible = aoShow end
                    if aoShow then local ao=hid.arrowOutline; ao.PointA=a.PointA; ao.PointB=a.PointB; ao.PointC=a.PointC; ao.Color=pColor(self,opt.offScreenArrowOutlineColor[1],true); ao.Transparency=opt.offScreenArrowOutlineColor[2] end
                else hid.arrowOutline.Visible=false end
            end
            local CO={}; CO.__index=CO
            function CO.new(pl,iface) local s=setmetatable({},CO); s.player=pl; s.interface=iface; s:Construct(); return s end
            function CO:Construct() self.highlight=Instance.new("Highlight",game:GetService("CoreGui")); self.rc=nil end
            function CO:Destruct() if self.rc then self.rc:Disconnect() end; self.highlight:Destroy(); clear(self) end
            function CO:Update()
                local h=self.highlight; local iface=self.interface
                local char=iface.getCharacter(self.player)
                local opt=iface.teamSettings[iface.isFriendly(self.player) and "friendly" or "enemy"]
                local en=opt.enabled and char and not(#iface.whitelist>0 and not find(iface.whitelist,self.player.UserId))
                h.Enabled=en and opt.chams
                if h.Enabled then h.Adornee=char; h.FillColor=pColor(self,opt.chamsFillColor[1]); h.FillTransparency=opt.chamsFillColor[2]; h.OutlineColor=pColor(self,opt.chamsOutlineColor[1],true); h.OutlineTransparency=opt.chamsOutlineColor[2]; h.DepthMode=opt.chamsVisibleOnly and "Occluded" or "AlwaysOnTop" end
            end
            local EI={_hasLoaded=false,_objectCache={},whitelist={},sharedSettings={textSize=13,textFont=2,limitDistance=false,maxDistance=150,useTeamColor=false,useFovRadius=false},teamSettings={enemy={enabled=false,box=false,boxColor={Color3.fromRGB(0,191,255),1},boxOutline=true,boxOutlineColor={Color3.new(),1},boxFill=false,boxFillColor={Color3.fromRGB(0,191,255),0.5},healthBar=false,healthyColor=Color3.new(0,1,0),dyingColor=Color3.new(1,0,0),healthBarOutline=true,healthBarOutlineColor={Color3.new(),0.5},healthText=false,healthTextColor={Color3.new(1,1,1),1},healthTextOutline=true,healthTextOutlineColor=Color3.new(),box3d=false,box3dColor={Color3.new(1,0,0),1},name=false,nameColor={Color3.new(1,1,1),1},nameOutline=true,nameOutlineColor=Color3.new(),weapon=false,weaponColor={Color3.new(1,1,1),1},weaponOutline=true,weaponOutlineColor=Color3.new(),distance=false,distanceColor={Color3.new(1,1,1),1},distanceOutline=true,distanceOutlineColor=Color3.new(),tracer=false,tracerOrigin="Bottom",tracerColor={Color3.fromRGB(0,191,255),1},tracerOutline=true,tracerOutlineColor={Color3.new(),1},offScreenArrow=false,offScreenArrowColor={Color3.new(1,1,1),1},offScreenArrowSize=15,offScreenArrowRadius=150,offScreenArrowOutline=true,offScreenArrowOutlineColor={Color3.new(),1},chams=false,chamsVisibleOnly=false,chamsFillColor={Color3.new(0.2,0.2,0.2),0.5},chamsOutlineColor={Color3.fromRGB(0,191,255),0}},friendly={enabled=false,box=false,boxColor={Color3.fromRGB(0,191,255),1},boxOutline=true,boxOutlineColor={Color3.new(),1},boxFill=false,boxFillColor={Color3.fromRGB(0,191,255),0.5},healthBar=false,healthyColor=Color3.new(0,1,0),dyingColor=Color3.new(1,0,0),healthBarOutline=true,healthBarOutlineColor={Color3.new(),0.5},healthText=false,healthTextColor={Color3.new(1,1,1),1},healthTextOutline=true,healthTextOutlineColor=Color3.new(),box3d=false,box3dColor={Color3.new(0,1,0),1},name=false,nameColor={Color3.new(1,1,1),1},nameOutline=true,nameOutlineColor=Color3.new(),weapon=false,weaponColor={Color3.new(1,1,1),1},weaponOutline=true,weaponOutlineColor=Color3.new(),distance=false,distanceColor={Color3.new(1,1,1),1},distanceOutline=true,distanceOutlineColor=Color3.new(),tracer=false,tracerOrigin="Bottom",tracerColor={Color3.fromRGB(0,191,255),1},tracerOutline=true,tracerOutlineColor={Color3.new(),1},offScreenArrow=false,offScreenArrowColor={Color3.new(1,1,1),1},offScreenArrowSize=15,offScreenArrowRadius=150,offScreenArrowOutline=true,offScreenArrowOutlineColor={Color3.new(),1},chams=false,chamsVisibleOnly=false,chamsFillColor={Color3.new(0.2,0.2,0.2),0.5},chamsOutlineColor={Color3.fromRGB(0,191,255),0}}}}
            function EI.Load()
                local function create(pl) EI._objectCache[pl]={EO.new(pl,EI),CO.new(pl,EI)} end
                local function remove(pl) local o=EI._objectCache[pl]; if o then for i=1,#o do o[i]:Destruct() end; EI._objectCache[pl]=nil end end
                local plrs=_players:GetPlayers(); for i=2,#plrs do create(plrs[i]) end
                EI.playerAdded=_players.PlayerAdded:Connect(create)
                EI.playerRemoving=_players.PlayerRemoving:Connect(remove)
                EI.sharedLoop = _rs.Heartbeat:Connect(function(dt)
                    local anyEnabled = EI.teamSettings.enemy.enabled or EI.teamSettings.friendly.enabled
                    for _, objs in next, EI._objectCache do
                        if objs[1] then
                            if anyEnabled then
                                objs[1]:Update(dt); objs[1]:Render(dt)
                            else
                                local vis = objs[1].drawings and objs[1].drawings.visible
                                local hid = objs[1].drawings and objs[1].drawings.hidden
                                if vis then
                                    for _, d in next, vis do pcall(function() d.Visible = false end) end
                                end
                                if hid then
                                    for _, d in next, hid do pcall(function() d.Visible = false end) end
                                end
                            end
                        end
                        if objs[2] then
                            if anyEnabled then
                                objs[2]:Update()
                            elseif not anyEnabled then
                                pcall(function() objs[2].highlight.Enabled = false end)
                            end
                        end
                    end
                end)
                EI._hasLoaded=true
            end
            function EI.Unload()
                if EI.sharedLoop then EI.sharedLoop:Disconnect() end
                if EI.playerAdded then EI.playerAdded:Disconnect() end
                if EI.playerRemoving then EI.playerRemoving:Disconnect() end
                for index, object in next, EI._objectCache do
                    for i=1,#object do object[i]:Destruct() end
                    EI._objectCache[index]=nil
                end
                EI._hasLoaded=false
            end
            function EI.getWeapon(player) return "" end
            function EI.isFriendly(player) return player.Team and player.Team==_lp.Team end
            function EI.getTeamColor(player) return player.Team and player.Team.TeamColor and player.Team.TeamColor.Color end
            function EI.getCharacter(player)
                return players_folder and players_folder:FindFirstChild(player.Name) or player.Character
            end
            function EI.getHealth(player)
                local char=EI.getCharacter(player)
                if char then
                    local h=char:GetAttribute("ActualHealth")
                    if h then return math.clamp(h,0,100),100 end
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    if hum then return hum.Health,hum.MaxHealth end
                end
                return 100,100
            end
            EI.Load()
            return EI
        end)()

        local item_preception = framework.item_esp
        local item_preception_objects = framework.item_esp.objects
        local item_preception_functions = framework.item_esp.functions

        local resources_path = workspace.Resources
        local bags_path = workspace.DroppedPacks
        local dropped_path = workspace.Dropped
        local cloth_path = workspace.ClothPlants

        local _cache_resources = {}
        local _cache_bags = {}
        local _cache_dropped = {}
        local _cache_cloth = {}
        local _cache_last_refresh = 0

        item_preception_functions.add_object = function(obj, object_type)
            if item_preception_objects[obj] then return end
            local name = Drawing.new("Text")
            name.Font = 1; name.Size = 13; name.Center = true; name.Outline = true; name.Color = Color3.new(1,1,1)
            item_preception_objects[obj] = { type = object_type, name = name }
        end

        item_preception_functions.remove_object = function(obj)
            local o = item_preception_objects[obj]
            if o then pcall(function() o.name:Remove() end) end
            item_preception_objects[obj] = nil
        end

        local item_type_map = {
            Bag = function() return cheat.body end,
            Hemp = function() return cheat.hemp end,
            Stone = function() return cheat.stone end,
            Iron = function() return cheat.iron end,
            Sulfur = function() return cheat.sulf end,
            Dropped = function() return cheat.dropped end,
        }

        local item_name_patterns = {
            { key = "Tree", type = "Tree", flag = function() return false end },
            { key = "Stone Ore", type = "Stone", flag = function() return cheat.stone end },
            { key = "Iron Ore", type = "Iron", flag = function() return cheat.iron end },
            { key = "Brimstone", type = "Sulfur", flag = function() return cheat.sulf end },
        }

        item_preception_functions.update_resources = function()
            local now = tick()
            if now - _cache_last_refresh >= 0.5 then
                _cache_last_refresh = now
                _cache_resources = resources_path:GetChildren()
                _cache_bags = bags_path:GetChildren()
                _cache_dropped = dropped_path:GetChildren()
                _cache_cloth = cloth_path:GetChildren()
            end

            -- First pass: add new objects
            if cheat.wvis then
                local camPos = my_camera.CFrame.p
                for _, obj in _cache_resources do
                    local d = (camPos - obj.WorldPivot.p).Magnitude
                    if d >= 500 then continue end
                    local n = obj.Name
                    for _, pat in ipairs(item_name_patterns) do
                        if n:find(pat.key) and pat.flag() then
                            item_preception_functions.add_object(obj, pat.type)
                            break
                        end
                    end
                end
                if cheat.body then
                    for _, obj in _cache_bags do
                        if (camPos - obj.WorldPivot.p).Magnitude < 500 then
                            item_preception_functions.add_object(obj, "Bag")
                        end
                    end
                end
                if cheat.dropped then
                    for _, obj in _cache_dropped do
                        if (camPos - obj.WorldPivot.p).Magnitude < 500 then
                            item_preception_functions.add_object(obj, "Dropped")
                        end
                    end
                end
                if cheat.hemp then
                    for _, obj in _cache_cloth do
                        if (camPos - obj.WorldPivot.p).Magnitude < 500 then
                            item_preception_functions.add_object(obj, "Hemp")
                        end
                    end
                end
            end

            -- Second pass: update/render on screen
            for obj, data in item_preception_objects do
                local flag_fn = item_type_map[data.type]
                if not cheat.wvis or (flag_fn and not flag_fn()) or not obj.Parent then
                    item_preception_functions.remove_object(obj)
                else
                    local d = (my_camera.CFrame.p - obj.WorldPivot.p).Magnitude
                    if d >= 500 then
                        item_preception_functions.remove_object(obj)
                    else
                        local sc, onSc = my_camera:WorldToViewportPoint(obj.WorldPivot.p)
                        data.name.Position = Vector2.new(sc.X, sc.Y)
                        data.name.Text = data.type
                        data.name.Visible = onSc
                    end
                end
            end
        end

        local _item_esp_frame = 0
        item_preception.loop = run_service.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            if not cheat.wvis then return end
            _item_esp_frame = _item_esp_frame + 1
            if _item_esp_frame % 10 ~= 0 then return end
            item_preception_functions.update_resources()
        end))

        local targeting = framework.targeting

        local _targeting_cache = {}
        local _targeting_cache_last = 0
        local function get_targeting_players()
            local now = tick()
            if now - _targeting_cache_last >= 0.5 then
                _targeting_cache_last = now
                _targeting_cache = players_folder and players_folder:GetChildren() or {}
            end
            return _targeting_cache
        end

        targeting.get_target = function(range)
            local max_distance = range
            local player_selected = nil
            local bodypart_selected = nil
            for _, player in get_targeting_players() do
                if player.Name == my_player.Name then
                    continue
                end
                local player_hitpart = player:FindFirstChild(cheat.hitpart)
                if player and player_hitpart then
                    local player_world_position = player_hitpart.Position
                    local player_screen_position, is_on_screen = utility.get_screen_pos(player_world_position)
                    if not is_on_screen then
                        continue
                    end
                    local player_data = {
                        IsTeam = player:FindFirstChild("TeamDot") and player:FindFirstChild("TeamDot").Enabled or false,
                        Downed = player:GetAttribute("Downed"),
                    }
                    if cheat.vischeck and not targeting.is_visible(player_world_position, player) then
                        continue
                    end
                    if cheat.ignore_team and player_data.IsTeam then
                        continue
                    end
                    if cheat.ignore_downed and player_data.Downed then
                        continue
                    end

                    local player_magnitude = (player_screen_position - user_input_service:GetMouseLocation()).magnitude
                    local player_world_magnitude = (player_world_position - my_camera.CFrame.p).magnitude

                    if player_magnitude < max_distance then
                        max_distance = player_magnitude
                        player_selected = player
                        bodypart_selected = player_hitpart
                    end
                end
            end

            return player_selected, bodypart_selected
        end

        targeting.get_target_closest = function(range)
            local my_character = my_player and my_player.Character or nil

            if not my_character or not my_character:FindFirstChild("Head") then
                return nil
            end

            local my_root = my_character.HumanoidRootPart
            local closest_player = nil
            local shortest_distance = range
            local head = nil
            for _, player in get_targeting_players() do
                if player.Name == my_player.Name then continue end
                if player:FindFirstChild("Head") and player:FindFirstChild("HumanoidRootPart") then
                    local head_part = player.Head
                    local my_target_root = player.HumanoidRootPart
                    local distance = (my_root.Position - my_target_root.Position).Magnitude

                    if distance < shortest_distance then
                        shortest_distance = distance
                        closest_player = player
                        head = head_part
                    end
                end
            end

            return closest_player, head
        end

        local _vis_params = RaycastParams.new()
        _vis_params.FilterType = Enum.RaycastFilterType.Blacklist
        targeting.is_visible = function(object, path, _origin)
            _vis_params.FilterDescendantsInstances = { my_player.Character }
            local origin = _origin or my_camera.CFrame.p
            local direction = (object - origin).Unit * (object - origin).Magnitude
            local raycastResult = workspace:Raycast(origin, direction, _vis_params)
            return raycastResult and raycastResult.Instance:IsDescendantOf(path)
        end

        local _targeting_frame = 0
        targeting.loop = run_service.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            _targeting_frame = _targeting_frame + 1
            if _targeting_frame % 3 ~= 0 then return end
            if not cheat.aimbot_enabled and not cheat.show_fov then
                targeting.current = nil
                targeting.bodypart = nil
                return
            end
            if cheat.show_fov then
                local current, hitpart = targeting.get_target(cheat.fovradius)
                targeting.current = current
                targeting.bodypart = hitpart
            else
                local current, hitpart = targeting.get_target(4000)
                targeting.current = current
                targeting.bodypart = hitpart
            end
        end))

        local visual = {
            loop = nil,
            fov = Drawing.new("Circle"),
            whitelisted_parts = {
                "LeftHand",
                "LeftLowerArm",
                "LeftUpperArm",
                "RightHand",
                "RightLowerArm",
                "RightUpperArm",
            },
            arms = {},
            gun_model = nil,
            free_cam = false,
        }

        do
            local module, old
            local random_key = tostring(math.random(1, 1e9))
            local speed2 = 20
            local cam_pos
            local camera_connection

            visual.freecam = LPH_NO_VIRTUALIZE(function()
                local freecam_enabled = cheat.fcam and cheat.fbind
                local speed = cheat.fcamsped or speed2

                if freecam_enabled then
                    if visual.free_cam then
                        return
                    end
                    visual.free_cam = true

                    repeat
                        task.wait(0.1)
                        for _, connection in ipairs(getconnections(my_camera:GetPropertyChangedSignal("CameraType"))) do
                            if connection.Function then
                                module = debug.getupvalue(connection.Function, 1)
                            end
                        end
                    until module or not freecam_enabled

                    if module and module.activeCameraController then
                        old = module.activeCameraController.GetSubjectPosition
                        cam_pos = old(module.activeCameraController) or Vector3.zero

                        module.activeCameraController.GetSubjectPosition = function()
                            return cam_pos
                        end

                        if camera_connection then
                            camera_connection:Disconnect()
                        end

                        camera_connection = run_service.PreSimulation:Connect(function(dt)
                            if not user_input_service:GetFocusedTextBox() then
                                local forward = (user_input_service:IsKeyDown(Enum.KeyCode.W) and -1 or 0)
                                    + (user_input_service:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
                                local side = (user_input_service:IsKeyDown(Enum.KeyCode.A) and -1 or 0)
                                    + (user_input_service:IsKeyDown(Enum.KeyCode.D) and 1 or 0)
                                local up = (user_input_service:IsKeyDown(Enum.KeyCode.Q) and -1 or 0)
                                    + (user_input_service:IsKeyDown(Enum.KeyCode.E) and 1 or 0)

                                dt = dt * (user_input_service:IsKeyDown(Enum.KeyCode.LeftShift) and 0.25 or 1)

                                local move_vector = Vector3.new(side, up, forward) * (speed * dt)
                                cam_pos = (CFrame.lookAlong(cam_pos, my_camera.CFrame.LookVector) * CFrame.new(move_vector)).Position
                            end
                        end)

                        context_service:BindActionAtPriority(
                            "FreecamKeyboard" .. random_key,
                            function()
                                return Enum.ContextActionResult.Sink
                            end,
                            false,
                            Enum.ContextActionPriority.High.Value,
                            Enum.KeyCode.W,
                            Enum.KeyCode.A,
                            Enum.KeyCode.S,
                            Enum.KeyCode.D,
                            Enum.KeyCode.E,
                            Enum.KeyCode.Q,
                            Enum.KeyCode.Up,
                            Enum.KeyCode.Down
                        )
                    end
                else
                    pcall(function()
                        context_service:UnbindAction("FreecamKeyboard" .. random_key)
                    end)

                    if module and old then
                        module.activeCameraController.GetSubjectPosition = old
                        module = nil
                        old = nil
                    end

                    if camera_connection then
                        camera_connection:Disconnect()
                        camera_connection = nil
                    end

                    visual.free_cam = false
                end
            end)
        end

        visual.get_arms = LPH_NO_VIRTUALIZE(function()
            local arm_parts = {}
            if not my_camera:FindFirstChild("Viewmodel") then
                return {}
            end
            for inx, child in my_camera.Viewmodel:GetChildren() do
                if table.find(visual.whitelisted_parts, child.Name) then
                    table.insert(arm_parts, child)
                end
            end

            return arm_parts
        end)

        visual.get_gun_model = LPH_NO_VIRTUALIZE(function()
            if not my_camera:FindFirstChild("Viewmodel") then
                return {}
            end
            for inx, child in my_camera.Viewmodel:GetChildren() do
                if child:IsA("Model") then
                    return child:GetChildren()
                end
            end

            return {}
        end)

        my_camera.ChildAdded:Connect(LPH_NO_VIRTUALIZE(function()
            visual.arms = visual.get_arms()
            visual.gun_model = visual.get_gun_model()
        end))

        visual.arms = visual.get_arms()
        visual.gun_model = visual.get_gun_model()

        local _visual_frame = 0

        visual.loop = run_service.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            _visual_frame = _visual_frame + 1

            visual.fov.Visible = cheat.show_fov
            if cheat.show_fov then
                visual.fov.Radius = cheat.fovradius
                visual.fov.Color = cheat.fov_color
                visual.fov.Position = user_input_service:GetMouseLocation()
                visual.fov.Thickness = 1
            end

            if _visual_frame % 2 ~= 0 then return end

            if EspInterface and cheat.highlight_target and framework.targeting.current then
                local targetChar = framework.targeting.current
                local targetPlayer = nil
                for pl, objs in next, EspInterface._objectCache do
                    if objs[1] and objs[1].character == targetChar then
                        targetPlayer = pl; break
                    end
                end
                if not targetPlayer then
                    local plname
                    if targetChar:IsA("Model") then
                        plname = targetChar.Name
                    end
                    targetPlayer = players_folder and players_folder:FindFirstChild(plname) or nil
                end
                if targetPlayer then
                    local obj = EspInterface._objectCache[targetPlayer]
                    if obj and obj[1] and obj[1].drawings then
                        local box = obj[1].drawings.visible.box
                        if box then
                            box.Color = cheat.highlight_color or Color3.fromRGB(255, 0, 255)
                            box.Visible = true
                        end
                    end
                end
                -- Also add a red Highlight instance on the target as backup
                pcall(function()
                    local hl = framework._target_hlight
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 1
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        framework._target_hlight = hl
                    end
                    hl.FillColor = cheat.highlight_color
                    hl.Adornee = targetChar
                    hl.Enabled = true
                end)
            elseif framework._target_hlight then
                framework._target_hlight.Enabled = false
            end

            visual.freecam()

            if not cheat.nobob and not cheat.arm and not cheat.gun then
                return
            end

            local My_Character = character_module.CurrentCharacter

            local tool_data = gun_handler.get_current()

            if tool_data.gun then
                if cheat.nobob then
                    if tool_data.gun.SideDirectionModifier then
                        tool_data.gun.SideDirectionModifier = 0
                    end

                    if tool_data.gun.Springs then
                        tool_data.gun.Springs.Rotation.WalkCycle.Target = Vector3.new()
                        tool_data.gun.Springs.Other.Sway.Position = Vector3.new()
                        tool_data.gun.Springs.Rotation.WalkCycle.Position = Vector3.new()
                    end
                end

                if cheat.nobob and tool_data.gun.Sprinting then
                    tool_data.gun.Springs.Position.Offset.Target = tool_data.gun.Attributes.Offset
                    tool_data.gun.Springs.Rotation.Offset.Target = tool_data.gun.Attributes.Rotation
                    tool_data.gun.Springs.Rotation.Backwards.Target = Vector3.new(-8, 0, 0)
                    tool_data.gun.WalkCycle.WalkSpeedMultiplier = 2.25
                end
            end

            if _visual_frame % 6 == 0 then
                if cheat.arm then
                    for _, v in visual.arms do
                        v.Material = Enum.Material.ForceField
                        v.Color = cheat.armchams_color
                    end
                end

                if cheat.gun then
                    for _, v in visual.gun_model do
                        if not v:IsA("BasePart") then
                            continue
                        end

                        local surface_appearance = v:FindFirstChild("SurfaceAppearance")

                        if surface_appearance then
                            surface_appearance:Destroy()
                        end

                        v.Color = cheat.gun_chams
                        v.Material = Enum.Material.ForceField
                    end
                end
            end

            if _visual_frame % 20 == 0 then
                for c_i, item in (my_camera:FindFirstChild("Model") and my_camera.Model:GetChildren() or {}) do
                    if not My_Character:FindFirstChild(item.Name) then
                        item:Destroy()
                    end
                end
            end
        end))

        local null_vector = Vector3.new(-100, -100, -100)

        local rage = {
            loop = nil,
            truss = nil,
            truss_position = Vector3.new(-100, -100, -100),
            rayparams = RaycastParams.new(),
            old_fov = nil,
            old_ambient = nil,
            delay = 0.3,
            last_guess = tick(),
            last_hb_update = tick(),
            last_health = my_player.Character:GetAttribute("ActualHealth"),
            pause_antiaim = false,
            shooting = false,
            reset_hb = false,
        }

        local gun_module_clone = utility.deepcopy(gun_module_data)

        do
            setfflag("SimEnableStepPhysics", "True")
            setfflag("SimEnableStepPhysicsSelective", "True")

            do
                local Truss = Instance.new("TrussPart")
                Truss.Size = Vector3.new(2, 100, 2)
                Truss.Transparency = 1
                Truss.Anchored = true
                Truss.Parent = workspace.CurrentCamera

                rage.truss = Truss
                rage.rayparams.RespectCanCollide = true
            end
        end

        rage.update_player_hitbox = function()
            for _i, player in get_targeting_players() do
                if player == my_player.Character then
                    continue
                end
                local selected_hitbox = player:FindFirstChild(cheat.hitpart)
                if player and selected_hitbox then
                    local uppertorso = player:FindFirstChild("UpperTorso")
                    local head = player:FindFirstChild("Head")

                    if not uppertorso or not head then continue end

                    if not uppertorso:GetAttribute("_orig_size") then
                        uppertorso:SetAttribute("_orig_size_x", uppertorso.Size.X)
                        uppertorso:SetAttribute("_orig_size_y", uppertorso.Size.Y)
                        uppertorso:SetAttribute("_orig_size_z", uppertorso.Size.Z)
                    end
                    if not head:GetAttribute("_orig_size_x") then
                        head:SetAttribute("_orig_size_x", head.Size.X)
                        head:SetAttribute("_orig_size_y", head.Size.Y)
                        head:SetAttribute("_orig_size_z", head.Size.Z)
                    end

                    local is_target = player == framework.targeting.current
                    local bodypart = framework.targeting.bodypart

                    if not cheat.hbe or (cheat.only_expand_target and not is_target) then
                        pcall(function()
                            uppertorso.Size = Vector3.new(
                                uppertorso:GetAttribute("_orig_size_x"),
                                uppertorso:GetAttribute("_orig_size_y"),
                                uppertorso:GetAttribute("_orig_size_z")
                            )
                            uppertorso.Transparency = 0
                            head.Size = Vector3.new(
                                head:GetAttribute("_orig_size_x"),
                                head:GetAttribute("_orig_size_y"),
                                head:GetAttribute("_orig_size_z")
                            )
                            head.Transparency = 0
                        end)
                        continue
                    end

                    if cheat.hbe then
                        if is_target and bodypart then
                            bodypart.Size = Vector3.new(cheat.hbs, cheat.hbs, cheat.hbs)
                            bodypart.CanCollide = false
                            bodypart.Transparency = 0.95
                            bodypart.Massless = true
                            continue
                        end
                    end

                    if selected_hitbox then
                        selected_hitbox.Size = Vector3.new(cheat.hbs, cheat.hbs, cheat.hbs)
                        selected_hitbox.CanCollide = false
                        selected_hitbox.Transparency = 0.95
                        selected_hitbox.Massless = true
                    end
                end
            end
        end

        rage.loop = run_service.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(dt)
            local anyActive = cheat.aimbot_enabled or cheat.autoshoot
                or cheat.boost or cheat.spider or cheat.hbe or cheat.god
            if not anyActive then return end

            local gun_class = gun_handler.get_current()

            if framework.targeting.current and cheat.aimbot_enabled and cheat.aim_method == "Aimbot" and cheat.aimbind then
                local bodypart = framework.targeting.bodypart
                if bodypart then
                    local Point = utility.get_screen_pos(bodypart.CFrame.p)
                    mousemoverel(
                        (Point.X - user_input_service:GetMouseLocation().X) / (1 + (cheat.smooth / 100)),
                        (Point.Y - user_input_service:GetMouseLocation().Y) / (1 + (cheat.smooth / 100))
                    )
                end
            end

            if not rage._frame then rage._frame = 0 end
            rage._frame = rage._frame + 1
            if rage._frame % 2 ~= 0 then return end

            if gun_class.gun_data and framework.targeting.current and cheat.autoshoot and cheat.autoshootbind then
                if gun_class.gun_data.Viewmodel then
                    gun_class.gun_data.Viewmodel.Sprinting = false
                end
                local auto_reload = false

                if gun_class.type == "Bow" or gun_class.type == "SingleShot" then
                    gun_class.gun_data.Ready    = true
                    gun_class.gun_data.Reloading = true
                    gun_class.gun_data.Aiming   = true

                    local slot = gun_class.gun_data.Viewmodel and gun_class.gun_data.Viewmodel.Tool and gun_class.gun_data.Viewmodel.Tool.Slot
                    local contents = slot and inventory_module.MyInventory and inventory_module.MyInventory.Contents and inventory_module.MyInventory.Contents[slot]
                    if not auto_reload and contents and contents.Ammo and contents.Ammo < 1 then
                        network:Fire("Weapon Insert Bullet", slot, contents.AmmoType)
                    end
                end

                if not auto_reload then
                    local slot = gun_class.gun_data.Viewmodel and gun_class.gun_data.Viewmodel.Tool and gun_class.gun_data.Viewmodel.Tool.Slot
                    local contents = slot and inventory_module.MyInventory and inventory_module.MyInventory.Contents and inventory_module.MyInventory.Contents[slot]
                    if slot and contents then
                        network:Fire("Weapon Reload", slot, contents.AmmoType)
                        auto_reload = true
                    end
                end

                gun_handler.fire_current()
            end

            if cheat.Omnisprint then
                pcall(function()
                    if character_module:Get(character_module) then
                        character_module.CurrentDir = "f"
                        character_module.Sprinting = true
                        local ch = character_module.CurrentCharacter
                        if ch then
                            ch:SetAttribute("Sprinting", true)
                            local hum = ch:FindFirstChildOfClass("Humanoid")
                            if hum then hum.WalkSpeed = 18 end
                        end
                    end
                end)
            end

            if my_player and my_player.Character and cheat.god and cheat.godbind then
                local my_health = character_module.CurrentCharacter:FindFirstChild("Humanoid")
                if my_health and rage.last_health ~= my_health.Health then
                    local new_hp = 100 - my_health.Health

                    if my_health.Health < 50 then
                        network:Fire("TFD", math.clamp(new_hp, 1, 100) * -1)
                    end

                    rage.last_health = my_health.Health
                end
            end
            if tick() - rage.last_hb_update >= 0.5 then
                if cheat.hbe then
                    rage.update_player_hitbox()
                end
                rage.last_hb_update = tick()
            end

            if not rage._last_rpm or rage._last_rpm ~= (cheat.rapidfire and cheat.rpm or 0) or rage._last_spread ~= (cheat.spread_toggle and cheat.spread or 0) or rage._last_recoil ~= (cheat.recoil_toggle and cheat.recoilamount or 0) then
                rage._last_rpm = cheat.rapidfire and cheat.rpm or 0
                rage._last_spread = cheat.spread_toggle and cheat.spread or 0
                rage._last_recoil = cheat.recoil_toggle and cheat.recoilamount or 0
                for weapon_id, weapon_data in gun_module_data do
                    if type(weapon_data) ~= "table" then continue end
                    local clone = gun_module_clone[weapon_id]
                    if not clone then continue end
                    if weapon_data.RPM and clone.RPM then
                        weapon_data.RPM = clone.RPM * (1 + ((cheat.rapidfire and (cheat.rpm or 1) or 1) / 100))
                    end
                    if weapon_data.Spread and clone.Spread then
                        weapon_data.Spread = clone.Spread * (cheat.spread_toggle and math.max(0, 1 - (cheat.spread or 0) / 100) or 1)
                    end
                end
            end
            if recoil_upvalues and recoil_upvalues.RecoilSpring then
                local rmult = (cheat.recoil_toggle and math.max(0, 1 - (cheat.recoilamount or 0) / 100) or 1)
                recoil_upvalues.RecoilSpring._multiplier = rmult
            end

            if cheat.boost and cheat.boostbind then
                if my_player and my_player.Character then
                    local hrp = my_player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = my_player.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum then
                        local moveDir = hum.MoveDirection
                        if moveDir.Magnitude >= 0.1 then
                            local multiplier = math.clamp((cheat.speed or 1) - 1, 0, 19)
                            if multiplier > 0 then
                                local nudge = math.min(multiplier * 0.45 * (dt / (1/60)), 0.45)
                                local flatDir = Vector3.new(moveDir.X, 0, moveDir.Z).Unit
                                hrp.CFrame = hrp.CFrame + flatDir * nudge
                            end
                        end
                    end
                end
            end

            if cheat.spider and cheat.spiderbind and my_player.Character then
                local root = my_player.Character.PrimaryPart
                local humnaoid = my_player.Character.Humanoid

                if root and root.CollisionGroup and root.CollisionGroup ~= nil then
                    rage.rayparams.FilterDescendantsInstances = { workspace.CurrentCamera, my_player.Character, rage.truss }
                    rage.rayparams.CollisionGroup = root.CollisionGroup

                    local ray = workspace:Raycast(
                        root.Position - Vector3.new(0, humnaoid.HipHeight - 0.5, 0),
                        root.CFrame.LookVector * 2,
                        rage.rayparams
                    )

                    if ray and rage.truss_position == null_vector then
                        rage.truss_position = ray.Position - ray.Normal * 0.9 or null_vector
                        rage.truss.Position = ray.Position - ray.Normal * 0.9 or null_vector
                    elseif rage.truss_position ~= null_vector and not ray then
                        rage.truss_position = null_vector
                        rage.truss.Position = null_vector
                    end
                end
            else
                rage.truss.Position = null_vector
            end
        end))

        local _original_task_spawn = getrenv().task.spawn
        local _original_task_wait  = getrenv().task.wait

        local desync = {
            loop = nil,
            aimbot_pause = false,
            pausetick = tick(),
            current_pos = CFrame.new(0, 0, 0),
        }

        function desync.pause(time)
            if desync.aimbot_pause then
                desync.aimbot_pause = true
                return
            end
            desync.aimbot_pause = true
            _original_task_wait(time)
            desync.aimbot_pause = false
        end

        desync.loop = run_service.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
            if not cheat.spin and not (cheat.aimbot_enabled and cheat.aim_method == "Silent Aim") then
                return
            end
            if not character_module:Get(character_module) then
                return
            end
            local My_Character = character_module.CurrentCharacter
            local Old_Position = My_Character.HumanoidRootPart.CFrame
            local newCFrame = Old_Position

            if
                cheat.aimbot_enabled
                and cheat.aim_method == "Silent Aim"
                and framework.targeting.current
                and desync.aimbot_pause
            then
                if framework.targeting.bodypart then
                    local origin = My_Character.HumanoidRootPart.Position
                    local target = framework.targeting.bodypart.Position

                    local direction = (target - origin).Unit
                    local angle = math.atan2(direction.X, direction.Z)

                    newCFrame = CFrame.new(origin) * CFrame.Angles(0, -angle, 0)

                    My_Character.HumanoidRootPart.CFrame = newCFrame
                    run_service.RenderStepped:Wait()
                    My_Character.HumanoidRootPart.CFrame = Old_Position

                    return
                end
            end


            if cheat.spin then
                if not desync._spin_accum then desync._spin_accum = 0 end
                desync._spin_accum = desync._spin_accum + (cheat.spinspeed or 1) * dt * 0.5
                local spinAngle = math.rad(desync._spin_accum)
                newCFrame = Old_Position * CFrame.Angles(0, spinAngle, 0)
            end

            My_Character.HumanoidRootPart.CFrame = newCFrame
            if not cheat.spin then
                run_service.RenderStepped:Wait()
                My_Character.HumanoidRootPart.CFrame = Old_Position
            end
        end))
        -- hitscan indicator removed

        local rebuilds = {
            projectile_module = {
                arrow_rebuilt = nil,
                bullet_rebuilt = nil,
                throwable_rebuilt = nil,
            },
            viewmodel_module = {
                equip_intercepter = nil,
            },
        }

        function equip_intercepter(old_equip, ...)
            local current_weapon = old_equip(...)
            if not current_weapon or not current_weapon.ViewmodelBehavior then
                return current_weapon
            end

            local behavior_name = current_weapon.ViewmodelBehavior
            if behavior_name:find("Harvesting") or behavior_name:find("Melee") or behavior_name:find("Throwable") then
                return current_weapon
            end

            local vm_script = viewmodel_module:FindFirstChild(behavior_name)
            if not vm_script then return current_weapon end

            local ok, vm_behavior = pcall(require, vm_script)
            if not ok or type(vm_behavior) ~= "table" then return current_weapon end

            local behavior_data = gun_handler.generate_data(behavior_name, vm_behavior, current_weapon)

            vm_behavior.New = function(...)
                return behavior_data
            end

            gun_handler.Current_Weapon = current_weapon
            gun_handler.Current_Weapon_Behavior = behavior_data
            gun_handler.Current_Weapon_Type = behavior_name

            return current_weapon
        end

        function sprint_intercepter(character_module, spriting_var)
            local script_trace = debug.traceback()

            if
                cheat.Omnisprint
                and character_module:IsMoving(character_module)
                and user_input_service:IsKeyDown(settings.Keybinds.Sprint.Keyboard)
                and not spriting_var
            then
                return
            end

            character_module.Sprinting = spriting_var
            if character_module.Downed then
                spriting_var = false
            end

            if
                spriting_var
                and not character_module.Crouching
                and (character_module.CurrentDir == "f" or cheat.Omnisprint)
            then
                camera_module:ChangeFOV(settings.General.DefaultFOV + 5, 0.1)
                character_module.CurrentCharacter.Humanoid.WalkSpeed = 18
                    - (character_module.CurrentCharacter:GetAttribute("WalkSpeedReduction") or 0)
                character_module:StopEmotes(true)
                character_module.Sprinting = true
                character_module.CurrentCharacter:SetAttribute("Sprinting", character_module.Sprinting)
            else
                character_module.Autorunning = false
                camera_module:ChangeFOV(settings.General.DefaultFOV, 0.1)
                if not character_module.Downed then
                    character_module.CurrentCharacter.Humanoid.WalkSpeed = character_module.CurrentCharacter:GetAttribute(
                        "Slowed"
                    ) and 2 or (character_module.Crouching and 6 - (character_module.CurrentCharacter:GetAttribute(
                        "WalkSpeedReduction"
                    ) or 0) or 12 - (character_module.CurrentCharacter:GetAttribute("WalkSpeedReduction") or 0))
                end
                character_module.Sprinting = false
                character_module.CurrentCharacter:SetAttribute("Sprinting", character_module.Sprinting)
            end

            character_module.CurrentCharacter:SetAttribute("Sprinting", spriting_var)
            network:Fire("Change Sprinting State", spriting_var)
        end

        function grounded_custom(p33)
            if p33.CurrentCharacter then
                local v34 = RaycastParams.new()
                v34.FilterType = Enum.RaycastFilterType.Exclude
                v34.FilterDescendantsInstances = { p33.CurrentCharacter }
                if
                    workspace:Blockcast(
                        p33.CurrentCharacter.PrimaryPart.CFrame,
                        p33.CurrentCharacter.PrimaryPart.Size,
                        Vector3.new(0, -2, 0),
                        v34
                    )
                then
                    return true
                end
            end
            return false
        end

        do
            local character_sprint_hook
            character_sprint_hook = hookfunction(
                character_module.Sprint,
                LPH_NO_UPVALUES(function(...)
                    return sprint_intercepter(...)
                end)
            )

            local equip_weapon_hook
            equip_weapon_hook = hookfunction(
                viewmodel_module_data.New,
                LPH_NO_UPVALUES(function(...)
                    return equip_intercepter(equip_weapon_hook, ...)
                end)
            )
        end

        -- hitscan task removed
        -- task_spawn_hook removed (was hitscan/forcehit)

        do
            network_fire = network.Fire

            network.Fire = function(self, ...)
                local data = { ... }

                if data[1] == "Update Look" then
                    return
                end

                if
                    data[1] == "Simulate Projectile"
                    and cheat.aimbot_enabled
                    and cheat.aim_method == "Silent Aim"
                    and framework.targeting.current
                then
                    _original_task_spawn(function()
                        desync.pause(0.5)
                    end)
                end

                if data[1] == "TFD" and cheat.nofall then
                    return
                end

                if data[1] == "Melee Hit" and cheat.pfarm then
                    for i = 2, #data do
                        if typeof(data[i]) == "Instance" then
                            local found_marker = data[i]:FindFirstChild("Marker")
                            if found_marker then
                                data[2] = found_marker
                                data[3] = found_marker.CFrame
                                data[9] = true
                                break
                            end
                        end
                    end
                end


                return network_fire(self, unpack(data))
            end
        end

        getgenv().Unload5 = function()
            pcall(function()
                if isfunctionhooked(viewmodel_module_data.New) then
                    restorefunction(viewmodel_module_data.New)
                end

                if isfunctionhooked(character_module.Sprint) then
                    restorefunction(character_module.Sprint)
                end

                if isfunctionhooked(task.spawn) then
                    restorefunction(task.spawn)
                end

                pcall(function() EspInterface.Unload() end)
                if visual.loop then visual.loop:Disconnect() end
                if SettingsPage then
                    for _, item in pairs(SettingsPage) do
                        if type(item) == "table" and item.Press then
                            item.Press = function() end
                        end
                    end
                end
            end)
        end
    end
end

getgenv().__ls_hub_fn = runMain
runMain()
