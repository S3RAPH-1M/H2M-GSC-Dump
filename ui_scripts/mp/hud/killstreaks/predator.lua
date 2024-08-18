if Engine.InFrontend() then
    return
end

local set_enabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "active" )
end

local set_disabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "default" )
end

local ui_predator_enabled = function(f4_arg0, f4_arg1)
    assert(f4_arg0)
    if Game.GetOmnvar("ui_predator_enabled") then
        f4_arg0:dispatchEventToRoot({
            name = "enable_predator",
            immediate = true
        })
    else
        f4_arg0:dispatchEventToRoot({
            name = "disable_predator",
            immediate = true
        })
    end
end

_buildPredatorOverlay = function ()

    local predator_overlay = LUI.UIElement.new({
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        top = -15,
        left = -15,
        width = ScreenResolution[currentScreenResolution].width,
        height = ScreenResolution[currentScreenResolution].height,
        alpha = 0,
        handlers = {
			enable = set_enabled,
			disable = set_disabled,
		},
    })

    predator_overlay:registerAnimationState( "active", {
		alpha = 1
	} )
	predator_overlay:registerAnimationState( "default", {
		alpha = 0
	} )

    predator_overlay:animateToState( "default", 0 )

    predator_overlay:registerEventHandler( "enable_predator", set_enabled )
	predator_overlay:registerEventHandler( "disable_predator", set_disabled )

    predator_overlay:registerEventHandler( "playerstate_client_changed", ui_predator_enabled )
    predator_overlay:registerOmnvarHandler("ui_predator_enabled", ui_predator_enabled)

    predator_overlay.id = "predator_overlay"

    -- Compass --
    LUI.MenuBuilder.BuildAddChild(predator_overlay, {
        type = "UICompass",
        id = "predator_tickertape",
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = false,
        rightAnchor = false,
        states = {
            default = {
                bottom = -190,
                width = 400,
                height = 20,
                material = RegisterMaterial("minimap_tickertape_mp"),
                alpha = 1
            }
        }
    })

    local owner_161 = LUI.UIElement.new()
	owner_161.id = "ownerDrawId" .. 161
	owner_161:setupOwnerdraw( 161 )
	owner_161:registerAnimationState( "default", {
		bottom = -200,
        left = 515,
        width = 20,
        height = 20,
        alpha = 0.7,
        scale = 0.01,
        bottomAnchor = true,
        leftAnchor = true,
        font = CoD.TextSettings.BodyFont.Font,
        alignment = LUI.Alignment.Center
	} )
	owner_161:animateToState( "default", 0 )
    predator_overlay:addElement(owner_161)

    local owner_160 = LUI.UIElement.new()
	owner_160.id = "ownerDrawId" .. 160
	owner_160:setupOwnerdraw( 160 )
	owner_160:registerAnimationState( "default", {
		bottom = -245,
        left = 475,
        width = 20,
        height = 20,
        alpha = 0.7,
        scale = 0.01,
        bottomAnchor = true,
        leftAnchor = true,
        font = CoD.TextSettings.BodyFont.Font,
        alignment = LUI.Alignment.Center
	} )
	owner_160:animateToState( "default", 0 )
    predator_overlay:addElement(owner_160)

    local steer_localization = Engine.Localize("@PLATFORM_PREDATOR_MISSILE_AIM")
    local steer_right_pos = -490

    if Engine.IsGamepadEnabled() then
        steer_localization = Engine.Localize("@PLATFORM_PREDATOR_MISSILE_AIM_GPAD")
        steer_right_pos = -450
    end

    LUI.MenuBuilder.BuildAddChild(predator_overlay, {
        type = "UIText",
        id = "predator_missileAim",
        properties = {
            text = steer_localization
        },
        states = {
            default = {
                alignment = LUI.Alignment.Center,
                scale = 0.1,
                alpha = 0.65,
                right = steer_right_pos * Engine.GetDvarFloat( "safeArea_adjusted_horizontal" ),
                bottom = -245 * Engine.GetDvarFloat( "safeArea_adjusted_vertical" ),
                font = CoD.TextSettings.BodyFont.Font,
                height = 20,
                rightAnchor = true,
                leftAnchor = true,
                bottomAnchor = true,
                horizontalAlignment = LUI.HorizontalAlignment.Right,
            }
        }
    })

    local boost_right_pos = -378
    if Engine.IsGamepadEnabled() then
        boost_right_pos = -450
    end

    LUI.MenuBuilder.BuildAddChild(predator_overlay, {
        type = "UIText",
        id = "predator_missileBoost",
        properties = {
            text = Engine.Localize("@PLATFORM_PREDATOR_MISSILE_BOOST")
        },
        states = {
            default = {
                alignment = LUI.Alignment.Center,
                scale = 0.1,
                alpha = 0.65,
                right = boost_right_pos * Engine.GetDvarFloat( "safeArea_adjusted_horizontal" ),
                bottom = -205 * Engine.GetDvarFloat( "safeArea_adjusted_vertical" ),
                font = CoD.TextSettings.BodyFont.Font,
                height = 20,
                rightAnchor = true,
                leftAnchor = true,
                bottomAnchor = true,
                horizontalAlignment = LUI.HorizontalAlignment.Right,
            }
        }
    })

    -- Overlay Grain --
    LUI.MenuBuilder.BuildAddChild(predator_overlay, {
        type = "UIImage",
        id = "predator_overlay_grain",
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        states = {
            default = {
                width = ScreenResolution[currentScreenResolution].width + 32,
                height = ScreenResolution[currentScreenResolution].height + 32,
                material = RegisterMaterial("ac130_overlay_grain"),
                alpha = 0.4
            }
        }
    })
    
    return predator_overlay
end

LUI.MenuBuilder.registerType("predator_overlay", _buildPredatorOverlay)
