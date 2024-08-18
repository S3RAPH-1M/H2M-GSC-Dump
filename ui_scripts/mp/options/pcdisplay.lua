local pcdisplay = luiglobals.require("LUI.PCDisplay")

pcdisplay.CreateOptions = function(menu)
    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select, "@LUA_MENU_COLORBLIND_FILTER",
        "@LUA_MENU_COLOR_BLIND_DESC", LUI.Options.GetRenderColorBlindText, LUI.Options.RenderColorBlindToggle,
        LUI.Options.RenderColorBlindToggle)

    --[[
    if Engine.IsMultiplayer() and Engine.GetDvarType("cg_paintballFx") == DvarTypeTable.DvarBool then
        LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select,
            "@LUA_MENU_PAINTBALL", "@LUA_MENU_PAINTBALL_DESC",
            LUI.Options.GetDvarEnableTextFunc("cg_paintballFx", false), LUI.Options.ToggleDvarFunc("cg_paintballFx"),
            LUI.Options.ToggleDvarFunc("cg_paintballFx"))
    end
    ]] --

    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select, "@LUA_MENU_BLOOD",
        "@LUA_MENU_BLOOD_DESC", LUI.Options.GetDvarEnableTextFunc("cg_blood", false), LUI.Options
            .ToggleProfiledataFunc("showblood", Engine.GetControllerForLocalClient(0)), LUI.Options
            .ToggleProfiledataFunc("showblood", Engine.GetControllerForLocalClient(0)))

    --[[
    if not Engine.IsMultiplayer() then
        LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select,
            "@LUA_MENU_CROSSHAIR", "@LUA_MENU_CROSSHAIR_DESC",
            LUI.Options.GetDvarEnableTextFunc("cg_drawCrosshairOption", false),
            LUI.Options.ToggleDvarFunc("cg_drawCrosshairOption"), LUI.Options.ToggleDvarFunc("cg_drawCrosshairOption"))

        LUI.Options.CreateOptionButton(menu, "cg_drawDamageFeedbackOption", "@LUA_MENU_HIT_MARKER",
            "@LUA_MENU_HIT_MARKER_DESC", {{
                text = "@LUA_MENU_ENABLED",
                value = true
            }, {
                text = "@LUA_MENU_DISABLED",
                value = false
            }})
    end
    ]] --
    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select, "@MENU_DISPLAY_MEDAL_SPLASHES",
        "@MENU_DISPLAY_MEDAL_SPLASHES_DESC", pcdisplay.GetDisplayMedalSplashesText,
        pcdisplay.DisplayMedalSplashesToggle, pcdisplay.DisplayMedalSplashesToggle)

    --[[
    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select, "@MENU_DISPLAY_WEAPON_EMBLEMS",
        "@MENU_DISPLAY_WEAPON_EMBLEMS_DESC", pcdisplay.GetDisplayWeaponEmblemsText,
        pcdisplay.DisplayWeaponEmblemsToggle, pcdisplay.DisplayWeaponEmblemsToggle)
    ]]--

   --[[ TODO: LUI.Options.CreateOptionButton(menu, "cg_xpbar", "@LUA_XPBAR_CAPS", "@LUA_XPBAR_CAPS", {{
        text = "@LUA_MENU_ENABLED",
        value = true
    }, {
        text = "@LUA_MENU_DISABLED",
        value = false
    }}, nil, nil, function(value)
        Engine.SetDvarBool("cg_xpbar", value)
    end) ]]

    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Common, "@MENU_BRIGHTNESS",
        "@MENU_BRIGHTNESS_DESC1", nil, nil, nil, pcdisplay.OpenBrightnessMenu, nil, nil, nil)

    local reddotbounds = {
        step = 0.2,
        max = 4,
        min = 0.2
    }

    createdivider(menu, Engine.Localize("@LUA_MENU_TELEMETRY"))

    LUI.Options.CreateOptionButton(menu, "cg_infobar_ping", "@LUA_MENU_LATENCY", "@LUA_MENU_LATENCY_DESC", {{
        text = "@LUA_MENU_ENABLED",
        value = true
    }, {
        text = "@LUA_MENU_DISABLED",
        value = false
    }}, nil, nil, function(value)
        Engine.SetDvarBool("cg_infobar_ping", value)
        Engine.GetLuiRoot():processEvent({
            name = "update_hud_infobar_settings"
        })
    end)

    LUI.Options.CreateOptionButton(menu, "cg_infobar_fps", "@LUA_MENU_FPS", "@LUA_MENU_FPS_DESC", {{
        text = "@LUA_MENU_ENABLED",
        value = true
    }, {
        text = "@LUA_MENU_DISABLED",
        value = false
    }}, nil, nil, function(value)
        Engine.SetDvarBool("cg_infobar_fps", value)
        Engine.GetLuiRoot():processEvent({
            name = "update_hud_infobar_settings"
        })
    end)

    LUI.Options.CreateOptionButton(menu, "cg_infobar_streak", "@MENU_KILLSTREAK_CAPS", "@LUA_MENU_STREAK_DESC", {{
        text = "@LUA_MENU_ENABLED",
        value = true
    }, {
        text = "@LUA_MENU_DISABLED",
        value = false
    }}, nil, nil, function(value)
        Engine.SetDvarBool("cg_infobar_streak", value)
        Engine.GetLuiRoot():processEvent({
            name = "update_hud_infobar_settings"
        })
    end)

    LUI.Options.InitScrollingList(menu.list, nil)
end
