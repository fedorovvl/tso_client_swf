package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.PvPProgressionPanel;
    import GUI.Components.data.dPvPRankItemRendererData;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;
    import GUI.Components.ItemRenderer.PvPRankItemRenderer;
    import GUI.Components.ToolTips.cToolTipUtil;
    import GUI.Assets.gAssetManager;
    import GUI.Components.data.dPvPTierSectionData;
    import Enums.GUI_END;
    import GUI.Loca.cLocaManager;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.events.ListEvent;
    import nLib.cLog;
    import Communication.VO.EffectVO;
    import GUI.Components.data.dPvPLevelUnlockData;
    import BuffSystem.cBuffDefinition;
    import Effects.Effects.FulfillCondition;
    import BuffSystem.cBuff;
    import __AS3__.vec.*;

    public class cPvPProgressionPanel extends cBasicPanel 
    {

        public static const STATE_OVERVIEW:String = "overview";
        public static const STATE_RANKS:String = "ranks";

        private var mGI:cGameInterface;
        protected var mPanel:PvPProgressionPanel;


        override public function Show():void
        {
            this.ensureViewIsAvailable();
            globalFlash.gui.windowController.closeActiveWindows();
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
            this.Update();
        }

        public function Update():void
        {
            var _local_12:dPvPRankItemRendererData;
            this.ensureViewIsAvailable();
            var _local_1:ArrayCollection = new ArrayCollection();
            var _local_2:int = this.mGI.mCurrentPlayer.GetClaimedPvPLevel();
            var _local_3:Vector.<ArrayCollection> = global.playerPvPLevelEffects_vector;
            var _local_4:Boolean = true;
            var _local_5:int;
            while (_local_5 < global.playerPvPLevels_vector.length)
            {
                _local_12 = new dPvPRankItemRendererData((_local_5 + 1), null, null, null);
                if ((_local_5 + 1) <= _local_2)
                {
                    _local_12.state = PvPRankItemRenderer.STATE_NORMAL;
                }
                else
                {
                    if ((((_local_5 + 1) <= this.mGI.mCurrentPlayer.GetPlayerPvPLevel()) && (_local_4)))
                    {
                        _local_12.state = PvPRankItemRenderer.STATE_BUTTON_NORMAL;
                        _local_4 = false;
                    }
                    else
                    {
                        if ((((_local_5 + 1) <= this.mGI.mCurrentPlayer.GetPlayerPvPLevel()) && (!(_local_4))))
                        {
                            _local_12.state = PvPRankItemRenderer.STATE_DISABLED;
                        }
                        else
                        {
                            _local_12.state = PvPRankItemRenderer.STATE_DISABLED;
                        };
                    };
                };
                _local_12.toolTip = cToolTipUtil.PVP_LEVEL_REWARDS_TOOLTIP_string;
                _local_12.iconName = global.playerPvPLevels_vector[_local_5].icon;
                _local_1.addItem(_local_12);
                _local_5++;
            };
            this.mPanel.rankList.dataProvider = _local_1;
            var _local_6:int = int((this.mGI.mCurrentPlayer.GetPlayerPvPLevel() / 10));
            var _local_7:int = (this.mGI.mCurrentPlayer.GetPlayerPvPLevel() % 10);
            this.mPanel.digit2.source = gAssetManager.GetBitmap(("PvPProgressionDigit" + _local_7));
            if (_local_6 == 0)
            {
                this.mPanel.digit1.visible = false;
            }
            else
            {
                this.mPanel.digit1.source = gAssetManager.GetBitmap(("PvPProgressionDigit" + _local_6));
                this.mPanel.digit1.visible = true;
            };
            this.mPanel.progressBar.SetData(1, global.playerPvPLevels_vector.length, _local_2, this.mGI.mCurrentPlayer.GetPlayerPvPLevel());
            var _local_8:dPvPTierSectionData = new dPvPTierSectionData(GUI_END.LEFT, true, 1, 0, 10, this.mGI.mCurrentPlayer.GetPvpModifier(), "barrenexpeditionislands");
            this.mPanel.pvpTier1.data = _local_8;
            var _local_9:dPvPTierSectionData = new dPvPTierSectionData(GUI_END.NONE, true, 2, 10, 20, this.mGI.mCurrentPlayer.GetPvpModifier(), "regularexpeditionislands");
            this.mPanel.pvpTier2.data = _local_9;
            var _local_10:dPvPTierSectionData = new dPvPTierSectionData(GUI_END.NONE, true, 3, 20, 30, this.mGI.mCurrentPlayer.GetPvpModifier(), "richexpeditionislands");
            this.mPanel.pvpTier3.data = _local_10;
            var _local_11:dPvPTierSectionData = new dPvPTierSectionData(GUI_END.RIGHT, true, 4, 30, 40, this.mGI.mCurrentPlayer.GetPvpModifier(), "");
            this.mPanel.pvpTier4.data = _local_11;
            this.mPanel.unlockList.dataProvider = this.getPvPLevlRewardUnlocks();
            this.mPanel.ranksPlayerLevelLabel.text = ((cLocaManager.GetInstance().getLabel("currentPlayerLevel") + ": ") + this.mGI.mCurrentPlayer.GetPlayerPvPLevel().toString());
            this.mPanel.pvpBuildingButton.enabled = (!(this.mGI.mCurrentPlayerZone.mStreetDataMap.getBuildingByName(defines.PVPPROGRESSIONHOUSE_NAME_string) == null));
        }

        protected function claimEventHandler(_arg_1:Event):void
        {
            this.mPanel.progressBar.Next();
        }

        public function SetState(_arg_1:String):void
        {
            this.ensureViewIsAvailable();
            this.mPanel.currentState = _arg_1;
            var _local_2:ArrayCollection = new ArrayCollection();
            switch (_arg_1)
            {
                case STATE_OVERVIEW:
                    _local_2.addItem({
                        "selected":true,
                        "label":cLocaManager.GetInstance().getLabel("Overview"),
                        "state":STATE_OVERVIEW,
                        "icon":gAssetManager.GetClass("ProgressionTabOverviewIcon")
                    });
                    _local_2.addItem({
                        "selected":false,
                        "label":cLocaManager.GetInstance().getLabel("GuildLevel"),
                        "state":STATE_RANKS,
                        "icon":gAssetManager.GetClass("ProgressionTabProgressionIcon")
                    });
                    break;
                case STATE_RANKS:
                    _local_2.addItem({
                        "selected":false,
                        "label":cLocaManager.GetInstance().getLabel("Overview"),
                        "state":STATE_OVERVIEW,
                        "icon":gAssetManager.GetClass("ProgressionTabOverviewIcon")
                    });
                    _local_2.addItem({
                        "selected":true,
                        "label":cLocaManager.GetInstance().getLabel("GuildLevel"),
                        "state":STATE_RANKS,
                        "icon":gAssetManager.GetClass("ProgressionTabProgressionIcon")
                    });
                    break;
            };
            this.mPanel.tabContainer.dataProvider = _local_2;
        }

        public function Init(_arg_1:PvPProgressionPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.SetState(STATE_OVERVIEW);
            this.mPanel.closeButton.addEventListener(MouseEvent.CLICK, this.closeButtonClickHandler);
            this.mPanel.okButton.addEventListener(MouseEvent.CLICK, this.closeButtonClickHandler);
            this.mPanel.tabContainer.addEventListener(ListEvent.ITEM_CLICK, this.listItemClickHandler);
            this.mPanel.addEventListener(PvPRankItemRenderer.CLAIM_EVENT, this.claimEventHandler);
            this.mPanel.achievementsButton.addEventListener(MouseEvent.CLICK, this.achievementsButtonClickHandler);
            this.mPanel.archiveButton.addEventListener(MouseEvent.CLICK, this.archiveButtonClickHandler);
            this.mPanel.pvpBuildingButton.addEventListener(MouseEvent.CLICK, this.pvpBuildingButtonClickHandler);
        }

        protected function pvpBuildingButtonClickHandler(_event:MouseEvent):void
        {
            try
            {
                this.mGI.SelectBuilding(this.mGI.mCurrentPlayerZone.mStreetDataMap.getBuildingByName(defines.PVPPROGRESSIONHOUSE_NAME_string));
                global.ui.mCurrentPlayerZone.ScrollToGrid(this.mGI.mCurrentPlayerZone.mStreetDataMap.getBuildingByName(defines.PVPPROGRESSIONHOUSE_NAME_string).GetGrid());
            }
            catch(error:Error)
            {
                cLog.error("Tried to open the PvP Progression Building but it hasn't been placed!");
            };
        }

        protected function archiveButtonClickHandler(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mHelpOverview.ShowItem(global.map_HelpName_HelpDefinition["Help_window_colony_tier_0"], 1);
            globalFlash.gui.mHelpOverview.Show();
        }

        protected function achievementsButtonClickHandler(_arg_1:MouseEvent):void
        {
            globalFlash.gui.OpenWindow("GAMESTATE_ID_ACHIEVEMENT_PANEL", "46");
        }

        protected function listItemClickHandler(_arg_1:ListEvent):void
        {
            var _local_2:Object;
            if (_arg_1.itemRenderer.data != null)
            {
                if (!_arg_1.itemRenderer.data.selected)
                {
                    for each (_local_2 in this.mPanel.tabContainer.dataProvider)
                    {
                        if (((!(_local_2.selected == null)) && (!(_local_2 == _arg_1.itemRenderer.data))))
                        {
                            _local_2.selected = false;
                        };
                    };
                    _arg_1.itemRenderer.data.selected = true;
                    this.mPanel.currentState = _arg_1.itemRenderer.data.state;
                };
            };
            (this.mPanel.tabContainer.dataProvider as ArrayCollection).refresh();
        }

        protected function closeButtonClickHandler(_arg_1:MouseEvent):void
        {
            super.Hide();
        }

        private function ensureViewIsAvailable():void
        {
            var _local_1:PvPProgressionPanel;
            if (!this.mPanel)
            {
                _local_1 = new PvPProgressionPanel();
                _local_1.id = "GAMESTATE_ID_PVP_PROGRESSION";
                global.getApplication().isoengine.addChild(_local_1);
                this.Init(_local_1);
            };
        }

        private function getPvPLevlRewardUnlocks():ArrayCollection
        {
            var _local_5:EffectVO;
            var _local_6:dPvPLevelUnlockData;
            var _local_7:EffectVO;
            var _local_8:cBuffDefinition;
            var _local_9:dPvPLevelUnlockData;
            var _local_10:EffectVO;
            var _local_1:ArrayCollection = new ArrayCollection();
            var _local_2:Object = new Object();
            var _local_3:Vector.<EffectVO> = new Vector.<EffectVO>();
            var _local_4:int;
            while (_local_4 < global.playerPvPLevels_vector.length)
            {
                for each (_local_7 in global.playerPvPLevelEffects_vector[_local_4])
                {
                    _local_7.index = (_local_4 + 1);
                    if (_local_7.effect_string == FulfillCondition.XML_string)
                    {
                        _local_8 = cBuff.getBuffDefinitionByName(_local_7.name_string);
                        if ((((((_local_8 == null) || (!(_local_8.isEventProduceable()))) || (this.mGI.mEventManager.isEventStarted(_local_8.RequiredEventName()))) && (!(_local_7.action_string.toLowerCase() == "hideinlevelupwindow"))) && (!(_local_7.type_string.toLowerCase() == "building"))))
                        {
                            _local_3.push(_local_7);
                        };
                    };
                };
                _local_4++;
            };
            for each (_local_5 in _local_3)
            {
                if (((_local_2[_local_5.name_string] == null) || (_local_5.index <= global.ui.mCurrentPlayer.GetClaimedPvPLevel())))
                {
                    _local_9 = new dPvPLevelUnlockData();
                    _local_9.effectName = _local_5.name_string;
                    _local_9.effectType = _local_5.type_string;
                    _local_9.level = _local_5.index;
                    _local_9.value = _local_5.amount;
                    _local_2[_local_5.name_string] = _local_9;
                };
            };
            for each (_local_6 in _local_2)
            {
                _local_6.nextLevel = 0;
                _local_6.enabled = (global.ui.mCurrentPlayer.GetClaimedPvPLevel() >= _local_6.level);
                for each (_local_10 in _local_3)
                {
                    if (_local_10.name_string == _local_6.effectName)
                    {
                        if (((_local_10.index > _local_6.level) && ((_local_6.nextLevel == 0) || (_local_10.index < _local_6.nextLevel))))
                        {
                            _local_6.nextLevel = _local_10.index;
                        };
                    };
                };
                _local_1.addItem(_local_6);
            };
            return (_local_1);
        }


    }
}
