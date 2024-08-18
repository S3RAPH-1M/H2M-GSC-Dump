local perks = luiglobals.require("LUI.mp_hud.PerksHud")

LUI.MenuBuilder.m_types_build["perksHudDef"] = function()
	local f3_local0 = 50
	local f3_local1 = 175
	local f3_local2 = 15
    local offset = -280 + HUD.GetXPBarOffset()
	local self = LUI.UIElement.new( {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true
	} )
	self.id = "perkInfo"
	for f3_local4 = 1, 3, 1 do
		local f3_local7 = LUI.UIHorizontalList.new( {
			topAnchor = false,
			bottomAnchor = true,
			leftAnchor = false,
			rightAnchor = true,
			bottom = offset + f3_local4 * f3_local0,
			left = -(f3_local0 + f3_local1 + f3_local2),
			alpha = 0,
			height = f3_local0,
			spacing = f3_local2
		} )
		f3_local7.id = "perksHList_" .. f3_local4
		local f3_local8 = LUI.UIVerticalList.new( {
			width = f3_local1,
			topAnchor = true,
			top = 12,
			spacing = 3
		} )
		f3_local8:registerAnimationState( "hidden", {
			alpha = 0
		} )
		f3_local8:registerAnimationState( "visible", {
			alpha = 1
		} )
		if not Engine.GetDvarBool( "g_oldschool" ) then
			local f3_local9 = LUI.UIText.new( {
				width = 100,
				height = 10,
				color = Colors.white,
				alignment = LUI.Alignment.Right,
				rightAnchor = true,
				font = CoD.TextSettings.BodyFontBold.Font
			} )
			f3_local9:setText( Engine.ToUpperCase( Engine.Localize( "@LUA_MENU_CAC_PERK_BLANK", tostring( f3_local4 ) ) ) )
			f3_local8:addElement( f3_local9 )
		end
		local f3_local9 = LUI.UIText.new( {
			width = f3_local1,
			height = 14,
			color = Colors.white,
			alignment = LUI.Alignment.Right,
			rightAnchor = true,
			font = CoD.TextSettings.BodyFontBold.Font
		} )
		f3_local8:addElement( f3_local9 )
		local f3_local10 = LUI.UIImage.new( {
			width = f3_local0,
			height = f3_local0,
			bottomAnchor = true
		} )
		f3_local7.imageElement = f3_local10
		f3_local7.textElement = f3_local9
		f3_local7.textHolder = f3_local8
		self["perk" .. f3_local4] = f3_local7
		f3_local7:registerAnimationState( "hidden", {
			alpha = 0
		} )
		f3_local7:registerAnimationState( "visible", {
			alpha = 1
		} )
		f3_local7:addElement( f3_local8 )
		f3_local7:addElement( f3_local10 )
		local f3_local11 = f3_local4 - 1
		local f3_local12 = LUI.UIElement.new( {} )
		f3_local12:setupUIIntWatch( "PerkSlotChanged", f3_local11 )
		f3_local12:registerEventHandler( "int_watch_alert", function ( element, event )
			perks.updateSpecificPerkInfo( f3_local7, f3_local11, event )
		end )
		f3_local7:addElement( f3_local12 )
		self:addElement( f3_local7 )
	end
	self:registerEventHandler( "playerstate_client_changed", perks.refreshAnimations )
	self:registerOmnvarHandler( "ui_class_changed_grace_period", perks.refreshAnimations )
	return self
end