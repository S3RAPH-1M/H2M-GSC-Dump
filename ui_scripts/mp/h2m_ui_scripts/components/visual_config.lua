-- -------------------------------------------------------------------------- --
--                                   Colors                                   --
-- -------------------------------------------------------------------------- --
local yellow_color = {
    r = 0.86,
    g = 0.81,
    b = 0.34
}

LUI.FactionIcon.BackgroundScale = 1.2

Colors.h2 = {}

Colors.h2.yellow = yellow_color
Colors.h2.title_yellow = yellow_color
Colors.h2.title_brown = yellow_color

Colors.s1.text_focused = yellow_color
Colors.mw1_green = yellow_color
Colors.h1.light_green = yellow_color
Colors.mp.free_highlight_color = yellow_color
Colors.mp.axis_highlight_color = yellow_color
Colors.mp.axis_row_bg_color = yellow_color
Colors.mp.axis_outline_color = yellow_color
Colors.mp.axis_color = yellow_color
Swatches.HUD.Party = Swatches.HUD.Allies

GenericButtonSettings.Common = {
    force_enable_action_button = false,
    force_disable_action_button = false,
    y_offset = -3,
    disable_height_guard = false,
    text_align_without_content = LUI.Alignment.Left,
    text_align_with_content = LUI.Alignment.Left,
    text_padding_without_content = 10,
    text_padding_with_content = 10,
    text_padding_focus_without_content = 10,
    text_padding_focus_with_content = 10,
    content_cap_width = 32,
    content_background_margin_top = 0,
    content_background_margin_bottom = 0,
    label_align = LUI.Alignment.Center,
    over_disabled_animation_duration = 300,
    visual_focus_animation_duration = 0,
    content_margin = 12,
    content_width = 220,
    content_arrows_margin = 0,
    content_slider_height = 10,
    content_slider_width = 180,
    text_default_color = Colors.generic_button_text_default_color,
    text_focus_color = Colors.generic_button_text_focus_color,
    text_lock_color = Colors.generic_button_text_focus_color,
    content_default_color = Colors.generic_button_text_default_color,
    pinned_color = Colors.h1.light_green,
    content_focus_color = Colors.h1.light_green,
    content_focus_color_without_bg = Colors.h1.light_green,
    content_lock_color = Colors.generic_button_content_focus_color,
    text_disabled_color = Colors.generic_button_text_disabled_color,
    text_over_disabled_color = Colors.generic_button_text_over_disabled_color,
    text_over_disabled_pulse_color = Colors.generic_button_text_over_disabled_pulse_color,
    border_color = Colors.generic_button_border_color,
    negative_color = false,
    disable_highlight_glow = true,
    field_edited_func = function()

    end,
    max_length = 20,
    password_field = false,
    keyboard_type = CoD.KeyboardInputTypes.Normal,
    text_alignment = LUI.Alignment.Left,
    field_name = "Placeholder Field Name",
    loading_icon_margin = 5,
    loading_icon_height = 32,
    fadeIn = false,
    H1OptionButton = false,
    lockedHighlight = false
}

-- -------------------------------------------------------------------------- --
--                                   Sounds                                   --
-- -------------------------------------------------------------------------- --

CoD.Music.MainMPMusicList = {"h2_main_menu_music"}

CoD.SFX.MenuAccept = "h2_ui_menu_accept"
CoD.SFX.MenuBack = "h2_ui_menu_back"
CoD.SFX.MenuScroll = "h2_ui_menu_scroll"
CoD.SFX.PauseMenuBack = "h2_ui_menu_back"
CoD.SFX.MouseOver = "h2_ui_menu_scroll"
CoD.SFX.MouseClick = "h2_ui_menu_accept"
CoD.SFX.PopupAppears = "h2_ui_menu_accept"

-- -------------------------------------------------------------------------- --
--                                    Font                                    --
-- -------------------------------------------------------------------------- --
CoD.TextStyle.MW1Title = 0;

local scale = function(size)
    return size * 720 / 1080
end

local function setup_h2_bank_font(height, use_scale)
    local return_data = {
        Font = RegisterFont("fonts/h2m_bank.ttf", height),
        Height = height
    }

    if (use_scale) then
        return_data.Height = scale(height)
    end

    return return_data
end

CoD.TextSettings.H1TitleFont = setup_h2_bank_font(50, true)
CoD.TextSettings.TitleFontTiny = setup_h2_bank_font(27, true)

-- -------------------------------------------------------------------------- --
--                                 Background                                 --
-- -------------------------------------------------------------------------- --
CoD.Material.LoadingAnim = "h2_loading_animation"

LoadingAnimationDims = {
    Width = 120,
    Height = 120
}

if Engine.InFrontend() then
    CoD.Background.Default = "h2_sp_menus_bg_start_screen"

    --[[
    LUI.onmenuopen("mp_main_menu", function(menu)
        PersistentBackground.ChangeBackground(nil, "h2_sp_menus_bg_start_screen")
    end)

    LUI.onmenuopen("pc_controls", function(menu)
        PersistentBackground.ChangeBackground(nil, CoD.Background.Default)
    end)
    ]] --

    PersistentBackground.ChangeBackground(nil, "h2_sp_menus_bg_start_screen")

    -- -------------------------------------------------------------------------- --
    --                                    Misc                                    --
    -- -------------------------------------------------------------------------- --

    -- Engine.IsDepotEnabled = true

    local GetCustomClassCount = Cac.GetCustomClassCount

    Cac.GetCustomClassCount = function(...)
        if GetCustomClassCount(...) > 10 then
            return 10
        end

        return GetCustomClassCount(...)
    end

    LUI.MPLobbyBase.AddDepotButton = function(...) end
end
