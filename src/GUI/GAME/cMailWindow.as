package GUI.GAME
{
    import mx.controls.TextInput;
    import Interface.cGameInterface;
    import Communication.VO.Mail.dMailVO;
    import Communication.VO.dPlayerListItemVO;
    import mx.collections.ArrayCollection;
    import Communication.VO.Guild.dGuildVO;
    import GUI.Components.ItemRenderer.MailTypeFilterHeaderRenderer;
    import GUI.Components.MailWindow;
    import mx.collections.Sort;
    import flash.utils.Dictionary;
    import mx.events.FlexEvent;
    import nLib.cLog;
    import mx.events.ListEvent;
    import flash.events.TextEvent;
    import GUI.Components.CustomAlert;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.controls.Alert;
    import Enums.MAIL_TYPE;
    import Enums.COMMAND;
    import Communication.VO.dIntegerVO;
    import flash.events.MouseEvent;
    import mx.events.CloseEvent;
    import GUI.Assets.gAssetManager;
    import GUI.Components.DismissMailsAlert;
    import flash.events.Event;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import Communication.VO.UpdateVO.dMailsDismissedVO;
    import GUI.Events.MailRecipientEvent;
    import Communication.VO.Mail.dFriendBodyVO;
    import mx.utils.StringUtil;
    import GUI.Components.ToolTips.SkillToolTipData;
    import mx.controls.Label;
    import Skill.SkillDefinition;
    import Communication.VO.Skill.SkillVO;
    import GUI.Components.ItemRenderer.SkillTipRenderer;
    import mx.containers.VBox;
    import Communication.VO.dResourceVO;
    import Communication.VO.Mail.dMarkMailsVO;
    import MilitarySystem.cMilitaryUnitDescription;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import mx.events.FlexMouseEvent;
    import GUI.Components.Frame;
    import GUI.Components.ItemRenderer.StarMenuItemRenderer;
    import Communication.VO.dBuffVO;
    import mx.events.ToolTipEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
    import Collections.CollectionsConsts;
    import BuffSystem.cBuff;
    import Communication.VO.dSpecialistVO;
    import Specialists.cSpecialist;
    import mx.containers.HBox;
    import GUI.Components.ItemRenderer.MailGridSelectItemRenderer;
    import flash.display.DisplayObject;
    import mx.core.IChildList;
    import GUI.FloatingItemsManager;
    import Communication.VO.Mail.dDeleteMailsRequestVO;
    import Communication.VO.Mail.dDismissMailsRequestVO;
    import flash.geom.Point;
    import GUI.Components.MailTypeContextMenu;
    import GUI.Components.ItemRenderer.MailTypeFilterItemRenderer;
    import flash.utils.clearInterval;
    import __AS3__.vec.Vector;
    import Enums.MAIL_TYPE_GROUP;
    import mx.events.StateChangeEvent;
    import GUI.Events.DismissMailCloseEvent;
    import GUI.Components.BattleWindow;
    import Communication.VO.Mail.dBattleReportBodyVO;
    import flash.utils.getTimer;
    import Communication.VO.Mail.dMailHeaderResponseVO;
    import mx.events.PropertyChangeEvent;
    import ServerState.cTradeObject;
    import ServerState.dResource;
    import AdventureSystem.cAdventureDefinition;
    import GO.cBuilding;
    import ShopSystem.cShopItem;
    import Interface.cGeneralInterface;
    import nLib.gMisc;
    import Communication.VO.Mail.dBuffedDataVO;
    import Communication.VO.Mail.dGuildBodyVO;
    import Communication.VO.Mail.dHardCurrencyMailBodyVO;
    import mx.collections.SortField;
    import mx.events.DataGridEvent;
    import com.bluebyte.tso.ui.util.ListPager;
    import mx.events.CollectionEvent;
    import Communication.VO.dContextItemVO;
    import mx.core.ScrollPolicy;
    import __AS3__.vec.*;
    import Communication.VO.Skill.*;

    public class cMailWindow extends cBasicPanel 
    {

        public static const DELETE_MAIL:String = "DeleteMail";
        public static const SELECT_MAIL:String = "SelectMail";
        public static const MAX_SUBJECT_CHAR:int = 100;
        public static const MAX_BODY_CHAR:int = 5000;
        private static const GET_MAIL_COOLDOWN:int = 7500;

        private var lastSelectedItem:Object;
        private var _toInputField:TextInput;
        private var mGI:cGameInterface;
        private var mCurrentMail:dMailVO;
        private var mCurrentShowingMailId:int;
        private var mReciepient:dPlayerListItemVO;
        private var mSortLastIndex:int = -1;
        private var mLastExpirationUpdateTime:int;
        private var mResetScrollPosition:Boolean;
        private var _mailTypeContextMenu:cMailTypeContextMenu;
        private var mSortDesc:Boolean = true;
        public var outBoxEnabled:Boolean = true;
        private var mContextMenu:cMailWindowContextMenu;
        private var hasDraft:Boolean = false;
        private var mMails:ArrayCollection;
        private var mLoadingMailPanel:cLoadingMailPanel;
        private var mReciepientGuild:dGuildVO;
        private var isInbox:Boolean;
        public var mailTypeHeader:MailTypeFilterHeaderRenderer;
        private var mExpirationUpdateIntervalId:uint;
        protected var mPanel:MailWindow;
        private var mSort:Sort;
        private var replyBody:String;
        private var mReplyBody:String;
        private var mReplyMail:dMailVO;
        private var mReplyRecipients:ArrayCollection;
        private var mfocusOnMailBody:Boolean = true;
        private var mReplySubject:String;
        private var mReciepientGuildApplication:dPlayerListItemVO;

        private var mMailsToDelete:ArrayCollection = new ArrayCollection();
        private var mMailCache:Dictionary = new Dictionary(false);
        private var mSelectedMails:Dictionary = new Dictionary();
        private var _947992121mRecipients:ArrayCollection = new ArrayCollection();
        private const allowedSortingColumns:Object = {
            "type":1,
            "timestamp":1,
            "expirationTime":1
        };


        private function toTileListUpdateCompleteHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.toTileList.removeEventListener(FlexEvent.UPDATE_COMPLETE, this.toTileListUpdateCompleteHandler);
            if (this.toInputField)
            {
                this.toInputField.setFocus();
            };
        }

        private function deleteMail(_arg_1:ListEvent):void
        {
            if (this.mPanel.mailsList.selectedItem == null)
            {
                cLog.warning("DeleteMail(): mPanel.mailsList.selectedItem is null");
                return;
            };
            var _local_2:dMailVO = (this.mPanel.mailsList.selectedItem as dMailVO);
            if (this.mMailsToDelete.length == 0)
            {
                this.mMailsToDelete.addItem(_local_2);
                this.deleteMultipleMails();
            };
        }

        private function subjectInputTextInputHandler(_arg_1:TextEvent):void
        {
            var _local_2:int = this.mPanel.subjectInput.text.length;
            var _local_3:int = _arg_1.text.length;
            if ((_local_2 + _local_3) > MAX_SUBJECT_CHAR)
            {
                this.mPanel.subjectInput.removeEventListener(TextEvent.TEXT_INPUT, this.subjectInputTextInputHandler);
                CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "MailSubjectCharacterLimit", [MAX_SUBJECT_CHAR]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "MailMaxSubjectCharacterLimit"), Alert.OK, null, this.maxLimitHandler, null, 4, false).setFocus();
                _arg_1.preventDefault();
                return;
            };
        }

        private function declineTrade(_arg_1:MouseEvent):Boolean
        {
            if (((this.isMailValid(this.mCurrentMail)) && (this.mCurrentMail.type == MAIL_TYPE.TRADE)))
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.DECLINE_TRADE, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
                this.removeMail(this.mCurrentMail);
                return (true);
            };
            return (false);
        }

        private function confirmCancelSend(_arg_1:CloseEvent=null):void
        {
            if (((_arg_1 == null) || (_arg_1.detail == Alert.OK)))
            {
                this.hasDraft = false;
                this.mReciepient = null;
                this.mReciepientGuild = null;
                this.mReplyRecipients = new ArrayCollection();
                this.mReplyMail = null;
                this.mReplyBody = null;
                this.mPanel.toTileList.dataProvider = null;
                this.mPanel.currentState = ((this.isInbox) ? "" : this.mPanel.stateSentbox.name);
            };
        }

        private function btnOutboxRollOutHandler(_arg_1:MouseEvent):void
        {
            if (this.mPanel.currentState == this.mPanel.stateSentbox.name)
            {
                this.mPanel.btnOutbox.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundHighlight"));
            }
            else
            {
                this.mPanel.btnOutbox.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            };
        }

        private function claimOrDeleteSelectedMails(_arg_1:Event):void
        {
            var _local_5:dMailVO;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            for each (_local_5 in this.mSelectedMails)
            {
                if (MAIL_TYPE.isImportant(_local_5.type))
                {
                    _local_4++;
                }
                else
                {
                    if (this.canAcceptLoot(_local_5))
                    {
                        this.mMailsToDelete.addItem(_local_5);
                        if (MAIL_TYPE.isCollectable(_local_5.type))
                        {
                            _local_2++;
                        }
                        else
                        {
                            _local_3++;
                        };
                    };
                };
            };
            if (this.mMailsToDelete.length > 0)
            {
                DismissMailsAlert.show("ConfirmDismissMailsMessage", "ConfirmDismissMailsTitle", this.mSelectedMails, this.onDismissMailsAccepted, this.mPanel, true, _local_2, _local_3, _local_4);
            };
        }

        private function subjectInputChangeHandler(_arg_1:Event):void
        {
            this.updateSendButtonState();
        }

        public function notifyLoadMailBodiesFinished(_arg_1:Boolean):void
        {
            this.showReplyMail(_arg_1);
        }

        private function acceptAdventureInvite(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.ACCEPT_ADVENTURE_INVITATION, (this.mCurrentMail.attachments as dAdventureClientInfoVO).zoneID, new dIntegerVO(this.mCurrentMail.id));
            AdventureManager.getInstance().increaseJoinedAdventuresCount();
            this.removeMail(this.mCurrentMail);
        }

        private function resetRecipients():void
        {
            this.mRecipients.removeAll();
            this.mRecipients.addItem(".");
        }

        public function get toInputField():TextInput
        {
            return (this._toInputField);
        }

        public function onMailsDismissed(_arg_1:dMailsDismissedVO):void
        {
            var _local_3:dLootItemsVO;
            var _local_7:int;
            var _local_8:dMailVO;
            var _local_9:dMailVO;
            this.mPanel.busyOverlay.visible = false;
            var _local_2:int = _arg_1.items.length;
            var _local_4:int;
            var _local_5:Number = 200;
            var _local_6:int;
            while (_local_6 < _local_2)
            {
                _local_3 = _arg_1.items[_local_6];
                _local_7 = (_local_4 * _local_5);
                _local_4 = (_local_4 + (_local_3.items.length + _local_3.premiumItems.length));
                _local_8 = this.getMailFromList(_local_3.mailVO.id);
                if (_local_8 != null)
                {
                    if ((_local_8.id in this.mMailsToDelete))
                    {
                        _local_9 = (this.mMailsToDelete[_local_8.id] as dMailVO);
                        _local_9.deletedAt = 1;
                    };
                    _local_8.deletedAt = 1;
                    this.setMailSelected(_local_8, false);
                    this.listRemoveItem(this.mMails, _local_8);
                };
                _local_6++;
            };
            this.updateMailListUI();
            this.pager.refresh();
        }

        private function btnFriendDeclineClickHandler(_arg_1:MouseEvent):void
        {
            this.declineFriend(_arg_1);
        }

        private function acceptGuildRequest(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            switch (this.mCurrentMail.type)
            {
                case MAIL_TYPE.GUILD_INVITE:
                    _local_2 = this.mCurrentMail.id;
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_INVITE_ACCEPT, 0, new dIntegerVO(_local_2));
                    break;
                case MAIL_TYPE.GUILD_APPLY:
                    this.mGI.GetCurrentPlayerGuild().size++;
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_APPLY_ACCEPT, 0, new dIntegerVO(this.mCurrentMail.id));
                    break;
                default:
                    return;
            };
            this.removeMail(this.mCurrentMail);
        }

        private function inboxClickHandler(_arg_1:MouseEvent):void
        {
            this.onMailTypeFilterChanged();
            this.isInbox = true;
            this.mContextMenu.UpdateMenuItemState(this.mSelectedMails, this.isInbox, this.mGI.mCurrentPlayer.GetPlayerId());
            var _local_2:* = (!(this.mPanel.currentState == ""));
            this.mPanel.currentState = "";
            if (_local_2)
            {
                this.getMailHeaders();
            };
            this.mPanel.btnContextMenu.enabled = (this.mPanel.btnCollectOrDelete.enabled = this.isAnyMailSelected());
        }

        public function mailsDeletedFromServer():void
        {
            var _local_2:dMailVO;
            var _local_3:dMailVO;
            var _local_1:int = this.mPanel.mailsList.verticalScrollPosition;
            this.lastSelectedItem = null;
            this.mPanel.pulsate.stop();
            this.mPanel.deleteIcon.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "MailsAreUpToDate");
            for each (_local_2 in this.mMailsToDelete)
            {
                if (_local_2.isDeletable)
                {
                    if ((_local_2.id in this.mMailsToDelete))
                    {
                        _local_3 = (this.mMailsToDelete[_local_2.id] as dMailVO);
                        _local_3.deletedAt = 1;
                    };
                    _local_2.deletedAt = 1;
                    this.setMailSelected(_local_2, false);
                    this.listRemoveItem(this.mMails, _local_2);
                };
            };
            this.mMailsToDelete.removeAll();
            this.updateMailListUI();
            this.pager.refresh();
            this.mPanel.mailsList.verticalScrollPosition = _local_1;
        }

        protected function recipientEnteredHandler(_arg_1:MailRecipientEvent):void
        {
            this.mReciepient = null;
            this.mPanel.btnSend.enabled = false;
            if (_arg_1.charLength >= 3)
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.SEARCH_RECIEPIENT_LIST, this.mGI.mCurrentViewedZoneID, _arg_1.recipientName);
            }
            else
            {
                this.mPanel.reciepientList.visible = false;
                this.mPanel.reciepientList.dataProvider = null;
                if (((_arg_1.charLength <= 0) && (this.mRecipients.length > 1)))
                {
                    this.mReciepient = (this.mRecipients.getItemAt((this.mRecipients.length - 2)) as dPlayerListItemVO);
                    this.updateSendButtonState();
                };
            };
        }

        private function clear():void
        {
            this.mPanel.mailContent.selectedIndex = 0;
            this.mPanel.subjectLabel.text = "";
            this.mPanel.bodyText.text = "";
            this.mCurrentShowingMailId = 0;
        }

        private function sendInvitationFriendRequest(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mFriendsList.AddFriend((this.mCurrentMail.attachments as dFriendBodyVO).player);
            this.removeMail(this.mCurrentMail, true);
        }

        private function isRecipientInList(_arg_1:ArrayCollection, _arg_2:int):Boolean
        {
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (((_arg_1[_local_3] is dPlayerListItemVO) && (_arg_1[_local_3].id == _arg_2)))
                {
                    return (true);
                };
                _local_3++;
            };
            return (false);
        }

        public function set toInputField(_arg_1:TextInput):void
        {
            if (_arg_1.parent.name != "hiddenItem")
            {
                this._toInputField = _arg_1;
            };
        }

        private function removeMail(_arg_1:dMailVO, _arg_2:Boolean=false):Boolean
        {
            var _local_3:int = this.getMailListIndex(_arg_1);
            if (_local_3 < 0)
            {
                cLog.warning((("Unable to remove mail with id:" + _arg_1.id) + " because it was not found in the ui list"));
                return (false);
            };
            if (_arg_2)
            {
                this.deleteMailFromServer(_arg_1);
            };
            this.mMails.removeItemAt(_local_3);
            _arg_1.deletedAt = 1;
            var _local_4:dMailVO = this.mMailCache[_arg_1.id];
            if (_local_4 != null)
            {
                _local_4.deletedAt = 1;
            };
            this.pager.refresh();
            this.clear();
            delete this.mSelectedMails[_arg_1.id];
            _local_3 = this.mMailsToDelete.getItemIndex(_arg_1);
            if (_local_3 > -1)
            {
                this.mMailsToDelete.removeItemAt(_local_3);
            };
            return (true);
        }

        private function getFullMail(_arg_1:dMailVO):void
        {
            var _local_3:dMailVO;
            var _local_2:dMailVO = this.mMailCache[_arg_1.id];
            if (((!(_arg_1.deletedAt == 0)) || ((!(_local_2 == null)) && (!(_local_2.deletedAt == 0)))))
            {
                return;
            };
            if (this.mCurrentShowingMailId != _arg_1.id)
            {
                if (_arg_1.id < 0)
                {
                    cLog.warning(("GetFullMail(): id of mail is " + _arg_1.id));
                }
                else
                {
                    _local_3 = (this.mMailCache[_arg_1.id] as dMailVO);
                    if (((!(_local_3 == null)) && (!(_local_3.body == null))))
                    {
                        if (!_local_3.read)
                        {
                            if ((((this.isInbox) && (!(this.mPanel.currentState == this.mPanel.stateSentbox.name))) && (!(this.mPanel.currentState == this.mPanel.stateEdit.name))))
                            {
                                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.MARK_MAIL_AS_READ, this.mGI.mCurrentViewedZoneID, new dIntegerVO(_arg_1.id));
                            };
                        };
                        this.setMail(_local_3);
                        this.mCurrentShowingMailId = _arg_1.id;
                    }
                    else
                    {
                        if (this.isInbox)
                        {
                            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_INBOX_BODY, this.mGI.mCurrentViewedZoneID, new dIntegerVO(_arg_1.id));
                        }
                        else
                        {
                            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_OUTBOX_BODY, this.mGI.mCurrentViewedZoneID, new dIntegerVO(_arg_1.id));
                        };
                    };
                };
            };
        }

        private function showBlockList(_arg_1:MouseEvent):void
        {
            this.Hide();
            globalFlash.gui.mBlockList.Show();
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_BLOCK_LIST, 0, null);
        }

        private function declineAdventureInvite(_arg_1:MouseEvent):Boolean
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return (false);
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.DECLINE_ADVENTURE_INVITATION, (this.mCurrentMail.attachments as dAdventureClientInfoVO).zoneID, new dIntegerVO(this.mCurrentMail.id));
            this.removeMail(this.mCurrentMail);
            return (true);
        }

        private function selectReciepientByName(_arg_1:MailRecipientEvent):void
        {
            var _local_2:dPlayerListItemVO;
            if (this.mPanel.getFocus() == this.mPanel.reciepientList)
            {
                return;
            };
            this.mPanel.reciepientList.visible = false;
            if (((this.mReciepient) || (this.mReciepientGuild)))
            {
                return;
            };
            for each (_local_2 in this.mPanel.reciepientList.dataProvider)
            {
                if (_local_2.username == _arg_1.recipientName)
                {
                    this.mPanel.reciepientList.selectedIndex = 0;
                    this.selectReciepientFromList(null);
                    return;
                };
            };
            _arg_1.target.setStyle("color", 0xFF0000);
            if (((this.toInputField) && (!(StringUtil.trim(this.toInputField.text) == ""))))
            {
                this.mPanel.btnSend.enabled = false;
            };
        }

        private function prepareGeneralSkillForBattleReport(_arg_1:ArrayCollection, _arg_2:VBox):void
        {
            var _local_3:SkillToolTipData;
            var _local_4:Label;
            var _local_5:SkillDefinition;
            var _local_6:SkillVO;
            var _local_7:SkillTipRenderer;
            if (_arg_1.length > 0)
            {
                _local_3 = new SkillToolTipData();
                _local_3.skills = _arg_1;
                _arg_2.removeAllChildren();
                if (_arg_1.length > 0)
                {
                    _arg_2.visible = true;
                    _arg_2.includeInLayout = true;
                    _local_4 = new Label();
                    _local_4.setStyle("color", 13876873);
                    _local_4.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdditionalSkillInfo");
                    _arg_2.addChild(_local_4);
                    for each (_local_6 in _arg_1)
                    {
                        _local_5 = global.skills_vector[_local_6.id];
                        if (((((((!(_local_5 == null)) && (!(_local_5.icon_string == null))) && (!(_local_5.icon_string == ""))) && (!(_local_5.id == 86))) && (!(_local_5.id == 91))) && (!(_local_5.id == 87))))
                        {
                            _local_7 = new SkillTipRenderer();
                            _local_7.setSkillVO(_local_6);
                            _arg_2.addChild(_local_7);
                        };
                    };
                };
            };
        }

        private function addGuildRecipient(_arg_1:dGuildVO):void
        {
            this.mPanel.toTileList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.toTileListItemAddedHandler, false, 0, true);
            this.mRecipients.removeAll();
            this.mRecipients.addItem(_arg_1);
            this.updateSendButtonState();
        }

        public function getMailInCache(_arg_1:int):dMailVO
        {
            return (this.mMailCache[_arg_1]);
        }

        private function showContextMenu(_arg_1:MouseEvent):void
        {
            this.mContextMenu.UpdateMenuItemState(this.mSelectedMails, this.isInbox, this.mGI.mCurrentPlayer.GetPlayerId());
            this.mContextMenu.Move((_arg_1.stageX - this.mPanel.x), (_arg_1.stageY - this.mPanel.y));
            if (((!(this._mailTypeContextMenu == null)) && (this._mailTypeContextMenu.IsVisible())))
            {
                this._mailTypeContextMenu.HideMenu();
            };
            _arg_1.stopPropagation();
            this.mContextMenu.Show();
        }

        private function increaseGuildSize(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mShopWindow.ShowDeepLink("MailWindow", 0, 3);
        }

        private function isMailValid(_arg_1:dMailVO):Boolean
        {
            return (this.getMailListIndex(_arg_1) >= 0);
        }

        private function addRecipient(_arg_1:dPlayerListItemVO):void
        {
            if (this.mRecipients.length > global.maxRecipients)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((((("Cannot add more recipients(" + this.mRecipients.length) + ") as the max limit(") + global.maxRecipients) + ") has been reached"));
                };
                CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "MailMaxRecipientsLimit", [global.maxRecipients]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "MailMaxRecipientsLimit"), Alert.OK, null, null, null, 4, false);
                this.mPanel.reciepientList.visible = false;
                this.mPanel.reciepientList.dataProvider = null;
                this.toInputField.text = "";
                this.updateSendButtonState();
            }
            else
            {
                if (((!(this.mReciepientGuild)) && (!(this.isInRecipientList(_arg_1)))))
                {
                    this.mPanel.toTileList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.toTileListItemAddedHandler, false, 0, true);
                    this.mPanel.reciepientList.visible = false;
                    this.mPanel.reciepientList.dataProvider = null;
                    this.mRecipients.addItemAt(_arg_1, (this.mRecipients.length - 1));
                    this.mReciepient = _arg_1;
                    this.updateSendButtonState();
                };
            };
        }

        private function calculateCombatReportTotalCasualties(_arg_1:XML):Array
        {
            var _local_5:XML;
            var _local_6:Array;
            var _local_7:int;
            var _local_8:XML;
            var _local_9:dResourceVO;
            var _local_2:Array = new Array();
            var _local_3:Array = new Array();
            var _local_4:int = -1;
            for each (_local_5 in _arg_1.Round.Phase)
            {
                if (!((_local_5.Casualties[0] == null) || (_local_5.Casualties[0].attribute("group").toString() == "Defenders")))
                {
                    for each (_local_8 in _local_5.Casualties[0].children())
                    {
                        _local_4 = _local_2.indexOf(_local_8.attribute("unitType").toString());
                        if (_local_4 > -1)
                        {
                            _local_3[_local_4] = (_local_3[_local_4] + int(_local_8.attribute("dead").toString()));
                        }
                        else
                        {
                            _local_2.push(_local_8.attribute("unitType").toString());
                            _local_4 = _local_2.indexOf(_local_8.attribute("unitType").toString());
                            _local_3[_local_4] = int(_local_8.attribute("dead").toString());
                        };
                    };
                };
            };
            _local_6 = new Array();
            _local_7 = 0;
            while (_local_7 < _local_2.length)
            {
                _local_9 = new dResourceVO();
                _local_9.name_string = _local_2[_local_7];
                _local_9.amount = _local_3[_local_7];
                _local_6.push(_local_9);
                _local_7++;
            };
            _local_6.sort(this.sortBattleMailUnits);
            return (_local_6);
        }

        public function getMPanel():MailWindow
        {
            return (this.mPanel);
        }

        private function pvpReportButtonClickHandler(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mPvpReportWindow.SetData(this.mCurrentMail.body.toString());
            globalFlash.gui.mPvpReportWindow.Show();
        }

        private function maxLimitHandler(_arg_1:CloseEvent):void
        {
            this.mPanel.subjectInput.addEventListener(TextEvent.TEXT_INPUT, this.subjectInputTextInputHandler);
        }

        private function declineGuildSuccessionRequest(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_SUCCESSION_DECLINE, 0, new dIntegerVO(this.mCurrentMail.id));
            this.removeMail(this.mCurrentMail);
        }

        private function markSelectedMailsAsUnread(_arg_1:MouseEvent):void
        {
            var _local_2:dMarkMailsVO = new dMarkMailsVO();
            _local_2.mailIds_collection = new ArrayCollection();
            _local_2.read = false;
            this.fillInAndMarkSelectedMailIDs(_local_2.mailIds_collection, _local_2.read);
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.MARK_MAILS, this.mGI.mCurrentViewedZoneID, _local_2);
            this.mContextMenu.UpdateMenuItemState(this.mSelectedMails, this.isInbox, this.mGI.mCurrentPlayer.GetPlayerId());
            this.mPanel.mailsList.invalidateDisplayList();
        }

        private function getMailHeaders():void
        {
            if (this.isInbox)
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_INBOX_HEADERS, this.mGI.mCurrentViewedZoneID, new dIntegerVO(5000));
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_BLOCK_LIST, 0, null);
            }
            else
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_OUTBOX_HEADERS, this.mGI.mCurrentViewedZoneID, new dIntegerVO(5000));
            };
            this.lastSelectedItem = this.mPanel.mailsList.selectedItem;
            this.mPanel.busyOverlay.visible = true;
        }

        private function isInRecipientListById(_arg_1:int):Boolean
        {
            var _local_2:int;
            while (_local_2 < this.mRecipients.length)
            {
                if (((this.mRecipients[_local_2] is dPlayerListItemVO) && (this.mRecipients[_local_2].id == _arg_1)))
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        public function editMailPreselected(_arg_1:dPlayerListItemVO):void
        {
            if (this.mPanel.currentState != this.mPanel.stateEdit.name)
            {
                this.mPanel.currentState = this.mPanel.stateEdit.name;
            };
            this.addRecipient(_arg_1);
            globalFlash.gui.windowController.setTop(this.mPanel, true);
            this.Show();
        }

        private function sortBattleMailUnits(_arg_1:dResourceVO, _arg_2:dResourceVO):int
        {
            var _local_3:cMilitaryUnitDescription = cMilitaryUnitDescription.GetUnitDescriptionForType(_arg_1.name_string);
            var _local_4:cMilitaryUnitDescription = cMilitaryUnitDescription.GetUnitDescriptionForType(_arg_2.name_string);
            if (((_local_3.IsSpecialist()) && (!(_local_4.IsSpecialist()))))
            {
                return (-1);
            };
            if (((!(_local_3.IsSpecialist())) && (_local_4.IsSpecialist())))
            {
                return (1);
            };
            if (_local_3.GetSequencePrio() < _local_4.GetSequencePrio())
            {
                return (-1);
            };
            if (_local_3.GetSequencePrio() > _local_4.GetSequencePrio())
            {
                return (1);
            };
            return (0);
        }

        private function btnInboxRollOutHandler(_arg_1:MouseEvent):void
        {
            if (((!(this.mPanel.currentState == this.mPanel.stateEdit.name)) && (!(this.mPanel.currentState == this.mPanel.stateSentbox.name))))
            {
                this.mPanel.btnInbox.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundHighlight"));
            }
            else
            {
                this.mPanel.btnInbox.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            };
        }

        private function listKeyDownHandler(_arg_1:KeyboardEvent):void
        {
            switch (_arg_1.keyCode)
            {
                case Keyboard.ENTER:
                    this.selectReciepientFromList(null);
                    return;
            };
        }

        private function enterEditState(_arg_1:Event):void
        {
            var _local_2:String;
            var _local_3:int;
            var _local_4:Object;
            this.clearEdit();
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NewMail");
            this.mPanel.btnSend.addEventListener(MouseEvent.CLICK, this.sendMail, false, 0, true);
            this.mPanel.btnCancelWrite.addEventListener(MouseEvent.CLICK, this.cancelSend, false, 0, true);
            this.mPanel.reciepientList.addEventListener(KeyboardEvent.KEY_DOWN, this.listKeyDownHandler, false, 0, true);
            this.mPanel.reciepientList.addEventListener(ListEvent.ITEM_CLICK, this.selectReciepientFromList, false, 0, true);
            this.mPanel.reciepientList.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, this.clickOutsideHandler, false, 0, true);
            this.mPanel.toTileList.addEventListener(MailRecipientEvent.RECIPIENT_ENTERED, this.recipientEnteredHandler, false, 0, true);
            this.mPanel.toTileList.addEventListener(MailRecipientEvent.SPECIAL_KEY_PRESS, this.keyEventHandler, false, 0, true);
            this.mPanel.toTileList.addEventListener(MailRecipientEvent.FOCUS_OUT, this.selectReciepientByName, false, 0, true);
            this.mPanel.toTileList.addEventListener(MailRecipientEvent.DELETE_RECIPIENT, this.removeReciepient, false, 0, true);
            this.mPanel.toTileList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.toTileListUpdateCompleteHandler, false, 0, true);
            this.mPanel.toTileList.addEventListener(MouseEvent.CLICK, this.toTilesClicked, false, 0, true);
            this.mPanel.subjectInput.addEventListener(TextEvent.TEXT_INPUT, this.subjectInputTextInputHandler);
            this.mPanel.subjectInput.addEventListener(Event.CHANGE, this.subjectInputChangeHandler);
            this.mPanel.editText.addEventListener(Event.CHANGE, this.bodyInputChangeHandler);
            this.mPanel.toTileList.dataProvider = this.mRecipients;
            this.mPanel.subjectInput.maxChars = (MAX_SUBJECT_CHAR + 1);
            this.resetRecipients();
            if (this.mReciepientGuild)
            {
                this.addGuildRecipient(this.mReciepientGuild);
            };
            if (this.mReplyMail)
            {
                this.addRecipient(this.mReciepient);
                _local_2 = ("Re: " + this.mReplyMail.subject).substring(0, MAX_SUBJECT_CHAR);
                this.mPanel.subjectInput.text = _local_2;
                this.mPanel.editText.text = "\n\n-----------------------------------------------------------------------------------\n";
                this.mPanel.editText.text = (this.mPanel.editText.text + (this.mReplyMail.senderName + ":\n\n"));
                this.mPanel.editText.text = (this.mPanel.editText.text + this.mReplyMail.body);
            };
            if (this.mReplyBody)
            {
                this.mPanel.editText.text = this.mReplyBody;
                this.mPanel.subjectInput.text = this.mReplySubject;
                _local_3 = 0;
                while (_local_3 < this.mReplyRecipients.length)
                {
                    _local_4 = this.mReplyRecipients.getItemAt(_local_3);
                    if ((_local_4 is dPlayerListItemVO))
                    {
                        this.addRecipient((_local_4 as dPlayerListItemVO));
                    };
                    _local_3++;
                };
                this.mReplyRecipients.removeAll();
            };
        }

        private function replyAllSelectedMails(_arg_1:MouseEvent):void
        {
            this.loadMailBodies(true);
        }

        private function getMailFromList(_arg_1:int):dMailVO
        {
            var _local_3:dMailVO;
            var _local_2:int = this.mMails.length;
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_3 = this.mMails[_local_4];
                if (_local_3.id == _arg_1)
                {
                    return (_local_3);
                };
                _local_4++;
            };
            return (null);
        }

        private function isInRecipientList(_arg_1:dPlayerListItemVO):Boolean
        {
            return (this.isInRecipientListById(_arg_1.id));
        }

        private function enterApplyState(event:Event):void
        {
            this.mPanel.btnSend.addEventListener(MouseEvent.CLICK, this.sendMail);
            this.clearApply();
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "NewMail");
            this.mPanel.btnApply.addEventListener(MouseEvent.CLICK, this.sendMail);
            this.mPanel.btnSend.enabled = true;
            this.mPanel.btnCancelApply.addEventListener(MouseEvent.CLICK, function ():void
            {
                Hide();
            });
        }

        public function ensureViewIsAvailable():void
        {
            var _local_1:MailWindow;
            if (!this.mPanel)
            {
                _local_1 = new MailWindow();
                _local_1.id = "GAMESTATE_ID_MAIL_WINDOW";
                global.getApplication().isoengine.addChild(_local_1);
                this.init(_local_1);
            };
        }

        private function renderLootItemsList(items:ArrayCollection, itemsGuiList:HBox):void
        {
            var item:* = undefined;
            var vo:* = undefined;
            var frame:Frame;
            var flyToTarget:String;
            var renderer:StarMenuItemRenderer;
            var buffVO:dBuffVO;
            itemsGuiList.removeAllChildren();
            for each (vo in items)
            {
                if (((vo is dResourceVO) && ((vo.name_string == "XP") || (vo.name_string == defines.PVP_XP_string))))
                {
                    item = vo;
                    frame = new Frame();
                    frame.contentType = Frame.CONTENT_TYPE_RESOURCE;
                    frame.amount = vo.amount;
                    frame.content = vo.name_string;
                    frame.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, vo.name_string);
                    frame.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, function (_arg_1:ToolTipEvent):void
                    {
                        cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
                    });
                    itemsGuiList.addChild(frame);
                }
                else
                {
                    flyToTarget = CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER;
                    if ((vo is dBuffVO))
                    {
                        buffVO = (vo as dBuffVO);
                        item = cBuff.CreateBuffFromVO(buffVO);
                    }
                    else
                    {
                        if ((vo is dSpecialistVO))
                        {
                            item = cSpecialist.CreateSpecialistFromVO(this.mGI, vo, false);
                        };
                    };
                    renderer = new StarMenuItemRenderer();
                    renderer.data = item;
                    renderer.flyToTarget = flyToTarget;
                    itemsGuiList.addChild(renderer);
                };
            };
        }

        private function onClickMailTypeHeader(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (!this.mailTypeContextMenu.IsVisible())
            {
                this.mailTypeContextMenu.updateSelection(this.mMails, this.mSelectedMails);
            };
            this.mailTypeContextMenu.toggle();
        }

        private function fillInAndMarkSelectedMailIDs(_arg_1:ArrayCollection, _arg_2:Boolean):void
        {
            var _local_3:Object;
            var _local_4:dMailVO;
            for (_local_3 in this.mSelectedMails)
            {
                _local_4 = (this.mSelectedMails[_local_3] as dMailVO);
                _local_4.read = _arg_2;
                _arg_1.addItem(_local_4.id);
            };
        }

        private function btnNewMailClick(_arg_1:MouseEvent):void
        {
            this.resetRecipients();
            this.mPanel.currentState = this.mPanel.stateEdit.name;
        }

        private function selectMail(_arg_1:Event):void
        {
            var _local_2:MailGridSelectItemRenderer = (_arg_1.target as MailGridSelectItemRenderer);
            var _local_3:dMailVO = (_local_2.data as dMailVO);
            this.setMailSelected(_local_3, _local_2.btnSelect.selected);
            this.mPanel.btnContextMenu.enabled = (this.mPanel.btnCollectOrDelete.enabled = ((this.isAnyMailSelected()) && (this.isInbox)));
            this.mContextMenu.UpdateMenuItemState(this.mSelectedMails, this.isInbox, this.mGI.mCurrentPlayer.GetPlayerId());
        }

        private function deselectMails():void
        {
            var _local_1:dMailVO;
            for each (_local_1 in this.mSelectedMails)
            {
                this.setMailSelected(_local_1, false, false);
            };
            // The grid creates its header renderer during its first layout pass.
            if (this.mailTypeHeader && this.mailTypeHeader.btnSelect)
            {
                this.mailTypeHeader.btnSelect.selected = false;
            }
        }

        private function fillInSelectedSenderIDs(_arg_1:ArrayCollection):void
        {
            var _local_2:Object;
            var _local_3:dMailVO;
            for (_local_2 in this.mSelectedMails)
            {
                _local_3 = (this.mSelectedMails[_local_2] as dMailVO);
                if ((((_local_3.type == MAIL_TYPE.MAIL) && (_local_3.senderId > 1)) && (!(_local_3.senderId == _local_3.reciepientId))))
                {
                    _arg_1.addItem(_local_3.senderId);
                };
            };
        }

        private function createFloatingItemsFromMailPanel(_arg_1:HBox):void
        {
            var _local_3:int;
            var _local_5:DisplayObject;
            var _local_2:IChildList = _arg_1.rawChildren;
            var _local_4:int = _arg_1.rawChildren.numChildren;
            _local_3 = 0;
            while (_local_3 < _local_4)
            {
                _local_5 = _local_2.getChildAt(_local_3);
                if ((_local_5 is StarMenuItemRenderer))
                {
                    FloatingItemsManager.createJumpFlyDestroy(_local_5, (_local_5 as StarMenuItemRenderer).flyToTarget);
                }
                else
                {
                    FloatingItemsManager.createJumpFlyDestroy(_local_5, CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER);
                };
                _local_3++;
            };
            _arg_1.removeAllChildren();
        }

        private function calculateCombatReportUsedArmy(_arg_1:XML):Array
        {
            var _local_3:XML;
            var _local_4:dResourceVO;
            var _local_2:Array = new Array();
            for each (_local_3 in _arg_1.ArmyDescription.Army[0].children())
            {
                _local_4 = new dResourceVO();
                _local_4.name_string = _local_3.attribute("unitType");
                _local_4.amount = _local_3.attribute("amount");
                _local_2.push(_local_4);
            };
            _local_2.sort(this.sortBattleMailUnits);
            return (_local_2);
        }

        public function applyToGuild(_arg_1:dPlayerListItemVO):void
        {
            this.mPanel.currentState = "apply";
            this.mPanel.applyTo.text = _arg_1.username;
            this.mPanel.subjectApply.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildApplyMailSubject", [globalFlash.gui.mAvatar.GetDisplayedPlayerVO().username]);
            this.mReciepientGuildApplication = _arg_1;
            this.mPanel.btnApply.enabled = true;
        }

        public function setReciepientList(_arg_1:Array):void
        {
            var _local_2:int = (_arg_1.length - 1);
            while (_local_2 >= 0)
            {
                if (this.isInRecipientList(_arg_1[_local_2]))
                {
                    _arg_1.splice(_local_2, 1);
                };
                _local_2--;
            };
            this.mPanel.reciepientList.dataProvider = _arg_1;
            this.mPanel.reciepientList.visible = (_arg_1.length > 0);
        }

        final private function setMailSelected(_arg_1:dMailVO, _arg_2:Boolean, _arg_3:Boolean=true):void
        {
            var _local_4:int;
            var _local_5:int;
            if (_arg_1 != null)
            {
                _arg_1.selected = _arg_2;
                if (_arg_2)
                {
                    this.mSelectedMails[_arg_1.id] = _arg_1;
                }
                else
                {
                    delete this.mSelectedMails[_arg_1.id];
                };
            };
            if (((this.mailTypeHeader) && (_arg_3)))
            {
                _local_4 = this.mMails.length;
                _local_5 = 0;
                for each (_arg_1 in this.mMails)
                {
                    if (_arg_1.selected)
                    {
                        _local_5++;
                    };
                };
                this.mailTypeHeader.btnSelect.selected = (_local_5 == _local_4);
                this.mailTypeHeader.btnSelect.partiallyselected = ((_local_5 < _local_4) && (_local_5 > 0));
            };
        }

        private function listRemoveItem(_arg_1:ArrayCollection, _arg_2:Object):void
        {
            var _local_3:int = _arg_1.getItemIndex(_arg_2);
            if (_local_3 >= 0)
            {
                _arg_1.removeItemAt(_local_3);
            };
        }

        private function replySelectedMails(_arg_1:MouseEvent):void
        {
            this.loadMailBodies(false);
        }

        private function isAnyMailSelected():Boolean
        {
            var _local_1:Object;
            for (_local_1 in this.mSelectedMails)
            {
                if (_local_1 != null)
                {
                    return (true);
                };
            };
            return (false);
        }

        private function claimAdventureLoot(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            this.outBoxEnabled = false;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.CLAIM_LOOT, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
            this.createFloatingItemsFromMailPanel(this.mPanel.advItemsList);
            if (this.mPanel.premiumItemsList.getChildren().length > 0)
            {
                this.createFloatingItemsFromMailPanel(this.mPanel.premiumItemsList);
            };
            this.removeMail(this.mCurrentMail);
        }

        private function toTilesClicked(_arg_1:Event):void
        {
            if (this.toInputField)
            {
                this.toInputField.setFocus();
            };
        }

        private function outboxClickHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Boolean;
            if (this.outBoxEnabled)
            {
                this.onMailTypeFilterChanged();
                this.isInbox = false;
                this.mContextMenu.UpdateMenuItemState(this.mSelectedMails, this.isInbox, this.mGI.mCurrentPlayer.GetPlayerId());
                _local_2 = (!(this.mPanel.currentState == this.mPanel.stateSentbox.name));
                this.mPanel.currentState = this.mPanel.stateSentbox.name;
                if (_local_2)
                {
                    this.getMailHeaders();
                };
                this.mPanel.btnContextMenu.enabled = (this.mPanel.btnCollectOrDelete.enabled = this.isAnyMailSelected());
            };
        }

        private function toTileListItemAddedHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.toTileList.removeEventListener(FlexEvent.UPDATE_COMPLETE, this.toTileListItemAddedHandler);
            this.defaultFocusOnNewMail();
            this.invalidateTileListFlexibility();
        }

        private function isDuplicate(_arg_1:dPlayerListItemVO):Boolean
        {
            var _local_4:Object;
            var _local_2:Boolean;
            var _local_3:uint;
            while (_local_3 < this.mRecipients.length)
            {
                _local_4 = this.mRecipients.getItemAt(_local_3);
                if ((_local_4 is dPlayerListItemVO))
                {
                    if (_arg_1.username == dPlayerListItemVO(_local_4).username)
                    {
                        _local_2 = true;
                        break;
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function claimLoot(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            this.outBoxEnabled = false;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.CLAIM_LOOT, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
            this.createFloatingItemsFromMailPanel(this.mPanel.itemsList);
            this.removeMail(this.mCurrentMail);
        }

        private function bodyInputChangeHandler(_arg_1:Event):void
        {
            _arg_1.preventDefault();
            var _local_2:int = this.mPanel.editText.text.length;
            var _local_3:int = MAX_BODY_CHAR;
            if (this.mPanel.editText.text.indexOf(this.replyBody) >= 0)
            {
                _local_3 = (_local_3 + this.replyBody.length);
            };
            if (_local_2 >= _local_3)
            {
                this.mPanel.editText.removeEventListener(TextEvent.TEXT_INPUT, this.bodyInputChangeHandler);
                CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "MailBodyCharacterLimit", [MAX_BODY_CHAR]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "MailMaxBodyCharacterLimit"), Alert.OK, null, this.maxBodyLimitHandler, null, 4, false).setFocus();
                _arg_1.preventDefault();
                this.mPanel.btnSend.enabled = false;
                this.mPanel.btnSend.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "MailMaxBodyCharacterLimit");
                return;
            };
            this.updateSendButtonState();
        }

        public function putMailInCache(_arg_1:dMailVO):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            this.mMailCache[_arg_1.id] = _arg_1;
        }

        private function confirmClose(_arg_1:CloseEvent=null):void
        {
            if (((_arg_1 == null) || (_arg_1.detail == Alert.OK)))
            {
                this.mReciepient = null;
                this.mReciepientGuild = null;
                this.mReplyRecipients = new ArrayCollection();
                this.mReplyMail = null;
                this.mReplyBody = null;
                if (this.mPanel.toTileList)
                {
                    this.mPanel.toTileList.dataProvider = null;
                };
                this.mPanel.currentState = "";
                this.Hide();
            };
        }

        private function acceptGuildSuccessionRequest(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_SUCCESSION_ACCEPT, 0, new dIntegerVO(this.mCurrentMail.id));
            this.removeMail(this.mCurrentMail);
        }

        private function clearApply():void
        {
            this.mPanel.applyTo.text = "";
            this.mPanel.subjectApply.text = "";
            this.mPanel.messageText.text = "";
            this.mPanel.reciepientApplyList.dataProvider = null;
            this.mPanel.reciepientApplyList.visible = false;
        }

        private function cancelSend(_arg_1:MouseEvent):void
        {
            CustomAlert.show("MailAbandonDraft", "MailAbandonDraft", (Alert.CANCEL | Alert.OK), this.mPanel, this.confirmCancelSend);
        }

        override public function Show():void
        {
            this.ensureViewIsAvailable();
            if (((mCurrentActivePanel) && (mCurrentActivePanel == this)))
            {
                globalFlash.gui.mActionBar.showFriendList();
                globalFlash.gui.mFriendsList.enableDisableFriendListOptions(false);
                globalFlash.gui.windowController.setTop(this.mPanel, true);
                return;
            };
            if (this.pager.page != 0)
            {
                this.pager.page = 0;
            };
            this.isInbox = (!(this.hasDraft));
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Inbox");
            if (global.getApplication().GAMESTATE_ID_ACTIONBAR.actionBarRight.btnActionBar06.enabled == false)
            {
                return;
            };
            globalFlash.gui.mAvatar.HideMailNotification();
            this.clear();
            if (this.mMails)
            {
                this.mMails.removeAll();
                this.pager.refresh();
            };
            this.pager.itemsPerPage = global.mailboxPageSize;
            this.deselectMails();
            this.getMailHeaders();
            super.Show();
            globalFlash.gui.mActionBar.showFriendList();
            globalFlash.gui.mFriendsList.enableDisableFriendListOptions(false);
            globalFlash.gui.windowController.setTop(this.mPanel, true);
            this.mPanel.btnContextMenu.enabled = this.isAnyMailSelected();
            this.mPanel.btnCollectOrDelete.enabled = (this.mPanel.btnCollectOrDelete.enabled = this.isAnyMailSelected());
            this.mPanel.deleteColumn.visible = this.isInbox;
        }

        public function init(_arg_1:MailWindow):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function exitEditState(_arg_1:Event):void
        {
            this.mPanel.btnSend.removeEventListener(MouseEvent.CLICK, this.sendMail);
            this.mPanel.btnCancelWrite.removeEventListener(MouseEvent.CLICK, this.cancelSend);
            this.mPanel.reciepientList.removeEventListener(KeyboardEvent.KEY_DOWN, this.listKeyDownHandler);
            this.mPanel.reciepientList.removeEventListener(ListEvent.ITEM_CLICK, this.selectReciepientFromList);
            this.mPanel.reciepientList.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, this.clickOutsideHandler);
            this.mPanel.toTileList.removeEventListener(MailRecipientEvent.RECIPIENT_ENTERED, this.recipientEnteredHandler);
            this.mPanel.toTileList.removeEventListener(MailRecipientEvent.SPECIAL_KEY_PRESS, this.keyEventHandler);
            this.mPanel.toTileList.removeEventListener(MailRecipientEvent.FOCUS_OUT, this.selectReciepientByName);
            this.mPanel.toTileList.removeEventListener(MailRecipientEvent.DELETE_RECIPIENT, this.removeReciepient);
            this.mPanel.toTileList.removeEventListener(FlexEvent.UPDATE_COMPLETE, this.toTileListUpdateCompleteHandler);
            this.mPanel.toTileList.removeEventListener(MouseEvent.CLICK, this.toTilesClicked);
            this.mPanel.subjectInput.removeEventListener(TextEvent.TEXT_INPUT, this.subjectInputTextInputHandler);
            this.mPanel.subjectInput.removeEventListener(Event.CHANGE, this.subjectInputChangeHandler);
            this.mPanel.editText.removeEventListener(Event.CHANGE, this.bodyInputChangeHandler);
            this.mReciepient = null;
            this.mReciepientGuild = null;
            this.mReplyMail = null;
            this.mReciepientGuildApplication = null;
            this.mRecipients = new ArrayCollection();
            this.mReplySubject = null;
            this.mReplyBody = "";
            this.replyBody = "";
            if (this.toInputField != null)
            {
                this.toInputField.text = "";
            };
            this.clearEdit();
            this.isInbox = true;
            this.updateMailListUI();
            this.pager.refresh();
        }

        private function declineGuildRequest(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            switch (this.mCurrentMail.type)
            {
                case MAIL_TYPE.GUILD_INVITE:
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_INVITE_DECLINE, 0, new dIntegerVO(this.mCurrentMail.id));
                    break;
                case MAIL_TYPE.GUILD_APPLY:
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_APPLY_DECLINE, 0, new dIntegerVO(this.mCurrentMail.id));
                    break;
                default:
                    return;
            };
            this.removeMail(this.mCurrentMail);
        }

        private function declineFriend(_arg_1:MouseEvent):Boolean
        {
            if (((this.isMailValid(this.mCurrentMail)) && (MAIL_TYPE.FRIEND_REQUEST == this.mCurrentMail.type)))
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.DECLINE_FRIEND_REQUEST, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
                this.removeMail(this.mCurrentMail);
                return (true);
            };
            return (false);
        }

        private function deleteMailFromServer(_arg_1:dMailVO):void
        {
            var _local_4:dMailVO;
            switch (_arg_1.type)
            {
                case MAIL_TYPE.TRADE:
                    this.declineTrade(null);
                    break;
                case MAIL_TYPE.FRIEND_REQUEST:
                    this.declineFriend(null);
                    break;
                case MAIL_TYPE.INVITE_TO_ADVENTURE:
                    this.declineAdventureInvite(null);
                    break;
                case MAIL_TYPE.GUILD_APPLY:
                    if (!this.removeMail(_arg_1))
                    {
                        return;
                    };
                    this.mCurrentMail = _arg_1;
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_APPLY_DECLINE, 0, new dIntegerVO(this.mCurrentMail.id));
                    break;
            };
            var _local_2:dDeleteMailsRequestVO = new dDeleteMailsRequestVO();
            var _local_3:ArrayCollection = new ArrayCollection();
            for each (_local_4 in this.mMailsToDelete)
            {
                _local_3.addItem(_local_4.id);
            };
            _local_2.mailsIDs_collection = _local_3;
            if (this.isInbox)
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.DELETE_INBOX_MAIL, this.mGI.mCurrentViewedZoneID, _local_2);
            }
            else
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.DELETE_OUTBOX_MAIL, this.mGI.mCurrentViewedZoneID, _local_2);
            };
            this.mCurrentMail = null;
            this.clear();
        }

        private function btnTradeDeclineClickHandler(_arg_1:MouseEvent):void
        {
            this.declineTrade(_arg_1);
        }

        public function setMail(_arg_1:dMailVO):void
        {
            if (_arg_1 == null)
            {
                cLog.warning("SetMail(): _mail is null");
                this.getMailHeaders();
                return;
            };
            var _local_2:dMailVO = this.mMailCache[_arg_1.id];
            if (_local_2 != null)
            {
                _arg_1.recipientIds_collection = _local_2.recipientIds_collection;
                _arg_1.recipientNames_collection = _local_2.recipientNames_collection;
            };
            this.mMailCache[_arg_1.id] = _arg_1;
            this.mCurrentMail = _arg_1;
            if (globalFlash.gui.mLoadingMailPanel.IsVisible())
            {
                globalFlash.gui.mLoadingMailPanel.notifyMailLoaded(_arg_1);
            }
            else
            {
                this.displayMail();
            };
        }

        private function isReplyable(_arg_1:dMailVO):Boolean
        {
            return ((_arg_1.type == MAIL_TYPE.MAIL) && (_arg_1.senderId > 0));
        }

        private function btnAdventureInviteDeclineClickHandler(_arg_1:MouseEvent):void
        {
            this.declineAdventureInvite(_arg_1);
        }

        private function getMailListIndex(_arg_1:dMailVO):int
        {
            var _local_3:dMailVO;
            if (_arg_1 == null)
            {
                return (-1);
            };
            var _local_2:int;
            while (_local_2 < this.mMails.length)
            {
                _local_3 = this.mMails[_local_2];
                if (_local_3.id == _arg_1.id)
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }

        private function defaultFocusOnNewMail():void
        {
            if (this.mPanel.currentState == this.mPanel.stateEdit.name)
            {
                if ((((this.mReplyMail) || (this.mReplyBody)) && (this.mfocusOnMailBody)))
                {
                    this.mPanel.editText.setFocus();
                    this.mfocusOnMailBody = false;
                }
                else
                {
                    if (this.toInputField)
                    {
                        this.toInputField.setFocus();
                    };
                };
            };
        }

        private function acceptTrade(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.ACCEPT_TRADE_MAIL, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
            this.removeMail(this.mCurrentMail);
            if (this.mPanel.tradeCostsRes.visible)
            {
                FloatingItemsManager.createJumpFlyDestroy(this.mPanel.tradeCostsResItemRenderer.resourceIcon, ("GAMESTATE_ID_FRIENDS_LIST." + this.mCurrentMail.senderName));
            }
            else
            {
                if (this.mPanel.tradeCostsBuff.visible)
                {
                    FloatingItemsManager.createJumpFlyDestroy(this.mPanel.tradeCostsBuffItemRenderer, ("GAMESTATE_ID_FRIENDS_LIST." + this.mCurrentMail.senderName));
                };
            };
            if (this.mPanel.tradeOfferRes.visible)
            {
                FloatingItemsManager.createJumpFlyDestroy(this.mPanel.tradeOfferResItemRenderer.resourceIcon, "GAMESTATE_ID_INFO_BAR.infoBarMiddle");
            }
            else
            {
                if (this.mPanel.tradeOfferBuff.visible)
                {
                    FloatingItemsManager.createJumpFlyDestroy(this.mPanel.tradeOfferBuffItemRenderer, CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER);
                };
            };
        }

        public function showReplyMail(_arg_1:Boolean):void
        {
            var _local_3:dPlayerListItemVO;
            var _local_4:Object;
            var _local_5:dMailVO;
            var _local_6:int;
            var _local_7:int;
            this.mReplyBody = "";
            this.mReplySubject = "";
            this.mReciepient = null;
            this.mReciepientGuild = null;
            this.mReplyMail = null;
            this.mReplyRecipients = new ArrayCollection();
            var _local_2:Dictionary = new Dictionary();
            for (_local_4 in this.mSelectedMails)
            {
                if (this.mRecipients.length > global.maxRecipients)
                {
                    CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "MailMaxRecipientsLimit", [global.maxRecipients]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "MailMaxRecipientsLimit"), Alert.OK, null, null, null, 4, false);
                    break;
                };
                _local_5 = (this.mMailCache[_local_4] as dMailVO);
                if (((_local_5.type == MAIL_TYPE.MAIL) && (_local_5.senderId > 1)))
                {
                    if (this.mReplySubject.length > 0)
                    {
                        this.mReplySubject = (this.mReplySubject + ", ");
                    }
                    else
                    {
                        this.mReplySubject = "Re: ";
                    };
                    this.mReplySubject = (this.mReplySubject + _local_5.subject);
                    this.mReplySubject = this.mReplySubject.substring(0, MAX_SUBJECT_CHAR);
                    this.mReplyBody = (this.mReplyBody + "\r\r-----------------------------------------------------------------------------------\r");
                    this.mReplyBody = (this.mReplyBody + (_local_5.senderName + ":\r\r"));
                    this.mReplyBody = (this.mReplyBody + _local_5.body);
                    this.replyBody = ("" + this.mReplyBody);
                    if (!this.isRecipientInList(this.mReplyRecipients, _local_5.senderId))
                    {
                        _local_3 = new dPlayerListItemVO();
                        _local_3.id = _local_5.senderId;
                        _local_3.username = _local_5.senderName;
                        this.mReplyRecipients.addItem(_local_3);
                        if (this.mReciepient == null)
                        {
                            this.mReciepient = _local_3;
                        };
                    };
                    if (_arg_1)
                    {
                        _local_6 = 0;
                        while (_local_6 < _local_5.recipientIds_collection.length)
                        {
                            _local_7 = _local_5.recipientIds_collection[_local_6];
                            if (this.mRecipients.length > global.maxRecipients)
                            {
                                CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "MailMaxRecipientsLimit", [global.maxRecipients]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "MailMaxRecipientsLimit"), Alert.OK, null, null, null, 4, false);
                                break;
                            };
                            if (!this.isRecipientInList(this.mReplyRecipients, _local_7))
                            {
                                _local_3 = new dPlayerListItemVO();
                                _local_3.id = _local_7;
                                _local_3.username = _local_5.recipientNames_collection[_local_6];
                                this.mReplyRecipients.addItem(_local_3);
                                if (this.mReciepient == null)
                                {
                                    this.mReciepient = _local_3;
                                };
                            };
                            _local_6++;
                        };
                    };
                };
            };
            this.mPanel.currentState = this.mPanel.stateEdit.name;
        }

        private function btnDeleteMailClickHandler(_arg_1:Event):void
        {
            var _local_2:dMailVO = (this.mPanel.mailsList.selectedItem as dMailVO);
            this.removeMail(_local_2, true);
        }

        private function keyEventHandler(_arg_1:KeyboardEvent):void
        {
            switch (_arg_1.keyCode)
            {
                case Keyboard.ENTER:
                    this.mPanel.reciepientList.selectedIndex = 0;
                    this.selectReciepientFromList(null);
                    this.mPanel.subjectInput.setFocus();
                    return;
                case Keyboard.UP:
                    if (this.mPanel.reciepientList.visible)
                    {
                        this.mPanel.reciepientList.setFocus();
                        this.mPanel.reciepientList.selectedIndex = ((this.mPanel.reciepientList.dataProvider as ArrayCollection).length - 1);
                    };
                case Keyboard.DOWN:
                    if (this.mPanel.reciepientList.visible)
                    {
                        this.mPanel.reciepientList.setFocus();
                        this.mPanel.reciepientList.selectedIndex = 0;
                    };
                    return;
            };
        }

        private function maxBodyLimitHandler(_arg_1:CloseEvent):void
        {
            this.mPanel.editText.addEventListener(Event.CHANGE, this.bodyInputChangeHandler);
        }

        private function dismissSelectedMails(_arg_1:Boolean):void
        {
            var _local_2:dDismissMailsRequestVO;
            var _local_3:ArrayCollection;
            var _local_4:dMailVO;
            if (this.mMailsToDelete.length != 0)
            {
                this.mPanel.busyOverlay.visible = true;
                this.mPanel.pulsate.play();
                this.mPanel.deleteIcon.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DeletingMails");
                _local_2 = new dDismissMailsRequestVO();
                _local_3 = new ArrayCollection();
                for each (_local_4 in this.mMailsToDelete)
                {
                    _local_3.addItem(_local_4.id);
                };
                this.mMailsToDelete.removeAll();
                _local_2.mailsIDs_collection = _local_3;
                _local_2.claim = _arg_1;
                this.mGI.mClientMessages.SendMessagetoServer(((this.isInbox) ? COMMAND.DISMISS_MAILS : COMMAND.DELETE_OUTBOX_MAIL), this.mGI.mCurrentViewedZoneID, _local_2);
                this.mCurrentMail = null;
                this.clear();
                this.mPanel.btnCollectOrDelete.enabled = false;
            };
        }

        public function get mailTypeContextMenu():cMailTypeContextMenu
        {
            var _local_1:Point;
            if (!this._mailTypeContextMenu)
            {
                this._mailTypeContextMenu = new cMailTypeContextMenu();
                _local_1 = this.mPanel.globalToLocal(this.mailTypeHeader.localToGlobal(new Point(0, this.mailTypeHeader.height)));
                this._mailTypeContextMenu.Init(new MailTypeContextMenu(), this.mPanel, _local_1);
                this._mailTypeContextMenu.addEventListener(MailTypeFilterItemRenderer.CHANGED, this.onMailTypeFilterChanged, false, 0, true);
            };
            return (this._mailTypeContextMenu);
        }

        private function fillInSelectedMailIDs(_arg_1:ArrayCollection):void
        {
            var _local_2:Object;
            for (_local_2 in this.mSelectedMails)
            {
                _arg_1.addItem((this.mSelectedMails[_local_2] as dMailVO));
            };
        }

        private function sendMail(_arg_1:MouseEvent):void
        {
            var _local_3:ArrayCollection;
            var _local_4:uint;
            var _local_2:dMailVO = new dMailVO();
            if (this.mReciepientGuild)
            {
                _local_2.body = this.mPanel.editText.text;
                _local_2.senderName = "";
                _local_2.subject = this.mPanel.subjectInput.text;
                _local_2.reciepientId = this.mReciepientGuild.id;
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_SEND_MAIL, this.mGI.mCurrentViewedZoneID, _local_2);
            }
            else
            {
                if (this.mReciepientGuildApplication)
                {
                    _local_2.body = this.mPanel.messageText.text;
                    _local_2.senderName = "";
                    _local_2.subject = this.mPanel.subjectApply.text;
                    _local_2.reciepientId = this.mReciepientGuildApplication.id;
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_APPLY, this.mGI.mCurrentViewedZoneID, _local_2);
                }
                else
                {
                    _local_2.body = this.mPanel.editText.text;
                    _local_2.senderName = "";
                    _local_2.subject = this.mPanel.subjectInput.text;
                    _local_3 = new ArrayCollection();
                    _local_4 = 0;
                    while (_local_4 < this.mRecipients.length)
                    {
                        if ((this.mRecipients[_local_4] is dPlayerListItemVO))
                        {
                            _local_2.reciepientId = this.mRecipients[_local_4].id;
                            _local_3.addItem(this.mRecipients[_local_4].id);
                        };
                        _local_4++;
                    };
                    _local_2.recipientIds_collection = _local_3;
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.SEND_MAIL, this.mGI.mCurrentViewedZoneID, _local_2);
                };
            };
            this.mReciepient = null;
            this.mReciepientGuild = null;
            this.mReciepientGuildApplication = null;
            this.mReplyMail = null;
            this.mReplyBody = null;
            this.mReplyRecipients = new ArrayCollection();
            if (this.mPanel.toTileList)
            {
                this.mPanel.toTileList.dataProvider = null;
            };
            if (this.mPanel.currentState != this.mPanel.stateApply.name)
            {
                this.clearEdit();
            };
            this.Hide();
            this.hasDraft = false;
        }

        public function editGuildMail(_arg_1:dGuildVO):void
        {
            this.mReciepientGuild = _arg_1;
            if (this.mPanel.currentState != this.mPanel.stateEdit.name)
            {
                this.mPanel.currentState = this.mPanel.stateEdit.name;
            };
            this.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        override public function Hide():void
        {
            this.hasDraft = ((this.mPanel.currentState == this.mPanel.stateEdit.name) && ((this.mPanel.editText.text.length > 0) || (this.mPanel.subjectInput.text.length > 0)));
            super.Hide();
            if (!this.hasDraft)
            {
                this.mReciepient = null;
                this.mPanel.currentState = "";
            };
            globalFlash.gui.mFriendsList.enableDisableFriendListOptions(true);
            if (this.mExpirationUpdateIntervalId != 0)
            {
                clearInterval(this.mExpirationUpdateIntervalId);
            };
        }

        protected function onMailTypeFilterChanged(_arg_1:Event=null):void
        {
            var _local_4:dMailVO;
            var _local_5:int;
            var _local_6:Boolean;
            if (this.mMails == null)
            {
                return;
            };
            var _local_2:Vector.<int> = this.mailTypeContextMenu.selectedMailGroups;
            var _local_3:int;
            while (_local_3 < this.mMails.length)
            {
                _local_4 = (this.mMails.getItemAt(_local_3) as dMailVO);
                _local_5 = MAIL_TYPE_GROUP.getMailGroup(_local_4.type, _local_4.read);
                _local_6 = (!(_local_2.indexOf(_local_5) == -1));
                this.setMailSelected(_local_4, _local_6, false);
                _local_3++;
            };
            this.mMails.refresh();
            this.setMailSelected(null, true, true);
            this.mPanel.btnContextMenu.enabled = (this.mPanel.btnCollectOrDelete.enabled = ((this.isAnyMailSelected()) && (this.isInbox)));
            this.mContextMenu.UpdateMenuItemState(this.mSelectedMails, this.isInbox, this.mGI.mCurrentPlayer.GetPlayerId());
        }

        private function panelStateChangingHandler(_arg_1:StateChangeEvent):void
        {
            this.clear();
            if (((!(_arg_1.newState == this.mPanel.stateEdit.name)) && (!(_arg_1.newState == this.mPanel.stateSentbox.name))))
            {
                this.mPanel.btnInbox.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundHighlight"));
                this.mPanel.btnOutbox.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            }
            else
            {
                if (_arg_1.newState == this.mPanel.stateSentbox.name)
                {
                    this.mPanel.btnOutbox.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundHighlight"));
                    this.mPanel.btnInbox.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
                };
            };
            this.updateSendButtonState();
        }

        private function onDismissMailsAccepted(_arg_1:DismissMailCloseEvent):void
        {
            if (_arg_1.detail == DismissMailsAlert.ACCEPT)
            {
                this.dismissSelectedMails(_arg_1.toStorage);
            }
            else
            {
                this.mMailsToDelete.removeAll();
            };
        }

        private function replayBattle(_arg_1:MouseEvent):void
        {
            var _local_2:BattleWindow;
            if (globalFlash.gui.mBattleWindow == null)
            {
                _local_2 = new BattleWindow();
                _local_2.id = "GAMESTATE_ID_BATTLE_WINDOW";
                global.getApplication().isoengine.addChild(_local_2);
                globalFlash.gui.mBattleWindow = new cBattleWindow();
                globalFlash.gui.mBattleWindow.Init(_local_2);
            };
            globalFlash.gui.mBattleWindow.SetData((this.mCurrentMail.attachments as dBattleReportBodyVO).battleScript);
            globalFlash.gui.mBattleWindow.Show();
        }

        private function exitApplyState(_arg_1:Event):void
        {
            this.mPanel.btnSend.removeEventListener(MouseEvent.CLICK, this.sendMail);
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Inbox");
            this.mReciepient = null;
            this.mReciepientGuild = null;
            this.mReplyMail = null;
            this.mReciepientGuildApplication = null;
            this.replyBody = "";
            this.clearApply();
        }

        public function setMailHeaderResponse(_arg_1:dMailHeaderResponseVO):void
        {
            if (_arg_1.headers_collection == null)
            {
                this.getMailHeaders();
                return;
            };
            this.pager.page = 0;
            if (this.isInbox == _arg_1.isInbox)
            {
                this.lastSelectedItem = this.mPanel.mailsList.selectedItem;
                _arg_1.headers_collection.sort = this.mSort;
                _arg_1.headers_collection.refresh();
                this.mLastExpirationUpdateTime = getTimer();
                this.mMails = _arg_1.headers_collection;
                this.updateMailListUI();
                this.pager.source = this.mMails;
                this.pager.view;
            };
            this.mPanel.busyOverlay.visible = false;
            this.pager.refresh();
            this.mailTypeContextMenu.updateAvailableTypes(this.mMails);
        }

        private function prepareAppliedSkillsTooltip(_arg_1:String, _arg_2:VBox):void
        {
            var _local_6:SkillVO;
            var _local_9:SkillToolTipData;
            var _local_10:Label;
            var _local_11:SkillDefinition;
            var _local_12:SkillVO;
            var _local_13:SkillTipRenderer;
            var _local_3:Dictionary = new Dictionary();
            var _local_4:Array = _arg_1.split(",");
            var _local_5:ArrayCollection = new ArrayCollection();
            var _local_7:int;
            var _local_8:int;
            while (_local_8 < _local_4.length)
            {
                _local_6 = new SkillVO();
                _local_6.id = _local_4[_local_8];
                _local_6.level = _local_4[(_local_8 + 1)];
                if (!(_local_6.toString() in _local_3))
                {
                    if (!(((_local_6.level == 0) || (_local_6.id == 0)) || (_local_6.id == _local_7)))
                    {
                        _local_7 = _local_6.id;
                        _local_5.addItem(_local_6);
                        _local_3[_local_6.toString()] = 1;
                    };
                };
                _local_8 = (_local_8 + 2);
            };
            if (_local_5.length > 0)
            {
                _local_9 = new SkillToolTipData();
                _local_9.skills = _local_5;
                _local_10 = new Label();
                _local_10.setStyle("color", 13876873);
                _local_10.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdditionalSkillInfo");
                _arg_2.addChild(_local_10);
                for each (_local_12 in _local_5)
                {
                    _local_11 = global.skills_vector[_local_12.id];
                    if ((((!(_local_11 == null)) && (!(_local_11.icon_string == null))) && (!(_local_11.icon_string == ""))))
                    {
                        _local_13 = new SkillTipRenderer();
                        _local_13.setSkillVO(_local_12);
                        _arg_2.addChild(_local_13);
                    };
                };
                _arg_2.includeInLayout = (_arg_2.visible = (_arg_2.numChildren > 0));
            };
        }

        private function set mRecipients(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._947992121mRecipients;
            if (_local_2 !== _arg_1)
            {
                this._947992121mRecipients = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mRecipients", _local_2, _arg_1));
            };
        }

        private function deleteMultipleMails(_arg_1:DismissMailCloseEvent=null):void
        {
            var _local_2:dDeleteMailsRequestVO;
            var _local_3:ArrayCollection;
            var _local_4:dMailVO;
            if (((_arg_1 == null) || (_arg_1.detail == DismissMailsAlert.ACCEPT)))
            {
                if (this.mMailsToDelete.length != 0)
                {
                    this.mPanel.pulsate.play();
                    this.mPanel.deleteIcon.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DeletingMails");
                    _local_2 = new dDeleteMailsRequestVO();
                    _local_3 = new ArrayCollection();
                    for each (_local_4 in this.mMailsToDelete)
                    {
                        _local_3.addItem(_local_4.id);
                    };
                    _local_2.mailsIDs_collection = _local_3;
                    this.mGI.mClientMessages.SendMessagetoServer(((this.isInboxActive()) ? COMMAND.DELETE_INBOX_MAIL : COMMAND.DELETE_OUTBOX_MAIL), this.mGI.mCurrentViewedZoneID, _local_2);
                    this.mCurrentMail = null;
                    this.clear();
                };
            }
            else
            {
                this.mMailsToDelete.removeAll();
            };
        }

        private function clickOutsideHandler(_arg_1:Event):void
        {
            this.mPanel.reciepientList.visible = false;
            this.mPanel.reciepientList.dataProvider = null;
            if (this.toInputField)
            {
                this.toInputField.setFocus();
            };
        }

        private function displayMail():void
        {
            var _local_2:String;
            var _local_3:Boolean;
            var _local_4:int;
            var _local_5:cTradeObject;
            var _local_6:String;
            var _local_7:int;
            var _local_8:String;
            var _local_9:int;
            var _local_10:cTradeObject;
            var _local_11:String;
            var _local_12:String;
            var _local_13:cBuff;
            var _local_14:int;
            var _local_15:String;
            var _local_16:String;
            var _local_17:dGuildVO;
            var _local_18:int;
            var _local_19:Array;
            var _local_20:String;
            var _local_21:dLootItemsVO;
            var _local_22:dLootItemsVO;
            var _local_23:dLootItemsVO;
            var _local_24:dResource;
            var _local_25:cAdventureDefinition;
            var _local_26:String;
            var _local_27:XML;
            var _local_28:Array;
            var _local_29:Array;
            var _local_30:String;
            var _local_31:ArrayCollection;
            var _local_32:String;
            var _local_33:XML;
            var _local_34:SkillVO;
            var _local_35:int;
            var _local_36:dResourceVO;
            var _local_37:dBuffVO;
            var _local_38:dResourceVO;
            var _local_39:dBuffVO;
            var _local_40:cBuilding;
            var _local_41:String;
            var _local_42:String;
            var _local_43:cShopItem;
            if (this.mPanel.mailsList.selectedItem == null)
            {
                cLog.warning("DisplayMail(): mPanel.mailsList.selectedItem is null");
                return;
            };
            if (this.mCurrentMail == null)
            {
                cLog.warning("DisplayMail(): mCurrentMail is null");
                return;
            };
            var _local_1:dMailVO = (this.mPanel.mailsList.selectedItem as dMailVO);
            if (this.isInboxActive())
            {
                _local_1.read = (this.mCurrentMail.read = true);
            };
            _local_1.body = this.mCurrentMail.body;
            _local_1.attachments = this.mCurrentMail.attachments;
            this.mPanel.buffedBuff.visible = true;
            this.mPanel.buffedArrow.visible = true;
            this.mPanel.buffedBuilding.visible = true;
            _local_2 = cGeneralInterface.getComputedPlayerName(this.mCurrentMail.senderName);
            switch (this.mCurrentMail.type)
            {
                case MAIL_TYPE.MAIL:
                    this.mPanel.subjectLabel.text = ((this.isInbox) ? ((_local_2 + ": ") + this.mCurrentMail.subject) : ("Sent To " + _local_2));
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentMail;
                    this.mPanel.bodyText.text = this.mCurrentMail.body;
                    break;
                case MAIL_TYPE.ADVENTURE_FAILED_CANCELLED:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdventureCancelledByOwnerMailSubject");
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentMail;
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "AdventureCancelledByOwnerMailBody");
                    break;
                case MAIL_TYPE.LOCA_MAIL:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (this.mCurrentMail.subject + "MailSubject"));
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentMail;
                    this.mPanel.bodyText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (this.mCurrentMail.subject + "MailBody"));
                    break;
                case MAIL_TYPE.NPC_MAIL:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.GAME_MESSAGE_LABELS, this.mCurrentMail.subject);
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentMail;
                    this.mPanel.bodyText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.GAME_MESSAGES, this.mCurrentMail.body);
                    break;
                case MAIL_TYPE.BATTLE_REPORT:
                case MAIL_TYPE.BATTLE_REPORT_INTERCEPTED:
                    if (this.mCurrentMail.subject != "")
                    {
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "AdventureMailSubject"), [this.mCurrentMail.subject]);
                        this.mPanel.battleReportText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "AdventureMailBody"), [this.mCurrentMail.subject]);
                    }
                    else
                    {
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailSubject"));
                        this.mPanel.battleReportText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailBody"));
                    };
                    if ((this.mCurrentMail.attachments as dBattleReportBodyVO).battleScript != "")
                    {
                        _local_27 = new XML((this.mCurrentMail.attachments as dBattleReportBodyVO).battleScript);
                        _local_28 = this.calculateCombatReportUsedArmy(_local_27);
                        this.mPanel.armyUsedList.rowCount = ((_local_28.length > 8) ? 2 : 1);
                        this.mPanel.armyUsedList.dataProvider = _local_28;
                        _local_29 = this.calculateCombatReportTotalCasualties(_local_27);
                        this.mPanel.armyLossesList.rowCount = ((_local_29.length > 8) ? 2 : 1);
                        this.mPanel.armyLossesList.dataProvider = _local_29;
                        this.mPanel.armyUsedLabel.width = (this.mPanel.armyLossesLabel.width = Math.max(this.mPanel.armyUsedLabel.width, this.mPanel.armyLossesLabel.width));
                        _local_30 = "";
                        this.mPanel.skillListGenerals.visible = (this.mPanel.skillListGenerals.includeInLayout = false);
                        _local_31 = new ArrayCollection();
                        if (_local_27.Skills[0] != null)
                        {
                            for each (_local_33 in _local_27.Skills[0].SkillVO)
                            {
                                if (_local_33.attribute("isUsed") != "false")
                                {
                                    _local_34 = new SkillVO();
                                    _local_34.id = parseInt(_local_33.attribute("id"));
                                    _local_34.level = parseInt(_local_33.attribute("level"));
                                    _local_31.addItem(_local_34);
                                };
                            };
                        };
                        for each (_local_32 in _local_27.Skills.attribute("skills").toString().split(","))
                        {
                            _local_35 = parseInt(_local_32.split(":")[0]);
                            if ((((!(_local_35 == 86)) && (!(_local_35 == 86))) && (!(_local_35 == 91))))
                            {
                                _local_30 = (_local_30 + (((_local_32.split(":")[0] + ",") + _local_32.split(":")[2]) + ","));
                            };
                        };
                        _local_30 = _local_30.substr(0, (_local_30.length - 1));
                        this.prepareGeneralSkillForBattleReport(_local_31, this.mPanel.skillListGenerals);
                    };
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentBattleReport;
                    this.mPanel.btnReplay.enabled = (!((this.mCurrentMail.attachments as dBattleReportBodyVO).battleScript == ""));
                    break;
                case MAIL_TYPE.PVP_COMBAT_REPORT_ATTACKER_WON:
                case MAIL_TYPE.PVP_COMBAT_REPORT_ATTACKER_LOST:
                case MAIL_TYPE.PVP_COMBAT_REPORT_DEFENDER_WON:
                case MAIL_TYPE.PVP_COMBAT_REPORT_DEFENDER_LOST:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailSubject"));
                    this.mPanel.battleReportText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailBody"));
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentPvPReport;
                    this.mPanel.btnPvPReport.enabled = true;
                    break;
                case MAIL_TYPE.TRADE:
                    _local_3 = true;
                    _local_4 = gMisc.ParseInt(this.mCurrentMail.subject);
                    _local_5 = new cTradeObject(this.mCurrentMail.body, _local_4);
                    _local_6 = "";
                    _local_7 = 0;
                    if ((_local_5.offer is dResourceVO))
                    {
                        _local_36 = (_local_5.offer as dResourceVO);
                        _local_6 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_36.name_string);
                        _local_7 = _local_36.amount;
                        this.mPanel.tradeOfferRes.visible = true;
                        this.mPanel.tradeOfferBuff.visible = false;
                        this.mPanel.tradeOfferResItemRenderer.data = _local_36;
                    }
                    else
                    {
                        if ((_local_5.offer is dBuffVO))
                        {
                            _local_37 = (_local_5.offer as dBuffVO);
                            _local_6 = cBuff.CreateBuffFromVO(_local_37).getLocalizedBuffName();
                            _local_7 = _local_37.amount;
                            this.mPanel.tradeOfferRes.visible = false;
                            this.mPanel.tradeOfferBuff.visible = true;
                            this.mPanel.tradeOfferBuffItemRenderer.data = _local_37;
                        };
                    };
                    _local_8 = "";
                    _local_9 = 0;
                    if ((_local_5.costs is dResourceVO))
                    {
                        _local_38 = (_local_5.costs as dResourceVO);
                        _local_8 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_38.name_string);
                        _local_9 = _local_38.amount;
                        this.mPanel.tradeCostsRes.visible = true;
                        this.mPanel.tradeCostsBuff.visible = false;
                        this.mPanel.tradeCostsResItemRenderer.data = _local_38;
                        if (!this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer).HasPlayerResource(_local_38.name_string, _local_38.amount))
                        {
                            _local_3 = false;
                        };
                    }
                    else
                    {
                        if ((_local_5.costs is dBuffVO))
                        {
                            _local_39 = (_local_5.costs as dBuffVO);
                            _local_8 = cBuff.CreateBuffFromVO(_local_39).getLocalizedBuffName();
                            _local_9 = 1;
                            this.mPanel.tradeCostsRes.visible = false;
                            this.mPanel.tradeCostsBuff.visible = true;
                            this.mPanel.tradeCostsBuffItemRenderer.data = _local_39;
                            if (!this.mGI.mCurrentPlayer.hasBuffByBuffVO(_local_39))
                            {
                                _local_3 = false;
                            };
                        };
                    };
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "MailSubjectTrade", [_local_7, _local_6, _local_9, _local_8]);
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentTrade;
                    this.mPanel.tradeInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "TradeOfferMailBody", [_local_2]);
                    if (!this.mGI.mCurrentPlayerZone.IsBuildingOnMap(defines.LOGISTICS_NAME_string))
                    {
                        this.mPanel.btnTradeAccept.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotAcceptTrade");
                        this.mPanel.btnTradeAccept.enabled = false;
                    }
                    else
                    {
                        if (!_local_3)
                        {
                            this.mPanel.btnTradeAccept.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotAffordTrade");
                            this.mPanel.btnTradeAccept.enabled = false;
                        }
                        else
                        {
                            this.mPanel.btnTradeAccept.toolTip = "";
                            this.mPanel.btnTradeAccept.enabled = true;
                            if (this.mPanel.currentState == this.mPanel.stateSentbox.name)
                            {
                                this.mPanel.btnTradeAccept.enabled = false;
                            };
                        };
                    };
                    break;
                case MAIL_TYPE.TRADE_ACCEPTED:
                case MAIL_TYPE.TRADE_DECLINED:
                    _local_10 = new cTradeObject(this.mCurrentMail.body, gMisc.ParseInt(this.mCurrentMail.subject));
                    if ((_local_10.offer is dResourceVO))
                    {
                        this.mPanel.completedRes.visible = true;
                        this.mPanel.completedBuff.visible = false;
                        this.mPanel.completedRes.data = (_local_10.offer as dResourceVO);
                    }
                    else
                    {
                        if ((_local_10.offer is dBuffVO))
                        {
                            this.mPanel.completedBuff.visible = true;
                            this.mPanel.completedRes.visible = false;
                            this.mPanel.completedBuff.data = (_local_10.offer as dBuffVO);
                        };
                    };
                    if (this.mGI.IsAdventureZoneID(this.mGI.mCurrentViewedZoneID))
                    {
                        this.mPanel.btnTradeComplete.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotAcceptTrade");
                        this.mPanel.btnTradeComplete.enabled = false;
                    }
                    else
                    {
                        this.mPanel.btnTradeComplete.toolTip = "";
                        this.mPanel.btnTradeComplete.enabled = true;
                    };
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentTradeComplete;
                    if (this.mCurrentMail.type == MAIL_TYPE.TRADE_ACCEPTED)
                    {
                        this.mPanel.tradeCompleteInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (("TradeAccepted" + ((this.mPanel.completedBuff.visible) ? "Buff" : "")) + "MailBody"), [_local_2]);
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TradeAcceptedSubject");
                    }
                    else
                    {
                        this.mPanel.tradeCompleteInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (("TradeDeclined" + ((this.mPanel.completedBuff.visible) ? "Buff" : "")) + "MailBody"), [_local_2]);
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TradeDeclinedSubject");
                    };
                    break;
                case MAIL_TYPE.BUFFED_BUILDING:
                case MAIL_TYPE.BUFFED_DEPOSIT:
                    _local_13 = cBuff.CreateBuffFromVO((this.mCurrentMail.attachments as dBuffedDataVO).buffVO);
                    _local_14 = (this.mCurrentMail.attachments as dBuffedDataVO).buffedObjectGridIdx;
                    if (this.mCurrentMail.type == MAIL_TYPE.BUFFED_BUILDING)
                    {
                        _local_11 = "BuffedBuildingMailSubject";
                        if (this.mGI.IsAdventureZoneID(this.mGI.mCurrentViewedZoneID))
                        {
                            _local_12 = "BuffedUnknownBuildingMailBody";
                            this.mPanel.buffedBuff.visible = false;
                            this.mPanel.buffedArrow.visible = false;
                            this.mPanel.buffedBuilding.visible = false;
                        }
                        else
                        {
                            if (_local_13.GetBuffDefinition().GetName_string().indexOf("ChangeColorScheme") >= 0)
                            {
                                _local_12 = ("ChangeColorScheme_" + _local_13.GetResourceName_string());
                            }
                            else
                            {
                                if (((_local_13.GetBuffDefinition().getProductivityOutputPercent() < 100) && (_local_13.GetBuffDefinition().getRecruitingTime() == 0)))
                                {
                                    _local_12 = "BuffedBuildingNegativeMailBody";
                                }
                                else
                                {
                                    _local_12 = "BuffedBuildingMailBody";
                                };
                            };
                            _local_40 = this.mGI.mCurrentPlayerZone.GetBuildingFromGridPosition(_local_14);
                            if (_local_40 == null)
                            {
                                this.mPanel.buffedBuff.visible = false;
                                this.mPanel.buffedArrow.visible = false;
                                this.mPanel.buffedBuilding.visible = false;
                            }
                            else
                            {
                                _local_41 = _local_40.GetBuildingName_string();
                                this.mPanel.buffedBuilding.source = gAssetManager.GetBuildingIcon(_local_41);
                                this.mPanel.buffedBuilding.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_41);
                            };
                        };
                    }
                    else
                    {
                        _local_11 = "BuffedDepositMailSubject";
                        if (((!(this.isInbox)) || (this.mGI.IsAdventureZoneID(this.mGI.mCurrentViewedZoneID))))
                        {
                            _local_12 = "BuffedUnknownDepositMailBody";
                            this.mPanel.buffedBuff.visible = false;
                            this.mPanel.buffedArrow.visible = false;
                            this.mPanel.buffedBuilding.visible = false;
                        }
                        else
                        {
                            _local_12 = "BuffedDepositMailBody";
                            _local_42 = this.mGI.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_14).GetName_string();
                            this.mPanel.buffedBuilding.source = gAssetManager.GetResourceIcon(_local_42);
                            this.mPanel.buffedBuilding.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_42);
                        };
                    };
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_11, [_local_2]);
                    this.mPanel.buffedInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_12, [_local_2]);
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentBuffed;
                    this.mPanel.buffedBuff.data = _local_13;
                    break;
                case MAIL_TYPE.GUILD_INVITE:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildInviteMailSubject", [this.mCurrentMail.subject]);
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentGuildRequest;
                    this.mPanel.guildRequestInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "GuildInviteMailBody", [_local_2, (this.mCurrentMail.attachments as dGuildBodyVO).guildName]);
                    this.mPanel.guildRequestButtons.visible = this.isInbox;
                    if (this.mGI.GetCurrentPlayerGuild() == null)
                    {
                        this.mPanel.btnGuildRequestAccept.toolTip = "";
                        this.mPanel.btnGuildRequestAccept.enabled = true;
                    }
                    else
                    {
                        this.mPanel.btnGuildRequestAccept.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotAcceptGuildInvite");
                        this.mPanel.btnGuildRequestAccept.enabled = false;
                    };
                    this.mPanel.guildIncreaseButtons.visible = false;
                    break;
                case MAIL_TYPE.GUILD_APPLY:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildApplyMailSubject", [_local_2]);
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentGuildRequest;
                    _local_15 = this.mCurrentMail.body.split("::")[1];
                    _local_16 = "";
                    if ((this.mCurrentMail.attachments is dGuildBodyVO))
                    {
                        _local_16 = (this.mCurrentMail.attachments as dGuildBodyVO).guildName;
                    };
                    this.mPanel.guildRequestInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "GuildApplyMailBody", [_local_2, _local_16, _local_15]);
                    this.mPanel.guildRequestButtons.visible = true;
                    _local_17 = this.mGI.GetCurrentPlayerGuild();
                    if (((_local_17 == null) || (_local_17.size >= _local_17.maxSize)))
                    {
                        this.mPanel.btnGuildRequestAccept.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotAcceptGuildApplication");
                        this.mPanel.btnGuildRequestAccept.enabled = false;
                    }
                    else
                    {
                        this.mPanel.btnGuildRequestAccept.toolTip = "";
                        this.mPanel.btnGuildRequestAccept.enabled = true;
                    };
                    this.mPanel.guildIncreaseButtons.visible = false;
                    if (!this.isInbox)
                    {
                        this.mPanel.btnGuildRequestAccept.visible = false;
                        this.mPanel.btnGuildRequestDecline.visible = false;
                    };
                    break;
                case MAIL_TYPE.GUILD_SUCCESSION_REQUEST:
                case MAIL_TYPE.GUILD_SUCCESSION_DUE_TO_INACTIVE:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailSubject"));
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentGuildSuccessionRequest;
                    this.mPanel.guildSuccessionRequestInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailBody"));
                    _local_18 = int(this.mCurrentMail.body);
                    this.mPanel.btnGuildSuccessionRequestAccept.enabled = (((!(this.mGI.mCurrentPlayerZone.mStreetDataMap.GetGuildHouse() == null)) && (!(this.mGI.GetCurrentPlayerGuild() == null))) && (_local_18 == this.mGI.GetCurrentPlayerGuild().id));
                    if (this.mPanel.btnGuildSuccessionRequestAccept.enabled)
                    {
                        this.mPanel.btnGuildSuccessionRequestAccept.toolTip = null;
                    }
                    else
                    {
                        if (((this.mGI.GetCurrentPlayerGuild() == null) || (!(_local_18 == this.mGI.GetCurrentPlayerGuild().id))))
                        {
                            this.mPanel.btnGuildSuccessionRequestAccept.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildSuccessionNotInGuild");
                        }
                        else
                        {
                            this.mPanel.btnGuildSuccessionRequestAccept.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildHouseRequired");
                        };
                    };
                    break;
                case MAIL_TYPE.GUILD_LEADER_CHANGED:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildLeaderChangedMailSubject");
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentMail;
                    this.mPanel.bodyText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "GuildLeaderChangedMailBody", [_local_2]);
                    break;
                case MAIL_TYPE.GUILD_NEW_LEADER:
                case MAIL_TYPE.GUILD_OLD_LEADER:
                case MAIL_TYPE.GUILD_SUCCESSION_DECLINED:
                case MAIL_TYPE.GUILD_SUCCESSION_EXPIRED:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailSubject"));
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentMail;
                    this.mPanel.bodyText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailBody"));
                    break;
                case MAIL_TYPE.GUILD_KICK:
                case MAIL_TYPE.GUILD_INVITE_DECLINE:
                case MAIL_TYPE.GUILD_INVITE_FULL:
                case MAIL_TYPE.GUILD_APPLY_ACCEPTED:
                case MAIL_TYPE.GUILD_APPLY_DECLINED:
                    if (this.mCurrentMail.type == MAIL_TYPE.GUILD_KICK)
                    {
                        _local_19 = [this.mCurrentMail.subject];
                    }
                    else
                    {
                        _local_19 = [_local_2];
                    };
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailSubject"), _local_19);
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentGuildRequest;
                    this.mPanel.guildRequestInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailBody"), [_local_2, this.mCurrentMail.subject]);
                    this.mPanel.guildIncreaseButtons.visible = ((this.isInbox) && (this.mCurrentMail.type == MAIL_TYPE.GUILD_INVITE_FULL));
                    this.mPanel.guildRequestButtons.visible = false;
                    break;
                case MAIL_TYPE.FRIEND_REQUEST:
                    if (!this.mGI.IsAdventureZoneID(this.mGI.mCurrentViewedZoneID))
                    {
                        this.mPanel.btnFriendAccept.enabled = true;
                    };
                    if (!this.isInbox)
                    {
                        this.mPanel.btnFriendAccept.visible = false;
                        this.mPanel.btnFriendDecline.visible = false;
                    };
                    _local_20 = ((this.isInbox) ? _local_2 : global.ui.mCurrentPlayer.GetPlayerName_string());
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "FriendMailSubject", [_local_2]);
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentFriendRequest;
                    this.mPanel.friendRequestInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "FriendRequestMailBody", [_local_2]);
                    this.mPanel.friendRequestAvatar.data = (this.mCurrentMail.attachments as dFriendBodyVO).player;
                    break;
                case MAIL_TYPE.FRIEND_INVITATION_CONFIRMED:
                    if (this.mCurrentMail.subject != "")
                    {
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "FriendInvitationConfirmedSubject", [this.mCurrentMail.subject]);
                        this.mPanel.friendInvitationInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "FriendInvitationConfirmedBody", [this.mCurrentMail.subject, (this.mCurrentMail.attachments as dFriendBodyVO).player.username]);
                    }
                    else
                    {
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "FriendInvitationNamelessConfirmedSubject");
                        this.mPanel.friendInvitationInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "FriendInvitationNamelessConfirmedBody", [(this.mCurrentMail.attachments as dFriendBodyVO).player.username]);
                    };
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentFriendInvitation;
                    this.mPanel.friendInvitationAvatar.data = (this.mCurrentMail.attachments as dFriendBodyVO).player;
                    break;
                case MAIL_TYPE.BANDITS_LOOT:
                case MAIL_TYPE.TREASURE_LOOT:
                case MAIL_TYPE.TREASURE_LOOT_BEANACOLOADA:
                case MAIL_TYPE.TREASURE_LOOT_TRAVELLINGERUDITE:
                case MAIL_TYPE.TREASURE_LOOT_SKILLED:
                case MAIL_TYPE.GIFT:
                case MAIL_TYPE.BUFF:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE_SKILLED:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_NEGATIVE:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_MAP_FRAGMENT:
                case MAIL_TYPE.FIND_ADVENTURE_LOOT_MAP_FRAGMENT_SKILLED:
                case MAIL_TYPE.FIND_EXPEDITION_LOOT_POSITIVE:
                case MAIL_TYPE.FIND_EXPEDITION_LOOT_NEGATIVE:
                case MAIL_TYPE.QUEST_LOOT:
                case MAIL_TYPE.COOPERATION_REWARD:
                case MAIL_TYPE.LOCA_LOOT_MAIL:
                case MAIL_TYPE.NPC_MAIL_LOOT:
                case MAIL_TYPE.COLLECTIBLE_REWARDS:
                case MAIL_TYPE.BLACKMARKET_WON:
                case MAIL_TYPE.ADVENTURE_LOCKED_COMPENSATION:
                case MAIL_TYPE.EXPEDITION_LOCKED_COMPENSATION:
                case MAIL_TYPE.EVENT_LOOT_REWARDS_CURRENT_USER:
                case MAIL_TYPE.EVENT_LOOT_REWARDS_FRIEND_USER:
                    _local_21 = (this.mCurrentMail.attachments as dLootItemsVO);
                    if (this.mCurrentMail.type == MAIL_TYPE.BUFF)
                    {
                        this.mPanel.lootAcceptInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (MAIL_TYPE.toString(MAIL_TYPE.GIFT) + "MailBody"), [_local_2]);
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(MAIL_TYPE.GIFT) + "MailSubject"), [_local_2]);
                    }
                    else
                    {
                        if (this.mCurrentMail.type == MAIL_TYPE.COOPERATION_REWARD)
                        {
                            this.mPanel.lootAcceptInfoText.text = this.mCurrentMail.body;
                            this.mPanel.subjectLabel.text = this.mCurrentMail.subject;
                        }
                        else
                        {
                            if (this.mCurrentMail.type == MAIL_TYPE.LOCA_LOOT_MAIL)
                            {
                                this.mPanel.lootAcceptInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (this.mCurrentMail.subject + "MailBody"));
                                this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (this.mCurrentMail.subject + "MailSubject"));
                            }
                            else
                            {
                                if (this.mCurrentMail.type == MAIL_TYPE.NPC_MAIL_LOOT)
                                {
                                    this.mPanel.lootAcceptInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.GAME_MESSAGES, this.mCurrentMail.body);
                                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.GAME_MESSAGE_LABELS, this.mCurrentMail.subject);
                                }
                                else
                                {
                                    this.mPanel.lootAcceptInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailBody"), [_local_2]);
                                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailSubject"), [_local_2]);
                                };
                            };
                        };
                    };
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentLootAccept;
                    this.renderLootItemsList(_local_21.items, this.mPanel.itemsList);
                    this.mPanel.premiumItemsList.removeAllChildren();
                    if (_local_21.premiumItems.length > 0)
                    {
                        this.renderLootItemsList(_local_21.premiumItems, this.mPanel.premiumItemsList);
                    };
                    this.mPanel.btnAcceptLoot.visible = ((this.isInbox) && (!(this.mCurrentMail.type == MAIL_TYPE.FIND_ADVENTURE_LOOT_NEGATIVE)));
                    this.mPanel.btnAcceptLoot.toolTip = "";
                    this.mPanel.btnAcceptLoot.enabled = true;
                    this.mPanel.skillList.removeAllChildren();
                    this.mPanel.skillList.visible = false;
                    this.mPanel.skillList.includeInLayout = false;
                    if ((((((this.mCurrentMail.type == MAIL_TYPE.FIND_ADVENTURE_LOOT_POSITIVE_SKILLED) || (this.mCurrentMail.type == MAIL_TYPE.FIND_ADVENTURE_LOOT_MAP_FRAGMENT_SKILLED)) || (this.mCurrentMail.type == MAIL_TYPE.TREASURE_LOOT_SKILLED)) || ((this.mCurrentMail.type == MAIL_TYPE.TREASURE_LOOT_BEANACOLOADA) && (this.mCurrentMail.subject.length > 0))) || ((this.mCurrentMail.type == MAIL_TYPE.TREASURE_LOOT_TRAVELLINGERUDITE) && (this.mCurrentMail.subject.length > 0))))
                    {
                        this.prepareAppliedSkillsTooltip(this.mCurrentMail.subject, this.mPanel.skillList);
                    };
                    if (((!(this.mGI.mCurrentViewedZoneID == this.mGI.mCurrentPlayer.GetPlayerId())) || (this.mGI.IsAdventureZoneID(this.mGI.mCurrentViewedZoneID))))
                    {
                        this.mPanel.btnAcceptLoot.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AcceptLootHomezone");
                        this.mPanel.btnAcceptLoot.enabled = false;
                        break;
                    };
                    if (this.mCurrentMail.type == MAIL_TYPE.GIFT)
                    {
                        _local_43 = cShopItem.GetShopItem((this.mCurrentMail.attachments as dLootItemsVO).shopItemId);
                        if (_local_43 != null)
                        {
                            if (((!(_local_43.GetTargetZone() == "Friend")) && (this.mGI.mCurrentPlayer.GetPlayerLevel() < _local_43.GetPlayerLevel())))
                            {
                                this.mPanel.btnAcceptLoot.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotAcceptItemLevelRequired", [_local_43.GetPlayerLevel().toString()]);
                                this.mPanel.btnAcceptLoot.enabled = false;
                            }
                            else
                            {
                                if (((!(_local_43.GetTargetZone() == "Friend")) && (this.mGI.mCurrentPlayer.GetPlayerPvPLevel() < _local_43.GetPvPLevel())))
                                {
                                    this.mPanel.btnAcceptLoot.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotAcceptItemPvPLevelRequired", [_local_43.GetPvPLevel().toString()]);
                                    this.mPanel.btnAcceptLoot.enabled = false;
                                }
                                else
                                {
                                    if (_local_43.GetPerPlayer() > 0)
                                    {
                                        this.mPanel.btnAcceptLoot.enabled = false;
                                    };
                                };
                            };
                            if (!this.isInbox)
                            {
                                this.mPanel.btnAcceptLoot.enabled = false;
                                this.mPanel.btnAcceptLoot.visible = false;
                                break;
                            };
                        };
                    };
                    break;
                case MAIL_TYPE.ADVENTURE_LOST_LOOT:
                case MAIL_TYPE.ADVENTURE_WON_LOOT:
                    _local_22 = (this.mCurrentMail.attachments as dLootItemsVO);
                    this.mPanel.premiumLootText.includeInLayout = false;
                    this.mPanel.premiumItemsHolder.includeInLayout = false;
                    this.mPanel.premiumItemsHolder.visible = false;
                    this.mPanel.premiumLootText.visible = false;
                    if (this.mCurrentMail.type == MAIL_TYPE.ADVENTURE_WON_LOOT)
                    {
                        this.mPanel.advLootAcceptInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_WON, _local_2);
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdventureLootMailSubject", [_local_2]);
                        if (_local_22.premiumItems.length > 0)
                        {
                            this.mPanel.premiumLootText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdventurePremiumLootMailHeadline");
                            this.mPanel.premiumLootText.includeInLayout = true;
                            this.mPanel.premiumItemsHolder.includeInLayout = true;
                            this.mPanel.premiumItemsHolder.visible = true;
                            this.mPanel.premiumLootText.visible = true;
                        };
                    }
                    else
                    {
                        if (this.mCurrentMail.type == MAIL_TYPE.ADVENTURE_LOST_LOOT)
                        {
                            this.mPanel.advLootAcceptInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_LOST, _local_2);
                            this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdventureLootMailSubject", [_local_2]);
                            if (_local_22.premiumItems.length > 0)
                            {
                                this.mPanel.premiumLootText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdventurePremiumLootMailHeadline");
                                this.mPanel.premiumLootText.includeInLayout = true;
                                this.mPanel.premiumItemsHolder.includeInLayout = true;
                                this.mPanel.premiumItemsHolder.visible = true;
                                this.mPanel.premiumLootText.visible = true;
                            };
                        };
                    };
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentAdvLootAccept;
                    this.renderLootItemsList(_local_22.items, this.mPanel.advItemsList);
                    this.mPanel.premiumItemsList.removeAllChildren();
                    if (_local_22.premiumItems.length > 0)
                    {
                        this.renderLootItemsList(_local_22.premiumItems, this.mPanel.premiumItemsList);
                    };
                    this.mPanel.btnAcceptAdvLoot.visible = (!(this.mCurrentMail.type == MAIL_TYPE.FIND_ADVENTURE_LOOT_NEGATIVE));
                    this.mPanel.btnAcceptAdvLoot.toolTip = "";
                    this.mPanel.btnAcceptAdvLoot.enabled = true;
                    if (((!(this.mGI.mCurrentViewedZoneID == this.mGI.mCurrentPlayer.GetPlayerId())) || (this.mGI.IsAdventureZoneID(this.mGI.mCurrentViewedZoneID))))
                    {
                        this.mPanel.btnAcceptAdvLoot.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AcceptLootHomezone");
                        this.mPanel.btnAcceptAdvLoot.enabled = false;
                        break;
                    };
                    break;
                case MAIL_TYPE.EXPEDITION_WON_LOOT:
                case MAIL_TYPE.EXPEDITION_LOST_LOOT:
                    _local_23 = (this.mCurrentMail.attachments as dLootItemsVO);
                    this.mPanel.premiumLootText.includeInLayout = false;
                    this.mPanel.premiumItemsHolder.includeInLayout = false;
                    this.mPanel.premiumItemsHolder.visible = false;
                    this.mPanel.premiumLootText.visible = false;
                    if (this.mCurrentMail.type == MAIL_TYPE.EXPEDITION_WON_LOOT)
                    {
                        this.mPanel.advLootAcceptInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_WON, _local_2);
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ExpeditionLootMailSubjectWon");
                        if (_local_23.premiumItems.length > 0)
                        {
                            this.mPanel.premiumLootText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ExpeditionPremiumLootMailHeadline");
                            this.mPanel.premiumLootText.includeInLayout = true;
                            this.mPanel.premiumItemsHolder.includeInLayout = true;
                            this.mPanel.premiumItemsHolder.visible = true;
                            this.mPanel.premiumLootText.visible = true;
                        };
                    }
                    else
                    {
                        if (this.mCurrentMail.type == MAIL_TYPE.EXPEDITION_LOST_LOOT)
                        {
                            this.mPanel.advLootAcceptInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_LOST, _local_2);
                            this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ExpeditionLootMailSubjectLost");
                            if (_local_23.premiumItems.length > 0)
                            {
                                this.mPanel.premiumLootText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ExpeditionPremiumLootMailHeadline");
                                this.mPanel.premiumLootText.includeInLayout = true;
                                this.mPanel.premiumItemsHolder.includeInLayout = true;
                                this.mPanel.premiumItemsHolder.visible = true;
                                this.mPanel.premiumLootText.visible = true;
                            };
                        };
                    };
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentAdvLootAccept;
                    this.renderLootItemsList(_local_23.items, this.mPanel.advItemsList);
                    this.mPanel.premiumItemsList.removeAllChildren();
                    if (_local_23.premiumItems.length > 0)
                    {
                        this.renderLootItemsList(_local_23.premiumItems, this.mPanel.premiumItemsList);
                    };
                    this.mPanel.btnAcceptAdvLoot.visible = (!(this.mCurrentMail.type == MAIL_TYPE.FIND_ADVENTURE_LOOT_NEGATIVE));
                    this.mPanel.btnAcceptAdvLoot.toolTip = "";
                    this.mPanel.btnAcceptAdvLoot.enabled = true;
                    if (((!(this.mGI.mCurrentViewedZoneID == this.mGI.mCurrentPlayer.GetPlayerId())) || (this.mGI.IsAdventureZoneID(this.mGI.mCurrentViewedZoneID))))
                    {
                        this.mPanel.btnAcceptAdvLoot.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AcceptLootHomezone");
                        this.mPanel.btnAcceptAdvLoot.enabled = false;
                        break;
                    };
                    break;
                case MAIL_TYPE.HARD_CURRENCY_PURCHASED:
                case MAIL_TYPE.HARD_CURRENCY_REMOVED:
                    _local_24 = new dResource();
                    _local_24.name_string = "HardCurrency";
                    _local_24.amount = (this.mCurrentMail.attachments as dHardCurrencyMailBodyVO).amount;
                    if (_local_24.amount >= 0)
                    {
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "HardCurrencyAppliedSubject", [_local_2]);
                        this.mPanel.gemsInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.mCurrentMail.subject, [_local_2]);
                    }
                    else
                    {
                        this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "HardCurrencyRemovedSubject", [_local_2]);
                        this.mPanel.gemsInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.mCurrentMail.subject, [_local_2]);
                    };
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentGems;
                    this.mPanel.gemsResource.data = _local_24;
                    this.mPanel.gemsResource.visible = true;
                    break;
                case MAIL_TYPE.INVITED_FRIEND_PURCHASED:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "InvitedFriendPurchasedSubject");
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentGems;
                    this.mPanel.gemsInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "InvitedFriendPurchasedBody", [this.mCurrentMail.subject]);
                    this.mPanel.gemsResource.visible = false;
                    break;
                case MAIL_TYPE.INVITE_TO_ADVENTURE:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "InviteToAdventureMailSubject");
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentAdventureInvite;
                    this.mPanel.adventureInviteInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "InviteToAdventureMailBody", [(this.mCurrentMail.attachments as dAdventureClientInfoVO).adventureName]);
                    _local_25 = cAdventureDefinition.FindAdventureDefinition((this.mCurrentMail.attachments as dAdventureClientInfoVO).adventureName);
                    this.mPanel.todo.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_TODO, (this.mCurrentMail.attachments as dAdventureClientInfoVO).adventureName);
                    this.mPanel.difficultIndicator.SetData(_local_25.GetDifficulty(), _local_25.GetTheme(), _local_25.GetCampaign(), _local_25.GetDifficultyTier());
                    this.mPanel.btnAdventureInviteDecline.enabled = true;
                    if (AdventureManager.getInstance().getJoinedAdventuresCount() < global.adventureMaximumGuest)
                    {
                        this.mPanel.btnAdventureInviteAccept.enabled = true;
                        this.mPanel.btnAdventureInviteAccept.toolTip = "";
                    }
                    else
                    {
                        this.mPanel.btnAdventureInviteAccept.enabled = false;
                        this.mPanel.btnAdventureInviteAccept.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdventuresJoinedLimitReached");
                    };
                    break;
                case MAIL_TYPE.EVENT_MONSTER_HIT_BY_FRIEND:
                    _local_26 = this.mCurrentMail.body;
                    this.mPanel.buffedBuilding.source = gAssetManager.GetBuildingIcon(_local_26);
                    this.mPanel.buffedBuilding.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_26);
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "EventMonsterHitByFriendMailSubject", [_local_20]);
                    this.mPanel.buffedInfoText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "EventMonsterHitByFriendMailBody", [_local_20]);
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentBuffed;
                    this.mPanel.buffedBuff.data = cBuff.CreateBuffFromVO((this.mCurrentMail.attachments as dBuffedDataVO).buffVO);
                    break;
                case MAIL_TYPE.ADVENTURE_LEAVE_NOTIFICATION:
                case MAIL_TYPE.ADVENTURE_CANCEL_INVITATION:
                    this.mPanel.subjectLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailSubject"));
                    this.mPanel.mailContent.selectedChild = this.mPanel.contentMail;
                    this.mPanel.bodyText.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (MAIL_TYPE.toString(this.mCurrentMail.type) + "MailBody"), [this.mCurrentMail.senderName, (this.mCurrentMail.attachments as dAdventureClientInfoVO).adventureName]);
                    break;
            };
            if (((!(this.mGI.mCurrentViewedZoneID == this.mGI.mCurrentPlayer.GetPlayerId())) || (this.mGI.IsAdventureZoneID(this.mGI.mCurrentViewedZoneID))))
            {
                this.mPanel.btnGuildIncreaseSize.enabled = false;
                this.mPanel.btnGuildRequestAccept.enabled = false;
                this.mPanel.btnAcceptLoot.enabled = false;
                this.mPanel.btnTradeAccept.enabled = false;
                this.mPanel.btnTradeComplete.enabled = false;
                this.mPanel.btnFriendInvitationSendRequest.enabled = false;
                this.mPanel.btnAdventureInviteDecline.enabled = false;
                this.mPanel.btnAdventureInviteAccept.enabled = false;
                this.mPanel.btnFriendAccept.enabled = false;
            };
            if ((((this.mCurrentMail.type == MAIL_TYPE.LOCA_LOOT_MAIL) && (_local_21.items.length == 0)) && (_local_21.premiumItems.length == 0)))
            {
                this.mPanel.itemsHolder.includeInLayout = false;
                this.mPanel.itemsHolder.visible = false;
            }
            else
            {
                this.mPanel.itemsHolder.includeInLayout = true;
                this.mPanel.itemsHolder.visible = true;
            };
        }

        private function setSortForMailList(_arg_1:DataGridEvent=null):void
        {
            var _local_2:String;
            if (_arg_1)
            {
                _arg_1.preventDefault();
                _local_2 = _arg_1.dataField;
                if (!this.allowedSortingColumns.hasOwnProperty(_local_2))
                {
                    return;
                };
                if (_arg_1.columnIndex == this.mSortLastIndex)
                {
                    this.mSortDesc = (!(this.mSortDesc));
                }
                else
                {
                    this.mSortDesc = false;
                    this.mSortLastIndex = _arg_1.columnIndex;
                };
                this.mSort.fields = [new SortField(_local_2, true, this.mSortDesc)];
                this.mMails.sort = this.mSort;
                this.mMails.refresh();
                this.pager.refresh();
            };
        }

        public function isInboxActive():Boolean
        {
            return (this.isInbox);
        }

        private function removeSelectedItemFromDataProvider(_arg_1:String):Boolean
        {
            if (this.mPanel.mailsList.selectedItem == null)
            {
                cLog.warning((_arg_1 + "(): mPanel.mailsList.selectedItem is null"));
                return (false);
            };
            var _local_2:dMailVO = (this.mPanel.mailsList.selectedItem as dMailVO);
            return (this.removeMail(_local_2));
        }

        private function onClickMailTypeHeaderCheckbox(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            this.mailTypeContextMenu.selectOrDeselectAll(this.mailTypeHeader.btnSelect.selected);
        }

        private function blockSenderOfSelectedMails(_arg_1:MouseEvent):void
        {
            var _local_2:ArrayCollection = new ArrayCollection();
            this.fillInSelectedSenderIDs(_local_2);
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.BLOCK_SENDER, this.mGI.mCurrentViewedZoneID, _local_2);
        }

        private function acceptAdventureLoot(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            this.outBoxEnabled = false;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.ACCEPT_LOOT, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
            this.createFloatingItemsFromMailPanel(this.mPanel.advItemsList);
            if (this.mPanel.premiumItemsList.getChildren().length > 0)
            {
                this.createFloatingItemsFromMailPanel(this.mPanel.premiumItemsList);
            };
            this.removeMail(this.mCurrentMail);
        }

        override protected function HideWithoutQueue():void
        {
            this.mReciepient = null;
            super.HideWithoutQueue();
            if (!this.hasDraft)
            {
                this.mPanel.currentState = "";
            };
            globalFlash.gui.mFriendsList.enableDisableFriendListOptions(true);
        }

        private function completeTrade(_arg_1:MouseEvent):void
        {
            if (this.isMailValid(this.mCurrentMail))
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.COMPLETE_TRADE_MAIL, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
                this.removeMail(this.mCurrentMail);
                if (this.mPanel.completedRes.visible)
                {
                    FloatingItemsManager.createJumpFlyDestroy(this.mPanel.completedRes.resourceIcon, "GAMESTATE_ID_INFO_BAR.infoBarMiddle");
                }
                else
                {
                    if (this.mPanel.completedBuff.visible)
                    {
                        FloatingItemsManager.createJumpFlyDestroy(this.mPanel.completedBuff, CollectionsConsts.STAR_MENU_DISPLAY_LIST_IDENTIFIER);
                    };
                };
                this.clear();
            };
        }

        private function canAcceptLoot(_arg_1:dMailVO):Boolean
        {
            var _local_2:cShopItem;
            if (_arg_1.type == MAIL_TYPE.GIFT)
            {
                _local_2 = null;
                if (_arg_1.attachments != null)
                {
                    _local_2 = cShopItem.GetShopItem((_arg_1.attachments as dLootItemsVO).shopItemId);
                };
                if (_local_2 != null)
                {
                    if (((!(_local_2.GetTargetZone() == "Friend")) && (this.mGI.mCurrentPlayer.GetPlayerLevel() < _local_2.GetPlayerLevel())))
                    {
                        return (false);
                    };
                    if (((!(_local_2.GetTargetZone() == "Friend")) && (this.mGI.mCurrentPlayer.GetPlayerPvPLevel() < _local_2.GetPvPLevel())))
                    {
                        return (false);
                    };
                    if (_local_2.GetPerPlayer() > 0)
                    {
                        return (false);
                    };
                };
            };
            return (true);
        }

        private function replyMail(_arg_1:MouseEvent):void
        {
            this.mReciepient = new dPlayerListItemVO();
            this.mReciepient.id = this.mCurrentMail.senderId;
            this.mReciepient.username = this.mCurrentMail.senderName;
            this.mReplyMail = this.mCurrentMail;
            this.mPanel.currentState = this.mPanel.stateEdit.name;
        }

        private function get pager():ListPager
        {
            return (this.mPanel.mailPager);
        }

        [Bindable(event="propertyChange")]
        private function get mRecipients():ArrayCollection
        {
            return (this._947992121mRecipients);
        }

        private function removeReciepient(_arg_1:MailRecipientEvent):void
        {
            var _local_2:dPlayerListItemVO = _arg_1.recipientVO;
            this.listRemoveItem(this.mRecipients, _local_2);
            if (this.mRecipients.length <= 1)
            {
                this.mPanel.btnSend.enabled = false;
            }
            else
            {
                this.mReciepient = (this.mRecipients.getItemAt((this.mRecipients.length - 2)) as dPlayerListItemVO);
            };
            this.updateSendButtonState();
            this.invalidateTileListFlexibility();
        }

        private function acceptFriend(_arg_1:MouseEvent):void
        {
            var _local_2:dPlayerListItemVO;
            if (((this.isMailValid(this.mCurrentMail)) && (MAIL_TYPE.FRIEND_REQUEST == this.mCurrentMail.type)))
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.ACCEPT_FRIEND_REQUEST, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
                _local_2 = (this.mCurrentMail.attachments as dFriendBodyVO).player;
                _local_2.friendSince = new Date().getTime();
                globalFlash.gui.mFriendsList.AddConfirmedFriend(_local_2);
                this.removeMail(this.mCurrentMail);
            };
        }

        private function updateSendButtonState():void
        {
            var _local_1:* = (this.mPanel.currentState == this.mPanel.stateEdit.name);
            if (!_local_1)
            {
                return;
            };
            if (((((this.mPanel.toTileList.dataProvider as ArrayCollection) == null) || (this.mRecipients == null)) || ((this.mRecipients.length <= 1) && (this.mReciepientGuild == null))))
            {
                this.mPanel.btnSend.enabled = false;
                return;
            };
            var _local_2:Boolean = (((this.mPanel.toTileList.dataProvider as ArrayCollection).length > 1) || (!(this.mReciepientGuild == null)));
            var _local_3:* = (this.mPanel.subjectInput.text.length > 0);
            var _local_4:int = ((this.mPanel.editText.text.indexOf(this.replyBody) >= 0) ? this.replyBody.length : 0);
            var _local_5:* = (this.mPanel.editText.text.length > _local_4);
            this.mPanel.btnSend.enabled = ((((_local_1) && (_local_2)) && (_local_3)) && (_local_5));
        }

        private function mailsListItemClickHandler(_arg_1:ListEvent):void
        {
            if (this.mailTypeContextMenu.IsVisible())
            {
                this.mailTypeContextMenu.HideMenu();
                return;
            };
            this.mailTypeContextMenu.deselectAll();
            var _local_2:dMailVO = (_arg_1.itemRenderer.data as dMailVO);
            this.lastSelectedItem = _local_2;
            if (((_arg_1.columnIndex > 0) && (this.mPanel.mailsList.selectedIndex >= 0)))
            {
                if (_local_2)
                {
                    this.getFullMail(_local_2);
                };
            };
            if (((_local_2) && (!(_arg_1.itemRenderer is MailGridSelectItemRenderer))))
            {
                this.deselectMails();
                this.setMailSelected(_local_2, true);
                this.mPanel.btnContextMenu.enabled = (this.mPanel.btnCollectOrDelete.enabled = ((this.isAnyMailSelected()) && (this.isInbox)));
                this.mContextMenu.UpdateMenuItemState(this.mSelectedMails, this.isInbox, this.mGI.mCurrentPlayer.GetPlayerId());
                this.updateMailListUI();
            };
        }

        private function acceptLoot(_arg_1:MouseEvent):void
        {
            if (!this.isMailValid(this.mCurrentMail))
            {
                return;
            };
            this.outBoxEnabled = false;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.ACCEPT_LOOT, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.mCurrentMail.id));
            this.createFloatingItemsFromMailPanel(this.mPanel.itemsList);
            this.removeMail(this.mCurrentMail);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.pager.disableAutoUpdate();
            this.mPanel.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGING, this.panelStateChangingHandler, false, 0, true);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.close);
            this.mPanel.stateApply.addEventListener(FlexEvent.ENTER_STATE, this.enterApplyState);
            this.mPanel.stateApply.addEventListener(FlexEvent.EXIT_STATE, this.exitApplyState);
            this.mailTypeHeader.btnSelect.addEventListener(MouseEvent.CLICK, this.onClickMailTypeHeaderCheckbox);
            this.mailTypeHeader.btnHeader.addEventListener(MouseEvent.CLICK, this.onClickMailTypeHeader);
            this.mPanel.mailsList.addEventListener(ListEvent.ITEM_CLICK, this.mailsListItemClickHandler, false, 0, true);
            this.mPanel.mailsList.addEventListener(DataGridEvent.HEADER_RELEASE, this.setSortForMailList, false, 0, true);
            this.mPanel.mailsList.addEventListener(cMailWindow.SELECT_MAIL, this.selectMail, false, 0, true);
            this.mPanel.mailsList.addEventListener(cMailWindow.DELETE_MAIL, this.deleteMail, false, 0, true);
            this.mPanel.stateEdit.addEventListener(FlexEvent.ENTER_STATE, this.enterEditState, false, 0, true);
            this.mPanel.stateEdit.addEventListener(FlexEvent.EXIT_STATE, this.exitEditState, false, 0, true);
            this.mPanel.btnTradeAccept.addEventListener(MouseEvent.CLICK, this.acceptTrade, false, 0, true);
            this.mPanel.btnTradeDecline.addEventListener(MouseEvent.CLICK, this.btnTradeDeclineClickHandler, false, 0, true);
            this.mPanel.btnTradeComplete.addEventListener(MouseEvent.CLICK, this.completeTrade, false, 0, true);
            this.mPanel.btnFriendAccept.addEventListener(MouseEvent.CLICK, this.acceptFriend, false, 0, true);
            this.mPanel.btnFriendDecline.addEventListener(MouseEvent.CLICK, this.btnFriendDeclineClickHandler, false, 0, true);
            this.mPanel.btnAcceptLoot.addEventListener(MouseEvent.CLICK, this.acceptLoot, false, 0, true);
            this.mPanel.btnClaimLoot.addEventListener(MouseEvent.CLICK, this.claimLoot, false, 0, true);
            this.mPanel.btnReplay.addEventListener(MouseEvent.CLICK, this.replayBattle, false, 0, true);
            this.mPanel.btnPvPReport.addEventListener(MouseEvent.CLICK, this.pvpReportButtonClickHandler, false, 0, true);
            this.mPanel.btnFriendInvitationSendRequest.addEventListener(MouseEvent.CLICK, this.sendInvitationFriendRequest, false, 0, true);
            this.mPanel.btnGuildRequestAccept.addEventListener(MouseEvent.CLICK, this.acceptGuildRequest, false, 0, true);
            this.mPanel.btnGuildRequestDecline.addEventListener(MouseEvent.CLICK, this.declineGuildRequest, false, 0, true);
            this.mPanel.btnGuildIncreaseSize.addEventListener(MouseEvent.CLICK, this.increaseGuildSize, false, 0, true);
            this.mPanel.btnAdventureInviteAccept.addEventListener(MouseEvent.CLICK, this.acceptAdventureInvite, false, 0, true);
            this.mPanel.btnAdventureInviteDecline.addEventListener(MouseEvent.CLICK, this.btnAdventureInviteDeclineClickHandler, false, 0, true);
            this.mPanel.btnNewMail.addEventListener(MouseEvent.CLICK, this.btnNewMailClick, false, 0, true);
            this.mPanel.btnInbox.addEventListener(MouseEvent.CLICK, this.inboxClickHandler, false, 0, true);
            this.mPanel.btnInbox.addEventListener(MouseEvent.ROLL_OUT, this.btnInboxRollOutHandler, false, 0, true);
            this.mPanel.btnOutbox.addEventListener(MouseEvent.CLICK, this.outboxClickHandler, false, 0, true);
            this.mPanel.btnOutbox.addEventListener(MouseEvent.ROLL_OUT, this.btnOutboxRollOutHandler, false, 0, true);
            this.mPanel.btnContextMenu.addEventListener(MouseEvent.CLICK, this.showContextMenu, false, 0, true);
            this.mPanel.btnBlockList.addEventListener(MouseEvent.CLICK, this.showBlockList, false, 0, true);
            this.mPanel.btnAcceptAdvLoot.addEventListener(MouseEvent.CLICK, this.acceptAdventureLoot, false, 0, true);
            this.mPanel.btnClaimAdvLoot.addEventListener(MouseEvent.CLICK, this.claimAdventureLoot, false, 0, true);
            this.mPanel.btnCollectOrDelete.addEventListener(MouseEvent.CLICK, this.claimOrDeleteSelectedMails);
            this.mPanel.btnGuildSuccessionRequestAccept.addEventListener(MouseEvent.CLICK, this.acceptGuildSuccessionRequest);
            this.mPanel.btnGuildSuccessionRequestDecline.addEventListener(MouseEvent.CLICK, this.declineGuildSuccessionRequest);
            this.pager.addEventListener(ListPager.PAGE_CHANGED, this.handlePageChanged);
            this.pager.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.onMailTypeFilterChanged);
            this.mSort = new Sort();
            this.mSort.fields = [new SortField("id", false, true)];
            this.isInbox = true;
            this.replyBody = "";
            this.mContextMenu = new cMailWindowContextMenu();
            this.mContextMenu.Init(global.getApplication().GAMESTATE_ID_MAIL_CONTEXT_MENU);
            var _local_2:Vector.<dContextItemVO> = new Vector.<dContextItemVO>();
            _local_2.push(new dContextItemVO("Delete", this.deleteSelectedMails, false));
            _local_2.push(new dContextItemVO("Reply", this.replySelectedMails, false));
            _local_2.push(new dContextItemVO("MarkAsRead", this.markSelectedMailsAsRead, false));
            _local_2.push(new dContextItemVO("MarkAsUnRead", this.markSelectedMailsAsUnread, false));
            _local_2.push(new dContextItemVO("BlockSender", this.blockSenderOfSelectedMails, false));
            this.mContextMenu.SetContextMenu(_local_2);
        }

        private function invalidateTileListFlexibility():void
        {
            var _local_6:Number;
            var _local_7:int;
            var _local_1:int = 4;
            var _local_2:int = 6;
            var _local_3:int = 25;
            var _local_4:int = int(Math.ceil((this.mRecipients.length / _local_2)));
            var _local_5:int = this.mPanel.toTileList.height;
            if (_local_4 <= _local_1)
            {
                if (_local_4 == 0)
                {
                    this.mPanel.toTileList.height = _local_3;
                }
                else
                {
                    this.mPanel.toTileList.height = (_local_4 * _local_3);
                };
                this.mPanel.toTileList.verticalScrollPolicy = ScrollPolicy.OFF;
                if (_local_5 != this.mPanel.toTileList.height)
                {
                    _local_6 = this.mPanel.reciepientList.getStyle("top");
                    _local_7 = Math.abs((_local_5 - this.mPanel.toTileList.height));
                    if (_local_5 > this.mPanel.toTileList.height)
                    {
                        this.mPanel.recipientContainer.height = (this.mPanel.recipientContainer.height - _local_7);
                        this.mPanel.reciepientList.setStyle("top", (_local_6 - _local_7));
                    }
                    else
                    {
                        this.mPanel.recipientContainer.height = (this.mPanel.recipientContainer.height + _local_7);
                        this.mPanel.reciepientList.setStyle("top", (_local_6 + _local_7));
                    };
                };
            }
            else
            {
                this.mPanel.toTileList.verticalScrollPolicy = ScrollPolicy.ON;
            };
        }

        private function deleteSelectedMails(_arg_1:Event):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:dMailVO;
            if (this.mMailsToDelete.length == 0)
            {
                _local_2 = 0;
                _local_3 = 0;
                _local_4 = 0;
                for each (_local_5 in this.mSelectedMails)
                {
                    if (MAIL_TYPE.isImportant(_local_5.type))
                    {
                        _local_2++;
                    }
                    else
                    {
                        this.mMailsToDelete.addItem(_local_5);
                        if (MAIL_TYPE.isCollectable(_local_5.type))
                        {
                            _local_3++;
                        }
                        else
                        {
                            _local_4++;
                        };
                    };
                };
                DismissMailsAlert.show("ConfirmDismissMailsMessage", "ConfirmDismissMailsTitle", this.mSelectedMails, this.deleteMultipleMails, this.mPanel, true, _local_3, _local_4, _local_2);
            };
        }

        private function selectReciepientFromList(_arg_1:ListEvent):void
        {
            this.mReciepient = (this.mPanel.reciepientList.selectedItem as dPlayerListItemVO);
            if (this.mReciepient)
            {
                this.addRecipient(this.mReciepient);
            }
            else
            {
                this.mPanel.btnSend.enabled = false;
            };
        }

        private function handlePageChanged(_arg_1:Event):void
        {
            this.mPanel.mailsList.verticalScrollPosition = 0;
            this.deselectMails();
        }

        private function loadMailBodies(_arg_1:Boolean):void
        {
            var _local_5:Object;
            var _local_6:dMailVO;
            var _local_7:Boolean;
            var _local_8:Object;
            var _local_2:Dictionary = new Dictionary();
            var _local_3:Boolean = true;
            var _local_4:Boolean;
            for (_local_5 in this.mSelectedMails)
            {
                _local_6 = (this.mSelectedMails[_local_5] as dMailVO);
                _local_7 = this.isReplyable(_local_6);
                if (_local_7)
                {
                    _local_4 = true;
                };
                if (((_local_6.body == null) && (_local_7)))
                {
                    _local_3 = false;
                    _local_2[_local_6.id] = 1;
                };
            };
            if (_local_4)
            {
                if (_local_3)
                {
                    this.showReplyMail(_arg_1);
                }
                else
                {
                    globalFlash.gui.mLoadingMailPanel.setMailsToLoad(_local_2, _arg_1);
                    globalFlash.gui.mLoadingMailPanel.Show();
                    for (_local_8 in _local_2)
                    {
                        this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_INBOX_BODY, this.mGI.mCurrentViewedZoneID, new dIntegerVO((_local_8 as int)));
                    };
                };
            };
        }

        private function updateMailListUI():void
        {
            this.mailTypeHeader.setVisible(((this.mMails) && (this.mMails.length > 0)));
            this.mPanel.mailsList.setSelectedItem(this.lastSelectedItem);
            this.mailTypeHeader.btnSelect.selected = false;
        }

        private function clearEdit():void
        {
            this.mPanel.subjectInput.text = "";
            this.mPanel.editText.text = "";
            this.mPanel.reciepientList.dataProvider = null;
            this.mPanel.reciepientList.visible = false;
            this.mPanel.recipientContainer.percentHeight = 18;
            this.mPanel.toTileList.height = 25;
            this.mPanel.toTileList.verticalScrollPolicy = ScrollPolicy.OFF;
            this.mfocusOnMailBody = true;
            this.mPanel.reciepientList.setStyle("top", 34);
            this.resetRecipients();
        }

        private function close(_arg_1:Event):void
        {
            if (((this.mPanel.currentState == this.mPanel.stateEdit.name) && ((this.mPanel.editText.text.length > 0) || (this.mPanel.subjectInput.text.length > 0))))
            {
                CustomAlert.show("MailAbandonDraft", "MailAbandonDraft", (Alert.CANCEL | Alert.OK), this.mPanel, this.confirmClose);
            }
            else
            {
                this.confirmClose();
            };
        }

        private function markSelectedMailsAsRead(_arg_1:MouseEvent):void
        {
            var _local_2:dMarkMailsVO = new dMarkMailsVO();
            _local_2.mailIds_collection = new ArrayCollection();
            _local_2.read = true;
            this.fillInAndMarkSelectedMailIDs(_local_2.mailIds_collection, _local_2.read);
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.MARK_MAILS, this.mGI.mCurrentViewedZoneID, _local_2);
            this.mContextMenu.UpdateMenuItemState(this.mSelectedMails, this.isInbox, this.mGI.mCurrentPlayer.GetPlayerId());
            this.mPanel.mailsList.invalidateDisplayList();
        }


    }
}
