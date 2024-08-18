-- PlayercardDesigner.lua --
LUI.Playercard = {}
LUI.Playercard.Width = 248 -- 248--273.33
LUI.Playercard.Height = LUI.Playercard.Width / 2.8 -- 64
LUI.Playercard.CallingCard = {}
LUI.Playercard.CallingCard.Aspect = 2.97
LUI.Playercard.CallingCard.Width = (LUI.Playercard.Height * LUI.Playercard.CallingCard.Aspect) * 0.75
LUI.Playercard.CallingCard.Height = LUI.Playercard.Height
LUI.Playercard.build = function(f1_arg0, f1_arg1, f1_arg2)
    return LUI.Playercard.new()
end

LUI.Playercard.new = function(menu, args)
    if menu == nil then
        menu = CoD.CreateState(0, 0, nil, nil, CoD.AnchorTypes.TopLeft)
    end
    menu.width = LUI.Playercard.Width
    menu.height = LUI.Playercard.Height

    local mainElement = LUI.UIElement.new(menu)
    local f2_local1 = CoD.CreateState(nil, 0, 0, nil, CoD.AnchorTypes.TopRight)
    f2_local1.width = LUI.Playercard.CallingCard.Width
    f2_local1.height = LUI.Playercard.CallingCard.Height

    local bgContainer = LUI.UIElement.new(f2_local1)
    bgContainer.id = "backgroundContainer"
    bgContainer:setUseStencil(true)
    mainElement:addElement(bgContainer)

    local backgroundBorder = LUI.UIBorder.new({
        borderThickness = 3,
        color = Colors.black,
        width = LUI.Playercard.Width,
        height = LUI.Playercard.Height - 10
    })
    mainElement:addElement(backgroundBorder)

    local darken = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.None)
    darken.width = LUI.Playercard.Width
    darken.height = LUI.Playercard.Height - 10
    darken.material = RegisterMaterial("black")
    darken.alpha = 0.25
    mainElement:addElement(LUI.UIImage.new(darken))

    local background = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.None)
    background.width = LUI.Playercard.Width
    background.height = LUI.Playercard.Height - 10
    background.material = RegisterMaterial("h2m_ui_playercard_bg")

    local background_image = LUI.UIImage.new(background)
    if Engine.InFrontend then
        background_image:setHandleMouse(true)
        background_image:registerEventHandler("leftmousedown", function(element, event)
            local f10_local0 = Engine.GetLuiRoot()
            if f10_local0:IsMenuInStack("PlayercardMenu") == false then
                Engine.PlaySound(CoD.SFX.MenuAccept)
                Cac.SetSelectedControllerIndex(Engine.GetFirstActiveController())
                LUI.FlowManager.RequestAddMenu(menu, "PlayercardMenu", true, Engine.GetFirstActiveController(), false,
                    {})
            end
        end)
    end
    mainElement:addElement(background_image)

    -- Calling Card --
    local callingCardState = CoD.CreateState(0, 0, nil, nil, CoD.AnchorTypes.TopLeft)
    callingCardState.width = LUI.Playercard.CallingCard.Width
    callingCardState.height = LUI.Playercard.CallingCard.Width * 0.2
    mainElement.background = LUI.UIImage.new(callingCardState)
    mainElement.background.id = "background"
    mainElement:addElement(mainElement.background)

    -- Emblem --
    local emblemState = CoD.CreateState(nil, 7, -2, nil, CoD.AnchorTypes.TopRight)
    emblemState.material = RegisterMaterial("white")
    emblemState.height = 50
    emblemState.width = emblemState.height
    mainElement.emblem = LUI.UIImage.new(emblemState)
    mainElement.emblem.state = emblemState
    mainElement:addElement(mainElement.emblem)

    local gamertagState = CoD.CreateState(8, nil, nil, -31, CoD.AnchorTypes.BottomLeft)
    gamertagState.width = callingCardState.width * 0.95
    gamertagState.height = 19
    gamertagState.font = CoD.TextSettings.H1TitleFont.Font
    gamertagState.alignment = LUI.Alignment.Left
    gamertagState.color = Colors.white

    mainElement.gamertag = LUI.UIText.new(gamertagState)
    mainElement.gamertag.state = gamertagState
    mainElement.gamertag:setTextStyle(CoD.TextStyle.Outlined)
    mainElement:addElement(mainElement.gamertag)
    mainElement.gamertag:setupAutoScaleText()

    -- Separator --
    local separatorState = CoD.CreateState(nil, nil, nil, -28.5, CoD.AnchorTypes.BottomLeft)
    separatorState.width = LUI.Playercard.Width
    separatorState.height = 1.4
    separatorState.color = Colors.black
    separatorState.alpha = 0.7
    local separator = LUI.UIImage.new(separatorState)
    mainElement:addElement(separator)

    local clantagState = CoD.CreateState(8, nil, nil, -8, CoD.AnchorTypes.BottomLeft)
    clantagState.height = 17.5
    clantagState.font = CoD.TextSettings.H1TitleFont.Font
    clantagState.alignment = LUI.Alignment.Left
    clantagState.color = Colors.white

    mainElement.clantag = LUI.UIText.new(clantagState)
    mainElement.clantag.state = clantagState
    mainElement.clantag:setTextStyle(CoD.TextStyle.Outlined)
    mainElement:addElement(mainElement.clantag)

    -- mainElement.gamertag:debugDraw()

    -- Rank --
    if Engine.GetOnlineGame() then
        local rankTextState = CoD.CreateState(nil, nil, -5, -9, CoD.AnchorTypes.BottomRight)
        rankTextState.height = 16.5
        rankTextState.width = 31
        rankTextState.font = CoD.TextSettings.TitleFontSmallBold.Font
        rankTextState.alignment = LUI.Alignment.Center
        rankTextState.color = Colors.white
        mainElement.rank = LUI.UIText.new(rankTextState)
        mainElement.rank.id = "rank"
        mainElement.rank:setTextStyle(CoD.TextStyle.Outlined)
        mainElement:addElement(mainElement.rank)

        local rankIconState = CoD.CreateState(nil, nil, -36, -8, CoD.AnchorTypes.BottomRight)
        rankIconState.width = 18
        rankIconState.height = 18
        rankIconState.material = RegisterMaterial("white")
        mainElement.rankIcon = LUI.UIImage.new(rankIconState)
        mainElement.rankIcon.state = rankIconState
        mainElement:addElement(mainElement.rankIcon)
    end

    mainElement.feedContent = LUI.Playercard.FeedContent
    mainElement:registerEventHandler("update_playercard", function(element, event)
        element:feedContent(event)
    end)

    if not Engine.InFrontend() then
        mainElement:registerEventHandler("update_playercard_for_clientnum", function(element, event)
            assert(event.clientNum)
            local f4_local0 = event.clientNum
            if f4_local0 >= 0 then
                local f4_local1 = Game.GetPlayerCard(f4_local0)
                local f4_local2 = Game.GetPlayerScoreInfo(f4_local0)
                if f4_local1 and f4_local2 then
                    element:feedContent({
                        name = "update_playercard",
                        gamertag = f4_local2.name,
                        rank = f4_local2.rank,
                        prestige = f4_local2.prestige,
                        background = f4_local1.background,
                        emblem = f4_local1.patch,
                        xuid = f4_local1.xuid
                    })
                end
            end
        end)
    end
    if args ~= nil then
        mainElement:feedContent(args)
    end
    return mainElement
end

LUI.Playercard.AnimatedTableToFunc = function(f5_arg0)
    local f5_local0 = LUI.Playercard[f5_arg0]
    local f5_local1
    if f5_local0 then
        f5_local1 = f5_local0.new
        if not f5_local1 then

        else
            return f5_local1
        end
    end
    f5_local1 = nil
end

LUI.Playercard.CreateAnimatedCallingCard = function(f6_arg0, f6_arg1, f6_arg2, f6_arg3)
    local f6_local0 = LUI.Playercard.AnimatedTableToFunc(f6_arg0)
    if f6_local0 then
        local f6_local1 = f6_local0()
        if f6_local1 then
            local f6_local2 = CoD.CreateState(f6_arg2, f6_arg3, nil, nil, CoD.AnchorTypes.None)
            f6_local2.width = LUI.Playercard.CallingCard.Width
            f6_local2.height = LUI.Playercard.CallingCard.Height
            if f6_arg1 ~= nil then
                f6_local2.scale = f6_arg1 / LUI.Playercard.Height - 1
            end
            local self = LUI.UIElement.new(f6_local2)
            self:setUseStencil(true)
            self:addElement(f6_local1)
            return self
        end
    end
    return nil
end

local function _ExtractClanTag(f1_arg0)
    local f1_local0 = ""
    local f1_local1 = f1_arg0
    if string.sub(f1_local1, 1, 1) == "[" then
        local f1_local2 = string.find(f1_local1, "]")
        if f1_local2 then
            f1_local0 = string.sub(f1_local1, 1, f1_local2)
            f1_local1 = string.sub(f1_local1, f1_local2 + 1)
        end
    end
    return f1_local0, f1_local1
end

LUI.Playercard.FeedContent = function(f7_arg0, f7_arg1)
    local is_private_match = Engine.GetDvarBool("xblive_privatematch") == true
    if is_private_match then
        f7_arg1.background = 0
        f7_arg1.emblem = 0
        f7_arg1.rank = 0
        f7_arg1.prestige = 0
    end

    local f7_local0 = f7_arg0

    if f7_local0.gamertag and f7_arg1.gamertag then
        local clantag, gamertag = _ExtractClanTag(f7_arg1.gamertag)
        if f7_local0.clantag then
            f7_local0.clantag:setText(clantag)
        end
        f7_local0.gamertag:setText(gamertag)
        local f7_local1, f7_local2, f7_local3, f7_local4 = GetTextDimensions(gamertag, f7_local0.gamertag.state.font,
            f7_local0.gamertag.state.height)
    end
    if f7_local0.rank and f7_arg1.rank then
        f7_local0.rank:setText(Rank.GetRankDisplay(f7_arg1.rank))
    end
    if f7_local0.rankIcon and f7_arg1.rank then
        if f7_arg1.prestige ~= nil and f7_arg1.prestige > 0 then
            f7_local0.rankIcon:setImage(RegisterMaterial(Rank.GetRankIcon(f7_arg1.rank, f7_arg1.prestige,
                f7_arg1.rankIcons))) -- .. "_small" ) )
        else
            f7_local0.rankIcon:setImage(RegisterMaterial(Rank.GetRankIcon(f7_arg1.rank, 0, f7_arg1.rankIcons)))
        end
    end
    if f7_local0.background and f7_arg1.background and f7_local0.backgroundImage ~= f7_arg1.background then
        f7_local0.backgroundImage = f7_arg1.background
        f7_local0.background:closeChildren()
        local f7_local1 = Engine.TableLookupByRow(CallingCardTable.File, tonumber(f7_arg1.background),
            CallingCardTable.Cols.AnimatedTable)
        if f7_local1 ~= nil and f7_local1 ~= "" then
            local f7_local2 = LUI.Playercard.CreateAnimatedCallingCard(f7_local1)
            if f7_local2 then
                f7_local0.background:addElement(f7_local2)
                f7_local0.background:setImage(RegisterMaterial("black"))
            end
        else
            local f7_local2 = Engine.TableLookupByRow(CallingCardTable.File, tonumber(f7_arg1.background),
                CallingCardTable.Cols.Image)
            if f7_local2 and f7_local2 ~= "" then
                f7_local0.background:animateToState("default")
                local f7_local3 = RegisterMaterial(f7_local2)
                Engine.CacheMaterial(f7_local3)
                f7_local0.background:setImage(f7_local3)
            end
        end
    end
    if f7_arg1.background then
        local f7_local1 = {
            r = tonumber(Engine.TableLookupByRow(CallingCardTable.File, tonumber(f7_arg1.background),
                CallingCardTable.Cols.WedgeR))
        }
        if f7_local1.r ~= nil then
            f7_local1.r = f7_local1.r / 255
            f7_local1.g = tonumber(Engine.TableLookupByRow(CallingCardTable.File, tonumber(f7_arg1.background),
                CallingCardTable.Cols.WedgeG)) / 255
            f7_local1.b = tonumber(Engine.TableLookupByRow(CallingCardTable.File, tonumber(f7_arg1.background),
                CallingCardTable.Cols.WedgeB)) / 255
        else
            f7_local1 = Colors.black
        end
        if f7_local0.wedge then
            f7_local0.wedge.state.color = f7_local1
            f7_local0.wedge:registerAnimationState("default", f7_local0.wedge.state)
            f7_local0.wedge:animateToState("default")
        end
    end
    if f7_local0.emblem and f7_arg1.emblem then
        local f7_local1 = Engine.TableLookupByRow(EmblemIconTable.File, tonumber(f7_arg1.emblem),
            EmblemIconTable.Cols.Image)
        if f7_local1 and f7_local1 ~= "" then
            local f7_local2 = RegisterMaterial(f7_local1)
            Engine.CacheMaterial(f7_local2)
            f7_local0.emblem:setImage(f7_local2)
        end
    end
end

LUI.MenuBuilder.m_types_build["playercard"] = LUI.Playercard.build

if Engine.InFrontend() then

    -- playercard.lua --

    local edit_name = false

    function InputTagComplete(f1_arg0, f1_arg1)
        if f1_arg1.text then
            if not edit_name then
                Engine.SetAndEnableCustomClanTag(f1_arg1.controller, f1_arg1.text)
                RefreshTagAndName(f1_arg0, f1_arg1)
            end

            if edit_name then
                Engine.SetDvarString("name", f1_arg1.text)
                RefreshTagAndName(f1_arg0, f1_arg1)
            end
        end
    end

    function RefreshTagAndName(f2_arg0, f2_arg1)
        f2_arg0:dispatchEventToRoot({
            name = "update_playercard",
            gamertag = CoD.FormatClanAndGamerTags(Engine.GetCustomClanTag(f2_arg1.controller),
                Engine.GetUsernameByController(f2_arg1.controller)),
            immediate = true
        })
    end

    function AddPlayerCard(menu, controller)
        local playerData = {
            gamertag = CoD.FormatClanAndGamerTags(Engine.GetCustomClanTag(controller),
                Engine.GetUsernameByController(controller)),
            background = Cao.GetCallingCard(controller),
            emblem = Cao.GetEmblemPatch(controller),
            xuid = Engine.GetXUIDByController(controller),
            controller = controller
        }

        if Engine.DoWeHaveStats(controller) then
            local experience = Engine.GetPlayerDataMPXP(controller)
            playerData.prestige = Lobby.GetPlayerPrestigeLevel(controller)
            playerData.rank = Lobby.GetRankForXP(experience, playerData.prestige)
        else
            playerData.rank = 0
            playerData.prestige = 0
        end

        local grid = CoD.DesignGridHelper(7)
        local topList = LUI.MenuTemplate.ListTop
        menu:addElement(LUI.Playercard.new(CoD.CreateState(-grid, topList, nil, nil, CoD.AnchorTypes.TopRight),
            playerData))
        local dividerState = CoD.CreateState(-grid, topList - H1MenuDims.spacing, nil, nil, CoD.AnchorTypes.TopRight)
        dividerState.width = LUI.Playercard.Width
        dividerState.height = 2
        menu:addElement(LUI.Divider.new(dividerState))
        menu:registerEventHandler("text_input_complete", InputTagComplete)
    end

    local unlock_pro_version_if_owned = function(existingPerk, classIndex)
        if existingPerk == nil or existingPerk == "specialty_null" then
            return false
        end

        local upgradedPerk =
            Engine.TableLookup(PerkTable.File, PerkTable.Cols.Ref, existingPerk, PerkTable.Cols.Upgrade)
        local upgradedPerkSlot = Engine.TableLookup(PerkTable.File, PerkTable.Cols.Ref, existingPerk,
            PerkTable.Cols.Slot)
        if upgradedPerk ~= nil and upgradedPerk ~= "" then
            local pro_perk_unlock_table = Engine.TableLookup(UnlockTable.File, UnlockTable.Cols.ItemId, upgradedPerk,
                UnlockTable.Cols.Challenge)
            if pro_perk_unlock_table ~= nil and pro_perk_unlock_table ~= "" then
                local f8_local24, f8_local25 = ParseChallengeName(pro_perk_unlock_table)
                local challenge_data = GetChallengeData(Cac.GetSelectedControllerIndex(), f8_local24, false, f8_local25)
                if challenge_data.Completed == true then
                    local original_is_unlocked = Cac.IsClassItemUnlocked(Cac.GetSelectedControllerIndex(), existingPerk)
                    if original_is_unlocked and Engine.IsItemUnlocked(Cac.GetSelectedControllerIndex(), upgradedPerk) then
                        Cac.SelectEquippedWeapon(upgradedPerkSlot, 0, upgradedPerk, LUI.CacStaticLayout.ClassLoc,
                            classIndex)
                        return true
                    end
                end
            end
        end

        return false
    end

    local handle_perk_upgrades = function()
        local customClassCount = Cac.GetCustomClassCount(LUI.CacStaticLayout.ClassLoc)
        for class = 0, customClassCount - 1, 1 do
            local class_loadout = Cac.GetLoadout(LUI.CacStaticLayout.ClassLoc, class)
            local is_slot_one_upgraded = unlock_pro_version_if_owned(class_loadout.perk1, class)
            local is_slot_two_upgraded = unlock_pro_version_if_owned(class_loadout.perk2, class)
            local is_slot_three_upgraded = unlock_pro_version_if_owned(class_loadout.perk3, class)
        end
    end

    LUI.MPLobbyBase.new = function(f27_arg0, f27_arg1)
        LUI.MPLobbyBase.CollectGarbage()
        local f27_local0 = f27_arg1 or {}
        f27_local0.subContainer = true
        f27_local0.persistentBackground = PersistentBackground.Variants.VirtualLobby
        local f27_local1 = LUI.MenuTemplate.new(f27_arg0, f27_local0)
        f27_local1:setClass(LUI.MPLobbyBase)
        LUI.CacStaticLayout.ClassLoc = Cac.GetCustomClassLoc()
        f27_local1:registerEventHandler("menu_close", LUI.MPLobbyBase.OnClose)
        f27_local1.list:makeFocusable()
        local f27_local2 = f27_local0.memberListState

        local use_party_member_screen = false

        if not f27_local2 then
            -- use_party_member_screen = true
            f27_local2 = Lobby.MemberListStates.Lobby
        end

        if use_party_member_screen then
            local f27_local3 = LUI.MemberScreen.new
            local f27_local4 = {
                parentMenu = f27_local1,
                memberListState = f27_local2,
                isPublicLobby = IsPublicMatch()
            }
            local f27_local5 = IsPrivateMatch()
            if not f27_local5 then
                f27_local5 = Engine.GetSystemLink()
            end
            f27_local4.isPrivateLobby = f27_local5
            f27_local3 = f27_local3(f27_local4)
            f27_local1.subContainer:addElement(f27_local3)
            f27_local3.parentMenu = f27_local1
            f27_local1.memberList = f27_local3
            f27_local3:initNavTables()
            f27_local1.memberList:makeFocusable()
            f27_local1.list.navigation.right = f27_local3
            f27_local3.navigation.left = f27_local1.list
        else
            AddPlayerCard(f27_local1.subContainer, 0)
        end

        f27_local1:AddLobbyBackButton(function(f28_arg0, f28_arg1)
            if Engine.IsCoreMode() and Engine.GetDvarBool("virtualLobbyEnabled") and
                not Engine.GetDvarBool("virtualLobbyReady") then
                return
            else
                LUI.MPLobbyBase.OnBack(f28_arg0, f28_arg1, f27_local1)
            end
        end)
        if Engine.IsCoreMode() then
            LUI.InventoryUtils.ValidateEquippedLootItemsForAll()
        end
        Cac.IsAnyCustomClassRestrictedCache = false
        Cac.CustomClassIndexForRestrictCheck = 0
        SetupTheLobby(f27_local1)
        if f27_local0.has_match_summary then
            LobbyInitAAR(f27_local1, Lobby.AARTypes.Normal)
        end
        f27_local4 = LUI.CacFactionWidget.new(f27_local1, f27_local1.exclusiveController, false)
        f27_local1.factionWidget = f27_local4
        f27_local1:addElement(f27_local4)
        LUI.MPLobbyBase.CheckForAddESportsInfo(f27_local1, f27_arg0, f27_local0)
        f27_local1:setBlur(false)

        handle_perk_upgrades()
        return f27_local1
    end

    -- personalization.lua --

    local function OnCustomTag(f3_arg0, f3_arg1)
        edit_name = false

        Engine.ExecNow("banCheck " .. CoD.AntiCheat.Ban.FEATURE_BAN_CLAN_TAGS, f3_arg1.controller)
        Engine.OpenScreenKeyboard(f3_arg1.controller, Engine.Localize("@LUA_MENU_CUSTOM_CLAN_TAG_SYSTEM_DIALOG"),
            Engine.GetCustomClanTag(f3_arg1.controller) or "", 4, true, true)
        LUI.FlowManager.RequestLeaveMenu(f3_arg0)
    end

    local function RefreshTag(f2_arg0, f2_arg1)
        f2_arg0:dispatchEventToRoot({
            name = "update_playercard",
            gamertag = CoD.FormatClanAndGamerTags(Engine.GetCustomClanTag(f2_arg1.controller),
                Engine.GetUsernameByController(f2_arg1.controller)),
            immediate = true
        })
    end

    local function OnClearTag(f4_arg0, f4_arg1)
        Engine.ClearCustomClanTag(f4_arg1.controller)
        Engine.SetProfileDataUseEliteClanTag(f4_arg1.controller, false)
        RefreshTag(f4_arg0, f4_arg1)
        LUI.FlowManager.RequestLeaveMenu(f4_arg0)
    end

    local function OnEditName(f3_arg0, f3_arg1)
        -- wtf am i doing
        edit_name = true

        Engine.OpenScreenKeyboard(f3_arg1.controller, Engine.Localize("@MENU_NAME"), Engine.GetDvarString("name"), 20,
            true, true)
    end

    local tag_edit_feeder = function()
        local f8_local0 = {}

        table.insert(f8_local0, {
            type = "UIGenericButton",
            id = "editTag",
            properties = {
                style = GenericButtonSettings.Styles.GlassButton,
                substyle = GenericButtonSettings.Styles.GlassButton.SubStyles.Popup,
                button_text = Engine.Localize("@LUA_MENU_CUSTOM_CLAN_TAG"),
                index = #f8_local0 + 1,
                button_action_func = OnCustomTag
            }
        })

        table.insert(f8_local0, {
            type = "UIGenericButton",
            id = "clearTag",
            properties = {
                style = GenericButtonSettings.Styles.GlassButton,
                substyle = GenericButtonSettings.Styles.GlassButton.SubStyles.Popup,
                button_text = Engine.Localize("@LUA_MENU_CLEAR_YOUR_CLAN_TAG"),
                index = #f8_local0 + 1,
                button_action_func = OnClearTag
            }
        })

        return f8_local0
    end

    local function TagEditPopup(f9_arg0, f9_arg1)
        return LUI.MenuBuilder.BuildRegisteredType("generic_selectionList_popup", {
            popup_childfeeder = tag_edit_feeder,
            popup_title = ""
        })
    end

    LUI.MenuBuilder.m_types_build["TagEditPopup"] = TagEditPopup

    function _PlayercardMenu(f17_arg0, f17_arg1)
        if not f17_arg1 then
            f17_arg1 = {}
        end
        local f17_local0 = f17_arg1.exclusiveController
        local f17_local1 = LUI.MenuTemplate.new(f17_arg0, {
            menu_title = "@LUA_MENU_PERSONALIZATION_CAPS",
            persistentBackground = PersistentBackground.Variants.VirtualLobby
        })
        Cac.SetSelectedControllerIndex(f17_local0)

        local f17_local2 = {}
        if IsPublicMatch() and LUI.InventoryUtils.GetCategoryNewStickerState(f17_local0, "CallingCard") then
            f17_local2.showNewSticker = true
        end
        local f17_local3 = {}
        if IsPublicMatch() and LUI.InventoryUtils.GetCategoryNewStickerState(f17_local0, "Emblem") then
            f17_local3.showNewSticker = true
        end

        f17_local1:AddButton("@MENU_CALLING_CARD", "CallingCardMenu", nil, nil, nil, f17_local2)
        f17_local1:AddButton("@MENU_PLAYERCARD_ICONS", "EmblemMenu", nil, nil, nil, f17_local3)

        local f17_local4 = false
        local f17_local5 = Engine.IsXbox360()
        if not f17_local5 then
            f17_local5 = Engine.IsXB3()
        end
        if f17_local5 and not Engine.IsUserSignedInToLive(f17_local0) then
            f17_local4 = true
        end

        local f17_local6, f17_local7, f17_local8 = nil
        if Engine.GetOnlineGame() and not Engine.IsChatRestricted() then
            local f17_local10 = f17_local1:AddButton("LUA_MP_FRONTEND_TAG", "TagEditPopup", f17_local4, nil, nil,
                f17_local9)
            f17_local10:clearActionSFX()
        end

        -- name button

        local edit_name = f17_local1:AddButton("MENU_NAME", OnEditName, nil, nil, nil)
        edit_name:clearActionSFX()

        AddPlayerCard(f17_local1, f17_local0)

        f17_local1:AddMenuDescription(3)
        local verticalList = LUI.UIVerticalList.new({
            topAnchor = true,
            bottomAnchor = true,
            leftAnchor = true,
            rightAnchor = false,
            top = 162,
            left = LUI.Playercard.Width + 7,
            width = LUI.Playercard.Width,
            spacing = 7
        })
        f17_local16 = f17_local1.list
        f17_local1.list = verticalList
        verticalList.buttonCount = 0
        f17_local1:addElement(verticalList)

        f17_local1.list = f17_local16
        f17_local1:AddBackButton(function(f18_arg0, f18_arg1)
            Engine.ExecNow("upload_playercard", f18_arg1.controller)
            LUI.FlowManager.RequestLeaveMenu(f18_arg0)
        end)

        Cac.NotifyVirtualLobby("cao", f17_local0)
        f17_local1:AddRotateHelp()
        f17_local1:AddCurrencyInfoPanel()
        return f17_local1
    end

    LUI.MenuBuilder.m_types_build["PlayercardMenu"] = _PlayercardMenu

    -- menu_xboxlive.lua --
    function disableCreateGameButtons()
        local inPrivateParty = Lobby.IsInPrivateParty()
        local PrivatePartyHost = Lobby.IsPrivatePartyHost()
        local WaitingOnMembers = Lobby.IsPartyHostWaitingOnMembers()
        local result
        if not inPrivateParty or PrivatePartyHost then
            result = WaitingOnMembers
        else
            result = true
        end
        return result
    end

    function OnPublicMatch(f7_arg0, f7_arg1)
        if Engine.GetOnlineGame() then
            Engine.Exec("xcheckezpatch")
            Engine.ExecNow("xblive_privatematch 0")
            LUI.FlowManager.RequestAddMenu(f7_arg0, "FindGameMenu", true, nil, false, {
                clanWarsController = f7_arg1.controller
            })
        end
    end

    function OnPrivateMatch(f8_arg0, f8_arg1)
        Engine.ExecNow("banCheck " .. CoD.AntiCheat.Ban.FEATURE_BAN_HOSTING, f8_arg1.controller)
        if Engine.AllSplitscreenPlayersInParty() then
            Engine.Exec("xcheckezpatch", f8_arg1.controller)
            Engine.Exec(MPConfig.default_xboxlive, f8_arg1.controller)
            Engine.Exec("ui_enumeratesaved", f8_arg1.controller)
            Engine.SetDvarBool("xblive_privatematch", true)
            Engine.ExecNow("xstartprivatematch")
            LUI.FlowManager.RequestAddMenu(f8_arg0, "menu_xboxlive_privatelobby", true)
        end
    end

    function disablePublicMatchButton()
        return disableCreateGameButtons()
    end

    function disablePrivateMatchButton()
        return disableCreateGameButtons()
    end

    exitLobby = function(f5_arg0)
        LeaveXboxLive()
        if Lobby.IsInPrivateParty() == false or Lobby.IsPrivatePartyHost() then
            LUI.FlowManager.RequestLeaveMenuByName("menu_xboxlive")
            Engine.ExecNow("clearcontrollermap")
        end
    end

    function menu_xboxlive(menu, args)
        if Engine.GetDvarBool("virtualLobbyReady") then
            PersistentBackground.FadeFromBlackSlow()
        end

        local menuTemplate = LUI.MPLobbyBase.new(menu, {
            menu_title = "@PLATFORM_UI_HEADER_PLAY_MP_CAPS",
            memberListState = Lobby.MemberListStates.Prelobby
        })

        menuTemplate:setClass(LUI.MPLobbyOnline)

        local serverListButton = menuTemplate:AddButton("@LUA_MENU_SERVERLIST", function(a1)
            LUI.FlowManager.RequestAddMenu(a1, "menu_systemlink_join", true, nil)
        end)
        serverListButton:setDisabledRefreshRate(500)

        if Engine.IsCoreMode() then
            menuTemplate:AddCACButton()
            menuTemplate:AddBarracksButton()
            menuTemplate:AddPersonalizationButton()
        end

        local privateMatchButton = menuTemplate:AddButton("@MENU_PRIVATE_MATCH", OnPrivateMatch,
            disablePrivateMatchButton)
        privateMatchButton:rename("menu_xboxlive_private_match")
        privateMatchButton:setDisabledRefreshRate(500)

        if not Engine.IsCoreMode() then
            local leaderboardButton = menuTemplate:AddButton("@LUA_MENU_LEADERBOARD", "OpLeaderboardMain")
            leaderboardButton:rename("OperatorMenu_leaderboard")
        end

        menuTemplate:AddOptionsButton()
        local natType = Lobby.GetNATType()
        if natType then
            local natTypeText = Engine.Localize("NETWORK_YOURNATTYPE", natType)
            local textState = CoD.CreateState(nil, nil, 2, -62, CoD.AnchorTypes.BottomRight)
            textState.width = 250
            textState.height = CoD.TextSettings.BodyFontVeryTiny.Height
            textState.font = CoD.TextSettings.BodyFontVeryTiny.Font
            textState.color = Colors.white
            textState.alpha = 0.25
            local self = LUI.UIText.new(textState)
            self:setText(natTypeText)
            menuTemplate:addElement(self)
        end

        menuTemplate:AddMenuDescription(1)
        menuTemplate:AddMarketingPanel(LUI.MarketingLocation.Featured, LUI.ComScore.ScreenID.PlayOnline)

        menuTemplate.isSignInMenu = true

        menuTemplate:registerEventHandler("gain_focus", LUI.MPLobbyOnline.OnGainFocus)
        menuTemplate:registerEventHandler("exit_live_lobby", exitLobby)

        if Engine.IsCoreMode() then
            Engine.ExecNow("eliteclan_refresh", Engine.GetFirstActiveController())
        end

        menuTemplate:AddCurrencyInfoPanel()
        return menuTemplate
    end

    LUI.MenuBuilder.m_types_build["menu_xboxlive"] = menu_xboxlive

    LUI.MenuTemplate.AddCurrencyInfoPanel = function(menu)
        return
    end
    -- EOF --
end
