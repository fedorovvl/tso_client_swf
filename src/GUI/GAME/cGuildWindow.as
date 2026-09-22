package GUI.GAME
{
    import mx.collections.ArrayCollection;
    import Interface.cGameInterface;
    import Communication.VO.Guild.dGuildRankListItemVO;
    import GUI.Components.GuildWindow;
    import flash.events.Event;
    import Communication.VO.Guild.dGuildVO;
    import Communication.VO.Guild.dGuildPlayerPermissionVO;
    import Communication.VO.Guild.dGuildPlayerListItemVO;
    import Enums.COMMAND;
    import Communication.VO.Guild.dGuildEditValueVO;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import flash.events.MouseEvent;
    import GO.cBuilding;
    import Enums.AVATAR_MESSAGE_TYPE;
    import mx.events.CloseEvent;
    import mx.controls.TextInput;
    import GUI.Effects.gHintManager;
    import Communication.VO.Votes.dVoteResultVO;
    import GUI.Components.ItemRenderer.GuildMarketItemRendererData;
    import __AS3__.vec.Vector;
    import nLib.cLog;
    import Votes.cVotePoolDefinition;
    import Enums.VOTE_POOL;
    import GuildSystem.EDIT_TYPE;
    import Communication.VO.dIntegerVO;
    import Communication.VO.dPlayerListItemVO;
    import Communication.VO.Guild.dGuildPlayerAdventureVO;
    import Interface.cGeneralInterface;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.ListEvent;
    import GUI.Assets.gAssetManager;
    import mx.events.FlexEvent;
    import Communication.VO.Votes.dPlayerVoteItemVO;
    import Communication.VO.dPlayerVotePoolVO;
    import GUI.Components.ItemRenderer.GuildMarketItemRenderer;
    import Communication.VO.dResourceVO;
    import Votes.cVoteDefinition;
    import mx.events.ItemClickEvent;
    import GUI.Components.TextEditor;
    import com.bluebyte.tso.util.TimeUtil;
    import Communication.VO.Guild.dGuildRankTabPermissionVO;
    import GuildSystem.cGuildBankTab;
    import ServerState.dResource;
    import flash.utils.getTimer;
    import GUI.Components.CustomTextInput;
    import flash.events.KeyboardEvent;
    import Communication.VO.Guild.dGuildLogListItemVO;
    import Communication.VO.Guild.dGuildQuestVO;
    import Communication.VO.dQuestElementVO;
    import mx.core.ClassFactory;
    import GUI.Components.ItemRenderer.GuildSuccessorItemRenderer;
    import Enums.GUILD_LOG_IDENTIFIER;
    import mx.controls.Label;
    import Communication.VO.Guild.dGuildHeadersListVO;
    import mx.events.CollectionEvent;
    import __AS3__.vec.*;

    public class cGuildWindow extends cBasicInfoPanel 
    {

        public static const SUCCESSOR_UP:String = "SuccessorUp";
        public static const SUCCESSOR_DOWN:String = "SuccessorDown";
        public static const CLICK_EXPAND_ITEM:String = "CLICK_EXPAND_ITEM";

        private var mMarketUniqueData:ArrayCollection;
        private var mMyRankPosition:int = 0;
        private var mGI:cGameInterface;
        private var mCurrentSuccessor:int;
        private var mOnlyWhiteSpaces:* = /^\s*$/;
        private var mMarketDefaultHistoryData:ArrayCollection;
        public var mIsChangingSuccession:Boolean = false;
        private var mMarketUniqueItemsSelected:int;
        private var mMarketDefaultItemsSelected:int;
        private var mSelectedBanner:int;
        private var mSelectedRank:dGuildRankListItemVO;
        private var mWaitingForServerResponse:Boolean = true;
        private var mMarketVotingEnabled:Boolean;
        protected var mPanel:GuildWindow;
        private var waitForServerStartTime:int;
        private var mMarketDefaultItemsMax:int;
        private var mIsOwnGuild:Boolean;
        private var rankAlertEventSelected:Event = null;
        private var mSelectedGuild:dGuildVO;
        private var mMyRank:dGuildRankListItemVO = null;
        private var _rankSelected:Object = null;
        private var mMarketUniqueHistoryData:ArrayCollection;
        private var mPermissions:dGuildPlayerPermissionVO;
        private var mMarketDefaultData:ArrayCollection;
        private var mMarketUniqueItemsMax:int;
        private var mCurrentRankPosition:int = 0;
        private var mSelectedMember:dGuildPlayerListItemVO;
        private var mMaxPage:int;
        private var mCurrentPage:int;


        public function RefreshOwnGuild():void
        {
            var _local_2:dGuildPlayerListItemVO;
            if (!this.mIsOwnGuild)
            {
                return;
            };
            var _local_1:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            if (!_local_1)
            {
                this.Hide();
                return;
            };
            this.mIsChangingSuccession = false;
            this.SetGuild(_local_1);
            if (((this.mPanel.guildDetailsStack.selectedChild == this.mPanel.administration) && (!(this.IsAdminTabAllowed()))))
            {
                this.mPanel.guildDetailsStack.selectedIndex = 0;
            }
            else
            {
                this.mPanel.buttonBar.selectedIndex = this.mPanel.guildDetailsStack.selectedIndex;
            };
            if (this.mSelectedMember)
            {
                for each (_local_2 in this.mSelectedGuild.members)
                {
                    if (_local_2.id == this.mSelectedMember.id) break;
                };
                if (_local_2)
                {
                    this.mPanel.membersList.selectedItem = _local_2;
                };
                this.ShowMemberDetails(null);
            };
        }

        private function SendChanges(_arg_1:dGuildEditValueVO):void
        {
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_EDIT_VALUE, 0, _arg_1);
        }

        private function showGuildTabGlassAnimation():void
        {
            this.mPanel.saveTabGlassAnimLayer.visible = this.mWaitingForServerResponse;
            this.mPanel.saveTabGlassAnim.visible = this.mWaitingForServerResponse;
        }

        private function KickHandler(_arg_1:MouseEvent):void
        {
            CustomAlert.show("ConfirmKickMember", "ConfirmKickMember", (Alert.OK | Alert.CANCEL), null, this.KickMember);
        }

        override public function SetData(_arg_1:cBuilding):void
        {
        }

        private function DisbandGuild(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:ArrayCollection = (this.mPanel.guildList.dataProvider as ArrayCollection);
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if ((_local_2.getItemAt(_local_3) as dGuildVO).id == this.mSelectedGuild.id)
                {
                    _local_2.removeItemAt(_local_3);
                    break;
                };
                _local_3++;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_LEAVE, this.mGI.mCurrentViewedZoneID, null);
            this.mGI.SetCurrentPlayerGuild(null);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GUILD_DISBANDED);
            globalFlash.gui.mChatPanel.leaveGuildChannels();
            Hide();
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        private function ShowMyGuildDetails(_arg_1:MouseEvent):void
        {
            this.SetGuild(this.mGI.GetCurrentPlayerGuild());
            this.mPanel.subcontent.selectedIndex = 1;
            this.mPanel.guildDetailsStack.selectedIndex = 0;
            this.mPanel.buttonBar.selectedIndex = 0;
        }

        private function ShowRankDetails(_event:Event):void
        {
            var textInput:TextInput;
            textInput = null;
            if ((_event.currentTarget is TextInput))
            {
                textInput = (_event.currentTarget as TextInput);
            }
            else
            {
                textInput = (_event.target.owneras as TextInput);
            };
            if ((((!(this.mSelectedRank == null)) && (this.RankChanged())) && (!(textInput.id == ("rankName" + (this.GetCurrentRankPosition(this.mSelectedRank.id) + 1))))))
            {
                this.rankAlertEventSelected = _event;
                CustomAlert.show("GuildRankTabNoChanged", "GuildRankTabNoChanged", (Alert.OK | Alert.CANCEL), null, function (_arg_1:CloseEvent):void
                {
                    if (_arg_1.detail == Alert.OK)
                    {
                        DisplayRankDetails(textInput);
                    };
                }, null, Alert.OK, true, CustomAlert.STYLE_DEFAULT, null);
            }
            else
            {
                this.DisplayRankDetails(textInput);
            };
        }

        private function ClearMemberDetails():void
        {
            this.mPanel.memberAvatar.data = null;
            this.mPanel.memberAvatar.visible = false;
            this.mPanel.btnRankDown.visible = false;
            this.mPanel.btnRankUp.visible = false;
            this.mPanel.memberName.text = "";
            this.mPanel.memberLevel.text = "";
            this.mPanel.memberRank.text = "";
            this.mPanel.note.text = "";
            this.mPanel.note.editable = false;
            this.mPanel.officerNote.text = "";
            this.mPanel.officerNote.editable = false;
        }

        override public function Show():void
        {
            this.GetGuildListPage(1);
            var _local_1:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            if (_local_1)
            {
                this.ShowMyGuildDetails(null);
            }
            else
            {
                this.ShowGuildList(null);
            };
            this.mPanel.btnMyGuild.visible = (!(_local_1 == null));
            this.mPanel.btnFoundGuild.visible = (_local_1 == null);
            this.mPanel.btnFoundGuild.enabled = (!(this.mGI.mCurrentPlayerZone.mStreetDataMap.GetGuildHouse() == null));
            this.ClearGuildRankDetails(true);
            this.mPanel.btnHelp.visible = false;
            gHintManager.TryRemainingHints();
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        private function FillMarketHistoryData():void
        {
            var _local_2:Object;
            var _local_3:dVoteResultVO;
            var _local_4:GuildMarketItemRendererData;
            var _local_5:int;
            var _local_6:String;
            var _local_1:Vector.<dVoteResultVO> = new Vector.<dVoteResultVO>();
            for each (_local_2 in this.mGI.mVotesManager.GetHistoryVotedShopItems())
            {
                _local_1.push((_local_2 as dVoteResultVO));
            };
            _local_1.sort(dVoteResultVO.PercentageDescComparator);
            for each (_local_3 in _local_1)
            {
                _local_4 = new GuildMarketItemRendererData();
                _local_4.shopItemId = _local_3.itemID;
                _local_4.percentage = (_local_3.percentage / 100);
                _local_4.isActive = false;
                _local_4.isSelected = this.mGI.mVotesManager.IsItemInCurrentShopItems(_local_3.itemID);
                _local_4.showPercentageCounting = (!(this.mGI.mVotesManager.GetPlayerVote().seen));
                _local_5 = _local_3.poolID;
                if (_local_5 < 1)
                {
                    cLog.warning((("no votePoolId found for availablePoolId:[" + _local_3.availablePoolID) + "] skipping guild market history entry"));
                }
                else
                {
                    _local_6 = (global.vote_pool_definitions.getItem(_local_5) as cVotePoolDefinition).name;
                    if (_local_6 == VOTE_POOL.UNIQUE_ITEMS)
                    {
                        this.mMarketUniqueHistoryData.addItem(_local_4);
                    }
                    else
                    {
                        if (_local_6 == VOTE_POOL.DEFAULT_ITEMS)
                        {
                            this.mMarketDefaultHistoryData.addItem(_local_4);
                        };
                    };
                };
            };
        }

        private function DiscardBannerChanges(_arg_1:MouseEvent):void
        {
            this.mSelectedBanner = this.mSelectedGuild.bannerID;
            this.ChangeBanner();
        }

        private function SaveRankChanges(_arg_1:MouseEvent):void
        {
            if (!this.mIsOwnGuild)
            {
                return;
            };
            this.mPanel.btnSaveRankChanges.enabled = false;
            this.mPanel.btnDiscardRankChanges.enabled = false;
            if (!this.RankChanged())
            {
                return;
            };
            var _local_2:dGuildRankListItemVO = this.mSelectedRank;
            _local_2.name = this.mPanel[("rankName" + (this.GetCurrentRankPosition(this.mSelectedRank.id) + 1))].text;
            var _local_3:dGuildPlayerPermissionVO = new dGuildPlayerPermissionVO();
            _local_3.kick = ((this.mPanel.kickMembersCheck.selected) ? 1 : 0);
            _local_3.guildMail = ((this.mPanel.writeGuildMailsCheck.selected) ? 1 : 0);
            _local_3.note = ((this.mPanel.useNotesCheck.selected) ? 1 : 0);
            _local_3.invite = ((this.mPanel.inviteMembersCheck.selected) ? 1 : 0);
            _local_3.banner = ((this.mPanel.editGuildEmblemCheck.selected) ? 1 : 0);
            _local_2.dGuildRankPermissionVO = _local_3;
            _local_2.rankTabsPermissions = this.cloneRankTabsPermissions((this.mPanel.manageRankTabItemList.dataProvider as ArrayCollection));
            var _local_4:dGuildEditValueVO = new dGuildEditValueVO();
            _local_4.type = EDIT_TYPE.RANK_NAME;
            var _local_5:ArrayCollection = new ArrayCollection();
            _local_5.addItem(_local_2);
            _local_4.parameters = _local_5;
            this.SendChanges(_local_4);
            this.displayWaitingForServer(true);
        }

        public function InviteMember(_arg_1:dPlayerListItemVO):void
        {
            if (_arg_1.id > 0)
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GUILD_INVITE_SENT);
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_INVITE, this.mGI.mCurrentViewedZoneID, new dIntegerVO(_arg_1.id));
        }

        private function Invite(_arg_1:Event):void
        {
            globalFlash.gui.mAddFriendsPanel.SetMode(cAddFriendsPanel.GUILD_INVITE);
            globalFlash.gui.mAddFriendsPanel.Show();
        }

        private function GuildMail(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mMailWindow.editGuildMail(this.mSelectedGuild);
        }

        private function ShowMemberDetails(_arg_1:ListEvent):void
        {
            var _local_4:dGuildPlayerAdventureVO;
            if (!this.mPanel.membersList.selectedItem)
            {
                this.ClearMemberDetails();
                return;
            };
            this.mSelectedMember = (this.mPanel.membersList.selectedItem as dGuildPlayerListItemVO);
            this.mPanel.memberAvatar.data = this.mSelectedMember;
            this.mPanel.memberAvatar.visible = true;
            this.mPanel.memberName.text = cGeneralInterface.getComputedPlayerName(this.mSelectedMember.username);
            this.mPanel.memberLevel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Level", [((this.mSelectedMember.playerLevel == 0) ? "1" : this.mSelectedMember.playerLevel.toString())]);
            this.mPanel.memberRank.text = (this.mPanel.rankMappings[this.mSelectedMember.rankID] as dGuildRankListItemVO).name;
            this.mPanel.note.editable = ((this.mIsOwnGuild) && ((this.mPermissions.NoteWrite()) || (this.mSelectedMember.id == this.mGI.mCurrentPlayer.GetPlayerId())));
            this.mPanel.officerNote.editable = ((this.mIsOwnGuild) && (this.mPermissions.OfficerNoteWrite()));
            this.mPanel.btnKick.enabled = (((this.mIsOwnGuild) && (this.mPermissions.Kick())) && (this.GetCurrentRankPosition(this.mSelectedMember.rankID) > this.mMyRankPosition));
            if (!this.mIsOwnGuild)
            {
                return;
            };
            this.mPanel.btnRankUp.visible = this.mPermissions.RanksAssign();
            this.mPanel.btnRankUp.enabled = this.IsRankUpAllowed(this.mSelectedMember.rankID);
            this.mPanel.btnRankDown.visible = this.mPermissions.RanksAssign();
            this.mPanel.btnRankDown.enabled = this.IsRankDownAllowed(this.mSelectedMember.rankID);
            this.mPanel.note.text = this.mSelectedMember.note;
            this.mPanel.officerNote.text = this.mSelectedMember.officerNote;
            this.mPanel.adventuresTextField.text = "";
            var _local_2:Boolean;
            var _local_3:Boolean;
            for each (_local_4 in this.mSelectedMember.adventures)
            {
                if (!_local_3)
                {
                    this.mPanel.adventuresTextField.text = (cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildActiveAdventures") + "\n");
                };
                _local_3 = true;
                _local_2 = ((_local_2) || (_local_4.isLookingForHelp));
                this.mPanel.adventuresTextField.text = (this.mPanel.adventuresTextField.text + (cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_NAME, _local_4.name) + "\n"));
            };
            if (_local_3)
            {
                this.mPanel.adventuresTextField.text = (this.mPanel.adventuresTextField.text + ((cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildCooperationRequested") + " ") + ((_local_2) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Yes") : cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "No"))));
            };
        }

        private function IsSuccessorAssignAllowed():Boolean
        {
            return (((this.mIsOwnGuild) && (this.mPermissions)) && (this.mPermissions.SuccessorAssign()));
        }

        public function SavedRank(_arg_1:dGuildEditValueVO):void
        {
            switch (_arg_1.type)
            {
                case EDIT_TYPE.RANK_NAME:
                    this.ClearGuildRankDetails(false);
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GUILD_CHANGES_SAVED);
                    return;
            };
        }

        private function ChangeBanner(_arg_1:MouseEvent=null):void
        {
            if (_arg_1)
            {
                switch (_arg_1.target)
                {
                    case this.mPanel.btnBannerLeft:
                        if (this.mSelectedBanner > 1)
                        {
                            this.mSelectedBanner--;
                        };
                        break;
                    case this.mPanel.btnBannerRight:
                        if (this.mSelectedBanner < global.guildBannerCount)
                        {
                            this.mSelectedBanner++;
                        };
                        break;
                };
            };
            this.mPanel.selectedBanner.source = gAssetManager.GetGuildBannerUrlById(this.mSelectedBanner);
            this.mPanel.btnBannerLeft.enabled = (((this.mSelectedBanner > 1) && (this.mPermissions)) && (this.mPermissions.BannerWrite()));
            this.mPanel.btnBannerRight.enabled = (((this.mSelectedBanner < global.guildBannerCount) && (this.mPermissions)) && (this.mPermissions.BannerWrite()));
            this.mPanel.btnSaveBannerChanges.enabled = (((!(this.mSelectedBanner == this.mSelectedGuild.bannerID)) && (this.mPermissions)) && (this.mPermissions.BannerWrite()));
            this.mPanel.btnDiscardBannerChanges.enabled = (!(this.mSelectedBanner == this.mSelectedGuild.bannerID));
        }

        private function ChangeSuccessor(_arg_1:int, _arg_2:int):void
        {
            var _local_4:dGuildPlayerListItemVO;
            var _local_8:dGuildPlayerListItemVO;
            var _local_3:dGuildPlayerListItemVO;
            for each (_local_4 in this.mPanel.membersList.dataProvider)
            {
                if (_local_4.id == _arg_1)
                {
                    _local_3 = _local_4;
                    break;
                };
            };
            if (_local_3 == null)
            {
                cLog.warning("SuccessorUp(): mPanel.membersList.selectedItem is null");
                return;
            };
            this.mIsChangingSuccession = true;
            var _local_5:int = Math.min(_local_3.successorOrder, (global.guildMaxSuccessionLimit + 1));
            _local_5 = (_local_5 + _arg_2);
            var _local_6:dGuildEditValueVO = new dGuildEditValueVO();
            _local_6.type = EDIT_TYPE.SUCCESSOR_ORDER;
            _local_6.newValue = _local_5.toString();
            _local_6.parameters = new ArrayCollection([_local_3.id.toString()]);
            var _local_7:int;
            while (_local_7 < this.mSelectedGuild.members.length)
            {
                _local_8 = (this.mSelectedGuild.members.getItemAt(_local_7) as dGuildPlayerListItemVO);
                if (_local_8.successorOrder == _local_5)
                {
                    _local_8.successorOrder = _local_3.successorOrder;
                };
                _local_7++;
            };
            _local_3.successorOrder = _local_5;
            this.UpdateGrid();
            this.SendChanges(_local_6);
        }

        public function Init(_arg_1:GuildWindow):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.label = "Guild list";
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function IsRankDownAllowed(_arg_1:int):Boolean
        {
            var _local_2:int = this.GetCurrentRankPosition(_arg_1);
            return ((((_local_2 < (this.mSelectedGuild.ranks.length - 1)) && (this.mPermissions)) && (this.mPermissions.RanksAssign())) && (_local_2 > this.mMyRankPosition));
        }

        private function SuccessorUp(_arg_1:ListEvent):void
        {
            this.ChangeSuccessor(_arg_1.rowIndex, 1);
        }

        private function SendMarketSelectionHandler(_arg_1:MouseEvent):void
        {
            CustomAlert.show("ConfirmSendGuildMarketSelection", "ConfirmSendGuildMarketSelection", (Alert.OK | Alert.CANCEL), null, this.SendMarketSelection);
        }

        private function RollOutRank(_arg_1:MouseEvent):void
        {
            if (((this._rankSelected == null) || (!(this._rankSelected == _arg_1.currentTarget))))
            {
                _arg_1.currentTarget.styleName = "detailsSubContentBoxNormal";
            };
        }

        private function CreateMarketVoteData(_arg_1:dPlayerVotePoolVO, _arg_2:int):ArrayCollection
        {
            var _local_4:dPlayerVoteItemVO;
            var _local_5:GuildMarketItemRendererData;
            var _local_6:dPlayerVoteItemVO;
            var _local_3:ArrayCollection = new ArrayCollection();
            for each (_local_4 in _arg_1.voteItems)
            {
                _local_5 = new GuildMarketItemRendererData();
                _local_5.voteItem = _local_4;
                _local_5.shopItemId = _local_4.itemId;
                _local_5.isActive = this.mMarketVotingEnabled;
                _local_5.isSelected = false;
                for each (_local_6 in _arg_1.votes)
                {
                    if (_local_4.itemId == _local_6.itemId)
                    {
                        _local_5.isSelected = true;
                        break;
                    };
                };
                _local_3.addItem(_local_5);
            };
            return (_local_3);
        }

        private function PreviousPage(_arg_1:MouseEvent):void
        {
            this.GetGuildListPage((this.mCurrentPage - 1));
        }

        private function Apply(_arg_1:Event):void
        {
            globalFlash.gui.mMailWindow.Show();
            globalFlash.gui.mMailWindow.applyToGuild((this.mPanel.leaderAvatar.data as dPlayerListItemVO));
        }

        private function isLeaderAlone():Boolean
        {
            return (this.mSelectedGuild.size == 1);
        }

        private function NextPage(_arg_1:MouseEvent):void
        {
            this.GetGuildListPage((this.mCurrentPage + 1));
        }

        private function ClickMarketItemHandler(_arg_1:ListEvent):void
        {
            var _local_2:GuildMarketItemRenderer = (_arg_1.itemRenderer as GuildMarketItemRenderer);
            var _local_3:GuildMarketItemRendererData = (_local_2.data as GuildMarketItemRendererData);
            if (_arg_1.target.id == "GuildMarketUniqueItems")
            {
                if (((_local_3.isSelected) || (this.mMarketUniqueItemsSelected < this.mMarketUniqueItemsMax)))
                {
                    _local_3.isSelected = (!(_local_3.isSelected));
                    this.mMarketUniqueItemsSelected = (this.mMarketUniqueItemsSelected + ((_local_3.isSelected) ? 1 : -1));
                    this.UpdateMarketItemSelecteLabel(this.mPanel.guildMarketUniqueSelectedLabel, this.mMarketUniqueItemsSelected, this.mMarketUniqueItemsMax);
                }
                else
                {
                    this.mPanel.flashLabel(this.mPanel.guildMarketUniqueSelectedLabel);
                };
            }
            else
            {
                if (_arg_1.target.id == "GuildMarketDefaultItems")
                {
                    if (((_local_3.isSelected) || (this.mMarketDefaultItemsSelected < this.mMarketDefaultItemsMax)))
                    {
                        _local_3.isSelected = (!(_local_3.isSelected));
                        this.mMarketDefaultItemsSelected = (this.mMarketDefaultItemsSelected + ((_local_3.isSelected) ? 1 : -1));
                        this.UpdateMarketItemSelecteLabel(this.mPanel.guildMarketDefaultSelectedLabel, this.mMarketDefaultItemsSelected, this.mMarketDefaultItemsMax);
                    }
                    else
                    {
                        this.mPanel.flashLabel(this.mPanel.guildMarketDefaultSelectedLabel);
                    };
                };
            };
            this.mPanel.btnGuildMarketSendSelection.enabled = (this.mPanel.btnGuildMarketResetSelection.enabled = ((this.mMarketDefaultItemsSelected > 0) || (this.mMarketUniqueItemsSelected > 0)));
        }

        public function RefreshGuildMarket():void
        {
            if (this.mGI.mVotesManager.GetPlayerVote() == null)
            {
                return;
            };
            var _local_1:dPlayerVotePoolVO = this.mGI.mVotesManager.GetPlayerVote().pools[VOTE_POOL.UNIQUE_ITEMS];
            var _local_2:dPlayerVotePoolVO = this.mGI.mVotesManager.GetPlayerVote().pools[VOTE_POOL.DEFAULT_ITEMS];
            if (((_local_1 == null) || (_local_2 == null)))
            {
                this.mPanel.GuildMarketUniqueItems.dataProvider = null;
                this.mPanel.GuildMarketDefaultItems.dataProvider = null;
                this.mMarketUniqueHistoryData = null;
                this.mMarketDefaultHistoryData = null;
                this.mPanel.guildMarketVoteButtons.visible = false;
                this.mPanel.guildMarketResetVoteBox.visible = false;
                this.mPanel.btnGuildMarketToShop.visible = false;
                return;
            };
            this.mMarketUniqueItemsSelected = _local_1.votes.length;
            this.mMarketDefaultItemsSelected = _local_2.votes.length;
            this.mMarketUniqueItemsMax = this.GetMarketPoolVoteAmount(VOTE_POOL.UNIQUE_ITEMS);
            this.mMarketDefaultItemsMax = this.GetMarketPoolVoteAmount(VOTE_POOL.DEFAULT_ITEMS);
            this.mMarketVotingEnabled = ((this.mMarketDefaultItemsSelected == 0) && (this.mMarketUniqueItemsSelected == 0));
            this.mPanel.btnGuildMarketSendSelection.enabled = this.mMarketVotingEnabled;
            this.mPanel.btnGuildMarketResetSelection.enabled = this.mMarketVotingEnabled;
            this.mPanel.GuildMarketUniqueItems.removeEventListener(ListEvent.ITEM_CLICK, this.ClickMarketItemHandler);
            this.mPanel.GuildMarketDefaultItems.removeEventListener(ListEvent.ITEM_CLICK, this.ClickMarketItemHandler);
            if (this.mMarketVotingEnabled)
            {
                this.mPanel.GuildMarketUniqueItems.addEventListener(ListEvent.ITEM_CLICK, this.ClickMarketItemHandler);
                this.mPanel.GuildMarketDefaultItems.addEventListener(ListEvent.ITEM_CLICK, this.ClickMarketItemHandler);
            };
            this.mMarketUniqueData = this.CreateMarketVoteData(_local_1, this.mMarketUniqueItemsMax);
            this.mMarketDefaultData = this.CreateMarketVoteData(_local_2, this.mMarketDefaultItemsMax);
            this.mPanel.GuildMarketUniqueItems.dataProvider = this.mMarketUniqueData;
            this.mPanel.GuildMarketDefaultItems.dataProvider = this.mMarketDefaultData;
            this.mMarketUniqueHistoryData = new ArrayCollection();
            this.mMarketDefaultHistoryData = new ArrayCollection();
            this.FillMarketHistoryData();
            this.UpdateMarketItemSelecteLabel(this.mPanel.guildMarketUniqueSelectedLabel, this.mMarketUniqueItemsSelected, this.mMarketUniqueItemsMax);
            this.UpdateMarketItemSelecteLabel(this.mPanel.guildMarketDefaultSelectedLabel, this.mMarketDefaultItemsSelected, this.mMarketDefaultItemsMax);
            this.mPanel.btnGuildMarketSendSelection.enabled = (this.mPanel.btnGuildMarketResetSelection.enabled = false);
            var _local_3:dResourceVO = new dResourceVO();
            _local_3.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
            _local_3.amount = (global.vote_definitions.getItem("GuildMarket") as cVoteDefinition).costGems;
            this.mPanel.resetVoteCosts.data = _local_3;
            this.UpdateTimeToNextGuildMarket();
            this.mPanel.guildMarketVoteButtons.visible = this.mMarketVotingEnabled;
            this.mPanel.guildMarketResetVoteBox.visible = (!(this.mMarketVotingEnabled));
            this.mPanel.btnGuildMarketResetVote.enabled = true;
            this.mPanel.btnGuildMarketToShop.visible = false;
        }

        private function SwitchDetailsViewstack(_arg_1:ItemClickEvent):void
        {
            this.mPanel.guildDetailsStack.selectedIndex = (((this.mPanel.buttonBar.selectedIndex >= 2) && (!(this.IsAdminTabAllowed()))) ? (this.mPanel.buttonBar.selectedIndex + 1) : this.mPanel.buttonBar.selectedIndex);
            this.mPanel.btnHelp.visible = (this.mPanel.guildDetailsStack.selectedChild.id == "guildmarket");
            if (((this.mPanel.guildDetailsStack.selectedChild.id == "guildmarket") && (!(this.mGI.mVotesManager.GetPlayerVote().seen))))
            {
                this.mGI.mVotesManager.SetVoteSeen();
            };
            this.UpdateTimeToNextGuildMarket();
        }

        private function IsAdminTabAllowed():Boolean
        {
            return (((this.mIsOwnGuild) && (this.mPermissions)) && ((this.mPermissions.BannerWrite()) || (this.mPermissions.RanksEdit())));
        }

        private function IncreaseGuildHandler(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mShopWindow.ShowDeepLink("GuildWindow", 0, 3, 4008);
        }

        private function SaveBannerChanges(_arg_1:MouseEvent):void
        {
            this.mSelectedGuild.bannerID = this.mSelectedBanner;
            this.mPanel.banner.source = gAssetManager.GetGuildBannerUrlById(this.mSelectedBanner);
            this.ChangeBanner();
            var _local_2:dGuildEditValueVO = new dGuildEditValueVO();
            _local_2.type = EDIT_TYPE.BANNER;
            _local_2.newValue = this.mSelectedBanner.toString();
            this.SendChanges(_local_2);
        }

        private function SaveChanges(_arg_1:Event):void
        {
            var _local_3:dGuildPlayerListItemVO;
            var _local_2:dGuildEditValueVO = new dGuildEditValueVO();
            _local_2.newValue = (_arg_1.target as TextEditor).text;
            switch (_arg_1.target)
            {
                case this.mPanel.motd:
                    _local_2.type = EDIT_TYPE.MOTD;
                    this.mSelectedGuild.motd = _local_2.newValue;
                    break;
                case this.mPanel.guildDescription:
                    _local_2.type = EDIT_TYPE.DESCRIPTION;
                    this.mSelectedGuild.description = _local_2.newValue;
                    break;
                case this.mPanel.note:
                    _local_2.type = EDIT_TYPE.NOTE;
                    _local_2.parameters = new ArrayCollection([new String(this.mSelectedMember.id)]);
                    for each (_local_3 in this.mPanel.membersList.dataProvider)
                    {
                        if (_local_3.id == this.mSelectedMember.id)
                        {
                            _local_3.note = _local_2.newValue;
                            break;
                        };
                    };
                    this.ShowMemberDetails(null);
                    break;
                case this.mPanel.officerNote:
                    _local_2.type = EDIT_TYPE.OFFICER_NOTE;
                    _local_2.parameters = new ArrayCollection([new String(this.mSelectedMember.id)]);
                    for each (_local_3 in this.mPanel.membersList.dataProvider)
                    {
                        if (_local_3.id == this.mSelectedMember.id)
                        {
                            _local_3.officerNote = _local_2.newValue;
                            break;
                        };
                    };
                    this.ShowMemberDetails(null);
                    break;
                default:
                    return;
            };
            this.SendChanges(_local_2);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GUILD_CHANGES_SAVED);
        }

        private function ResetGuildMarketVote(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            global.getApplication().inputNotifier.notifyClick("GAMESTATE_ID_GUILD_WINDOW.btnGuildMarketResetVote.OK");
            this.mGI.mVotesManager.DeleteVoteWithGems();
            this.mPanel.btnGuildMarketResetVote.enabled = false;
        }

        private function UpdateTimeToNextGuildMarket():void
        {
            if (this.mGI.mVotesManager.GetPlayerVote() == null)
            {
                return;
            };
            var _local_1:Number = (this.mGI.mVotesManager.GetPlayerVote().endTime - TimeUtil.getServerTime());
            this.mPanel.timeToNextVote.text = ((cLocaManager.GetInstance().getLabel("nextVote") + ": ") + cLocaManager.GetInstance().FormatDuration(((_local_1 > 0) ? _local_1 : 0), cLocaManager.DURATION_FORMAT_SHORT));
        }

        private function itemClickExpandHandler(_arg_1:ItemClickEvent):void
        {
            this.mPanel.rankTabCanvas.height = this.calculateListHeight();
        }

        private function RankTabsChanged():Boolean
        {
            var _local_3:dGuildRankTabPermissionVO;
            var _local_4:dGuildRankTabPermissionVO;
            var _local_1:Boolean;
            var _local_2:int;
            while (_local_2 < this.mSelectedRank.rankTabsPermissions.length)
            {
                _local_3 = (this.mSelectedRank.rankTabsPermissions.getItemAt(_local_2) as dGuildRankTabPermissionVO);
                _local_4 = (this.mPanel.manageRankTabItemList.dataProvider[_local_2] as dGuildRankTabPermissionVO);
                if ((((((!(_local_3.permission == _local_4.permission)) || (!(_local_3.resourcesLimit == _local_4.resourcesLimit))) || (!(_local_3.resourcesPermission == _local_4.resourcesPermission))) || (!(_local_3.itemsLimit == _local_4.itemsLimit))) || (!(_local_3.itemsPermission == _local_4.itemsPermission))))
                {
                    _local_1 = true;
                    break;
                };
                _local_2++;
            };
            return (_local_1);
        }

        private function calculateListHeight():int
        {
            var _local_4:dGuildRankTabPermissionVO;
            var _local_1:int;
            var _local_2:int;
            var _local_3:Boolean;
            for each (_local_4 in this.mPanel.manageRankTabItemList.dataProvider)
            {
                if (!_local_4.collapsed)
                {
                    if (!global.ui.mCurrentPlayerGuildBank.GetGuildBankTab(_local_4.tabID).isPaymentTab)
                    {
                        _local_1++;
                    }
                    else
                    {
                        _local_3 = true;
                    };
                };
                _local_2 = (_local_2 + (25 + 1));
            };
            _local_2 = (_local_2 + (124 * _local_1));
            if (_local_3)
            {
                _local_2 = (_local_2 + 62);
            };
            return (_local_2);
        }

        private function GetCurrentRankPosition(_arg_1:int):int
        {
            var _local_3:dGuildRankListItemVO;
            var _local_2:int;
            while (_local_2 < this.mSelectedGuild.ranks.length)
            {
                _local_3 = (this.mSelectedGuild.ranks.getItemAt(_local_2) as dGuildRankListItemVO);
                if (_local_3.id == _arg_1)
                {
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }

        public function SetRankDetail(_arg_1:dGuildRankListItemVO):void
        {
            this.mPanel.btnSaveRankChanges.enabled = false;
            this.mPanel.btnDiscardRankChanges.enabled = false;
            this.mSelectedRank = _arg_1;
            if (this.mSelectedRank == null)
            {
                this.mPanel.vRankRights.visible = false;
                return;
            };
            this.mPanel.vRankRights.visible = true;
            if (this.mSelectedRank.dGuildRankPermissionVO.Kick())
            {
                this.mPanel.kickMembersCheck.selected = true;
            }
            else
            {
                this.mPanel.kickMembersCheck.selected = false;
            };
            if (this.mSelectedRank.dGuildRankPermissionVO.GuildMail())
            {
                this.mPanel.writeGuildMailsCheck.selected = true;
            }
            else
            {
                this.mPanel.writeGuildMailsCheck.selected = false;
            };
            if (this.mSelectedRank.dGuildRankPermissionVO.NoteWrite())
            {
                this.mPanel.useNotesCheck.selected = true;
            }
            else
            {
                this.mPanel.useNotesCheck.selected = false;
            };
            if (this.mSelectedRank.dGuildRankPermissionVO.Invite())
            {
                this.mPanel.inviteMembersCheck.selected = true;
            }
            else
            {
                this.mPanel.inviteMembersCheck.selected = false;
            };
            if (this.mSelectedRank.dGuildRankPermissionVO.BannerWrite())
            {
                this.mPanel.editGuildEmblemCheck.selected = true;
            }
            else
            {
                this.mPanel.editGuildEmblemCheck.selected = false;
            };
            this.mPanel.manageRankTabItemList.dataProvider = this.cloneRankTabsPermissions(this.mSelectedRank.rankTabsPermissions);
            this.displayWaitingForServer(false);
        }

        private function ResetMarketSelection(_arg_1:MouseEvent):void
        {
            var _local_2:GuildMarketItemRendererData;
            for each (_local_2 in this.mPanel.GuildMarketUniqueItems.dataProvider)
            {
                _local_2.isSelected = false;
            };
            for each (_local_2 in this.mPanel.GuildMarketDefaultItems.dataProvider)
            {
                _local_2.isSelected = false;
            };
            this.mMarketUniqueItemsSelected = 0;
            this.UpdateMarketItemSelecteLabel(this.mPanel.guildMarketUniqueSelectedLabel, this.mMarketUniqueItemsSelected, this.mMarketUniqueItemsMax);
            this.mMarketDefaultItemsSelected = 0;
            this.UpdateMarketItemSelecteLabel(this.mPanel.guildMarketDefaultSelectedLabel, this.mMarketDefaultItemsSelected, this.mMarketDefaultItemsMax);
            this.mPanel.btnGuildMarketSendSelection.enabled = (this.mPanel.btnGuildMarketResetSelection.enabled = false);
        }

        public function ResetValue(_arg_1:dGuildEditValueVO):void
        {
            switch (_arg_1.type)
            {
                case EDIT_TYPE.MOTD:
                    this.mPanel.motd.text = _arg_1.newValue;
                    return;
                case EDIT_TYPE.DESCRIPTION:
                    this.mPanel.guildDescription.text = _arg_1.newValue;
                    return;
                case EDIT_TYPE.NOTE:
                    this.mPanel.note.text = _arg_1.newValue;
                    return;
                case EDIT_TYPE.OFFICER_NOTE:
                    this.mPanel.officerNote.text = _arg_1.newValue;
                    return;
                case EDIT_TYPE.RANK_NAME:
                    this.mPanel.rankName1.text = this.mSelectedGuild.ranks.getItemAt(0).name;
                    this.mPanel.rankName2.text = this.mSelectedGuild.ranks.getItemAt(1).name;
                    this.mPanel.rankName3.text = this.mSelectedGuild.ranks.getItemAt(2).name;
                    this.mPanel.rankName4.text = this.mSelectedGuild.ranks.getItemAt(3).name;
                    return;
                case EDIT_TYPE.BANNER:
                    this.mPanel.banner.source = gAssetManager.GetGuildBannerUrlById(parseInt(_arg_1.newValue));
                    this.mPanel.selectedBanner.source = gAssetManager.GetGuildBannerUrlById(parseInt(_arg_1.newValue));
                    return;
            };
        }

        private function isGuildBankEmpty():Boolean
        {
            var _local_1:cGuildBankTab;
            var _local_2:dResource;
            for each (_local_1 in this.mGI.mCurrentPlayerGuildBank.GetGuildBankTabs())
            {
                if (_local_1.GetSortedBuffs().length > 0)
                {
                    return (false);
                };
                for each (_local_2 in _local_1.GetResourcesVector())
                {
                    if (_local_2.amount > 0)
                    {
                        return (false);
                    };
                };
            };
            return (true);
        }

        private function OpenShopWindow(_arg_1:MouseEvent):void
        {
            Hide();
            this.ToggleMarketHistory(null);
            globalFlash.gui.mShopWindow.ShowDeepLink("GuildMarket", 0, 16, 0);
        }

        private function ShowGuildList(_arg_1:MouseEvent):void
        {
            this.ClearGuildDetails();
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildList");
            this.mPanel.banner.source = null;
            this.mPanel.subcontent.selectedIndex = 0;
        }

        private function RanksValid():Boolean
        {
            if (((((this.mPanel.rankName1.text == "") || (this.mPanel.rankName2.text == "")) || (this.mPanel.rankName3.text == "")) || (this.mPanel.rankName4.text == "")))
            {
                return (false);
            };
            if (((((!(this.mPanel.rankName1.text.match(this.mOnlyWhiteSpaces) == null)) || (!(this.mPanel.rankName2.text.match(this.mOnlyWhiteSpaces) == null))) || (!(this.mPanel.rankName3.text.match(this.mOnlyWhiteSpaces) == null))) || (!(this.mPanel.rankName4.text.match(this.mOnlyWhiteSpaces) == null))))
            {
                return (false);
            };
            return (true);
        }

        private function DisplayRankDetails(_arg_1:TextInput):void
        {
            var _local_2:dGuildRankListItemVO;
            var _local_3:dGuildRankListItemVO;
            switch (_arg_1)
            {
                case this.mPanel.rankName1:
                    _local_3 = (this.mSelectedGuild.ranks.getItemAt(0) as dGuildRankListItemVO);
                    break;
                case this.mPanel.rankName2:
                    _local_3 = (this.mSelectedGuild.ranks.getItemAt(1) as dGuildRankListItemVO);
                    break;
                case this.mPanel.rankName3:
                    _local_3 = (this.mSelectedGuild.ranks.getItemAt(2) as dGuildRankListItemVO);
                    break;
                case this.mPanel.rankName4:
                    _local_3 = (this.mSelectedGuild.ranks.getItemAt(3) as dGuildRankListItemVO);
                    break;
            };
            this.HighLightRankSelected(_arg_1);
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_RANK_GET, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(_local_3.id));
        }

        private function displayWaitingForServer(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.waitForServerStartTime = getTimer();
            };
            this.mWaitingForServerResponse = _arg_1;
            if (((((this.mPanel.saveTabGlassAnimLayer) && (this.mPanel.saveTabGlassAnim)) && (this.mPanel.saveTabGlassAnimLayer.stage)) && (this.mPanel.saveTabGlassAnim.stage)))
            {
                this.showGuildTabGlassAnimation();
            };
        }

        private function DiscardRanksChanges(_arg_1:MouseEvent):void
        {
            this.mPanel.btnSaveRankChanges.enabled = false;
            this.mPanel.btnDiscardRankChanges.enabled = false;
            this.ClearGuildRankDetails(true);
            this.SetRanks();
        }

        private function ShowGuildDetails(_arg_1:ListEvent):void
        {
            if (!this.mPanel.guildList.selectedItem)
            {
                return;
            };
            var _local_2:dGuildVO = (this.mPanel.guildList.selectedItem as dGuildVO);
            var _local_3:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            if (((!(_local_3 == null)) && (_local_2.id == _local_3.id)))
            {
                this.ShowMyGuildDetails(null);
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_GET, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(_local_2.id));
            this.mPanel.subcontent.selectedIndex = 1;
            this.mPanel.guildDetailsStack.selectedIndex = 0;
            this.mPanel.buttonBar.selectedIndex = 0;
        }

        private function HighLightRankSelected(_arg_1:TextInput):void
        {
            this._rankSelected = _arg_1;
            var _local_2:int;
            while (_local_2 < 4)
            {
                this.mPanel[("rankName" + (_local_2 + 1))].styleName = "detailsSubContentBoxNormal";
                _local_2++;
            };
            _arg_1.styleName = "detailsSubContentBoxHighlightSelected";
        }

        private function IsRankUpAllowed(_arg_1:int):Boolean
        {
            var _local_2:int = this.GetCurrentRankPosition(_arg_1);
            return ((((_local_2 > 0) && (this.mPermissions)) && (this.mPermissions.RanksAssign())) && (this.mMyRankPosition < (_local_2 - 1)));
        }

        private function KickMember(_arg_1:CloseEvent):void
        {
            if (((!(_arg_1.detail == Alert.OK)) || (this.mSelectedMember == null)))
            {
                return;
            };
            this.mSelectedGuild.members.removeItemAt(this.mSelectedGuild.members.getItemIndex(this.mSelectedMember));
            this.ClearMemberDetails();
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_KICK, this.mGI.mCurrentViewedZoneID, new dIntegerVO(this.mSelectedMember.id));
            this.mSelectedMember = null;
            this.mPanel.btnKick.enabled = false;
        }

        private function ClearGuildDetails():void
        {
            this.mPanel.leaderAvatar.data = null;
            this.mPanel.leaderName.text = "";
            this.mPanel.motd.text = "";
            this.mPanel.guildInfo.text = "";
            this.mPanel.guildDescription.text = "";
            this.mPanel.guildLog.dataProvider = null;
            this.mPanel.membersList.dataProvider = null;
            this.mSelectedGuild = null;
            this.mPanel.guildDetailsStack.selectedIndex = 0;
            this.mPanel.buttonBar.selectedIndex = 0;
            this.ClearMemberDetails();
        }

        private function SetRanks():void
        {
            var _local_2:CustomTextInput;
            var _local_1:int;
            while (_local_1 < this.mSelectedGuild.ranks.length)
            {
                _local_2 = (this.mPanel[("rankName" + (_local_1 + 1))] as CustomTextInput);
                if (_local_2)
                {
                    _local_2.text = (this.mSelectedGuild.ranks.getItemAt(_local_1) as dGuildRankListItemVO).name;
                };
                _local_1++;
            };
        }

        private function FoundGuild(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mFoundGuildPanel.Show();
        }

        private function ToggleMarketHistory(_arg_1:MouseEvent):void
        {
            if (this.mPanel.btnGuildMarketToShop.visible)
            {
                this.mPanel.GuildMarketUniqueItems.dataProvider = this.mMarketUniqueData;
                this.mPanel.GuildMarketDefaultItems.dataProvider = this.mMarketDefaultData;
                if (this.mMarketVotingEnabled)
                {
                    this.mPanel.GuildMarketUniqueItems.addEventListener(ListEvent.ITEM_CLICK, this.ClickMarketItemHandler);
                    this.mPanel.GuildMarketDefaultItems.addEventListener(ListEvent.ITEM_CLICK, this.ClickMarketItemHandler);
                };
                this.mPanel.guildMarketUniqueSelectedLabel.visible = true;
                this.mPanel.guildMarketDefaultSelectedLabel.visible = true;
                this.mPanel.guildMarketVoteButtons.visible = this.mMarketVotingEnabled;
                this.mPanel.guildMarketResetVoteBox.visible = (!(this.mMarketVotingEnabled));
                this.mPanel.btnGuildMarketToShop.visible = false;
            }
            else
            {
                this.mPanel.GuildMarketUniqueItems.dataProvider = this.mMarketUniqueHistoryData;
                this.mPanel.GuildMarketDefaultItems.dataProvider = this.mMarketDefaultHistoryData;
                this.mPanel.GuildMarketUniqueItems.removeEventListener(ListEvent.ITEM_CLICK, this.ClickMarketItemHandler);
                this.mPanel.GuildMarketDefaultItems.removeEventListener(ListEvent.ITEM_CLICK, this.ClickMarketItemHandler);
                this.mPanel.guildMarketUniqueSelectedLabel.visible = false;
                this.mPanel.guildMarketDefaultSelectedLabel.visible = false;
                this.mPanel.guildMarketVoteButtons.visible = false;
                this.mPanel.guildMarketResetVoteBox.visible = false;
                this.mPanel.btnGuildMarketToShop.visible = true;
            };
        }

        private function LeaveGuild(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_LEAVE, this.mGI.mCurrentViewedZoneID, null);
            this.mGI.SetCurrentPlayerGuild(null);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.GUILD_LEFT);
            globalFlash.gui.mChatPanel.leaveGuildChannels();
            Hide();
        }

        private function ResetMarketVoteHandler(_arg_1:MouseEvent):void
        {
            var _local_2:dResourceVO = (this.mPanel.resetVoteCosts.data as dResourceVO);
            if (this.mGI.mCurrentPlayerZone.getResourcesFromCurrentZone().HasPlayerResource(_local_2.name_string, _local_2.amount))
            {
                CustomAlert.show("ConfirmResetGuildMarketVote", "ConfirmResetGuildMarketVote", (Alert.OK | Alert.CANCEL), null, this.ResetGuildMarketVote);
            }
            else
            {
                CustomAlert.show("ItemPurchaseSwitchToBuyGems", "", (Alert.OK | Alert.CANCEL), null, this.mGI.shopManager.ConfirmAddHardCurrency, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
        }

        private function LeaveHandler(_arg_1:MouseEvent):void
        {
            if (this.mMyRankPosition == 0)
            {
                CustomAlert.show("ConfirmDisbandGuild", "ConfirmDisbandGuild", (Alert.OK | Alert.CANCEL), null, this.DisbandGuild);
            }
            else
            {
                CustomAlert.show("ConfirmLeaveGuild", "ConfirmLeaveGuild", (Alert.OK | Alert.CANCEL), null, this.LeaveGuild);
            };
        }

        private function cloneRankTabsPermissions(_arg_1:ArrayCollection):ArrayCollection
        {
            var _local_3:dGuildRankTabPermissionVO;
            var _local_2:ArrayCollection = new ArrayCollection();
            for each (_local_3 in _arg_1)
            {
                _local_2.addItem(_local_3.clone());
            };
            return (_local_2);
        }

        private function StepDownHandler(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            var _local_3:dGuildPlayerListItemVO;
            for each (_local_3 in this.mSelectedGuild.members)
            {
                if (_local_3.successorOrder == 1)
                {
                    _local_2 = _local_3.username;
                    break;
                };
            };
            CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ConfirmStepDown", [_local_2]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmStepDown"), (Alert.OK | Alert.CANCEL), null, this.StepDown, null, 4, false);
        }

        private function RanksEditKeyUpHandler(_arg_1:Event):void
        {
            this.mPanel.btnSaveRankChanges.enabled = ((this.RankChanged()) && (this.RanksValid()));
            this.mPanel.btnDiscardRankChanges.enabled = this.RankChanged();
        }

        private function SuccessorDown(_arg_1:ListEvent):void
        {
            this.ChangeSuccessor(_arg_1.rowIndex, -1);
        }

        private function GetGuildListPage(_arg_1:int):void
        {
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_GET_HEADERS, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(_arg_1));
        }

        private function UpdateGrid(_arg_1:dGuildVO=null):void
        {
            var _local_2:int = this.mPanel.membersList.selectedIndex;
            var _local_3:int = this.mPanel.membersList.verticalScrollPosition;
            if (_arg_1)
            {
                this.mPanel.membersList.dataProvider = _arg_1.members;
            }
            else
            {
                this.mSelectedGuild.members.refresh();
            };
            if (_local_2 > -1)
            {
                _local_2 = (this.mPanel.membersList.selectedIndex - (_local_2 - _local_3));
                _local_2 = Math.max(_local_2, 0);
                this.mPanel.membersList.verticalScrollPosition = _local_2;
            }
            else
            {
                this.mPanel.membersList.verticalScrollPosition = _local_3;
            };
        }

        private function GetMarketPoolVoteAmount(_arg_1:String):int
        {
            var _local_2:cVotePoolDefinition;
            for each (_local_2 in global.vote_definitions.getItem("GuildMarket").votePools)
            {
                if (_local_2.name == _arg_1)
                {
                    return (_local_2.votesAmount);
                };
            };
            return (0);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK, this.SwitchDetailsViewstack);
            this.mPanel.btnPrevPage.addEventListener(MouseEvent.CLICK, this.PreviousPage);
            this.mPanel.btnNextPage.addEventListener(MouseEvent.CLICK, this.NextPage);
            this.mPanel.btnFoundGuild.addEventListener(MouseEvent.CLICK, this.FoundGuild);
            this.mPanel.btnBackToList.addEventListener(MouseEvent.CLICK, this.ShowGuildList);
            this.mPanel.btnMyGuild.addEventListener(MouseEvent.CLICK, this.ShowMyGuildDetails);
            this.mPanel.membersList.addEventListener(ListEvent.ITEM_CLICK, this.ShowMemberDetails);
            this.mPanel.membersList.addEventListener(cGuildWindow.SUCCESSOR_UP, this.SuccessorUp);
            this.mPanel.membersList.addEventListener(cGuildWindow.SUCCESSOR_DOWN, this.SuccessorDown);
            this.mPanel.guildList.addEventListener(ListEvent.ITEM_CLICK, this.ShowGuildDetails);
            this.mPanel.btnInvite.addEventListener(MouseEvent.CLICK, this.Invite);
            this.mPanel.btnMail.addEventListener(MouseEvent.CLICK, this.GuildMail);
            this.mPanel.btnLeave.addEventListener(MouseEvent.CLICK, this.LeaveHandler);
            this.mPanel.btnIncrease.addEventListener(MouseEvent.CLICK, this.IncreaseGuildHandler);
            this.mPanel.btnKick.addEventListener(MouseEvent.CLICK, this.KickHandler);
            this.mPanel.btnSaveRankChanges.addEventListener(MouseEvent.CLICK, this.SaveRankChanges);
            this.mPanel.btnDiscardRankChanges.addEventListener(MouseEvent.CLICK, this.DiscardRanksChanges);
            this.mPanel.btnRankUp.addEventListener(MouseEvent.CLICK, this.AssignRank);
            this.mPanel.btnRankDown.addEventListener(MouseEvent.CLICK, this.AssignRank);
            this.mPanel.btnBannerLeft.addEventListener(MouseEvent.CLICK, this.ChangeBanner);
            this.mPanel.btnBannerRight.addEventListener(MouseEvent.CLICK, this.ChangeBanner);
            this.mPanel.btnSaveBannerChanges.addEventListener(MouseEvent.CLICK, this.SaveBannerChanges);
            this.mPanel.btnDiscardBannerChanges.addEventListener(MouseEvent.CLICK, this.DiscardBannerChanges);
            this.mPanel.btnStepDown.addEventListener(MouseEvent.CLICK, this.StepDownHandler);
            this.mPanel.btnApply.addEventListener(MouseEvent.CLICK, this.Apply);
            this.mPanel.addEventListener(cGuildWindow.CLICK_EXPAND_ITEM, this.itemClickExpandHandler);
            this.mPanel.rankName1.addEventListener(KeyboardEvent.KEY_UP, this.RanksEditKeyUpHandler);
            this.mPanel.rankName2.addEventListener(KeyboardEvent.KEY_UP, this.RanksEditKeyUpHandler);
            this.mPanel.rankName3.addEventListener(KeyboardEvent.KEY_UP, this.RanksEditKeyUpHandler);
            this.mPanel.rankName4.addEventListener(KeyboardEvent.KEY_UP, this.RanksEditKeyUpHandler);
            this.mPanel.rankName1.addEventListener(MouseEvent.CLICK, this.ShowRankDetails);
            this.mPanel.rankName2.addEventListener(MouseEvent.CLICK, this.ShowRankDetails);
            this.mPanel.rankName3.addEventListener(MouseEvent.CLICK, this.ShowRankDetails);
            this.mPanel.rankName4.addEventListener(MouseEvent.CLICK, this.ShowRankDetails);
            this.mPanel.rankName1.addEventListener(MouseEvent.ROLL_OUT, this.RollOutRank);
            this.mPanel.rankName2.addEventListener(MouseEvent.ROLL_OUT, this.RollOutRank);
            this.mPanel.rankName3.addEventListener(MouseEvent.ROLL_OUT, this.RollOutRank);
            this.mPanel.rankName4.addEventListener(MouseEvent.ROLL_OUT, this.RollOutRank);
            this.mPanel.manageRankTabItemList.addEventListener(ItemClickEvent.ITEM_CLICK, this.RanksEditKeyUpHandler);
            this.mPanel.motd.addEventListener("SaveChanges", this.SaveChanges);
            this.mPanel.guildDescription.addEventListener("SaveChanges", this.SaveChanges);
            this.mPanel.note.addEventListener("SaveChanges", this.SaveChanges);
            this.mPanel.officerNote.addEventListener("SaveChanges", this.SaveChanges);
            this.mPanel.kickMembersCheck.addEventListener(MouseEvent.CLICK, this.RanksEditKeyUpHandler);
            this.mPanel.writeGuildMailsCheck.addEventListener(MouseEvent.CLICK, this.RanksEditKeyUpHandler);
            this.mPanel.useNotesCheck.addEventListener(MouseEvent.CLICK, this.RanksEditKeyUpHandler);
            this.mPanel.inviteMembersCheck.addEventListener(MouseEvent.CLICK, this.RanksEditKeyUpHandler);
            this.mPanel.editGuildEmblemCheck.addEventListener(MouseEvent.CLICK, this.RanksEditKeyUpHandler);
            this.mPanel.btnGuildMarketSendSelection.addEventListener(MouseEvent.CLICK, this.SendMarketSelectionHandler);
            this.mPanel.btnGuildMarketResetSelection.addEventListener(MouseEvent.CLICK, this.ResetMarketSelection);
            this.mPanel.btnGuildMarketResetVote.addEventListener(MouseEvent.CLICK, this.ResetMarketVoteHandler);
            this.mPanel.btnGuildMarketToShop.addEventListener(MouseEvent.CLICK, this.OpenShopWindow);
            this.mPanel.btnGuildMarketToggleHistory.addEventListener(MouseEvent.CLICK, this.ToggleMarketHistory);
            this.mPanel.btnHelp.addEventListener(MouseEvent.CLICK, this.ShowHelp);
        }

        public function SetGuild(_arg_1:dGuildVO):void
        {
            var _local_4:dGuildRankListItemVO;
            var _local_5:dGuildPlayerListItemVO;
            var _local_7:dGuildLogListItemVO;
            var _local_8:Array;
            var _local_9:int;
            var _local_10:dGuildQuestVO;
            var _local_11:dQuestElementVO;
            var _local_12:int;
            var _local_13:int;
            var _local_14:String;
            if (_arg_1 == null)
            {
                this.mSelectedGuild = null;
                Hide();
                return;
            };
            this.mSelectedGuild = _arg_1;
            this.mPanel.label = (((_arg_1.name + " [") + _arg_1.tag) + "]");
            var _local_2:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            this.mIsOwnGuild = ((_local_2) && (_arg_1.id == _local_2.id));
            var _local_3:Object = {};
            for each (_local_4 in _arg_1.ranks)
            {
                _local_3[_local_4.id] = _local_4;
            };
            this.mPanel.rankMappings = _local_3;
            if (this.mIsOwnGuild)
            {
                for each (_local_5 in this.mSelectedGuild.members)
                {
                    if (_local_5.id == this.mGI.mCurrentPlayer.GetPlayerId())
                    {
                        this.mMyRank = (this.mPanel.rankMappings[_local_5.rankID] as dGuildRankListItemVO);
                        break;
                    };
                };
                if (this.mMyRank)
                {
                    _local_9 = 0;
                    while (_local_9 < this.mSelectedGuild.ranks.length)
                    {
                        _local_4 = (this.mSelectedGuild.ranks.getItemAt(_local_9) as dGuildRankListItemVO);
                        if (_local_4.id == this.mMyRank.id)
                        {
                            this.mMyRankPosition = _local_9;
                            break;
                        };
                        _local_9++;
                    };
                };
                this.mPanel.myGuildDescriptionLogView.selectedIndex = 1;
            }
            else
            {
                this.mMyRank = null;
                this.mMyRankPosition = -1;
                this.mPanel.myGuildDescriptionLogView.selectedIndex = 0;
                if (((_arg_1.size >= _arg_1.maxSize) && (_arg_1.maxSize >= global.guildMaxSizeLimit)))
                {
                    this.mPanel.btnApply.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildInviteFullMailSubject");
                    this.mPanel.btnApply.enabled = false;
                }
                else
                {
                    if (_arg_1.hasAppliedToGuildInTheLast24Hours)
                    {
                        this.mPanel.btnApply.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "GuildAlreadyApplied");
                        this.mPanel.btnApply.enabled = false;
                    }
                    else
                    {
                        if (this.mGI.GetCurrentPlayerGuild() != null)
                        {
                            this.mPanel.btnApply.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "GuildHasGuild");
                            this.mPanel.btnApply.enabled = false;
                        }
                        else
                        {
                            this.mPanel.btnApply.toolTip = "";
                            this.mPanel.btnApply.enabled = true;
                        };
                    };
                };
            };
            this.mPermissions = _arg_1.playerPermissions;
            this.mCurrentSuccessor = _arg_1.currentSuccessor;
            this.mPanel.banner.source = gAssetManager.GetGuildBannerUrlById(_arg_1.bannerID);
            this.mSelectedBanner = _arg_1.bannerID;
            this.ChangeBanner();
            this.mPanel.btnInvite.enabled = (((this.mIsOwnGuild) && (this.mPermissions)) && (this.mPermissions.Invite()));
            this.mPanel.btnMail.enabled = (((this.mIsOwnGuild) && (this.mPermissions)) && (this.mPermissions.GuildMail()));
            this.mPanel.btnLeave.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ((this.mMyRankPosition == 0) ? "GuildDisband" : "GuildLeave"));
            this.mPanel.btnLeave.enabled = ((this.mMyRankPosition == 0) ? this.canDisbandGuild() : this.mIsOwnGuild);
            if (((!(this.mPanel.btnLeave.enabled)) && (this.mMyRankPosition == 0)))
            {
                this.mPanel.btnLeave.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "GuildDisbandDisabeldTooltip");
            };
            this.mPanel.btnStepDown.enabled = (((this.mMyRankPosition == 0) && (this.mSelectedGuild.size > 1)) && (this.mCurrentSuccessor == 0));
            this.mPanel.btnIncrease.enabled = ((this.mIsOwnGuild) && (_arg_1.maxSize < global.guildMaxSizeLimit));
            this.mPanel.btnKick.enabled = false;
            if (this.mCurrentSuccessor != 0)
            {
                this.mPanel.btnStepDown.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildSuccessionInPlace");
            }
            else
            {
                this.mPanel.btnStepDown.toolTip = null;
            };
            var _local_6:ClassFactory = new ClassFactory(GuildSuccessorItemRenderer);
            _local_6.properties = {
                "isOwnGuild":this.mIsOwnGuild,
                "successorAssignAllowed":this.IsSuccessorAssignAllowed(),
                "successionInPlace":(this.mCurrentSuccessor > 0),
                "guildSize":this.mSelectedGuild.size
            };
            this.mPanel.membersList.itemRenderer = _local_6;
            this.UpdateGrid(_arg_1);
            if (this.mIsOwnGuild)
            {
                _local_13 = int.MAX_VALUE;
                for each (_local_5 in this.mPanel.membersList.dataProvider)
                {
                    _local_5.questsStatus = _local_5.quest.status;
                };
            };
            this.mPanel.motd.text = _arg_1.motd;
            this.mPanel.motd.editable = ((this.mPermissions) && (this.mPermissions.MOTDWrite()));
            this.mPanel.guildInfo.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildDetailsFounded", [cLocaManager.GetInstance().FormatDate(_arg_1.foundTime).toString()]);
            this.mPanel.guildInfo.text = (this.mPanel.guildInfo.text + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildDetailsPlayersCount", [_arg_1.size.toString()])));
            if (this.mIsOwnGuild)
            {
                this.mPanel.guildInfo.text = (this.mPanel.guildInfo.text + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildDetailsMaxPlayersCount", [_arg_1.maxSize])));
            };
            if (_arg_1.leader)
            {
                this.mPanel.leaderAvatar.data = _arg_1.leader;
                this.mPanel.leaderName.text = cGeneralInterface.getComputedPlayerName(_arg_1.leader.username);
            };
            this.mPanel.guildDescriptionForNotMembers.text = _arg_1.description;
            this.mPanel.guildDescription.text = _arg_1.description;
            this.mPanel.guildDescription.editable = ((this.mPermissions) && (this.mPermissions.DescriptionWrite()));
            this.mPanel.guildLog.dataProvider = new ArrayCollection();
            for each (_local_7 in _arg_1.log)
            {
                _local_14 = cLocaManager.GetInstance().GetText(LOCA_GROUP.GUILD_LOG_RECORDS, GUILD_LOG_IDENTIFIER.toString(_local_7.identifier), _local_7.parameters.toArray());
                this.mPanel.guildLog.dataProvider.addItem(((cLocaManager.GetInstance().FormatDate(_local_7.timestamp).toString() + ": ") + _local_14));
            };
            _local_8 = [{
                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildPage"),
                "group":"GuildPage"
            }];
            if (this.mIsOwnGuild)
            {
                _local_8.push({
                    "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildMembers"),
                    "group":"GuildMembers"
                });
            };
            if (this.IsAdminTabAllowed())
            {
                _local_8.push({
                    "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildAdministration"),
                    "group":"GuildAdministration"
                });
            };
            if (((this.mIsOwnGuild) && (this.mGI.mVotesManager.IsVoteEnabled())))
            {
                _local_8.push({
                    "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildMarket"),
                    "group":"GuildMarket"
                });
            };
            if (((this.mPanel.buttonBar.dataProvider == null) || (!(this.mPanel.buttonBar.dataProvider.length == _local_8.length))))
            {
                this.mPanel.buttonBar.dataProvider = _local_8;
            };
            if (!this.mIsOwnGuild)
            {
                return;
            };
            this.mPanel.rankName1.editable = ((this.mPermissions) && (this.mPermissions.RanksEdit()));
            this.mPanel.rankName2.editable = ((this.mPermissions) && (this.mPermissions.RanksEdit()));
            this.mPanel.rankName3.editable = ((this.mPermissions) && (this.mPermissions.RanksEdit()));
            this.mPanel.rankName4.editable = ((this.mPermissions) && (this.mPermissions.RanksEdit()));
            if (((!(_arg_1.leader == null)) && (_local_2.leader.id == this.mGI.mCurrentPlayer.GetPlayerId())))
            {
                this.mPanel.editPermissionsAllowed = true;
            };
            this.SetRanks();
            if (((this.mPanel.GuildMarketUniqueItems.dataProvider == null) || (this.mPanel.GuildMarketDefaultItems.dataProvider == null)))
            {
                this.RefreshGuildMarket();
            };
        }

        private function AssignRank(_arg_1:MouseEvent):void
        {
            var _local_2:dGuildRankListItemVO;
            switch (_arg_1.target)
            {
                case this.mPanel.btnRankUp:
                    if (this.IsRankUpAllowed(this.mSelectedMember.rankID))
                    {
                        _local_2 = (this.mSelectedGuild.ranks.getItemAt((this.GetCurrentRankPosition(this.mSelectedMember.rankID) - 1)) as dGuildRankListItemVO);
                    };
                    break;
                case this.mPanel.btnRankDown:
                    if (this.IsRankDownAllowed(this.mSelectedMember.rankID))
                    {
                        _local_2 = (this.mSelectedGuild.ranks.getItemAt((this.GetCurrentRankPosition(this.mSelectedMember.rankID) + 1)) as dGuildRankListItemVO);
                    };
                    break;
            };
            if (!_local_2)
            {
                return;
            };
            this.mSelectedMember.rankID = _local_2.id;
            this.ShowMemberDetails(null);
            this.UpdateGrid();
            var _local_3:dGuildEditValueVO = new dGuildEditValueVO();
            _local_3.type = EDIT_TYPE.RANK_ASSIGN;
            _local_3.newValue = _local_2.id.toString();
            _local_3.parameters = new ArrayCollection([this.mSelectedMember.id.toString()]);
            this.SendChanges(_local_3);
        }

        public function ClearGuildRankDetails(_arg_1:Boolean):void
        {
            var _local_2:int;
            this.mWaitingForServerResponse = false;
            this.showGuildTabGlassAnimation();
            if (_arg_1)
            {
                this.mSelectedRank = null;
                this.SetRankDetail(null);
                this.mPanel.manageRankTabItemList.dataProvider = null;
                _local_2 = 0;
                while (_local_2 < 4)
                {
                    this.mPanel[("rankName" + (_local_2 + 1))].styleName = "detailsSubContentBoxNormal";
                    _local_2++;
                };
            };
        }

        private function canDisbandGuild():Boolean
        {
            return ((this.isLeaderAlone()) && (this.isGuildBankEmpty()));
        }

        private function UpdateMarketItemSelecteLabel(_arg_1:Label, _arg_2:int, _arg_3:int):void
        {
            _arg_1.text = ((((cLocaManager.GetInstance().getLabel("VotesSpent") + ": ") + _arg_2) + " / ") + _arg_3);
        }

        public function SetHeaders(_arg_1:dGuildHeadersListVO):void
        {
            if (_arg_1)
            {
                this.mCurrentPage = _arg_1.page;
                this.mMaxPage = _arg_1.maxPages;
                this.mPanel.guildList.dataProvider = _arg_1.list;
            };
            this.mPanel.btnPrevPage.enabled = (this.mCurrentPage > 1);
            this.mPanel.btnNextPage.enabled = (this.mCurrentPage < this.mMaxPage);
        }

        private function StepDown(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_STEP_DOWN, this.mGI.mCurrentViewedZoneID, null);
            this.mPanel.btnStepDown.enabled = false;
            this.mCurrentSuccessor = 1;
            var _local_2:ClassFactory = new ClassFactory(GuildSuccessorItemRenderer);
            _local_2.properties = {
                "isOwnGuild":this.mIsOwnGuild,
                "successorAssignAllowed":this.IsSuccessorAssignAllowed(),
                "successionInPlace":(this.mCurrentSuccessor > 0),
                "guildSize":this.mSelectedGuild.size
            };
            this.mPanel.membersList.itemRenderer = _local_2;
            this.mSelectedGuild.members.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
        }

        private function SendMarketSelection(_arg_1:CloseEvent):void
        {
            var _local_4:GuildMarketItemRendererData;
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:ArrayCollection = new ArrayCollection();
            var _local_3:ArrayCollection = new ArrayCollection();
            for each (_local_4 in this.mPanel.GuildMarketUniqueItems.dataProvider)
            {
                if (_local_4.isSelected)
                {
                    _local_2.addItem(_local_4.voteItem);
                };
            };
            this.mGI.mVotesManager.GetPlayerVote().pools[VOTE_POOL.UNIQUE_ITEMS].votes = _local_2;
            for each (_local_4 in this.mPanel.GuildMarketDefaultItems.dataProvider)
            {
                if (_local_4.isSelected)
                {
                    _local_3.addItem(_local_4.voteItem);
                };
            };
            this.mGI.mVotesManager.GetPlayerVote().pools[VOTE_POOL.DEFAULT_ITEMS].votes = _local_3;
            this.mPanel.btnGuildMarketSendSelection.enabled = false;
            this.mPanel.btnGuildMarketResetSelection.enabled = false;
            this.mGI.mVotesManager.SendVote();
        }

        private function RankChanged():Boolean
        {
            var _local_1:TextInput = this.mPanel[("rankName" + (this.GetCurrentRankPosition(this.mSelectedRank.id) + 1))];
            return (((((((!(this.mSelectedRank.name == _local_1.text)) || (!(this.mSelectedRank.dGuildRankPermissionVO.Kick() == this.mPanel.kickMembersCheck.selected))) || (!(this.mSelectedRank.dGuildRankPermissionVO.GuildMail() == this.mPanel.writeGuildMailsCheck.selected))) || (!(this.mSelectedRank.dGuildRankPermissionVO.NoteWrite() == this.mPanel.useNotesCheck.selected))) || (!(this.mSelectedRank.dGuildRankPermissionVO.Invite() == this.mPanel.inviteMembersCheck.selected))) || (!(this.mSelectedRank.dGuildRankPermissionVO.BannerWrite() == this.mPanel.editGuildEmblemCheck.selected))) || (this.RankTabsChanged()));
        }

        private function ShowHelp(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mHelpOverview.ShowItem(global.map_HelpName_HelpDefinition["Help_window_guild_market_0"], 1);
            globalFlash.gui.mHelpOverview.Show();
        }


    }
}
