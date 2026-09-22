package GUI.Loca
{
    import flash.events.EventDispatcher;
    import mx.formatters.DateFormatter;
    import mx.formatters.NumberFormatter;
    import nLib.cXML;
    import flash.utils.Dictionary;
    import nLib.cLog;
    import nLib.gMisc;
    import Enums.LOCA_GROUP;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import GUI.LoadingScreen.LoadingScreenLoca;
    import mx.events.StyleEvent;
    import Utils.StringUtils;
    import mx.core.Application;

    public class cLocaManager extends EventDispatcher 
    {

        public static const UNDEFINED:String = "[undefined text] ";
        public static const DURATION_FORMAT_NORMAL:int = 0;
        public static const DURATION_FORMAT_SHORT:int = 1;
        public static const DURATION_FORMAT_SHORT_COMPLETE:int = 2;
        public static const DURATION_FORMAT_NUMERIC:int = 3;
        public static const DURATION_FORMAT_NUMERIC_SHORT:int = 4;
        public static const DURATION_FORMAT_LOCALE_TIME:int = 5;
        public static const DURATION_FORMAT_SHORTER:int = 6;
        private static var mInstance:cLocaManager;
        private static var formatter:DateFormatter = new DateFormatter();
        private static var numberFormatter:NumberFormatter = new NumberFormatter();
        private static var date:Date = new Date();
        public static var debugMode:Boolean = false;

        private var mLocaXML:cXML;
        private var mLoadedFilesCount:int = 0;
        private var mDefaultLanguage:String = "de-de";
        private var mFontName:String = "DefaultFontEmbedded";
        private var mSelectedLanguage:String;
        private var mInitialized:Boolean = false;
        private var mCompleteFunction:Function;

        private var _re1:RegExp = new RegExp("{([0-9])}", "g");
        private var regexCache:Dictionary = new Dictionary();
        private var mTexts:Dictionary = new Dictionary();
        public var NT:Array = new Array();

        {
            NT = new Array();
        }

        public function cLocaManager(_arg_1:cSingletonEnforcer)
        {
            super();
            if (_arg_1 == null)
            {
                throw (new Error("cLocaManager is a Singleton. Use GetInstance() to use this class."));
            };
        }

        public static function GetInstance():cLocaManager
        {
            if (mInstance == null)
            {
                mInstance = new cLocaManager(new cSingletonEnforcer());
            };
            return (mInstance);
        }


        [Bindable(event="languageChanged")]
        public function GetText(_arg_1:String, _arg_2:String, _arg_3:Array=null):String
        {
            var _local_5:String;
            if (!_arg_2)
            {
                cLog.error(("Text identifier must not be null " + ((definesMaster.MASTER_VERSION) ? "" : gMisc.GetCallingMethodName())));
                return ("[identifier null]");
            };
            if (!this.mTexts[_arg_1])
            {
                return ("[undefined group] - " + _arg_1);
            };
            var _local_4:String = this.mTexts[_arg_1][_arg_2.toLowerCase()];
            if (((_local_4) && (_local_4.length > 0)))
            {
                return (this.replaceVariables(_local_4, _arg_3));
            };
            for (_local_5 in this.mTexts[_arg_1])
            {
                if (_local_5.indexOf("*") != -1)
                {
                    if (_arg_2.toLowerCase().indexOf(_local_5.split("*")[0]) != -1)
                    {
                        return (this.replaceVariables(this.mTexts[_arg_1][_local_5], _arg_3));
                    };
                };
            };
            return (UNDEFINED);
        }

        public function getLabel(_arg_1:String, _arg_2:Array=null):String
        {
            _arg_1 = _arg_1.toLocaleLowerCase();
            if (this.mTexts[LOCA_GROUP.LABELS] && this.mTexts[LOCA_GROUP.LABELS][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.LABELS, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.RESOURCES] && this.mTexts[LOCA_GROUP.RESOURCES][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.RESOURCES, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.BUILDINGS] && this.mTexts[LOCA_GROUP.BUILDINGS][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.BUILDINGS, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.ADVENTURE_NAME] && this.mTexts[LOCA_GROUP.ADVENTURE_NAME][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.ADVENTURE_NAME, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.SPECIALISTS] && this.mTexts[LOCA_GROUP.SPECIALISTS][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.SPECIALISTS, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.SHOP_ITEMS] && this.mTexts[LOCA_GROUP.SHOP_ITEMS][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.SHOP_ITEMS, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.QUEST_LABELS] && this.mTexts[LOCA_GROUP.QUEST_LABELS][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.QUEST_LABELS, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.MESSAGE_LABELS] && this.mTexts[LOCA_GROUP.MESSAGE_LABELS][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.MESSAGE_LABELS, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.HELP_ITEM_LABEL] && this.mTexts[LOCA_GROUP.HELP_ITEM_LABEL][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.HELP_ITEM_LABEL, _arg_1, _arg_2));
            };
            if (this.mTexts[LOCA_GROUP.ALERT_TITLES] && this.mTexts[LOCA_GROUP.ALERT_TITLES][_arg_1])
            {
                return (this.GetText(LOCA_GROUP.ALERT_TITLES, _arg_1, _arg_2));
            };
            return (this.GetText(LOCA_GROUP.LABELS, _arg_1, _arg_2));
        }

        private function loadLanguageComplete(_arg_1:cXML):void
        {
            var _local_2:String;
            var _local_3:cXML;
            var _local_4:IEventDispatcher;
            var _local_5:cXML;
            if (this.mLoadedFilesCount < 1)
            {
                return;
            };
            this.mLoadedFilesCount = 0;
            for each (_local_3 in this.mLocaXML.MoveToSubNodeAndCreateChildrenArray("translations"))
            {
                _local_2 = _local_3.GetAttributeString_string("name");
                if (!this.mTexts.hasOwnProperty(_local_2))
                {
                    this.mTexts[_local_2] = new Dictionary();
                };
                for each (_local_5 in _local_3.CreateChildrenArray())
                {
                    this.setText(_local_2, _local_5.GetAttributeString_string("id"), _local_5.GetAttributeString_string("text"));
                };
            };
            dispatchEvent(new Event("languageChanged"));
            this.mInitialized = true;
            this.mLocaXML = null;
            _local_4 = new TSOStyleManager().loadStyleDeclarations(("loca/styles/" + LoadingScreenLoca.getStyleFilename(this.mSelectedLanguage)));
            _local_4.addEventListener(StyleEvent.COMPLETE, this.initFonts);
        }

        public function FormatNumber(_arg_1:Number):String
        {
            var _local_2:String = cLocaManager.GetInstance().GetText(LOCA_GROUP.FORMATS, "DecimalSeparator");
            var _local_3:String = cLocaManager.GetInstance().GetText(LOCA_GROUP.FORMATS, "ThousandsSeparator");
            numberFormatter.decimalSeparatorFrom = _local_2;
            numberFormatter.decimalSeparatorTo = _local_2;
            numberFormatter.thousandsSeparatorFrom = _local_3;
            numberFormatter.thousandsSeparatorTo = _local_3;
            var _local_4:String = numberFormatter.format(_arg_1);
            return (((!(_local_4 == null)) && (!(_local_4 == ""))) ? _local_4 : _arg_1.toString());
        }

        public function FormatDuration(_arg_1:Number, _arg_2:int=0):String
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:Date;
            var _local_3:Number = Math.round((_arg_1 / 1000));
            if (_arg_2 == DURATION_FORMAT_LOCALE_TIME)
            {
                _local_8 = new Date();
                _local_8.setTime((_local_8.getTime() + _arg_1));
                return ((_local_8.getHours() + ":") + ((_local_8.getMinutes() < 10) ? ("0" + _local_8.getMinutes()) : ("" + _local_8.getMinutes())));
            };
            if (_local_3 >= 86400)
            {
                _local_4 = int((_local_3 / 86400));
                _local_5 = int(((_local_3 % 86400) / 3600));
                _local_6 = int(((_local_3 % 3600) / 60));
                _local_7 = (_local_3 % 60);
                if (_arg_2 == DURATION_FORMAT_NORMAL)
                {
                    return ((((this.GetText(LOCA_GROUP.FORMATS, "Days", [_local_4.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "Hours", [_local_5.toString()])) + " ") + this.GetText(LOCA_GROUP.FORMATS, "Minutes", [_local_6.toString()]));
                };
                if (_arg_2 == DURATION_FORMAT_SHORT)
                {
                    return ((((this.GetText(LOCA_GROUP.FORMATS, "DaysShort", [_local_4.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "HoursShort", [_local_5.toString()])) + " ") + this.GetText(LOCA_GROUP.FORMATS, "MinutesShort", [_local_6.toString()]));
                };
                if (_arg_2 == DURATION_FORMAT_SHORTER)
                {
                    return ((this.GetText(LOCA_GROUP.FORMATS, "DaysShort", [_local_4.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "HoursShort", [_local_5.toString()]));
                };
                if (_arg_2 == DURATION_FORMAT_NUMERIC_SHORT)
                {
                    return ((((((_local_4 + ":") + ((_local_5 > 9) ? _local_5 : ("0" + _local_5))) + ":") + ((_local_6 > 9) ? _local_6 : ("0" + _local_6))) + ":") + ((_local_7 > 9) ? _local_7 : ("0" + _local_7)));
                };
                if (_arg_2 == DURATION_FORMAT_SHORT_COMPLETE)
                {
                    return ((((((this.GetText(LOCA_GROUP.FORMATS, "DaysShort", [_local_4.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "HoursShort", [_local_5.toString()])) + " ") + this.GetText(LOCA_GROUP.FORMATS, "MinutesShort", [_local_6.toString()])) + " ") + this.GetText(LOCA_GROUP.FORMATS, "SecondsShort", [_local_7.toString()]));
                };
            }
            else
            {
                if (_local_3 >= 3600)
                {
                    _local_4 = 0;
                    _local_5 = int((_local_3 / 3600));
                    _local_6 = int(((_local_3 % 3600) / 60));
                    _local_7 = (_local_3 % 60);
                    if (_arg_2 == DURATION_FORMAT_NORMAL)
                    {
                        return ((this.GetText(LOCA_GROUP.FORMATS, "Hours", [_local_5.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "Minutes", [_local_6.toString()]));
                    };
                    if (_arg_2 == DURATION_FORMAT_SHORT)
                    {
                        return ((this.GetText(LOCA_GROUP.FORMATS, "HoursShort", [_local_5.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "MinutesShort", [_local_6.toString()]));
                    };
                    if (_arg_2 == DURATION_FORMAT_NUMERIC_SHORT)
                    {
                        return ((((_local_5 + ":") + ((_local_6 > 9) ? _local_6 : ("0" + _local_6))) + ":") + ((_local_7 > 9) ? _local_7 : ("0" + _local_7)));
                    };
                    if (_arg_2 == DURATION_FORMAT_SHORT_COMPLETE)
                    {
                        return ((((this.GetText(LOCA_GROUP.FORMATS, "HoursShort", [_local_5.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "MinutesShort", [_local_6.toString()])) + " ") + this.GetText(LOCA_GROUP.FORMATS, "SecondsShort", [_local_7.toString()]));
                    };
                }
                else
                {
                    if (_local_3 >= 60)
                    {
                        _local_4 = 0;
                        _local_5 = 0;
                        _local_6 = int((_local_3 / 60));
                        _local_7 = (_local_3 % 60);
                        if (_arg_2 == DURATION_FORMAT_NORMAL)
                        {
                            return ((this.GetText(LOCA_GROUP.FORMATS, "Minutes", [_local_6.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "Seconds", [_local_7.toString()]));
                        };
                        if (((_arg_2 == DURATION_FORMAT_SHORT) || (_arg_2 == DURATION_FORMAT_SHORT_COMPLETE)))
                        {
                            return ((this.GetText(LOCA_GROUP.FORMATS, "MinutesShort", [_local_6.toString()]) + " ") + this.GetText(LOCA_GROUP.FORMATS, "SecondsShort", [_local_7.toString()]));
                        };
                        if (_arg_2 == DURATION_FORMAT_NUMERIC_SHORT)
                        {
                            return ((_local_6 + ":") + ((_local_7 > 9) ? _local_7 : ("0" + _local_7)));
                        };
                    }
                    else
                    {
                        _local_4 = 0;
                        _local_5 = 0;
                        _local_6 = 0;
                        _local_7 = (_local_3 % 60);
                        if (_arg_2 == DURATION_FORMAT_NORMAL)
                        {
                            return (this.GetText(LOCA_GROUP.FORMATS, "Seconds", [_local_7.toString()]));
                        };
                        if (((_arg_2 == DURATION_FORMAT_SHORT) || (_arg_2 == DURATION_FORMAT_SHORT_COMPLETE)))
                        {
                            return (this.GetText(LOCA_GROUP.FORMATS, "SecondsShort", [_local_7.toString()]));
                        };
                        if (_arg_2 == DURATION_FORMAT_NUMERIC_SHORT)
                        {
                            return ("00:" + ((_local_7 > 9) ? _local_7 : ("0" + _local_7)));
                        };
                    };
                };
            };
            return ((((_local_4 + ":") + ((_local_5 > 9) ? _local_5 : ("0" + _local_5))) + ":") + ((_local_6 > 9) ? _local_6 : ("0" + _local_6)));
        }

        public function LoadLanguage(_arg_1:String):void
        {
            cLog.statusText(("Loading language: " + _arg_1));
            this.mInitialized = false;
            this.mSelectedLanguage = _arg_1;
            this.mLocaXML = new cXML();
            this.mLocaXML.LoadFile((("loca/" + _arg_1) + ".xml"), this.languageLoaded, definesMaster.LOAD_ENC);
        }

        public function FormatAmount(_arg_1:Number):String
        {
            if (_arg_1 > 999)
            {
                return (Math.floor((_arg_1 / 1000)) + "k");
            };
            return (_arg_1.toString());
        }

        public function getSelectedLanguage():String
        {
            return (this.mSelectedLanguage);
        }

        public function SetDefaultLanguage(_arg_1:String):void
        {
            this.mDefaultLanguage = _arg_1;
        }

        public function GetTextPure(_arg_1:String, _arg_2:String):String
        {
            if (((!(this.mTexts[_arg_1] == null)) && (!(this.mTexts[_arg_1][_arg_2.toLowerCase()] == null))))
            {
                return (this.mTexts[_arg_1][_arg_2.toLowerCase()]);
            };
            return (null);
        }

        private function replaceVariables(_arg_1:String, _arg_2:Array):String
        {
            var _local_4:Array;
            var _local_5:int;
            var _local_6:String;
            var _local_7:Array;
            var _local_8:int;
            var _local_9:String;
            var _local_10:Array;
            var _local_11:String;
            var _local_12:int;
            if (!_arg_2)
            {
                _local_4 = _arg_1.match(this._re1);
                _local_5 = 0;
                while (_local_5 < _local_4.length)
                {
                    _arg_1 = _arg_1.replace(_local_4[_local_5], "");
                    _local_5++;
                };
                return (_arg_1);
            };
            var _local_3:int;
            while (_local_3 < _arg_2.length)
            {
                _local_6 = (((("{(" + _local_3) + "|") + _local_3) + ",[A-Z]{1,3})}");
                if (!(_local_6 in this.regexCache))
                {
                    this.regexCache[_local_6] = new RegExp(_local_6, "g");
                };
                _local_7 = _arg_1.match(this.regexCache[_local_6]);
                if (_local_7)
                {
                    _local_8 = 0;
                    while (_local_8 < _local_7.length)
                    {
                        if ((_local_7[_local_8] as String).indexOf(",") > 0)
                        {
                            _local_11 = (_local_7[_local_8] as String).split(",")[1];
                            _local_11 = _local_11.substr(0, (_local_11.length - 1));
                            if (String(_arg_2[_local_3]).indexOf(StringUtils.COMMA) < 0)
                            {
                                _local_9 = this.GetText(_local_11, _arg_2[_local_3]);
                            }
                            else
                            {
                                _local_10 = StringUtils.split(_arg_2[_local_3], StringUtils.COMMA);
                                _local_9 = this.GetText(_local_11, _local_10[0]);
                                _local_12 = 1;
                                while (_local_12 < _local_10.length)
                                {
                                    _local_9 = (_local_9 + (", " + this.GetText(_local_11, _local_10[_local_12])));
                                    _local_12++;
                                };
                            };
                        }
                        else
                        {
                            _local_9 = _arg_2[_local_3];
                        };
                        _arg_1 = _arg_1.replace(_local_7[_local_8], _local_9);
                        _local_8++;
                    };
                };
                _local_3++;
            };
            return (_arg_1);
        }

        public function FormatDateAndTime(_arg_1:Number):String
        {
            date.setTime(_arg_1);
            formatter.formatString = cLocaManager.GetInstance().GetText(LOCA_GROUP.FORMATS, "Date");
            return ((((formatter.format(date) + " ") + ((date.hours < 10) ? ("0" + date.hours) : ("" + date.hours))) + ":") + ((date.minutes < 10) ? ("0" + date.minutes) : ("" + date.minutes)));
        }

        private function initFonts(_arg_1:Event):void
        {
            this.mFontName = Application.application.getStyle("fontFamily");
            globalFlash.gui.InitFonts(this.mFontName);
            if (this.mCompleteFunction != null)
            {
                this.mCompleteFunction(_arg_1);
            };
            this.mCompleteFunction = null;
            cLog.statusText(("cLocaManager: Loaded " + this.mSelectedLanguage));
        }

        public function FormatDate(_arg_1:Number):String
        {
            date.setTime(_arg_1);
            formatter.formatString = cLocaManager.GetInstance().GetText(LOCA_GROUP.FORMATS, "Date");
            return (formatter.format(date));
        }

        public function hasText(_arg_1:String, _arg_2:String):Boolean
        {
            if (((!(_arg_2)) || (!(this.mTexts[_arg_1]))))
            {
                return (false);
            };
            var _local_3:String = this.mTexts[_arg_1][_arg_2.toLowerCase()];
            if (((_local_3) && (_local_3.length > 0)))
            {
                return (true);
            };
            return (false);
        }

        private function changesLoaded(_arg_1:cXML):void
        {
            this.mLoadedFilesCount++;
            this.loadLanguageComplete(_arg_1);
        }

        public function GetGroup(_arg_1:String):Object
        {
            return (this.mTexts[_arg_1]);
        }

        public function IsInitialized():Boolean
        {
            return (this.mInitialized);
        }

        public function Init(_arg_1:Function):void
        {
            this.mCompleteFunction = _arg_1;
            this.LoadLanguage(this.mDefaultLanguage);
            numberFormatter.useThousandsSeparator = true;
            numberFormatter.rounding = "none";
        }

        public function exist(_arg_1:String, _arg_2:String=null):Boolean
        {
            if (this.mTexts[_arg_1])
            {
                return (this.mTexts[_arg_1][_arg_2.toLowerCase()]);
            };
            return (false);
        }

        private function languageLoaded(_arg_1:cXML):void
        {
            this.mLocaXML = _arg_1;
            this.mLoadedFilesCount++;
            this.loadLanguageComplete(_arg_1);
        }

        public function setText(_arg_1:String, _arg_2:String, _arg_3:String=""):void
        {
            if (((_arg_3 == "") || (_arg_3.indexOf("NT") == 0)))
            {
                NT.push(((_arg_1 + "|") + _arg_2));
                return;
            };
            this.mTexts[_arg_1][_arg_2.toLowerCase()] = _arg_3;
        }

        public function getTexts():*
        {
            return (this.mTexts);
        }

        public function getDefaultLanguage():String
        {
            return (this.mDefaultLanguage);
        }


    }
}//package GUI.Loca

class cSingletonEnforcer 
{

    public function cSingletonEnforcer()
    {
        super();
    }

}


