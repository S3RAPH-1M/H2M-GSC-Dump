local obit = luiglobals.require("LUI.mp_hud.Obituary")
obit.eventTTL = 5000
obit.font = {
	Font = CoD.TextSettings.BodyFont.Font,
	Height = 14
}

local updateMaxEvents = function()
    local maxevents = Engine.GetDvarInt("cg_maxObituaryEvents")
    obit.maxVisibleEvents = maxevents ~= nil and maxevents or obit.maxVisibleEvents
end

updateMaxEvents()

local root = LUI.roots.UIRoot0
local timer = LUI.UITimer.new(500, "update_max_events")
root:registerEventHandler("update_max_events", updateMaxEvents)
root:addElement(timer)


local function _ExtractClanTag( f1_arg0 )
	local f1_local0 = ""
	local f1_local1 = f1_arg0
	if string.sub( f1_local1, 1, 1 ) == "[" then
		local f1_local2 = string.find( f1_local1, "]" )
		if f1_local2 then
			f1_local0 = string.sub( f1_local1, 1, f1_local2 )
			f1_local1 = string.sub( f1_local1, f1_local2 + 1 )
		end
	end
	return f1_local0, f1_local1
end

local GetPlayerNameAndModifiedTag = function ( f2_arg0 )
    local original_name_and_tag = Game.GetPlayerName( f2_arg0 )
    local clantag, gamertag = _ExtractClanTag( original_name_and_tag )
    return original_name_and_tag, clantag, gamertag
end

local test_tag = function(str, width, height, og_bytes)
	local clantag = str
	local bytes = { string.byte(clantag, 1,-1) }
	local clantag_bytes = {0x5B, 0x5E, 0x01, width, height, #clantag}

	for _, byte in ipairs(bytes) do
		table.insert(clantag_bytes, byte)
	end

	table.insert(clantag_bytes, 0x5D)

	if CompareByteArrays(og_bytes, clantag_bytes) then
		return clantag
	end
end

local has_material_tag = function ( bytes )
	local h2m = test_tag( "h2", 0x40, 0x40, bytes )
	if h2m ~= nil then
		return true, 69
	end
	
	local verified = test_tag( "vr", 0x40, 0x40, bytes )
	if verified ~= nil then
		return true, 60
	end

	local sm2 = test_tag( "sm", 0x5A, 0x40, bytes )
	if sm2 ~= nil then
		return true, 56
	end

	return false, 0
end

obit.makePlayerText = function( f2_arg0, f2_arg1 )
	local f2_local0, clantag, gamertag = GetPlayerNameAndModifiedTag( f2_arg0 )
	local left, top, right, bottom = GetTextDimensions2( gamertag, obit.font.Font, obit.font.Height )
	local width = right - left
	local UIText = LUI.UIText.new( {
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = false,
		left = 0,
		width = width,
		height = obit.font.Height,
		color = obit.getColorForClientNum( f2_arg0, f2_arg1 ),
		font = obit.font.Font
	} )
	
	UIText:setText( gamertag )

	local new_color = obit.getColorForClientNum( f2_arg0, f2_arg1 )
	local tag_as_bytes = StrToBytes(clantag)
	
	left, top, right, bottom = GetTextDimensions2( clantag, obit.font.Font, obit.font.Height )
	
	local has_mat_tag, offset = has_material_tag( tag_as_bytes )
	if has_mat_tag then
		new_color = Colors.white
		right = right - offset
	end


	local clantag_width = right - left
	local UIText2 = LUI.UIText.new( {
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = false,
		left = 0,
		width = clantag_width,
		height = obit.font.Height,
		color = new_color,
		font = obit.font.Font
	} )
	UIText2:setText( clantag )

	return UIText, UIText2, width
end

obit.obituaryKillEvent = function (f7_arg0)
	local f7_local0 = 2
	local f7_local1 = f7_arg0.attacker
	if f7_local1 then
		f7_local1 = f7_arg0.attacker ~= f7_arg0.victim
	end
	local f7_local2 = Game.GetPlayerTeam()
	if MLG.IsMLGSpectator() then
		f7_local2 = Teams.allies
	end
	local f7_local3, clantagElement, f7_local4, self, f7_local6 = nil
	local f7_local7 = 0
	local HorizontalList = LUI.UIHorizontalList.new( {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		left = obit.eventPadding,
		right = 0,
		spacing = f7_local0
	} )
	HorizontalList.id = "content"
	if f7_local1 then
		f7_local3, clantagElement, f7_local6 = obit.makePlayerText( f7_arg0.attacker )
		f7_local3.id = "attackerText"
		clantagElement.id = "attackerClanText"
		f7_local7 = f7_local7 + f7_local6
	end
	assert( f7_arg0.victim )
	f7_local4, victim_ClantagElement, f7_local6 = obit.makePlayerText( f7_arg0.victim, nil )
	f7_local4.id = "victimText"
	victim_ClantagElement.id = "victimClanText"
	f7_local7 = f7_local7 + f7_local6
	assert( f7_arg0.icon )
	local f7_local9 = obit.iconHeight * Engine.GetMaterialAspectRatio( f7_arg0.icon )
	local UIImage = nil
	if f7_arg0.flip then
		UIImage = LUI.UIImage.new( {
			topAnchor = false,
			bottomAnchor = false,
			leftAnchor = true,
			rightAnchor = false,
			height = obit.iconHeight,
			left = f7_local9,
			right = 0,
			material = f7_arg0.icon
		} )
	else
		UIImage = LUI.UIImage.new( {
			topAnchor = false,
			bottomAnchor = false,
			leftAnchor = true,
			rightAnchor = false,
			height = obit.iconHeight,
			left = 0,
			width = f7_local9,
			material = f7_arg0.icon
		} )
	end
	UIImage.id = "weaponImage"
	f7_local7 = f7_local7 + f7_local9
	if f7_local1 then
		HorizontalList:addElement( clantagElement )
		HorizontalList:addElement( f7_local3 )
		HorizontalList:addElement( UIImage )
		HorizontalList:addElement( victim_ClantagElement )
		HorizontalList:addElement( f7_local4 )
		f7_local7 = f7_local7 + 2 * f7_local0
	else
		HorizontalList:addElement( victim_ClantagElement )
		HorizontalList:addElement( f7_local4 )
		HorizontalList:addElement( UIImage )
		f7_local7 = f7_local7 + f7_local0
	end
	local f7_local10 = obit.obituaryEvent( f7_local7 + 3 * obit.eventPadding )
	f7_local10:addElement( HorizontalList )
	return f7_local10
end

local close_log_event = function ( element, event )
	if element.closing then
		return 
	else
		element.closing = true
		element:animateToState( "closed", 300 )
	end
end

obit.obituaryEvent = function( f3_arg0 )
	local self = LUI.UIElement.new( {
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = false,
		height = 1,
		left = 0,
		width = f3_arg0,
		alpha = 0
	} )
	self:registerAnimationState( "opening", {
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = false,
		height = obit.eventHeight,
		left = 0,
		width = f3_arg0,
		scale = 0.05,
		alpha = 1
	} )
	self:registerAnimationState( "visible", {
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = false,
		height = obit.eventHeight,
		left = 0,
		width = f3_arg0,
		scale = 0,
		alpha = 1
	} )
	self:registerAnimationState( "closed", {
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = false,
		height = obit.eventHeight,
		left = 0,
		width = f3_arg0,
		scale = 0,
		alpha = 0
	} )
	local f3_local1 = MBh.AnimateSequence( {
		{
			"opening",
			100,
			true,
			true
		},
		{
			"visible",
			150,
			true,
			true
		}
	} )
	f3_local1( self, {} )

	self:registerEventHandler( "close_log_event", close_log_event )
	self:registerOmnvarHandler( "ui_killcam_end_milliseconds", self.close )
	self:registerEventHandler( LUI.FormatAnimStateFinishEvent( "closed" ), self.close )
	self:registerEventHandler( "new_log_event", function ( element, event )
		if element.closing then
			return 
		else
			element.timesPushed = element.timesPushed and element.timesPushed + 1 or 1
			local shouldFade = element.timesPushed >= 4
			element:registerAnimationState( "target", {
				topAnchor = false,
				bottomAnchor = false,
				leftAnchor = true,
				rightAnchor = false,
				height = obit.eventHeight,
				left = 0,
				width = f3_arg0,
				scale = 0,
				alpha = shouldFade and LUI.clamp( 1 - element.timesPushed / math.max( 1, obit.maxVisibleEvents ), 0, 1 ) or 1
			} )
			element:animateToState( "target", 300 )
		end
	end )
	f3_local1 = LUI.UITimer.new( obit.eventTTL, "close_log_event", nil, true )
	f3_local1.id = "expirationTimer"
	self:addElement( f3_local1 )
	return self
end


LUI.MenuBuilder.m_types_build["obituary"] = function()
	local f8_local0 = 0
	local self = LUI.UIElement.new( {
		topAnchor = false,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = false,
		height = 0,
		bottom = 15 - obit.maxVisibleEvents * obit.eventHeight,
		width = obit.obituaryWidth,
		left = 0
	} )
	self.id = "obituary"
	local f8_local2 = LUI.UIVerticalList.new( {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
		alignment = LUI.Alignment.Bottom
	} )
	f8_local2.id = "vlist"
	self:addElement( f8_local2 )
	local f8_local3 = function()
		local f9_local0 = 0
		local f9_local1 = f8_local2:getFirstChild()
		while f9_local1 do
			if not f9_local1.closing then
				f9_local0 = f9_local0 + 1
			end
			f9_local1 = f9_local1:getNextSibling()
		end
		return f9_local0
	end
	
	local f8_local4 = function ( f10_arg0 )
		f8_local2:processEvent( {
			name = "new_log_event"
		} )
		f10_arg0:setPriority( -f8_local0 )
		f10_arg0.id = "event_" .. f8_local0
		f8_local2:addElement( f10_arg0 )
		if f8_local3() > obit.maxVisibleEvents then
			local f10_local0 = f8_local2:getLastChild()
			f10_local0:processEvent( {
				name = "close_log_event"
			} )
		end
		f8_local0 = f8_local0 + 1
	end
	
	self:registerEventHandler( "obituary", function ( element, event )
		f8_local4( obit.obituaryKillEvent( event ) )
	end )
	self:registerEventHandler( "game_message", function ( element, event )
		if event.message and event.bold == false then
			f8_local4( obit.obituaryTextEvent( event.message ) )
		end
	end )
	return self
end
