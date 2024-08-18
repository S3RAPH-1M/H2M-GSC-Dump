local f0_local1 = function ( f2_arg0 )
	if f2_arg0 ~= PersistentBackground.currentVideo or not Engine.IsVideoPlaying( f2_arg0 ) then
		Engine.PlayMenuVideo( f2_arg0, 1 )
		PersistentBackground.currentVideo = f2_arg0
	end
end

local f0_local4 = function ( f11_arg0, f11_arg1 )
	if Engine.GetDvarBool( "virtualLobbyPresentable" ) and f11_arg0.PBTimer then
		PersistentBackground.FadeFromBlackSlow()
		--f11_arg0:animateToState( "hidden" )
		--LUI.UITimer.Stop( f11_arg0.PBTimer )
		--f11_arg0:removeElement( f11_arg0.PBTimer )
		--f11_arg0.PBTimer = nil
	end
end

-- TODO: just fix all this idk how to explain it
local ogvlobby = PersistentBackground.Variants.VirtualLobby
PersistentBackground.Variants.VirtualLobby = function ()
    if not Engine.GetDvarBool( "new_menu" ) then
        return ogvlobby()
    end

	--PersistentBackground.FadeFromBlackSlow()

    local self = nil
    f0_local1( "H2M_Party_Menu" )
    local f12_local1 = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
    f12_local1.color = Colors.h1.black
    f12_local1.alpha = 1
    self = LUI.UIImage.new( f12_local1 )
    self:setupFullWindowElement()
    self:registerAnimationState( "hidden", {
        alpha = 0
    } )
    self:registerEventHandler( "checkLobbyPresentable", f0_local4 )
    local f12_local2 = CoD.CreateState( 0, 0, 0, 0, CoD.AnchorTypes.All )
    f12_local2.material = RegisterMaterial( "cinematic" )
    f12_local2.alpha = 1
    local cinematic = LUI.UIImage.new( f12_local2 )
    cinematic:setupLetterboxElement()
    self:addElement( cinematic )
    local timer = LUI.UITimer.new( 1, "checkLobbyPresentable" )
    self:addElement( timer )
    self.PBTimer = timer
    return self
end