LUI.H1ButtonBackground.AnimUpTime = 133
LUI.H1ButtonBackground.AnimOverTime = 133
LUI.H1ButtonBackground.AnimOverTimeContent = 67
LUI.H1ButtonBackground.EdgeW = 12
LUI.H1ButtonBackground.EdgeH = 12
LUI.H1ButtonBackground.EdgeU = 0.33
LUI.H1ButtonBackground.EdgeV = 0.33
LUI.H1ButtonBackground.ButtonHeight = 36
LUI.H1ButtonBackground.GreenlineVerticalOffset = 5
LUI.H1ButtonBackground.ScanlinesAlpha = 1
LUI.H1ButtonBackground.SubScanlineElements = 3
LUI.H1ButtonBackground.DisabledActionExtention = 2
LUI.H1ButtonBackground.ContourFinalAlpha = 0.8
LUI.H1ButtonBackground.ContourExtention = 2
LUI.DefaultButtonBackground = LUI.H1ButtonBackground

LUI.H1ButtonBackground.DisabledActionAnimation = function(focusedButton)
    focusedButton:animateInSequence({{"action_extended", 33}, {"focused_disabled", 66}})
end

LUI.H1ButtonBackground.SelectionContourActionAnimation = function(focusedButton)
    focusedButton:animateInSequence({{"action", 67}, {"action_scaled", 133}, {"default", 33}})
end

LUI.H1ButtonBackground.CreateFocusedElements = function(focusedButton)
    local parent = focusedButton:getParent()

    local selectionContourState = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    selectionContourState.material = RegisterMaterial("h1_btn_reg_selected_contour")
    selectionContourState.alpha = 0
    local selectionContour = LUI.UIImage.new(selectionContourState)
    selectionContour.id = "selectionContour"
    selectionContour:setup9SliceImage(LUI.H1ButtonBackground.EdgeW, LUI.H1ButtonBackground.EdgeH,
        LUI.H1ButtonBackground.EdgeU, LUI.H1ButtonBackground.EdgeV)
    selectionContour:registerAnimationState("default", selectionContourState)

    local actionState = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    actionState.material = RegisterMaterial("h1_btn_reg_selected_contour")
    actionState.alpha = LUI.H1ButtonBackground.ContourFinalAlpha
    selectionContour:registerAnimationState("action", actionState)

    local actionScaledState = CoD.CreateState(-LUI.H1ButtonBackground.ContourExtention,
        -LUI.H1ButtonBackground.ContourExtention, LUI.H1ButtonBackground.ContourExtention,
        LUI.H1ButtonBackground.ContourExtention, CoD.AnchorTypes.All)
    actionScaledState.material = RegisterMaterial("h1_btn_reg_selected_contour")
    actionScaledState.alpha = LUI.H1ButtonBackground.ContourFinalAlpha
    selectionContour:registerAnimationState("action_scaled", actionScaledState)
    selectionContour:registerEventHandler("button_action", LUI.H1ButtonBackground.SelectionContourActionAnimation)
    parent:addElement(selectionContour)

    local focusedContainerState = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    focusedContainerState.alpha = 0
    local focusedContainer = LUI.UIElement.new(focusedContainerState)
    focusedContainer.id = "focusedContainer"
    focusedContainer:registerAnimationState("default", focusedContainerState)
    focusedContainer:registerAnimationState("focused", {
        alpha = 1
    })
    focusedContainer:registerEventHandler("button_over",
        MBh.AnimateToState("focused", LUI.H1ButtonBackground.AnimOverTimeContent))
    focusedContainer:registerEventHandler("button_up", MBh.AnimateToState("default", LUI.H1ButtonBackground.AnimUpTime))
    parent:addElement(focusedContainer)

    local stencilElement = LUI.UIElement.new(CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    stencilElement:setUseStencil(true)
    focusedContainer:addElement(stencilElement)

    local strokeState = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    strokeState.material = RegisterMaterial("h2_btn_focused_stroke")
    local stroke = LUI.UIImage.new(strokeState)
    stroke.id = "stroke"
    stroke:setup9SliceImage(LUI.H1ButtonBackground.EdgeW, LUI.H1ButtonBackground.EdgeH, LUI.H1ButtonBackground.EdgeU,
        LUI.H1ButtonBackground.EdgeV)
    stroke:registerAnimationState("default", strokeState)
    focusedContainer:addElement(stroke)

    local outerGlowSize = 10
    local outerGlowState = CoD.CreateState(-1 * outerGlowSize, -1 * outerGlowSize, outerGlowSize, outerGlowSize,
        CoD.AnchorTypes.All)
    outerGlowState.material = RegisterMaterial("h2_btn_focused_outerglow")
    local outerGlow = LUI.UIImage.new(outerGlowState)
    outerGlow.id = "backglow"
    outerGlow:setup9SliceImage(LUI.H1ButtonBackground.EdgeW + 8, LUI.H1ButtonBackground.EdgeH + 10,
        LUI.H1ButtonBackground.EdgeU, LUI.H1ButtonBackground.EdgeV)
    outerGlow:registerAnimationState("default", outerGlowState)
    focusedContainer:addElement(outerGlow)

    local dotPatternState = CoD.CreateState(0, 0, nil, nil, CoD.AnchorTypes.TopLeft)
    dotPatternState.material = RegisterMaterial("h2_btn_dot_pattern")
    dotPatternState.alpha = 0
    dotPatternState.width = 666.6
    dotPatternState.height = 37.33
    local dotPattern = LUI.UIImage.new(dotPatternState)
    dotPattern.id = "dotPattern"
    dotPattern:registerAnimationState("default", dotPatternState)
    dotPattern:registerAnimationState("focused", {
        alpha = 0.2
    })
    dotPattern:registerEventHandler("button_up", MBh.AnimateToState("default", 0))
    dotPattern:registerEventHandler("button_over", MBh.AnimateToState("focused", 133))
    stencilElement:addElement(dotPattern)

    parent.hasFocusedElements = true
    return focusedContainer, stencilElement
end

LUI.H1ButtonBackground.ReceivedFocus = function(focusedButton)
    if focusedButton.hasFocus then
        return
    end
    focusedButton.hasFocus = true
    focusedButton:animateToState("focused", LUI.H1ButtonBackground.AnimOverTime)

    if focusedButton.lostFocusTimer then
        LUI.UITimer.Stop(focusedButton.lostFocusTimer)
        focusedButton.lostFocusTimer:close()
        focusedButton.lostFocusTimer = nil
        local parent = focusedButton:getParent()
        if parent.hasFocusedElements then
            return
        end
    end

    local focusedContainer, stencilElement = LUI.H1ButtonBackground.CreateFocusedElements(focusedButton)
    focusedContainer:processEvent({
        name = "button_over",
        dispatchChildren = true
    })
    stencilElement:processEvent({
        name = "button_over",
        dispatchChildren = true
    })
end

LUI.H1ButtonBackground.CreateFocusedLockedElements = function(button)
    local state = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    state.alpha = 0
    local focusedLockedContainer = LUI.UIElement.new(state)
    focusedLockedContainer:setUseStencil(true)
    focusedLockedContainer.id = "focusedLockedContainer"

    local focusedState = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    focusedState.alpha = 1
    focusedLockedContainer:registerAnimationState("default", state)
    focusedLockedContainer:registerAnimationState("focused", focusedState)
    focusedLockedContainer:registerEventHandler("button_disable",
        MBh.AnimateToState("default", LUI.H1ButtonBackground.AnimUpTime))
    focusedLockedContainer:registerEventHandler("button_over_disable",
        MBh.AnimateToState("focused", LUI.H1ButtonBackground.AnimOverTime))
    button:addElement(focusedLockedContainer)

    local parent = button:getParent()
    parent.hasFocusLockedElement = true
    return focusedLockedContainer
end

LUI.H1ButtonBackground.ReceivedFocusLocked = function(focusedButton)
    if focusedButton.hasFocus then
        return
    else
        focusedButton.hasFocus = true
        focusedButton.everHadFocus = true
        focusedButton:animateToState("focused_disabled", LUI.H1ButtonBackground.AnimOverTime)

        if focusedButton.lostFocusTimer then
            LUI.UITimer.Stop(focusedButton.lostFocusTimer)
            focusedButton.lostFocusTimer:close()
            focusedButton.lostFocusTimer = nil
            return
        else
            local parent = focusedButton:getParent()
            if parent.hasFocusLockedElement then
                return
            else
                local focusedLockedContainer = LUI.H1ButtonBackground.CreateFocusedLockedElements(focusedButton)
                focusedLockedContainer:processEvent({
                    name = "button_over_disable",
                    dispatchChildren = true
                })
            end
        end
    end
end

LUI.H1ButtonBackground.LostFocusLocked = function(focusedButton)
    if not focusedButton.hasFocus and focusedButton.everHadFocus then
        return
    end

    local parent = focusedButton:getParent()
    if parent.hasFocusLockedElement then
        focusedButton.hasFocus = false

        if not focusedButton.lostFocusTimer then
            focusedButton.lostFocusTimer = LUI.UITimer.new(LUI.H1ButtonBackground.AnimUpTime, "lost_focus_done", nil,
                true)
            focusedButton:addElement(focusedButton.lostFocusTimer)
        else
            LUI.UITimer.Reset(focusedButton.lostFocusTimer)
        end

        LUI.H1ButtonBackground.AnimateToDisable(focusedButton)
    end
end

LUI.H1ButtonBackground.ClearFocusedContainers = function(focusedButton)
    local parent = focusedButton:getParent()
    if parent ~= nil then
        local selectionContour = parent:getChildById("selectionContour")
        if selectionContour then
            selectionContour:close()
        end

        local focusedContainer = parent:getChildById("focusedContainer")
        if focusedContainer then
            focusedContainer:close()
        end

        parent.hasFocusLockedElement = false
        parent.hasFocusedElements = false
    end

    focusedButton:closeChildren()
    collectgarbage("collect")
end

LUI.H1ButtonBackground.LostFocusDone = function(focusedButton)
    if focusedButton.lostFocusTimer then
        LUI.UITimer.Stop(focusedButton.lostFocusTimer)
        focusedButton.lostFocusTimer:close()
        focusedButton.lostFocusTimer = nil
    end

    LUI.H1ButtonBackground.ClearFocusedContainers(focusedButton)
end

LUI.H1ButtonBackground.LostFocus = function(focusedButton)
    if not focusedButton.hasFocus then
        return
    end

    focusedButton.hasFocus = false
    if not focusedButton.lostFocusTimer then
        focusedButton.lostFocusTimer = LUI.UITimer.new(LUI.H1ButtonBackground.AnimUpTime, "lost_focus_done", nil, true)
        focusedButton:addElement(focusedButton.lostFocusTimer)
    else
        LUI.UITimer.Reset(focusedButton.lostFocusTimer)
    end

    LUI.H1ButtonBackground.AnimateToEnable(focusedButton)
end

LUI.H1ButtonBackground.AnimateToEnable = function(focusedButton)
    if focusedButton.hasFocus then
        LUI.H1ButtonBackground.ClearFocusedContainers(focusedButton)
        focusedButton:animateToState("focused", LUI.H1ButtonBackground.AnimOverTime)
        local focusedContainer, stencilElement = LUI.H1ButtonBackground.CreateFocusedElements(focusedButton)
        focusedContainer:processEvent({
            name = "button_over",
            dispatchChildren = true
        })
        stencilElement:processEvent({
            name = "button_over",
            dispatchChildren = true
        })
    else
        focusedButton:animateToState("default", LUI.H1ButtonBackground.AnimUpTime)
        focusedButton.material = RegisterMaterial("h2_btn_unfocused")
    end
end

LUI.H1ButtonBackground.AnimateToDisable = function(focusedButton)
    if focusedButton.hasFocus then
        LUI.H1ButtonBackground.ClearFocusedContainers(focusedButton)
        focusedButton:animateToState("focused_disabled", LUI.H1ButtonBackground.AnimOverTime)
        local focusedLockedContainer = LUI.H1ButtonBackground.CreateFocusedLockedElements(focusedButton)
        focusedLockedContainer:processEvent({
            name = "button_over_disable",
            dispatchChildren = true
        })
    else
        focusedButton:animateToState("default_disabled", LUI.H1ButtonBackground.AnimUpTime)
        focusedButton.material = RegisterMaterial("h2_btn_unfocused_locked")
    end
end

LUI.H1ButtonBackground.new = function(buttonData)
    local self = LUI.UIElement.new(CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    self.id = "buttonContainer"
    self:setClass(LUI.H1ButtonBackground)

    local stateDefault = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    stateDefault.material = RegisterMaterial("h2_btn_unfocused")

    local fillImage = LUI.UIImage.new(stateDefault)
    fillImage.id = "fill"
    fillImage.UITimer = nil
    fillImage.hasFocus = false
    fillImage.everHadFocus = false
    fillImage:setup9SliceImage(LUI.H1ButtonBackground.EdgeW, LUI.H1ButtonBackground.EdgeH, LUI.H1ButtonBackground.EdgeU,
        LUI.H1ButtonBackground.EdgeV)
    fillImage:registerAnimationState("default", stateDefault)
    fillImage:registerAnimationState("focused", {
        material = RegisterMaterial("h2_btn_focused_fill")
    })
    fillImage:registerAnimationState("default_disabled", {
        material = RegisterMaterial("h2_btn_unfocused_locked")
    })

    local stateFocusedDisabled = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    stateFocusedDisabled.material = RegisterMaterial("h2_btn_focused_locked")
    fillImage:registerAnimationState("focused_disabled", stateFocusedDisabled)

    fillImage:registerAnimationState("action_extended",
        CoD.CreateState(-LUI.H1ButtonBackground.DisabledActionExtention,
            -LUI.H1ButtonBackground.DisabledActionExtention, LUI.H1ButtonBackground.DisabledActionExtention,
            LUI.H1ButtonBackground.DisabledActionExtention, CoD.AnchorTypes.All))

    fillImage:registerEventHandler("button_up", LUI.H1ButtonBackground.LostFocus)
    fillImage:registerEventHandler("button_over", LUI.H1ButtonBackground.ReceivedFocus)
    fillImage:registerEventHandler("button_disable", LUI.H1ButtonBackground.LostFocusLocked)
    fillImage:registerEventHandler("button_over_disable", LUI.H1ButtonBackground.ReceivedFocusLocked)
    fillImage:registerEventHandler("button_action_disable", LUI.H1ButtonBackground.DisabledActionAnimation)
    fillImage:registerEventHandler("lost_focus_done", LUI.H1ButtonBackground.LostFocusDone)
    fillImage:registerEventHandler("enable", LUI.H1ButtonBackground.AnimateToEnable)
    fillImage:registerEventHandler("disable", LUI.H1ButtonBackground.AnimateToDisable)

    self:addElement(fillImage)

    if buttonData ~= nil and buttonData.strip ~= nil and buttonData.glow ~= nil and buttonData.corner ~= nil and
        buttonData.rarity > 0 then
        local stateLeftStrip = CoD.CreateState(0, 0, nil, 0, CoD.AnchorTypes.TopBottomLeft)
        stateLeftStrip.width = 8
        stateLeftStrip.material = buttonData.strip

        local leftStrip = LUI.UIImage.new(stateLeftStrip)
        self:addElement(leftStrip)
        self.leftStrip = leftStrip

        local stateGlow = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
        stateGlow.material = buttonData.glow

        local glow = LUI.UIImage.new(stateGlow)
        self:addElement(glow)
        self.glow = glow

        local stateTopRightCorner = CoD.CreateState(nil, 2, -2, nil, CoD.AnchorTypes.TopRight)
        stateTopRightCorner.width = 16
        stateTopRightCorner.height = 16
        stateTopRightCorner.material = buttonData.corner
        stateTopRightCorner.alpha = 0

        local topRightCorner = LUI.UIImage.new(stateTopRightCorner)
        topRightCorner:registerAnimationState("focused", {
            alpha = 1
        })
        topRightCorner:registerEventHandler("button_up", MBh.AnimateToState("default"))
        topRightCorner:registerEventHandler("button_over", MBh.AnimateToState("focused"))
        topRightCorner:registerEventHandler("button_disable", MBh.AnimateToState("default"))
        topRightCorner:registerEventHandler("button_over_disable", MBh.AnimateToState("focused"))

        self:addElement(topRightCorner)
        self.topRightCorner = topRightCorner
    end

    return self
end
