LUI.PCOptionsMenu = {}
LUI.PCGraphicOptions = {}
LUI.PCGraphicOptions.Categories = {}
LUI.PCGraphicOptions.Categories[#LUI.PCGraphicOptions.Categories + 1] = {
    title = "@LUA_MENU_DISPLAY_OPTIONS",
    menuType = "pc_display"
}
LUI.PCGraphicOptions.Categories[#LUI.PCGraphicOptions.Categories + 1] = {
    title = "@LUA_MENU_VIDEO_OPTIONS",
    menuType = "pc_video"
}
LUI.PCGraphicOptions.Categories[#LUI.PCGraphicOptions.Categories + 1] = {
    title = "@LUA_MENU_ADVANCED_VIDEO",
    menuType = "advanced_video"
}
LUI.PCGraphicOptions.FindTypeIndex = function(f1_arg0)
    for f1_local3, f1_local4 in ipairs(LUI.PCGraphicOptions.Categories) do
        if f1_local4.menuType == f1_arg0 then
            return f1_local3
        end
    end
    return 0
end

LUI.PCGraphicOptions.LoadMenu = function(f2_arg0, f2_arg1, f2_arg2)
    LUI.FlowManager.RequestAddMenu(f2_arg0, LUI.PCGraphicOptions.Categories[f2_arg2].menuType, true, f2_arg1.controller,
        true)
    CoD.PlayEventSound(CoD.SFX.H1TabChange, 10)
end

LUI.PCControlOptions = {}
LUI.PCControlOptions.Categories = {}
LUI.PCControlOptions.Categories[#LUI.PCControlOptions.Categories + 1] = {
    title = "@LUA_MENU_MOVEMENT",
    menuType = "movement_controls"
}
LUI.PCControlOptions.Categories[#LUI.PCControlOptions.Categories + 1] = {
    title = "@LUA_MENU_ACTIONS",
    menuType = "actions_controls"
}
LUI.PCControlOptions.Categories[#LUI.PCControlOptions.Categories + 1] = {
    title = "@LUA_MENU_LOOK",
    menuType = "look_controls"
}
if Engine.IsMultiplayer() then
    LUI.PCControlOptions.Categories[#LUI.PCControlOptions.Categories + 1] = {
        title = "@LUA_MENU_CHAT",
        menuType = "chat_controls"
    }
end
LUI.PCControlOptions.Categories[#LUI.PCControlOptions.Categories + 1] = {
    title = "@LUA_MENU_GAMEPAD",
    menuType = "gamepad_controls"
}
LUI.PCControlOptions.IsCategoryDisabled = function(f3_arg0)
    if LUI.PCControlOptions.FindTypeIndex("gamepad_controls") == f3_arg0 then
        return false
    else
        return Engine.IsGamepadEnabled()
    end
end

LUI.PCControlOptions.FindTypeIndex = function(f4_arg0)
    for f4_local3, f4_local4 in ipairs(LUI.PCControlOptions.Categories) do
        if f4_local4.menuType == f4_arg0 then
            return f4_local3
        end
    end
    return 0
end

LUI.PCControlOptions.LoadMenu = function(f5_arg0, f5_arg1, f5_arg2)
    LUI.FlowManager.RequestAddMenu(f5_arg0, LUI.PCControlOptions.Categories[f5_arg2].menuType, true, f5_arg1.controller,
        true)
    CoD.PlayEventSound(CoD.SFX.H1TabChange, 10)
end

LUI.PCControlOptions.ResetToDefault = function(f6_arg0, f6_arg1)
    LUI.FlowManager.RequestAddMenu(f6_arg0, "reset_controls", false, f6_arg1.controller)
end

LUI.PCControlOptions.AddResetToDefaultButton = function(f7_arg0)
    f7_arg0:AddHelp({
        name = "add_button_helper_text",
        button_ref = "button_alt1",
        helper_text = Engine.Localize("@LUA_MENU_RESTORE_DEFAULT_CONTROLS"),
        side = "right",
        clickable = true
    }, LUI.PCControlOptions.ResetToDefault)
end

LUI.PCControlOptions.OptimalVideo = function(f8_arg0, f8_arg1)
    LUI.FlowManager.RequestAddMenu(f8_arg0, "optimal_notice", false, f8_arg1.controller)
end

LUI.PCControlOptions.AddOptimalVideoButton = function(f9_arg0)
    f9_arg0:AddHelp({
        name = "add_button_helper_text",
        button_ref = "button_alt1",
        helper_text = Engine.Localize("@LUA_MENU_OPTIMAL_VIDEO_AUDIO"),
        side = "right",
        clickable = true
    }, LUI.PCControlOptions.OptimalVideo)
end

function OnVideoChange(f10_arg0, f10_arg1)
    TransferSettingsToUI()
    local f10_local0 = Engine.GetLuiRoot()
    local f10_local1 = f10_local0:getFirstDescendentById("pc_controls_window_content")
    f10_local1:processEvent({
        name = "menu_refresh"
    })
end

function SetDvarValue(f11_arg0, f11_arg1)
    if Engine.GetDvarType(f11_arg0) == nil then
        Engine.SetDvarFromString(f11_arg0, tostring(f11_arg1))
    elseif Engine.GetDvarType(f11_arg0) == DvarTypeTable.DvarInt then
        Engine.SetDvarInt(f11_arg0, tonumber(f11_arg1))
    elseif Engine.GetDvarType(f11_arg0) == DvarTypeTable.DvarFloat then
        Engine.SetDvarFloat(f11_arg0, tonumber(f11_arg1))
    elseif Engine.GetDvarType(f11_arg0) == DvarTypeTable.DvarBool then
        if type(f11_arg1) == "boolean" then
            Engine.SetDvarBool(f11_arg0, f11_arg1)
        elseif type(f11_arg1) == "string" and f11_arg1 == "true" then
            Engine.SetDvarBool(f11_arg0, true)
        elseif type(f11_arg1) == "string" and f11_arg1 == "false" then
            Engine.SetDvarBool(f11_arg0, false)
        else
            Engine.SetDvarBool(f11_arg0, tonumber(f11_arg1) ~= 0)
        end
    elseif Engine.GetDvarType(f11_arg0) == DvarTypeTable.DvarEnum then
        if type(f11_arg1) == "string" then
            Engine.SetDvarString(f11_arg0, f11_arg1)
        else
            Engine.SetDvarInt(f11_arg0, f11_arg1)
        end
    elseif Engine.GetDvarType(f11_arg0) == DvarTypeTable.DvarString then
        Engine.SetDvarString(f11_arg0, tostring(f11_arg1))
    else
        DebugPrint(
            "WARNING: Unsupported SetDvarValue type " .. tostring(Engine.GetDvarType(f11_arg0)) .. " for dvar " ..
                f11_arg0)
    end
end

function GetDvarValue(f12_arg0)
    if Engine.GetDvarType(f12_arg0) == DvarTypeTable.DvarInt then
        return tostring(Engine.GetDvarInt(f12_arg0))
    elseif Engine.GetDvarType(f12_arg0) == DvarTypeTable.DvarFloat then
        return tostring(Engine.GetDvarFloat(f12_arg0))
    elseif Engine.GetDvarType(f12_arg0) == DvarTypeTable.DvarBool then
        return tostring(Engine.GetDvarBool(f12_arg0))
    elseif Engine.GetDvarType(f12_arg0) == DvarTypeTable.DvarEnum then
        return Engine.GetDvarString(f12_arg0)
    elseif Engine.GetDvarType(f12_arg0) == DvarTypeTable.DvarString then
        return Engine.GetDvarString(f12_arg0)
    else
        DebugPrint(
            "WARNING: Unsupported GetDvarValue type " .. tostring(Engine.GetDvarType(f12_arg0)) .. " for dvar " ..
                f12_arg0)
        return ""
    end
end

function TransferSettingsToUI()
    DebugPrint("TransferSettingsToUI")
    local f13_local0 = Engine.GetDvarBool("r_fullscreen")
    local f13_local1 = false
    if Engine.IsPCApp() then
        if f13_local0 then
            SetDvarValue("ui_r_displayMode", "fullscreen")
        else
            SetDvarValue("ui_r_displayMode", "windowed")
        end
    else
        f13_local1 = Engine.GetDvarBool("r_fullscreenWindow")
        if f13_local0 and not f13_local1 then
            SetDvarValue("ui_r_displayMode", "fullscreen")
        elseif f13_local0 and f13_local1 then
            SetDvarValue("ui_r_displayMode", "windowed_no_border")
        elseif not f13_local0 then
            SetDvarValue("ui_r_displayMode", "windowed")
        end
    end
    if f13_local0 and not f13_local1 then
        SetDvarValue("ui_r_mode", GetDvarValue("r_mode"))
    else
        SetDvarValue("ui_r_mode", Engine.GetDisplayWidth() .. " " .. Engine.GetDisplayHeight())
    end
    SetDvarValue("ui_r_adapter", GetDvarValue("r_adapter"))
    if not Engine.IsPCApp() then
        SetDvarValue("ui_r_monitor", GetDvarValue("r_monitor"))
        SetDvarValue("ui_r_refreshRate", GetDvarValue("r_refreshRate"))
        SetDvarValue("ui_r_aspectratio", GetDvarValue("r_aspectratio"))
    end
    SetDvarValue("ui_r_vsync", GetDvarValue("r_vsync"))
    if Engine.IsMultiplayer() then
        SetDvarValue("ui_cg_fov", GetDvarValue("cg_fov"))
    end
    -- SetDvarValue( "ui_cg_drawFPS", GetDvarValue( "cg_drawFPS" ) )
    SetDvarValue("ui_r_letterboxAspectRatio", GetDvarValue("r_letterboxAspectRatio"))
    Engine.SetDvarBool("ui_r_renderResolutionNative", Engine.GetDvarBool("r_renderResolutionNative"), true)
    Engine.SetDvarInt("ui_r_renderResolution", Engine.GetDvarFloat("r_renderResolution") * 1000000, true)
    SetDvarValue("ui_r_fill_texture_memory", GetDvarValue("r_fill_texture_memory"))
    SetDvarValue("ui_r_picmip", GetDvarValue("r_picmip"))
    SetDvarValue("ui_r_picmip_bump", GetDvarValue("r_picmip_bump"))
    SetDvarValue("ui_r_picmip_spec", GetDvarValue("r_picmip_spec"))
    SetDvarValue("ui_r_texFilterAnisoMin", GetDvarValue("r_texFilterAnisoMin"))
    SetDvarValue("ui_sm_enable", GetDvarValue("sm_enable"))
    SetDvarValue("ui_sm_tileResolution", GetDvarValue("sm_tileResolution"))
    SetDvarValue("ui_sm_cacheSunShadow", GetDvarValue("sm_cacheSunShadow"))
    SetDvarValue("ui_sm_cacheSpotShadows", GetDvarValue("sm_cacheSpotShadows"))
    SetDvarValue("ui_r_dof_limit", GetDvarValue("r_dof_limit"))
    SetDvarValue("ui_r_mbLimit", GetDvarValue("r_mbLimit"))
    SetDvarValue("ui_r_ssaoLimit", GetDvarValue("r_ssaoLimit"))
    SetDvarValue("ui_r_mdaoLimit", GetDvarValue("r_mdaoLimit"))
    SetDvarValue("ui_r_sssLimit", GetDvarValue("r_sssLimit"))
    SetDvarValue("ui_r_depthPrepass", GetDvarValue("r_depthPrepass"))
    SetDvarValue("ui_r_postAA", GetDvarValue("r_postAA"))
    SetDvarValue("ui_r_ssaaSamples", GetDvarValue("r_ssaaSamples"))
    SetDvarValue("ui_r_preloadShaders", GetDvarValue("r_preloadShaders"))
    SetDvarValue("ui_r_preloadShadersAfterCinematic", GetDvarValue("r_preloadShadersAfterCinematic"))
    SetDvarValue("ui_r_preloadShadersFrontendAllow", GetDvarValue("r_preloadShadersFrontendAllow"))
    SetDvarValue("ui_fx_marks", GetDvarValue("fx_marks"))
    SetDvarValue("ui_r_dlightForceLimit", GetDvarValue("r_dlightForceLimit"))
end

function LUI.PCOptions.TransferSettingsToGame()
    DebugPrint("TransferSettingsToGame")
    local f14_local0 = GetDvarValue("ui_r_displayMode")
    if Engine.IsPCApp() then
        if f14_local0 == "fullscreen" then
            SetDvarValue("r_fullscreen", true)
        elseif f14_local0 == "windowed" then
            SetDvarValue("r_fullscreen", false)
        else
            DebugPrint("WARNING: Unsupported display mode " .. f14_local0)
        end
    elseif f14_local0 == "fullscreen" then
        SetDvarValue("r_fullscreen", true)
        SetDvarValue("r_fullscreenWindow", false)
    elseif f14_local0 == "windowed_no_border" then
        SetDvarValue("r_fullscreen", true)
        SetDvarValue("r_fullscreenWindow", true)
    elseif f14_local0 == "windowed" then
        SetDvarValue("r_fullscreen", false)
    else
        DebugPrint("WARNING: Unsupported display mode " .. f14_local0)
    end
    local f14_local1 = Engine.GetDvarString("ui_r_mode")
    if f14_local0 == "fullscreen" then
        SetDvarValue("r_mode", f14_local1)
    end
    SetDvarValue("r_adapter", Engine.GetDvarString("ui_r_adapter"))
    if not Engine.IsPCApp() then
        SetDvarValue("r_monitor", Engine.GetDvarString("ui_r_monitor"))
        SetDvarValue("r_refreshRate", Engine.GetDvarString("ui_r_refreshRate"))
        SetDvarValue("r_aspectratio", Engine.GetDvarString("ui_r_aspectratio"))
    end
    SetDvarValue("r_vsync", Engine.GetDvarString("ui_r_vsync"))
    if Engine.IsMultiplayer() then
        SetDvarValue("cg_fov", Engine.GetDvarString("ui_cg_fov"))
    end
    -- SetDvarValue( "cg_drawFPS", Engine.GetDvarInt( "ui_cg_drawFPS" ) )
    local f14_local2 = Engine.GetDvarString("ui_r_letterboxAspectRatio")
    if f14_local0 == "windowed" then
        if not Engine.IsPCApp() and f14_local2 ~= Engine.GetDvarString("r_letterboxAspectRatio") and f14_local2 ~=
            "auto" then
            local f14_local3 = {
                standard = 1.33,
                ["wide 16:10"] = 1.6,
                ["wide 16:9"] = 1.78,
                ["wide 21:9"] = 2.37
            }
            local f14_local4 = f14_local3[f14_local2]
            local f14_local5 = LUI.StringSplit(f14_local1, " ")
            local f14_local6 = tonumber(f14_local5[1])
            local f14_local7 = tonumber(f14_local5[2])
            if f14_local6 / f14_local7 ~= f14_local4 then
                f14_local7 = math.floor(math.sqrt(f14_local6 * f14_local7 / f14_local4) + 0.5)
                f14_local1 = math.floor(f14_local7 * f14_local4 + 0.5) .. " " .. f14_local7
            end
        end
        Engine.Exec("window " .. f14_local1)
    end
    SetDvarValue("r_letterboxAspectRatio", f14_local2)
    Engine.SetDvarBool("r_renderResolutionNative", Engine.GetDvarBool("ui_r_renderResolutionNative"))
    Engine.SetDvarFloat("r_renderResolution", Engine.GetDvarInt("ui_r_renderResolution") / 1000000)
    SetDvarValue("r_fill_texture_memory", Engine.GetDvarString("ui_r_fill_texture_memory"))
    SetDvarValue("r_picmip", Engine.GetDvarString("ui_r_picmip"))
    SetDvarValue("r_picmip_bump", Engine.GetDvarString("ui_r_picmip_bump"))
    SetDvarValue("r_picmip_spec", Engine.GetDvarString("ui_r_picmip_spec"))
    SetDvarValue("r_texFilterAnisoMin", Engine.GetDvarString("ui_r_texFilterAnisoMin"))
    SetDvarValue("sm_enable", Engine.GetDvarString("ui_sm_enable"))
    SetDvarValue("sm_tileResolution", Engine.GetDvarString("ui_sm_tileResolution"))
    SetDvarValue("sm_cacheSunShadow", Engine.GetDvarString("ui_sm_cacheSunShadow"))
    SetDvarValue("sm_cacheSpotShadows", Engine.GetDvarString("ui_sm_cacheSpotShadows"))
    SetDvarValue("r_dof_limit", Engine.GetDvarString("ui_r_dof_limit"))
    SetDvarValue("r_mbLimit", Engine.GetDvarString("ui_r_mbLimit"))
    SetDvarValue("r_ssaoLimit", Engine.GetDvarString("ui_r_ssaoLimit"))
    SetDvarValue("r_mdaoLimit", Engine.GetDvarString("ui_r_mdaoLimit"))
    SetDvarValue("r_sssLimit", Engine.GetDvarString("ui_r_sssLimit"))
    SetDvarValue("r_depthPrepass", Engine.GetDvarString("ui_r_depthPrepass"))
    SetDvarValue("r_postAA", Engine.GetDvarString("ui_r_postAA"))
    SetDvarValue("r_ssaaSamples", Engine.GetDvarString("ui_r_ssaaSamples"))
    SetDvarValue("r_preloadShaders", Engine.GetDvarString("ui_r_preloadShaders"))
    SetDvarValue("r_preloadShadersAfterCinematic", Engine.GetDvarString("ui_r_preloadShadersAfterCinematic"))
    SetDvarValue("r_preloadShadersFrontendAllow", Engine.GetDvarString("ui_r_preloadShadersFrontendAllow"))
    SetDvarValue("fx_marks", Engine.GetDvarString("ui_fx_marks"))
    SetDvarValue("r_dlightForceLimit", Engine.GetDvarString("ui_r_dlightForceLimit"))
end

function optimal_notice(f15_arg0, f15_arg1)
    return LUI.MenuBuilder.BuildRegisteredType("generic_yesno_popup", {
        popup_title = Engine.Localize("@MENU_RESET_SYSTEM_DEFAULTS"),
        message_text = Engine.Localize("@MENU_RESTORE_DEFAULTS"),
        yes_action = function(f16_arg0, f16_arg1)
            Engine.SetRecommended()
            Engine.Exec("wait; wait; r_applyPicmip;")
        end,
        no_action = function(f17_arg0, f17_arg1)
            DebugPrint("Running generic_onfirmation_popup no action")
        end,
        yes_text = Engine.Localize("@LUA_MENU_YES"),
        no_text = Engine.Localize("@LUA_MENU_NO")
    })
end

function PCOptionsMainClose(f18_arg0, f18_arg1)
    Engine.ExecNow("profile_menuDvarsFinish")
    Engine.Exec("updategamerprofile")
end

function InGameDisabledFunc(f19_arg0, f19_arg1)
    local f19_local0
    if Engine.CanVidRestart() then
        f19_local0 = Engine.IsMultiplayer()
        if f19_local0 then
            f19_local0 = not Engine.InFrontend()
        end
    else
        f19_local0 = true
    end
    return f19_local0
end

function SinglePlayerDisabled(f20_arg0, f20_arg1)
    return not Engine.IsMultiplayer()
end

function SinglePlayerVoiceDisable(f21_arg0, f21_arg1)
    if SinglePlayerDisabled(f21_arg0, f21_arg1) then
        f21_arg0:processEvent({
            name = "disable"
        })
    end
end

function ResetControlsYesAction(f22_arg0, f22_arg1)
    if Engine.IsGamepadEnabled() then
        local f22_local0 = f22_arg1.controller
        Engine.ExecNow("profile_setSticksConfig thumbstick_default", f22_local0)
        Engine.ExecNow("profile_setButtonsConfig buttons_default", f22_local0)
        Engine.ExecNow("profile_toggleInvertedPitch 0", f22_local0)
        Engine.ExecNow("profile_toggleInvertedFlightPitch 0", f22_local0)
        Engine.ExecNow("profile_toggleRumble 1", f22_local0)
        Engine.ExecNow("profile_toggleLean 1", f22_local0)
        Engine.ExecNow("profile_toggleAutoAim 1", f22_local0)
        Engine.ExecNow("profile_toggleAutoWeaponSwitch 1", f22_local0)
        Engine.MenuDvarsFinish(f22_local0)
        Engine.SetProfileData("viewSensitivityPitch", 3, f22_local0)
        Engine.SetProfileData("viewSensitivityYaw", 3, f22_local0)
        Engine.Exec("updategamerprofile")
    elseif Engine.GetCurrentLanguage() ~= 1 then
        Engine.Exec("exec default_smp_controls.cfg")
    else
        f22_arg0:dispatchEventToRoot({
            name = "check_switch_to_azerty",
            resetControl = true
        })
    end
end

function reset_controls(f23_arg0, f23_arg1)
    return LUI.MenuBuilder.BuildRegisteredType("generic_yesno_popup", {
        popup_title = Engine.Localize("@LUA_MENU_SET_DEFAULT_CONTROLS"),
        message_text = Engine.Localize("@LUA_MENU_RESTORE_EACH_SETTING_CONSOLE"),
        yes_action = ResetControlsYesAction,
        no_action = function(f24_arg0, f24_arg1)
            DebugPrint("Running generic_confirmation_popup no action")
        end,
        yes_text = Engine.Localize("@LUA_MENU_YES"),
        no_text = Engine.Localize("@LUA_MENU_CANCEL")
    })
end

function openSystemInfo(f25_arg0, f25_arg1)
    local f25_local0 = 360
    if Engine.IsMultiplayer() then
        f25_local0 = 150
    end
    LUI.FlowManager.RequestAddMenu(f25_arg0, "SystemInfo", true, f25_arg1.controller, false, {
        menu_height = f25_local0
    })
end

local function pc_controls(f26_arg0, f26_arg1)
    local f26_local0 = LUI.MenuTemplate.new(f26_arg0, {
        menu_title = Engine.ToUpperCase(Engine.Localize("@LUA_MENU_OPTIONS_UPPER_CASE")),
        menu_top_indent = Engine.IsMultiplayer() and 0 or LUI.MenuTemplate.spMenuOffset
    })
    f26_local0:AddButton("@LUA_MENU_GRAPHIC_OPTIONS", "pc_display", nil, nil, nil, {
        desc_text = Engine.Localize("@LUA_MENU_GRAPHIC_OPTIONS_DESC")
    })
    f26_local0:AddButton("@LUA_MENU_AUDIO_OPTIONS", "pc_audio", nil, nil, nil, {
        desc_text = Engine.Localize("@LUA_MENU_AUDIO_OPTIONS_DESC")
    })

    if Engine.IsGamepadEnabled() then
        f26_local0:AddButton("@LUA_MENU_CONTROL_OPTIONS", "gamepad_controls", nil, nil, nil, {
            desc_text = Engine.Localize("@LUA_MENU_CONTROL_OPTIONS_DESC")
        })
    else
        f26_local0:AddButton("@LUA_MENU_CONTROL_OPTIONS", "movement_controls", nil, nil, nil, {
            desc_text = Engine.Localize("@LUA_MENU_CONTROL_OPTIONS_DESC")
        })
    end

    f26_local0:AddButton("@LUA_MENU_SYSTEM_INFO", openSystemInfo, nil, nil, nil, {
        desc_text = Engine.Localize("@LUA_MENU_SYSTEM_INFO_DESC")
    })

    LUI.Options.InitScrollingList(f26_local0.list, nil)
    LUI.Options.AddOptionTextInfo(f26_local0)
    f26_local0:AddBackButton(function(f27_arg0, f27_arg1)
        PCOptionsMainClose(f27_arg0, f27_arg1)
        LUI.FlowManager.RequestLeaveMenu(f27_arg0)
    end)
    return f26_local0
end

LUI.MenuBuilder.m_types_build["pc_controls"] = pc_controls
