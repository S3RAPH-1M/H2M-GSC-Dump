--[[
    -- h2m_class_editor_menu          -- main class selection screen
    -- h2m_class_editor_menu_stage1   -- type of class data to edit
    -- h2m_class_editor_menu_stage1_2 -- weapon choices menus
    -- h2m_class_editor_menu_stage2   -- individual item selection
]] -- class editor data
local stages = {
    default = 0,
    class_selected = 1,
    type_selected = 2,
    type_2_selected = 3,
    item_selected = 4
}

local saved_stage_data = {
    stage = stages.default,
    class_index = nil,
    type = nil,
    type_2 = nil
}

local options = luiglobals.require("LUI.mp_hud.OptionsMenu")
local class_select = luiglobals.require("LUI.mp_hud.CharSelectMenu")

local function leave_this_menu(f6_arg0, f6_arg1)
    f6_arg0:dispatchEventToRoot({
        name = "toggle_pause_off"
    })
    LUI.FlowManager.RequestCloseAllMenus(f6_arg0)
    Game.HandleLeavePauseMenu()
    Engine.PlaySound(CoD.SFX.PauseMenuResume)
end

local end_game_cb = function(f4_arg0, f4_arg1)
    local f4_local0 = Engine.GetOnlineGame()
    if f4_local0 then
        f4_local0 = not Engine.GetDvarBool("xblive_privatematch")
    end
    local f4_local1 = Engine.GetDvarBool("sv_running")
    if f4_local0 then
        LUI.FlowManager.RequestAddMenu(f4_arg0, "popup_leave_game", true, f4_arg1.controller)
    else
        LUI.FlowManager.RequestAddMenu(f4_arg0, "popup_end_game", true, f4_arg1.controller)
    end
end

LUI.MenuBuilder.m_types_build["mp_pause_menu"] = function(f7_arg0, f7_arg1)
    local ui_options_menu_sum = false
    if GameX.IsRankedMatch() then
        ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") > 0
    else
        local spectate_allowed = GetPrivateMatchSpectateAllowedLevel()
        if spectate_allowed == 0 then
            ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") > 0
        elseif spectate_allowed == 1 and not GameX.gameModeIsFFA() then
            ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") == 1
        end
    end

    local is_splitscreen = GameX.IsSplitscreen()
    local pause_menu = LUI.inGameBase.new(f7_arg0, {
        menu_title = "@LUA_MENU_PAUSE_CAPS",
        disableBack = ui_options_menu_sum
    })

    if options.CanChooseClass() then
        local temp_button_var = pause_menu:AddButton("@LUA_MENU_CHOOSE_CLASS", options.OnChooseClass)
        temp_button_var:rename(f7_arg0.type .. "_choose_class")

        temp_button_var = pause_menu:AddButton("@LUA_MENU_CLASS_EDITOR", function(arg0, arg1)
            LUI.FlowManager.RequestAddMenu(arg0, "h2m_class_editor", true, arg1.controller)
        end, function()
            return true
        end)
        temp_button_var:rename(f7_arg0.type .. "_class_editor")
    end

    if options.CanShowChangeTeamMenuOption() and not Game.GetOmnvar("ui_disable_team_change") then
        local temp_button_var = pause_menu:AddButton("@LUA_MENU_CHANGE_TEAM", options.OnChangeTeam)
        temp_button_var:rename(f7_arg0.type .. "_change_team")
    end

    local f7_local5 = pause_menu:AddOptionsButton(true)
    if is_splitscreen then
        f7_local5.disabledFunc = GameX.IsOptionStateLocked
        f7_local5:setDisabledRefreshRate(100)
    end

    pause_menu:AddButton("@LUA_MENU_MUTE_PLAYERS", function(f3_arg0, f3_arg1)
        LUI.FlowManager.RequestAddMenu(f3_arg0, "MutePlayers", true, f3_arg1.controller)
    end)

    if not ui_options_menu_sum then
        local self = LUI.UIBindButton.new()
        self.id = "inGameButtonBinds"
        self:registerEventHandler("button_start", leave_this_menu)
        self:registerEventHandler("button_select", leave_this_menu)
        pause_menu:addElement(self)
        pause_menu:AddBackButton(leave_this_menu)
    end

    local self = pause_menu:AddButton("@LUA_MENU_END_GAME", end_game_cb)
    self:clearActionSFX()

    return pause_menu
end

-- class editor below here
local function on_edit_class_action(menu, arg1)
    saved_stage_data.stage = stages.class_selected
    saved_stage_data.class_index = menu.classSelectIndex

    LUI.FlowManager.RequestAddMenu(menu, "h2m_class_editor_menu_stage1", true, arg1.controller, nil, {
        menu_title = menu.title
    })
end

local function add_class_buttons(menu, arg1)
    local f11_local0 = Cac.GetSelectedControllerIndex()
    local f11_local1 = nil
    for class_index = 0, arg1 - 1, 1 do
        f11_local1 = menu:AddButton(Engine.MarkLocalized(class_index), on_edit_class_action, nil, nil, nil, {
            canShowRestricted = true,
            showLockOnDisable = true
        })
        f11_local1:rename("cac_class_button_" .. class_index)
        f11_local1.disabledFunc = class_select.IsClassButtonDisabled
        f11_local1.controllerIndex = f11_local0
        f11_local1:registerEventHandler("button_over", class_select.OnClassButtonOver)
        f11_local1:registerEventHandler("button_over_disable", class_select.OnClassButtonOver)
        f11_local1:registerEventHandler("refresh_class_name", class_select.RefreshClassButton)
        f11_local1.menu = menu
    end
end

local function enter_new_stage(menu, sum, menu_loc, new_menu, stage, type, has_type_2, type_2)
    if stage ~= stages.item_selected then
        saved_stage_data.type = type
    else
        -- TODO: handle item somewhere here? we have all the data needed, including item

        -- item == saved_stage_data.type
        Cac.SelectEquippedWeapon(saved_stage_data.type, saved_stage_data.class_index, type, LUI.CacStaticLayout.ClassLoc)
    end

    if has_type_2 then
        saved_stage_data.type_2 = type_2
    end

    saved_stage_data.stage = (stage == stages.item_selected and stages.class_selected or stage) -- item selected goes to class selected again

    -- if we're opening stage 1, make sure stage 1.5 and 2 are closed
    if new_menu == "h2m_class_editor_menu_stage1" then
        LUI.FlowManager.RequestLeaveMenuByName("h2m_class_editor_menu_stage1_2")
        LUI.FlowManager.RequestLeaveMenuByName("h2m_class_editor_menu_stage2")
    end

    LUI.FlowManager.RequestAddMenu(menu, new_menu, true, sum.controller, nil, {
        menu_title = menu_loc
    })
end

local function add_current_stage_buttons(menu)
    saved_stage_data.buttons = {}

    if saved_stage_data.stage == stages.class_selected then
        local add_type_button = function(menu_loc, target_menu, type, has_type_2, type_2)
            menu:AddButton(menu_loc, function(menu_, sum)
                has_type_2 = has_type_2 or false
                enter_new_stage(menu_, sum, menu_loc, target_menu,
                    (has_type_2 and stages.type_2_selected or stages.type_selected), type, has_type_2, type_2)
            end)
        end

        add_type_button("@MENU_PRIMARY_CAPS", "h2m_class_editor_menu_stage1_2", "Primary")
        add_type_button("@MENU_SECONDARY_CAPS", "h2m_class_editor_menu_stage1_2", "Secondary")
        add_type_button("@LUA_MENU_EQUIPMENT_CAPS", "h2m_class_editor_menu_stage2", "Lethal", true, "equipment_lethal")
        add_type_button("@LUA_MENU_TACTICAL_CAPS", "h2m_class_editor_menu_stage2", "Tactical", true,
            "equipment_tactical")
        add_type_button("@MENU_PERK1_CAPS", "h2m_class_editor_menu_stage2", "Perk_Slot1", true, "perk")
        add_type_button("@MENU_PERK2_CAPS", "h2m_class_editor_menu_stage2", "Perk_Slot2", true, "perk")
        add_type_button("@MENU_PERK3_CAPS", "h2m_class_editor_menu_stage2", "Perk_Slot3", true, "perk")
        add_type_button("@MENU_DEATHSTREAK_CAPS", "h2m_class_editor_menu_stage2", "Melee", true, "weapon_melee")
    elseif saved_stage_data.stage == stages.type_selected then
        local add_category_button = function(menu_loc, target_menu, type, has_type_2, type_2)
            menu:AddButton(menu_loc, function(menu_, sum)
                enter_new_stage(menu_, sum, menu_loc, target_menu, stages.type_2_selected, type, has_type_2, type_2)
            end)
        end

        if saved_stage_data.type == "Primary" then
            add_category_button("@LUA_MENU_ASSAULT_RIFLES_CAPS", "h2m_class_editor_menu_stage2", "Primary", true,
                "weapon_assault")
            add_category_button("@LUA_MENU_SMGS_CAPS", "h2m_class_editor_menu_stage2", "Primary", true, "weapon_smg")
            add_category_button("@LUA_MENU_SNIPER_RIFLES_CAPS", "h2m_class_editor_menu_stage2", "Primary", true,
                "weapon_sniper")
            add_category_button("@LUA_MENU_LMGS_CAPS", "h2m_class_editor_menu_stage2", "Primary", true, "weapon_heavy")
        elseif saved_stage_data.type == "Secondary" then
            add_category_button("@LUA_MENU_MACHINE_PISTOLS_CAPS", "h2m_class_editor_menu_stage2", "Secondary", true,
                "weapon_secondary_machine_pistol")
            add_category_button("@LUA_MENU_SHOTGUNS_CAPS", "h2m_class_editor_menu_stage2", "Secondary", true,
                "weapon_shotgun")
            add_category_button("@LUA_MENU_HANDGUNS_CAPS", "h2m_class_editor_menu_stage2", "Secondary", true,
                "weapon_pistol")
            add_category_button("@LUA_MENU_LAUNCHERS_CAPS", "h2m_class_editor_menu_stage2", "Secondary", true,
                "weapon_projectile")
            -- add_category_button("@LUA_MENU_MELEE1_CAPS",            "h2m_class_editor_menu_stage2", "Secondary", true, "weapon_melee")
        end
    elseif saved_stage_data.stage == stages.type_2_selected then
        local add_item_button = function(menu_loc, target_menu, item)
            menu:AddButton(menu_loc, function(menu_, sum)
                enter_new_stage(menu_, sum, menu_loc, target_menu, stages.item_selected, item)
            end)
        end

        if saved_stage_data.type == "Primary" or saved_stage_data.type == "Secondary" then
            for index, primary_ in ipairs(Cac.Weapons.Primary) do
                for _, primary_data in pairs(primary_) do
                    local name = Cac.GetWeaponName(saved_stage_data.type, primary_data[1])
                    if #name > 2 and Cac.Weapons.Primary.Keys[index] == saved_stage_data.type_2 then
                        add_item_button(name, "h2m_class_editor_menu_stage1", primary_data[1])
                    end
                end
            end
        else
            for index, sum in pairs(Cac.GetAllDefinedAndValidWeapons(saved_stage_data.type, saved_stage_data.type_2,
                LUI.CacStaticLayout.ClassLoc, nil, Cac.NotPreorderWeapon, Cac.GetSelectedControllerIndex())) do
                add_item_button(Cac.GetWeaponName(saved_stage_data.type, sum[1]), "h2m_class_editor_menu_stage1", sum[1])
            end
        end
    end
end

-- modified to not include default classes
local function create_class_table()
    local f12_local0, f12_local1, f12_local2 = nil
    local f12_local3 = Cac.GetSelectedControllerIndex()
    local f12_local4 = {}
    local f12_local5, f12_local6 = nil
    f12_local0 = Cac.GetCustomClassLoc()
    f12_local1 = Cac.GetCustomClassCount(f12_local0)
    for f12_local7 = 0, f12_local1 - 1, 1 do
        if Cac.IsCustomClassLocked(f12_local3, f12_local0, f12_local7) then
            break
        end
        f12_local4[#f12_local4 + 1] = {
            title = Cac.GetCustomClassName(f12_local0, f12_local7),
            classLoc = f12_local0,
            classSlot = f12_local7,
            classSelectIndex = Cac.GenerateCustomClassIndex(f12_local7, f12_local0, f12_local1),
            isDefaultClass = false,
            restricted = Cac.IsCustomClassRestricted(f12_local0, f12_local7),
            isLocked = false
        }
    end
    f12_local5 = #f12_local4

    --[[
    f12_local1 = Cac.GetDefaultClassCount()
    f12_local0 = "defaultClassesTeam" .. Game.GetPlayerTeam()
    if f12_local0 == "defaultClassesTeam0" then
        f12_local0 = "defaultClassesTeam2"
    end
    for f12_local7 = 0, f12_local1 - 1, 1 do
        f12_local4[#f12_local4 + 1] = {
            title = Cac.GetCustomClassName(f12_local0, f12_local7),
            classLoc = f12_local0,
            classSlot = f12_local7,
            classSelectIndex = Cac.GenerateDefaultClassIndex(f12_local7, f12_local0, f12_local1),
            isDefaultClass = true,
            isLocked = Cac.IsDefaultClassLocked(f12_local3, f12_local7)
        }
    end
    ]] --

    return f12_local4, f12_local5, #f12_local4
end

LUI.MenuBuilder.registerType("h2m_class_editor", function(arg0, arg1)
    --[[
    local f13_local0, f13_local1, f13_local2 = nil

    local f13_local3 = false
    local classes_per_page = 11
    if Engine.UsingSplitscreenUpscaling() then
        classes_per_page = 5
    end

    Cac.EnableMenuCache()
    Cac.SetSelectedControllerIndex(arg1.exclusiveController)

    f13_local0, f13_local1, f13_local2 = create_class_table()
    local f13_local5 = nil
    if classes_per_page < f13_local2 then
        f13_local5 = 35
        f13_local3 = true
    end

    local menu_settings = {
        menu_title = "@LUA_MENU_EDIT_CLASS_CAPS",
        menu_height = 548,
        menu_top_indent = f13_local5,
        exclusiveController = arg1.exclusiveController,
        scrollInSplitscreen = true
    }

    local allow_scrolling = Engine.IsConsoleGame()
    if not allow_scrolling then
        allow_scrolling = Engine.IsGamepadEnabled()
    end

    menu_settings.allowPagedScrolling = allow_scrolling

    local menu = LUI.MenuTemplate.new(arg0, menu_settings)
    menu.numCustomClasses = f13_local1
    menu.totalClasses = f13_local2
    menu.classTable = f13_local0
    menu.classesPerPage = classes_per_page
    menu.selectedClassIndex = Game.GetOmnvar("ui_loadout_selected")
    if menu.selectedClassIndex < 0 then
        menu.selectedClassIndex = 0
    end

    local current_page = nil
    if menu.selectedClassIndex >= 200 then
        current_page = math.ceil((menu.numCustomClasses + (menu.selectedClassIndex - 200) % 6 + 1) / classes_per_page)
    elseif menu.selectedClassIndex >= 100 then
        current_page = math.ceil((menu.numCustomClasses + menu.selectedClassIndex - 100 + 1) / classes_per_page)
    else
        current_page = math.ceil((menu.selectedClassIndex + 1) / classes_per_page)
    end
    menu.currentPage = current_page

    add_class_buttons(menu, classes_per_page)

    if f13_local3 then
        local left_trigger_btn_text = ""
        local right_trigger_btn_text = ""

        if CoD.UsingController() then
            if Engine.IsVita(arg1.exclusiveController) then
                left_trigger_btn_text = Engine.Localize("LUA_MENU_PAD_LEFT_TRIGGER_BUTTON")
                right_trigger_btn_text = Engine.Localize("LUA_MENU_PAD_RIGHT_TRIGGER_BUTTON")
            else
                left_trigger_btn_text = Engine.Localize("LUA_MENU_PAD_LEFT_SHOULDER_BUTTON")
                right_trigger_btn_text = Engine.Localize("LUA_MENU_PAD_RIGHT_SHOULDER_BUTTON")
            end
        else
            left_trigger_btn_text = Engine.Localize("PLATFORM_KB_LEFT_SHOULDER_BUTTON")
            right_trigger_btn_text = Engine.Localize("PLATFORM_KB_RIGHT_SHOULDER_BUTTON")
        end

        local f13_local10 = function(f14_arg0, f14_arg1)
            class_select.CacOnTabLeft(f14_arg0, f14_arg1, menu)
        end

        local layout = function(f15_arg0, f15_arg1)
            class_select.CacOnTabRight(f15_arg0, f15_arg1, menu)
        end

        local invalid_self_0 = LUI.UIElement.new(CoD.CreateState(0, GenericMenuDims.MenuStartY - 7,
            GenericMenuDims.menu_width_standard, GenericMenuDims.MenuStartY + f13_local5, CoD.AnchorTypes.TopLeft))
        menu:addElement(invalid_self_0)

        local f13_local13 = nil
        if Engine.IsConsoleGame() or Engine.IsGamepadEnabled() then
            f13_local13 = LUI.UIText.new(CoD.CreateState(-70, 0, -50, 20, CoD.AnchorTypes.Top))
            f13_local13:setText(left_trigger_btn_text)
        else
            local f13_local14 = CoD.CreateState(25, 0, -50, nil, CoD.AnchorTypes.TopLeft)
            f13_local14.font = CoD.TextSettings.TitleFontMediumLarge.Font
            f13_local14.height = 20
            f13_local13 = LUI.UIButtonText.new(f13_local14, Engine.ToUpperCase(Engine.Localize(left_trigger_btn_text)),
                false, false, false, false, f13_local10, function()
                    return menu.currentPage == 1
                end)
        end
        local f13_local14 = nil
        if Engine.IsConsoleGame() or Engine.IsGamepadEnabled() then
            f13_local14 = LUI.UIText.new(CoD.CreateState(70, 0, 90, 20, CoD.AnchorTypes.Top))
            f13_local14:setText(right_trigger_btn_text)
        else
            local f13_local15 = CoD.CreateState(GenericMenuDims.menu_width_standard - 45, 0, 0, nil,
                CoD.AnchorTypes.TopLeft)
            f13_local15.font = CoD.TextSettings.TitleFontMediumLarge.Font
            f13_local15.height = 20
            f13_local14 = LUI.UIButtonText.new(f13_local15, Engine.ToUpperCase(Engine.Localize(f13_local9)), false,
                false, false, false, layout, function()
                    return menu.currentPage == math.ceil(menu.totalClasses / menu.classesPerPage)
                end)
        end
        local f13_local15 = LUI.UIText.new(CoD.CreateState(0, 2, 0, 18, CoD.AnchorTypes.TopLeftRight))
        local f13_local16 = 5
        local f13_local17 = math.ceil(menu.totalClasses / menu.classesPerPage)
        local f13_local18 = GenericMenuDims.menu_width_standard
        local f13_local19 = f13_local18 / f13_local17
        local f13_local20 = LUI.UIHorizontalList.new({
            top = -4,
            spacing = 0,
            alignment = LUI.Alignment.Center,
            height = f13_local16 + 10,
            width = f13_local18
        })
        local f13_local21 = function(f18_arg0, f18_arg1)
            f18_arg0.pipList:closeChildren()
            for f18_local0 = 1, f13_local17, 1 do
                local f18_local3 = f18_local0
                local invalid_self_1 = nil
                invalid_self_1 = LUI.UIBorder.new({
                    width = f13_local19,
                    height = f13_local16,
                    color = Colors.mw1_green,
                    material = RegisterMaterial("white"),
                    borderThickness = 1
                })
                if f18_local3 == f18_arg0.currentPage then
                    local f18_local5 = 4
                    local f18_local6 = 6
                    local f18_local7 = CoD.CreateState(-f18_local5, -f18_local6, f18_local5, f18_local6,
                        CoD.AnchorTypes.All)
                    f18_local7.material = RegisterMaterial("h1_tabs_states_selected")
                    f18_local7.alpha = 0.35
                    local f18_local8 = LUI.UIImage.new(f18_local7)
                    f18_local8:setup3SliceRatio(8, 0.25)
                    invalid_self_1:addElement(f18_local8)
                elseif Engine.IsPC() then
                    local f18_local5 = 4
                    local f18_local6 = 6
                    local f18_local7 = CoD.CreateState(-f18_local5, -f18_local6, f18_local5, f18_local6,
                        CoD.AnchorTypes.All)
                    f18_local7.material = RegisterMaterial("h1_tabs_states_selected")
                    f18_local7.alpha = 0
                    local f18_local8 = LUI.UIImage.new(f18_local7)
                    f18_local8:registerAnimationState("mouseOver", {
                        alpha = 0.25
                    })
                    f18_local8:setup3SliceRatio(8, 0.25)
                    invalid_self_1:addElement(f18_local8)
                    local f18_local9 = LUI.UIElement.new(CoD.CreateState(nil, nil, nil, 10, CoD.AnchorTypes.All))
                    f18_local9:setHandleMouseButton(true)
                    f18_local9:setHandleMouseMove(true)
                    f18_local9.m_requireFocusType = FocusType.MouseOver
                    f18_local9:registerEventHandler("leftmousedown", function(element, event)
                        Engine.PlaySound(CoD.SFX.MenuAccept)
                        class_select.CacOnTabClick(element, event, menu, f18_local3)
                    end)
                    f18_local9:registerEventHandler("mouseenter", function(element, event)
                        f18_local8:animateToState("mouseOver")
                    end)
                    f18_local9:registerEventHandler("mouseleave", function(element, event)
                        f18_local8:animateToState("default")
                    end)
                    invalid_self_1:addElement(f18_local9)
                end
                f18_arg0.pipList:addElement(invalid_self_1)
            end
        end

        menu:registerEventHandler("update_pips", f13_local21)
        invalid_self_0:addElement(f13_local13)
        invalid_self_0:addElement(f13_local14)
        invalid_self_0:addElement(f13_local15)
        invalid_self_0:addElement(f13_local20)
        menu.headerText = f13_local15
        menu.pipList = f13_local20
        f13_local21(menu, nil)
        local f13_local22 = LUI.UIBindButton.new()
        menu:addElement(f13_local22)
        f13_local22:registerEventHandler("button_shoulderl", f13_local10)
        f13_local22:registerEventHandler("button_shoulderr", layout)
    end

    menu.list:registerEventHandler("refresh_loadout", function(element, event)
        local f22_local0 = element:getParent()
        if f22_local0 and f22_local0.layout then
            local specific_container = nil
            local containers = #f22_local0.layout.containers
            for f22_local3 = 1, containers, 1 do
                specific_container = f22_local0.layout.containers[f22_local3]
                specific_container:Refresh(event.loadout, event.isCustom)
                specific_container:show()
            end
        end
    end)

    local using_splitscreen_upscale = Engine.UsingSplitscreenUpscaling()
    local f13_local9 = CoD.CreateState(CoD.DesignGridHelper(8.25), 60, 0, 0, CoD.AnchorTypes.All)
    if using_splitscreen_upscale then
        f13_local9 = CoD.CreateState(-CoD.DesignGridHelper(27), 60, 0, 0, CoD.AnchorTypes.TopRight)
    end

    local f13_local10 = LUI.UIElement.new(f13_local9)
    f13_local10.id = "cac_container"
    menu:addElement(f13_local10)

    local layout = LUI.CacStaticLayout.new(nil, true, true, using_splitscreen_upscale)
    layout:disableTreeFocus()
    f13_local10:addElement(layout)
    menu.layout = layout

    LUI.ButtonHelperText
        .AddHelperTextObject(menu.help, LUI.ButtonHelperText.CommonEvents.addBackButton, MBh.LeaveMenu())
    if Engine.IsConsoleGame() or Engine.IsGamepadEnabled() then
        LUI.ButtonHelperText.AddHelperTextObject(menu.help, LUI.ButtonHelperText.CommonEvents.addSelectButton)
    end

    Cac.DisableMenuCache()
    menu:registerEventHandler("gain_focus", class_select.OnCacGainFocus)
    menu:registerEventHandler("restore_focus", class_select.OnCacRestoreFocus)

    if LUI.FlowManager.IsTopMenuModal() then
        class_select.OnCacGainFocus(menu, nil)
    end

    return menu
    ]]--
end)

local function setup_class_editor_menu(arg0, arg1)
    local f13_local3 = false
    local classes_per_page = 11
    if Engine.UsingSplitscreenUpscaling() then
        classes_per_page = 5
    end

    Cac.EnableMenuCache()
    Cac.SetSelectedControllerIndex(arg1.exclusiveController)

    local f13_local0, f13_local1, f13_local2 = create_class_table()
    local f13_local5 = nil
    if classes_per_page < f13_local2 then
        f13_local5 = 35
        f13_local3 = true
    end

    local menu_settings = {
        menu_title = (arg1.menu_title and arg1.menu_title or "@LUA_MENU_EDIT_CLASS_CAPS"),
        menu_height = 548,
        menu_top_indent = f13_local5,
        exclusiveController = arg1.exclusiveController,
        scrollInSplitscreen = true
    }

    local allow_scrolling = Engine.IsConsoleGame()
    if not allow_scrolling then
        allow_scrolling = Engine.IsGamepadEnabled()
    end

    menu_settings.allowPagedScrolling = allow_scrolling

    local menu = LUI.MenuTemplate.new(arg0, menu_settings)
    menu.numCustomClasses = f13_local1
    menu.totalClasses = f13_local2
    menu.classTable = f13_local0
    menu.classesPerPage = classes_per_page
    menu.selectedClassIndex = Game.GetOmnvar("ui_loadout_selected")
    if menu.selectedClassIndex < 0 then
        menu.selectedClassIndex = 0
    end

    local current_page = nil
    if menu.selectedClassIndex >= 200 then
        current_page = math.ceil((menu.numCustomClasses + (menu.selectedClassIndex - 200) % 6 + 1) / classes_per_page)
    elseif menu.selectedClassIndex >= 100 then
        current_page = math.ceil((menu.numCustomClasses + menu.selectedClassIndex - 100 + 1) / classes_per_page)
    else
        current_page = math.ceil((menu.selectedClassIndex + 1) / classes_per_page)
    end
    menu.currentPage = current_page

    add_current_stage_buttons(menu)
    menu:AddBackButton(function(arg0, arg1)
        -- before we go to previous menu, reset data that may be relied on
        if saved_stage_data.stage == stages.type_selected then
            saved_stage_data.type = nil
        elseif saved_stage_data.stage == stages.type_2_selected then
            saved_stage_data.type_2 = nil
        end

        if saved_stage_data.stage == stages.type_2_selected and
            (saved_stage_data.type ~= "Primary" and saved_stage_data.type ~= "Secondary") then
            saved_stage_data.stage = saved_stage_data.stage - 2
        else
            saved_stage_data.stage = saved_stage_data.stage - 1
        end

        LUI.FlowManager.RequestLeaveMenu(arg0)
    end)

    if f13_local3 then
        local left_trigger_btn_text = ""
        local right_trigger_btn_text = ""

        if CoD.UsingController() then
            if Engine.IsVita(arg1.exclusiveController) then
                left_trigger_btn_text = Engine.Localize("LUA_MENU_PAD_LEFT_TRIGGER_BUTTON")
                right_trigger_btn_text = Engine.Localize("LUA_MENU_PAD_RIGHT_TRIGGER_BUTTON")
            else
                left_trigger_btn_text = Engine.Localize("LUA_MENU_PAD_LEFT_SHOULDER_BUTTON")
                right_trigger_btn_text = Engine.Localize("LUA_MENU_PAD_RIGHT_SHOULDER_BUTTON")
            end
        else
            left_trigger_btn_text = Engine.Localize("PLATFORM_KB_LEFT_SHOULDER_BUTTON")
            right_trigger_btn_text = Engine.Localize("PLATFORM_KB_RIGHT_SHOULDER_BUTTON")
        end

        local f13_local10 = function(f14_arg0, f14_arg1)
            class_select.CacOnTabLeft(f14_arg0, f14_arg1, menu)
        end

        local layout = function(f15_arg0, f15_arg1)
            class_select.CacOnTabRight(f15_arg0, f15_arg1, menu)
        end

        local invalid_self_0 = LUI.UIElement.new(CoD.CreateState(0, GenericMenuDims.MenuStartY - 7,
            GenericMenuDims.menu_width_standard, GenericMenuDims.MenuStartY + f13_local5, CoD.AnchorTypes.TopLeft))
        menu:addElement(invalid_self_0)

        local f13_local13 = nil
        if Engine.IsConsoleGame() or Engine.IsGamepadEnabled() then
            f13_local13 = LUI.UIText.new(CoD.CreateState(-70, 0, -50, 20, CoD.AnchorTypes.Top))
            f13_local13:setText(left_trigger_btn_text)
        else
            local f13_local14 = CoD.CreateState(25, 0, -50, nil, CoD.AnchorTypes.TopLeft)
            f13_local14.font = CoD.TextSettings.TitleFontMediumLarge.Font
            f13_local14.height = 20
            f13_local13 = LUI.UIButtonText.new(f13_local14, Engine.ToUpperCase(Engine.Localize(left_trigger_btn_text)),
                false, false, false, false, f13_local10, function()
                    return menu.currentPage == 1
                end)
        end
        local f13_local14 = nil
        if Engine.IsConsoleGame() or Engine.IsGamepadEnabled() then
            f13_local14 = LUI.UIText.new(CoD.CreateState(70, 0, 90, 20, CoD.AnchorTypes.Top))
            f13_local14:setText(right_trigger_btn_text)
        else
            local f13_local15 = CoD.CreateState(GenericMenuDims.menu_width_standard - 45, 0, 0, nil,
                CoD.AnchorTypes.TopLeft)
            f13_local15.font = CoD.TextSettings.TitleFontMediumLarge.Font
            f13_local15.height = 20
            f13_local14 = LUI.UIButtonText.new(f13_local15, Engine.ToUpperCase(Engine.Localize(f13_local9)), false,
                false, false, false, layout, function()
                    return menu.currentPage == math.ceil(menu.totalClasses / menu.classesPerPage)
                end)
        end
        local f13_local15 = LUI.UIText.new(CoD.CreateState(0, 2, 0, 18, CoD.AnchorTypes.TopLeftRight))
        local f13_local16 = 5
        local f13_local17 = math.ceil(menu.totalClasses / menu.classesPerPage)
        local f13_local18 = GenericMenuDims.menu_width_standard
        local f13_local19 = f13_local18 / f13_local17
        local f13_local20 = LUI.UIHorizontalList.new({
            top = -4,
            spacing = 0,
            alignment = LUI.Alignment.Center,
            height = f13_local16 + 10,
            width = f13_local18
        })
        local f13_local21 = function(f18_arg0, f18_arg1)
            f18_arg0.pipList:closeChildren()
            for f18_local0 = 1, f13_local17, 1 do
                local f18_local3 = f18_local0
                local invalid_self_1 = nil
                invalid_self_1 = LUI.UIBorder.new({
                    width = f13_local19,
                    height = f13_local16,
                    color = Colors.mw1_green,
                    material = RegisterMaterial("white"),
                    borderThickness = 1
                })
                if f18_local3 == f18_arg0.currentPage then
                    local f18_local5 = 4
                    local f18_local6 = 6
                    local f18_local7 = CoD.CreateState(-f18_local5, -f18_local6, f18_local5, f18_local6,
                        CoD.AnchorTypes.All)
                    f18_local7.material = RegisterMaterial("h1_tabs_states_selected")
                    f18_local7.alpha = 0.35
                    local f18_local8 = LUI.UIImage.new(f18_local7)
                    f18_local8:setup3SliceRatio(8, 0.25)
                    invalid_self_1:addElement(f18_local8)
                elseif Engine.IsPC() then
                    local f18_local5 = 4
                    local f18_local6 = 6
                    local f18_local7 = CoD.CreateState(-f18_local5, -f18_local6, f18_local5, f18_local6,
                        CoD.AnchorTypes.All)
                    f18_local7.material = RegisterMaterial("h1_tabs_states_selected")
                    f18_local7.alpha = 0
                    local f18_local8 = LUI.UIImage.new(f18_local7)
                    f18_local8:registerAnimationState("mouseOver", {
                        alpha = 0.25
                    })
                    f18_local8:setup3SliceRatio(8, 0.25)
                    invalid_self_1:addElement(f18_local8)
                    local f18_local9 = LUI.UIElement.new(CoD.CreateState(nil, nil, nil, 10, CoD.AnchorTypes.All))
                    f18_local9:setHandleMouseButton(true)
                    f18_local9:setHandleMouseMove(true)
                    f18_local9.m_requireFocusType = FocusType.MouseOver
                    f18_local9:registerEventHandler("leftmousedown", function(element, event)
                        Engine.PlaySound(CoD.SFX.MenuAccept)
                        class_select.CacOnTabClick(element, event, menu, f18_local3)
                    end)
                    f18_local9:registerEventHandler("mouseenter", function(element, event)
                        f18_local8:animateToState("mouseOver")
                    end)
                    f18_local9:registerEventHandler("mouseleave", function(element, event)
                        f18_local8:animateToState("default")
                    end)
                    invalid_self_1:addElement(f18_local9)
                end
                f18_arg0.pipList:addElement(invalid_self_1)
            end
        end

        menu:registerEventHandler("update_pips", f13_local21)
        invalid_self_0:addElement(f13_local13)
        invalid_self_0:addElement(f13_local14)
        invalid_self_0:addElement(f13_local15)
        invalid_self_0:addElement(f13_local20)
        menu.headerText = f13_local15
        menu.pipList = f13_local20
        f13_local21(menu, nil)
        local f13_local22 = LUI.UIBindButton.new()
        menu:addElement(f13_local22)
        f13_local22:registerEventHandler("button_shoulderl", f13_local10)
        f13_local22:registerEventHandler("button_shoulderr", layout)
    end

    -- edit
    menu.list:registerEventHandler("refresh_loadout", function(element, event)
        local parent_element = element:getParent()
        if parent_element and parent_element.layout then
            local specific_container = nil
            local containers = #parent_element.layout.containers
            for f22_local3 = 1, containers, 1 do
                specific_container = parent_element.layout.containers[f22_local3]
                specific_container:Refresh(event.loadout, event.isCustom)
                specific_container:show()
            end
        end
    end)

    local using_splitscreen_upscale = Engine.UsingSplitscreenUpscaling()
    local f13_local9 = CoD.CreateState(CoD.DesignGridHelper(8.25), 60, 0, 0, CoD.AnchorTypes.All)
    if using_splitscreen_upscale then
        f13_local9 = CoD.CreateState(-CoD.DesignGridHelper(27), 60, 0, 0, CoD.AnchorTypes.TopRight)
    end

    local cac_container_elem = LUI.UIElement.new(f13_local9)
    cac_container_elem.id = "cac_container"
    menu:addElement(cac_container_elem)

    -- edit layout
    local layout = LUI.CacStaticLayout.new(nil, true, true, using_splitscreen_upscale)
    layout:disableTreeFocus()
    cac_container_elem:addElement(layout)

    local loadout = Cac.GetLoadout((CoD.GetStatsGroupForGameMode() ~= CoD.StatsGroup.Private and "customClasses" or
                                       "privateMatchCustomClasses"), saved_stage_data.class_index)

    -- basically refresh_loadout but called right away to show class, each container will get loadout data from above
    local f22_local1 = nil
    local f22_local2 = #layout.containers
    for f22_local3 = 1, f22_local2, 1 do
        f22_local1 = layout.containers[f22_local3]
        f22_local1:Refresh(loadout, true)
        f22_local1:show()
    end

    menu.layout = layout

    if Engine.IsConsoleGame() or Engine.IsGamepadEnabled() then
        LUI.ButtonHelperText.AddHelperTextObject(menu.help, LUI.ButtonHelperText.CommonEvents.addSelectButton)
    end

    Cac.DisableMenuCache()

    return menu
end

LUI.MenuBuilder.registerType("h2m_class_editor_menu_stage1", setup_class_editor_menu)
LUI.MenuBuilder.registerType("h2m_class_editor_menu_stage1_2", setup_class_editor_menu)
LUI.MenuBuilder.registerType("h2m_class_editor_menu_stage2", setup_class_editor_menu)
