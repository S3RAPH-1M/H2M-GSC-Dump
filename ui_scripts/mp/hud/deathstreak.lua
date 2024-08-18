local function getDeathstreakEvent( parent, omnvar )
    local ttl = 2500
    local splash = Game.GetOmnvar( "ui_splash_deathstreak_idx" ) or -1
    local icon = parent:getChildById( "deathstreak_icon" )
    local title = parent:getChildById( "deathstreak_title" )
    local desc = parent:getChildById( "deathstreak_desc" )
    
    if splash > -1 then
        parent:animateToState( "drop" )

        icon:setImage(RegisterMaterial( Engine.TableLookup( StatsTable.File, StatsTable.Cols.WeaponId, splash, StatsTable.Cols.Image ) ) )
        title:setText( Engine.Localize( Engine.TableLookup( StatsTable.File, StatsTable.Cols.WeaponId, splash, StatsTable.Cols.Name ) ) )
        desc:setText( Engine.Localize( Engine.TableLookup( StatsTable.File, StatsTable.Cols.WeaponId, splash, StatsTable.Cols.WeaponDesc ) ) )

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
        Engine.PlaySound( "mp_last_stand" )
    end
end

LUI.MenuBuilder.registerType("deathstreakSplashEventHudDef", function()
    local root = LUI.UIElement.new()
    root.id = "deathstreakSplashEventHud";
    local width = 250
    local top = 200
	local icon = LUI.UIImage.new({
        topAnchor = true,
        leftAnchor = false,
        bottomAnchor = false,
        rightAnchor = false,
        top = -top - 80,
        height = 72,
        width = 72,
        material = RegisterMaterial("white"),
        color = Colors.white,
    })
    icon.id = "deathstreak_icon"
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
    title.id = "deathstreak_title"
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
    desc.id = "deathstreak_desc"
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

	root:registerOmnvarHandler( "ui_splash_deathstreak_time", getDeathstreakEvent )
	root:addElement( icon )
    root:addElement( title )
    root:addElement( desc )
    return root
end)