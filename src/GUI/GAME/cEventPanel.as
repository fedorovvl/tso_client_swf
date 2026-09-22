package GUI.GAME
{
    import flash.utils.Timer;
    import Interface.cGameInterface;
    import GUI.Components.EventPanel;
    import GameEvent.EventWindowDefinition;
    import flash.events.Event;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;

    public class cEventPanel extends cBasicPanel 
    {

        private var ladderLoadCheck:Timer;
        private var gi:cGameInterface;
        protected var panel:EventPanel;
        private var mEventWindowDefinition:EventWindowDefinition;


        private function ladderLoadedHandler(_arg_1:Event):void
        {
            this.panel.ladderLoadable = true;
            this.panel.ladderImage.removeEventListener(Event.COMPLETE, this.ladderLoadedHandler);
        }

        override public function Hide():void
        {
            super.Hide();
        }

        override public function Show():void
        {
            this.mEventWindowDefinition = EventWindowDefinition.GetFirstValidWindowDefinition();
            if (this.mEventWindowDefinition)
            {
                this.panel.eventImage.source = gAssetManager.GetEventWindowImageUrl(this.mEventWindowDefinition.eventWindowImage_string);
                this.panel.eventDescription.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.mEventWindowDefinition.eventWindowText_string);
                this.panel.ladderEnabled = this.mEventWindowDefinition.includesRanking;
                if (this.panel.ladderEnabled)
                {
                    this.panel.ladderLoadable = false;
                    this.panel.ladderImage.addEventListener(Event.COMPLETE, this.ladderLoadedHandler);
                };
                this.panel.ladderImage.source = ((global.eventLadderURL_string + "?rand=") + int((Math.random() * 1000000)));
                super.Show();
            };
        }

        public function Init(_arg_1:EventPanel):void
        {
            this.gi = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.panel = _arg_1;
            this.panel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.panel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.panel.btnCloseWindow.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.panel.btnClose.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.panel.btnEventLadder.addEventListener(MouseEvent.CLICK, this.showLadder);
            this.panel.eventLadderPanelClose.addEventListener(MouseEvent.CLICK, this.hideLadder);
        }

        private function closePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function hideLadder(_arg_1:Event):void
        {
            globalFlash.gui.windowController.closeModal();
            this.panel.eventLadderPanel.visible = false;
        }

        private function showLadder(_arg_1:Event):void
        {
            this.panel.ladderImage.source = ((global.eventLadderURL_string + "?rand=") + int((Math.random() * 1000000)));
            globalFlash.gui.windowController.showModal();
            this.panel.eventLadderPanel.visible = true;
            this.gi.mQuestClientCallbacks.InitiateWindowOpen((this.panel.id + ".eventLadderPanel"));
        }


    }
}
