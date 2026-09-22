package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import __AS3__.vec.Vector;
    import GUI.Components.ItemRenderer.FriendsListMenuItemRenderer;
    import Communication.VO.dPlayerListItemVO;
    import GUI.Components.FriendsListMenu;
    import GUI.Components.CustomAlert;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.controls.Alert;
    import flash.events.MouseEvent;
    import Achievements.IAchievementTreeNode;
    import Enums.COMMAND;
    import Communication.VO.dIntegerVO;
    import GUI.ApplicationFacade;
    import Achievements.AchievementConsts;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.dContextItemVO;
    import Communication.VO.ColonyCommandVO;
    import mx.events.CloseEvent;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import mx.core.Application;
    import Communication.VO.Guild.dGuildPlayerListItemVO;
    import Communication.VO.dPartnerSettingsVO;
    import Colony.cColony;
    import AdventureSystem.cAdventure;
    import com.bluebyte.tso.util.TimeUtil;
    import Enums.KILL_SWITCH;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import Tracks.TrackManager;
    import mx.events.ResizeEvent;
    import flash.desktop.NativeApplication;
    import __AS3__.vec.*;

    public class cFriendsListMenu extends cGuiBaseElement 
    {

        private const GUILD_MEMBER:int = 2;
        private const ADD_FRIEND:int = 5;
        private const FRIEND:int = 1;
        private const EVENT_ZONE:int = 4;
        private const OWN_PLAYER:int = 0;
        private const FOREIGNER:int = 3;

        private var mGI:cGameInterface;
        private var mRendererPool:Vector.<FriendsListMenuItemRenderer>;
        private var mPlayer:dPlayerListItemVO;
        private var mPlayerStatus:int;
        protected var mMenu:FriendsListMenu;


        private function ConfirmRemoveFriend(_arg_1:MouseEvent):void
        {
            CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ConfirmRemoveFriend", [this.mPlayer.username]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmRemoveFriend"), (Alert.OK | Alert.CANCEL), null, this.RemoveFriend, null, 4, false);
        }

        private function CompareAchievements(_arg_1:MouseEvent):void
        {
            var _local_2:IAchievementTreeNode = this.mGI.getComparedUserTree(this.mPlayer.id);
            if (_local_2 == null)
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.GET_COMPARED_USER_ACHIEVEMENTS, this.mGI.mCurrentPlayer.GetHomeZoneId(), new dIntegerVO(this.mPlayer.id));
            };
            globalFlash.gui.mAchievementPanel.setComparedUserItemVO(this.mPlayer);
            ApplicationFacade.sendNotification(AchievementConsts.SHOW_HIDE_ACHIEVEMENT_PANEL, _local_2, AchievementConsts.COMPARE_MODE);
        }

        private function ConfirmCancelPvPColony(_arg_1:MouseEvent):void
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(this.mPlayer.adventureVO.adventureName);
            CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, ((_local_2.IsRecurring()) ? "ConfirmCancelRecurringArchipelago" : "ConfirmCancelArchipelago"), [this.mPlayer.adventureVO.adventureName]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmCancelArchipelago"), (Alert.OK | Alert.CANCEL), null, this.CancelPvPColony, null, 4, false);
        }

        public function SetContextMenu(_arg_1:Vector.<dContextItemVO>):void
        {
            var _local_2:dContextItemVO;
            this.mMenu.removeAllChildren();
            for each (_local_2 in _arg_1)
            {
                this.AddMenuItem(_local_2.key_string, _local_2.enabled, _local_2.callback, _local_2.tooltip_string, _local_2.labelParams, _local_2.over, _local_2.out, _local_2.locaGroup);
            };
        }

        private function AddFriend(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mFriendsList.AddFriend(this.mPlayer);
        }

        private function RemoveColonyFromColoniesCloseHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.YES)
            {
                return;
            };
            var _local_2:ColonyCommandVO = ColonyCommandVO.Create(COMMAND.COLONY_REMOVE, this.mPlayer.adventureVO.colonyID);
            global.ui.SendServerActionSimple(COMMAND.COLONY_REMOVE, _local_2);
            globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = true;
        }

        private function CancelAdventure(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            AdventureManager.getInstance().removeAdventure(this.mPlayer.id);
            global.ui.mClientMessages.SendMessagetoServer(COMMAND.CANCEL_ADVENTURE, this.mPlayer.id, null);
        }

        override public function Show():void
        {
            this.mMenu.enabled = (!(global.ui.mPacketLost));
            global.getApplication().addEventListener(MouseEvent.CLICK, this.HideMenu);
            super.Show();
            globalFlash.gui.windowController.setTop(mUiElement);
            this.Move(Application.application.mouseX, Application.application.mouseY);
            this.ResizeHandler(null);
        }

        private function IsGuildMemberAllowedForTrade(_arg_1:dPlayerListItemVO):Boolean
        {
            var _local_2:dGuildPlayerListItemVO = globalFlash.gui.mFriendsList.GetGuildMemberById(this.mGI.mCurrentPlayer.GetPlayerId());
            var _local_3:dPlayerListItemVO = globalFlash.gui.mFriendsList.GetGuildMemberById(_arg_1.id);
            if (((_local_2 == null) || (_local_3 == null)))
            {
                return (false);
            };
            var _local_4:Number = (new Date().getTime() - (global.tradeFriendDelay * 1000));
            return ((_local_2.friendSince < _local_4) && (_local_3.friendSince < _local_4));
        }

        public function SetData(_arg_1:dPlayerListItemVO, _arg_2:String=null):void
        {
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_7:Boolean;
            var _local_8:cAdventureDefinition;
            var _local_9:Boolean;
            var _local_10:Boolean;
            var _local_11:String;
            this.mPlayer = _arg_1;
            this.mMenu.removeAllChildren();
            var _local_5:Boolean = this.mGI.isOnHomzone();
            var _local_6:cLocaManager = cLocaManager.GetInstance();
            if (this.mPlayer == null)
            {
                this.mPlayerStatus = this.ADD_FRIEND;
                this.AddMenuItem("AddFriend", true, this.ShowAddFriendPanel);
                if (((defines.FRIEND_INVITE_ENABLED) && (global.partner == "")))
                {
                    this.AddMenuItem("InviteByMail", true, this.Invite);
                }
                else
                {
                    if (((defines.FRIEND_INVITE_ENABLED) && ((global.partnerSettings[global.partner] as dPartnerSettingsVO).hideInviteByMail)))
                    {
                        this.AddMenuItem(("InviteBy" + global.partner), true, this.Invite);
                    };
                };
            }
            else
            {
                if (this.mPlayer.id == this.mGI.mCurrentPlayer.GetPlayerId())
                {
                    this.mPlayerStatus = this.OWN_PLAYER;
                    _local_4 = this.isAdventureTravelAllowed(_arg_1);
                    this.AddMenuItem("ReturnHome", (!(this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mGI.mCurrentViewedZoneID)), this.Visit);
                    this.AddMenuItem("Whisper", false, this.Whisper);
                    this.AddMenuItem("SendMail", false, this.SendMail);
                    this.AddMenuItem("Gift", false, this.Gift);
                    this.AddMenuItem("Trade", false, this.Trade);
                    if (!defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
                    {
                        this.AddMenuItem("CompareAchievements", false, this.CompareAchievements);
                    };
                    this.AddMenuItem("RemoveFriend", false, this.ConfirmRemoveFriend);
                    this.AddMenuItem("SendArmy", ((!(this.mGI.mCurrentViewedZoneID == this.mPlayer.id)) && (_local_4)), this.SendSpecialist, ((_local_4) ? "" : _local_6.GetText(LOCA_GROUP.LABELS, "AdventurePreventsSendArmy")));
                }
                else
                {
                    if (((this.mPlayer.id < 0) || (((!(this.mPlayer.adventureVO == null)) && (this.mPlayer.adventureVO.IsColony())) && (!(this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_WAIT_FOR_ASSIGNMENT)))))
                    {
                        if (this.mGI.mCurrentPlayer.GetHomeZoneId() != this.mGI.mCurrentViewedZoneID)
                        {
                            this.AddMenuItem("ReturnHome", true, this.ReturnHome);
                        };
                        this.mPlayerStatus = this.EVENT_ZONE;
                        _local_8 = cAdventureDefinition.FindAdventureDefinition(this.mPlayer.adventureVO.adventureName);
                        _local_9 = (((((this.mPlayer.adventureVO.status == cAdventure.STATUS_INITIALIZED) && (!(this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_ASSIGNED))) && (!(this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_REMOVED))) && (!(this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK))) || (this.mPlayer.adventureVO.status == cAdventure.STATUS_STARTED));
                        if (((_local_9) && (!((this.mPlayer.adventureVO.IsColony()) && (cColony.IsAssignableState(this.mPlayer.adventureVO.colonyStatus))))))
                        {
                            _local_4 = this.isAdventureTravelAllowed(_arg_1);
                            if (this.mGI.mCurrentViewedZoneID == this.mPlayer.id)
                            {
                                this.AddMenuItem("SendArmyBack", ((((this.mPlayer.adventureVO.collectedTime < cAdventure.GetAdventureDuration(this.mGI, _local_8, (TimeUtil.getServerTime() - this.mPlayer.adventureVO.collectedTime), this.mPlayer.adventureVO.totalDuration)) && (this.mPlayer.adventureVO.status < cAdventure.STATUS_FINISHED_WON)) || ((this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) && (!(this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mPlayer.adventureVO.ownerPlayerID)))) && (_local_4)), this.SendSpecialist);
                            }
                            else
                            {
                                this.AddMenuItem("Visit", (!(this.mGI.mCurrentViewedZoneID == this.mPlayer.id)), this.Visit);
                                this.AddMenuItem("SendArmy", (((this.mPlayer.adventureVO.status < cAdventure.STATUS_FINISHED_WON) || ((this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) && (!(this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mPlayer.adventureVO.ownerPlayerID)))) && (_local_4)), this.SendSpecialist, ((_local_4) ? "" : _local_6.GetText(LOCA_GROUP.LABELS, "AdventurePreventsSendArmy")));
                            };
                        };
                        this.AddMenuItem("ShowAdventureDetails", true, this.ShowAdventureDetails);
                        if ((((!(_local_8.IsColony())) && (!(_local_8.IsExpedition()))) && (!(_local_8.mMaxPlayers == 1))))
                        {
                            this.AddMenuItem("AdventureInvitePlayer", (this.mPlayer.adventureVO.ownerPlayerID == this.mGI.mCurrentPlayer.GetPlayerId()), this.ShowAdventureDetails);
                        };
                        if (_local_9)
                        {
                            if (((!(_local_8.IsColony())) && (!(_local_8.IsTrainingExpedition()))))
                            {
                                if (this.mPlayer.adventureVO.ownerPlayerID == this.mGI.mCurrentPlayer.GetPlayerId())
                                {
                                    this.AddMenuItem("CancelAdventure", true, this.ConfirmCancelAdventure);
                                }
                                else
                                {
                                    this.AddMenuItem("LeaveAdventure", true, this.ConfirmLeaveAdventure);
                                };
                            }
                            else
                            {
                                if (((_local_8.IsTrainingExpedition()) || ((_local_8.IsColony()) && (this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK))))
                                {
                                    this.AddMenuItem("CancelArchipelago", true, this.ConfirmCancelPvPColony);
                                };
                            };
                        };
                        if (_local_8.IsColony())
                        {
                            _local_10 = AdventureManager.getInstance().enoughColonySlots();
                            _local_11 = "";
                            if (!_local_10)
                            {
                                _local_11 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "MakeColonyForbiddenNotEnoughSlots");
                            }
                            else
                            {
                                if (!cColony.IsAssignableState(this.mPlayer.adventureVO.colonyStatus))
                                {
                                    _local_11 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "MakeColonyForbidden");
                                };
                            };
                            if ((((!(_local_9)) && ((this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_ASSIGNED) || (this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK))) || (this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_WAIT_FOR_ASSIGNMENT)))
                            {
                                this.AddMenuItem("AbandonIsland", (this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_ASSIGNED), this.RemoveColonyFromColonies, (((!(this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_ASSIGNED)) && (!(this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_WAIT_FOR_ASSIGNMENT))) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "RemoveColonyForbidden") : ""));
                            };
                        };
                    }
                    else
                    {
                        if ((((!(this.mPlayer.adventureVO == null)) && (this.mPlayer.adventureVO.IsColony())) && (this.mPlayer.adventureVO.colonyStatus == cColony.STATUS_WAIT_FOR_ASSIGNMENT)))
                        {
                            this.AddMenuItem("ShowAdventureDetails", true, this.ShowAdventureDetails);
                            this.AddMenuItem("AbandonIsland", true, this.RemoveColonyFromColonies, "");
                        }
                        else
                        {
                            if (globalFlash.gui.mFriendsList.IsFriend(this.mPlayer))
                            {
                                this.mPlayerStatus = this.FRIEND;
                                this.mPlayer = globalFlash.gui.mFriendsList.GetFriendById(this.mPlayer.id);
                                this.AddMenuItem("Visit", (!(this.mGI.mCurrentViewedZoneID == this.mPlayer.id)), this.Visit);
                                this.AddMenuItem("Whisper", true, this.Whisper);
                                this.AddMenuItem("SendMail", true, this.SendMail);
                                _local_7 = (this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mGI.mCurrentViewedZoneID);
                                this.AddMenuItem("Gift", _local_7, this.Gift, ((_local_7) ? "" : cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GiftDisabledOnForeignIsland")));
                                _local_3 = (((this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mGI.mCurrentViewedZoneID) && ((this.IsFriendAllowedForTrade(this.mPlayer)) || (this.IsGuildMemberAllowedForTrade(this.mPlayer)))) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.FRIEND_TRADE)));
                                this.AddMenuItem("Trade", _local_3, this.Trade, ((_local_3) ? "" : _local_6.GetText(LOCA_GROUP.LABELS, "TradeFriendDelay", [(global.tradeFriendDelay / 3600)])));
                                if (!defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
                                {
                                    this.AddMenuItem("CompareAchievements", _local_5, this.CompareAchievements, ((_local_5) ? "" : _local_6.GetText(LOCA_GROUP.LABELS, "CantCompareAchi")));
                                };
                                this.AddMenuItem("RemoveFriend", true, this.ConfirmRemoveFriend);
                            }
                            else
                            {
                                if (globalFlash.gui.mFriendsList.IsGuildMember(this.mPlayer))
                                {
                                    this.mPlayerStatus = this.GUILD_MEMBER;
                                    this.mPlayer = globalFlash.gui.mFriendsList.GetGuildMemberById(this.mPlayer.id);
                                    this.AddMenuItem("Visit", true, this.Visit);
                                    this.AddMenuItem("Whisper", true, this.Whisper);
                                    this.AddMenuItem("SendMail", true, this.SendMail);
                                    this.AddMenuItem("Gift", true, this.Gift);
                                    _local_3 = (((this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mGI.mCurrentViewedZoneID) && (this.IsGuildMemberAllowedForTrade(this.mPlayer))) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.FRIEND_TRADE)));
                                    this.AddMenuItem("Trade", _local_3, this.Trade, ((_local_3) ? "" : _local_6.GetText(LOCA_GROUP.LABELS, "TradeFriendDelay", [(global.tradeFriendDelay / 3600)])));
                                    if (!defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
                                    {
                                        this.AddMenuItem("CompareAchievements", _local_5, this.CompareAchievements, ((_local_5) ? "" : _local_6.GetText(LOCA_GROUP.LABELS, "CantCompareAchi")));
                                    };
                                }
                                else
                                {
                                    this.mPlayerStatus = this.FOREIGNER;
                                    this.AddMenuItem("Whisper", true, this.Whisper);
                                    this.AddMenuItem("SendMail", (!(this.mPlayer.id == 0)), this.SendMail);
                                    this.AddMenuItem("AddFriend", (!(this.mPlayer.id == 0)), this.AddFriend);
                                };
                            };
                        };
                    };
                };
            };
        }

        public function Invite(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest((global.baseUri + defines.INVITE_URL)), "_blank");
            TrackManager.getInstance().trackExternalFriendInviteCall(global.ui.mCurrentPlayer.getPlayerID());
        }

        private function CancelPvPColony(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            AdventureManager.getInstance().removeAdventure(this.mPlayer.adventureVO.zoneID);
            if (this.mPlayer.adventureVO.colonyID > 0)
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.CANCEL_PVP_COLONY, this.mPlayer.id, null);
            }
            else
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.CANCEL_ADVENTURE, this.mPlayer.id, null);
            };
        }

        private function Visit(_arg_1:MouseEvent):void
        {
            if (defines.CLIENT_EXPERIMENTAL != 0)
            {
                this.mGI.channels.ZONE.send("CLIENT_VISIT_ZONE", this.mPlayer.id);
                return;
            };
            this.mGI.visitZone(this.mPlayer.id);
        }

        public function Init(_arg_1:FriendsListMenu):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mMenu = _arg_1;
            this.mRendererPool = new Vector.<FriendsListMenuItemRenderer>();
            this.mMenu.addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
        }

        public function ShowAddFriendPanel(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mAddFriendsPanel.SetMode(cAddFriendsPanel.ADD_FRIEND);
            globalFlash.gui.mAddFriendsPanel.Show();
        }

        private function AddMenuItem(_arg_1:String, _arg_2:Boolean, _arg_3:Function, _arg_4:String="", _arg_5:Array=null, _arg_6:Function=null, _arg_7:Function=null, _arg_8:String="LAB"):void
        {
            var _local_9:FriendsListMenuItemRenderer;
            if (this.mRendererPool.length > this.mMenu.numChildren)
            {
                _local_9 = this.mRendererPool[this.mMenu.numChildren];
            }
            else
            {
                _local_9 = new FriendsListMenuItemRenderer();
                this.mRendererPool.push(_local_9);
            };
            this.mMenu.addChild(_local_9);
            _local_9.data = new dContextItemVO(_arg_1, _arg_3, _arg_2, _arg_4, _arg_5, null, null, _arg_8);
            this.mMenu.y = (this.mMenu.y - (_local_9.height + 1));
        }

        private function LeaveAdventure(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            AdventureManager.getInstance().removeAdventure(this.mPlayer.id);
            global.ui.mClientMessages.SendMessagetoServer(COMMAND.LEAVE_ADVENTURE, this.mPlayer.id, null);
        }

        private function IsFriendAllowedForTrade(_arg_1:dPlayerListItemVO):Boolean
        {
            var _local_2:dPlayerListItemVO = globalFlash.gui.mFriendsList.GetFriendById(this.mPlayer.id);
            if (_local_2 == null)
            {
                return (false);
            };
            var _local_3:Number = (new Date().getTime() - (global.tradeFriendDelay * 1000));
            return (_local_2.friendSince < _local_3);
        }

        private function MoveExpeditionToColonies(_arg_1:MouseEvent):void
        {
            var _local_2:ColonyCommandVO = ColonyCommandVO.Create(COMMAND.COLONY_ASSIGN, this.mPlayer.adventureVO.zoneID);
            global.ui.SendServerActionSimple(COMMAND.COLONY_ASSIGN, _local_2);
            globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = true;
        }

        private function ShowAdventurePlayers(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mAdventurePanel.SetData(this.mPlayer.adventureVO);
            globalFlash.gui.mAdventurePanel.Show();
        }

        private function Trade(_arg_1:MouseEvent):void
        {
            if (((this.mGI.mCurrentPlayerZone.IsBuildingOnMap(defines.LOGISTICS_NAME_string)) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.FRIEND_TRADE))))
            {
                globalFlash.gui.mTradingPanel.SetData(this.mPlayer);
                globalFlash.gui.mTradingPanel.Show();
            }
            else
            {
                CustomAlert.show("NoTradeWithoutLogistics", "NoTradeWithoutLogistics");
            };
        }

        private function RemoveColonyFromColonies(_arg_1:MouseEvent):void
        {
            CustomAlert.show("AbandonIsland", "AbandonIsland", (Alert.YES | Alert.NO), null, this.RemoveColonyFromColoniesCloseHandler);
        }

        private function isAdventureTravelAllowed(_arg_1:dPlayerListItemVO):Boolean
        {
            if (!_arg_1.adventureVO)
            {
                return (true);
            };
            if (_arg_1.adventureVO.IsColony())
            {
                return ((_arg_1.adventureVO.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) && (!(this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mPlayer.adventureVO.colonyOwnerPlayerId)));
            };
            return (!(cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureVO.adventureName).IsPreventTravel()));
        }

        private function ReturnHome(_arg_1:MouseEvent):void
        {
            if (defines.CLIENT_ZONEID != 0)
            {
                NativeApplication.nativeApplication.exit(1);
            };
            this.mGI.visitZone(this.mGI.mCurrentPlayer.GetHomeZoneId());
        }

        private function Gift(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mShopWindow.SetGiftPlayer(this.mPlayer);
            globalFlash.gui.mShopWindow.Show();
        }

        private function IgnoreUserChat(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mChatPanel.sendIgnoreChatMessage(this.mPlayer.username);
        }

        private function ShowAdventureDetails(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mAdventurePanel.SetData(this.mPlayer.adventureVO);
            globalFlash.gui.mAdventurePanel.Show();
        }

        private function ConfirmLeaveAdventure(_arg_1:MouseEvent):void
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(this.mPlayer.adventureVO.adventureName);
            CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ConfirmLeaveAdventure", [this.mPlayer.adventureVO.adventureName]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmLeaveAdventure"), (Alert.OK | Alert.CANCEL), null, this.LeaveAdventure, null, 4, false);
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.mMenu.x < 0)
            {
                this.mMenu.x = 0;
            };
            if (this.mMenu.y < 0)
            {
                this.mMenu.y = 0;
            };
            if (this.mMenu.x > (global.getApplication().stage.stageWidth - this.mMenu.width))
            {
                this.mMenu.x = (global.getApplication().stage.stageWidth - this.mMenu.width);
            };
            if (this.mMenu.y > (global.getApplication().stage.stageHeight - this.mMenu.height))
            {
                this.mMenu.y = (global.getApplication().stage.stageHeight - this.mMenu.height);
            };
        }

        private function RemoveFriend(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            globalFlash.gui.mFriendsList.RemoveFriend(this.mPlayer.id);
        }

        private function HideMenu(_arg_1:MouseEvent):void
        {
            global.getApplication().removeEventListener(MouseEvent.CLICK, this.HideMenu);
            this.Hide();
        }

        private function Whisper(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mChatPanel.ActivatePrivateChat(this.mPlayer.username);
        }

        public function Move(_arg_1:int, _arg_2:int):void
        {
            this.mMenu.x = (_arg_1 - (this.mMenu.width >> 1));
            this.mMenu.y = _arg_2;
        }

        private function ConfirmCancelAdventure(_arg_1:MouseEvent):void
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(this.mPlayer.adventureVO.adventureName);
            CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, ((_local_2.IsRecurring()) ? "ConfirmCancelRecurringAdventure" : "ConfirmCancelAdventure"), [this.mPlayer.adventureVO.adventureName]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmCancelAdventure"), (Alert.OK | Alert.CANCEL), null, this.CancelAdventure, null, 4, false);
        }

        private function SendSpecialist(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mSpecialistTravelPanel.SetData(this.mPlayer.id);
            globalFlash.gui.mSpecialistTravelPanel.Show();
        }

        private function SendMail(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mMailWindow.editMailPreselected(this.mPlayer);
            globalFlash.gui.mMailWindow.Show();
        }


    }
}
