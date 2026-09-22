package GUI.GAME
{
    import GUI.Components.AddFriendsPanel;
    import Interface.cGameInterface;
    import Communication.VO.dPlayerListItemVO;
    import flash.events.MouseEvent;
    import mx.events.ListEvent;
    import Enums.COMMAND;
    import flash.events.KeyboardEvent;
    import mx.events.FlexEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cAddFriendsPanel extends cBasicPanel 
    {

        public static const ADD_FRIEND:int = 0;
        public static const GUILD_INVITE:int = 1;
        public static const ADVENTURE_INVITE:int = 2;

        protected var mPanel:AddFriendsPanel;
        private var mGI:cGameInterface;
        private var mMode:int;
        private var mCachedClientPlayers:Array;


        private function AddFriend(_arg_1:MouseEvent):void
        {
            var _local_2:dPlayerListItemVO = (this.mPanel.usersList.selectedItem as dPlayerListItemVO);
            if (_local_2)
            {
                switch (this.mMode)
                {
                    case ADD_FRIEND:
                        globalFlash.gui.mFriendsList.AddFriend(_local_2);
                        this.Hide();
                        return;
                    case GUILD_INVITE:
                        globalFlash.gui.mGuildWindow.InviteMember(_local_2);
                        globalFlash.gui.mGuildWindow.Show();
                        return;
                    case ADVENTURE_INVITE:
                        globalFlash.gui.mAdventurePanel.AddInvitedPlayer(_local_2);
                        globalFlash.gui.mAdventurePanel.Show();
                        return;
                };
            };
        }

        public function SetMode(_arg_1:int):void
        {
            this.mMode = _arg_1;
        }

        private function SelectUser(_arg_1:ListEvent):void
        {
            var _local_2:dPlayerListItemVO = (this.mPanel.usersList.selectedItem as dPlayerListItemVO);
            if (_local_2)
            {
                this.mPanel.avatarPreview.data = _local_2;
                this.mPanel.namePreview.text = _local_2.username;
            };
        }

        private function KeyUpHandler(_arg_1:KeyboardEvent):void
        {
            if (this.mMode == ADVENTURE_INVITE)
            {
                this.SetData(globalFlash.gui.mFriendsList.GetFilteredFriends(this.mPanel.searchInput.text, true));
            }
            else
            {
                if (this.mPanel.searchInput.text.length >= defines.SEARCH_PLAYERLIST_BY_NAME_MIN_CHAR_LEN)
                {
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.SEARCH_PLAYER_LIST, 0, this.mPanel.searchInput.text);
                };
            };
        }

        public function SetData(_arg_1:Array):void
        {
            var _local_3:dPlayerListItemVO;
            if (this.mMode == ADVENTURE_INVITE)
            {
                this.mPanel.usersList.dataProvider = _arg_1;
                return;
            };
            var _local_2:Array = [];
            for each (_local_3 in _arg_1)
            {
                if (_local_3.id != this.mGI.mCurrentPlayer.GetPlayerId())
                {
                    switch (this.mMode)
                    {
                        case ADD_FRIEND:
                            if (!globalFlash.gui.mFriendsList.IsFriend(_local_3))
                            {
                                _local_2.push(_local_3);
                            };
                            break;
                        case GUILD_INVITE:
                            if (!globalFlash.gui.mFriendsList.IsGuildMember(_local_3))
                            {
                                _local_2.push(_local_3);
                            };
                            break;
                    };
                };
            };
            this.mPanel.usersList.dataProvider = _local_2;
        }

        private function Clear():void
        {
            this.mPanel.searchInput.text = "";
            this.mPanel.usersList.dataProvider = null;
            this.mPanel.namePreview.text = "";
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.AddFriend);
            this.mPanel.usersList.addEventListener(ListEvent.ITEM_CLICK, this.SelectUser);
            this.mPanel.searchInput.addEventListener(KeyboardEvent.KEY_UP, this.KeyUpHandler);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            if (this.mMode == ADVENTURE_INVITE)
            {
                globalFlash.gui.mAdventurePanel.Show();
            }
            else
            {
                this.Hide();
            };
        }

        override public function Show():void
        {
            this.Clear();
            switch (this.mMode)
            {
                case ADD_FRIEND:
                    this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AddFriends");
                    this.mPanel.enterNameLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "EnterFriendsName");
                    this.mPanel.height = 235;
                    break;
                case GUILD_INVITE:
                    this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildInvitePlayer");
                    this.mPanel.enterNameLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "EnterFriendsName");
                    this.mPanel.height = 235;
                    break;
                case ADVENTURE_INVITE:
                    this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AdventureInvitePlayer");
                    this.mPanel.enterNameLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "EnterFriendsNameAdventure");
                    this.mPanel.height = 250;
                    this.KeyUpHandler(null);
                    break;
            };
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel);
            this.mPanel.searchInput.setFocus();
        }

        public function Init(_arg_1:AddFriendsPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }


    }
}
