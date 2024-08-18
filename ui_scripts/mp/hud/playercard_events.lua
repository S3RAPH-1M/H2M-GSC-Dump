local previous_timer = nil

local function hideActionSlots( element, ttl )
    local actionslot = Engine.GetLuiRoot():getFirstDescendentById("actionslothud_id")
    if actionslot == nil then return end

    actionslot:animateToState( "hide" )

    local timer = LUI.UITimer.new(ttl + 250, "playercardSplashEnded", nil, true, nil, nil, nil, false)
    if previous_timer then
        previous_timer:close()
    end

    element:registerEventHandler("playercardSplashEnded", function(self, event)
        actionslot:animateToState("active")
    end)
    element:addElement(timer)
    previous_timer = timer
end

local function getKillEvent( parent, omnvar )
    local ttl = 1500
    local clientID = Game.GetOmnvar( "ui_splash_cardkill_clientnum" ) or -1
    local type_ = Game.GetOmnvar( "ui_splash_cardkill_idx" ) or -1
    local card = parent:getChildById( "cardkill_playercard" )
    local text = parent:getChildById( "cardkill_caption" )
    local caption
    
    if type_ == 0 then
        caption = "MP_KILLED_BY"
    elseif type_ == 1 then
        caption = "MP_YOU_KILLED"
    else
        return
    end
    
    if clientID > -1 and type_ > -1 then
        hideActionSlots( parent, ttl )

        card:processEvent({
            name = "update_playercard_for_clientnum",
            clientNum = clientID
        })
        
        text:setText( Engine.Localize( caption ) )
        local animator = MBh.AnimateSequence( {
            { -- animate drop for existing card
                "drop",
                50
            },
            {
                "raise",
                150
            },
            {
                "active",
                ttl
            },
            {
                "drop",
                150
            }
        } )
        animator( parent )
    end
end

local function getSplashEvent( parent, omnvar )
    local ttl = 2500
    local clientID = Game.GetOmnvar( "ui_splash_playercard_clientnum" ) or -1
    local splash = Game.GetOmnvar( "ui_splash_playercard_idx" ) or -1
    local optional = Game.GetOmnvar( "ui_splash_playercard_optional_number" )
    local card = parent:getChildById( "callout_playercard" )
    local text = parent:getChildById( "callout_caption" )

    if clientID > -1 and splash > -1 then
        card:processEvent({
            name = "update_playercard_for_clientnum",
            clientNum = clientID
        })

        local string = Engine.TableLookupByRow( SplashTable.File, splash, SplashTable.Cols.Name )
        if optional ~= nil then
            text:setText( Engine.Localize( string, optional ) )
        else
            text:setText( Engine.Localize( string ) )
        end

        local animator = MBh.AnimateSequence( {
            { -- animate drop for existing card
                "drop",
                50
            },
            {
                "raise",
                150
            },
            {
                "active",
                ttl
            },
            {
                "drop",
                150
            }
        } )
        animator( parent )
        Engine.PlaySound( "h2_card_slide")
    end
end


LUI.MenuBuilder.registerType("playercardKillEventHudDef", function()
    local root = LUI.UIElement.new()
    root.id = "playercardKillEventHud";
	root:registerAnimationState( "default", {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		top = 0,
		left = 0,
		right = 0,
		bottom = 0
	} )

    -- this is gross but im not sure how safe area works
    local bottom = ( 350 + HUD.GetXPBarOffset() ) * Engine.GetDvarFloat( "safeArea_adjusted_vertical" )

    local default = {
        topAnchor = false,
        leftAnchor = false,
        bottomAnchor = true,
        rightAnchor = false,
        height = LUI.Playercard.Height,
        width = LUI.Playercard.Width,
        bottom = bottom,
        alpha = 1
    }

    local caption = LUI.UIText.new({
        topAnchor = false,
        leftAnchor = false,
        bottomAnchor = true,
        rightAnchor = false,
        height = 17,
        width = LUI.Playercard.Width,
        bottom = bottom - 89,
        alignment = LUI.Alignment.Center,
        font = CoD.TextSettings.TitleFontSmallBold.Font,
        color = Colors.white
    })
    caption.id = "cardkill_caption"
    caption:setTextStyle(CoD.TextStyle.Outlined)

	local playercard = LUI.Playercard.new( default )
    playercard.id = "cardkill_playercard"
    root:registerAnimationState( "default", default )
	root:registerAnimationState( "drop", {
        bottom = 200,
        alpha = 0
	} )
	root:registerAnimationState( "raise", {
        bottom = 0,
        alpha = 1
	} )
	root:registerAnimationState( "active", {
        bottom = 0,
        alpha = 1
	} )
    root:animateToState( "drop" )

	root:registerOmnvarHandler( "ui_splash_cardkill_time", getKillEvent )
    root:addElement( playercard )
    root:addElement( caption )
    return root
end)

LUI.MenuBuilder.registerType("playercardSplashEventHudDef", function()
    local root = LUI.UIElement.new()
    root.id = "playercardSplashEventHud";
	root:registerAnimationState( "default", {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		top = 0,
		left = 0,
		right = 0,
		bottom = 0
	} )

    local top = -350 * Engine.GetDvarFloat( "safeArea_adjusted_vertical" )
    local left = 390 * Engine.GetDvarFloat( "safeArea_adjusted_horizontal" )
    local default = {
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = false,
        rightAnchor = false,
        height = LUI.Playercard.Height,
        width = LUI.Playercard.Width,
        top = top,
        left = left,
        alpha = 1
    }

    local caption = LUI.UIText.new({
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = false,
        rightAnchor = false,
        height = 17,
        width = LUI.Playercard.Width,
        top = top + 89,
        left = left,
        alignment = LUI.Alignment.Left,
        font = CoD.TextSettings.TitleFontSmallBold.Font,
        color = Colors.white
    })
    caption.id = "callout_caption"
    caption:setTextStyle(CoD.TextStyle.Outlined)

	local playercard = LUI.Playercard.new( default )
    playercard.id = "callout_playercard"
    root:registerAnimationState( "default", default )
	root:registerAnimationState( "drop", {
        left = 500,
        alpha = 0
	} )
	root:registerAnimationState( "raise", {
        left = 0,
        alpha = 1
	} )
	root:registerAnimationState( "active", {
        alpha = 1
	} )
    root:animateToState( "drop" )

	root:registerOmnvarHandler( "ui_splash_playercard_time", getSplashEvent )
    root:addElement( playercard )
    root:addElement( caption )
    return root
end)