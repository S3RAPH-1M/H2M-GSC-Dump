local function getStuckEvent( parent, omnvar )
    local ttl = 2500
    local splash = Game.GetOmnvar( "ui_splash_stuck_idx" ) or -1
    local title = parent:getChildById( "stuck_title" )
    local desc = parent:getChildById( "stuck_desc" )
    
    if splash > -1 then
        local deathstreak = Engine.GetLuiRoot():getFirstDescendentById( "deathstreakSplashEventHud" )
        if deathstreak ~= nil then
            deathstreak:animateToState( "drop" )
        end
        parent:animateToState( "drop" )
        
        title:setText( Engine.Localize( Engine.TableLookupByRow( SplashTable.File, splash, SplashTable.Cols.Name ) ) )
        desc:setText( Engine.Localize( Engine.TableLookupByRow( SplashTable.File, splash, SplashTable.Cols.Desc ) ) )

        local animator = MBh.AnimateSequence( {
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
        Engine.PlaySound( Engine.TableLookupByRow( SplashTable.File, splash, SplashTable.Cols.Sound ) )
    end
end

LUI.MenuBuilder.registerType("stuckSplashEventHudDef", function()
    local root = LUI.UIElement.new()
    root.id = "stuckSplashEventHud";
    local width = 250
    local top = 200

    local title = LUI.UIText.new({
        topAnchor = true,
        leftAnchor = false,
        bottomAnchor = false,
        rightAnchor = false,
        top = -top,
        height = 24,
        width = width / 2,
        alignment = LUI.Alignment.Center,
        font = CoD.TextSettings.H1TitleFont.Font,
        color = Colors.white
    })
    title.id = "stuck_title"
    title:setTextStyle( CoD.TextStyle.ShadowedMore )
    title:setGlow( Swatches.HUD.Enemies, 0.3, 0.3 )

    local desc = LUI.UIText.new({
        topAnchor = true,
        leftAnchor = false,
        bottomAnchor = false,
        rightAnchor = false,
        top = -top + 30,
        height = 15,
        width = width,
        alignment = LUI.Alignment.Center,
        font = CoD.TextSettings.TitleFontSmallBold.Font,
        color = Colors.white
    })
    desc.id = "stuck_desc"
    desc:setTextStyle( CoD.TextStyle.ShadowedMore )

	root:registerAnimationState( "drop", {
        scale = 1,
        alpha = 0
	} )
	root:registerAnimationState( "raise", {
        scale = 0,
        alpha = 1
	} )
	root:registerAnimationState( "active", {
        alpha = 1
	} )
    root:animateToState( "drop" )

	root:registerOmnvarHandler( "ui_splash_stuck_time", getStuckEvent )
    root:addElement( title )
    root:addElement( desc )
    return root
end)