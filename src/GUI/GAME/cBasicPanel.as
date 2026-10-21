package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import com.bluebyte.tso.util.HotkeyManager;
    import Enums.COMMAND;
    import Sound.cSoundManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import mx.core.UIComponent;
    import GUI.Components.BasicPanel;
    import GUI.WindowGeometry;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import mx.events.ResizeEvent;

    public class cBasicPanel extends cGuiBaseElement 
    {

        public static var EVENT_SHOW:String = "ui-show";
        public static var EVENT_HIDE:String = "ui-hide";
        public static var EVENT_CLICK:String = "ui-click";
        private static var _mCurrentActivePanel:cBasicPanel = null;
        protected static var mCurrentActiveSecondaryPanel:cBasicPanel = null;

        protected var openSound:String = "MenuOpen";
        private var clickOffsetX:int;
        private var clickOffsetY:int;
        private var geometryEnabled:Boolean = false;
        private var geometryReady:Boolean = false;
        private var initialWidth:Number;
        private var initialHeight:Number;
        private var geometrySaveTimer:Timer;
        private var defaultGeometry:Object;


        public static function IsCurrentActivePanelVisible():Boolean
        {
            if (!_mCurrentActivePanel)
            {
                return (false);
            };
            return (_mCurrentActivePanel.IsVisible());
        }

        public static function get mCurrentActivePanel():cBasicPanel
        {
            return (_mCurrentActivePanel);
        }

        public static function HideCurrentActivePanel():void
        {
            if (_mCurrentActivePanel != null)
            {
                _mCurrentActivePanel.Hide();
            };
            _mCurrentActivePanel = null;
        }

        public static function set mCurrentActivePanel(_arg_1:cBasicPanel):void
        {
            _mCurrentActivePanel = _arg_1;
            if (_mCurrentActivePanel != null)
            {
                HotkeyManager.getInstance().setConfirmActions(null, _mCurrentActivePanel.Hide);
            }
            else
            {
                HotkeyManager.getInstance().clearConfirmActions();
            };
        }


        override public function Hide():void
        {
            if (!this.IsVisible())
            {
                return;
            };
            global.ui.inputNotifier.notifyPropertyObserver(EVENT_HIDE, mUiElement.id);
            this.HideWithoutQueue();
            if (((((mCurrentActiveSecondaryPanel) && (!(mCurrentActiveSecondaryPanel == this))) && (mCurrentActiveSecondaryPanel.IsVisible())) && (!(this.hasSameViewComponentSecondary(mCurrentActiveSecondaryPanel)))))
            {
                mCurrentActiveSecondaryPanel.Hide();
            };
            globalFlash.gui.ShowQuestWindowDelayed();
        }

        protected function hasSameViewComponentSecondary(_arg_1:cBasicPanel):Boolean
        {
            return (mUiElement == mCurrentActiveSecondaryPanel.mUiElement);
        }

        override public function Show():void
        {
            this.RestoreWindowGeometry();
            this.hideCurrent();
            this.hideCurrentSecondary();
            global.ui.channels.INPUT.notifyPropertyObserver(EVENT_SHOW, mUiElement.id);
            global.ui.channels.INPUT.notifyPropertyObserver("show", mUiElement.id);
            global.ui.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            globalFlash.gui.windowController.setTop(mUiElement);
            mCurrentActivePanel = this;
            if (this.openSound != "")
            {
                cSoundManager.getInstance().playEffect(this.openSound);
            };
            super.Show();
        }

        protected function HideWithoutQueue():void
        {
            this.SaveWindowGeometry();
            this.UnselectBuildingWhenHide();
            super.Hide();
            if (_mCurrentActivePanel == this)
            {
                globalFlash.gui.windowController.closeModal();
                mCurrentActivePanel = null;
            };
        }

        public function ShowSecondaryPanel():void
        {
            this.RestoreWindowGeometry();
            this.hideCurrentSecondary();
            mCurrentActiveSecondaryPanel = this;
            super.Show();
            globalFlash.gui.windowController.setTop(mUiElement);
            if (this.openSound != "")
            {
                cSoundManager.getInstance().playEffect(this.openSound);
            };
        }

        private function TrackMouseClick(_arg_1:MouseEvent):void
        {
            if (_mCurrentActivePanel == this)
            {
                global.ui.inputNotifier.notifyPropertyObserver(EVENT_CLICK, mUiElement.id);
            };
        }

        private function MouseUpHandler(_arg_1:Event):void
        {
            this.SaveWindowGeometry();
            global.getApplication().removeEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
            global.getApplication().stage.removeEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
            global.getApplication().removeEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
        }

        protected function EnableDragging():void
        {
            if (!geometryEnabled)
            {
                geometryEnabled = true;
                initialWidth = mUiElement.width;
                initialHeight = mUiElement.height;
                geometrySaveTimer = new Timer(300, 1);
                geometrySaveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, SaveWindowGeometry);
                mUiElement.addEventListener(ResizeEvent.RESIZE, WindowResized, false, 0, true);
                WindowGeometry.events.addEventListener(WindowGeometry.RESET, ResetWindowGeometry, false, 0, true);
            };
            mUiElement.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler, false, 0, true);
        }

        private function RestoreWindowGeometry():void
        {
            if (!geometryEnabled) return;
            geometryReady = false;
            if (defaultGeometry == null)
            {
                defaultGeometry = {x:mUiElement.x, y:mUiElement.y, styles:{}};
                for each (var style:String in ["left", "right", "top", "bottom", "horizontalCenter", "verticalCenter"])
                    defaultGeometry.styles[style] = mUiElement.getStyle(style);
            };
            WindowGeometry.restore(mUiElement, initialWidth, initialHeight);
            geometryReady = true;
        }

        private function ResetWindowGeometry(event:Event):void
        {
            if (defaultGeometry == null) return;
            geometryReady = false;
            geometrySaveTimer.reset();
            mUiElement.width = initialWidth;
            mUiElement.height = initialHeight;
            mUiElement.x = defaultGeometry.x;
            mUiElement.y = defaultGeometry.y;
            for (var style:String in defaultGeometry.styles)
            {
                var value:Object = defaultGeometry.styles[style];
                if (value === undefined) mUiElement.clearStyle(style);
                else mUiElement.setStyle(style, value);
            };
            mUiElement.validateNow();
            geometryReady = true;
        }

        private function WindowResized(event:Event):void
        {
            if (!geometryReady || !IsVisible()) return;
            geometrySaveTimer.reset();
            geometrySaveTimer.start();
        }

        private function SaveWindowGeometry(event:Event = null):void
        {
            if (!geometryEnabled || !geometryReady) return;
            geometrySaveTimer.reset();
            WindowGeometry.save(mUiElement);
        }

        protected function UnselectBuildingWhenHide():void
        {
            global.ui.UnselectBuilding();
        }

        private function MouseMoveHandler(_arg_1:MouseEvent):void
        {
            mUiElement.x = (Math.round(_arg_1.stageX) - this.clickOffsetX);
            mUiElement.y = (Math.round(_arg_1.stageY) - this.clickOffsetY);
            if (mUiElement.x < 0)
            {
                mUiElement.x = 0;
            };
            if (mUiElement.y < 0)
            {
                mUiElement.y = 0;
            };
            if (mUiElement.x > (global.getApplication().stage.stageWidth - mUiElement.width))
            {
                mUiElement.x = (global.getApplication().stage.stageWidth - mUiElement.width);
            };
            if (mUiElement.y > (global.getApplication().stage.stageHeight - mUiElement.height))
            {
                mUiElement.y = (global.getApplication().stage.stageHeight - mUiElement.height);
            };
        }

        public function hideCurrent():void
        {
            if (((((_mCurrentActivePanel) && (!(_mCurrentActivePanel == this))) && (_mCurrentActivePanel.IsVisible())) && (!(this.hasSameViewComponent(_mCurrentActivePanel)))))
            {
                _mCurrentActivePanel.Hide();
            };
            mCurrentActivePanel = null;
        }

        protected function hasSameViewComponent(_arg_1:cBasicPanel):Boolean
        {
            return (mUiElement == _mCurrentActivePanel.mUiElement);
        }

        override protected function AddBaseElement(_arg_1:UIComponent):void
        {
            super.AddBaseElement(_arg_1);
            mUiElement.addEventListener(MouseEvent.MOUSE_DOWN, this.TrackMouseClick);
        }

        private function MouseDownHandler(_arg_1:MouseEvent):void
        {
            if (((_arg_1.target.parent == BasicPanel(mUiElement).headline) || ((_arg_1.target.parent == mUiElement) && (_arg_1.localY < 25))))
            {
                this.clickOffsetX = (Math.round(_arg_1.stageX) - mUiElement.x);
                this.clickOffsetY = (Math.round(_arg_1.stageY) - mUiElement.y);
                global.getApplication().addEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
                global.getApplication().stage.addEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
                global.getApplication().addEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
            };
        }

        public function hideCurrentSecondary():void
        {
            if (((((mCurrentActiveSecondaryPanel) && (!(mCurrentActiveSecondaryPanel == this))) && (mCurrentActiveSecondaryPanel.IsVisible())) && (!(this.hasSameViewComponentSecondary(mCurrentActiveSecondaryPanel)))))
            {
                mCurrentActiveSecondaryPanel.HideWithoutQueue();
            };
            mCurrentActiveSecondaryPanel = null;
        }


    }
}
