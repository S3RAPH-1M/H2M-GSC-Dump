SliderBounds = {
    Brightness = {
        Min = -0.4,
        Max = 0.2,
        Step = -0.01
    },
    PCBrightness = {
        Min = -0.4,
        Max = 0.2,
        Step = -0.01
    },
    HorzMargin = {
        Min = 0.9,
        Max = 1,
        Step = 0
    },
    MouseSensitivity = {
        Min = 1,
        Max = 20,
        Step = 0.2
    },
    VertMargin = {
        Min = 0.9,
        Max = 1,
        Step = 0
    },
    Volume = {
        Min = 0,
        Max = 1,
        Step = 0.02,
        PCStep = 0.02
    },
    VoiceRecord = {
        Min = 0,
        Max = 65535,
        Step = 655
    },
    VoiceThreshold = {
        Min = 0,
        Max = 65535,
        Step = 655
    },
    FOV = {
        Min = 65,
        Max = 200,
        Step = 1
    }
}

function createdivider(menu, text)
    local element = LUI.UIElement.new({
        leftAnchor = true,
        rightAnchor = true,
        left = 0,
        right = 0,
        topAnchor = true,
        bottomAnchor = false,
        top = 0,
        bottom = 33.33
    })

    element.scrollingToNext = true
    element:addElement(LUI.MenuBuilder.BuildRegisteredType("h1_option_menu_titlebar", {
        title_bar_text = text
    }))

    menu.list:addElement(element)
end

-- remove cod account button
CoD.IsCoDAccountRegistrationAvailableInMyRegion = function()
    return false
end

-- additional gamepad settings for configurization
require("gamepad_controls")

-- change PC sensitivity to slider instead
require("lookcontrols")

-- add additional voice chat settings
require("pcaudio")

-- add telemetry fps & latency
require("pcdisplay")

-- require("pcoptions")
require("pcvideo")
