local set_minimap_size = function(element)
    -- H1 has more minimap but leftover from S1 so just do this
    element:processEvent({
        name = "contract"
    })
end

local check_is_scrambler_on = function(f4_arg0, f4_arg1)
    assert(f4_arg0)
    if Game.GetOmnvar("ui_uav_scrambler_on") then
        f4_arg0:dispatchEventToChildren({
            name = "hud_scrambled_on",
            dispatchChildren = true
        })
    else
        f4_arg0:dispatchEventToChildren({
            name = "hud_scrambled_off",
            dispatchChildren = true
        })
    end
end

local run_minimap_callbacks = function(element)
    assert(element)
    set_minimap_size(element)
    check_is_scrambler_on(element)
end

local return_hud_state = function(f6_arg0, f6_arg1)
    local f6_local0 = f6_arg1.name
    local f6_local1 = "default"
    if f6_local0 == "hud_nosignal_on" then
        f6_local1 = "nosignal"
    elseif f6_local0 == "hud_scrambled_on" then
        f6_local1 = "scrambled"
    elseif f6_local0 == "hud_nosignal_off" or f6_local0 == "hud_scrambled_off" then
        f6_local1 = "active"
    end
    f6_arg0:animateToState(f6_local1, 0)
end

local minimap_top_offset = -22 -- was 0

LUI.MenuBuilder.m_types_build["minimapHudDef"] = function()
    local mapWidth = 170 -- was 208
    local mapHeight = mapWidth * 0.865
    local f7_local2 = 255
    local f7_local3 = 16
    local f7_local4 = -5

    local self = LUI.UIElement.new({
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        top = f7_local3,
        left = f7_local4,
        width = mapWidth,
        height = mapHeight
    })
    self.id = "minimapHud"
    self:registerAnimationState("extended", {
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        top = f7_local3,
        left = f7_local4,
        width = f7_local2,
        height = mapHeight
    })
    self:registerEventHandler("extend", MBh.AnimateToState("extended", 0))
    self:registerEventHandler("contract", MBh.AnimateToState("default", 0))
    self:registerEventHandler("playerstate_client_changed", run_minimap_callbacks)
    self:registerOmnvarHandler("ui_minimap_extend_grace_period", run_minimap_callbacks)
    self:registerOmnvarHandler("ui_uav_scrambler_on", check_is_scrambler_on)

    local blank_elem = LUI.UIElement.new({})
    blank_elem:setupUIIntWatch("PlayerPerkChanged", Game.GetPerkIndexForName("specialty_moreminimap"))
    blank_elem:registerEventHandler("int_watch_alert", function(element, event)
        set_minimap_size(element:getParent())
    end)
    self:addElement(blank_elem)

    local minimap_wrapper = LUI.UIElement.new(CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    minimap_wrapper.id = "minimapWrapper_id"
    self:addElement(minimap_wrapper)

    local f7_local8 = CoD.CreateState(0, minimap_top_offset, 0, 0, CoD.AnchorTypes.All)
    f7_local8.material = RegisterMaterial("h1_hud_minimap_backing")
    self:addElement(LUI.UIImage.new(f7_local8))

    local f7_local9 = CoD.CreateState(nil, nil, nil, 5, CoD.AnchorTypes.BottomLeftRight)
    f7_local9.color = Colors.black

    --[[
    local f7_local10 = LUI.Divider.new(f7_local9, 5, 2)
    f7_local10.id = "lower_divider"
    self:addElement(f7_local10)
    ]] --

    local hud_shake_sequence = {}
    local f7_local17 = {"active", 0}
    local f7_local18 = {}
    local f7_local19 = "default"
    local f7_local20 = math.random(10, 50)
    f7_local18 = f7_local19
    f7_local19 = {}
    f7_local20 = "active"
    local f7_local21 = math.random(10, 50)
    f7_local19 = f7_local20
    f7_local20 = {}
    f7_local21 = "default"
    local f7_local22 = math.random(10, 50)
    f7_local20 = f7_local21
    f7_local21 = {}
    f7_local22 = "active"
    local f7_local23 = math.random(10, 50)
    f7_local21 = f7_local22
    f7_local22 = {}
    f7_local23 = "default"
    local f7_local24 = math.random(10, 50)
    f7_local22 = f7_local23
    f7_local23 = {}
    f7_local24 = "active"
    local f7_local25 = math.random(10, 50)
    f7_local23 = f7_local24
    f7_local24 = {}
    f7_local25 = "default"
    local f7_local26 = math.random(50, 100)
    f7_local24 = f7_local25
    f7_local25 = {"active", 250}

    hud_shake_sequence[1] = f7_local17
    hud_shake_sequence[2] = f7_local18
    hud_shake_sequence[3] = f7_local19
    hud_shake_sequence[4] = f7_local20
    hud_shake_sequence[5] = f7_local21
    hud_shake_sequence[6] = f7_local22
    hud_shake_sequence[7] = f7_local23
    hud_shake_sequence[8] = f7_local24
    hud_shake_sequence[9] = f7_local25

    local minimap_hud_handlers = {}
    minimap_hud_handlers.hud_shake = MBh.AnimateSequence(hud_shake_sequence)
    minimap_hud_handlers.hud_nosignal_on = return_hud_state
    minimap_hud_handlers.hud_nosignal_off = return_hud_state
    minimap_hud_handlers.hud_scrambled_on = return_hud_state
    minimap_hud_handlers.hud_scrambled_off = return_hud_state

    local minimap = {
        type = "UIMinimap",
        id = "minimap",
        states = {
            default = {
                topAnchor = true,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = true,
                top = minimap_top_offset,
                bottom = 0,
                left = 0,
                right = 0,
                alpha = 0
            },
            active = {
                alpha = 0.5
            },
            nosignal = {
                alpha = 0.05
            },
            scrambled = {
                alpha = 0.15
            }
        }
    }
    minimap.handlers = minimap_hud_handlers

    LUI.MenuBuilder.BuildAddChild(self, minimap)

    LUI.MenuBuilder.BuildAddChild(self, {
        type = "UIMinimapIcons",
        id = "minimapIcons",
        properties = {
            drawPlayer = true
        },
        states = {
            default = {
                topAnchor = true,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = true,
                top = minimap_top_offset,
                bottom = 0,
                left = 0,
                right = 0,
                alpha = 0,
            },
            active = {
                alpha = 1
            },
            nosignal = {
                alpha = 0.05
            },
            scrambled = {
                alpha = 0
            }
        },
        handlers = {
            hud_nosignal_on = return_hud_state,
            hud_nosignal_off = return_hud_state,
            hud_scrambled_on = return_hud_state,
            hud_scrambled_off = return_hud_state
        }
    })

    --[[
    f7_local11 = CoD.CreateState(0, -22, 0, nil, CoD.AnchorTypes.TopLeftRight)
    f7_local11.height = 20
    f7_local11.material = RegisterMaterial("black")
    f7_local11.alpha = 0.6
    self:addElement(LUI.UIImage.new(f7_local11))

    LUI.MenuBuilder.BuildAddChild(self, {
        type = "UICompass",
        id = "minimapCompass",
        states = {
            default = {
                topAnchor = true,
                bottomAnchor = false,
                leftAnchor = true,
                rightAnchor = true,
                bottom = -4,
                left = 0,
                right = 0,
                height = 16,
                material = RegisterMaterial("minimap_tickertape_mp"),
                alpha = 0
            },
            active = {
                alpha = 1
            },
            nosignal = {
                alpha = 0.05
            },
            scrambled = {
                alpha = 0
            }
        },
        handlers = {
            hud_nosignal_on = return_hud_state,
            hud_nosignal_off = return_hud_state,
            hud_scrambled_on = return_hud_state,
            hud_scrambled_off = return_hud_state
        }
    })
    ]] --

    local f7_local12 = CoD.CreateState(0, -22, 0, 0, CoD.AnchorTypes.All)
    f7_local12.alpha = 0

    local scrambler_image = LUI.UIImage.new(f7_local12)
    scrambler_image.id = "minimapScramblerGlitch_id"
    scrambler_image:registerAnimationState("scrambled_on", {
        alpha = 1
    })
    scrambler_image:registerAnimationState("scrambled_off", {
        alpha = 0
    })
    scrambler_image:registerEventHandler("hud_scrambled_on", MBh.AnimateToState("scrambled_on", 0))
    scrambler_image:registerEventHandler("hud_scrambled_off", MBh.AnimateToState("scrambled_off", 0))
    CoD.SetMaterial(scrambler_image, RegisterMaterial("compass_scrambled"))
    self:addElement(scrambler_image)

    run_minimap_callbacks(self)

    return self
end
