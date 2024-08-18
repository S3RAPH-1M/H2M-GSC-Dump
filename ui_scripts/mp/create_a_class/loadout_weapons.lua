Cac.H2MGetWeaponTypeFromWeaponWithoutCategory = function ( f163_arg0 )
	for f163_local6, f163_local7 in ipairs( Cac.Weapons.Primary ) do
		for f163_local3, f163_local4 in pairs( f163_local7 ) do
			if f163_arg0 == f163_local4[1] then
				return Cac.Weapons.Primary.Keys[f163_local6]
			end
		end
	end

	for k, v in pairs (Cac.Weapons.Secondary) do
		if type(k) == "number" then
			for f163_local3, f163_local4 in pairs( v ) do
				if f163_arg0 == f163_local4[1] then
					return Cac.Weapons.Secondary.Keys[k]
				end
			end
		end
	end
end

Cac.GetWeaponIterator = function ( weapon_type, f157_arg1, f157_arg2, f157_arg3 )
	local f157_local0 = {}
	local f157_local1 = false
	f157_local0.weaponNameArray = {}
	if weapon_type and #weapon_type > 0 then
		for index, weapon_table in pairs( weapon_type ) do
            if weapon_table == Cac.Weapons.Secondary then
                for k, weapon_list in pairs (weapon_table) do
                    if type(k) == "number" then
                        for f157_local8, f157_local9 in pairs( weapon_list ) do
                            local weapon_name = f157_local9[1]
                            if string.sub(weapon_name, 1, string.len("h1_")) ~= "h1_" then
                                local f157_local12 = f157_local9[2]
                                local f157_local13 = f157_local9[3]
                                if not f157_arg3 or f157_arg3 == weapon_name then
                                    f157_local0.weaponNameArray[#f157_local0.weaponNameArray + 1] = weapon_name
                                    if f157_local12 and f157_local12 > 0 and not f157_arg1 then
                                        for f157_local5 = 0, f157_local12 - 1, 1 do
                                            f157_local0.weaponNameArray[#f157_local0.weaponNameArray + 1] = weapon_name .. "loot" .. f157_local5
                                        end
                                    end
                                    if f157_arg2 and f157_local13 ~= nil then
                                        f157_local0.weaponNameArray[#f157_local0.weaponNameArray + 1] = f157_local13
                                    end
                                end
                            end
                        end
                    end
                end
            else
                for index, weapon_list in ipairs( weapon_table ) do
                    for f157_local8, f157_local9 in pairs( weapon_list ) do
                        local weapon_name = f157_local9[1]
                        if string.sub(weapon_name, 1, string.len("h1_")) ~= "h1_" then
                            local f157_local12 = f157_local9[2]
                            local f157_local13 = f157_local9[3]
                            if not f157_arg3 or f157_arg3 == weapon_name then
                                f157_local0.weaponNameArray[#f157_local0.weaponNameArray + 1] = weapon_name
                                if f157_local12 and f157_local12 > 0 and not f157_arg1 then
                                    for f157_local5 = 0, f157_local12 - 1, 1 do
                                        f157_local0.weaponNameArray[#f157_local0.weaponNameArray + 1] = weapon_name .. "loot" .. f157_local5
                                    end
                                end
                                if f157_arg2 and f157_local13 ~= nil then
                                    f157_local0.weaponNameArray[#f157_local0.weaponNameArray + 1] = f157_local13
                                end
                            end
                        end
                    end
                end
            end
		end
	end
	f157_local0.index = 0
	f157_local0.weaponName = nil
	if #f157_local0.weaponNameArray > 0 then
		f157_local0.index = 1
		f157_local0.weaponName = f157_local0.weaponNameArray[f157_local0.index]
	end
	f157_local0.GetWeaponName = function ( f158_arg0 )
		return f158_arg0.weaponName
	end
	
	f157_local0.Advance = function ( f159_arg0 )
		if f159_arg0.index > 0 then
			f159_arg0.index = f159_arg0.index + 1
			if #f159_arg0.weaponNameArray < f159_arg0.index then
				f159_arg0.done = true
				f159_arg0.weaponName = nil
			else
				f159_arg0.weaponName = f159_arg0.weaponNameArray[f159_arg0.index]
			end
		end
	end
	
	return f157_local0
end

local combatrecorditemlistdetails = require( "LUI.mp_menus.CombatRecordItemListDetails" )

combatrecorditemlistdetails.addTabs = function ( f10_arg0, f10_arg1 )
	local f10_local0 = {
		[1] = {
			label = "@LUA_MP_FRONTEND_CALLINGCARD_WEAPONS",
			inputTable = CombatRecord.InputTable.WeaponDetails
		},
		[2] = { 
			label = "@MENU_SCORESTREAKS_CAPS",
			inputTable = CombatRecord.InputTable.ScorestreakDetails
		},
		[3] = {
			label = "@MENU_GAME_TYPES",
			inputTable = CombatRecord.InputTable.GameModeDetails
		}
	}
	local f10_local1 = LUI.MenuBuilder.BuildRegisteredType( "MFTabManager", {
		defState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.TopLeftRight ),
		numOfTabs = #f10_local0,
		isHidden = false
	} )
	f10_local1:keepRightBumperAlignedToHeader( true )
	f10_local1.tabSelected = 1
	f10_arg0:addElement( f10_local1 )
	for f10_local2 = 1, #f10_local0, 1 do
		local f10_local5 = f10_local2
		f10_local1:addTab( f10_arg1, f10_local0[f10_local5].label, function ()
			combatrecorditemlistdetails.changeTab( f10_local0[f10_local5], f10_arg0, f10_arg1 )
		end )
	end
	return f10_local1
end

CombatRecord.InputTable.ScorestreakDetails = {
	MenuTitle = "MENU_SCORESTREAKS_CAPS",
	OverviewCategoryTable = CombatRecord.ScoreStreakStatDetailsTable,
	StatTextUpdateHandler = function ( f56_arg0, f56_arg1 )
		local f56_local0 = CombatRecord.GetScoreStreakStatsInfoString( f56_arg1.controllerIndex, f56_arg0.itemDetails, f56_arg1.itemName )
		if f56_local0 ~= nil then
			f56_arg0:setText( f56_local0 )
			return true
		else
			return false
		end
	end,
	ItemListFunction = CombatRecord.GetEarnedSortedScoreStreakData,
	ImageLookupTable = KillstreakTable,
	getImageLookupTable = function ( f57_arg0 )
		return KillstreakTable
	end,
	PanelImageHeight = 200,
	getItemListStatString = function ( f58_arg0 )
		return tostring( f58_arg0.itemEarned )
	end,
	getItemListStatTitleString = function ()
		return Engine.ToUpperCase( Engine.Localize( "LUA_MP_FRONTEND_SCORESTREAK_EARNED" ) )
	end
}

CombatRecord.GetScoreStreakStatsInfoString = function ( f23_arg0, f23_arg1, f23_arg2 )
	local f23_local0 = nil
	local f23_local1 = Engine.TableLookup( KillstreakTable.File, KillstreakTable.Cols.Ref, f23_arg2, KillstreakTable.Cols.Type )

	if f23_arg1.statConcat and f23_arg1.statsType then
		local f23_local3
		if f23_arg1.statConcat ~= "kill" or f23_local1 ~= "support" then
			f23_local3 = Engine.GetPlayerData( f23_arg0, CoD.StatsGroup.Common, "awards", f23_arg2 .. "_" .. f23_arg1.statConcat )
			if f23_local3 ~= nil then
				local f23_local4 = CombatRecord.GetCareerStatsInfoString( f23_arg1.statsType, f23_local3 )
			end
			f23_local0 = f23_local4 or nil
		end
	end
	return f23_local0
end