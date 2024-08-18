if not Engine.InFrontend() then
    return
end

local key_event_callback = function(f1_arg0, f1_arg1)
    -- later set this in client
    Engine.Exec("set startup_video_played 1")
    LUI.FlowManager.RequestAddMenu(f1_arg0, "mp_main_menu", false, f1_arg1.controller, true)
end

local cinematic_update_callback = function(f2_arg0, f2_arg1)
    if Engine.IsVideoFinished() then
        key_event_callback(f2_arg0, f2_arg1)
    end
end

LUI.MenuBuilder.m_types_build["main_attract"] = function()
    local element = LUI.UIElement.new({
        leftAnchor = true,
        rightAnchor = false,
        topAnchor = true,
        bottomAnchor = false,
        top = 0,
        bottom = 720,
        left = 0,
        right = 1280,
        alpha = 1
    })
    local startup_video = "h2m_startup"
    PersistentBackground.ChangeBackground(nil, startup_video, false)
    local button = LUI.UIBindButton.new()
    button.id = "AttractBindButton"
    button.handlePrimary = true
    button:registerAnyKeyEventHandler(key_event_callback)
    element:addElement(button)
    local timer = LUI.UITimer.new(300, "cinematic_update", nil, false)
    timer.id = "cinematic_update_timer"
    element:addElement(timer)
    element:registerEventHandler("cinematic_update", cinematic_update_callback)
    if Engine.IsPC() then
        element:setHandleMouseButton(true)
        element:registerEventHandler("leftmousedown", key_event_callback)
        element:registerEventHandler("rightmousedown", key_event_callback)
    end

    -- hide cursor
    local f2_local1 = Engine.GetLuiRoot()
    local f2_local2 = f2_local1:getChildById("mouse_cursor")
    if f2_local2 then
        f2_local2:hide()
    end

    return element
end