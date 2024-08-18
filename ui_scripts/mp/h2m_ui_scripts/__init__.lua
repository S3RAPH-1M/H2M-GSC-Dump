require("components.tabs")
require("components.generic")
require("components.visual_config")

if Engine.InFrontend() then
    require("menus.mp_main_menu")
    require("menus.cacdetails")
end
