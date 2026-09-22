package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.FoundGuildPanel;
    import Enums.ERROR_CODES;
    import flash.events.KeyboardEvent;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import Communication.VO.Guild.dGuildRankListItemVO;
    import Communication.VO.Guild.dGuildVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.collections.ArrayCollection;
    import Enums.COMMAND;
    import GUI.Assets.gAssetManager;
    import GUI.Components.CustomTextInput;

    public class cFoundGuildPanel extends cBasicPanel 
    {

        private var mNameValid:Boolean = false;
        private var mTagValid:Boolean = false;
        private var mSelectedBanner:int;
        private var mGI:cGameInterface;
        protected var mPanel:FoundGuildPanel;


        public function ValidateName(_arg_1:String, _arg_2:int):void
        {
            if (this.mPanel.guildName.text != _arg_1)
            {
                return;
            };
            if (_arg_2 == ERROR_CODES.NO_ERROR)
            {
                this.mPanel.guildName.setStyle("color", 0xFFFFFF);
                this.mNameValid = true;
            }
            else
            {
                this.mPanel.guildName.setStyle("color", 0xFF0000);
                this.mNameValid = false;
            };
            this.ValidateInputs();
        }

        private function ValidateInputs(_arg_1:KeyboardEvent=null):void
        {
            this.mPanel.btnFound.enabled = ((this.mNameValid) && (this.mTagValid));
        }

        public function ValidateTag(_arg_1:String, _arg_2:int):void
        {
            if (this.mPanel.guildTag.text != _arg_1)
            {
                return;
            };
            if (_arg_2 == ERROR_CODES.NO_ERROR)
            {
                this.mPanel.guildTag.setStyle("color", 0xFFFFFF);
                this.mTagValid = true;
            }
            else
            {
                this.mPanel.guildTag.setStyle("color", 0xFF0000);
                this.mTagValid = false;
            };
            this.ValidateInputs();
        }

        private function Clear():void
        {
            this.mPanel.guildName.text = "";
            this.mPanel.guildTag.text = "";
            this.mNameValid = false;
            this.mTagValid = false;
            this.mSelectedBanner = 1;
            this.ChangeBanner();
        }

        public function Init(_arg_1:FoundGuildPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnFound.addEventListener(MouseEvent.CLICK, this.FoundGuild);
            this.mPanel.guildName.addEventListener(KeyboardEvent.KEY_UP, this.KeyUpHandler);
            this.mPanel.guildTag.addEventListener(KeyboardEvent.KEY_UP, this.KeyUpHandler);
            this.mPanel.btnBannerLeft.addEventListener(MouseEvent.CLICK, this.ChangeBanner);
            this.mPanel.btnBannerRight.addEventListener(MouseEvent.CLICK, this.ChangeBanner);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        private function FoundGuild(_arg_1:MouseEvent):void
        {
            var _local_4:dGuildRankListItemVO;
            var _local_2:dGuildVO = new dGuildVO();
            _local_2.name = this.mPanel.guildName.text;
            _local_2.tag = this.mPanel.guildTag.text;
            _local_2.motd = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildDefaultMOTD");
            _local_2.bannerID = this.mSelectedBanner;
            _local_2.ranks = new ArrayCollection();
            var _local_3:int = 1;
            while (_local_3 <= 4)
            {
                _local_4 = new dGuildRankListItemVO();
                _local_4.name = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("GuildDefaultRank" + _local_3));
                _local_2.ranks.addItem(_local_4);
                _local_3++;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_FOUND, this.mGI.mCurrentPlayer.GetPlayerId(), _local_2);
            this.Hide();
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
            this.mPanel.btnBannerLeft.enabled = (this.mSelectedBanner > 1);
            this.mPanel.btnBannerRight.enabled = (this.mSelectedBanner < global.guildBannerCount);
        }

        override public function Show():void
        {
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildFound");
            this.Clear();
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        private function KeyUpHandler(_arg_1:KeyboardEvent):void
        {
            var _local_2:CustomTextInput = (_arg_1.currentTarget as CustomTextInput);
            switch (_local_2)
            {
                case this.mPanel.guildName:
                    if (_local_2.text.length < 3)
                    {
                        this.mNameValid = false;
                        this.ValidateInputs();
                        return;
                    };
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_FOUND_VALIDATE_NAME, 0, _local_2.text);
                    return;
                case this.mPanel.guildTag:
                    if (_local_2.text.length < 1)
                    {
                        this.mTagValid = false;
                        this.ValidateInputs();
                        return;
                    };
                    this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_FOUND_VALIDATE_TAG, 0, _local_2.text);
                    return;
            };
        }


    }
}
