LuaQ            TNIL    	   TBOOLEAN       TLIGHTUSERDATA       TNUMBER       TSTRING       TTABLE    
   TFUNCTION    
   TUSERDATA       TTHREAD 	      TIFUNCTION 
      TCFUNCTION       TUI64       TSTRUCT            V       _   ¶   ¶          ¶  
        ¶    ¶   h "     6    6    6    6    6    6    6    6    6 	   6 
   6    6    6    6     6   ! 6   " 6  ¶           F  ¶  $        %       & 2 ¶       #        ' ¶( * ¶+    -          module          package          seeall        CoD          PrintModuleLoad        _NAME          LUI          AdvancedVideo        RefreshAdapterInfo "       RefreshVideoSettingAndAdapterInfo        CreateExtraSpace        CreateDivider        OnVideoChange        CreateVideoAdapterInfoElement        VSyncDisplayFunc        CreateDisplayOptions        CreateTextureOptions        CreateShadowOptions        CreatePostProcessOptions        CreateAntiAliasingOptions        CreateShaderPreloadOptions        CreateMiscellaneousOption        CreateOptions        RefreshFunc        DelayedRefreshFunc        new        MenuBuilder        registerType        advanced_video 
       LockTable          _M                             ___   ¶           2 h  	          Engine          GetLuiRoot        getFirstDescendentById        videoAdapterInfoContainer        processEvent        name        menu_refresh                               ¶                    ¶              LUI          Options        RefreshVideoSetting        RefreshAdapterInfo                              h ¶                                   leftAnchor        rightAnchor        left            right 
       topAnchor        bottomAnchor         top        bottom UUB       LUI   
       UIElement        new        list        addElement                 
   6         ¶              h			#  ¶              2 h ¶        ¶       	   *                      LUI   
       UIElement        new        leftAnchor        rightAnchor        left            right 
       topAnchor        bottomAnchor         top        bottom UUB       scrollingToNext        MenuBuilder        BuildRegisteredType        h1_option_menu_titlebar        title_bar_text        Engine          ToUpperCase 	       Localize        addElement        list                 	   7       ___  ¶              ¶       	
 2 h  ¶              2         9	        h         h-            LUI   
       PCOptions        TransferSettingsToUI        Engine          GetLuiRoot        getFirstDescendentById        videoAdapterInfoContainer        processEvent        name        menu_refresh        FlowManager        GetMenuScopedDataByMenuName        pc_controls        selectorButtonId         button_action        list        content_refresh        dispatchChildren                     ’          ¶                   ¶              2 2 ¶ 
                   V ¶              h       " ¶             &,/3       69
T        T ¶             	 h
        	
"
 ¶ 
      
      	
&	,	/	3
        	
6
  ¶! 
#      
$      	
>	9%	&' ¶( *      + 2 	 	T
       	
T
 ¶ 
      
       h       " ¶             &	,/3       6  ¶! ,      -      >9

.& ¶ /      0      1 2  T        T ¶              h        " ¶             &,/3        6  ¶! #      $      >92&' ¶( *      3 2  4	 4	 4	 4	   
   5	6 2    7          CoD          TextSettings        Font23    @  B       LUI   
       UIElement        new        id        videoAdapterInfoContainer        Height  C       UIText        font        Font 
       alignment 
       Alignment        Right        top        left   ĀB       width  ņC       height        alpha   ?       videoAdapterMemory        color        Colors          s1        text_unfocused        videoAdapterMemoryTitle        setText        Engine   	       Localize $       @PLATFORM_UI_DEDICATED_VIDEO_MEMORY        h1        medium_grey        videoAdapter 
       PCOptions        GetDvarValue        r_adapterName        videoAdapterTitle        @PLATFORM_UI_VIDEO_ADAPTER        addElement        registerEventHandler        menu_refresh                
   f       __   L   ¶              2     ¶  
         ¶        4 ¶           9 ¶         9 ¶              ¶           9 ¶    ¶ 
       2x  9 ¶    2 ¶   2 ¶       	 2x L	 2 h8 L	 2 L 	             setText        LUI   
       PCOptions        GetDvarValue        r_adapterName        Engine   &       GetEstimatedVRAMUsageFromUISettingsMB        GetAvailableTextureMemMB        ShouldWarnLowVRAM        Colors          red        h1        medium_grey        HasNoDedicatedVRAM 	       tostring   	       Localize        @PLATFORM_UI_MB_USED         /                  registerAnimationState        color        animateToState                           __  ¶           9  ¶        2 ,    9 4             Engine          GetVSyncControlDisable 	       Localize 	       @MENU_ON                           _    ¶                2 2  h   ¶       
         2 2 2 h h!	 h		! 4	 
  ¶ 
      
       ¶  ¶         ! 9 
h h! h! h !! h"#! h$%!
  ¶               & 2' 2  h(	 	R  ¶       
        * 2+ 2, 2 h h-!	 h		.! 4
     ¶               / 20 2  h1 R  2          LUI          Options        CreateDVarVideoOptionHelper        ui_r_adapter        @PLATFORM_UI_ADAPTER        button_desc        @PLATFORM_UI_ADAPTER_DESC        refreshFunc        CreateOptionButton        ui_r_vsync        @MENU_SYNC_EVERY_FRAME '       @PLATFORM_SYNC_EVERY_FRAME_DESCRIPTION        text 	       @MENU_ON        value        1 
       @MENU_OFF        0        RefreshVideoSetting        VSyncDisplayFunc          Engine          IsPCApp        @MENU_AUTO        auto        @MENU_STANDARD_4_3 	       standard        @MENU_WIDE_16_10        wide 16:10        @MENU_WIDE_16_9 
       wide 16:9        @MENU_WIDE_21_9 
       wide 21:9        ui_r_aspectRatio        @PLATFORM_MONITOR_ASPECT_RATIO #       @PLATFORM_ASPECT_RATIO_DESCRIPTION        disabledFunc        ui_r_renderResolutionNative &       @PLATFORM_UI_NATIVE_RENDER_RESOLUTION +       @PLATFORM_UI_NATIVE_RENDER_RESOLUTION_DESC         ui_r_renderResolution        @PLATFORM_UI_IMAGE_QUALITY $       @PLATFORM_IMAGE_QUALITY_DESCRIPTION                    &       ___   ¶                  ¶          	 2  n	 2 }        ¶              
       ī’~              LUI          Options        StringOptionListFromList        Engine          GetAdapterList   ?       text        MarkLocalized                            _   ¶    ¶          2             RefreshAdapterInfo          Engine          Exec        vid_restart                               ¶                          Engine          GetVSyncControlDisable                            _   ¶          2  	 9   ¶          2    9                  Engine          GetDvarBool        r_fullscreen         r_fullscreenWindow                           __   ¶                     L              LUI          Options        RefreshVideoSetting        RefreshButtonDisabled                            ___   ¶                          Engine          GetRenderResolutionOptions                     	       _   ¶          2  ,               Engine          GetDvarBool        ui_r_renderResolutionNative                    ³       ___  ¶    2 2 ¶       	        
 2 2 2 h h h	 h		
 h

 4	 ¶ 	      	       ¶       	         2 2 2 h h h	 h		
 h

 4	 ¶ 	      	       ¶       	         2 2 2 h h h	 h		
 h

 4	 ¶ 	      	       ¶       	         2 2  2 h h!" h#$ 4  	 ¶ 	      	       ¶       	        % 2& 2' 2 h h h(	 h		) 4	 ¶ 	      	        *          CreateDivider          @PLATFORM_UI_TEXTURE_OPTIONS    A       LUI          Options        CreateOptionButton        ui_r_picmip        @MENU_TEXTURE_RESOLUTION )       @PLATFORM_TEXTURE_RESOLUTION_DESCRIPTION        text 
       @MENU_LOW        value        3        @MENU_NORMAL        2        @MENU_HIGH        1        @MENU_EXTRA        0        RefreshVideoSetting        ui_r_picmip_bump        @MENU_NORMAL_MAP_RESOLUTION ,       @PLATFORM_NORMAL_MAP_RESOLUTION_DESCRIPTION        ui_r_picmip_spec        @MENU_SPECULAR_MAP_RESOLUTION .       @PLATFORM_SPECULAR_MAP_RESOLUTION_DESCRIPTION        ui_r_fill_texture_memory        @MENU_FILL_MEMORY_TEXTURES +       @PLATFORM_FILL_MEMORY_TEXTURES_DESCRIPTION 
       @MENU_OFF        false 	       @MENU_ON        true        ui_r_texFilterAnisoMin         @LUA_MENU_ANISOTROPIC_FILTERING ,       @PLATFORM_ANISOTROPIC_FILTERING_DESCRIPTION        8        16                           _   ¶                          Engine          HasNoDedicatedVRAM                 
   ~       _  ¶    2 ¶               	 2
 2 2 h h h 4	     ¶                2 2 2 h h h	 h		 4 	 ¶ 	      	       ¶                2 2 2 h h h  4 	 ¶ 	      	       ¶               ! 2" 2# 2 h h h  4 	 ¶ 	      	        $          CreateDivider          @PLATFORM_UI_SHADOW_OPTIONS        LUI          Options        CreateOptionButton        ui_sm_enable        @MENU_SHADOWS        @PLATFORM_SHADOWS_DESCRIPTION        text 
       @MENU_OFF        value        false 	       @MENU_ON        true        ui_sm_tileResolution #       @PLATFORM_UI_SHADOW_MAP_RESOLUTION ,       @PLATFORM_SHADOW_MAP_RESOLUTION_DESCRIPTION        @MENU_NORMAL        Normal        @MENU_HIGH        High        @MENU_EXTRA        Extra        RefreshVideoSetting        ui_sm_cacheSunShadow         @PLATFORM_UI_CACHED_SUN_SHADOWS )       @PLATFORM_CACHED_SUN_SHADOWS_DESCRIPTION 	       Disabled        Enabled        ui_sm_cacheSpotShadows !       @PLATFORM_UI_CACHED_SPOT_SHADOWS *       @PLATFORM_CACHED_SPOT_SHADOWS_DESCRIPTION                          _   ¶                     L              LUI          Options        RefreshVideoSetting        RefreshButtonDisabled                            ___   ¶          2    9                  Engine          GetDvarBool 
       sm_enable                             ___   ¶          2    9                  Engine          GetDvarBool 
       sm_enable                             ___   ¶          2    9                  Engine          GetDvarBool 
       sm_enable                     ń       ___  ¶    2 ¶         $ 9 ¶	                2 2 2 h h!% h!%	 h	!	%
 h
!
% 4	 ¶	 	      	        9 ¶	                2 2 2 h h!% h!% 4	 ¶	 	      	       ¶         # 9 ¶	                2 2 2 h h!% h!%	 h	!	%
 h
!
% 4	 ¶	 	      	       ¶	                2  2! 2 h h!% h"!%	 h	#!	%
 h
$!
% 4	     ¶	               % 2& 2' 2 h h!% h!% 4 	 ¶	 	      	       ¶	               ( 2) 2* 2 h h!% h!% 4 	 ¶	 	      	       ¶	               + 2, 2- 2 h h!.% h!/% 4	     0          CreateDivider   "       @PLATFORM_UI_POST_PROCESS_OPTIONS        Engine          IsMultiplayer        LUI          Options        CreateOptionButton        ui_r_dof_limit 
       @MENU_DOF        @PLATFORM_DOF_DESCRIPTION        text 
       @MENU_OFF        value        0        @PLATFORM_LOW_QUALITY        1        @PLATFORM_MEDIUM_QUALITY        2        @PLATFORM_HIGH_QUALITY        3        RefreshVideoSetting 	       @MENU_ON        ui_r_mbLimit        @PLATFORM_MOTIONBLUR !       @PLATFORM_MOTIONBLUR_DESCRIPTION        ui_r_ssaoLimit        @PLATFORM_SSAO        @PLATFORM_SSAO_DESCRIPTION        @MENU_NORMAL        @MENU_HIGH        @PLATFORM_HBAO        ui_r_mdaoLimit        @PLATFORM_MDAO        @PLATFORM_MDAO_DESCRIPTION        ui_r_sssLimit #       @PLATFORM_UI_SUBSURFACE_SCATTERING ,       @PLATFORM_SUBSURFACE_SCATTERING_DESCRIPTION        ui_r_depthPrepass        @PLATFORM_UI_DEPTH_PREPASS $       @PLATFORM_DEPTH_PREPASS_DESCRIPTION        None        All                          _   ¶                     L              LUI          Options        RefreshVideoSetting        RefreshButtonDisabled                            ___   ¶                  2   9   ¶                  2    9        	          LUI   
       PCOptions        GetDvarValue        ui_r_ssaoLimit        0        ui_r_depthPrepass        None                            ___   ¶                  2    9                  LUI   
       PCOptions        GetDvarValue        ui_r_depthPrepass        None                           __   ¶                     L              LUI          Options        RefreshVideoSetting        RefreshButtonDisabled                    W       ___  ¶    2 ¶               	 2
 2 2 h h h	 h		
 h

 h h 4	 ¶ 	      	       ¶                2 2 2 
h h h 	 h	!	"
 h
#
$ h%&
 4	 ¶ 	      	        '          CreateDivider   #       @PLATFORM_UI_ANTI_ALIASING_OPTIONS        LUI          Options        CreateOptionButton        ui_r_postAA        @PLATFORM_UI_POST_AA        @PLATFORM_POST_AA_DESCRIPTION        text 
       @MENU_OFF        value        None        @PLATFORM_FXAA        FXAA        @PLATFORM_SMAA_1X        SMAA 1x        @PLATFORM_SMAA_T2X 	       SMAA T2x        @PLATFORM_FILMIC_SMAA_1X        Filmic SMAA 1x        @PLATFORM_FILMIC_SMAA_T2X        Filmic SMAA T2x        RefreshVideoSetting        ui_r_ssaaSamples        @MENU_SUPERSAMPLING $       @PLATFORM_SUPERSAMPLING_DESCRIPTION        1 	       @MENU_2X        2 	       @MENU_4X        4 	       @MENU_8X        8 
       @MENU_16X        16                 
   T       __  ¶        2 I 9 ¶   	 2
 ¶                2	 2 2 h h#' h#' 4	
 ¶ 	      	        ¶          9
 ¶                2 2 2 h h#' h#' 4  	
 ¶ 	      	                  Engine          GetDvarInt -       enable_video_options_preload_shader_controls            CreateDivider          @PLATFORM_UI_SHADER_PRELOAD        LUI          Options        CreateOptionButton        ui_r_preloadShaders %       @PLATFORM_SHADER_PRELOAD_DESCRIPTION        text 
       @MENU_OFF        value        false 	       @MENU_ON        true        RefreshVideoSetting        IsMultiplayer "       ui_r_preloadShadersAfterCinematic ,       @PLATFORM_UI_SHADER_PRELOAD_AFTER_CINEMATIC 5       @PLATFORM_SHADER_PRELOAD_AFTER_CINEMATIC_DESCRIPTION                              ¶                  2    9                  LUI   
       PCOptions        GetDvarValue        ui_r_preloadShaders        false                    t       ___  ¶    2 ¶               	 2
 2 2 h h h 4	 ¶ 	      	        h 2 2 2T 2 }P	P
 h ¶        ¶    
 ¶  

 ź’~ ¶                2 2  2	 
 4 ¶              ¶ !         9 ¶               " 2# 2$ 2	 h
 h

% h&	  '          CreateDivider   #       @PLATFORM_UI_MISCELLANEOUS_OPTIONS        LUI          Options        CreateOptionButton        ui_fx_marks        @MENU_BULLET_IMPACTS %       @PLATFORM_BULLET_IMPACTS_DESCRIPTION        text 
       @MENU_OFF        value        false 	       @MENU_ON        true        RefreshVideoSetting    A   @      ?       Engine          MarkLocalized 	       tostring          ui_r_dlightForceLimit         @PLATFORM_UI_DLIGHT_FORCE_LIMIT )       @PLATFORM_DLIGHT_FORCE_LIMIT_DESCRIPTION        IsConsoleGame        ragdoll_enable        @MENU_RAGDOLL        @PLATFORM_RAGDOLL_DESC                     *         ¶    ¶    ¶   	 ¶
    ¶    ¶    ¶    ¶                      4            CreateDisplayOptions          CreateTextureOptions          CreateShadowOptions          CreatePostProcessOptions          CreateAntiAliasingOptions          CreateShaderPreloadOptions          CreateMiscellaneousOption          LUI          Options        InitScrollingList        list                           ___                            #       ___  ¶              ¶       	 2  ¶ 
              L       h!            LUI   
       PCOptions        TransferSettingsToUI        Engine          ExecNow        profile_menuDvarsSetup        Options        RefreshVideoSetting        list        processEvent        name        content_refresh        dispatchChildren                           ___  2 ¶                      registerEventHandler        video_option_update_delay        RefreshFunc                 	          ___  L  ¶              2 2 4  
             addElement        LUI          UITimer        new   HC       video_option_update_delay                 
   ģ       __  ¶              ¶       	 2 ¶ 
          9 2   9  ¶               ¶               ¶           9    ¶                h ¶        ¶       	 2  $  ¶             P ¶       P, ¶ !      :  ¶              ¶       P jD  FH%	& 2' ¶( %	* 2 %	+ 2, ¶- 	     ¶ 
      
      	 h ^  ¶       1       n` d  ¶       4      Pf ¶ !      j  ¶       7      l  ¶             9 2p;u<       x=	 
> ¶?    ¶ A      B         ¶ C      D       =	E ¶F   H	   I          LUI   
       PCOptions        TransferSettingsToUI        Engine          ExecNow        profile_menuDvarsSetup        IsMultiplayer            MenuTemplate        spMenuOffset        PCGraphicOptions        FindTypeIndex        PreviousMenuName        new        menu_title        ToUpperCase 	       Localize        @LUA_MENU_GRAPHIC_OPTIONS        menu_top_indent 
       H1MenuTab        tabChangeHoldingElementHeight        H1MenuDims          spacing        menu_width        GenericMenuDims          OptionMenuWidth        menu_list_divider_top_offset        genericListAction 	       skipAnim        registerEventHandler        onVideoChange        OnVideoChange          menu_create        popup_inactive        RefreshFunc          title 	       tabCount        Categories        underTabTextFunc        top        ListTop        width        clickTabBtnAction 	       LoadMenu        activeIndex        advanced_video        skipChangeTab        exclusiveController        addElement        CreateOptions          PCControlOptions        AddOptimalVideoButton        Options        AddOptionTextInfo        CreateVideoAdapterInfoElement          AddBackButtonWithSelector                          _  ¶                                LUI          Options        CloseSelectionMenu        menu                           _  ¶              2            LUI          FlowManager        GetMenuScopedDataByMenuName        pc_controls        selectorValues         selectorUpdateValueFunc        selectorButtonId        selectorDefaultDesc        selectorPriorValueIndex   æ                          __  ¶                                        LUI          PCGraphicOptions        Categories        title                           ___  ¶                                        LUI          PCGraphicOptions        Categories        title                    