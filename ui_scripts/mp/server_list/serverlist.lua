local Lobby = luiglobals.Lobby
local SystemLinkJoinMenu = LUI.mp_menus.SystemLinkJoinMenu

local SortTypes = {
    Hostname = 1,
    Map = 2,
    Mode = 3,
    Players = 4,
    Ping = 5,
    Verified = 6
}

local CurrentSortType = SortTypes.Players

if (not SystemLinkJoinMenu) then
    return
end

local columns = {{
    offset = 40 + 25,
    text = "@MENU_HOST_NAME",
    dataindex = 0
}, {
    offset = 615,
    text = "@MENU_MAP",
    dataindex = 1
}, {
    offset = 790,
    text = "@MPUI_MODE",
    dataindex = 3
}, {
    offset = 980,
    text = "@MENU_PLAYERS",
    dataindex = 2
}, {
    offset = 1100,
    text = "@MENU_PING",
    dataindex = 4
},
{
    offset = 30,
    customelement = function(value, offset)
        return LUI.UIImage.new({
            leftAnchor = true,
            height = 25,
            width = 25,
            left = offset,
            material = RegisterMaterial("vr"),
            alpha = value == "1" and 1 or 0,
            color = {
                r = 1,
                b = 1,
                g = 1
            }
        })
    end,
    dataindex = 7
},
{
    offset = 10,
    image = "s1_icon_locked",
    customelement = function(value, offset)
        return LUI.UIImage.new({
            leftAnchor = true,
            topAnchor = true,
            height = 20,
            width = 20,
            left = offset,
            top = 2,
            material = RegisterMaterial(CoD.Material.RestrictedIcon),
            alpha = value == "1" and 1 or 0,
            color = {
                r = 1,
                b = 1,
                g = 1
            }
        })
    end,
    dataindex = 5
}}

function textlength(text, font, height)
    local _, _, width = luiglobals.GetTextDimensions(text, font, height)
    return width
end

function trimtext(text, font, height, maxwidth)
    if (maxwidth < 0) then
        return text
    end

    while (textlength(text, font, height) > maxwidth) do
        text = text:sub(1, #text - 1)
    end

    return text
end

SystemLinkJoinMenu.AddHeaderButton = function(menu, f12_arg1, width)
    local state = CoD.CreateState(0, f12_arg1, nil, nil, CoD.AnchorTypes.TopLeft)
    state.width = width
    local element = LUI.UIElement.new(state)
    local button = SystemLinkJoinMenu.CreateButton("header", 24)

    button:addElement(LUI.Divider.new(CoD.CreateState(nil, 0, nil, nil, CoD.AnchorTypes.TopLeftRight), 40,
        LUI.Divider.Grey))
    button:makeNotFocusable()
    button:addElement(LUI.Divider.new(CoD.CreateState(nil, 0, nil, nil, CoD.AnchorTypes.BottomLeftRight), 40,
        LUI.Divider.Grey))

    button.m_eventHandlers = {}

    for i = 1, #columns do
        if (columns[i].text) then
            SystemLinkJoinMenu.MakeText(button.textHolder, columns[i].offset, Engine.Localize(columns[i].text), nil)
        elseif (columns[i].image) then
            local image = LUI.UIImage.new({
                leftAnchor = true,
                topAnchor = true,
                height = 20,
                width = 20,
                top = 2,
                left = columns[i].offset,
                material = RegisterMaterial(columns[i].image)
            })
            button.textHolder:addElement(image)
        end
    end

    element:addElement(button)
    menu:addElement(element)
end

AddFavourite = function ( index )
    serverlist:addfavourite(""..index)
end

DeleteFavourite = function ( index )
    serverlist:deletefavourite(""..index)
end

toggleNetSource = function ()
    local ui_netsource = Engine.GetDvarInt("ui_netsource")

    local netsource_value = 0;

    if ui_netsource == 2 then
        netsource_value = 1
    else
        netsource_value = 2
    end

    Engine.SetDvarInt("ui_netsource", netsource_value)
end

local currentServerIndex = -1

SetCurrentServer = function (menu, args)
    currentServerIndex = menu.index
end

SystemLinkJoinMenu.AddServerButton = function(menu, controller, index)
    local button = SystemLinkJoinMenu.CreateButton(index or "header", 24)
    button:makeFocusable()
    button.index = index
    button:addEventHandler("button_action", SystemLinkJoinMenu.OnJoinGame)
    button:addEventHandler("gain_focus", SetCurrentServer)

    local gettext = function(i)
        local text = Lobby.GetServerData(controller, index, columns[i].dataindex)
        if (columns[i].customelement) then
            text = columns[i].customelement(text)
        end

        local islast = not columns[i + 1]
        local end_ = islast and 1130 or columns[i + 1].offset
        local maxlength = end_ - columns[i].offset

        if (maxlength < 0) then
            maxlength = columns[i].offset - end_
        end

        if (not islast) then
            maxlength = maxlength - 50
        end

        return trimtext(text, CoD.TextSettings.TitleFontSmall.Font, 14, maxlength)
    end

    for i = 1, #columns do
        if (columns[i].customelement) then
            local value = Lobby.GetServerData(controller, index, columns[i].dataindex)
            local element = columns[i].customelement(value, columns[i].offset)
            button.textHolder:addElement(element)
        else
            SystemLinkJoinMenu.MakeText(button.textHolder, columns[i].offset, gettext(i),
                luiglobals.Colors.h1.medium_grey)
        end
    end

    menu.list:addElement(button)
    return button
end

SystemLinkJoinMenu.MakeText = function(menu, f5_arg1, text, color)
    local state = CoD.CreateState(f5_arg1, nil, f5_arg1 + 200, nil, CoD.AnchorTypes.Left)
    state.font = CoD.TextSettings.TitleFontSmall.Font
    state.top = -6
    state.height = 14
    state.alignment = nil
    state.glow = LUI.GlowState.None
    state.color = color

    local el = LUI.UIText.new(state)
    el:registerAnimationState("focused", {
        color = luiglobals.Colors.white
    })

    el:registerEventHandler("focused", function(element, event)
        element:animateToState("focused", 0)
    end)

    el:registerEventHandler("unfocused", function(element, event)
        element:animateToState("default", 0)
    end)

    el:setText(text)
    menu:addElement(el)

    return el
end

function get_ui_netsource()
    local ui_netsource = Engine.GetDvarInt("ui_netsource")
    local value = "EXE_INTERNET"
    
    if ui_netsource == 0 then
        value = "EXE_LOCAL"
    end
    
    if ui_netsource == 2 then
        value = "EXE_FAVORITES"
    end
    
    return value
end

function showRelevantButtons(menu)
    local ui_netsource = Engine.GetDvarInt("ui_netsource")

    if ui_netsource == 2 then
        menu:AddHelp({
            name = "add_button_helper_text",
            button_ref = "button_alt2",
            helper_text = Engine.Localize("@MENU_DEL_FAVORITE"),
            side = "right",
            clickable = false,
            priority = -888
        }, function(f21_arg0, f21_arg1)
            DeleteFavourite(currentServerIndex)
            SystemLinkJoinMenu.RefreshServers(f21_arg0, f21_arg1, menu)
        end)
    else
        menu:AddHelp({
            name = "add_button_helper_text",
            button_ref = "button_alt2",
            helper_text = Engine.Localize("@MENU_ADD_TO_FAVORITES"),
            side = "right",
            clickable = false,
            priority = -888
        }, function(f21_arg0, f21_arg1)
            AddFavourite(currentServerIndex)
        end)
    end
end

local function get_text_for_sort(sort)
    if sort > SortTypes.Verified or sort == SortTypes.Hostname then
        return Engine.Localize("@MENU_HOST_NAME")
    elseif sort == SortTypes.Map then
        return Engine.Localize("@MENU_MAP")
    elseif sort == SortTypes.Mode then
        return Engine.Localize("@MPUI_MODE")
    elseif sort == SortTypes.Ping then
        return Engine.Localize("@MENU_PING")
    elseif sort == SortTypes.Verified then
        return Engine.Localize("Verified")
    end

    return Engine.Localize("@MENU_PLAYERS")
end

function sort_server_helper(menu)
    local ref = Engine.IsGamepadEnabled() and "button_l3" or "button_page_up"

    menu:AddHelp({
        name = "sort_servers_helper_text",
        button_ref = ref,
        helper_text = "Sort by " .. get_text_for_sort(CurrentSortType + 1),
        side = "right",
        clickable = true,
        priority = -1000
    }, function(f21_arg0, f21_arg1)
        CurrentSortType = CurrentSortType + 1
        if CurrentSortType > SortTypes.Verified then
            CurrentSortType = SortTypes.Hostname
        end
        serverlist:sortservers(tonumber(CurrentSortType) - 1)
        SystemLinkJoinMenu.RefreshServers(f21_arg0, f21_arg1, menu)
        sort_server_helper(menu)
    end)
end

local function menu_systemlink_join(f19_arg0, f19_arg1)
    local width = 1145

    local menu = LUI.MenuTemplate.new(f19_arg0, {
        menu_title = "@MENU_SERVER_BROWSER_CAPS",
        menu_width = width,
        menu_top_indent = 20,
        disableDeco = true,
        spacing = 1,
        do_not_add_friends_helper = true
    })

    SystemLinkJoinMenu.AddHeaderButton(menu, 80, width)
    SystemLinkJoinMenu.AddLowerCounter(menu, width)
    SystemLinkJoinMenu.UpdateCounterText(menu, nil)
    Lobby.BuildServerList(Engine.GetFirstActiveController())

    local bottom_text_y = 58

    local current_sort = LUI.UIText.new({
        rightAnchor = true,
        topAnchor = true,
        height = 18,
        bottom = bottom_text_y,
        font = CoD.TextSettings.H1TitleFont.Font,
        width = 300,
        alignment = LUI.Alignment.Right
    })
    current_sort:setText("Sorting by " .. get_text_for_sort(CurrentSortType))
    menu:addElement(current_sort)

    local ui_netsource = LUI.UIText.new({
        rightAnchor = true,
        topAnchor = true,
        height = 18,
        bottom = bottom_text_y - 17,
        font = CoD.TextSettings.H1TitleFont.Font,
        width = 300,
        alignment = LUI.Alignment.Right
    })
    ui_netsource:setText("Source: " .. Engine.Localize(get_ui_netsource()))
    menu:addElement(ui_netsource)

    local servercount = LUI.UIText.new({
        rightAnchor = true,
        topAnchor = true,
        height = 18,
        bottom = bottom_text_y - 34,
        font = CoD.TextSettings.H1TitleFont.Font,
        width = 300,
        alignment = LUI.Alignment.Right
    })
    menu:addElement(servercount)

    local playercount = LUI.UIText.new({
        rightAnchor = true,
        topAnchor = true,
        height = 18,
        bottom = bottom_text_y - 51,
        font = CoD.TextSettings.H1TitleFont.Font,
        width = 300,
        alignment = LUI.Alignment.Right
    })
    menu:addElement(playercount)
    
    local monitor_timer = LUI.UITimer.new(100, "monitor_server_browser_text")
    menu:addElement(monitor_timer)
    menu:registerEventHandler("monitor_server_browser_text", function()
        ui_netsource:setText("Source: " .. Engine.Localize(get_ui_netsource()))
        current_sort:setText("Sorting by " .. get_text_for_sort(CurrentSortType))
    end)

    playercount:setText(Engine.Localize("@SERVERLIST_PLAYER_COUNT", 0))
    servercount:setText(Engine.Localize("@SERVERLIST_SERVER_COUNT", 0))

    menu.list:registerEventHandler(LUI.UIScrollIndicator.UpdateEvent, function(element, event)
        SystemLinkJoinMenu.UpdateCounterText(menu, event)

        playercount:setText(Engine.Localize("@SERVERLIST_PLAYER_COUNT", serverlist:getplayercount()))
        servercount:setText(Engine.Localize("@SERVERLIST_SERVER_COUNT", serverlist:getservercount()))
        ui_netsource:setText("Source: " .. Engine.Localize(get_ui_netsource()))
    end)

    serverlist:sortservers(tonumber(CurrentSortType) - 1)
    SystemLinkJoinMenu.UpdateGameList(menu)
    menu:registerEventHandler("updateGameList", SystemLinkJoinMenu.UpdateGameList)

    LUI.ButtonHelperText.ClearHelperTextObjects(menu.help, {
        side = "all"
    })

    showRelevantButtons(menu);

    menu:AddHelp({
        name = "add_button_helper_text",
        button_ref = "button_alt1",
        helper_text = Engine.Localize("@MENU_SB_TOOLTIP_BTN_REFRESH"),
        side = "right",
        clickable = true,
        priority = -1000
    }, function(f21_arg0, f21_arg1)
        SystemLinkJoinMenu.RefreshServers(f21_arg0, f21_arg1, menu)
        showRelevantButtons(menu);
    end)

    local filters_servers_cb = function(f21_arg0, f21_arg1)
        toggleNetSource();
        SystemLinkJoinMenu.RefreshServers(f21_arg0, f21_arg1, menu)
        showRelevantButtons(menu);
    end
    if Engine.IsGamepadEnabled() then
        menu:AddHelp({
            name = "add_button_helper_text",
            button_ref = "button_r3",
            helper_text = Engine.Localize("@MENU_FILTER_SERVERS"),
            side = "right",
            clickable = true,
            priority = -1000
        }, filters_servers_cb)
    else
        menu:AddHelp({
            name = "add_button_helper_text",
            button_ref = "button_page_down",
            helper_text = Engine.Localize("@MENU_FILTER_SERVERS"),
            side = "right",
            clickable = true,
            priority = -1000
        }, filters_servers_cb)
    end

    sort_server_helper(menu)

    menu:AddHelp({
        name = "add_button_helper_text",
        button_ref = "button_action",
        helper_text = Engine.Localize("@MENU_JOIN_GAME1"),
        side = "left",
        clickable = false,
        priority = -1000
    }, nil, nil, true)

    menu:AddBackButton()

    Lobby.RefreshServerList(Engine.GetFirstActiveController())

    return menu
end

LUI.MenuBuilder.m_types_build["menu_systemlink_join"] = menu_systemlink_join
