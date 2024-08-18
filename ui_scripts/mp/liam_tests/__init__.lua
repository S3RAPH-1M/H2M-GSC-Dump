-- tests -- 
Cac.GameModes = {
    Group = {
        Standard = "Standard"
    },
    Data = {
        Standard = {
            Label = Engine.Localize( "@MPUI_STANDARD_CAPS" ),
            Image = "h1_ui_icon_playlist_standard",
            List = {
                "dm",
                "war",
                "sd",
                "dom",
                "conf",
                "sab",
                "koth",
                "hp",
                "gun"
            }
        }
    }
}

require("hud")

function GetGameModeName()
	return Engine.Localize( Engine.TableLookup( GameTypesTable.File, GameTypesTable.Cols.Ref, GameX.GetGameMode(), GameTypesTable.Cols.Name ) )
end