package GUI.GAME
{
    import flash.utils.Dictionary;
    import GUI.Components.LoadingMailPanel;
    import Communication.VO.Mail.dMailVO;
    import flash.events.MouseEvent;

    public class cLoadingMailPanel extends cBasicPanel 
    {

        private var mReplyToAll:Boolean;
        private var mMailsToLoad:Dictionary;
        protected var mPanel:LoadingMailPanel;


        override public function Hide():void
        {
            globalFlash.gui.mMailWindow.getMPanel().removeChild(this.mPanel);
            this.mPanel.visible = false;
            this.mPanel.pulsate.stop();
        }

        override public function Show():void
        {
            globalFlash.gui.mMailWindow.getMPanel().addChild(this.mPanel);
            this.mPanel.visible = true;
            this.mPanel.pulsate.play();
        }

        public function notifyMailLoaded(_arg_1:dMailVO):void
        {
            var _local_3:Object;
            delete this.mMailsToLoad[_arg_1.id];
            var _local_2:Boolean = true;
            for (_local_3 in this.mMailsToLoad)
            {
                _local_2 = false;
                break;
            };
            if (_local_2)
            {
                this.Hide();
                globalFlash.gui.mMailWindow.notifyLoadMailBodiesFinished(this.mReplyToAll);
            };
        }

        public function setLoadingMessage(_arg_1:String):void
        {
            this.mPanel.loadingLabel.text = _arg_1;
        }

        private function cancelLoading(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        public function setMailsToLoad(_arg_1:Dictionary, _arg_2:Boolean):void
        {
            this.mMailsToLoad = _arg_1;
            this.mReplyToAll = _arg_2;
        }

        public function init(_arg_1:LoadingMailPanel):void
        {
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.cancelLoading);
        }


    }
}
