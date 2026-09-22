package GUI.GAME
{
    import GUI.Components.LoadingZonePanel;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cLoadingZonePanel extends cBasicPanel 
    {

        protected var mPanel:LoadingZonePanel;


        override public function Hide():void
        {
            super.Hide();
            this.mPanel.btnCancel.visible = false;
            this.mPanel.pulsate.stop();
        }

        public function SetLoadingMessage(_arg_1:String):void
        {
            this.mPanel.loadingLabel.text = _arg_1;
        }

        private function cancelLoadingZone(_arg_1:MouseEvent):void
        {
            global.ui.mClientMessages.cancelLoadingZone();
            this.Hide();
        }

        public function Init(_arg_1:LoadingZonePanel):void
        {
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.cancelLoadingZone);
        }

        public function SetLoadingMessageFromBB(_arg_1:String, _arg_2:Boolean):void
        {
            this.mPanel.loadingLabel.text = _arg_1;
            this.mPanel.btnCancel.visible = _arg_2;
        }

        override public function Show():void
        {
            super.Show();
            this.mPanel.loadingLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ((global.useBigBrother) ? "LoginQueueInit" : "LoadingZone"));
            globalFlash.gui.windowController.setTop(this.mPanel, true);
            this.mPanel.btnCancel.visible = false;
            this.mPanel.pulsate.play();
        }


    }
}
