local function getDamageType( parent, omnvar )
	local type = omnvar.value
	if type ~= nil then
		local ttl = 1000
		local element = parent:getChildById( "damageFeedbackImageId" )
		if type == "killshot" then
			element:animateToState( "killshot", 0 )
        elseif type == "killshot_headshot" then
			element:animateToState( "killshot_headshot", 0 )
		elseif type == "standard" then
			element:animateToState( "standard", 0 )
		else
			element:animateToState( "default", 0 )
		end
		local animator = MBh.AnimateSequence( {
			{
				"pop",
				15
			},
			{
				"active",
			    200
			},
			{
				"default",
				ttl
			}
		} )
		animator( parent )
	end
end

LUI.MenuBuilder.m_types_build["damageFeedbackHudDef"] = function()
    local defaultMaterial = RegisterMaterial( "h2m_damage_feedback" )
	local root = LUI.UIElement.new()
	root.id = "damageFeedbackHud"
	root:registerAnimationState( "default", {
		topAnchor = true,
		bottomAnchor = true,
		leftAnchor = true,
		rightAnchor = true,
		top = 0,
		left = 0,
		right = 0,
		bottom = 0
	} )
	root:animateToState( "default" )
	local f8_local2 = LUI.UIElement.new()
	f8_local2:registerAnimationState( "default", {
		topAnchor = false,
		bottomAnchor = false,
		leftAnchor = false,
		rightAnchor = false,
		top = -32,
		bottom = 32,
		left = -32,
		right = 32,
		alpha = 0,
        scale = 0
	} )
	f8_local2:registerAnimationState( "pop", {
		alpha = 1,
        scale = 0.75
	} )
	f8_local2:registerAnimationState( "active", {
        alpha = 1,
        scale = 0
	} )
	f8_local2:animateToState( "default" )
	f8_local2:registerOmnvarHandler( "damage_feedback", getDamageType )
	local f8_local3 = {
		{
			name = "default",
			material = defaultMaterial,
            colour = Colors.white
		}
	}
	LUI.ConcatenateToTable( f8_local3, {
        {
            name = "standard",
            colour = Colors.white
        },
		{
			name = "killshot",
            colour = Colors.h1.light_red
		},
		{
			name = "killshot_headshot",
            colour = Colors.s1.overload_red
		}
	} )
	local image = LUI.UIImage.new()
	image.id = "damageFeedbackImageId"
	for f8_local10, f8_local11 in ipairs( f8_local3 ) do
		local f8_local12 = image
		local animator = image.registerAnimationState
		local f8_local14 = f8_local11.name
		local state = {
			material = f8_local11.material,
			topAnchor = true,
			bottomAnchor = false
		}
		local f8_local9
		if f8_local11.leftAnchor ~= nil then
			f8_local9 = f8_local11.leftAnchor
		else
			f8_local9 = true
		end
		state.leftAnchor = f8_local9
		if f8_local11.rightAnchor ~= nil then
			f8_local9 = f8_local11.rightAnchor
		else
			f8_local9 = true
		end
		state.rightAnchor = f8_local9
		state.top = f8_local11.top or 0
		state.height = f8_local11.height or 128
		state.left = f8_local11.left
		state.right = f8_local11.right
        state.color = f8_local11.colour
		animator( f8_local12, f8_local14, state )
	end
	image:animateToState( "default" )
	f8_local2:addElement( image )
	root:addElement( f8_local2 )
	return root
end