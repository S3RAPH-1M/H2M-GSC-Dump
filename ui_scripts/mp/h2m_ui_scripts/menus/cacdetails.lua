CreateTabManager = function(f1_arg0, f1_arg1)
    local f1_local0 = LUI.MenuBuilder.BuildRegisteredType("MFTabManager", {
        defState = {
            leftAnchor = true,
            topAnchor = true,
            rightAnchor = true,
            top = 10
        },
        numOfTabs = f1_arg1,
        vPadding = 20,
        forceStringBasedTabWidth = true,
        forceShowTabs = true
    })
    f1_local0:keepRightBumperAlignedToHeader(true)
    f1_arg0.tabManager = f1_local0
    f1_arg0:addElement(f1_local0)
    if not Engine.IsConsoleGame() and not Engine.IsGamepadEnabled() then
        f1_arg0:AddHelp({
            name = "add_button_helper_text",
            button_ref = "button_shoulderl",
            button_ref2 = "button_shoulderr",
            helper_text = Engine.Localize("@LUA_MENU_CATEGORY"),
            side = "right",
            clickable = false,
            priority = 2000,
            groupLRButtons = true
        })
    end
end

LUI.CacDetails.new = function(f14_arg0, f14_arg1)
    local f14_local0 = nil
    if f14_arg1.weaponType ~= "reticle" then
        f14_local0 = PersistentBackground.Variants.VirtualLobby
    end

    local f14_local1 = LUI.CacBase.new(f14_arg0, {
        menu_title = Engine.ToUpperCase(Engine.Localize(f14_arg1.menuTitle)),
        menu_width = CoD.DesignGridHelper(7, 1),
        menu_top_indent = 20,
        persistentBackground = f14_local0
    })
    f14_local1:SetBreadCrumb(Engine.Localize("@LUA_MENU_CREATE_A_CLASS_CAPS"))
    f14_local1:setClass(LUI.CacDetails)
    f14_local1.storageCategory = f14_arg1.storageCategory
    f14_local1.weaponType = f14_arg1.weaponType
    f14_local1.parentCategory = f14_arg1.parentCategory
    f14_local1.overrideStorageCategory = f14_arg1.overrideStorageCategory
    f14_local1.statsPrefix = f14_arg1.statsPrefix
    f14_local1.attributesDelta = f14_arg1.attributesDelta
    f14_local1.optionsForVL = f14_arg1.optionsForVL
    f14_local1.parentWeaponID = f14_arg1.parentWeaponID
    f14_local1.menuToRestore = f14_arg0.type
    f14_local1.showUnlocks = IsPublicMatch() and f14_arg1.showUnlocks or false
    local f14_local2 = 0
    local f14_local3 = f14_local1.overrideStorageCategory or f14_local1.storageCategory
    if f14_local3 == "Primary_Camo" or f14_local3 == "Secondary_Camo" or f14_local3 == "Primary_Reticle" or f14_local3 ==
        "Secondary_Reticle" then
        f14_local2 = 30
    end

    local f14_local4 = LUI.ItemDescriptionWidget.new({
        topAnchor = true,
        leftAnchor = true,
        top = LUI.CacDetails.TitleBoxTop,
        left = LUI.CacDetails.TitleBoxLeft + f14_local2
    })
    f14_local1.itemDescriptionWidget = f14_local4
    f14_local1:addElement(f14_local4)
    if f14_arg1.storageCategory == "Perk_Slot1" then
        f14_local4:ColorForPerks(LUI.CacDetails.PerksBlue)
    elseif f14_arg1.storageCategory == "Perk_Slot2" then
        f14_local4:ColorForPerks(LUI.CacDetails.PerksRed)
    elseif f14_arg1.storageCategory == "Perk_Slot3" then
        f14_local4:ColorForPerks(LUI.CacDetails.PerksYellow)
    end
    if Cac.InPermanentLockingContext() then
        f14_local1:SetBreadCrumb(Engine.ToUpperCase(Engine.Localize("@LUA_MENU_PERMANENT_UNLOCKS")))
    end
    if f14_local1.parentCategory ~= nil and f14_local1.parentWeaponID == nil then
        f14_local1.parentWeaponID = Cac.GetEquippedWeapon(f14_local1.parentCategory, 0, LUI.CacStaticLayout.ClassLoc)
    end
    local f14_local5 = Cac.GetEquippedWeapon(f14_local1.storageCategory, 0, LUI.CacStaticLayout.ClassLoc)
    if f14_arg1.exclusiveController ~= nil then
        f14_local1.numTokens = Cac.GetPrestigeTokens(f14_arg1.exclusiveController)
    end
    local f14_local6 = CoD.CreateState(420, 175, nil, nil, CoD.AnchorTypes.TopLeft)
    f14_local6.height = 400
    f14_local6.width = 533
    f14_local6.alpha = 0
    f14_local6.material = RegisterMaterial("cinematic")

    local self = LUI.UIImage.new(f14_local6)
    self:registerAnimationState("visible", {
        alpha = 1
    })
    self:registerAnimationState("hidden", {
        alpha = 0
    })
    self:registerOmnvarHandler("ui_cac_weapon_loading", function(f15_arg0, f15_arg1)
        if f15_arg1.value == true then
            Engine.PlayMenuVideo("h1_ui_weapon_load_fx", 1)
            f15_arg0:animateToState("visible", 0)
        else
            if Engine.IsVideoPlaying(LUI.CacDetails.LoadingVideo) then
                Engine.StopMenuVideo()
            end
            f15_arg0:animateToState("hidden", 0)
        end
    end)
    f14_local1:addElement(LUI.MPDepotHelp.new(f14_local1, {
        actionAndCollectionHelpOnly = true
    }))
    f14_local1:addElement(self)
    f14_local1:AddBackButton(function(f16_arg0, f16_arg1)
        if Engine.IsVideoPlaying(LUI.CacDetails.LoadingVideo) then
            Engine.StopMenuVideo()
        end
        LUI.FlowManager.RequestLeaveMenu(f16_arg0)
    end)
    if f14_arg1.showAttributes then
        local f14_local8, itemModelLockOverlay = nil
        if Cac.InPermanentLockingContext() then
            if Cac.SelectingAttachmentPermanentUnlock() then
                local f14_local10 = f14_local1.parentWeaponID
            end
            itemModelLockOverlay = f14_local10 or nil
        else
            if f14_local1.parentWeaponID then
                local f14_local11 = f14_local1.parentWeaponID
            end
            itemModelLockOverlay = f14_local11 or f14_local5
        end
        local itemLockReasonLabel = nil
        if itemModelLockOverlay then
            itemLockReasonLabel = {
                accuracy = Cac.GetWeaponAccuracy(itemModelLockOverlay),
                damage = Cac.GetWeaponDamage(itemModelLockOverlay),
                range = Cac.GetWeaponRange(itemModelLockOverlay),
                fireRate = Cac.GetWeaponFireRate(itemModelLockOverlay),
                mobility = Cac.GetWeaponMobility(itemModelLockOverlay)
            }
        end
        f14_local8 = LUI.CacWeaponAttributes.new(itemLockReasonLabel, f14_local2)
        f14_local1.attributes = f14_local8
        f14_local1:addElement(f14_local8)
    end

    f14_local1.weaponNameBackgroundBox = weaponNameBackgroundBox
    if f14_arg1 and f14_arg1.weaponType ~= "reticle" then
        f14_local1:AddRotateHelp()
    end

    if (f14_local1.numTokens > 0 or Cac.InPermanentLockingContext()) and f14_local1.showUnlocks == true then
        local f14_local8 = CoD.TextSettings.Font21
        local itemModelLockOverlay = CoD.CreateState(0, 32, 0, nil, CoD.AnchorTypes.TopLeftRight)
        itemModelLockOverlay.alignment = LUI.Alignment.Right
        itemModelLockOverlay.height = f14_local8.Height
        itemModelLockOverlay.font = f14_local8.Font
        itemModelLockOverlay.color = Colors.h1.light_grey
        itemModelLockOverlay.alpha = 0.4
        local itemLockReasonLabel = nil
        if f14_local1.numTokens > 1 or f14_local1.numTokens == 0 then
            itemLockReasonLabel = Engine.Localize("@LUA_MENU_PERMANENT_UNLOCK_COUNT", f14_local1.numTokens)
        else
            itemLockReasonLabel = Engine.Localize("@LUA_MENU_PERMANENT_UNLOCK_COUNT_SINGLE")
        end
        local reticlePreviewElement = LUI.UIText.new(itemModelLockOverlay)
        reticlePreviewElement:setText(itemLockReasonLabel)
        f14_local1:addElement(reticlePreviewElement)
        local f14_local14, f14_local15, f14_local16, f14_local17 =
            GetTextDimensions(itemLockReasonLabel, f14_local8.Font, f14_local8.Height)
        local f14_local18 = 20
        local f14_local19 = CoD.CreateState(nil, 28, 0 - f14_local16 - 10, nil, CoD.AnchorTypes.TopRight)
        f14_local19.width = f14_local18
        f14_local19.height = f14_local18
        f14_local19.material = RegisterMaterial("h1_ui_icon_unlock_token")
        f14_local1:addElement(LUI.UIImage.new(f14_local19))
    end

    if f14_arg1.weaponType == nil and not Cac.InPermanentLockingContext() then
        f14_arg1.weaponType = Cac.GetWeaponTypeFromWeapon(
            f14_local1.overrideStorageCategory or f14_arg1.storageCategory, f14_local5)
    end

    if f14_arg1.weaponType == ItemTypes.Reticle then
        local f14_local8 = CoD.CreateState(-247, -185, nil, nil, CoD.AnchorTypes.None)
        f14_local8.width = 788.14
        f14_local8.height = 420
        f14_local8.material = RegisterMaterial("h1_reticles_previewscene")
        f14_local1:addElement(LUI.UIImage.new(f14_local8))
        local itemLockReasonLabel = CoD.CreateState(147, -61.5, nil, nil, CoD.AnchorTypes.None)
        itemLockReasonLabel.width = 60
        itemLockReasonLabel.height = 60

        local reticlePreviewElement = LUI.UIImage.new(itemLockReasonLabel)
        f14_local1:addElement(reticlePreviewElement)
        f14_local1.reticlePreviewElement = reticlePreviewElement

        f14_local1.reticlePreviewElement:hide()
    end

    local itemModelLockOverlay = LUI.CacDetails.MakeLockOverlay(
        CoD.CreateState(530, 122, 970, 562, CoD.AnchorTypes.TopLeft))
    f14_local1:addElement(itemModelLockOverlay)
    f14_local1.itemModelLockOverlay = itemModelLockOverlay

    local itemLockReasonLabel = LUI.UIText.new({
        color = Colors.white,
        alignment = LUI.Alignment.Center,
        height = 14,
        font = CoD.TextSettings.BodyFont.Font,
        alpha = 0.4,
        top = 165,
        topAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        alpha = 1
    })

    itemLockReasonLabel:registerAnimationState("hidden", {
        alpha = 0
    })
    itemLockReasonLabel:setText(Engine.Localize("@DEPOT_LOCKED_LIVE_EVENT_EXPIRED"))
    itemModelLockOverlay:addElement(itemLockReasonLabel)
    f14_local1.itemLockReasonLabel = itemLockReasonLabel

    f14_local1:AddCurrencyInfoPanel()

    if not (not f14_arg1.subCategories or #f14_arg1.subCategories <= 0) or f14_arg1.cacLootTabs and
        #f14_arg1.cacLootTabs > 0 then
        CreateTabManager(f14_local1, f14_arg1.subCategories and #f14_arg1.subCategories or #f14_arg1.cacLootTabs)
        local f14_local14 = false
        local f14_local15 = LUI.FlowManager.GetMenuScopedDataFromElement(f14_local1)

        if f14_local15 and f14_local15.tabIndex then
            f14_local1.tabManager.tabSelected = f14_local15.tabIndex
            f14_local14 = true
        end

        if f14_arg1.subCategories and #f14_arg1.subCategories > 0 then
            for f14_local16 = 1, #f14_arg1.subCategories, 1 do
                local f14_local19 = f14_local16
                local f14_local20 = false
                if IsPublicMatch() then
                    f14_local20 = LUI.InventoryUtils.GetSubCategoryNewStickerState(Cac.GetSelectedControllerIndex(),
                        f14_arg1.subCategories[f14_local19].weaponCategory)
                end
                f14_local1.tabManager:addTab(Cac.GetSelectedControllerIndex(),
                    Engine.Localize(f14_arg1.subCategories[f14_local19].name), function(f17_arg0, f17_arg1)
                        local f17_local0 = f14_local1
                        local f17_local1 = f17_local0
                        f17_local0 = f17_local0.PopulateList
                        local f17_local2 = f14_local1.overrideStorageCategory
                        if not f17_local2 then
                            f17_local2 = f14_local1.storageCategory
                        end

                        f17_local0(f17_local1, f17_local2, f14_arg1.subCategories[f14_local19].weaponCategory,
                            f14_local5, true, f14_local1.parentCategory)
                        f17_local0 = LUI.FlowManager.GetMenuScopedDataFromElement(f14_local1)
                        if f17_local0 then
                            f17_local0.tabIndex = f14_local19
                        end
                    end, nil, nil, nil, nil, f14_local20)
                if not f14_local14 and f14_arg1.subCategories[f14_local19].weaponCategory == f14_arg1.weaponType then
                    f14_local1.tabManager.tabSelected = f14_local19
                end
            end
        else

            local f14_local16 = Engine.TableLookup(StatsTable.File, StatsTable.Cols.ExternalRef, f14_local5,
                StatsTable.Cols.ProdLevel)
            local f14_local17 = Engine.TableLookup(StatsTable.File, StatsTable.Cols.ExternalRef, f14_local5,
                StatsTable.Cols.ContentPromo)
            if f14_local17 ~= nil and f14_local17 ~= "0" and f14_local17 ~= "" then
                f14_local16 = f14_local16 .. ":" .. f14_local17
            end

            for f14_local18 = 1, #f14_arg1.cacLootTabs, 1 do
                local f14_local21 = f14_local18

                f14_local1.tabManager:addTab(Cac.GetSelectedControllerIndex(),
                    Engine.Localize(f14_arg1.cacLootTabs[f14_local21].name), function(f18_arg0, f18_arg1)
                        local f18_local0 = f14_local1
                        local f18_local1 = f18_local0
                        f18_local0 = f18_local0.PopulateListCamo
                        local f18_local2 = f14_local1.overrideStorageCategory

                        if not f18_local2 then
                            f18_local2 = f14_arg1.storageCategory
                        end

                        f18_local0(f18_local1, f18_local2, f14_arg1.weaponType, f14_local5, nil,
                            f14_local1.parentCategory, f14_arg1.cacLootTabs[f14_local21].category)
                        f18_local0 = LUI.FlowManager.GetMenuScopedDataFromElement(f14_local1)
                        if f18_local0 then
                            f18_local0.tabIndex = f14_local21
                        end
                    end, nil, nil, nil, nil, false)

                if not f14_local14 then
                    if f14_local5 then
                        local f14_local22 = LUI.MPLootDropsBase.GetLootDropListFromString(
                            f14_arg1.cacLootTabs[f14_local21].category)
                        for f14_local23 = 1, #f14_local22, 1 do
                            if f14_local22[f14_local23] == f14_local16 then
                                f14_local1.tabManager.tabSelected = f14_local21
                                f14_local14 = true
                            end
                        end
                    else
                        f14_local1.tabManager.tabSelected = 1
                        f14_local14 = true
                    end
                end
            end
        end

        f14_local1.tabManager:refreshTab(Cac.GetSelectedControllerIndex())
    else
        f14_local1:PopulateListCamo(f14_local1.overrideStorageCategory or f14_arg1.storageCategory, f14_arg1.weaponType,
            f14_local5, nil, f14_local1.parentCategory)
    end

    return f14_local1
end

LUI.MenuBuilder.m_types_build["CacDetails"] = LUI.CacDetails.new
