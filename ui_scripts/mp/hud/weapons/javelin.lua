local f0_local0 = 0
local alpha_on = 1
local alpha_off = 0
local f0_local3 = 0.1
local f0_local4 = 35
local f0_local5 = 35
local f0_local6 = 2048
local f0_local7 = 4096
local f0_local8 = math.pi
local f0_local9 = 0
local f0_local10 = 1536
local f0_local11 = function ( f1_arg0 )
	if f1_arg0.targetRight ~= nil and f1_arg0.targetWidth ~= nil then
		f1_arg0:registerAnimationState( "current", {
			width = f1_arg0.targetWidth * f0_local0,
			right = f1_arg0.targetRight * f0_local0
		} )
	elseif f1_arg0.targetLeft ~= nil and f1_arg0.targetWidth ~= nil then
		f1_arg0:registerAnimationState( "current", {
			width = f1_arg0.targetWidth * f0_local0,
			left = f1_arg0.targetLeft * f0_local0
		} )
	elseif f1_arg0.targetLeft ~= nil and f1_arg0.targetRight ~= nil then
		f1_arg0:registerAnimationState( "current", {
			right = f1_arg0.targetRight * f0_local0,
			left = f1_arg0.targetLeft * f0_local0
		} )
	elseif f1_arg0.targetLeft ~= nil then
		f1_arg0:registerAnimationState( "current", {
			left = f1_arg0.targetLeft * f0_local0
		} )
	elseif f1_arg0.targetRight ~= nil then
		f1_arg0:registerAnimationState( "current", {
			right = f1_arg0.targetRight * f0_local0
		} )
	elseif f1_arg0.targetWidth ~= nil then
		f1_arg0:registerAnimationState( "current", {
			width = f1_arg0.targetWidth * f0_local0
		} )
	end
	f1_arg0:animateToState( "current" )
end

local f0_local12 = function ( f2_arg0, f2_arg1, f2_arg2 )
	if f2_arg0._state ~= f2_arg1 then
		f2_arg0._state = f2_arg1
		f2_arg0:animateToState( f2_arg1, f2_arg2 )
	end
end

local f0_local13 = function ( f3_arg0 )
	f3_arg0:registerAnimationState( "on", {
		alpha = alpha_on
	} )
	f3_arg0:registerAnimationState( "off", {
		alpha = alpha_off
	} )
	return f3_arg0
end

local f0_local14 = function ( f4_arg0 )
	local NVGEnabled = Game.GetPlayerActionSlotActive(0)

	if NVGEnabled == true then
		f0_local12( f4_arg0.parent.dayLight, "off" )
		f0_local12( f4_arg0.parent.nightLight, "on" )
	else
		f0_local12( f4_arg0.parent.dayLight, "on" )
		f0_local12( f4_arg0.parent.nightLight, "off" )
	end
end

local f0_local15 = function ( f5_arg0, f5_arg1, f5_arg2 )
	if f5_arg0 < f5_arg1 then
		return f5_arg1
	elseif f5_arg2 < f5_arg0 then
		return f5_arg2
	else
		return f5_arg0
	end
end

local f0_local16 = function ( f6_arg0 )
	local f6_local0, f6_local1, f6_local2, f6_local3, f6_local4, f6_local5, f6_local6, f6_local7, f6_local8 = Game.GetPlayerVectors()
	local f6_local9 = math.acos( f6_local0 )
	local f6_local10 = math.acos( f6_local8 )
	if f6_local1 < 0 then
		f6_local9 = math.pi - f6_local9 + math.pi
	end
	if f6_local2 > 0 then
		f6_local10 = math.pi - f6_local10 + math.pi
	end
	if f6_arg0.firstRun then
		f6_arg0.black:registerAnimationState( "off", {
			alpha = 0
		} )
		f0_local12( f6_arg0.black, "off", 0.25 )
		f6_arg0.forward.acosx = f6_local9
		f6_arg0.up.acosz = f6_local10
		f6_arg0.firstRun = false
	end
	local f6_local11 = nil
	local f6_local12 = math.abs( f6_local9 - f6_arg0.forward.acosx )
	if f0_local9 <= f6_local12 and f6_local12 <= f0_local8 then
		f6_local11 = math.acos( f0_local15( f6_local0 * f6_arg0.forward.x + f6_local1 * f6_arg0.forward.y + f6_local2 * f6_arg0.forward.z, -1, 1 ) )
		if f6_arg0.forward.acosx < f6_local9 then
			f6_local11 = -f6_local11
		end
	elseif f6_local12 == 0 then
		f6_local11 = 0
	else
		f6_local11 = f6_arg0.forward.delta
	end
	local f6_local13 = nil
	local f6_local14 = math.abs( f6_local10 - f6_arg0.up.acosz )
	if f0_local9 <= f6_local14 and f6_local14 <= f0_local8 then
		f6_local13 = math.acos( f0_local15( f6_local6 * f6_arg0.up.x + f6_local7 * f6_arg0.up.y + f6_local8 * f6_arg0.up.z, -1, 1 ) )
		if f6_local10 < f6_arg0.up.acosz then
			f6_local13 = -f6_local13
		end
	elseif f6_local14 == 0 then
		f6_local13 = 0
	else
		f6_local13 = f6_arg0.up.delta
	end
	f6_arg0.forward.delta = f6_arg0.forward.delta * (1 - f0_local3) + f6_local11 * f0_local3
	f6_arg0.up.delta = f6_arg0.up.delta * (1 - f0_local3) + f6_local13 * f0_local3
	f6_arg0.forward.x = f6_local0
	f6_arg0.forward.y = f6_local1
	f6_arg0.forward.z = f6_local2
	f6_arg0.forward.acosx = f6_local9
	f6_arg0.up.x = f6_local6
	f6_arg0.up.y = f6_local7
	f6_arg0.up.z = f6_local8
	f6_arg0.up.acosz = f6_local10
	f6_arg0.lensShadow:registerAnimationState( "move", {
		left = -f0_local10 / 2 + f0_local15( f6_arg0.forward.delta * f0_local6, -f0_local4, f0_local4 ),
		top = -f0_local10 / 2 + f0_local15( f6_arg0.up.delta * f0_local7, -f0_local5, f0_local5 ),
		width = f0_local10,
		height = f0_local10
	} )
	f6_arg0.lensShadow:animateToState( "move", 0 )
end

local f0_local17 = function ( f7_arg0 )
	local f7_local0 = {
		[false] = "off",
		[true] = "on"
	}
	local f7_local1 = Game.CheckWeapLockBlink( 4.5 )
	local f7_local2 = Game.CheckWeapLockBlink( 0 )
	local f7_local3 = Game.CheckWeapLockBlink( 17 )
	local f7_local4 = Game.CheckWeapLockAttackTop()
	local f7_local5 = Game.CheckWeapLockAttackDirect()
	local f7_local6 = Game.GetPlayerClipAmmo( 1 ) > 0
	local f7_local7 = f7_local2
	local f7_local8
	if not f7_local4 then
		f7_local8 = not f7_local5
	else
		f7_local8 = false
	end
	local f7_local9 = f7_local4
	local f7_local10 = not f7_local6
	local f7_local11
	if not f7_local2 then
		f7_local11 = not f7_local4
	else
		f7_local11 = false
	end
	local f7_local12 = Game.GetOmnvar( "ui_javelin_lock_status" )
	f0_local12( f7_arg0.lockOn, f7_local0[f7_local1] )
	f0_local12( f7_arg0.lightClu, f7_local0[f7_local8] )
	f0_local12( f7_arg0.attackTop, f7_local0[f7_local9] )
	f0_local12( f7_arg0.direct, f7_local0[f7_local5] )
	f0_local12( f7_arg0.rocketOn, f7_local0[f7_local6] )
	f0_local12( f7_arg0.noRocket, f7_local0[f7_local10] )
	f0_local12( f7_arg0.lockBox, f7_local0[f7_local3] )
	f0_local12( f7_arg0.reticle, f7_local0[f7_local11] )
	local f7_local13 = f7_local12
	if f7_arg0.lockStatus ~= f7_local13 then
		f7_arg0.lockStatus = f7_local13
		Engine.SetDvarBool( "vehHudUseTargetingCorners", f7_arg0.lockStatus > 0 )
	end
	if f7_arg0.lockStatus > 0 then
		local f7_local14 = nil
		if f7_local3 then
			f7_local14 = 1
		else
			f7_local14 = 0
		end
		Engine.SetDvarFloat( "vehHudTargetingCornersAlpha", f7_local14 )
	end
end

local f0_local18 = function ( f8_arg0 )
	local f8_local0 = Engine.GetAspectRatio()
	local f8_local1 = f8_local0 / 1.78
	if f8_local1 ~= f0_local0 then
		f0_local0 = f8_local1
		local f8_local2 = 1.33
		if f8_local2 <= f8_local0 then
			Engine.SetDvarFloat( "vehHudTargetScreenEdgeClampBufferLeft", 145 / f8_local0 / f8_local2 )
			Engine.SetDvarFloat( "vehHudTargetScreenEdgeClampBufferRight", 145 / f8_local0 / f8_local2 )
		else
			Engine.SetDvarFloat( "vehHudTargetScreenEdgeClampBufferLeft", 145 )
			Engine.SetDvarFloat( "vehHudTargetScreenEdgeClampBufferRight", 145 )
		end
		Engine.SetDvarFloat( "vehHudTargetScreenEdgeClampBufferTop", 139 )
		Engine.SetDvarFloat( "vehHudTargetScreenEdgeClampBufferBottom", 134 )
		if f8_arg0.overlayElements ~= nil then
			for f8_local6, f8_local7 in pairs( f8_arg0.overlayElements ) do
				f0_local11( f8_local7 )
			end
		end
	end
end

local f0_local19 = function ( f9_arg0 )
	f0_local18( f9_arg0 )
	f0_local17( f9_arg0 )
	f0_local16( f9_arg0 )
end

local f0_local20 = function ( f10_arg0, f10_arg1 )
	f0_local19( f10_arg0 )
end

local f0_local21 = function ( f11_arg0 )
	if f11_arg0.on then
		return 
	else
		f11_arg0.timer = LUI.UITimer.new( 10, {
			name = "timer_event"
		}, "hud", false )
		f11_arg0:registerEventHandler( "timer_event", f0_local20 )
		f11_arg0:addElement( f11_arg0.timer )
		f11_arg0.firstRun = true
		f0_local12( f11_arg0, "on" )
		f11_arg0.on = true
		f0_local0 = 0
		f0_local19( f11_arg0 )
	end
end

local f0_local22 = function ( f12_arg0 )
	if not f12_arg0.on then
		return 
	elseif f12_arg0.timer ~= nil then
		LUI.UITimer.Stop( f12_arg0.timer )
		f12_arg0.timer:close()
		f12_arg0.timer = nil
	end
	f12_arg0.black:registerAnimationState( "on", {
		alpha = 1
	} )
	f0_local12( f12_arg0.black, "on" )
	f0_local12( f12_arg0, "off" )
	f12_arg0.on = false
end

local f0_local23 = function ( f13_arg0, f13_arg1 )
	
	local is_player_dead = Game.GetOmnvar("ui_session_state") == "dead"

	if is_player_dead then
		f0_local22( f13_arg0 )
		return
	end

	local weapon = Game.GetPlayerWeaponName()
	if weapon ~= "javelin_mp" then
		f0_local22( f13_arg0 )
		return
	end
	
	if f13_arg1.newValue == 1 then
		f0_local21( f13_arg0 )
	else
		f0_local22( f13_arg0 )
	end

	local NVGEnabled = Game.GetPlayerActionSlotActive(0)

	if NVGEnabled == true then
		f0_local12( f13_arg0.dayLight, "off" )
		f0_local12( f13_arg0.nightLight, "on" )
	else
		f0_local12( f13_arg0.dayLight, "on" )
		f0_local12( f13_arg0.nightLight, "off" )
	end
end

local f0_local24 = function ( f14_arg0 )
	f14_arg0.overlayElements = {}
	f14_arg0:registerAnimationState( "off", {
		alpha = 0
	} )
	f14_arg0:registerAnimationState( "on", {
		alpha = 1
	} )
	local javelinElement = LUI.UIImage.new( {
		height = 512,
		material = RegisterMaterial( "h1_javelin_overlay_distort" )
	} )
	javelinElement.targetWidth = 1024
	javelinElement.id = "javelinDistortId"
	f14_arg0:addElement( javelinElement )
	table.insert( f14_arg0.overlayElements, javelinElement )
	local overlayGrain = LUI.UIImage.new( {
		width = 793.6 * Engine.GetAspectRatio() / 1.78,
		height = 793.6,
		material = RegisterMaterial( "javelin_overlay_grain" ),
		alpha = 1
	} )
	overlayGrain.id = "javelinGrainId"
	f14_arg0:addElement( overlayGrain )
	local crosshairElement = LUI.UIElement.new( {} )
	crosshairElement.id = "javelinCrosshairsId"
	crosshairElement:setupOwnerdraw( CoD.Ownerdraw.CGHudTargetsJavelin )
	crosshairElement:registerAnimationState( "default", {
		alpha = 0.5
	} )
	crosshairElement:animateToState( "default", 0 )
	f14_arg0:addElement( crosshairElement )
	local javelinBGElement = LUI.UIImage.new( {
		leftAnchor = true,
		rightAnchor = true,
		topAnchor = true,
		bottomAnchor = true,
		top = -10,
		bottom = 20,
		material = RegisterMaterial( "hud_javelin_bg" ),
		alpha = 1
	} )
	javelinBGElement.id = "javelinBgId"
	f14_arg0:addElement( javelinBGElement )
	local activeAreaElement = LUI.UIImage.new( {
		height = 152,
		material = RegisterMaterial( "h1_hud_javelin_active_area" ),
		alpha = 0.5
	} )
	activeAreaElement.targetWidth = 304
	activeAreaElement.id = "javelinReticleId"
	f14_arg0:addElement( activeAreaElement )
	table.insert( f14_arg0.overlayElements, activeAreaElement )
	local lockBoxElement = LUI.UIImage.new( {
		height = 152,
		material = RegisterMaterial( "hud_javelin_lock_box" ),
		alpha = 0.25
	} )
	lockBoxElement.targetWidth = 304
	lockBoxElement.id = "javelinLockBoxId"
	f14_arg0:addElement( lockBoxElement )
	table.insert( f14_arg0.overlayElements, lockBoxElement )
	local dayOnElement = LUI.UIImage.new( {
		height = 128,
		bottom = -198,
		material = RegisterMaterial( "hud_javelin_day_on" ),
		alpha = 1
	} )
	dayOnElement.targetWidth = 128
	dayOnElement.targetRight = -268
	dayOnElement.id = "javelinLightDayId"
	f14_arg0:addElement( dayOnElement )
	table.insert( f14_arg0.overlayElements, dayOnElement )
	local lockOnElement = LUI.UIImage.new( {
		height = 128,
		bottom = -200,
		material = RegisterMaterial( "hud_javelin_lock_on" ),
		alpha = 1
	} )
	lockOnElement.targetWidth = 128
	lockOnElement.targetLeft = 250
	lockOnElement.id = "javelinLightLockId"
	f14_arg0:addElement( lockOnElement )
	table.insert( f14_arg0.overlayElements, lockOnElement )
	local topOnElement = LUI.UIImage.new( {
		height = 128,
		bottom = -85,
		material = RegisterMaterial( "hud_javelin_top_on" ),
		alpha = alpha_off
	} )
	topOnElement.targetWidth = 128
	topOnElement.targetLeft = 389
	topOnElement.id = "javelinLightTopId"
	f14_arg0:addElement( topOnElement )
	table.insert( f14_arg0.overlayElements, topOnElement )
	local dirOnElement = LUI.UIImage.new( {
		height = 128,
		top = -63,
		material = RegisterMaterial( "hud_javelin_dir_on" ),
		alpha = alpha_off
	} )
	dirOnElement.targetWidth = 128
	dirOnElement.targetLeft = 392
	dirOnElement.id = "javelinLightDirId"
	f14_arg0:addElement( dirOnElement )
	table.insert( f14_arg0.overlayElements, dirOnElement )
	local noRocketElement = LUI.UIImage.new( {
		height = 128,
		top = 206,
		material = RegisterMaterial( "hud_javelin_norocket_on" ),
		alpha = alpha_off
	} )
	noRocketElement.targetWidth = 128
	noRocketElement.targetLeft = 251
	noRocketElement.id = "javelinLightNoRocketId"
	f14_arg0:addElement( noRocketElement )
	table.insert( f14_arg0.overlayElements, noRocketElement )
	local rocketOnElement = LUI.UIImage.new( {
		height = 128,
		top = 209,
		material = RegisterMaterial( "hud_javelin_rocket_on" ),
		alpha = 1
	} )
	rocketOnElement.targetWidth = 128
	rocketOnElement.targetLeft = 40
	rocketOnElement.id = "javelinLightRocketId"
	f14_arg0:addElement( rocketOnElement )
	table.insert( f14_arg0.overlayElements, rocketOnElement )
	local cluOnElement = LUI.UIImage.new( {
		height = 128,
		top = -62,
		material = RegisterMaterial( "hud_javelin_clu_on" ),
		alpha = 1
	} )
	cluOnElement.targetWidth = 128
	cluOnElement.targetRight = -406
	cluOnElement.id = "javelinLightCluId"
	f14_arg0:addElement( cluOnElement )
	table.insert( f14_arg0.overlayElements, cluOnElement )
	local nightOnElement = LUI.UIImage.new( {
		height = 128,
		bottom = -85,
		material = RegisterMaterial( "hud_javelin_night_on" ),
		alpha = alpha_off
	} )
	nightOnElement.targetWidth = 128
	nightOnElement.targetRight = -403
	nightOnElement.id = "javelinLightNightId"
	f14_arg0:addElement( nightOnElement )
	table.insert( f14_arg0.overlayElements, nightOnElement )
	local lensShadowElement = LUI.UIImage.new( {
		width = f0_local10,
		height = f0_local10,
		alpha = 1,
		material = RegisterMaterial( "h1_hud_javelin_lens_shadow" )
	} )
	lensShadowElement.id = "javelinLensShadowId"
	f14_arg0:addElement( lensShadowElement )
	local eyePieceElement = LUI.UIImage.new( {
		height = 1700,
		material = RegisterMaterial( "h1_hud_javelin_eyepiece" ),
		alpha = 1
	} )
	eyePieceElement.targetWidth = 1700
	eyePieceElement.id = "javelinEyepieceId"
	f14_arg0:addElement( eyePieceElement )
	table.insert( f14_arg0.overlayElements, eyePieceElement )
	local blackIdElement = LUI.UIImage.new( {
		width = f0_local10,
		height = f0_local10,
		red = 0,
		green = 0,
		blue = 0,
		alpha = 0,
		material = nil
	} )
	blackIdElement.id = "javelinBlackId"
	f14_arg0:addElement( blackIdElement )
	-- f14_arg0:registerEventHandler( "UpdateActionSlots", f0_local14 )
	local actionSlotWatcherElement = LUI.UIElement.new()
	actionSlotWatcherElement.id = "actionslot_watch"
	actionSlotWatcherElement:setupUIIntWatch( "PlayerActionSlotActive" )
	actionSlotWatcherElement:registerEventHandler( "int_watch_alert", f0_local14 )
	actionSlotWatcherElement.parent = f14_arg0
	f14_arg0:addElement(actionSlotWatcherElement)
	f14_arg0.lockOn = f0_local13( lockOnElement )
	f14_arg0.attackTop = f0_local13( topOnElement )
	f14_arg0.direct = f0_local13( dirOnElement )
	f14_arg0.noRocket = f0_local13( noRocketElement )
	f14_arg0.rocketOn = f0_local13( rocketOnElement )
	f14_arg0.lightClu = f0_local13( cluOnElement )
	f14_arg0.dayLight = f0_local13( dayOnElement )
	f14_arg0.nightLight = f0_local13( nightOnElement )
	f14_arg0.lockBox = f0_local13( lockBoxElement )
	f14_arg0.reticle = f0_local13( activeAreaElement )
	f14_arg0.lensShadow = lensShadowElement
	f14_arg0.black = blackIdElement
	f14_arg0.forward = {
		acosx = 0,
		delta = 0,
		x = 0,
		y = 0,
		z = 0
	}
	f14_arg0.up = {
		acosz = 0,
		delta = 0,
		x = 0,
		y = 0,
		z = 0
	}
	f14_arg0.firstRun = true
	f14_arg0:setupUIIntWatch( "PlayerADS" )
	f14_arg0:registerEventHandler( "int_watch_alert", f0_local23 )
	f14_arg0:registerOmnvarHandler( "ui_session_state", f0_local23 )
	f0_local12( f14_arg0, "off" )
	f0_local18( f14_arg0 )
	return f14_arg0
end

local f0_local25 = function ( f15_arg0, f15_arg1 )
	if f15_arg1.value and not f15_arg0.ready then
		f0_local24( f15_arg0 )
		f15_arg0.ready = true
	end
end

LUI.MenuBuilder.registerType( "javelinHudDef", function ()
	local mainElement = LUI.UIElement.new({
		leftAnchor = true,
		rightAnchor = true,
		topAnchor = true,
		bottomAnchor = true,
		left = 0,
		right = 0,
		top = -10,
		bottom = 0
	} )
	mainElement.id = "javelinRootId"
	mainElement:registerOmnvarHandler( "ui_javelin", f0_local25 )
	f0_local25( mainElement, {
		name = "ui_javelin",
		value = Game.GetOmnvar( "ui_javelin" )
	} )
	return mainElement
end )