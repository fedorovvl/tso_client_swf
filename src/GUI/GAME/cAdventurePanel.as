package GUI.GAME
{
    import Communication.VO.ColonyVO;
    import Interface.cGameInterface;
    import GUI.Components.AdventurePanel;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import Communication.VO.dAdventurePlayerListItemVO;
    import GUI.Components.ItemRenderer.AdventureAvatarListItemRenderer;
    import AdventureSystem.cAdventure;
    import AdventureSystem.cAdventureDefinition;
    import Colony.cColony;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import Communication.VO.dRequirementsVO;
    import Communication.VO.CombatCommandVO;
    import Communication.VO.ExpeditionMapLevelGroupResourceRewardVO;
    import com.bluebyte.tso.util.TimeUtil;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import GUI.Loca.TriggerLocaManager;
    import Enums.KILL_SWITCH;
    import Enums.COMMAND;
    import flash.desktop.NativeApplication;
    import Communication.VO.dIntegerVO;
    import GUI.Assets.gAssetManager;
    import GUI.helpers.GraphicsHelpers;
    import mx.controls.Alert;
    import BuffSystem.cBuff;
    import mx.events.CloseEvent;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Communication.VO.dPlayerListItemVO;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import GUI.Components.CustomAlert;

    public class cAdventurePanel extends cBasicPanel 
    {

        private var mColony:ColonyVO;
        private var mDefenseStats:Object;
        private var mGI:cGameInterface;
        protected var mPanel:AdventurePanel;
        private var mCurrentAdventure:dAdventureClientInfoVO;
        private var mCombatStats:Object;


        private function createPlayerList(_arg_1:cAdventureDefinition):void
        {
            var _local_2:dAdventurePlayerListItemVO;
            var _local_3:Boolean;
            var _local_4:AdventureAvatarListItemRenderer;
            var _local_5:int;
            this.mPanel.playerList.removeAllChildren();
            for each (_local_2 in this.mCurrentAdventure.players)
            {
                _local_4 = new AdventureAvatarListItemRenderer();
                _local_4.data = _local_2;
                _local_4.showCancelAdventureInvitation = (this.mCurrentAdventure.ownerPlayerID == this.mGI.mCurrentPlayer.GetPlayerId());
                this.mPanel.playerList.addChild(_local_4);
            };
            _local_3 = false;
            if (this.mCurrentAdventure.status < cAdventure.STATUS_FINISHED_WON)
            {
                _local_5 = 0;
                while (_local_5 < (_arg_1.mMaxPlayers - this.mCurrentAdventure.players.length))
                {
                    _local_4 = new AdventureAvatarListItemRenderer();
                    if (this.mCurrentAdventure.ownerPlayerID == this.mGI.mCurrentPlayer.GetPlayerId())
                    {
                        _local_4.addMode = ((this.mCurrentAdventure.status == cAdventure.STATUS_STARTED) && (!(_local_3)));
                        _local_3 = true;
                    };
                    this.mPanel.playerList.addChild(_local_4);
                    _local_5++;
                };
            };
        }

        public function setCombatStats(_arg_1:Object):void
        {
            var _local_3:Number;
            if (!((this.mCurrentAdventure.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) && (this.mCurrentAdventure.ownerPlayerID == this.mGI.mCurrentPlayer.GetPlayerId())))
            {
            };
            if (_arg_1 != null)
            {
                this.mCombatStats = _arg_1;
            };
            this.mPanel.fetchingData.visible = false;
            this.mPanel.fetchingDataBusy.visible = false;
            this.mPanel.colonyTextLeft.text = (cLocaManager.GetInstance().getLabel("AttacksInitiated") + "\n");
            this.mPanel.colonyTextRight.text = ((this.mCombatStats.attackCountLost + this.mCombatStats.attackCountSuccess).toString() + "\n");
            this.mPanel.colonyTextLeft.text = (this.mPanel.colonyTextLeft.text + (cLocaManager.GetInstance().getLabel("GeneralsInjured") + "\n"));
            this.mPanel.colonyTextRight.text = (this.mPanel.colonyTextRight.text + (this.mCombatStats.attackCountLost.toString() + "\n"));
            this.mPanel.colonyTextLeft.text = (this.mPanel.colonyTextLeft.text + (cLocaManager.GetInstance().getLabel("UnitsLost") + "\n"));
            this.mPanel.colonyTextRight.text = (this.mPanel.colonyTextRight.text + (this.mCombatStats.unitsLost.toString() + "\n"));
            if (!((this.mCurrentAdventure.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) && (this.mCurrentAdventure.colonyOwnerPlayerId == this.mGI.mCurrentPlayer.GetPlayerId())))
            {
                this.mPanel.colonyTextLeft.text = (this.mPanel.colonyTextLeft.text + cLocaManager.GetInstance().getLabel("TimePlayed"));
                _local_3 = this.mCurrentAdventure.colonyDuration;
                if (((this.mCurrentAdventure.colonyDuration == 0) && (this.mCurrentAdventure.collectedTime > 0)))
                {
                    _local_3 = this.mCurrentAdventure.collectedTime;
                };
                this.mPanel.colonyTextRight.text = (this.mPanel.colonyTextRight.text + cLocaManager.GetInstance().FormatDuration(_local_3));
                this.mPanel.playerCount1.text = (cLocaManager.GetInstance().getLabel("AvailableTime") + cLocaManager.GetInstance().FormatDuration((this.mCurrentAdventure.totalDuration - this.mCurrentAdventure.colonyDuration)));
            };
            var _local_2:int = global.expeditionMapLevelGroupVO.CalcTroopLimit(this.mCurrentAdventure.getLevelRange(), this.mCurrentAdventure.mapLevel);
            this.mPanel.unitInfo.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ColonyUnitLimit", [(_local_2 - this.mCurrentAdventure.troopLimit), _local_2]);
            this.mPanel.unitInfo.visible = (this.mCurrentAdventure.troopLimit > 0);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnStart.addEventListener(MouseEvent.CLICK, this.StartAdventureHandler);
            this.mPanel.btnReturnHome.addEventListener(MouseEvent.CLICK, this.ReturnHome);
        }

        public function SetData(_arg_1:dAdventureClientInfoVO):void
        {
            var _local_3:cLocaManager;
            var _local_4:cAdventureDefinition;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:dRequirementsVO;
            var _local_9:CombatCommandVO;
            var _local_10:String;
            var _local_11:ExpeditionMapLevelGroupResourceRewardVO;
            var _local_12:Date;
            var _local_13:Number;
            this.mPanel.colonyHeader.visible = false;
            this.mPanel.colonyContent.visible = false;
            this.mCurrentAdventure = _arg_1;
            var _local_2:Boolean = this.mGI.isOnHomzone();
            _local_3 = cLocaManager.GetInstance();
            _local_4 = cAdventureDefinition.FindAdventureDefinition(this.mCurrentAdventure.adventureName);
            this.mPanel.label = _local_3.GetText(LOCA_GROUP.ADVENTURE_NAME, this.mCurrentAdventure.adventureName);
            this.mPanel.todo.text = _local_3.GetText(LOCA_GROUP.ADVENTURE_TODO, this.mCurrentAdventure.adventureName);
            this.mPanel.playerCount1.text = _local_3.GetText(LOCA_GROUP.LABELS, "PlayersAllowed", [_local_4.mMaxPlayers.toString()]);
            this.mPanel.unitInfo.text = "";
            this.mPanel.difficultIndicator.SetData(_local_4.GetDifficulty(), _local_4.GetTheme(), _local_4.GetCampaign(), _local_4.GetDifficultyTier());
            this.mPanel.pvpTierIndicator.SetData(_local_4.GetDifficulty(), _local_4.GetTheme(), _local_4.GetCampaign(), _local_4.GetDifficultyTier());
            this.mPanel.teaserImage.source = _local_4.GetTeaserImage();
            if (((this.mCurrentAdventure.status == cAdventure.STATUS_STARTED) || ((_local_2) && (cColony.IsWaitForAssignmentState(this.mCurrentAdventure.colonyStatus)))))
            {
                this.mPanel.opener.text = _local_3.GetText(LOCA_GROUP.ADVENTURE_OPENER, this.mCurrentAdventure.adventureName);
                this.mPanel.height = 622;
                this.mPanel.buttonsInitialized.visible = false;
                this.mPanel.buttonsFinished.visible = false;
                this.mPanel.buttonsActive.visible = true;
                this.mPanel.playerCount2.text = _local_3.GetText(LOCA_GROUP.LABELS, "ActivePlayers", [this.mCurrentAdventure.players.length.toString()]);
                this.mPanel.missionHeader.visible = true;
                this.mPanel.missionPanel.visible = true;
                this.mPanel.playerListHeader.visible = true;
                this.mPanel.playerListPanel.visible = true;
                this.mPanel.requestHelpPanel.visible = false;
                this.mPanel.playerCountPanel.height = 25;
                this.mPanel.playerListHeader.setConstraintValue("top", 347);
                this.mPanel.playerListPanel.setConstraintValue("top", 365);
                this.mPanel.playerCountPanel.setConstraintValue("top", 470);
                this.mPanel.durationBar.visible = true;
                _local_5 = cAdventure.GetAdventureDuration(this.mGI, _local_4, (TimeUtil.getServerTime() - this.mCurrentAdventure.collectedTime), this.mCurrentAdventure.totalDuration);
                _local_6 = (this.mCurrentAdventure.collectedTime / _local_5);
                _local_7 = (_local_5 - this.mCurrentAdventure.collectedTime);
                this.mPanel.durationBar.value = _local_6;
                this.mPanel.durationBar.toolTip = cLocaManager.GetInstance().FormatDuration(((_local_7 > 0) ? _local_7 : 0), cLocaManager.DURATION_FORMAT_NORMAL);
                this.createPlayerList(_local_4);
            }
            else
            {
                if (((!(_local_4.IsColony())) && ((cAdventure.IsFinishedState(this.mCurrentAdventure.status)) || ((!(_local_2)) && (cColony.IsWaitForAssignmentState(this.mCurrentAdventure.colonyStatus))))))
                {
                    if (this.mCurrentAdventure.status == cAdventure.STATUS_FINISHED_LOST)
                    {
                        this.mPanel.opener.text = _local_3.GetText(LOCA_GROUP.ADVENTURE_LOST, this.mCurrentAdventure.adventureName);
                    }
                    else
                    {
                        this.mPanel.opener.text = _local_3.GetText(LOCA_GROUP.ADVENTURE_WON, this.mCurrentAdventure.adventureName);
                    };
                    this.mPanel.height = 508;
                    this.mPanel.durationBar.visible = false;
                    this.mPanel.buttonsFinished.visible = true;
                    this.mPanel.buttonsInitialized.visible = false;
                    this.mPanel.buttonsActive.visible = false;
                    this.mPanel.playerCount2.text = _local_3.GetText(LOCA_GROUP.LABELS, "ActivePlayers", [this.mCurrentAdventure.players.length.toString()]);
                    this.mPanel.missionHeader.visible = false;
                    this.mPanel.missionPanel.visible = false;
                    this.mPanel.playerListHeader.visible = true;
                    this.mPanel.playerListPanel.visible = true;
                    this.mPanel.requestHelpPanel.visible = false;
                    this.mPanel.playerCountPanel.height = 25;
                    this.mPanel.playerListHeader.setConstraintValue("top", 237);
                    this.mPanel.playerListPanel.setConstraintValue("top", 0xFF);
                    this.mPanel.playerCountPanel.setConstraintValue("top", 350);
                    this.createPlayerList(_local_4);
                }
                else
                {
                    if (!_local_4.IsColony())
                    {
                        if (_local_4.IsExpedition())
                        {
                            this.mPanel.pvpTierIndicator.visible = true;
                            this.mPanel.difficultIndicator.visible = false;
                        }
                        else
                        {
                            this.mPanel.pvpTierIndicator.visible = false;
                            this.mPanel.difficultIndicator.visible = true;
                        };
                        this.mPanel.missionHeader.visible = true;
                        this.mPanel.missionPanel.visible = true;
                        this.mPanel.playerListHeader.visible = false;
                        this.mPanel.playerListPanel.visible = false;
                        if (_local_4.mMaxPlayers > 1)
                        {
                            this.mPanel.requestHelpPanel.visible = true;
                            this.mPanel.height = 533;
                            this.mPanel.cooperationCheckBox.selected = false;
                        }
                        else
                        {
                            this.mPanel.requestHelpPanel.visible = false;
                            this.mPanel.height = 503;
                        };
                        this.mPanel.playerCountPanel.height = 25;
                        this.mPanel.playerCountPanel.setConstraintValue("top", 345);
                        this.mPanel.opener.text = _local_3.GetText(LOCA_GROUP.ADVENTURE_OPENER, this.mCurrentAdventure.adventureName);
                        this.mPanel.durationBar.visible = false;
                        this.mPanel.buttonsFinished.visible = false;
                        this.mPanel.buttonsInitialized.visible = true;
                        this.mPanel.buttonsActive.visible = false;
                        this.mPanel.playerCount2.text = _local_3.GetText(LOCA_GROUP.LABELS, "AvailableTime", [_local_3.FormatDuration(cAdventure.GetAdventureDuration(this.mGI, _local_4, TimeUtil.getServerTime(), _local_4.GetDuration()))]);
                        if (((AdventureManager.getInstance().getStartedAdventuresCount() >= global.adventureMaximumOwner) || (!(AdventureManager.getInstance().getWaitingColonies() == null))))
                        {
                            this.mPanel.btnStart.enabled = false;
                            this.mPanel.btnStart.toolTip = _local_3.GetText(LOCA_GROUP.LABELS, "AdventuresStartedLimitReached");
                        }
                        else
                        {
                            _local_8 = this.mGI.mRequirements.adventureRequirements_vector[_local_4.mLevelRange];
                            if (!_local_8.isFulfilled())
                            {
                                this.mPanel.btnStart.enabled = false;
                                this.mPanel.btnStart.toolTip = _local_8.locaString;
                            }
                            else
                            {
                                if (!_local_4.isStartConditionsFullfilled(global.ui))
                                {
                                    this.mPanel.btnStart.enabled = false;
                                    this.mPanel.btnStart.toolTip = TriggerLocaManager.getInstance().getTriggerLocaText(_local_4.mStartConditions_vector[0]);
                                }
                                else
                                {
                                    this.mPanel.btnStart.enabled = this.mGI.killswitch.isAccessible(KILL_SWITCH.ADVENTURE_START);
                                    this.mPanel.btnStart.toolTip = "";
                                };
                            };
                        };
                    };
                };
            };
            if (_local_4.IsColony())
            {
                _local_9 = new CombatCommandVO();
                this.mPanel.height = 540;
                this.mPanel.playerCountPanel.setConstraintValue("bottom", 44);
                this.mPanel.playerCountPanel.height = 23;
                this.mPanel.playerCount1.text = "";
                this.mPanel.playerCount2.text = "";
                this.mPanel.unitInfo.text = "";
                this.mPanel.missionPanel.visible = false;
                this.mPanel.missionHeader.visible = false;
                this.mPanel.playerListHeader.visible = false;
                this.mPanel.playerListPanel.visible = false;
                this.mPanel.requestHelpPanel.visible = false;
                this.mPanel.colonyHeader.visible = true;
                this.mPanel.colonyContent.visible = true;
                this.mPanel.durationBar.visible = false;
                this.mPanel.buttonsInitialized.visible = false;
                this.mPanel.buttonsFinished.visible = false;
                this.mPanel.buttonsActive.visible = false;
                this.mPanel.playerCountPanel.visible = true;
                this.mPanel.playerCount1.visible = true;
                this.mPanel.playerCount2.visible = true;
                this.mPanel.unitInfo.visible = true;
                this.mPanel.pvpTierIndicator.visible = true;
                this.mPanel.difficultIndicator.visible = false;
                _local_10 = "";
                this.mColony = global.ui.mCurrentPlayerZone.ColonyGet(this.mCurrentAdventure.colonyID);
                if (this.mCurrentAdventure.colonyStatus == cColony.STATUS_WAIT_FOR_ASSIGNMENT)
                {
                    this.mPanel.colonyTitle.text = cLocaManager.GetInstance().getLabel("BuildingUpDefences");
                    this.mPanel.buttonsActive.visible = true;
                    _local_9.commandId = _arg_1.zoneID;
                    _local_9.value = this.mCurrentAdventure.colonyID.toString();
                    this.mPanel.fetchingData.visible = true;
                    this.mPanel.fetchingDataBusy.visible = true;
                    this.mGI.SendServerAction(COMMAND.COLONY_GET_DEFENSE_MODE_STATS, 0, 0, 0, _local_9);
                }
                else
                {
                    if (this.mCurrentAdventure.colonyStatus == cColony.STATUS_READY_FOR_DEFENSE_MODE)
                    {
                        this.mPanel.colonyTitle.text = cLocaManager.GetInstance().getLabel("YouWon");
                        this.mPanel.fetchingData.visible = true;
                        this.mPanel.fetchingDataBusy.visible = true;
                        this.mGI.SendServerAction(COMMAND.COMBAT_GET_STATS, 0, 0, 0, new CombatCommandVO());
                        this.mPanel.buttonsFinished.visible = true;
                    };
                };
                if (this.mCurrentAdventure.colonyStatus == cColony.STATUS_ASSIGNED)
                {
                    this.mPanel.colonyTitle.text = cLocaManager.GetInstance().getLabel("ProducingResources");
                    _local_11 = global.expeditionMapLevelGroupVO.GetExpeditionMapLevelGroupDataVO(cAdventureDefinition.FindAdventureDefinition(this.mColony.adventureName).GetLevelRangeExpedition()).GetResourceReward(this.mColony.rewardId);
                    _local_12 = new Date();
                    _local_12.time = this.mColony.colonyYieldStartTime;
                    if (_local_11 != null)
                    {
                        _local_12.date = (_local_12.date + int((_local_11.duration / 86400)));
                    };
                    _local_13 = Math.max(0, (_local_12.time - TimeUtil.getServerTime()));
                    if (_local_13 > 0)
                    {
                        this.mPanel.colonyTextLeft.text = (cLocaManager.GetInstance().getLabel("StartedProductionDate") + "\n");
                        this.mPanel.colonyTextRight.text = (cLocaManager.GetInstance().FormatDate(this.mColony.colonyYieldStartTime) + "\n");
                        this.mPanel.colonyTextLeft.text = (this.mPanel.colonyTextLeft.text + (cLocaManager.GetInstance().getLabel("SuccessfulDefences") + "\n"));
                        this.mPanel.colonyTextRight.text = (this.mPanel.colonyTextRight.text + (this.mColony.defenseCount + "\n"));
                        this.mPanel.colonyTextLeft.text = (this.mPanel.colonyTextLeft.text + cLocaManager.GetInstance().getLabel("NoResoureTicks"));
                        this.mPanel.colonyTextRight.text = (this.mPanel.colonyTextRight.text + Math.floor(((TimeUtil.getServerTime() - this.mColony.colonyYieldStartTime) / (global.colonyYieldTickTime * 1000))).toString());
                        this.mPanel.playerCount1.text = ((cLocaManager.GetInstance().getLabel("LifeTime") + ": ") + cLocaManager.GetInstance().FormatDuration(_local_13));
                    }
                    else
                    {
                        this.mPanel.colonyTextLeft.text = (this.mPanel.colonyTextLeft.text + cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ExpeditionJustExpired"));
                        this.mPanel.playerCount1.text = "";
                    };
                    this.mPanel.buttonsActive.visible = true;
                };
                if (((this.mCurrentAdventure.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) && (this.mCurrentAdventure.colonyOwnerPlayerId == this.mGI.mCurrentPlayer.GetPlayerId())))
                {
                    this.mPanel.colonyTitle.text = cLocaManager.GetInstance().getLabel("ColonyUnderAttack");
                    if (this.mColony != null)
                    {
                        _local_9.commandId = _arg_1.colonyID;
                        this.mPanel.fetchingData.visible = true;
                        this.mPanel.fetchingDataBusy.visible = true;
                        this.mGI.SendServerAction(COMMAND.COMBAT_GET_STATS, 0, 0, 0, _local_9);
                        this.mPanel.buttonsActive.visible = true;
                        this.mPanel.playerCountPanel.visible = true;
                    };
                };
                if (((this.mCurrentAdventure.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) && (!(this.mCurrentAdventure.colonyOwnerPlayerId == this.mGI.mCurrentPlayer.GetPlayerId()))))
                {
                    _local_9.commandId = _arg_1.zoneID;
                    this.mPanel.colonyTitle.text = cLocaManager.GetInstance().getLabel("InProgress");
                    this.mPanel.fetchingData.visible = true;
                    this.mPanel.fetchingDataBusy.visible = true;
                    this.mGI.SendServerAction(COMMAND.COMBAT_GET_STATS, 0, 0, 0, _local_9);
                    this.mPanel.buttonsActive.visible = true;
                };
            };
        }

        private function ReturnHome(_arg_1:MouseEvent):void
        {
            this.Hide();
            this.doReturnHome();
        }

        private function doReturnHome():void
        {
            if (defines.CLIENT_ZONEID != 0)
            {
                NativeApplication.nativeApplication.exit(1);
            };
            global.ui.mCurrentPlayerZone.SaveZoneStartZoom();
            var _local_1:dAdventureClientInfoVO = AdventureManager.getInstance().getAdventure(global.ui.mHomePlayer.GetPlayerId());
            if ((((!(_local_1 == null)) && (cAdventure.IsFinishedState(_local_1.status))) && (!(cColony.IsWaitForAssignmentState(_local_1.colonyStatus)))))
            {
                AdventureManager.getInstance().removeAdventure(global.ui.mHomePlayer.GetPlayerId());
            };
            var _local_2:String = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LoadingZone");
            globalFlash.gui.mLoadingZonePanel.SetLoadingMessage(_local_2);
            globalFlash.gui.mLoadingZonePanel.Show();
            global.ui.mClientMessages.SendGetZoneMessageToServer(COMMAND.GET_ZONE, global.ui.mCurrentPlayer.GetPlayerId(), false);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(this.mCurrentAdventure.adventureName);
            if ((((((cAdventure.IsFinishedState(this.mCurrentAdventure.status)) && (_local_2.IsColony())) && (!(this.mGI.mCurrentViewedZoneID == this.mGI.mCurrentPlayer.GetPlayerId()))) && (!(this.mCurrentAdventure.colonyStatus == cColony.STATUS_ASSIGNED))) || (this.mPanel.buttonsFinished.visible)))
            {
                this.doReturnHome();
            };
        }

        public function setDefenseModeStats(_arg_1:Object):void
        {
            var _local_2:ExpeditionMapLevelGroupResourceRewardVO;
            var _local_3:Date;
            this.mColony = global.ui.mCurrentPlayerZone.ColonyGet(this.mCurrentAdventure.colonyID);
            if (_arg_1 != null)
            {
                this.mDefenseStats = _arg_1;
            };
            if (this.mColony != null)
            {
                _local_2 = global.expeditionMapLevelGroupVO.GetExpeditionMapLevelGroupDataVO(cAdventureDefinition.FindAdventureDefinition(this.mColony.adventureName).GetLevelRangeExpedition()).GetResourceReward(this.mColony.rewardId);
                _local_3 = new Date();
                _local_3.time = this.mColony.colonyYieldStartTime;
                if (_local_2 != null)
                {
                    _local_3.date = (_local_3.date + int((_local_2.duration / 86400)));
                };
                this.mPanel.playerCount1.text = (cLocaManager.GetInstance().getLabel("LifeTime") + cLocaManager.GetInstance().FormatDuration((_local_3.time - TimeUtil.getServerTime())));
            };
            this.mPanel.fetchingData.visible = false;
            this.mPanel.fetchingDataBusy.visible = false;
            this.mPanel.colonyTextLeft.text = (cLocaManager.GetInstance().getLabel("NativeCamps") + "\n");
            this.mPanel.colonyTextRight.text = (this.mDefenseStats.NPCCampCount.toString() + "\n");
            this.mPanel.colonyTextLeft.text = (this.mPanel.colonyTextLeft.text + (cLocaManager.GetInstance().getLabel("BuiltCampSlots") + "\n"));
            this.mPanel.colonyTextRight.text = (this.mPanel.colonyTextRight.text + (this.mDefenseStats.defenseCampCount.toString() + "\n"));
            this.mPanel.colonyTextLeft.text = (this.mPanel.colonyTextLeft.text + cLocaManager.GetInstance().getLabel("AvailableCampSlots"));
            this.mPanel.colonyTextRight.text = (this.mPanel.colonyTextRight.text + this.mDefenseStats.freeCampSlotCount.toString());
        }

        public function CancelAdventureInvitation(_arg_1:int):void
        {
            global.ui.mClientMessages.SendMessagetoServer(COMMAND.CANCEL_ADVENTURE_INVITATION, this.mCurrentAdventure.zoneID, new dIntegerVO(_arg_1));
        }

        override public function Show():void
        {
            this.mPanel.ornament.source = gAssetManager.GetClass(GraphicsHelpers.getUIComponentHeaderClassName(this.mGI, this.mPanel.id));
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        public function Init(_arg_1:AdventurePanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function StartAdventure(_arg_1:CloseEvent):void
        {
            if (((!(_arg_1.detail == Alert.OK)) || (this.mGI.killswitch.isLocked(KILL_SWITCH.ADVENTURE_START))))
            {
                return;
            };
            var _local_2:Boolean = this.mPanel.cooperationCheckBox.selected;
            var _local_3:cBuff = this.mGI.mCurrentCursor.mCurrentBuff;
            this.mGI.SendServerAction(COMMAND.APPLY_BUFF, ((_local_2) ? 1 : 0), this.mGI.mCurrentPlayerZone.mStreetDataMap.GetMayorHouse().GetGrid(), 0, _local_3.GetUniqueId());
            _local_3.IncWaitingForServerCount(this.mGI);
            this.mGI.mCurrentCursor.mCurrentBuff = null;
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            AdventureManager.getInstance().increaseStartedAdventuresCount();
            this.Hide();
        }

        public function AddInvitedPlayer(_arg_1:dPlayerListItemVO):void
        {
            var _local_2:dAdventurePlayerListItemVO;
            var _local_3:dAdventurePlayerListItemVO;
            for each (_local_2 in this.mCurrentAdventure.players)
            {
                if (_local_2.id == _arg_1.id)
                {
                    return;
                };
            };
            _local_3 = new dAdventurePlayerListItemVO().InitFromPlayerListItemVO(_arg_1);
            this.mCurrentAdventure.players.addItem(_local_3);
            this.SetData(this.mCurrentAdventure);
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.INVITE_TO_ADVENTURE, this.mCurrentAdventure.zoneID, new dIntegerVO(_arg_1.id));
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_WAS_INVITED, {
                "playerName":_arg_1.username,
                "adventureName":this.mCurrentAdventure.adventureName,
                "owner":this.mGI.mCurrentPlayer.GetPlayerName_string()
            });
        }

        private function StartAdventureHandler(_arg_1:MouseEvent):void
        {
            var _local_3:String;
            var _local_4:Vector.<dResource>;
            var _local_5:CustomAlert;
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(this.mCurrentAdventure.adventureName);
            if ((((_local_2.IsColony()) || (_local_2.IsExpedition())) && (!(this.mCurrentAdventure.status == cAdventure.STATUS_INITIALIZED))))
            {
                this.mGI.visitZone(this.mCurrentAdventure.zoneID);
            }
            else
            {
                _local_3 = "ConfirmStartAdventure";
                _local_4 = null;
                if (((_local_2.IsColony()) || (_local_2.IsExpedition())))
                {
                    _local_3 = "ConfirmStartExpedition";
                    _local_4 = global.expeditionMapLevelGroupVO.GetExpeditionCreationCost(_local_2.GetLevelRangeExpedition());
                };
                _local_5 = CustomAlert.show(_local_3, _local_3, (Alert.CANCEL | Alert.OK), this.mPanel, this.StartAdventure, null, Alert.OK, true, CustomAlert.STYLE_DEFAULT, _local_4);
                _local_5.addEventListener(CloseEvent.CLOSE, this.StartAdventure);
            };
        }

        public function SetBuffData(_arg_1:String):void
        {
            var _local_2:dAdventureClientInfoVO = new dAdventureClientInfoVO();
            _local_2.adventureName = _arg_1;
            _local_2.status = cAdventure.STATUS_INITIALIZED;
            this.SetData(_local_2);
        }


    }
}
