local function shouldWeaponShowAmmo( f1_arg0, f1_arg1 )
	if not f1_arg1 then
		f1_arg1 = Game.GetPlayerWeaponName()
	end
	if f1_arg0.current_weaponName ~= f1_arg1 then
		f1_arg0.current_weaponName = f1_arg1
		f1_arg0.current_showAmmo = false
		if f1_arg1 == "none" then
			f1_arg0.current_showAmmo = false
			return false
		elseif string.find( f1_arg1, "riotshield" ) then
			f1_arg0.current_showAmmo = false
			return false
		elseif CoD.WeaponListKillstreak[f1_arg1] ~= nil or CoD.WeaponListSpecial[f1_arg1] ~= nil then
			f1_arg0.current_showAmmo = false
			return false
		else
			f1_arg0.current_showAmmo = true
			return true
		end
	else
		return f1_arg0.current_showAmmo
	end
end

local function updateAmmoEmptyText(f2_arg0, f2_arg1)
    assert(f2_arg1)

    local f2_local6 = Game.GetPlayerWeaponClass(1)
    local isLowAmmo = f2_local6 == WeaponClasses.Sniper

    if isLowAmmo then
        local f2_local13 = Game.GetPlayerMaxClipAmmo(1)
        local f2_local14 = f2_local13 * 0.33
        local f2_local15 = isLowAmmo and 0 or math.max(3, math.ceil(f2_local13 * 0.33))
        local f2_local16 = Game.IsStockAmmoHidden()
        local f2_local3 = Game.GetPlayerWeaponDisplayName()
        print(f2_local3)

        if f2_local3 ~= "" and f2_local3 ~= "none" then
            local f2_local17 = "default"
            local f2_local11 = Game.GetPlayerClipAmmo(1)
            local f2_local12 = Game.GetPlayerClipAmmo(2)
            local f2_local10 = Game.GetPlayerStockAmmo()

            if f2_arg1.isStock and f2_local16 then
                f2_local17 = "hidden"
            elseif f2_arg1.isStock and f2_local10 == 0 then
                f2_local17 = "depleted"
            elseif f2_arg1.isPrimary and f2_local11 <= f2_local14 then
                f2_local17 = "depleted"
            elseif f2_arg1.isSecondary and f2_local12 <= f2_local14 then
                f2_local17 = "depleted"
            end

            if f2_arg0.currentState ~= f2_local17 then
                f2_arg0:animateToState(f2_local17)
                f2_arg0.currentState = f2_local17
            end
        end
    end
end

local function updateAmmoWarningText( f3_arg0, f3_arg1 )
	assert( f3_arg1 )
	local f3_local0 = Game.GetPlayerWeaponName()
	if shouldWeaponShowAmmo( f3_arg0, f3_local0 ) and Game.PlayerCanReloadWeapon() and Game.GetPlayerMaxClipAmmo( 1 ) > 0 then
		local f3_local1 = Game.GetPlayerStockAmmo()
		local f3_local2 = Game.GetPlayerMaxClipAmmo()
		local f3_local3 = Game.GetPlayerClipAmmo( 1 )
		local f3_local4 = Game.GetPlayerClipAmmo( 2 )
		local f3_local5 = 0.33
		local f3_local6 = ""
		local f3_local7 = "default"
		local f3_local8 = "reset"
		local f3_local9 = string.find( f3_local0, "akimbo" ) ~= nil
		if not (f3_local9 ~= false or f3_local3 ~= 0 or f3_local1 ~= 0) or f3_local9 == true and f3_local3 == 0 and f3_local4 == 0 and f3_local1 == 0 then
			f3_local6 = Engine.Localize( "@WEAPON_NO_AMMO_CAPS" )
			f3_local7 = "no_ammo"
			f3_local8 = "out"
		elseif f3_local3 <= f3_local2 * f3_local5 or f3_local9 and f3_local4 <= f3_local2 * f3_local5 then
			if f3_local1 == 0 then
				f3_local6 = Engine.Localize( "@PLATFORM_LOW_AMMO_NO_RELOAD_CAPS" )
				f3_local7 = "low_ammo"
				f3_local8 = "low"
			elseif f3_local3 ~= 0 or f3_local9 and f3_local4 ~= 0 then
				f3_local6 = Engine.Localize( "@PLATFORM_RELOAD_CAPS" )
				f3_local7 = "reloading"
				f3_local8 = "reload"
			end
		end
		f3_arg0:show()
		if f3_arg0.current_state ~= f3_local7 then
			f3_arg0.current_state = f3_local7
			f3_arg0:processEvent( {
				name = "update_message_text",
				dispatchChildren = true,
				text = f3_local6
			} )
			f3_arg0:processEvent( {
				name = f3_local8,
				dispatchChildren = true
			} )
		end
	else
		f3_arg0:hide()
	end
end

local function lowAmmoWarningHudDef()
    local isSplitscreen = Engine.UsingSplitscreenUpscaling()
    local offset = isSplitscreen and 105 or -210
    local anchor = isSplitscreen

    local hudElement = LUI.UIElement.new({
        topAnchor = anchor,
        bottomAnchor = not anchor,
        leftAnchor = false,
        rightAnchor = false,
        bottom = offset,
        width = 400,
        height = 32
    })
    hudElement.id = "lowAmmoWarningHud"

    local updateFunction = function(f6_arg0, f6_arg1)
        updateAmmoWarningText(hudElement, {})
    end
    updateFunction()

    local bgElement = LUI.UIImage.new({
        width = 140,
        height = 74,
        material = RegisterMaterial("h1_hud_ammo_status_bg"),
        alpha = 0
    })
    bgElement.id = "lowAmmoWarningBackground_id"

    bgElement:registerAnimationState("reload", 
        {
            color = {
                r = 1,
                g = 1,
                b = 1
            },
            alpha = 0.5
        }
    )
    bgElement:registerAnimationState("low", 
        {
            color = {
                r = 1,
                g = 0.99,
                b = 0.14
            },
            alpha = 0.5
        }
    )
    bgElement:registerAnimationState("out", 
        {
            color = Swatches.HUD.Caution,
            alpha = 1
        }
    )

    bgElement:registerEventHandler("reload", MBh.AnimateToState("reload", 0))
    bgElement:registerEventHandler("low", MBh.AnimateToState("low", 0))
    bgElement:registerEventHandler("out", MBh.AnimateToState("out", 0))
    bgElement:registerEventHandler("reset", MBh.AnimateToState("default", 0))

    local textElement = LUI.UIText.new({
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = true,
        top = 9,
        left = 0,
        right = 0,
        height = 16,
        font = CoD.TextSettings.TitleFontTiny.Font,
        alignment = LUI.Alignment.Center,
        color = Swatches.HUD.Black,
        alpha = 0
    })
    textElement.id = "lowAmmoWarningMessageText_id"
    textElement:setText("")
    textElement:setTextStyle(CoD.TextStyle.Shadowed)

    textElement:registerAnimationState("reload", 
        {
            color = {
                r = 1,
                g = 1,
                b = 1
            },
            alpha = 1
        }
    )
    textElement:registerAnimationState("low", 
        {
            color = {
                r = 1,
                g = 0.99,
                b = 0.14
            },
            alpha = 1
        }
    )
    textElement:registerAnimationState("out", 
        {
            color = Swatches.HUD.Caution,
            alpha = 1
        }
    )

    textElement:registerEventHandler("reload", MBh.AnimateToState("reload", 0))
    textElement:registerEventHandler("low", MBh.AnimateToState("low", 0))
    textElement:registerEventHandler("out", MBh.AnimateToState("out", 0))
    textElement:registerEventHandler("reset", MBh.AnimateToState("default", 0))

    textElement:registerEventHandler("update_message_text", function(element, event)
        assert(event)
        element:setText(event.text)
    end)

    hudElement:addElement(bgElement)
    hudElement:addElement(textElement)

    local clipAmmoLeftWatch = LUI.UIElement.new()
    clipAmmoLeftWatch:setupUIIntWatch("ClipAmmoLeft")
    clipAmmoLeftWatch.id = "clip_ammo_left_watch"
    clipAmmoLeftWatch:registerEventHandler("int_watch_alert", updateFunction)
    clipAmmoLeftWatch:registerEventHandler("weapon_change", updateFunction)
    hudElement:addElement(clipAmmoLeftWatch)

    local clipAmmoRightWatch = LUI.UIElement.new()
    clipAmmoRightWatch:setupUIIntWatch("ClipAmmoRight")
    clipAmmoRightWatch.id = "clip_ammo_right_watch"
    clipAmmoRightWatch:registerEventHandler("int_watch_alert", updateFunction)
    clipAmmoRightWatch:registerEventHandler("weapon_change", updateFunction)
    hudElement:addElement(clipAmmoRightWatch)

    return hudElement
end

LUI.MenuBuilder.m_types_build["lowAmmoWarningHudDef"] = lowAmmoWarningHudDef
