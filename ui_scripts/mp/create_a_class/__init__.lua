-- Remove all default ones to prepare for custom weapons
Cac.Weapons.Primary.weapon_assault = {} -- ASSAULT RIFLES
Cac.Weapons.Primary.weapon_smg = {} -- SMGS
Cac.Weapons.Primary.weapon_sniper = {} -- SNIPERS
Cac.Weapons.Primary.weapon_heavy = {} -- LMGS
Cac.Weapons.Primary.weapon_shotgun = {} -- SHOTGUN
Cac.Weapons.Primary.weapon_melee = {} -- MELEES

Cac.Weapons.Secondary.weapon_pistol = {} -- PISTOLS
Cac.Weapons.Secondary.weapon_secondary_machine_pistol = {} -- MACHINE PISTOLS
Cac.Weapons.Secondary.weapon_secondary_shotgun = {} -- SHOTGUNS
Cac.Weapons.Secondary.weapon_projectile = {} -- LAUNCHERS
Cac.Weapons.Secondary.weapon_melee = {} -- MELEE

Cac.Weapons.Secondary[4] = {}
Cac.Weapons.Secondary.Keys[4] = "weapon_secondary_machine_pistol"
Cac.Weapons.Secondary.DisplayNames["weapon_secondary_machine_pistol"] = "@LUA_MENU_MACHINE_PISTOLS_CAPS"

Cac.Weapons.Secondary[5] = {}
Cac.Weapons.Secondary.Keys[5] = "weapon_secondary_shotgun"
Cac.Weapons.Secondary.DisplayNames["weapon_secondary_shotgun"] = "@LUA_MENU_SHOTGUN_CAPS"

Cac.Weapons.Secondary[6] = {}
Cac.Weapons.Secondary.Keys[6] = "weapon_projectile"
Cac.Weapons.Secondary.DisplayNames["weapon_projectile"] = "@LUA_MENU_LAUNCHERS_CAPS"

Cac.Weapons.Secondary[7] = {}
Cac.Weapons.Secondary.Keys[7] = "weapon_melee"
Cac.Weapons.Secondary.DisplayNames["weapon_melee"] = "@LUA_MENU_MELEE_CAPS"

Cac.Weapons.Secondary.Indices["weapon_secondary_machine_pistol"] = 4
Cac.Weapons.Secondary.Indices["weapon_secondary_shotgun"] = 5
Cac.Weapons.Secondary.Indices["weapon_projectile"] = 6
Cac.Weapons.Secondary.Indices["weapon_melee"] = 7

Cac.Weapons.Lethal.equipment_lethal = {} -- LETHALS
Cac.Weapons.Tactical.equipment_tactical = {} -- EQUIPMENT

Cac.Weapons.Equipment.equipment_lethal = {} -- LETHALS
Cac.Weapons.Equipment.equipment_tactical = {} -- EQUIPMENT	

Cac.Weapons.Perk_Slot1.perk = {} -- PERK 1
Cac.Weapons.Perk_Slot2.perk = {} -- PERK 2
Cac.Weapons.Perk_Slot3.perk = {} -- PERK 3
Cac.Weapons.Melee.weapon_melee = {} -- Melee

Cac.Weapons.Primary.streak = {
	{
		"radar_mp",
		0
	},
	{
		"counter_radar_mp",
		0
	},
	{
		"helicopter_mp",
		0
	},
	{
		"nuke_mp",
		0
	},
	{
		"emp_mp",
		0
	},
	{
		"pavelow_mp",
		0
	},
	{
		"chopper_gunner_mp",
		0
	},
	{
		"ac130_mp",
		0
	},
	{
		"predator_mp",
		0
	},
	{
		"sentry_mp",
		0
	},
	{
		"airdrop_mega_marker_mp",
		0
	},
	{
		"harrier_airstrike_mp",
		0
	},
	{
		"airstrike_mp",
		0
	},
	{
		"airdrop_marker_mp",
		0
	},
	{
		"stealth_airstrike_mp",
		0
	}
}

Cac.Weapons.Streak[1] = Cac.Weapons.Primary.streak

Cac.Weapons.Primary_Camo.camo = {}
Cac.Weapons.Secondary_Camo.camo = {}


Cac.DefaultWeaponNames = {
	Primary = "h2_m4",
	Primary_AttachKit = "none",
	Primary_FurnitureKit = "none",
	Primary_Camo = "none",
	Primary_Reticle = "none",
	Secondary = "h2_usp",
	Secondary_AttachKit = "none",
	Secondary_FurnitureKit = "none",
	Secondary_Camo = "none",
	Secondary_Reticle = "none",
	Lethal = "h1_fraggrenade_mp",
	Tactical = "h1_flashgrenade_mp",
	Perk_Slot1 = "specialty_fastreload",
	Perk_Slot2 = "specialty_bulletdamage",
	Perk_Slot3 = "specialty_bulletaccuracy",
	Melee = "none"
}

Cac.KitWeaponTypes = {
	weapon_assault = "ast",
	weapon_smg = "smg",
	weapon_sniper = "snp",
	weapon_shotgun = "sht",
	weapon_secondary_shotgun = "sht",
	weapon_heavy = "lmg",
	weapon_lmg = "lmg",
	weapon_pistol = "pst",
	weapon_projectile = "prj",
	weapon_secondary_machine_pistol = "pst",
	weapon_melee = "mel"
}

local cols = {
    name = 0,
    class = 1,
    type = 2
}

local csv = "mp/customweapons.csv"
local rows = Engine.TableGetRowCount(csv)

function get_key_for_value( t, value )
	for k,v in pairs(t) do
	  if v==value then return k end
	end
	return nil
end

pcall(function()
    for i = 0, rows do
        local weap = Engine.TableLookupByRow(csv, i, cols.name)
        local class = Engine.TableLookupByRow(csv, i, cols.class)
        local weapon_type = Engine.TableLookupByRow(csv, i, cols.type)

		local tableIndex = get_key_for_value(Cac.Weapons[weapon_type].Keys, class)

        if type(Cac.Weapons[weapon_type][tableIndex]) == "table" then
            table.insert(Cac.Weapons[weapon_type][tableIndex], { weap, 0 })
		else
			-- print ("Couldn't add", weap, "to", weapon_type, class, "because index doesn't exist")
        end

		if type(Cac.Weapons[weapon_type][class]) == "table" then
			table.insert(Cac.Weapons[weapon_type][class], { weap, 0 })
		else
			-- print ("Couldn't add", weap, "to", weapon_type, class)
        end

		if type(Cac.Weapons.Equipment[class]) == "table" then
			table.insert(Cac.Weapons.Equipment[class], { weap, 0 })
		end
    end
end)

if Engine.InFrontend() then
    require("loadout_weapons")
    require("loadout_editor")
    require("utils")
    require("details")
end

HasOmaEquiped = function ()
	local f3_local0 = Cac.HasEquippedWeapon( "Perk_Slot1", "specialty_onemanarmy", LUI.CacStaticLayout.ClassLoc )
	if not f3_local0 then
		f3_local0 = Cac.HasEquippedWeapon( "Perk_Slot1", "specialty_omaquickchange", LUI.CacStaticLayout.ClassLoc )
	end
	return f3_local0
end

OmaPerkCheck = function ()
    return HasOmaEquiped() == false
end

weaponNameLookup = {
	Primary = function ( f332_arg0, f332_arg1 )
		if f332_arg1 == Cac.NullWeaponNames[f332_arg0] then
			return ""
		else
			return Cac.GetNameFromStatsTable( f332_arg1 )
		end
	end,
	Primary_AttachKit = function ( f333_arg0, f333_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f333_arg1, AttachKitTable.Cols.Name ) )
	end,
	Primary_FurnitureKit = function ( f333_arg0, f333_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f333_arg1, AttachKitTable.Cols.Name ) )
	end,
	Primary_Camo = function ( f335_arg0, f335_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( CamoTable.File, CamoTable.Cols.Ref, f335_arg1, CamoTable.Cols.Name ) )
	end,
	Primary_Reticle = function ( f336_arg0, f336_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( ReticleTable.File, ReticleTable.Cols.Ref, f336_arg1, ReticleTable.Cols.Name ) )
	end,
	Secondary = function ( f337_arg0, f337_arg1 )
		if f337_arg1 == Cac.NullWeaponNames[f337_arg0] then
			return ""
		else
			return Cac.GetNameFromStatsTable( f337_arg1 )
		end
	end,
	Secondary_AttachKit = function ( f338_arg0, f338_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f338_arg1, AttachKitTable.Cols.Name ) )
	end,
	Secondary_FurnitureKit = function ( f338_arg0, f338_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f338_arg1, AttachKitTable.Cols.Name ) )
	end,
	Secondary_Camo = function ( f340_arg0, f340_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( CamoTable.File, CamoTable.Cols.Ref, f340_arg1, CamoTable.Cols.Name ) )
	end,
	Secondary_Reticle = function ( f341_arg0, f341_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( ReticleTable.File, ReticleTable.Cols.Ref, f341_arg1, ReticleTable.Cols.Name ) )
	end,
	Lethal = function ( f342_arg0, f342_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f342_arg1, PerkTable.Cols.Name ) )
	end,
	Tactical = function ( f343_arg0, f343_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f343_arg1, PerkTable.Cols.Name ) )
	end,
	Perk_Slot1 = function ( f344_arg0, f344_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f344_arg1, PerkTable.Cols.Name ) )
	end,
	Perk_Slot2 = function ( f345_arg0, f345_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f345_arg1, PerkTable.Cols.Name ) )
	end,
	Perk_Slot3 = function ( f346_arg0, f346_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f346_arg1, PerkTable.Cols.Name ) )
	end,
	Primary_AttachmentBase = function ( f347_arg0, f347_arg1 )
		return Engine.Localize( "@" .. Engine.TableLookup( AttachBaseTable.File, AttachBaseTable.Cols.Ref, f347_arg1, AttachBaseTable.Cols.Name ) )
	end,
	Melee = function ( f348_arg0, f348_arg1 )
		return Cac.GetNameFromStatsTable( f348_arg1 )
	end
}
Cac.GetWeaponName = function ( f349_arg0, f349_arg1 )
	return weaponNameLookup[f349_arg0]( f349_arg0, f349_arg1 )
end

weaponRestrictedLookup = {
	Primary = function ( f48_arg0, f48_arg1 )
		return Cac.GetWeaponRestricted( f48_arg0, f48_arg1 )
	end,
	Primary_AttachKit = function ( f49_arg0, f49_arg1 )
		return Cac.GetAttachKitRestricted( f49_arg0 )
	end,
	Primary_FurnitureKit = function ( f50_arg0, f50_arg1 )
		return Cac.GetAttachKitRestricted( f49_arg0 )
	end,
	Primary_Camo = function ( f51_arg0, f51_arg1 )
		return nil
	end,
	Primary_Reticle = function ( f52_arg0, f52_arg1 )
		return nil
	end,
	Secondary = function ( f53_arg0, f53_arg1 )
		return Cac.GetWeaponRestricted( f53_arg0, f53_arg1 )
	end,
	Secondary_AttachKit = function ( f54_arg0, f54_arg1 )
		return Cac.GetAttachKitRestricted( f54_arg0 )
	end,
	Secondary_FurnitureKit = function ( f55_arg0, f55_arg1 )
		return Cac.GetAttachKitRestricted( f54_arg0 )
	end,
	Secondary_Camo = function ( f56_arg0, f56_arg1 )
		return nil
	end,
	Secondary_Reticle = function ( f57_arg0, f57_arg1 )
		return nil
	end,
	Lethal = function ( f58_arg0, f58_arg1 )
		return Cac.GetPerkRestricted( f58_arg0 )
	end,
	Tactical = function ( f59_arg0, f59_arg1 )
		return Cac.GetPerkRestricted( f59_arg0 )
	end,
	Perk_Slot1 = function ( f60_arg0, f60_arg1 )
		return Cac.GetPerkRestricted( f60_arg0 )
	end,
	Perk_Slot2 = function ( f61_arg0, f61_arg1 )
		return Cac.GetPerkRestricted( f61_arg0 )
	end,
	Perk_Slot3 = function ( f62_arg0, f62_arg1 )
		return Cac.GetPerkRestricted( f62_arg0 )
	end,
	Primary_AttachmentBase = function ( f63_arg0, f63_arg1 )
		return Cac.GetAttachBaseRestricted( f63_arg0 )
	end,
	Melee = function ( f64_arg0, f64_arg1 )
		return Cac.GetWeaponRestricted( f64_arg0, f64_arg1 )
	end
}
Cac.GetItemRestricted = function ( f65_arg0, f65_arg1, f65_arg2 )
	return weaponRestrictedLookup[f65_arg0]( f65_arg1, f65_arg2 )
end

-- TODO: restrict attachments if one is enabled --
weaponRestrictedSet = {
	Primary = function ( f66_arg0, f66_arg1 )
		return Cac.SetWeaponRestricted( f66_arg0, f66_arg1 )
	end,
	Primary_AttachKit = function ( f67_arg0, f67_arg1 )
		return nil
	end,
	Primary_FurnitureKit = function ( f68_arg0, f68_arg1 )
		return nil
	end,
	Primary_Camo = function ( f69_arg0, f69_arg1 )
		return nil
	end,
	Primary_Reticle = function ( f70_arg0, f70_arg1 )
		return nil
	end,
	Secondary = function ( f71_arg0, f71_arg1 )
		return Cac.SetWeaponRestricted( f71_arg0, f71_arg1 )
	end,
	Secondary_AttachKit = function ( f72_arg0, f72_arg1 )
		return nil
	end,
	Secondary_FurnitureKit = function ( f73_arg0, f73_arg1 )
		return nil
	end,
	Secondary_Camo = function ( f74_arg0, f74_arg1 )
		return nil
	end,
	Secondary_Reticle = function ( f75_arg0, f75_arg1 )
		return nil
	end,
	Lethal = function ( f76_arg0, f76_arg1 )
		return Cac.SetPerkRestricted( f76_arg0, f76_arg1 )
	end,
	Tactical = function ( f77_arg0, f77_arg1 )
		return Cac.SetPerkRestricted( f77_arg0, f77_arg1 )
	end,
	Perk_Slot1 = function ( f78_arg0, f78_arg1 )
		return Cac.SetPerkRestricted( f78_arg0, f78_arg1 )
	end,
	Perk_Slot2 = function ( f79_arg0, f79_arg1 )
		return Cac.SetPerkRestricted( f79_arg0, f79_arg1 )
	end,
	Perk_Slot3 = function ( f80_arg0, f80_arg1 )
		return Cac.SetPerkRestricted( f80_arg0, f80_arg1 )
	end,
	Primary_AttachmentBase = function ( f81_arg0, f81_arg1 )
		return Cac.SetAttachBaseRestricted( f81_arg0, f81_arg1 )
	end,
	Melee = function ( f82_arg0, f82_arg1 )
		return Cac.SetWeaponRestricted( f82_arg0, f82_arg1 )
	end
}
Cac.SetItemRestricted = function ( f83_arg0, f83_arg1, f83_arg2 )
	return weaponRestrictedSet[f83_arg0]( f83_arg1, f83_arg2 )
end

weaponClassRestrictedLookup = {
	Primary = function ( f84_arg0, f84_arg1 )
		return Cac.GetWeaponClassRestricted( f84_arg1 )
	end,
	Primary_AttachKit = function ( f85_arg0, f85_arg1 )
		return nil
	end,
	Primary_FurnitureKit = function ( f86_arg0, f86_arg1 )
		return nil
	end,
	Primary_Camo = function ( f87_arg0, f87_arg1 )
		return nil
	end,
	Primary_Reticle = function ( f88_arg0, f88_arg1 )
		return nil
	end,
	Secondary = function ( f89_arg0, f89_arg1 )
		return Cac.GetWeaponClassRestricted( f89_arg1 )
	end,
	Secondary_AttachKit = function ( f90_arg0, f90_arg1 )
		return nil
	end,
	Secondary_FurnitureKit = function ( f91_arg0, f91_arg1 )
		return nil
	end,
	Secondary_Camo = function ( f92_arg0, f92_arg1 )
		return nil
	end,
	Secondary_Reticle = function ( f93_arg0, f93_arg1 )
		return nil
	end,
	Lethal = function ( f94_arg0, f94_arg1 )
		return Cac.GetPerkClassRestricted( f94_arg0 )
	end,
	Tactical = function ( f95_arg0, f95_arg1 )
		return Cac.GetPerkClassRestricted( f95_arg0 )
	end,
	Perk_Slot1 = function ( f96_arg0, f96_arg1 )
		return Cac.GetPerkClassRestricted( f96_arg0 )
	end,
	Perk_Slot2 = function ( f97_arg0, f97_arg1 )
		return Cac.GetPerkClassRestricted( f97_arg0 )
	end,
	Perk_Slot3 = function ( f98_arg0, f98_arg1 )
		return Cac.GetPerkClassRestricted( f98_arg0 )
	end,
	Primary_AttachmentBase = function ( f99_arg0, f99_arg1 )
		return Cac.GetAttachClassRestricted( f99_arg1 )
	end,
	Melee = function ( f100_arg0, f100_arg1 )
		return Cac.GetWeaponClassRestricted( f100_arg1 )
	end
}
Cac.GetItemClassRestricted = function ( f101_arg0, f101_arg1 )
	return weaponClassRestrictedLookup[f101_arg0]( f101_arg0, f101_arg1 )
end

weaponClassRestrictedSet = {
	Primary = function ( f102_arg0, f102_arg1, f102_arg2 )
		return Cac.SetWeaponClassRestricted( f102_arg1, f102_arg2 )
	end,
	Primary_AttachKit = function ( f103_arg0, f103_arg1, f103_arg2 )
		return nil
	end,
	Primary_FurnitureKit = function ( f104_arg0, f104_arg1, f104_arg2 )
		return nil
	end,
	Primary_Camo = function ( f105_arg0, f105_arg1, f105_arg2 )
		return nil
	end,
	Primary_Reticle = function ( f106_arg0, f106_arg1, f106_arg2 )
		return nil
	end,
	Secondary = function ( f107_arg0, f107_arg1, f107_arg2 )
		return Cac.SetWeaponClassRestricted( f107_arg1, f107_arg2 )
	end,
	Secondary_AttachKit = function ( f108_arg0, f108_arg1, f108_arg2 )
		return nil
	end,
	Secondary_FurnitureKit = function ( f109_arg0, f109_arg1, f109_arg2 )
		return nil
	end,
	Secondary_Camo = function ( f110_arg0, f110_arg1, f110_arg2 )
		return nil
	end,
	Secondary_Reticle = function ( f111_arg0, f111_arg1, f111_arg2 )
		return nil
	end,
	Lethal = function ( f112_arg0, f112_arg1, f112_arg2 )
		return Cac.SetPerkClassRestricted( f112_arg0, f112_arg2 )
	end,
	Tactical = function ( f113_arg0, f113_arg1, f113_arg2 )
		return Cac.SetPerkClassRestricted( f113_arg0, f113_arg2 )
	end,
	Perk_Slot1 = function ( f114_arg0, f114_arg1, f114_arg2 )
		return Cac.SetPerkClassRestricted( f114_arg0, f114_arg2 )
	end,
	Perk_Slot2 = function ( f115_arg0, f115_arg1, f115_arg2 )
		return Cac.SetPerkClassRestricted( f115_arg0, f115_arg2 )
	end,
	Perk_Slot3 = function ( f116_arg0, f116_arg1, f116_arg2 )
		return Cac.SetPerkClassRestricted( f116_arg0, f116_arg2 )
	end,
	Primary_AttachmentBase = function ( f117_arg0, f117_arg1, f117_arg2 )
		return Cac.SetAttachClassRestricted( f117_arg1, f117_arg2 )
	end,
	Melee = function ( f118_arg0, f118_arg1, f118_arg2 )
		return Cac.SetWeaponClassRestricted( f118_arg1, f118_arg2 )
	end
}
Cac.SetItemClassRestricted = function ( f119_arg0, f119_arg1, f119_arg2 )
	return weaponClassRestrictedSet[f119_arg0]( f119_arg0, f119_arg1, f119_arg2 )
end

f0_local8 = function ( f196_arg0, f196_arg1, f196_arg2, f196_arg3, f196_arg4, f196_arg5 )
	assert( f196_arg3 == 0 )
	local f196_local0 = Cac.GetCacConfig( f196_arg0, f196_arg1, f196_arg2, "weaponSetups", f196_arg5, "kit", "attachKit" )
	local f196_local1 = nil
	if type( f196_local0 ) == "number" then
		f196_local1 = Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Id, tostring( f196_local0 ), AttachKitTable.Cols.Ref )
	else
		f196_local1 = f196_local0
	end
	return f196_local1
end

-- TODO: fix crashes happening in Cac.GetCacConfig on furnitureKit
f0_local9 = function ( f197_arg0, class_type, f197_arg2, f197_arg3, f197_arg4, is_secondary )
	assert( f197_arg3 == 0 )
	local f197_local0 = Cac.GetCacConfig( f197_arg0, class_type, f197_arg2, "weaponSetups", is_secondary, "kit", "furnitureKit" )	
	local f197_local1 = nil
	if type( f197_local0 ) == "number" then
		f197_local1 = Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Id, tostring( f197_local0 ), AttachKitTable.Cols.Ref )
	else
		f197_local1 = f197_local0
	end

	if f197_local1 == "" then
		f197_local1 = "none"
	end

	return f197_local1
end


weaponEquipedLookup = {
	Primary = function ( f214_arg0, f214_arg1, f214_arg2, f214_arg3, f214_arg4 )
		return Cac.GetCacConfig( f214_arg0, f214_arg1, f214_arg2, "weaponSetups", 0, "weapon" )
	end,
	Primary_AttachKit = function ( f215_arg0, f215_arg1, f215_arg2, f215_arg3, f215_arg4 )
		return f0_local8( f215_arg0, f215_arg1, f215_arg2, f215_arg3, f215_arg4, 0 )
	end,
	Primary_FurnitureKit = function ( f216_arg0, f216_arg1, f216_arg2, f216_arg3, f216_arg4 )
		return f0_local9( f216_arg0, f216_arg1, f216_arg2, f216_arg3, f216_arg4, 0 )
	end,
	Primary_Camo = function ( f217_arg0, f217_arg1, f217_arg2, f217_arg3, f217_arg4 )
		assert( f217_arg3 == 0 )
		return Cac.GetCacConfig( f217_arg0, f217_arg1, f217_arg2, "weaponSetups", 0, "camo" )
	end,
	Primary_Reticle = function ( f218_arg0, f218_arg1, f218_arg2, f218_arg3, f218_arg4 )
		assert( f218_arg3 == 0 )
		return Cac.GetCacConfig( f218_arg0, f218_arg1, f218_arg2, "weaponSetups", 0, "reticle" )
	end,
	Secondary = function ( f219_arg0, f219_arg1, f219_arg2, f219_arg3, f219_arg4 )
		return Cac.GetCacConfig( f219_arg0, f219_arg1, f219_arg2, "weaponSetups", 1, "weapon" )
	end,
	Secondary_AttachKit = function ( f220_arg0, f220_arg1, f220_arg2, f220_arg3, f220_arg4 )
		return f0_local8( f220_arg0, f220_arg1, f220_arg2, f220_arg3, f220_arg4, 1 )
	end,
	Secondary_FurnitureKit = function ( f221_arg0, f221_arg1, f221_arg2, f221_arg3, f221_arg4 )
		return f0_local9( f221_arg0, f221_arg1, f221_arg2, f221_arg3, f221_arg4, 1 )
	end,
	Secondary_Camo = function ( f222_arg0, f222_arg1, f222_arg2, f222_arg3, f222_arg4 )
		assert( f222_arg3 == 0 )
		return Cac.GetCacConfig( f222_arg0, f222_arg1, f222_arg2, "weaponSetups", 1, "camo" )
	end,
	Secondary_Reticle = function ( f223_arg0, f223_arg1, f223_arg2, f223_arg3, f223_arg4 )
		assert( f223_arg3 == 0 )
		return Cac.GetCacConfig( f223_arg0, f223_arg1, f223_arg2, "weaponSetups", 1, "reticle" )
	end,
	Lethal = function ( f224_arg0, f224_arg1, f224_arg2, f224_arg3, f224_arg4 )
		assert( f224_arg3 == 0 )
		return Cac.GetCacConfig( f224_arg0, f224_arg1, f224_arg2, "equipment", 0 )
	end,
	Tactical = function ( f225_arg0, f225_arg1, f225_arg2, f225_arg3, f225_arg4 )
		assert( f225_arg3 == 0 )
		return Cac.GetCacConfig( f225_arg0, f225_arg1, f225_arg2, "equipment", 1 )
	end,
	Perk_Slot1 = function ( f226_arg0, f226_arg1, f226_arg2, f226_arg3, f226_arg4 )
		return Cac.GetCacConfig( f226_arg0, f226_arg1, f226_arg2, "perkSlots", f226_arg3 )
	end,
	Perk_Slot2 = function ( f227_arg0, f227_arg1, f227_arg2, f227_arg3, f227_arg4 )
		return Cac.GetCacConfig( f227_arg0, f227_arg1, f227_arg2, "perkSlots", f227_arg3 + 1 )
	end,
	Perk_Slot3 = function ( f228_arg0, f228_arg1, f228_arg2, f228_arg3, f228_arg4 )
		return Cac.GetCacConfig( f228_arg0, f228_arg1, f228_arg2, "perkSlots", f228_arg3 + 2 )
	end,
	Melee = function ( f229_arg0, f229_arg1, f229_arg2, f229_arg3, f229_arg4 )
		return Cac.GetCacConfig( f229_arg0, f229_arg1, f229_arg2, "meleeWeapon" )
	end
}

Cac.GetEquippedWeapon = function ( f231_arg0, f231_arg1, f231_arg2, f231_arg3, f231_arg4, f231_arg5 )
	assert( f231_arg1 ~= nil )
	if f231_arg0 == Cac.EditRemove_SelectedCategory and (f231_arg4 == nil or f231_arg4 == true) and f231_arg1 == Cac.EditRemove_SelectedIndex then
		return Cac.EditRemove_SelectedWeapon
	else
		return weaponEquipedLookup[f231_arg0]( Cac.GetSelectedControllerIndex(), f231_arg2, f231_arg3, f231_arg1, f231_arg5 )
	end
end


Cac.AreAttachmentsCompatible = function ( f423_arg0, f423_arg1 )
	local f423_local0 = Engine.TableLookupGetRowNum( AttachmentComboTable.File, AttachmentComboTable.Cols.Ref, f423_arg1 )
	local f423_local1 = true
	local engine_lookup = Engine.TableLookup( AttachmentComboTable.File, AttachmentComboTable.Cols.Ref, f423_arg0, f423_local0 )
	if f423_arg1 ~= "none" and f423_arg0 ~= "none" and engine_lookup == "no" then
		f423_local1 = false
	end
	return f423_local1
end

f0_local14 = function ( f234_arg0, f234_arg1, f234_arg2, f234_arg3, f234_arg4, f234_arg5, f234_arg6 )
	if Cac.BlingPerkCheck() ~= false then
		if f234_arg6 == 0 then
			local primary_attachkit = Cac.GetEquippedWeapon( "Primary_AttachKit", 0, LUI.CacStaticLayout.ClassLoc, nil, false )
			if not Cac.AreAttachmentsCompatible(f234_arg2, primary_attachkit) then
				return
			end
		elseif f234_arg6 == 1 then
			local secondary_attachkit = Cac.GetEquippedWeapon( "Secondary_AttachKit", 0, LUI.CacStaticLayout.ClassLoc, nil, false )
			if not Cac.AreAttachmentsCompatible(f234_arg2, secondary_attachkit) then
				return
			end
		end
	end

	if f234_arg2 == "base" then
		f234_arg2 = "none"
	end

	local isSniper = Cac.GetWeaponTypeFromWeaponWithoutCategory(Cac.GetEquippedWeapon("Primary", 0, LUI.CacStaticLayout.ClassLoc)) == "weapon_sniper"
	if isSniper == true then
		if f234_arg2 == "acogh2" or f234_arg2 == "thermal" then
			local controller = Cac.GetSelectedControllerIndex()
			local class_index = Cac.GetSelectedClassIndex(LUI.CacStaticLayout.ClassLoc)
			local existing_2d_scope_option = Cac.GetCacConfig(controller, LUI.CacStaticLayout.ClassLoc, class_index, "use2dScopes")
			if existing_2d_scope_option == true then
				Cac.SetCacConfig(controller, LUI.CacStaticLayout.ClassLoc, class_index, "use2dScopes", false)
			end
		end
	end

	Cac.SetCacConfig( f234_arg0, f234_arg3, f234_arg4, "weaponSetups", f234_arg6, "kit", "furnitureKit", tonumber( Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f234_arg2, AttachKitTable.Cols.Id ) ) )
end

f0_local31 = function ( f282_arg0, f282_arg1, f282_arg2, f282_arg3 )
	local f282_local0 = Cac.NullWeaponNames[f282_arg0]
	local f282_local1 = false
	if f282_arg1 == nil then
		for f282_local2 = 0, Cac.GetWeaponSlotCount( f282_arg0, f282_arg2, f282_arg3 ) - 1, 1 do
			if Cac.GetEquippedWeapon( f282_arg0, f282_local2, f282_arg2, f282_arg3 ) ~= f282_local0 then
				f0_local30( f282_arg0, f282_local2, f282_local0, f282_arg2, f282_arg3 )
				f282_local1 = true
			end
		end
	elseif Cac.GetEquippedWeapon( f282_arg0, f282_arg1, f282_arg2, f282_arg3 ) ~= f282_local0 then
		f0_local30( f282_arg0, f282_arg1, f282_local0, f282_arg2, f282_arg3 )
		f282_local1 = true
	end
	return f282_local1
end

f0_local33 = {
	Primary = function ( f284_arg0, f284_arg1, f284_arg2, f284_arg3 )
		return f0_local31( f284_arg0, f284_arg1, f284_arg2, f284_arg3 )
	end,
	Primary_AttachKit = function ( f285_arg0, f285_arg1, f285_arg2, f285_arg3 )
		return f0_local31( f285_arg0, f285_arg1, f285_arg2, f285_arg3 )
	end,
	Primary_FurnitureKit = function ( f286_arg0, f286_arg1, f286_arg2, f286_arg3 )
		return f0_local31( f286_arg0, f286_arg1, f286_arg2, f286_arg3 )
	end,
	Primary_Camo = function ( f287_arg0, f287_arg1, f287_arg2, f287_arg3 )
		return f0_local31( f287_arg0, f287_arg1, f287_arg2, f287_arg3 )
	end,
	Primary_Reticle = function ( f288_arg0, f288_arg1, f288_arg2, f288_arg3 )
		return f0_local31( f288_arg0, f288_arg1, f288_arg2, f288_arg3 )
	end,
	Secondary = function ( f289_arg0, f289_arg1, f289_arg2, f289_arg3 )
		return f0_local31( f289_arg0, f289_arg1, f289_arg2, f289_arg3 )
	end,
	Secondary_AttachKit = function ( f290_arg0, f290_arg1, f290_arg2, f290_arg3 )
		return f0_local31( f290_arg0, f290_arg1, f290_arg2, f290_arg3 )
	end,
	Secondary_FurnitureKit = function ( f291_arg0, f291_arg1, f291_arg2, f291_arg3 )
		return f0_local31( f291_arg0, f291_arg1, f291_arg2, f291_arg3 )
	end,
	Secondary_Camo = function ( f292_arg0, f292_arg1, f292_arg2, f292_arg3 )
		return f0_local31( f292_arg0, f292_arg1, f292_arg2, f292_arg3 )
	end,
	Secondary_Reticle = function ( f293_arg0, f293_arg1, f293_arg2, f293_arg3 )
		return f0_local31( f293_arg0, f293_arg1, f293_arg2, f293_arg3 )
	end,
	Lethal = function ( f294_arg0, f294_arg1, f294_arg2, f294_arg3 )
		return f0_local31( f294_arg0, f294_arg1, f294_arg2, f294_arg3 )
	end,
	Tactical = function ( f295_arg0, f295_arg1, f295_arg2, f295_arg3 )
		return f0_local31( f295_arg0, f295_arg1, f295_arg2, f295_arg3 )
	end,
	Perk_Slot1 = function ( f296_arg0, f296_arg1, f296_arg2, f296_arg3 )
		return f0_local31( f296_arg0, f296_arg1, f296_arg2, f296_arg3 )
	end,
	Perk_Slot2 = function ( f297_arg0, f297_arg1, f297_arg2, f297_arg3 )
		return f0_local31( f297_arg0, f297_arg1, f297_arg2, f297_arg3 )
	end,
	Perk_Slot3 = function ( f298_arg0, f298_arg1, f298_arg2, f298_arg3 )
		return f0_local31( f298_arg0, f298_arg1, f298_arg2, f298_arg3 )
	end,
	Melee = function ( f299_arg0, f299_arg1, f299_arg2, f299_arg3 )
		return f0_local31( f299_arg0, f299_arg1, f299_arg2, f299_arg3 )
	end
}

remove_weapon_config = function ( f316_arg0, f316_arg1, f316_arg2, f316_arg3 )
	local f316_local0 = false
	if f316_arg0 == Cac.EditRemove_SelectedCategory and f316_arg1 == Cac.EditRemove_SelectedIndex then
		Cac.ClearEditRemoveWeapon()
		f316_local0 = true
	else
		f316_local0 = f0_local33[f316_arg0]( f316_arg0, f316_arg1, f316_arg2, f316_arg3 )
	end
	if Cac.EditRemove_SelectedCategory and Cac.GetEquippedWeaponCount( f316_arg2, f316_arg3 ) <= Cac.GetMaxEquippedWeaponCount( f316_arg2 ) then
		local f316_local1 = Cac.EditRemove_SelectedCategory
		local f316_local2 = Cac.EditRemove_SelectedIndex
		local f316_local3 = Cac.EditRemove_SelectedWeapon
		Cac.ClearEditRemoveWeapon()
		f0_local30( f316_local1, f316_local2, f316_local3, f316_arg2, f316_arg3 )
	end
	return f316_local0
end

Cac.Perk1Disabled = function ()
	return false
end

f0_local13 = function ( f233_arg0, f233_arg1, f233_arg2, f233_arg3, f233_arg4, f233_arg5, f233_arg6 )
	if Cac.BlingPerkCheck() ~= false then
		if f233_arg6 == 0 then
			local primary_attachkit = Cac.GetEquippedWeapon( "Primary_FurnitureKit", 0, LUI.CacStaticLayout.ClassLoc, nil, false )
			if not Cac.AreAttachmentsCompatible(f233_arg2, primary_attachkit) then
				return
			end
		elseif f233_arg6 == 1 then
			local secondary_attachkit = Cac.GetEquippedWeapon( "Secondary_FurnitureKit", 0, LUI.CacStaticLayout.ClassLoc, nil, false )
			if not Cac.AreAttachmentsCompatible(f233_arg2, secondary_attachkit) then
				return
			end
		end
	end

	local isSniper = Cac.GetWeaponTypeFromWeaponWithoutCategory(Cac.GetEquippedWeapon("Primary", 0, LUI.CacStaticLayout.ClassLoc)) == "weapon_sniper"
	if isSniper == true then
		if f233_arg2 == "acogh2" or f233_arg2 == "thermal" then
			local controller = Cac.GetSelectedControllerIndex()
			local class_index = Cac.GetSelectedClassIndex(LUI.CacStaticLayout.ClassLoc)
			local existing_2d_scope_option = Cac.GetCacConfig(controller, LUI.CacStaticLayout.ClassLoc, class_index, "use2dScopes")
			if existing_2d_scope_option == true then
				Cac.SetCacConfig(controller, LUI.CacStaticLayout.ClassLoc, class_index, "use2dScopes", false)
			end
		end
	end

	Cac.SetCacConfig( f233_arg0, f233_arg3, f233_arg4, "weaponSetups", f233_arg6, "kit", "attachKit", tonumber( Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f233_arg2, AttachKitTable.Cols.Id ) ) )
end

weaponSetConfig = {
	Primary = function ( f235_arg0, f235_arg1, f235_arg2, f235_arg3, f235_arg4, f235_arg5 )
		Cac.SetCacConfig( f235_arg0, f235_arg3, f235_arg4, "weaponSetups", 0, "weapon", f235_arg2 )
	end,
	Primary_AttachKit = function ( f236_arg0, f236_arg1, f236_arg2, f236_arg3, f236_arg4, f236_arg5 )
		f0_local13( f236_arg0, f236_arg1, f236_arg2, f236_arg3, f236_arg4, f236_arg5, 0 )
	end,
	Primary_FurnitureKit = function ( f237_arg0, f237_arg1, f237_arg2, f237_arg3, f237_arg4, f237_arg5 )
		f0_local14( f237_arg0, f237_arg1, f237_arg2, f237_arg3, f237_arg4, f237_arg5, 0 )
	end,
	Primary_Camo = function ( f238_arg0, f238_arg1, f238_arg2, f238_arg3, f238_arg4, f238_arg5 )
		Cac.SetCacConfig( f238_arg0, f238_arg3, f238_arg4, "weaponSetups", 0, "camo", f238_arg2 )
	end,
	Primary_Reticle = function ( f239_arg0, f239_arg1, f239_arg2, f239_arg3, f239_arg4, f239_arg5 )
		Cac.SetCacConfig( f239_arg0, f239_arg3, f239_arg4, "weaponSetups", 0, "reticle", f239_arg2 )
	end,
	Secondary = function ( f240_arg0, f240_arg1, f240_arg2, f240_arg3, f240_arg4, f240_arg5 )
		Cac.SetCacConfig( f240_arg0, f240_arg3, f240_arg4, "weaponSetups", 1, "weapon", f240_arg2 )
	end,
	Secondary_AttachKit = function ( f241_arg0, f241_arg1, f241_arg2, f241_arg3, f241_arg4, f241_arg5 )
		f0_local13( f241_arg0, f241_arg1, f241_arg2, f241_arg3, f241_arg4, f241_arg5, 1 )
	end,
	Secondary_FurnitureKit = function ( f242_arg0, f242_arg1, f242_arg2, f242_arg3, f242_arg4, f242_arg5 )
		f0_local14( f242_arg0, f242_arg1, f242_arg2, f242_arg3, f242_arg4, f242_arg5, 1 )
	end,
	Secondary_Camo = function ( f243_arg0, f243_arg1, f243_arg2, f243_arg3, f243_arg4, f243_arg5 )
		Cac.SetCacConfig( f243_arg0, f243_arg3, f243_arg4, "weaponSetups", 1, "camo", f243_arg2 )
	end,
	Secondary_Reticle = function ( f244_arg0, f244_arg1, f244_arg2, f244_arg3, f244_arg4, f244_arg5 )
		Cac.SetCacConfig( f244_arg0, f244_arg3, f244_arg4, "weaponSetups", 1, "reticle", f244_arg2 )
	end,
	Lethal = function ( f245_arg0, f245_arg1, f245_arg2, f245_arg3, f245_arg4, f245_arg5 )
		Cac.SetCacConfig( f245_arg0, f245_arg3, f245_arg4, "equipment", 0, f245_arg2 )
	end,
	Tactical = function ( f246_arg0, f246_arg1, f246_arg2, f246_arg3, f246_arg4, f246_arg5 )
		Cac.SetCacConfig( f246_arg0, f246_arg3, f246_arg4, "equipment", 1, f246_arg2 )
	end,
	Perk_Slot1 = function ( f247_arg0, f247_arg1, f247_arg2, f247_arg3, f247_arg4, f247_arg5 )
		Cac.SetCacConfig( f247_arg0, f247_arg3, f247_arg4, "perkSlots", f247_arg1, f247_arg2 )

		if Cac.BlingPerkCheck() ~= true then
			remove_weapon_config( "Primary_FurnitureKit", 0, f247_arg3, f247_arg4 )
			remove_weapon_config( "Secondary_FurnitureKit", 0, f247_arg3, f247_arg4 )
		end
	end,
	Perk_Slot2 = function ( f248_arg0, f248_arg1, f248_arg2, f248_arg3, f248_arg4, f248_arg5 )
		Cac.SetCacConfig( f248_arg0, f248_arg3, f248_arg4, "perkSlots", f248_arg1 + 1, f248_arg2 )
	end,
	Perk_Slot3 = function ( f249_arg0, f249_arg1, f249_arg2, f249_arg3, f249_arg4, f249_arg5 )
		Cac.SetCacConfig( f249_arg0, f249_arg3, f249_arg4, "perkSlots", f249_arg1 + 2, f249_arg2 )
	end,
	Melee = function ( f250_arg0, f250_arg1, f250_arg2, f250_arg3, f250_arg4, f250_arg5 )
		Cac.SetCacConfig( f250_arg0, f250_arg3, f250_arg4, "meleeWeapon", f250_arg2 )
	end
}

f0_local16 = function ( f251_arg0, f251_arg1, f251_arg2, f251_arg3, f251_arg4, f251_arg5 )
	weaponSetConfig[f251_arg0]( Cac.GetSelectedControllerIndex(), f251_arg1, f251_arg2, f251_arg3, f251_arg4, f251_arg5 )
end

f0_local17 = function ( f252_arg0, f252_arg1, f252_arg2 )
	local f252_local0 = Cac.NullWeaponNames[f252_arg0]
	for f252_local1 = 0, Cac.GetWeaponSlotCount( f252_arg0, f252_arg1, f252_arg2 ) - 1, 1 do
		f0_local16( f252_arg0, f252_local1, f252_local0, f252_arg1, f252_arg2 )
	end
end

f0_local19 = function ( f254_arg0, f254_arg1, f254_arg2, f254_arg3, f254_arg4 )
	local f254_local0 = Cac.NullWeaponNames[f254_arg0]
	local f254_local1 = "Primary_Reticle"
	if f254_arg0 == "Secondary_AttachKit" then
		f254_local1 = "Secondary_Reticle"
	end
	local f254_local2 = Cac.GetEquippedWeapon( f254_arg0, 0, f254_arg3, f254_arg4, false )
	if f254_local2 ~= f254_arg2 then
		if Cac.DoesAttachKitAllowReticles( f254_local2 ) and not Cac.DoesAttachKitAllowReticles( f254_arg2 ) and not Cac.OverrideClearReticle then
			f0_local17( f254_local1, f254_arg3, f254_arg4 )
		end
		f0_local16( f254_arg0, f254_arg1, f254_arg2, f254_arg3, f254_arg4 )
	end
end

f0_local20 = function ( f255_arg0, f255_arg1, f255_arg2, f255_arg3, f255_arg4 )
	local f255_local0 = Cac.NullWeaponNames[f255_arg0]
	if Cac.GetEquippedWeapon( f255_arg0, f255_arg1, f255_arg3, f255_arg4 ) == "specialty_twoprimaries" or f255_arg2 == "specialty_twoprimaries" then
		remove_weapon_config( "Secondary", 0, f255_arg3, f255_arg4 )
		if f255_arg2 == "specialty_twoprimaries" then
			if Cac.GetEquippedWeapon( "Primary", 0, f255_arg3, f255_arg4 ) ~= "h1_m16" then
				f0_local16( "Secondary", 0, "h1_m16", f255_arg3, f255_arg4 )
			else
				f0_local16( "Secondary", 0, "h1_ak47", f255_arg3, f255_arg4 )
			end
		else
			f0_local16( "Secondary", 0, "h1_beretta", f255_arg3, f255_arg4 )
		end
	end
	f0_local16( f255_arg0, f255_arg1, f255_arg2, f255_arg3, f255_arg4 )
end

f0_local29 = {
	Primary_AttachKit = function ( f265_arg0, f265_arg1, f265_arg2, f265_arg3, f265_arg4 )
		f0_local19( f265_arg0, f265_arg1, f265_arg2, f265_arg3, f265_arg4 )
		return true
	end,
	Primary_FurnitureKit = function ( f266_arg0, f266_arg1, f266_arg2, f266_arg3, f266_arg4 )
		f0_local16( f266_arg0, f266_arg1, f266_arg2, f266_arg3, f266_arg4 )
		return true
	end,
	Secondary_AttachKit = function ( f270_arg0, f270_arg1, f270_arg2, f270_arg3, f270_arg4 )
		f0_local19( f270_arg0, f270_arg1, f270_arg2, f270_arg3, f270_arg4 )
		return true
	end,
	Secondary_FurnitureKit = function ( f271_arg0, f271_arg1, f271_arg2, f271_arg3, f271_arg4 )
		f0_local16( f271_arg0, f271_arg1, f271_arg2, f271_arg3, f271_arg4 )
		return true
	end,
	Perk_Slot1 = function ( f276_arg0, f276_arg1, f276_arg2, f276_arg3, f276_arg4 )
		f0_local20( f276_arg0, f276_arg1, f276_arg2, f276_arg3, f276_arg4 )
		return true
	end,
}
f0_local30 = function ( f280_arg0, f280_arg1, f280_arg2, f280_arg3, f280_arg4 )
	return f0_local29[f280_arg0]( f280_arg0, f280_arg1, f280_arg2, f280_arg3, f280_arg4 )
end

Cac.SelectEquippedWeaponOriginal = Cac.SelectEquippedWeapon
Cac.SelectEquippedWeapon = function ( f281_arg0, f281_arg1, f281_arg2, f281_arg3, f281_arg4 )
	if f281_arg0 ~= "Primary_FurnitureKit" and f281_arg0 ~= "Secondary_FurnitureKit" and f281_arg0 ~= "Primary_AttachKit" and f281_arg0 ~= "Secondary_AttachKit" and f281_arg0 ~= "Perk_Slot1" then
		Cac.SelectEquippedWeaponOriginal( f281_arg0, f281_arg1, f281_arg2, f281_arg3, f281_arg4 )
		return
	end

	local f281_local0 = f0_local30( f281_arg0, f281_arg1, f281_arg2, f281_arg3, f281_arg4 )
	if f281_local0 == true then
		local f281_local1 = CoD.SFX.CaC[f281_arg2]
		if f281_local1 == nil then
			local f281_local2 = Cac.GetWeaponTypeFromWeapon( f281_arg0, f281_arg2 )
			if f281_local2 ~= nil then
				f281_local1 = CoD.SFX.CaC[f281_local2]
			end
		end
		if f281_local1 ~= nil then
			Engine.PlaySound( f281_local1 )
		end
	end
	if Engine.GetDvarBool( "virtualLobbyActive" ) then
		Cac.SetVirtualLobbyLoadout( Cac.GetSelectedControllerIndex() )
	end
	return f281_local0
end

weaponImageLookup = {
	Primary = function ( f352_arg0, f352_arg1 )
		if f352_arg1 == Cac.NullWeaponNames[f352_arg0] then
			return "ui_transparent"
		else
			return Cac.GetImageNameFromStatsTable( f352_arg1 )
		end
	end,
	Primary_AttachKit = function ( f353_arg0, f353_arg1 )
		return Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f353_arg1, AttachKitTable.Cols.Image )
	end,
	Primary_FurnitureKit = function ( f354_arg0, f354_arg1 )
		return Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f354_arg1, AttachKitTable.Cols.Image )
	end,
	Primary_Camo = function ( f355_arg0, f355_arg1 )
		return Engine.TableLookup( CamoTable.File, CamoTable.Cols.Ref, f355_arg1, CamoTable.Cols.Image )
	end,
	Primary_Reticle = function ( f356_arg0, f356_arg1 )
		return Engine.TableLookup( ReticleTable.File, ReticleTable.Cols.Ref, f356_arg1, ReticleTable.Cols.Image )
	end,
	Secondary = function ( f357_arg0, f357_arg1 )
		if f357_arg1 == Cac.NullWeaponNames[f357_arg0] then
			return "ui_transparent"
		else
			return Cac.GetImageNameFromStatsTable( f357_arg1 )
		end
	end,
	Secondary_AttachKit = function ( f358_arg0, f358_arg1 )
		return Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f358_arg1, AttachKitTable.Cols.Image )
	end,
	Secondary_FurnitureKit = function ( f359_arg0, f359_arg1 )
		return Engine.TableLookup( AttachKitTable.File, AttachKitTable.Cols.Ref, f359_arg1, AttachKitTable.Cols.Image )
	end,
	Secondary_Camo = function ( f360_arg0, f360_arg1 )
		return Engine.TableLookup( CamoTable.File, CamoTable.Cols.Ref, f360_arg1, CamoTable.Cols.Image )
	end,
	Secondary_Reticle = function ( f361_arg0, f361_arg1 )
		return Engine.TableLookup( ReticleTable.File, ReticleTable.Cols.Ref, f361_arg1, ReticleTable.Cols.Image )
	end,
	Lethal = function ( f362_arg0, f362_arg1 )
		return Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f362_arg1, PerkTable.Cols.Image )
	end,
	Tactical = function ( f363_arg0, f363_arg1 )
		return Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f363_arg1, PerkTable.Cols.Image )
	end,
	Perk_Slot1 = function ( f364_arg0, f364_arg1 )
		return Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f364_arg1, PerkTable.Cols.Image )
	end,
	Perk_Slot2 = function ( f365_arg0, f365_arg1 )
		return Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f365_arg1, PerkTable.Cols.Image )
	end,
	Perk_Slot3 = function ( f366_arg0, f366_arg1 )
		return Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f366_arg1, PerkTable.Cols.Image )
	end,
	Melee = function ( f367_arg0, f367_arg1 )
		if f367_arg1 == Cac.NullWeaponNames[f367_arg0] then
			return "ui_transparent"
		else
			return Cac.GetImageNameFromStatsTable( f367_arg1 )
		end
	end
}

Cac.GetWeaponImageName = function ( f368_arg0, f368_arg1 )

	if f368_arg0 == "Secondary" and HasOmaEquiped() then
		return "weapon_onemanarmy"
	end

	if f368_arg0 == "Secondary_AttachKit" and HasOmaEquiped() then
		return "ui_transparent"
	end

	if f368_arg0 == "Secondary_FurnitureKit" and HasOmaEquiped() then
		return "ui_transparent"
	end

	return weaponImageLookup[f368_arg0]( f368_arg0, f368_arg1 )
end

LUI.CacDataProvider.Secondary = function ( f9_arg0 )
	local f9_local0 = "Secondary"
	local f9_local1 = Cac.HasOverkill() and "Primary" or "Secondary"
	local f9_local2 = LUI.CacDataProvider.Default( f9_local0, f9_local1, f9_arg0.secondary, 0 )
	LUI.CacDataProvider.Weapon( f9_local1, f9_arg0.secondary, f9_local2 )
	if f9_arg0.secondaryCamo and f9_arg0.secondaryCamo ~= Cac.NullWeaponName_Secondary_Camo then
		f9_local2.camoImage = Cac.GetWeaponImage( "Secondary_Camo", f9_arg0.secondaryCamo )
		f9_local2.camoLabel = Cac.GetWeaponName( "Secondary_Camo", f9_arg0.secondaryCamo )
	end

    if OmaPerkCheck() ~= true then
        f9_local2.elementDisabled = true
        f9_local2.label = Cac.GetWeaponName( "Perk_Slot1", "specialty_onemanarmy" )
        f9_local2.camoImage = nil
        f9_local2.camoLabel = Engine.Localize( "@LUA_MENU_NO_ATTACHKITS_AVAILABLE" )
    end

	return f9_local2
end

LUI.CacDataProvider.SecondaryAttachKit = function ( f10_arg0 )
	local f10_local0 = LUI.CacDataProvider.Default( "Secondary_AttachKit", Cac.HasOverkill() and "Primary_AttachKit" or "Secondary_AttachKit", f10_arg0.secondaryAttachKit, 0 )
	if not Cac.WeaponHasAttachKitsAvailable( Cac.GetSelectedControllerIndex(), f10_arg0.secondary, "Secondary" ) then
		f10_local0.elementDisabled = true
	end
	if Engine.InFrontend() and f10_local0.hasNew then
		local f10_local1 = false
		if f10_arg0.secondary then
			for f10_local5, f10_local6 in pairs( Cac.GetAllDefinedAndValidWeapons( "Secondary_AttachKit", nil, LUI.CacStaticLayout.ClassLoc, nil, Cac.NotPreorderWeapon, Cac.GetSelectedControllerIndex() ) ) do
				if LUI.InventoryUtils.GetItemNewStickerState( Cac.GetSelectedControllerIndex(), Cac.GetWeaponNameFromLootName( f10_arg0.secondary ) .. " " .. f10_local6[1] ) then
					f10_local1 = true
					break
				end
			end
		end
		f10_local0.hasNew = f10_local1
	end
	if Cac.NullWeaponNames[f10_local0.weaponCategory] == f10_local0.id then
		f10_local0.label = ""
		if f10_local0.elementDisabled then
			f10_local0.label = Engine.Localize( "@LUA_MENU_NO_ATTACHKITS_AVAILABLE" )
		end
	else
		f10_local0.label = Cac.GetWeaponName( f10_local0.weaponCategory, f10_local0.id )
	end

    if OmaPerkCheck() ~= true then
        f10_local0.label = Engine.Localize( "@LUA_MENU_NO_ATTACHKITS_AVAILABLE" )
    end

	return f10_local0
end

LUI.CacDataProvider.SecondaryFurnitureKit = function ( f11_arg0 )
	local f11_local0 = LUI.CacDataProvider.Default( "Secondary_FurnitureKit", Cac.HasOverkill() and "Primary_FurnitureKit" or "Secondary_FurnitureKit", f11_arg0.secondaryFurnitureKit, 0 )
	if not Cac.WeaponHasFurnitureKitsAvailable( Cac.GetSelectedControllerIndex(), f11_arg0.secondary, "Secondary" ) then
		f11_local0.elementDisabled = true
	end
	if Engine.InFrontend() and f11_local0.hasNew then
		local f11_local1 = false
		if f11_arg0.secondary then
			for f11_local5, f11_local6 in pairs( Cac.GetAllDefinedAndValidWeapons( "Secondary_FurnitureKit", nil, LUI.CacStaticLayout.ClassLoc, nil, Cac.NotPreorderWeapon, Cac.GetSelectedControllerIndex() ) ) do
				if LUI.InventoryUtils.GetItemNewStickerState( Cac.GetSelectedControllerIndex(), Cac.GetWeaponNameFromLootName( f11_arg0.secondary ) .. " " .. f11_local6[1] ) then
					f11_local1 = true
					break
				end
			end
		end
		f11_local0.hasNew = f11_local1
	end
	if Cac.NullWeaponNames[f11_local0.weaponCategory] == f11_local0.id then
		f11_local0.label = ""
		if f11_local0.elementDisabled then
			f11_local0.label = Engine.Localize( "@LUA_MENU_NO_FURNITUREKITS_AVAILABLE" )
		end
	else
		f11_local0.label = Cac.GetWeaponName( f11_local0.weaponCategory, f11_local0.id )
	end

    if OmaPerkCheck() ~= true then
        f11_local0.label = Engine.Localize( "@LUA_MENU_NO_ATTACHKITS_AVAILABLE" )
        f11_local0.displayName = Engine.Localize( "@LUA_MENU_NO_ATTACHKITS_AVAILABLE" )
    end

	return f11_local0
end

Cac.GetPerkRestricted = function ( f131_arg0 )
	if f131_arg0 == nil or f131_arg0 == "" then
		return false
	end
	return MatchRules.GetData( "commonOption", "perkRestricted", f131_arg0 )
end

Cac.PasteClassFromObj = function ( f324_arg0, f324_arg1, f324_arg2 )
	local f324_local0 = Cac.GetCustomClassName( f324_arg0, f324_arg1 )
	Cac.ClearClass( f324_arg0, f324_arg1 )
	for f324_local4, f324_local5 in pairs( f324_arg2 ) do
		if f324_local5.dataType == "cacItem" then
			f0_local16( f324_local5.weaponCategory, f324_local5.weaponIndex, f324_local5.newWeapon, f324_arg0, f324_arg1, f324_local5.moduleIndex )
		end
		if f324_local5.dataType == "className" then
			if f324_local5.disableRename == true then
				Cac.SetCustomClassName( f324_local0, f324_arg0, f324_arg1 )
			end
			if f324_arg1 ~= 5 then
				Cac.SetCustomClassName( f324_local5.srcClassName, f324_arg0, f324_arg1 )
			else
				Cac.SetCustomClassName( f324_local0, f324_arg0, f324_arg1 )
			end
		end
	end
end

-- to remove social button from cac

if Engine.InFrontend() then
	local CacHook = luiglobals.require("LUI.mp_menus.Cac")

	local function Refresh( f1_arg0 )
		local f1_local0 = Cac.GetLoadout( LUI.CacStaticLayout.ClassLoc, f1_arg0.selectedClassIndex )
		if f1_arg0 == nil then
			f1_arg0 = {}
		end
		f1_arg0.loadout = f1_local0
		if f1_arg0.staticLayout then
			local f1_local1 = nil
			local f1_local2 = #f1_arg0.staticLayout.containers
			for f1_local3 = 1, f1_local2, 1 do
				f1_arg0.staticLayout.containers[f1_local3]:Refresh( f1_local0 )
			end
		end
		f1_arg0.haveRestrictedClasses = false
		if f1_arg0.list then
			f1_arg0.list:processEvent( {
				name = "refresh_class_name",
				dispatchChildren = true
			} )
			CacHook.RefreshHelpButtons( f1_arg0 )
		end
	end

	local function OnToggleDefault( f18_arg0 )
		Cac.SetClassInUse( LUI.CacStaticLayout.ClassLoc, f18_arg0.selectedClassIndex, not Cac.IsClassInUse( LUI.CacStaticLayout.ClassLoc, f18_arg0.selectedClassIndex ) )
		Refresh( f18_arg0 )
	end

	local function goBack( f27_arg0 )
		Cac.ClearCopyData()
		LUI.FlowManager.RequestLeaveMenu( f27_arg0 )
	end

	local function OnFiringRange( f8_arg0 )
		if Engine.GetDvarBool( "virtualLobbyActive" ) and Engine.GetDvarBool( "virtualLobbyPresentable" ) then
			Engine.PlaySound( CoD.SFX.MenuAccept )
			PersistentBackground.FadeFromBlackSlow()
			Engine.CloseScreenKeyboard( Cac.GetSelectedControllerIndex() )
			Cac.SetVirtualLobbyLoadout( Cac.GetSelectedControllerIndex() )
			Cac.NotifyVLClassChange( Cac.GetSelectedControllerIndex(), -1, LUI.CacStaticLayout.ClassLoc )
			Lobby.SetFiringRangeController( Cac.GetSelectedControllerIndex() )
			LUI.FlowManager.RequestAddMenu( f8_arg0, "FiringRange" )
		end
		return true
	end

	CacHook.RefreshHelpButtons = function( f2_arg0 )
		local f2_local0 = f2_arg0.properties or {}
		local f2_local1 = f2_arg0.list:getFirstInFocus()
		local f2_local2
		if f2_local1 then
			f2_local2 = f2_local1.properties.isLocked
		else
			f2_local2 = true
		end
		local f2_local3 = f2_local1 and f2_local1.properties.isDlcLocked
		LUI.ButtonHelperText.ClearHelperTextObjects( f2_arg0.help, {
			side = "all"
		} )
		LUI.ButtonHelperText.AddHelperTextObject( f2_arg0.help, LUI.ButtonHelperText.CommonEvents.addBackButton, goBack )
		if f2_arg0.properties.equipRef then
			f2_arg0:AddHelp( {
				name = "add_button_helper_text",
				button_ref = "button_action",
				helper_text = Engine.Localize( "@DEPOT_EQUIP" ),
				side = "left",
				clickable = false,
				priority = -1000
			} )
			if f2_local1 ~= nil and f2_local1.restricted then
				f2_arg0:AddHelp( {
					name = "add_button_helper_text",
					id = "restricted",
					image_name = CoD.Material.RestrictedIcon,
					helper_text = Engine.Localize( "@DEPOT_NOT_COMPATIBLE" ),
					side = "top_right",
					clickable = false,
					priority = -1000
				} )
			end
		elseif Engine.IsConsoleGame() or Engine.IsGamepadEnabled() then
			f2_arg0:processEvent( LUI.ButtonHelperText.CommonEvents.addSelectButton )
		end
		if f2_local3 then
			LUI.ButtonHelperText.AddHelperTextObject( f2_arg0.help, {
				name = "add_button_helper_text",
				button_ref = "button_action",
				helper_text = Engine.Localize( "@LUA_MENU_STORE" ),
				side = "right",
				clickable = true,
				priority = -1000
			}, function ( f3_arg0, f3_arg1 )
				if f2_local1 then
					f2_local1.properties:button_action_func( f3_arg1 )
				end
			end )
		elseif not f2_local2 then
			if not f2_local0.editMatchPresets then
				LUI.ButtonHelperText.AddHelperTextObject( f2_arg0.help, {
					name = "add_button_helper_text",
					button_ref = "button_start",
					helper_text = Engine.Localize( "@MPUI_FIRINGRANGE" ),
					side = "right",
					clickable = true,
					priority = -1000
				}, function ( f4_arg0, f4_arg1 )
					OnFiringRange( f2_arg0 )
				end )
			end
			local class_options_helper = LUI.ButtonHelperText.AddHelperTextObject( f2_arg0.help, {
				name = "add_button_helper_text",
				button_ref = "button_alt1",
				helper_text = Engine.Localize( "@LUA_MENU_CLASS_OPTIONS" ),
				side = "right",
				clickable = true,
				priority = -1000
			}, function ( f5_arg0, f5_arg1 )
				LUI.FlowManager.RequestAddMenu( nil, "cac_class_options_popup", true, f5_arg1.controller, false, {
					callback_params = {
						menu = f2_arg0
					}
				} )
			end )
			class_options_helper:clearActionSFX()
			if f2_local0.editMatchPresets then
				LUI.ButtonHelperText.AddHelperTextObject( f2_arg0.help, {
					name = "add_button_helper_text",
					button_ref = "button_select",
					helper_text = Engine.Localize( "@LUA_MENU_TOGGLE_DEFAULT" ),
					side = "right",
					clickable = true,
					priority = -1000
				}, function ( f6_arg0, f6_arg1 )
					Engine.PlaySound( CoD.SFX.MouseClick )
					OnToggleDefault( f2_arg0 )
				end )
			end
			f2_arg0:registerEventHandler( "text_input_complete", function ( element, event )
				if event.text and event.text ~= "" then
					if #event.text > CoD.MaxClassNameLength then
						event.text = string.sub( event.text, 1, CoD.MaxClassNameLength )
						LUI.FlowManager.RequestAddMenu( element, "generic_confirmation_popup", false, false, false, {
							popup_title = Engine.Localize( "@MENU_WARNING" ),
							message_text = Engine.Localize( "@LUA_MENU_CUSTOM_CLASS_NAME_TOO_LONG", CoD.MaxClassNameLength )
						} )
					end
					Cac.SetCustomClassName( event.text, LUI.CacStaticLayout.ClassLoc )
					Refresh( f2_arg0 )
				end
			end )
			if f2_arg0.haveRestrictedClasses then
				LUI.ButtonHelperText.AddHelperTextObject( f2_arg0.help, LUI.ButtonHelperText.CommonEvents.addRestrictedHelp )
			end
		end
		f2_arg0:AddRotateHelp()
		if f2_arg0.factionWidget then
			f2_arg0.factionWidget:ShowHelpButtons()
		end
	end
end