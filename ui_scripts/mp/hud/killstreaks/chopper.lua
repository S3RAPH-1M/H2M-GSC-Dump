if Engine.InFrontend() then
    return
end

local set_enabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "active" )
end

local set_disabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "default" )
end

local ui_chopper_enabled = function(f4_arg0, f4_arg1)
    assert(f4_arg0)
    if Game.GetOmnvar("ui_chopper_enabled") then
        f4_arg0:dispatchEventToRoot({
            name = "enable_chopper",
            immediate = true
        })
    else
        f4_arg0:dispatchEventToRoot({
            name = "disable_chopper",
            immediate = true
        })
    end
end

_buildChopperOverlay = function ()

    local chopper_overlay = LUI.UIElement.new({
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

    chopper_overlay:registerAnimationState( "active", {
		alpha = 1
	} )
	chopper_overlay:registerAnimationState( "default", {
		alpha = 0
	} )

    chopper_overlay:animateToState( "default", 0 )

    chopper_overlay:registerEventHandler( "enable_chopper", set_enabled )
	chopper_overlay:registerEventHandler( "disable_chopper", set_disabled )

    chopper_overlay:registerEventHandler( "playerstate_client_changed", ui_chopper_enabled )
    chopper_overlay:registerOmnvarHandler("ui_chopper_enabled", ui_chopper_enabled)

    chopper_overlay.id = "chopper_overlay"

    LUI.MenuBuilder.BuildAddChild(chopper_overlay, {
        type = "UIImage",
        id = "ballistic_overlay",
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        states = {
            default = {
                width = ScreenResolution[currentScreenResolution].width + 32,
                height = ScreenResolution[currentScreenResolution].height + 32,
                material = RegisterMaterial("ballistic_overlay"),
                alpha = 0.2
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
    chopper_overlay:addElement(owner_161)

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
    chopper_overlay:addElement(owner_160)

    LUI.MenuBuilder.BuildAddChild(chopper_overlay, {
        type = "UIText",
        id = "chopper_thermalText",
        properties = {
            text = Engine.Localize("@PLATFORM_UI_AC130_TOGGLE_THERMAL")
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = true,
                top = -205,
                bottom = -205 + 16,
                right = -240,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Right,
            }
        }
    })

    LUI.MenuBuilder.BuildAddChild(chopper_overlay, {
        type = "UIText",
        id = "chopper_25mmText",
        properties = {
            text = "25 mm"
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = false,
                top = -30,
                bottom = -30 + CoD.TextSettings.BodyFont.Height,
                left = 15,
                right = 15,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Bottom,
                alpha = 1
            }
        }
    })

    -- Overlay Grain --
    LUI.MenuBuilder.BuildAddChild(chopper_overlay, {
        type = "UIImage",
        id = "chopper_overlay_grain",
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

    return chopper_overlay
end

LUI.MenuBuilder.registerType("chopper_overlay", _buildChopperOverlay)
