function StrToBytes(str)
    local bytes = {}
    for i = 1, #str do
        bytes[i] = string.byte(str, i)
    end
    return bytes
end

function CompareByteArrays(bytes1, bytes2)
    if #bytes1 ~= #bytes2 then
        return false
    end

    for i = 1, #bytes1 do
        if bytes1[i] ~= bytes2[i] then
            return false
        end
    end

    return true
end

HUD = {}

function HUD.IsRankedAndNotFrontend()
    return GameX.IsRankedMatch() and not Engine.InFrontend()
end

function HUD.CanShowXPBar()
    return HUD.IsRankedAndNotFrontend()-- and Engine.GetDvarBool( "cg_xpbar" )
end

function HUD.GetXPBarOffset()
    return HUD.CanShowXPBar() and -30 or 0
end