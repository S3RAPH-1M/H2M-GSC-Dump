local PrimaryWeaponTabs = {{
    name = "@LUA_MENU_ASSAULT_RIFLES_CAPS",
    weaponCategory = "weapon_assault"
}, {
    name = "@LUA_MENU_SMGS_CAPS",
    weaponCategory = "weapon_smg"
}, {
    name = "@LUA_MENU_SNIPER_RIFLES_CAPS",
    weaponCategory = "weapon_sniper"
}, {
    name = "@LUA_MENU_LMGS_CAPS",
    weaponCategory = "weapon_heavy"
}}

local SecondaryWeaponTabs = {{
    name = "@LUA_MENU_MACHINE_PISTOLS_CAPS",
    weaponCategory = "weapon_secondary_machine_pistol"
}, {
    name = "@LUA_MENU_SHOTGUNS_CAPS",
    weaponCategory = "weapon_secondary_shotgun"
}, {
    name = "@LUA_MENU_HANDGUNS_CAPS",
    weaponCategory = "weapon_pistol"
}, {
    name = "@LUA_MENU_LAUNCHERS_CAPS",
    weaponCategory = "weapon_projectile"
}, {
    name = "@LUA_MENU_MELEE1_CAPS",
    weaponCategory = "weapon_melee"
}}

local CamoTabs = {{
    name = "@MENU_CLASSIC",
    category = "Gold"
}, {
    name = "@MENU_SOLID_COLORS",
    category = "LootDrop5"
}, {
    name = "@MENU_REFLECTIVE_SOLID_COLORS",
    category = "ReflectiveSolid"
}, {
    name = "@MENU_ELEMENTS",
    category = "Elements"
}, {
    name = "@MENU_BONUS",
    category = "Bonus"
}}

local OpenCacDetails = function(weaponData, parentMenu, overrideStorageCategory)
    LUI.FlowManager.RequestAddMenu(nil, "CacDetails", true, Cac.GetSelectedControllerIndex(), nil, {
        storageCategory = weaponData.storageCategory,
        weaponType = weaponData.weaponCategory,
        parentCategory = weaponData.parentCategory,
        overrideStorageCategory = overrideStorageCategory,
        menuTitle = weaponData.name,
        showAttributes = weaponData.showAttributes,
        subCategories = weaponData.subCategories,
        statsPrefix = weaponData.statsPrefix,
        attributesDelta = weaponData.attributesDelta,
        optionsForVL = weaponData.optionsForVL,
        showUnlocks = weaponData.showUnlocks,
        cacLootTabs = weaponData.cacLootTabs
    })
end

local OpenCacDetailsMenuWithOverkill = function(weaponData, parentMenu)
    local primaryWeaponCategory = Cac.GetPrimaryCategoryIfOverkill(weaponData.storageCategory, weaponData,
        PrimaryWeaponTabs)
    if weaponData.storageCategory ~= primaryWeaponCategory then
        OpenCacDetails(weaponData, parentMenu, primaryWeaponCategory)
    else
        OpenCacDetails(weaponData, parentMenu)
    end
end

local LeaveMenu = function(menuRef, event)
    LUI.FlowManager.RequestLeaveMenu(menuRef)
end

local GetSecondaryTitle = function()
    return "@MENU_SECONDARY_CAPS"
end

local IsReticleAllowed = function(storageCategory, controllerIndex)
    if not Engine.IsDepotEnabled() then
        return false
    elseif Cac.GetWeaponTypeFromWeapon(Cac.GetPrimaryCategoryIfOverkill(storageCategory, nil, PrimaryWeaponTabs),
        Cac.GetEquippedWeapon(storageCategory, 0, LUI.CacStaticLayout.ClassLoc)) == "weapon_sniper" then
        return true
    else
        return Cac.DoesAttachKitAllowReticles(Cac.GetEquippedWeapon(controllerIndex, 0, LUI.CacStaticLayout.ClassLoc))
    end
end

local MeleeInUseCheck = function()
    local melees = {
        "h2_shovel",
        "h2_karambit",
        "h2_hatchet",
        "h2_icepick",
        "h2_sickle"
    }

    local weapon_in_use = Cac.GetEquippedWeapon("Secondary", 0, LUI.CacStaticLayout.ClassLoc)
    for melee = 1, #melees, 1 do
        if weapon_in_use == melees[melee] then
            return false
        end
    end

    return true
end

local LauncherInUseCheck = function()
    local launchers = {
        "at4",
        "h2_rpg",
        "javelin",
        "h2_m79",
        "stinger"
    }

    local weapon_in_use = Cac.GetEquippedWeapon("Secondary", 0, LUI.CacStaticLayout.ClassLoc)
    for launcher = 1, #launchers, 1 do
        if weapon_in_use == launchers[launcher] then
            return false
        end
    end

    return true
end

local MeleeOrLauncherInUseCheck = function()
    local MeleeInUse = MeleeInUseCheck()
    local LauncherInUse = LauncherInUseCheck()

    if not MeleeInUse then
        return false
    end

    if not LauncherInUse then
        return false
    end

    return true
end

local BlingProPerkCheck = function()
    if (MeleeInUseCheck() == false or LauncherInUseCheck() == false) then
        return false
    end

    local f3_local0 = Cac.HasEquippedWeapon("Perk_Slot1", "specialty_secondarybling", LUI.CacStaticLayout.ClassLoc)
    return f3_local0 ~= false
end

Cac.BlingPerkCheck = function()
    local f3_local0 = Cac.HasEquippedWeapon("Perk_Slot1", "specialty_bling", LUI.CacStaticLayout.ClassLoc)
    if not f3_local0 then
        f3_local0 = BlingProPerkCheck()
    end

    return f3_local0 ~= false
end

local HasOmaEquiped = function()
    local f3_local0 = Cac.HasEquippedWeapon("Perk_Slot1", "specialty_onemanarmy", LUI.CacStaticLayout.ClassLoc)
    if not f3_local0 then
        f3_local0 = Cac.HasEquippedWeapon("Perk_Slot1", "specialty_omaquickchange", LUI.CacStaticLayout.ClassLoc)
    end
    return f3_local0
end

local OmaPerkCheck = function()
    return HasOmaEquiped() == false
end

local Categories = {{
    name = "@MENU_PRIMARY_CAPS",
    storageCategory = "Primary",
    actionFunc = OpenCacDetails,
    options = {{
        name = "@LUA_MENU_ATTACHMENT_CAPS",
        storageCategory = "Primary_AttachKit",
        weaponCategory = "attachkit",
        showAttributes = true,
        statsPrefix = "ak_",
        attributesDelta = true,
        showUnlocks = false
    }, {
        name = "@LUA_MENU_ATTACHMENT_CAPS",
        storageCategory = "Primary_FurnitureKit",
        weaponCategory = "attachkit",
        showAttributes = true,
        statsPrefix = "ak_",
        attributesDelta = true,
        showUnlocks = false,
        visibleFunc = Cac.BlingPerkCheck
    }, {
        name = "@MENU_CAMO_SHORT_CAPS",
        storageCategory = "Primary_Camo",
        weaponCategory = "camo",
        showUnlocks = false,
        cacLootTabs = CamoTabs
    }},
    showAttributes = true,
    subCategories = PrimaryWeaponTabs,
    showUnlocks = false
}, {
    name = GetSecondaryTitle,
    storageCategory = "Secondary",
    actionFunc = OpenCacDetails,
    options = {{
        name = "@LUA_MENU_ATTACHMENT_CAPS",
        storageCategory = "Secondary_AttachKit",
        weaponCategory = "attachkit",
        actionFunc = OpenCacDetails,
        showAttributes = true,
        statsPrefix = "ak_",
        attributesDelta = true,
        showUnlocks = false,
        visibleFunc = MeleeOrLauncherInUseCheck
    }, {
        name = "@LUA_MENU_ATTACHMENT_CAPS",
        storageCategory = "Secondary_FurnitureKit",
        weaponCategory = "attachkit",
        showAttributes = true,
        statsPrefix = "ak_",
        attributesDelta = true,
        showUnlocks = false,
        visibleFunc = BlingProPerkCheck
    }, {
        name = "@MENU_CAMO_SHORT_CAPS",
        storageCategory = "Secondary_Camo",
        weaponCategory = "camo",
        showUnlocks = false,
        cacLootTabs = CamoTabs,
        visibleFunc = LauncherInUseCheck
    }},
    showAttributes = true,
    subCategories = SecondaryWeaponTabs,
    showUnlocks = false,
    visibleFunc = OmaPerkCheck
}, {
    name = "@LUA_MENU_EQUIPMENT_CAPS",
    storageCategory = "Lethal",
    weaponCategory = "equipment_lethal"
}, {
    name = "@LUA_MENU_TACTICAL_CAPS",
    storageCategory = "Tactical",
    weaponCategory = "equipment_tactical"
}, {
    name = "@MENU_PERK1_CAPS",
    storageCategory = "Perk_Slot1",
    weaponCategory = "perk",
    disabledFunc = Cac.GetPerk1Names,
    showUnlocks = false,
    isPerk1 = true
}, {
    name = "@MENU_PERK2_CAPS",
    storageCategory = "Perk_Slot2",
    weaponCategory = "perk",
    showUnlocks = false
}, {
    name = "@MENU_PERK3_CAPS",
    storageCategory = "Perk_Slot3",
    weaponCategory = "perk",
    showUnlocks = false
}, {
    name = "@MENU_DEATHSTREAK_CAPS",
    storageCategory = "Melee",
    weaponCategory = "weapon_melee",
    showUnlocks = false
}}

local function GetValueOrCallFunction(value)
    if type(value) == "function" then
        return value()
    else
        return value
    end
end

local function ShowOpenList(parent, list)
    parent.openList = list
    local listItem = list:getFirstChild()
    while listItem ~= nil do
        if listItem.SetVisible then
            listItem:SetVisible(true, true)
        end
        listItem = listItem:getNextSibling()
    end
end

local function HideOpenList(parent)
    if parent.openList ~= nil then
        local listItem = parent.openList:getFirstChild()
        while listItem ~= nil do
            if listItem.SetVisible then
                listItem:SetVisible(false)
            end
            listItem = listItem:getNextSibling()
        end
        parent.openList:clearSavedState()
        parent.openList = nil
    end
end

local function OnOptionsListRestoreFocus(element, event, parent)
    local restored = LUI.UIElement.restoreFocus(element, event)
    if restored then
        ShowOpenList(parent, element)
    end
    return restored
end

local function OnButtonGainFocus(button, event, parent)
    HideOpenList(parent)
    LUI.UIButton.gainFocus(button, event)
    Cac.NotifyVirtualLobby("weapon_highlighted", "" .. Cac.GetSelectedControllerIndex() .. "_" .. Cac.GetVLOptionsString(button.storageCategory, button.weaponRef))
end

local function OnHorizontalListGainFocus(list, event, parent)
    if parent.openList == list then
        return
    else
        HideOpenList(parent)
        ShowOpenList(parent, list)
    end
end

local function OnWeaponButtonGainFocus(button, event, optionalButton, parent)
    LUI.UIButton.gainFocus(optionalButton or button, event)
    local selectedOptions = "" .. Cac.GetSelectedControllerIndex() .. "_"
    for i = 1, #button.optionsForVL, 1 do
        if button.optionsForVL[i].optionStorageCategory == "Perk_Slot1" or button.optionsForVL[i].optionStorageCategory ==
            "Perk_Slot2" or button.optionsForVL[i].optionStorageCategory == "Perk_Slot3" or
            button.optionsForVL[i].optionStorageCategory == "Melee" then
            selectedOptions = "none"
        else
            selectedOptions = selectedOptions ..
                                  Cac.GetVLOptionsString(button.optionsForVL[i].optionStorageCategory,
                    button.optionsForVL[i].optionWeaponRef) .. "_"
        end
    end
    Cac.NotifyVirtualLobby("weapon_highlighted", selectedOptions)
    OnHorizontalListGainFocus(button:getParent(), event, parent)
    if not optionalButton then
        button.menu:AddHelp({
            name = "add_button_helper_text",
            button_ref = "button_alt1",
            helper_text = ""
        })
    end
end

local function ClearWeaponAccessory(button)
    Engine.PlaySound(CoD.SFX.ButtonX)
    local weaponCategory = nil
    if string.find(button.storageCategory, "Primary") then
        weaponCategory = "Primary"
    else
        weaponCategory = "Secondary"
    end
    local isSniper = Cac.GetWeaponTypeFromWeaponWithoutCategory(
        Cac.GetEquippedWeapon(weaponCategory, 0, LUI.CacStaticLayout.ClassLoc)) == "weapon_sniper"
    local isPerk1Disabled = Cac.Perk1Disabled()
    local equippedWeapon = Cac.GetEquippedWeapon(button.storageCategory, 0, LUI.CacStaticLayout.ClassLoc)
    Cac.OverrideClearReticle = isSniper
    Cac.ClearEquippedWeapon(button.storageCategory, 0, LUI.CacStaticLayout.ClassLoc,
        Cac.GetSelectedClassIndex(LUI.CacStaticLayout.ClassLoc))
    local updatedWeapon = Cac.GetEquippedWeapon(button.storageCategory, 0, LUI.CacStaticLayout.ClassLoc)
    if equippedWeapon ~= updatedWeapon then
        button:Refresh(Cac.GetWeaponImageName(button.storageCategory, updatedWeapon))
        for i = 1, #button.optionsForVL, 1 do
            if button.optionsForVL[i].optionWeaponRef == equippedWeapon and button.optionsForVL[i].optionStorageCategory ==
                button.storageCategory then
                button.optionsForVL[i].optionWeaponRef = updatedWeapon
                break
            end
        end
        if string.find(button.storageCategory, "_AttachKit") ~= nil then
            for i = 1, #button.optionsForVL, 1 do
                if string.find(button.optionsForVL[i].optionStorageCategory, "_Reticle") ~= nil and not isSniper then
                    table.remove(button.optionsForVL, i)
                    break
                end
            end
            if not isSniper then
                local parent = button:getParent()
                if parent ~= nil then
                    local child = parent:getFirstChild()
                    while child ~= nil do
                        if string.find(child.storageCategory, "_Reticle") ~= nil then
                            parent:removeElement(child)
                            break
                        end
                        child = child:getNextSibling()
                    end
                end
            end
        end
        OnWeaponButtonGainFocus(button, {}, button, button.menu)
        if isPerk1Disabled and not Cac.Perk1Disabled() then
            local equippedPerk1 = Cac.GetEquippedWeapon("Perk_Slot1", 0, LUI.CacStaticLayout.ClassLoc)
            button.menu.Perk1:UnlockRefresh("@MENU_PERK1_CAPS", Cac.GetWeaponName("Perk_Slot1", equippedPerk1),
                Cac.GetWeaponImageName("Perk_Slot1", equippedPerk1))
        end
    end
end

local function OnWeaponAccessoryButtonGainFocus(button, event, parentButton, menu)
    OnWeaponButtonGainFocus(button, event, parentButton, menu)
    button.menu:AddHelp({
        name = "add_button_helper_text",
        button_ref = "button_alt1",
        helper_text = Engine.Localize("@LUA_MENU_CLEAR"),
        side = "right",
        clickable = true,
        func = function(helperButton, helperEvent)
            ClearWeaponAccessory(parentButton)
        end
    })
end

local function hasAcogScope()
    local location = "Primary_AttachKit"
    local hasAcogScope = Cac.HasEquippedWeapon(location, "acogh2", LUI.CacStaticLayout.ClassLoc)
    if not hasAcogScope then
        location = "Primary_FurnitureKit"
        hasAcogScope = Cac.HasEquippedWeapon(location, "acogh2", LUI.CacStaticLayout.ClassLoc)
    end
    return { hasAcogScope, location }
end

local function hasThermalScope()
    local location = "Primary_AttachKit"
    local hasThermalScope = Cac.HasEquippedWeapon(location, "thermal", LUI.CacStaticLayout.ClassLoc)
    if not hasThermalScope then
        location = "Primary_FurnitureKit"
        hasThermalScope = Cac.HasEquippedWeapon(location, "thermal", LUI.CacStaticLayout.ClassLoc)
    end
    return { hasThermalScope, location }
end

function RefreshAttachments()
	local f1_local0 = Engine.GetLuiRoot()
	local f1_local1 = f1_local0:getFirstDescendentById( "optionsList_Primary_option_1" )
	f1_local1:processEvent( {
		name = "menu_refresh"
	} )
    f1_local1 = f1_local0:getFirstDescendentById( "optionsList_Primary_option_2" )
    if f1_local1 ~= nil then
        f1_local1:processEvent( {
            name = "menu_refresh"
        } )
    end
end

local function buildSniperScopeHelp(f18_local1)

    local isSniper = Cac.GetWeaponTypeFromWeaponWithoutCategory(Cac.GetEquippedWeapon("Primary", 0, LUI.CacStaticLayout.ClassLoc)) == "weapon_sniper"

    if isSniper ~= true then
        return
    end

    local controller = Cac.GetSelectedControllerIndex()
    local class_index = Cac.GetSelectedClassIndex(LUI.CacStaticLayout.ClassLoc)
    local existing_2d_scope_option = Cac.GetCacConfig(controller, LUI.CacStaticLayout.ClassLoc, class_index, "use2dScopes")

    local helper_text = "Enable 2D Scopes"
    if existing_2d_scope_option then
        helper_text =  "Disable 2D Scopes"
    end

    f18_local1:AddHelp({
        name = "add_button_helper_text",
        button_ref = "button_alt1",
        helper_text = helper_text,
        side = "right",
        clickable = true,
        priority = 0,
        func = function()
            Cac.SetCacConfig(controller, LUI.CacStaticLayout.ClassLoc, class_index, "use2dScopes", not existing_2d_scope_option)
            local hasAcogScope = hasAcogScope()
            local hasThermalScope = hasThermalScope()
            if not existing_2d_scope_option == true then
                if hasAcogScope[1] == true then
                    remove_weapon_config(hasAcogScope[2], 0, LUI.CacStaticLayout.ClassLoc, nil)
                elseif hasThermalScope[1] == true then
                    remove_weapon_config(hasThermalScope[2], 0, LUI.CacStaticLayout.ClassLoc, nil)
                end
                RefreshAttachments()
            end

            buildSniperScopeHelp(f18_local1)
        end
    }, nil, nil, true)
end

local function CacLoadoutEditorMenu2(f18_arg0, f18_arg1)
    local f18_local0 = CoD.DesignGridHelper(7, 1)
    local f18_local1 = LUI.CacBase.new(f18_arg0, {
        menu_title = Engine.ToUpperCase(Cac.GetCustomClassName(LUI.CacStaticLayout.ClassLoc)),
        menu_width = f18_local0,
        persistentBackground = PersistentBackground.Variants.VirtualLobby
    })
    f18_local1:SetBreadCrumb(Engine.Localize("@LUA_MENU_CREATE_A_CLASS_CAPS"))
    f18_local1:AddListDivider()
    f18_local1:CreateBottomDivider()

    for categoryIndex, category in pairs(Categories) do
        if not category.visibleFunc or category.visibleFunc() then
            local buttonElement = nil
            local weaponRef = Cac.GetEquippedWeapon(category.storageCategory, 0, LUI.CacStaticLayout.ClassLoc)
            local weaponImageName = Cac.GetWeaponImageName(category.storageCategory, weaponRef)
            local weaponName = Cac.GetWeaponName(category.storageCategory, weaponRef)
            local displayName = GetValueOrCallFunction(category.name)
            local newMode = false

            if IsPublicMatch() then
                local newStickerState = LUI.InventoryUtils.GetCategoryNewStickerState(Cac.GetSelectedControllerIndex(),
                    category.storageCategory)
                newMode = newStickerState and LUI.NewSticker.Default
            end

            local weaponData = {
                optionWeaponRef = weaponRef,
                optionStorageCategory = category.storageCategory
            }

            local unrestricted = Cac.GetUnrestrictedState(category.storageCategory, weaponRef)

            if category.disabledFunc then
                local disabledDisplayName, disabledSecondaryText = category.disabledFunc()
                if disabledDisplayName and disabledSecondaryText then
                    displayName = disabledDisplayName
                    weaponName = disabledSecondaryText
                    newMode = true
                end
            end

            local lootData = LUI.InventoryUtils.GetLootDataForRef(category.storageCategory, weaponRef,
                LUI.CacStaticLayout.ClassLoc, Cac.GetSelectedClassIndex(LUI.CacStaticLayout.ClassLoc))

            local buttonOptions = {
                actionFunc = category.actionFunc or OpenCacDetails,
                primaryText = displayName,
                secondaryText = weaponName,
                iconName = weaponImageName,
                newMode = newMode,
                unrestricted = unrestricted,
                rarity = nil
            }

            if category.options ~= nil then
                local optionsList = LUI.UIHorizontalList.new({
                    topAnchor = true,
                    bottomAnchor = false,
                    leftAnchor = true,
                    rightAnchor = false,
                    top = 0,
                    bottom = 60,
                    left = 0,
                    right = f18_local0,
                    alignment = LUI.HorizontalAlignment.Left,
                    spacing = H1MenuDims.spacing
                })

                optionsList:registerEventHandler("restore_focus", function(element, event)
                    return OnOptionsListRestoreFocus(element, event, f18_local1)
                end)

                optionsList.buttonCount = 0
                optionsList:makeFocusable()
                optionsList.id = "optionsList_" .. category.storageCategory
                f18_local1.list:addElement(optionsList)

                local currentList = f18_local1.list
                f18_local1.list = optionsList

                local buttonElement = f18_local1:AddCacButton(buttonOptions)
                buttonElement:registerEventHandler("gain_focus", function(element, event)
                    OnWeaponButtonGainFocus(element, event, nil, f18_local1)
                end)

                buttonElement.optionsForVL = {}
                table.insert(buttonElement.optionsForVL, weaponData)
                f18_local1.list = currentList

                buttonElement.storageCategory = category.storageCategory
                buttonElement.weaponCategory = category.weaponCategory
                buttonElement.showAttributes = category.showAttributes
                buttonElement.showUnlocks = category.showUnlocks
                buttonElement.subCategories = category.subCategories
                buttonElement.name = weaponName
                buttonElement.weaponRef = weaponRef

                for optionIndex, option in pairs(category.options) do
                    if weaponRef ~= "h1_deserteagle55" and (not option.visibleFunc or option.visibleFunc()) then
                        local accessoryWeaponRef = Cac.GetEquippedWeapon(option.storageCategory, 0,
                            LUI.CacStaticLayout.ClassLoc)
                        local accessoryWeaponImageName = Cac.GetWeaponImageName(option.storageCategory,
                            accessoryWeaponRef)
                        local isAccessoryNew = false
                        local isAccessorySelectable = true

                        if IsPublicMatch() then
                            isAccessoryNew = LUI.InventoryUtils.GetCategoryNewStickerState(
                                Cac.GetSelectedControllerIndex(),
                                Cac.GetPrimaryCategoryIfOverkill(option.storageCategory, nil, f0_local0)) and
                                                 LUI.InventoryUtils
                                                     .GetSubCategoryNewStickerState(Cac.GetSelectedControllerIndex(),
                                    weaponRef)
                        else
                            local accessoryUnrestricted = Cac.GetUnrestrictedState(option.storageCategory,
                                accessoryWeaponRef)
                            if option.weaponCategory ~= "camo" and accessoryWeaponRef ~= "none" then
                                isAccessorySelectable = true
                            else
                                isAccessorySelectable = accessoryUnrestricted
                            end
                        end

                        local accessoryLootData = LUI.InventoryUtils.GetLootDataForRef(option.storageCategory,
                            accessoryWeaponRef, LUI.CacStaticLayout.ClassLoc, Cac.GetSelectedClassIndex(
                                LUI.CacStaticLayout.ClassLoc), category.storageCategory)

                        local accessoryButton = LUI.CacWeaponAccessoryButton.new(option.actionFunc or OpenCacDetails,
                            accessoryWeaponImageName, optionIndex, option.name, isAccessoryNew, isAccessorySelectable,
                            nil)

                        accessoryButton.menu = f18_local1
                        accessoryButton:registerEventHandler("gain_focus", function(element, event)
                            OnWeaponAccessoryButtonGainFocus(buttonElement, event, accessoryButton, f18_local1)
                        end)
                        accessoryButton:registerEventHandler("menu_refresh", function(element, event)
                            local updatedWeapon = Cac.GetEquippedWeapon(accessoryButton.storageCategory, 0, LUI.CacStaticLayout.ClassLoc)
                            if equippedWeapon ~= updatedWeapon then
                                accessoryButton:Refresh(Cac.GetWeaponImageName(accessoryButton.storageCategory, updatedWeapon))
                                for i = 1, #accessoryButton.optionsForVL, 1 do
                                    if accessoryButton.optionsForVL[i].optionWeaponRef == equippedWeapon and accessoryButton.optionsForVL[i].optionStorageCategory ==
                                        accessoryButton.storageCategory then
                                        accessoryButton.optionsForVL[i].optionWeaponRef = updatedWeapon
                                        break
                                    end
                                end
                                if string.find(accessoryButton.storageCategory, "_AttachKit") ~= nil then
                                    for i = 1, #accessoryButton.optionsForVL, 1 do
                                        if string.find(accessoryButton.optionsForVL[i].optionStorageCategory, "_Reticle") ~= nil and not isSniper then
                                            table.remove(accessoryButton.optionsForVL, i)
                                            break
                                        end
                                    end
                                    if not isSniper then
                                        local parent = accessoryButton:getParent()
                                        if parent ~= nil then
                                            local child = parent:getFirstChild()
                                            while child ~= nil do
                                                if string.find(child.storageCategory, "_Reticle") ~= nil then
                                                    parent:removeElement(child)
                                                    break
                                                end
                                                child = child:getNextSibling()
                                            end
                                        end
                                    end
                                end
                            end
                        end)

                        accessoryButton.id = optionsList.id .. "_option_" .. optionIndex
                        accessoryButton.storageCategory = option.storageCategory
                        accessoryButton.weaponCategory = option.weaponCategory
                        accessoryButton.showAttributes = option.showAttributes
                        accessoryButton.statsPrefix = option.statsPrefix
                        accessoryButton.attributesDelta = option.attributesDelta
                        accessoryButton.parentCategory = category.storageCategory
                        accessoryButton.cacLootTabs = Engine.GetOnlineGame() and option.cacLootTabs or nil
                        accessoryButton.showUnlocks = option.showUnlocks
                        accessoryButton.name = option.name

                        optionsList:addElement(accessoryButton)
                        table.insert(buttonElement.optionsForVL, {
                            optionWeaponRef = accessoryWeaponRef,
                            optionStorageCategory = option.storageCategory
                        })
                        accessoryButton.optionsForVL = buttonElement.optionsForVL
                    end
                end
            else
                buttonOptions.optionsForVL = {}
                table.insert(buttonOptions.optionsForVL, weaponData)

                buttonElement = f18_local1:AddCacButton(buttonOptions)
                buttonElement:registerEventHandler("gain_focus", function(element, event)
                    OnWeaponButtonGainFocus(element, event, nil, f18_local1)
                end)

                buttonElement.optionsForVL = buttonOptions.optionsForVL

                if category.isPerk1 then
                    f18_local1.Perk1 = buttonElement
                end

                buttonElement.storageCategory = category.storageCategory
                buttonElement.weaponCategory = category.weaponCategory
                buttonElement.showAttributes = category.showAttributes
                buttonElement.showUnlocks = category.showUnlocks
                buttonElement.subCategories = category.subCategories
                buttonElement.name = displayName
                buttonElement.weaponRef = weaponRef

                if category.isPerk1 then
                    f18_local1.Perk1 = buttonElement
                end
            end
        end
    end

    f18_local1:AddCurrencyInfoPanel()
    f18_local1:AddBottomDividerToList()
    f18_local1:AddBackButton(function(f23_arg0, f23_arg1)
        LeaveMenu(f18_local1, f23_arg1)
    end)
    f18_local1:AddRotateHelp()

    buildSniperScopeHelp(f18_local1)

    return f18_local1
end

LUI.MenuBuilder.m_types_build["CacLoadoutEditorMenu"] = CacLoadoutEditorMenu2
