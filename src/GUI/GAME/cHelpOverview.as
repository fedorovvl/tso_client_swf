package GUI.GAME
{
    import GUI.Components.HelpOverview;
    import Communication.VO.dHelpDefinitionVO;
    import flash.events.MouseEvent;
    import Interface.cGeneralInterface;
    import ServerState.cPlayerData;
    import Enums.COMMAND;
    import mx.events.FlexEvent;
    import mx.events.ItemClickEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import flash.utils.Dictionary;
    import Achievements.AchievementConsts;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class cHelpOverview extends cBasicPanel 
    {

        private var currentPage:int;
        private var selectedItem:Object;
        private var mPanel:HelpOverview;


        private function NextPage(_arg_1:MouseEvent):void
        {
            this.ShowItem((this.mPanel.list.selectedItem as dHelpDefinitionVO), (this.currentPage + 1));
        }

        override public function Show():void
        {
            this.SetData();
            super.Show();
        }

        private function LastPage(_arg_1:MouseEvent):void
        {
            this.ShowItem((this.mPanel.list.selectedItem as dHelpDefinitionVO), this.mPanel.list.selectedItem.pages);
        }

        private function FirstPage(_arg_1:MouseEvent):void
        {
            this.ShowItem((this.mPanel.list.selectedItem as dHelpDefinitionVO), 1);
        }

        private function ResetHelp(_arg_1:MouseEvent):void
        {
            var _local_2:cGeneralInterface = global.ui;
            var _local_3:cPlayerData = _local_2.mCurrentPlayer;
            _local_2.mClientMessages.SendMessagetoServer(COMMAND.RESET_HELP, _local_3.GetPlayerId(), null);
            _local_3.resetHelp();
            globalFlash.gui.mHelpWindow.ResetHideHelp();
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            Hide();
        }

        private function PreviousPage(_arg_1:MouseEvent):void
        {
            this.ShowItem((this.mPanel.list.selectedItem as dHelpDefinitionVO), (this.currentPage - 1));
        }

        private function DisplayNextItem():void
        {
            var _local_2:Array;
            var _local_3:Object;
            var _local_1:Object;
            for each (_local_2 in this.mPanel.list.dataProvider)
            {
                for each (_local_3 in _local_2)
                {
                    if (_local_3 != this.mPanel.list.selectedItem)
                    {
                        _local_1 = _local_3;
                        break;
                    };
                };
                if (_local_1) break;
            };
            this.ShowItem((_local_1 as dHelpDefinitionVO), 1);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnClose2.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.list.addEventListener(ItemClickEvent.ITEM_CLICK, this.ItemClickedHandler);
            this.mPanel.btnHelpReset.addEventListener(MouseEvent.CLICK, this.ResetHelp);
            this.mPanel.btnHelpPreviousEnd.addEventListener(MouseEvent.CLICK, this.FirstPage);
            this.mPanel.btnHelpPrevious.addEventListener(MouseEvent.CLICK, this.PreviousPage);
            this.mPanel.btnHelpNext.addEventListener(MouseEvent.CLICK, this.NextPage);
            this.mPanel.btnHelpNextEnd.addEventListener(MouseEvent.CLICK, this.LastPage);
            this.mPanel.btnInImageButton.addEventListener(MouseEvent.CLICK, this.InImage);
        }

        public function ShowItem(_arg_1:dHelpDefinitionVO, _arg_2:int):void
        {
            if (!_arg_1)
            {
                return;
            };
            this.mPanel.list.selectedItem = _arg_1;
            this.selectedItem = _arg_1;
            this.currentPage = _arg_2;
            this.mPanel.helpHeadline.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.HELP_ITEM_LABEL, _arg_1.helpName_string);
            this.mPanel.helpImage.source = gAssetManager.GetHelpImageUrl(_arg_1.helpImage_string, this.currentPage);
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.HELP_ITEM_DESCRIPTION, (_arg_1.helpName_string + this.currentPage));
            this.mPanel.description.verticalScrollPosition = 0;
            this.mPanel.pageBox.visible = (_arg_1.pages > 1);
            this.mPanel.pageLabel.text = ((this.currentPage + "/") + _arg_1.pages);
            if (this.currentPage == 1)
            {
                this.mPanel.btnHelpPreviousEnd.enabled = false;
                this.mPanel.btnHelpPrevious.enabled = false;
            }
            else
            {
                this.mPanel.btnHelpPreviousEnd.enabled = true;
                this.mPanel.btnHelpPrevious.enabled = true;
            };
            if (this.currentPage == _arg_1.pages)
            {
                this.mPanel.btnHelpNext.enabled = false;
                this.mPanel.btnHelpNextEnd.enabled = false;
            }
            else
            {
                this.mPanel.btnHelpNext.enabled = true;
                this.mPanel.btnHelpNextEnd.enabled = true;
            };
            global.ui.mQuestClientCallbacks.InitiateWindowOpen(((mUiElement.id + ".") + _arg_1.helpName_string));
            global.getApplication().inputNotifier.notifyClick(((mUiElement.id + ".") + _arg_1.helpName_string));
            this.mPanel.btnInImageButton.visible = _arg_1.hasButton;
            if (_arg_1.hasButton)
            {
                this.mPanel.btnInImageButton.setStyle("icon", gAssetManager.GetClass(_arg_1.helpName_string));
                this.mPanel.btnInImageButton.x = _arg_1.buttonPositionX;
                this.mPanel.btnInImageButton.y = _arg_1.buttonPositionY;
            };
        }

        private function SetData():void
        {
            var _local_2:dHelpDefinitionVO;
            var _local_3:String;
            var _local_1:Dictionary = new Dictionary();
            for each (_local_2 in global.map_HelpName_HelpDefinition)
            {
                if (defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
                {
                    if (_local_2.helpName_string == AchievementConsts.HELP_DEFINITION_NAME) continue;
                };
                _local_3 = (_local_2.type_string + "Help");
                if (_local_1[_local_3] == null)
                {
                    _local_1[_local_3] = new Array();
                };
                _local_1[_local_3].push(_local_2);
            };
            this.mPanel.list.dataProvider = _local_1;
            if (this.selectedItem)
            {
                this.ShowItem((this.selectedItem as dHelpDefinitionVO), this.currentPage);
            }
            else
            {
                this.DisplayNextItem();
            };
        }

        private function ItemClickedHandler(_arg_1:ItemClickEvent):void
        {
            this.ShowItem((_arg_1.item as dHelpDefinitionVO), 1);
        }

        private function InImage(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest(this.selectedItem.url), "_blank");
            global.getApplication().inputNotifier.notifyClick(this.selectedItem.helpName_string);
        }

        public function Init(_arg_1:HelpOverview):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }


    }
}
