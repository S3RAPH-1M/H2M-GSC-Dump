local as = luiglobals.require("LUI.mp_hud.ActionSlotHud")

BuildActionSlotGamePad = function( f4_arg0, f4_arg1, f4_arg2, f4_arg3 )
	local f4_local0 = CoD.CreateState( -32 + f4_arg0, nil, nil, f4_arg1, CoD.AnchorTypes.Bottom )
	f4_local0.width = 64
	f4_local0.height = 64
	f4_local0.zRot = f4_arg2
	local self = LUI.UIElement.new( f4_local0 )
	local f4_local2 = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
	f4_local2.material = RegisterMaterial( "h2m_hud_as_dpad_blur" )	
	f4_local2.alpha = CoD.HudStandards.blurAlpha
	self:addElement( LUI.UIImage.new( f4_local2 ) )
	local f4_local3 = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
	f4_local3.material = RegisterMaterial( "h2m_hud_as_dpad_border" )
	f4_local3.color = CoD.HudStandards.overlayTint
    f4_local3.alpha = CoD.HudStandards.overlayAlpha
	self:addElement( LUI.UIImage.new( f4_local3 ) )
	local f4_local4 = CoD.CreateState( nil, nil, nil, -10, CoD.AnchorTypes.Bottom )
	f4_local4.width = 30
	f4_local4.height = 30
	f4_local4.alpha = 0
	f4_local4.zRot = -f4_arg2
	local f4_local5 = LUI.UIElement.new( f4_local4 )
	f4_local5:registerAnimationState( "depleted", {
		alpha = 0.5
	} )
	f4_local5:registerAnimationState( "visible", {
		alpha = 1
	} )
	self:addElement( f4_local5 )
	local f4_local6 = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
	f4_local6.material = RegisterMaterial( "black" )
	local f4_local7 = LUI.UIImage.new( f4_local6 )
	f4_local5:addElement( f4_local7 )
	local f4_local8 = LUI.UIText.new( {
		font = CoD.TextSettings.TitleFontSmallBold.Font,
		alignment = LUI.Alignment.Right,
		topAnchor = false,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		bottom = 3,
		left = 0,
		right = -9,
		height = 10,
		color = Colors.white
	} )
	f4_local8.id = "ammoText_id"
	f4_local8:registerAnimationState( "depleted", {
		color = Colors.red
	} )
	f4_local5:addElement( f4_local8 )
	self.container = f4_local5
	self.text = f4_local8
	self.image = f4_local7
	self.image.slotNum = f4_arg3
	return self
end

actionSlotGamePad = function()
	local f11_local1 = CoD.CreateState( 27, nil, nil, nil, CoD.AnchorTypes.Bottom )
	f11_local1.height = 60
	local self = LUI.UIElement.new( f11_local1 )
	self.id = "actionSlotHudDef"
	local f11_local3 = CoD.CreateState( nil, 4, nil, nil, CoD.AnchorTypes.Top )
	f11_local3.width = 66
	f11_local3.height = 40
	local f11_local4 = LUI.UIElement.new( f11_local3 )
	f11_local4.id = "mask_id"
	f11_local4:setUseStencil( true )
	self:addElement( f11_local4 )
	local f11_local5 = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Top )
	f11_local5.width = 66
	f11_local5.height = 66
	f11_local5.color = CoD.HudStandards.overlayTint
    f11_local5.alpha = CoD.HudStandards.overlayAlpha
	f11_local5.material = RegisterMaterial( "h1_hud_dpad_extra" )
	f11_local4:addElement( LUI.UIImage.new( f11_local5 ) )
	local f11_local16 = BuildActionSlotGamePad( 0, -28, 0, 0 )
	self.slot1 = f11_local16
	self:addElement( f11_local16 )
	f11_local16 = BuildActionSlotGamePad( -38, 10, 90, 2 )
	self.slot2 = f11_local16
	self:addElement( f11_local16 )
	f11_local16 = BuildActionSlotGamePad( 38, 10, 270, 3 )
	self.slot3 = f11_local16
	self:addElement( f11_local16 )
	self:addElement( LUI.UITimer.new( 50, "UpdateActionSlots" ) )
	self:registerEventHandler( "UpdateActionSlots", as.UpdateActionSlots )
	return self
end

BuildActionSlotKeyboard = function( f5_arg0, f5_arg1, f5_arg2 )
	local f5_local0 = CoD.CreateState( -32 + f5_arg0, nil, nil, f5_arg1, CoD.AnchorTypes.Bottom )
	f5_local0.width = 64
	f5_local0.height = 64
	local self = LUI.UIElement.new( f5_local0 )
	local f5_local2 = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
	f5_local2.material = RegisterMaterial( "h2m_hud_as_kbm_blur" )
	f5_local2.alpha = CoD.HudStandards.blurAlpha
	self:addElement( LUI.UIImage.new( f5_local2 ) )
	local f5_local3 = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
	f5_local3.material = RegisterMaterial( "h2m_hud_as_kbm_border" )
	f5_local3.color = CoD.HudStandards.overlayTint
    f5_local3.alpha = CoD.HudStandards.overlayAlpha
	self:addElement( LUI.UIImage.new( f5_local3 ) )
	local f5_local4 = CoD.CreateState( 0, nil, nil, -5, CoD.AnchorTypes.Bottom )
	f5_local4.width = 30
	f5_local4.height = 30
	f5_local4.alpha = 0
	local f5_local5 = LUI.UIElement.new( f5_local4 )
	f5_local5:registerAnimationState( "depleted", {
		alpha = 0.5
	} )
	f5_local5:registerAnimationState( "visible", {
		alpha = 1
	} )
	self:addElement( f5_local5 )
	local f5_local6 = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
	f5_local6.material = RegisterMaterial( "black" )
	local f5_local7 = LUI.UIImage.new( f5_local6 )
	f5_local5:addElement( f5_local7 )
	local f5_local8 = LUI.UIText.new( {
		font = CoD.TextSettings.TitleFontSmallBold.Font,
		alignment = LUI.Alignment.Right,
		topAnchor = false,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		bottom = 2,
		left = 0,
		right = -1,
		height = 14,
		color = Colors.white
	} )
	f5_local8.id = "ammoText_id"
	f5_local8:registerAnimationState( "depleted", {
		color = Colors.red
	} )
	f5_local5:addElement( f5_local8 )
	local f5_local9 = LUI.UIText.new( {
		font = CoD.TextSettings.SP_HudItemKeybindFont.Font,
		alignment = LUI.Alignment.Left,
		topAnchor = true,
		bottomAnchor = false,
		leftAnchor = true,
		rightAnchor = false,
		bottom = 5,
		left = -2,
		right = 0,
		height = CoD.TextSettings.SP_HudItemKeybindFont.Height
	} )
	f5_local9.id = "keyBindingText_id"
	f5_local9:registerAnimationState( "unselected", {
		alpha = 0.5,
		color = {
			r = 0.96,
			g = 0.81,
			b = 0
		}
	} )
	f5_local9:registerAnimationState( "selected", {
		alpha = 1,
		color = {
			r = 1,
			g = 1,
			b = 0.2
		}
	} )

	f5_local5:addElement( f5_local9 )
	self.container = f5_local5
	self.text = f5_local8
	self.keyBindingText = f5_local9
	self.image = f5_local7
	self.image.slotNum = f5_arg2
	return self
end

actionSlotKeyboard = function()
	local f15_local1 = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Bottom )
	f15_local1.height = 60
	local self = LUI.UIElement.new( f15_local1 )
	self.id = "actionSlotHudDef"

	local spacing = 36
	local f15_local11 = BuildActionSlotKeyboard( 0, 0, 0 )
	self.slot1 = f15_local11
	self:addElement( f15_local11 )
	f15_local11 = BuildActionSlotKeyboard( -spacing, 0, 2 )
	self.slot2 = f15_local11
	self:addElement( f15_local11 )
	f15_local11 = BuildActionSlotKeyboard( spacing, 0, 3 )
	self.slot3 = f15_local11
	self:addElement( f15_local11 )
	self:addElement( LUI.UITimer.new( 50, "UpdateActionSlots" ) )
	self:registerEventHandler( "UpdateActionSlots", as.UpdateActionSlots )
	return self
end

function CreateActionSlotHud()
    local root = LUI.UIElement.new( CoD.CreateState( -28, nil, nil, HUD.GetXPBarOffset(), CoD.AnchorTypes.All ) ) -- -28 to fix centering
	root.id = "actionslothud_id"
    root.gamePad = Engine.IsGamepadEnabled()
	root:addElement( root.gamePad and actionSlotGamePad() or actionSlotKeyboard())
	root:registerAnimationState( "active", {
        alpha = 1
	} )
	root:registerAnimationState( "hide", {
        alpha = 0
	} )

	root:registerEventHandler( "button_config_updated", function ( element, event )
		if root.gamePad == false and Engine.IsGamepadEnabled() then
			root:closeChildren()
			root:addElement( actionSlotGamePad() )
			root.gamePad = true
		elseif root.gamePad == true and not Engine.IsGamepadEnabled() then
			root:closeChildren()
			root:addElement( actionSlotKeyboard() )
			root.gamePad = false
		end
		root:dispatchEventToChildren( event )
	end )
	return root
end

LUI.MenuBuilder.m_types_build["actionSlotHudDef"] = CreateActionSlotHud