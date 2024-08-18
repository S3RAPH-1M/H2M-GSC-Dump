if Engine.InFrontend() then
    return
end

local _AddOuterText = function (ac130_overlay)
    -- 105mm Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_105mmText",
        properties = {
            text = "105 mm",
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = false,
                top = -30,
                bottom = -30 + CoD.TextSettings.BodyFont.Height,
                left = 0,
                right = 0,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Bottom,
                scale = 0.2,
                alpha = 0.3
            },
            active = {
                scale = 0.2,
                alpha = 1
            },
            inactive = {
                scale = 0.1,
                alpha = 0.3
            }
        }
    })

    -- 40mm Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_40mmText",
        properties = {
            text = "40 mm",
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = false,
                top = -60,
                bottom = -60 + CoD.TextSettings.BodyFont.Height,
                left = 0,
                right = 0,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Bottom,
                scale = 0.1,
                alpha = 0.3
            },
            active = {
                scale = 0.2,
                alpha = 1
            },
            inactive = {
                scale = 0.1,
                alpha = 0.3
            }
        }
    })

    -- 25mm Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_25mmText",
        properties = {
            text = "25 mm",
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = false,
                top = -90,
                bottom = -90 + CoD.TextSettings.BodyFont.Height,
                left = 0,
                right = 0,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Bottom,
                scale = 0.1,
                alpha = 0.3
            },
            active = {
                scale = 0.2,
                alpha = 1
            },
            inactive = {
                scale = 0.1,
                alpha = 0.3
            }
        }
    })

    -- TopBar Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_topBarText",
        topAnchor = false,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        properties = {
            text = Engine.Localize("@AC130_HUD_TOP_BAR")
        },
        states = {
            default = {
                topAnchor = true,
                bottomAnchor = false,
                leftAnchor = true,
                rightAnchor = true,
                top = 0,
                bottom = 0 + CoD.TextSettings.BodyFont.Height,
                left = 0,
                right = 0,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Left,
            }
        }
    })

    -- LeftBlock Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_leftBarText",
        topAnchor = false,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        properties = {
            text = Engine.Localize("@AC130_HUD_LEFT_BLOCK")
        },
        states = {
            default = {
                topAnchor = true,
                bottomAnchor = false,
                leftAnchor = true,
                rightAnchor = true,
                top = 60,
                bottom = 60 + CoD.TextSettings.BodyFont.Height,
                left = 0,
                right = 0,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Left,
            }
        }
    })

    -- RightBlock Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_rightBarText",
        topAnchor = false,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        properties = {
            text = Engine.Localize("@AC130_HUD_RIGHT_BLOCK")
        },
        states = {
            default = {
                topAnchor = true,
                bottomAnchor = false,
                leftAnchor = true,
                rightAnchor = true,
                top = 50,
                bottom = 50 + CoD.TextSettings.BodyFont.Height,
                right = -40,
                left = 0,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Right,
            }
        }
    })

    -- BottomBlock Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_bottomBarText",
        topAnchor = false,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        properties = {
            text = Engine.Localize("@AC130_HUD_BOTTOM_BLOCK")
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = true,
                top = -30,
                bottom = -30 + CoD.TextSettings.BodyFont.Height,
                right = 0,
                left = 0,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Center,
            }
        }
    })

    -- Thermal Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_thermalText",
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
                -- left = 780,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Right,
            }
        }
    })

    -- Switch Weapon Text --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIText",
        id = "ac130_switchWeaponText",
        properties = {
            text = Engine.Localize("@PLATFORM_UI_AC130_CHANGE_WEAPON")
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = true,
                top = -160,
                bottom = -160 + 16,
                right = -206,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Right, 
                textAlignment = LUI.Alignment.Right,
            }
        }
    })
end

local set_enabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "active" )
end

local set_disabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "default" )
end

local ui_ac130_enabled = function(f4_arg0, f4_arg1)
    assert(f4_arg0)
    if Game.GetOmnvar("ui_ac130_enabled") then
        f4_arg0:dispatchEventToRoot({
            name = "enable_ac130",
            immediate = true
        })
    else
        f4_arg0:dispatchEventToRoot({
            name = "disable_ac130",
            immediate = true
        })
    end
end

local ui_ac130_weapon = function (arg0, arg1)
    local weapon = Game.GetOmnvar("ui_ac130_weapon")

    local engineRoot = Engine.GetLuiRoot()
    local ac130_105mmText = engineRoot:getFirstDescendentById( "ac130_105mmText" )
    local ac130_40mmText = engineRoot:getFirstDescendentById( "ac130_40mmText" )
    local ac130_25mmText = engineRoot:getFirstDescendentById( "ac130_25mmText" )

    ac130_105mmText:animateToState( "inactive" )
    ac130_40mmText:animateToState( "inactive" )
    ac130_25mmText:animateToState( "inactive" )

    if weapon == 1 or weapon == 0 then
        ac130_105mmText:animateToState( "active" )
    elseif weapon == 2 then
        ac130_40mmText:animateToState( "active" )
    elseif weapon == 3 then
        ac130_25mmText:animateToState( "active" )
    end
end

-- TODO: We dont actually give the weapon, so no reticle exists
function vehicleReticleDef()
	local self = LUI.UIElement.new()
	self.id = "vehicleReticleDefId"
	self:setupOwnerdraw( CoD.Ownerdraw.CGVehicleReticle )
	self:registerAnimationState( "default", {
		bottom = 200,
        width = 640,
        height = 480,
        alpha = 1
	} )
	self:animateToState( "default", 0 )

    self:debugDraw()
	return self
end

_buildAC130Overlay = function ()

    local ac130_overlay = LUI.UIElement.new({
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        top = -20,
        left = 0,
        width = ScreenResolution[currentScreenResolution].width,
        height = ScreenResolution[currentScreenResolution].height,
        alpha = 0,
        handlers = {
			enable = set_enabled,
			disable = set_disabled,
		},
    })

    ac130_overlay:registerAnimationState( "active", {
		alpha = 1
	} )
	ac130_overlay:registerAnimationState( "default", {
		alpha = 0
	} )

    ac130_overlay:animateToState( "default", 0 )


    ac130_overlay:registerEventHandler( "enable_ac130", set_enabled )
	ac130_overlay:registerEventHandler( "disable_ac130", set_disabled )

    ac130_overlay:registerEventHandler( "playerstate_client_changed", ui_ac130_enabled )
    ac130_overlay:registerOmnvarHandler("ui_ac130_enabled", ui_ac130_enabled)
    ac130_overlay:registerOmnvarHandler("ui_ac130_weapon", ui_ac130_weapon)

    ac130_overlay.id = "ac130_overlay"

    -- Compass --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UICompass",
        id = "ac130_tickertape",
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

    _AddOuterText(ac130_overlay)

    -- Overlay Grain --
    LUI.MenuBuilder.BuildAddChild(ac130_overlay, {
        type = "UIImage",
        id = "ac130_overlay_grain",
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

    -- ac130_overlay:addElement(vehicleReticleDef())
    -- ac130_overlay:debugDraw()

    return ac130_overlay
end

LUI.MenuBuilder.registerType("ac130_overlay", _buildAC130Overlay)
