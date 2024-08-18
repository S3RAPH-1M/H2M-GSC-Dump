LUI.RoundEnd = InheritFrom(LUI.UIElement)

local f0_local0 = 0

-- use this variable to scale the hud (simon probably needs this for his res)
local hud_scale = 0.05

local f0_local2 = -11
local f0_local3 = Engine.Localize("@LUA_MENU_VERSUS")
local f0_local4 = CoD.TextSettings.Font24
local f0_local5 = 10
local f0_local6 = 4
local f0_local7 = 250
local f0_local8 = CoD.TextSettings.Font76
local f0_local9 = 6
local f0_local10 = 1
local f0_local11 = 2
local f0_local12 = 2
local f0_local13 = 60
local OutcomeTitles = {"MP_DRAW", "LUA_MENU_REPORT_DRAW", "MP_ROUND_WIN", "MP_ROUND_LOSS", "LUA_MENU_REPORT_VICTORY",
                       "LUA_MENU_REPORT_DEFEAT", "MP_HALFTIME", "MP_OVERTIME", "MP_ROUNDEND", "MP_INTERMISSION",
                       "MP_SWITCHING_SIDES", "MP_MATCH_BONUS_IS", "MP_MATCH_TIE", "MP_GAME_END", "SPLASHES_BLANK"}

local ReasonStrings = {"MP_SCORE_LIMIT_REACHED", "MP_TIME_LIMIT_REACHED", "MP_PLAYERS_FORFEITED", "MP_TARGET_DESTROYED",
                       "MP_BOMB_DEFUSED", "MP_SAS_ELIMINATED", "MP_SPETSNAZ_ELIMINATED", "MP_SAS_FORFEITED",
                       "MP_SPETSNAZ_FORFEITED", "MP_SAS_MISSION_ACCOMPLISHED", "MP_SPETSNAZ_MISSION_ACCOMPLISHED",
                       "MP_ENEMIES_ELIMINATED", "MP_MATCH_TIE", "GAME_OBJECTIVECOMPLETED", "GAME_OBJECTIVEFAILED",
                       "MP_SWITCHING_SIDES", "MP_ROUND_LIMIT_REACHED", "MP_ENDED_GAME", "MP_HOST_ENDED_GAME",
                       "MP_PREVENT_STAT_LOSS", "MP_SURVIVORS_ELIMINATED", "MP_INFECTED_ELIMINATED",
                       "MP_SURVIVORS_FORFEITED", "MP_INFECTED_FORFEITED"}
local f0_local15 = 20
local f0_local16 = CoD.TextSettings.Font24
local f0_local17 = 14
local f0_local18 = 6
local f0_local19 = 235
local f0_local20 = Engine.Localize("@LUA_MENU_XP")
local f0_local21 = Colors.h1.light_grey
local f0_local22 = Colors.black
local f0_local23 = CoD.TextSettings.FontBold46
local f0_local24 = 7
local f0_local25 = 0
local f0_local26 = Engine.ToUpperCase(Engine.Localize("@MPUI_MATCHBONUS"))
local f0_local27 = 15
local f0_local28 = CoD.TextSettings.Font24
local f0_local29 = 22
local f0_local30 = 4
local f0_local31 = 8
local f0_local32 = CoD.TextSettings.FontBold36
local f0_local33 = Colors.h1.light_grey
local f0_local34 = 50
local f0_local35 = CoD.TextSettings.FontBold95
local f0_local36 = 30
local f0_local37 = 160
local f0_local38 = 60
local f0_local39 = 50
local f0_local40 = 4
local f0_local41 = CoD.TextSettings.Font30
local f0_local42 = Colors.h1.light_grey
local f0_local43 = 16
local f0_local44 = 4
local f0_local45 = Colors.white
local f0_local46 = Colors.h1.light_grey
local f0_local47, f0_local48 = nil
local f0_local49 = 10
local f0_local50 = 1
local f0_local51 = 2
function AddTextElement(f1_arg0, f1_arg1)
    local f1_local0, f1_local1, f1_local2, f1_local3 = GetTextDimensions(f1_arg1.textStr, f1_arg1.textFont.Font,
        f1_arg1.textFont.Height)
    local f1_local4 = f1_local2 - f1_local0
    local f1_local5 = CoD.CreateState
    local f1_local7 = f1_arg1.top
    local f1_local8 = nil
    local f1_local9 = f1_arg1.bot
    local f1_local10 = f1_arg1.rootAnchorType
    if not f1_local10 then
        f1_local10 = CoD.AnchorTypes.Bottom
    end
    f1_local5 = f1_local5(nil, f1_local7, f1_local8, f1_local9, f1_local10)
    f1_local5.width = f1_local4 + f1_arg1.leftEdgePadding * 2
    f1_local5.height = f1_arg1.textFont.Height + f1_arg1.topEdgePadding * 2
    local UIElement = LUI.UIElement.new(f1_local5)
    f1_arg0:addElement(UIElement)
    if not f1_arg1.disableBg then
        f1_local7 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.All)
        f1_local7.material = RegisterMaterial("white")
        f1_local8 = f1_arg1.bgColor
        if not f1_local8 then
            f1_local8 = Colors.black
        end
        f1_local7.color = f1_local8
        f1_local7.alpha = f1_arg1.bgAlpha or 0 -- idk but wtv
        UIElement:addElement(LUI.UIImage.new(f1_local7))
    end
    if f1_arg1.decoMatName then
        f1_local7 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.None)
        f1_local7.material = RegisterMaterial(f1_arg1.decoMatName)
        f1_local7.width = f1_local5.width
        f1_local7.height = f1_local5.height * 1.25
        UIElement:addElement(LUI.UIImage.new(f1_local7))
    end
    f1_local7 = CoD.CreateState
    f1_local8 = -f1_local4 / 2 + (f1_arg1.textLeftOffset or 0)
    f1_local9 = -f1_arg1.textFont.Height / 2
    f1_local10 = f1_arg1.textTopOffset
    if not f1_local10 then
        f1_local10 = f1_arg1.topEdgePadding - 1
    end
    f1_local7 = f1_local7(f1_local8, f1_local9 + f1_local10, nil, nil, CoD.AnchorTypes.None)
    f1_local7.font = f1_arg1.textFont.Font
    f1_local8 = f1_arg1.textColor
    if not f1_local8 then
        f1_local8 = Colors.h1.light_grey
    end
    f1_local7.color = f1_local8
    f1_local7.height = f1_arg1.textFont.Height
    f1_local7.width = f1_local4
    if Engine.IsAsianLanguage() or Engine.IsRightToLeftLanguage() then
        f1_local7.top = f1_local7.top - f1_arg1.textFont.Height * 0.15
    end
    f1_local8 = LUI.UIText.new(f1_local7)
    f1_local8:setText(f1_arg1.textStr)
    f1_local8:setTextStyle(CoD.TextStyle.Shadowed)
    UIElement:addElement(f1_local8)
    if not f1_arg1.disableBg then
        f1_local9 = CoD.CreateState(nil, -(f1_local5.height / 2) - 1, nil, nil, CoD.AnchorTypes.None)
        f1_local9.width = f1_local5.width
        f1_local9.height = f1_local5.height + 1
        f1_local10 = LUI.DecoFrame.new
        local f1_local11 = f1_local9
        local f1_local12 = f1_arg1.frameTypeId
        if not f1_local12 then
            f1_local12 = LUI.DecoFrame.Grey
        end
        f1_local10 = f1_local10(f1_local11, f1_local12)
        f1_local10:setPriority(f0_local49)
        UIElement:addElement(f1_local10)
    end
    return UIElement
end

function AddTeam(f3_arg0, f3_arg1)
    local f3_local0 = Game.GetOmnvar("ui_game_victor")
    local f3_local1 = f3_local0 == f3_arg1
    local f3_local2 = f0_local47 == f3_arg1
    local f3_local3 = -30
    local f3_local4 = CoD.CreateState(nil, f3_local3, f0_local37, nil, CoD.AnchorTypes.Right)
    if f3_local2 then
        f3_local4 = CoD.CreateState(-f0_local37, f3_local3, nil, nil, CoD.AnchorTypes.Left)
    end
    f3_local4.width = f0_local38
    f3_local4.height = f0_local39
    local mainElement = LUI.UIElement.new(f3_local4)
    f3_arg0:addElement(mainElement)
    local f3_local6 = tostring(Game.GetTeamScore(f3_arg1) or 0)
    local f3_local7, f3_local8, f3_local9, f3_local10 = GetTextDimensions(f3_local6, f0_local35.Font, f0_local35.Height)
    local f3_local11 = f3_local9 - f3_local7
    if f3_arg1 == Teams.allies or f3_arg1 == Teams.axis then
        local f3_local12 = f0_local48[f3_arg1].icon
        local f3_local13 = 128
        local f3_local14 = f3_local13
        local f3_local15 = -7
        local f3_local16 = 50
        local f3_local17 = CoD.CreateState(-f0_local38 / 2 - f3_local16, -f0_local39 / 2 - 1, nil, nil,
            CoD.AnchorTypes.Left)
        if f3_local2 then
            f3_local17 = CoD.CreateState(nil, -f0_local39 / 2 - 1, f0_local38 / 2 + f3_local16, nil,
                CoD.AnchorTypes.Right)
        end
        local f3_local18 = RegisterMaterial
        local f3_local19 = "h1_ui_endgame_scorebar_enemy"
        if f3_local2 then
            f3_local19 = "h1_ui_endgame_scorebar_team"
        end

        f3_local17.material = f3_local18(f3_local19)
        f3_local17.width = 450
        f3_local17.height = 65
        f3_local18 = LUI.UIImage.new(f3_local17)
        f3_local19 = "teamColorbar"
        local f3_local20 = "Right"
        if f3_local2 then
            f3_local20 = "Left"
        end
        f3_local18.id = f3_local19 .. f3_local20 .. "Icon"
        mainElement:addElement(f3_local18)
        f3_local19 = 137
        f3_local20 = CoD.CreateState(f3_local19, nil, nil, nil, CoD.AnchorTypes.Left)
        if f3_local2 then
            f3_local20 = CoD.CreateState(nil, nil, -f3_local19, nil, CoD.AnchorTypes.Right)
        end
        f3_local20.top = -f3_local14 / 2 + f3_local15
        f3_local20.width = f3_local13
        f3_local20.height = f3_local14
        local f3_local21 = LUI.FactionIcon.new(f3_local20, {
            botDivOffset = 1
        })
        mainElement:addElement(f3_local21)
        f3_local21:Update(f3_local12)
        f3_local21:setPriority(5000)
        local f3_local22 = f0_local48[f3_arg1].name
        local f3_local23, f3_local24, f3_local25, f3_local26 =
            GetTextDimensions(f3_local22, f0_local41.Font, f0_local41.Height)
        f3_local10 = f3_local26
        f3_local9 = f3_local25
        f3_local8 = f3_local24
        f3_local23 = f3_local9 - f3_local23
        f3_local26 = {
            bot = f0_local41.Height + f0_local44 * 2 + f0_local40,
            leftEdgePadding = f0_local43,
            topEdgePadding = f0_local44,
            textStr = f3_local22,
            textFont = f0_local41,
            textColor = f0_local42
        }
        local f3_local27 = 0
        if f3_arg1 == Teams.allies then
            f3_local27 = -2
        end
        f3_local26.textLeftOffset = f3_local27
        f3_local26.textTopOffset = f0_local51
        f3_local26.disableBg = true
        AddTextElement(f3_local21, f3_local26)
    end
    local f3_local14 = true
    if Game.GetOmnvar("ui_current_round") < 3 or GameX.GetGameMode() ~= "ctf" then
        f3_local14 = false
    end
    local f3_local15 = 7
    local f3_local16 = 0
    if f3_local14 then
        f3_local16 = 7
    end
    local f3_local17 = CoD.CreateState(-f3_local16, -f0_local35.Height / 2 - f0_local51 + f3_local15, nil, nil,
        CoD.AnchorTypes.Left)
    if f3_local2 then
        f3_local17 = CoD.CreateState(nil, -f0_local35.Height / 2 - f0_local51 + f3_local15, f3_local16, nil,
            CoD.AnchorTypes.Right)
    end
    f3_local17.font = f0_local35.Font
    local f3_local18 = f0_local46
    if f3_local1 then
        f3_local18 = f0_local45
    end

    f3_local17.color = f3_local18
    if f3_local0 == 0 then
        f3_local17.color = Colors.white
    end
    f3_local17.height = f0_local35.Height
    f3_local17.width = f3_local11
    f3_local18 = 0.5
    if f3_local1 or f3_local0 == 0 then
        f3_local18 = 1
    end

    f3_local17.alpha = f3_local18
    f3_local18 = LUI.UIText.new(f3_local17)
    if f3_local14 then
        local f3_local19, f3_local20 = nil
        local f3_local21 = 1000
        local f3_local22 = Game.GetOmnvar("ui_friendly_time_to_beat") / f3_local21
        local f3_local23 = Game.GetOmnvar("ui_enemy_time_to_beat") / f3_local21
        if f3_local2 then
            f3_local19 = f3_local22
            f3_local20 = DetermineOvertimeColor(f3_local19, f3_local23)
        else
            f3_local19 = f3_local23
            f3_local20 = DetermineOvertimeColor(f3_local19, f3_local22)
        end
        if f3_local19 <= 0 then
            local f3_local28 = "-:--"
        end
        f3_local6 = f3_local28 or FormatTimeMinutesSeconds(f3_local19, "%01d:%02d")
        local f3_local25 = f3_local18
        local f3_local24 = f3_local18.registerAnimationState
        local f3_local26 = "updateColor"
        local f3_local27 = {
            color = f3_local20
        }
        local f3_local29 = 1
        if f3_local20 == f0_local46 then
            f3_local29 = 0.5
        end
        f3_local27.alpha = f3_local29
        f3_local24(f3_local25, f3_local26, f3_local27)
        f3_local18:animateToState("updateColor")
        f3_local24 = 41
        f3_local25 = 60
        if f3_local2 and f3_local22 > 0 and (f3_local22 < f3_local23 or f3_local23 <= 0) then
            mainElement:addElement(BuildTimeToBeatHeader({
                right = f3_local24,
                anchor = CoD.AnchorTypes.TopRight,
                textRight = -f3_local25,
                textAnchor = CoD.AnchorTypes.Right,
                material = "h1_mp_endgame_timetobeat_team"
            }))
        elseif not f3_local2 and f3_local23 > 0 and (f3_local23 < f3_local22 or f3_local22 <= 0) then
            mainElement:addElement(BuildTimeToBeatHeader({
                left = -f3_local24,
                anchor = CoD.AnchorTypes.TopLeft,
                textLeft = f3_local25,
                textAnchor = CoD.AnchorTypes.Left,
                material = "h1_mp_endgame_timetobeat_enemy"
            }))
        end
    end
    f3_local18:setText(f3_local6)
    mainElement:addElement(f3_local18)
end

function BuildTimeToBeatHeader(f4_arg0)
    local f4_local0 = Engine.GetMaterialAspectRatio(RegisterMaterial(f4_arg0.material))
    local f4_local1 = 40
    local f4_local2 = 9
    local f4_local3 = f4_local0 * f4_local1
    local f4_local4 = CoD.CreateState(f4_arg0.left, -f4_local1 + f4_local2, f4_arg0.right, f4_arg0.bottom,
        f4_arg0.anchor)
    f4_local4.width = f4_local3
    f4_local4.height = f4_local1
    local timeToBeatElement = LUI.UIElement.new(f4_local4)
    local f4_local6 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.All)
    f4_local6.material = RegisterMaterial(f4_arg0.material)
    timeToBeatElement:addElement(LUI.UIImage.new(f4_local6))
    local f4_local7 = CoD.TextSettings.Font23
    local f4_local8 = CoD.CreateState(f4_arg0.textLeft, -f4_local7.Height / 2 + -1.5, f4_arg0.textRight, nil,
        f4_arg0.textAnchor)
    f4_local8.font = f4_local7.Font
    f4_local8.color = Colors.white
    f4_local8.height = f4_local7.Height
    local f4_local9 = LUI.UIText.new(f4_local8)
    f4_local9:setText(Engine.ToUpperCase(Engine.Localize("@LUA_MP_COMMON_TIME_TO_BEAT_CAPS")))
    timeToBeatElement:addElement(f4_local9)
    return timeToBeatElement
end

function DetermineOvertimeColor(f5_arg0, f5_arg1)
    local f5_local0 = f0_local46
    if 0 < f5_arg0 and (f5_arg0 <= f5_arg1 or f5_arg1 <= 0) then
        f5_local0 = f0_local45
    end
    return f5_local0
end

function AddFooter(f6_arg0)
    local f6_local0 = Engine.GetFirstActiveController()
    local f6_local1 = Game.GetOmnvar("ui_round_end_match_bonus")
    if f6_local1 > 0 then
        local f6_local2 = CoD.CreateState(nil, f0_local19, nil, nil, CoD.AnchorTypes.Top)
        f6_local2.width = f0_local19
        f6_local2.height = f0_local19
        local footerElement = LUI.UIElement.new(f6_local2)
        f6_arg0:addElement(footerElement)
        local f6_local4 = AddTextElement(AddTextElement(footerElement, {
            top = 0,
            leftEdgePadding = f0_local24,
            topEdgePadding = f0_local25,
            textStr = f0_local20,
            textFont = f0_local23,
            textColor = f0_local22,
            bgColor = f0_local21,
            bgAlpha = 1,
            rootAnchorType = CoD.AnchorTypes.Top
        }), {
            bot = f0_local28.Height + f0_local30 * 2 + f0_local27,
            leftEdgePadding = f0_local29,
            topEdgePadding = f0_local30,
            textStr = f0_local26,
            textFont = f0_local28,
            textTopOffset = f0_local51
        })
        local f6_local5 = tostring(f6_local1)
        local f6_local6, f6_local7, f6_local8, f6_local9 = GetTextDimensions(f6_local5, f0_local32.Font,
            f0_local32.Height)
        local f6_local10 = f6_local8 - f6_local6
        local f6_local11 = CoD.CreateState(nil, nil, nil, f0_local32.Height + f0_local31, CoD.AnchorTypes.Bottom)
        f6_local11.font = f0_local32.Font
        f6_local11.color = f0_local33
        f6_local11.height = f0_local32.Height
        f6_local11.width = f6_local10
        local f6_local12 = LUI.UIText.new(f6_local11)
        f6_local12:setText(f6_local5)
        f6_local4:addElement(f6_local12)
    end
end

function RoundEndTeamBased(f7_arg0, f7_arg1)
    f0_local48 = {{
        name = Engine.ToUpperCase(Engine.Localize(Engine.GetDvarString("g_TeamName_Axis"))),
        icon = Engine.GetDvarString("g_TeamIcon_Axis")
    }, {
        name = Engine.ToUpperCase(Engine.Localize(Engine.GetDvarString("g_TeamName_Allies"))),
        icon = Engine.GetDvarString("g_TeamIcon_Allies")
    }}
    if string.find(tostring(f0_local48[Teams.allies].name), "MARINES") then
        CoD.SwapFactionReasonStrings()
    else
        CoD.RestoreFactionReasonStrings()
    end
    local mainElement = LUI.UIElement.new(CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.All))
    mainElement.id = "roundEnd"
    mainElement:setupLetterboxElement()
    local f7_local1 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.All)
    f7_local1.material = RegisterMaterial("white")
    f7_local1.color = Colors.black
    f7_local1.alpha = f0_local0
    local f7_local2 = LUI.UIImage.new(f7_local1)
    mainElement:addElement(f7_local2)
    f7_local2:setupFullWindowElement()
    local f7_local3 = Game.GetNumPlayersOnTeam(Teams.free)

    local f7_local5 = AddTextElement(mainElement, {
        top = f0_local2 - (f0_local4.Height + f0_local6 * 2) / 2,
        leftEdgePadding = f0_local5,
        topEdgePadding = f0_local6,
        textStr = f0_local3,
        textFont = f0_local4,
        rootAnchorType = CoD.AnchorTypes.None,
        textTopOffset = f0_local51
    })
    local f7_local6 = Game.GetPlayerTeam()
    local f7_local7 = f7_local6
    if f7_local6 == Teams.spectator then
        f7_local7 = Teams.allies
    end

    f0_local47 = f7_local7
    f7_local7 = f0_local47
    local f7_local8 = Teams.allies
    f7_local7 = f7_local8 and Teams.axis or Teams.allies
    AddTeam(f7_local5, Teams.axis)
    AddTeam(f7_local5, Teams.allies)
    return mainElement
end

function RoundEndSlayer()
    local clientNum = Game.GetPlayerClientnum()
    local mainElement = LUI.UIElement.new({
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = 0,
        right = 0
    })
    mainElement.id = "roundEndFFA"
    local playerList = LUI.UIVerticalList.new({
        topAnchor = false,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = true,
        top = -110,
        height = 0,
        left = 0,
        right = 0,
        spacing = -5
    })
    playerList.id = "vlist"
    mainElement:addElement(playerList)
    local placementStrings = {"@LUA_MP_COMMON_ROUND_END_1ST", "@LUA_MP_COMMON_ROUND_END_2ND",
                              "@LUA_MP_COMMON_ROUND_END_3RD"}
    for index = 1, #placementStrings, 1 do
        local player = Game.GetPlayerScoreInfoAtRank(Teams.free, index)
        if player and player.name then
            local font = CoD.TextSettings.TitleFont50
            local fontScale = 24
            local fontAlpha = 0.7
            Engine.SetDvarInt("scr_dm_scorelimit", index)
            if index == 1 then
                fontScale = 36
                fontAlpha = 1
            end
            local fontColour = Swatches.RoundEnd.FFAMeWinning
            local placement = LUI.UIText.new({
                font = font.Font,
                alignment = LUI.Alignment.Center,
                topAnchor = true,
                bottomAnchor = false,
                leftAnchor = true,
                rightAnchor = true,
                left = 0,
                top = 0,
                right = 0,
                height = fontScale,
                color = fontColour,
                alpha = fontAlpha
            })
            placement.id = "rank_" .. index
            placement:setText(Engine.Localize(placementStrings[index]))
            playerList:addElement(placement)
            local playerName = LUI.UIText.new({
                font = font.Font,
                alignment = LUI.Alignment.Center,
                topAnchor = true,
                bottomAnchor = false,
                leftAnchor = true,
                rightAnchor = true,
                left = 0,
                top = 0,
                right = 0,
                height = fontScale,
                color = fontColour,
                alpha = fontAlpha
            })
            playerName.id = "player_" .. index
            playerName:setText(player.name)
            playerName:setUsePulseFX(true, false)
            playerList:addElement(playerName)
            local playerSpacer = LUI.UIElement.new({
                topAnchor = true,
                bottomAnchor = false,
                leftAnchor = true,
                rightAnchor = true,
                top = 0,
                bottom = 25,
                left = 0,
                right = 0
            })
            playerSpacer.id = "spacer_" .. index
            playerList:addElement(playerSpacer)
        end
    end
    return mainElement
end

function RoundEndSummary()
    local outcomeTitle = Game.GetOmnvar("ui_round_end_title")
    local outcomeReason = Game.GetOmnvar("ui_round_end_reason")
    local summaryElement = LUI.UIElement.new({
        topAnchor = false,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = true,
        top = -250,
        height = 0,
        left = 0,
        right = 0
    })
    summaryElement.id = "summary"

    if outcomeTitle > 0 then
        local localised = Engine.Localize(OutcomeTitles[outcomeTitle])
        local decor = LUI.UIImage.new({
            topAnchor = true,
            left = 0 - 610 / 2,
            top = -15,
            width = 610,
            height = 88,
            material = RegisterMaterial("h2_title_backglow_light")
        })
        decor:addElement(LUI.UIImage.new({
            topAnchor = true,
            left = 0 - 610 / 2,
            top = 0,
            width = 610,
            height = 88,
            material = RegisterMaterial("h2_title_pattern_dot")
        }))
        decor:addElement(LUI.UIImage.new({
            topAnchor = true,
            left = 0 - 250 / 2,
            top = 75,
            width = 250,
            height = 1,
            material = RegisterMaterial("h1_ui_divider_gradient_left"),
            color = Colors.mw1_green,
            alpha = 0.5
        }))
        decor:addElement(LUI.UIImage.new({
            topAnchor = true,
            left = 0 - 250 / 2,
            top = 75,
            width = 25,
            height = 1,
            material = RegisterMaterial("white"),
            color = Colors.mw1_green,
            alpha = 0.5
        }))
        decor:addElement(LUI.UIImage.new({
            topAnchor = true,
            left = 0 + 200 / 2,
            top = 75,
            width = 25,
            height = 1,
            material = RegisterMaterial("white"),
            color = Colors.mw1_green,
            alpha = 0.5
        }))
        summaryElement:addElement(decor)

        local textElement = LUI.UIText.new({
            topAnchor = true,
            bottomAnchor = false,
            leftAnchor = true,
            rightAnchor = true,
            left = 0,
            top = 16,
            right = 0,
            height = 36,
            alignment = LUI.Alignment.Center,
            font = CoD.TextSettings.H1TitleFont.Font,
            color = Colors.white
        })
        textElement.id = "titleText"
        textElement:setText(localised)
        textElement:setUsePulseFX(true, false)

        summaryElement:addElement(textElement)
    end

    if outcomeReason > 0 then
        local localised = Engine.ToUpperCase(Engine.Localize(ReasonStrings[outcomeReason]))
        local textElement = LUI.UIText.new({
            topAnchor = true,
            bottomAnchor = false,
            leftAnchor = true,
            rightAnchor = true,
            left = 0,
            top = 5,
            right = 0,
            height = 16,
            alignment = LUI.Alignment.Center,
            font = CoD.TextSettings.TitleFontMedium.Font,
            color = Colors.mw1_green
        })
        textElement.id = "reasonText"
        textElement:setText(localised)
        textElement:setUsePulseFX(true, false)
        summaryElement:addElement(textElement)
    end
    local matchBonus = Game.GetOmnvar("ui_round_end_match_bonus") or 0

    -- this is a horrible way of glow alpha lol
    if matchBonus and GameX.IsRankedMatch() then
        local mbTextBack = LUI.UIText.new({
            bottomAnchor = true,
            leftAnchor = true,
            rightAnchor = true,
            height = 16,
            bottom = 450,
            color = Colors.mw1_green,
            alignment = LUI.Alignment.Center,
            font = CoD.TextSettings.TitleFontMedium.Font,
            glow = LUI.GlowState.Orange,
            alpha = 0.3
        })
        local mbTextFront = LUI.UIText.new({
            bottomAnchor = true,
            leftAnchor = true,
            rightAnchor = true,
            height = 16,
            bottom = 450,
            color = Colors.mw1_green,
            alignment = LUI.Alignment.Center,
            font = CoD.TextSettings.TitleFontMedium.Font,
            alpha = 1
        })

        mbTextBack.id = "matchBonusTitle"
        mbTextBack:setText(Engine.Localize("@LUA_MENU_MATCH_BONUS", matchBonus))
        mbTextFront:setText(Engine.Localize("@LUA_MENU_MATCH_BONUS", matchBonus))
        summaryElement:addElement(mbTextBack)
        summaryElement:addElement(mbTextFront)
    end
    return summaryElement
end

local function roundEnd()
    local roundEndElement = LUI.UIElement.new({
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = 0,
        right = 0,
        alpha = 0,
        scale = 2
	} )
    roundEndElement.id = "roundEnd"

    local darkOverlay = LUI.UIImage.new({
        material = RegisterMaterial("white"),
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = 0,
        right = 0,
        color = Colors.black,
        alpha = 0.5
    })
    darkOverlay.id = "darken"
    darkOverlay:addElement(LUI.UIImage.new({
        material = RegisterMaterial("h1_ui_load_vignette"),
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = 0,
        right = 0
    }))
    darkOverlay:addElement(LUI.UIImage.new({
        material = RegisterMaterial("h1_ui_footer_glitch"),
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        left = 0,
        right = 0,
        height = 80
    }))
    darkOverlay:addElement(LUI.UIImage.new({
        material = RegisterMaterial("h1_ui_header_glitch"),
        topAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        left = 0,
        right = 0,
        height = 110
    }))
    roundEndElement:addElement(darkOverlay)

    local bounds = LUI.UIElement.new({
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = 0,
        right = 0,
        scale = hud_scale
    })
    bounds.id = "scaledElements"
    roundEndElement:addElement(bounds)

    bounds:addElement(RoundEndSummary())
    if LUI.Scoreboard.IsSingleTeam() and Game.GetNumPlayersOnTeam(Teams.free) > 0 then
        bounds:addElement(RoundEndSlayer())
    else
        bounds:addElement(RoundEndTeamBased())
    end      

    roundEndElement:registerAnimationState( "pop", {
        alpha = 0,
        scale = 1
	} )
    roundEndElement:registerAnimationState( "default", {
        alpha = 1,
        scale = 0
	} )

    local animator = MBh.AnimateSequence( {
        {
            "pop",
            0
        },
        {
            "default",
            75
        }
    } )
    animator( roundEndElement )
    return roundEndElement
end

LUI.MenuBuilder.m_types_build["roundEnd"] = roundEnd
