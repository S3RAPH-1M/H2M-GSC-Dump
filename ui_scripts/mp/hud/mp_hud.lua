local MPHud = luiglobals.require("LUI.mp_hud.MPHud")

MPHud.addWidget = function( hud, constructor, options )
	assert( constructor )
	assert( constructor.id )
	if not options then
		options = {}
	end
	local canShake = options.shakeable
	local canScale = options.scalable
	local canGlitch = options.glitches
	local isBotLayer = options.botLayer
	local widgetRoot = LUI.UIElement.new( {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true
	} )

	widgetRoot:registerAnimationState( "hud_on", {
		alpha = 1
	} )

    if constructor.id ~= "pointsPopup" and constructor.id ~= "obituary" then
        widgetRoot:registerAnimationState( "hud_off", {
            alpha = 0
        } )
    end

	widgetRoot.id = "wrapper_for_" .. constructor.id
	widgetRoot.widget = constructor
	local f13_local5 = 32
	local f13_local6 = {
		{
			"show",
			0
		},
		{
			"show",
			f13_local5
		},
		{
			"hide",
			0
		},
		{
			"hide",
			f13_local5
		},
		{
			"show",
			0
		},
		{
			"show",
			f13_local5
		},
		{
			"hide",
			0
		},
		{
			"hide",
			f13_local5
		},
		{
			"show",
			0
		}
	}

	-- tb 26 lr 41
	local widgetWrapper = LUI.UIElement.new( {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true
	} )
	widgetWrapper.id = "widget_wrapper_for_" .. constructor.id
	widgetWrapper:registerAnimationState( "show", {
		alpha = 1
	} )
	widgetWrapper:registerAnimationState( "hide", {
		alpha = 0
	} )
	widgetWrapper:registerEventHandler( "animate_in_widget_wrapper", MBh.AnimateSequence( f13_local6 ) )
	widgetWrapper:addElement( constructor )
	widgetRoot:addElement( widgetWrapper )
	widgetRoot.widgetWrapper = widgetWrapper

	if not options.allowInput then
		widgetRoot:registerEventHandler( "gamepad_button", function ()
		end )
	end
	local f13_local8 = hud

	local updateSafeAreaMargins = function ( f27_arg0 )
		local f27_local0, f27_local1, f27_local2, f27_local3 = GameX.GetAdjustedSafeZoneSize()
		local f27_local4 = Engine.UsingSplitscreenUpscaling() and 5 or 15
		f27_arg0:registerAnimationState( "current", {
			topAnchor = true,
			bottomAnchor = true,
			leftAnchor = true,
			rightAnchor = true,
			left = f27_local0 + f27_local4,
			top = f27_local1 + f27_local4,
			right = f27_local2 - f27_local4,
			bottom = f27_local3 - f27_local4
		} )
		f27_arg0:animateToState( "current" )
	end

	if isBotLayer then
		f13_local8 = f13_local8.botLayer
	else
		if canShake then
			local f13_local9 = f13_local8.shakeable
		end
		f13_local8 = f13_local9 or f13_local8.static
		if canScale then
			local f13_local10 = f13_local8.scalable
			updateSafeAreaMargins(widgetRoot)
		end
		f13_local8 = f13_local10 or f13_local8.fullscreen
	end
	
	f13_local8:addElement( widgetRoot )
	table.insert( hud.allWidgets, widgetRoot )
	return widgetRoot
end

local initWidgets = MPHud.initWidgets
MPHud.initWidgets = function ( f15_arg0 )
	initWidgets(f15_arg0)
	if not Engine.InFrontend() then
		f15_arg0.ac130Hud = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "ac130_overlay",
			properties = {
				enabledAlpha = 1
			}
		} ), {
			shakeable = true,
			scalable = true
		} )
		f15_arg0.empHud = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "emp_overlay",
			properties = {
				enabledAlpha = 1
			}
		} ), {
			shakeable = true,
			scalable = true
		} )
		f15_arg0.predatorHud = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "predator_overlay",
			properties = {
				enabledAlpha = 1
			}
		} ), {
			shakeable = true,
			scalable = true
		} )
		f15_arg0.chopperHud = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "chopper_overlay",
			properties = {
				enabledAlpha = 1
			}
		} ), {
			shakeable = true,
			scalable = true
		} )
		f15_arg0.javelinHud = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "javelinHudDef"
		} ), {
			scalable = true
		} )
		f15_arg0.playercardSplashEvent = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "playercardSplashEventHudDef"
		} ), {
			scalable = true
		} )
		f15_arg0.playercardKillEvent = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "playercardKillEventHudDef"
		} ), {
			scalable = true
		} )
		f15_arg0.deathstreakSplashEvent = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "deathstreakSplashEventHudDef"
		} ), {
			scalable = true
		} )
		f15_arg0.stuckSplashEvent = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
			type = "stuckSplashEventHudDef"
		} ), {
			scalable = true
		} )
	else
		if not Engine.GetDvarBool( "cg_e3TrailerHacks" ) and not GameX.IsHardcoreMode() then
			f15_arg0.lowAmmoWarning = MPHud.addWidget( f15_arg0, LUI.MenuBuilder.buildItems( {
				type = "lowAmmoWarningHudDef"
			} ), {
				shakeable = true,
				scalable = true
			} )
		end
	end
end

hide_hud_for_killstreak = function ()
	local is_in_killstreak = Game.GetOmnvar("ui_killstreak_remote")
	local engineRoot = Engine.GetLuiRoot()

	local minimap = engineRoot:getFirstDescendentById( "minimapHud" )
	local teamScores = engineRoot:getFirstDescendentById( "teamScores_root" )
	local weaponInfo = engineRoot:getFirstDescendentById( "weaponInfoHud" )
	local actionSlot = engineRoot:getFirstDescendentById( "actionSlotHudDef" )

	local alpha_mask = 1

	if is_in_killstreak == true then
		alpha_mask = 0
	end

	if GameX.IsHardcoreMode() ~= true then
		minimap:setAlpha(alpha_mask)
		teamScores:setAlpha(alpha_mask)
		weaponInfo:setAlpha(alpha_mask)
		actionSlot:setAlpha(alpha_mask)
	end
end

local initHandlers = MPHud.initHandlers
MPHud.initHandlers = function (arg0)
	initHandlers(arg0)
	arg0:registerOmnvarHandler( "ui_killstreak_remote", hide_hud_for_killstreak )
end
