LUI.Divider = {}
LUI.Divider.Green = 1
LUI.Divider.Grey = 2

LUI.Divider.Materials = {}
LUI.Divider.Materials[LUI.Divider.Green] = "h2_ui_divider_yellow"
LUI.Divider.Materials[LUI.Divider.Grey] = "h1_ui_divider"

LUI.Divider.new = function(x, y, dividerType, height)
    assert(#LUI.Divider.Materials == LUI.Divider.Grey, "Divider type is not within range.")
    local props = x or CoD.CreateState(0, 0, 0, nil, CoD.AnchorTypes.TopLeftRight)
    props.height = height or 2
    props.material = RegisterMaterial(LUI.Divider.Materials[dividerType or LUI.Divider.Green])
    local divider = LUI.UIImage.new(props)
    divider:setup3SliceRatio(y or 12, 0.3)
    return divider
end
