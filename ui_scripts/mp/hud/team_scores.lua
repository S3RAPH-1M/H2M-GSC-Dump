local function f0_local0()
	if GameX.gameModeIsFFA() then
		local f1_local0 = Game.GetPlayerScoreRanking() or 0
		if f1_local0 > 1 then
			local f1_local1 = GameX.GetPlayerScoreInfoAtRankForGameMode( Teams.free, 1, GameX.GetGameMode() )
			local f1_local2 = GameX.GetPlayerScoreInfoAtRankForGameMode( Teams.free, f1_local0, GameX.GetGameMode() )
			if f1_local1 and f1_local2 then
				if f1_local1.score == f1_local2.score then
					return "tied"
				else
					return "losing"
				end
			else
				return "tied"
			end
		end
		local f1_local1 = Game.GetPlayerName()
		local f1_local2 = Game.GetPlayerScore()
		local f1_local3 = Game.GetPlayerTeam()
		local f1_local4 = Game.GetNumPlayersOnTeam( f1_local3 )
		local f1_local5 = false
		for f1_local6 = 1, f1_local4, 1 do
			local f1_local9 = Game.GetPlayerScoreInfoAtRank( f1_local3, f1_local6 )
			if f1_local9 and f1_local9.name ~= f1_local1 then
				f1_local5 = f1_local9.score == f1_local2
				if f1_local5 then
					break
				end
			end
		end
		if f1_local5 then
			return "tied"
		end
		return "winning"
	else
		local f1_local0 = Game.GetPlayerTeam()
		if f1_local0 == Teams.spectator then
			f1_local0 = Game.GetPlayerTeam( Game.GetPlayerstateClientnum() )
		end
		local f1_local1 = GameX.GetPlayerOpposingTeam( f1_local0 )
		local f1_local2 = Game.GetTeamScore( f1_local0 ) or 0
		local f1_local3 = Game.GetTeamScore( f1_local1 ) or 0
		if f1_local3 < f1_local2 then
			return "winning"
		elseif f1_local2 < f1_local3 then
			return "losing"
		elseif f1_local2 == f1_local3 then
			return "tied"
		else
			return nil
		end
	end
end

local function f0_local1( f2_arg0, f2_arg1 )
	local f2_local0 = {
		winning = "@LUA_MP_COMMON_SCORE_WINNING",
		losing = "@LUA_MP_COMMON_SCORE_LOSING",
		tied = "@LUA_MP_COMMON_SCORE_TIED"
	}
	local f2_local1 = f0_local0()
	local f2_local2, f2_local3 = nil
	local f2_local4 = Game.GetPlayerstateClientnum()
	if GameX.gameModeIsFFA() then
		f2_local2 = Game.GetPlayerScore( f2_local4 )
		local f2_local5 = Game.GetPlayerName( f2_local4 )
		local f2_local6 = Game.GetPlayerTeam( f2_local4 )
		local f2_local7 = Game.GetNumPlayersOnTeam( f2_local6 )
		for f2_local8 = 1, f2_local7, 1 do
			local f2_local11 = Game.GetPlayerScoreInfoAtRank( f2_local6, f2_local8 )
			if f2_local11 and f2_local11.name ~= f2_local5 then
				f2_local3 = f2_local11.score
			end
		end
	else
		local f2_local5 = Game.GetPlayerTeam( f2_local4 )
		local f2_local6 = GameX.GetPlayerOpposingTeam()
		f2_local2 = Game.GetTeamScore( f2_local5 ) or 0
		f2_local3 = Game.GetTeamScore( f2_local6 ) or 0
	end
	if not f2_local2 then
		f2_local2 = 0
	end
	if not f2_local3 then
		f2_local3 = 0
	end
	f2_arg0:setText( Engine.Localize( f2_local0[f2_local1], f2_local2, f2_local3 ) )
	if f2_local1 ~= f2_arg0.currentStatus or f2_arg1 == true then
		f2_arg0:animateInSequence( {
			{
				f2_local1,
				0
			},
			{
				f2_local1,
				1000
			},
			{
				"hidden",
				500
			}
		} )
		f2_arg0.currentStatus = f2_local1
	end
end

local function f0_local2( f3_arg0, f3_arg1 )
	local f3_local0 = f0_local0()
    if f3_arg0 then
        if f3_local0 ~= f3_arg0.currentStatus then
            f3_arg0.score:animateToState( f3_local0 )
            f3_arg0.currentStatus = f3_local0
        end
        if f3_arg0.matchStatus and Game.GetOmnvar( "ui_session_state" ) ~= "spectator" then
            local f3_local1 = f0_local1
            local f3_local2 = f3_arg0.matchStatus
            local f3_local3
            if f3_arg1 == nil or f3_arg1.forced ~= true then
                f3_local3 = false
            else
                f3_local3 = true
            end
            f3_local1( f3_local2, f3_local3 )
        end
    end
end

local function UpdateScores( element, intWatch )
	local score = intWatch.newValue
	if element then
        if element.bar then
            local targetWidth = 2 + score / element.limit * (element.width - 6)
            element.bar:registerAnimationState( "default", CoD.CreateState( 1, 1, targetWidth, -1, CoD.AnchorTypes.TopBottomLeft ) )
            element.bar:animateToState( "default", 0 )
            local state = CoD.CreateState( -2 + targetWidth, nil, nil, 2, CoD.AnchorTypes.BottomLeft )
            state.width = 2
            state.height = 2
            element.bar.triangle:registerAnimationState( "move", state )
            element.bar.triangle:animateToState( "move", 0 )
        end

        if score > element.root.score then
            local digits = string.len(score)
            element.root.score = score
            if digits == 1 then
                element.root:animateToState("one_digit")
            elseif digits == 2 then
                element.root:animateToState("two_digits")
            else
                element.root:animateToState("three_digits")
            end
        end
	end
	f0_local2( element, intWatch )
end

function IsGameTypeRoundBased( f2_arg0 )
	assert( f2_arg0 )
	return Engine.TableLookup( GameTypesTable.File, GameTypesTable.Cols.Ref, f2_arg0, GameTypesTable.Cols.RoundBased ) == "1"
end

local f0_local5 = function ( f6_arg0, f6_arg1 )
	f6_arg0.cycle = f6_arg0.cycle or 0
	local f6_local0 = {}
	table.insert( f6_local0, GetGameModeName() )
	local f6_local1 = true
	if Game.GetPlayerTeam() == Teams.spectator and GameX.gameModeIsFFA() then
		f6_local1 = false
	end
	local f6_local2 = false
	local f6_local3 = Engine.GetDvarString( "ui_gametype" )
	if f6_local1 then
		local f6_local4 = nil
		local f6_local5 = false
		if f6_local3 ~= nil then
			f6_local2 = IsGameTypeRoundBased( f6_local3 )
			f6_local5 = 0 < Engine.GetDvarInt( "ui_scorelimit" )
		end
		local f6_local6 = {
			winning = "@LUA_MP_COMMON_WINNING_CAPS",
			losing = "@LUA_MP_COMMON_LOSING_CAPS",
			tied = "@LUA_MP_COMMON_TIED_CAPS"
		}
		table.insert( f6_local0, Engine.Localize( f6_local6[f0_local0()] ) )
	end
	if f6_local2 then
		local f6_local4 = Game.GetOmnvar( "ui_current_round" )
		local f6_local6 = Engine.GetDvarInt( "scr_" .. f6_local3 .. "_halftime" ) == 1
		local f6_local7 = nil
		if f6_local6 or f6_local3 == "dd" then
			local f6_local8 = 2
			if f6_local8 < f6_local4 then
				f6_local7 = Engine.Localize( "@LUA_MP_COMMON_OVERTIME" )
			else
				f6_local7 = Engine.Localize( "@LUA_MP_COMMON_ROUND_NUM_OF_NUM", f6_local4, f6_local8 )
			end
		else
			f6_local7 = Engine.Localize( "@LUA_MP_COMMON_ROUND_NUM", f6_local4 )
		end
		table.insert( f6_local0, f6_local7 )
	end
	f6_arg0.cycle = (f6_arg0.cycle + 1) % #f6_local0
	f6_arg0:setText( f6_local0[f6_arg0.cycle + 1] )
end

local function GetFactionIcon( f7_arg0 )
	local f7_local0 = nil
	local f7_local1 = Game.GetOmnvar( "ui_team_selected" )
	if f7_local1 == 1 then
		f7_local0 = Engine.GetDvarString( "g_TeamIcon_Axis" )
	elseif f7_local1 == 2 then
		f7_local0 = Engine.GetDvarString( "g_TeamIcon_Allies" )
	end
	if f7_local0 ~= nil then
		f7_arg0:Update( f7_local0 )
	end
end

LUI.MenuBuilder.m_types_build["teamScoresHudDef"] = function()
    local factionOffset = 0--80
    local root = LUI.UIElement.new(CoD.CreateState(factionOffset, 0, 0, HUD.GetXPBarOffset(), CoD.AnchorTypes.All))
    root.id = "teamScores_root"

    local scoresWidth = 340
    local scoresHeight = 61
    local f9_local2 = CoD.CreateState(nil, nil, nil, -2, CoD.AnchorTypes.BottomLeft)
    f9_local2.width = scoresWidth
    f9_local2.height = scoresHeight
    local scoresHUD = LUI.UIElement.new(f9_local2)

    local blurRootState = CoD.CreateState(nil, nil, nil, -30, CoD.AnchorTypes.BottomLeft)
    blurRootState.width = scoresWidth
    blurRootState.height = 81
    local blurRoot = LUI.UIElement.new(blurRootState)

    local blurWidth = 256 * 1.6
    local blurHeight = 50 * 1.4

	local factionSize = 56
	local f8_local13 = 60
	local barWidth = 100
    local scoreTextLeft = 79.5
	local barLeft = scoreTextLeft + 57.5
    local matchStatusTop = -10
	local matchStatusHeight = 15

    local state = CoD.CreateState(-25, nil, nil, -3, CoD.AnchorTypes.BottomLeft)
    state.width = scoresWidth
    state.height = scoresHeight
    barContainer = LUI.UIElement.new(state)
    barContainer.id = "bar_container"
    barContainer.score = 0

    local f9_local4 = CoD.CreateState(blurWidth, nil, nil, blurHeight, CoD.AnchorTypes.BottomLeft)
    f9_local4.material = RegisterMaterial("h2m_hud_weapwidget_blur")
    f9_local4.alpha = CoD.HudStandards.blurAlpha
    blurRoot:addElement(LUI.UIImage.new(f9_local4))

    local f9_local5 = CoD.CreateState(blurWidth, nil, nil, blurHeight, CoD.AnchorTypes.BottomLeft)
    f9_local5.material = RegisterMaterial("h2m_hud_weapwidget_border")
    f9_local5.color = CoD.HudStandards.overlayTint
    f9_local5.alpha = CoD.HudStandards.overlayAlpha
    blurRoot:addElement(LUI.UIImage.new(f9_local5))

    local f9_local4 = CoD.CreateState(blurWidth, 1, nil, -blurHeight, CoD.AnchorTypes.BottomLeft)
    f9_local4.material = RegisterMaterial("h2m_hud_weapwidget_blur")
    f9_local4.alpha = CoD.HudStandards.blurAlpha
    blurRoot:addElement(LUI.UIImage.new(f9_local4))

    local f9_local5 = CoD.CreateState(blurWidth, 1, nil, -blurHeight, CoD.AnchorTypes.BottomLeft)
    f9_local5.material = RegisterMaterial("h2m_hud_weapwidget_border")
    f9_local5.color = CoD.HudStandards.overlayTint
    f9_local5.alpha = CoD.HudStandards.overlayAlpha
    blurRoot:addElement(LUI.UIImage.new(f9_local5))

    local gametype = Engine.GetDvarString( "ui_gametype" )
    local scoreLimit
    local showScores = false
    if gametype ~= nil then
        scoreLimit = Engine.GetDvarInt( "ui_scorelimit" )
        showScores = scoreLimit > 0
    end

    if showScores then
        local f8_local33 = CoD.CreateState( barLeft, 16, nil, 27, CoD.AnchorTypes.TopLeft )
        f8_local33.color = Colors.black
        f8_local33.width = barWidth
        local friendlyScoreBarFrame = LUI.DecoFrame.new( f8_local33, LUI.DecoFrame.Grey )
        barContainer:addElement( friendlyScoreBarFrame )
        local f8_local35 = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.All )
        f8_local35.material = RegisterMaterial( "white" )
        f8_local35.color = Colors.grey_2
        f8_local35.alpha = 0.3
        local f8_local36 = LUI.UIImage.new( f8_local35 )
        f8_local36.id = "friendlyBarBg_id"
        friendlyScoreBarFrame:addElement( f8_local36 )
        local friendlyScoreCap = CoD.CreateState( nil, 1, -1, -1, CoD.AnchorTypes.TopBottomRight )
        friendlyScoreCap.material = RegisterMaterial( "white" )
        friendlyScoreCap.color = Colors.h1.ally_blue
        friendlyScoreCap.width = 2
        friendlyScoreCap.alpha = 0.4
        local f8_local38 = LUI.UIImage.new( friendlyScoreCap )
        f8_local38.id = "friendlyEndCap_id"
        friendlyScoreBarFrame:addElement( f8_local38 )
        local friendlyScoreBarState = CoD.CreateState( 0, 0, 1, 0, CoD.AnchorTypes.TopBottomLeft )
        friendlyScoreBarState.material = RegisterMaterial( "white" )
        friendlyScoreBarState.color = Colors.h1.ally_blue
        friendlyScoreBar = LUI.UIImage.new( friendlyScoreBarState )
        friendlyScoreBar.id = "friendlyBar_id"
        friendlyScoreBarFrame:addElement( friendlyScoreBar )
        local friendlyGlowState = CoD.CreateState( -10, -7, 7, 7, CoD.AnchorTypes.All )
        friendlyGlowState.material = RegisterMaterial( "h1_hud_team_score_glow" )
        friendlyGlowState.color = Colors.h1.ally_blue
        local friendlyGlow = LUI.UIImage.new( friendlyGlowState )
        friendlyGlow.id = "friendlyGlow_id"
        friendlyScoreBar:addElement( friendlyGlow )
        local f8_local42 = CoD.CreateState( -2, nil, nil, 2, CoD.AnchorTypes.BottomLeft )
        f8_local42.width = 2
        f8_local42.height = 2
        f8_local42.material = RegisterMaterial( "h1_deco_corner" )
        local triangle = LUI.UIImage.new( f8_local42 )
        friendlyScoreBarFrame:addElement( triangle )
        friendlyScoreBar.triangle = triangle
        
        local f8_local44 = CoD.CreateState( barLeft, -18.5, nil, -10, CoD.AnchorTypes.BottomLeft )
        f8_local44.color = Colors.black
        f8_local44.width = barWidth
        local enemyScoreBarFrame = LUI.DecoFrame.new( f8_local44, LUI.DecoFrame.Grey )
        barContainer:addElement( enemyScoreBarFrame )
        local f8_local46 = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.All )
        f8_local46.material = RegisterMaterial( "white" )
        f8_local46.color = Colors.grey_2
        f8_local46.alpha = 0.3
        local f8_local47 = LUI.UIImage.new( f8_local46 )
        f8_local47.id = "enemyBarBg_id"
        enemyScoreBarFrame:addElement( f8_local47 )
        local enemyScoreCap = CoD.CreateState( nil, 1, -1, -1, CoD.AnchorTypes.TopBottomRight )
        enemyScoreCap.material = RegisterMaterial( "white" )
        enemyScoreCap.color = Colors.h1.enemy_red
        enemyScoreCap.width = 2
        enemyScoreCap.alpha = 0.5
        local f8_local49 = LUI.UIImage.new( enemyScoreCap )
        f8_local49.id = "enemyEndCap_id"
        enemyScoreBarFrame:addElement( f8_local49 )
        local f8_local50 = CoD.CreateState( 0, 0, 1, 0, CoD.AnchorTypes.TopBottomLeft )
        f8_local50.material = RegisterMaterial( "white" )
        f8_local50.color = Colors.h1.enemy_red
        enemyScoreBar = LUI.UIImage.new( f8_local50 )
        enemyScoreBar.id = "enemyBar_id"
        enemyScoreBarFrame:addElement( enemyScoreBar )
        local f8_local51 = CoD.CreateState( -2, nil, nil, 2, CoD.AnchorTypes.BottomLeft )
        f8_local51.width = 2
        f8_local51.height = 2
        f8_local51.material = RegisterMaterial( "h1_deco_corner" )
        local f8_local52 = LUI.UIImage.new( f8_local51 )
        enemyScoreBarFrame:addElement( f8_local52 )
        enemyScoreBar.triangle = f8_local52
    end

    local friendlyScoreText = LUI.UIText.new( {
        font = CoD.TextSettings.H1TitleFont.Font,
        alignment = LUI.Alignment.Left,
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = true,
        top = 5,
        left = scoreTextLeft,
        right = 0,
        height = CoD.TextSettings.H1TitleFont.Height * 0.9,
        color = {
            r = 0.75,
            g = 0.9,
            b = 1,
            a = 1
        }
    } )
    friendlyScoreText:setTextStyle( CoD.TextStyle.Shadowed )
    friendlyScoreText.id = "friendlyScore_id"
    scoresHUD:addElement( friendlyScoreText )

    local enemyScoreText = LUI.UIText.new( {
        font = CoD.TextSettings.H1TitleFont.Font,
        alignment = LUI.Alignment.Left,
        topAnchor = false,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        bottom = -5,
        left = scoreTextLeft,
        right = 0,
        height = CoD.TextSettings.H1TitleFont.Height * 0.65,
        color = {
            r = 1,
            g = 0.9,
            b = 0.9,
            a = 1
        },
        alpha = 1
    } )
    enemyScoreText:setTextStyle( CoD.TextStyle.Shadowed )
    enemyScoreText.id = "enemyScore_id"
    scoresHUD:addElement( enemyScoreText )
    local matchStatus = LUI.UIText.new( {
        alignment = LUI.Alignment.Left,
        font = CoD.TextSettings.SP_HudWeaponNameFont.Font,
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = true,
        top = matchStatusTop,
        height = matchStatusHeight,
        left = scoreTextLeft,
        right = 0
    } )
    matchStatus.id = "roundStatus_id"
    matchStatus:setTextStyle( CoD.TextStyle.ForceUpperCase )
    matchStatus:registerOmnvarHandler( "ui_current_round", f0_local5 )
    matchStatus:registerEventHandler( "update_round_status", f0_local5 )
    local f8_local40 = LUI.UITimer.new( 3000, "update_round_status" )
    f8_local40.id = "update_round_status"
    matchStatus:addElement( f8_local40 )
    scoresHUD:addElement( matchStatus )

    local matchTimer = LUI.MenuBuilder.buildItems( {
        type = "timersHudDef"
    }, {} )
    matchTimer:registerAnimationState( "default", {
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        top = matchStatusTop,
        left = 9.5,--barLeft + barWidth * 1.1,
        width = f8_local13,
        height = matchStatusHeight
    } )
    matchTimer:animateToState( "default" )
    scoresHUD:addElement( matchTimer )

    local f8_local53 = LUI.FactionIcon.new( {
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = false,
        bottom = 1,
        left = 11,---factionOffset,
        height = factionSize,
        width = factionSize
    }, {
        disableDividers = true
    } )
    f8_local53.id = "logo"
    scoresHUD:addElement( f8_local53 )

    GetFactionIcon( f8_local53 )
    f8_local53:registerEventHandler( "playerstate_client_changed", function ( element, event )
        GetFactionIcon( f8_local53 )
    end )
    f8_local53:registerOmnvarHandler( "ui_team_selected", function ( f11_arg0, f11_arg1 )
        GetFactionIcon( f8_local53 )
    end )

    friendlyScoreText:setupUIBindText( "TeamScoreFriendly" )
    enemyScoreText:setupUIBindText( "TeamScoreEnemy" )
    local friendlyState = LUI.UIElement.new()
    friendlyState.id = "scoreWatchFriendly"
    friendlyState.score = friendlyScoreText
    friendlyState.bar = friendlyScoreBar
    friendlyState.width = barWidth
    friendlyState.limit = scoreLimit
    friendlyState.root = barContainer
    friendlyState:setupUIIntWatch( "TeamScoreFriendly" )
    friendlyState:registerEventHandler( "int_watch_alert", UpdateScores )
    friendlyState:registerOmnvarHandler( "ui_match_countdown_toggle", function ( f12_arg0, f12_arg1 )
        if f12_arg1.value == false then
            local self = LUI.UITimer.new( 3000, "delay_complete", nil, true )
            f12_arg0:registerEventHandler( "delay_complete", function ()
                f0_local2( f12_arg0, {
                    forced = true
                } )
            end )
            f12_arg0:addElement( self )
        end
    end )
    matchStatus:addElement( friendlyState )
    local enemyState = LUI.UIElement.new()
    enemyState.id = "scoreWatchEnemy"
    enemyState.score = enemyScoreText
    enemyState.bar = enemyScoreBar
    enemyState.width = barWidth
    enemyState.limit = scoreLimit
    enemyState.root = barContainer
    enemyState:setupUIIntWatch( "TeamScoreEnemy" )
    enemyState:registerEventHandler( "int_watch_alert", UpdateScores )
    matchStatus:addElement( enemyState )

    local three_digits_state = CoD.CreateState(nil, nil, nil, -3, CoD.AnchorTypes.BottomLeft)
    three_digits_state.width = scoresWidth
    three_digits_state.height = scoresHeight

    local two_digits_state = CoD.CreateState(-15, nil, nil, -3, CoD.AnchorTypes.BottomLeft)
    two_digits_state.width = scoresWidth
    two_digits_state.height = scoresHeight

    local one_digit_state = CoD.CreateState(-25, nil, nil, -3, CoD.AnchorTypes.BottomLeft)
    one_digit_state.width = scoresWidth
    one_digit_state.height = scoresHeight

    barContainer:registerAnimationState("three_digits", three_digits_state)
    barContainer:registerAnimationState("two_digits", two_digits_state)
    barContainer:registerAnimationState("one_digit", one_digit_state)

    root:addElement(blurRoot)
    root:addElement(scoresHUD)
    root:addElement(barContainer)
    return root
end
