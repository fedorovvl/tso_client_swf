package com.bluebyte.tso.quests.view.controller
{
    import GUI.GAME.cBasicPanel;
    import GUI.Components.StandardButton;
    import Interface.cGameInterface;
    import com.bluebyte.tso.quests.view.ui.panel.QuestBook;
    import Communication.VO.dQuestPoolVO;
    import GUI.Loca.cLocaManager;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import Communication.VO.dQuestElementVO;
    import mx.core.UIComponent;
    import Tasks.Task;
    import Communication.VO.dTrackedMissionListVO;
    import Communication.VO.dTrackedMissionVO;
    import Enums.MISSION_TYPE;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Communication.VO.dServerAction;
    import Enums.COMMAND;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.ItemClickEvent;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import nLib.gMisc;
    import AdventureSystem.cAdventureDefinition;
    import mx.events.CloseEvent;
    import Sound.cSoundManager;
    import Communication.VO.EffectVO;
    import mx.collections.ArrayCollection;
    import Effects.Effects.Reward;
    import GUI.FloatingItemsManager;
    import mx.events.FlexEvent;
    import ServerState.cResources;
    import Communication.VO.dBuyOneClickShopItemVO;
    import Enums.ONE_CLICK_SHOPITEM;
    import GUI.Assets.gAssetManager;
    import Enums.LOCA_GROUP;
    import Colony.cColony;
    import AdventureSystem.cAdventure;
    import com.bluebyte.tso.util.TimeUtil;
    import GUI.Events.TrackMissionEvent;
    import mx.events.ToolTipEvent;
    import Communication.VO.dQuestDefinitionTriggerVO;
    import converted.bluebyte.tso.quests.trigger.QuestTriggerFactory;
    import Communication.VO.dQuestTriggerVO;
    import Communication.VO.TriggerVO;
    import Trigger.Trigger;
    import Communication.VO.dQuestDefinitionVO;
    import Communication.VO.dQuestDefinitionRewardVO;
    import GUI.Effects.gHintManager;
    import Enums.TRIGGER_ACTION;
    import Trigger.Triggers.GlobalDonationTrigger;
    import Effects.Effects.GiveCollectibleResource;
    import Effects.Effects.FulfillCondition;
    import com.bluebyte.tso.quests.view.ui.itemrenderer.QuestListGroupItemRenderer;
    import com.bluebyte.tso.quests.view.ui.itemrenderer.QuestListItemRenderer;
    import GUI.Components.ToolTips.cToolTipUtil;

    public class cQuestBook extends cBasicPanel 
    {

        private static const MODE_PREVIEW:int = 0;
        private static const MODE_RUNNING:int = 1;
        private static const MODE_FINISHED:int = 2;

        private var mBtnCancelAdventure:StandardButton;
        private var mGI:cGameInterface;
        private var mBtnCloseBook:StandardButton;
        private var mPanel:QuestBook;
        private var mBtnLeaveAdventure:StandardButton;
        private var mQuestPool:dQuestPoolVO;
        private var mLM:cLocaManager = cLocaManager.GetInstance();
        private var mCurrentAdventure:dAdventureClientInfoVO = null;
        private var mDisplayedQuest:dQuestElementVO;
        private var mPreselectedQuest:dQuestElementVO;
        private var mTrackingChanged:Boolean = false;
        private var mNotificationQuest:dQuestElementVO;
        private var mBtnCloseFailedQuest:StandardButton;
        private var mBtnCloseQuest:StandardButton;
        private var mBtnInstantFinish:StandardButton;
        private var mBtnPayQuest:StandardButton;
        private var mCanceledQuest:Object;
        private var mCurrentQuest:dQuestElementVO;


        private function hideAllButtons():void
        {
            var _local_1:UIComponent;
            for each (_local_1 in this.mPanel.footerButtons.getChildren())
            {
                _local_1.includeInLayout = (_local_1.visible = false);
            };
        }

        private function setDisplayedQuest(_arg_1:dQuestElementVO):void
        {
            this.mDisplayedQuest = _arg_1;
            this.mPanel.list.selectedItem = _arg_1;
        }

        public function SetPreselectedQuestThatStartsWith(_arg_1:String):void
        {
            this.mPreselectedQuest = this.mQuestPool.GetQuestThatStartsWith(_arg_1);
        }

        public function SendTrackedMissionList(_arg_1:Boolean=false):void
        {
            var _local_3:dQuestElementVO;
            var _local_4:dAdventureClientInfoVO;
            var _local_6:Task;
            if (((!(this.mTrackingChanged)) && (!(_arg_1))))
            {
                return;
            };
            var _local_2:dTrackedMissionListVO = new dTrackedMissionListVO();
            for each (_local_3 in this.mGI.mQuestClientCallbacks.GetClientQuestPool().mQuestVO_vector)
            {
                if (_local_3.mIsTrackedMission)
                {
                    _local_2.trackedMissionList.addItem(new dTrackedMissionVO().init(MISSION_TYPE.QUEST, _local_3.mUniqueID.uniqueID1, _local_3.mUniqueID.uniqueID2));
                };
            };
            for each (_local_4 in AdventureManager.getInstance().getAdventures())
            {
                if (_local_4.isTrackedMission)
                {
                    _local_2.trackedMissionList.addItem(new dTrackedMissionVO().init(MISSION_TYPE.ADVENTURE, _local_4.zoneID, 0));
                };
            };
            if (this.mGI.getCurrentTaskManager() != null)
            {
                for each (_local_6 in this.mGI.getCurrentTaskManager().getIdentities().valueSet())
                {
                    if (_local_6.isTracked)
                    {
                        _local_2.trackedMissionList.addItem(new dTrackedMissionVO().init(MISSION_TYPE.TASKS, _local_6.getId(), 0));
                    };
                };
            };
            var _local_5:dServerAction = new dServerAction();
            _local_5.data = _local_2;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.CHANGE_TRACKED_MISSION_LIST, this.mGI.mCurrentViewedZoneID, _local_5);
            this.mTrackingChanged = false;
        }

        private function ConfirmCancelAllQuestsByType(_arg_1:ItemClickEvent):void
        {
            this.mCanceledQuest = _arg_1.item;
            CustomAlert.show("ConfirmCancelAllQuests", "ConfirmCancelAllQuests", (Alert.OK | Alert.CANCEL), null, this.CancelAllQuestsByType);
        }

        public function SetQuestData(_arg_1:dQuestPoolVO):void
        {
            this.mQuestPool = _arg_1;
            this.SetData();
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        private function SetData():void
        {
            var _local_2:dQuestElementVO;
            var _local_3:Array;
            var _local_4:String;
            var _local_5:String;
            if (this.mQuestPool == null)
            {
                return;
            };
            var _local_1:Dictionary = new Dictionary();
            for each (_local_2 in this.mQuestPool.GetQuest_vector())
            {
                if ((((!(_local_2.mQuestDefinition == null)) && (_local_2.IsQuestModeAllowedForQuestList(this.mGI))) && ((_local_2.mQuestDefinition.showQuestWindow) || (_local_2.mQuestDefinition.showRewardWindow))))
                {
                    if (_local_2.mQuestMode == QuestManagerStatic.QUEST_MODE_PENDING_NEXT_RANDOM_DAILY_QUEST)
                    {
                        if (_local_1["WaitingDailyQuests"] == null)
                        {
                            _local_1["WaitingDailyQuests"] = new Array();
                        };
                        _local_1["WaitingDailyQuests"].push(_local_2);
                    }
                    else
                    {
                        _local_4 = (_local_2.mQuestDefinition.type_string + "Quests");
                        if (((!(_local_4 == "GuildQuests")) || (!(this.mGI.GetCurrentPlayerGuild() == null))))
                        {
                            if (_local_1[_local_4] == null)
                            {
                                _local_1[_local_4] = new Array();
                            };
                            _local_1[_local_4].push(_local_2);
                        };
                    };
                };
            };
            _local_3 = gMisc.iterableToArray(AdventureManager.getInstance().getAdventures());
            if (((_local_3.length > 0) && ((this.mGI.isOnHomzone()) || (this.mGI.IsAdventureZone()))))
            {
                _local_5 = "ActiveAdventures";
                if (_local_3.length == 1)
                {
                    if (cAdventureDefinition.FindAdventureDefinition(_local_3[0].adventureName).IsExpedition())
                    {
                        _local_5 = "ActiveExpeditions";
                    }
                    else
                    {
                        if (cAdventureDefinition.FindAdventureDefinition(_local_3[0].adventureName).IsColony())
                        {
                            _local_5 = "ActiveArchipelagos";
                        };
                    };
                };
                _local_1[_local_5] = _local_3;
            };
            this.mPanel.list.dataProvider = _local_1;
            if (this.mPanel.list.selectedItem)
            {
                this.ShowItem(this.mPanel.list.selectedItem);
            }
            else
            {
                this.DisplayNextItem();
            };
        }

        public function SetNotificationQuest(_arg_1:dQuestElementVO):void
        {
            this.mNotificationQuest = _arg_1;
        }

        private function CancelAdventure(_arg_1:CloseEvent):void
        {
            var _local_2:dAdventureClientInfoVO;
            if (_arg_1.detail == Alert.OK)
            {
                _local_2 = (this.mPanel.list.selectedItem as dAdventureClientInfoVO);
                AdventureManager.getInstance().removeAdventure(_local_2.zoneID);
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.CANCEL_ADVENTURE, _local_2.zoneID, null);
                this.SetData();
                this.DisplayNextItem();
            };
        }

        private function cancelExpedition(_arg_1:MouseEvent):void
        {
            CustomAlert.show("ConfirmCancelExpedition", "ConfirmCancelExpedition", (Alert.OK | Alert.CANCEL), null, this.cancelExpeditionHandler, null, Alert.OK, true, CustomAlert.STYLE_DEFAULT);
        }

        override public function Show():void
        {
            if (this.mGI.mIsDefenseMode)
            {
                Hide();
                return;
            };
            cSoundManager.getInstance().playEffect("QuestOpenLog");
            this.mPanel.guildQuestProgressContainer.visible = false;
            this.SetData();
            super.Show();
            this.mGI.channels.ZONE.send("QUESTBOOK_OPENED", true);
            if (this.mPreselectedQuest)
            {
                this.DisplayQuest(this.mPreselectedQuest);
            }
            else
            {
                if (this.mNotificationQuest)
                {
                    this.DisplayQuest(this.mNotificationQuest);
                };
            };
        }

        private function ShowEffects(_arg_1:MouseEvent):void
        {
            var _local_2:EffectVO;
            var _local_3:ArrayCollection;
            var _local_4:int;
            var _local_5:int;
            if (this.mPanel.list.selectedItem)
            {
                _local_3 = this.mPanel.list.selectedItem.GetQuestDefinition().helpEffects_vector;
                _local_5 = _local_3.length;
                _local_4 = 0;
                while (_local_4 < _local_5)
                {
                    this.mGI.effectFactory.createEffect(_local_3[_local_4]).apply();
                    _local_4++;
                };
                _local_3 = this.mPanel.list.selectedItem.GetQuestDefinition().preEffects_vector;
                _local_5 = _local_3.length;
                _local_4 = 0;
                while (_local_4 < _local_5)
                {
                    _local_2 = (_local_3[_local_4] as EffectVO);
                    if (((_local_2.onQuestSight) && (!(_local_2.effect_string == Reward.XML_string))))
                    {
                        this.mGI.effectFactory.createEffect(_local_2).apply();
                    };
                    _local_4++;
                };
            };
        }

        public function SetPreselectedQuest(_arg_1:dQuestElementVO):void
        {
            this.mPreselectedQuest = _arg_1;
        }

        private function CancelAllQuestsByType(_arg_1:CloseEvent):void
        {
            var _local_2:dQuestElementVO;
            var _local_3:Boolean;
            var _local_4:String;
            var _local_5:dQuestElementVO;
            if (_arg_1.detail == Alert.OK)
            {
                for each (_local_2 in this.mQuestPool.GetQuest_vector())
                {
                    if (this.mCanceledQuest == (_local_2.mQuestDefinition.type_string + "Quests"))
                    {
                        _local_3 = _local_2.GetQuestDefinition().cancelable;
                        _local_4 = _local_2.GetQuestDefinition().connectedToQuest_string;
                        if ((((!(_local_3)) && (!(_local_4 == null))) && (!(_local_4 == ""))))
                        {
                            _local_5 = this.mQuestPool.GetQuestFromName(_local_4);
                            if (_local_5 != null)
                            {
                                _local_3 = _local_5.mQuestDefinition.cancelable;
                            };
                        };
                        if (_local_3)
                        {
                            this.mGI.mQuestClientCallbacks.CancelQuest(_local_2.mUniqueID);
                            _local_2.SetQuestMode(QuestManagerStatic.QUEST_MODE_DEACTIVATED);
                        };
                    };
                };
                this.SetData();
                this.DisplayNextItem();
            };
        }

        private function CloseQuestImpl():void
        {
            this.mGI.mQuestClientCallbacks.RewardOkButtonPressedFromGui(this.mCurrentQuest);
            FloatingItemsManager.flyRewards(this.mPanel.rewards.getRewardFrames());
            if (this.mCurrentQuest)
            {
                this.DisplayQuest(this.mCurrentQuest);
            };
        }

        override protected function HideWithoutQueue():void
        {
            this.SendTrackedMissionList();
            this.mPanel.sparkleAnim.visible = false;
            super.HideWithoutQueue();
        }

        private function Clear():void
        {
            this.SetDetailsBackground(false);
            this.mPanel.questNPC.source = null;
            this.mPanel.questHeadline.text = "";
            this.mPanel.description.text = "";
            this.mPanel.triggerCanvas.visible = false;
            this.mPanel.adventureTextContainer.visible = true;
            this.mPanel.adventureText.text = "";
            this.mPanel.rewardInfo.visible = false;
            this.mPanel.adventureOptions.visible = false;
            this.hideAllButtons();
            this.mBtnCloseBook.includeInLayout = (this.mBtnCloseBook.visible = true);
            this.mPanel.effects.visible = false;
            this.mPanel.questionmark.visible = false;
        }

        private function cancelExpeditionHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mPanel.btnShowDetails.enabled = false;
            this.mPanel.btnInvite.enabled = false;
            this.mPanel.btnSendArmy.enabled = false;
            this.mPanel.btnVisit.enabled = false;
            this.mPanel.btnCancelExpedition.enabled = false;
            AdventureManager.getInstance().removeAdventure(this.mCurrentAdventure.zoneID);
            if (this.mCurrentAdventure.colonyID > 0)
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.CANCEL_PVP_COLONY, this.mCurrentAdventure.zoneID, null);
            }
            else
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.CANCEL_ADVENTURE, this.mCurrentAdventure.zoneID, null);
            };
            this.SetData();
        }

        public function Init(_arg_1:QuestBook):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function InstantFinish(_arg_1:MouseEvent):void
        {
            var _local_2:dQuestElementVO = (this.getDisplayedQuest() as dQuestElementVO);
            var _local_3:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            if (_local_3.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_2.mQuestDefinition.questWinGemCosts))
            {
                _local_2.instantFinishInProgress = true;
                this.DisplayQuest(_local_2);
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, this.mGI.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().InitWithUniqueID(ONE_CLICK_SHOPITEM.PAY_FOR_QUEST_FINISH, _local_2.mUniqueID));
            }
            else
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
        }

        private function ItemClickedHandler(_arg_1:ItemClickEvent):void
        {
            this.ShowItem(_arg_1.item);
        }

        private function LeaveAdventure(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:dAdventureClientInfoVO = (this.mPanel.list.selectedItem as dAdventureClientInfoVO);
            AdventureManager.getInstance().removeAdventure(_local_2.zoneID);
            global.ui.mClientMessages.SendMessagetoServer(COMMAND.LEAVE_ADVENTURE, _local_2.zoneID, null);
            this.SetData();
            this.DisplayNextItem();
        }

        private function PayQuest(_arg_1:MouseEvent):void
        {
            var _local_2:dQuestElementVO = (this.getDisplayedQuest() as dQuestElementVO);
            this.mGI.mQuestClientCallbacks.InitiatePayForQuestFinish(_local_2.mUniqueID);
            _local_2.SetQuestMode(QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH);
            this.DisplayQuest(_local_2);
        }

        private function DisplayAdventure(_arg_1:dAdventureClientInfoVO):void
        {
            this.hideAllButtons();
            this.mCurrentAdventure = _arg_1;
            this.mPanel.guildQuestProgressContainer.visible = false;
            this.mPanel.triggerContainer.visible = true;
            this.SetDetailsBackground(false);
            this.mPanel.questNPC.source = gAssetManager.GetNPCUrl("quest_no_character01.png");
            this.mPanel.questHeadline.text = this.mLM.GetText(LOCA_GROUP.ADVENTURE_NAME, _arg_1.adventureName);
            this.mPanel.description.text = this.mLM.GetText(LOCA_GROUP.ADVENTURE_OPENER, _arg_1.adventureName);
            this.mPanel.triggerCanvas.visible = false;
            this.mPanel.adventureTextContainer.visible = true;
            this.mPanel.adventureText.text = this.mLM.GetText(LOCA_GROUP.ADVENTURE_TODO, _arg_1.adventureName);
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName);
            this.mPanel.rewardInfo.visible = false;
            this.mPanel.adventureOptions.visible = true;
            this.mPanel.btnSendArmy.label = this.mLM.GetText(LOCA_GROUP.LABELS, (((this.mGI.mCurrentPlayer.mIsAdventureZone) && (_arg_1.zoneID == this.mGI.mCurrentViewedZoneID)) ? "SendArmyBack" : "SendArmy"));
            this.mPanel.btnCancelExpedition.includeInLayout = (this.mPanel.btnCancelExpedition.visible = _local_2.IsColony());
            this.mPanel.btnCancelExpedition.enabled = ((_arg_1.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) || (_arg_1.colonyStatus == cColony.STATUS_READY_FOR_DEFENSE_MODE));
            if (((_local_2.IsPreventTravel()) || (cColony.IsWaitForAssignmentState(_arg_1.colonyStatus))))
            {
                this.mPanel.btnSendArmy.enabled = false;
                this.mPanel.btnSendArmy.toolTip = this.mLM.GetText(LOCA_GROUP.LABELS, "AdventurePreventsSendArmy");
            }
            else
            {
                this.mPanel.btnSendArmy.enabled = true;
                this.mPanel.btnSendArmy.toolTip = null;
            };
            this.mPanel.btnVisit.enabled = (!(this.mGI.mCurrentViewedZoneID == _arg_1.zoneID));
            this.mPanel.btnInvite.visible = (!(_local_2.mMaxPlayers == 1));
            this.mPanel.btnInvite.enabled = true;
            this.mBtnCancelAdventure.enabled = (((_arg_1.collectedTime < cAdventure.GetAdventureDuration(this.mGI, _local_2, (TimeUtil.getServerTime() - _arg_1.collectedTime), _arg_1.totalDuration)) && (_arg_1.status < cAdventure.STATUS_FINISHED_WON)) && (!((_local_2.IsColony()) && (_arg_1.colonyStatus == cColony.STATUS_WAIT_FOR_ASSIGNMENT))));
            this.mBtnCancelAdventure.includeInLayout = (this.mBtnCancelAdventure.visible = ((!(_local_2.IsColony())) && (this.mGI.mCurrentPlayer.GetHomeZoneId() == _arg_1.ownerPlayerID)));
            this.mBtnLeaveAdventure.enabled = (((!(this.mGI.mCurrentPlayer.GetHomeZoneId() == _arg_1.ownerPlayerID)) && (_arg_1.status < cAdventure.STATUS_FINISHED_WON)) && (!((_local_2.IsColony()) && (_arg_1.colonyStatus == cColony.STATUS_WAIT_FOR_ASSIGNMENT))));
            this.mBtnLeaveAdventure.includeInLayout = (this.mBtnLeaveAdventure.visible = ((!(_local_2.IsColony())) && (!(this.mGI.mCurrentPlayer.GetHomeZoneId() == _arg_1.ownerPlayerID))));
            this.mBtnCloseQuest.includeInLayout = (this.mBtnCloseQuest.visible = false);
            this.mBtnCloseBook.includeInLayout = (this.mBtnCloseBook.visible = true);
            this.mPanel.effects.visible = false;
            this.mPanel.questionmark.visible = false;
        }

        private function RemoveQuest(_arg_1:Boolean):void
        {
            var _local_3:dQuestElementVO;
            var _local_4:Boolean;
            if (((_arg_1) && (!(this.mCanceledQuest.mQuestDefinition.connectedToQuest_string == ""))))
            {
                for each (_local_3 in this.mQuestPool.GetQuest_vector())
                {
                    if (_local_3.mQuestDefinition.questName_string == this.mCanceledQuest.mQuestDefinition.connectedToQuest_string)
                    {
                        this.mCanceledQuest = _local_3;
                        break;
                    };
                };
            };
            var _local_2:dQuestElementVO;
            for each (_local_3 in this.mQuestPool.GetQuest_vector())
            {
                if (((_local_3.mQuestDefinition.connectedToQuest_string == this.mCanceledQuest.mQuestDefinition.questName_string) && ((!(this.mCanceledQuest.mQuestDefinition.specialType_string == QuestManagerStatic.SPECIAL_TYPE_GUILD_QUEST)) || (_local_3.GetRandomPosition() == this.mCanceledQuest.mUniqueID.uniqueID1))))
                {
                    _local_3.SetQuestMode(QuestManagerStatic.QUEST_MODE_DEACTIVATED);
                    _local_2 = _local_3;
                };
            };
            _local_4 = this.mCanceledQuest.isFailed();
            this.mCanceledQuest.SetQuestMode(QuestManagerStatic.QUEST_MODE_DEACTIVATED);
            if (((!(_local_2 == null)) && (QuestManagerStatic.IsPartialGuildQuest(_local_2.mQuestDefinition))))
            {
                this.mCanceledQuest = _local_2;
            };
            if (_local_4)
            {
                this.mGI.mQuestClientCallbacks.RemoveFailedQuest(this.mCanceledQuest.mUniqueID);
            }
            else
            {
                this.mGI.mQuestClientCallbacks.CancelQuest(this.mCanceledQuest.mUniqueID);
            };
            this.mCanceledQuest.SetQuestMode(QuestManagerStatic.QUEST_MODE_DEACTIVATED);
            this.SetData();
            this.DisplayNextItem();
        }

        private function ConfirmLeavelAdventure(_arg_1:MouseEvent):void
        {
            var _local_2:String = (this.mPanel.list.selectedItem as dAdventureClientInfoVO).adventureName;
            CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ConfirmLeaveAdventure", [_local_2]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmLeaveAdventure"), (Alert.OK | Alert.CANCEL), null, this.LeaveAdventure, null, 4, false);
        }

        private function Visit(_arg_1:MouseEvent):void
        {
            this.mGI.visitZone((this.mPanel.list.selectedItem as dAdventureClientInfoVO).zoneID);
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        private function ConfirmCancelQuest(_arg_1:ItemClickEvent):void
        {
            this.mCanceledQuest = _arg_1.item;
            var _local_2:String = ("ConfirmCancelQuest" + ((this.mCanceledQuest.mQuestDefinition.connectedToQuest_string != "") ? "Chain" : ""));
            CustomAlert.show(_local_2, _local_2, (Alert.OK | Alert.CANCEL), null, this.CancelQuest);
        }

        private function CloseQuestCallback(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.CloseQuestImpl();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.list.addEventListener(ItemClickEvent.ITEM_CLICK, this.ItemClickedHandler);
            this.mPanel.list.addEventListener(TrackMissionEvent.TRACK_MISSION, this.TrackMission);
            this.mPanel.list.addEventListener("cancelQuest", this.ConfirmCancelQuest);
            this.mPanel.list.addEventListener("cancelAllQuests", this.ConfirmCancelAllQuestsByType);
            this.mPanel.btnInstantFinish.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateInstantFinishTip);
            this.mPanel.btnInstantFinish.addEventListener(MouseEvent.CLICK, this.InstantFinish);
            this.mPanel.btnPayQuest.addEventListener(MouseEvent.CLICK, this.PayQuest);
            this.mPanel.btnCloseQuest.addEventListener(MouseEvent.CLICK, this.CloseQuest);
            this.mPanel.btnCloseFailedQuest.addEventListener(MouseEvent.CLICK, this.CloseQuest);
            this.mPanel.btnCloseBook.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnCancelAdventure.addEventListener(MouseEvent.CLICK, this.ConfirmCancelAdventure);
            this.mPanel.btnLeaveAdventure.addEventListener(MouseEvent.CLICK, this.ConfirmLeavelAdventure);
            this.mPanel.effects.addEventListener(MouseEvent.CLICK, this.ShowEffects);
            this.mPanel.questionmark.addEventListener(MouseEvent.CLICK, this.ShowHelp);
            this.mPanel.btnShowDetails.addEventListener(MouseEvent.CLICK, this.ShowAdventureDetails);
            this.mPanel.btnInvite.addEventListener(MouseEvent.CLICK, this.ShowAdventureDetails);
            this.mPanel.btnSendArmy.addEventListener(MouseEvent.CLICK, this.SendArmy);
            this.mPanel.btnVisit.addEventListener(MouseEvent.CLICK, this.Visit);
            this.mPanel.btnCancelExpedition.addEventListener(MouseEvent.CLICK, this.cancelExpedition);
            this.mBtnInstantFinish = this.mPanel.btnInstantFinish;
            this.mBtnPayQuest = this.mPanel.btnPayQuest;
            this.mBtnCloseQuest = this.mPanel.btnCloseQuest;
            this.mBtnCloseFailedQuest = this.mPanel.btnCloseFailedQuest;
            this.mBtnCloseBook = this.mPanel.btnCloseBook;
            this.mBtnCancelAdventure = this.mPanel.btnCancelAdventure;
            this.mBtnLeaveAdventure = this.mPanel.btnLeaveAdventure;
            this.hideAllButtons();
        }

        private function ShowAdventureDetails(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mAdventurePanel.SetData((this.mPanel.list.selectedItem as dAdventureClientInfoVO));
            globalFlash.gui.mAdventurePanel.Show();
        }

        private function ShowItem(_arg_1:Object):void
        {
            this.mPanel.list.selectedItem = _arg_1;
            if ((_arg_1 is dQuestElementVO))
            {
                this.DisplayQuest((_arg_1 as dQuestElementVO));
            }
            else
            {
                if ((_arg_1 is dAdventureClientInfoVO))
                {
                    this.DisplayAdventure((_arg_1 as dAdventureClientInfoVO));
                }
                else
                {
                    this.Clear();
                };
            };
        }

        private function TrackMission(_arg_1:TrackMissionEvent):void
        {
            var _local_2:dAdventureClientInfoVO;
            var _local_3:dQuestElementVO;
            if ((_arg_1.item is dAdventureClientInfoVO))
            {
                _local_2 = (_arg_1.item as dAdventureClientInfoVO);
                _local_2.isTrackedMission = _arg_1.track;
            }
            else
            {
                if ((_arg_1.item is dQuestElementVO))
                {
                    _local_3 = (_arg_1.item as dQuestElementVO);
                    _local_3.mIsTrackedMission = _arg_1.track;
                    if (_arg_1.track)
                    {
                        global.ui.mQuestClientCallbacks.InitiateWindowOpen("TrackQuest");
                        global.getApplication().inputNotifier.notifyClick("TrackQuest");
                    };
                };
            };
            this.mTrackingChanged = true;
            globalFlash.gui.mTrackedMissionList.Refresh();
            this.SetData();
        }

        private function DisplayQuest(_arg_1:dQuestElementVO):void
        {
            var _local_4:int;
            var _local_7:Object;
            var _local_8:Object;
            var _local_9:dQuestDefinitionTriggerVO;
            var _local_10:String;
            var _local_11:Boolean;
            var _local_12:Object;
            var _local_13:int;
            var _local_14:QuestTriggerFactory;
            var _local_15:int;
            var _local_16:int;
            var _local_17:dQuestDefinitionTriggerVO;
            var _local_18:dQuestTriggerVO;
            var _local_19:int;
            var _local_20:int;
            var _local_21:TriggerVO;
            var _local_22:Trigger;
            var _local_23:TriggerVO;
            var _local_24:Trigger;
            var _local_25:TriggerVO;
            var _local_26:dQuestDefinitionVO;
            var _local_27:ArrayCollection;
            var _local_28:Number;
            var _local_29:int;
            var _local_30:Number;
            var _local_31:dQuestDefinitionRewardVO;
            var _local_32:dQuestDefinitionRewardVO;
            var _local_33:dQuestDefinitionRewardVO;
            var _local_34:dQuestDefinitionRewardVO;
            var _local_35:EffectVO;
            if (!this.mPanel.initialized)
            {
                return;
            };
            if (this.IsVisible())
            {
                if (((!(this.mPreselectedQuest == null)) && (_arg_1.mUniqueID.eq(this.mPreselectedQuest.mUniqueID))))
                {
                    this.setDisplayedQuest(_arg_1);
                    this.mPreselectedQuest = null;
                };
                if (((!(this.mNotificationQuest == null)) && (_arg_1.mUniqueID.eq(this.mNotificationQuest.mUniqueID))))
                {
                    this.setDisplayedQuest(_arg_1);
                    this.mNotificationQuest = null;
                    gHintManager.HideQuestNotification();
                };
            };
            if (((_arg_1.mQuestDefinition.type_string == "Guild") && (this.mGI.GetCurrentPlayerGuild() == null)))
            {
                this.DisplayNextItem();
                return;
            };
            if (_arg_1.mQuestDefinition.npc_string != null)
            {
                this.mPanel.questNPC.source = gAssetManager.GetNPCUrl(_arg_1.mQuestDefinition.npc_string);
            };
            var _local_2:Boolean = QuestManagerStatic.IsPartialGuildQuest(_arg_1.mQuestDefinition);
            var _local_3:Boolean = ((_local_2) && (_arg_1.mQuestDefinition.specialType_string == QuestManagerStatic.SPECIAL_TYPE_LAST_QUEST));
            switch (_arg_1.mQuestMode)
            {
                case QuestManagerStatic.QUEST_MODE_DEACTIVATED:
                case QuestManagerStatic.QUEST_MODE_REWARD_COLLECTED_IDLE:
                case QuestManagerStatic.QUEST_MODE_LOOP_UNTIL_QUEST_REWARD_COULD_BE_ASSIGNED:
                case QuestManagerStatic.QUEST_MODE_PRESS_REWARD_BUTTON:
                case QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE:
                case 21:
                case 22:
                case 23:
                case 24:
                case 25:
                case 26:
                case 27:
                case 28:
                case 29:
                case 30:
                case 31:
                case 32:
                    _local_4 = MODE_FINISHED;
                    break;
                case QuestManagerStatic.QUEST_MODE_PENDING_NEXT_RANDOM_DAILY_QUEST:
                    _local_4 = MODE_PREVIEW;
                    break;
                case QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH:
                    if (_local_3)
                    {
                        _local_4 = MODE_FINISHED;
                    }
                    else
                    {
                        _local_4 = MODE_RUNNING;
                    };
                    break;
                default:
                    _local_4 = MODE_RUNNING;
            };
            this.mPanel.triggerCanvas.visible = true;
            this.mPanel.triggerContainer.visible = true;
            this.mPanel.adventureTextContainer.visible = false;
            this.mPanel.guildQuestProgressContainer.visible = false;
            this.mPanel.donationProgressContainer.visible = false;
            var _local_5:ArrayCollection = new ArrayCollection();
            var _local_6:Boolean;
            if (_arg_1.mQuestDefinition.specialType_string == QuestManagerStatic.SPECIAL_TYPE_GUILD_QUEST)
            {
                _local_8 = null;
                if (_arg_1.mQuestDefinition.questTriggers_vector.length == 0)
                {
                    _local_8 = this.mGI.mQuestClientCallbacks.GetGuildQuestTriggerData(_arg_1.mUniqueID.uniqueID1);
                }
                else
                {
                    _local_9 = _arg_1.mQuestDefinition.questTriggers_vector[0];
                    _local_8 = this.mGI.mQuestClientCallbacks.GetGuildQuestTriggerData(_arg_1.mUniqueID.uniqueID1);
                };
                _local_8.isLegacyTrigger = true;
                _local_5.addItem(_local_8);
                if (_local_8.trigger.status == 1)
                {
                    _local_4 = MODE_FINISHED;
                };
                this.mPanel.triggerContainer.visible = false;
                this.mPanel.guildQuestProgressContainer.visible = true;
                this.mPanel.guildQuestProgressContainer.data = _local_8;
            }
            else
            {
                this.mPanel.guildQuestProgressContainer.visible = false;
                _local_11 = false;
                _local_12 = new Object();
                _local_13 = 0;
                while (_local_13 < _arg_1.mQuestDefinition.questTriggers_vector.length)
                {
                    _local_17 = _arg_1.mQuestDefinition.questTriggers_vector[_local_13];
                    _local_18 = _arg_1.mQuestTriggersFinished_vector[_local_13];
                    if (_local_17.type != QuestManagerStatic.TYPE_NEW_QUEST_TRIGGER)
                    {
                        if (_local_17.type == QuestManagerStatic.TYPE_PAY_FOR_QUEST_FINISH)
                        {
                            _local_6 = true;
                        };
                        if (_local_17.type == QuestManagerStatic.TYPE_QUEST_COMPLETE)
                        {
                            _local_10 = _arg_1.mQuestDefinition.questName_string;
                            if (!_local_12[_local_17.name_string])
                            {
                                _local_12[_local_17.name_string] = this.mQuestPool.GetQuestFromName(_local_17.name_string);
                            };
                            _local_11 = (!(_local_12[_local_17.name_string] == null));
                        };
                        _local_19 = this.mGI.mQuestClientCallbacks.GetRemainingValuesForQuestTrigger(this.mGI.mCurrentPlayer, _arg_1, _local_13);
                        _local_20 = this.mGI.mQuestClientCallbacks.GetTotalValuesForQuestTrigger(this.mGI.mCurrentPlayer, _arg_1, _local_13);
                        _local_8 = {
                            "isLegacyTrigger":true,
                            "definition":_local_17,
                            "trigger":_local_18,
                            "remaining":_local_19,
                            "total":_local_20,
                            "questAvailable":_local_11
                        };
                        _local_5.addItem(_local_8);
                    };
                    _local_13++;
                };
                _local_14 = new QuestTriggerFactory(this.mGI, _arg_1);
                _local_15 = 0;
                while (_local_15 < _arg_1.mQuestDefinition.endConditions_vector.length)
                {
                    _local_21 = (_arg_1.mQuestDefinition.endConditions_vector.getItemAt(_local_15) as TriggerVO);
                    _local_22 = _local_14.createTrigger(_local_21, null);
                    _local_22.check();
                    _local_11 = false;
                    if (_local_21.action_string == TRIGGER_ACTION.ACTION_QUEST_COMPLETE_string)
                    {
                        if (!_local_12[_local_21.item_string])
                        {
                            _local_12[_local_21.item_string] = this.mQuestPool.GetQuestFromName(_local_21.item_string);
                        };
                        _local_11 = (!(_local_12[_local_21.item_string] == null));
                    };
                    _local_8 = {
                        "isLegacyTrigger":false,
                        "trigger":_local_21,
                        "remaining":global.ui.mQuestClientCallbacks.getNewTriggerRemaining(_local_22),
                        "total":global.ui.mQuestClientCallbacks.getNewTriggerTotal(_local_21),
                        "questAvailable":_local_11,
                        "loca":global.ui.mQuestClientCallbacks.getNewTriggerText(_local_21, _local_22),
                        "oldTriggerDefinition":_arg_1.mQuestDefinition.questTriggers_vector[_local_22.getDefinition().triggerIdx]
                    };
                    _local_5.addItem(_local_8);
                    _local_22.dispose();
                    _local_15++;
                };
                _local_16 = 0;
                while (_local_16 < _arg_1.mQuestDefinition.failConditions_vector.length)
                {
                    _local_23 = (_arg_1.mQuestDefinition.failConditions_vector.getItemAt(_local_16) as TriggerVO);
                    _local_24 = _local_14.createTrigger(_local_23, null);
                    _local_24.check();
                    _local_11 = false;
                    if (_local_23.action_string == TRIGGER_ACTION.ACTION_QUEST_COMPLETE_string)
                    {
                        if (!_local_12[_local_23.item_string])
                        {
                            _local_12[_local_23.item_string] = this.mQuestPool.GetQuestFromName(_local_23.item_string);
                        };
                        _local_11 = (!(_local_12[_local_23.item_string] == null));
                    };
                    _local_8 = {
                        "isLegacyTrigger":false,
                        "trigger":_local_23,
                        "remaining":global.ui.mQuestClientCallbacks.getNewTriggerRemaining(_local_24),
                        "total":global.ui.mQuestClientCallbacks.getNewTriggerTotal(_local_23),
                        "questAvailable":_local_11,
                        "loca":global.ui.mQuestClientCallbacks.getNewTriggerText(_local_23, _local_24),
                        "oldTriggerDefinition":_arg_1.mQuestDefinition.questTriggers_vector[_local_24.getDefinition().triggerIdx]
                    };
                    _local_5.addItem(_local_8);
                    _local_24.dispose();
                    _local_16++;
                };
            };
            for each (_local_7 in _local_5)
            {
                _local_25 = (_local_7.trigger as TriggerVO);
                if ((((_local_25) && (_local_25.action_string == GlobalDonationTrigger.XML_string)) && (!(_local_25.isFailTrigger))))
                {
                    this.mPanel.triggerContainer.visible = false;
                    this.mPanel.donationProgressContainer.visible = true;
                    this.mPanel.donationProgressContainer.data = _local_25;
                    break;
                };
            };
            if (!this.mPanel.donationProgressContainer.visible)
            {
                this.mPanel.triggers.dataProvider = _local_5;
                this.mPanel.triggers.height = (Math.ceil((_local_5.length / 2)) * 81);
            };
            this.SetDetailsBackground((_local_4 == MODE_FINISHED));
            this.mPanel.questHeadline.text = this.mLM.GetText(LOCA_GROUP.QUEST_LABELS, _arg_1.getQuestName_string());
            if (_local_4 == MODE_FINISHED)
            {
                this.mPanel.description.text = this.mLM.GetText(LOCA_GROUP.QUEST_REWARD_DESCRIPTIONS, _arg_1.getQuestName_string());
            }
            else
            {
                this.mPanel.description.text = this.mLM.GetText(LOCA_GROUP.QUEST_START_DESCRIPTIONS, _arg_1.getQuestName_string());
            };
            this.mPanel.rewardInfo.visible = true;
            this.mPanel.adventureOptions.visible = false;
            if (((((!(_local_4 == MODE_FINISHED)) || (_arg_1.mQuestMode == QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE)) || (_arg_1.mQuestDefinition.specialType_string == QuestManagerStatic.SPECIAL_TYPE_GUILD_QUEST)) && (!(_local_3))))
            {
                _local_27 = new ArrayCollection();
                if (_arg_1.mQuestDefinition.specialType_string == QuestManagerStatic.SPECIAL_TYPE_GUILD_QUEST)
                {
                    _local_26 = (_arg_1.mOtherQuestDefinition_vector.getItemAt(0) as dQuestDefinitionVO);
                    _local_28 = (1 - (_local_5.getItemAt(0).remaining / _local_5.getItemAt(0).total));
                    _local_29 = Math.min(Math.max(this.mGI.mQuestClientCallbacks.GetGuildQuestTriggerData(_arg_1.mUniqueID.uniqueID1).total, 10), 100);
                    _local_30 = global.guildQuestRewardModifierPerSize[_local_29];
                    if (_local_28 > 0)
                    {
                        for each (_local_31 in _local_26.questReward)
                        {
                            _local_33 = _local_31.Clone();
                            _local_33.amount = Math.max(Math.ceil(((_local_31.amount * _local_30) * _local_28)), 0);
                            _local_27.addItem(_local_33);
                        };
                        for each (_local_32 in _local_26.postEffects_vector)
                        {
                            _local_34 = _local_32.Clone();
                            _local_34.amount = Math.max(Math.ceil(((_local_32.amount * _local_30) * _local_28)), 1);
                            _local_27.addItem(_local_34);
                        };
                    };
                }
                else
                {
                    _local_26 = _arg_1.mQuestDefinition;
                    _local_27.addAll(_local_26.questReward);
                    for each (_local_35 in _local_26.postEffects_vector)
                    {
                        if ((((_local_35.effect_string == Reward.XML_string) || (_local_35.effect_string == FulfillCondition.XML_string)) || (_local_35.effect_string == GiveCollectibleResource.XML_string)))
                        {
                            _local_27.addItem(_local_35);
                        };
                    };
                };
                this.mPanel.rewards.dataProvider = _local_27;
                this.mPanel.rewards.setFailedIndicatorVisible((_arg_1.GetQuestMode() == QuestManagerStatic.QUEST_MODE_QUEST_FAILED));
            }
            else
            {
                this.mPanel.rewards.dataProvider = null;
            };
            this.hideAllButtons();
            if ((((_local_4 == MODE_RUNNING) && (!(_arg_1.mQuestMode == QuestManagerStatic.QUEST_MODE_QUEST_FAILED))) && (!(_arg_1.mQuestMode == QuestManagerStatic.QUEST_MODE_WAIT_FOR_FINISH))))
            {
                if (_arg_1.mQuestDefinition.questWinGemCosts > 0)
                {
                    this.mBtnInstantFinish.enabled = (!(_arg_1.instantFinishInProgress));
                    this.mBtnInstantFinish.includeInLayout = (this.mBtnInstantFinish.visible = true);
                };
                if (_local_6)
                {
                    this.mBtnPayQuest.enabled = QuestManagerStatic.IsQuestReadyForSubmit(_arg_1, true);
                    this.mBtnPayQuest.includeInLayout = (this.mBtnPayQuest.visible = true);
                };
            };
            if (_arg_1.mQuestMode == QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE)
            {
                this.mBtnCloseQuest.enabled = true;
                this.mBtnCloseQuest.includeInLayout = (this.mBtnCloseQuest.visible = true);
            }
            else
            {
                if (_arg_1.mQuestMode == QuestManagerStatic.QUEST_MODE_QUEST_FAILED)
                {
                    this.mBtnCloseFailedQuest.enabled = true;
                    this.mBtnCloseFailedQuest.includeInLayout = (this.mBtnCloseFailedQuest.visible = true);
                };
            };
            this.mBtnCloseBook.includeInLayout = (this.mBtnCloseBook.visible = true);
            this.mPanel.effects.visible = false;
            this.mPanel.questionmark.visible = ((!(_arg_1.mQuestDefinition.helpName_string == "")) || (_arg_1.mQuestDefinition.linkEventWindow));
            if (((this.mPanel.visible) && (_arg_1.mQuestMode == QuestManagerStatic.QUEST_MODE_START_WINDOW_DESCRIPTION_WAIT_FOR_BUTTON_PRESSED)))
            {
                this.ShowEffects(null);
                this.mGI.mQuestClientCallbacks.QuestOkButtonPressedFromGui(_arg_1);
            }
            else
            {
                if (((_local_4 == MODE_FINISHED) && (!(_arg_1.mQuestMode == QuestManagerStatic.QUEST_MODE_REWARD_WINDOW_WAIT_FOR_BUTTON_ACTIVE))))
                {
                    cSoundManager.getInstance().playEffect("BuffPlace");
                    this.mPanel.sparkleAnim.visible = true;
                };
            };
        }

        private function DisplayNextItem():void
        {
            var _local_2:QuestListGroupItemRenderer;
            var _local_3:QuestListItemRenderer;
            var _local_1:Object;
            for each (_local_2 in this.mPanel.list.getChildren())
            {
                for each (_local_3 in _local_2.list.getChildren())
                {
                    if (_local_3.data != this.mPanel.list.selectedItem)
                    {
                        _local_1 = _local_3.data;
                        break;
                    };
                };
                if (_local_1) break;
            };
            this.ShowItem(_local_1);
        }

        private function CloseQuest(_arg_1:MouseEvent):void
        {
            this.mCurrentQuest = (this.getDisplayedQuest() as dQuestElementVO);
            if (this.mCurrentQuest.isFailed())
            {
                this.mCanceledQuest = this.mCurrentQuest;
                this.RemoveQuest(true);
            }
            else
            {
                if (((this.mGI.IsAdventureZone()) && (!(this.mCurrentQuest.GetQuestDefinition().specialType_string.indexOf(QuestManagerStatic.SPECIAL_TYPE_LAST_QUEST) == -1))))
                {
                    CustomAlert.show("ConfirmFinishAdventure", "ConfirmFinishAdventure", (Alert.OK | Alert.CANCEL), null, this.CloseQuestCallback, null, Alert.OK, true, CustomAlert.STYLE_DEFAULT);
                }
                else
                {
                    this.CloseQuestImpl();
                };
            };
        }

        private function SetDetailsBackground(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mPanel.questWonBg.visible = true;
                this.mPanel.backgroundFooter.styleName = "questPanelFooterReward";
                this.mPanel.descBG.visible = false;
                this.mPanel.description.setStyle("color", "#000000");
                this.mPanel.triggerHeadBG.visible = false;
                this.mPanel.triggerHeadLabel.text = this.mLM.GetText(LOCA_GROUP.LABELS, "FinishedTasks");
                this.mPanel.triggerHeadLabel.setStyle("color", "#000000");
                this.mPanel.triggerBG.visible = false;
                this.mPanel.rewardHeadLabel.setStyle("color", "#000000");
            }
            else
            {
                this.mPanel.questWonBg.visible = false;
                this.mPanel.backgroundFooter.styleName = "questPanelFooter";
                this.mPanel.descBG.visible = true;
                this.mPanel.description.setStyle("color", "#FFFFFF");
                this.mPanel.triggerHeadBG.visible = true;
                this.mPanel.triggerHeadLabel.text = this.mLM.GetText(LOCA_GROUP.LABELS, "Tasks");
                this.mPanel.triggerHeadLabel.setStyle("color", "#FFFFFF");
                this.mPanel.triggerBG.visible = true;
                this.mPanel.rewardHeadLabel.setStyle("color", "#FFFFFF");
            };
            this.mPanel.donationProgressContainer.finished = _arg_1;
        }

        private function CancelQuest(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                this.RemoveQuest(true);
            };
        }

        private function CreateInstantFinishTip(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.INSTANT_BUILD_string, _arg_1, this.getDisplayedQuest().mQuestDefinition.questWinGemCosts);
        }

        private function SendArmy(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mSpecialistTravelPanel.SetData((this.mPanel.list.selectedItem as dAdventureClientInfoVO).zoneID);
            globalFlash.gui.mSpecialistTravelPanel.Show();
        }

        private function getDisplayedQuest():dQuestElementVO
        {
            if ((this.mPanel.list.selectedItem as dQuestElementVO) == null)
            {
                return (this.mDisplayedQuest);
            };
            return (this.mPanel.list.selectedItem as dQuestElementVO);
        }

        private function ConfirmCancelAdventure(_arg_1:MouseEvent):void
        {
            var _local_2:String = (this.mPanel.list.selectedItem as dAdventureClientInfoVO).adventureName;
            var _local_3:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_local_2);
            var _local_4:Boolean = _local_3.IsRecurring();
            if (_local_3.IsTrainingExpedition())
            {
                CustomAlert.show(this.mLM.GetText(LOCA_GROUP.ALERT_MESSAGES, ((_local_4) ? "ConfirmCancelRecurringArchipelago" : "ConfirmCancelArchipelago"), [_local_2]), this.mLM.GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmCancelAdventure"), (Alert.OK | Alert.CANCEL), null, this.CancelAdventure, null, 4, false);
            }
            else
            {
                CustomAlert.show(this.mLM.GetText(LOCA_GROUP.ALERT_MESSAGES, ((_local_4) ? "ConfirmCancelRecurringAdventure" : "ConfirmCancelAdventure"), [_local_2]), this.mLM.GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmCancelAdventure"), (Alert.OK | Alert.CANCEL), null, this.CancelAdventure, null, 4, false);
            };
        }

        private function ShowHelp(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            if (this.mPanel.list.selectedItem != null)
            {
                if ((this.mPanel.list.selectedItem as dQuestElementVO).mQuestDefinition.linkEventWindow)
                {
                    globalFlash.gui.mEventWindow.Show();
                }
                else
                {
                    _local_2 = (this.mPanel.list.selectedItem as dQuestElementVO).mQuestDefinition.helpName_string;
                    if (_local_2 != "")
                    {
                        globalFlash.gui.mHelpOverview.ShowItem(global.map_HelpName_HelpDefinition[_local_2], 1);
                        globalFlash.gui.mHelpOverview.Show();
                    };
                };
            };
        }


    }
}
