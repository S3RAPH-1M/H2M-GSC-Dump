local function f0_local0 ( f1_arg0, f1_arg1, f1_arg2, f1_arg3 )
	local f1_local0 = Game.GetOmnvar( "ui_player_xp_rank" )
	if f1_local0 ~= nil then
		LUI.ExperienceProgressBar.UpdatePlayerRank( f1_arg2, {
			value = f1_local0
		} )
	end
	local f1_local1 = Game.GetOmnvar( "ui_player_xp_pct" )
	if f1_local1 ~= nil then
		LUI.ExperienceProgressBar.UpdatePlayerXP( f1_arg3, {
			value = f1_local1,
			initialUpdate = true
		} )
	end
end


LUI.MenuBuilder.m_types_build["experienceBar"] = function()
    local state = CoD.CreateState( 19, nil, 0, 7, CoD.AnchorTypes.BottomLeftRight )
	state.height = LUI.ExperienceProgressBar.ContainerHeight
	local root = LUI.UIElement.new( state )
    root:setClass( LUI.ExperienceProgressBar )
    root.id = "experienceBar_root"

    if not HUD.CanShowXPBar() then
        return root
    end

	local f7_local2 = CoD.CreateState( LUI.ExperienceProgressBar.Padding, nil, -LUI.ExperienceProgressBar.Padding, nil, CoD.AnchorTypes.LeftRight )
	f7_local2.height = LUI.ExperienceProgressBar.Height
	local f7_local3 = LUI.UIElement.new( f7_local2 )
	root:addElement( f7_local3 )

	local background = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
	background.material = RegisterMaterial( "black" )
	background.alpha = 0.5
	f7_local3:addElement( LUI.UIImage.new( background ) )
    
	local f7_local5 = CoD.CreateState( LUI.ExperienceProgressBar.Padding, nil, -LUI.ExperienceProgressBar.Padding, nil, CoD.AnchorTypes.LeftRight )
	f7_local5.height = LUI.ExperienceProgressBar.Height
	local f7_local6 = LUI.UIElement.new( f7_local5 )
	f7_local3:addElement( f7_local6 )

	local f7_local7 = CoD.CreateState( 1, 0, nil, nil, CoD.AnchorTypes.TopBottomLeft )
	f7_local7.width = 0
	f7_local6:registerAnimationState( "reset", f7_local7 )

	local leftFlareState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Right )
	leftFlareState.width = 0
	leftFlareState.height = 0
	leftFlareState.material = RegisterMaterial( "h1_ui_xp_progress_flare_l" )
	local leftFlare = LUI.UIImage.new( leftFlareState )
	leftFlare:registerAnimationState( "big", {
		rightAnchor = true,
		left = -34,
		right = -5,
		height = 43
	} )
	local rightFlareState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Right )
	rightFlareState.width = 0
	rightFlareState.height = 0
	rightFlareState.material = RegisterMaterial( "h1_ui_xp_progress_flare_r" )
	local rightFlare = LUI.UIImage.new( rightFlareState )
	rightFlare:registerAnimationState( "big", {
		rightAnchor = true,
		right = 7,
		left = -5,
		height = 43
	} )
	local f7_local13 = LUI.UIElement.new( CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All ) )
	f7_local6.flareLeft = leftFlare
	f7_local6.flareRight = rightFlare
	f7_local13:setUseStencil( true )
	f7_local6:registerOmnvarHandler( "ui_player_xp_pct", LUI.ExperienceProgressBar.UpdatePlayerXP )
	f7_local6.lastEventValue = 0
	f7_local6.lastWidthValue = 0
	f7_local6:addElement( f7_local13 )
	f7_local6:addElement( rightFlare )
	f7_local6:addElement( leftFlare )

	local barFillState = CoD.CreateState( -20, -6, 20, 6, CoD.AnchorTypes.All )
	barFillState.material = RegisterMaterial( "h1_ui_experiencebar_fill" )
	local barFill = LUI.UIImage.new( barFillState )
    barFill:setup3SliceRatio( 0.01, 1 )
	f7_local6.bar = barFill
	f7_local13:addElement( barFill )
    
	local f7_local16 = CoD.CreateState( -20, -6, 20, 6, CoD.AnchorTypes.All )
	barFill:registerAnimationState( "position", f7_local16 )
	f7_local16.alpha = 1
	barFill:registerAnimationState( "full", f7_local16 )
	f7_local16.alpha = 0.4
	barFill:registerAnimationState( "half", f7_local16 )

	local leftRankState = CoD.CreateState( 0, 3, nil, -3, CoD.AnchorTypes.TopBottomLeft )
	leftRankState.width = LUI.ExperienceProgressBar.ContainerHeight - 6
	leftRankState.material = RegisterMaterial( "black" )
	local leftRank = LUI.UIImage.new( leftRankState )
	root:addElement( leftRank )
	root.leftRank = leftRank
	
	local leftRankTextState = CoD.CreateState( 27, -4.5, nil, nil, CoD.AnchorTypes.Left )
	leftRankTextState.width = 40
	leftRankTextState.height = CoD.TextSettings.TitleFontVeryTiny.Height
	leftRankTextState.font = CoD.TextSettings.TitleFontVeryTiny.Font
	local leftRankText = LUI.UIText.new( leftRankTextState )
	root:addElement( leftRankText )
	root.leftRankText = leftRankText
	
	local rightRankState = CoD.CreateState( nil, 3, -10, -3, CoD.AnchorTypes.TopBottomRight )
	rightRankState.width = LUI.ExperienceProgressBar.ContainerHeight - 6
	rightRankState.material = RegisterMaterial( "black" )
	
	local rightRank = LUI.UIImage.new( rightRankState )
	rightRank:registerAnimationState( "default", rightRankState )
	rightRank:registerAnimationState( "hidden", {
		alpha = 0
	} )
	root:addElement( rightRank )
	root.rightRank = rightRank
	
	root:registerOmnvarHandler( "ui_player_xp_rank", LUI.ExperienceProgressBar.UpdatePlayerRank )
	root:addElement( LUI.UITimer.new( 0, "firstFrameUpdate", nil, true ) )
	root:registerEventHandler( "firstFrameUpdate", function ( element, event )
		f0_local0( element, event, root, f7_local6 )
	end )

	return root
end