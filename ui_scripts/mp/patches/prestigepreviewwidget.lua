LUI.PrestigePreviewWidget = InheritFrom(LUI.UIElement )
LUI.PrestigePreviewWidget.PrestigeContainerTop = 40
function lockedDisplay(menu, controller )
	local self = LUI.UIElement.new({
		leftAnchor = true,
		rightAnchor = true,
		topAnchor = true,
		bottomAnchor = true
	} )
	local f1_local1 = RegisterMaterial("h1_prestige1_preview_locked" )
	local f1_local2, f1_local3 = GetMaterialDimensions(f1_local1 )
	local f1_local4 = controller
	local f1_local5 = LUI.UIImage.new({
		leftAnchor = true,
		topAnchor = true,
		width = f1_local4 * f1_local2 / f1_local3,
		height = f1_local4,
		material = f1_local1
	} )
	local f1_local6 = RegisterMaterial("s1_icon_locked_full" )
	f1_local2, f1_local3 = GetMaterialDimensions(f1_local6 )
	f1_local4 = 30
	local f1_local7 = LUI.UIImage.new({
		topAnchor = true,
		top = 15,
		width = f1_local4 * f1_local2 / f1_local3,
		height = f1_local4,
		material = f1_local6
	} )
	self:addElement(f1_local5 )
	self:addElement(LUI.DecoFrame.new({
		topAnchor = true,
		top = 35,
		width = 400,
		height = 70
	}, LUI.DecoFrame.Grey ) )
	self:addElement(f1_local7 )
	local f1_local8 = LUI.UIText.new({
		height = 10,
		width = 300,
		color = Colors.white,
		font = CoD.TextSettings.BodyFont.Font,
		alignment = LUI.Alignment.Center
	} )
	f1_local8:setText(Engine.Localize("@LUA_MENU_UNLOCKED_AFTER_REACHING", menu.prestige + 1, Rank.GetRankDisplay(Rank.GetMaxRank(menu.prestige ) ) ) )
	self:addElement(f1_local8 )
	return self
end

function unlockedDisplay(f2_arg0, f2_arg1 )
	local f2_local0 = f2_arg0.prestige + 1
	local self = LUI.UIElement.new({
		leftAnchor = true,
		rightAnchor = true,
		topAnchor = true,
		bottomAnchor = true
	} )
	self:addElement(LUI.UIImage.new({
		leftAnchor = true,
		rightAnchor = true,
		topAnchor = true,
		bottomAnchor = true,
		material = RegisterMaterial("white" ),
		color = Colors.black,
		alpha = 0.5
	} ) )
	local f2_local2 = CoD.CreateState(0, 0, 0, 0, CoD.AnchorTypes.All )
	f2_local2.material = RegisterMaterial("h1_ui_dot_pattern" )
	local f2_local3 = LUI.UIImage.new(f2_local2 )
	f2_local3:setupTiles(6 )
	self:addElement(f2_local3 )
	local f2_local4 = RegisterMaterial("h1_combatrecord_silverplate" )
	local f2_local5, f2_local6 = GetMaterialDimensions(f2_local4 )
	local f2_local7 = f2_arg1
	local f2_local8 = LUI.UIImage.new({
		material = f2_local4,
		width = f2_local7 * f2_local5 / f2_local6,
		height = f2_local7
	} )
	local f2_local9 = LUI.UIElement.new({
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		width = 110
	} )
	local f2_local10 = LUI.UIImage.new({
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		material = f2_local4
	} )
	local f2_local11 = RegisterMaterial(Rank.GetRankIcon(f2_arg0.rank, f2_local0 ) )
	local f2_local12, f2_local13 = GetMaterialDimensions(f2_local11 )
	local f2_local14 = 75
	local f2_local15 = LUI.UIImage.new({
		material = f2_local11,
		width = f2_local14 * f2_local12 / f2_local13,
		height = f2_local14
	} )
	f2_local9:addElement(f2_local10 )
	f2_local9:addElement(f2_local15 )
	self:addElement(f2_local9 )
	local f2_local16 = LUI.DecoFrame.new(nil, LUI.DecoFrame.Grey )
	local f2_local17 = LUI.UIHorizontalList.new({
		leftAnchor = true,
		topAnchor = true,
		top = 50,
		left = 130,
		spacing = 30
	} )
	local f2_local18 = LUI.UIVerticalList.new({
		leftAnchor = true,
		topAnchor = true,
		width = 120
	} )
	local f2_local19 = LUI.UIText.new({
		leftAnchor = true,
		topAnchor = true,
		height = 25,
		color = Colors.white,
		font = CoD.TextSettings.BodyFont.Font
	} )
	local f2_local20 = LUI.UIText.new({
		leftAnchor = true,
		topAnchor = true,
		height = 15,
		color = Colors.white,
		font = CoD.TextSettings.BodyFont.Font
	} )
	f2_local19:setText(Engine.ToUpperCase(Engine.Localize("@LUA_MP_FRONTEND_PRESTIGE_NUM", f2_local0 ) ) )
	f2_local20:setText(Engine.Localize("@LUA_MENU_AVAILABLE_CAPS" ) )
	f2_local18:addElement(f2_local19 )
	f2_local18:addElement(f2_local20 )
	local f2_local21 = LUI.UIImage.new({
		leftAnchor = true,
		topAnchor = true,
		top = -7,
		width = 0.5,
		alpha = 0.5,
		height = 75,
		color = Colors.h1.light_grey,
		material = RegisterMaterial("white" )
	} )
	local f2_local22 = LUI.UIHorizontalList.new({
		leftAnchor = true,
		topAnchor = true,
		width = 100,
		spacing = 8
	} )
	local f2_local23 = RegisterMaterial("h1_ui_icon_unlock_token" )
	f2_local12, f2_local13 = GetMaterialDimensions(f2_local23 )
	f2_local14 = 55
	local f2_local24 = LUI.UIImage.new({
		leftAnchor = true,
		topAnchor = true,
		top = -5,
		width = f2_local14 * f2_local12 / f2_local13,
		height = f2_local14,
		material = f2_local23
	} )
	local f2_local25 = LUI.UIVerticalList.new({
		leftAnchor = true,
		topAnchor = true,
		width = 75
	} )
	local f2_local26 = LUI.UIText.new({
		leftAnchor = true,
		topAnchor = true,
		height = 25,
		color = Colors.white,
		font = CoD.TextSettings.BodyFont.Font
	} )
	local f2_local27 = LUI.UIText.new({
		leftAnchor = true,
		topAnchor = true,
		height = 15,
		color = Colors.white,
		font = CoD.TextSettings.BodyFont.Font
	} )
	local f2_local28 = Cac.GetPrestigeTokens(f2_arg0.controller )
	f2_local26:setText(f2_local28 )
	local f2_local29 = nil
	if f2_local28 == 1 then
		f2_local29 = Engine.Localize("@LUA_MENU_TOKEN_CAPS" )
	else
		f2_local29 = Engine.Localize("@LUA_MENU_TOKENS_CAPS" )
	end
	f2_local27:setText(f2_local29 )
	f2_local22:addElement(f2_local25 )
	f2_local17:addElement(f2_local18 )
	self:addElement(f2_local17 )
	self:addElement(f2_local16 )
	return self
end

LUI.PrestigePreviewWidget.new = function (f3_arg0 )
	local f3_local0 = Engine.GetPlayerDataMPXP(f3_arg0, CoD.StatsGroup.Ranked, "experience" )
	local f3_local1 = Lobby.GetPlayerPrestigeLevel(f3_arg0 )
	local f3_local2 = Lobby.GetRankForXP(f3_local0, f3_local1 )
	local f3_local3 = {
		xp = f3_local0,
		prestige = f3_local1,
		rank = f3_local2,
		rankDisplay = Rank.GetRankDisplay(f3_local2 ),
		controller = f3_arg0
	}
	local self = LUI.UIElement.new({
		leftAnchor = true,
		topAnchor = true,
		left = OperatorMenuUtil.LowerPreviewLeft,
		top = OperatorMenuUtil.LowerPreviewTop
	} )
	self:setClass(LUI.PrestigePreviewWidget )
	self:registerAnimationState("show", {
		alpha = 1
	} )
	self:registerAnimationState("hide", {
		alpha = 0
	} )
	self:animateToState("hide" )
	local f3_local5 = LUI.UIText.new({
		leftAnchor = true,
		topAnchor = true,
		height = 15,
		color = Colors.white,
		font = CoD.TextSettings.BodyFont.Font
	} )
	f3_local5:setText(Engine.Localize("@LUA_MENU_PRESTIGE_PROGRESS_CAPS" ) )
	self:addElement(f3_local5 )
	self:addElement(LUI.UIImage.new({
		topAnchor = true,
		top = 20,
		height = 2,
		width = 25,
		leftAnchor = true,
		material = RegisterMaterial("white" ),
		color = Colors.mw1_green
	} ) )
	local f3_local6 = LUI.UIElement.new({
		leftAnchor = true,
		topAnchor = true,
		top = OperatorMenuUtil.HeaderOffset,
		width = 490,
		height = 150
	} )
	local f3_local7 = Rank.GetRankMaxXP(f3_local2, f3_local1 )
	if f3_local3.prestige < Rank.GetMaxPrestigeLevel() then
		if tonumber(f3_local7 ) <= f3_local0 then
			f3_local6:addElement(unlockedDisplay(f3_local3, 150 ) )
		else
			f3_local6:addElement(lockedDisplay(f3_local3, 150 ) )
		end
		self:addElement(f3_local6 )
	end
	return self
end

