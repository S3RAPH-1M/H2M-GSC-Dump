if Engine.InFrontend() then
    return
end

local set_enabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "active" )
end

local set_disabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "default" )
end

local ui_hud_emp_artifact = function(f4_arg0, f4_arg1)
    assert(f4_arg0)
    if Game.GetOmnvar("ui_hud_emp_artifact") then
        f4_arg0:dispatchEventToRoot({
            name = "enable_emp",
            immediate = true
        })
    else
        f4_arg0:dispatchEventToRoot({
            name = "disable_emp",
            immediate = true
        })
    end
end

_buildempOverlay = function ()

    local emp_overlay = LUI.UIElement.new({
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

    emp_overlay:registerAnimationState( "active", {
		alpha = 1
	} )
	emp_overlay:registerAnimationState( "default", {
		alpha = 0
	} )

    emp_overlay:animateToState( "default", 0 )

    emp_overlay:registerEventHandler( "enable_emp", set_enabled )
	emp_overlay:registerEventHandler( "disable_emp", set_disabled )

    emp_overlay:registerEventHandler( "playerstate_client_changed", ui_hud_emp_artifact )
    emp_overlay:registerOmnvarHandler("ui_hud_emp_artifact", ui_hud_emp_artifact)

    emp_overlay.id = "emp_overlay"

    -- Overlay Grain --
    LUI.MenuBuilder.BuildAddChild(emp_overlay, {
        type = "UIImage",
        id = "emp_overlay_grain",
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        states = {
            default = {
                width = ScreenResolution[currentScreenResolution].width + 32,
                height = ScreenResolution[currentScreenResolution].height + 32,
                material = RegisterMaterial("ac130_overlay_grain"),
                alpha = 0.5
            }
        }
    })

    return emp_overlay
end

LUI.MenuBuilder.registerType("emp_overlay", _buildempOverlay)
