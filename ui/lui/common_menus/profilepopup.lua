LuaQ            TNIL    	   TBOOLEAN       TLIGHTUSERDATA       TNUMBER       TSTRING       TTABLE    
   TFUNCTION    
   TUSERDATA       TTHREAD 	      TIFUNCTION 
      TCFUNCTION       TUI64       TSTRUCT            A       _   � � � � ��   �   �   � � 
 �   �   � � �    �  6  �  6  �  6  �  6  �  6  �  6  �  6  �  6  �  6  � �  �   �   �  �   �   � 2 � �   � �  �   �   �  �   �   � 2 � �  ! �" �$ �% �   '          module          package          seeall        CoD          PrintModuleLoad        _NAME          profileMenuOptionsFeeder        OnCreatePS3ProfileMenu        OnClosePS3ProfileMenu        OnBackPS3ProfileMenu        menu_ps3_profile        SaveErrorContinue        SaveErrorReturn        GetSomeText        menu_ps3_savegame_error        LUI          MenuBuilder        registerDef          registerPopupType   
       LockTable          _M       	              y       ___ h h� h � �	�   �   �
�   �   �
 � �	�   �   �
�   �   ��   �   ��   �   � � ��   �   � 2  �( h� h � �	
�   �   �

�   �   �
 � �	
�   �   �

�   �   �
�   �   �
�   �   � � �
�   �   � 2 �( h� h � �	�   �   �
�   �   �
 � �	�   �   �
�   �   ��   �   ��   �   � � ��   �   � 2 �(�             type        UIGenericButton        id        offile_profile_create_btn        properties        style        GenericButtonSettings          Styles        GlassButton 	       substyle 
       SubStyles        Popup        button_text        Engine   	       Localize !       @MENU_CREATE_NEW_OFFLINE_PROFILE        button_action_func        offile_profile_load_btn $       @MENU_LOAD_EXISTING_OFFLINE_PROFILE        offile_profile_delete_btn        @MENU_DELETE_OFFLINE_PROFILE                          __  � � 2 � ��   �   � 2	    �   �
 � ��   �   ��   �   �              DebugPrint   '       button offile_profile_create_btn press        Engine          Exec        newOfflineProfile        controller        LUI          FlowManager        RequestLeaveMenu                             � � 2 � ��   �   � 2	    �   �
 � ��   �   ��   �   �              DebugPrint   %       button offile_profile_load_btn press        Engine          Exec        loadOfflineProfile        controller        LUI          FlowManager        RequestLeaveMenu                           _  � � 2 � ��   �   � 2	    �   �
 � ��   �   ��   �   �              DebugPrint   '       button offile_profile_delete_btn press        Engine          Exec        deleteOfflineProfile        controller        LUI          FlowManager        RequestLeaveMenu                           _  � � 2 � ��   �   � 2  	          DebugPrint          On Create PS3 profile menu        Engine          ExecNow )       incnosplitscreencontrol menu_ps3_profile                    1         � � 2 � ��   �   � 2 � �	�   �   ��
    �   �  2    9
    �   �  2   9
    �   �  2   9 � ��   �   � 2            DebugPrint          On Close PS3 profile menu        Engine          ExecNow )       decnosplitscreencontrol menu_ps3_profile        GetLuiRoot        IsMenuOpenAndVisible        menu_splitscreensignin        menu_resetstats_warning        menu_ps3_savegame_warning        Exec        startsplitscreensignin                    %       _  � � 2 � ��   �   ��    �   � 	 2    9 � �
�   �   � � ��   �   � �    9 h�            DebugPrint          On Back PS3 profile menu        Engine          GetLuiRoot        IsMenuOpenAndVisible        menu_systemlink        OfflineProfileIsSelected        GetFirstActiveController        dispatchEventToRoot        name        exit_system_link                            _  h �  h � �	�   �   �
 2
 � �  h � �  � �( � �0               type        generic_selectionList_popup        id !       offline_profile_management_popup        properties        popup_title        Engine   	       Localize        @MENU_LOAD_OFFLINE_PROFILE        popup_childfeeder        profileMenuOptionsFeeder   	       handlers        menu_create        OnCreatePS3ProfileMenu          menu_close        OnClosePS3ProfileMenu          popup_back        OnBackPS3ProfileMenu                   	   G         � � 2 � ��   �   ��    9 � ��   �   �	 2
 � ��   �   ��   �   �   2      �   �    h   9 � �     �   ��   �   ��   �   �     �   ��   �   ��   �   �
 � ��   �   ��   �   �                 DebugPrint          Save Error Continue        Engine          GetSplitScreen        Exec        endsplitscreensignin        LUI          FlowManager        RequestAddMenu        menu_gamesetup_splitscreen        controller        assert          properties        callback_params        continue_to_menu        RequestOldMenu                           _  � � 2 � ��   �   ��    9 � ��   �   �	 2  
          DebugPrint          Save Error Cancel        Engine          GetSplitScreen        Exec        startsplitscreensignin                            __   2              my cool text                    3       _ h � ��   �   ��  � ��   �   � 2
 � ��   �   �	 2 � ��   �   � 2 � � � �  � ��   �   ��   �   � 2  ,              message_text        Engine          UserWithoutOfflineProfile        popup_title 	       Localize        @MENU_SAVE_ERROR_MP 	       yes_text        @MENU_RESUMEGAME_NOSAVE_MP        no_text        @MENU_RETURN_SIGNIN_MP        yes_action        SaveErrorContinue   
       no_action        SaveErrorReturn          LUI          MenuBuilder        BuildRegisteredType        generic_yesno_popup                    