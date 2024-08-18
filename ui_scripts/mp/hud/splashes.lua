local f0_local0 = Engine.UsingSplitscreenUpscaling()
local f0_local1 = 0
local f0_local2 = 1
local f0_local3 = 2
local f0_local4 = 3
local f0_local5 = 4
local f0_local6 = 5
local f0_local7 = 6
local f0_local8 = 15
local f0_local9 = 0
local f0_local10 = 100
local f0_local11 = 160
if f0_local0 then
	f0_local8 = 0
	f0_local9 = 0
	f0_local10 = 60
	f0_local11 = 60
end
local f0_local12 = 20
local f0_local13 = 9
local f0_local14 = 16 * f0_local12
local f0_local15 = 16 * f0_local13
local f0_local16 = 90
local f0_local17 = 512
local f0_local18 = 300
local f0_local19 = 200
if f0_local0 then
	f0_local19 = 240
end
function addToClipCache( f1_arg0, f1_arg1)
	table.insert( f1_arg0, 1, f1_arg1)
end

function getFromClipCache( f2_arg0)
	return table.remove( f2_arg0)
end

function HasSplashData(f3_arg0)
	local f3_local0 = Engine.TableLookupByRow( SplashTable.File, f3_arg0, SplashTable.Cols.Ref)
	if not f3_local0 or #f3_local0 == 0 then
		return false
	else
		return true
	end
end

function GetSplashData( f4_arg0, f4_arg1)
	local f4_local0 = Engine.TableLookupByRow( SplashTable.File, f4_arg0, SplashTable.Cols.Ref)
	if not f4_local0 or #f4_local0 == 0 then
		return 
	elseif not f4_arg1 or not f4_arg1 then
		f4_arg1 = Game.GetOmnvar( "ui_challenge_splash_optional_number")
	end
	return tonumber( Engine.TableLookupByRow( SplashTable.File, f4_arg0, SplashTable.Cols.Duration)) * 1000, Engine.TableLookupByRow( SplashTable.File, f4_arg0, SplashTable.Cols.Image), Engine.Localize( Engine.TableLookupByRow( SplashTable.File, f4_arg0, SplashTable.Cols.Name), f4_arg1), Engine.TableLookup( SplashTable.File, 0, f4_local0, SplashTable.Cols.Desc), f4_local0
end

function GetChallengeSplashData( f5_arg0, f5_arg1, f5_arg2 )
    local f5_local0 = Engine.TableLookup( "mp/allchallengestable.csv", 28, f5_arg0, 0 )
    if not f5_local0 or #f5_local0 == 0 then
        return 
    elseif not f5_arg1 or not f5_arg1 then
        f5_arg1 = Game.GetOmnvar( "ui_challenge_splash_tier" )
    end
    if not f5_arg2 or not f5_arg2 then
        f5_arg2 = Game.GetOmnvar( "ui_challenge_splash_optional_number" )
    end

	print ("about to get splashdata for ", f5_local0, f5_arg0, f5_arg1, f5_arg2 )
    local f5_local1 = tonumber( Engine.TableLookup( SplashTable.File, 0, f5_local0, SplashTable.Cols.Duration ) ) * 1000
        
    local f5_local2 = Engine.TableLookup( SplashTable.File, 0, f5_local0 .. "_" .. f5_arg1, SplashTable.Cols.Image )
    if not f5_local2 or f5_local2 == "" then
        f5_local2 = Engine.TableLookup( SplashTable.File, 0, f5_local0, SplashTable.Cols.Image )
    end
    
    if not f5_local2 or f5_local2 == "" then
        f5_local2 = "ui_challenge_unlocked"
    end

    local description = Engine.TableLookup( SplashTable.File, 0, f5_local0, SplashTable.Cols.Desc )

    if description ~= nil then
        description = Engine.Localize( description, f5_arg2 )
    end

    return f5_local1, f5_local2, GetChallengeNameWithTier( f5_local0, f5_arg1 ), description, f5_local0
end

function handleMedalSplash(f6_arg0, f6_arg1)
	local f6_local0 = Engine.TableLookupByRow( SplashTable.File, f6_arg1.splash, SplashTable.Cols.Sound)
	if HasSplashData(f6_arg1.splash) then
		local f6_local1, f6_local2, f6_local3, f6_local4, f6_local5 = GetSplashData( f6_arg1.splash, f6_arg1.value)
		Engine.PlaySound(f6_local0)
		OnMedalSplash( f6_arg0, f6_local1, f6_local2, f6_local3, nil, f6_local5, f6_arg1.controller, f6_arg1.count)
	else
		print( "Could not find splashIdx (" .. f6_arg1.splash .. ")")
	end
end

function handleChallengeSplash(f7_arg0, f7_arg1)
	if HasSplashData(f7_arg1.splash) then
		local f7_local0, f7_local1, f7_local2, f7_local3, f7_local4 = GetChallengeSplashData( f7_arg1.splash, f7_arg1.tier, f7_arg1.target)
		Engine.PlaySound( Engine.TableLookup( SplashTable.File, 0, f7_local4, SplashTable.Cols.Sound))
		OnMedalSplash( f7_arg0, f7_local0, f7_local1, f7_local2, f7_local3, f7_local4, f7_arg1.controller, f7_arg1.count)
	else
		print( "Could not find splashIdx (" .. f7_arg1.splash .. ")")
	end
end

function handleRankUpSplash( f8_arg0, f8_arg1)
	local f8_local0 = f8_arg1.splash
	if HasSplashData( f8_local0) then
		local f8_local1, f8_local2, f8_local3, f8_local4, f8_local5 = GetSplashData( f8_local0, f8_arg1.rank + 1)
		local f8_local6 = Engine.TableLookupByRow( SplashTable.File, f8_local0, SplashTable.Cols.Sound)
		local f8_local7 = f8_arg1.rank
		local f8_local8 = f8_arg1.prestige
		if f8_local7 and f8_local8 then
			f8_local4 = Engine.Localize( f8_local4, Rank.GetRankDisplay( f8_local7))
			f8_local2 = Rank.GetRankIcon( f8_local7, f8_local8)
			Engine.PlaySound( f8_local6)
			OnMedalSplash( f8_arg0, f8_local1, f8_local2, f8_local3, f8_local4, f8_local5, f8_arg1.controller, f8_arg1.count)
		end
	else
		print( "Could not find splashIdx (" .. f8_local0 .. ")")
	end
end

function handleKillstreakSplash(f9_arg0, f9_arg1)
	local f9_local0 = false
	if HasSplashData( f9_arg1.splash) then
		local f9_local1, f9_local2, f9_local3, f9_local4, f9_local5 = GetSplashData( f9_arg1.splash, f9_arg1.value)
		Engine.PlaySound( Engine.TableLookupByRow( SplashTable.File, f9_arg1.splash, SplashTable.Cols.Sound))
		OnKillstreakSplash( f9_arg0, f9_local1, f9_local2, f9_local3, Engine.Localize("LUA_MP_COMMON_KILLSTREAK_HOWTO", f9_local3), f9_local5, f9_arg1.controller, f9_arg1.count)
		f9_local0 = true
	else
		print( "Could not find splashIdx (" .. splashIdx .. ")")
	end
	return f9_local0
end

function processQueue( f10_arg0)
	local f10_local0 = false
	local f10_local1 = table.remove( f10_arg0.queue, 1)
	if f10_local1.type == f0_local3 then
		f10_arg0.currentType = f0_local3
		f10_local0 = handleMedalSplash( f10_arg0, f10_local1)
	elseif f10_local1.type == f0_local6 then
		f10_arg0.currentType = f0_local6
		f10_local0 = handleMedalSplash( f10_arg0, f10_local1)
	elseif f10_local1.type == f0_local4 then
		f10_arg0.currentType = f0_local4
		f10_local0 = handleChallengeSplash( f10_arg0, f10_local1)
	elseif f10_local1.type == f0_local5 then
		f10_arg0.currentType = f0_local5
		f10_local0 = handleRankUpSplash( f10_arg0, f10_local1)
	elseif f10_local1.type == f0_local2 then
		f10_arg0.currentType = f0_local2
		f10_local0 = handleKillstreakSplash( f10_arg0, f10_local1)
	end
	if f10_local0 == false then
		f10_arg0.currentType = f0_local1
	end
end

function insertToQueue(f11_arg0, f11_arg1)
	local f11_local0 = true
	local f11_local1 = #f11_arg0
	if f11_arg1.type ~= f0_local4 and f11_arg1.type ~= f0_local5 and f11_arg1.type ~= f0_local2 then
		for f11_local2 = 1, f11_local1, 1 do
			if f11_arg0[f11_local2].type == f11_arg1.type and f11_arg0[f11_local2].splash == f11_arg1.splash then
				f11_arg0[f11_local2].count = f11_arg0[f11_local2].count + 1
				f11_local0 = false
				break
			end
		end
	end
	if f11_local1 > 0 then
		Engine.PlaySound( "mp_ui_medal_bank")
	end
	if f11_local0 == true then
		if f11_arg1.type ~= f0_local2 then
			table.insert( f11_arg0, f11_arg1)
		else
			local f11_local2 = nil
			for f11_local3 = 1, f11_local1, 1 do
				if f11_arg1.type ~= f0_local2 then
					f11_local2 = f11_local3
					break
				end
			end
			if f11_local2 == nil then
				table.insert( f11_arg0, f11_arg1)
			else
				table.insert( f11_arg0, f11_local2, f11_arg1)
			end
		end
	end
end

function addKillstreakToQueue( f12_arg0, f12_arg1)
	insertToQueue( f12_arg0.queue, {
		type = f0_local2,
		splash = f12_arg1.data[1],
		value = f12_arg1.data[2],
		controller = f12_arg1.controller,
		count = 1
	})
	checkQueue( f12_arg0, f12_arg1)
end

function addMedalToQueue( f13_arg0, f13_arg1)
	insertToQueue( f13_arg0.queue, {
		type = f0_local3,
		splash = f13_arg1.data[1],
		controller = f13_arg1.controller,
		count = 1
	})
	checkQueue( f13_arg0, f13_arg1)
end

function addChallengeToQueue( f14_arg0, f14_arg1)
	insertToQueue( f14_arg0.queue, {
		type = f0_local4,
		splash = f14_arg1.data[1],
		tier = f14_arg1.data[2],
		target = f14_arg1.data[3],
		controller = f14_arg1.controller,
		count = 1
	})
	checkQueue( f14_arg0, f14_arg1)
end

function addRankUpToQueue( f15_arg0, f15_arg1)
	insertToQueue( f15_arg0.queue, {
		type = f0_local5,
		splash = f15_arg1.data[1],
		rank = f15_arg1.data[2],
		prestige = f15_arg1.data[3],
		controller = f15_arg1.controller,
		count = 1
	})
	checkQueue( f15_arg0, f15_arg1)
end

function addGenericToQueue( f16_arg0, f16_arg1)
	insertToQueue( f16_arg0.queue, {
		type = f0_local6,
		splash = f16_arg1.data[1],
		value = f16_arg1.data[2],
		controller = f16_arg1.controller,
		count = 1
	})
	checkQueue( f16_arg0, f16_arg1)
end

function checkQueue( f17_arg0, f17_arg1)
	if f17_arg0.checkQueue == true and #f17_arg0.queue > 0 and not f17_arg0.queueSwap and (f17_arg0.currentType == f0_local1 or f17_arg0.currentType == f17_arg0.queue[1].type) then
		if f17_arg0.currentType ~= f0_local1 then
			Engine.PlaySound( "mp_ui_medal_slide")
		end
		processQueue( f17_arg0)
	end
end

function OnMedalSplash( f18_arg0, f18_arg1, f18_arg2, f18_arg3, f18_arg4, f18_arg5, f18_arg6, f18_arg7)
	if not f18_arg2 or not f18_arg1 then
		return 
	end
	f18_arg0.checkQueue = false
	if not f18_arg3 then
		f18_arg3 = ""
	end
	if not f18_arg4 then
		f18_arg4 = ""
	end
	if not f18_arg7 then
		f18_arg7 = 0
	end
	local f18_local0 = getFromClipCache( f18_arg0.clipCache)
	f18_local0.medal:cancelAnimateToState()
	f18_local0.glitch:cancelAnimateToState()
	f18_local0.title:cancelAnimateToState()
	f18_local0.description:cancelAnimateToState()
	f18_local0:animateToState( "hidden")
	f18_local0.locationAnchor:animateToState( "6", 0)
	addToClipCache( f18_arg0.clipCache, f18_local0)
	local f18_local1 = 250
	for f18_local2 = 1, #f18_arg0.clipCache, 1 do
		f18_arg0.clipCache[f18_local2].locationAnchor:animateToState( tostring( f18_local2), f18_local1)
		f18_arg0.clipCache[f18_local2].glitch:registerEventHandler( "transition_step_complete_outro_8", nil)
	end
	f18_local0.medal:registerAnimationState( "correctIcon", {
		alpha = 0,
		material = RegisterMaterial( f18_arg2)
	})
	local f18_local2 = MBh.AnimateSequence( {
		{
			"correctIcon",
			0
		},
		{
			"correctIcon",
			160
		},
		{
			"visible",
			0
		},
		{
			"visible",
			f18_arg1 - 160 - f0_local15
		},
		{
			"correctIcon",
			f0_local15
		},
		{
			"default",
			0
		}
	})
	f18_local2( f18_local0.medal, {})
	f18_local2 = {}
	for f18_local3 = 0, f0_local12 - 1, 1 do
		table.insert( f18_local2, {
			"intro_" .. f18_local3,
			16
		})
	end
	table.insert( f18_local2, {
		"default",
		0
	})
	table.insert( f18_local2, {
		"default",
		f18_arg1 - f0_local14 - f0_local15
	})
	for f18_local3 = 0, f0_local13 - 1, 1 do
		table.insert( f18_local2, {
			"outro_" .. f18_local3,
			16
		})
	end
	table.insert( f18_local2, {
		"default",
		0
	})
	f18_local0.glitch:animateInSequence( f18_local2, nil, true, true)
	f18_local0.glitch:registerEventHandler( "transition_step_complete_outro_8", function ( element, event)
		f18_arg0.checkQueue = true
		f18_arg0.queueSwap = false
		f18_arg0.currentType = f0_local1
		checkQueue( f18_arg0, event)
	end)
	f18_local0.title:setText( f18_arg3)
	local f18_local4 = MBh.AnimateSequence( {
		{
			"default",
			0
		},
		{
			"visible",
			f0_local14
		},
		{
			"visible",
			f18_arg1 - f0_local14 - f0_local15
		},
		{
			"default",
			f0_local15
		},
		{
			"default",
			0
		}
	})
	f18_local4( f18_local0.title, {})
	f18_local0.description:setText( f18_arg4)
	f18_local4 = MBh.AnimateSequence( {
		{
			"default",
			0
		},
		{
			"visible",
			f0_local14
		},
		{
			"visible",
			f18_arg1 - f0_local14 - f0_local15
		},
		{
			"default",
			f0_local15
		},
		{
			"default",
			0
		}
	})
	f18_local4( f18_local0.description, {})
	if f18_arg7 > 1 then
		f18_local0.count:setText( Engine.Localize( "@MPUI_X_N", f18_arg7))
		f18_local4 = MBh.AnimateSequence( {
			{
				"default",
				0
			},
			{
				"visible",
				f0_local14
			},
			{
				"visible",
				f18_arg1 - f0_local14 - f0_local15
			},
			{
				"default",
				f0_local15
			},
			{
				"default",
				0
			}
		})
		f18_local4( f18_local0.count, {})
	end
	f18_local0:animateToState( "visible")
end

function OnKillstreakSplash( f20_arg0, killstreak_duration, killstreak_image, killstreak_text, f20_arg4, splash_index_name, f20_arg6, f20_arg7)
	if not killstreak_image or not killstreak_duration then
		return 
	end
	f20_arg0.checkQueue = false
	if not killstreak_text then
		killstreak_text = ""
	end
	if not f20_arg4 then
		f20_arg4 = ""
	end
	local f20_local0 = nil
	if f20_arg0.ks1.active == true then
		f20_arg0.ks1.active = false
		f20_local0 = f20_arg0.ks2
	else
		f20_arg0.ks1.active = true
		f20_local0 = f20_arg0.ks1
	end
	f20_local0.flare:cancelAnimateToState()
	f20_local0.medal:cancelAnimateToState()
	f20_local0.glitch:cancelAnimateToState()
	f20_local0.title:cancelAnimateToState()
	f20_local0.description:cancelAnimateToState()
	f20_local0:animateToState( "hidden")
	f20_local0.locationAnchor:animateToState( "6", 0)
	f20_local0.glitch:registerEventHandler( "transition_step_complete_outro_8", nil)
	local f20_local1 = MBh.AnimateSequence( {
		{
			"zoomin",
			0
		},
		{
			"visible",
			160
		},
		{
			"visible",
			killstreak_duration - 160 - f0_local15
		},
		{
			"zoom",
			f0_local15
		},
		{
			"default",
			0
		}
	})
	f20_local1 = MBh.AnimateSequence( {
		{
			"default",
			0
		},
		{
			"default",
			160
		},
		{
			"zoom",
			60
		},
		{
			"zoom",
			60
		},
		{
			"default",
			160
		}
	})
	f20_local1( f20_local0.flare, {})
	f20_local0.medal:registerAnimationState( "correctIcon", {
		alpha = 1,
		material = RegisterMaterial(killstreak_image),
		scale = 2
	})
	f20_local1 = MBh.AnimateSequence( {
		{
			"default",
			160
		},
		{
			"correctIcon",
			0
		},
		{
			"visible",
			160
		},
		{
			"visible",
			killstreak_duration - 160 - 160 - f0_local15
		},
		{
			"zoom",
			f0_local15
		},
		{
			"default",
			0
		}
	})
	f20_local1( f20_local0.medal, {})
	f20_local1 = {}
	for f20_local2 = 0, f0_local12 - 1, 1 do
		table.insert( f20_local1, {
			"intro_" .. f20_local2,
			16
		})
	end
	table.insert( f20_local1, {
		"default",
		0
	})
	table.insert( f20_local1, {
		"default",
		killstreak_duration - f0_local14 - f0_local15
	})
	for f20_local2 = 0, f0_local13 - 1, 1 do
		table.insert( f20_local1, {
			"outro_" .. f20_local2,
			16
		})
	end
	table.insert( f20_local1, {
		"default",
		0
	})
	f20_local0.glitch:animateInSequence( f20_local1, nil, true, true)
	f20_local0.glitch:registerEventHandler( "transition_step_complete_outro_8", function ( element, event)
		f20_arg0.checkQueue = true
		f20_arg0.queueSwap = false
		f20_arg0.currentType = f0_local1
		checkQueue( f20_arg0, event)
	end)
	f20_local0.title:setText( killstreak_text)
	local f20_local3 = MBh.AnimateSequence( {
		{
			"default",
			0
		},
		{
			"visible",
			f0_local14
		},
		{
			"visible",
			killstreak_duration - f0_local14 - f0_local15
		},
		{
			"default",
			f0_local15
		},
		{
			"default",
			0
		}
	})
	f20_local3( f20_local0.title, {})
	f20_local0.description:setText( f20_arg4)
	f20_local3 = MBh.AnimateSequence( {
		{
			"default",
			0
		},
		{
			"visible",
			f0_local14
		},
		{
			"visible",
			killstreak_duration - f0_local14 - f0_local15
		},
		{
			"default",
			f0_local15
		},
		{
			"default",
			0
		}
	})
	f20_local3( f20_local0.description, {})
	f20_local0:animateToState( "visible")
end

function UpdateSplashPlayerCard( f22_arg0, f22_arg1)
	local f22_local0 = f22_arg1.value
	if f22_local0 == -1 then
		f22_arg0:animateToState( "default", 0)
		return 
	else
		local f22_local1 = tonumber( Engine.TableLookupByRow( SplashTable.File, f22_local0, SplashTable.Cols.Duration)) * 1000
		local f22_local2 = Game.GetOmnvar( "ui_splash_playercard_optional_number")
		local f22_local3 = Game.GetOmnvar( "ui_splash_playercard_clientnum")
		if not Game.IsEntityValid( f22_local3) then
			f22_arg0:animateToState( "default", 0)
			return 
		else
			f22_arg0:processEvent( {
				name = "update_playercard_for_clientnum",
				clientNum = f22_local3
			})
			f22_arg0:setSplashCardData( Engine.Localize( Engine.TableLookupByRow( SplashTable.File, f22_local0, SplashTable.Cols.Name), f22_local2))
			f22_arg0:showSplashCard( f22_local1)
		end
	end
end

function UpdateChallengeSplash( f23_arg0, f23_arg1)
	local f23_local0 = f23_arg1.value
	if f23_local0 == -1 then
		f23_arg0:animateToState( "default", 0)
		return 
	else
		local f23_local1, f23_local2, f23_local3, f23_local4, f23_local5 = GetChallengeSplashData( f23_local0)
		OnMedalSplash( f23_arg0, f23_local1, f23_local2, f23_local3, f23_local4, f23_local5, f23_arg1.controller)
	end
end

function medalSplash( f24_arg0)
	local self = LUI.UIElement.new( {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = f0_local8,
		bottom = 0,
		left = 0,
		right = 0
	})
	self:registerAnimationState( "visible", {
		alpha = 1
	})
	self:registerAnimationState( "hidden", {
		alpha = 0
	})
	self.id = "basicSplash_" .. f24_arg0
	local f24_local1 = f0_local10 / 2
	local f24_local2 = {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = 0,
		left = -f24_local1,
		width = f0_local10,
		height = f0_local10,
		scale = 0,
		z = 0,
		alpha = 0
	}
	local f24_local3 = {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = 0,
		left = -f24_local1,
		width = f0_local10,
		height = f0_local10,
		scale = 0,
		z = 0,
		alpha = 1
	}
	local f24_local4 = {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = -10,
		left = -f24_local1 + f0_local10 + 5,
		width = f0_local10,
		height = f0_local10,
		scale = -0.3,
		z = -20,
		alpha = 1
	}
	local f24_local5 = {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = -10,
		left = -f24_local1 + (f0_local10 + 5) * 2,
		width = f0_local10,
		height = f0_local10,
		scale = -0.3,
		z = -30,
		alpha = 1
	}
	local f24_local6 = {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = -10,
		left = -f24_local1 + (f0_local10 + 5) * 3,
		width = f0_local10,
		height = f0_local10,
		scale = -0.3,
		z = -40,
		alpha = 1
	}
	local f24_local7 = {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = -20,
		left = -f24_local1 + (f0_local10 + 5) * 4,
		width = f0_local10,
		height = f0_local10,
		scale = -1,
		z = -50,
		alpha = 0
	}
	local f24_local8 = LUI.UIElement.new( f24_local2)
	f24_local8:registerAnimationState( "1", f24_local3)
	f24_local8:registerAnimationState( "2", f24_local4)
	f24_local8:registerAnimationState( "3", f24_local5)
	f24_local8:registerAnimationState( "4", f24_local6)
	f24_local8:registerAnimationState( "5", f24_local7)
	f24_local8:registerAnimationState( "6", f24_local2)
	f24_local8.id = "locationAnchor"
	self.locationAnchor = f24_local8
	self:addElement( f24_local8)
	f24_local8:animateToState( "1")
	local f24_local9 = LUI.UIImage.new( {
		material = RegisterMaterial( "white"),
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = 0,
		height = f0_local10,
		left = -f24_local1,
		width = f0_local10,
		alpha = 0
	})
	f24_local9:registerAnimationState( "visible", {
		alpha = 1
	})
	f24_local9.id = "icon"
	self.medal = f24_local9
	f24_local8:addElement( f24_local9)
	local f24_local10 = "medal_glitch_default"
	local f24_local11 = "medal_glitch_intro_"
	local f24_local12 = "medal_glitch_outro_"
	local f24_local13 = LUI.UIImage.new( {
		material = RegisterMaterial( f24_local10),
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = 0,
		height = f0_local10,
		left = -f0_local10 / 2,
		width = f0_local10
	})
	for f24_local14 = 0, f0_local12 - 1, 1 do
		f24_local13:registerAnimationState( "intro_" .. f24_local14, {
			material = RegisterMaterial( f24_local11 .. string.format( "%02d", f24_local14 + 1))
		})
	end
	for f24_local14 = 0, f0_local13 - 1, 1 do
		f24_local13:registerAnimationState( "outro_" .. f24_local14, {
			material = RegisterMaterial( f24_local12 .. string.format( "%02d", f24_local14 + 1))
		})
	end
	f24_local13.id = "glitch"
	self.glitch = f24_local13
	f24_local8:addElement( f24_local13)
	local f24_local14 = f0_local0 and 10 or 20
	local f24_local15 = LUI.UIText.new( {
		alignment = LUI.Alignment.Center,
		font = CoD.TextSettings.SP_HudCarbon27.Font,
		textStyle = CoD.TextStyle.Shadowed,
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		left = -200,
		top = f0_local10,
		right = 200,
		height = f24_local14,
		color = Colors.white,
		alpha = 0
	})
	f24_local15:registerAnimationState( "visible", {
		alpha = 1
	})
	f24_local15.id = "title"
	self.title = f24_local15
	f24_local8:addElement( f24_local15)
	local f24_local16 = LUI.UIText.new( {
		alignment = LUI.Alignment.Center,
		font = CoD.TextSettings.SP_HudCarbon27.Font,
		textStyle = CoD.TextStyle.Shadowed,
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		left = -200,
		top = f24_local14 + f0_local10,
		right = 200,
		height = f24_local14 * 0.75,
		alpha = 0
	})
	f24_local16:registerAnimationState( "visible", {
		alpha = 1
	})
	f24_local16.id = "description"
	self.description = f24_local16
	f24_local8:addElement( f24_local16)
	local f24_local17 = LUI.UIText.new( {
		alignment = LUI.Alignment.right,
		font = CoD.TextSettings.SP_HudCarbon27.Font,
		textStyle = CoD.TextStyle.Shadowed,
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		left = -200,
		top = f24_local14 + f0_local10,
		right = 200,
		height = f24_local14 * 0.75,
		alpha = 0
	})
	f24_local17:registerAnimationState( "visible", {
		alpha = 1
	})
	f24_local17.id = "count"
	self.count = f24_local17
	f24_local8:addElement( f24_local17)
	return self
end

function createKillStreakSplash( f25_arg0)
	local self = LUI.UIElement.new()
	local f25_local1 = LUI.UIElement.new( {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = f0_local9,
		bottom = 0,
		left = 0,
		right = 0
	})
	f25_local1:registerAnimationState( "visible", {
		alpha = 1
	})
	f25_local1:registerAnimationState( "hidden", {
		alpha = 0
	})
	f25_local1.id = "killStreakContainer_" .. f25_arg0
	f25_local1:animateToState( "hidden")
	local f25_local2 = f0_local11 / 2
	local f25_local3 = {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = 0,
		left = -f25_local2,
		width = f0_local11,
		height = f0_local11,
		scale = 0,
		z = 0,
		alpha = 0
	}
	local f25_local4 = {
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = 0,
		left = -f25_local2,
		width = f0_local11,
		height = f0_local11,
		scale = 0,
		z = 0,
		alpha = 1
	}
	local f25_local5 = LUI.UIElement.new( f25_local3)
	f25_local5:registerAnimationState( "1", f25_local4)
	f25_local5:registerAnimationState( "2", f25_local3)
	f25_local5.id = "locationAnchor"
	f25_local1.locationAnchor = f25_local5
	f25_local1:addElement( f25_local5)
	f25_local5:animateToState( "1")
	local f25_local7 = LUI.UIImage.new( {
		material = RegisterMaterial( "h1_hud_splash_glow"),
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		height = f25_local2,
		left = -f25_local2 / 2,
		width = f25_local2,
		alpha = 1,
		scale = -1
	})
	f25_local7:registerAnimationState( "zoom", {
		alpha = 1,
		scale = 0.6
	})
	f25_local7:registerAnimationState( "visible", {
		alpha = 1,
		scale = 0
	})
	f25_local7.id = "flare"
	f25_local1.flare = f25_local7
	f25_local5:addElement( f25_local7)
	local f25_local8 = LUI.UIImage.new( {
		material = RegisterMaterial( "white"),
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		height = f25_local2,
		left = -f25_local2 / 2,
		width = f25_local2,
		alpha = 0,
		scale = 0.4
	})
	f25_local8:registerAnimationState( "zoom", {
		alpha = 0,
		scale = 0.4
	})
	f25_local8:registerAnimationState( "visible", {
		alpha = 1,
		scale = -0.2
	})
	f25_local8.id = "icon"
	f25_local1.medal = f25_local8
	f25_local5:addElement( f25_local8)
	local f25_local9 = "medal_glitch_default"
	local f25_local10 = "medal_glitch_intro_"
	local f25_local11 = "medal_glitch_outro_"
	local f25_local12 = LUI.UIImage.new( {
		material = RegisterMaterial( f25_local9),
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = 0,
		height = f0_local11,
		left = -f25_local2,
		width = f0_local11
	})
	for f25_local13 = 0, f0_local12 - 1, 1 do
		f25_local12:registerAnimationState( "intro_" .. f25_local13, {
			material = RegisterMaterial( f25_local10 .. string.format( "%02d", f25_local13 + 1))
		})
	end
	for f25_local13 = 0, f0_local13 - 1, 1 do
		f25_local12:registerAnimationState( "outro_" .. f25_local13, {
			material = RegisterMaterial( f25_local11 .. string.format( "%02d", f25_local13 + 1))
		})
	end
	f25_local12.id = "glitch"
	f25_local1.glitch = f25_local12
	f25_local5:addElement( f25_local12)
	local f25_local13 = f0_local0 and 10 or 20
	local f25_local14 = 40
	local f25_local15 = LUI.UIText.new( {
		alignment = LUI.Alignment.Center,
		font = CoD.TextSettings.TitleFontTiny.Font,
		textStyle = CoD.TextStyle.ShadowedMore,
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		left = -200,
		top = f0_local11 - f25_local14,
		right = 200,
		height = f25_local13,
		color = Colors.white,
		alpha = 0,
		glow = LUI.GlowState.LightGreen
	})
	f25_local15:registerAnimationState( "visible", {
		alpha = 1
	})
	f25_local15.id = "title"
	f25_local1.title = f25_local15
	f25_local5:addElement( f25_local15)
	local f25_local16 = LUI.UIText.new( {
		alignment = LUI.Alignment.Center,
		font = CoD.TextSettings.TitleFontTiny.Font,
		textStyle = CoD.TextStyle.Shadowed,
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		left = -200,
		top = f25_local13 + f0_local11 - f25_local14,
		right = 200,
		height = f25_local13 * 0.75,
		alpha = 0,
		color = Colors.white
	})
	f25_local16:registerAnimationState( "visible", {
		alpha = 1
	})
	-- test_color = {
	-- 	r = 0.1,
	-- 	g = 0.1,
	-- 	b = 0.1
	-- }
	-- f25_local16:setGlow( test_color, 0.2, 1 )
	f25_local16.id = "description"
	f25_local1.description = f25_local16
	f25_local5:addElement( f25_local16)
	return f25_local1
end	

function createCardSplashElement( f26_arg0)
	local self = LUI.UIElement.new()
	self.id = f26_arg0
	if not f0_local0 then
		self:registerAnimationState( "default", {
			topAnchor = true,
			leftAnchor = true,
			bottomAnchor = false,
			rightAnchor = false,
			top = f0_local18,
			left = -f0_local19,
			height = f0_local16,
			width = f0_local19,
			alpha = 0
		})
		self:registerAnimationState( "active", {
			topAnchor = true,
			leftAnchor = true,
			bottomAnchor = false,
			rightAnchor = false,
			top = f0_local18,
			left = 5,
			height = f0_local16,
			width = f0_local19,
			alpha = 1
		})
		self:registerAnimationState( "opening", {
			topAnchor = true,
			leftAnchor = true,
			bottomAnchor = false,
			rightAnchor = false,
			top = f0_local18,
			left = 25,
			height = f0_local16,
			width = f0_local19,
			alpha = 1
		})
		self:registerAnimationState( "leave", {
			topAnchor = true,
			leftAnchor = true,
			bottomAnchor = false,
			rightAnchor = false,
			top = f0_local18,
			left = -f0_local19,
			height = f0_local16,
			width = f0_local19,
			alpha = 0
		})
	else
		self:registerAnimationState( "default", {
			topAnchor = true,
			leftAnchor = false,
			bottomAnchor = false,
			rightAnchor = true,
			top = 0,
			right = f0_local19,
			height = f0_local16,
			width = f0_local19,
			alpha = 0
		})
		self:registerAnimationState( "active", {
			topAnchor = true,
			leftAnchor = false,
			bottomAnchor = false,
			rightAnchor = true,
			top = 0,
			right = 0,
			height = f0_local16,
			width = f0_local19,
			alpha = 1
		})
		self:registerAnimationState( "opening", {
			topAnchor = true,
			leftAnchor = false,
			bottomAnchor = false,
			rightAnchor = true,
			top = 0,
			right = -20,
			height = f0_local16,
			width = f0_local19,
			alpha = 1
		})
		self:registerAnimationState( "leave", {
			topAnchor = true,
			leftAnchor = false,
			bottomAnchor = false,
			rightAnchor = true,
			top = 0,
			right = f0_local19,
			height = f0_local16,
			width = f0_local19,
			alpha = 0
		})
	end
	self:animateToState( "default", 0)
	local f26_local1 = LUI.MenuBuilder.BuildRegisteredType( "playercard")
	local f26_local2 = f26_local1
	local f26_local3 = LUI.Playercard.Width
	local f26_local4 = LUI.Playercard.Height
	local f26_local5 = f0_local19 / f26_local3 / f26_local4
	local f26_local6 = LUI.UIElement.new( {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		top = 0,
		scale = f26_local5 / f26_local4 - 1,
		alpha = 1
	})
	f26_local1.id = "player_card_class_item_id"
	local f26_local7 = f26_local5 + 4
	local f26_local8 = 20
	local f26_local9 = LUI.UIText.new()
	f26_local9.id = "cardSplashDescId"
	f26_local9:setText( "")
	f26_local9:setTextStyle( CoD.TextStyle.Shadowed)
	f26_local9:registerAnimationState( "default", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		top = f26_local7,
		left = 0,
		height = 0,
		width = f0_local17,
		font = CoD.TextSettings.SP_HudCarbon27.Font,
		alignment = LUI.Alignment.Left
	})
	f26_local9:animateToState( "default", 0)
	f26_local9:registerAnimationState( "active", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		top = f26_local7,
		left = 8,
		height = f26_local8,
		width = f0_local17,
		red = 1,
		green = 1,
		blue = 1
	})
	f26_local9:registerAnimationState( "friendly", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		top = f26_local7,
		left = 8,
		height = f26_local8,
		width = f0_local17,
		color = Colors.h1.ally_blue
	})
	f26_local9:registerAnimationState( "enemy", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = false,
		rightAnchor = false,
		top = f26_local7,
		left = 8,
		height = f26_local8,
		width = f0_local17,
		color = Colors.h1.enemy_red
	})
	f26_local6:addElement( f26_local1)
	self:addElement( f26_local6)
	self:addElement( f26_local9)
	self.setSplashCardData = function ( f27_arg0, f27_arg1)
		local f27_local0 = f27_arg0:getChildById( "cardSplashDescId")
		f27_local0:setText( f27_arg1)
		f27_local0:animateToState( "active", 0)
	end
	
	self.showSplashCard = function ( f28_arg0, f28_arg1)
		local f28_local0 = MBh.AnimateSequence( {
			{
				"default",
				0
			},
			{
				"opening",
				150
			},
			{
				"active",
				150
			},
			{
				"active",
				f28_arg1
			},
			{
				"leave",
				150
			}
		})
		f28_local0( f28_arg0)
	end
	
	return self
end

function splashesFanoutHudDef( f29_arg0)
	local f29_local0 = RegisterMaterial( "white")
	local f29_local1 = RegisterMaterial( "hud_message_bg")
	local f29_local2 = RegisterMaterial( "popup_backing")
	local self = LUI.UIElement.new()
	self.id = "splashesHud"
	self:registerAnimationState( "default", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = true,
		rightAnchor = true,
		top = 0,
		left = 0,
		bottom = 0,
		right = 0
	})
	self:animateToState( "default", 0)
	self.ourQueue = {}
	self.othersQueue = {}
	self.currentType = f0_local1
	self.clipCache = {}
	self.checkQueue = true
	self.queueSwap = false
	self.queue = self.ourQueue
	local f29_local4 = function ( f30_arg0, f30_arg1)
		if self.currentType ~= f0_local4 and self.currentType ~= f0_local5 and not self.queueSwap then
			self.checkQueue = true
			checkQueue( self, f30_arg1)
		end
	end

	-- local f29_local8 = medalSplash(1)
    -- f29_local8:registerOmnvarHandler( "ui_challenge_splash_idx", function ( f31_arg0, f31_arg1)
    --     UpdateChallengeSplash( self, f31_arg1)
    -- end)
    -- f29_local8:registerEventHandler( "splashes_hud_challenge_request", function ( element, event)
    --     UpdateChallengeSplash( self, event)
    -- end)
    -- f29_local8.locationAnchor:registerEventHandler( "transition_complete_1", f29_local4)
    -- self:addElement( f29_local8)
    -- f29_local8:animateToState( "hidden")
    -- addToClipCache( self.clipCache, f29_local8)

	for f29_local5 = 1, f0_local7, 1 do
		local f29_local8 = medalSplash( f29_local5 )
		f29_local8:registerOmnvarHandler( "ui_challenge_splash_idx", function ( f31_arg0, f31_arg1 )
			UpdateChallengeSplash( self, f31_arg1 )
		end )
		f29_local8:registerEventHandler( "splashes_hud_challenge_request", function ( element, event )
			UpdateChallengeSplash( self, event )
		end )
		f29_local8.locationAnchor:registerEventHandler( "transition_complete_1", f29_local4 )
		self:addElement( f29_local8 )
		f29_local8:animateToState( "hidden" )
		addToClipCache( self.clipCache, f29_local8 )
	end

	self.ks1 = createKillStreakSplash( 1)
	self.ks2 = createKillStreakSplash( 2)
	self.ks1.active = false
	self.ks2.active = false
	self:addElement( self.ks1)
	self:addElement( self.ks2)
	self:registerEventHandler( "killstreak_splash", addKillstreakToQueue)
	self:registerEventHandler( "challenge_splash", addChallengeToQueue)
	self:registerEventHandler( "rankup_splash", addRankUpToQueue)
	self:registerEventHandler( "generic_splash", addGenericToQueue)
	self:registerEventHandler( "generic_splash_number", addGenericToQueue)
	self:registerEventHandler( "clear_notification_queue", function ( element, event)
		self.queue = {}
	end)
	local f29_local6 = Engine.GetLuiRoot()
	local f29_local7 = f29_local6.m_controllerIndex
	if Engine.WantsDisplayMedalSplashes( f29_local7) == true then
		self:registerEventHandler( "medal_splash", addMedalToQueue)
		self.wantsMedals = true
	else
		self.wantsMedals = false
	end
	self:registerEventHandler( "button_config_updated", function ( element, event)
		local f34_local0 = Engine.WantsDisplayMedalSplashes( f29_local7)
		if element.wantsMedals ~= f34_local0 then
			element.wantsMedals = f34_local0
			if element.wantsMedals == true then
				self:registerEventHandler( "medal_splash", addMedalToQueue)
			else
				self:registerEventHandler( "medal_splash", nil)
			end
		end
	end)
	self:registerEventHandler( "playerstate_client_changed", function ( element, event)
		if not Game.InKillCam() and Game.GetPlayerClientnum() ~= Game.GetPlayerstateClientnum() then
			self.othersQueue = {}
			self.queueSwap = not self.checkQueue
			self.queue = self.othersQueue
		else
			self.othersQueue = {}
			if self.queue ~= self.ourQueue then
				local f35_local0 = nil
				f35_local0 = self.clipCache[1]
				f35_local0.medal:cancelAnimateToState()
				f35_local0.glitch:cancelAnimateToState()
				f35_local0.title:cancelAnimateToState()
				f35_local0.description:cancelAnimateToState()
				f35_local0:animateToState( "hidden")
				f35_local0.locationAnchor:animateToState( "6", 0)
				if self.ks1.active == true then
					f35_local0 = self.ks1
				else
					f35_local0 = self.ks2
				end
				f35_local0.flare:cancelAnimateToState()
				f35_local0.medal:cancelAnimateToState()
				f35_local0.glitch:cancelAnimateToState()
				f35_local0.title:cancelAnimateToState()
				f35_local0.description:cancelAnimateToState()
				f35_local0:animateToState( "hidden")
				f35_local0.locationAnchor:animateToState( "6", 0)
				f35_local0.glitch:registerEventHandler( "transition_step_complete_outro_8", nil)
				self.checkQueue = true
				self.queueSwap = not self.checkQueue
				self.queue = self.ourQueue
				self.currentType = f0_local1
				checkQueue( self, event)
			end
		end
	end)
	self:registerOmnvarHandler( "ui_splash_idx", function ( f36_arg0, f36_arg1)
		local f36_local0 = f36_arg1.value
		if HasSplashData( f36_local0) then
			local f36_local1, f36_local2, f36_local3, f36_local4, f36_local5 = GetSplashData( f36_local0)
			OnMedalSplash( f36_arg0, f36_local1, f36_local2, f36_local3, nil, f36_local5, f36_arg1.controller)
		else
			DebugPrint( "Could not find splashIdx (" .. f36_local0 .. ")")
		end
	end)
	self:registerOmnvarHandler( "ui_rankup_splash_idx", function ( f37_arg0, f37_arg1)
		if f37_arg1.value then
			local f37_local0 = f37_arg1.value
			if HasSplashData( f37_local0) then
				local f37_local1, f37_local2, f37_local3, f37_local4, f37_local5 = GetSplashData( f37_local0)
				local f37_local6 = Game.GetOmnvar( "ui_rank_splash_rank")
				local f37_local7 = Game.GetOmnvar( "ui_rank_splash_prestige")
				if f37_local6 and f37_local7 then
					OnMedalSplash( f37_arg0, f37_local1, Rank.GetRankIcon( f37_local6, f37_local7), f37_local3, Engine.Localize( f37_local4, f37_local6 + 1), f37_local5, f37_arg1.controller)
				end
			else
				DebugPrint( "Could not find splashIdx (" .. f37_local0 .. ")")
			end
		end
	end)
	self:registerEventHandler( "splashes_hud_medal_request", function ( element, event)
		if event.splashRef then
			local f38_local0 = Engine.TableLookupGetRowNum( SplashTable.File, SplashTable.Cols.Ref, event.splashRef)
			local f38_local1 = Engine.TableLookupByRow( SplashTable.File, f38_local0, SplashTable.Cols.Sound)
			if HasSplashData( f38_local0) then
				local f38_local2, f38_local3, f38_local4, f38_local5, f38_local6 = GetSplashData( f38_local0)
				local f38_local7 = event.rank
				local f38_local8 = event.prestige
				if f38_local7 and f38_local8 then
					f38_local3 = Rank.GetRankIcon( f38_local7, f38_local8)
					Engine.PlaySound( f38_local1)
				end
				OnMedalSplash( element, f38_local2, f38_local3, f38_local4, nil, f38_local6, event.controller)
			else
				DebugPrint( "Could not find splashIdx (" .. f38_local0 .. ")")
			end
		end
	end)
	return self
end

LUI.MenuBuilder.m_types_build["splashesFanoutHudDef"] = splashesFanoutHudDef