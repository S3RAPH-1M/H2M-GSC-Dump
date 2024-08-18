LUI.H1MenuTab.Colors = {
    ButtonHighlight = Colors.h1.light_grey,
    ButtonSelected = Colors.h1.light_grey,
    ButtonAvailable = Colors.h1.light_grey,
    ButtonDisabled = Colors.h1.dark_grey,
    ButtonDisabledHighlight = Colors.h1.medium_grey
}

LUI.H1MenuTab.Materials = {
    ButtonActive = RegisterMaterial("h2_tabs_states_active"),
    ButtonAvailable = RegisterMaterial("h2_tabs_states_normal"),
    ButtonDisabled = RegisterMaterial("h1_tabs_states_disable"),
    ButtonDisabledHighlight = RegisterMaterial("h1_tabs_states_disable_hover"),
    Background = RegisterMaterial("h2_tabs_bg")
}

LUI.H1MenuTab.Alphas = {
    Normal = 1,
    Hover = 1,
    Selected = 1,
    Disabled = 1,
    GlowMin = 0.6,
    GlowMax = 1
}

LUI.H1MenuTab.Time = {
    Expansion = 1500,
    Contraction = 1500
}

LUI.H1MenuTab.left = GenericMenuDims.menu_left
LUI.H1MenuTab.right = GenericMenuDims.menu_right_standard
LUI.H1MenuTab.width = LUI.H1MenuTab.right - LUI.H1MenuTab.left
LUI.H1MenuTab.shoulderButtonWidth = 100
LUI.H1MenuTab.shoulderButtonTextWidth = 50
LUI.H1MenuTab.arrowHOffset = 60
LUI.H1MenuTab.arrowHOffsetTextButton = 36
LUI.H1MenuTab.arrowBoxSize = 12
LUI.H1MenuTab.tabTextHeight = 12
LUI.H1MenuTab.tabBackgroundTopOffset = 7.5
LUI.H1MenuTab.tabBackgroundHeight = LUI.H1MenuTab.tabTextHeight * 1.8
LUI.H1MenuTab.tabTextTopOffset = -LUI.H1MenuTab.tabTextHeight -
                                     (LUI.H1MenuTab.tabBackgroundHeight - LUI.H1MenuTab.tabTextHeight) / 2
LUI.H1MenuTab.tabTextFont = CoD.TextSettings.BodyFont.Font
LUI.H1MenuTab.tabChangeBarsTop = 0 -- Origionally 30 changed cause of that one weird ass function
LUI.H1MenuTab.tabChangeHeight = 12
LUI.H1MenuTab.tabChangeTopOffsetClickable = 5
LUI.H1MenuTab.tabChangeHeightClickable = LUI.H1MenuTab.tabBackgroundHeight + 3
LUI.H1MenuTab.tabChangeHoldingElementHeight = LUI.H1MenuTab.tabChangeBarsTop + LUI.H1MenuTab.tabChangeHeightClickable
LUI.H1MenuTab.tabChangeSpacing = 0
LUI.H1MenuTab.tabChangeButtonHScale = 1.14
LUI.H1MenuTab.glowXScale = 1
LUI.H1MenuTab.glowYScale = 1

function WrapTabIndex(f1_arg0, f1_arg1, f1_arg2)
    assert(math.abs(f1_arg1) < f1_arg2.tabCount)
    local f1_local0 = f1_arg0 + f1_arg1
    while f1_local0 ~= f1_arg0 do
        if f1_arg2.tabCount < f1_local0 then
            f1_local0 = f1_local0 - f1_arg2.tabCount
        end
        if f1_local0 < 1 then
            f1_local0 = f1_local0 + f1_arg2.tabCount
        end
        if f1_arg2.isTabLockedfunc and f1_arg2.isTabLockedfunc(f1_local0) then
            f1_local0 = f1_local0 + f1_arg1
        end
        return f1_local0
    end
    return f1_local0
end

f0_local1 = function(f2_arg0, f2_arg1)
    if Engine.IsGamepadEnabled() ~= f2_arg0.previousIsGamepad or Engine.IsPS4Controller() ~= f2_arg0.previousIsPS4Ctrl then
        f2_arg0:Refresh()
    end
end

f0_local2 = "false"
local f0_local3 = false
function AddTabSelectButton(f3_arg0, f3_arg1, f3_arg2, f3_arg3)
    local f3_local8 = Engine.IsConsoleGame()
    if not f3_local8 then
        f3_local8 = Engine.IsGamepadEnabled()
    end

    if f3_local8 then
        local f3_local9 = f3_arg3.arrowHOffset
        if f3_local9 then
            local f3_local0, f3_local1, f3_local2, f3_local3, f3_local4, f3_local5, f3_local6, f3_local7

            if f3_arg1 == "left" then
                f3_local4 = f3_arg3.shoulderButtonWidth
                f3_local7 = f3_local9 - f3_arg3.arrowBoxSize / 2
                if Engine.IsVita(f3_arg3.exclusiveController) then
                    f3_local1 = ButtonMap.button_left_trigger
                else
                    local f3_local10 = Engine.GetDvarBool("cg_IsUsingAZERTY")
                    if f3_local10 ~= nil and f3_local10 == true then
                        f3_local1 = ButtonMap.button_left_trigger
                    else
                        f3_local1 = ButtonMap.button_shoulderl
                    end
                end
                f3_local3 = 0
                f3_local7 = f3_local7 + f3_arg3.arrowBoxSize
                f3_local5 = CoD.CreateState(f3_local7, f3_arg3.arrowBoxSize / 2, nil, nil, CoD.AnchorTypes.TopLeft)
                f3_local6 = -1
            elseif f3_arg1 == "right" then
                f3_local0 = f3_arg3.width - f3_arg3.shoulderButtonWidth
                f3_local4 = f3_arg3.shoulderButtonWidth
                f3_local7 = -f3_local9 - f3_arg3.arrowBoxSize / 2
                if Engine.IsVita(f3_arg3.exclusiveController) then
                    f3_local1 = ButtonMap.button_right_trigger
                else
                    f3_local1 = ButtonMap.button_shoulderr
                end
                if f3_local8 then
                    f3_local3 = f3_arg3.shoulderButtonWidth - f3_arg3.shoulderButtonTextWidth
                else
                    f3_local3 = 0
                end
                f3_local5 = CoD.CreateState(f3_local7, f3_arg3.arrowBoxSize / 2, nil, nil, CoD.AnchorTypes.TopRight)
                f3_local6 = 1
            else
                assert(false, "AddTabSelectButton(side) : side should be \"right\" or \"left\".")
                return {}
            end

            f3_local5.material = RegisterMaterial("h1_deco_option_scrollbar_arrows")
            local f3_local12 = f3_arg3.arrowBoxSize

            if f3_arg1 == "left" then
                local f3_local14 = -1
                f3_local5.width = f3_local12 * f3_local14
                f3_local5.height = f3_arg3.arrowBoxSize
                f3_local5.alpha = 0.5
                f3_local5.red = 1
                f3_local5.green = 1
                f3_local5.blue = 1
                if not f3_arg2 then
                    f3_local5.alpha = 0.25
                end
                f3_local2 = f3_local1.string
                local f3_local15 = CoD.CreateState(f3_local0, nil, nil, nil, CoD.AnchorTypes.TopLeft)
                f3_local15.width = f3_local4
                f3_local15.height = CoD.TextSettings.TitleFontSmall.Height
                local self = LUI.UIButton.new(f3_local15)
                self.id = "button_change_tab_id_" .. f3_arg1
                self.requireFocusType = FocusType.MouseOver
                self:registerEventHandler("button_action", function(element, event)
                    local f4_local0 = TryChangeIndex(f3_arg0, f3_arg3, f3_local6, true)
                    f4_local0(element, event)
                    f0_local2 = f3_arg1
                end)
                local f3_local17 = 0.9
                local f3_local18 = LUI.UIImage.new(f3_local5)
                f3_local18.id = "tab_select_arrow_id_" .. f3_arg1
                local f3_local19 = f3_local18
                local f3_local20 = f3_local18.registerAnimationState
                local f3_local21 = "buttonOver"
                local f3_local22 = {
                    topAnchor = true
                }
                local f3_local23
                if f3_arg1 == "left" then
                    f3_local23 = true
                else
                    f3_local23 = false
                end
                f3_local22.leftAnchor = f3_local23
                if f3_arg1 == "right" then
                    f3_local23 = true
                else
                    f3_local23 = false
                end
                f3_local22.rightAnchor = f3_local23
                f3_local22.red = 1
                f3_local22.green = 1
                f3_local22.blue = 1
                f3_local22.alpha = 1
                f3_local22.left = f3_local7
                f3_local22.top = f3_arg3.arrowBoxSize / 2
                f3_local22.width = f3_local5.width
                f3_local22.height = f3_local5.height
                f3_local20(f3_local19, f3_local21, f3_local22)
                f3_local19 = f3_local18
                f3_local20 = f3_local18.registerAnimationState
                f3_local21 = "pulse"
                f3_local22 = {
                    topAnchor = true
                }
                if f3_arg1 == "left" then
                    f3_local23 = true
                else
                    f3_local23 = false
                end
                f3_local22.leftAnchor = f3_local23
                if f3_arg1 == "right" then
                    f3_local23 = true
                else
                    f3_local23 = false
                end
                f3_local22.rightAnchor = f3_local23
                f3_local22.red = 0.86
                f3_local22.green = 0.81
                f3_local22.blue = 0.34
                f3_local22.alpha = 1
                f3_local22.left = f3_local7
                f3_local22.top = f3_arg3.arrowBoxSize / 2
                f3_local22.width = f3_local5.width * f3_local17
                f3_local22.height = f3_local5.height * f3_local17
                f3_local20(f3_local19, f3_local21, f3_local22)
                f3_local18:registerEventHandler("button_over", MBh.AnimateToState("buttonOver"))
                f3_local18:registerEventHandler("button_up", MBh.AnimateToState("default"))
                self:addElement(f3_local18)

                if f0_local2 == f3_arg1 then
                    f3_local18:animateInSequence({{"buttonOver", 0}, {"pulse", 100},
                                                  {f0_local3 and "buttonOver" or "default", 200}})
                end

                local f3_local24 = CoD.CreateState(f3_local3, nil, nil, nil, CoD.AnchorTypes.TopLeft)
                if f3_local8 then
                    local f3_local25 = -7
                    if f3_local25 then
                        f3_local24.top = f3_local25
                        f3_local24.width = f3_arg3.shoulderButtonTextWidth
                        if f3_local8 then
                            local f3_local26 = CoD.TextSettings.TitleFontMediumLarge.Height
                            if f3_local26 then
                                f3_local24.height = f3_local26
                                f3_local24.alignment = LUI.Alignment.Center
                                if f3_local8 then
                                    local f3_local27 = CoD.TextSettings.TitleFontMediumLarge.Font
                                    if f3_local27 then
                                        f3_local24.font = f3_local27
                                        if not f3_arg2 then
                                            f3_local24.alpha = 0.5
                                        end
                                        local f3_local28 = nil
                                        if f3_local8 then
                                            f3_local28 = LUI.UIText.new(f3_local24)
                                            f3_local28:setText(Engine.ToUpperCase(Engine.Localize(f3_local2)))
                                        else
                                            f3_local28 = LUI.UIButtonText.new(f3_local24, Engine.ToUpperCase(
                                                Engine.Localize(f3_local2)), f3_arg1 == "right", f3_arg2)
                                        end
                                        f3_local28.id = "button_change_act_text_id_" .. f3_arg1
                                        f3_local28.requireFocusType = FocusType.MouseOver

                                        if f0_local2 == f3_arg1 and not f3_local8 then
                                            f3_local28:processEvent({
                                                name = "pulse",
                                                mouse = f0_local3
                                            })
                                        end

                                        self:addElement(f3_local28)
                                        return self
                                    end
                                end
                            end
                        end
                    end
                    f3_local25 = 2
                end
            end
        end
    end
    return self
end

LUI.H1MenuTab.RemoveNewState = function(f5_arg0, f5_arg1)
    local f5_local0 = f5_arg0:getChildById("tab_change_tab_id")
    local f5_local1 = f5_local0:getChildById("tab_change_tab_button_id_" .. f5_arg1)
    local f5_local2 = f5_local1:getChildById("tab_new_icon")
    if f5_local2 then
        f5_local2:close()
    end
end

function CreateBarElement(f6_arg0, f6_arg1, f6_arg2, f6_arg3, f6_arg4)
    local f6_local0 = LUI.H1MenuTab.Colors.ButtonAvailable
    local f6_local1 = LUI.H1MenuTab.Alphas.Normal
    local f6_local2 = LUI.H1MenuTab.Materials.ButtonAvailable
    local f6_local3 = 1
    local f6_local4 = f6_arg4.activeIndex == f6_arg1
    local f6_local5 = false
    if f6_arg4.isTabLockedfunc then
        f6_local5 = f6_arg4.isTabLockedfunc(f6_arg1)
    end
    if f6_local4 then
        f6_local0 = LUI.H1MenuTab.Colors.ButtonSelected
        f6_local1 = LUI.H1MenuTab.Alphas.Selected
        f6_local2 = LUI.H1MenuTab.Materials.ButtonActive
        f6_local3 = 5
    elseif f6_local5 then
        f6_local0 = LUI.H1MenuTab.Colors.ButtonDisabled
        f6_local1 = LUI.H1MenuTab.Alphas.Disabled
        f6_local2 = LUI.H1MenuTab.Materials.ButtonDisabled
    end
    local f6_local6 = f6_arg4.tabChangeTopOffsetClickable
    local f6_local7 = nill
    f6_local6 = REG24 and f6_arg4.tabChangeTopOffsetClickable or LUI.H1MenuTab.tabChangeTopOffsetClickable
    f6_local7 = CoD.CreateState(f6_arg2, 0, nil, nil, CoD.AnchorTypes.TopLeft)
    f6_local7.width = f6_arg3
    f6_local7.top = f6_local6
    local self = f6_arg4.tabChangeHeightClickable
    if not self then
        self = LUI.H1MenuTab.tabChangeHeightClickable
    end
    f6_local7.height = self
    self = LUI.UIButton.new(f6_local7)
    if f6_local5 then
        self.disabled = true
    end
    self:registerEventHandler("button_action", TryChangeIndex(f6_arg0, f6_arg4, f6_arg1 - f6_arg4.activeIndex))
    self.id = "tab_change_tab_button_id_" .. f6_arg1
    self.requireFocusType = FocusType.MouseOver
    self:setPriority(f6_local3)
    if f6_arg4.tabHasNewFunc and f6_arg4.tabHasNewFunc(f6_arg1) then
        local f6_local9 = CoD.CreateState(-15, 5, nil, nil, CoD.AnchorTypes.TopRight)
        f6_local9.width = 12.85
        f6_local9.height = 10
        f6_local9.material = RegisterMaterial(CoD.Material.NewStickerSP)
        local f6_local10 = LUI.UIImage.new(f6_local9)
        f6_local10.id = "tab_new_icon"
        self:addElement(f6_local10)
    end
    local f6_local9 = CoD.CreateState(0, 0, nil, nil, CoD.AnchorTypes.TopLeft)
    f6_local9.top = -f6_local6
    f6_local9.width = f6_local7.width * LUI.H1MenuTab.tabChangeButtonHScale
    f6_local9.left = (f6_local7.width - f6_local9.width) / 2
    f6_local9.height = f6_arg4.tabChangeHeight
    f6_local9.color = f6_local0
    f6_local9.material = f6_local2
    f6_local9.alpha = f6_local1
    local f6_local10 = LUI.UIImage.new(f6_local9)
    if f6_local5 then
        f6_local10.disabled = true
        f6_local10:registerAnimationState("buttonOverDisable", {
            material = LUI.H1MenuTab.Materials.ButtonDisabledHighlight,
            alpha = LUI.H1MenuTab.Alphas.Hover
        })
        f6_local10:registerEventHandler("button_over_disable", MBh.AnimateToState("buttonOverDisable", 200))
        f6_local10:registerEventHandler("button_disable", MBh.AnimateToState("default", 200))
    else
        f6_local10:registerAnimationState("buttonOver", {
            material = LUI.H1MenuTab.Materials.ButtonAvailable,
            alpha = LUI.H1MenuTab.Alphas.Hover
        })
        f6_local10:registerEventHandler("button_over", MBh.AnimateToState("buttonOver", 200))
        f6_local10:registerEventHandler("button_up", MBh.AnimateToState("default", 200))
    end
    f6_local10.id = "tab_change_tab_button_image_id_" .. f6_arg1
    f6_local10.requireFocusType = FocusType.MouseOver
    f6_local10:makeNotFocusable()
    if f6_local4 then
        f6_local9.alpha = LUI.H1MenuTab.Alphas.GlowMax
        local f6_local11 = LUI.UIImage.new(f6_local9)
        f6_local9.top = f6_local9.top + (f6_local9.height - f6_local9.height * LUI.H1MenuTab.glowYScale) / 2
        f6_local9.left = f6_local9.left + (f6_local9.width - f6_local9.width * LUI.H1MenuTab.glowXScale) / 2
        f6_local9.width = f6_local9.width * LUI.H1MenuTab.glowXScale
        f6_local9.height = f6_local9.height * LUI.H1MenuTab.glowYScale
        f6_local9.alpha = LUI.H1MenuTab.Alphas.GlowMin
        f6_local11:registerAnimationState("expanded", f6_local9)
        f6_local11:registerEventHandler("menu_create", function(element)
            element:animateInLoop({{"expanded", LUI.H1MenuTab.Time.Expansion, true, true},
                                   {"default", LUI.H1MenuTab.Time.Contraction, true, true}})
        end)
        self:addElement(f6_local11)
    end
    self:addElement(f6_local10)
    if f6_arg4.underTabTextFunc then
        local f6_local11 = CoD.CreateState(nil, LUI.H1MenuTab.tabTextTopOffset, nil, nil, CoD.AnchorTypes.BottomLeft)
        f6_local11.height = LUI.H1MenuTab.tabTextHeight
        f6_local11.width = f6_arg3 + 3
        f6_local11.font = LUI.H1MenuTab.tabTextFont
        f6_local11.color = f6_local0
        f6_local11.alignment = LUI.Alignment.Center
        local f6_local12 = LUI.UIText.new(f6_local11)
        f6_local12:setText(Engine.ToUpperCase(Engine.Localize(f6_arg4.underTabTextFunc(f6_arg1))))
        if f6_local5 then
            f6_local12:registerAnimationState("buttonOver", {
                color = LUI.H1MenuTab.Colors.ButtonDisabledHighlight
            })
            f6_local12:registerEventHandler("button_over_disable", MBh.AnimateToState("buttonOver", 200))
            f6_local12:registerEventHandler("button_disable", MBh.AnimateToState("default", 200))
        else
            f6_local12:registerAnimationState("buttonOver", {
                color = LUI.H1MenuTab.Colors.ButtonHighlight
            })
            f6_local12:registerEventHandler("button_over", MBh.AnimateToState("buttonOver", 200))
            f6_local12:registerEventHandler("button_up", MBh.AnimateToState("default", 200))
        end
        self:addElement(f6_local12)
    end
    return self
end

function CreateTabSelectBarElements(f8_arg0, f8_arg1)
    local f8_local0 = f8_arg1.tabCount
    local f8_local1 = f8_arg1.tabChangeSpacing and f8_arg1.tabChangeSpacing or LUI.H1MenuTab.tabChangeSpacing
    local f8_local2 = (f8_arg1.width - (f8_local0 - 1) * f8_local1) / f8_local0
    local f8_local3 = CoD.CreateState(nil, f8_arg1.tabChangeBarsTop and f8_arg1.tabChangeBarsTop or
        LUI.H1MenuTab.tabChangeBarsTop, f8_arg1.width, nil, CoD.AnchorTypes.TopLeft)
    f8_local3.height = f8_arg1.tabChangeHeight
    local self = LUI.UIElement.new(f8_local3)
    self.id = "tab_change_tab_id"
    self:makeNotFocusable()
    local f8_local5 = CoD.CreateState(0, LUI.H1MenuTab.tabBackgroundTopOffset, 0, nil, CoD.AnchorTypes.TopLeftRight)
    f8_local5.material = LUI.H1MenuTab.Materials.Background
    f8_local5.height = LUI.H1MenuTab.tabBackgroundHeight
    self:addElement(LUI.UIImage.new(f8_local5))
    for f8_local6 = 1, f8_local0, 1 do
        self:addElement(CreateBarElement(f8_arg0, f8_local6, (f8_local6 - 1) * (f8_local1 + f8_local2), f8_local2,
            f8_arg1))
    end
    return self
end

function isPreviousDisabled(f9_arg0, f9_arg1)
    local f9_local0 = f9_arg0.previousDisabled
    if not f9_local0 then
        f9_local0 = f9_arg1 and f9_arg0.previousDisabledWhenController
    end
    return f9_local0
end

function isNextDisabled(f10_arg0, f10_arg1)
    local f10_local0 = f10_arg0.nextDisabled
    if not f10_local0 then
        f10_local0 = f10_arg1 and f10_arg0.nextDisabledWhenController
    end
    return f10_local0
end

function ConstructMenuTab(f11_arg0, f11_arg1)
    local f11_local0 = Engine.IsConsoleGame()
    if not f11_local0 then
        f11_local0 = Engine.IsGamepadEnabled()
    end
    local f11_local1 = AddTabSelectButton(f11_arg0, "left", not isPreviousDisabled(f11_arg1, f11_local0), f11_arg1)
    -- f11_arg0:addElement( f11_local1 )
    if isPreviousDisabled(f11_arg1, f11_local0) then
        f11_local1.disabled = true
    end
    local f11_local2 = AddTabSelectButton(f11_arg0, "right", not isNextDisabled(f11_arg1, f11_local0), f11_arg1)
    f0_local2 = "false"
    f0_local3 = false
    -- f11_arg0:addElement( f11_local2 )
    if isNextDisabled(f11_arg1, f11_local0) then
        f11_local2.disabled = true
    end
    f11_arg0:addElement(CreateTabSelectBarElements(f11_arg0, f11_arg1))
    if f11_arg1.title then
        local f11_local3 = nil
        if type(f11_arg1.title) == "function" then
            f11_local3 = Engine.ToUpperCase(Engine.Localize(f11_arg1.title(f11_arg1.activeIndex)))
        else
            f11_local3 = Engine.ToUpperCase(Engine.Localize(f11_arg1.title))
        end
        local f11_local4 = CoD.CreateState(nil, 2, nil, nil, CoD.AnchorTypes.TopLeft)
        f11_local4.width = f11_arg1.width
        f11_local4.height = CoD.TextSettings.BodyFont24.Height
        f11_local4.alignment = LUI.Alignment.Center
        f11_local4.font = CoD.TextSettings.H1TitleFont.Font
        f11_local4.color = Colors.white
        local self = LUI.UIText.new(f11_local4)
        self:setText(f11_local3)
        self.id = "tab_select_title_text_id"
        -- f11_arg0:addElement( self )
    end
    if not isPreviousDisabled(f11_arg1, f11_local0) then
        local f11_local3 = LUI.UIBindButton.new()
        f11_local3.id = "tab_select_previous_act"
        local f11_local4 = Engine.GetDvarBool("cg_IsUsingAZERTY")
        if f11_local4 ~= nil and f11_local4 == true then
            f11_local3:registerEventHandler("button_left_trigger", TryChangeIndex(f11_arg0, f11_arg1, -1, true))
        else
            f11_local3:registerEventHandler("button_shoulderl", TryChangeIndex(f11_arg0, f11_arg1, -1, true))
        end
        if not f11_local0 and f11_arg1.enableRightLeftNavigation then
            f11_local3:registerEventHandler("button_left", TryChangeIndex(f11_arg0, f11_arg1, -1, true))
        end
        f11_arg0:addElement(f11_local3)
    end
    if not isNextDisabled(f11_arg1, f11_local0) then
        local f11_local3 = LUI.UIBindButton.new()
        f11_local3.id = "tab_select_next_act"
        f11_local3:registerEventHandler("button_shoulderr", TryChangeIndex(f11_arg0, f11_arg1, 1, true))
        if not f11_local0 and f11_arg1.enableRightLeftNavigation then
            f11_local3:registerEventHandler("button_right", TryChangeIndex(f11_arg0, f11_arg1, 1, true))
        end
        f11_arg0:addElement(f11_local3)
    end
    if Engine.IsPC() then
        f11_arg0:registerEventHandler("onControllerChange", f0_local1)
        f11_arg0:registerEventHandler("popup_inactive", LUI.H1MenuTab.Refresh)
        f11_arg0.previousIsGamepad = Engine.IsGamepadEnabled()
        f11_arg0.previousIsPS4Ctrl = Engine.IsPS4Controller()
    end
end

function TryChangeIndex(f12_arg0, f12_arg1, f12_arg2, f12_arg3)
    return function(f13_arg0, f13_arg1)
        if f12_arg1.tabChangeLockedFunc and not f12_arg1.tabChangeLockedFunc(f13_arg0) then
            return
        end
        local f13_local0 = WrapTabIndex(f12_arg1.activeIndex, f12_arg2, f12_arg1)
        if f12_arg3 then
            f0_local2 = f12_arg2 and "left" or "right"
        else
            f0_local2 = false
        end
        f0_local3 = f13_arg1.mouse
        if not f12_arg1.skipChangeTab then
            f12_arg0:ChangeIndex(f13_local0)
        end
        f12_arg1.clickTabBtnAction(f13_arg0, f13_arg1, f13_local0)
    end

end

LUI.H1MenuTab.ChangeIndex = function(f14_arg0, f14_arg1)
    assert(f14_arg0.props)
    assert(f14_arg1 > 0)
    assert(f14_arg1 <= f14_arg0.props.tabCount)
    f14_arg0:closeChildren()
    f14_arg0.props.activeIndex = f14_arg1
    ConstructMenuTab(f14_arg0, f14_arg0.props)
end

LUI.H1MenuTab.Refresh = function(f15_arg0)
    assert(f15_arg0.props)
    assert(f15_arg0.props.activeIndex > 0)
    assert(f15_arg0.props.activeIndex <= f15_arg0.props.tabCount)
    f15_arg0:closeChildren()
    ConstructMenuTab(f15_arg0, f15_arg0.props)
end

LUI.H1MenuTab.new = function(f16_arg0)
    assert(f16_arg0)
    assert(f16_arg0.tabCount)
    assert(f16_arg0.clickTabBtnAction,
        "Require function clickTabBtnAction(self, event, index) to know what action doing tab!")
    assert(f16_arg0.exclusiveController)
    if not f16_arg0 then
        f16_arg0 = {}
    end
    local f16_local0 = LUI.DeepCopy(f16_arg0)
    f16_local0.width = f16_local0.width and f16_local0.width or LUI.H1MenuTab.width
    f16_local0.shoulderButtonWidth = f16_local0.shoulderButtonWidth and f16_local0.shoulderButtonWidth or
                                         LUI.H1MenuTab.shoulderButtonWidth
    f16_local0.shoulderButtonTextWidth = f16_local0.shoulderButtonTextWidth and f16_local0.shoulderButtonTextWidth or
                                             LUI.H1MenuTab.shoulderButtonTextWidth
    f16_local0.arrowHOffset = f16_local0.arrowHOffset and f16_local0.arrowHOffset or LUI.H1MenuTab.arrowHOffset
    f16_local0.arrowHOffsetTextButton = f16_local0.arrowHOffsetTextButton and f16_local0.arrowHOffsetTextButton or
                                            LUI.H1MenuTab.arrowHOffsetTextButton
    f16_local0.arrowBoxSize = f16_local0.arrowBoxSize and f16_local0.arrowBoxSize or LUI.H1MenuTab.arrowBoxSize
    f16_local0.tabChangeHeight = f16_local0.tabChangeHeight and f16_local0.tabChangeHeight or
                                     LUI.H1MenuTab.tabChangeHeight
    f16_local0.activeIndex = f16_local0.activeIndex and f16_local0.activeIndex or 1
    local f16_local1 = CoD.CreateState(nil, f16_local0.top, nil, nil, CoD.AnchorTypes.TopLeft)
    f16_local1.height = f16_local0.tabChangeHoldingElementHeight and f16_local0.tabChangeHoldingElementHeight or
                            LUI.H1MenuTab.tabChangeHoldingElementHeight
    f16_local1.width = f16_local0.width
    local self = LUI.UIElement.new(f16_local1)
    self:setClass(LUI.H1MenuTab)
    self.id = f16_arg0.id
    self.props = f16_local0
    ConstructMenuTab(self, f16_local0)
    return self
end

LUI.H1MenuTab.build = function(f17_arg0, f17_arg1, f17_arg2)
    return LUI.H1MenuTab.new(f17_arg1)
end
