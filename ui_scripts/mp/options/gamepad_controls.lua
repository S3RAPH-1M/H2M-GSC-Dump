local function get_current_dvar_value_float(dvar)
    return (Engine.GetDvarFloat(dvar) - SliderBounds.Volume.Min) / (SliderBounds.Volume.Max - SliderBounds.Volume.Min)
end

local function change_dvar_value(dvar, amount)
    local current = get_current_dvar_value_float(dvar)
    Engine.SetDvarFloat(dvar, current + amount)
end

local function is_gamepad_disabled_func(f1_arg0, f1_arg1)
    return not Engine.GetProfileData("gpadEnabled")
end

local function add_dvar_slider(menu, dvar, loc_title)
    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Slider, loc_title, loc_title .. "_DESC",
        function() -- current value
            return get_current_dvar_value_float(dvar)
        end, function(i) -- less
            change_dvar_value(dvar, -SliderBounds.Volume.Step)
        end, function(i) -- more
            change_dvar_value(dvar, SliderBounds.Volume.Step)
        end, nil, nil, nil, is_gamepad_disabled_func)
end

local function gpad_threshold_options(menu)
    createdivider(menu, Engine.Localize("@LUA_MENU_GPAD_DEADZONE"))

    add_dvar_slider(menu, "gpad_button_deadzone", "@LUA_MENU_GPAD_BTN_DEADZONE")
    add_dvar_slider(menu, "gpad_stick_deadzone_min", "@LUA_MENU_GPAD_STICK_DZ_MIN")
    add_dvar_slider(menu, "gpad_stick_deadzone_max", "@LUA_MENU_GPAD_STICK_DZ_MAX")
    add_dvar_slider(menu, "gpad_stick_pressed", "@LUA_MENU_GPAD_STICK_PRESSED")
    add_dvar_slider(menu, "gpad_stick_pressed_hysteresis", "@LUA_MENU_GPAD_STICK_PRESSED_HYSTERESIS")
end

local profile_data_btn_og = LUI.Options.CreateControlProfileDataButton
LUI.Options.CreateControlProfileDataButton = function(menu, profile_value, f38_arg2, f38_arg3, f38_arg4, f38_arg5,
    f38_arg6, f38_arg7, f38_arg8, f38_arg9)
    if profile_value then
        if profile_value == "gpadSticksConfig" then
            createdivider(menu, Engine.Localize("@LUA_MENU_GPAD_LAYOUT"))
        elseif profile_value == "invertedPitch" then
            createdivider(menu, Engine.Localize("@LUA_MENU_GPAD_SENSITIVITY"))
        elseif profile_value == "rumble" then
            -- add deadzone options before vibration
            gpad_threshold_options(menu)

            createdivider(menu, Engine.Localize("@LUA_MENU_GPAD_EXTRA"))
        end
    end

    return profile_data_btn_og(menu, profile_value, f38_arg2, f38_arg3, f38_arg4, f38_arg5, f38_arg6, f38_arg7,
        f38_arg8, f38_arg9)
end
