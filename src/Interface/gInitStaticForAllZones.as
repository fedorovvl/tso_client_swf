package Interface
{
    import nLib.cCustomDispatcher;
    import flash.net.URLVariables;
    import flash.desktop.NativeApplication;
    import nLib.cFilenameUtil;
    import flash.utils.Dictionary;
    import Communication.VO.dPartnerSettingsVO;
    import converted.bluebyte.tso.quests.logic.QuestManagerStatic;
    import flash.events.Event;

    public class gInitStaticForAllZones 
    {

        private static var mDispatcherInitStaticForAllZones:cCustomDispatcher = new cCustomDispatcher();
        private static var receiver:IGFXProgressReceiver = null;


        private static function getIntegerParameter(_arg_1:String, _arg_2:String, _arg_3:int):int
        {
            if (((!(_arg_1 == null)) && (global.getApplication().parameters.hasOwnProperty(_arg_1))))
            {
                return (global.getApplication().parameters[_arg_1] as int);
            };
            return (_arg_3);
        }

        public static function getStringArgument(_arg_1:String):String
        {
            if (global.commandLineArguments == null)
            {
                throw (new Error("Command Line Arguments not initialized!"));
            };
            if (!global.commandLineArguments.hasOwnProperty(_arg_1))
            {
                return (null);
            };
            return (global.commandLineArguments[_arg_1]);
        }

        public static function getIntegerArgument(_arg_1:String, _arg_2:int):int
        {
            var _local_3:String = getStringArgument(_arg_1);
            if (_local_3 == null)
            {
                return (_arg_2);
            };
            return (parseInt(_local_3, 10));
        }

        public static function setCallback(_arg_1:Function):void
        {
            if (mDispatcherInitStaticForAllZones.hasEventListener(cCustomDispatcher.mAction_string))
            {
                mDispatcherInitStaticForAllZones.removeEventListener(cCustomDispatcher.mAction_string, _arg_1);
            };
            mDispatcherInitStaticForAllZones.addEventListener(cCustomDispatcher.mAction_string, _arg_1);
        }

        public static function setPogressReceiver(_arg_1:IGFXProgressReceiver):void
        {
            receiver = _arg_1;
        }

        public static function getStringParameter(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            if (((((!(_arg_1 == null)) && (global.getApplication().parameters.hasOwnProperty(_arg_1))) && (global.getApplication().parameters[_arg_1])) && (!(global.getApplication().parameters[_arg_1] == null))))
            {
                return (global.getApplication().parameters[_arg_1]);
            };
            var _local_4:String = getStringArgument(_arg_1);
            return ((_local_4 != null) ? _local_4 : _arg_3);
        }

        public static function parseCommandLineArguments(_arg_1:Array):void
        {
            var _local_2:String;
            var _local_4:String;
            var _local_5:String;
            var _local_6:URLVariables;
            var _local_7:String;
            var _local_8:int;
            var _local_9:RegExp;
            if (global.commandLineArguments != null)
            {
                trace("Command Line Arguments already parsed.");
                return;
            };
            global.commandLineArguments = {};
            var _local_3:RegExp = /^tso[a-z0-9]*:\/\//i;
            if (((_arg_1.length == 1) && (_arg_1[0].search(_local_3) == 0)))
            {
                _local_5 = _arg_1[0].replace(_local_3, "");
                if (_local_5.charAt((_local_5.length - 1)) == "/")
                {
                    _local_5 = _local_5.substring(0, (_local_5.length - 1));
                };
                _local_6 = new URLVariables(_local_5);
                for (_local_2 in _local_6)
                {
                    global.commandLineArguments[_local_2] = _local_6[_local_2];
                };
            }
            else
            {
                for each (_local_7 in _arg_1)
                {
                    _local_8 = _local_7.indexOf("=");
                    if (_local_8 == -1)
                    {
                        trace(("Invalid command line argument found: " + _local_7));
                    }
                    else
                    {
                        global.commandLineArguments[_local_7.substr(0, _local_8)] = _local_7.substr((_local_8 + 1));
                    };
                };
            };
            _local_4 = getStringArgument("baseUri");
            if (((!(_local_4 == null)) && (_local_4.length > 0)))
            {
                _local_9 = /^https?:\/\/[a-z0-9.-]+[\/a-z]*$/i;
                if (_local_4.search(_local_9) == 0)
                {
                    return;
                };
            };
            trace("baseUri seems to be invalid, exiting...");
            NativeApplication.nativeApplication.exit(1);
        }

        public static function ShowLoadingScreen(_arg_1:int):void
        {
            if (receiver != null)
            {
                receiver.setLoadedCount(_arg_1);
            };
        }

        public static function getBooleanArgument(_arg_1:String, _arg_2:Boolean):Boolean
        {
            var _local_3:String = getStringArgument(_arg_1);
            if (_local_3 == null)
            {
                return (_arg_2);
            };
            return ((_local_3 == "true") || (_local_3 == "1"));
        }

        public static function Init(_arg_1:Function):void
        {
            global.gameState = "Game";
            global.useExternalServer = getBooleanParameter("e", "swmmo.use_external_server", defines.USE_EXTERNAL_SERVER);
            global.useBigBrother = getBooleanParameter("ubb", "swmmo.use_big_brother", defines.USE_BIG_BROTHER);
            global.bigBrotherURL = getStringParameter("bb", "swmmo.big_brother_url", defines.BIG_BROTHER_URL);
            global.staticFilesURL = getStringParameter("s", "swmmo.static_url", defines.STATIC_FILES_URL);
            defines.GFX_CACHE = getBooleanParameter("gfxcache", "swmmo.gfxcache", false);
            if (global.staticFilesURLList == null)
            {
                global.staticFilesURLList = getStringParameter("s", "swmmo.static_url", defines.STATIC_FILES_URL).split("|");
                cFilenameUtil.resetCDNs();
            };
            global.m_JSInitCall = getStringParameter("initJSCallFunction", "", "initJSCallFunction");
            if (!global.useBigBrother)
            {
                global.settingsEnvironment = getStringParameter("settingsEnvironment", "swmmo.settings_environment", "default");
                global.eventLoadingScreen = getStringParameter("eventLoadingScreen", "swmmo.event_loadingscreen", defines.DEFAULT_UNDEFINED);
            };
            global.userCountry = getStringParameter("country", "swmmo.country", defines.USER_COUNTRY).toLowerCase();
            global.realmLanguage = getStringParameter("realmLang", "swmmo.realm_language", defines.REALM_LANGUAGE).toLowerCase();
            global.lang = getStringParameter("lang", "empty", null);
            global.partner = getStringParameter("partner", "", "").toLowerCase();
            global.partnerSettings = new Dictionary();
            global.partnerSettings[defines.PARTNER_STEAM] = new dPartnerSettingsVO(true, true, true, true);
            global.partnerSettings[defines.PARTNER_KONGREGATE] = new dPartnerSettingsVO(false, false, false, true);
            global.partnerSettings[defines.PARTNER_STANDALONE] = new dPartnerSettingsVO(true, true, false, false);
            gCalculations.Init();
            QuestManagerStatic.Init();
            if (_arg_1 != null)
            {
                mDispatcherInitStaticForAllZones.addEventListener(cCustomDispatcher.mAction_string, _arg_1);
            };
        }

        private static function getBooleanParameter(_arg_1:String, _arg_2:String, _arg_3:Boolean):Boolean
        {
            if (((!(_arg_1 == null)) && (global.getApplication().parameters.hasOwnProperty(_arg_1))))
            {
                return ((global.getApplication().parameters[_arg_1] == "true") || (global.getApplication().parameters[_arg_1] == "1"));
            };
            return (getBooleanArgument(_arg_1, _arg_3));
        }

        public static function loadGfxResourceHandler(_arg_1:Event):void
        {
            gGfxResource.LoadAll(loadGfxResourceCompleteHandler, 0);
        }

        public static function ClearScreen():void
        {
            global.getApplication().isoengine.graphics.clear();
            global.getApplication().isoengine.graphics.beginFill(-1);
            global.getApplication().isoengine.graphics.endFill();
        }

        private static function loadGfxResourceCompleteHandler():void
        {
            mDispatcherInitStaticForAllZones.doAction();
            if (((global.gameState == "Editor") || (global.gameState == "MainMenu")))
            {
                gGfxResource.mActivateStreaming = true;
            };
        }


    }
}
