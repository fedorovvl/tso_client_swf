package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.CameraControlPanel;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import mx.events.FlexEvent;
    import mx.events.ResizeEvent;

    public class cCameraControlPanel extends cGuiBaseElement 
    {

        private var clickOffsetY:int;
        private var mGI:cGameInterface;
        protected var mPanel:CameraControlPanel;
        private var clickOffsetX:int;


        private function StopScrolling(_arg_1:MouseEvent):void
        {
            global.getApplication().removeEventListener(MouseEvent.MOUSE_UP, this.StopScrolling);
            this.mGI.ResetScrolling();
        }

        private function MouseDownHandler(_arg_1:MouseEvent):void
        {
            if (((_arg_1.target is this.mPanel.inheritingStyles.backgroundImage) && (_arg_1.localY < 18)))
            {
                this.clickOffsetX = _arg_1.localX;
                this.clickOffsetY = _arg_1.localY;
                global.getApplication().addEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
                global.getApplication().stage.addEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
                global.getApplication().addEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
            };
        }

        private function MouseUpHandler(_arg_1:Event):void
        {
            global.getApplication().removeEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
            global.getApplication().stage.removeEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
            global.getApplication().removeEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        public function Init(_arg_1:CameraControlPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnUp.addEventListener(MouseEvent.MOUSE_DOWN, this.StartScrolling);
            this.mPanel.btnLeft.addEventListener(MouseEvent.MOUSE_DOWN, this.StartScrolling);
            this.mPanel.btnRight.addEventListener(MouseEvent.MOUSE_DOWN, this.StartScrolling);
            this.mPanel.btnDown.addEventListener(MouseEvent.MOUSE_DOWN, this.StartScrolling);
            this.mPanel.btnZoomIn.addEventListener(MouseEvent.CLICK, this.ZoomIn);
            this.mPanel.btnZoomOut.addEventListener(MouseEvent.CLICK, this.ZoomOut);
            this.mPanel.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler);
            global.getApplication().addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
        }

        private function StartScrolling(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            var _local_3:String;
            switch (_arg_1.currentTarget)
            {
                case this.mPanel.btnUp:
                    _local_2 = defines.SCROLL_UP;
                    _local_3 = "ScrollUp";
                    break;
                case this.mPanel.btnLeft:
                    _local_2 = defines.SCROLL_LEFT;
                    _local_3 = "ScrollLeft";
                    break;
                case this.mPanel.btnRight:
                    _local_2 = defines.SCROLL_RIGHT;
                    _local_3 = "ScrollRight";
                    break;
                case this.mPanel.btnDown:
                    _local_2 = defines.SCROLL_DOWN;
                    _local_3 = "ScrollDown";
                    break;
            };
            global.getApplication().addEventListener(MouseEvent.MOUSE_UP, this.StopScrolling);
            this.mGI.StartScrolling(_local_2);
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen(_local_3);
            global.getApplication().inputNotifier.notifyClick(_local_3);
        }

        private function MouseMoveHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.x = (_arg_1.stageX - this.clickOffsetX);
            this.mPanel.y = (_arg_1.stageY - this.clickOffsetY);
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 0)
            {
                this.mPanel.y = 0;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > ((global.getApplication().stage.stageHeight - this.mPanel.height) + 18))
            {
                this.mPanel.y = ((global.getApplication().stage.stageHeight - this.mPanel.height) + 18);
            };
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 0)
            {
                this.mPanel.y = 0;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > ((global.getApplication().stage.stageHeight - this.mPanel.height) + 18))
            {
                this.mPanel.y = ((global.getApplication().stage.stageHeight - this.mPanel.height) + 18);
            };
        }

        private function ZoomIn(_arg_1:MouseEvent):void
        {
            this.mGI.mZoom.modifyScaleIndex(-1);
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("ZoomIn");
            global.getApplication().inputNotifier.notifyClick("ZoomIn");
        }

        private function ZoomOut(_arg_1:MouseEvent):void
        {
            this.mGI.mZoom.modifyScaleIndex(1);
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("ZoomOut");
            global.getApplication().inputNotifier.notifyClick("ZoomOut");
        }


    }
}
