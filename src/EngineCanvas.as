package 
{
    import mx.containers.Canvas;
    import mx.managers.LayoutManager;
    import flash.geom.Point;
    import flash.events.FocusEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.IEventDispatcher;
    import nLib.gMisc;
    import Interface.gInitStaticForAllZones;
    import nLib.cLog;
    import Interface.cGameInterface;
    import com.bluebyte.tso.service.ServiceManager;
    import flash.utils.getTimer;
    import flash.external.ExternalInterface;
    import ServerState.cClientMessagesII;
    import com.bluebyte.tso.util.HotkeyManager;
    import GUI.cGuiBaseElement;
    import mx.core.UIComponent;
    import mx.core.mx_internal; 

    use namespace mx_internal;

    public class EngineCanvas extends Canvas 
    {

        private var engineReady:Boolean = false;
        private var layoutUpdateTries:int = 0;
        public var mApplicationActive:Boolean = true;
        public var mCanvasFocused:Boolean = true;
        private var gameInterfaceAvailable:Boolean = false;
        private var layoutManager:LayoutManager;
        private var lastValidSize:Point = new Point();
        public var mMouseMove:int = 0;
        private var lastEnterFrame:Number = 0;
        public var mMouseOverCanvas:Boolean = false;
        private var gameRoot:SWMMO;
        public var mIgnoreNextClick:Boolean = false;


        private function FocusOutHandler(_arg_1:FocusEvent):void
        {
            if (!this.gameInterfaceAvailable)
            {
                return;
            };
            global.ui.FocusOutHandler(_arg_1);
        }

        private function deactivateHandler(_arg_1:Event):void
        {
            this.mApplicationActive = false;
            if (this.gameInterfaceAvailable)
            {
                global.ui.mComputeAndInputActive = false;
            };
        }

        private function click(_arg_1:MouseEvent):void
        {
            if (!this.gameInterfaceAvailable)
            {
                return;
            };
            if (this.mIgnoreNextClick)
            {
                this.mIgnoreNextClick = false;
                return;
            };
            if (this.IsMouseOverCanvas(_arg_1))
            {
                global.ui.MouseClick(_arg_1);
            };
        }

        public function init():void
        {
            var _local_1:Boolean = true;
            this.gameRoot = global.getApplication();
            this.layoutManager = LayoutManager.getInstance();
            if ((((_local_1) && (definesMaster.MASTER_VERSION == true)) && (this.gameRoot.loaderInfo.hasOwnProperty("uncaughtErrorEvents"))))
            {
                IEventDispatcher(this.gameRoot.loaderInfo["uncaughtErrorEvents"]).addEventListener("uncaughtError", gMisc.uncaughtErrorHandler);
            };
            this.registerHandlers();
            this.engineReady = true;
        }

        public function bootup():void
        {
            gMisc.InitTimeSinceStartup();
            if (global.gameState != "MainMenu")
            {
                global.gameSettingsFilename = defines.FILENAME_GAME_SETTINGS;
            };
            global.baseUri = gInitStaticForAllZones.getStringArgument("baseUri");
            var _local_1:String = global.baseUri.replace(/https?:\/\//, "");
            var _local_2:Array = _local_1.split("/");
            global.domain = _local_2[0];
            global.localizedDomain = ((_local_2[0] + "/") + _local_2[1]);
            cLog.statusText(("global base URL set to:" + global.domain));
            this.gameRoot.inputNotifier.init();
            var _local_3:cGameInterface = new cGameInterface();
            global.ui = _local_3;
            global.ui_bindable = _local_3;
            this.gameRoot.mGameInterface = _local_3;
            this.gameRoot.mMemoryMonitor.Init(_local_3);
            this.gameInterfaceAvailable = true;
            global.services = ServiceManager.getInstance();
            _local_3.mInitStartTime = getTimer();
            if (ExternalInterface.available)
            {
                ExternalInterface.call("logStartUpTime");
                _local_3.mClientMessages.loadUserCookies();
            }
            else
            {
                _local_3.mClientMessages.fetchFromArguments();
            };
            cSettingsManager.getInstance();
            _local_3.Init(cClientMessagesII.mAuthUser);
            if (defines.CLIENT_ZONEID != 0)
            {
                _local_3.mCurrentViewedZoneID = defines.CLIENT_ZONEID;
            };
            globalFlash.hotkeyManager = HotkeyManager.getInstance();
            globalFlash.hotkeyManager.Init(_local_3, stage, this.gameRoot.blueFireComponent);
        }

        public function setCanvasFocused(_arg_1:Boolean):void
        {
            this.mCanvasFocused = _arg_1;
        }

        private function activateHandler(_arg_1:Event):void
        {
            if (!this.mApplicationActive)
            {
                this.mIgnoreNextClick = true;
                this.mApplicationActive = true;
                if (this.gameInterfaceAvailable)
                {
                    cGuiBaseElement.SetEnableStateForAllGuiElements(true);
                    global.ui.mComputeAndInputActive = true;
                };
            };
        }

        public function update():void
        {
            var _local_1:Number;
            if (!this.engineReady)
            {
                return;
            };
            this.layoutUpdateTries = ((this.layoutManager.isInvalid()) ? (this.layoutUpdateTries + 1) : 0);
            if (this.layoutUpdateTries > 30)
            {
                this.layoutUpdateTries = 0;
            };
            if (this.layoutUpdateTries == 0)
            {
                gMisc.UpdateTimeSinceStartup();
                _local_1 = (gMisc.GetTimeSinceStartup() - this.lastEnterFrame);
                if (_local_1 < (1000 / globalFlash.FPS))
                {
                    return;
                };
                this.lastEnterFrame = gMisc.GetTimeSinceStartup();
                if (this.gameInterfaceAvailable)
                {
                    global.ui.Compute();
                    global.ui.Render();
                    global.ui.channels.TICK.render();
                };
            };
        }

        private function GetLastMouseOverCanvas():Boolean
        {
            return (this.mCanvasFocused);
        }

        private function mouseUp(_arg_1:MouseEvent):void
        {
            if (!this.gameInterfaceAvailable)
            {
                return;
            };
            global.ui.MouseUp(_arg_1);
        }

        override mx_internal function createContentPane():void
        {
            super.createContentPane();
            if (contentPane)
            {
                contentPane.mouseEnabled = false;
            };
        }

        public function SetApplicationWidthandHeight():void
        {
            global.screenWidth = this.gameRoot.width;
            global.screenHeight = this.gameRoot.height;
            global.screenWidthHalf = (global.screenWidth / 2);
            global.screenHeightHalf = (global.screenHeight / 2);
            this.width = global.screenWidth;
            this.height = global.screenHeight;
        }

        private function IsMouseOverCanvas(_arg_1:Event):Boolean
        {
            if (!this.gameInterfaceAvailable)
            {
                return (false);
            };
            if (_arg_1.target != this)
            {
                this.mCanvasFocused = false;
            }
            else
            {
                this.mCanvasFocused = true;
            };
            return (this.mCanvasFocused);
        }

        private function mouseWheel(_arg_1:MouseEvent):void
        {
            if (!this.gameInterfaceAvailable)
            {
                return;
            };
            if (this.IsMouseOverCanvas(_arg_1))
            {
                global.ui.MouseWheel(_arg_1);
            };
        }

        private function mouseOut(_arg_1:MouseEvent):void
        {
            if (!this.gameInterfaceAvailable)
            {
                return;
            };
            global.ui.MouseOut(_arg_1);
        }

        private function mouseMove(_arg_1:MouseEvent):void
        {
            if (!this.gameInterfaceAvailable)
            {
                return;
            };
            this.mMouseMove++;
            if (this.IsMouseOverCanvas(_arg_1))
            {
                this.mMouseOverCanvas = true;
                if (global.ui.mCurrentCursor)
                {
                    global.ui.mCurrentCursor.SetCursorVisible(true);
                };
                global.ui.MouseMove(_arg_1);
            }
            else
            {
                this.mMouseOverCanvas = false;
                if (global.ui.mCurrentCursor)
                {
                    global.ui.mCurrentCursor.SetCursorVisible(false);
                };
            };
        }

        private function registerHandlers():void
        {
            stage.addEventListener(Event.ACTIVATE, this.activateHandler, false, 0, true);
            stage.addEventListener(Event.DEACTIVATE, this.deactivateHandler, false, 0, true);
            stage.addEventListener(Event.RESIZE, this.resizeHandler, false, 0, true);
            stage.addEventListener(FocusEvent.FOCUS_OUT, this.FocusOutHandler, false, 0, true);
            this.resizeHandler(null);
            systemManager.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheel, false, 0, true);
            this.gameRoot.addEventListener(MouseEvent.CLICK, this.click, false, 0, true);
            this.gameRoot.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown, false, 0, true);
            this.gameRoot.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp, false, 0, true);
            this.gameRoot.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove, false, 0, true);
            this.gameRoot.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut, false, 0, true);
        }

        private function resizeHandler(_arg_1:Event):void
        {
            if (((stage.stageWidth == 0) || (stage.stageHeight == 0)))
            {
                this.gameRoot.width = this.lastValidSize.x;
                this.gameRoot.height = this.lastValidSize.y;
                return;
            };
            this.lastValidSize.x = this.gameRoot.parent.width;
            this.lastValidSize.y = this.gameRoot.parent.height;
            this.gameRoot.width = this.lastValidSize.x;
            this.gameRoot.height = this.lastValidSize.y;
            this.SetApplicationWidthandHeight();
            if (!this.gameInterfaceAvailable)
            {
                return;
            };
            global.ui.ApplicationResized();
        }

        private function mouseDown(_arg_1:MouseEvent):void
        {
            if (!this.gameInterfaceAvailable)
            {
                return;
            };
            if ((_arg_1.target is UIComponent))
            {
                if ((_arg_1.target.owner is UIComponent))
                {
                    if ((_arg_1.target.owner as UIComponent).id != "messageInput")
                    {
                        if (((!(this.gameRoot.GAMESTATE_ID_CHAT_PANEL == null)) && (this.gameRoot.GAMESTATE_ID_CHAT_PANEL.messageInput)))
                        {
                            if (focusManager.getFocus() == this.gameRoot.GAMESTATE_ID_CHAT_PANEL.messageInput)
                            {
                                _arg_1.target.setFocus();
                            };
                        };
                    };
                };
            };
            if (this.IsMouseOverCanvas(_arg_1))
            {
                global.ui.MouseDown(_arg_1);
            };
        }


    }
}
