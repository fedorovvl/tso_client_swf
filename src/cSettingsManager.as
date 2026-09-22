package 
{
    import Communication.VO.PlayerOptionsVO;
    import Communication.VO.PlayerOptionVO;
    import Enums.PLAYER_OPTION;
    import Enums.COMMAND;
    import ServerState.Responding;
    import Sound.cSoundManager;
    import Tracks.TrackManager;

    public class cSettingsManager 
    {

        private static var instance:cSettingsManager;

        private var mSfxMuted:Boolean = false;
        private var mShowSmoke:Boolean;
        private var mShowMissingResources:Boolean;
        private var mShowAnimals:Boolean;
        private var mPlayerOptions:PlayerOptionsVO;
        private var mShowFullWarehouse:Boolean;
        private var mSfxVolume:int;
        private var mShowGeneralMarkers:Boolean;
        private var mForceChatColorWhite:Boolean;
        private var mShowHalfSizeGraphics:Boolean;
        private var mLoopsMuted:Boolean = false;
        private var mShowGeneralName:Boolean;
        private var mHalfSizeImages:Boolean;
        private var mCurrentGlobalChatInstance:int;
        private var mShowSectorMarkers:Boolean;
        private var mShowBuffAnimations:Boolean;
        private var mChatVisible:Boolean;
        private var mShowPvpTaskBuildingTasks:Boolean;
        private var mShowMissingSettler:Boolean;
        private var mMusicVolume:int;
        private var mFriendsListVisible:Boolean;
        private var mAirshipSkin:int;
        private var mShowStoppedProduction:Boolean;
        private var mShowSettlers:Boolean;

        public function cSettingsManager(_arg_1:SingletonEnforcer)
        {
            super();
            if (!_arg_1)
            {
                throw (new Error("Please use getInstance() to get the cLocalSettingsManager!"));
            };
        }

        public static function getInstance():cSettingsManager
        {
            if (!cSettingsManager.instance)
            {
                cSettingsManager.instance = new cSettingsManager(new SingletonEnforcer());
            };
            return (cSettingsManager.instance);
        }


        public function get showSmoke():Boolean
        {
            return (this.mShowSmoke);
        }

        public function set showAnimals(_arg_1:Boolean):void
        {
            this.mShowAnimals = _arg_1;
            if (((!(this.mShowAnimals)) && (global.ui.mCurrentPlayerZone.mSettlerKIManager)))
            {
                global.ui.mCurrentPlayerZone.mSettlerKIManager.clearAnimals(true);
            };
            globalFlash.gui.mPlayerOptionsPanel.setShowAnimalsState(this.mShowAnimals);
        }

        public function set showSectorMarkers(_arg_1:Boolean):void
        {
            this.mShowSectorMarkers = _arg_1;
            global.ui.mCurrentPlayerZone.SetBackgroundHasChanged(true);
            globalFlash.gui.mPlayerOptionsPanel.setSectorMarkerState(this.mShowSectorMarkers);
        }

        public function get sfxVolume():int
        {
            return (this.mSfxVolume);
        }

        public function set showMissingResources(_arg_1:Boolean):void
        {
            if (this.mShowMissingResources != _arg_1)
            {
                this.mShowMissingResources = _arg_1;
            };
            globalFlash.gui.mPlayerOptionsPanel.setShowMissingResourcesState(this.mShowMissingResources);
        }

        public function set showSettlers(_arg_1:Boolean):void
        {
            this.mShowSettlers = _arg_1;
            globalFlash.gui.mPlayerOptionsPanel.setShowSettlersState(this.mShowSettlers);
        }

        public function get playerOptions():PlayerOptionsVO
        {
            var _local_1:PlayerOptionsVO = new PlayerOptionsVO();
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.CHAT_VISIBLE, ((this.chatVisible) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.CURRENT_GLOBAL_CHAT_INSTANCE, this.currentGlobalChatInstance.toString()));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.FRIENDS_LIST_VISIBLE, ((this.friendsListVisible) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.FORCE_CHAT_COLOR_WHITE, ((this.forceChatColorWhite) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.LOOPS_MUTED, ((this.loopsMuted) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SFX_MUTED, ((this.sfxMuted) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_SECTOR_BOUNDARIES, ((this.showSectorMarkers) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_GENERAL_MARKER, ((this.showGeneralMarkers) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.LOOPS_VOLUME, this.musicVolume.toString()));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SFX_VOLUME, this.sfxVolume.toString()));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_GENERAL_NAME, ((this.showGeneralName) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_SETTLERS, ((this.showSettlers) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_BUILDING_SMOKE, ((this.showSmoke) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_ANIMALS, ((this.showAnimals) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_BUFF_ANIMATIONS, ((this.showBuffAnimations) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.USE_HALF_SIZE_GRAPHICS, ((this.showHalfSizeGraphics) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.PVP_TASK_BUILDING_TASKS, ((this.showPvpTaskBuildingTasks) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.AIRSHIP_SKIN, this.airshipSkin.toString()));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_MISSING_SETTLER, ((this.showMissingSettler) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_MISSING_RESOURCES, ((this.showMissingResources) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_FULL_WAREHOUSE, ((this.showFullWarehouse) ? "true" : "false")));
            _local_1.options.addItem(PlayerOptionVO.Create(PLAYER_OPTION.SHOW_STOPPED_PRODUCTION, ((this.showStoppedProduction) ? "true" : "false")));
            return (_local_1);
        }

        public function get showBuffAnimations():Boolean
        {
            return (this.mShowBuffAnimations);
        }

        public function set showBuffAnimations(_arg_1:Boolean):void
        {
            this.mShowBuffAnimations = _arg_1;
            globalFlash.gui.mPlayerOptionsPanel.setBuffAnimationState((!(this.mShowBuffAnimations)));
        }

        public function set showPvpTaskBuildingTasks(_arg_1:Boolean):void
        {
            this.mShowPvpTaskBuildingTasks = _arg_1;
            globalFlash.gui.mTaskBuildingPanel.setPvpTaskBuildingTasks(this.mShowPvpTaskBuildingTasks);
        }

        public function set showSmoke(_arg_1:Boolean):void
        {
            this.mShowSmoke = _arg_1;
            globalFlash.gui.mPlayerOptionsPanel.setShowSmokeState(this.mShowSmoke);
        }

        public function get showMissingSettler():Boolean
        {
            return (this.mShowMissingSettler);
        }

        public function get friendsListVisible():Boolean
        {
            return (this.mFriendsListVisible);
        }

        public function set showGeneralMarkers(_arg_1:Boolean):void
        {
            this.mShowGeneralMarkers = _arg_1;
            globalFlash.gui.mPlayerOptionsPanel.setGeneralMarkerState(this.mShowGeneralMarkers);
        }

        public function get musicVolume():Number
        {
            return (this.mMusicVolume);
        }

        public function set playerOptions(_arg_1:PlayerOptionsVO):void
        {
            var _local_2:PlayerOptionVO;
            this.mPlayerOptions = _arg_1;
            for each (_local_2 in this.mPlayerOptions.options)
            {
                switch (_local_2.settingName)
                {
                    case PLAYER_OPTION.CHAT_VISIBLE:
                        this.chatVisible = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.CURRENT_GLOBAL_CHAT_INSTANCE:
                        this.currentGlobalChatInstance = parseInt(_local_2.value);
                        break;
                    case PLAYER_OPTION.FRIENDS_LIST_VISIBLE:
                        this.friendsListVisible = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.FORCE_CHAT_COLOR_WHITE:
                        this.forceChatColorWhite = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.LOOPS_MUTED:
                        this.loopsMuted = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SFX_MUTED:
                        this.sfxMuted = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.LOOPS_VOLUME:
                        this.musicVolume = Number(_local_2.value);
                        break;
                    case PLAYER_OPTION.SFX_VOLUME:
                        this.sfxVolume = Number(_local_2.value);
                        break;
                    case PLAYER_OPTION.SHOW_BUFF_ANIMATIONS:
                        this.showBuffAnimations = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_SECTOR_BOUNDARIES:
                        this.showSectorMarkers = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_GENERAL_MARKER:
                        this.showGeneralMarkers = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_GENERAL_NAME:
                        this.showGeneralName = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_SETTLERS:
                        this.showSettlers = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_ANIMALS:
                        this.showAnimals = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_BUILDING_SMOKE:
                        this.showSmoke = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_MISSING_SETTLER:
                        this.showMissingSettler = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_MISSING_RESOURCES:
                        this.showMissingResources = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_FULL_WAREHOUSE:
                        this.showFullWarehouse = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.SHOW_STOPPED_PRODUCTION:
                        this.showStoppedProduction = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.USE_HALF_SIZE_GRAPHICS:
                        this.showHalfSizeGraphics = ((_local_2.value == "true") ? true : false);
                        global.mGraphicScaleFactor = ((this.showHalfSizeGraphics) ? 0.5 : 1);
                        break;
                    case PLAYER_OPTION.PVP_TASK_BUILDING_TASKS:
                        this.showPvpTaskBuildingTasks = ((_local_2.value == "true") ? true : false);
                        break;
                    case PLAYER_OPTION.AIRSHIP_SKIN:
                        this.airshipSkin = parseInt(_local_2.value);
                        break;
                };
            };
            globalFlash.gui.mPlayerOptionsPanel.Update();
        }

        public function get showHalfSizeGraphics():Boolean
        {
            return (this.mShowHalfSizeGraphics);
        }

        public function set showGeneralName(_arg_1:Boolean):void
        {
            this.mShowGeneralName = _arg_1;
            globalFlash.gui.mPlayerOptionsPanel.setGeneralNameState((!(this.mShowGeneralName)));
        }

        public function get airshipSkin():int
        {
            return (this.mAirshipSkin);
        }

        public function get showMissingResources():Boolean
        {
            return (this.mShowMissingResources);
        }

        public function get showAnimals():Boolean
        {
            return (this.mShowAnimals);
        }

        public function saveToServer(_arg_1:Responding=null):void
        {
            global.ui.SendServerActionSimple(COMMAND.SAVE_PLAYER_SETTINGS, this.playerOptions, _arg_1);
        }

        public function get showSectorMarkers():Boolean
        {
            return (this.mShowSectorMarkers);
        }

        public function set friendsListVisible(_arg_1:Boolean):void
        {
            this.mFriendsListVisible = _arg_1;
            if (this.mFriendsListVisible)
            {
                globalFlash.gui.mActionBar.showFriendList();
            }
            else
            {
                globalFlash.gui.mActionBar.hideFriendList();
            };
        }

        public function get currentGlobalChatInstance():int
        {
            return (this.mCurrentGlobalChatInstance);
        }

        public function set showMissingSettler(_arg_1:Boolean):void
        {
            if (this.mShowMissingSettler != _arg_1)
            {
                this.mShowMissingSettler = _arg_1;
            };
            globalFlash.gui.mPlayerOptionsPanel.setShowMissingSettlerState(this.mShowMissingSettler);
        }

        public function set musicVolume(_arg_1:Number):void
        {
            if (_arg_1 <= 0)
            {
                this.mMusicVolume = 0;
                if (!this.loopsMuted)
                {
                    this.loopsMuted = true;
                };
            }
            else
            {
                if (_arg_1 > defines.VOLUME_MAX_VALUE)
                {
                    this.mMusicVolume = defines.VOLUME_MAX_VALUE;
                }
                else
                {
                    this.mMusicVolume = _arg_1;
                };
            };
            if (((this.musicVolume > 0) && (this.loopsMuted)))
            {
                this.loopsMuted = false;
            };
            cSoundManager.getInstance().setLoopsVolume((this.mMusicVolume / defines.VOLUME_MAX_VALUE));
            if (!this.mLoopsMuted)
            {
                cSoundManager.getInstance().restartLoops();
            };
        }

        public function set airshipSkin(_arg_1:int):void
        {
            if (this.mAirshipSkin != _arg_1)
            {
                this.mAirshipSkin = _arg_1;
            };
        }

        public function set loopsMuted(_arg_1:Boolean):void
        {
            this.mLoopsMuted = _arg_1;
            TrackManager.getInstance().trackUI(global.ui.mCurrentPlayer.GetPlayerId(), "Sound Option", ((this.mLoopsMuted) ? "on" : "muted"), 0, false);
            if (((this.loopsMuted) && (!(cSoundManager.getInstance().isLoopsMuted()))))
            {
                cSoundManager.getInstance().toggleLoops();
                this.musicVolume = 0;
                globalFlash.gui.mPlayerOptionsPanel.refreshVolumeControls();
            }
            else
            {
                if (((!(this.loopsMuted)) && (cSoundManager.getInstance().isLoopsMuted())))
                {
                    cSoundManager.getInstance().toggleLoops();
                    this.musicVolume = 3;
                    globalFlash.gui.mPlayerOptionsPanel.refreshVolumeControls();
                };
            };
            globalFlash.gui.mPlayerOptionsPanel.setMusicMutedState(this.mLoopsMuted);
            globalFlash.gui.mOptionsPanel.SetLoopsMutedButtonState(this.mLoopsMuted);
        }

        public function get showPvpTaskBuildingTasks():Boolean
        {
            return (this.mShowPvpTaskBuildingTasks);
        }

        public function set forceChatColorWhite(_arg_1:Boolean):void
        {
            this.mForceChatColorWhite = _arg_1;
        }

        public function get showGeneralMarkers():Boolean
        {
            return (this.mShowGeneralMarkers);
        }

        public function get forceChatColorWhite():Boolean
        {
            return (this.mForceChatColorWhite);
        }

        public function set sfxMuted(_arg_1:Boolean):void
        {
            this.mSfxMuted = _arg_1;
            if (((this.sfxMuted) && (!(cSoundManager.getInstance().isEffectsMuted()))))
            {
                cSoundManager.getInstance().toggleEffects();
                this.sfxVolume = 0;
                globalFlash.gui.mPlayerOptionsPanel.refreshVolumeControls();
            }
            else
            {
                if (((!(this.sfxMuted)) && (cSoundManager.getInstance().isEffectsMuted())))
                {
                    cSoundManager.getInstance().toggleEffects();
                    this.sfxVolume = 3;
                    globalFlash.gui.mPlayerOptionsPanel.refreshVolumeControls();
                };
            };
            globalFlash.gui.mPlayerOptionsPanel.setSfxMutedState(this.mSfxMuted);
            globalFlash.gui.mOptionsPanel.SetEffectsMutedButtonState(this.mSfxMuted);
        }

        public function set showHalfSizeGraphics(_arg_1:Boolean):void
        {
            this.mShowHalfSizeGraphics = _arg_1;
            globalFlash.gui.mPlayerOptionsPanel.setUseHalfSizeGraphicsState(this.mShowHalfSizeGraphics);
        }

        public function get loopsMuted():Boolean
        {
            return (this.mLoopsMuted);
        }

        public function get showGeneralName():Boolean
        {
            return (this.mShowGeneralName);
        }

        public function set showStoppedProduction(_arg_1:Boolean):void
        {
            if (this.mShowStoppedProduction != _arg_1)
            {
                this.mShowStoppedProduction = _arg_1;
            };
            globalFlash.gui.mPlayerOptionsPanel.setShowStoppedProductionState(this.mShowStoppedProduction);
        }

        public function get showSettlers():Boolean
        {
            return (this.mShowSettlers);
        }

        public function set currentGlobalChatInstance(_arg_1:int):void
        {
            this.mCurrentGlobalChatInstance = _arg_1;
        }

        public function get sfxMuted():Boolean
        {
            return (this.mSfxMuted);
        }

        public function set showFullWarehouse(_arg_1:Boolean):void
        {
            if (this.mShowFullWarehouse != _arg_1)
            {
                this.mShowFullWarehouse = _arg_1;
            };
            globalFlash.gui.mPlayerOptionsPanel.setShowFullWarehouseState(this.mShowFullWarehouse);
        }

        public function get showStoppedProduction():Boolean
        {
            return (this.mShowStoppedProduction);
        }

        public function set chatVisible(_arg_1:Boolean):void
        {
            this.mChatVisible = _arg_1;
            if (globalFlash.gui.mChatPanel != null)
            {
                if (!this.mChatVisible)
                {
                    globalFlash.gui.mChatPanel.Collapse();
                }
                else
                {
                    globalFlash.gui.mChatPanel.Expand();
                };
            };
        }

        public function get showFullWarehouse():Boolean
        {
            return (this.mShowFullWarehouse);
        }

        public function get chatVisible():Boolean
        {
            return (this.mChatVisible);
        }

        public function set sfxVolume(_arg_1:int):void
        {
            if (_arg_1 <= 0)
            {
                this.mSfxVolume = 0;
                if (!this.sfxMuted)
                {
                    this.sfxMuted = true;
                };
            }
            else
            {
                if (_arg_1 >= defines.VOLUME_MAX_VALUE)
                {
                    this.mSfxVolume = defines.VOLUME_MAX_VALUE;
                }
                else
                {
                    this.mSfxVolume = _arg_1;
                };
            };
            if (((this.sfxVolume > 0) && (this.sfxMuted)))
            {
                this.sfxMuted = false;
            };
            cSoundManager.getInstance().setEffectsVolume((this.mSfxVolume / defines.VOLUME_MAX_VALUE));
        }


    }
}//package 

class SingletonEnforcer 
{

    public function SingletonEnforcer()
    {
        super();
    }

}


