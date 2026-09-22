package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.PlayerOptionsPanel;
    import flash.utils.Timer;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.FlexEvent;
    import GUI.event.VolumeBarClickEvent;
    import GUI.Components.VolumeControl;
    import ServerState.ResponderSimple;
    import flash.desktop.NativeApplication;
    import mx.events.CloseEvent;

    public class cPlayerOptionsPanel extends cBasicInfoPanel 
    {

        private var workyardProductionPanel:WorkyardProductionPanel;
        private var mGI:cGameInterface;
        private var mPanel:PlayerOptionsPanel;
        private var timer:Timer;
        private var sm:cSettingsManager;
        private var clickOffsetX:int;
        private var clickOffsetY:int;


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

        public function setSfxMutedState(_arg_1:Boolean):void
        {
            this.mPanel.sfxMute.selected = _arg_1;
        }

        private function persistenceTimerCompleteHandler(_arg_1:TimerEvent):void
        {
            this.sm.saveToServer();
        }

        protected function closeButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        public function setUseHalfSizeGraphicsState(_arg_1:Boolean):void
        {
            this.mPanel.halfSizeImagesButton.selected = (!(_arg_1));
        }

        protected function sectorMarkersButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showSectorMarkers = (!(this.sm.showSectorMarkers));
            this.resetPersistenceTimer();
        }

        protected function generalTextButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showGeneralName = (!(this.sm.showGeneralName));
            this.resetPersistenceTimer();
        }

        protected function sfxPlusButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.sfxVolume = (this.sm.sfxVolume + 1);
            this.mPanel.sfxVolume.data = this.sm.sfxVolume;
            this.resetPersistenceTimer();
        }

        protected function halfSizeImagesButtonClickHandler(_arg_1:MouseEvent):void
        {
            CustomAlert.show("ConfirmUseHalfSizeGraphicsOption", "ConfirmUseHalfSizeGraphicsOption", (Alert.OK | Alert.CANCEL), null, this.halfSizeConfirmHandler, null, Alert.OK, true);
        }

        override public function Show():void
        {
            super.Show();
        }

        protected function musicMinusButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.musicVolume--;
            this.mPanel.musicVolume.data = this.sm.musicVolume;
            this.resetPersistenceTimer();
        }

        public function setBuffAnimationState(_arg_1:Boolean):void
        {
            this.mPanel.buffAnimationButton.selected = _arg_1;
        }

        public function setMusicMutedState(_arg_1:Boolean):void
        {
            this.mPanel.musicMute.selected = _arg_1;
        }

        public function setShowStoppedProductionState(_arg_1:Boolean):void
        {
            this.mPanel.showStoppedProductionButton.selected = (!(_arg_1));
        }

        public function refreshVolumeControls():void
        {
            this.mPanel.musicVolume.data = this.sm.musicVolume;
            this.mPanel.sfxVolume.data = this.sm.sfxVolume;
        }

        public function Init(_arg_1:PlayerOptionsPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.timer = new Timer(1000, 1);
            this.sm = cSettingsManager.getInstance();
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function MouseUpHandler(_arg_1:Event):void
        {
            global.getApplication().removeEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
            global.getApplication().stage.removeEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
            global.getApplication().removeEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
        }

        protected function showStoppedProductionClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showStoppedProduction = (!(this.sm.showStoppedProduction));
            this.resetPersistenceTimer();
        }

        protected function musicPlusButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.musicVolume = (this.sm.musicVolume + 1);
            this.mPanel.musicVolume.data = this.sm.musicVolume;
            this.resetPersistenceTimer();
        }

        protected function musicVolumeBarClickHandler(_arg_1:VolumeBarClickEvent):void
        {
            this.sm.musicVolume = _arg_1.val;
            this.mPanel.musicVolume.data = this.sm.musicVolume;
            this.resetPersistenceTimer();
        }

        protected function showFullWarehouseClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showFullWarehouse = (!(this.sm.showFullWarehouse));
            this.resetPersistenceTimer();
        }

        public function setShowMissingResourcesState(_arg_1:Boolean):void
        {
            this.mPanel.showMissingResourcesButton.selected = (!(_arg_1));
        }

        public function Refresh():void
        {
        }

        protected function showMissingResourcesClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showMissingResources = (!(this.sm.showMissingResources));
            this.resetPersistenceTimer();
        }

        protected function sfxMinusButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.sfxVolume--;
            this.mPanel.sfxVolume.data = this.sm.sfxVolume;
            this.resetPersistenceTimer();
        }

        public function setGeneralNameState(_arg_1:Boolean):void
        {
            this.mPanel.generalTextButton.selected = _arg_1;
        }

        public function setShowSmokeState(_arg_1:Boolean):void
        {
            this.mPanel.smokeButton.selected = (!(_arg_1));
        }

        protected function smokeButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showSmoke = (!(this.sm.showSmoke));
            this.resetPersistenceTimer();
        }

        protected function animalsButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showAnimals = (!(this.sm.showAnimals));
            this.resetPersistenceTimer();
        }

        protected function buffAnimationButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showBuffAnimations = (!(this.sm.showBuffAnimations));
            this.resetPersistenceTimer();
        }

        public function pvpTaskBuildingTasksButtonHandler(_arg_1:MouseEvent):void
        {
            this.sm.showPvpTaskBuildingTasks = (!(this.sm.showPvpTaskBuildingTasks));
            this.resetPersistenceTimer();
        }

        public function setShowMissingSettlerState(_arg_1:Boolean):void
        {
            this.mPanel.showMissingSettlerButton.selected = (!(_arg_1));
        }

        protected function sfxMuteButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.sfxMuted = (!(this.sm.sfxMuted));
            this.resetPersistenceTimer();
        }

        private function resetPersistenceTimer():void
        {
            this.timer.reset();
            this.timer.start();
        }

        protected function generalMarkerButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showGeneralMarkers = (!(this.sm.showGeneralMarkers));
            this.resetPersistenceTimer();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.halfSizeImagesButton.addEventListener(MouseEvent.CLICK, this.halfSizeImagesButtonClickHandler);
            this.mPanel.buffAnimationButton.addEventListener(MouseEvent.CLICK, this.buffAnimationButtonClickHandler);
            this.mPanel.sectorMarkersButton.addEventListener(MouseEvent.CLICK, this.sectorMarkersButtonClickHandler);
            this.mPanel.generalMarkerButton.addEventListener(MouseEvent.CLICK, this.generalMarkerButtonClickHandler);
            this.mPanel.generalTextButton.addEventListener(MouseEvent.CLICK, this.generalTextButtonClickHandler);
            this.mPanel.settlersButton.addEventListener(MouseEvent.CLICK, this.settlersButtonClickHandler);
            this.mPanel.animalsButton.addEventListener(MouseEvent.CLICK, this.animalsButtonClickHandler);
            this.mPanel.smokeButton.addEventListener(MouseEvent.CLICK, this.smokeButtonClickHandler);
            this.mPanel.musicMute.addEventListener(MouseEvent.CLICK, this.musicMuteButtonClickHandler);
            this.mPanel.musicMinus.addEventListener(MouseEvent.CLICK, this.musicMinusButtonClickHandler);
            this.mPanel.musicPlus.addEventListener(MouseEvent.CLICK, this.musicPlusButtonClickHandler);
            this.mPanel.sfxMute.addEventListener(MouseEvent.CLICK, this.sfxMuteButtonClickHandler);
            this.mPanel.sfxMinus.addEventListener(MouseEvent.CLICK, this.sfxMinusButtonClickHandler);
            this.mPanel.sfxPlus.addEventListener(MouseEvent.CLICK, this.sfxPlusButtonClickHandler);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.persistenceTimerCompleteHandler);
            this.mPanel.musicVolume.addEventListener(VolumeControl.VOLUME_BAR_CLICK, this.musicVolumeBarClickHandler);
            this.mPanel.sfxVolume.addEventListener(VolumeControl.VOLUME_BAR_CLICK, this.sfxVolumeBarClickHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.closeButtonClickHandler);
            this.mPanel.showMissingSettlerButton.addEventListener(MouseEvent.CLICK, this.showMissingSettlerClickHandler);
            this.mPanel.showMissingResourcesButton.addEventListener(MouseEvent.CLICK, this.showMissingResourcesClickHandler);
            this.mPanel.showFullWarehouseButton.addEventListener(MouseEvent.CLICK, this.showFullWarehouseClickHandler);
            this.mPanel.showStoppedProductionButton.addEventListener(MouseEvent.CLICK, this.showStoppedProductionClickHandler);
            this.mPanel.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler);
        }

        public function setShowFullWarehouseState(_arg_1:Boolean):void
        {
            this.mPanel.showFullWarehouseButton.selected = (!(_arg_1));
        }

        protected function sfxVolumeBarClickHandler(_arg_1:VolumeBarClickEvent):void
        {
            this.sm.sfxVolume = _arg_1.val;
            this.mPanel.sfxVolume.data = this.sm.sfxVolume;
            this.resetPersistenceTimer();
        }

        protected function halfSizeConfirmHandler(_event:CloseEvent):void
        {
            if (_event.detail == Alert.OK)
            {
                this.sm.showHalfSizeGraphics = (!(this.sm.showHalfSizeGraphics));
                this.sm.saveToServer(new ResponderSimple(function ():void
                {
                    NativeApplication.nativeApplication.exit(defines.EXIT_CODE_RESTART);
                }));
            };
        }

        protected function settlersButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showSettlers = (!(this.sm.showSettlers));
            this.resetPersistenceTimer();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        public function setShowSettlersState(_arg_1:Boolean):void
        {
            this.mPanel.settlersButton.selected = (!(_arg_1));
        }

        protected function showMissingSettlerClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.showMissingSettler = (!(this.sm.showMissingSettler));
            this.resetPersistenceTimer();
        }

        public function Update():void
        {
            this.mPanel.musicVolume.data = this.sm.musicVolume;
            this.mPanel.sfxVolume.data = this.sm.sfxVolume;
        }

        public function setSectorMarkerState(_arg_1:Boolean):void
        {
            this.mPanel.sectorMarkersButton.selected = (!(_arg_1));
        }

        public function setGeneralMarkerState(_arg_1:Boolean):void
        {
            this.mPanel.generalMarkerButton.selected = (!(_arg_1));
        }

        protected function musicMuteButtonClickHandler(_arg_1:MouseEvent):void
        {
            this.sm.loopsMuted = (!(this.sm.loopsMuted));
            this.resetPersistenceTimer();
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

        public function setShowAnimalsState(_arg_1:Boolean):void
        {
            this.mPanel.animalsButton.selected = (!(_arg_1));
        }


    }
}
