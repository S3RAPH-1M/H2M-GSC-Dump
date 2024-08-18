require("h2_tab")
require("h1_tab")
require("iw4_tab")

local h2_maps = require("data.h2_maps")
local iw4_maps = require("data.iw4_maps")
local h1_maps = require("data.h1_maps")

local currentTab = "iw4"

local function NoBonusMapsAction(menu, controller)
    local onlineGame = Engine.GetOnlineGame()
    if not onlineGame then
        onlineGame = Engine.GetDvarBool("ui_onlineRequired")
    end

    if onlineGame then
        LUI.FlowManager.RequestLeaveMenu(menu)
        Sns.OpenStoreMenu(controller, "map_select_menu", LUI.ComScore.ScreenID.MapSelect, LUI.ComScore.StoreSource.MenuButton)
    end
end

local function GetButtonMapName(mapIndex)
	local localizedMapName = Lobby.GetMapNameByIndex(mapIndex)
	if Engine.MarkLocalized(localizedMapName) == Engine.Localize("DLC_MAPSTORE") then
		localizedMapName = Engine.Localize("LUA_MENU_MORE_MAPS")
	end
	return localizedMapName
end

local function AddDetailsWindow(menuElement)
    local width = 468
    local height = 143
    local padding = 3
    local contentWidth = width - 2 * padding
    local headerFont = CoD.TextSettings.Font46
    local bodyFont = CoD.TextSettings.BodyFontVeryTiny
    local headerTop = 300
    local nameTop = 60
    local descriptionTop = 100
    local detailsState = CoD.CreateState(GenericMenuDims.menu_right_standard / width + 105, 140, nil, nil, CoD.AnchorTypes.None)
    detailsState.width = width
    detailsState.height = height
    local detailsWindow = LUI.UIElement.new(detailsState)
    detailsWindow.id = "mapsetup_details_window"
    
    local bgElement = LUI.MenuBuilder.BuildRegisteredType("generic_menu_background")
    bgElement.id = "mapsetup_details_window_bg"
    detailsWindow:addElement(bgElement)
    bgElement:addElement(LUI.DecoFrame.new(CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All), LUI.DecoFrame.Grey))
    
    local imageMaskState = CoD.CreateState(padding + 0.5, 8.5, -padding + 0.5, nil, CoD.AnchorTypes.TopLeftRight)
    imageMaskState.height = (width - 2 * padding) * 0.71
    local imageMaskElement = LUI.UIElement.new(imageMaskState)
    imageMaskElement.id = "mapsetup_mapimagemask"
    imageMaskElement:setUseStencil(true)
    detailsWindow:addElement(imageMaskElement)
    
    local mapImageState = CoD.CreateState(-17, 25, 25, nil, CoD.AnchorTypes.TopLeftRight)
    mapImageState.height = 0
    local mapImageElement = LUI.UIImage.new(mapImageState)
    mapImageElement.id = "mapsetup_mapimage"
    detailsWindow:addElement(mapImageElement)
    
    local headerLabelStyle = {
        topAnchor = true,
        width = contentWidth - 20,
        left = -214,
        alignment = LUI.Alignment.Left
    }
    
    local headerOffsetY = 19
    local headerWidth, _, _, _ = GetTextDimensions(Engine.Localize("@LUA_MENU_MAP_CAPS"), bodyFont.Font, bodyFont.Height)
    local headerBackgroundState = CoD.CreateState(headerOffsetY, headerTop, headerWidth * 2.08 + headerOffsetY, headerTop + bodyFont.Height * 1.75, CoD.AnchorTypes.TopLeft)
    headerBackgroundState.alpha = 0.7
    headerBackgroundState.color = {
        r = 0,
        b = 0,
        g = 0
    }
    
    local headerBackgroundElement = LUI.UIImage.new(headerBackgroundState)
    detailsWindow:addElement(headerBackgroundElement)
    
    local headerLabel = LUI.UIText.new({
        topAnchor = true,
        alignment = LUI.Alignment.Left,
        width = contentWidth - 20,
        top = headerTop + 5.5 + 50,
        left = -204,
        height = bodyFont.Height,
        font = bodyFont.Font
    })
    headerLabel.id = "mapsetup_thewordmap"
    headerLabel:setText(Engine.Localize("@LUA_MENU_MAP_CAPS"))
    
    headerLabelStyle.top = nameTop
    headerLabelStyle.height = headerFont.Height
    headerLabelStyle.font = headerFont.Font
    headerLabelStyle.color = Colors.mw1_green
    
    local nameLabel = LUI.UIText.new(headerLabelStyle)
    nameLabel:setTextStyle(CoD.TextStyle.ShadowedMore)
    nameLabel.id = "mapsetup_mapname"
    nameLabel.properties = {
        text = ""
    }
    detailsWindow:addElement(nameLabel)

    headerLabelStyle.color = Colors.white
    
    headerLabelStyle.top = descriptionTop
    headerLabelStyle.height = bodyFont.Height
    headerLabelStyle.font = bodyFont.Font
    headerLabelStyle.alignment = LUI.AdjustAlignmentForLanguage(LUI.Alignment.Left)
    
    local descriptionLabel = LUI.UIText.new(headerLabelStyle)
    descriptionLabel.id = "mapsetup_mapdesc"
    descriptionLabel:registerAnimationState("adjusted", {
        topAnchor = true,
        top = 293,
        height = bodyFont.Height
    })
    detailsWindow:addElement(descriptionLabel)

    headerLabelStyle.alpha = 0.5
    headerLabelStyle.top = 120
    headerLabelStyle.height = 11
    headerLabelStyle.font = headerFont.Font

    local gameLabel = LUI.UIText.new(headerLabelStyle)
    gameLabel.id = "mapsetup_mapgame"
    gameLabel.properties = {
        topAnchor = false
    }
    detailsWindow:addElement(gameLabel)
    
    local triangleState = CoD.CreateState(0, 0, nil, nil, CoD.AnchorTypes.TopLeft)
    triangleState.height = 11
    triangleState.width = 11
    triangleState.left = -35
    triangleState.top = 48
    triangleState.material = RegisterMaterial("h1_ui_deco_green_triangle")
    
    detailsWindow:hide()
    menuElement:addElement(detailsWindow)
end

LUI.MapSetup.ChangeTab = function ( menu, tab, tabManager )
	if menu.currTab then        
		menu.currTab:animateToState( "disabled" )
		tab:animateToState( "enabled" )
		menu.currTab:processEvent( {
            name = "lostFocus"
		} )
		tab:processEvent( {
            name = "gainedFocus"
		} )
        
        for count = 1, #menu.currTab.Buttons, 1 do
            if menu.currTab.Buttons[count] ~= nil then
                local parent = menu.currTab.Buttons[count]:getParent()
                parent:removeElement(menu.currTab.Buttons[count])
            end
        end
        tab:MapFeeder(menu)
	end

	menu.currTab = tab
    currentTab = tab:GetTabReferrer()

    ListPaging.Reset( menu.list )

    menu:InitScrolling()
end

LUI.MapSetup.AddTabs = function ( menu )

	local tabState = {
		defState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.TopLeftRight ),
		numOfTabs = 3
	}

	local tabManager = LUI.MenuBuilder.BuildRegisteredType( "MFTabManager", tabState )
	tabManager:keepRightBumperAlignedToHeader( false )
	tabManager.tabSelected = 1
	local tabs = {}

    local IW4Maps = LUI.MenuBuilder.BuildRegisteredType( "iw4_tab", {
        controller = menu.controller
    } )
    tabs[#tabs + 1] = IW4Maps
    menu:addElement( IW4Maps )

    local H2Maps = LUI.MenuBuilder.BuildRegisteredType( "h2_tab", {
        controller = menu.controller
    } )
    tabs[#tabs + 1] = H2Maps
    menu:addElement( H2Maps )

    local H1Maps = LUI.MenuBuilder.BuildRegisteredType( "h1_tab", {
        controller = menu.controller
    } )
    tabs[#tabs + 1] = H1Maps
    menu:addElement( H1Maps )

    tabs[1]:MapFeeder(menu)

    for count = 1, #tabs, 1 do
		local counter = count
		tabManager:addTab( menu.controller, tabs[counter]:GetTabLabel(), function ()
			menu:ChangeTab( tabs[counter], tabManager )
		end )
	end

	tabManager:refreshTab( menu.controller )
	menu:addElement( tabManager )
end

local function UpdateMapRotation(menu, controller)
    local mapScopedData = LUI.FlowManager.GetMenuScopedDataFromElement(menu)

    local maps = nil

    if currentTab == "h2" then
        maps = h2_maps
    elseif currentTab == "iw4" then
        maps = iw4_maps
    elseif currentTab == "h1" then
        maps = h1_maps
    end

    local mapFeederCount = #maps
    for index = 0, mapFeederCount - 1, 1 do
        local mapButton = menu:getFirstDescendentById("mapsetup_menu_main_button_" .. index)
        if mapButton ~= nil then
            mapButton:processEvent({
                name = "set_checked",
                checkBox = Lobby.IsMapInRotation(Lobby.GetMapLoadNameByIndex(index)),
                dispatchChildren = true
            })
        end
    end
end

local function RefreshMapList(menu, controller)
    local mapList = menu:getChildById("mapsetup_rptatopmmaplist")
    mapList:processEvent({
        name = "menu_refresh"
    })
    menu:processEvent({
        name = "update_lists_new"
    })
    menu:processEvent({
        name = "gain_focus"
    })
    UpdateMapRotation(menu, controller)
end

-- -------------------------------------------------------------------------- --
--                           Back button and exiting                          --
-- -------------------------------------------------------------------------- --

local function ExitMenu(menu, controller)
    local menuScopedData = LUI.FlowManager.GetMenuScopedDataFromElement(menu) or {}
    local isRotationAllowed = menuScopedData.rotationAllowed

    if isRotationAllowed then
        isRotationAllowed = MatchRules.IsUsingCustomMapRotation()
    end

    if not isRotationAllowed then
        Engine.ExecNow("xupdatepartystate")
    end

    Engine.SetDvarBool("ui_showDLCMaps", false)
    PersistentBackground.ChangeBackground(nil, CoD.Background.Default)
    LUI.FlowManager.RequestLeaveMenu(menu)
    PersistentBackground.ChangeBackground(nil, CoD.Background.Default)
end

local function BackButtonFunc(button, controller)
    if Engine.GetDvarBool("ui_showDLCMaps") then
        Engine.SetDvarBool("ui_showDLCMaps", false)
        button:dispatchEventToRoot({
            name = "refresh_maps_new"
        })
    else
        PersistentBackground.ChangeBackground(nil, CoD.Background.Default)
        ExitMenu(button, controller)
    end
end

-- -------------------------------------------------------------------------- --
--                                Map Selection                               --
-- -------------------------------------------------------------------------- --

local function PurchaseMapsAction(menu, controller)
    LUI.FlowManager.RequestLeaveMenu(menu)
    Sns.OpenStoreMenu(controller, "map_select_menu", LUI.ComScore.ScreenID.MapSelect, LUI.ComScore.StoreSource.MenuButton)
end

local function GetMoreMaps(menu, controller)
    local popupData = {
        popup_title = Engine.Localize("@MENU_NOTICE"),
        message_text = nil,
        yes_action = nil
    }

    if LUI.MenuTemplate.CanShowStore() then
        if Engine.GetOnlineGame() then
            popupData.message_text = Engine.Localize("@LUA_MENU_PURCHASE_MAPS")
            popupData.yes_action = PurchaseMapsAction
            LUI.FlowManager.RequestAddMenu(menu, "generic_yesno_popup", true, controller, false, popupData)
        else
            popupData.message_text = Engine.Localize("@LUA_MENU_PURCHASE_MAPS_OFFLINE")
            LUI.FlowManager.RequestAddMenu(menu, "generic_confirmation_popup", true, controller, false, popupData)
        end
    elseif Engine.IsPS4() then
        Store.ShowEmptyStoreDialog(controller)
    else
        popupData.message_text = Engine.Localize("@LUA_MENU_STORE_RESTRICTED")
        LUI.FlowManager.RequestAddMenu(menu, "generic_confirmation_popup", true, controller, false, popupData)
    end
end

local function SelectMap_Single(menu, controller)
    local menuScopedData = LUI.FlowManager.GetMenuScopedDataFromElement(menu) or {}
    local mapIndex = controller.idx

    local maps = nil

    if currentTab == "h2" then
        maps = h2_maps
    elseif currentTab == "iw4" then
        maps = iw4_maps
    elseif currentTab == "h1" then
        maps = h1_maps
    end

    if maps == nil then
        --print ("maps was nil")
        return
    end

    local mapData = maps[mapIndex]

    if mapIndex == nil then
        return
    else
        Engine.SetDvarString("ui_mapname", mapData.loadName)
        ExitMenu(menu, controller)
    end
end

local function SelectMap_Rotation(menu, controller)

    local maps = nil

    if currentTab == "h2" then
        maps = h2_maps
    elseif currentTab == "iw4" then
        maps = iw4_maps
    elseif currentTab == "h1" then
        maps = h1_maps
    end

    if maps == nil then
        --print ("maps was nil")
        return
    end

    local mapData = maps[controller.idx]
    local mapLoadName = mapData.loadName
    if Lobby.IsMapInRotation(mapLoadName) then
        Lobby.IncludeMapInRotation(mapLoadName, false)
    else
        Lobby.IncludeMapInRotation(mapLoadName, true)
    end
    Engine.ExecNow("xupdatepartystate")
end

local function SelectMap(menu, controller)
    local mapData = nil

    if controller.game == "h2" then
        mapData = h2_maps[controller.idx]
    elseif controller.game == "iw4" then
        mapData = iw4_maps[controller.idx]
    elseif controller.game == "h1" then
        mapData = h1_maps[controller.idx]
    end

    local mapLoadName = mapData.loadName

    if mapLoadName == "bonus_map" then
        local dlcMapCount = Lobby.GetDLCMapCount()
        local popupData = {
            popup_title = Engine.Localize("@MENU_NOTICE"),
            message_text = nil,
            yes_action = nil
        }

        if dlcMapCount > 0 then
            Engine.SetDvarBool("ui_showDLCMaps", true)
            menu:dispatchEventToRoot({
                name = "refresh_maps_new"
            })
        elseif LUI.MenuTemplate.CanShowStore() then
            if Engine.GetOnlineGame() then
                popupData.message_text = Engine.Localize("@LUA_MENU_NO_BONUS_MAPS")
                popupData.yes_action = NoBonusMapsAction
                LUI.FlowManager.RequestAddMenu(menu, "generic_yesno_popup", true, controller, false, popupData)
            else
                popupData.message_text = Engine.Localize("@LUA_MENU_NO_BONUS_MAPS_OFFLINE")
                LUI.FlowManager.RequestAddMenu(menu, "generic_confirmation_popup", true, controller, false, popupData)
            end
        elseif Engine.IsPS4() then
            Store.ShowEmptyStoreDialog(controller)
        else
            popupData.message_text = Engine.Localize("@LUA_MENU_STORE_RESTRICTED")
            LUI.FlowManager.RequestAddMenu(menu, "generic_confirmation_popup", true, controller, false, popupData)
        end
    elseif mapLoadName == "more_maps" then
        GetMoreMaps(menu, controller)
    elseif menu.properties.rotationAllowed and MatchRules.IsUsingCustomMapRotation() then
        SelectMap_Rotation(menu, controller)
    else
        SelectMap_Single(menu, controller)
    end
end

-- -------------------------------------------------------------------------- --
--                                  Updating                                  --
-- -------------------------------------------------------------------------- --

local function UpdateLists(menu, controller)
    local menuScopedData = LUI.FlowManager.GetMenuScopedDataFromElement(menu) or {}
    local isRotationAllowed = menuScopedData.rotationAllowed and MatchRules.IsUsingCustomMapRotation() or false

    menu:processEvent({
        name = "show_checkbox",
        showBox = isRotationAllowed,
        dispatchChildren = true
    })
end

local function UpdateMap(menu, controller)

    local maps = nil

    if currentTab == "h2" then
        maps = h2_maps
    elseif currentTab == "iw4" then
        maps = iw4_maps
    elseif currentTab == "h1" then
        maps = h1_maps
    end

    if maps == nil then
        --print ("maps was nil")
        return
    end

    local mapNameText = menu:getFirstDescendentById("mapsetup_mapname")    
    local mapDescText = menu:getFirstDescendentById("mapsetup_mapdesc")
    local mapGameText = menu:getFirstDescendentById("mapsetup_mapgame")
    local mapImage = menu:getFirstDescendentById("mapsetup_mapimage")
    local detailsWindow = menu:getFirstDescendentById("mapsetup_details_window")
    local missingWindow = menu:getFirstDescendentById("mapsetup_missing_window")
    local mapIndex = controller.idx
    local mapData = maps[controller.idx]
    local mapDesc = mapData.description
    local mapName = Engine.Localize(mapData.name)
    local mapGame = mapData.game

    if mapNameText then
        mapNameText:setText(Engine.ToUpperCase(mapName))
    end

    if mapDescText then
        mapDescText:setText(Engine.Localize(mapDesc))
    end

    if mapGameText then
        mapGameText:setText(Engine.Localize(mapGame))
    end

    menu:processEvent({
        name = "adjust_desc_text",
        dispatchChildren = true,
        descText = mapDesc
    })

    if mapImage then
        local mapLoadName = mapData.loadName
        if mapLoadName == "bonus_map" or mapLoadName == "more_maps" then
            mapImage:setImage(RegisterMaterial("loadscreen_mp_bonusmaps"))
        else
            mapImage:setImage(RegisterMaterial(mapData.image))
            PersistentBackground.ChangeBackground(mapData.image)
        end
    end

    local chosenIcon = nil
    local uiMapName = Engine.GetDvarString("ui_mapname")
    if uiMapName then
        chosenIcon = Game.GetMapDisplayName(uiMapName)
    end

    local chosenIconImage = detailsWindow:getChildById("chosenIcon")
    if chosenIcon == mapName and chosenIconImage == nil then
        local equippedIconMaterial = RegisterMaterial("h1_ui_menu_icon_equipped")
        local iconSize = 16
        local iconTopOffset = 28
        local iconRightOffset = 7

        local chosenIconImage = LUI.UIImage.new({
            leftAnchor = false,
            topAnchor = true,
            rightAnchor = true,
            bottomAnchor = false,
            width = iconSize,
            height = iconSize,
            top = iconTopOffset + iconRightOffset,
            right = -(iconRightOffset - 1),
            material = equippedIconMaterial
        })

        chosenIconImage.id = "chosenIcon"
        detailsWindow:addElement(chosenIconImage)
    elseif chosenIcon ~= mapName and chosenIconImage ~= nil then
        detailsWindow:removeElement(chosenIconImage)
        chosenIconImage = nil
    end

    detailsWindow:show()

    if not Engine.ControllerHasMap(menu.m_ownerController, Lobby.GetMapLoadNameByIndex(mapIndex)) then
        missingWindow:show()
    else
        missingWindow:hide()
    end
end

local function MapSetupCreate(menu, controller)
    local menuScopedData = LUI.FlowManager.GetMenuScopedDataFromElement(menu) or {}
    menuScopedData.rotationAllowed = menu.properties.rotationAllowed
    local backButtonEvent = LUI.ButtonHelperText.CommonEvents.addBackButton
    backButtonEvent.immediate = true
    menu:dispatchEventToRoot(backButtonEvent)
    menu:dispatchEventToRoot({
        name = "update_lists_new",
        immediate = true
    })
    UpdateMapRotation(menu, controller)
end

LUI.MapSetup.new = function ( menu, controller )

    local mapSetupRoot = LUI.UIElement.new(CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    mapSetupRoot.id = "mapsetup_root"
    mapSetupRoot:registerEventHandler("menu_create", MapSetupCreate)
    mapSetupRoot:registerEventHandler("update_map_new", UpdateMap)
    mapSetupRoot:registerEventHandler("update_lists_new", UpdateLists)
    mapSetupRoot:registerEventHandler("select_map_new", SelectMap)
    mapSetupRoot:registerEventHandler("refresh_maps_new", RefreshMapList)
	local menuTemplate = LUI.MenuTemplate.new( menu, {
		menu_title = "@LUA_MENU_MAP_SELECT_CAPS",
		uppercase_title = true,
		disableDeco = true,
		do_not_add_friends_helper = true,
		showSelectButton = false,
        menu_top_indent = 22,
        menu_height = 20
	} )

	menuTemplate:setClass( LUI.MapSetup )
    menuTemplate:SetBreadCrumb(Engine.ToUpperCase(Engine.Localize("@LUA_MENU_GAME_SETUP_CAPS")))

    local mapSetupBindButton = LUI.UIBindButton.new()
    mapSetupBindButton.properties = {
        rotationAllowed = true
    }
    mapSetupBindButton.id = mapSetupBindButton.id .. "mapsetup_bindbuttons"
    mapSetupBindButton:registerEventHandler("button_secondary", BackButtonFunc)
    MatchRules.SetUsingCustomMapRotation(false)

	menuTemplate:AddTabs()

    menuTemplate:addElement(mapSetupBindButton)
    AddDetailsWindow(menuTemplate)
    menuTemplate:AddMissingMapWindow()
    mapSetupRoot:addElement(menuTemplate)
    
    return mapSetupRoot
end

LUI.MenuBuilder.m_types_build["mapsetup_menu_main"] = LUI.MapSetup.new