package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import GUI.Components.MailWindowContextMenu;
    import __AS3__.vec.Vector;
    import GUI.Components.ItemRenderer.FriendsListMenuItemRenderer;
    import Communication.VO.dContextItemVO;
    import mx.events.ResizeEvent;
    import __AS3__.vec.*;

    public class cBlockListContextMenu extends cGuiBaseElement 
    {

        private var mContextMenu:MailWindowContextMenu;
        private var mRendererPool:Vector.<FriendsListMenuItemRenderer>;


        override public function Show():void
        {
            globalFlash.gui.mBlockList.GetMPanel().parent.addChild(this.mContextMenu);
            super.Show();
            this.ResizeHandler(null);
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


    }
}
