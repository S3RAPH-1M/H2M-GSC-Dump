function ProcessScorePopupEvents( mainElement )
	mainElement.ttl = Game.GetTime() + 1180
	if not mainElement.visible then
		mainElement:processEvent( {
			name = "reset"
		} )
	end
	mainElement.visible = true
	if not mainElement.timer then
		mainElement.timer = LUI.UITimer.new( 100, "monitor_ttl" )
		mainElement.timer.id = "timer"
		mainElement:addElement( mainElement.timer )
		mainElement:registerEventHandler( "monitor_ttl", function ( element, event )
			if element.ttl < Game.GetTime() and not Game.InKillCam() then
				mainElement.timer:close()
				mainElement.timer = nil
				mainElement:processEvent( {
					name = "fade"
				} )
				mainElement.visible = false
			end
		end )
	end
end

LUI.MenuBuilder.m_types_build["pointsPopup"] = function()
	local mainElement = LUI.UIElement.new( {
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = 10,
		height = 0,
		left = 20,
		width = 0
	} )

	mainElement.id = "pointsPopup"
	mainElement.processOmnvarEvent = true

	local defaultScale = 0
	local textElement = LUI.UIText.new( {
		font = CoD.TextSettings.H1TitleFont.Font,
		alignment = LUI.Alignment.Center,
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = true,
		left = -40,
		top = -85,
		right = 0,
		height = 30,
		alpha = 1,
		scale = defaultScale,
		color = Colors.mw1_green
	} )
	
	textElement.id = "points"
    textElement:setTextStyle( CoD.TextStyle.ShadowedMore )
	textElement:registerAnimationState( "start", {
		scale = defaultScale,
		alpha = 1
	} )
	textElement:registerAnimationState( "pop", {
		scale = 2,
		alpha = 1
	} )
	textElement:registerAnimationState( "hidden", {
		scale = defaultScale,
		alpha = 0
	} )

	textElement:registerEventHandler( "fade", function ( element, event )
		element.active = false
		element:animateToState( "hidden", 600 )
	end )

	textElement:registerEventHandler( "reset", function ( element, event )
		element:setText( "" )
		element:animateToState( "default" )
	end )

	textElement:registerOmnvarHandler( "ui_points_popup", function ( element, event )
		if not Game.InKillCam() and mainElement.processOmnvarEvent then
			if event.value > 0 then
				ProcessScorePopupEvents( mainElement )
				element:setText( "+" .. event.value )
				element.active = true
				local animator = MBh.AnimateSequence( {
					{
						"default",
						20
					},
					{
						"pop",
						100
					},
					{
						"default",
						118
					}
				} )
				animator( element, {} )
			end
		end
	end )

	mainElement:addElement( textElement )
	mainElement.curClientNum = Game.GetPlayerstateClientnum()
	mainElement:registerEventHandler( "playerstate_client_changed", function ( element, event )
		local clientNum = Game.GetPlayerstateClientnum()
		if mainElement.curClientNum ~= clientNum then
			mainElement.curClientNum = clientNum
			mainElement.processOmnvarEvent = not Game.InKillCam()
		end
	end )

	return mainElement
end