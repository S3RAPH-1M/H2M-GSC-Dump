local maps = require("data.h2_maps")

LUI.H2Maps = InheritFrom( LUI.UIElement )

LUI.H2Maps.Buttons = {}

LUI.H2Maps.MapFeeder = function (menu, menu2)
	LUI.H2Maps.Buttons = {}
    local excludedMaps = {
		mp_virtual_lobb = true,
		mp_vlobby_refra = true,
		mp_vlobby_laser = true,
		mp_vlobby_room = true
	}
	local mapCount = #maps

	local menuScopedData = LUI.FlowManager.GetMenuScopedDataByMenuName("mapsetup_menu_main") or {}

	for mapIndex = 1, mapCount do
        local mapData = maps[mapIndex]
		local mapLoadName = mapData.loadName

		if not excludedMaps[mapLoadName] then
			local supportsAliens = true
			if Lobby.GetMapSupportsAliensByIdx then
				if Engine.IsAliensMode() and Lobby.GetMapSupportsAliensByIdx(mapIndex) then
					supportsAliens = true
				elseif not Engine.IsAliensMode() and not Lobby.GetMapSupportsAliensByIdx(mapIndex) then
					supportsAliens = true
				end
			else
				supportsAliens = true
			end

			if supportsAliens then
				local selectMapEvent = MBh.EmitEventToRoot({
					name = "select_map_new",
					idx = mapIndex,
                    game = "h2"
				})
				local updateMapEvent = MBh.EmitEventToRoot({
					name = "update_map_new",
					idx = mapIndex,
                    game = "h2"
				})
				local isSelectedMap = mapLoadName == Engine.GetDvarString("ui_mapname")

				if mapLoadName == "bonus_map" or mapLoadName == "more_maps" then
					if Engine.StreamingIsFullyInstalled() then
						local button = menu:AddButton(GetButtonMapName(mapIndex), selectMapEvent, nil, nil, nil, {
							button_text = GetButtonMapName(mapIndex),
							button_over_func = updateMapEvent
						})
						button:registerEventHandler("element_refresh", function(element, event)
							element:setText(GetButtonMapName(element.properties.button_map_index))
						end)
					end
				end

				local buttonData = {
					button_text = Engine.Localize(mapData.name),
					variant = GenericButtonSettings.Variants.FlatButton,
					content_margin = 0,
					content_width = 60,
					button_over_func = updateMapEvent
				}

				if isSelectedMap then
					buttonData.text_default_color = Colors.mw1_green
				end

				local mapNotInstalled = not Engine.ControllerHasMap( 0, mapLoadName)
                local disableButtonOver = nil

				if mapNotInstalled then
					selectMapEvent = NoBonusMapsAction
					buttonData.customIcon = {
						material = "h1_ui_download_arrow",
						initVisible = true,
						size = 14
					}

					local onlineGame = Engine.GetOnlineGame()
					if not onlineGame then
						onlineGame = Engine.GetDvarBool("ui_onlineRequired")
					end
					local disableButtonOver = not onlineGame

					if disableButtonOver then
						buttonData.button_over_disable_func = updateMapEvent
					end
				end

				local mapButton = menu2:AddButton(Engine.Localize(mapData.name), selectMapEvent, disableButtonOver, nil, nil, buttonData)
				mapButton.listDefaultFocus = isSelectedMap
				mapButton:registerEventHandler("element_refresh", function(element, event)
					element:setText(Engine.Localize(mapData.name))
				end)
				LUI.H2Maps.Buttons[#LUI.H2Maps.Buttons + 1] = mapButton
			end
		end
	end
end

LUI.H2Maps.GetTabLabel = function ()
	return "Modern Warfare 2 Campaign Remastered"
end

LUI.H2Maps.GetTabReferrer = function ()
	return "h2"
end

LUI.H2Maps.new = function ( menu, controller )
    f96_local7 = CoD.CreateState( nil, 80, nil, nil, CoD.AnchorTypes.TopLeft )
	f96_local7.alpha = 0
	local H2MapsRoot = LUI.UIElement.new( f96_local7 )
	H2MapsRoot.id = "H2MapsRoot"
	H2MapsRoot.height = 100
	H2MapsRoot:setClass( LUI.H2Maps )
	
	H2MapsRoot:registerAnimationState( "disabled", {
		alpha = 0
	} )
	H2MapsRoot:registerAnimationState( "enabled", {
		alpha = 1
	} )
	H2MapsRoot:animateToState( "enabled", 1000 )
	
	return H2MapsRoot
end

LUI.MenuBuilder.registerType( "h2_tab", LUI.H2Maps.new )