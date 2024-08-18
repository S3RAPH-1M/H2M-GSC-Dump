LUI.CacDetails.ArrowBoxOffset = 35
LUI.CacDetails.WeaponBoxLeft = 345
LUI.CacDetails.PrimaryWeaponBoxTop = 125
LUI.CacDetails.WeaponBoxTop = 105
LUI.CacDetails.PerksBlue = {
	r = 0.13,
	g = 0.32,
	b = 0.5
}
LUI.CacDetails.PerksRed = {
	r = 0.46,
	g = 0.12,
	b = 0.16
}
LUI.CacDetails.PerksYellow = {
	r = 0.42,
	g = 0.45,
	b = 0.31
}
LUI.CacDetails.LoadingVideo = "h1_ui_weapon_load_fx"
LUI.CacDetails.TitleBoxLeft = 345
LUI.CacDetails.TitleBoxTop = 125
LUI.WeaponInfoFont = CoD.TextSettings.BodyFont.Font

local function CreateTabManager(menu, numTabs)
    local tabManager = LUI.MenuBuilder.BuildRegisteredType("MFTabManager", {
        defState = {
            leftAnchor = true,
            topAnchor = true,
            rightAnchor = true,
            top = 10
        },
        numOfTabs = numTabs,
        vPadding = 20,
        forceStringBasedTabWidth = true,
        forceShowTabs = true
    })

    tabManager:keepRightBumperAlignedToHeader(true)
    menu.tabManager = tabManager
    menu:addElement(tabManager)

    if not Engine.IsConsoleGame() and not Engine.IsGamepadEnabled() then
        menu:AddHelp({
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

LUI.InventoryUtils.GetLootGuidForRef = function ( f12_arg0, f12_arg1, f12_arg2, f12_arg3, f12_arg4 )

	if f12_arg1 == "" or f12_arg1 == nil then
		return ""
	end

	local f12_local0 = nil
	local f12_local1 = {
		Primary = true,
		Secondary = true,
		Tactical = true,
		Perk_Slot1 = true,
		Perk_Slot2 = true,
		Perk_Slot3 = true,
		Melee = true
	}
	local f12_local2 = {
		callingcard = true,
		emblem = true
	}
	
	if f12_local1[f12_arg0] == true then
		f12_local0 = Engine.TableLookup( StatsTable.File, StatsTable.Cols.Ref, f12_arg1, StatsTable.Cols.GUID )
	elseif f12_local2[f12_arg0] == true then
		f12_local0 = Engine.TableLookup( StatsTable.File, StatsTable.Cols.ExternalRef, f12_arg1, StatsTable.Cols.GUID )
	elseif f12_arg0 == "Primary_AttachKit" or f12_arg0 == "Secondary_AttachKit" or f12_arg0 == "Primary_FurnitureKit" or f12_arg0 == "Secondary_FurnitureKit" then
		f12_local0 = Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f12_arg1, AttachKitTable.Cols.GlobalID )
	else
		local f12_local3 = Cac.GetEquippedWeapon( f12_arg4 or f12_arg0, 0, f12_arg2, f12_arg3 )
		if f12_local3 ~= nil and f12_local3 ~= "" then
			local f12_local4 = Cac.GetWeaponTypeFromWeaponWithoutCategory( f12_local3 )

            if f12_local4 == nil then
                f12_local4 = Cac.H2MGetWeaponTypeFromWeaponWithoutCategory( f12_local3 )
            end

			if f12_local4 ~= nil and f12_local4 ~= "" then
				local f12_local5 = {
					weapon_assault = 0,
					weapon_smg = 1,
					weapon_heavy = 2,
					weapon_lmg = 2,
					weapon_shotgun = 3,
					weapon_sniper = 4,
					weapon_pistol = 5,
					weapon_secondary_machine_pistol = 6,
					weapon_secondary_shotgun = 7,
					weapon_projectile = 8,
					weapon_melee = 9
				}
				local f12_local6 = f12_local5[f12_local4]
				if f12_arg0 == "Primary_Camo" or f12_arg0 == "Secondary_Camo" then
					f12_local0 = Engine.TableLookup( CamoTable.File, CamoTable.Cols.Ref, f12_arg1, f12_local6 + CamoTable.Cols.ARGuid )
				end
			end
		end
	end
	return f12_local0 or "" 
end

LUI.CacDetails.MakeLockOverlay = function(parent, size, alpha, topDividerProperties, bottomDividerProperties, showDividers)
	if size == nil then
		size = 400
	end
	if alpha == nil then
		alpha = 0.7
	end
	if topDividerProperties == nil then
		topDividerProperties = {
			topAnchor = true,
			leftAnchor = true,
			rightAnchor = true,
			top = 153,
			left = 60,
			right = -60
		}
	end
	if bottomDividerProperties == nil then
		bottomDividerProperties = {
			bottomAnchor = true,
			leftAnchor = true,
			rightAnchor = true,
			bottom = -151,
			left = 60,
			right = -60
		}
	end

	local self = LUI.UIElement.new(parent)

	local overlayProperties = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.None)
	overlayProperties.width = size
	overlayProperties.height = size
	overlayProperties.material = RegisterMaterial("h1_deco_locked_3d_overlay")
	overlayProperties.alpha = alpha
	self:addElement(LUI.UIImage.new(overlayProperties))

	local lockIconProperties = CoD.CreateState(-10, -11, nil, nil, CoD.AnchorTypes.None)
	lockIconProperties.width = 20
	lockIconProperties.height = 20
	lockIconProperties.material = RegisterMaterial("s1_icon_locked_full")

	local lockIcon = LUI.UIImage.new(lockIconProperties)
	self:addElement(lockIcon)

	self:hide()
	return self
end