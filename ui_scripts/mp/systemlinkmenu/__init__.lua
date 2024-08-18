if not Engine.InFrontend() then
    return
end

LUI.MPLobbySystemLinkStaging = InheritFrom(LUI.MPLobbyBase)

function OnCreateGame(f2_arg0, f2_arg1)
    local canSaveOfflineProfile = Engine.OfflineProfileCanSave(f2_arg1.controller)
    if Lobby.UsingSystemLinkParty() then
        Engine.ExecNow("xstartlobby", Engine.GetFirstActiveController())
    end
    if canSaveOfflineProfile then
        LUI.FlowManager.RequestAddMenu(f2_arg0, "menu_gamesetup_systemlink", false, f2_arg1.controller, false, {})
    else
        LUI.FlowManager.RequestAddMenu(f2_arg0, "savegame_error_systemlink", true, f2_arg1.controller, false, {
            nextmenu = "menu_gamesetup_systemlink"
        })
    end
end

function OnBack(f3_arg0, f3_arg1)
    if Engine.IsCoreMode() and not Engine.GetDvarBool("virtualLobbyReady") and Engine.GetDvarBool("virtualLobbyEnabled") then
        return
    else
        clearMatchData()
        Engine.SetSystemLink(false)
        Engine.SetSplitScreen(false)
        Engine.Exec("forcesplitscreencontrol systemLinkExit")
        LUI.FlowManager.RequestLeaveMenu(f3_arg0)
        local f3_local0 = Engine.GetFirstActiveController()
        Engine.ExecNow("xstopprivateparty", f3_local0)
        Cac.NotifyVirtualLobby("leave_lobby", Engine.GetXUIDByController(f3_local0))
        Engine.ExecNow("clearcontrollermap")
    end
end

function menu_systemlink(menu, args)

    local mainElement = LUI.MPLobbyBase.new(menu, {
        menu_title = "@PLATFORM_SYSTEM_LINK_TITLE",
        memberListState = Lobby.MemberListStates.Prelobby
    })

    mainElement:setClass(LUI.MPLobbySystemLinkStaging)

    local controller = args.exclusiveController
    if not controller then
        controller = Engine.GetFirstActiveController()
    end
    Cac.SetSelectedControllerIndex(controller)

    mainElement:AddButton("@MENU_CREATE_GAME", OnCreateGame)
    if Engine.IsCoreMode() then
        LUI.MPLobbyBase.AddCACButton(mainElement, true)
        -- mainElement:AddPersonalizationButton()
    end
    mainElement:AddOptionsButton(true)
    LUI.MPLobbyBase.AddLobbyBackButton(mainElement, OnBack)
    Engine.SetDvarBool("xblive_privatematch", true)
    Engine.Exec("xstartlocalprivateparty")
    mainElement.isSignInMenu = true
    mainElement:addElement(LUI.LANWarningWidget.new())
    return mainElement
end

LUI.MenuBuilder.m_types_build["menu_systemlink"] = menu_systemlink

require("gamesetup")
