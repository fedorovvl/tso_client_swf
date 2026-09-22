package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.FriendsList;
    import Communication.VO.dPlayerListItemVO;
    import Communication.VO.Guild.dGuildPlayerListItemVO;
    import Communication.VO.Guild.dGuildVO;
    import Enums.COMMAND;
    import Communication.VO.dIntegerVO;
    import mx.events.FlexEvent;
    import mx.events.ItemClickEvent;
    import flash.events.MouseEvent;
    import Communication.VO.dPartnerSettingsVO;
    import Communication.VO.Guild.dGuildRankListItemVO;
    import GUI.Components.FriendsListFilterSelector;
    import mx.containers.Canvas;
    import Utils.TriggerUtils;
    import mx.utils.ObjectUtil;

    public class cFriendsList extends cGuiBaseElement 
    {

        private var mOnlineStatusFriendQueue:Object;
        private var mGuildRanksPositionMapping:Object;
        private var mFilter:int = 0;
        private var mGI:cGameInterface;
        private var mIsLoaded:Boolean = false;
        private var mPreviousFilter:int = 0;
        protected var mFriendsList:FriendsList;
        private var mFriendListPlayer:dPlayerListItemVO;
        private var mList:Array;
        private var mOnlineStatusGuildQueue:Object;


        public function IsGuildMember(_arg_1:dPlayerListItemVO):Boolean
        {
            var _local_3:dGuildPlayerListItemVO;
            var _local_2:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            if (_local_2 == null)
            {
                return (false);
            };
            for each (_local_3 in _local_2.members)
            {
                if (_local_3.id == _arg_1.id)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function AddFriend(_arg_1:dPlayerListItemVO):void
        {
            if (this.IsFriend(_arg_1))
            {
                return;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.ADD_FRIEND, 0, new dIntegerVO(_arg_1.id));
        }

        public function SetOnlineStatus(_arg_1:String, _arg_2:Boolean, _arg_3:Boolean=false):void
        {
            var _local_4:dPlayerListItemVO;
            var _local_5:dGuildPlayerListItemVO;
            if (!_arg_3)
            {
                _local_4 = this.GetFriendByName_string(_arg_1);
                if (_local_4)
                {
                    _local_4.onlineStatus = _arg_2;
                }
                else
                {
                    this.mOnlineStatusFriendQueue[_arg_1] = _arg_2;
                };
            }
            else
            {
                _local_5 = this.GetGuildMemberByName_string(_arg_1);
                if (_local_5)
                {
                    _local_5.onlineStatus = _arg_2;
                    _local_5.onlineLast24 = true;
                }
                else
                {
                    this.mOnlineStatusGuildQueue[_arg_1] = _arg_2;
                };
            };
        }

        public function GetGuildMemberById(_arg_1:int):dGuildPlayerListItemVO
        {
            var _local_2:dGuildPlayerListItemVO;
            if (this.mGI.GetCurrentPlayerGuild() == null)
            {
                return (null);
            };
            for each (_local_2 in this.mGI.GetCurrentPlayerGuild().members)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        private function SortGuildMembers(_arg_1:dGuildPlayerListItemVO, _arg_2:dGuildPlayerListItemVO):Number
        {
            if (this.mGuildRanksPositionMapping[_arg_1.rankID] > this.mGuildRanksPositionMapping[_arg_2.rankID])
            {
                return (1);
            };
            if (this.mGuildRanksPositionMapping[_arg_1.rankID] < this.mGuildRanksPositionMapping[_arg_2.rankID])
            {
                return (-1);
            };
            return (this.SortFriends(_arg_1, _arg_2));
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mFriendsList.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mFriendsList.filterSelector.buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK, this.FilterList);
            this.mFriendsList.optionButtons.btnAddFriend.addEventListener(MouseEvent.CLICK, globalFlash.gui.mFriendsListMenu.ShowAddFriendPanel);
            this.mFriendsList.optionButtons.btnInvite.addEventListener(MouseEvent.CLICK, globalFlash.gui.mFriendsListMenu.Invite);
            this.mFriendsList.optionButtons.btnReturnHome.addEventListener(MouseEvent.CLICK, this.ReturnHome);
            this.mOnlineStatusFriendQueue = {};
            this.mOnlineStatusGuildQueue = {};
            if (((!(global.partner == "")) && ((global.partnerSettings[global.partner] as dPartnerSettingsVO).hideInviteByMail)))
            {
                this.mFriendsList.optionButtons.setCurrentState("hideMailInvite", false);
            };
        }

        public function SetData(_arg_1:Array):void
        {
            var _local_5:dPlayerListItemVO;
            var _local_6:String;
            var _local_11:dGuildPlayerListItemVO;
            var _local_12:dGuildRankListItemVO;
            var _local_13:int;
            if (_arg_1 == null)
            {
                _arg_1 = [];
            }
            else
            {
                this.mIsLoaded = true;
            };
            this.mList = _arg_1;
            var _local_2:Array = [];
            var _local_3:Array = [];
            var _local_4:Array = [];
            if (this.mOnlineStatusFriendQueue == null)
            {
                return;
            };
            for each (_local_5 in _arg_1)
            {
                if (this.mOnlineStatusFriendQueue[_local_5.username.toLowerCase()] != null)
                {
                    _local_5.onlineStatus = this.mOnlineStatusFriendQueue[_local_5.username.toLowerCase()];
                    this.mOnlineStatusFriendQueue[_local_5.username.toLowerCase()] = null;
                    delete this.mOnlineStatusFriendQueue[_local_5.username.toLowerCase()];
                };
                _local_3.push(_local_5);
            };
            for each (_local_6 in this.mOnlineStatusFriendQueue)
            {
                if (this.mOnlineStatusFriendQueue[_local_6] == false)
                {
                    this.mOnlineStatusFriendQueue[_local_6] = null;
                    delete this.mOnlineStatusFriendQueue[_local_6];
                };
            };
            if (this.mFriendListPlayer)
            {
                _local_3.push(this.mFriendListPlayer);
            };
            var _local_7:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            this.mGuildRanksPositionMapping = {};
            if (_local_7)
            {
                _local_4 = _local_7.members.toArray();
                for each (_local_11 in _local_4)
                {
                    if (this.mOnlineStatusGuildQueue[_local_11.username.toLowerCase()] != null)
                    {
                        _local_11.onlineStatus = this.mOnlineStatusGuildQueue[_local_11.username.toLowerCase()];
                        this.mOnlineStatusGuildQueue[_local_11.username.toLowerCase()] = null;
                        delete this.mOnlineStatusGuildQueue[_local_11.username.toLowerCase()];
                    };
                };
                for each (_local_6 in this.mOnlineStatusGuildQueue)
                {
                    if (this.mOnlineStatusGuildQueue[_local_6] == false)
                    {
                        this.mOnlineStatusGuildQueue[_local_6] = null;
                        delete this.mOnlineStatusGuildQueue[_local_6];
                    };
                };
                for each (_local_12 in _local_7.ranks)
                {
                    this.mGuildRanksPositionMapping[_local_12.id] = _local_7.ranks.getItemIndex(_local_12);
                };
            };
            switch (this.mFilter)
            {
                case FriendsListFilterSelector.ALL:
                    if (_local_7)
                    {
                        _local_13 = 0;
                        while (_local_13 < _local_3.length)
                        {
                            if (this.IsGuildMember(_local_3[_local_13]))
                            {
                                _local_3.splice(_local_13, 1);
                                _local_13--;
                            };
                            _local_13++;
                        };
                    };
                    _local_3 = _local_3.concat(_local_4);
                    _local_3.sort(this.SortFriends);
                    _local_2 = _local_2.concat(_local_3);
                    break;
                case FriendsListFilterSelector.FRIENDS:
                    _local_2 = _local_2.concat(_local_3);
                    _local_2.sort(this.SortFriends);
                    break;
                case FriendsListFilterSelector.GUILD:
                    _local_2 = _local_2.concat(_local_4.filter(this.guildOnlyActiveFilter));
                    _local_2.sort(this.SortGuildMembers);
                    break;
                case 3:
                    _local_3 = _local_3.filter(this.removeDpFilter).concat(_local_4);
                    _local_3.sort(this.SortFriends);
                    _local_2 = _local_2.concat(_local_3.filter(this.onlineFrFilter));
                    break;
            };
            var _local_8:int = int((this.mFriendsList.list.width / (this.mFriendsList.list.itemRenderer.newInstance() as Canvas).width));
            var _local_9:int = (_local_8 - _local_2.length);
            _local_13 = 0;
            while (_local_13 < _local_9)
            {
                _local_2.push(null);
                _local_13++;
            };
            var _local_10:int = this.mFriendsList.list.horizontalScrollPosition;
            this.mFriendsList.list.dataProvider = _local_2;
            if (this.mFilter == this.mPreviousFilter)
            {
                this.mFriendsList.list.horizontalScrollPosition = _local_10;
            };
            this.mPreviousFilter = this.mFilter;
            this.mFriendsList.optionButtons.btnReturnHome.enabled = (!(this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mGI.mCurrentViewedZoneID));
            globalFlash.gui.mTrackedMissionList.Refresh();
        }

        public function GetGuildMemberByName_string(_arg_1:String):dGuildPlayerListItemVO
        {
            var _local_3:dGuildPlayerListItemVO;
            var _local_2:dGuildVO = this.mGI.GetCurrentPlayerGuild();
            if (!_local_2)
            {
                return (null);
            };
            for each (_local_3 in _local_2.members)
            {
                if (_local_3.username.toLowerCase() == _arg_1)
                {
                    return (_local_3);
                };
            };
            return (null);
        }

        public function GetFriendByName_string(_arg_1:String):dPlayerListItemVO
        {
            var _local_2:dPlayerListItemVO;
            for each (_local_2 in this.mList)
            {
                if (_local_2.username.toLowerCase() == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function RemoveFriendById(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < this.mList.length)
            {
                if ((this.mList[_local_2] as dPlayerListItemVO).id == _arg_1)
                {
                    this.mList.splice(_local_2, 1);
                    break;
                };
                _local_2++;
            };
            this.SetData(this.mList);
        }

        public function FilterList(_arg_1:ItemClickEvent):void
        {
            this.mFilter = _arg_1.item.selection;
            this.SetData(this.mList);
        }

        public function RemoveFriend(_arg_1:int):void
        {
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.REMOVE_FRIEND, 0, new dIntegerVO(_arg_1));
            this.RemoveFriendById(_arg_1);
        }

        public function getHeight():Number
        {
            return (this.mFriendsList.height);
        }

        private function ReturnHome(_arg_1:MouseEvent):void
        {
            cBasicPanel.HideCurrentActivePanel();
            globalFlash.gui.mLoadingZonePanel.Show();
            global.ui.mCurrentPlayerZone.SaveZoneStartZoom();
            global.ui.mClientMessages.SendGetZoneMessageToServer(COMMAND.GET_ZONE, global.ui.mCurrentPlayer.GetHomeZoneId(), false);
        }

        public function GetFilteredFriends(_arg_1:String, _arg_2:Boolean=false):Array
        {
            var _local_4:dPlayerListItemVO;
            var _local_6:dGuildPlayerListItemVO;
            var _local_3:Array = [];
            _arg_1 = _arg_1.toLowerCase();
            for each (_local_4 in this.mList)
            {
                if (_local_4.id >= 0)
                {
                    if (_local_4.username.toLocaleLowerCase().indexOf(_arg_1) == 0)
                    {
                        _local_3.push(_local_4);
                    };
                };
            };
            if (((!(_arg_2)) || (!(this.mGI.GetCurrentPlayerGuild()))))
            {
                return (_local_3);
            };
            var _local_5:int;
            while (_local_5 < _local_3.length)
            {
                if (this.IsGuildMember(_local_3[_local_5]))
                {
                    _local_3.splice(_local_5, 1);
                    _local_5--;
                };
                _local_5++;
            };
            for each (_local_6 in this.mGI.GetCurrentPlayerGuild().members)
            {
                if (_local_6.id != this.mGI.mCurrentPlayer.GetPlayerId())
                {
                    if (_local_6.username.toLocaleLowerCase().indexOf(_arg_1) == 0)
                    {
                        _local_3.push(_local_6);
                    };
                };
            };
            return (_local_3);
        }

        public function GetFriendById(_arg_1:int):dPlayerListItemVO
        {
            var _local_2:dPlayerListItemVO;
            for each (_local_2 in this.mList)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function IsLoaded():Boolean
        {
            return (this.mIsLoaded);
        }

        private function SortAdventuresDesc(_arg_1:dPlayerListItemVO, _arg_2:dPlayerListItemVO):Number
        {
            if (_arg_1.adventureVO.collectedTime < _arg_2.adventureVO.collectedTime)
            {
                return (1);
            };
            if (_arg_1.adventureVO.collectedTime > _arg_2.adventureVO.collectedTime)
            {
                return (-1);
            };
            return (0);
        }

        public function AddConfirmedFriend(_arg_1:dPlayerListItemVO):void
        {
            if (this.IsFriend(_arg_1))
            {
                return;
            };
            this.mList.push(_arg_1);
            this.SetData(this.mList);
        }

        public function IsFriend(_arg_1:dPlayerListItemVO):Boolean
        {
            var _local_2:dPlayerListItemVO;
            if (_arg_1.id == this.mGI.mCurrentPlayer.GetPlayerId())
            {
                return (true);
            };
            for each (_local_2 in this.mList)
            {
                if (_local_2.username == _arg_1.username)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function Init(_arg_1:FriendsList):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mFriendsList = _arg_1;
            this.mOnlineStatusFriendQueue = {};
            this.mOnlineStatusGuildQueue = {};
            this.mFriendsList.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        public function AddCurrentPlayer():void
        {
            var _local_1:dPlayerListItemVO = globalFlash.gui.mAvatar.GetDisplayedPlayerVO();
            this.mFriendListPlayer = _local_1;
            this.SetData(this.mList);
        }

        public function Refresh():void
        {
            this.mFriendsList.list.dataProvider = [];
            this.AddCurrentPlayer();
            this.mGI.channels.GUILD.send(TriggerUtils.NON_GUILD_FRIENDS_PROPERTY_NAME, null);
        }

        public function enableDisableFriendListOptions(_arg_1:Boolean):void
        {
            this.mFriendsList.optionButtons.btnAddFriend.enabled = _arg_1;
            this.mFriendsList.optionButtons.btnInvite.enabled = _arg_1;
            if (_arg_1)
            {
                this.mFriendsList.optionButtons.btnReturnHome.enabled = (!(this.mGI.mCurrentPlayer.GetHomeZoneId() == this.mGI.mCurrentViewedZoneID));
            }
            else
            {
                this.mFriendsList.optionButtons.btnReturnHome.enabled = false;
            };
        }

        private function SortFriends(_arg_1:dPlayerListItemVO, _arg_2:dPlayerListItemVO):Number
        {
            if (_arg_1.playerLevel < _arg_2.playerLevel)
            {
                return (1);
            };
            if (_arg_1.playerLevel > _arg_2.playerLevel)
            {
                return (-1);
            };
            return (ObjectUtil.compare(_arg_1.username.toLowerCase(), _arg_2.username.toLowerCase()));
        }

        public function onlineFrFilter(_arg_1:dPlayerListItemVO, _arg_2:int, _arg_3:Array):Boolean
        {
            return (_arg_1.onlineStatus == true);
        }

        public function removeDpFilter(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
        {
            return (!(this.IsGuildMember(_arg_1)));
        }

        public function guildOnlyActiveFilter(_arg_1:dGuildPlayerListItemVO, _arg_2:int, _arg_3:Array):Boolean
        {
            return ((_arg_1.onlineStatus == true) || (defines.GUILD_ACTIVE));
        }


    }
}
