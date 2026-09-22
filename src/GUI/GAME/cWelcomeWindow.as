package GUI.GAME
{
    import GUI.Components.WelcomeWindow;
    import Interface.cGameInterface;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;

    public class cWelcomeWindow extends cBasicPanel 
    {

        private var mPanel:WelcomeWindow;
        private var mGI:cGameInterface;


        public function Init(_arg_1:WelcomeWindow):void
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
            this.mPanel.btnCloseWindow.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            Hide();
        }

        override public function Show():void
        {
        }


    }
}
