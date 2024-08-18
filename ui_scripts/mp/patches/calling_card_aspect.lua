local cc = luiglobals.require("LUI.mp_menus.CallingCardMenu")
local f0_local0 = 7
local f0_local1 = 3
local f0_local3 = 52
local f0_local4 = 240
local f0_local6 = f0_local4 * f0_local1

cc.BuildGrid = function(menu, controller, category, cc_data)
    local f9_local0 = menu.list
    if menu.grid then
        f9_local0 = menu.grid
    end
    if f9_local0 ~= nil and f9_local0.listPagerScrollIndicator ~= nil then
        f9_local0.listPagerScrollIndicator:close()
        f9_local0.listPagerScrollIndicator = nil
    end
    local f9_local1 = {}
    local f9_local2 = 10
    local f9_local3 = f9_local2
    local f9_local4 = f9_local2
    local f9_local5, f9_local6, f9_local7, f9_local8 = nil
    if menu.gridMask ~= nil then
        f9_local5, f9_local6, f9_local7, f9_local8 = menu.gridMask:getLocalRect()
    elseif menu.list and f9_local3 ~= nil and f9_local4 ~= nil then
        local f9_local9, f9_local10, f9_local11, f9_local12 = menu.list:getLocalRect()
        f9_local8 = f9_local12
        f9_local7 = f9_local11
        f9_local6 = f9_local10
        f9_local5 = f9_local9 - f9_local3
        f9_local6 = f9_local6 - f9_local4
    end
    f9_local1.iconHeight = f0_local3 * 0.75
    f9_local1.height = f0_local3
    f9_local1.width = f0_local4
    f9_local1.anchorType = CoD.AnchorTypes.TopLeft
    f9_local1.primaryFontHeight = f9_local1.height * 0.07
    f9_local1.primaryTextLeft = 14
    f9_local1.primaryTextRight = -10
    f9_local1.primaryTextTop = 5
    f9_local1.secondaryFontHeight = f9_local1.primaryFontHeight * 0.85
    f9_local1.secondaryTextRight = -10
    f9_local1.secondaryTextTop = f9_local1.primaryTextTop + f9_local1.primaryFontHeight + 2
    f9_local1.iconCentered = true
    f9_local1.gridProps = {
        elementsPerRow = f0_local1,
        rowHeight = f9_local1.height,
        rows = f0_local0,
        hSpacing = f9_local3,
        vSpacing = f9_local4,
        left = f9_local5,
        top = f9_local6
    }
    if menu.grid then
        menu.grid:closeTree()
        menu.grid:close()
        menu.gridMask:close()
        menu.grid = nil
        menu.list:closeTree()
        menu.list:close()
        menu.list.buttonCount = 0
    elseif f9_local0 then
        local f9_local9 = f9_local0:getParent()
        f9_local0.buttonCount = 0
        f9_local0:closeTree()
        if f9_local9 then
            f9_local9:addElement(f9_local0)
            ListPaging.Reset(f9_local0)
        end
        f9_local0.pagingData = nil
    else
        menu.list:closeTree()
        menu.list:close()
        menu.list.buttonCount = 0
        if menu.gridMask then
            menu.gridMask:close()
            menu.gridMask = nil
        end
    end
    run_gc()
    run_gc()
    local f9_local9 = Cao.GetCallingCard(controller)
    local f9_local10 = {}
    local f9_local11 = RegisterMaterial("white")
    local f9_local12 = RegisterMaterial("s1_icon_locked_full")
    local f9_local13 = RegisterMaterial("h1_ui_btn_focused_stroke_square")
    local f9_local14 = RegisterMaterial("h1_ui_menu_icon_equipped")

    local cc_data_count = cc_data[category]
    if cc_data_count then
        for index = 1, #cc_data_count, 1 do
            local f9_local19 = index
            local get_item_sticker_state = false

            if IsPublicMatch() then
                get_item_sticker_state = LUI.InventoryUtils.GetItemNewStickerState(controller,
                    cc_data_count[f9_local19].image)
            end

            local cc_loot_data = cc_data_count[f9_local19].lootData
            if not cc_loot_data then
                cc_loot_data = true
            end

            local calling_card = cc.CallingCard(f9_local19, cc_data_count[f9_local19], f0_local4 * 0.75,
                f0_local3 * 0.75, get_item_sticker_state, f9_local11, f9_local12, f9_local13, f9_local14)
            local f9_local24 = cc_data_count[f9_local19].lootData
            if not f9_local24 then
                f9_local24 = cc_data_count[f9_local19]
            end
            f9_local1.locked = nil
            f9_local1.iconLeftOffset = nil
            f9_local1.iconTopOffset = nil
            f9_local1.iconHeight = f0_local3 * 0.75
            f9_local1.iconName = nil
            f9_local1.customIcon = nil
            local f9_local25

            if cc_loot_data then
                f9_local1.actionFunc = function(f10_arg0, f10_arg1)
                    LUI.MPDepotHelp.OnAction(calling_card, f10_arg1, menu, cc_data_count[f9_local19].lootData)
                end
                f9_local1.primaryText = ""
                f9_local1.secondaryText = ""
                f9_local1.extraImagePadding = f9_local24.padding
                f9_local1.rarity = f9_local24.lootRarity
                f9_local1.equipped = f9_local9 == tonumber(calling_card.data.cardIndex)
                f9_local1.externalElement = calling_card
                f9_local1.extraElems = {}
                f9_local25 = nil

                if f9_local24.lockState == nil and f9_local24.locked == true then
                    f9_local1.locked = true
                elseif f9_local24.lockState == "Locked" then
                    if not IsContentPromoUnlocked(f9_local24.contentPromo) then
                        f9_local1.locked = true
                        f9_local1.iconName = "s1_icon_locked_full"
                    elseif Cac.IsRewardType(f9_local24.inventoryItemType) then
                        f9_local1.iconName = "collection_reward_locked"
                        f9_local1.locked = nil
                    elseif Cac.IsCraftableType(f9_local24.inventoryItemType) then
                        f9_local25 = f9_local24.price
                        if f9_local1.iconCentered then
                            f9_local1.iconTopOffset = -15
                            f9_local1.iconLeftOffset = -18
                        else
                            f9_local1.iconLeftOffset = -46
                            f9_local1.iconTopOffset = 16
                        end
                        local f9_local26 = 1000
                        while f9_local26 - 1 < f9_local25 do
                            f9_local1.iconLeftOffset = f9_local1.iconLeftOffset - 8
                            f9_local26 = f9_local26 * 10
                        end
                        f9_local1.iconHeight = 28
                        f9_local1.iconName = GetCurrencyImage(InventoryCurrencyType.Parts)
                        f9_local1.secondaryImage = nil
                        f9_local1.locked = nil
                    end
                end
                if f9_local1.iconName ~= nil then
                    calling_card.fader:registerAnimationState("scaledBack", {
                        alpha = 0.75
                    })
                    calling_card.fader:animateToState("scaledBack")
                end
                f9_local1.listDefaultFocus = f9_local1.equipped
                
				local f9_local22 = LUI.CacBase.AddCacButton(menu, f9_local1)
                if cc_loot_data == false then
                    f9_local22:clearActionSFX()
                end

                f9_local1.externalElement = nil

                if f9_local25 then
                    LUI.MPDepotBase.AddInfoToButton(menu, f9_local22, f9_local25, true, 60, LUI.Alignment.Right)
                end

                calling_card.id = "card_button_" .. category .. "_" .. f9_local19
                calling_card:registerEventHandler("button_over", menu.UpdateInfo)
                calling_card:registerEventHandler("button_over_disable", menu.UpdateInfo)
                calling_card.category = category
                calling_card.passThruFunc = function(f11_arg0, f11_arg1)
                    cc.CallingCardEquip(f11_arg0, f11_arg1, menu)
                end
                f9_local10[f9_local19] = calling_card.image
                f9_local1.externalElement = nil
            end

            f9_local25 = nil
        end

        local index = {
            containerWidth = f0_local6,
            containerHeight = 32
        }

        local scrollIndicatorParent = LUI.UIElement.new({
            topAnchor = false,
            bottomAnchor = true,
            leftAnchor = true,
            left = 288,
            top = -96,
            height = index.containerHeight
        })
        menu:addElement(scrollIndicatorParent)
        menu.scrollIndicatorParent = scrollIndicatorParent

        ListPaging.InitGrid(menu.grid, f0_local0, nil, false, scrollIndicatorParent, index)
        ListPaging.InitStreaming(menu.grid, f9_local10, StreamingCount)
        local f9_local18, f9_local19, get_item_sticker_state, cc_loot_data = menu.gridMask:getLocalRect()
        if not menu.tabManager then
            menu:AddListDivider(nil, f9_local18 + f9_local1.gridProps.hSpacing,
                f9_local19 + f9_local1.gridProps.vSpacing, get_item_sticker_state - f9_local1.gridProps.hSpacing,
                cc_loot_data)
        end

        if not LUI.FlowManager.IsTopMenuModal() then
            menu.grid:processEvent({
                name = "gain_focus",
                controller = controller
            })
        else
            return mask
        end
    end

    return mask
end

cc.BuildInfoPane = function(menu, controller)
    local self = LUI.UIElement.new({
        rightAnchor = true,
        topAnchor = true,
        top = -28,
        right = -25,
        width = 355
    })
    controller:addElement(self)
    local f12_local1 = CoD.CreateState(0, 15, 0, nil, CoD.AnchorTypes.TopLeftRight)
    f12_local1.height = 68
    local f12_local2 = LUI.UIElement.new(f12_local1)
    f12_local2:setUseStencil(true)
    self:addElement(f12_local2)
    local f12_local3 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.None)
    f12_local3.width = f12_local1.height
    f12_local3.height = f12_local1.height
    f12_local3.material = RegisterMaterial("h1_ui_loader_emblem")
    f12_local2:addElement(LUI.UIImage.new(f12_local3))
    local f12_local4 = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All)
    f12_local4.material = RegisterMaterial("black")
    local f12_local5 = LUI.UIImage.new(f12_local4)
    f12_local2:addElement(f12_local5)

    local itemModelLockOverlay = LUI.CacDetails.MakeLockOverlay(
        CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.None), 400, 0.9, {
            topAnchor = true,
            top = 37,
            width = 300
        }, {
            topAnchor = true,
            top = -15,
            width = 300
        })
    f12_local5:addElement(itemModelLockOverlay)
    menu.itemModelLockOverlay = itemModelLockOverlay

    local itemLockReasonLabel = LUI.UIText.new({
        color = Colors.white,
        height = 14,
        font = CoD.TextSettings.BodyFont.Font,
        bottom = -27,
        topAnchor = true,
        width = 300,
        alpha = 1
    })
    itemLockReasonLabel:registerAnimationState("hidden", {
        alpha = 0
    })
    itemLockReasonLabel:setText(Engine.Localize("@DEPOT_LOCKED_LIVE_EVENT_EXPIRED"))
    itemModelLockOverlay:addElement(itemLockReasonLabel)
    menu.itemLockReasonLabel = itemLockReasonLabel

    self:addElement(LUI.Divider.new({
        leftAnchor = true,
        rightAnchor = true,
        topAnchor = true,
        top = 90
    }, 5, LUI.Divider.Green))
    local f12_local8 = LUI.ItemDescriptionWidget.new({
        topAnchor = true,
        leftAnchor = true,
        top = 105
    }, 350)
    f12_local8:registerAnimationState("default", {
        alpha = 1
    })
    f12_local8:registerAnimationState("hidden", {
        alpha = 0
    })
    menu.itemDescriptionWidget = f12_local8
    self:addElement(f12_local8)
    local f12_local9 = LUI.UIVerticalList.new({
        topAnchor = true,
        leftAnchor = true,
        rightAnchor = true,
        top = 335,
        spacing = 40
    })
    local f12_local10 = CombatRecord.GetRankInfo(menu.exclusiveController)
    local f12_local11 = {
        gamertag = CoD.FormatClanAndGamerTags(Engine.GetCustomClanTag(menu.exclusiveController),
            Engine.GetUsernameByController(menu.exclusiveController)),
        clantag = Engine.GetProfileDataUseEliteClanTag(menu.exclusiveController) and
            Clan.GetTag(menu.exclusiveController) or Engine.GetCustomClanTag(menu.exclusiveController),
        background = Cao.GetCallingCard(menu.exclusiveController),
        xuid = Engine.GetXUIDByController(menu.exclusiveController),
        emblem = Cao.GetEmblemPatch(menu.exclusiveController),
        prestige = f12_local10.prestige,
        rank = f12_local10.rank
    }
    local f12_local12 = LUI.UIElement.new({
        topAnchor = true,
        height = 40
    })
    local f12_local13 = LUI.UIText.new({
        color = Colors.white,
        height = 14,
        font = CoD.TextSettings.BodyFont.Font,
        alpha = 0.4,
        top = -40
    })
    f12_local13:setText(Engine.Localize("@LUA_MENU_PREVIEW"))
    f12_local12:addElement(f12_local13)
    f12_local9:addElement(f12_local12)
    local f12_local14 = LUI.Playercard.new({
        scale = 0.35,
        topAnchor = true,
        top = 13
    }, f12_local11)
    menu.playerCard = f12_local14
    f12_local12:addElement(f12_local14)
    self:addElement(f12_local9)
    menu.UpdateInfo = function(f13_arg0, f13_arg1)
        local f13_local0 = f13_arg1.controller
        if f13_local0 == nil then
            local f13_local1 = LUI.FlowManager.GetMenuScopedDataFromElement(menu)
            f13_local0 = f13_local1.exclusiveControllerIndex
        end
        menu.depotHelp:OnFocus(f13_local0, f13_arg0.data.lootData)
        f12_local5:closeChildren()
        menu.playerCard:feedContent({
            background = f13_arg0.data.cardIndex
        })
        if f13_arg0.data.animatedTable == nil or f13_arg0.data.animatedTable == "" then
            f12_local5:setImage(f13_arg0.image)
        else
            local f13_local2 = LUI.Playercard.CreateAnimatedCallingCard(f13_arg0.data.animatedTable, f12_local1.height)
            if f13_local2 then
                f12_local5:addElement(f13_local2)
                f12_local5:setImage(RegisterMaterial("black"))
            end
        end
        if f13_arg0.data.unlockData ~= nil and f13_arg0.data.unlockData.lockStatus ~= Cac.ItemLockStatus.Unlocked and
            (f13_arg0.data.unlockData.unlockChallenge == nil or f13_arg0.data.unlockData.unlockChallenge == "") then
            menu.itemDescriptionWidget:animateToState("default")
            menu.itemDescriptionWidget:Update(Engine.Localize(f13_arg0.data.name),
                f13_arg0.data.unlockData.unlockMessage)
            menu.itemDescriptionWidget:ClearColor()
        elseif f13_arg0.data.unlockData.unlockChallenge and f13_arg0.data.unlockData.unlockChallenge ~= "" then
            local f13_local2, f13_local3 = ParseChallengeName(f13_arg0.data.unlockData.unlockChallenge)
            local f13_local4 = GetChallengeData(f13_local0, f13_local2, nil, nil, f13_local3)
            if f13_local4 then
                menu.itemDescriptionWidget:animateToState("default")
                local f13_local5 = nil
                if f13_local4.prerequisite then
                    f13_local5 = f13_local4.prerequisite
                else
                    f13_local5 = GetChallengeNameWithTier(f13_local2, f13_local3)
                end
                menu.itemDescriptionWidget:Update(Engine.Localize(f13_arg0.data.name), f13_local5, nil, f13_local4)
            end
            menu.itemDescriptionWidget:ClearColor()
        else
            menu.itemDescriptionWidget:Update(Engine.Localize(f13_arg0.data.name), "", nil, nil,
                f13_arg0.data.lootData and f13_arg0.data.lootData.guid or nil)
            if f13_arg0.data.lootData and f13_arg0.data.lootData.lootRarity then
                menu.itemDescriptionWidget:ColorForPerks(f13_arg0.data.lootData.lootRarity.color)
            else
                menu.itemDescriptionWidget:ClearColor()
            end
        end
        if IsPublicMatch() then
            LUI.NewSticker.Update(f13_arg0)
            local f13_local2 = "cc_" .. f13_arg0.category
            LUI.InventoryUtils.SetNewStickerState(f13_local0, f13_arg0.data.image, "CallingCard", f13_local2, false)
            if not LUI.InventoryUtils.GetSubCategoryNewStickerState(Cac.GetSelectedControllerIndex(), f13_local2) and
                menu.tabManager and menu.tabManager.tabsList ~= nil and menu.tabManager.tabSelected <=
                #menu.tabManager.tabsList then
                local f13_local4 = menu.tabManager.tabsList[menu.tabManager.tabSelected]
                if f13_local4 and f13_local4.tabHeader then
                    LUI.NewSticker.Update(f13_local4.tabHeader)
                end
            end
        end
        f12_local5:addElement(menu.itemModelLockOverlay)
        menu.itemModelLockOverlay:setPriority(501)
        if f13_arg0.disabled == true or f13_arg0.data.lootData and f13_arg0.data.lootData.lockState == "Locked" then
            menu.itemModelLockOverlay:show()
            if f13_arg0.data.lootData and IsContentPromoUnlocked(f13_arg0.data.lootData.contentPromo) == false then
                menu.itemLockReasonLabel:animateToState("default")
            else
                menu.itemLockReasonLabel:animateToState("hidden")
            end
        else
            menu.itemModelLockOverlay:hide()
            menu.itemLockReasonLabel:animateToState("hidden")
        end
    end

end
