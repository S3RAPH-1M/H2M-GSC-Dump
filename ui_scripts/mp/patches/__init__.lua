-- remove social button
LUI.MenuBuilder.m_definitions["online_friends_widget"] = function()
    return {
        type = "UIElement"
    }
end

-- Hide Party Status --
local template = require("LUI.MenuTemplate")
template.OnPartyStatusRefresh = function(f54_arg0, f54_arg1, f54_arg2)
    local f54_local0 = Lobby.GetPartyStatus()
end

-- add sv_disableCustomClasses for community servers
require("custom_classes")
-- Patches
require("calling_card_aspect")
require("prestige_menu")
require("prestigepreviewwidget")
require("mpcustomclassrestrictions")
require("patch_unused_menus")