local pcoptions = luiglobals.require("LUI.PCOptions")

pcoptions.TransferSettingsToUI = function()
	local f13_local0 = Engine.GetDvarBool( "r_fullscreen" )
	local f13_local1 = false
	if Engine.IsPCApp() then
		if f13_local0 then
			pcoptions.SetDvarValue( "ui_r_displayMode", "fullscreen" )
		else
			pcoptions.SetDvarValue( "ui_r_displayMode", "windowed" )
		end
	else
		f13_local1 = Engine.GetDvarBool( "r_fullscreenWindow" )
		if f13_local0 and not f13_local1 then
			pcoptions.SetDvarValue( "ui_r_displayMode", "fullscreen" )
		elseif f13_local0 and f13_local1 then
			pcoptions.SetDvarValue( "ui_r_displayMode", "windowed_no_border" )
		elseif not f13_local0 then
			pcoptions.SetDvarValue( "ui_r_displayMode", "windowed" )
		end
	end
	if f13_local0 and not f13_local1 then
		pcoptions.SetDvarValue( "ui_r_mode", pcoptions.GetDvarValue( "r_mode" ) )
	else
		pcoptions.SetDvarValue( "ui_r_mode", Engine.GetDisplayWidth() .. " " .. Engine.GetDisplayHeight() )
	end
	pcoptions.SetDvarValue( "ui_r_adapter", pcoptions.GetDvarValue( "r_adapter" ) )
	if not Engine.IsPCApp() then
		pcoptions.SetDvarValue( "ui_r_monitor", pcoptions.GetDvarValue( "r_monitor" ) )
		pcoptions.SetDvarValue( "ui_r_refreshRate", pcoptions.GetDvarValue( "r_refreshRate" ) )
		pcoptions.SetDvarValue( "ui_r_aspectratio", pcoptions.GetDvarValue( "r_aspectratio" ) )
	end
	pcoptions.SetDvarValue( "ui_r_vsync", pcoptions.GetDvarValue( "r_vsync" ) )
	if Engine.IsMultiplayer() then
		pcoptions.SetDvarValue( "ui_cg_fov", pcoptions.GetDvarValue( "cg_fov" ) )
        pcoptions.SetDvarValue( "ui_cg_fov_scale", pcoptions.GetDvarValue( "cg_fovScale" ) )
	end
	pcoptions.SetDvarValue( "ui_r_letterboxAspectRatio", pcoptions.GetDvarValue( "r_letterboxAspectRatio" ) )
	Engine.SetDvarBool( "ui_r_renderResolutionNative", Engine.GetDvarBool( "r_renderResolutionNative" ), true )
	Engine.SetDvarInt( "ui_r_renderResolution", Engine.GetDvarFloat( "r_renderResolution" ) * 1000000, true )
	pcoptions.SetDvarValue( "ui_r_fill_texture_memory", pcoptions.GetDvarValue( "r_fill_texture_memory" ) )
	pcoptions.SetDvarValue( "ui_r_picmip", pcoptions.GetDvarValue( "r_picmip" ) )
	pcoptions.SetDvarValue( "ui_r_picmip_bump", pcoptions.GetDvarValue( "r_picmip_bump" ) )
	pcoptions.SetDvarValue( "ui_r_picmip_spec", pcoptions.GetDvarValue( "r_picmip_spec" ) )
	pcoptions.SetDvarValue( "ui_r_texFilterAnisoMin", pcoptions.GetDvarValue( "r_texFilterAnisoMin" ) )
	pcoptions.SetDvarValue( "ui_sm_enable", pcoptions.GetDvarValue( "sm_enable" ) )
	pcoptions.SetDvarValue( "ui_sm_tileResolution", pcoptions.GetDvarValue( "sm_tileResolution" ) )
	pcoptions.SetDvarValue( "ui_sm_cacheSunShadow", pcoptions.GetDvarValue( "sm_cacheSunShadow" ) )
	pcoptions.SetDvarValue( "ui_sm_cacheSpotShadows", pcoptions.GetDvarValue( "sm_cacheSpotShadows" ) )
	pcoptions.SetDvarValue( "ui_r_dof_limit", pcoptions.GetDvarValue( "r_dof_limit" ) )
	pcoptions.SetDvarValue( "ui_r_mbLimit", pcoptions.GetDvarValue( "r_mbLimit" ) )
	pcoptions.SetDvarValue( "ui_r_ssaoLimit", pcoptions.GetDvarValue( "r_ssaoLimit" ) )
	pcoptions.SetDvarValue( "ui_r_mdaoLimit", pcoptions.GetDvarValue( "r_mdaoLimit" ) )
	pcoptions.SetDvarValue( "ui_r_sssLimit", pcoptions.GetDvarValue( "r_sssLimit" ) )
	pcoptions.SetDvarValue( "ui_r_depthPrepass", pcoptions.GetDvarValue( "r_depthPrepass" ) )
	pcoptions.SetDvarValue( "ui_r_postAA", pcoptions.GetDvarValue( "r_postAA" ) )
	pcoptions.SetDvarValue( "ui_r_ssaaSamples", pcoptions.GetDvarValue( "r_ssaaSamples" ) )
	pcoptions.SetDvarValue( "ui_r_preloadShaders", pcoptions.GetDvarValue( "r_preloadShaders" ) )
	pcoptions.SetDvarValue( "ui_r_preloadShadersAfterCinematic", pcoptions.GetDvarValue( "r_preloadShadersAfterCinematic" ) )
	pcoptions.SetDvarValue( "ui_r_preloadShadersFrontendAllow", pcoptions.GetDvarValue( "r_preloadShadersFrontendAllow" ) )
	pcoptions.SetDvarValue( "ui_fx_marks", pcoptions.GetDvarValue( "fx_marks" ) )
	pcoptions.SetDvarValue( "ui_r_dlightForceLimit", pcoptions.GetDvarValue( "r_dlightForceLimit" ) )
end

pcoptions.TransferSettingsToGame = function()
	local f14_local0 = pcoptions.GetDvarValue( "ui_r_displayMode" )
	if Engine.IsPCApp() then
		if f14_local0 == "fullscreen" then
			pcoptions.SetDvarValue( "r_fullscreen", true )
		elseif f14_local0 == "windowed" then
			pcoptions.SetDvarValue( "r_fullscreen", false )
		else
			DebugPrint( "WARNING: Unsupported display mode " .. f14_local0 )
		end
	elseif f14_local0 == "fullscreen" then
		pcoptions.SetDvarValue( "r_fullscreen", true )
		pcoptions.SetDvarValue( "r_fullscreenWindow", false )
	elseif f14_local0 == "windowed_no_border" then
		pcoptions.SetDvarValue( "r_fullscreen", true )
		pcoptions.SetDvarValue( "r_fullscreenWindow", true )
	elseif f14_local0 == "windowed" then
		pcoptions.SetDvarValue( "r_fullscreen", false )
	else
		DebugPrint( "WARNING: Unsupported display mode " .. f14_local0 )
	end
	local f14_local1 = Engine.GetDvarString( "ui_r_mode" )
	if f14_local0 == "fullscreen" then
		pcoptions.SetDvarValue( "r_mode", f14_local1 )
	end
	pcoptions.SetDvarValue( "r_adapter", Engine.GetDvarString( "ui_r_adapter" ) )
	if not Engine.IsPCApp() then
		pcoptions.SetDvarValue( "r_monitor", Engine.GetDvarString( "ui_r_monitor" ) )
		pcoptions.SetDvarValue( "r_refreshRate", Engine.GetDvarString( "ui_r_refreshRate" ) )
		pcoptions.SetDvarValue( "r_aspectratio", Engine.GetDvarString( "ui_r_aspectratio" ) )
	end
	pcoptions.SetDvarValue( "r_vsync", Engine.GetDvarString( "ui_r_vsync" ) )
	if Engine.IsMultiplayer() then
		pcoptions.SetDvarValue( "cg_fov", Engine.GetDvarString( "ui_cg_fov" ) )
        pcoptions.SetDvarValue( "cg_fovScale", Engine.GetDvarString( "ui_cg_fov_scale" ) )
	end
	local f14_local2 = Engine.GetDvarString( "ui_r_letterboxAspectRatio" )
	if f14_local0 == "windowed" then
		if not Engine.IsPCApp() and f14_local2 ~= Engine.GetDvarString( "r_letterboxAspectRatio" ) and f14_local2 ~= "auto" then
			local f14_local3 = {
				standard = 1.33,
				["wide 16:10"] = 1.6,
				["wide 16:9"] = 1.78,
				["wide 21:9"] = 2.37
			}
			local f14_local4 = f14_local3[f14_local2]
			local f14_local5 = LUI.StringSplit( f14_local1, " " )
			local f14_local6 = tonumber( f14_local5[1] )
			local f14_local7 = tonumber( f14_local5[2] )
			if f14_local6 / f14_local7 ~= f14_local4 then
				f14_local7 = math.floor( math.sqrt( f14_local6 * f14_local7 / f14_local4 ) + 0.5 )
				f14_local1 = math.floor( f14_local7 * f14_local4 + 0.5 ) .. " " .. f14_local7
			end
		end
		Engine.Exec( "window " .. f14_local1 )
	end
	pcoptions.SetDvarValue( "r_letterboxAspectRatio", f14_local2 )
	Engine.SetDvarBool( "r_renderResolutionNative", Engine.GetDvarBool( "ui_r_renderResolutionNative" ) )
	Engine.SetDvarFloat( "r_renderResolution", Engine.GetDvarInt( "ui_r_renderResolution" ) / 1000000 )
	pcoptions.SetDvarValue( "r_fill_texture_memory", Engine.GetDvarString( "ui_r_fill_texture_memory" ) )
	pcoptions.SetDvarValue( "r_picmip", Engine.GetDvarString( "ui_r_picmip" ) )
	pcoptions.SetDvarValue( "r_picmip_bump", Engine.GetDvarString( "ui_r_picmip_bump" ) )
	pcoptions.SetDvarValue( "r_picmip_spec", Engine.GetDvarString( "ui_r_picmip_spec" ) )
	pcoptions.SetDvarValue( "r_texFilterAnisoMin", Engine.GetDvarString( "ui_r_texFilterAnisoMin" ) )
	pcoptions.SetDvarValue( "sm_enable", Engine.GetDvarString( "ui_sm_enable" ) )
	pcoptions.SetDvarValue( "sm_tileResolution", Engine.GetDvarString( "ui_sm_tileResolution" ) )
	pcoptions.SetDvarValue( "sm_cacheSunShadow", Engine.GetDvarString( "ui_sm_cacheSunShadow" ) )
	pcoptions.SetDvarValue( "sm_cacheSpotShadows", Engine.GetDvarString( "ui_sm_cacheSpotShadows" ) )
	pcoptions.SetDvarValue( "r_dof_limit", Engine.GetDvarString( "ui_r_dof_limit" ) )
	pcoptions.SetDvarValue( "r_mbLimit", Engine.GetDvarString( "ui_r_mbLimit" ) )
	pcoptions.SetDvarValue( "r_ssaoLimit", Engine.GetDvarString( "ui_r_ssaoLimit" ) )
	pcoptions.SetDvarValue( "r_mdaoLimit", Engine.GetDvarString( "ui_r_mdaoLimit" ) )
	pcoptions.SetDvarValue( "r_sssLimit", Engine.GetDvarString( "ui_r_sssLimit" ) )
	pcoptions.SetDvarValue( "r_depthPrepass", Engine.GetDvarString( "ui_r_depthPrepass" ) )
	pcoptions.SetDvarValue( "r_postAA", Engine.GetDvarString( "ui_r_postAA" ) )
	pcoptions.SetDvarValue( "r_ssaaSamples", Engine.GetDvarString( "ui_r_ssaaSamples" ) )
	pcoptions.SetDvarValue( "r_preloadShaders", Engine.GetDvarString( "ui_r_preloadShaders" ) )
	pcoptions.SetDvarValue( "r_preloadShadersAfterCinematic", Engine.GetDvarString( "ui_r_preloadShadersAfterCinematic" ) )
	pcoptions.SetDvarValue( "r_preloadShadersFrontendAllow", Engine.GetDvarString( "ui_r_preloadShadersFrontendAllow" ) )
	pcoptions.SetDvarValue( "fx_marks", Engine.GetDvarString( "ui_fx_marks" ) )
	pcoptions.SetDvarValue( "r_dlightForceLimit", Engine.GetDvarString( "ui_r_dlightForceLimit" ) )
end

function GetFOV()
    return (Engine.GetDvarFloat("ui_cg_fov") - SliderBounds.FOV.Min) / (SliderBounds.FOV.Max - SliderBounds.FOV.Min)
end

function FOVLess(f2_arg0)
    Engine.SetDvarFloat("ui_cg_fov", math.min(SliderBounds.FOV.Max, math.max(SliderBounds.FOV.Min, Engine.GetDvarFloat(
        "ui_cg_fov") - SliderBounds.FOV.Step)))
    LUI.PCOptions.TransferSettingsToGame()
end

function FOVMore(f3_arg0)
    Engine.SetDvarFloat("ui_cg_fov", math.min(SliderBounds.FOV.Max, math.max(SliderBounds.FOV.Min, Engine.GetDvarFloat(
        "ui_cg_fov") + SliderBounds.FOV.Step)))
    LUI.PCOptions.TransferSettingsToGame()
end

local FOVScale = {
    Min = 1,
    Max = 2,
    Step = 0.1
}

local function GetFOVScale()    
    return (Engine.GetDvarFloat("ui_cg_fov_scale") - FOVScale.Min) / (FOVScale.Max - FOVScale.Min)
end

local function FOVScaleLess(f2_arg0)
    Engine.SetDvarFloat("ui_cg_fov_scale", math.min(FOVScale.Max, math.max(FOVScale.Min, Engine.GetDvarFloat(
        "ui_cg_fov_scale") - FOVScale.Step)))
    
    LUI.PCOptions.TransferSettingsToGame()
end

local function FOVScaleMore(f3_arg0)
    Engine.SetDvarFloat("ui_cg_fov_scale", math.min(FOVScale.Max, math.max(FOVScale.Min, Engine.GetDvarFloat(
        "ui_cg_fov_scale") + FOVScale.Step)))
    
    LUI.PCOptions.TransferSettingsToGame()
end

function OpenShaderCacheDialog(f4_arg0, f4_arg1)
    LUI.FlowManager.RequestAddMenu(f4_arg0, "ShaderCacheChoiceDialog")
end

function CreateOptions(f5_arg0)
    local f5_local0 = {{
        text = "@LUA_MENU_MODE_FULLSCREEN",
        value = "fullscreen"
    }, {
        text = "@LUA_MENU_MODE_WINDOWED_NO_BORDER",
        value = "windowed_no_border"
    }, {
        text = "@LUA_MENU_MODE_WINDOWED",
        value = "windowed"
    }}
    local f5_local1 = {{
        text = "@LUA_MENU_MODE_FULLSCREEN",
        value = "fullscreen"
    }, {
        text = "@LUA_MENU_MODE_WINDOWED",
        value = "windowed"
    }}
    local f5_local2 = LUI.Options.CreateDVarVideoOptionHelper
    local f5_local3 = f5_arg0
    local f5_local4 = "ui_r_displayMode"
    local f5_local5 = "@LUA_MENU_DISPLAY_MODE"
    if Engine.IsPCApp() then
        local f5_local6 = f5_local1
    end
    f5_local2(f5_local3, f5_local4, f5_local5, f5_local6 or f5_local0, {
        button_desc = "@LUA_MENU_DISPLAY_MODE_DESC"
    })
    if not Engine.IsPCApp() then
        LUI.Options.CreateDVarVideoOptionHelper(f5_arg0, "ui_r_monitor", "@PLATFORM_UI_MONITOR", function()
            local f6_local0 = LUI.Options.StringOptionListFromList(Engine.GetMonitorList())
            for f6_local1 = 1, #f6_local0, 1 do
                f6_local0[f6_local1].text = Engine.MarkLocalized(f6_local0[f6_local1].text)
            end
            return f6_local0
        end, {
            button_desc = "@PLATFORM_UI_MONITOR_DESC",
            disabledFunc = function()
                return Engine.GetDvarBool("r_fullscreen") == false
            end
        })
        f5_local3 = LUI.Options.StringOptionListFromList(Engine.GetRefreshRateList())
        for f5_local4 = 1, #f5_local3, 1 do
            f5_local3[f5_local4].text = Engine.MarkLocalized(f5_local3[f5_local4].text)
        end
        LUI.Options.CreateDVarVideoOptionHelper(f5_arg0, "ui_r_refreshRate", "@MENU_SCREEN_REFRESH_RATE", f5_local3, {
            button_desc = "@PLATFORM_SCREEN_REFRESH_RATE_DESCRIPTION",
            disabledFunc = function()
                local f8_local0
                if Engine.GetDvarBool("r_fullscreen") ~= false and Engine.GetDvarBool("r_fullscreenWindow") ~= true then
                    f8_local0 = false
                else
                    f8_local0 = true
                end
                return f8_local0
            end
        })
    end
    f5_local2 = {{
        width = 800,
        height = 600,
        aspect = "4:3"
    }, {
        width = 1024,
        height = 768,
        aspect = "4:3"
    }, {
        width = 1280,
        height = 960,
        aspect = "4:3"
    }, {
        width = 1440,
        height = 1080,
        aspect = "4:3"
    }, {
        width = 1600,
        height = 1200,
        aspect = "4:3"
    }, {
        width = 2048,
        height = 1536,
        aspect = "4:3"
    }, {
        width = 1024,
        height = 576,
        aspect = "16:9"
    }, {
        width = 1365,
        height = 768,
        aspect = "16:9"
    }, {
        width = 1600,
        height = 900,
        aspect = "16:9"
    }, {
        width = 1920,
        height = 1080,
        aspect = "16:9"
    }, {
        width = 2560,
        height = 1440,
        aspect = "16:9"
    }, {
        width = 3840,
        height = 2160,
        aspect = "16:9"
    }, {
        width = 1280,
        height = 540,
        aspect = "21:9"
    }, {
        width = 1920,
        height = 810,
        aspect = "21:9"
    }, {
        width = 2560,
        height = 1080,
        aspect = "21:9"
    }, {
        width = 3840,
        height = 1620,
        aspect = "21:9"
    }}
    f5_local3 = function(f9_arg0, f9_arg1)
        local f9_local0 = 1
        while f5_local2[f9_local0] do
            if f5_local2[f9_local0].width == f9_arg0 and f5_local2[f9_local0].height == f9_arg1 then
                return f9_local0
            end
            f9_local0 = f9_local0 + 1
        end
        return 0
    end

    f5_local4 = function()
        local f10_local0 = nil
        local f10_local1 = Engine.GetDisplayWidth()
        local f10_local2 = Engine.GetDisplayHeight()
        if Engine.GetDvarBool("r_fullscreen") == true and Engine.GetDvarBool("r_fullscreenWindow") == false then
            f10_local0 = LUI.Options.StringOptionListFromList(Engine.GetModeList())
        elseif Engine.GetDvarBool("r_fullscreen") == true and Engine.GetDvarBool("r_fullscreenWindow") == true then
            f10_local0 = {{
                text = f10_local1 .. "x" .. f10_local2,
                value = ""
            }}
        else
            f10_local0 = {}
            if f5_local3(f10_local1, f10_local2) == 0 then
                f10_local0[1] = {
                    text = f10_local1 .. "x" .. f10_local2,
                    value = f10_local1 .. " " .. f10_local2
                }
            end
            for f10_local6, f10_local7 in pairs(f5_local2) do
                f10_local0[#f10_local0 + 1] = {
                    text = f10_local7.width .. "x" .. f10_local7.height .. " (" .. f10_local7.aspect .. ")",
                    value = f10_local7.width .. " " .. f10_local7.height
                }
            end
        end
        for f10_local3 = 1, #f10_local0, 1 do
            f10_local0[f10_local3].text = Engine.MarkLocalized(f10_local0[f10_local3].text)
        end
        return f10_local0
    end

    if not Engine.IsPCApp() then
        LUI.Options.CreateDVarVideoOptionHelper(f5_arg0, "ui_r_mode", "@LUA_MENU_VIDEO_MODE", f5_local4, {
            button_desc = "@LUA_MENU_VIDEO_MODE_DESC",
            disabledFunc = function()
                local f11_local0 = Engine.GetDvarBool("r_fullscreen")
                if f11_local0 then
                    f11_local0 = Engine.IsPCApp()
                    if not f11_local0 then
                        f11_local0 = Engine.GetDvarBool("r_fullscreenWindow")
                    end
                end
                return f11_local0
            end
        })
    end
    if not Engine.IsPCApp() then
        LUI.Options.CreateDVarVideoOptionHelper(f5_arg0, "ui_r_letterboxAspectRatio", "@PLATFORM_FORCED_ASPECT_RATIO",
            {{
                text = "@MENU_AUTO",
                value = "auto"
            }, {
                text = "@MENU_STANDARD_4_3",
                value = "standard"
            }, {
                text = "@MENU_WIDE_16_10",
                value = "wide 16:10"
            }, {
                text = "@MENU_WIDE_16_9",
                value = "wide 16:9"
            }, {
                text = "@MENU_WIDE_21_9",
                value = "wide 21:9"
            }}, {
                button_desc = "@PLATFORM_FORCED_ASPECT_RATIO_DESC"
            })
    end
    if Engine.IsMultiplayer() then
        LUI.Options.AddButtonOptionVariant(f5_arg0, GenericButtonSettings.Variants.Slider, "@PLATFORM_FOV",
            "@PLATFORM_FOV_OPTION_SUB", GetFOV, FOVLess, FOVMore)

        LUI.Options.AddButtonOptionVariant(f5_arg0, GenericButtonSettings.Variants.Slider, "@PLATFORM_FOV_SCALE",
            "@PLATFORM_FOV_SCALE_OPTION_SUB", GetFOVScale, FOVScaleLess, FOVScaleMore)

        if Engine.ShaderUploadFrontendSystemIsAvailable() then
            LUI.Options.CreateOptionButton(f5_arg0, "ui_r_preloadShadersFrontendAllow",
                "@PLATFORM_SHADER_PRECACHE_BUTTON", "@PLATFORM_SHADER_PRECACHE_BUTTON_DESC", {{
                    text = "@LUA_MENU_DISABLED",
                    value = "false"
                }, {
                    text = "@LUA_MENU_ENABLED",
                    value = "true"
                }}, nil, nil, function()
                    LUI.Options.RefreshVideoSetting()
                    f5_arg0:RefreshButtonDisabled()
                end)
        end
        if Engine.ShaderUploadFrontendOptionsAreAvailable() then
            LUI.Options.AddButtonOptionVariant(f5_arg0, GenericButtonSettings.Variants.Common,
                "@PLATFORM_SHADER_POPULATE_CACHE_BUTTON", "@PLATFORM_SHADER_POPULATE_CACHE_BUTTON_DESC", nil, nil, nil,
                OpenShaderCacheDialog, nil, nil, function()
                    return not Engine.GetDvarBool("r_preloadShadersFrontendAllow")
                end)
        end
    end

    -- LUI.Options.AddButtonOptionVariant( f5_arg0, GenericButtonSettings.Variants.Select, "SHOW FRAMES PER SECOND", "Displays the current frames per second in the top-right.", LUI.Options.GetDvarEnableTextFunc( "ui_cg_drawFPS", false ), LUI.Options.ToggleDvarFunc( "ui_cg_drawFPS" ), LUI.PCOptions.TransferSettingsToGame() )

    LUI.Options.InitScrollingList(f5_arg0.list, nil)
end

function RefreshFunc(f14_arg0)
    return function(f15_arg0, f15_arg1)
        LUI.PCOptions.TransferSettingsToUI()
        f14_arg0.list:processEvent({
            name = "content_refresh",
            dispatchChildren = true
        })
    end

end

function pc_video(f16_arg0, f16_arg1)
    LUI.PCOptions.TransferSettingsToUI()
    Engine.ExecNow("profile_menuDvarsSetup")
    local f16_local0 = Engine.IsMultiplayer() and 0 or LUI.MenuTemplate.spMenuOffset
    local f16_local1 = LUI.MenuTemplate.new(f16_arg0, {
        menu_title = Engine.ToUpperCase(Engine.Localize("@LUA_MENU_GRAPHIC_OPTIONS")),
        menu_top_indent = f16_local0 + LUI.H1MenuTab.tabChangeHoldingElementHeight + H1MenuDims.spacing,
        menu_list_divider_top_offset = -(LUI.H1MenuTab.tabChangeHoldingElementHeight + H1MenuDims.spacing),
        menu_width = GenericMenuDims.OptionMenuWidth,
        genericListAction = function(f17_arg0, f17_arg1)
            LUI.Options.CloseSelectionMenu(f17_arg1.menu)
        end,
        skipAnim = LUI.PCGraphicOptions.FindTypeIndex(LUI.PreviousMenuName) ~= 0
    })
    f16_local1:addElement(LUI.H1MenuTab.new({
        title = function(f18_arg0)
            return LUI.PCGraphicOptions.Categories[f18_arg0].title
        end,
        tabCount = #LUI.PCGraphicOptions.Categories,
        underTabTextFunc = function(f19_arg0)
            return LUI.PCGraphicOptions.Categories[f19_arg0].title
        end,
        top = f16_local0 + LUI.MenuTemplate.ListTop,
        width = GenericMenuDims.OptionMenuWidth,
        clickTabBtnAction = LUI.PCGraphicOptions.LoadMenu,
        activeIndex = LUI.PCGraphicOptions.FindTypeIndex("pc_video"),
        skipChangeTab = true,
        exclusiveController = f16_local1.exclusiveController
    }))
    f16_local1:registerEventHandler("onVideoChange", RefreshFunc(f16_local1))
    CreateOptions(f16_local1)
    LUI.PCControlOptions.AddOptimalVideoButton(f16_local1)
    LUI.Options.AddOptionTextInfo(f16_local1)
    f16_local1:AddBackButtonWithSelector()
    return f16_local1
end
LUI.MenuBuilder.m_types_build["pc_video"] = pc_video
