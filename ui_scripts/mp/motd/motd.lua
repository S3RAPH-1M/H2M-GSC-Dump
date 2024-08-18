LUI.MenuBuilder.registerPopupType("motd", function()
    local data = motd.getmotd()
    data.popup_image = "motd_image"
    return LUI.MenuBuilder.BuildRegisteredType("motd_main", {
        popupDataQueue = {data}
    })
end)

LUI.common_menus.MarketingPopup.OnPopupAction = function(a1, a2)
	local data = a1.popupData
    if (type(data.link) == "string") then
        game:openlink(data.link)
    end
end

local marketingbase = LUI.MarketingPopup.Base
LUI.MarketingPopup.Base = function(a1, data, a3)
    local haslink = data.popupAction ~= nil and game:islink(data.popupAction)

    if (haslink) then
        data.link = data.popupAction
        data.popupAction = "depot"
    end

    return marketingbase(a1, data, a3)
end

local marketingcomms = LUI.common_menus.MarketingComms
if Engine.InFrontend() then
    LUI.MOTD.TryForceOpenMOTD = function()
        local controller = Engine.GetFirstActiveController()

        if not Engine.IsProfileSignedIn(controller) then
            return false
        elseif not marketingcomms.CanReadReserveData(controller) then
            return false
        elseif marketingcomms.HasSeenMOTDToday(controller) and Engine.GetDvarBool("marketing_motd_once_per_day") then
            return false
        elseif LUI.FlowManager.IsInStackRoot("motd_main") then
            return false
        else
            marketingcomms.SetHasSeenMOTDToday(controller)

            local data = motd.getmotd()
            data.popup_image = "motd_image"
            LUI.FlowManager.RequestPopupMenu(self, "motd_main", true, controller, false, {
                popupDataQueue = {data}
            })

            return true
        end
    end
end

LUI.onmenuopen("menu_xboxlive", function(menu)
    menu:AddHelp({
        name = "add_button_helper_text",
        button_ref = "button_alt2",
        helper_text = Engine.Localize("@MENU_OPEN_MOTD"),
        side = "left",
        clickable = true
    }, function()
        Engine.PlaySound(CoD.SFX.MenuAccept)
        LUI.FlowManager.RequestPopupMenu(nil, "motd")
    end)
end)