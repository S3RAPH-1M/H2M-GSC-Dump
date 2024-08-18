
if Engine.InFrontend() then

    KillstreakTable = {
        File = "mp/killstreakTable.csv",
        Cols = {
            Index = 0,
            Ref = 1,
            Name = 2,
            Desc = 3,
            Adrenaline = 4,
            Sound = 6,
            Weapon = 11,
            Image = 13,
            CrateIcon = 14,
            CrateIconPlus1 = 15,
            CrateIconPlus2 = 16,
            CrateIconPlus3 = 17,
            DPadIcon = 18,
            UnearnedIcon = 19,
            EarnedIcon = 20,
            Type = 21,
            AlternateName = 22,
            Challenge = 22,
            CKills = 23,
            CDesc = 24,
            CImage = 25,
            CPImage = 26
        }
    }

    local killstreakPlayerData = {
        "sosRating",
        "gdfVariance",
        "gdfRating"
    }
    
    function DrawKillstreakInformation ( infoPanelMenu )

        local f10_local0 = 135 * CoD.FullHDToHD
        local f10_local1 = 642 * CoD.FullHDToHD
        local f10_local2 = 850 * CoD.FullHDToHD
        local f10_local3 = 40 * CoD.FullHDToHD
        local f10_local4 = 44 * CoD.FullHDToHD
        local f10_local5 = 16
        local f10_local6 = 12
        local f10_local7 = CoD.TextSettings.BodyFont18.Font
        local f10_local8 = f10_local3
        local f10_local9 = f10_local3 + f10_local4 + f10_local5
        local f10_local10 = -(f10_local3 + f10_local6)
        local f10_local11 = f10_local9 - f10_local4 / 2
        local f10_local12 = f10_local10 - f10_local4 / 2 - f10_local6
        local UIElement = LUI.UIElement.new( CoD.CreateState( -f10_local2, f10_local0, 0, f10_local0 + f10_local1, CoD.AnchorTypes.TopRight ) )
        UIElement.id = "mainwindow_id"
        
        local imageState = CoD.CreateState( f10_local2, 0, 0, f10_local1, CoD.AnchorTypes.TopLeft )
        imageState.material = RegisterMaterial( "h1_popup_bg" )
        imageState.alpha = 0.6
        local UIElementImage = LUI.UIImage.new( imageState )
        UIElementImage.id = "background_id"
        UIElement:addElement( UIElementImage )

        -- text --
        local textState = CoD.CreateState( -f10_local2 + 20, f10_local8, -f10_local3, nil, CoD.AnchorTypes.TopRight )
        textState.height = f10_local5
        textState.alignment = LUI.Alignment.Left
        textState.font = f10_local7
        textState.color = Colors.h1.yellow
        local selected_streak_text = LUI.UIText.new( textState )
        local textContent = "@KILLSTREAK_NAME"
        selected_streak_text.id = "killstreak_name"
        selected_streak_text:setTextStyle( CoD.TextStyle.ForceUpperCase )
        selected_streak_text:setText( textContent )

        selected_streak_text:registerEventHandler( "set_selected_streak_text", function ( element, event )
            if event.text then
                element:setText( event.text )
            else
                element:setText( "" )
            end
        end )
        UIElement:addElement( selected_streak_text )

        -- kills --
        local textState = CoD.CreateState( -f10_local2 + 20, f10_local8 + 20, -f10_local3, nil, CoD.AnchorTypes.TopRight )
        textState.height = f10_local6
        textState.alignment = LUI.Alignment.Left
        textState.font = f10_local7
        textState.color = Colors.h1.medium_grey
        local selected_streak_kills_text = LUI.UIText.new( textState )
        local textContent = "@KILLSTREAK_KILLS"
        selected_streak_kills_text.id = "killstreak_kills"
        selected_streak_kills_text:setTextStyle( CoD.TextStyle.ForceUpperCase )
        selected_streak_kills_text:setText( textContent )

        selected_streak_kills_text:registerEventHandler( "selected_streak_kills_text", function ( element, event )
            if event.text then
                element:setText( event.text )
            else
                element:setText( "" )
            end
        end )

        UIElement:addElement( selected_streak_kills_text )

        -- description --
        local textState = CoD.CreateState( -f10_local2 + 20, f10_local8 + 50, -f10_local3, nil, CoD.AnchorTypes.TopRight )
        textState.height = f10_local6
        textState.alignment = LUI.Alignment.Left
        textState.font = f10_local7
        local selected_streak_desc_text = LUI.UIText.new( textState )
        local textContent = "@KILLSTREAK_DESC"
        selected_streak_desc_text.id = "killstreak_desc"
        selected_streak_desc_text:setText( textContent )

        selected_streak_desc_text:registerEventHandler( "selected_streak_desc_text", function ( element, event )
            if event.text then
                element:setText( event.text )
            else
                element:setText( "" )
            end
        end )

        UIElement:addElement( selected_streak_desc_text )

        -- killstreak icon --
        local imageState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.TopRight )
        imageState.material = RegisterMaterial( CoD.Material.LockedIcon )
        imageState.width = 64
        imageState.height = 64
        imageState.top = 20
        imageState.left = -100
        local UIElementImage = LUI.UIImage.new( imageState )
        UIElementImage.id = "killstreak_image"

        UIElementImage:registerEventHandler( "selected_streak_preview_img", function ( element, event )
            if event.material then
                CoD.SetMaterial( element, RegisterMaterial ( event.material ) )
            else
                CoD.SetMaterial( element, RegisterMaterial ( CoD.Material.LockedIcon ) )
            end
        end )

        UIElement:addElement( UIElementImage )

        -- Challenge Text --
        local textState = CoD.CreateState( -f10_local2 + 20, f10_local8 + 100, -f10_local3, nil, CoD.AnchorTypes.TopRight )
        textState.height = f10_local6
        textState.alignment = LUI.Alignment.Left
        textState.font = f10_local7
        local selected_streak_challenge_desc_text = LUI.UIText.new( textState )
        local textContent = ""
        selected_streak_challenge_desc_text.id = "challenge_name"
        selected_streak_challenge_desc_text:setText( textContent )

        selected_streak_challenge_desc_text:registerEventHandler( "selected_streak_challenge_text", function ( element, event )
            if event.text then
                element:setText( Engine.Localize("@LUA_MENU_UNLOCK_CHALLENGE_PREFIX", event.text ))
            else
                element:setText( "" )
            end
        end )

        UIElement:addElement( selected_streak_challenge_desc_text )

        -- Challenge Description --
        local textState = CoD.CreateState( -f10_local2 + 20, f10_local8 + 120, -f10_local3, nil, CoD.AnchorTypes.TopRight )
        textState.height = f10_local6
        textState.alignment = LUI.Alignment.Left
        textState.font = f10_local7
        textState.color = Colors.h1.light_grey
        local selected_streak_challenge_progress_text = LUI.UIText.new( textState )
        local textContent = ""
        selected_streak_challenge_progress_text.id = "challenge_desc"
        selected_streak_challenge_progress_text:setText( textContent )

        selected_streak_challenge_progress_text:registerEventHandler( "selected_streak_challenge_description_text", function ( element, event )
            if event.text then
                element:setText( event.text )
            else
                element:setText( "" )
            end
        end )

        UIElement:addElement( selected_streak_challenge_progress_text )

        -- Challenge Progress --
        local textState = CoD.CreateState( -f10_local2 + 20, f10_local8 + 140, -f10_local3, nil, CoD.AnchorTypes.TopRight )
        textState.height = f10_local6
        textState.alignment = LUI.Alignment.Left
        textState.font = f10_local7
        local selected_streak_challenge_progress_text = LUI.UIText.new( textState )
        local textContent = ""
        selected_streak_challenge_progress_text.id = "challenge_progress"
        selected_streak_challenge_progress_text:setText( textContent )

        selected_streak_challenge_progress_text:registerEventHandler( "selected_streak_challenge_progress_text", function ( element, event )
            if event.X and event.Y then
                element:setText( Engine.Localize("@MPUI_X_SLASH_Y", event.X, event.Y ))
            else
                element:setText( "" )
            end
        end )

        UIElement:addElement( selected_streak_challenge_progress_text )

        -- selected streaks --
        local default_ks_left = 100

        local imageState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Left )
        imageState.material = RegisterMaterial( CoD.Material.LockedIcon )
        imageState.width = 64
        imageState.height = 64
        imageState.top = 20
        imageState.left = default_ks_left
        local UIElementImage = LUI.UIImage.new( imageState )
        UIElementImage.id = "killstreak_image_1"

        UIElementImage:registerEventHandler( "selected_streak_selected_img_1", function ( element, event )
            if event.material then
                CoD.SetMaterial( element, RegisterMaterial ( event.material ) )
            else
                CoD.SetMaterial( element, RegisterMaterial ( CoD.Material.LockedIcon ) )
            end
        end )

        UIElement:addElement( UIElementImage )

        local imageState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Left )
        imageState.material = RegisterMaterial( CoD.Material.LockedIcon )
        imageState.width = 64
        imageState.height = 64
        imageState.top = 20
        imageState.left = default_ks_left + 150
        local UIElementImage = LUI.UIImage.new( imageState )
        UIElementImage.id = "killstreak_image_2"

        UIElementImage:registerEventHandler( "selected_streak_selected_img_2", function ( element, event )
            if event.material then
                CoD.SetMaterial( element, RegisterMaterial ( event.material ) )
            else
                CoD.SetMaterial( element, RegisterMaterial ( CoD.Material.LockedIcon ) )
            end
        end )

        UIElement:addElement( UIElementImage )

        local imageState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Left )
        imageState.material = RegisterMaterial( CoD.Material.LockedIcon )
        imageState.width = 64
        imageState.height = 64
        imageState.top = 20
        imageState.left = default_ks_left + 300
        local UIElementImage = LUI.UIImage.new( imageState )
        UIElementImage.id = "killstreak_image_3"

        UIElementImage:registerEventHandler( "selected_streak_selected_img_3", function ( element, event )
            if event.material then
                CoD.SetMaterial( element, RegisterMaterial ( event.material ) )
            else
                CoD.SetMaterial( element, RegisterMaterial ( CoD.Material.LockedIcon ) )
            end
        end )

        UIElement:addElement( UIElementImage )

        local textState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Left )
        textState.height = f10_local6
        textState.width = 64
        textState.alignment = LUI.Alignment.Center
        textState.font = f10_local7
        textState.top = 100
        textState.left = default_ks_left
        local killstreak_selected_desc_1 = LUI.UIText.new( textState )
        local textContent = "0 Kills"
        killstreak_selected_desc_1.id = "killstreak_selected_desc_1"
        killstreak_selected_desc_1:setTextStyle( CoD.TextStyle.ForceUpperCase )
        killstreak_selected_desc_1:setText( textContent )

        killstreak_selected_desc_1:registerEventHandler( "killstreak_selected_desc_1", function ( element, event )
            if event.text then
                element:setText( event.text )
            else
                element:setText( "0 Kills" )
            end
        end )

        UIElement:addElement( killstreak_selected_desc_1 )

        local textState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Left )
        textState.height = f10_local6
        textState.width = 64
        textState.alignment = LUI.Alignment.Center
        textState.font = f10_local7
        textState.top = 100
        textState.left = default_ks_left + 150
        local killstreak_selected_desc_2 = LUI.UIText.new( textState )
        local textContent = "0 Kills"
        killstreak_selected_desc_2.id = "killstreak_selected_desc_2"
        killstreak_selected_desc_2:setTextStyle( CoD.TextStyle.ForceUpperCase )
        killstreak_selected_desc_2:setText( textContent )

        killstreak_selected_desc_2:registerEventHandler( "killstreak_selected_desc_2", function ( element, event )
            if event.text then
                element:setText( event.text )
            else
                element:setText( "0 Kills" )
            end
        end )

        UIElement:addElement( killstreak_selected_desc_2 )

        local textState = CoD.CreateState( nil, nil, nil, nil, CoD.AnchorTypes.Left )
        textState.height = f10_local6
        textState.width = 64
        textState.alignment = LUI.Alignment.Center
        textState.font = f10_local7
        textState.top = 100
        textState.left = default_ks_left + 300
        local killstreak_selected_desc_3 = LUI.UIText.new( textState )
        local textContent = "0 Kills"
        killstreak_selected_desc_3.id = "killstreak_selected_desc_3"
        killstreak_selected_desc_3:setTextStyle( CoD.TextStyle.ForceUpperCase )
        killstreak_selected_desc_3:setText( textContent )

        killstreak_selected_desc_3:registerEventHandler( "killstreak_selected_desc_3", function ( element, event )
            if event.text then
                element:setText( event.text )
            else
                element:setText( "0 Kills" )
            end
        end )

        UIElement:addElement( killstreak_selected_desc_3 )

        -- hide by default --
        UIElement:hide()

        -- set up event handlers to show and hide --
        UIElement:registerEventHandler( "show_info_panel", function ( element, event )
            element:show()
        end )

        UIElement:registerEventHandler( "hide_info_panel", function ( element, event )
            element:show()
        end )

        infoPanelMenu:addElement(UIElement)
    end

    function KillstreakIsFocused ( button, name, kills, desc, image, popup_image, challengeData )
        button:addEventHandler( "button_over", function ( menu, f12_arg1 )
            button:dispatchEventToRoot( {
                name = "set_selected_streak_text",
                text = name,
                immediate = true
            } )

            button:dispatchEventToRoot( {
                name = "selected_streak_kills_text",
                text = kills .. " Killstreak",
                immediate = true
            } )

            button:dispatchEventToRoot( {
                name = "selected_streak_desc_text",
                text = desc,
                immediate = true
            } )

            button:dispatchEventToRoot( {
                name = "selected_streak_preview_img",
                material = image,
                immediate = true
            } )

            button:dispatchEventToRoot({
                name = "selected_streak_challenge_text",
                immediate = true
            })

            button:dispatchEventToRoot({
                name = "selected_streak_challenge_description_text",
                immediate = true
            })

            button:dispatchEventToRoot({
                name = "selected_streak_challenge_progress_text",
                immediate = true
            })
		end )

        button:addEventHandler( "button_over_disable", function ( menu, f12_arg1 )
            if challengeData ~= nil then
                if challengeData.Completed == false then
                    button:dispatchEventToRoot({
                        name = "selected_streak_challenge_text",
                        text = challengeData.Name,
                        immediate = true
                    })
                
                    button:dispatchEventToRoot({
                        name = "selected_streak_challenge_description_text",
                        text = challengeData.Desc,
                        immediate = true
                    })

                    local progress = challengeData.Progress
                    local target = challengeData.Target

                    if not progress then
                        progress = 0
                    end

                    if target < progress then
                        progress = target
                    end

                    button:dispatchEventToRoot({
                        name = "selected_streak_challenge_progress_text",
                        X = progress,
                        Y = target,
                        immediate = true
                    })
                end
            end

            button:dispatchEventToRoot( {
                name = "set_selected_streak_text",
                text = name,
                immediate = true
            } )

            button:dispatchEventToRoot( {
                name = "selected_streak_kills_text",
                text = kills .. " Killstreak",
                immediate = true
            } )

            button:dispatchEventToRoot( {
                name = "selected_streak_desc_text",
                text = desc,
                immediate = true
            } )

            button:dispatchEventToRoot( {
                name = "selected_streak_preview_img",
                material = image,
                immediate = true
            } )
		end )
    end

    local set_streak_count = 0
    local set_streaks = {}

    function checkConflictingKillstreaks (element, event )
        if event.disabled ~= nil and event.disabled == true then
            set_streak_count = 0
            element.properties.button_checked = false
            local event = {}
            event.name = "set_checked"
            event.checkBox = element.properties.button_checked
            element:processEvent( event )
            return
        end

        local kills = element.properties.button_kills
        local enabled = element.properties.button_checked
        local name = element.properties.button_name
        local image = element.properties.button_image
        local challenge_locked = element.properties.button_challenge_locked

        if challenge_locked == true then
            element.properties.button_checked = false
            local event = {}
            event.name = "set_checked"
            event.checkBox = element.properties.button_checked
            element:processEvent( event )
            return
        end

        if set_streak_count == 3 and enabled ~= true then
            element.properties.button_checked = false
            local event = {}
            event.name = "set_checked"
            event.checkBox = element.properties.button_checked
            element:processEvent( event )
        end
    end

    -- button_checked is true after this runs, so we just need to disable if its a duplicate
    function UpdateKillstreaks ( element, event )
        checkConflictingKillstreaks (element, event)
    end

    -- button_checked gets set AFTER this runs, so we check the previous state!
    function KillstreakWithSameKillsSelected ( element, table )

        if element.properties.button_challenge_locked == true then
            return true
        end

        local streakIsNotSelected = true

        for count = 1, 3, 1 do
            if set_streaks[count] ~= nil then
                if set_streaks[count].kills == element.properties.button_kills then
                    if set_streaks[count].name ~= element.properties.button_name then
                        return true 
                    else
                        streakIsNotSelected = false
                    end
                end
            end
        end

        if set_streak_count == 3 and streakIsNotSelected == true then 
            return element.properties.button_checked == false
        end

        return false
    end

    function DrawStreaksInOrder (element)       
        local position = 0
        for counter = 1, 3, 1 do
            position = position + 1
            if set_streaks[counter] ~= nil then
                local item = set_streaks[counter]
                local selected_kills_value = "killstreak_selected_desc_" .. position
                local selected_image_value = "selected_streak_selected_img_" .. position
                local selected_ks_omnvar = killstreakPlayerData[position]

                Engine.SetPlayerData(0, CoD.StatsGroup.Ranked, selected_ks_omnvar, item.index)

                if element.properties then
                    element:dispatchEventToRoot( {
                        name = selected_image_value,
                        material = item.image,
                        immediate = true
                    } )
                    element:dispatchEventToRoot( {
                        name = selected_kills_value,
                        text = item.kills .. " Kills",
                        immediate = true
                    } )
                else
                    element:processEvent( {
                        name = selected_image_value,
                        material = item.image,
                        immediate = true
                    } )
                    element:processEvent( {
                        name = selected_kills_value,
                        text = item.kills .. " Kills",
                        immediate = true
                    } )
                end
            else
                local selected_kills_value = "killstreak_selected_desc_" .. position
                local selected_image_value = "selected_streak_selected_img_" .. position
                local selected_ks_omnvar = "ui_mlg_loadout_streak_" .. position

                local selected_ks_omnvar = killstreakPlayerData[position]

                Engine.SetPlayerData(0, CoD.StatsGroup.Ranked, selected_ks_omnvar, -1)

                element:dispatchEventToRoot( {
                    name = selected_image_value,
                    immediate = true
                } )

                element:dispatchEventToRoot( {
                    name = selected_kills_value,    
                    immediate = true
                } )
            end
        end
    end

    function compare(a,b)
        if (a ~= nil and b ~= nil) then
            return a.kills < b.kills
        else
            return true
        end
    end

    function check_killstreak_for_duplicate_killstreaks (element, event)
        if element.properties.button_challenge_locked == true then
            element.properties.button_checked = false
            event.name = "set_checked"
		    event.checkBox = element.properties.button_checked
		    element:processEvent( event )
            element:dispatchEventToRoot( {
                name = "refresh_disabled",
                immediate = true
            } )
    
            element:dispatchEventToRoot({
                name = "update_killstreaks",
                immediate = true
            })
            return
        end

        if element.properties.button_checked == false then
            element.properties.button_checked = true
        else
            element.properties.button_checked = false
        end

        if element.properties.button_checked == true then
            set_streak_count = set_streak_count + 1
        else
            set_streak_count = set_streak_count - 1
        end

        table.sort(set_streaks, compare)

        if element.properties.button_checked == true then
            if element.properties.button_selected_position == 0 then
                for count = 1, 3, 1 do 
                    if set_streaks[count] == nil then
                        set_streaks[count] = {
                            name = element.properties.button_name,
                            image = element.properties.button_image,
                            kills = element.properties.button_kills,
                            index = element.properties.button_index,
                            position = count
                        }
                        break
                    end
                end
            end
        else
            for count = 1, 3, 1 do
                if set_streaks[count] ~= nil then
                    if set_streaks[count].name == element.properties.button_name then
                        set_streaks[count] = nil
                    end
                end
            end
        end
        
        table.sort(set_streaks, compare)

        DrawStreaksInOrder(element)

        event.name = "set_checked"
		event.checkBox = element.properties.button_checked
		element:processEvent( event )

        element:dispatchEventToRoot( {
            name = "refresh_disabled"
        } )

        element:dispatchEventToRoot({
            name = "update_killstreaks"
        })
    end

    function isKillStreakAlreadyEnabled ( text, kills, image, index, challengeLocked )
        local isEnabled = false
        
        local streak_1 = Engine.GetPlayerData (0, CoD.StatsGroup.Ranked, "sosRating")
        local streak_2 = Engine.GetPlayerData (0, CoD.StatsGroup.Ranked, "gdfVariance")
        local streak_3 = Engine.GetPlayerData (0, CoD.StatsGroup.Ranked, "gdfRating")

        isEnabled = (streak_1 == index or streak_2 == index or streak_3 == index) and challengeLocked ~= true
        local streak_index = -1

        if streak_1 == index and isEnabled then
            set_streak_count = set_streak_count + 1
            streak_index = 1
        end

        if streak_2 == index and isEnabled then
            set_streak_count = set_streak_count + 1
            streak_index = 2
        end

        if streak_3 == index and isEnabled then
            set_streak_count = set_streak_count + 1
            streak_index = 3
        end

        if streak_index ~= -1 then
            set_streaks[streak_index] = {
                name = text,
                image = image,
                kills = kills,
                index = index,
                position = count
            }
        end

        return {
            checked = isEnabled,
            index = streak_index
        }
    end

    local function ItemButton ( menu, name, text, description, kills, image, index, challengeLocked, _func )

        local shouldBeSelectedAlready = isKillStreakAlreadyEnabled( text, kills, image, index, challengeLocked )
        local buttonData = {
            button_text = text,
            button_description = description,
            style = GenericButtonSettings.Styles.FlatButton,
            substyle = GenericButtonSettings.Styles.FlatButton.SubStyles.SubMenu,
            variant = GenericButtonSettings.Variants.Checkbox,
            content_margin = 0,
            content_width = 60,
            canShowLocked = false,
            button_over_func = _func,
            button_action_func = _func,
            button_name = text,
            height = 28,
            button_kills = kills,
            button_image = image,
            button_checked = shouldBeSelectedAlready.checked,
            button_selected_position = 0,
            button_index = index,
            button_challenge_locked = challengeLocked,
        }

        if challengeLocked then
            buttonData.customIcon = {
                material = CoD.Material.LockedIcon,
                offset = 18,
                initVisible = true
            }
        end

        local killstreak_button = menu:AddButton( name, nil, KillstreakWithSameKillsSelected, nil, nil, buttonData )       

        killstreak_button:registerEventHandler("toggle_checked", check_killstreak_for_duplicate_killstreaks)
        killstreak_button:registerEventHandler("update_killstreaks", UpdateKillstreaks )

        local event = {}
        event.name = "set_checked"
		event.checkBox = killstreak_button.properties.button_checked
		killstreak_button:processEvent( event )

        killstreak_button:dispatchEventToRoot( {
            name = "refresh_disabled"
        } )

        killstreak_button:dispatchEventToRoot({
            name = "update_killstreaks"
        })

        return killstreak_button
    end

    function SubscribeChanged ( menu, table )
        local item = LUI.FlowManager.GetMenuScopedDataFromElement( menu )

        menu:dispatchEventToRoot( {
            name = "show_info_panel"
        } )
    end

    function resetStreaks ( menu, cdata )
        for count = 1, 3, 1 do
            set_streaks[count] = nil
            local selected_kills_value = "killstreak_selected_desc_" .. count
            local selected_image_value = "selected_streak_selected_img_" .. count

            menu:dispatchEventToRoot( {
                name = selected_image_value,
                immediate = true
            } )

            menu:dispatchEventToRoot( {
                name = selected_kills_value,    
                immediate = true
            } )

            menu:dispatchEventToRoot( {
                name = "update_killstreaks", 
                disabled = true,  
                immediate = true
            } )
        end
    end

    buildKillStreakSelectionMenu = function (a1)
        set_streak_count = 0
        set_streaks = {}
        local menu = LUI.MenuTemplate.new(a1, {
            menu_title = "MENU_KILLSTREAK_REWARDS_CAPS",
            menu_width = luiglobals.GenericMenuDims.OptionMenuWidth
        })

        DrawKillstreakInformation( menu )

        menu:AddBackButton()
        local ksButton = nil
        local loaded_streaks = {}
        for key, value in pairs(Cac.Weapons.Primary.streak) do
            local streak_name = value[1]
            local localized_name = Engine.TableLookup( KillstreakTable.File, KillstreakTable.Cols.Ref, streak_name, KillstreakTable.Cols.Name )
            local killstreak_challenge = Engine.TableLookup( KillstreakTable.File, KillstreakTable.Cols.Ref, streak_name, KillstreakTable.Cols.Challenge )
            local is_streak_locked = false
            local killstreak_challenge_info = nil
            if killstreak_challenge ~= nil and killstreak_challenge ~= "" then
                local f8_local24, f8_local25 = ParseChallengeName( killstreak_challenge )
                killstreak_challenge_info = GetChallengeData( Cac.GetSelectedControllerIndex(), f8_local24, false, f8_local25 )

                if killstreak_challenge_info.Completed == false then
                    is_streak_locked = true
                end
            end

            local name = Engine.Localize("@" .. localized_name .. "_LOWERC")
            local kills = tonumber(Engine.TableLookup( KillstreakTable.File, KillstreakTable.Cols.Ref, streak_name, KillstreakTable.Cols.CKills ))
            local desc = Engine.TableLookup( KillstreakTable.File, KillstreakTable.Cols.Ref, streak_name, KillstreakTable.Cols.CDesc )
            local image = Engine.TableLookup( KillstreakTable.File, KillstreakTable.Cols.Ref, streak_name, KillstreakTable.Cols.CImage )
            local popup_image = Engine.TableLookup( KillstreakTable.File, KillstreakTable.Cols.Ref, streak_name, KillstreakTable.Cols.CPImage )
            local index = key

            loaded_streaks[#loaded_streaks + 1] = {
                name = name,
                kills = kills,
                desc = desc,
                image = image,
                popup_image = popup_image,
                index = index,
                is_streak_locked = is_streak_locked,
                challenge_data = killstreak_challenge_info
            }
        end

        table.sort(loaded_streaks, compare)

        for key, value in pairs(loaded_streaks) do
            local streak_event = SubscribeChanged
            if is_streak_locked then
                streak_event = nil
            end

            local name_and_kills = "[ ^3" .. value.kills .. " ^7]     " .. value.name

            local localized_desc = Engine.Localize("@" .. value.desc )

            value.index = key

            ksButton = ItemButton (menu, name_and_kills, value.name, localized_desc, value.kills, value.image, value.index, value.is_streak_locked, streak_event)
            KillstreakIsFocused ( ksButton, value.name, value.kills, localized_desc, value.image, value.popup_image, value.challenge_data )
        end


        menu:AddHelp({
            name = "add_button_helper_text",
            button_ref = "button_action",
            helper_text = Engine.Localize("KILLSTREAK_SELECT"),
            side = "left",
            clickable = false,
            priority = -1000
        }, nil, nil, true)

        menu:AddHelp({
            name = "reset_streaks_text",
            button_ref = "button_alt1",
            helper_text = Engine.Localize("KILLSTREAK_RESET"),
            side = "left",
            clickable = true
        }, resetStreaks )

        table.sort(set_streaks, compare)
        
        DrawStreaksInOrder( menu )

        return menu
    end

    LUI.MenuBuilder.registerType("killstreak_selection", buildKillStreakSelectionMenu)
end