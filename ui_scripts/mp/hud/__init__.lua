require("hud_utils")

-- don't register "hud_off" event for score_popup
require("mp_hud")

-- modify score popup to mimic iw4
require("score_popup")

-- obit TTL change to match IW4 (6s to 5s)
require("obituary")

-- remove ugly minimap divider
require("minimap")

-- h2 custom hud
require("team_scores")
require("weapon_info")
require("actionslothud")
require("experience_bar")
require("damage_feedback")
require("hints")

-- splashes
require("splashes")
require("playercard_events")
require("deathstreak")
require("stuck")
require("perks")

-- custom round end for FFA by simon
require("roundend")

-- custom overlay for AC130 made by yoyo & Liam
require("killstreaks.ac130")
require("killstreaks.predator")
require("killstreaks.chopper")
require("killstreaks.emp")

-- scoreboard tweaks to allow custom modes
require("scoreboard")

-- start of killcam hud from scratch
require("killcam")

-- TODO: class editor
require("options")

-- implementation of singleplayer hud for javelin
require("weapons.javelin")

require("low_ammo_warning")