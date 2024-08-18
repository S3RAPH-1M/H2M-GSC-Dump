function OnSystemLinkNetwork(buttonContainer, buttonEvent)
    buttonContainer:processEvent({
        name = "button_action",
        controller = buttonEvent.controller,
        noRefocus = true
    })
end

function ProcessGavelMessages(buttonContainer, buttonEvent)
    buttonContainer:processEvent({
        name = "button_action",
        controller = buttonEvent.controller,
        noRefocus = true
    })
end

function OnOnlineDataFetched(buttonContainer, buttonEvent)
    local useOnlineStats = Engine.GetDvarBool("useonlinestats")
    Engine.SetDvarBool("useonlinestats", true)
    CheckGavelMessages(buttonEvent.controller)
    Engine.SetDvarBool("useonlinestats", useOnlineStats)
    buttonContainer:processEvent({
        name = "button_action",
        controller = buttonEvent.controller,
        noRefocus = true
    })
end

function ClearWaitingForOtherType(networkType)
    if GetWaitingForNetworkType() ~= networkType then
        SetWaitingForNetworkType(WaitingForNetworkType.None)
    end
end

function ResolveSignInRefusal(controller)
    if not Engine.IsProfileSignedIn(controller) then
        LUI.FlowManager.RequestAddMenu(nil, "no_profile_force_popmenu", false, controller, false, {})
    end
end

function OnPlayButton(menu, event)
    ClearWaitingForOtherType(WaitingForNetworkType.Online)
    Engine.ExecNow("forcenosplitscreencontrol main_XBOXLIVE_1", event.controller)
    if DCache.IsStartupDisabled() then
        LUI.FlowManager.RequestAddMenu(nil, "generic_yesno_popup", true, event.controller, nil, {
            popup_title = Engine.Localize("@MENU_NOTICE"),
            yes_action = function()
                DCache.ClearDCache(1)
                Engine.SystemRestart(Engine.Localize("@LUA_MENU_DCACHE_RESTART"))
            end,
            no_action = function()
                DCache.ClearStartupCount()
                Engine.SystemRestart(Engine.Localize("@LUA_MENU_DCACHE_RESTART"))
            end,
            message_text = Engine.Localize("@LUA_MENU_DCACHE_CLEAR_REQUEST"),
            yes_text = Engine.Localize("@LUA_MENU_YES"),
            no_text = Engine.Localize("@LUA_MENU_NO")
        })
        return
    end
    local canAccessMPMenu, failureCode = Engine.UserCanAccessMPLiveMenu(event.controller)
    if not canAccessMPMenu then
        if Engine.IsXB3() and failureCode == CoD.PlayOnlineFailure.OPFR_XBOXLIVE_MPNOTALLOWED then
            canAccessMPMenu = Engine.ShowXB3GoldUpsell(event.controller)
        elseif Engine.IsPCApp() and failureCode == CoD.PlayOnlineFailure.OPFR_PLATFORM_UPDATE_REQUIRED then
            LUI.FlowManager.RequestAddMenu(menu, "uwp_update_required", true, event.controller)
            return
        end
    end
    if not canAccessMPMenu then
        if Engine.IsPS4() and failureCode == CoD.PlayOnlineFailure.OPFR_XBOXLIVE_SIGNEDOUTOFLIVE then
            Engine.ExecWithResolve("xrequirelivesignin", ResolveSignInRefusal, event.controller)
        elseif Engine.IsPS4() and failureCode == CoD.PlayOnlineFailure.OPFR_XBOXLIVE_MPNOTALLOWED then
            Engine.ExecWithResolve("xrequirelivesignin", ResolveSignInRefusal, event.controller)
        else
            Engine.Exec("xrequirelivesignin", event.controller)
            if WaitingForNetworkType.Online ~= GetWaitingForNetworkType() and failureCode ~= CoD.PlayOnlineFailure.OPFR_PLATFORM_PSPLUS_REQUIRED then
                SetWaitingForNetworkType(WaitingForNetworkType.Online, event.controller)
            end
        end
    elseif not Engine.HasAcceptedEULA(event.controller) then
        LUI.FlowManager.RequestAddMenu(nil, "EULA", true, event.controller, false, {
            callback = function()
                OnPlayButton(menu, event)
            end
        })
    elseif CheckCRMBanMessage(menu, event.controller) then
        return
    elseif Lobby.GavelMessagesToShow ~= nil and #Lobby.GavelMessagesToShow > 0 then
        menu:processEvent({
            name = "lose_focus"
        })
        ShowGavelMessage(menu)
    else
        if Engine.UsingStreamingInstall() then
            Engine.ForceUpdateArenas()
        end
        Engine.ExecNow("resetSplitscreenSignIn", event.controller)
        Engine.ExecNow("forcenosplitscreencontrol main_XBOXLIVE_3", event.controller)
        Engine.SetOnlineGame(true)
        Engine.SetSystemLink(false)
        Engine.SetSplitScreen(false)
        Engine.SetDvarBool("xblive_privatematch", false)
        AAR.ClearAAR()
        Engine.SetDvarBool("squad_match", false)
        Engine.ExecNow(MPConfig.default_xboxlive, event.controller)
        Engine.SetDvarInt("party_maxplayers", Engine.IsAliensMode() and 4 or 9)
        Engine.ExecNow("xstartprivateparty", event.controller)
        Engine.Exec("startentitlements", event.controller)
        Engine.ExecNow("upload_playercard", event.controller)
        Cac.SetSelectedControllerIndex(event.controller)
        Engine.CacheUserDataForController(event.controller)
        LUI.FlowManager.RequestAddMenu(menu, "menu_xboxlive", false, event.controller, false, {
            initialController = event.controller
        })
    end
end

function OnSplitscreenButton(menu, event)
    if DCache.IsStartupDisabled() then
        LUI.FlowManager.RequestAddMenu(nil, "generic_yesno_popup", true, controller, nil, {
            popup_title = Engine.Localize("@MENU_NOTICE"),
            yes_action = function()
                DCache.ClearDCache(1)
                Engine.SystemRestart(Engine.Localize("@LUA_MENU_DCACHE_RESTART"))
            end,
            no_action = function()
                DCache.ClearStartupCount()
                Engine.SystemRestart(Engine.Localize("@LUA_MENU_DCACHE_RESTART"))
            end,
            message_text = Engine.Localize("@LUA_MENU_DCACHE_CLEAR_REQUEST"),
            yes_text = Engine.Localize("@LUA_MENU_YES"),
            no_text = Engine.Localize("@LUA_MENU_NO")
        })
        return
    end
    SetWaitingForNetworkType(WaitingForNetworkType.None)
    Engine.Exec("xstopprivateparty")
    Engine.Exec("resetSplitscreenSignIn")
    Engine.Exec("forcesplitscreencontrol main_SPLITSCREEN")
    Engine.SetSystemLink(false)
    Engine.SetSplitScreen(true)
    Engine.SetOnlineGame(false)
    Engine.SetDvarBool("xblive_privatematch", false)
    AAR.ClearAAR()
    Engine.Exec(MPConfig.default_splitscreen)
    Engine.CacheUserDataForController(event.controller)
    if Engine.GetDvarBool("lui_splitscreensignin_menu") then
        LUI.FlowManager.RequestAddMenu(menu, "menu_splitscreensignin", false, event.controller, false)
    else
        assert(not Engine.IsAliensMode(), "Splitscreen sign in UI not supported by .menu.")
        LUI.FlowManager.RequestOldMenu(menu, "menu_splitscreensignin", false)
    end
end

function OnReturnToMainMenu(menu, event)
    LUI.FlowManager.RequestPopupMenu(menu, "main_choose_exe_popup_menu", true, event.controller)
    Engine.Exec("forcenosplitscreencontrol openChooseExe " .. tostring(event.controller))
end

function OnSystemLinkButton(menu, event)
    ClearWaitingForOtherType(WaitingForNetworkType.SystemLink)
    local canAccessSystemLink, failureCode = Engine.UserCanAccessSystemLinkMenu(event.controller)
    if not canAccessSystemLink then
        SetWaitingForNetworkType(WaitingForNetworkType.SystemLink, event.controller)
        LUI.FlowManager.RequestAddMenu(menu, "popup_connecting", false, event.controller, false)
        Engine.Exec("xrequiresignin", event.controller)
        Engine.Exec("forcesplitscreencontrol main_SYSTEMLINK_2", event.controller)
    elseif not Engine.HasAcceptedEULA(event.controller) then
        LUI.FlowManager.RequestAddMenu(nil, "EULA", true, event.controller, false, {
            callback = function()
                OnSystemLinkButton(menu, event)
            end
        })
    else
        if Engine.UsingStreamingInstall() then
            Engine.ForceUpdateArenas()
        end
        LUI.FlowManager.RequestLeaveMenuByName("popup_connecting", nil)
        Engine.ExecNow("resetSplitscreenSignIn", event.controller)
        Engine.Exec("forcenosplitscreencontrol main_SYSTEMLINK_3", event.controller)
        Engine.SetSystemLink(true)
        Engine.SetSplitScreen(false)
        Engine.Exec("clearcontrollermap")
        Engine.SetOnlineGame(false)
        AAR.ClearAAR()
        if Lobby.UsingSystemLinkParty() then
            Engine.SetDvarBool("xblive_privatematch", true)
        else
            Engine.SetDvarBool("xblive_privatematch", false)
        end
        Engine.SetDvarBool("ui_opensummary", false)
        Engine.Exec(MPConfig.default_systemlink, event.controller)
        Engine.MakeLocalClientActive(event.controller)
        Engine.CacheUserDataForController(event.controller)
        Cac.SetSelectedControllerIndex(event.controller)
        if Engine.GetDvarBool("lui_systemlink_menu") then
            LUI.FlowManager.RequestAddMenu(menu, "menu_systemlink", false, event.controller, false)
        else
            assert(not Engine.IsAliensMode(), "SystemLink UI not supported by .menu.")
            LUI.FlowManager.RequestOldMenu(menu, "menu_systemlink", false)
        end
    end
end

function AddStreamingInstallWidget(menu)
    if IsStreamingInstall() then
        local streamingInstallWidget = LUI.StreamingInstallWidget.new()
        menu:addElement(streamingInstallWidget)
        menu.streamingInstall = streamingInstallWidget
    end
end

function ResolveCRPClickThroughAction(controller)
    local canAccessMPMenu, failureCode = Engine.UserCanAccessMPLiveMenu(controller)
    if not canAccessMPMenu and failureCode ~= CoD.PlayOnlineFailure.OPFR_PLATFORM_PSPLUS_REQUIRED then
        SetWaitingForNetworkType(WaitingForNetworkType.Online, controller)
        Engine.ExecNow("forcenosplitscreencontrol main_XBOXLIVE_1", controller)
        Engine.ExecWithResolve("xrequirelivesignin", ResolveCRPClickThroughAction, controller)
    else
        local menuData = LUI.FlowManager.GetMenuScopedDataByMenuName("mp_main_menu")
        OnPlayButton(menuData.crpButton, {
            name = "button_action",
            controller = controller
        })
    end
end

function CRPClickThroughAction(menu, event)
    if not IsStreamingInstall() then
        local menuData = LUI.FlowManager.GetMenuScopedDataByMenuName("mp_main_menu")
        ResolveCRPClickThroughAction(menuData.crpController)
    end
end

local function CreateLogoImage(imageContainer)
    local imageProps = CoD.CreateState(nil, nil, 100, 250, CoD.AnchorTypes.TopRight)
    imageProps.material = RegisterMaterial("h2m_mod_logo")
    imageProps.width = 416
    imageProps.height = 234
    --imageContainer:addElement(LUI.UIImage.new(imageProps))
end

LUI.MenuTemplate.AddBuildNumber = function ( f2_arg0 )
	local self = LUI.UIText.new( {
		leftAnchor = true,
		topAnchor = true,
		rightAnchor = false,
		bottomAnchor = false,
        top = 15,
		height = CoD.TextSettings.BodyFontTiny.Height,
		font = CoD.TextSettings.BodyFontTiny.Font,
		width = GenericMenuDims.menu_right_wide - GenericMenuDims.menu_left,
        alpha = 0.2
	} )
	self:setText( Engine.GetBuildNumber() )
	self:addElement( LUI.UITimer.new( 500, "refresh_buildnumber" ) )
	self:registerEventHandler( "refresh_buildnumber", function ( element, event )
		element:setText( Engine.GetBuildNumber() )
	end )
	f2_arg0:addElement( self )
end

function MainMenu(menu, event)
    -- PersistentBackground.FadeFromBlackSlow()
    -- ok this is the worst thing ever but it works
    if (Engine.GetDvarBool("startup_video_played") ~= true) then
	    LUI.FlowManager.RequestAddMenu( nil, "main_attract" )
    end

    local mainMenuTitle = "@MENU_MULTIPLAYER_CAPS"
    local mainMenuBreadcrumb = ""
    local mainMenuUppercaseTitle = nil
    Engine.SetDvarBool("party_playersCoop", false)
    menu = LUI.MenuTemplate.new(menu, {
        menu_top_indent = 0,
        menu_title = mainMenuTitle,
        uppercase_title = mainMenuUppercaseTitle
    })

    menu:AddBuildNumber()

    LUI.MenuTemplate.SetBreadCrumb(menu, mainMenuBreadcrumb)

    local playButton = menu:AddButton("@PLATFORM_PLAY_ONLINE", OnPlayButton, IsStreamingInstall)
    playButton:setDisabledRefreshRate(1000)
    playButton:rename("mp_main_menu_play_online")
    playButton:registerEventHandler("onOnlineDataFetched", OnOnlineDataFetched)
    playButton:registerEventHandler("gavelMessagesProcessed", ProcessGavelMessages)

    -- local systemLinkButton = menu:AddButton("@PLATFORM_SYSTEM_LINK", OnSystemLinkButton)
    -- systemLinkButton:rename("MainMenu_SystemLink")
    -- systemLinkButton:registerEventHandler("onSystemLinkNetwork", OnSystemLinkNetwork)

    menu:AddButton("OPTIONS", function ()
        LUI.FlowManager.RequestAddMenu(nil, "pc_controls", true, event.controller, false)
    end)
    menu:AddButton("QUIT", OnReturnToMainMenu)
    
    PersistentBackground.ChangeBackground(nil, "h2_sp_menus_bg_start_screen")
    if Engine.IsCoreMode() then
        for controller = 0, Engine.GetMaxControllerCount() - 1 do
            if Engine.HasActiveLocalClient(controller) and Engine.GetProfileData("mp_StartCRPLobby", controller) then
                Engine.Exec("profile_ClearStartCRPLobby", controller)
                Engine.Exec("updategamerprofile")
                playButton.listDefaultFocus = true
                local menuData = LUI.FlowManager.GetMenuScopedDataByMenuName("mp_main_menu")
                menuData.crpButton = playButton
                menuData.crpController = controller
                playButton:registerEventHandler("StartCRPLobby", CRPClickThroughAction)
                playButton:dispatchEventToRoot({
                    name = "StartCRPLobby",
                    target = playButton
                })
                break
            end
        end
    end

    menu:AddOptionsButton(false, true)
    if Engine.IsXB3() or Engine.IsPCApp() then
        LUI.ButtonHelperText.AddSignInAndSwitchUserHelp(menu)
    end

    CreateLogoImage(menu)
    menu:AddBackButton(OnReturnToMainMenu)
    AddStreamingInstallWidget(menu)
    Engine.ExecNow("set xblive_competitionmatch 0")
    Lobby.ClearLocalPlayLoadouts()
    menu:registerEventHandler("refresh_button_helper", refreshHelpButtons)
    IsInitialMenuView = false
    if Engine.IsPC() then
        if not Engine.GetDisplayDriverMeetsMinVer() then
            LUI.FlowManager.RequestAddMenu(self, "PCDriverDialog")
        elseif Engine.ShaderUploadFrontendShouldShowDialog() then
            LUI.FlowManager.RequestAddMenu(self, "ShaderCacheDialog")
        end
    end

    return menu
end

LUI.MenuBuilder.m_types_build["mp_main_menu"] = MainMenu

-- need to add this for startup shit
local s1MPMainMenu = LUI.mp_menus.s1MPMainMenu
local function StartMenuMusic()
    if (Engine.GetDvarBool("startup_video_played") ~= true) then
	    return
    end
	Engine.PlayMusic( CoD.Music.MainMPMusicList[math.random( 1, #CoD.Music.MainMPMusicList )] )
end
s1MPMainMenu.StartMenuMusic = StartMenuMusic

LUI.MenuBuilder.m_definitions["main_choose_exe_popup_menu"] = function()
    return {
        type = "generic_yesno_popup",
        id = "main_choose_exe_popup_menu_id",
        properties = {
            popup_title = Engine.Localize("@MENU_NOTICE"),
            message_text = Engine.Localize("@MENU_QUIT_WARNING"),
            yes_action = function()
                Engine.Quit()
            end
        }
    }
end