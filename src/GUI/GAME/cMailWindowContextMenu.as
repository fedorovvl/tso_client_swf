package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import GUI.Components.MailWindowContextMenu;
    import __AS3__.vec.Vector;
    import GUI.Components.ItemRenderer.FriendsListMenuItemRenderer;
    import flash.events.MouseEvent;
    import mx.events.ResizeEvent;
    import Communication.VO.dContextItemVO;
    import Communication.VO.Mail.dMailVO;
    import Communication.VO.dPlayerListItemVO;
    import Enums.MAIL_TYPE;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;

    public class cMailWindowContextMenu extends cGuiBaseElement 
    {

        private var mContextMenu:MailWindowContextMenu;
        private var mRendererPool:Vector.<FriendsListMenuItemRenderer>;


        override public function Show():void
        {
            global.getApplication().addEventListener(MouseEvent.CLICK, this.HideMenu);
            globalFlash.gui.mMailWindow.getMPanel().addChild(this.mContextMenu);
            super.Show();
            this.ResizeHandler(null);
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.mContextMenu.x < 0)
            {
                this.mContextMenu.x = 0;
            };
            if (this.mContextMenu.y < 0)
            {
                this.mContextMenu.y = 0;
            };
            if (this.mContextMenu.x > (global.getApplication().stage.stageWidth - this.mContextMenu.width))
            {
                this.mContextMenu.x = (global.getApplication().stage.stageWidth - this.mContextMenu.width);
            };
            if (this.mContextMenu.y > (global.getApplication().stage.stageHeight - this.mContextMenu.height))
            {
                this.mContextMenu.y = (global.getApplication().stage.stageHeight - this.mContextMenu.height);
            };
        }

        private function HideMenu(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mMailWindow.getMPanel().removeChild(this.mContextMenu);
            global.getApplication().removeEventListener(MouseEvent.CLICK, this.HideMenu);
            this.Hide();
        }

        public function SetContextMenu(_arg_1:Vector.<dContextItemVO>):void
        {
            var _local_2:dContextItemVO;
            this.mContextMenu.removeAllChildren();
            for each (_local_2 in _arg_1)
            {
                this.AddMenuItem(_local_2.key_string, _local_2.enabled, _local_2.callback, _local_2.tooltip_string, _local_2.labelParams);
            };
        }

        public function Init(_arg_1:MailWindowContextMenu):void
        {
            this.mContextMenu = _arg_1;
            this.mRendererPool = new Vector.<FriendsListMenuItemRenderer>();
            AddBaseElement(_arg_1);
            this.mContextMenu.addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
        }

        public function Move(_arg_1:int, _arg_2:int):void
        {
            this.mContextMenu.x = _arg_1;
            this.mContextMenu.y = _arg_2;
        }

        private function AddMenuItem(_arg_1:String, _arg_2:Boolean, _arg_3:Function, _arg_4:String="", _arg_5:Array=null):void
        {
            var _local_6:FriendsListMenuItemRenderer;
            if (this.mRendererPool.length > this.mContextMenu.numChildren)
            {
                _local_6 = this.mRendererPool[this.mContextMenu.numChildren];
            }
            else
            {
                _local_6 = new FriendsListMenuItemRenderer();
                this.mRendererPool.push(_local_6);
            };
            _local_6.data = new dContextItemVO(_arg_1, _arg_3, _arg_2, _arg_4, _arg_5);
            this.mContextMenu.addChild(_local_6);
            this.mContextMenu.y = (this.mContextMenu.y - (_local_6.height + 1));
        }

        public function UpdateMenuItemState(_arg_1:Dictionary, _arg_2:Boolean, _arg_3:int):void
        {
            var _local_11:Object;
            var _local_12:FriendsListMenuItemRenderer;
            var _local_13:dMailVO;
            var _local_14:dPlayerListItemVO;
            var _local_4:Array = this.mContextMenu.getChildren();
            var _local_5:int;
            while (_local_5 < (_local_4.length - 1))
            {
                _local_12 = (_local_4[_local_5] as FriendsListMenuItemRenderer);
                _local_12.resetStyle();
                _local_12.enabled = false;
                _local_5++;
            };
            var _local_6:Boolean;
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_9:int;
            var _local_10:Array = globalFlash.gui.mBlockList.GetBlockList();
            _local_4[0].enabled = true;
            for (_local_11 in _arg_1)
            {
                _local_6 = true;
                _local_9++;
                _local_13 = (_arg_1[_local_11] as dMailVO);
                if (((_arg_2) && (!(_local_13.isDeletable))))
                {
                    _local_4[0].enabled = false;
                };
                if (((!(_arg_2)) || ((_local_13.type == MAIL_TYPE.MAIL) && (_local_13.senderId > 1))))
                {
                    _local_4[1].enabled = true;
                };
                if (_arg_2)
                {
                    if (_local_13.read)
                    {
                        _local_4[3].enabled = true;
                    }
                    else
                    {
                        _local_4[2].enabled = true;
                    };
                };
                if ((((_local_13.senderId <= 1) || (_local_13.senderId == _arg_3)) || ((_local_13.senderName) && ((_local_13.senderName.toLowerCase().indexOf("mod_") > -1) || (_local_13.senderName.toLowerCase().indexOf("bb_") > -1)))))
                {
                    _local_8 = true;
                };
                for each (_local_14 in _local_10)
                {
                    if (_local_14.id == _local_13.senderId)
                    {
                        _local_7 = true;
                    };
                };
            };
            if (_local_9 > 1)
            {
                _local_4[1].enabled = false;
            };
            _local_4[4].enabled = (((((_arg_2) && (_local_6)) && (!(_local_8))) && (!(_local_7))) && (_local_13.type == MAIL_TYPE.MAIL));
        }


    }
}
