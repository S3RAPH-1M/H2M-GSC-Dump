local f0_local0 = CoD.DesignGridHelper(18, 1 )
local f0_local1 = tonumber(Engine.TableLookup(RankIconTable.File, 0, "maxPrestige", 1 ) )
local f0_local2 = 140
local f0_local3 = 15
local f0_local4 = 4
local f0_local5 = f0_local2 * 1.75
local f0_local6 = (f0_local0 - f0_local3 * (f0_local4 - 1)) / f0_local4
local f0_local7 = -f0_local6 - f0_local3
local f0_local8 = 150
local f0_local9 = 1
local f0_local10 = Colors.h1.light_green
local f0_local11 = 20
local f0_local12 = 1
local f0_local13 = 2
local f0_local15 = "@LUA_MENU_PRESTIGE"
local f0_local16 = 1
local f0_local17 = 2
local f0_local18 = {
	{
		contentTopGap = 12,
		left = 0,
		top = 88,
		textKey = "@LUA_MENU_PRESTIGE_PROGRESS_CAPS",
		font = CoD.TextSettings.Font21,
		color = Colors.h1.light_grey,
		dividerTopGap = 3,
		useUpper = true
	},
	{
		contentTopGap = 15,
		left = CoD.DesignGridHelper(20, 0 ),
		top = 118,
		textKey = "@LUA_MENU_PRESTIGE",
		font = CoD.TextSettings.Font46,
		color = Colors.white,
		dividerTopGap = 3,
		dividerLeft = 1
	}
}
function OnPrestigeButtonListInput(f1_arg0, f1_arg1 )
	local f1_local0 = false
	if f1_arg0:isInFocus() and f1_arg1.down == true then
		if f1_arg1.button == "left" and (f1_arg0.hList.currIndex ~= 1 or not f1_arg0.wasPrevEventDown) then
			UpdateShiftListPosition(f1_arg0.hList, {
				nextIndex = f1_arg0.hList.currIndex - 1
			} )
			f1_local0 = true
		elseif f1_arg1.button == "right" and (f1_arg0.hList.currIndex ~= f0_local1 or not f1_arg0.wasPrevEventDown) then
			UpdateShiftListPosition(f1_arg0.hList, {
				nextIndex = f1_arg0.hList.currIndex + 1
			} )
			f1_local0 = true
		elseif f1_arg1.button == "primary" then
			if not f1_arg0.hList.list[f1_arg0.hList.currIndex].isDisabled then
				PrestigeButtonAction(f1_arg0, f1_arg1, {
					currIndex = f1_arg0.hList.currIndex
				} )
			else
				Engine.PlaySound(CoD.SFX.Error )
			end
		end
		f1_arg0.pagination.text:setText(f1_arg0.hList.currIndex .. " / " .. f0_local1 )
	end
	f1_arg0.wasPrevEventDown = f1_arg1.down
	if f1_local0 then
		Engine.PlaySound(CoD.SFX.MenuScroll )
	end
end

function CanHandleMouseInput(f3_arg0 )
	local f3_local0 = f3_arg0.parent.prestigeButtonList:isInFocus()
	return f3_local0
end

function HighlightButton(f4_arg0 )
	f4_arg0:animateToState("highlight" )
	Engine.PlaySound(CoD.SFX.MenuScroll )
end

function PrestigeButtonAction(f5_arg0, f5_arg1, f5_arg2 )
	f5_arg0:setFocus(false )
	Engine.PlaySound(CoD.SFX.MenuAccept )
	LUI.FlowManager.RequestAddMenu(f5_arg0, "PrestigePopup", true, f5_arg1.controller, false, {
		parent = f5_arg0,
		prestigeIdx = f5_arg2.currIndex
	} )
end

function AnimateShiftListLeft(f7_arg0, f7_arg1 )
	f7_arg0.currStrideAmount = f7_arg1.strideAmount
	f7_arg0:registerAnimationState("default", {
		left = f0_local7 * f7_arg1.strideAmount,
		leftAnchor = true,
		width = f0_local0,
		height = f0_local5,
		spacing = f0_local3
	} )
	f7_arg0:animateToState("default", f7_arg1.instantAnimate and 0 or f0_local8 )
end

function ChangeFocusedListButton(f8_arg0 )
	AnimateButton({
		button = f8_arg0.hList.list[f8_arg0.hList.currIndex].root,
		animState = "unfocused"
	} )
	f8_arg0.hList.currIndex = f8_arg0.overrideOffset and f8_arg0.overrideOffset or f8_arg0.hList.currIndex + f8_arg0.indexOffset
	AnimateButton({
		button = f8_arg0.hList.list[f8_arg0.hList.currIndex].root,
		animState = "focused"
	} )
end

function UpdateShiftListPosition(f9_arg0, f9_arg1 )
	if f9_arg1.nextIndex < 1 then
		ChangeFocusedListButton({
			hList = f9_arg0,
			overrideOffset = f0_local1
		} )
		AnimateShiftListLeft(f9_arg0, {
			strideAmount = f0_local1 - f0_local4
		} )
		f9_arg0.currMaxRangeIndex = f0_local1
		f9_arg0.currMinRangeIndex = f0_local1 - f0_local4 - 1
	elseif f0_local1 < f9_arg1.nextIndex then
		ChangeFocusedListButton({
			hList = f9_arg0,
			overrideOffset = 1
		} )
		AnimateShiftListLeft(f9_arg0, {
			strideAmount = 0
		} )
		f9_arg0.currMaxRangeIndex = f0_local4 - 1
		f9_arg0.currMinRangeIndex = 0
	elseif f9_arg1.nextIndex < f9_arg0.currMinRangeIndex then
		ChangeFocusedListButton({
			hList = f9_arg0,
			indexOffset = -1
		} )
		AnimateShiftListLeft(f9_arg0, {
			strideAmount = f9_arg0.currStrideAmount - 1
		} )
		f9_arg0.currMaxRangeIndex = f9_arg0.currMaxRangeIndex - 1
		f9_arg0.currMinRangeIndex = f9_arg0.currMinRangeIndex - 1
	elseif f9_arg0.currMaxRangeIndex < f9_arg1.nextIndex then
		ChangeFocusedListButton({
			hList = f9_arg0,
			indexOffset = 1
		} )
		AnimateShiftListLeft(f9_arg0, {
			strideAmount = f9_arg0.currIndex - f0_local4
		} )
		f9_arg0.currMaxRangeIndex = f9_arg0.currMaxRangeIndex + 1
		f9_arg0.currMinRangeIndex = f9_arg0.currMinRangeIndex + 1
	else
		ChangeFocusedListButton({
			hList = f9_arg0,
			overrideOffset = f9_arg1.nextIndex
		} )
	end
end

function AnimateButton(f10_arg0 )
	f10_arg0.button.focusedBorder:animateToState(f10_arg0.animState )
	f10_arg0.button:animateToState(f10_arg0.animState, f0_local8 / 2 )
end

function AddDivider(f12_arg0, f12_arg1 )
	local f12_local0 = CoD.CreateState
	local self = f12_arg1.left
	local f12_local2 = f12_arg1.top
	local f12_local3, f12_local4 = nil
	local f12_local5 = f12_arg1.anchorType
	if not f12_local5 then
		f12_local5 = CoD.AnchorTypes.TopLeft
	end
	f12_local0 = f12_local0(self, f12_local2, f12_local3, f12_local4, f12_local5 )
	f12_local0.material = RegisterMaterial("white" )
	self = f12_arg1.color
	if not self then
		self = Colors.h1.light_grey
	end
	f12_local0.color = self
	f12_local0.width = f12_arg1.width
	f12_local0.height = f12_arg1.height
	self = LUI.UIImage.new(f12_local0 )
	self.defState = f12_local0
	f12_arg0:addElement(self )
	return width, self
end

function AddTitle(f13_arg0, f13_arg1 )
	local f13_local0 = Engine.Localize(f13_arg1.textKey )
	if f13_arg1.useUpper then
		f13_local0 = Engine.ToUpperCase(f13_local0 ) or f13_local0
	end
	local f13_local1, f13_local2, f13_local3, f13_local4 = GetTextDimensions(f13_local0, f13_arg1.font.Font, f13_arg1.font.Height )
	local f13_local5 = CoD.CreateState(f13_arg1.left, f13_arg1.top, nil, nil, CoD.AnchorTypes.TopLeft )
	f13_local5.font = f13_arg1.font.Font
	f13_local5.color = f13_arg1.color
	f13_local5.width = f13_local3 - f13_local1
	f13_local5.height = f13_arg1.font.Height
	local self = LUI.UIText.new(f13_local5 )
	if f13_arg1.textKey == f0_local15 then
		local f13_local7 = self
	end
	f13_arg0.prestigeTitle = f13_local7 or nil
	self:setText(f13_local0 )
	f13_arg0:addElement(self )
	local f13_local8 = {
		left = f13_arg1.dividerLeft,
		top = f13_arg1.dividerTopGap + f13_arg1.font.Height,
		width = f0_local11,
		height = f0_local9,
		color = f0_local10
	}
	AddDivider(self, f13_local8 )
	return f13_local8.height + f13_local8.top + f13_arg1.top, title
end

function AddPrestigeDesc(f14_arg0, f14_arg1 )
	local f14_local0 = Engine.Localize(f14_arg1.textKey )
	local f14_local1, f14_local2, f14_local3, f14_local4 = GetTextDimensions(f14_local0, f14_arg1.font.Font, f14_arg1.font.Height )
	local f14_local5 = CoD.CreateState(f14_arg1.left, f14_arg1.top, nil, nil, CoD.AnchorTypes.TopLeft )
	f14_local5.font = f14_arg1.font.Font
	f14_local5.color = f14_arg1.color
	f14_local5.alignment = LUI.AdjustAlignmentForLanguage(LUI.Alignment.Left )
	f14_local5.width = 255
	f14_local5.lineSpacingRatio = 0.3
	f14_local5.height = f14_arg1.font.Height
	local self = LUI.UIText.new(f14_local5 )
	f14_arg0.prestigeDesc = self
	self:setText(f14_local0 )
	f14_arg0:addElement(self )
end

function BuildPrestigeButton(f24_arg0 )
	local f24_local0 = 0
	local f24_local1 = 0.09
	local f24_local2 = CoD.CreateState(f24_arg0.left, f24_arg0.top, nil, nil, CoD.AnchorTypes.TopLeft )
	f24_local2.width = f0_local6
	f24_local2.height = f0_local5
	local self = LUI.UIElement.new(f24_local2 )
	local f24_local4 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.Left )
	f24_local4.width = f0_local6
	f24_local4.height = f0_local5
	f24_local4.scale = 0
	local f24_local5 = LUI.UIElement.new(f24_local4 )
	f24_local5:registerAnimationState("unfocused", f24_local4 )
	f24_local5:registerAnimationState("focused", {
		scale = f24_local1
	} )
	self.root = f24_local5
	self:addElement(f24_local5 )
	local f24_local6 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.All )
	f24_local6.material = RegisterMaterial("h1_prestige_card_background" )
	f24_local5:addElement(LUI.UIImage.new(f24_local6 ) )
	local f24_local7 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.All )
	f24_local7.material = RegisterMaterial("h1_ui_dot_pattern" )
	f24_local7.alpha = 0.7
	local f24_local8 = LUI.UIImage.new(f24_local7 )
	f24_local8:setupTiles(5 )
	f24_local5:addElement(f24_local8 )
	f24_local0 = f24_local0 + 30
	local f24_local9 = 84
	local f24_local10 = CoD.CreateState(nil, f24_local0, nil, nil, CoD.AnchorTypes.Top )
	f24_local10.width = f24_local9
	f24_local10.height = f24_local9
	f24_local10.alpha = f24_arg0.isLocked and 0.2 or 1
	f24_local10.material = RegisterMaterial(f24_arg0.materialName )
	f24_local5:addElement(LUI.UIImage.new(f24_local10 ) )
	if f24_arg0.isLocked then
		local f24_local11 = 22
		local f24_local12 = 11
		local f24_local13 = CoD.TextSettings.Font30
		local f24_local14 = CoD.CreateState(nil, 70, nil, nil, CoD.AnchorTypes.Top )
		f24_local14.width = f24_local4.width
		f24_local14.height = f24_local4.height * 0.45
		local f24_local15 = LUI.UIElement.new(f24_local14 )
		f24_local5.lockedRoot = f24_local15
		f24_local5:addElement(f24_local15 )
		local f24_local16 = 5
		local f24_local17 = CoD.CreateState(-f24_local16, nil, f24_local16, nil, CoD.AnchorTypes.All )
		f24_local17.material = RegisterMaterial("h1_prestige_card_locked" )
		f24_local15:addElement(LUI.UIImage.new(f24_local17 ) )
		local f24_local18 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.None )
		f24_local18.width = f24_local4.width
		f24_local18.height = f24_local11 + f24_local12 + f24_local13.Height
		local f24_local19 = LUI.UIElement.new(f24_local18 )
		f24_local15:addElement(f24_local19 )
		local f24_local20 = 0
		local f24_local21 = CoD.CreateState(nil, f24_local20, nil, nil, CoD.AnchorTypes.Top )
		f24_local21.width = f24_local11
		f24_local21.height = f24_local11
		f24_local21.material = RegisterMaterial("icon_lock_mini" )
		f24_local19:addElement(LUI.UIImage.new(f24_local21 ) )
		local f24_local22 = Engine.ToUpperCase(Engine.Localize("@LUA_MENU_PRESTIGE" ) ) .. " " .. f24_arg0.index
		local f24_local23, f24_local24, f24_local25, f24_local26 = GetTextDimensions(f24_local22, f24_local13.Font, f24_local13.Height )
		local f24_local27 = CoD.CreateState(nil, f24_local20 + f24_local21.height + f24_local12, nil, nil, CoD.AnchorTypes.Top )
		f24_local27.font = f24_local13.Font
		f24_local27.color = Colors.h1.light_grey
		f24_local27.alignment = LUI.Alignment.Center
		f24_local27.width = f0_local6
		f24_local27.height = f24_local13.Height
		local f24_local28 = LUI.UIText.new(f24_local27 )
		f24_local28:setText(f24_local22 )
		f24_local19:addElement(f24_local28 )
	else
		f24_local0 = f24_local0 + 10 + f24_local10.height
		local f24_local12 = CoD.TextSettings.Font30
		local f24_local13 = Engine.ToUpperCase(Engine.Localize("@LUA_MENU_PRESTIGE" ) ) .. " " .. f24_arg0.index
		local f24_local14, f24_local15, f24_local16, f24_local17 = GetTextDimensions(f24_local13, f24_local12.Font, f24_local12.Height )
		local f24_local29 = CoD.CreateState(nil, f24_local0, nil, nil, CoD.AnchorTypes.Top )
		f24_local29.font = f24_local12.Font
		f24_local29.color = Colors.white
		f24_local29.alignment = LUI.Alignment.Center
		f24_local29.width = f0_local6
		f24_local29.height = f24_local12.Height
		local f24_local18 = LUI.UIText.new(f24_local29 )
		f24_local18:setText(f24_local13 )
		f24_local5:addElement(f24_local18 )
		f24_local0 = f24_local0 + 5 + f24_local12.Height
		local f24_local20 = CoD.TextSettings.Font16
		local f24_local21 = Engine.ToUpperCase(Engine.Localize(f24_arg0.statusTextKey or "" ) )
		local f24_local30, f24_local22, f24_local23, f24_local24 = GetTextDimensions(f24_local21, f24_local20.Font, f24_local20.Height )
		local f24_local25 = CoD.CreateState(nil, f24_local0, nil, nil, CoD.AnchorTypes.Top )
		f24_local25.font = f24_local20.Font
		f24_local25.color = Colors.h1.light_grey
		f24_local25.alignment = LUI.Alignment.Center
		f24_local25.width = f0_local6
		f24_local25.height = f24_local20.Height
		local f24_local26 = LUI.UIText.new(f24_local25 )
		f24_local26:setText(f24_local21 )
		f24_local5:addElement(f24_local26 )
	end
	if f24_arg0.currPrestige == f24_arg0.index then
		local f24_local11 = RegisterMaterial("h1_active_prestige_deco_bar" )
		local f24_local12, f24_local13 = GetMaterialDimensions(f24_local11 )
		local f24_local14 = f24_local12 / f24_local13
		local f24_local15 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.Top )
		f24_local15.width = f24_local4.width
		f24_local15.height = f24_local15.width / f24_local14
		f24_local15.material = f24_local11
		f24_local5:addElement(LUI.UIImage.new(f24_local15 ) )
	end
	local f24_local11 = LUI.DecoFrame.new(nil, LUI.DecoFrame.Grey )
	f24_local11:setPriority(PRIORITY_HIGH )
	f24_local5:addElement(f24_local11 )
	local f24_local12 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.All )
	f24_local12.material = RegisterMaterial("h1_ui_btn_focused_stroke_square" )
	f24_local12.alpha = 0
	local f24_local13 = LUI.UIBorder.new(f24_local12 )
	f24_local13:setup9SliceImage()
	f24_local13:registerAnimationState("unfocused", {
		alpha = 0
	} )
	f24_local13:registerAnimationState("highlight", {
		alpha = 0.35
	} )
	f24_local13:registerAnimationState("focused", {
		alpha = 1
	} )
	f24_local5.focusedBorder = f24_local13
	f24_local5:addElement(f24_local13 )
	return self
end

function AddArrowIcon(f25_arg0, f25_arg1, f25_arg2 )
	f25_arg1.alpha = Engine.IsPC() and 0.5 or 1
	f25_arg1.scale = 0
	local self = LUI.UIImage.new(f25_arg1 )
	if Engine.IsPC() then
		self:registerAnimationState("highlight", {
			alpha = 1,
			scale = 0
		} )
		self:registerAnimationState("pulse", {
			scale = -0.1
		} )
		self:setHandleMouseButton(true )
		self:setHandleMouseMove(true )
		self.m_requireFocusType = FocusType.MouseOver
		self:registerEventHandler("mouseenter", function (element, event )
			if CanHandleMouseInput(f25_arg0 ) then
				HighlightButton(element )
			end
		end )
		self:registerEventHandler("mouseleave", function (element, event )
			element:animateToState("default" )
		end )
		self:registerEventHandler("leftmousedown", function (element, event )
			if CanHandleMouseInput(f25_arg0 ) then
				element:animateInSequence({
					{
						"highlight",
						0
					},
					{
						"pulse",
						100
					},
					{
						"highlight",
						100
					}
				} )
				OnPrestigeButtonListInput(f25_arg0, {
					down = true,
					button = f25_arg2,
					name = "gamepad_button",
					controller = event.controller
				} )
			end
		end )
		self:registerEventHandler("leftmouseup", function (element, event )
			OnPrestigeButtonListInput(f25_arg0, {
				down = false,
				button = f25_arg2,
				name = "gamepad_button",
				controller = event.controller
			} )
		end )
	end
	return self
end

function AddPagination(f30_arg0 )
	local f30_local0 = CoD.TextSettings.Font18
	local f30_local1 = 15
	local f30_local2 = f0_local18[f0_local16].font.Height / 2
	local f30_local3 = f0_local18[f0_local16].font.Height
	local f30_local4 = 5
	local f30_local5, f30_local6, f30_local7, f30_local8 = GetTextDimensions(f0_local1 .. " / " .. f0_local1, f30_local0.Font, f30_local0.Height )
	local f30_local9 = f30_local7 - f30_local5
	local f30_local10 = CoD.CreateState(nil, -f30_local3 - f30_local1, nil, nil, CoD.AnchorTypes.TopRight )
	f30_local10.width = f30_local9 + (f30_local2 + f30_local4) * 2
	f30_local10.height = f30_local3
	local self = LUI.UIElement.new(f30_local10 )
	f30_arg0:addElement(self )
	local f30_local12 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.Left )
	f30_local12.height = f30_local3
	f30_local12.width = f30_local2
	f30_local12.material = RegisterMaterial("h1_prestige_leftright_arrow" )
	self:addElement(AddArrowIcon(f30_arg0, f30_local12, "left" ) )
	local f30_local13 = CoD.CreateState(nil, -f30_local0.Height / 2 + 2, nil, nil, CoD.AnchorTypes.None )
	f30_local13.height = f30_local0.Height
	f30_local13.width = f30_local9 + f30_local4 * 2
	f30_local13.alignment = LUI.Alignment.Center
	f30_local13.font = f30_local0.Font
	local f30_local14 = LUI.UIText.new(f30_local13 )
	self.text = f30_local14
	f30_local14:setText(f30_arg0.hList.currIndex .. " / " .. f0_local1 )
	self:addElement(f30_local14 )
	local f30_local15 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.Right )
	f30_local15.height = f30_local3
	f30_local15.width = f30_local2
	f30_local15.zRot = 180
	f30_local15.material = RegisterMaterial("h1_prestige_leftright_arrow" )
	self:addElement(AddArrowIcon(f30_arg0, f30_local15, "right" ) )
	return self
end

function AddPrestigeButtonList(f31_arg0, f31_arg1 )
	local f31_local0 = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.None )
	f31_local0.width = f0_local0
	f31_local0.height = f0_local5
	local self = LUI.UIElement.new(f31_local0 )
	self.parent = f31_arg0
	self:registerEventHandler("gamepad_button", OnPrestigeButtonListInput )
	local f31_local2 = f0_local3 * 2 - 1
	local f31_local3 = f0_local3 * 4
	local f31_local4 = CoD.CreateState(f31_arg1.left - f31_local2 / 2, f31_arg1.top - f31_local3 / 2, nil, nil, CoD.AnchorTypes.TopLeft )
	f31_local4.width = f31_local0.width + f31_local2
	f31_local4.height = f31_local0.height + f31_local3
	local f31_local5 = LUI.UIStencilText.new(f31_local4 )
	f31_local5:addElement(self )
	f31_arg0:addElement(f31_local5 )
	local f31_local6 = LUI.UIHorizontalList.new({
		left = 0,
		leftAnchor = true,
		width = f0_local0,
		height = f0_local5,
		spacing = f0_local3
	} )
	f31_local6.list = {}
	f31_local6.currIndex = 1
	f31_local6.currMinRangeIndex = 1
	f31_local6.currMaxRangeIndex = f0_local4
	local f31_local7 = f31_arg0.exclusiveController
	local f31_local8 = Engine.GetPlayerDataMPXP(f31_local7, CoD.StatsGroup.Ranked, "experience" )
	local f31_local9 = Lobby.GetPlayerPrestigeLevel(f31_local7 )
	local f31_local10 = Lobby.GetRankForXP(f31_local8, f31_local9 )
	for f31_local11 = 1, f0_local1, 1 do
		local f31_local14 = nil
		local f31_local15 = false
		if f31_local9 == f31_local11 - 1 and Rank.GetRankMaxXP(f31_local10, f31_local9 ) <= f31_local8 then
			f31_local14 = {
				materialName = "rank_prestige" .. f31_local11,
				index = f31_local11,
				statusTextKey = "@LUA_MENU_AVAILABLE_CAPS",
				showTokenAvailable = false
			}
			f31_local6.currIndex = f31_local11
		elseif f31_local9 < f31_local11 then
			f31_local14 = {
				materialName = "rank_prestige" .. f31_local11 .. "_locked",
				index = f31_local11,
				isLocked = true
			}
			f31_local15 = true
		else
			f31_local14 = {
				materialName = "rank_prestige" .. f31_local11,
				index = f31_local11,
				statusTextKey = "@MENU_COMPLETED",
				showTokenReceived = false
			}
			f31_local15 = true
			f31_local6.currIndex = f31_local11
		end
		f31_local14.currPrestige = f31_local9
		local f31_local16 = BuildPrestigeButton(f31_local14 )
		f31_local16.isDisabled = f31_local15
		if Engine.IsPC() then
			f31_local16:setHandleMouseButton(true )
			f31_local16:setHandleMouseMove(true )
			f31_local16.m_requireFocusType = FocusType.MouseOver
			f31_local16:registerEventHandler("mouseenter", function (element, event )
				if CanHandleMouseInput(self ) and (f31_local14.index ~= f31_local6.currIndex or not self:isInFocus()) then
					HighlightButton(element.root.focusedBorder )
				end
			end )
			f31_local16:registerEventHandler("mouseleave", function (element, event )
				if not (not CanHandleMouseInput(self ) or self:isInFocus()) or f31_local14.index ~= f31_local6.currIndex then
					element.root.focusedBorder:animateToState("unfocused" )
				end
			end )
			f31_local16:registerEventHandler("leftmousedown", function (element, event )
				if CanHandleMouseInput(self ) then
					ChangeFocusedListButton({
						hList = f31_local6,
						overrideOffset = f31_local14.index
					} )
					OnPrestigeButtonListInput(self, {
						down = true,
						button = "primary",
						name = "gamepad_button",
						controller = event.controller
					} )
				end
			end )
			f31_local16:registerEventHandler("leftmouseup", function (element, event )
				OnPrestigeButtonListInput(self, {
					down = false,
					button = "primary",
					name = "gamepad_button",
					controller = event.controller
				} )
			end )
		end
		table.insert(f31_local6.list, f31_local16 )
		f31_local6:addElement(f31_local16 )
	end
	if f0_local4 <= f31_local6.currIndex then
		local f31_local11 = f31_local6.currIndex
		local f31_local12 = f0_local1
		f31_local11 = REG24 and 0 or 1
		AnimateShiftListLeft(f31_local6, {
			strideAmount = f31_local6.currIndex - f0_local4 + f31_local11,
			instantAnimate = true
		} )
		f31_local6.currMaxRangeIndex = f31_local6.currIndex + f31_local11
		f31_local6.currMinRangeIndex = f31_local6.currIndex - f0_local4 - 1 + f31_local11
	end
	f31_local6.list[f31_local6.currIndex].root:animateToState("focused" )
	f31_local6.list[f31_local6.currIndex].root.focusedBorder:animateToState("focused" )
	self.hList = f31_local6
	self:addElement(f31_local6 )
	self.pagination = AddPagination(self )
	return self
end

function PrestigeMenu(f36_arg0, f36_arg1 )
	local f36_local0 = f36_arg1.exclusiveController
	if not f36_local0 then
		f36_local0 = Engine.GetFirstActiveController()
	end
	Engine.ExecNow("banCheck " .. CoD.AntiCheat.Ban.FEATURE_BAN_PRESTIGE, f36_local0 )
	local f36_local1 = LUI.MenuTemplate.new(f36_arg0, {
		menu_title = "@LUA_MENU_PRESTIGE_CAPS",
		do_not_add_friends_helper = true
	} )
	LUI.MenuTemplate.SetBreadCrumb(f36_local1, Engine.Localize("@LUA_MENU_BARRACKS_CAPS" ) )
	local f36_local2 = CoD.CreateState(f0_local18[f0_local17].left - 200, -100, 300, 10, CoD.AnchorTypes.All )
	f36_local2.color = Colors.black
	f36_local2.material = RegisterMaterial("h1_prestige_description_shadow" )
	f36_local1:addElement(LUI.UIImage.new(f36_local2 ) )
	local f36_local3 = -30
	local f36_local4 = CoD.CreateState(f0_local18[f0_local17].left - 30, f0_local18[f0_local17].top - 30, 27, -45, CoD.AnchorTypes.All )
	f36_local4.material = RegisterMaterial("h1_ui_dot_pattern_lg" )
	f36_local4.alpha = 1
	local self = LUI.UIImage.new(f36_local4 )
	self:setupTiles(16 )
	f36_local1:addElement(self )
	for f36_local6 = 1, #f0_local18, 1 do
		local f36_local9 = AddTitle(f36_local1, f0_local18[f36_local6] ) + f0_local18[f36_local6].contentTopGap
		local f36_local10 = f0_local18[f36_local6].left
		if f36_local6 == f0_local12 then
			f36_local1.prestigeButtonList = AddPrestigeButtonList(f36_local1, {
				left = f36_local10,
				top = f36_local9
			} )
			f36_local1.prestigeButtonList:setFocus(true )
		end
		if f36_local6 == f0_local13 then
			AddPrestigeDesc(f36_local1, {
				left = f36_local10,
				top = f36_local9,
				textKey = "@LUA_MENU_PRESTIGE_PROGRESS_DESC",
				font = CoD.TextSettings.Font23,
				color = Colors.h1.light_grey
			} )
		end
	end
	f36_local1:AddBackButton()
	return f36_local1
end

LUI.MenuBuilder.m_types_build["PrestigeMenu"] = PrestigeMenu