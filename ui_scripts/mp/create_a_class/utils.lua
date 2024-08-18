Cac.DoesWeaponSupportAttachKit = function ( weaponName, index )
	local weapon = weaponName .. "_mp"
	local attach1 = AttachKitTable.Cols.Attach1
	local attach4 = AttachKitTable.Cols.Attach4
	for attachIndex = attach1, attach4, 1 do
		local rowValue = Engine.TableLookupByRow( AttachKitTable.File, index, attachIndex )
		if rowValue == nil or rowValue == "" then
			return true
		elseif not Engine.DoesWeaponSupportAttachment( weapon, rowValue ) then
			return false
		end
	end
	return true
end

Cac.GetValidAttachKits = function ( f173_arg0, weaponName, f173_arg2 )
	local f173_local0, weaponType, f173_local2 = nil
	local f173_local3 = {
		{
			"none",
			0
		}
	}

	if (weaponName == "h1_mp44" or weaponName == "h1_deserteagle" or weaponName == "h1_deserteagle55") and not Engine.GetDvarBool( "unlockDevAttachments" ) then
		f173_local2 = true
	end

	weaponType = Cac.KitWeaponTypes[Cac.H2MGetWeaponTypeFromWeaponWithoutCategory( weaponName )]
	if weaponType ~= nil then
		local tableRowCount = Engine.TableGetRowCount( AttachKitTable.File )
		for index = 1, tableRowCount - 1, 1 do
			if Cac.IsValidLootdrop( Engine.TableLookupByRow( AttachKitTable.File, index, AttachKitTable.Cols.Lootdrop ) ) then
				local validAttachmentKit = nil
				local f173_local9 = Engine.TableLookupByRow( AttachKitTable.File, index, AttachKitTable.Cols.Valid )
				if f173_local9 == "" then
					validAttachmentKit = true
				else
					for match in string.gmatch( f173_local9, "%a+" ) do
						if match == weaponType then
							validAttachmentKit = true
							break
						end
					end
				end
				if validAttachmentKit ~= nil then
					local validMatch = nil
					local GlobalID = Engine.TableLookupByRow( AttachKitTable.File, index, AttachKitTable.Cols.GlobalID )
					if f173_local2 ~= nil and Engine.Inventory_GetItemTypeByGuid( GlobalID ) == Cac.InventoryItemType.Default then
						validMatch = true
					end

					if validMatch == nil then
						local attachmentNameContainsDev = string.sub( Engine.TableLookupByRow( AttachKitTable.File, index, AttachKitTable.Cols.Ref ), 1, 3 ) == "dev"
						local isDevAttachment = nil
						if attachmentNameContainsDev and not Engine.GetDvarBool( "unlockDevAttachments" ) then
							isDevAttachment = true
						end

						if isDevAttachment == nil and Cac.DoesWeaponSupportAttachKit( weaponName, index ) then
							local f173_local15, f173_local16, f173_local17 = Cac.GetItemLockState( f173_arg0, GlobalID, nil, false )
							if f173_local15 ~= "Hidden" then
								local kitName = Engine.TableLookupByRow( AttachKitTable.File, index, AttachKitTable.Cols.Ref )
								local f173_local19, f173_local20, f173_local21 = Cac.GetItemLockState( f173_arg0, nil, Cac.GetUnlockItemRef( kitName, weaponName ), false )
								f173_local17 = f173_local21
								f173_local16 = f173_local20
								if f173_local19 ~= "Hidden" and kitName ~= nil and kitName ~= "" and kitName ~= "none" then
									f173_local3[#f173_local3 + 1] = {
										kitName,
										0
									}
								end
							end
						end
					end
				end
			end
		end
	end
	return f173_local3
end

Cac.GetAllDefinedAndValidWeapons = function ( StorageCategory, weaponCategory, classType, f169_arg3, f169_arg4, controller, weaponID )
	local f169_local0 = {}
	if StorageCategory == "Primary_AttachKit" or StorageCategory == "Secondary_AttachKit" or StorageCategory == "Primary_FurnitureKit" or StorageCategory == "Secondary_FurnitureKit" then
		local f169_local1 = nil
		local f169_local2 = ""
		if StorageCategory == "Primary_AttachKit" or StorageCategory == "Primary_FurnitureKit" then
			f169_local2 = "Primary"
		else
			f169_local2 = "Secondary"
		end
		if weaponID then
			f169_local1 = weaponID
		else
			f169_local1 = Cac.GetEquippedWeapon( f169_local2, 0, classType, f169_arg3 )
		end
		f169_local0 = Cac.GetValidAttachKits( controller, f169_local1, f169_local2 )
	else
		assert( Cac.Weapons[StorageCategory][weaponCategory] )
		local f169_local1 = function ( f170_arg0 )
			if Engine.Inventory_GetItemTypeByReference( f170_arg0[1] ) == Cac.InventoryItemType.Entitlement then
				local f170_local0, f170_local1, f170_local2 = Cac.GetItemLockState( controller, nil, f170_arg0[1] )
				if f170_local0 == "Hidden" then
					return false
				elseif not Engine.Inventory_IsItemUsableForPlayer( controller, f170_arg0[1] ) and f170_local1 ~= Cac.ItemLockStatus.DlcRequired then
					return false
				end
			else
				local f170_local0, f170_local1, f170_local2 = Cac.GetItemLockState( controller, nil, f170_arg0[1], nil, weaponID )
				if f170_local0 == "Hidden" then
					return false
				end
			end
			return true
		end
		
		local f169_local2 = Cac.Weapons[StorageCategory][weaponCategory]
		for f169_local3 = 1, #f169_local2, 1 do
			if f169_arg4 then
				if f169_arg4( f169_local2[f169_local3] ) and f169_local1( f169_local2[f169_local3] ) then
					table.insert( f169_local0, f169_local2[f169_local3] )
				end
            else
                if f169_local1( f169_local2[f169_local3] ) then
					if weaponCategory == "perk" then
						local upgradedPerk = Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f169_local2[f169_local3][1], PerkTable.Cols.Upgrade )
						if upgradedPerk ~= nil and upgradedPerk ~= "" then
							local pro_perk_unlock_table = Engine.TableLookup( UnlockTable.File, UnlockTable.Cols.ItemId, upgradedPerk, UnlockTable.Cols.Challenge )
							if pro_perk_unlock_table ~= nil and pro_perk_unlock_table ~= "" then
								local f8_local24, f8_local25 = ParseChallengeName( pro_perk_unlock_table )
								local challenge_data = GetChallengeData( Cac.GetSelectedControllerIndex(), f8_local24, false, f8_local25 )
								if challenge_data.Completed == true then
									local original_is_unlocked = Cac.IsClassItemUnlocked( controller, f169_local2[f169_local3][1], weaponID )
									if original_is_unlocked and Engine.IsItemUnlocked( Cac.GetSelectedControllerIndex(), upgradedPerk ) then
										f169_local2[f169_local3][1] = upgradedPerk
									end
								end
							end
						end
					end
                    table.insert( f169_local0, f169_local2[f169_local3] )
                end
            end
		end
	end
	if not Engine.IsDepotEnabled() then
		for f169_local1 = #f169_local0, 1, -1 do
			if Engine.Inventory_GetItemTypeByReference( f169_local0[f169_local1][1] ) ~= Cac.InventoryItemType.Default then
				table.remove( f169_local0, f169_local1 )
			end
		end
	end
	local f169_local1 = nil
	if StorageCategory == "Primary_Camo" or StorageCategory == "Secondary_Camo" then
		f169_local1 = CamoTable
	elseif StorageCategory == "Primary_Reticle" or StorageCategory == "Secondary_Reticle" then
		f169_local1 = ReticleTable
	end

	if f169_local1 ~= nil then
		local f169_local2 = Cac.GetWeaponTypeFromWeaponWithoutCategory( weaponID )

		if f169_local2 == nil then
			f169_local2 = Cac.H2MGetWeaponTypeFromWeaponWithoutCategory( weaponID )
		end

		local f169_local3 = {
			weapon_assault = 0,
			weapon_smg = 1,
			weapon_heavy = 2,
			weapon_shotgun = 3,
			weapon_sniper = 4,
			weapon_pistol = 5,			
			weapon_secondary_machine_pistol = 6,
			weapon_secondary_shotgun = 7,
			weapon_projectile = 8,
			weapon_melee = 9
		}
		local f169_local4 = f169_local3[f169_local2]
		for f169_local5 = #f169_local0, 1, -1 do
			local f169_local8 = false
			local f169_local9 = f169_local0[f169_local5][1]
			local f169_local10 = false
			for f169_local11 = 0, 9, 1 do
				local f169_local14 = Engine.TableLookup( f169_local1.File, f169_local1.Cols.Ref, f169_local9, f169_local1.Cols.ARGuid + f169_local11 )
				if f169_local14 ~= nil and f169_local14 ~= "" then
					f169_local8 = true
					if f169_local4 == f169_local11 then
						f169_local10 = true
					end
				end
			end
			if f169_local8 == true and f169_local10 == false then
				table.remove( f169_local0, f169_local5 )
			end
		end
	end

	return f169_local0
end

local organiseCamos = function ( f6_arg0 )
	local function compare(a, b)
		if a.itemID == "none" then
			return true
		else
			return (b.itemID ~= "none" and a.itemID < b.itemID)
		end
	end
	table.sort(f6_arg0, compare)
	return f6_arg0
end

function GetPrestigePrerequisite( controllerIndex, challengeRef )
	local f20_local1 = Lobby.GetPlayerPrestigeLevel( controllerIndex )
	local f20_local5 = Engine.TableLookup( AllChallengesTable.File, AllChallengesTable.Cols.Ref, challengeRef, AllChallengesTable.Cols.PrestigeUnlock )
	if f20_local5 ~= nil and f20_local5 ~= "" and f20_local1 < tonumber( f20_local5 ) then
		return Engine.Localize( "@LUA_MENU_ITEM_PRESTIGE_UNLOCK_DESC", f20_local5 )
	end
	return nil
end

LUI.CacDetails.PopulateListCamo = function ( f8_arg0, f8_arg1, f8_arg2, f8_arg3, f8_arg4, f8_arg5, f8_arg6 )
	local f8_local0 = Engine.GetDvarBool( "xblive_privatematch" )
	f8_arg0.weaponType = f8_arg2
	local f8_local1 = f8_arg0.list
	if f8_arg0.grid then
		f8_local1 = f8_arg0.grid
	end
	if not f8_arg0.tabManager then
		f8_arg0:AddListDivider()
	end
	if f8_local1.listPagerScrollIndicator ~= nil then
		f8_local1.listPagerScrollIndicator:close()
		f8_local1.listPagerScrollIndicator = nil
	end
	local f8_local2
	if f8_arg1 ~= "Primary_Camo" and f8_arg1 ~= "Secondary_Camo" and f8_arg1 ~= "Primary_Reticle" and f8_arg1 ~= "Secondary_Reticle" then
		f8_local2 = false
	else
		f8_local2 = true
	end
	local f8_local3 = f8_arg0.weaponType == "reticle"
	local f8_local4 = Cac.GetSelectedControllerIndex()
	local f8_local5 = {}
	if f8_local2 then
		local f8_local6 = LUI.MenuTemplate.ButtonStyle.border_padding
		local f8_local7 = LUI.MenuTemplate.ButtonStyle.border_padding
		local f8_local8, f8_local9, f8_local10, f8_local11 = nil
		if f8_arg0.gridMask ~= nil then
			f8_local8, f8_local9, f8_local10, f8_local11 = f8_arg0.gridMask:getLocalRect()
		else
			local f8_local12, f8_local13, f8_local14, f8_local15 = f8_arg0.list:getLocalRect()
			f8_local11 = f8_local15
			f8_local10 = f8_local14
			f8_local9 = f8_local13
			f8_local8 = f8_local12 - f8_local6
			f8_local9 = f8_local9 - f8_local7
		end
		f8_local5.iconHeight = 56
		f8_local5.height = f8_local5.iconHeight * 2
		f8_local5.width = f8_local5.height
		f8_local5.anchorType = CoD.AnchorTypes.TopLeft
		f8_local5.primaryFontHeight = f8_local5.height * 0.08
		f8_local5.primaryTextLeft = 14
		f8_local5.primaryTextRight = -10
		f8_local5.primaryTextTop = 5
		f8_local5.secondaryFontHeight = f8_local5.primaryFontHeight
		f8_local5.secondaryTextRight = -10
		f8_local5.secondaryTextTop = f8_local5.primaryTextTop + f8_local5.primaryFontHeight + 2
		f8_local5.iconCentered = true
		f8_local5.gridProps = {
			elementsPerRow = 3,
			rowHeight = f8_local5.height,
			rows = 4,
			hSpacing = f8_local6,
			vSpacing = f8_local7,
			left = f8_local8,
			top = f8_local9
		}
		f8_local5.extraElemsFuncs = {
			category = function ( f9_arg0 )
				local self = LUI.UIText.new( {
					leftAnchor = true,
					topAnchor = false,
					rightAnchor = false,
					bottomAnchor = true,
					left = f8_local5.primaryTextLeft,
					bottom = -f8_local5.primaryTextTop + 0.5,
					height = f8_local5.secondaryFontHeight,
					width = f8_local5.width,
					font = LUI.CacButton.SecondaryFont.Font,
					alpha = 0.3
				} )
				self:setText( f9_arg0.category )
				return self
			end
		}
	end
	if f8_arg0.grid then
		f8_arg0.grid:closeTree()
		f8_arg0.grid:close()
		f8_arg0.gridMask:close()
		f8_arg0.grid = nil
		f8_arg0.list:closeTree()
		f8_arg0.list:close()
		f8_arg0.list.buttonCount = 0
		f8_arg0.gridMask = nil
	else
		local f8_local6 = f8_local1:getParent()
		f8_local1.buttonCount = 0
		f8_local1:closeTree()
		f8_arg0.list:closeTree()
		f8_arg0.list:close()
		f8_arg0.list.buttonCount = 0
		f8_local6:addElement( f8_local1 )
		ListPaging.Reset( f8_local1 )
		f8_local1.pagingData = nil
	end
	run_gc()
	run_gc()
	local f8_local6 = nil
	local f8_local7 = false
	local f8_local8 = f8_arg6
	if f8_local8 ~= nil then
		if f8_local8 == "Gold" then
			f8_local6 = function ( f10_arg0 )
				if f10_arg0[1] == "none" then
					return true
				else
					local f10_local0 = LUI.InventoryUtils.GetLootGuidForRef( f8_arg1, f10_arg0[1], LUI.CacStaticLayout.ClassLoc, Cac.GetSelectedClassIndex( LUI.CacStaticLayout.ClassLoc ), f8_arg5 )
					if f10_local0 == "" then
						return true
					else
						return Cac.ItemsForProdLevel( f10_local0, f8_local8 )
					end
				end
			end
			
		else
			f8_local7 = true
			f8_local6 = function ( f11_arg0 )
				if f11_arg0[1] == "none" then
					return true
				else
					local f11_local0 = LUI.InventoryUtils.GetLootGuidForRef( f8_arg1, f11_arg0[1], LUI.CacStaticLayout.ClassLoc, Cac.GetSelectedClassIndex( LUI.CacStaticLayout.ClassLoc ), f8_arg5 )
					if f11_local0 == "" then
						return false
					else
						return Cac.ItemsForProdLevel( f11_local0, f8_local8 )
					end
				end
			end
			
		end
	elseif f8_arg2 == "furniturekit" or f8_arg2 == "reticle" or f8_arg2 == "weapon_melee" then
		f8_local7 = true
	end
	local f8_local9 = Cac.GetAllDefinedAndValidWeapons( f8_arg1, f8_arg2, LUI.CacStaticLayout.ClassLoc, nil, f8_local6, f8_local4, f8_arg0.parentWeaponID )
	local f8_local10 = {}
	for f8_local14, f8_local15 in pairs( f8_local9 ) do
		local f8_local16 = {
			itemID = f8_local15[1],
			lootData = LUI.InventoryUtils.GetLootDataForRef( f8_arg1, f8_local15[1], LUI.CacStaticLayout.ClassLoc, Cac.GetSelectedClassIndex( LUI.CacStaticLayout.ClassLoc ), f8_arg5 )
		}
		local skip_attachment = false
		if Cac.BlingPerkCheck() ~= false then
			if f8_arg1 == "Primary_FurnitureKit" then
				local primary_attachkit = Cac.GetEquippedWeapon( "Primary_AttachKit", 0, LUI.CacStaticLayout.ClassLoc, nil, false )
				if not Cac.AreAttachmentsCompatible(f8_local16.itemID, primary_attachkit) then
					skip_attachment = true
				end
			elseif f8_arg1 == "Primary_AttachKit" then
				local primary_attachkit = Cac.GetEquippedWeapon( "Primary_FurnitureKit", 0, LUI.CacStaticLayout.ClassLoc, nil, false )
				if not Cac.AreAttachmentsCompatible(f8_local16.itemID, primary_attachkit) then
					skip_attachment = true
				end
			elseif f8_arg1 == "Secondary_FurnitureKit" then
				local secondary_attachkit = Cac.GetEquippedWeapon( "Secondary_AttachKit", 0, LUI.CacStaticLayout.ClassLoc, nil, false )
				if not Cac.AreAttachmentsCompatible(f8_local16.itemID, secondary_attachkit) then
					skip_attachment = true
				end
			elseif f8_arg1 == "Secondary_AttachKit" then
				local secondary_attachkit = Cac.GetEquippedWeapon( "Secondary_FurnitureKit", 0, LUI.CacStaticLayout.ClassLoc, nil, false )
				if not Cac.AreAttachmentsCompatible(f8_local16.itemID, secondary_attachkit) then
					skip_attachment = true
				end
			end
		end

		if skip_attachment ~= true then
			if f8_local16.lootData and Engine.TableLookupGetRowNum( LootTable.File, LootTable.Cols.GUID, f8_local16.lootData.guid ) > -1 then
				f8_local16.unlocked = f8_local16.lootData.lockState == "Unlocked"
			else
				f8_local16.unlocked = Cac.IsClassItemUnlocked( f8_local4, f8_local16.itemID, f8_arg0.parentWeaponID )
			end
			f8_local10[#f8_local10 + 1] = f8_local16
		end
	end

	if f8_arg2 == "camo" then
		organiseCamos( f8_local10 )
	end

	f8_local11, f8_local12 = nil
	for f8_local16, f8_local44 in pairs( f8_local10 ) do
		local f8_local45 = f8_local44.itemID
		local f8_local27 = ""
		local f8_local29 = nil
		local f8_local18 = true
		local f8_local31 = nil
		local f8_local21 = false
		local f8_local20 = false
		local f8_local17 = ""
		local f8_local19 = nil
		local f8_local28, f8_local26, f8_local30 = false
		if f8_arg0.parentWeaponID then
			f8_local17 = f8_local17 .. f8_arg0.parentWeaponID .. " "
		end
		f8_local17 = f8_local17 .. f8_local45
		if Cac.InPermanentLockingContext() then
			if f8_local45 == "none" then
				f8_local18 = false
			elseif Cac.SelectingWeaponForAttachmentPermanentUnlock() then
				if f8_local45 ~= "h1_mp44" and f8_local45 ~= "h1_junsho" then
					f8_local18 = true
				else
					f8_local18 = false
				end
			else
				f8_local19 = Cac.GetPrestigeShopChallenge( f8_local17 )
				if f8_local19 == nil or f8_local19 == "" then
					f8_local18 = false
				else
					f8_local18 = true
				end
			end
		else
			f8_local20 = f8_arg3 == f8_local45
			if IsPublicMatch() then
				f8_local21 = LUI.InventoryUtils.GetItemNewStickerState( f8_local4, f8_local17 )
			end
		end
		
		if f8_local18 then
			local f8_local22 = Cac.GetUnlockItemRef( f8_local45, f8_arg0.parentWeaponID )
			if f8_local22 ~= nil and f8_local22 ~= "" then
				local f8_local23 = Engine.TableLookup( UnlockTable.File, UnlockTable.Cols.ItemId, f8_local22, UnlockTable.Cols.Challenge )
				if f8_local23 ~= nil and f8_local23 ~= "" then
					local f8_local24, f8_local25 = ParseChallengeName( f8_local23 )
					f8_local26 = GetChallengeData( f8_local4, f8_local24, false, f8_local25 )
					if f8_local11 ~= nil and f8_local26.NumTiers == 3 then
						f8_local26.lowerUnlockedTierRewardName = f8_local11
					end
					if f8_local26.Completed == false and f8_local26.ActiveTier == 3 then
						f8_local11 = f8_local26.RewardName
					end
					if f8_local26 and f8_local26.Name and f8_local26.Name ~= "" and not f8_local0 and not f8_local44.unlocked then
						f8_local27 = Engine.Localize( "@LUA_MENU_UNLOCK_CHALLENGE_PREFIX", f8_local26.Name )
						local prerequisite = GetPrestigePrerequisite(f8_local4, f8_local24)
						if prerequisite then
							f8_local27 = prerequisite
						elseif f8_local26.prerequisite then 
							f8_local27 = f8_local26.prerequisite
						end
					end

				elseif f8_arg2 == "perk" then
					local upgradedPerk = Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, f8_local22, PerkTable.Cols.Upgrade )
					if upgradedPerk ~= nil and upgradedPerk ~= "" then
						local f8_local23 = Engine.TableLookup( UnlockTable.File, UnlockTable.Cols.ItemId, upgradedPerk, UnlockTable.Cols.Challenge )
						if f8_local23 ~= nil and f8_local23 ~= "" then
							local f8_local24, f8_local25 = ParseChallengeName( f8_local23 )
							f8_local26 = GetChallengeData( f8_local4, f8_local24, false, f8_local25 )
							if f8_local11 ~= nil and f8_local26.NumTiers == 3 then
								f8_local26.lowerUnlockedTierRewardName = f8_local11
							end
							if f8_local26.Completed == false and f8_local26.ActiveTier == 3 then
								f8_local11 = f8_local26.RewardName
							end
							
							local upgradedPerkDesc = Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, upgradedPerk, PerkTable.Cols.Name )
							local originalDesc = f8_local26.Desc

							if upgradedPerkDesc ~= nil then
								f8_local26.Desc = "^3" .. Engine.Localize("@" .. upgradedPerkDesc) .. "\n^7" .. originalDesc
							end

							local original_is_unlocked = Cac.IsClassItemUnlocked( 0, f8_local22, f8_arg5 )
							if original_is_unlocked ~= true then
								local f8_local23 = Engine.TableLookup( UnlockTable.File, UnlockTable.Cols.ItemId, f8_local22, UnlockTable.Cols.Rank )
								f8_local27 = Engine.Localize( "@LUA_MENU_UNLOCKED_AT_RANK", f8_local23 + 1 )
							elseif f8_local26 and f8_local26.Name and f8_local26.Name ~= "" and not f8_local0 and not f8_local44.unlocked then
								f8_local27 = Engine.Localize( "@LUA_MENU_UNLOCK_CHALLENGE_PREFIX", f8_local26.Name )
								local prerequisite = GetPrestigePrerequisite(f8_local4, f8_local24)
								if prerequisite then
									f8_local27 = prerequisite
								elseif f8_local26.prerequisite then 
									f8_local27 = f8_local26.prerequisite
								end
							end
						end
					end
				elseif f8_arg2 == "weapon_melee" or f8_arg2 == "equipment_lethal" then
					local original_is_unlocked = Cac.IsClassItemUnlocked( 0, f8_local22, f8_arg5 )
					if original_is_unlocked ~= true then
						local f8_local23 = Engine.TableLookup( UnlockTable.File, UnlockTable.Cols.ItemId, f8_local22, UnlockTable.Cols.Rank )
						f8_local27 = Engine.Localize( "@LUA_MENU_UNLOCKED_AT_RANK", f8_local23 + 1 )
					elseif not f8_local0 and not f8_local44.unlocked then
						f8_local27 = Engine.Localize( "@LUA_MENU_UNLOCK_CHALLENGE_PREFIX", f8_local26.Name )
						local prerequisite = GetPrestigePrerequisite(f8_local4, f8_local24)
						if prerequisite then
							f8_local27 = prerequisite
						elseif f8_local26.prerequisite then 
							f8_local27 = f8_local26.prerequisite
						end
					end
				end
			end
			if f8_arg0.showUnlocks then
				f8_local19 = Cac.GetPrestigeShopChallenge( f8_local17 )
				if f8_local19 ~= nil and f8_local19 ~= "" then
					if Cac.IsItemPermanentlyUnlocked( f8_local4, Cac.GetPermanentUnlockItemRef( f8_local45, f8_arg0.parentWeaponID ) ) then
						f8_local28 = true
						f8_local27 = Engine.Localize( "@LUA_MENU_PERMANENTLY_UNLOCKED_CAPS" )
						f8_local29 = "h1_ui_icon_unlocked"
					elseif f8_arg0.showUnlocks and f8_arg0.numTokens > 0 then
						f8_local29 = "h1_ui_icon_unlock_token"
					end
				end
			end
			if not f8_local44.unlocked and (f8_local44.lootData == nil or f8_local44.lootData.inventoryItemType == Cac.InventoryItemType.Default) then
				local f8_local23 = Engine.TableLookup( UnlockTable.File, UnlockTable.Cols.ItemId, f8_local45, UnlockTable.Cols.Rank )
				if f8_local23 ~= nil and f8_local23 ~= "" then
					f8_local30 = Engine.Localize( "@LUA_MENU_UNLOCKED_AT_RANK", f8_local23 + 1 )
				end
			elseif not Cac.InPermanentLockingContext() and not f8_local28 then
				f8_local29 = nil
			end
			local f8_local23 = Cac.IsClassItemLockedForOverkill( f8_local4, LUI.CacStaticLayout.ClassLoc, f8_arg0.storageCategory, f8_local45 )
			local f8_local24 = Cac.IsClassItemLockedForSmoke( f8_local4, LUI.CacStaticLayout.ClassLoc, f8_arg0.storageCategory, f8_local45 )
			local f8_local25 = false
			if f8_local23.locked or f8_local24.locked then
				f8_local31 = true
				f8_local25 = true
				if f8_local23.reasonText then
					local f8_local32 = f8_local23.reasonText
				end
				f8_local27 = f8_local32 or f8_local24.reasonText
			else
				f8_local31 = not f8_local44.unlocked
			end
			local f8_local33 = LUI.CacDetails.OnButtonActionGeneral
			local f8_local34 = false
			if Cac.InPermanentLockingContext() then
				if (f8_local28 or f8_arg0.numTokens == 0) and not Cac.SelectingWeaponForAttachmentPermanentUnlock() then
					f8_local33 = nil
				else
					f8_local33 = LUI.CacDetails.OnButtonActionUnlocks
				end
			end
			local f8_local35 = nil
			f8_local5.iconLeftOffset = nil
			f8_local5.iconTopOffset = nil
			f8_local5.iconHeight = 56
			f8_local5.iconName = nil
			f8_local5.customIcon = nil
			f8_local5.actionFunc = function ( f12_arg0, f12_arg1 )
				LUI.MPDepotHelp.OnAction( f12_arg0, f12_arg1, f8_arg0, f8_local44.lootData )
			end
			
			f8_local5.primaryText = Cac.GetWeaponName( f8_arg1, f8_local45 )
			f8_local5.secondaryText = f8_local27
			f8_local5.iconName = Cac.GetWeaponImageName( f8_arg1, f8_local45 )
			f8_local5.locked = f8_local31
			f8_local5.equipped = f8_local20
			local f8_local36 = LUI.NewSticker.WithText
			if not f8_local21 then
				f8_local36 = nil
			end

			f8_local5.newMode = f8_local36
			f8_local5.secondaryImage = f8_local29
			f8_local5.extraImagePadding = f8_local2
			f8_local36 = Cac.GetUnrestrictedState( f8_arg1, f8_local45 )

			if not f8_local36 then
				if f8_local45 ~= "none" and f8_local2 ~= true then
					f8_local36 = false
				else
					f8_local36 = true
				end
			end

			f8_local5.unrestricted = f8_local36
			f8_local5.rarity = f8_local35
			f8_local5.extraElems = {}
			f8_local36 = nil

			if f8_local5.gridProps and f8_local44.lootData then
				f8_local36 = CreateExtraImage( f8_local5.iconHeight, f8_local5.iconHeight, f8_local44.lootData.image )
			end

			local f8_local37 = nil
			local f8_local38 = 0

			if not f8_local44.unlocked and f8_local44.lootData ~= nil then
				if IsContentPromoUnlocked( f8_local44.lootData.contentPromo ) then
					if Cac.IsRewardType( f8_local44.lootData.inventoryItemType ) then
						if Cac.LootDropRewardImages[f8_local44.lootData.guid] and Cac.LootDropRewardImages[f8_local44.lootData.guid].complete and Cac.LootDropRewardImages[f8_local44.lootData.guid].isOwned == true then
							f8_local5.iconName = Cac.LootDropRewardImages[f8_local44.lootData.guid].complete
						else
							f8_local5.iconName = "collection_reward_locked"
						end
						f8_local5.locked = nil
					elseif Cac.IsCraftableType( f8_local44.lootData.inventoryItemType ) then
						f8_local37 = f8_local44.lootData.price
						if f8_local5.iconCentered then
							f8_local5.iconTopOffset = -20
							f8_local38 = 15
						else
							f8_local5.iconLeftOffset = -46
							f8_local5.iconTopOffset = 16
							local f8_local39 = 1000
							while f8_local39 - 1 < f8_local37 do
								f8_local5.iconLeftOffset = f8_local5.iconLeftOffset - 8
								f8_local39 = f8_local39 * 10
							end
						end
						f8_local5.iconHeight = 28
						f8_local5.iconName = GetCurrencyImage( InventoryCurrencyType.Parts )
						f8_local5.secondaryImage = nil
						f8_local5.locked = nil
					end
				end

				if f8_local36 ~= nil then
					if f8_local3 then
						f8_local36.image:registerAnimationState( "scaledBack", {
							color = {
								r = 0.25,
								g = 0.25,
								b = 0.25
							}
						} )
						f8_local36.image:animateToState( "scaledBack" )
					else
						f8_local36:registerAnimationState( "scaledBack", {
							alpha = 0.15
						} )
						f8_local36:animateToState( "scaledBack" )
					end
				end
			end

			if f8_local5.extraElemsFuncs and f8_local44.lootData ~= nil then
				for f8_local42, f8_local43 in pairs( f8_local5.extraElemsFuncs ) do
					f8_local5.extraElems[#f8_local5.extraElems + 1] = f8_local43( {
						category = f8_local44.lootData.category
					} )
				end
			end

			f8_local5.externalElement = f8_local36
			f8_local12 = LUI.CacBase.AddCacButton( f8_arg0, f8_local5 )
			f8_local5.externalElement = nil
			
			if f8_local37 then
				LUI.MPDepotBase.AddInfoToButton( f8_arg0, f8_local12, f8_local37, true, nil, f8_local5.iconCentered and LUI.Alignment.Center or LUI.Alignment.Right, f8_local38 )
			end

			f8_local12:addEventHandler( "button_over", LUI.CacDetails.OnButtonFocus )
			f8_local12:addEventHandler( "button_over_disable", LUI.CacDetails.OnButtonFocus )
			f8_local12.itemID = f8_local45
			f8_local12.listDefaultFocus = f8_local20
			f8_local12.challengeData = f8_local26
			f8_local12.rankUnlockStr = f8_local30
			f8_local12.unlocked = f8_local44.unlocked
			f8_local12.lootData = f8_local44.lootData
			f8_local12.passThruFunc = f8_local33

			if f8_local44.lootData ~= nil and f8_local44.lootData.loot_type == ItemTypes.Reticle then
				f8_local12.reticlePreviewIconName = f8_local44.lootData.image
			elseif f8_arg2 == "reticle" then
				f8_local12.reticlePreviewIconName = RegisterMaterial( f8_local5.iconName )
			end

			if f8_local33 == nil then
				f8_local12.actionSFX = f8_local12.disabledSFX
			end

			if f8_arg0.showUnlocks == true and not f8_local25 and (f8_arg0.numTokens > 0 or Cac.InPermanentLockingContext() and Cac.SelectingWeaponForAttachmentPermanentUnlock()) then
				f8_local12.properties = {}
				f8_local12.properties.allowDisabledAction = true
				f8_local12.disabledSFX = CoD.SFX.MouseClick
				f8_local12:registerEventHandler( "button_action_disable", LUI.CacDetails.OnButtonActionUnlocks )
			end

			if Cac.InPermanentLockingContext() and f8_arg0.numTokens > 0 and not f8_local28 and not Cac.SelectingWeaponForAttachmentPermanentUnlock() then
				f8_local12:clearActionSFX()
				f8_local12.disabledSFX = nil
			end
		end
	end
	if f8_arg0.grid then
		f8_local13, f8_local14, f8_local15, f8_local16 = f8_arg0.gridMask:getLocalRect()
		ListPaging.InitGrid( f8_arg0.grid, 4, 10, false, f8_arg0, {
			enabled = f8_arg0.list:getNumChildren() > 4,
			scrollState = {
				leftAnchor = true,
				rightAnchor = false,
				topAnchor = true,
				bottomAnchor = false,
				top = f8_local16,
				left = f8_local13 + (f8_local15 - f8_local13) / 2 - LUI.UIScrollIndicator.DefaultWidth / 2 - LUI.UIScrollIndicator.GetMaxTextWidth( f8_arg0.list.buttonCount, LUI.UIScrollIndicator.DefaultFont ) / 2 + LUI.UIScrollIndicator.DefaultHeight / 2,
				width = f8_local15 - f8_local13,
				height = LUI.UIScrollIndicator.DefaultHeight
			}
		}, nil )
		if not LUI.FlowManager.IsTopMenuModal() then
			f8_arg0.grid:processEvent( {
				name = "gain_focus",
				controller = f8_arg0.controller
			} )
		end
		if not f8_arg0.tabManager then
			f8_arg0:AddListDivider( nil, f8_local13 + f8_local5.gridProps.hSpacing, f8_local14, f8_local15 - f8_local5.gridProps.hSpacing, f8_local16 )
		end
	else
		ListPaging.InitList( f8_arg0.list, 7, 10, false, false, {
			enabled = false
		}, nil )
		if not LUI.FlowManager.IsTopMenuModal() then
			f8_arg0.list:processEvent( {
				name = "gain_focus",
				controller = f8_arg0.controller
			} )
		end
		f8_arg0:CreateBottomDivider()
		f8_arg0:AddBottomDividerToList( f8_local12 )
	end
end

Cac.SetCacConfig = function ( controller, classType, f15_arg2, equipment, index, itemID, f15_arg6, f15_arg7 )
	assert( classType ~= nil, "Class location is a required parameter." )
	if f15_arg2 == nil then
		f15_arg2 = Cac.GetSelectedClassIndex( classType )
	end
	
	if Cac.IsMatchPresetClass( classType ) then
		local f15_local0 = Cac.Settings.DataLoc[classType].teamName
		if equipment ~= "inUse" and not Cac.IsClassInUse( classType, f15_arg2 ) then
			local f15_local1 = {}
			Cac.CopyClassToObj( classType, f15_arg2, f15_local1 )
			Cac.SetClassInUse( classType, f15_arg2 )
			Cac.PasteClassFromObj( classType, f15_arg2, f15_local1 )
			if Cac.IsCarrierClassSlot( f15_arg2, classType ) then
				Cac.SetCustomClassName( Cac.GetCarrierClassName( classType ), classType, f15_arg2 )
			end
		end
		if f15_arg7 ~= nil then
			return MatchRules.SetData( "defaultClasses", f15_local0, "defaultClass", f15_arg2, "class", equipment, index, itemID, f15_arg6, f15_arg7 )
		elseif f15_arg6 ~= nil then
			return MatchRules.SetData( "defaultClasses", f15_local0, "defaultClass", f15_arg2, "class", equipment, index, itemID, f15_arg6 )
		elseif itemID ~= nil then
			return MatchRules.SetData( "defaultClasses", f15_local0, "defaultClass", f15_arg2, "class", equipment, index, itemID )
		elseif index ~= nil then
			return MatchRules.SetData( "defaultClasses", f15_local0, "defaultClass", f15_arg2, "class", equipment, index )
		elseif equipment ~= nil then
			return MatchRules.SetData( "defaultClasses", f15_local0, "defaultClass", f15_arg2, "class", equipment )
		end
	elseif (classType == "customClasses" or classType == "privateMatchCustomClasses") and Cac.Settings.DataLoc[classType].baseClassSlots <= f15_arg2 then
		f15_arg2 = f15_arg2 - Cac.Settings.DataLoc[classType].baseClassSlots
		if f15_arg7 ~= nil then
			return Engine.SetPlayerDataExtendedEx( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment, index, itemID, f15_arg6, f15_arg7 )
		elseif f15_arg6 ~= nil then
			return Engine.SetPlayerDataExtendedEx( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment, index, itemID, f15_arg6 )
		elseif itemID ~= nil then
			return Engine.SetPlayerDataExtendedEx( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment, index, itemID )
		elseif index ~= nil then
			return Engine.SetPlayerDataExtendedEx( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment, index )
		elseif equipment ~= nil then
			return Engine.SetPlayerDataExtendedEx( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment )
		end
	elseif f15_arg7 ~= nil then
		return Engine.SetPlayerData( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment, index, itemID, f15_arg6, f15_arg7 )
	elseif f15_arg6 ~= nil then
		return Engine.SetPlayerData( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment, index, itemID, f15_arg6 )
	elseif itemID ~= nil then
		return Engine.SetPlayerData( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment, index, itemID )
	elseif index ~= nil then
		return Engine.SetPlayerData( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment, index )
	elseif equipment ~= nil then
		return Engine.SetPlayerData( controller, CoD.GetStatsGroupForGameMode(), classType, f15_arg2, equipment )
	end
	assert( false )
end

CacLookup = {
	Perk_Slot1 = function ( f226_arg0, f226_arg1, f226_arg2, f226_arg3, f226_arg4 )
		return Cac.GetCacConfig( f226_arg0, f226_arg1, f226_arg2, "perkSlots", f226_arg3 )
	end,
	Perk_Slot2 = function ( f227_arg0, f227_arg1, f227_arg2, f227_arg3, f227_arg4 )
		return Cac.GetCacConfig( f227_arg0, f227_arg1, f227_arg2, "perkSlots", f227_arg3 + 1 )
	end,
	Perk_Slot3 = function ( f228_arg0, f228_arg1, f228_arg2, f228_arg3, f228_arg4 )
		return Cac.GetCacConfig( f228_arg0, f228_arg1, f228_arg2, "perkSlots", f228_arg3 + 2 )
	end,
}

Cac.GetEquippedWeaponOriginal = Cac.GetEquippedWeapon
Cac.GetEquippedWeapon = function ( f231_arg0, f231_arg1, f231_arg2, f231_arg3, f231_arg4, f231_arg5 )
	
	if f231_arg0 ~= "Perk_Slot1" and  f231_arg0 ~= "Perk_Slot2" and f231_arg0 ~= "Perk_Slot3" then
		return Cac.GetEquippedWeaponOriginal (f231_arg0, f231_arg1, f231_arg2, f231_arg3, f231_arg4, f231_arg5)
	end
	
	assert( f231_arg1 ~= nil )
	if f231_arg0 == Cac.EditRemove_SelectedCategory and (f231_arg4 == nil or f231_arg4 == true) and f231_arg1 == Cac.EditRemove_SelectedIndex then
		return Cac.EditRemove_SelectedWeapon
	else
		local selectedPerk = CacLookup[f231_arg0]( Cac.GetSelectedControllerIndex(), f231_arg2, f231_arg3, f231_arg1, f231_arg5 )
		local upgradedPerk = Engine.TableLookup( PerkTable.File, PerkTable.Cols.Ref, selectedPerk, PerkTable.Cols.Upgrade )

		if upgradedPerk ~= nil and upgradedPerk ~= "" then
			local pro_perk_unlock_table = Engine.TableLookup( UnlockTable.File, UnlockTable.Cols.ItemId, upgradedPerk, UnlockTable.Cols.Challenge )
			if pro_perk_unlock_table ~= nil and pro_perk_unlock_table ~= "" then
				local f8_local24, f8_local25 = ParseChallengeName( pro_perk_unlock_table )
				local challenge_data = GetChallengeData( Cac.GetSelectedControllerIndex(), f8_local24, false, f8_local25 )
				if challenge_data.Completed == true then
					local original_is_unlocked = Cac.IsClassItemUnlocked( controller, selectedPerk, nil )
					if original_is_unlocked and Engine.IsItemUnlocked( Cac.GetSelectedControllerIndex(), upgradedPerk ) then
						selectedPerk = upgradedPerk
					end
				end
			end
		end

		return selectedPerk
	end
end

Cac.GetDescFromStatsTable = function ( f376_arg0, f376_arg1 )
	return Engine.Localize( "@" .. Engine.TableLookup( StatsTable.File, StatsTable.Cols.WeaponRef, f376_arg0, StatsTable.Cols.WeaponDesc ) )
end

--[[
Cac.NotifyVirtualLobby = function ( f437_arg0, f437_arg1 )
	if Engine.GetDvarBool( "virtualLobbyActive" ) then
		if type( f437_arg1 ) == "string" then
			if f437_arg1 == "none" then
				f437_arg1 = "_0_0_"
			end
			Engine.NotifyServerString( f437_arg0, f437_arg1 )
		else
			Engine.NotifyServer( f437_arg0, f437_arg1 )
		end
	end
	local f437_local0 = Engine.GetDvarString( "virtualLobbyModeChannel" )
	local f437_local1 = Engine.GetDvarString( "virtualLobbyModeData" )
	if f437_local0 ~= nil and f437_local0 ~= "" and f437_local0 ~= "weapon_highlighted_c" and f437_local0 ~= "costume_preview_c" and f437_local0 ~= "camo_preview_c" then
		Engine.SetDvarString( "virtualLobbyModeChannel2", "" .. f437_local0 )
		Engine.SetDvarString( "virtualLobbyModeData2", "" .. f437_local1 )
	end
	if f437_arg0 == "classpreview" or f437_arg0 == "weapon_highlighted" or f437_arg0 == "cao" or f437_arg0 == "costume_preview" or f437_arg0 == "camo_preview" or f437_arg0 == "weapon_highlighted_c" or f437_arg0 == "costume_preview_c" or f437_arg0 == "camo_preview_c" then
		Engine.SetDvarString( "virtualLobbyModeChannel", "" .. f437_arg0 )
		Engine.SetDvarString( "virtualLobbyModeData", "" .. f437_arg1 )
	end
end
--]]

LUI.CacDetails.OnButtonFocus = function ( f4_arg0, f4_arg1 )
	local f4_local0 = Cac.GetSelectedControllerIndex()
	local f4_local1 = Cac.GetWeaponName( f4_arg0.menu.storageCategory, f4_arg0.itemID )
	if f4_arg0.unlocked == true then
		f4_arg0.menu.itemModelLockOverlay:hide()
		f4_arg0.menu.itemLockReasonLabel:animateToState( "hidden" )
	else
		f4_arg0.menu.itemModelLockOverlay:show()
		if f4_arg0.lootData and IsContentPromoUnlocked( f4_arg0.lootData.contentPromo ) == false then
			f4_arg0.menu.itemLockReasonLabel:animateToState( "default" )
		else
			f4_arg0.menu.itemLockReasonLabel:animateToState( "hidden" )
		end
	end
	f4_arg0.menu.itemDescriptionWidget:Update( Engine.ToUpperCase( f4_local1 ), Cac.GetWeaponDescription( f4_arg0.menu.storageCategory, f4_arg0.itemID ), nil, f4_arg0.challengeData, f4_arg0.lootData and f4_arg0.lootData.guid or nil )

	if f4_arg0.itemID == "none" then
		f4_arg0.menu.itemDescriptionWidget:registerAnimationState( "hide", {
			alpha = 0
		} )
		f4_arg0.menu.itemDescriptionWidget:animateToState( "hide" )
	else
		f4_arg0.menu.itemDescriptionWidget:registerAnimationState( "show", {
			alpha = 1
		} )
		f4_arg0.menu.itemDescriptionWidget:animateToState( "show" )
	end
	if f4_arg0.menu.attributes ~= nil then
		local f4_local2 = ""
		if f4_arg0.menu.statsPrefix then
			f4_local2 = f4_local2 .. f4_arg0.menu.statsPrefix
		end
		f4_arg0.menu.attributes:Refresh( f4_local2 .. f4_arg0.itemID, f4_arg0.menu.attributesDelta, f4_arg0.menu.parentWeaponID )
	end
	if IsPublicMatch() then
		LUI.NewSticker.Update( f4_arg0 )
		local f4_local2 = ""
		if f4_arg0.menu.parentWeaponID then
			f4_local2 = f4_local2 .. f4_arg0.menu.parentWeaponID .. " "
		end
		LUI.InventoryUtils.SetNewStickerState( f4_local0, f4_local2 .. f4_arg0.itemID, f4_arg0.menu.storageCategory, f4_arg0.menu.parentWeaponID and f4_arg0.menu.parentWeaponID or f4_arg0.menu.weaponType, false )
		if not LUI.InventoryUtils.GetSubCategoryNewStickerState( f4_local0, f4_arg0.menu.weaponType ) and f4_arg0.menu.tabManager and f4_arg0.menu.tabManager.tabsList ~= nil and f4_arg0.menu.tabManager.tabSelected <= #f4_arg0.menu.tabManager.tabsList then
			local f4_local3 = f4_arg0.menu.tabManager.tabsList[f4_arg0.menu.tabManager.tabSelected]
			if f4_local3 and f4_local3.tabHeader then
				LUI.NewSticker.Update( f4_local3.tabHeader )
			end
		end
	end
	-- f4_arg0.menu.depotHelp:OnFocus( f4_local0, f4_arg0.lootData )
	if f4_arg0.reticlePreviewIconName and f4_arg0.menu.reticlePreviewElement then
		f4_arg0.menu.reticlePreviewElement:show()
		f4_arg0.menu.reticlePreviewElement:registerAnimationState( "update", {
			material = f4_arg0.reticlePreviewIconName
		} )
		f4_arg0.menu.reticlePreviewElement:animateToState( "update" )
	elseif f4_arg0.menu.reticlePreviewElement then
		f4_arg0.menu.reticlePreviewElement:hide()
	else
		local f4_local2 = "" .. f4_local0 .. "_"
		if f4_arg0.menu.storageCategory == "Primary" or f4_arg0.menu.storageCategory == "Secondary" then
			f4_local2 = f4_local2 .. Cac.GetVLOptionsString( f4_arg0.menu.storageCategory, f4_arg0.itemID )
		elseif f4_arg0.menu.storageCategory ~= "Melee" and f4_arg0.menu.storageCategory ~= "Perk_Slot1" and f4_arg0.menu.storageCategory ~= "Perk_Slot2" and f4_arg0.menu.storageCategory ~= "Perk_Slot3" then
			for f4_local4 = 1, #f4_arg0.menu.optionsForVL, 1 do
				-- if f4_arg0.menu.storageCategory == "Primary_AttachKit" or f4_arg0.menu.storageCategory == "Secondary_AttachKit" then
				-- 	f4_local2 = "none"
				-- else
				if f4_arg0.menu.optionsForVL[f4_local4].optionStorageCategory == f4_arg0.menu.storageCategory then
					f4_local2 = f4_local2 .. Cac.GetVLOptionsString( f4_arg0.menu.storageCategory, f4_arg0.itemID ) .. "_"
				else
					f4_local2 = f4_local2 .. Cac.GetVLOptionsString( f4_arg0.menu.optionsForVL[f4_local4].optionStorageCategory, f4_arg0.menu.optionsForVL[f4_local4].optionWeaponRef ) .. "_"
				end
			end
		else
			f4_local2 = ""
		end

		Cac.NotifyVirtualLobby( "weapon_highlighted", f4_local2 )
	end
end

LUI.CacDataProvider.GetRestricted = function ( f3_arg0, f3_arg1, f3_arg2 )
	if MatchRules.IsUsingMatchRulesData() then
		if f3_arg1 == "none" or f3_arg1 == "specialty_null" or f3_arg1 == "iw5_combatknife" then
			return false
		elseif Cac.IsMatchPresetClass( LUI.CacStaticLayout.ClassLoc ) then
			return false
		end
		local f3_local0 = f3_arg1
		local f3_local1 = f3_arg0
		if f3_arg0 == "Primary" or f3_arg0 == "Secondary" or f3_arg0 == "Melee" then
			f3_local0 = Cac.GetWeaponNameFromLootName( f3_arg1 )
			f3_local1 = Cac.GetWeaponTypeFromWeapon( f3_arg0, f3_local0 )
		end

		-- if f3_arg0 == "Primary" or f3_arg0 == "Secondary" or f3_arg0 == "Melee" then
		-- 	if string.sub(f3_local0, 1, string.len("h1_")) == "h1_" then
		-- 		return true
		-- 	end
		-- end

		if Cac.GetItemRestricted( f3_arg0, f3_local0, f3_arg1 ) then
			return true
		elseif f3_arg0 == "Primary_AttachKit" or f3_arg0 == "Primary_FurnitureKit" then
			f3_local1 = Cac.GetWeaponTypeFromWeapon( "Primary", Cac.GetEquippedWeapon( "Primary", 0, LUI.CacStaticLayout.ClassLoc ) )
		elseif f3_arg0 == "Secondary_AttachKit" or f3_arg0 == "Secondary_FurnitureKit" then
			f3_local1 = Cac.GetWeaponTypeFromWeapon( "Secondary", Cac.GetEquippedWeapon( "Secondary", 0, LUI.CacStaticLayout.ClassLoc ) )
		end
		if Cac.GetItemClassRestricted( f3_arg0, f3_local1 ) then
			return true
		end
	end
	return false
end

Cac.GetVLOptionsString = function ( f444_arg0, f444_arg1 )
	local f444_local0 = ""
	local f444_local1 = {
		Primary = StatsTable,
		Secondary = StatsTable,
		Lethal = PerkTable,
		Tactical = PerkTable,
		Perk_Slot1 = PerkTable,
		Perk_Slot2 = PerkTable,
		Perk_Slot3 = PerkTable,
		Primary_FurnitureKit = AttachKitTable,
		Secondary_FurnitureKit = AttachKitTable,
		Primary_AttachKit = AttachKitTable,
		Secondary_AttachKit = AttachKitTable,
		Primary_Camo = CamoTable,
		Secondary_Camo = CamoTable,
		Primary_Reticle = ReticleTable,
		Secondary_Reticle = ReticleTable,
		Melee = StatsTable
	}
	local f444_local2 = f444_local1[f444_arg0]
	if f444_local2 ~= nil then
		local f444_local3 = Engine.TableLookup( f444_local2.File, f444_local2.Cols.Ref, f444_arg1, 0 )
		if f444_local3 ~= nil and f444_local3 ~= "" then
			local f444_local4 = {
				Primary = 1,
				Secondary = 2,
				Lethal = 3,
				Tactical = 3,
				Perk_Slot1 = 4,
				Perk_Slot2 = 4,
				Perk_Slot3 = 4,
				Primary_FurnitureKit = 5,
				Secondary_FurnitureKit = 5,
				Primary_AttachKit = 6,
				Secondary_AttachKit = 6,
				Primary_Camo = 7,
				Secondary_Camo = 7,
				Primary_Reticle = 8,
				Secondary_Reticle = 8,
				Melee = 9
			}
			f444_local0 = tostring( f444_local4[f444_arg0] ) .. "_" .. f444_local3
		end
	else
		assert( false, "Unhandled category in Cac.GetVLOptionsValue: " .. f444_arg0 )
	end

	return f444_local0
end

LUI.ItemDescriptionWidget.RefreshCollectionWidget = function ( f6_arg0, f6_arg1 )
	f6_arg0.collectionWidget:hide()
end

Cac.IsItemPermanentlyUnlocked = function ( f28_arg0, f28_arg1 )
	local f28_local0, f28_local1, f28_local2 = Cac.GetItemPermanentLockState( f28_arg0, f28_arg1 )
	return f28_local0 == "Unlocked"
end

Cac.GetItemPermanentLockState = function ( f27_arg0, f27_arg1 )
	local f27_local0 = "Locked"
	local f27_local1 = -1
	local f27_local2 = ""
	if not f27_arg1 or Engine.Inventory_GetItemTypeByReference( f27_arg1 ) ~= Cac.InventoryItemType.Default then
		f27_local0 = "Hidden"
	end
	local f27_local3 = Cac.GetPrestigeShopChallenge( f27_arg1 )
	if f27_local3 ~= nil and f27_local3 ~= "" and Engine.CheckPlayerData( f27_arg0, CoD.StatsGroup.Ranked, "challengeProgress", f27_local3 ) then
		if Engine.GetPlayerData( f27_arg0, CoD.StatsGroup.Ranked, "challengeProgress", f27_local3 ) >= 2 or itemShouldAlwaysBeUnlocked then
			f27_local0 = "Unlocked"
		else
			f27_local0 = "Locked"
			local f27_local4 = 0
			if existsUnlockRank then
				f27_local4 = tonumber( itemUnlockRank ) + 1
			end
			f27_local2 = Engine.Localize( "LUA_MP_FRONTEND_PRESTIGE_UNLOCK", f27_local4 )
		end
	end
	return f27_local0, f27_local1, f27_local2
end

