local function unused_menu(controller)
    local root = LUI.MenuTemplate.new(controller, {
        menu_title = "@MENU_DISABLED_DEFAULT"
    })

    root:AddBackButton()
    return root
end

if Engine.InFrontend() then
    LUI.MenuBuilder.m_types_build["MPDepotOpenLootMenu"] = unused_menu
    LUI.MenuBuilder.m_types_build["MPDepotCollectionsMenu"] = unused_menu
    LUI.MenuBuilder.m_types_build["MPDepotCollectionDetailsMenu"] = unused_menu
    LUI.MenuBuilder.m_types_build["MPDepotArmoryMenu"] = unused_menu
    LUI.MenuBuilder.m_types_build["MPLootDropsBase"] = unused_menu
    LUI.MenuBuilder.m_types_build["PersonalizeCamo"] = unused_menu
    LUI.MenuBuilder.m_types_build["PersonalizeCharacter"] = unused_menu
    VLobby.InitMenuMode( "MPDepotCollectionDetailsMenu", VirtualLobbyModes.LUI_MODE_OBSCURED )
end