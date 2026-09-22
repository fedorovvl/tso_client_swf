package nLib
{
    import GUI.Components.CustomAlert;
    import mx.managers.PopUpManager;
    import GUI.Loca.cLocaManager;
    import GUI.Components.StandardButton;
    import Enums.LOCA_GROUP;
    import flash.events.MouseEvent;
    import mx.utils.Base64Decoder;
    import flash.utils.ByteArray;
    import flash.system.Capabilities;
    import flash.net.getClassByAlias;
    import mx.collections.ArrayCollection;
    import com.bluebyte.tso.util.ClientLogger;
    import ServerState.cClientMessagesII;
    import flash.events.Event;
    import com.bluebyte.tso.util.TimeUtil;
    import BuffSystem.cBuffDefinition;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import mx.utils.StringUtil;
    import Communication.VO.dNumberVO;
    import ServerState.dResource;
    import mx.utils.Base64Encoder;
    import flash.utils.getTimer;
    import mx.controls.Alert;

    public class gMisc 
    {

        private static const FULLSCREEN_INTERACTIVE_MAJOR:int = 11;
        private static const FULLSCREEN_INTERACTIVE_MINOR:int = 3;
        private static var fpPopUp:CustomAlert = null;
        private static var timeSinceStartup:int;
        public static var sendLoadingLog:Boolean = true;
        private static var lastMessage:String = "";


        public static function AsciiKeyCode(_arg_1:String):int
        {
            return (_arg_1.charCodeAt(0));
        }

        public static function getAbsoluteValue(_arg_1:int):int
        {
            return ((_arg_1 + (_arg_1 >> 31)) ^ (_arg_1 >> 31));
        }

        public static function CustomAlertFPUpgrade():void
        {
            if (fpPopUp != null)
            {
                PopUpManager.removePopUp(fpPopUp);
            };
            var _local_1:cLocaManager = cLocaManager.GetInstance();
            fpPopUp = CustomAlert.show("FlashUpgradingToFullScreenInteractive", "FlashUpgradingToFullScreenInteractive");
            var _local_2:StandardButton = new StandardButton();
            _local_2.name = "FlashPlayerRedirectButton";
            _local_2.label = ((_local_1.IsInitialized()) ? _local_1.GetText(LOCA_GROUP.LABELS, "FlashPlayerRedirectButton") : "Upgrade Flash Player");
            _local_2.height = 32;
            _local_2.addEventListener(MouseEvent.CLICK, OpenFlash);
            fpPopUp.addCustomButton(_local_2);
        }

        public static function ParseFloat(_arg_1:String):Number
        {
            return (parseFloat(_arg_1));
        }

        public static function ReadObjectFromStringBytes(_arg_1:String):Object
        {
            var _local_2:Base64Decoder = new Base64Decoder();
            _local_2.decode(_arg_1);
            var _local_3:ByteArray = _local_2.drain();
            _local_3.position = 0;
            return (_local_3.readObject());
        }

        public static function ReplaceRightAlign_string(_arg_1:String, _arg_2:String):String
        {
            return (_arg_2.substr(0, (_arg_2.length - _arg_1.length)) + _arg_1);
        }

        public static function getCallStack(_arg_1:int=1, _arg_2:int=6):String
        {
            var _local_3:String;
            var _local_8:int;
            var _local_9:int;
            var _local_10:String;
            var _local_11:int;
            var _local_12:String;
            var _local_13:int;
            var _local_14:String;
            var _local_15:int;
            if (!Capabilities.isDebugger)
            {
                return ("");
            };
            var _local_4:Error = new Error();
            var _local_5:String = _local_4.getStackTrace();
            var _local_6:int = _local_5.indexOf("at ", 0);
            while (_arg_1 > 0)
            {
                _local_6 = _local_5.indexOf("at ", (_local_6 + 1));
                _arg_1--;
            };
            var _local_7:* = "";
            while (_arg_2 > 0)
            {
                _local_3 = "";
                _local_6 = _local_5.indexOf("at ", (_local_6 + 1));
                _local_8 = _local_5.indexOf("[", _local_6);
                if (_local_8 > -1)
                {
                    _local_13 = _local_5.indexOf("]", (_local_6 + 1));
                    _local_14 = _local_5.substring((_local_8 + 1), _local_13);
                    _local_15 = _local_14.lastIndexOf("\\");
                    _local_3 = _local_14.substring((_local_15 + 1), _local_14.length);
                };
                _local_9 = _local_5.indexOf("()", _local_6);
                _local_10 = _local_5.substring((_local_6 + 3), _local_9);
                _local_11 = _local_10.indexOf("/");
                _local_12 = _local_10.substring((_local_11 + 1), _local_10.length);
                _local_7 = (_local_7 + (((("\n    " + _local_12) + " (") + ((_local_3 != null) ? _local_3 : "??")) + ")"));
                _arg_2--;
            };
            return (_local_7);
        }

        public static function GetObject(_arg_1:Object, _arg_2:Object):*
        {
            var _local_5:Object;
            var _local_6:Object;
            var _local_7:*;
            if (((_arg_1 == null) || (!(_arg_1.hasOwnProperty("metadata")))))
            {
                return (_arg_1);
            };
            if (!_arg_1.metadata.hasOwnProperty("type"))
            {
                return (_arg_1);
            };
            var _local_3:Class = getClassByAlias(_arg_1.metadata.type);
            if (_local_3 == null)
            {
                return (_arg_1);
            };
            var _local_4:Object = new (_local_3)();
            for (_local_5 in _arg_1)
            {
                if (_local_5 !== "metadata")
                {
                    if (_arg_1[_local_5] != null)
                    {
                        if (_arg_1[_local_5].hasOwnProperty("object"))
                        {
                            if ((_arg_1[_local_5].object is ArrayCollection))
                            {
                                _local_4[_local_5] = new ArrayCollection();
                                if (_arg_2 != null)
                                {
                                    _arg_2[_local_5] = new ArrayCollection();
                                };
                                for each (_local_6 in ArrayCollection(_arg_1[_local_5].object))
                                {
                                    _local_7 = GetObject(_local_6, _arg_2);
                                    ArrayCollection(_local_4[_local_5]).addItem(_local_7);
                                };
                            }
                            else
                            {
                                _local_4[_local_5] = GetObject(_arg_1[_local_5].object, _arg_2);
                                if (_arg_2 != null)
                                {
                                    _arg_2[_local_5] = _local_4[_local_5];
                                };
                            };
                        }
                        else
                        {
                            _local_4[_local_5] = _arg_1[_local_5];
                            if (_arg_2 != null)
                            {
                                _arg_2[_local_5] = _local_4[_local_5];
                            };
                        };
                    };
                };
            };
            return (_local_4);
        }

        public static function uncaughtErrorHandler(_arg_1:Event):void
        {
            trace("in uncaughtErrorHandler");
            _arg_1.preventDefault();
            ClientLogger.log(("event:" + _arg_1));
            var _local_2:Error = _arg_1["error"];
            if (_local_2 != null)
            {
                ClientLogger.error(_local_2);
            }
            else
            {
                ClientLogger.log("Uncaught non-Error value: " + _arg_1["error"]);
                return;
            }
            var _local_3:* = "Client exception\r\n";
            _local_3 = (_local_3 + (("    os:" + Capabilities.os) + "\r\n"));
            _local_3 = (_local_3 + (("    version:" + Capabilities.version) + "\r\n"));
            _local_3 = (_local_3 + (("    isDebugger:" + Capabilities.isDebugger) + "\r\n"));
            _local_3 = (_local_3 + (("    avHardwareDisable:" + Capabilities.avHardwareDisable) + "\r\n"));
            _local_3 = (_local_3 + (("    language:" + Capabilities.language) + "\r\n"));
            _local_3 = (_local_3 + (("    playerType:" + Capabilities.playerType) + "\r\n"));
            _local_3 = (_local_3 + (((("    screen:" + Capabilities.screenResolutionX) + "x") + Capabilities.screenResolutionY) + "\r\n    "));
            var _local_4:String = _local_2.getStackTrace();
            if (((!(_local_4 == null)) && (_local_4.length > 0)))
            {
                _local_3 = (_local_3 + _local_4);
            }
            else
            {
                _local_3 = (_local_3 + (((_local_2.message + "\r\n") + "    event:") + _arg_1.toString()));
            };
            cClientMessagesII.LogMessageToBigBrother(_arg_1);
        }

        public static function IntToObject(_arg_1:int):Object
        {
            return (_arg_1 as Object);
        }

        public static function GetEpochMillis():Number
        {
            return (TimeUtil.getServerTime());
        }

        public static function GetExtensionString(_arg_1:String):String
        {
            return (_arg_1.substr(_arg_1.lastIndexOf(".")));
        }

        public static function getRandomIntegerArray(_arg_1:int, _arg_2:int):Array
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_3:Array = new Array(_arg_2);
            var _local_4:int;
            while (_local_4 < _arg_2)
            {
                _local_3[_local_4] = _local_4;
                _local_4++;
            };
            var _local_5:cRandomSeed = new cRandomSeed();
            _local_5.SetSeed(_arg_1);
            var _local_6:int;
            while (_local_6 < (_local_3.length * 3))
            {
                _local_7 = _local_5.GetNextRandom();
                if (_local_7 < 0)
                {
                    _local_7 = -(_local_7);
                };
                _local_7 = (_local_7 % _local_3.length);
                _local_8 = _local_5.GetNextRandom();
                if (_local_8 < 0)
                {
                    _local_8 = -(_local_8);
                };
                _local_8 = (_local_8 % _local_3.length);
                if (_local_7 != _local_8)
                {
                    _local_9 = _local_3[_local_7];
                    _local_3[_local_7] = _local_3[_local_8];
                    _local_3[_local_8] = _local_9;
                };
                _local_6++;
            };
            return (_local_3);
        }

        public static function Replace_string(_arg_1:String, _arg_2:String):String
        {
            return (_arg_1 + _arg_2.substr(_arg_1.length));
        }

        public static function ReplaceRegEx_string(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            return (_arg_1.replace(_arg_2, _arg_3));
        }

        public static function getPseudoRandom(_arg_1:int):Number
        {
            if (_arg_1 == 0)
            {
                _arg_1 = 1;
            };
            _arg_1 = (_arg_1 & 0x7FFF);
            _arg_1 = (_arg_1 * _arg_1);
            _arg_1 = (_arg_1 & 0x7FFF);
            _arg_1 = (_arg_1 * _arg_1);
            _arg_1 = (_arg_1 % 1000000);
            return (_arg_1 * 1E-6);
        }

        public static function isEnabledFullScreenInteractive():Boolean
        {
            var _local_1:Array = Capabilities.version.split(",");
            var _local_2:Array = _local_1[0].split(" ");
            var _local_3:int = parseInt(_local_2[1]);
            var _local_4:int = parseInt(_local_1[1]);
            return ((_local_3 > FULLSCREEN_INTERACTIVE_MAJOR) || ((_local_3 == FULLSCREEN_INTERACTIVE_MAJOR) && (_local_4 >= FULLSCREEN_INTERACTIVE_MINOR)));
        }

        public static function sortBuffDefinitionList(_arg_1:cBuffDefinition, _arg_2:cBuffDefinition):Number
        {
            var _local_3:int = _arg_1.GetSortIndex();
            var _local_4:int = _arg_2.GetSortIndex();
            if (_local_3 != _local_4)
            {
                return (_local_3 - _local_4);
            };
            if (_arg_1.GetResourceName_string() > _arg_2.GetResourceName_string())
            {
                return (1);
            };
            if (_arg_1.GetResourceName_string() < _arg_2.GetResourceName_string())
            {
                return (-1);
            };
            var _local_5:String = _arg_1.GetName_string();
            var _local_6:String = _arg_2.GetName_string();
            if (_local_5 > _local_6)
            {
                return (1);
            };
            if (_local_5 < _local_6)
            {
                return (-1);
            };
            return (0);
        }

        public static function GetFileNameWithoutExtensionString(_arg_1:String):String
        {
            return (_arg_1.substr(0, _arg_1.lastIndexOf(".")));
        }

        public static function GetTimeSinceStartup():int
        {
            return (timeSinceStartup);
        }

        public static function GetRandomValueMinMax(_arg_1:Number, _arg_2:Number):Number
        {
            var _local_3:Number = (_arg_2 - _arg_1);
            return ((Math.random() * _local_3) + _arg_1);
        }

        public static function GetRandomMinMax(_arg_1:Number, _arg_2:Number):Number
        {
            var _local_3:Number = ((_arg_2 + 1) - _arg_1);
            return ((Math.random() * _local_3) + _arg_1);
        }

        private static function OpenFlash(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest(global.flashPlayerRedirectURL), "_blank");
        }

        public static function Trim_string(_arg_1:String):String
        {
            return (StringUtil.trim(_arg_1));
        }

        public static function InitTimeSinceStartup():void
        {
            UpdateTimeSinceStartup();
        }

        public static function DoubleToObject(_arg_1:Number):Object
        {
            var _local_2:dNumberVO = new dNumberVO();
            _local_2.value = _arg_1;
            return (_local_2);
        }

        public static function ConvertIntToStringRadix_string(_arg_1:int, _arg_2:int):String
        {
            return (_arg_1.toString(_arg_2));
        }

        public static function GetMaxIntValue():int
        {
            return (2147483647);
        }

        public static function getPseudoRandomMinMax(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            var _local_4:Number = ((getPseudoRandom(_arg_1) * (_arg_3 - _arg_2)) + _arg_2);
            return (int((_local_4 + int((((_local_4 * 100000) % 100000) * 2E-5)))));
        }

        public static function ObjectToDouble(_arg_1:Object):Number
        {
            var _local_2:dNumberVO = (_arg_1 as dNumberVO);
            return (_local_2.value);
        }

        public static function GetGemResourceData(_arg_1:int):dResource
        {
            var _local_2:dResource = new dResource();
            _local_2.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
            _local_2.amount = _arg_1;
            return (_local_2);
        }

        public static function ConvertIntToString_string(_arg_1:int):String
        {
            return (_arg_1.toString());
        }

        public static function GetRandomMinMaxInt(_arg_1:int, _arg_2:int):int
        {
            var _local_3:Number = ((_arg_2 + 1) - _arg_1);
            return ((Math.random() * _local_3) + _arg_1);
        }

        public static function SerializeToString(_arg_1:Object):String
        {
            if (_arg_1 == null)
            {
                throw (new Error("null isn't a legal serialization candidate"));
            };
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeObject(_arg_1);
            _local_2.position = 0;
            var _local_3:Base64Encoder = new Base64Encoder();
            _local_3.encode(_local_2.readUTFBytes(_local_2.length));
            return (_local_3.drain());
        }

        public static function IsNaN(_arg_1:Number):Boolean
        {
            return (isNaN(_arg_1));
        }

        public static function iterableToArray(_arg_1:*):Array
        {
            var _local_3:*;
            var _local_2:Array = [];
            for each (_local_3 in _arg_1)
            {
                _local_2.push(_local_3);
            };
            return (_local_2);
        }

        public static function ObjectToInt(_arg_1:Object):int
        {
            return (_arg_1 as int);
        }

        public static function UpdateTimeSinceStartup():void
        {
            timeSinceStartup = getTimer();
        }

        public static function GetCallingMethodName(_arg_1:int=1):String
        {
            var _local_11:int;
            var _local_12:String;
            var _local_13:int;
            if (!Capabilities.isDebugger)
            {
                return ("");
            };
            var _local_2:* = "";
            var _local_3:Error = new Error();
            var _local_4:String = _local_3.getStackTrace();
            var _local_5:int;
            switch (_arg_1)
            {
                case 0:
                    _local_5 = _local_4.indexOf("at ", (_local_4.indexOf("at ") + 1));
                    break;
                case 1:
                    _local_5 = _local_4.indexOf("at ", (_local_4.indexOf("at ", (_local_4.indexOf("at ") + 1)) + 1));
                    break;
                case 2:
                    _local_5 = _local_4.indexOf("at ", (_local_4.indexOf("at ", (_local_4.indexOf("at ", (_local_4.indexOf("at ") + 1)) + 1)) + 1));
                    break;
                case 3:
                    _local_5 = _local_4.indexOf("at ", (_local_4.indexOf("at ", (_local_4.indexOf("at ", (_local_4.indexOf("at ", (_local_4.indexOf("at ") + 1)) + 1)) + 1)) + 1));
                    break;
                default:
                    _local_5 = _local_4.indexOf("at ", (_local_4.indexOf("at ", (_local_4.indexOf("at ") + 1)) + 1));
            };
            var _local_6:int = _local_4.indexOf("[", _local_5);
            if (_local_6 > -1)
            {
                _local_11 = _local_4.indexOf("]", (_local_5 + 1));
                _local_12 = _local_4.substring((_local_6 + 1), _local_11);
                _local_13 = _local_12.lastIndexOf("\\");
                _local_2 = _local_12.substring((_local_13 + 1), _local_12.length);
            };
            var _local_7:int = _local_4.indexOf("()", _local_5);
            var _local_8:String = _local_4.substring((_local_5 + 3), _local_7);
            var _local_9:int = _local_8.indexOf("/");
            var _local_10:String = _local_8.substring((_local_9 + 1), _local_8.length);
            if (_local_2 != null)
            {
                return (((_local_10 + " (") + _local_2) + ")");
            };
            return (_local_10);
        }

        public static function ParseInt(_arg_1:String):int
        {
            return (parseInt(_arg_1));
        }

        public static function ConvertDoubleToString_string(_arg_1:Number):String
        {
            return (_arg_1.toString());
        }

        public static function CheatWindowConsoleOut(_arg_1:String):void
        {
            trace(_arg_1);
        }

        public static function FastIntegerSqrt(_arg_1:int):int
        {
            var _local_3:int;
            var _local_5:int;
            var _local_2:int;
            var _local_4:int = (-(_arg_1) - 1);
            _local_3 = 30;
            while (_local_3 >= 0)
            {
                _local_2 = (_local_2 + _local_2);
                _local_5 = (_local_4 + (((2 * _local_2) + 1) << _local_3));
                if (_local_5 < 0)
                {
                    _local_4 = _local_5;
                    _local_2++;
                };
                _local_3 = (_local_3 - 2);
            };
            return (_local_2);
        }

        public static function GetMaxFloatValue():Number
        {
            return (Number.MAX_VALUE);
        }

        public static function MessageBox(_arg_1:String):void
        {
            if (lastMessage != _arg_1)
            {
                Alert.show(_arg_1);
                lastMessage = _arg_1;
            };
        }

        public static function GetRandomValueMinMaxInt(_arg_1:int, _arg_2:int):int
        {
            return (Math.round(GetRandomValueMinMax(_arg_1, _arg_2)));
        }

        public static function Assert(_arg_1:Boolean, _arg_2:String):void
        {
            var _local_3:String;
            if (!_arg_1)
            {
                _local_3 = (("Assert! \n" + _arg_2) + "\n\n");
                MessageBox(_local_3);
                throw (new SyntaxError(_local_3));
            };
        }

        public static function ConvertDoubleToStringWithDecimalPlaces_string(_arg_1:Number):String
        {
            return (_arg_1.toFixed(2));
        }

        public static function safeMultiplication(_arg_1:Number, _arg_2:Number):Number
        {
            return ((Math.round((_arg_1 * 1000)) * Math.round((_arg_2 * 1000))) / 1000000);
        }

        public static function GetSubString_string(_arg_1:String, _arg_2:Number, _arg_3:Number):String
        {
            return (_arg_1.substr(_arg_2, _arg_3));
        }

        public static function SearchString(_arg_1:String, _arg_2:String):int
        {
            return (_arg_1.search(_arg_2));
        }

        public static function RemoveExtension(_arg_1:String):String
        {
            var _local_2:int = _arg_1.lastIndexOf(".");
            if (_local_2 != -1)
            {
                return (_arg_1.substr(0, _local_2));
            };
            return (_arg_1);
        }


    }
}
