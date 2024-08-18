if Engine.InFrontend() then  
    local PersonalizationButtonOverride = LUI.MPLobbyBase.AddPersonalizationButton
    LUI.MPLobbyBase.AddPersonalizationButton = function (menu) 
        menu:AddButton("@LUA_MENU_KILLSTREAKS", function()
            LUI.FlowManager.RequestAddMenu(nil, "killstreak_selection", true, Cac.GetSelectedControllerIndex(), nil, {
                storageCategory = "Primary",
                weaponType = "streak",
                parentCategory = nil,
                overrideStorageCategory = nil,
                menuTitle = "@LUA_MENU_KILLSTREAKS",
                showAttributes = false,
                subCategories = {},
                statsPrefix = nil,
                attributesDelta = false,
                optionsForVL = {},
                showUnlocks = true,
                cacLootTabs = nil
            })
        end)
        PersonalizationButtonOverride(menu)
    end
end

require("menu")