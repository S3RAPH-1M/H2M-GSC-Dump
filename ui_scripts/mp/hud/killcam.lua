local KILLCAM_BAR_HEIGHT = 90.0
local KILLCAM_BAR_ALPHA = 0.4
local KILLCAM_TEXT_ALPHA = 0.9

local f0_local6 = 4

local f0_local10 = function(f1_arg0, f1_arg1)
    if not f1_arg0.kcElems then
        f1_arg0.kcElems = {}
        local f1_local0 = {
            "killCamRespawnText",
            "killCamCopycatText",
            "killCamWeaponImage",
			"killCamWeaponHL",
			"killCamWeaponNameText",
			"killCamWeaponNameBg",
			"killCamAbilitiesHL",
            "attackerPlayerCard",
            "killCamVictimAttacker",
            "killCamVictimAttackerText",
            --"killCamCountDownBar",
            --"killCamCountDownTimerText",
            "killCamTextBarsBg",
            "killCamBottom",
            "killCamTitleText",
            --"killCamVSOrNemesisText",
            --"leftScoreText",
            --"rightScoreText",
            --"versusTriangle",
            "nemesisSkull",
            "killCamPerk1Image",
            "killCamPerk2Image",
            "killCamPerk3Image",
            "rightFactionIcon",
            "rightNameText",
            "leftFactionIcon",
            "leftNameText",
            "killCamTopBar",
            "killCamBottomBar"
        }
        for f1_local1 = 1, #f1_local0, 1 do
            f1_arg0.kcElems[f1_local0[f1_local1]] = f1_arg0:getFirstDescendentById(f1_local0[f1_local1])
        end
    end
end

local f0_local11 = function(f2_arg0)
    local f2_local0 = f2_arg0.kcElems.killCamTitleText
    --local f2_local1 = f2_arg0.kcElems.killCamCountDownTimerText
    local topBar = f2_arg0.kcElems.killCamTopBar
    local bottomBar = f2_arg0.kcElems.killCamBottomBar
    local f2_local2 = Engine.GetDvarString("ui_game_state") == "postgame"
    local f2_local3 = Game.GetOmnvar("ui_killcam_type")
    local killcam_text = nil
    if f2_local2 then
        killcam_text = Engine.Localize("@LUA_MENU_KILLCAM_FINAL_CAPS")
    else
        killcam_text = Engine.Localize("@LUA_MENU_KILLCAM_CAPS")
    end
    f2_local0:setText(killcam_text)

    local f2_local5, f2_local6, f2_local7, f2_local8 = GetTextDimensions2(killcam_text, CoD.TextSettings.H1TitleFont.Font, CoD.TextSettings.H1TitleFont.Height)

    f2_arg0.headerContainer:registerAnimationState("updateWidth", {
        width = f2_local7 - f2_local5 + 15
    })
    f2_arg0.headerContainer:animateToState("updateWidth")
    if f2_local2 then
        --f2_local1:animateToState("final", 0)
        topBar:animateToState("final", 0)
        bottomBar:animateToState("final", 0)
    else
        --f2_local1:animateToState("default", 0)
        topBar:animateToState("default", 0)
        bottomBar:animateToState("default", 0)
    end
end

local f0_local13 = function(f4_arg0)
    local f4_local0 = f4_arg0.kcElems.killCamRespawnText
    local f4_local1 = MBh.AnimateSequence({{"default", 0}, {"active", 250}})
    f4_local1(f4_local0)
    f4_local1 = Game.GetOmnvar("ui_killcam_text")
    if f4_local1 == "skip" then
        f4_local0:setText(Engine.Localize("@PLATFORM_PRESS_TO_SKIP_CAPS"))
    elseif f4_local1 == "respawn" then
        f4_local0:setText(Engine.Localize("@PLATFORM_PRESS_TO_RESPAWN_CAPS"))
    else
        f4_local0:setText("")
    end
end

local f0_local14 = function(f5_arg0)
    local f5_local0 = f5_arg0.kcElems.killCamCopycatText
    local f5_local1 = MBh.AnimateSequence({{"default", 0}, {"active", 250}})
    f5_local1(f5_local0)
    if Game.GetOmnvar("ui_killcam_copycat") then
        f5_local0:setText(Engine.Localize("@PLATFORM_PRESS_TO_COPYCAT"))
    else
        f5_local0:setText("")
    end
end

local f0_local15 = function(f6_arg0, f6_arg1)
    local f6_local0 = f6_arg0.kcElems.killCamCopycatText
    if f6_arg1.value == false then
        f6_local0:setText("")
        return
    else

    end
end

local f0_local16 = function ( f7_arg0 )
	local f7_local0 = f7_arg0.kcElems.killCamWeaponNameText
	local f7_local1 = f7_arg0.kcElems.killCamWeaponNameBg
	local f7_local2 = f7_arg0.kcElems.killCamWeaponImage
	local f7_local3 = {}
	for f7_local4 = 1, f0_local6, 1 do
		f7_local3[f7_local4] = f7_arg0.kcElems.killCamWeaponHL:getChildById( "killCamAttachment" .. f7_local4 )
	end
	local f7_local4 = Game.GetOmnvar( "ui_killcam_killedby_killstreak" )
	local f7_local5 = Game.GetOmnvar( "ui_killcam_killedby_weapon" )
	local f7_local6 = Game.GetOmnvar( "ui_killcam_killedby_weapon_custom" )
	local f7_local7 = Game.GetOmnvar( "ui_killcam_killedby_weapon_alt" )
	local f7_local8 = ""
	local f7_local9 = ""
	local f7_local10 = ""
	local f7_local11, f7_local12 = nil
	if f7_local5 ~= -1 then
		f7_local12 = Game.GetKillCamWeaponIcon( f7_local5, f7_local6, f7_local7 )
		f7_local9 = Game.GetKillCamWeaponName( f7_local5, f7_local6, f7_local7 )
	elseif f7_local4 ~= -1 then
		f7_local10 = Engine.TableLookupByRow( KillstreakTable.File, f7_local4, 25 )
		f7_local9 = Engine.TableLookupByRow( KillstreakTable.File, f7_local4, KillstreakTable.Cols.Name ) .. "_LOWERC"
		if f7_local10 ~= nil then
			f7_local12 = {
				icon = RegisterMaterial( f7_local10 ),
				flip = false
			}
			Engine.CacheMaterial( f7_local12.icon )
		end
	end
	if f7_local12 == nil then
		f7_local2:animateToState( "inactive", 0 )
	else
		local f7_local13 = 40
		local f7_local14 = f7_local13 * Engine.GetMaterialAspectRatio( f7_local12.icon )

		if f7_local4 ~= -1 then
			f7_local13 = 64
			f7_local14 = 64
		end

		local f7_local15 = nil
		local f7_local16 = 0
		if f7_local12.flip then
			f7_local15 = 0
			f7_local14 = -f7_local14
			f7_local16 = nil
		end
		f7_local2:registerAnimationState( "default", {
			topAnchor = false,
			leftAnchor = true,
			bottomAnchor = false,
			rightAnchor = false,
			left = f7_local16,
			right = f7_local15,
			height = f7_local13,
			width = f7_local14,
			alpha = 1,
			material = f7_local12.icon
		} )
		f7_local2:animateToState( "default", 0 )
	end
	local f7_local13
	if f7_local9 and f7_local9 ~= "" then
		f7_local13 = Engine.Localize( f7_local9 )
		if not f7_local13 then
		
		else
			f7_local0:setText( f7_local13 )
			local f7_local17, f7_local14, f7_local15, f7_local16 = GetTextDimensions2( f7_local13, CoD.TextSettings.BodyFontTiny.Font, CoD.TextSettings.BodyFontTiny.Height )
			f7_local1:registerAnimationState( "widthOfMessage", {
				leftAnchor = true,
				rightAnchor = false,
				topAnchor = true,
				bottomAnchor = true,
				left = 0,
				width = f7_local15 - f7_local17 + 4
			} )
			f7_local1:animateToState( "widthOfMessage", 0 )
			for f7_local18 = 1, #f7_local3, 1 do
				local f7_local21 = ""
				if f7_local21 == nil or f7_local21 == "" then
					f7_local3[f7_local18]:animateToState( "default", 0 )
				end
			end
			local f7_local18 = 0
			for f7_local19 = 1, 3, 1 do
				local f7_local23 = f7_arg0.kcElems["killCamPerk" .. f7_local19 .. "Image"]
				local f7_local24 = Game.GetPlayerPerkSlotMaterial( f7_local18 )
				if f7_local24 ~= nil then
					CoD.SetMaterial( f7_local23, f7_local24 )
				else
					f7_local23:animateToState( "empty", 0 )
				end
				f7_local18 = f7_local18 + 1
			end
			f7_arg0.kcElems.killCamWeaponHL:setLayoutCached( false )
		end
	end
	f7_local13 = ""
end


local f0_local17 = function(f8_arg0)
    local f8_local0, f8_local1, f8_local2, f8_local3 = nil
    local f8_local4 = f8_arg0.kcElems.leftFactionIcon
    local f8_local5 = f8_arg0.kcElems.leftNameText
    local f8_local6 = f8_arg0.kcElems.rightFactionIcon
    local f8_local7 = f8_arg0.kcElems.rightNameText
    if Game.GetPlayerTeam() == 1 then
        f8_local0 = Engine.GetDvarString("g_TeamIcon_Axis")
        f8_local2 = Engine.Localize(Engine.GetDvarString("g_TeamName_Axis"))
        f8_local1 = Engine.GetDvarString("g_TeamIcon_Allies")
        f8_local3 = Engine.Localize(Engine.GetDvarString("g_TeamName_Allies"))
    else
        f8_local0 = Engine.GetDvarString("g_TeamIcon_Allies")
        f8_local2 = Engine.Localize(Engine.GetDvarString("g_TeamName_Allies"))
        f8_local1 = Engine.GetDvarString("g_TeamIcon_Axis")
        f8_local3 = Engine.Localize(Engine.GetDvarString("g_TeamName_Axis"))
    end
    if Game.GetPlayerClientnum() == Game.GetOmnvar("ui_killcam_killedby_id") then
        f8_local4:Update(f8_local0)
        f8_local6:Update(f8_local1)
        f8_local5:setText(f8_local2)
        f8_local7:setText(f8_local3)
    else
        f8_local4:Update(f8_local1)
        f8_local6:Update(f8_local0)
        f8_local5:setText(f8_local3)
        f8_local7:setText(f8_local2)
    end
end

local f0_local18 = function(f9_arg0, f9_arg1, f9_arg2)
    local f9_local0 = f9_arg0.kcElems[f9_arg1]
    f9_local0:show()

    if f9_arg2 == -1 then
        f9_local0:animateToState("default", 0)
    else
        f9_local0:animateToState("default")
        f9_local0:processEvent({
            name = "update_playercard_for_clientnum",
            clientNum = f9_arg2
        })
    end
end

local f0_local19 = function(f10_arg0, f10_arg1)
    f10_arg0.kcElems[f10_arg1]:hide()
end

local f0_local20 = function(f11_arg0)
    f0_local18(f11_arg0, "attackerPlayerCard", Game.GetOmnvar("ui_killcam_killedby_id"))
end

local f0_local25 = function(f16_arg0, f16_arg1)
    if f16_arg1.value <= 0 then
        f16_arg0:processEvent({
            name = "killcam_off"
        })
        return
    end
    f0_local11(f16_arg0)
    -- f0_local12(f16_arg0)
    f0_local13(f16_arg0)
    f0_local14(f16_arg0)
    f0_local16(f16_arg0)
    if not GameX.gameModeIsFFA() then
        f0_local17(f16_arg0)
    end
    f0_local20(f16_arg0)
    f16_arg0.kcElems.killCamBottom:animateToState("active", 0)
    f16_arg0.kcElems.killCamTitleText:animateToState("active", 0)
    f16_arg0:dispatchEventToChildren({
        name = "killcam_on"
    })
    f16_arg0:processEvent({
        name = "killcam_on"
    })
    f16_arg0:animateToState("active", 0)
end

local f0_local26 = function(f17_arg0, f17_arg1)
    --local f17_local0 = f17_arg0.kcElems.killCamCountDownBar
    local f17_local1 = f17_arg0.kcElems.killCamVictimAttacker
    local f17_local2 = f17_arg0.kcElems.killCamVictimAttackerText
    local f17_local4 = f17_arg0.kcElems.killCamBottom
    local f17_local5 = f17_arg0.kcElems.killCamTitleText
    --f17_local0:animateToState("inactive", 0)
    if f17_arg1.value == 0 then
        f17_arg0:animateToState("active", 0)
        f17_local4:animateToState("default", 0)
        local f17_local6 = MBh.AnimateSequence({{"default", 0}, {"active", 250}, {"active", 1250}, {"default", 250}})
        -- f17_local6(f17_local3)
        f17_local2:setText("")
        f17_local6 = MBh.AnimateSequence({{"default", 0}, {"active", 250}, {"active", 1250}, {"default", 250}})
        f17_local6(f17_local1)
    elseif f17_arg1.value == 1 then
        f0_local20(f17_arg0)
        f17_arg0:animateToState("active", 0)
        f17_local5:animateToState("inactive", 0)
        local f17_local6 = MBh.AnimateSequence({{"default", 0}, {"active", 250}, {"active", 4500}})
        -- f17_local6(f17_local3)
        f17_local2:setText("")
        f17_local6 = MBh.AnimateSequence({{"default", 0}, {"active", 250}, {"active", 2000}, {"default", 250}})
        f17_local6(f17_local1)
        f17_local6 = MBh.AnimateSequence({{"default", 0}, {"active", 250}})
        f17_local6(f17_local4)
    else
        f17_arg0:animateToState("default", 0)
    end
end

local f0_local27 = function(f18_arg0)
    local self = LUI.UIElement.new()
    self.id = "killCamTextBarsBg"
    self:registerAnimationState("default", {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        alpha = 1
    })
    self:animateToState("default", 0)
    self:registerAnimationState("inactive", {
        alpha = 0
    })

    local attacker_playercard = LUI.Playercard.new({
        topAnchor = false,
        leftAnchor = false,
        bottomAnchor = true,
        rightAnchor = false,
        height = LUI.Playercard.Height * 2,
        width = LUI.Playercard.Width * 2,
        bottom = -52,
        left = -118
    })
    attacker_playercard.id = "attackerPlayerCard"
    attacker_playercard:setPriority(9999)

    local top_bar_kc_bg = LUI.UIImage.new({
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = false,
        rightAnchor = true,
        height = KILLCAM_BAR_HEIGHT,
        alpha = KILLCAM_BAR_ALPHA,
        red = 0.2,
        blue = 0.0,
        green = 0.0,
        material = RegisterMaterial("white") -- h1_ui_killcam_header_bg_not_tiled
    })
    top_bar_kc_bg.id = "killCamTopBar"
    top_bar_kc_bg:registerAnimationState("default",
    {
        red = 0.2,
        green = 0.0,
        blue = 0.0
    })
    top_bar_kc_bg:registerAnimationState("final",
    {
        red = 0.0,
        green = 0.0,
        blue = 0.0
    })
    top_bar_kc_bg:setPriority(9998)

    local bottom_bar_kc_bg = LUI.UIImage.new({
        topAnchor = false,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        height = KILLCAM_BAR_HEIGHT,
        alpha = KILLCAM_BAR_ALPHA,
        red = 0.0,
        blue = 0.0,
        green = 0.0,
        material = RegisterMaterial("white") -- h1_ui_killcam_header_bg_not_tiled
    })
    bottom_bar_kc_bg.id = "killCamBottomBar"
    bottom_bar_kc_bg:registerAnimationState("default",
    {
        red = 0.2,
        green = 0.0,
        blue = 0.0
    })
    bottom_bar_kc_bg:registerAnimationState("final",
    {
        red = 0.0,
        green = 0.0,
        blue = 0.0
    })
    bottom_bar_kc_bg:setPriority(9998)

    local killcam_text_title_bg = LUI.UIImage.new({
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = false,
        rightAnchor = false,
        left = 276,
        height = 106.67,
        width = 728,
        alpha = 0.9,
        material = RegisterMaterial("h1_ui_topbar_title_bg")
    })

    -- TODO: support all modes and get rid of FFA check
    local f18_local3 = true -- GameX.gameModeIsFFA()
    local f18_local4 = {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = false,
        rightAnchor = false,
        left = 73,
        top = 48,
        width = 100,
        height = 100
    }
    local f18_local5
    if f18_local3 then
        f18_local5 = 0
        if not f18_local5 then

        else
            f18_local4.alpha = f18_local5
            f18_local5 = LUI.FactionIcon.new(f18_local4)
            f18_local5.id = "leftFactionIcon"
            local f18_local6 = LUI.UIText.new()
            f18_local6.id = "leftNameText"
            local f18_local7 = f18_local6
            local f18_local8 = f18_local6.registerAnimationState
            local f18_local9 = "default"
            local f18_local10 = {
                topAnchor = true,
                leftAnchor = true,
                bottomAnchor = false,
                rightAnchor = false,
                top = 120,
                left = 186,
                height = CoD.TextSettings.BodyFontSmall.Height,
                font = CoD.TextSettings.BodyFontSmall.Font,
                alignment = LUI.Alignment.Left,
                color = Colors.white
            }
            local f18_local11
            if f18_local3 then
                f18_local11 = 0
                if not f18_local11 then

                else
                    f18_local10.alpha = f18_local11
                    f18_local8(f18_local7, f18_local9, f18_local10)
                    f18_local6:animateToState("default", 0)
                    f18_local6:setTextStyle(CoD.TextStyle.Shadowed)

                    f18_local7 = {
                        topAnchor = true,
                        leftAnchor = false,
                        bottomAnchor = false,
                        rightAnchor = true,
                        right = -73,
                        top = 48,
                        height = 100,
                        width = 100
                    }
                    if f18_local3 then
                        f18_local9 = 0
                        if not f18_local9 then

                        else
                            f18_local7.alpha = f18_local9
                            f18_local9 = LUI.FactionIcon.new(f18_local7)
                            f18_local9.id = "rightFactionIcon"

                            local f18_local10 = LUI.UIText.new()
                            f18_local10.id = "rightNameText"
                            local f18_local12 = f18_local10
                            f18_local11 = f18_local10.registerAnimationState
                            local f18_local13 = "default"
                            local f18_local14 = {
                                topAnchor = true,
                                leftAnchor = true,
                                bottomAnchor = false,
                                rightAnchor = true,
                                top = 120,
                                right = -186,
                                height = CoD.TextSettings.BodyFontSmall.Height,
                                font = CoD.TextSettings.BodyFontSmall.Font,
                                alignment = LUI.Alignment.Right,
                                color = Colors.white
                            }
                            local f18_local15
                            if f18_local3 then
                                f18_local15 = 0
                                if not f18_local15 then

                                else
                                    f18_local14.alpha = f18_local15
                                    f18_local11(f18_local12, f18_local13, f18_local14)
                                    f18_local10:animateToState("default", 0)
                                    f18_local10:setTextStyle(CoD.TextStyle.Shadowed)

                                    -- hmmmm
                                    local topbar_titletext_bg = LUI.UIElement.new({
                                        topAnchor = true,
                                        leftAnchor = false,
                                        bottomAnchor = false,
                                        rightAnchor = false,
                                        left = -62,
                                        top = 41,
                                        height = 42,
                                        width = 125,
                                        alpha = 0,
                                        material = RegisterMaterial("h1_ui_topbar_titletext_bg_not_tiled")
                                    })
                                    f18_arg0.headerContainer = topbar_titletext_bg

                                    local f18_local18 = 640.5
                                    local f18_local19 = 293.33
                                    if Engine.UsingSplitscreenUpscaling() or Engine.IsPC() then
                                        f18_local18 = GameX.GetScreenWidth() / 2
                                        if f18_local18 < 640.5 then
                                            f18_local18 = 640.5
                                        end
                                    end

                                    local f18_local23 = LUI.UIImage.new({
                                        bottomAnchor = true,
                                        height = 50.67,
                                        width = 45.33,
                                        alpha = 0,
                                        top = -140,
                                        material = RegisterMaterial("h1_ui_nemesis_skull")
                                    })
                                    f18_local23.id = "nemesisSkull"
                                    f18_local23:registerAnimationState("nemesis", {
                                        alpha = 1
                                    })

                                    -- killcam elements to toggle
                                    self:addElement(attacker_playercard)
                                    self:addElement(top_bar_kc_bg)
                                    self:addElement(bottom_bar_kc_bg)

                                    -- self:addElement(killcam_text_title_bg)

                                    self:addElement(f18_local5)
                                    self:addElement(f18_local6)
                                    self:addElement(f18_local9)
                                    -- self:addElement(f18_local11)
                                    self:addElement(f18_local10)
                                    self:addElement(topbar_titletext_bg)
                                    -- self:addElement(f18_local23)
                                    -- self:addElement(f18_local26)

                                    return self
                                end
                            end
                            f18_local15 = 1
                        end
                    end
                    f18_local9 = 1
                end
            end
            f18_local11 = 1
        end
    end
    f18_local5 = 1
end

local f0_local28 = function(f19_arg0)
    local self = LUI.UIElement.new()
    self.id = "killCamCountDownBar"
    self:registerAnimationState("default", {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        top = 0,
        left = 0,
        right = 0,
        bottom = 0,
        alpha = 0
    })
    self:animateToState("default", 0)
    self:registerAnimationState("inactive", {
        alpha = 0
    })
    self:registerAnimationState("active", {
        alpha = 1
    })

    local f19_local3 = {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = false,
        rightAnchor = true,
        top = 70,
        height = 18,
        font = CoD.TextSettings.TitleFontSmallBold.Font,
        alignment = LUI.Alignment.Center,
        alpha = 0.75
    }
    if Engine.IsAsianLanguage() or Engine.IsRightToLeftLanguage() then
        f19_local3.bottom = -210
    end
    local f19_local4 = LUI.UICountdown.new({})
    f19_local4.id = "killCamCountDownTimerText"
    f19_local4:registerAnimationState("default", f19_local3)
    f19_local4:animateToState("default")
    f19_local4:registerAnimationState("final", {
        alpha = 1
    })
    f19_local4:registerEventHandler("killcam_on", function(element, event)
        element:setEndTime(Game.GetOmnvar("ui_killcam_end_milliseconds"))
    end)
    self:addElement(f19_local4)
    return self
end

local f0_local29 = function()
    local self = LUI.UIElement.new()
    self.id = "killCamBottom"
    self:registerAnimationState("default", {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        right = 0,
        left = 0,
        alpha = 0
    })
    self:animateToState("default", 0)
    self:registerAnimationState("active", {
        alpha = 1
    })

    local killcam_title_settings = {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = false,
        rightAnchor = true,
        top = 36,
        height = CoD.TextSettings.H1TitleFont.Height * 1.1,
        font = CoD.TextSettings.H1TitleFont.Font,
        alignment = LUI.Alignment.Center,
        alpha = KILLCAM_TEXT_ALPHA,
        red = 190,
        green = 190,
        blue = 190,
        right = 5
    }
    if Engine.IsAsianLanguage() or Engine.IsRightToLeftLanguage() then
        killcam_title_settings.top = 48
    end

    local killcam_title_text = LUI.UIText.new(killcam_title_settings)
    killcam_title_text.id = "killCamTitleText"
    killcam_title_text:setText("")
    killcam_title_text:registerAnimationState("inactive", {
        alpha = 0
    })
    killcam_title_text:registerAnimationState("active", {
        alpha = KILLCAM_TEXT_ALPHA
    })

    killcam_title_text:registerEventHandler("toggle_cam_header", function(element, event)
        if event.scoreboardExists then
            element:animateToState("active", 100)
        else
            element:animateToState("inactive", 100)
        end
    end)

    local killcam_respawn_text = LUI.UIText.new()
    killcam_respawn_text.id = "killCamRespawnText"
    killcam_respawn_text:setText("")
    killcam_respawn_text:registerAnimationState("default", {
        topAnchor = false,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        bottom = -170,
        height = 21,
        font = CoD.TextSettings.TitleFontBold.Font,
        alignment = LUI.Alignment.Center,
        alpha = KILLCAM_TEXT_ALPHA
    })
    killcam_respawn_text:animateToState("default", 0)

    local killcam_copycat_text = LUI.UIText.new()
    killcam_copycat_text.id = "killCamCopycatText"
    killcam_copycat_text:setText("")
    killcam_copycat_text:registerAnimationState("default", {
        topAnchor = false,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        bottom = -35,
        right = 0,
        height = CoD.TextSettings.BodyFont.Height,
        font = CoD.TextSettings.BodyFont.Font,
        alignment = LUI.Alignment.Center
    })
    killcam_copycat_text:animateToState("default", 0)
    local f21_local5 = LUI.UIHorizontalList.new()
	f21_local5.id = "killCamWeaponHL"
	f21_local5:registerAnimationState( "default", {
		topAnchor = false,
		leftAnchor = true,
		bottomAnchor = true,
		rightAnchor = false,
		bottom = -25,
		left = 50,
		height = 64,
		width = 512,
		alignment = LUI.Alignment.Left,
		spacing = 5
	} )
	f21_local5:animateToState( "default", 0 )
	local f21_local6 = function ( f23_arg0 )
		local self = LUI.UIImage.new()
		self.id = "killCamPerk" .. f23_arg0 .. "Image"
		self:registerAnimationState( "default", {
			topAnchor = false,
			leftAnchor = true,
			bottomAnchor = false,
			rightAnchor = false,
			left = 0,
			height = 32,
			width = 32,
			alpha = 1
		} )
		self:registerAnimationState( "empty", {
			material = RegisterMaterial( "specialty_null" )
		} )
		self:animateToState( "default", 0 )
		return self
	end
	
	local f21_local7 = f21_local6( 1 )
	local f21_local8 = f21_local6( 2 )
	local f21_local9 = f21_local6( 3 )
	local f21_local10 = LUI.UIElement.new()
	f21_local10.id = "weaponNameContainer"
	f21_local10:registerAnimationState( "default", {
		topAnchor = false,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		bottom = (CoD.TextSettings.BodyFontTiny.Height + 4) * 0.5,
		left = 0,
		width = 260,
		height = CoD.TextSettings.BodyFontTiny.Height + 4
	} )
	f21_local10:animateToState( "default", 0 )
	local f21_local11 = LUI.UIText.new()
	f21_local11.id = "killCamWeaponNameText"
	f21_local11:registerAnimationState( "default", {
		topAnchor = false,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		bottom = CoD.TextSettings.BodyFontTiny.Height * 0.5,
		left = 2,
		height = CoD.TextSettings.BodyFontTiny.Height,
		width = 256,
		font = CoD.TextSettings.BodyFontTiny.Font,
		alignment = LUI.Alignment.Left
	} )
	f21_local11:animateToState( "default", 0 )
	local f21_local12 = LUI.UIImage.new()
	f21_local12.id = "killCamWeaponNameBg"
	f21_local12:registerAnimationState( "default", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = true,
		rightAnchor = false,
		left = 0,
		width = 260,
		color = Colors.black,
		alpha = 0
	} )
	f21_local12:animateToState( "default" )
	local f21_local13 = LUI.UIImage.new()
	f21_local13.id = "killCamWeaponImage"
	f21_local13:registerAnimationState( "default", {
		topAnchor = false,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		bottom = 0,
		left = 0,
		height = 0,
		width = 0,
		alpha = 1
	} )
	f21_local13:animateToState( "default", 0 )
	f21_local13:registerAnimationState( "inactive", {
		topAnchor = false,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		bottom = 0,
		left = 0,
		height = 0,
		width = 0,
		alpha = 0
	} )
	f21_local5:addElement( f21_local7 )
	f21_local5:addElement( f21_local8 )
	f21_local5:addElement( f21_local9 )
	f21_local5:addElement( f21_local13 )
	f21_local10:addElement( f21_local12 )
	f21_local10:addElement( f21_local11 )
	f21_local5:addElement( f21_local10 )
	for f21_local14 = 1, f0_local6, 1 do
		local f21_local17 = LUI.UIImage.new()
		f21_local17.id = "killCamAttachment" .. f21_local14
		f21_local17:registerAnimationState( "default", {
			topAnchor = false,
			leftAnchor = true,
			bottomAnchor = true,
			rightAnchor = false,
			bottom = 0,
			left = 0,
			height = 32,
			width = 32,
			material = RegisterMaterial( "white" ),
			alpha = 0
		} )
		f21_local17:animateToState( "default", 0 )
		f21_local17:registerAnimationState( "active", {
			alpha = 0
		} )
		f21_local5:addElement( f21_local17 )
	end
	local f21_local14 = LUI.UIHorizontalList.new()
	f21_local14.id = "killCamAbilitiesHL"
	f21_local14:registerAnimationState( "default", {
		topAnchor = false,
		leftAnchor = true,
		bottomAnchor = true,
		rightAnchor = false,
		bottom = -26,
		left = 90,
		height = 32,
		width = 512,
		alignment = LUI.Alignment.Left,
		spacing = 0
	} )
	f21_local14:animateToState( "default", 0 )
	self:addElement( f21_local5 )
	self:addElement( f21_local14 )
    self:addElement(killcam_title_text)
    self:addElement(killcam_respawn_text)
    self:addElement(killcam_copycat_text)

    return self
end

local f0_local30 = function()
    local self = LUI.UIElement.new()
    self.id = "killCamVictimAttacker"
    self:registerAnimationState("default", {
        topAnchor = true,
        leftAnhor = false,
        bottomAnchor = false,
        rightAnchor = true,
        top = 110,
        right = 0,
        height = CoD.TextSettings.BodyFont.Height,
        width = 512,
        alpha = 0
    })
    self:animateToState("default", 0)
    self:registerAnimationState("active", {
        alpha = 1
    })
    local f24_local1 = LUI.UIText.new()
    f24_local1.id = "killCamVictimAttackerText"
    f24_local1:setText("")
    f24_local1:setTextStyle(CoD.TextStyle.Shadowed)
    f24_local1:registerAnimationState("default", {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        font = CoD.TextSettings.BodyFont.Font,
        alignment = LUI.Alignment.Right
    })
    f24_local1:animateToState("default", 0)
    self:addElement(f24_local1)
    return self
end

LUI.MenuBuilder.m_types_build["killCamHudDef"] = function()
    local self = LUI.UIElement.new()
    self.id = "killCamHudId"
    self:registerAnimationState("default", {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        alpha = 0
    })
    self:animateToState("default", 0)
    self:registerAnimationState("active", {
        alpha = 1
    })

    self:registerEventHandler("menu_create", f0_local10)
    self:registerOmnvarHandler("ui_killcam_end_milliseconds", f0_local25)
    self:registerOmnvarHandler("ui_killcam_copycat", f0_local15)
    self:registerOmnvarHandler("ui_killcam_victim_or_attacker", f0_local26)
    self:registerEventHandler("killcam_on", MBh.AnimateToState("active", 0))
    self:registerEventHandler("killcam_off", MBh.AnimateToState("default", 0))

    local overlay = LUI.UIImage.new({
        material = RegisterMaterial("h1_ui_load_vignette"),
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = -4,
        right = 4
    })
    overlay:addElement(LUI.UIImage.new({
        material = RegisterMaterial("h1_ui_footer_glitch"),
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        left = -4,
        right = 4,
        height = 80
    }))
    overlay:addElement(LUI.UIImage.new({
        material = RegisterMaterial("h1_ui_header_glitch"),
        topAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        left = -4,
        right = 4,
        height = 110
    }))

    local decorTop = 0

    local decor = LUI.UIImage.new({
        topAnchor = true,
        left = 0 - 610 / 2,
        top = decorTop,
        width = 610,
        height = 88,
        material = RegisterMaterial("h2_title_backglow_light")
    })
    decor:addElement(LUI.UIImage.new({
        topAnchor = true,
        left = 0 - 610 / 2,
        top = decorTop + 15,
        width = 610,
        height = 88,
        material = RegisterMaterial("h2_title_pattern_dot")
    }))
    decor:addElement(LUI.UIImage.new({
        topAnchor = true,
        left = 0 - 250 / 2,
        top = decorTop + 90,
        width = 250,
        height = 1,
        material = RegisterMaterial("h1_ui_divider_gradient_left"),
        color = Colors.mw1_green,
        alpha = 0.5
    }))
    decor:addElement(LUI.UIImage.new({
        topAnchor = true,
        left = 0 - 250 / 2,
        top = decorTop + 90,
        width = 25,
        height = 1,
        material = RegisterMaterial("white"),
        color = Colors.mw1_green,
        alpha = 0.5
    }))
    decor:addElement(LUI.UIImage.new({
        topAnchor = true,
        left = 0 + 200 / 2,
        top = decorTop + 90,
        width = 25,
        height = 1,
        material = RegisterMaterial("white"),
        color = Colors.mw1_green,
        alpha = 0.5
    }))

    self:addElement(overlay)
    self:addElement(decor)

    self:addElement(f0_local27(self))
    self:addElement(f0_local28(self))
    self:addElement(f0_local29())
    self:addElement(f0_local30())

    local f25_local1 = 256
    local f25_local2 = not GameX.IsSplitscreen()
    local f25_local3 = GameX.IsSplitscreen() and -f25_local1 or -190
    local f25_local4 = GameX.IsSplitscreen() and -f25_local1 or -260
    local f25_local5 = GameX.IsSplitscreen() and 140 or 110
    local f25_local6 = LUI.UIElement.new({
        leftAnchor = f25_local2,
        topAnchor = true,
        bottomAnchor = false,
        rightAnchor = not f25_local2,
        top = f25_local5,
        left = f25_local3,
        height = f25_local1,
        width = f25_local1
    })
    f25_local6:registerAnimationState("extended", {
        leftAnchor = f25_local2,
        topAnchor = true,
        bottomAnchor = false,
        rightAnchor = not f25_local2,
        top = f25_local5,
        left = f25_local4,
        height = f25_local1,
        width = f25_local1
    })
    local f25_local7 = LUI.UIElement.new()
    f25_local7:setupUIIntWatch("PlayerPerkChanged", Game.GetPerkIndexForName("specialty_moreminimap"))
    f25_local7:registerEventHandler("int_watch_alert", function(element, event)
        if Game.PlayerHasPerk("specialty_moreminimap") then
            f25_local6:animateToState("extended")
        else
            f25_local6:animateToState("default")
        end
    end)
    f25_local6:addElement(f25_local7)
    f25_local6:addElement(LUI.MenuBuilder.BuildRegisteredType("talkerHudDef", {}))
    self:addElement(f25_local6)
    return self
end
