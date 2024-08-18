local debug = Engine.GetDvarBool("uiscript_debug")

local scale = function(size)
    return size * 720 / 1080
end
local h2_bank_font = {
    Font = RegisterFont("fonts/h2_bank.ttf", 23),
    Height = scale(23)
}

local connect = function (a1)
    print("connect menu")

    local mapname = "Bog"
    local gametype = "Team Deathmatch"
    local didyouknow = "This is dummy didyouknow content for debugging"

    if debug ~= true then
        mapname = Engine.GetDvarString( "ui_mapname" )
        gametype = Engine.GetDvarString( "ui_gametype" )
        didyouknow = Engine.GetDvarString("didyouknow")
    end

    local menu = LUI.MenuTemplate.new(a1, {
        menu_title = "",
        menu_width = luiglobals.GenericMenuDims.OptionMenuWidth
    })

    -- remove 'MULTIPLAYER' breadcrumb
    menu:SetBreadCrumb( "" )    
    
    -- Add Background of Current Map --
    local loadscreen_background_mat = {
        material = RegisterMaterial("$levelbriefingcrossfade")
    }
    menu:AddOptionalBackground(loadscreen_background_mat)

    menu:AddVignette()
    menu:AddVignette()

    -- Add Mapname and Gametype to the far right --
    local gametypeDisplay = LUI.UIText.new({
        font = h2_bank_font.Font,
		alignment = LUI.Alignment.Right,
		top = -300 - h2_bank_font.Height,
		left = 97,
		width = 485,
		height = h2_bank_font.Height + 6,
		alpha = 1,
        color = Colors.goldenrod
    })
    gametypeDisplay.id = "gametypeDisplay"
    gametypeDisplay:setText( Engine.Localize("@" .. Engine.ToUpperCase( gametype ) ) )
    menu:addElement(gametypeDisplay)

    local mapnameDisplay = LUI.UIText.new({
        font = h2_bank_font.Font,
		alignment = LUI.Alignment.Right,
		top = -276 - h2_bank_font.Height,
		left = 97,
		width = 485,
		height = h2_bank_font.Height + 6,
		alpha = 1,
        color = Colors.white
    })
    mapnameDisplay.id = "mapnameDisplay"
    mapnameDisplay:setText( Engine.Localize("@" .. Engine.ToUpperCase( mapname ) ) )
    menu:addElement(mapnameDisplay)

    -- Add h1 logo to bottom right --
    local logoState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.BottomRight )
	logoState.material = RegisterMaterial( CoD.Material.LoadingAnim )
	logoState.width = 64
	logoState.height = 64
    logoState.top = -70
    local h1LogoDisplay = LUI.UIImage.new(logoState)
    h1LogoDisplay.id = "h1LogoDisplay"
    menu:addElement(h1LogoDisplay)

    -- Add didyouknow --
    local dykDisplay = LUI.UIText.new({
        font = h2_bank_font.Font,
		horizontalAlignment = LUI.HorizontalAlignment.Left,
        verticalAlignment = LUI.VerticalAlignment.Bottom,
        left = -600,
        top = 306 - h2_bank_font.Height,
		height = h2_bank_font.Height,
		alpha = 1,
        color = Colors.white
    })
    dykDisplay.id = "dykDisplay"
    dykDisplay:setText( Engine.Localize( didyouknow ) )
    menu:addElement(dykDisplay)

    return menu
end

LUI.MenuBuilder.m_types_build["connect"] = connect
--LUI.MenuBuilder.registerType("connect", connect)
