local function InputFieldOpensVirtualKeyboard(f1_arg0)
    return Engine.IsConsoleGame() or f1_arg0
end

local function InputFieldAction(f2_arg0, f2_arg1)
    local f2_local0 = Engine.GetDvarString(f2_arg0.properties.dvar_hook)
    local f2_local1
    if not Engine.IsConsoleGame() and not f2_arg1.mouse then
        f2_local1 = not f2_arg1.keyboard
    else
        f2_local1 = false
    end
    f2_arg0.properties.isPCGamepad = f2_local1
    if InputFieldOpensVirtualKeyboard(f2_local1) then
        f2_arg0.properties.active = true
        local f2_local2 = Engine.OpenScreenKeyboard
        local f2_local3 = f2_arg1.controller
        if not f2_local3 then
            f2_local3 = Engine.GetFirstActiveController()
        end
        local f2_local4 = f2_arg0.properties.field_name
        if f2_local0 then
            local f2_local5 = f2_local0
        end
        f2_local2(f2_local3, f2_local4, f2_local5 or "", f2_arg0.properties.max_length,
            f2_arg0.properties.verify_string, f2_arg0.properties.filter_profanity, f2_arg0.properties.keyboard_type)
    elseif f2_arg0.properties.active then
        f2_arg0:processEvent({
            name = "finish_editing"
        })
        f2_arg0.properties.active = false
    else
        local f2_local2 = f2_arg0:getChildById("input_text")
        f2_local2:setTextEditActive()
        f2_arg0.properties.active = true
    end
end

local function InputFieldUpdateText(f3_arg0, f3_arg1)
    if f3_arg1.text then
        local f3_local0 = f3_arg0.properties.password_field and string.rep("*", #f3_arg1.text) or f3_arg1.text
        local f3_local1 = f3_arg0:getChildById("input_text")
        f3_local1:setTextEditText(f3_local0)
        Engine.SetDvarString(f3_arg0.properties.dvar_hook, f3_arg1.text)
    end
end

local function InitField(f4_arg0, f4_arg1)
    f4_arg0:setTextEditText(f4_arg0.properties.text)
    local f4_local0 = Engine.GetDvarString(f4_arg0.properties.dvar_hook)
    if f4_local0 ~= nil and f4_local0 ~= "" then
        f4_arg0:setTextEditText(f4_arg0.properties.password_field and string.rep("*", #f4_local0) or f4_local0)
    end
end

local f0_local0 = function()
    return CoD.TextSettings.TitleFontTiny.Height
end

local f0_local1 = function(f7_arg0, f7_arg1, f7_arg2, f7_arg3, f7_arg4, f7_arg5)
    local f7_local0 = f7_arg4 or GenericPopupAnimationSettings.Global.DelayOut
    local f7_local1 = f7_arg5 or GenericPopupAnimationSettings.Global.DurationOut
    f7_arg0:registerAnimationState("default", f7_arg1)
    f7_arg1.alpha = 0
    f7_arg0:registerAnimationState("hidden", f7_arg1)
    f7_arg0:animateInSequence({{"hidden", 0, true, true}, {"hidden", f7_arg2, true, true},
                               {"default", f7_arg3, true, true}})
    f7_arg0:registerEventHandler("close_popup", function(element, event)
        element:animateInSequence({{"default", f7_local0, true, true}, {"hidden", f7_local1, true, true}})
    end)
end

local function generic_input_field()
    return {
        type = "UIButton",
        id = "generic_input_field_id",
        focusable = true,
        properties = {
            help_value = "Placeholder field help",
            field_name = "Placeholder Field name",
            dvar_hook = "override_this_with_a_DVarString_name",
            max_length = 16,
            password_field = false,
            active = false,
            isPCGamepad = false,
            field_edited_func = function()
                -- blank
            end,
            verify_string = false,
            filter_profanity = false,
            keyboard_type = CoD.KeyboardInputTypes.Normal,
            text_alignment = LUI.Alignment.Left
        },
        states = {
            default = {
                leftAnchor = true,
                rightAnchor = true,
                topAnchor = true,
                bottomAnchor = false,
                left = 0,
                right = 0,
                top = 0,
                bottom = GenericButtonDims.button_height,
                alpha = 0.5
            },
            over = {
                alpha = 1
            }
        },
        handlers = {
            button_over = MBh.AnimateToState("over", 0),
            button_up = MBh.AnimateToState("default", 0),
            button_action = InputFieldAction,
            text_edit_complete = function(f10_arg0, f10_arg1)
                if not InputFieldOpensVirtualKeyboard(f10_arg0.properties.isPCGamepad) and f10_arg0.properties.active then
                    f10_arg1.text = f10_arg0.properties:field_edited_func(f10_arg1) or f10_arg1.text
                    InputFieldUpdateText(f10_arg0, f10_arg1)
                end
            end,
            text_input_complete = function(f11_arg0, f11_arg1)
                if InputFieldOpensVirtualKeyboard(f11_arg0.properties.isPCGamepad) and f11_arg0.properties.active then
                    f11_arg1.text = f11_arg0.properties:field_edited_func(f11_arg1) or f11_arg1.text
                    InputFieldUpdateText(f11_arg0, f11_arg1)
                    f11_arg0.properties.active = false
                end
            end,
            edit_unfocus = function(f12_arg0, f12_arg1)
                if not InputFieldOpensVirtualKeyboard(f12_arg0.properties.isPCGamepad) and f12_arg0.properties.active then
                    f12_arg0:processEvent({
                        name = "finish_editing"
                    })
                    f12_arg0.properties.active = false
                end
            end

        },
        children = {{
            type = "UITextEdit",
            id = "input_text",
            properties = {
                text = MBh.Property("help_value"),
                max_length = MBh.Property("max_length"),
                dvar_hook = MBh.Property("dvar_hook"),
                password_field = MBh.Property("password_field"),
                text_alignment = MBh.Property("text_alignment")
            },
            handlers = {
                menu_create = InitField,
                finish_editing = function(f13_arg0, f13_arg1)
                    f13_arg0:setTextEditActive(false)
                end,
                colorize = function(f14_arg0, f14_arg1)
                    f14_arg0:registerAnimationState("colorized", {
                        red = f14_arg1.red,
                        green = f14_arg1.green,
                        blue = f14_arg1.blue
                    })
                    f14_arg0:animateToState("colorized")
                end

            },
            states = {
                default = {
                    leftAnchor = true,
                    rightAnchor = true,
                    topAnchor = true,
                    bottomAnchor = false,
                    left = 0,
                    right = 0,
                    top = 0,
                    bottom = f0_local0(),
                    font = CoD.TextSettings.TitleFontTiny.Font,
                    alignment = MBh.Property("text_alignment")
                }
            }
        }}
    }
end

local function generic_back_button()
    return {
        type = "UIBindButton",
        id = "generic_back_button",
        handlers = {
            button_secondary = MBh.LeaveMenu()
        }
    }
end

local f0_local2 = function(f16_arg0, f16_arg1)
    if f16_arg1.string then
        f16_arg0:setText(f16_arg1.string)
    end
end

local f0_local3 = function(f17_arg0, f17_arg1)
    if f17_arg1.string then
        f17_arg0:setText(f17_arg1.string)
    end
end

function HandleMenuTitleShow(f18_arg0, f18_arg1)
    local f18_local0 = f18_arg1.preAnimTime or 0
    local f18_local1 = f18_arg1.animTime or 0
    if f18_arg0.properties.isHidden then
        local f18_local2 = MBh.AnimateSequence({{"hidden", f18_local0}, {"shown", f18_local1}})
        f18_local2(f18_arg0)
        f18_arg0.properties.isHidden = false
    end
end

function HandleMenuTitleHide(f19_arg0, f19_arg1)
    local f19_local0 = f19_arg1.preAnimTime or 0
    local f19_local1 = f19_arg1.animTime or 0
    if not f19_arg0.properties.isHidden then
        local f19_local2 = MBh.AnimateSequence({{"shown", f19_local0}, {"hidden", f19_local1}})
        f19_local2(f19_arg0)
        f19_arg0.properties.isHidden = true
    end
end

function AddHeaderDecorations(f20_arg0)
    f20_arg0:addElement(LUI.UIImage.new({
        leftAnchor = true,
        topAnchor = true,
        height = 24,
        width = 13.33,
        left = 0,
        top = 0,
        material = RegisterMaterial("h2_title_arrow")
    }))
end

function generic_menu_title(menu, controller)
    local self = LUI.UIElement.new()
    self.id = "generic_menu_title_container_id"
    self:registerAnimationState("default", {
        leftAnchor = true,
        rightAnchor = true,
        topAnchor = true,
        bottomAnchor = false,
        left = 0,
        right = 0,
        top = 0,
        bottom = 128
    })
    self:registerAnimationState("hidden", {
        leftAnchor = true,
        rightAnchor = true,
        topAnchor = true,
        bottomAnchor = false,
        left = 0,
        right = 0,
        top = -128,
        bottom = 0
    })
    self:animateToState("default")
    local title_font_tiny = 0
    local menu_start_x = nil
    if Engine.IsPC() then
        title_font_tiny = -74.66
        menu_start_x = RegisterMaterial("h2_title_backglow_pc")
    else
        menu_start_x = RegisterMaterial("h2_title_backglow")
    end
    local title_top = CoD.CreateState(-DesignGridDims.horz_gutter + title_font_tiny, -DesignGridDims.vert_gutter / 70, nil,
        nil, CoD.AnchorTypes.TopLeft)
    title_top.material = menu_start_x
    title_top.width = 266.64 - title_font_tiny
    title_top.height = 85.32
    title_top.alpha = 1
    local f21_local4 = LUI.UIImage.new(title_top)
    f21_local4.id = "generic_menu_title_background_id"
    f21_local4.properties = {
        isHidden = false
    }
    f21_local4:registerAnimationState("hidden", {
        alpha = 0
    })
    f21_local4:registerAnimationState("shown", {
        alpha = 1
    })
    f21_local4:registerEventHandler("menu_title_show", HandleMenuTitleShow)
    f21_local4:registerEventHandler("menu_title_hide", HandleMenuTitleHide)
    self:addElement(f21_local4)
    local f21_local5 = CoD.CreateState(-DesignGridDims.horz_gutter + 50, -DesignGridDims.vert_gutter + 55, nil, nil,
        CoD.AnchorTypes.TopLeft)
    f21_local5.material = RegisterMaterial("h2_title_backglow_light")
    f21_local5.width = 333.3
    f21_local5.height = 32
    f21_local5.alpha = 1
    local f21_local6 = LUI.UIImage.new(f21_local5)
    f21_local6.id = "generic_menu_title_backglow_light_id"
    f21_local6.properties = {
        isHidden = false
    }
    self:addElement(f21_local6)
    local f21_local7 = CoD.CreateState(-DesignGridDims.horz_gutter, 0, nil, nil, CoD.AnchorTypes.TopLeft)
    f21_local7.material = RegisterMaterial("h2_title_pattern_dot")
    f21_local7.alpha = 0.6
    f21_local7.width = 610
    f21_local7.height = 88
    local f21_local8 = LUI.UIImage.new(f21_local7)
    f21_local8.id = "generic_menu_title_background_dot_id"
    self:addElement(f21_local8)
    local f21_local9 = CoD.CreateState(-20, 33, nil, nil, CoD.AnchorTypes.TopLeft)
    f21_local9.alpha = 0.15
    f21_local9.width = 50
    f21_local9.height = 50
    local menu_breadcrumb = LUI.UIElement.new(f21_local9)
    self:addElement(menu_breadcrumb)
    AddHeaderDecorations(menu_breadcrumb)
    self:addElement(LUI.SimpleAnimatedObjects.new({{
        introDelay = 0,
        repeatDelay = {5000, 5500},
        hudlist = {{
            material = {"h2_title_splatter_02"},
            flippedX = {true, false},
            flippedY = {true, false},
            scaleAdditive = {0.15, 1},
            anchor = CoD.AnchorTypes.TopLeft,
            top = {20, 45},
            left = -100,
            height = 15,
            width = 15,
            alpha = 0,
            color = {Colors.h1.light_green, Colors.h1.light_green, Colors.h1.light_green},
            persistentState = {{
                left = {600, 800},
                topOffset = {-20, 100}
            }},
            states = {{
                alpha = 0,
                duration = 0
            }, {
                alpha = {0.1, 0.7},
                duration = 1000
            }, {
                duration = 20000
            }, {
                scale = 0,
                alpha = 0,
                duration = 20000
            }}
        }, {
            material = {"h2_title_splatter_01"},
            zRot = {0, 360},
            flippedX = {true, false},
            flippedY = {true, false},
            scaleAdditive = {1.5, 3},
            anchor = CoD.AnchorTypes.TopLeft,
            top = {20, 45},
            left = -100,
            height = 15,
            width = 15,
            alpha = 0,
            color = {Colors.h1.light_green, Colors.h1.light_green, Colors.h1.light_green},
            persistentState = {{
                left = {600, 700}
            }},
            states = {{
                alpha = 0,
                duration = 0
            }, {
                alpha = {0.6, 1},
                duration = 1000
            }, {
                duration = 30000
            }, {
                scale = 0,
                alpha = 0,
                duration = 30000
            }}
        }}
    }, {
        introDelay = 0,
        repeatDelay = {1000, 2000},
        hudlist = {{
            material = {"h2_title_smoke_01", "h2_title_smoke_02"},
            flippedX = {true, false},
            flippedY = {true, false},
            scaleAdditive = {0.1, 0.7},
            anchor = CoD.AnchorTypes.TopLeft,
            top = {15, 35},
            left = -100,
            height = 32,
            width = 128,
            alpha = 0,
            color = {Colors.h1.light_green, Colors.h1.light_green, Colors.h1.light_green},
            persistentState = {{
                left = {600, 800}
            }},
            states = {{
                alpha = 0,
                duration = 0
            }, {
                alpha = {0.1, 0.6},
                duration = 1000
            }, {
                duration = 40000
            }, {
                alpha = 0,
                duration = 20000
            }}
        }}
    }}, 100, 60))
    local header = LUI.DeepCopy(controller)
    header.parent = self
    header.type = "generic_menu_title_and_breadCrumb_text"
    LUI.MenuBuilder.BuildAddChild(self, header)
    return self
end

local function generic_menu_title_and_breadCrumb_text(f21_arg0, f21_arg1)
    local h1_title_font = CoD.TextSettings.H1TitleFont
    local title_font_tiny = CoD.TextSettings.TitleFontTiny
    local menu_start_x = GenericMenuDims.MenuStartX
    local title_top = GenericMenuDims.TitleTop
    if f21_arg0.headerStartX ~= nil then
        menu_start_x = f21_arg0.headerStartX
    end
    if f21_arg0.headerStartY ~= nil then
        title_top = f21_arg0.headerStartY
    end
    local f21_local4 = 1280 - menu_start_x - menu_start_x
    if f21_arg0.menu_title_width ~= nil then
        f21_local4 = f21_arg0.menu_title_width
    end
    local f21_local5 = 0
    if f21_arg0.marqueePadding ~= nil then
        f21_local5 = f21_arg0.marqueePadding
    end

    local element = LUI.UIElement.new()
    element.id = "generic_menu_title_id"
    element.properties = {
        isHidden = false
    }
    element:registerAnimationState("default", {
        leftAnchor = true,
        rightAnchor = false,
        topAnchor = true,
        bottomAnchor = false,
        top = title_top,
        bottom = title_top + h1_title_font.Height,
        left = menu_start_x,
        width = f21_local4
    })
    element:registerAnimationState("hidden", {
        alpha = 0
    })
    element:registerAnimationState("shown", {
        alpha = 1
    })
    element:animateToState("default")
    element:registerEventHandler("menu_title_show", HandleMenuTitleShow)
    element:registerEventHandler("menu_title_hide", HandleMenuTitleHide)

    local breadcrumb = {
        leftAnchor = true,
        rightAnchor = true,
        topAnchor = true,
        bottomAnchor = false,
        left = 0,
        right = 0,
        top = -title_font_tiny.Height * 0.9,
        bottom = 4,
        font = title_font_tiny.Font,
        horizontalAlignment = LUI.HorizontalAlignment.RTL_ForcedLeft,
        color = Colors.mw1_green
    }
    local f21_local8 = LUI.MenuTemplate.GetDefaultBreadCrumpText()
    local breadcrumb_text = LUI.UIText.new(breadcrumb)
    breadcrumb_text.id = "breadcrumb_text"
    local menu_breadcrumb = f21_arg0.menu_breadcrumb
    if not menu_breadcrumb then
        menu_breadcrumb = f21_local8
    end
    breadcrumb_text:setText(menu_breadcrumb)
    breadcrumb_text:registerAnimationState("default", breadcrumb)
    breadcrumb_text:registerEventHandler("update_breadcrumb_text", f0_local2)
    breadcrumb_text:animateToState("default")
    element:addElement(breadcrumb_text)
    local header = {
        leftAnchor = true,
        rightAnchor = true,
        topAnchor = true,
        bottomAnchor = false,
        left = 0,
        right = 0,
        top = 0,
        bottom = h1_title_font.Height,
        font = h1_title_font.Font,
        horizontalAlignment = LUI.HorizontalAlignment.RTL_ForcedLeft,
        color = Colors.h1.light_grey
    }
    local header_text = LUI.UIText.new(header)
    header_text.id = "header_text"
    local menu_title = f21_arg0.menu_title
    if not menu_title then
        menu_title = ""
    end
    header_text:setText(menu_title)
    header_text:registerAnimationState("default", header)
    header_text:registerEventHandler("update_header_text", f0_local3)
    header_text:animateToState("default")
    header_text:setTextStyle(CoD.TextStyle.MW1Title)
    element:addElement(header_text)

    return element
end

headerHeight = 35
function generic_border(f23_arg0, f23_arg1)
    local f23_local0 = false
    if f23_arg1.inner ~= nil then
        f23_local0 = f23_arg1.inner
    end
    local f23_local1 = f23_arg1.thickness
    if not f23_local1 then
        f23_local1 = 1
    end
    if not f23_arg1.border_red then
        local f23_local2 = 1
    end
    if not f23_arg1.border_green then
        local f23_local3 = 1
    end
    if not f23_arg1.border_blue then
        local f23_local4 = 1
    end
    local f23_local5 = f23_arg1.border_alpha
    if not f23_local5 then
        f23_local5 = 1
    end
    if f23_arg1.border_color then
        local f23_local2 = f23_arg1.border_color.r
        local f23_local3 = f23_arg1.border_color.g
        local f23_local4 = f23_arg1.border_color.b
    end
    local f23_local6 = f23_arg1.hide_bottom
    if not f23_local6 then
        f23_local6 = false
    end
    local self = LUI.UIElement.new(f23_arg1.defAnimState)
    local f23_local8 = self
    local f23_local9 = self.registerAnimationState
    local f23_local10 = "default"
    local f23_local11 = {
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true
    }
    if f23_local0 then
        local f23_local12 = f23_local1
    end
    f23_local11.top = f23_local12 or 0
    local f23_local13
    if f23_local0 then
        f23_local13 = -f23_local1
        if not f23_local13 then

        else
            f23_local11.bottom = f23_local13
            if f23_local0 then
                local f23_local14 = f23_local1
            end
            f23_local11.left = f23_local14 or 0
            if f23_local0 then
                f23_local13 = -f23_local1
                if not f23_local13 then

                else
                    f23_local11.right = f23_local13
                    f23_local9(f23_local8, f23_local10, f23_local11)
                    self:animateToState("default")
                    f23_local9 = LUI.UIImage.new()
                    f23_local9.id = "top"
                    f23_local9:registerAnimationState("default", {
                        material = RegisterMaterial("white"),
                        topAnchor = true,
                        bottomAnchor = false,
                        leftAnchor = true,
                        rightAnchor = true,
                        top = -f23_local1,
                        bottom = 0,
                        left = 0,
                        right = 0
                    })
                    f23_local9:animateToState("default")
                    self:addElement(f23_local9)
                    f23_local8 = nil
                    if not f23_local6 then
                        f23_local8 = LUI.UIImage.new()
                        f23_local8.id = "bottom"
                        f23_local8:registerAnimationState("default", {
                            material = RegisterMaterial("white"),
                            topAnchor = false,
                            bottomAnchor = true,
                            leftAnchor = true,
                            rightAnchor = true,
                            top = 0,
                            bottom = f23_local1 or 0,
                            left = 0,
                            right = 0
                        })
                        f23_local8:animateToState("default")
                        self:addElement(f23_local8)
                    end
                    f23_local10 = LUI.UIImage.new()
                    f23_local10.id = "left"
                    f23_local13 = f23_local10
                    f23_local11 = f23_local10.registerAnimationState
                    local f23_local15 = "default"
                    local f23_local16 = {
                        material = RegisterMaterial("white"),
                        topAnchor = true,
                        bottomAnchor = true,
                        leftAnchor = true,
                        rightAnchor = false,
                        top = -f23_local1
                    }
                    if not f23_local6 then
                        local f23_local17 = f23_local1
                    end
                    f23_local16.bottom = f23_local17 or 0
                    f23_local16.left = -f23_local1
                    f23_local16.right = 0
                    f23_local11(f23_local13, f23_local15, f23_local16)
                    f23_local10:animateToState("default")
                    self:addElement(f23_local10)
                    f23_local11 = LUI.UIImage.new()
                    f23_local11.id = "right"
                    f23_local15 = f23_local11
                    f23_local13 = f23_local11.registerAnimationState
                    f23_local16 = "default"
                    local f23_local18 = {
                        material = RegisterMaterial("white"),
                        topAnchor = true,
                        bottomAnchor = true,
                        leftAnchor = false,
                        rightAnchor = true,
                        top = -f23_local1
                    }
                    if not f23_local6 then
                        local f23_local19 = f23_local1
                    end
                    f23_local18.bottom = f23_local19 or 0
                    f23_local18.left = 0
                    f23_local18.right = f23_local1
                    f23_local13(f23_local15, f23_local16, f23_local18)
                    f23_local11:animateToState("default")
                    self:addElement(f23_local11)
                    self.colorize = function(f24_arg0, f24_arg1, f24_arg2, f24_arg3)
                        for f24_local3, f24_local4 in ipairs({f23_local9, f23_local11, f23_local10, f23_local8}) do
                            f24_local4:registerAnimationState("current", {
                                red = f24_arg0,
                                green = f24_arg1,
                                blue = f24_arg2,
                                alpha = f24_arg3
                            })
                            f24_local4:animateToState("current")
                        end
                    end

                    self.colorize(f23_local2, f23_local3, f23_local4, f23_local5)
                    self:registerEventHandler("updateBorderColor", function(self, event)
                        self.colorize(event.red, event.green, event.blue, event.alpha)
                    end)
                    return self
                end
            end
            f23_local13 = 0
        end
    end
    f23_local13 = 0
end

genericPopupMessageWidth = 300
genericPopupMessageHeight = 75
function generic_popup_message(menu, controller)
    local self = LUI.UIElement.new(CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    self.id = "generic_test_id"
    self.properties = {
        message_text = controller.message_text
    }
    self:addElement(LUI.MenuBuilder.BuildRegisteredType("generic_popup_screen_overlay"))
    local f26_local1 = CoD.CreateState(-200, -75, 200, nil, CoD.AnchorTypes.None)
    f26_local1.height = 85
    local f26_local2 = LUI.UIElement.new(f26_local1)
    f26_local2:addElement(LUI.MenuBuilder.BuildRegisteredType("live_dialog_popup_background"))
    f26_local2:addElement(LUI.DecoFrame.new(nil, LUI.DecoFrame.Green))
    local f26_local3 = CoD.CreateState(0, nil, 0, nil, CoD.AnchorTypes.LeftRight)
    f26_local3.height = CoD.TextSettings.PopupFont.Height
    f26_local3.font = CoD.TextSettings.PopupFont.Font
    f26_local3.alignment = LUI.Alignment.Center
    f26_local3.red = Colors.secondary_text_color.r
    f26_local3.green = Colors.secondary_text_color.g
    f26_local3.blue = Colors.secondary_text_color.b
    local f26_local4 = LUI.UIText.new(f26_local3)
    f26_local4:setText(controller.message_text)
    f26_local4.properties = {
        text = controller.message_text
    }
    f26_local2:addElement(f26_local4)
    self:addElement(f26_local2)
    return self
end

local f0_local4 = function()
    return {
        type = "UIElement",
        id = "spacer",
        states = {
            default = {
                leftAnchor = true,
                rightAnchor = true,
                topAnchor = true,
                bottomAnchor = false,
                left = 0,
                right = 0,
                top = 0,
                bottom = 12
            }
        }
    }
end
--[[ @ 0]]
local f0_local5 = function(f28_arg0, f28_arg1)
    f28_arg0:setText(f28_arg1.message_text)
    f28_arg0:dispatchEventToRoot({
        name = "resize_popup"
    })
end
--[[ @ 0]]
function generic_confirmation_popup(f29_arg0, f29_arg1)
    if not f29_arg1 then
        f29_arg1 = {}
    end
    local f29_local0 = f29_arg1.message_text_alignment
    if not f29_local0 then
        f29_local0 = LUI.Alignment.Left
    end
    f29_arg1.message_text_alignment = f29_local0
    f29_arg1.popup_title = f29_arg1.popup_title or ""
    f29_arg1.message_text = f29_arg1.message_text or ""
    f29_local0 = f29_arg1.button_text
    if not f29_local0 then
        f29_local0 = Engine.Localize("@MENU_EXIT")
    end
    f29_arg1.button_text = f29_local0
    f29_arg1.confirmation_action = f29_arg1.confirmation_action or function(f30_arg0, f30_arg1)
        DebugPrint("Running generic_confirmation_popup default action")
    end

    f29_arg1.callback_params = f29_arg1.callback_params or {}
    f29_arg1.padding_top = f29_arg1.padding_top or 12
    if f29_arg1.cancel_will_close == nil then
        f29_local0 = true
    else
        f29_local0 = f29_arg1.cancel_will_close
    end
    f29_arg1.cancel_will_close = f29_local0
    if f29_arg1.confirm_will_close == nil then
        f29_local0 = true
    else
        f29_local0 = f29_arg1.confirm_will_close
    end
    f29_arg1.confirm_will_close = f29_local0
    if f29_arg1.popup_childfeeder == nil then
        f29_arg1.popup_childfeeder = function(f31_arg0)
            return {{
                type = "UIText",
                id = "message_text_id",
                properties = {
                    text = MBh.Property("message_text"),
                    message_text_alignment = MBh.Property("message_text_alignment")
                },
                states = {
                    default = {
                        topAnchor = true,
                        bottomAnchor = false,
                        leftAnchor = true,
                        rightAnchor = true,
                        top = 0,
                        bottom = CoD.TextSettings.PopupFont.Height,
                        left = 12,
                        right = -12,
                        alignment = LUI.AdjustAlignmentForLanguage(f31_arg0.message_text_alignment),
                        font = CoD.TextSettings.PopupFont.Font,
                        color = Colors.h1.light_grey,
                        lineSpacingRatio = 0.2
                    }
                },
                handlers = {
                    update_message = f0_local5
                }
            }, f0_local4(), {
                type = "UIGenericButton",
                id = "exit_button_id",
                audio = {
                    button_over = CoD.SFX.SubMenuMouseOver
                },
                properties = {
                    confirmation_action = MBh.Property("confirmation_action"),
                    button_text = MBh.Property("button_text"),
                    confirm_will_close = MBh.Property("confirm_will_close"),
                    button_action_func = function(f32_arg0, f32_arg1)
                        local f32_local0 = function(f33_arg0, f33_arg1)
                            f33_arg0.properties:confirmation_action(f33_arg1)
                            if f33_arg0.properties.confirm_will_close then
                                LUI.FlowManager.RequestLeaveMenu(f33_arg0, nil, nil, f33_arg1.controller)
                            end
                        end

                        if f32_arg0.properties.parent_popup then
                            if f32_arg1 ~= nil then
                                f32_arg1.name = "close_popup"
                                f32_arg1.dispatchChildren = true
                            end
                            f32_arg0.properties.parent_popup:dispatchEventToChildren(f32_arg1)
                            f32_arg0:registerEventHandler("popup_closed", f32_local0)
                        else
                            f32_local0(f32_arg0, f32_arg1)
                        end
                    end,
                    callback_params = MBh.Property("callback_params"),
                    text_align_without_content = LUI.Alignment.Center,
                    parent_popup = nil
                }
            }}
        end

    end
    f29_local0 = LUI.MenuBuilder.BuildRegisteredType("generic_selectionList_popup", f29_arg1)
    f29_local0:registerAnimationState("default", CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    return f29_local0
end

function addLoadingAnimationWidget(f34_arg0, f34_arg1)
    local f34_local0 = CoD.CreateState(nil, -LoadingAnimationDims.Height / 2, nil, nil, CoD.AnchorTypes.TopLeftRight)
    f34_local0.height = LoadingAnimationDims.Height
    f34_local0.horizontalAlignment = LUI.HorizontalAlignment.Center
    f34_arg0.loadingAnimationContainer = LUI.UIElement.new(f34_local0)
    f34_arg0.loadingAnimationContainer.id = "animation_container"
    f34_arg0:addElement(f34_arg0.loadingAnimationContainer)
    f34_arg0.loadingAnimationContainer:addElement(LUI.MenuBuilder.BuildRegisteredType("loading_animation_widget"))
end

function generic_waiting_popup(f35_arg0, f35_arg1)
    if not f35_arg1 then
        f35_arg1 = {}
    end
    local f35_local0 = f35_arg1.message_text_alignment
    if not f35_local0 then
        f35_local0 = LUI.Alignment.Left
    end
    f35_arg1.message_text_alignment = f35_local0
    f35_arg1.popup_title = f35_arg1.popup_title or ""
    f35_local0 = f35_arg1.button_text
    if not f35_local0 then
        f35_local0 = Engine.Localize("@MENU_EXIT")
    end
    f35_arg1.button_text = f35_local0
    f35_arg1.confirmation_action = f35_arg1.confirmation_action or function(f36_arg0, f36_arg1)
        DebugPrint("Running generic_waiting_popup default action")
    end

    f35_arg1.callback_params = f35_arg1.callback_params or {}
    f35_arg1.padding_top = f35_arg1.padding_top or 12
    if f35_arg1.cancel_will_close == nil then
        f35_local0 = true
    else
        f35_local0 = f35_arg1.cancel_will_close
    end
    f35_arg1.cancel_will_close = f35_local0
    if f35_arg1.confirm_will_close == nil then
        f35_local0 = true
    else
        f35_local0 = f35_arg1.confirm_will_close
    end
    f35_arg1.confirm_will_close = f35_local0
    if f35_arg1.popup_childfeeder == nil then
        f35_arg1.popup_childfeeder = function(f37_arg0)
            return {{
                type = "UIElement",
                id = "loading_icon",
                states = {
                    default = {
                        topAnchor = true,
                        bottomAnchor = false,
                        leftAnchor = true,
                        rightAnchor = true,
                        top = 0,
                        bottom = CoD.TextSettings.PopupFont.Height
                    }
                },
                handlers = {
                    menu_create = addLoadingAnimationWidget
                }
            }, {
                type = "UIGenericButton",
                id = "exit_button_id",
                audio = {
                    button_over = CoD.SFX.SubMenuMouseOver
                },
                properties = {
                    confirmation_action = MBh.Property("confirmation_action"),
                    button_text = MBh.Property("button_text"),
                    confirm_will_close = MBh.Property("confirm_will_close"),
                    button_action_func = function(f38_arg0, f38_arg1)
                        local f38_local0 = function(f39_arg0, f39_arg1)
                            f39_arg0.properties:confirmation_action(f39_arg1)
                            if f39_arg0.properties.confirm_will_close then
                                LUI.FlowManager.RequestLeaveMenu(f39_arg0, nil, nil, f39_arg1.controller)
                            end
                        end

                        if f38_arg0.properties.parent_popup then
                            if f38_arg1 ~= nil then
                                f38_arg1.name = "close_popup"
                                f38_arg1.dispatchChildren = true
                            end
                            f38_arg0.properties.parent_popup:dispatchEventToChildren(f38_arg1)
                            f38_arg0:registerEventHandler("popup_closed", f38_local0)
                        else
                            f38_local0(f38_arg0, f38_arg1)
                        end
                    end,
                    callback_params = MBh.Property("callback_params"),
                    text_align_without_content = LUI.Alignment.Center,
                    parent_popup = nil
                }
            }}
        end

    end
    f35_local0 = LUI.MenuBuilder.BuildRegisteredType("generic_selectionList_popup", f35_arg1)
    f35_local0:registerAnimationState("default", CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    return f35_local0
end

function CreatePurchasePopupRow(f40_arg0, f40_arg1, f40_arg2, f40_arg3, f40_arg4)
    local f40_local0 = 15
    local f40_local1 = 16
    return {
        type = "UIHorizontalList",
        id = "yesno_message_" .. f40_arg0 .. "_hl_id",
        states = {
            default = {
                topAnchor = true,
                leftAnchor = true,
                bottomAnchor = false,
                rightAnchor = true,
                top = 0,
                left = 12 + f40_arg1,
                right = -32,
                height = CoD.TextSettings.TitleFontSmall.Height
            }
        },
        children = {{
            type = "UIText",
            id = "yesno_message_" .. f40_arg0 .. "_text_id",
            properties = {
                text = MBh.Property(f40_arg2)
            },
            states = {
                default = {
                    topAnchor = true,
                    leftAnchor = true,
                    bottomAnchor = false,
                    rightAnchor = true,
                    top = 0,
                    left = 0,
                    right = -(f40_local1 + 32 + f40_local0),
                    height = CoD.TextSettings.TitleFontSmall.Height,
                    font = CoD.TextSettings.TitleFontSmall.Font,
                    alignment = LUI.Alignment.Right,
                    red = Colors.primary_text_color.r,
                    green = Colors.primary_text_color.g,
                    blue = Colors.primary_text_color.b
                }
            }
        }, {
            type = "UIElement",
            id = "yesno_message_" .. f40_arg0 .. "_spacer",
            states = {
                default = {
                    topAnchor = true,
                    leftAnchor = true,
                    bottomAnchor = true,
                    rightAnchor = false,
                    top = 0,
                    left = 0,
                    width = f40_local0
                }
            }
        }, {
            type = "UIImage",
            id = "yesno_message_" .. f40_arg0 .. "_image_id",
            states = {
                default = {
                    topAnchor = false,
                    leftAnchor = false,
                    bottomAnchor = false,
                    rightAnchor = false,
                    top = -f40_local1 * 0.5,
                    left = -f40_local1 * 0.5,
                    bottom = f40_local1 * 0.5,
                    right = f40_local1 * 0.5,
                    material = f40_arg3
                }
            }
        }, {
            type = "UIText",
            id = "yesno_message_" .. f40_arg0 .. "_id",
            properties = {
                text = MBh.Property(f40_arg4)
            },
            states = {
                default = {
                    topAnchor = true,
                    leftAnchor = true,
                    bottomAnchor = false,
                    rightAnchor = true,
                    top = 0,
                    left = 0,
                    right = -12,
                    height = CoD.TextSettings.BodyFont.Height,
                    font = CoD.TextSettings.BodyFont.Font,
                    alignment = LUI.Alignment.Left,
                    red = Colors.white.r,
                    green = Colors.white.g,
                    blue = Colors.white.b
                }
            }
        }}
    }
end

function YesNoFeeder(f41_arg0)
    local f41_local0 = {}
    if not f41_arg0.message_image then
        f41_local0[#f41_local0 + 1] = {
            type = "UIText",
            id = "yesno_message_text_id",
            properties = {
                text = MBh.Property("message_text")
            },
            states = {
                default = {
                    topAnchor = true,
                    bottomAnchor = false,
                    leftAnchor = true,
                    rightAnchor = true,
                    top = 0,
                    bottom = CoD.TextSettings.PopupFont.Height,
                    left = 12,
                    right = -12,
                    font = CoD.TextSettings.PopupFont.Font,
                    color = Colors.h1.light_grey,
                    alignment = LUI.AdjustAlignmentForLanguage(f41_arg0.message_text_alignment),
                    spacing = 6,
                    lineSpacingRatio = 0.2
                }
            },
            handlers = {
                update_message = f0_local5
            }
        }
    else
        f41_local0[#f41_local0 + 1] = {
            type = "UIElement",
            id = "yesno_message_container_id",
            states = {
                default = {
                    topAnchor = true,
                    leftAnchor = true,
                    bottomAnchor = false,
                    rightAnchor = true,
                    top = 0,
                    left = 12,
                    right = -12,
                    height = 0
                }
            },
            children = {{
                type = "UIImage",
                id = "yesno_message_image_id",
                states = {
                    default = {
                        topAnchor = true,
                        leftAnchor = true,
                        bottomAnchor = false,
                        rightAnchor = false,
                        top = f41_arg0.message_image_top,
                        left = f41_arg0.message_image_left,
                        height = f41_arg0.message_image_height,
                        width = f41_arg0.message_image_width,
                        material = f41_arg0.message_image
                    }
                }
            }}
        }
        if f41_arg0.message_text then
            f41_local0[#f41_local0 + 1] = {
                type = "UIText",
                id = "yesno_message_text_id",
                properties = {
                    text = MBh.Property("message_text")
                },
                states = {
                    default = {
                        topAnchor = true,
                        leftAnchor = true,
                        bottomAnchor = false,
                        rightAnchor = true,
                        top = 0,
                        left = 12 + f41_arg0.message_image_width + 20,
                        right = -12,
                        height = CoD.TextSettings.PopupFont.Height,
                        font = CoD.TextSettings.PopupFont.Font,
                        alignment = LUI.AdjustAlignmentForLanguage(f41_arg0.message_text_alignment),
                        color = Colors.h1.light_grey,
                        lineSpacingRatio = 0.2
                    }
                }
            }
        else
            if f41_arg0.message_required_rank_image then
                f41_local0[#f41_local0 + 1] = CreatePurchasePopupRow("required_rank", f41_arg0.message_image_width,
                    "message_required_rank_text", f41_arg0.message_required_rank_image, "message_required_rank")
                f41_local0[#f41_local0 + 1] = CreatePurchasePopupRow("current_rank", f41_arg0.message_image_width,
                    "message_current_rank_text", f41_arg0.message_current_rank_image, "message_current_rank")
                f41_local0[#f41_local0 + 1] = {
                    type = "UIElement",
                    id = "yesno_message_separator_container_id",
                    states = {
                        default = {
                            topAnchor = true,
                            leftAnchor = false,
                            bottomAnchor = false,
                            rightAnchor = true,
                            top = 0,
                            right = 0,
                            height = 5,
                            width = 300
                        }
                    },
                    children = {{
                        type = "UIImage",
                        id = "yesno_message_separator_image_id",
                        states = {
                            default = {
                                topAnchor = true,
                                leftAnchor = true,
                                bottomAnchor = false,
                                rightAnchor = true,
                                top = 2,
                                left = 0,
                                height = 1,
                                material = RegisterMaterial("white"),
                                alpha = 0.1
                            }
                        }
                    }}
                }
            end
            if f41_arg0.message_cost_image then
                f41_local0[#f41_local0 + 1] = CreatePurchasePopupRow("cost", f41_arg0.message_image_width,
                    "message_cost_text", f41_arg0.message_cost_image, "message_cost")
                f41_local0[#f41_local0 + 1] = CreatePurchasePopupRow("squad_points", f41_arg0.message_image_width,
                    "message_squad_points_text", f41_arg0.message_squad_points_image, "message_squad_points")
            end
        end
    end
    f41_local0[#f41_local0 + 1] = f0_local4()
    if f41_arg0.yes_text then
        f41_local0[#f41_local0 + 1] = {
            type = "UIGenericButton",
            id = "yes_button_id",
            audio = {
                button_over = CoD.SFX.SubMenuMouseOver
            },
            properties = {
                yes_action = MBh.Property("yes_action"),
                button_text = MBh.Property("yes_text"),
                button_action_func = function(f42_arg0, f42_arg1)
                    local f42_local0 = function(f43_arg0, f43_arg1)
                        f43_arg0.properties:yes_action(f43_arg1)
                        LUI.FlowManager.RequestLeaveMenu(f43_arg0)
                    end

                    if f42_arg0.properties.parent_popup then
                        if f42_arg1 ~= nil then
                            f42_arg1.name = "close_popup"
                            f42_arg1.dispatchChildren = true
                        end
                        f42_arg0.properties.parent_popup:dispatchEventToChildren(f42_arg1)
                        f42_arg0:registerEventHandler("popup_closed", f42_local0)
                    else
                        f42_local0(f42_arg0, f42_arg1)
                    end
                end,
                callback_params = MBh.Property("callback_params"),
                text_align_without_content = LUI.Alignment.Center,
                fade_in = GenericPopupAnimationSettings.Buttons.DelayIn,
                parent_popup = nil
            }
        }
    end
    f41_local0[#f41_local0 + 1] = {
        type = "UIGenericButton",
        id = "no_button_id",
        audio = {
            button_over = CoD.SFX.SubMenuMouseOver
        },
        properties = {
            no_action = MBh.Property("no_action"),
            button_text = MBh.Property("no_text"),
            button_action_func = function(f44_arg0, f44_arg1)
                local f44_local0 = function(f45_arg0, f45_arg1)
                    f45_arg0.properties:no_action(f45_arg1)
                    LUI.FlowManager.RequestLeaveMenu(f45_arg0)
                end

                if f44_arg0.properties.parent_popup then
                    if f44_arg1 ~= nil then
                        f44_arg1.name = "close_popup"
                        f44_arg1.dispatchChildren = true
                    end
                    f44_arg0.properties.parent_popup:dispatchEventToChildren(f44_arg1)
                    f44_arg0:registerEventHandler("popup_closed", f44_local0)
                else
                    f44_local0(f44_arg0, f44_arg1)
                end
            end,
            callback_params = MBh.Property("callback_params"),
            text_align_without_content = LUI.Alignment.Center,
            fade_in = GenericPopupAnimationSettings.Buttons.DelayIn,
            parent_popup = nil
        }
    }
    if f41_arg0.default_focus_index then
        local f41_local1 = assert
        local f41_local2
        if f41_arg0.default_focus_index <= 0 or f41_arg0.default_focus_index > #f41_local0 then
            f41_local2 = false
        else
            f41_local2 = true
        end
        f41_local1(f41_local2)
        f41_local1 = #f41_local0 - 2
        f41_local0[#f41_local0 - 2 + f41_arg0.default_focus_index].listDefaultFocus = true
    end
    return f41_local0
end

function generic_yesno_popup(f46_arg0, f46_arg1)
    if not f46_arg1 then
        f46_arg1 = {}
    end
    local f46_local0 = f46_arg1.message_text_alignment
    if not f46_local0 then
        f46_local0 = LUI.Alignment.Left
    end
    f46_arg1.message_text_alignment = f46_local0
    f46_arg1.popup_title = f46_arg1.popup_title or ""
    f46_arg1.message_text = f46_arg1.message_text or ""
    f46_arg1.padding_top = f46_arg1.padding_top or 25
    if f46_arg1.cancel_means_no == nil then
        f46_local0 = true
    else
        f46_local0 = false
    end
    f46_arg1.cancel_means_no = f46_local0
    f46_arg1.yes_action = f46_arg1.yes_action or function(f47_arg0, f47_arg1)
        DebugPrint("Running generic_confirmation_popup yes action")
    end

    f46_arg1.no_action = f46_arg1.no_action or function(f48_arg0, f48_arg1)
        DebugPrint("Running generic_confirmation_popup no action")
    end

    f46_local0 = f46_arg1.yes_text
    if not f46_local0 then
        f46_local0 = Engine.Localize("@LUA_MENU_YES")
    end
    f46_arg1.yes_text = f46_local0
    f46_local0 = f46_arg1.no_text
    if not f46_local0 then
        f46_local0 = Engine.Localize("@LUA_MENU_NO")
    end
    f46_arg1.no_text = f46_local0
    f46_arg1.callback_params = f46_arg1.callback_params or {}
    f46_arg1.default_focus_index = f46_arg1.default_focus_index or 2
    f46_arg1.popup_childfeeder = f46_arg1.popup_childfeeder or YesNoFeeder
    f46_local0 = f46_arg1.popup_list_spacing
    if not f46_local0 then
        f46_local0 = H1MenuDims.spacing
    end
    f46_arg1.popup_list_spacing = f46_local0
    f46_local0 = LUI.MenuBuilder.BuildRegisteredType("generic_selectionList_popup", f46_arg1)
    f46_local0:registerAnimationState("default", CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    f46_local0:registerEventHandler("popup_back", function(element, event)
        if f46_arg1.cancel_means_no then
            f46_arg1.no_action(element, event)
        elseif f46_arg1.cancel_action then
            f46_arg1.cancel_action(element, event)
        end
    end)
    f46_local0:registerEventHandler("menu_create", function(element, event)
        element:clearSavedState()
    end)
    return f46_local0
end

local f0_local6 = function(f51_arg0, f51_arg1, f51_arg2, f51_arg3, f51_arg4, f51_arg5)
    local f51_local0 = 30
    if f51_arg0:getRect() then
        local f51_local1 = GenericTitleBarDims.TitleBarHeight + f51_arg3 + f51_arg4 + f51_arg5 *
                               (f51_arg1:getNumChildren() - 1)
        local f51_local2 = f51_arg1:getFirstChild()
        while f51_local2 do
            local f51_local3 = nil
            if f51_local2.getText and f51_local2:getText() then
                local f51_local4 = nil
                f51_local4, f51_local3 = f51_local2:getElementTextDims()
            else
                f51_local3 = f51_local2:getHeight()
            end
            f51_local1 = f51_local1 + f51_local3
            f51_local2 = f51_local2:getNextSibling()
        end
        local f51_local3 = {
            topAnchor = false,
            bottomAnchor = false,
            leftAnchor = false,
            rightAnchor = false,
            left = -f51_arg2 / 2,
            right = f51_arg2 / 2,
            top = -(f51_local1 / 2 + f51_local0),
            bottom = f51_local1 / 2 - f51_local0,
            alpha = 1
        }
        f51_arg0:registerAnimationState("final_state", f51_local3)
        f51_local3.alpha = 0
        f51_arg0:registerAnimationState("start_state", f51_local3)
        f51_arg0:registerAnimationState("wait", f51_local3)
        f51_arg0:animateInSequence({{"start_state", 0}, {"final_state", 0, true, true}}, nil, true, true)
    else
        f51_arg0:animateToState("start", 1)
    end
end
--[[ @ 0]]
function AddDarken(f52_arg0)
    f52_arg0:addElement(LUI.UIImage.new({
        topAnchor = true,
        leftAnchor = true,
        bottomAnchor = true,
        rightAnchor = true,
        material = RegisterMaterial("black"),
        alpha = 0.5,
        color = Colors.white
    }))
end

function generic_popup_screen_overlay(f53_arg0)
    local f53_local0 = f53_arg0 or {}
    local self = LUI.UIImage.new({
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        material = RegisterMaterial("h1_popup_dark_vignetting")
    })
    self.id = "generic_popup_screen_overlay_blur"
    self:setupFullWindowElement()
    return self
end

LUI.MenuGenerics.InAnim = function(f54_arg0)
    f54_arg0.backgroundBorder:animateInSequence({{"default", 67}, {"default", 66}, {"border_dimmed", 33},
                                                 {"default", 33}, {"border_dimmed", 33}, {"default", 33}})
    f54_arg0.background:animateInSequence({{"default", 67}})
    f54_arg0.titleText:animateInSequence({{"hidden", GenericPopupAnimationSettings.Window.DelayIn},
                                          {"default", GenericPopupAnimationSettings.Window.DurationIn}})
    f54_arg0.title:animateInSequence({{"default", 67}, {"default", 66}, {"title_dimmed", 33}, {"default", 33},
                                      {"title_dimmed", 33}, {"default", 33}})
end
--[[ @ 0]]
LUI.MenuGenerics.OutAnim = function(f55_arg0)
    f55_arg0.backgroundBorder:animateInSequence({{"hidden", 67}})
    f55_arg0.background:animateInSequence({{"hidden", 67}})
    f55_arg0.titleText:animateInSequence({{"hidden", GenericPopupAnimationSettings.Window.DurationOut}})
    f55_arg0.title:animateInSequence({{"hidden", 67}})
end

--[[ @ 0]]
function generic_selectionList_popup(f57_arg0, f57_arg1)
    f57_arg1.paddingBottom = f57_arg1.padding_bottom or 11
    f57_arg1.paddingRight = f57_arg1.padding_right or 11
    f57_arg1.paddingLeft = f57_arg1.padding_left or 11
    f57_arg1.paddingTop = f57_arg1.padding_top or 11
    local f57_local0 = f57_arg1.popup_title_alignment
    if not f57_local0 then
        f57_local0 = LUI.AdjustAlignmentForLanguage(LUI.Alignment.Left)
    end
    f57_arg1.titleAlign = f57_local0
    f57_local0 = f57_arg1.titleAlign
    local f57_local1 = LUI.Alignment.Left
    f57_arg1.titleBarTextIndent = REG23 and 12 or 0
    f57_arg1.title = Engine.ToUpperCase(f57_arg1.popup_title) or "popup_title property"
    if f57_arg1.cancel_will_close ~= nil then
        f57_local0 = f57_arg1.cancel_will_close
    else
        f57_local0 = true
    end
    f57_arg1.cancel_will_close = f57_local0
    f57_arg1.titleFont = CoD.TextSettings.TitleFontSmaller
    f57_local0 = f57_arg1.popup_list_spacing
    if not f57_local0 then
        f57_local0 = H1MenuDims.spacing
    end
    f57_arg1.listSpacing = f57_local0
    local f57_local0, f57_local1, f57_local2, f57_local3 = GetTextDimensions(f57_arg1.title, f57_arg1.titleFont.Font,
        f57_arg1.titleFont.Height)
    local self = f57_arg1.popup_width
    if not self then
        self = LUI.clamp(f57_local2 - f57_local0 + 60, GenericPopupDims.Width, 1200)
    end
    f57_arg1.width = self
    self = LUI.UIElement.new()
    self:registerAnimationState("default", {
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = 0,
        right = 0
    })
    self:animateToState("default")
    local f57_local5 = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    f57_local5.alpha = 1
    local f57_local6 = LUI.UIElement.new(f57_local5)
    f57_local6.id = "generic_selectionList_intermediate"
    f57_local6:registerAnimationState("default", f57_local5)
    f57_local6:registerAnimationState("hidden", {
        alpha = 0
    })
    f57_local6:registerEventHandler("gain_focus", function(element, event)
        if event.focusType ~= FocusType.MouseOver then
            element:animateToState("default")
        end
        element:dispatchEventToChildren(event)
    end)
    f57_local6:registerEventHandler("restore_focus", function(element, event)
        element:animateToState("default")
    end)
    f57_local6:registerEventHandler("lose_focus", function(element, event)
        if event.focusType ~= FocusType.MouseOver then
            element:animateToState("hidden")
        end
        element:dispatchEventToChildren(event)
    end)
    self:addElement(f57_local6)
    f57_local6:addElement(generic_popup_screen_overlay())
    local f57_local7 = LUI.UIElement.new()
    f57_local7.id = "generic_selectionList_window_id"
    f57_local7:registerAnimationState("default", {
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = false,
        rightAnchor = false,
        left = -f57_arg1.width / 2,
        right = f57_arg1.width / 2,
        top = 0,
        bottom = 0,
        alpha = 0
    })
    f57_local7:registerAnimationState("start", {
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = false,
        rightAnchor = false,
        left = -f57_arg1.width / 2,
        right = f57_arg1.width / 2,
        top = 0,
        bottom = 0,
        alpha = 0
    })
    f57_local7:animateToState("default")
    f57_local7:animateToState("start", 1)
    f57_local6:addElement(f57_local7)
    f57_local7:addElement(LUI.MenuGenerics.new(self, f57_arg1))
    local f57_local8 = LUI.UIVerticalList.new()
    f57_local8.id = "generic_selectionList_content_id"
    f0_local1(f57_local8, {
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        left = f57_arg1.paddingLeft,
        right = -f57_arg1.paddingRight,
        top = GenericTitleBarDims.TitleBarHeight + f57_arg1.paddingTop,
        bottom = -f57_arg1.paddingBottom,
        spacing = f57_arg1.listSpacing,
        alpha = 1
    }, GenericPopupAnimationSettings.Window.DelayIn, GenericPopupAnimationSettings.Window.DurationIn,
        GenericPopupAnimationSettings.Window.DelayOut, GenericPopupAnimationSettings.Window.DurationOut)
    f57_local7:addElement(f57_local8)
    local f57_local9 = function(f61_arg0, f61_arg1)
        f0_local6(f61_arg0, f57_local8, f57_arg1.width, f57_arg1.paddingTop, f57_arg1.paddingBottom,
            f57_arg1.listSpacing)
    end

    f57_local7:addEventHandler("menu_create", f57_local9)
    f57_local7:addEventHandler("resize_popup", f57_local9)
    f57_local7:addEventHandler("transition_step_complete_final_state", function(f62_arg0, f62_arg1)
        Engine.PlaySound(CoD.SFX.PopupAppears)
    end)
    f57_local7:registerEventHandler("close_popup", function(element, event)
        if f57_local7.animOutTimer == nil then
            local self = LUI.UITimer.new(66, "wait_for_anim_end")
            self.id = "timer_wait_for_anim_end"
            self.loop = false
            f57_local7.animOutTimer = self
            f57_local7:addElement(self)
            f57_local7:registerEventHandler("wait_for_anim_end", function(element, event)
                if event ~= nil then
                    event.name = "popup_closed"
                end
                self:dispatchEventToChildren(event)
            end)
        end
    end)
    f57_local7:addEventHandler("transition_complete_start", f57_local9)
    local f57_local10 = f57_arg1.popup_childfeeder or function()
        return {}
    end

    if type(f57_local10) == "table" and f57_local10.isProperty then
        f57_local10 = f57_local10.func(f57_arg1)
    end
    assert(type(f57_local10) == "function", "Feeders must be a function or referenced by the MBh.Property helper")
    local f57_local11 = f57_local10(f57_arg1)
    f57_local8.childrenFeeder = f57_local10
    if f57_local11 then
        for f57_local15, f57_local16 in ipairs(f57_local11) do
            if f57_local16.type == "UIGenericButton" then
                f57_local16.properties.parent_popup = self
                f57_local16.properties.muteAction = f57_arg1.muteAction
            end
        end
        LUI.MenuBuilder.buildChildren(f57_local8, f57_arg1, f57_local11)
    end
    local f57_local12 = LUI.UIBindButton.new()
    f57_local12.id = "generic_selectionList_back_id"
    f57_local12:registerEventHandler("button_secondary", function(element, event)
        if f57_arg1.cancel_will_close then
            if event ~= nil then
                event.name = "close_popup"
                event.dispatchChildren = true
            end
            self:dispatchEventToChildren(event)
            element:registerEventHandler("popup_closed", function(element, event)
                self:processEvent({
                    name = "popup_back",
                    controller = event.controller
                })
                LUI.FlowManager.RequestLeaveMenu(element)
            end)
        else
            self:processEvent({
                name = "popup_back",
                controller = event.controller
            })
        end
    end)
    self:addElement(f57_local12)
    return self
end

function DebugMessageBox(f68_arg0, f68_arg1, f68_arg2, f68_arg3)
    if not f68_arg1 or f68_arg1 == -1 then
        f68_arg1 = Engine.GetFirstActiveController()
    end
    if not f68_arg2 then
        f68_arg2 = ""
    end
    if not f68_arg3 then
        f68_arg3 = ""
    end
    Engine.ExecNow("set LUIDebugMessageBoxTitle " .. f68_arg2)
    Engine.ExecNow("set LUIDebugMessageBoxMessage " .. f68_arg3)
    LUI.FlowManager.RequestAddMenu(f68_arg0, "generic_debugMessageBox_popup", true, f68_arg1, false)
end

function generic_debugMessageBox_popup(f69_arg0, f69_arg1)
    return LUI.MenuBuilder.BuildRegisteredType("generic_confirmation_popup", {
        popup_title = Engine.GetDvarString("LUIDebugMessageBoxTitle"),
        message_text = Engine.GetDvarString("LUIDebugMessageBoxMessage"),
        button_text = Engine.Localize("@MENU_OK")
    })
end

function generic_menu_background(f70_arg0, f70_arg1)
    if not f70_arg1 then
        f70_arg1 = {}
    end
    local f70_local0 = f70_arg1.bottom_offset or 0
    local f70_local1 = f70_arg1.top_offset
    if not f70_local1 then
        f70_local1 = GenericTitleBarDims.TitleBarHeight
    end
    local self = LUI.UIBackgroundPanel.new(nil, f70_arg1)
    self.id = "generic_menu_background"
    self:registerAnimationState("default", {
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = f70_local1,
        bottom = -f70_local0,
        left = 0,
        right = 0
    })
    self:animateToState("default")
    return self
end

function generic_menu_titlebar_background(f71_arg0, f71_arg1)
    local f71_local0 = CoD.CreateState(0, 0, 0, GenericTitleBarDims.TitleBarHeight, CoD.AnchorTypes.TopLeftRight)
    f71_local0.material = RegisterMaterial("h2_popup_title_bg")
    f71_local0.alpha = 0.6
    local self = LUI.UIImage.new(f71_local0)
    self.id = "generic_menu_titlebar_background_id"
    return self
end

local f0_local7 = function(f72_arg0, f72_arg1)
    f72_arg0:setText(f72_arg1.title_text)
end
--[[ @ 0]]
function generic_menu_titlebar(f73_arg0, f73_arg1)
    local f73_local0 = f73_arg1.title_bar_text_indent
    if not f73_local0 then
        f73_local0 = GenericTitleBarDims.TitleBarLCapWidth
    end
    local f73_local1 = f73_arg1.title_bar_alignment
    if not f73_local1 then
        f73_local1 = LUI.Alignment.Left
    end
    local f73_local2 = f73_arg1.title_bar_text or ""
    local f73_local3 = f73_arg1.font
    if not f73_local3 then
        f73_local3 = CoD.TextSettings.TitleFontSmaller
    end
    local f73_local4 = f73_arg1.vertOffset or 2
    local f73_local5 = f73_arg1.color
    if not f73_local5 then
        f73_local5 = Colors.white
    end
    local self = LUI.UIElement.new(CoD.CreateState(0, 0, 0, GenericTitleBarDims.TitleBarHeight,
        CoD.AnchorTypes.TopLeftRight, {
            alpha = 1
        }))
    self:animateToState("default")
    self:addElement(generic_menu_titlebar_background(nil, f73_arg1))
    local f73_local7 = LUI.UIText.new()
    f73_local7.id = "title"
    f73_local7:setText(f73_local2)
    f0_local1(f73_local7, {
        topAnchor = false,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = true,
        top = -f73_local3.Height / 2 + f73_local4,
        height = f73_local3.Height,
        left = f73_local0,
        right = -f73_local0,
        font = f73_local3.Font,
        color = f73_local5,
        alignment = f73_local1,
        alpha = 1
    }, GenericPopupAnimationSettings.Title.DelayIn, GenericPopupAnimationSettings.Title.DurationIn)
    f73_local7:registerEventHandler("update_title", f0_local7)
    self:addElement(f73_local7)
    return self
end

function h1_option_menu_titlebar(f74_arg0, f74_arg1)
    if f74_arg1 == nil then
        f74_arg1 = {}
    end
    local f74_local0 = f74_arg1.title_bar_text_indent
    if not f74_local0 then
        f74_local0 = GenericTitleBarDims.TitleBarLCapWidth
    end
    local f74_local1 = f74_arg1.title_bar_alignment
    if not f74_local1 then
        f74_local1 = LUI.Alignment.Left
    end
    local f74_local2 = f74_arg1.title_bar_text or ""
    local f74_local3 = f74_arg1.font
    if not f74_local3 then
        f74_local3 = CoD.TextSettings.BodyFont24
    end
    local self = LUI.UIElement.new()
    self.id = "title_base_id"
    self:registerAnimationState("default", {
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        height = H1MenuDims.popupTitleBgHeight,
        left = 0,
        right = 0
    })
    self:animateToState("default")
    local f74_local5 = LUI.UIImage.new()
    f74_local5.id = "title_bg_id"
    f74_local5:registerAnimationState("default", {
        topAnchor = false,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = false,
        top = -3,
        height = 1,
        left = f74_local0,
        right = 30,
        material = RegisterMaterial("h2_deco_option_title"),
        alpha = 0.5
    })
    f74_local5:animateToState("default")
    self:addElement(f74_local5)
    local f74_local6 = LUI.UIText.new()
    f74_local6.id = "title_text_id"
    f74_local6:setText(f74_local2)
    f74_local6:registerAnimationState("default", {
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = true,
        top = H1MenuDims.popupTitleTextTopOffset,
        height = H1MenuDims.popupTitleBgFontHeight,
        left = f74_local0,
        right = -f74_local0,
        font = f74_local3.Font,
        alignment = f74_local1
    })
    f74_local6:animateToState("default")
    f74_local6:registerEventHandler("update_title", f0_local7)
    self:addElement(f74_local6)
    return self
end

function RefreshScrollList(f75_arg0, f75_arg1)
    f75_arg0:closeChildren()
    f75_arg0:clearSavedState()
    f75_arg0:processEvent({
        name = "menu_refresh"
    })
end

function generic_loading_widget(f76_arg0, f76_arg1)
    if not f76_arg1 then
        f76_arg1 = {}
    end
    local f76_local0 = f76_arg1.indent
    local f76_local1 = f76_arg1.message or ""
    local self = LUI.UIElement.new(f76_arg1.defaultAnimState)
    self.id = "generic_loading_widget"
    self:registerAnimationState("default", {
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = 0,
        right = 0
    })
    self:animateToState("default")
    local f76_local3 = LUI.UIHorizontalList.new()
    f76_local3:registerAnimationState("default", {
        topAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 0,
        bottom = 0,
        left = 0,
        right = 0,
        alignment = LUI.Alignment.Center,
        spacing = f76_local0
    })
    f76_local3:animateToState("default")
    self:addElement(f76_local3)
    local f76_local4 = f76_local3:addElement(LUI.MenuBuilder.BuildRegisteredType("loading_animation_widget"))
    if #f76_local1 > 0 then
        local f76_local5, f76_local6, f76_local7, f76_local8 = GetTextDimensions(f76_local1,
            CoD.TextSettings.NormalFont.Font, CoD.TextSettings.NormalFont.Height)
        local f76_local9 = LUI.UIText.new()
        f76_local9:setText(f76_local1)
        f76_local9:registerAnimationState("default", {
            font = CoD.TextSettings.NormalFont.Font,
            alignment = LUI.Alignment.Left,
            topAnchor = false,
            bottomAnchor = false,
            leftAnchor = true,
            rightAnchor = false,
            top = -CoD.TextSettings.NormalFont.Height / 2,
            bottom = CoD.TextSettings.NormalFont.Height / 2,
            left = 0,
            right = f76_local7 - f76_local5
        })
        f76_local9:animateToState("default")
        f76_local3:addElement(f76_local9)
    end
    return self
end

function generic_highlight(f77_arg0, f77_arg1)
    if not f77_arg1 then
        f77_arg1 = {}
    end
    local self = LUI.UIElement.new({
        leftAnchor = true,
        rightAnchor = true,
        topAnchor = true,
        bottomAnchor = true,
        alpha = 0
    })
    local f77_local1 = 0.6
    local f77_local2 = LUI.UIImage.new({
        leftAnchor = true,
        rightAnchor = true,
        topAnchor = true,
        bottomAnchor = true,
        left = -12,
        right = 12,
        top = -12,
        bottom = 12,
        material = RegisterMaterial("s1_9slice_highlight")
    })
    f77_local2:setup9SliceImage()
    f77_local2:setTileHorizontally(false)
    f77_local2:setTileVertically(false)
    self:addElement(f77_local2)
    self.id = "generic_highlight"
    self:registerAnimationState("visible", {
        alpha = f77_local1
    })
    local f77_local3 = GenericButtonSettings.Common.visual_focus_animation_duration or 0
    self:registerEventHandler("button_over", function(self, event)
        self:animateToState("visible")
    end)
    self:registerEventHandler("button_up", function(self, event)
        self:animateToState("default", f77_local3, true)
    end)
    self:registerEventHandler("button_over_disable", function(self, event)
        self:animateToState("visible")
    end)
    self:registerEventHandler("button_disable", function(self, event)
        self:animateToState("default", f77_local3, true)
    end)
    return self
end

function GetRandValue(f82_arg0, f82_arg1)
    if not f82_arg0 then
        return f82_arg1 or 0
    elseif type(f82_arg0) == "table" then
        if #f82_arg0 == 2 and type(f82_arg0[1]) == "number" then
            return math.random(0, 1000) / 1000 * (f82_arg0[2] - f82_arg0[1]) + f82_arg0[1]
        else
            return f82_arg0[math.random(1, #f82_arg0)]
        end
    else
        return f82_arg0
    end
end

function TryCopyField(f83_arg0, f83_arg1, f83_arg2)
    if f83_arg2[f83_arg0] then
        f83_arg1[f83_arg0] = GetRandValue(f83_arg2[f83_arg0])
    end
end

function TryOffsetCopyField(f84_arg0, f84_arg1, f84_arg2)
    local f84_local0 = f84_arg0 .. "Offset"
    if f84_arg2[f84_local0] then
        if f84_arg1[f84_arg0] == nil then
            f84_arg1[f84_arg0] = 0
        end
        f84_arg1[f84_arg0] = f84_arg1[f84_arg0] + GetRandValue(f84_arg2[f84_local0])
    end
end

function TryRatioCopyField(f85_arg0, f85_arg1, f85_arg2, f85_arg3)
    if f85_arg2[f85_arg0] then
        if f85_arg1[f85_arg0] == nil then
            f85_arg1[f85_arg0] = 0
        end
        f85_arg1[f85_arg0] = f85_arg1[f85_arg0] + (GetRandValue(f85_arg2[f85_arg0]) - f85_arg1[f85_arg0]) * f85_arg3
    end
end

function TryRatioOffsetCopyField(f86_arg0, f86_arg1, f86_arg2, f86_arg3)
    local f86_local0 = f86_arg0 .. "Offset"
    if f86_arg2[f86_local0] then
        if f86_arg1[f86_arg0] == nil then
            f86_arg1[f86_arg0] = 0
        end
        f86_arg1[f86_arg0] = f86_arg1[f86_arg0] + GetRandValue(f86_arg2[f86_local0]) * f86_arg3
    end
end

local f0_local8 = {"left", "top", "width", "height", "alpha", "zRot"}
function CreateSingleState(f87_arg0, f87_arg1, f87_arg2, f87_arg3, f87_arg4)
    for f87_local3, f87_local4 in ipairs(f0_local8) do
        TryRatioCopyField(f87_local4, f87_arg0, f87_arg3, f87_arg1)
        TryRatioOffsetCopyField(f87_local4, f87_arg0, f87_arg3, f87_arg1)
        TryCopyField(f87_local4, f87_arg0, f87_arg2)
        TryOffsetCopyField(f87_local4, f87_arg0, f87_arg2)
    end
    if f87_arg2.scale then
        f87_arg0.scale = GetRandValue(f87_arg2.scale) * f87_arg4.scaleMultiplier + f87_arg4.scaleAdditive
    end
    return f87_arg0
end

function RegisterAnimimationState(f88_arg0, f88_arg1, f88_arg2, f88_arg3, f88_arg4)
    local f88_local0 = {}
    local f88_local1 = 0
    local f88_local2 = {}
    for f88_local9, f88_local10 in ipairs(f88_arg1.persistentState) do
        for f88_local6, f88_local7 in ipairs(f0_local8) do
            TryCopyField(f88_local7, f88_local2, f88_local10)
            TryOffsetCopyField(f88_local7, f88_local2, f88_local10)
        end
    end
    if f88_arg4 == 0 then
        f88_arg4 = 1
    end
    for f88_local9, f88_local10 in ipairs(f88_arg1.states) do
        local f88_local11 = LUI.DeepCopy(f88_arg2)
        f88_local1 = f88_local1 + f88_local10.duration
        f88_arg0:registerAnimationState("animateState" .. f88_local9, CreateSingleState(f88_local11,
            f88_local1 / f88_arg4, f88_local10, f88_local2, f88_arg3))
        f88_local0[#f88_local0 + 1] = {"animateState" .. f88_local9, f88_local10.nextTotalDuration}
    end
    return f88_local0
end

function RegisterSimulatedAnimimationState(f89_arg0, f89_arg1, f89_arg2, f89_arg3, f89_arg4, f89_arg5)
    local f89_local0 = {}
    local f89_local1 = 0
    local f89_local2 = {}
    for f89_local9, f89_local10 in ipairs(f89_arg1.persistentState) do
        for f89_local6, f89_local7 in ipairs(f0_local8) do
            TryCopyField(f89_local7, f89_local2, f89_local10)
            TryOffsetCopyField(f89_local7, f89_local2, f89_local10)
        end
    end
    if f89_arg4 == 0 then
        f89_arg4 = 1
    end
    f89_local3 = 1
    f89_local4 = LUI.DeepCopy(f89_arg2)
    f89_local5 = nil
    f89_local9 = 1
    f89_local10 = 1
    for f89_local6, f89_local7 in ipairs(f89_arg1.states) do
        f89_local1 = f89_local1 + f89_local7.duration
        f89_local9 = f89_local10
        f89_local10 = f89_local1 / f89_arg4
        if f89_arg5 and 0 < f89_arg5 then
            f89_arg5 = f89_arg5 - f89_local7.duration
            if f89_arg5 < 0 then
                local f89_local13 = 1 - f89_arg5 / f89_local7.duration * -1
                local f89_local14 = (f89_local1 + f89_arg5) / f89_arg4
                local f89_local15 = CreateSingleState(LUI.DeepCopy(f89_arg2), f89_local10, f89_local7, f89_local2,
                    f89_arg3)
                local f89_local16 = LUI.DeepCopy(f89_arg2)
                if f89_local5 ~= nil then
                    f89_local16 = CreateSingleState(f89_local16, f89_local9, f89_local5, f89_local2, f89_arg3)
                end
                for f89_local20, f89_local21 in ipairs(f0_local8) do
                    TryRatioCopyField(f89_local21, f89_local16, f89_local15, f89_local13)
                    TryRatioOffsetCopyField(f89_local21, f89_local16, f89_local15, f89_local13)
                end
                f89_arg0:registerAnimationState("animateState" .. f89_local3, f89_local16)
                f89_local0[#f89_local0 + 1] = {"animateState" .. f89_local3, 0}
                f89_local3 = f89_local3 + 1
                f89_arg0:registerAnimationState("animateState" .. f89_local3, CreateSingleState(LUI.DeepCopy(f89_arg2),
                    f89_local10, f89_local7, f89_local2, f89_arg3))
                f89_local0[#f89_local0 + 1] = {"animateState" .. f89_local3, f89_arg5 * -1}
                f89_local3 = f89_local3 + 1
            end
            f89_local5 = LUI.DeepCopy(f89_local7)
        end
        f89_arg0:registerAnimationState("animateState" .. f89_local3, CreateSingleState(LUI.DeepCopy(f89_arg2),
            f89_local10, f89_local7, f89_local2, f89_arg3))
        f89_local0[#f89_local0 + 1] = {"animateState" .. f89_local3, f89_local7.nextTotalDuration}
        f89_local3 = f89_local3 + 1
    end
    return f89_local0
end

function GenerateStatesDuration(f90_arg0, f90_arg1)
    local f90_local0 = 0
    for f90_local4, f90_local5 in ipairs(f90_arg0) do
        f90_local5.nextTotalDuration = GetRandValue(f90_local5.duration) * f90_arg1
        f90_local0 = f90_local0 + f90_local5.nextTotalDuration
    end
    return f90_local0
end

function CreateAnimatedHuds(f91_arg0, f91_arg1, f91_arg2, f91_arg3)
    for f91_local9, f91_local10 in ipairs(f91_arg1.hudlist) do
        local f91_local7 = nil
        local f91_local11 = GetRandValue(f91_local10.left)
        local f91_local12 = GetRandValue(f91_local10.top)
        local f91_local13 = GetRandValue(f91_local10.width)
        local f91_local14 = GetRandValue(f91_local10.height)
        local f91_local15 = {
            durationMultiplier = GetRandValue(f91_local10.durationMultiplier, 1),
            scaleMultiplier = GetRandValue(f91_local10.scaleMultiplier, 1),
            scaleAdditive = GetRandValue(f91_local10.scaleAdditive, 0)
        }
        local f91_local4 = CoD.CreateState
        local f91_local5, f91_local6, f91_local8, f91_local16 = nil
        local f91_local3 = f91_local10.anchor
        if not f91_local3 then
            f91_local3 = CoD.AnchorTypes.TopLeft
        end
        f91_local4 = f91_local4(f91_local5, f91_local6, f91_local8, f91_local16, f91_local3)
        f91_local4.left = GetRandValue(f91_local10.left)
        f91_local4.top = GetRandValue(f91_local10.top)
        f91_local4.width = GetRandValue(f91_local10.width)
        f91_local4.height = GetRandValue(f91_local10.height)
        f91_local4.alpha = GetRandValue(f91_local10.alpha, 1)
        f91_local4.scale = GetRandValue(f91_local10.scale, 0) * f91_local15.scaleMultiplier + f91_local15.scaleAdditive
        f91_local4.zRot = GetRandValue(f91_local10.zRot)
        if GetRandValue(f91_local10.flippedY) == true then
            assert(f91_local10.text == nil, "Cannot flip text")
            f91_local4.left = f91_local4.left + f91_local4.width
            f91_local4.width = -f91_local4.width
        end
        if GetRandValue(f91_local10.flippedX) == true then
            assert(f91_local10.text == nil, "Cannot flip text")
            f91_local4.top = f91_local4.top + f91_local4.height
            f91_local4.height = -f91_local4.height
        end
        f91_local5 = GenerateStatesDuration(f91_local10.states, f91_local15.durationMultiplier)
        if f91_arg3 and f91_local5 < f91_arg3 then
            return
        end
        f91_local6 = LUI.UIElement.new
        if f91_local10.material then
            f91_local4.material = RegisterMaterial(GetRandValue(f91_local10.material))
            f91_local6 = LUI.UIImage.new
        end
        if f91_local10.text then
            assert(f91_local6 == LUI.UIElement.new, "Can't have text + material in a simple animated object")
            f91_local6 = LUI.UIText.new
        end
        if f91_local10.color then
            f91_local4.color = GetRandValue(f91_local10.color)
            if f91_local6 == LUI.UIElement.new then
                f91_local6 = LUI.UIImage.new
            end
        end
        f91_local7 = f91_local6(f91_local4)
        if f91_local7 == LUI.UIText.new then
            f91_local7:setText(Engine.Localize(GetRandValue(f91_local10.text)))
        end
        if f91_local10.childFunc then
            if type(f91_local10.childType) == "table" then
                f91_local8 = GetRandValue(f91_local10.childFunc)
                f91_local8(f91_local7)
            else
                f91_local10.childFunc(f91_local7)
            end
        end
        if f91_local10.childType then
            if type(f91_local10.childType) == "table" then
                LUI.MenuBuilder.BuildAddChild(f91_local7, f91_local10.childType)
            else
                LUI.MenuBuilder.BuildAddChild(f91_local7, {f91_local10.childType})
            end
        end
        f91_local8 = nil
        if f91_arg3 and f91_arg3 > 0 then
            f91_local8 = RegisterSimulatedAnimimationState(f91_local7, f91_local10, f91_local4, f91_local15, f91_local5,
                f91_arg3)
        else
            f91_local8 = RegisterAnimimationState(f91_local7, f91_local10, f91_local4, f91_local15, f91_local5)
        end
        if f91_local10.loop then
            if f91_local10.randomizeloop then
                f91_local7:animateInSequence(f91_local8, nil, true, true)
                f91_local7:registerEventHandler(LUI.FormatAnimStateFinishStepEvent(f91_local8[#f91_local8][1]),
                    function(element, event)
                        f91_local7:animateInSequence(
                            RegisterAnimimationState(element, f91_local10, f91_local4, f91_local15,
                                GenerateStatesDuration(f91_local10.states, f91_local15.durationMultiplier)), nil, true,
                            true)
                    end)
            else
                f91_local7:animateInLoop(f91_local8)
            end
        else
            f91_local7:animateInSequence(f91_local8, nil, true, false, true)
        end
        f91_arg0:addElement(f91_local7)
    end
end

LUI.SimpleAnimatedObjects = {}
LUI.SimpleAnimatedObjects.new = function(f93_arg0, f93_arg1, f93_arg2)
    local self = LUI.UIElement.new(CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All))
    self.currentTime = 0
    for f93_local4, f93_local5 in ipairs(f93_arg0) do
        f93_local5.nextTriggerTime = GetRandValue(f93_local5.introDelay)
    end
    f93_local1 = function(f94_arg0, f94_arg1)
        local f94_local0 = f93_arg1
        if f94_arg1.lateness < f93_arg1 then
            f94_local0 = f94_local0 + f94_arg1.lateness
        end
        f94_arg0.currentTime = f94_arg0.currentTime + f94_local0
        for f94_local4, f94_local5 in ipairs(f93_arg0) do
            if f94_local5.nextTriggerTime > -1 and f94_local5.nextTriggerTime < f94_arg0.currentTime then
                CreateAnimatedHuds(f94_arg0, f94_local5, false, f93_arg2)
                if not f94_local5.once then
                    f94_local5.nextTriggerTime = f94_local5.nextTriggerTime + GetRandValue(f94_local5.repeatDelay)
                else
                    f94_local5.nextTriggerTime = -1
                end
            end
        end
        if f93_arg2 and f93_arg2 > 0 then
            f93_arg2 = f93_arg2 - f94_local0
        else
            f93_arg2 = nil
            self:animateToState("default", f93_arg1)
        end
    end

    self:animateToState("default", f93_arg1)
    self:registerEventHandler("transition_complete_default", f93_local1)
    f93_local1(self, {
        lateness = 0
    })
    while f93_arg2 == nil or f93_arg2 <= 0 do
        return self
    end
    return self
end

LUI.MenuBuilder.m_types_build["generic_menu_title"] = generic_menu_title
LUI.MenuBuilder.m_types_build["generic_menu_title_and_breadCrumb_text"] = generic_menu_title_and_breadCrumb_text
-- LUI.MenuBuilder.m_types_build["generic_menu_titlebar"] = generic_menu_titlebar
-- LUI.MenuBuilder.m_types_build["h1_option_menu_titlebar"] = h1_option_menu_titlebar
