package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.NewsWindow;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import Sound.cSoundManager;
    import GUI.ApplicationFacade;
    import GUI.GAME.avatarSelection.AvatarSelectionPanel;
    import flash.utils.getTimer;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import nLib.gMisc;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cNewsWindow extends cBasicPanel 
    {

        private const TIP_DURATION:int = 10000;

        private var mMessageDuration:int = 10000;
        private var mGI:cGameInterface;
        protected var mPanel:NewsWindow;
        private var mPreviousMessage:int = 0;
        private var mTipChanged:Number;
        private var mLoadingMessageChanged:Number;
        private var mPreviousTip:int = 0;


        private function SetLoadingMessage():void
        {
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnChangeLog.addEventListener(MouseEvent.CLICK, this.changeLogClickHandler);
        }

        public function SetData():void
        {
            this.SetRandomTip();
            this.SetLoadingMessage();
            this.mPanel.pulsate.play();
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        public function SetLoadingMessageFromBB(_arg_1:String):void
        {
            this.mPanel.loadingLabel.text = _arg_1;
        }

        override public function Show():void
        {
            this.SetData();
            if (global.tipOfTheDayCount > 1)
            {
                this.mPanel.addEventListener(Event.ENTER_FRAME, this.UpdateTip);
            };
            if (global.loadingMessageCount > 1)
            {
                this.mPanel.addEventListener(Event.ENTER_FRAME, this.UpdateLoadingMessage);
            };
            super.Show();
        }

        public function Enable():void
        {
            this.mPanel.btnOK.enabled = true;
            this.mPanel.loadingLabel.visible = false;
            this.mPanel.loadingLabel.includeInLayout = false;
            this.mPanel.pulsate.stop();
            this.mPanel.removeEventListener(Event.ENTER_FRAME, this.UpdateLoadingMessage);
            cSoundManager.getInstance().init();
            ApplicationFacade.getInstance().sendNotification(AvatarSelectionPanel.CHECK_SHOW, this.mGI);
        }

        override protected function HideWithoutQueue():void
        {
            this.mPanel.removeEventListener(Event.ENTER_FRAME, this.UpdateTip);
            globalFlash.gui.mAvatarMessageList.ActivateMessages();
            super.HideWithoutQueue();
        }

        public function Init(_arg_1:NewsWindow):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function UpdateTip(_arg_1:Event):void
        {
            if ((getTimer() - this.mTipChanged) > this.TIP_DURATION)
            {
                this.SetRandomTip();
            };
        }

        protected function changeLogClickHandler(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest(global.changeLogUrl), "_blank");
        }

        private function UpdateLoadingMessage(_arg_1:Event):void
        {
            if ((getTimer() - this.mLoadingMessageChanged) > this.mMessageDuration)
            {
                this.SetLoadingMessage();
            };
        }

        private function SetRandomTip():void
        {
            var _local_2:String;
            var _local_1:int = gMisc.GetRandomMinMaxInt(1, global.tipOfTheDayCount);
            while (_local_1 == this.mPreviousTip)
            {
                _local_1 = gMisc.GetRandomMinMaxInt(1, global.tipOfTheDayCount);
            };
            if (_local_1 < 10)
            {
                _local_2 = ("TipOfTheDay0" + _local_1);
            }
            else
            {
                _local_2 = ("TipOfTheDay" + _local_1);
            };
            this.mPanel.tipText = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mTipChanged = getTimer();
            this.mPreviousTip = _local_1;
        }


    }
}
