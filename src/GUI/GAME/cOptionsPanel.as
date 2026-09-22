package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.OptionsPanel;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.Event;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import Communication.VO.dPartnerSettingsVO;
    import mx.core.UIComponent;
    import nLib.gMisc;
    import mx.core.Application;
    import flash.display.StageDisplayState;
    import GameEvent.EventWindowDefinition;
    import flash.desktop.NativeApplication;
    import Tracks.TrackManager;

    public class cOptionsPanel extends cGuiBaseElement 
    {

        private var mGI:cGameInterface;
        protected var mPanel:OptionsPanel;
        private var mCollapsed:Boolean;


        private function OpenSupport(_arg_1:Event):void
        {
            navigateToURL(new URLRequest((global.baseUri + defines.SUPPORT_URL)), "_blank");
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("Support");
            global.getApplication().inputNotifier.notifyClick("Support");
        }

        private function OpenHelp(_arg_1:Event):void
        {
            globalFlash.gui.mHelpOverview.Show();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnToggleEffects.addEventListener(MouseEvent.CLICK, this.ToggleEffects);
            this.mPanel.btnToggleLoops.addEventListener(MouseEvent.CLICK, this.ToggleLoops);
            this.mPanel.btnCamera.addEventListener(MouseEvent.CLICK, this.ToggleCameraPanel);
            this.mPanel.btnFullScreen.addEventListener(MouseEvent.CLICK, this.ToggleFullscreen);
            this.mPanel.btnHelp.addEventListener(MouseEvent.CLICK, this.OpenHelp);
            this.mPanel.btnEventWindow.addEventListener(MouseEvent.CLICK, this.OpenEventWindow);
            this.mPanel.btnSupport.addEventListener(MouseEvent.CLICK, this.OpenSupport);
            this.mPanel.btnForum.addEventListener(MouseEvent.CLICK, this.OpenForum);
            this.mPanel.btnLogout.addEventListener(MouseEvent.CLICK, this.Logout);
            this.mPanel.btnPlayerOptions.addEventListener(MouseEvent.CLICK, this.OpenOptions);
            this.mPanel.btnToggleEffects.selected = cSettingsManager.getInstance().sfxMuted;
            this.mPanel.btnToggleLoops.selected = cSettingsManager.getInstance().loopsMuted;
            this.mPanel.btnExpandCollapse.addEventListener(MouseEvent.CLICK, this.ToggleSize);
            this.ToggleEventWindowButton();
            if (global.partner != "")
            {
                if ((global.partnerSettings[global.partner] as dPartnerSettingsVO).hideFullScreen)
                {
                    this.mPanel.btnFullScreen.visible = false;
                    this.mPanel.btnFullScreen.includeInLayout = false;
                };
                if ((global.partnerSettings[global.partner] as dPartnerSettingsVO).hideLogout)
                {
                    this.mPanel.btnLogout.visible = false;
                    this.mPanel.btnLogout.includeInLayout = false;
                };
            };
        }

        private function ToggleCameraPanel(_arg_1:MouseEvent):void
        {
            if (globalFlash.gui.mCameraControlPanel.IsVisible())
            {
                globalFlash.gui.mCameraControlPanel.Hide();
            }
            else
            {
                globalFlash.gui.mCameraControlPanel.Show();
            };
        }

        private function OpenOptions(_arg_1:MouseEvent):void
        {
            if (globalFlash.gui.mPlayerOptionsPanel.IsVisible())
            {
                globalFlash.gui.mPlayerOptionsPanel.Hide();
            }
            else
            {
                globalFlash.gui.mPlayerOptionsPanel.Show();
            };
        }

        private function ToggleSize(_arg_1:MouseEvent):void
        {
            if (this.mCollapsed)
            {
                this.ToggleButtons(true);
                this.mPanel.expand.play();
                global.ui.mQuestClientCallbacks.InitiateWindowOpen((((this.mPanel.parent as UIComponent).id + ".") + this.mPanel.id));
            }
            else
            {
                this.ToggleButtons(false);
                this.mPanel.collapse.play();
            };
            this.mCollapsed = (!(this.mCollapsed));
        }

        private function ToggleFullscreen(_arg_1:MouseEvent):void
        {
            if (gMisc.isEnabledFullScreenInteractive())
            {
                if (Application.application.stage.displayState == "fullScreenInteractive")
                {
                    this.mPanel.stage.displayState = StageDisplayState.NORMAL;
                }
                else
                {
                    this.mPanel.stage.displayState = "fullScreenInteractive";
                };
            }
            else
            {
                gMisc.CustomAlertFPUpgrade();
            };
        }

        private function OpenForum(_arg_1:Event):void
        {
            navigateToURL(new URLRequest((global.baseUri + defines.FORUM_URL)), "_blank");
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("Forum");
            global.getApplication().inputNotifier.notifyClick("Forum");
        }

        public function SetEventWindowButton(_arg_1:Boolean, _arg_2:String):void
        {
            this.mPanel.btnEventWindow.enabled = (((_arg_1) && ((!(EventWindowDefinition.GetEventWindowDefinition(_arg_2) == null)) || (this.mPanel.btnEventWindow.enabled))) && (!(this.mGI.mPacketLost)));
        }

        private function ZoomOut(_arg_1:Event):void
        {
            this.mGI.mZoom.modifyScaleIndex(1);
        }

        private function OpenEventWindow(_arg_1:Event):void
        {
            globalFlash.gui.mEventWindow.Show();
        }

        public function SetLoopsMutedButtonState(_arg_1:Boolean):void
        {
            this.mPanel.btnToggleLoops.selected = _arg_1;
        }

        public function ToggleEventWindowButton():void
        {
            this.mPanel.btnEventWindow.enabled = ((!(EventWindowDefinition.GetFirstValidWindowDefinition() == null)) && (!(this.mGI.mPacketLost)));
        }

        public function SetEffectsMutedButtonState(_arg_1:Boolean):void
        {
            this.mPanel.btnToggleEffects.selected = _arg_1;
        }

        private function ToggleButtons(_arg_1:Boolean):void
        {
            this.mPanel.btnPlayerOptions.enabled = (this.mPanel.btnToggleLoops.enabled = (this.mPanel.btnToggleEffects.enabled = (this.mPanel.btnCamera.enabled = (this.mPanel.btnHelp.enabled = (this.mPanel.btnEventWindow.enabled = (this.mPanel.btnSupport.enabled = (this.mPanel.btnForum.enabled = _arg_1)))))));
            this.mPanel.btnPlayerOptions.mouseEnabled = (this.mPanel.btnToggleLoops.mouseEnabled = (this.mPanel.btnToggleEffects.mouseEnabled = (this.mPanel.btnCamera.mouseEnabled = (this.mPanel.btnHelp.mouseEnabled = (this.mPanel.btnEventWindow.mouseEnabled = (this.mPanel.btnSupport.mouseEnabled = (this.mPanel.btnForum.enabled = _arg_1)))))));
            this.ToggleEventWindowButton();
        }

        public function Init(_arg_1:OptionsPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mCollapsed = true;
            this.ToggleButtons(false);
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function Logout(_arg_1:Event):void
        {
            NativeApplication.nativeApplication.exit();
        }

        private function ToggleEffects(_arg_1:Event):void
        {
            TrackManager.getInstance().trackUI(this.mGI.mCurrentPlayer.GetPlayerId(), "Sound Effect Option", ((cSettingsManager.getInstance().sfxMuted) ? "on" : "muted"), 0, false);
            cSettingsManager.getInstance().sfxMuted = (!(cSettingsManager.getInstance().sfxMuted));
            cSettingsManager.getInstance().saveToServer();
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("ToggleEffects");
            global.getApplication().inputNotifier.notifyClick("ToggleEffects");
        }

        private function ZoomIn(_arg_1:Event):void
        {
            this.mGI.mZoom.modifyScaleIndex(-1);
        }

        private function ToggleLoops(_arg_1:Event):void
        {
            TrackManager.getInstance().trackUI(this.mGI.mCurrentPlayer.GetPlayerId(), "Sound Option", ((cSettingsManager.getInstance().loopsMuted) ? "on" : "muted"), 0, false);
            cSettingsManager.getInstance().loopsMuted = (!(cSettingsManager.getInstance().loopsMuted));
            cSettingsManager.getInstance().saveToServer();
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("ToggleLoops");
            global.getApplication().inputNotifier.notifyClick("ToggleLoops");
        }


    }
}
