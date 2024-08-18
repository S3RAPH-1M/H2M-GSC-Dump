LUI.MPCustomClassRestrictions = InheritFrom(LUI.GroupedOptionsBase )
Cac.Restrict = {}
Cac.Restrict.State = {
	AllowAll = 1,
	ItemRestricted = 2,
	SubtypeRestricted = 3
}
Cac.Restrict.Categ = {
	Primary = 1,
	Secondary = 2,
	Perk = 3,
	Tactical = 4,
	Melee = 5
}
Cac.Restrict.CategData = {}
Cac.Restrict.CategData[Cac.Restrict.Categ.Primary] = {
	CategKey = "Primary",
	ActionText = "@LUA_MENU_RESTRICT_PRIMARY",
	MenuTitle = "@LUA_MENU_RESTRICTIONS_PRIMARY_CAPS",
	Subtype = {
		Assault = 1,
		SMG = 2,
		Sniper = 3,
		Heavy = 4
	},
	SubtypeData = {}
}
PrimaryData = Cac.Restrict.CategData[Cac.Restrict.Categ.Primary]
PrimaryData.SubtypeData[PrimaryData.Subtype.Assault] = {
	SubKey = "weapon_assault",
	Label = "@LUA_MENU_WEAPTYPE_AR"
}
PrimaryData.SubtypeData[PrimaryData.Subtype.SMG] = {
	SubKey = "weapon_smg",
	Label = "@LUA_MENU_WEAPTYPE_SMG"
}
PrimaryData.SubtypeData[PrimaryData.Subtype.Sniper] = {
	SubKey = "weapon_sniper",
	Label = "@LUA_MENU_WEAPTYPE_SNIPER"
}
PrimaryData.SubtypeData[PrimaryData.Subtype.Heavy] = {
	SubKey = "weapon_heavy",
	Label = "@LUA_MENU_LMGS_CAPS"
}
Cac.Restrict.CategData[Cac.Restrict.Categ.Secondary] = {
	CategKey = "Secondary",
	ActionText = "@LUA_MENU_RESTRICT_SECONDARY",
	MenuTitle = "@LUA_MENU_RESTRICTIONS_SECONDARY_CAPS",
	Subtype = {
		MPistol = 1,
		Shotgun = 2,
		Pistol = 3,
		Launchers = 4,
		Melee = 5
	},
	SubtypeData = {}
}
SecondaryData = Cac.Restrict.CategData[Cac.Restrict.Categ.Secondary]
SecondaryData.SubtypeData[SecondaryData.Subtype.MPistol] = {
	SubKey = "weapon_secondary_machine_pistol",
	Label = "@LUA_MENU_WEAPTYPE_MHANDGUNS"
}

SecondaryData.SubtypeData[SecondaryData.Subtype.Shotgun] = {
	SubKey = "weapon_secondary_shotgun",
	Label = "@LUA_MENU_WEAPTYPE_SHOTGUN"
}

SecondaryData.SubtypeData[SecondaryData.Subtype.Pistol] = {
	SubKey = "weapon_pistol",
	Label = "@LUA_MENU_WEAPTYPE_HANDGUNS"
}

SecondaryData.SubtypeData[SecondaryData.Subtype.Launchers] = {
	SubKey = "weapon_projectile",
	Label = "@LUA_MENU_WEAPTYPE_LAUNCHERS"
}

SecondaryData.SubtypeData[SecondaryData.Subtype.Melee] = {
	SubKey = "weapon_melee",
	Label = "@LUA_MENU_WEAPTYPE_MELEE"
}

Cac.Restrict.CategData[Cac.Restrict.Categ.Perk] = {
	SubKey = "perk",
	ActionText = "@LUA_MENU_RESTRICT_PERK",
	MenuTitle = "@LUA_MENU_RESTRICTIONS_PERK_CAPS",
	Subtype = {
		Slot1 = 1,
		Slot2 = 2,
		Slot3 = 3
	},
	SubtypeData = {}
}
PerkData = Cac.Restrict.CategData[Cac.Restrict.Categ.Perk]
PerkData.SubtypeData[PerkData.Subtype.Slot1] = {
	CategKey = "Perk_Slot1",
	Label = "@MPUI_PERK_1"
}
PerkData.SubtypeData[PerkData.Subtype.Slot2] = {
	CategKey = "Perk_Slot2",
	Label = "@MPUI_PERK_2"
}
PerkData.SubtypeData[PerkData.Subtype.Slot3] = {
	CategKey = "Perk_Slot3",
	Label = "@MPUI_PERK_3"
}
Cac.Restrict.CategData[Cac.Restrict.Categ.Tactical] = {
	CategKey = "Tactical",
	ActionText = "@LUA_MENU_RESTRICT_TACTICAL",
	MenuTitle = "@LUA_MENU_RESTRICTIONS_TACTICAL_CAPS",
	Subtype = {
		Tactical = 1
	},
	SubtypeData = {}
}
TacticalData = Cac.Restrict.CategData[Cac.Restrict.Categ.Tactical]
TacticalData.SubtypeData[TacticalData.Subtype.Tactical] = {
	SubKey = "equipment_tactical",
	Label = "@MENU_TACTICAL"
}
Cac.Restrict.CategData[Cac.Restrict.Categ.Melee] = {
	CategKey = "Melee",
	ActionText = "@LUA_MENU_RESTRICT_MELEE",
	MenuTitle = "@LUA_MENU_RESTRICTIONS_MELEE_CAPS",
	Subtype = {
		Melee = 1
	},
	SubtypeData = {}
}
MeleeData = Cac.Restrict.CategData[Cac.Restrict.Categ.Melee]
MeleeData.SubtypeData[MeleeData.Subtype.Melee] = {
	SubKey = "weapon_melee",
	Label = "@MENU_MELEE_CAPS"
}
SubtypeWindowContentWidth = 140
SubtypeWindowWidth = 450
function GetCategKeySubKey(f1_arg0, f1_arg1 )
	local f1_local0 = Cac.Restrict.CategData[f1_arg0]
	local f1_local1 = f1_local0.SubtypeData[f1_arg1]
	local f1_local2 = f1_local0.CategKey
	local f1_local3 = nil
	if f1_local2 ~= nil then
		f1_local3 = f1_local1.SubKey
	else
		f1_local2 = f1_local1.CategKey
		f1_local3 = f1_local0.SubKey
	end
	return f1_local2, f1_local3
end

function GetItemList(f2_arg0, f2_arg1 )
	local f2_local0, f2_local1 = GetCategKeySubKey(f2_arg0, f2_arg1 )
	local f2_local2 = Cac.Weapons[f2_local0][f2_local1]
	local f2_local3 = nil
	if (f2_arg0 == Cac.Restrict.Categ.Primary or f2_arg0 == Cac.Restrict.Categ.Secondary or f2_arg0 == Cac.Restrict.Categ.Melee) and not IsOnlineMatch() then
		f2_local3 = Cac.LootWeapons[f2_local0][f2_local1]
	end
	local f2_local4 = {}
	local f2_local5 = 1
	local f2_local6 = nil
	if f2_local2 then
		for f2_local7 = 1, #f2_local2, 1 do
			f2_local6 = false
			if f2_local3 then
				for f2_local10 = 1, #f2_local3, 1 do
					if f2_local2[f2_local7][1] == f2_local3[f2_local10][1] then
						f2_local6 = true
					end
				end
			elseif f2_local2[f2_local7][1] == "none" and f2_arg0 == Cac.Restrict.Categ.Melee then
				f2_local6 = true
			end
			if not f2_local6 then
				f2_local4[f2_local5] = f2_local2[f2_local7][1]
				f2_local5 = f2_local5 + 1
			end
		end
	end
	return f2_local4
end

function GetRestrictState(f3_arg0, f3_arg1 )
	local f3_local0, f3_local1 = GetCategKeySubKey(f3_arg0, f3_arg1 )
	if Cac.GetItemClassRestricted(f3_local0, f3_local1 ) then
		return Cac.Restrict.State.SubtypeRestricted
	end
	local f3_local2 = GetItemList(f3_arg0, f3_arg1 )
	for f3_local3 = 1, #f3_local2, 1 do
		if Cac.GetItemRestricted(f3_local0, f3_local2[f3_local3] ) then
			return Cac.Restrict.State.ItemRestricted
		end
	end
	return Cac.Restrict.State.AllowAll
end

function ItemButtonUpdateRestricted(f4_arg0 )
	local f4_local0 = Cac.GetItemRestricted(f4_arg0.categoryKey, f4_arg0.itemKey )
	if not f4_local0 then
		f4_local0 = Cac.GetItemClassRestricted(f4_arg0.categoryKey, f4_arg0.subtypeKey )
	end
	f4_arg0:processEvent({
		name = "set_checked",
		checkBox = f4_local0
	} )
	f4_arg0:processEvent({
		name = "refresh_disabled"
	} )
end

function ItemButtonSetData(f5_arg0, f5_arg1, f5_arg2, f5_arg3 )
	f5_arg0.category = f5_arg1
	f5_arg0.subtype = f5_arg2
	f5_arg0.itemKey = f5_arg3
	f5_arg0.categoryKey, f5_arg0.subtypeKey = GetCategKeySubKey(f5_arg1, f5_arg2 )
	f5_arg0:setText(Cac.GetWeaponName(f5_arg0.categoryKey, f5_arg3 ) )
	ItemButtonUpdateRestricted(f5_arg0 )
end

function ItemButtonToggle(f6_arg0 )
	local f6_local0 = not Cac.GetItemRestricted(f6_arg0.categoryKey, f6_arg0.itemKey )
	Cac.SetItemRestricted(f6_arg0.categoryKey, f6_arg0.itemKey, f6_local0 )
	f6_arg0:processEvent({
		name = "set_checked",
		checkBox = f6_local0
	} )
	f6_arg0:dispatchEventToRoot({
		name = "content_refresh"
	} )
end

function SubtypeHeaderSetData(f7_arg0, f7_arg1, f7_arg2 )
	f7_arg0:setText(Engine.ToUpperCase(Engine.Localize(Cac.Restrict.CategData[f7_arg1].SubtypeData[f7_arg2].Label ) ) )
	f7_arg0:processEvent({
		name = "content_refresh"
	} )
end

function SubtypeWindowToggleSubtypeRestrict(f8_arg0 )
	Cac.SetItemClassRestricted(f8_arg0.categKey, f8_arg0.subtypeKey, not Cac.GetItemClassRestricted(f8_arg0.categKey, f8_arg0.subtypeKey ) )
	for f8_local0 = 1, #f8_arg0.optionItems, 1 do
		ItemButtonUpdateRestricted(f8_arg0.list:getChildById(f8_arg0.optionItems[f8_local0] ) )
	end
end

function SubtypeWindowGetHeaderText(f9_arg0 )
	if f9_arg0.category == nil then
		return ""
	else
		local f9_local0 = GetRestrictState(f9_arg0.category, f9_arg0.subtype )
		if f9_local0 == Cac.Restrict.State.SubtypeRestricted then
			return Engine.Localize("@LUA_MENU_RESTRICTED" )
		elseif f9_local0 == Cac.Restrict.State.ItemRestricted then
			return Engine.Localize("@LUA_MENU_CUSTOM" )
		else
			assert(f9_local0 == Cac.Restrict.State.AllowAll )
			return Engine.Localize("@LUA_MENU_UNRESTRICTED" )
		end
	end
end

LUI.MPCustomClassRestrictions.UpdateSubMenu = function (f10_arg0, f10_arg1 )
	local f10_local0 = f10_arg0.subMenu
	local f10_local1 = f10_arg1.category
	local f10_local2 = f10_arg1.subtype
	f10_local0.category = f10_local1
	f10_local0.subtype = f10_local2
	f10_local0.categKey, f10_local0.subtypeKey = GetCategKeySubKey(f10_local1, f10_local2 )
	SubtypeHeaderSetData(f10_local0.header, f10_local1, f10_local2 )
	local f10_local3 = GetItemList(f10_local1, f10_local2 )
	local f10_local4 = f10_local0.optionItems
	if #f10_local4 < #f10_local3 then
		for f10_local5 = #f10_local4 + 1, #f10_local3, 1 do
			local f10_local8 = ItemButton(f10_local5 )
			f10_local4[f10_local5] = f10_local8.id
			f10_local0.list:addElement(f10_local8 )
		end
	elseif #f10_local3 < #f10_local4 then
		for f10_local5 = #f10_local4, #f10_local3 + 1, -1 do
			f10_local0.list:removeElement(f10_local0.list:getChildById(f10_local4[f10_local5] ) )
			table.remove(f10_local4, f10_local5 )
		end
	end
	for f10_local5 = 1, #f10_local3, 1 do
		ItemButtonSetData(f10_local0.list:getChildById(f10_local4[f10_local5] ), f10_local1, f10_local2, f10_local3[f10_local5] )
	end
	if f10_local0.listInitialized == nil then
		ListPaging.InitList(f10_local0.list, 15, 15, false, false, {
			enabled = #f10_local3 > 15,
			left_offset = 155
		}, nil )
		f10_local0.listInitialized = true
	end
end

function ItemButton(f11_arg0 )
	local f11_local0 = {
		id = "option_btn_" .. f11_arg0,
		style = GenericButtonSettings.Styles.GlassButton,
		substyle = GenericButtonSettings.Styles.GlassButton.SubStyles.SubMenu,
		variant = GenericButtonSettings.Variants.Checkbox,
		content_width = SubtypeWindowContentWidth,
		negative_color = true,
		button_text = "test",
		button_action_func = ItemButtonToggle
	}
	local self = LUI.UIGenericButton.new(nil, f11_local0 )
	self:makeFocusable()
	self.properties = f11_local0
	self.disabledFunc = function (f12_arg0 )
		if not f12_arg0.subtypeKey then
			return false
		else
			return Cac.GetItemClassRestricted(f12_arg0.categoryKey, f12_arg0.subtypeKey )
		end
	end
	
	return self
end

function SubtypeHeader(f13_arg0 )
	return LUI.MenuBuilder.BuildAddChild(f13_arg0.list, {
		type = "UIGenericButton",
		id = "header",
		audio = {
			button_over = CoD.SFX.SubMenuMouseOver
		},
		properties = {
			style = GenericButtonSettings.Styles.GlassButton,
			substyle = GenericButtonSettings.Styles.GlassButton.SubStyles.SubMenu,
			variant = GenericButtonSettings.Variants.Select,
			content_width = SubtypeWindowContentWidth,
			button_display_func = function (f14_arg0, f14_arg1 )
				return SubtypeWindowGetHeaderText(f13_arg0 )
			end
			,
			button_text = "",
			button_left_func = function (f15_arg0, f15_arg1 )
				SubtypeWindowToggleSubtypeRestrict(f13_arg0 )
			end
			,
			button_right_func = function (f16_arg0, f16_arg1 )
				SubtypeWindowToggleSubtypeRestrict(f13_arg0 )
			end
			
		}
	}, true )
end

function SubtypeWindow(menu, controller )
	local self = LUI.UIElement.new()
	self:registerAnimationState("default", {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = false,
		top = menu,
		left = controller,
		width = SubtypeWindowWidth,
		height = 500
	} )
	self:animateToState("default" )
	
	local list = LUI.UIVerticalList.new()
	list:registerAnimationState("default", {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		alignment = LUI.Alignment.Top
	} )
	list:animateToState("default" )
	self:addElement(list )
	self.list = list
	
	self.header = SubtypeHeader(self )
	self.optionItems = {}
	return self
end

LUI.MPCustomClassRestrictions.OnRestoreFocus = function (f18_arg0, f18_arg1 )
	local f18_local0 = LUI.FlowManager.GetMenuScopedDataFromElement(f18_arg0 )
	if f18_local0.lockedButton ~= nil then
		local f18_local1 = f18_arg0.menuButtons[f18_local0.lockedButton]
		if f18_local1 ~= nil then
			f18_arg0:UpdateSubMenu(f18_local1.subOptionsData )
		end
	end
	LUI.GroupedOptionsBase.OnRestoreFocus(f18_arg0, f18_arg1 )
end

function ClassRestrictMenu(f19_arg0, f19_arg1 )
	local f19_local0 = f19_arg1 or {}
	local f19_local1 = f19_local0.numDescriptionLines or 0
	local f19_local2 = f19_local0.category
	local f19_local3 = Cac.Restrict.CategData[f19_local2]
	local f19_local4 = f19_local3.SubtypeData
	local f19_local5 = LUI.GroupedOptionsBase.new(f19_arg0, {
		menu_title = f19_local3.MenuTitle
	} )
	f19_local5:setClass(LUI.MPCustomClassRestrictions )
	f19_local5:SetBreadCrumb(Engine.ToUpperCase(Engine.Localize("@LUA_MENU_GAME_SETUP_CAPS" ) ) )
	local f19_local6 = {}
	local f19_local7 = {}
	for f19_local8 = 1, #f19_local4, 1 do
		f19_local6[f19_local8] = f19_local5:AddButton(f19_local4[f19_local8].Label )
		f19_local7[f19_local8] = {
			category = f19_local2,
			subtype = f19_local8
		}
	end
	f19_local5:InitOptionsMenu(f19_local6, f19_local7, SubtypeWindow(LUI.GroupedOptionsBase.SubMenuTop, LUI.GroupedOptionsBase.SubMenuLeft ), f19_local1 )
	f19_local5:registerEventHandler("restore_focus", LUI.MPCustomClassRestrictions.OnRestoreFocus )
	return f19_local5
end

LUI.MenuBuilder.m_types_build["ClassRestrictMenu"] = ClassRestrictMenu