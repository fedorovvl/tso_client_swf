package GUI.GAME
{
    import mx.containers.Canvas;
    import flash.display.DisplayObject;
    import mx.collections.ArrayCollection;
    import flash.display.DisplayObjectContainer;
    import GUI.Components.MailWindow;
    import flash.events.MouseEvent;
    import flash.display.InteractiveObject;

    public final class WindowController 
    {

        private var modalLayer:Canvas;
        private var topWindow:DisplayObject;
        private var activeWindows:ArrayCollection = new ArrayCollection();

        public function WindowController(_arg_1:Canvas)
        {
            super();
            this.modalLayer = _arg_1;
        }

        public function setTop(_arg_1:DisplayObject, _arg_2:Boolean=false):void
        {
            var _local_3:DisplayObjectContainer;
            this.modalLayer.setStyle("bottom", 0);
            this.closeModal();
if (_arg_1.parent != null)
{
_local_3 = _arg_1.parent;
if (_arg_2)
{
this.modalLayer.visible = true;
_local_3.addChild(this.modalLayer);
};
this.topWindow = _arg_1;
if (((_arg_1 is MailWindow) && (cSettingsManager.getInstance().friendsListVisible)))
{
this.modalLayer.setStyle("bottom", globalFlash.gui.mFriendsList.getHeight());
};
try
{
_local_3.setChildIndex(_arg_1, (_local_3.numChildren - 1));
}
catch (e:Error)
{
};
};
        }

        protected function mouseDownHandler(_arg_1:MouseEvent):void
        {
            if (((!(this.modalLayer.visible)) && (!(this.topWindow == _arg_1.currentTarget))))
            {
                this.setTop(DisplayObject(_arg_1.currentTarget));
            };
        }

        public function closeActiveWindows():void
        {
            var _local_1:InteractiveObject;
            for each (_local_1 in this.activeWindows)
            {
                _local_1.visible = false;
            };
        }

        public function showModal():void
        {
            this.modalLayer.visible = true;
        }

        public function addWindow(_arg_1:InteractiveObject):void
        {
            _arg_1.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            this.activeWindows.addItem(_arg_1);
        }

        public function closeModal():void
        {
            this.modalLayer.visible = false;
        }


    }
}
