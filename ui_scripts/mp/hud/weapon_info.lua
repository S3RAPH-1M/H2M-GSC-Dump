local function UpdateGrenadeAmmoText(f1_arg0, f1_arg1)
    local f1_local0 = "0"
    if f1_arg1.newValue < 1 then
        f1_arg0.ammoIcon:animateToState("no_ammo", 0)
        f1_arg0.ammoText:animateToState("no_ammo", 0)
    else
        f1_local0 = tostring(f1_arg1.newValue)
        f1_arg0.ammoIcon:animateToState("default", 0)
        f1_arg0.ammoText:animateToState("default", 0)
    end
    f1_arg0.ammoText:setText(f1_local0)
    if f1_arg0.cachedEvent then
        f1_arg0.cachedEvent = false
        f1_arg0:registerEventHandler("playerstate_client_changed", function(element, event)

        end)
    end
end

local function GetWeaponName(weapon_name_elem, f7_arg1)
    if (Game.InKillCam()) then
        return
    end

    local weapon_name_display = Game.GetPlayerWeaponDisplayName() or ""

    local clean_base_name = game:getweapondisplayname(Game.GetPlayerWeaponBaseName() or "")
    local original_weapon_name = Game.GetPlayerWeaponName()

    local attach_str = "";

    local is_akimbo_weapon = false

    if original_weapon_name ~= nil and Game.GetPlayerWeaponBaseName() ~= nil then
        local attachment_arr, _ = original_weapon_name:gsub(Game.GetPlayerWeaponBaseName(), '')

        local attachments = {}
        for attachment in attachment_arr:gmatch("[^_]+") do
            if attachment:find("glpre") == nil and attachment:find("shopre") == nil and attachment:find("camo") == nil then
                table.insert(attachments, attachment)
            end
        end

        if attachments[1] ~= nil then
            is_akimbo_weapon = attachments[1] == 'akimbo'
            attach_str = "^7" .. Engine.Localize(game:getattachmentdisplayname(attachments[1]))
        end

        if attachments[2] ~= nil then
            if is_akimbo_weapon ~= true then
                is_akimbo_weapon = attachments[2] == 'akimbo'
            end
            attach_str = "^7Custom"
        end
    end

    weapon_name_elem.attachName:setText(attach_str)
    if clean_base_name ~= nil then
        weapon_name_elem:setText(clean_base_name)
    end

    if is_akimbo_weapon and weapon_name_elem.dualAmmoRef ~= nil then
        weapon_name_elem.dualAmmoRef:show()
    else
        weapon_name_elem.dualAmmoRef:hide()
    end
end

function UpdateAmmoEmptyText(f8_arg0, f8_arg1)
    local weapon = Game.GetPlayerWeaponName()
    local currentStock = Game.GetPlayerStockAmmo()
    local maxStock = Game.GetPlayerMaxStockAmmo()
    local f8_local3 = Game.IsStockAmmoHidden()

    if maxStock > 0 then
        f8_arg0.ammoText:setText(currentStock)
    else
        f8_arg0.ammoText:setText("")
    end

    if weapon ~= "" and weapon ~= "none" then
        local f8_local4 = "default"

        if f8_local3 then
            f8_local4 = "hidden"
        elseif maxStock > 0 and currentStock <= maxStock * 0.15 then
            f8_local4 = "depleted"
        elseif maxStock > 0 and currentStock <= maxStock * 0.25 then
            f8_local4 = "depleted_warn"
        end

        if f8_arg0.currentState ~= f8_local4 then
            f8_arg0.ammoText:animateToState(f8_local4)
            f8_arg0.ammoText.currentState = f8_local4
        end
        if currentStock > 99 then
            f8_arg0.ammoBelt:animateToState("three_digits")
            f8_arg0.weaponName:animateToState("three_digits")
            if f8_arg0.ammoBeltLeft ~= nil then
                f8_arg0.ammoBeltLeft:animateToState("three_digits")
            end
        elseif currentStock > 9 then
            f8_arg0.ammoBelt:animateToState("two_digits")
            f8_arg0.weaponName:animateToState("two_digits")
            if f8_arg0.ammoBeltLeft ~= nil then
                f8_arg0.ammoBeltLeft:animateToState("two_digits")
            end
        elseif f8_local3 ~= true then
            f8_arg0.ammoBelt:animateToState("one_digits")
            f8_arg0.weaponName:animateToState("one_digits")
            if f8_arg0.ammoBeltLeft ~= nil then
                f8_arg0.ammoBeltLeft:animateToState("one_digits")
            end
        else
            f8_arg0.ammoBelt:animateToState("no_digits")
            f8_arg0.weaponName:animateToState("no_digits")
            if f8_arg0.ammoBeltLeft ~= nil then
                f8_arg0.ammoBeltLeft:animateToState("no_digits")
            end
        end
    end
end

local function ProcessEvent(func, f3_arg1)
    return function(f4_arg0, f4_arg1)
        if Game.GetPlayerHealth() > 0 or (Game.GetOmnvar("ui_session_state") == "spectator") or Game.InKillCam() then
            func(f4_arg0, f4_arg1)
        elseif f3_arg1 then
            f4_arg0.cachedEvent = true
            local f4_local0 = ProcessEvent(func, f3_arg1)
            f4_arg0:registerEventHandler("playerstate_client_changed", function(element, event)
                f4_local0(f4_arg0, f4_arg1)
            end)
        end
    end
end

local function CreateGrenadeAmmoDisplay(spacing, material, type)
    local element_state = CoD.CreateState(nil, nil, -spacing, nil, CoD.AnchorTypes.BottomRight)
    element_state.width = 48
    element_state.height = 48
    local self = LUI.UIElement.new(element_state)

    local equipment_state = CoD.CreateState(nil, nil, -13, -1, CoD.AnchorTypes.BottomRight)
    equipment_state.width = 28
    equipment_state.height = equipment_state.width
    equipment_state.alpha = 1
    local ammo_icon = LUI.UIImage.new(equipment_state)
    ammo_icon:setupUIBindImage(material)
    self:addElement(ammo_icon)
    ammo_icon:registerAnimationState("no_ammo", {
        alpha = 0.2
    })

    local ammo_state = CoD.CreateState(nil, nil, -7, -7, CoD.AnchorTypes.BottomLeftRight)
    ammo_state.alignment = LUI.Alignment.Right
    ammo_state.font = CoD.TextSettings.SP_HudItemAmmoFont.Font
    ammo_state.height = CoD.TextSettings.SP_HudItemAmmoFont.Height * 0.7
    ammo_state.textStyle = CoD.TextStyle.ShadowedMore
    ammo_state.color = Colors.white
    local ammo_text = LUI.UIText.new(ammo_state)
    self:addElement(ammo_text)
    ammo_text:registerAnimationState("no_ammo", {
        color = Colors.red
    })

    local f6_local8 = LUI.UIElement.new()
    f6_local8.id = type .. "_id"
    f6_local8:setupUIIntWatch(type)
    f6_local8.ammoText = ammo_text
    f6_local8.ammoIcon = ammo_icon
    f6_local8:registerEventHandler("int_watch_alert", ProcessEvent(UpdateGrenadeAmmoText, true))
    self:addElement(f6_local8)

    return self
end

LUI.MenuBuilder.m_types_build["weaponInfoHudDef"] = function()
    local root = LUI.UIElement.new(CoD.CreateState(0, 0, 0, HUD.GetXPBarOffset(), CoD.AnchorTypes.All))
    root.id = "weaponInfoHud"
    local f9_local2 = CoD.CreateState(nil, nil, nil, -30, CoD.AnchorTypes.BottomRight)
    f9_local2.width = 340
    f9_local2.height = 81
    local weaponHUD = LUI.UIElement.new(f9_local2)

    local width = 256 * 1.1
    local height = 50 * 1.4

    local f9_local4 = CoD.CreateState(-width, nil, nil, height, CoD.AnchorTypes.BottomRight)
    f9_local4.material = RegisterMaterial("h2m_hud_weapwidget_blur")
    f9_local4.alpha = CoD.HudStandards.blurAlpha
    weaponHUD:addElement(LUI.UIImage.new(f9_local4))

    local f9_local5 = CoD.CreateState(-width, nil, nil, height, CoD.AnchorTypes.BottomRight)
    f9_local5.material = RegisterMaterial("h2m_hud_weapwidget_border")
    f9_local5.color = CoD.HudStandards.overlayTint
    f9_local5.alpha = CoD.HudStandards.overlayAlpha
    weaponHUD:addElement(LUI.UIImage.new(f9_local5))

    local f9_local4 = CoD.CreateState(-width, 1, nil, -height, CoD.AnchorTypes.BottomRight)
    f9_local4.material = RegisterMaterial("h2m_hud_weapwidget_blur")
    f9_local4.alpha = CoD.HudStandards.blurAlpha
    weaponHUD:addElement(LUI.UIImage.new(f9_local4))

    local f9_local5 = CoD.CreateState(-width, 1, nil, -height, CoD.AnchorTypes.BottomRight)
    f9_local5.material = RegisterMaterial("h2m_hud_weapwidget_border")
    f9_local5.color = CoD.HudStandards.overlayTint
    f9_local5.alpha = CoD.HudStandards.overlayAlpha
    weaponHUD:addElement(LUI.UIImage.new(f9_local5))

    if Engine.GetDvarString( "ui_gametype" ) ~= "gun" then
        root:addElement(CreateGrenadeAmmoDisplay(0, "FragMaterial", "LethalCount"))
        if Engine.GetDvarString("ui_gametype") ~= "infect" then
            root:addElement(CreateGrenadeAmmoDisplay(CoD.HudStandards.boxSpacing, "FlashMaterial", "TacticalCount"))
        end
    end

    local right_hand_clip_y = 56
    local rightHandClipState = CoD.CreateState(275, right_hand_clip_y, 0, 0, CoD.AnchorTypes.All)
    local rightHandClip = LUI.UIElement.new(rightHandClipState)
    rightHandClip:setupOwnerdraw(CoD.Ownerdraw.CGAmmoMagazine, 1, CoD.TextStyle.Shadowed)
    weaponHUD:addElement(rightHandClip)

    local left_hand_clip_y = right_hand_clip_y - 10
    local leftHandClipState = CoD.CreateState(275, left_hand_clip_y, 0, 0, CoD.AnchorTypes.All)
    local leftHandClip = LUI.UIElement.new(leftHandClipState)
    leftHandClip:setupOwnerdraw(CoD.Ownerdraw.CGAmmoMagazineLeftHand, 1, CoD.TextStyle.Shadowed)
    weaponHUD:addElement(leftHandClip)

    rightHandClip:registerAnimationState("three_digits", rightHandClipState)
    rightHandClip:registerAnimationState("two_digits",
        CoD.CreateState(290, right_hand_clip_y, 0, 0, CoD.AnchorTypes.All))
    rightHandClip:registerAnimationState("one_digits",
        CoD.CreateState(310, right_hand_clip_y, 0, 0, CoD.AnchorTypes.All))
    rightHandClip:registerAnimationState("no_digits", CoD.CreateState(330, right_hand_clip_y, 0, 0, CoD.AnchorTypes.All))

    -- akimbo
    leftHandClip:registerAnimationState("three_digits", leftHandClipState)
    leftHandClip:registerAnimationState("two_digits", CoD.CreateState(290, left_hand_clip_y, 0, 0, CoD.AnchorTypes.All))
    leftHandClip:registerAnimationState("one_digits", CoD.CreateState(310, left_hand_clip_y, 0, 0, CoD.AnchorTypes.All))
    leftHandClip:registerAnimationState("no_digits", CoD.CreateState(330, left_hand_clip_y, 0, 0, CoD.AnchorTypes.All))
    leftHandClip:hide()

    local stockAmmoState = CoD.CreateState(0, nil, -6, 2, CoD.AnchorTypes.BottomLeftRight)
    stockAmmoState.alignment = LUI.Alignment.Right
    stockAmmoState.font = CoD.TextSettings.H1TitleFont.Font
    stockAmmoState.height = CoD.TextSettings.H1TitleFont.Height
    stockAmmoState.color = Colors.white
    stockAmmoState.alpha = 1
    local stockAmmo = LUI.UIText.new(stockAmmoState)
    stockAmmo:setTextStyle(CoD.TextStyle.Shadowed)
    weaponHUD:addElement(stockAmmo)
    stockAmmo:registerAnimationState("depleted_warn", {
        color = Swatches.HUD.Highlight,
        alpha = 1
    })
    stockAmmo:registerAnimationState("depleted", {
        color = Swatches.HUD.Warning,
        alpha = 1
    })
    stockAmmo:registerAnimationState("hidden", {
        alpha = 0
    })

    -- CoD.CreateState(arg1, arg2, right, down, anchor)

    local weaponNameState = CoD.CreateState(nil, nil, -6.5, -27, CoD.AnchorTypes.BottomLeftRight)
    weaponNameState.alignment = LUI.Alignment.Right
    weaponNameState.font = CoD.TextSettings.SP_HudWeaponNameFont.Font
    weaponNameState.height = CoD.TextSettings.SP_HudWeaponNameFont.Height

    local weaponName = LUI.UIText.new(weaponNameState)
    weaponName:setTextStyle(CoD.TextStyle.ForceUpperCase)
        weaponName:setTextStyle(CoD.TextStyle.ForceUpperCase)
    weaponName.dualAmmoRef = leftHandClip
    weaponName:setupAutoScaleText()

    local weapon_attach_name_state = CoD.CreateState(nil, nil, -6.5, -42, CoD.AnchorTypes.BottomLeftRight)
    weapon_attach_name_state.alignment = LUI.Alignment.Right
    weapon_attach_name_state.font = CoD.TextSettings.SP_HudWeaponNameFont.Font
    weapon_attach_name_state.height = CoD.TextSettings.SP_HudWeaponNameFont.Height * 0.7
    weapon_attach_name_state.alpha = 0.8

    local gray = {
        r = 180 / 255,
        g = 180 / 255,
        b = 180 / 255
    }

    weapon_attach_name_state.color = gray

    local weapon_attach_name = LUI.UIText.new(weapon_attach_name_state)
    weapon_attach_name:setTextStyle(CoD.TextStyle.ForceUpperCase)
    weapon_attach_name:setupAutoScaleText()

    weaponName.attachName = weapon_attach_name

    local get_weapon_name_event = ProcessEvent(GetWeaponName)
    weaponName:registerEventHandler("weapon_change", get_weapon_name_event)
    weaponName:registerEventHandler("playerstate_client_changed", get_weapon_name_event)
    weaponHUD:addElement(weaponName)
    weaponHUD:addElement(weapon_attach_name)

    local f9_local18 = LUI.UIElement.new()
    f9_local18:setupUIIntWatch("StockAmmo")
    f9_local18.ammoText = stockAmmo
    f9_local18.ammoBelt = rightHandClip
    f9_local18.ammoBeltLeft = leftHandClip
    f9_local18.weaponName = weaponName
    local f9_local19 = ProcessEvent(UpdateAmmoEmptyText)
    f9_local18:registerEventHandler("int_watch_alert", f9_local19)
    f9_local18:registerEventHandler("weapon_change", f9_local19)
    weaponHUD:addElement(f9_local18)

    UpdateAmmoEmptyText(f9_local18, nil)
    root:addElement(weaponHUD)

    return root
end