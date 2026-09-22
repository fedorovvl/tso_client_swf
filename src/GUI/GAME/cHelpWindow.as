package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import GUI.Components.HelpWindow;
    import Interface.cGeneralInterface;
    import Communication.VO.dHelpDefinitionVO;
    import __AS3__.vec.Vector;
    import flash.events.MouseEvent;
    import Enums.COMMAND;
    import mx.events.FlexEvent;
    import mx.events.ResizeEvent;
    import flash.events.Event;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import ServerState.cPlayerData;
    import nLib.cLog;
    import __AS3__.vec.*;

    public class cHelpWindow extends cGuiBaseElement 
    {

        private var clickOffsetY:int;
        private var maxPages:int;
        private var ignoreHideHelp:Boolean = false;
        private var mPanel:HelpWindow;
        private var gi:cGeneralInterface;
        private var hideHelp:Object = null;
        private var currentPage:int;
        private var helpDefinition:dHelpDefinitionVO;
        private var clickOffsetX:int;
        private var forceNext:Boolean = false;

        private var visibleHelp_vector:Vector.<dHelpDefinitionVO> = new Vector.<dHelpDefinitionVO>();
        private var mKnownHelp_vector:Vector.<String> = new Vector.<String>();

        public function cHelpWindow()
        {
            super();
            if (defines.CLIENT_ZONEID != 0)
            {
                this.hideHelp = true;
            };
        }

        private function NextPage(_arg_1:MouseEvent):void
        {
            this.currentPage++;
            this.SetData();
        }

        private function addKnownHelp(_arg_1:String):void
        {
            this.mKnownHelp_vector.push(_arg_1);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.visibleHelp_vector.length = 0;
            if (this.mPanel.helpHide.selected)
            {
                this.gi.mCurrentPlayer.mHideHelp = true;
                this.hideHelp = true;
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.SET_HIDE_HELP, this.gi.mCurrentPlayer.GetPlayerId(), true);
            };
            Hide();
        }

        private function PreviousPage(_arg_1:MouseEvent):void
        {
            this.currentPage--;
            this.SetData();
        }

        private function ShowOverview(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            if (this.visibleHelp_vector.length > 0)
            {
                _local_2 = this.visibleHelp_vector[0].helpName_string;
                globalFlash.gui.mHelpOverview.ShowItem(global.map_HelpName_HelpDefinition[_local_2], 1);
            };
            globalFlash.gui.mHelpOverview.Show();
        }

        public function ForceNextHelpWindow():void
        {
            this.forceNext = true;
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnClose2.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnHelpOverview.addEventListener(MouseEvent.CLICK, this.ShowOverview);
            this.mPanel.btnHelpPreviousEnd.addEventListener(MouseEvent.CLICK, this.FirstPage);
            this.mPanel.btnHelpPrevious.addEventListener(MouseEvent.CLICK, this.PreviousPage);
            this.mPanel.btnHelpNext.addEventListener(MouseEvent.CLICK, this.NextPage);
            this.mPanel.btnHelpNextEnd.addEventListener(MouseEvent.CLICK, this.LastPage);
            this.mPanel.btnInImageButton.addEventListener(MouseEvent.CLICK, this.InImage);
            this.mPanel.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler);
            this.mPanel.ornamentalTop.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler);
            global.getApplication().addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
        }

        private function MouseDownHandler(_arg_1:MouseEvent):void
        {
            if ((((_arg_1.target == this.mPanel.ornamentalTop) || (_arg_1.target.parent == this.mPanel.headline)) || ((_arg_1.target.parent == this.mPanel.background) && (_arg_1.localY < 8))))
            {
                this.mPanel.setConstraintValue("left", null);
                this.mPanel.setConstraintValue("top", null);
                this.clickOffsetX = (_arg_1.stageX - this.mPanel.x);
                this.clickOffsetY = (_arg_1.stageY - this.mPanel.y);
                global.getApplication().addEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
                global.getApplication().stage.addEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
                global.getApplication().addEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
            };
        }

        private function SetData():void
        {
            var _local_2:dHelpDefinitionVO;
            var _local_1:int;
            for each (_local_2 in this.visibleHelp_vector)
            {
                if ((_local_1 + _local_2.pages) < this.currentPage)
                {
                    _local_1 = (_local_1 + _local_2.pages);
                }
                else
                {
                    _local_1 = (this.currentPage - _local_1);
                    this.helpDefinition = _local_2;
                    break;
                };
            };
            this.mPanel.headline.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.HELP_ITEM_LABEL, this.helpDefinition.helpName_string);
            this.mPanel.helpImage.source = gAssetManager.GetHelpImageUrl(this.helpDefinition.helpImage_string, _local_1);
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.HELP_ITEM_DESCRIPTION, (this.helpDefinition.helpName_string + _local_1));
            this.mPanel.description.verticalScrollPosition = 0;
            this.mPanel.pageLabel.text = ((this.currentPage + "/") + this.maxPages);
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
            if (this.currentPage == this.maxPages)
            {
                this.mPanel.btnHelpNext.enabled = false;
                this.mPanel.btnHelpNextEnd.enabled = false;
            }
            else
            {
                this.mPanel.btnHelpNext.enabled = true;
                this.mPanel.btnHelpNextEnd.enabled = true;
            };
            this.mPanel.btnInImageButton.visible = this.helpDefinition.hasButton;
            if (this.helpDefinition.hasButton)
            {
                this.mPanel.btnInImageButton.setStyle("icon", gAssetManager.GetClass(this.helpDefinition.helpName_string));
                this.mPanel.btnInImageButton.x = this.helpDefinition.buttonPositionX;
                this.mPanel.btnInImageButton.y = this.helpDefinition.buttonPositionY;
            };
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 58)
            {
                this.mPanel.y = 58;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > ((global.getApplication().stage.stageHeight - this.mPanel.height) - 15))
            {
                this.mPanel.y = ((global.getApplication().stage.stageHeight - this.mPanel.height) - 15);
            };
        }

        override public function Show():void
        {
            if (this.visibleHelp_vector.length == 0)
            {
                return;
            };
            super.Show();
        }

        private function MouseMoveHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.x = (_arg_1.stageX - this.clickOffsetX);
            this.mPanel.y = (_arg_1.stageY - this.clickOffsetY);
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 58)
            {
                this.mPanel.y = 58;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > ((global.getApplication().stage.stageHeight - this.mPanel.height) - 15))
            {
                this.mPanel.y = ((global.getApplication().stage.stageHeight - this.mPanel.height) - 15);
            };
        }

        private function LastPage(_arg_1:MouseEvent):void
        {
            this.currentPage = this.maxPages;
            this.SetData();
        }

        public function Init(_arg_1:HelpWindow):void
        {
            this.gi = global.ui;
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function MouseUpHandler(_arg_1:Event):void
        {
            global.getApplication().removeEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
            global.getApplication().stage.removeEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
            global.getApplication().removeEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
        }

        public function ResetHideHelp():void
        {
            this.hideHelp = null;
            this.mKnownHelp_vector = new Vector.<String>();
        }

        private function isHelpKnown(_arg_1:String):Boolean
        {
            return (!(this.mKnownHelp_vector.indexOf(_arg_1) == -1));
        }

        private function InImage(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest(this.helpDefinition.url), "_blank");
            global.getApplication().inputNotifier.notifyClick(this.helpDefinition.helpName_string);
        }

        override public function SetDataByString(_arg_1:String):void
        {
            var _local_3:dHelpDefinitionVO;
            var _local_2:cPlayerData = this.gi.mCurrentPlayer;
            if (this.hideHelp == null)
            {
                this.hideHelp = _local_2.mHideHelp;
                this.mKnownHelp_vector = _local_2.mKnownHelp_vector;
            };
            if ((((!(this.hideHelp)) && (!(this.isHelpKnown(_arg_1)))) || (this.forceNext)))
            {
                this.forceNext = false;
                _local_3 = global.map_HelpName_HelpDefinition[_arg_1];
                if (_local_3 == null)
                {
                    cLog.error(("Unknown HelpWindow ID:" + _arg_1));
                    return;
                };
                this.addKnownHelp(_arg_1);
                this.gi.mClientMessages.SendMessagetoServer(COMMAND.HELP_SHOWN, _local_2.GetPlayerId(), _arg_1);
                if (((this.visibleHelp_vector.length == 0) || (!(this.visibleHelp_vector[(this.visibleHelp_vector.length - 1)].helpName_string == _local_3.helpName_string))))
                {
                    this.visibleHelp_vector.push(_local_3);
                };
                if (this.visibleHelp_vector.length == 1)
                {
                    this.currentPage = 1;
                    this.maxPages = this.visibleHelp_vector[0].pages;
                    this.mPanel.helpHide.selected = false;
                }
                else
                {
                    this.currentPage = (this.maxPages + 1);
                    this.maxPages = (this.maxPages + _local_3.pages);
                };
                this.mPanel.pageBox.visible = (this.maxPages > 1);
                this.SetData();
            };
        }

        private function FirstPage(_arg_1:MouseEvent):void
        {
            this.currentPage = 1;
            this.SetData();
        }


    }
}
