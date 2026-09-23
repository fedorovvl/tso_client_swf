package com.bluebyte.tso.util
{
    import mx.formatters.DateFormatter;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import nLib.gMisc;
    import flash.utils.getQualifiedClassName;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import __AS3__.vec.*;

    public class ClientLogger 
    {

        private static const MAX_LOG:int = 2000;
        private static var formatter:DateFormatter = genFormatter();
        private static var messages:Vector.<String> = new Vector.<String>();
        private static var missingLoca:Dictionary = new Dictionary();
        private static var loadLog:Vector.<String> = new Vector.<String>();
        private static var logFile:File = File.applicationStorageDirectory.resolvePath("client.log");


        private static function add(_arg_1:String, _arg_2:Boolean):void
        {
            _arg_1 = _arg_1.replace(/((?:dsoAuthToken|mAuthToken|authrandom|randomauth)\s*[:=]\s*)[^&\s]+/gi, "$1[redacted]");
            var _local_3:String = ((_arg_2) ? formatter.format(new Date()) : "") + _arg_1;
            trace(_local_3);
            messages.push(_local_3);
            if (messages.length > MAX_LOG)
            {
                messages.shift();
            };
            try
            {
                var _local_4:FileStream = new FileStream();
                _local_4.open(logFile, FileMode.APPEND);
                _local_4.writeUTFBytes(_local_3 + "\r\n");
                _local_4.close();
            }
            catch (_error:Error)
            {
                // Logging must never interrupt the game client.
            };
        }

        public static function getLogFilePath():String
        {
            return (logFile.nativePath);
        }

        public static function logMissingLoca(_arg_1:String, _arg_2:String):void
        {
            var _local_3:String = ((_arg_1 + " / ") + _arg_2);
            missingLoca[_local_3] = (int(missingLoca[_local_3]) + 1);
        }

        public static function log(_arg_1:String):void
        {
            add(_arg_1, true);
        }

        public static function getLoadingLog():String
        {
            return (loadLog.join("\n"));
        }

        public static function loadingLog(_arg_1:String):void
        {
            if (gMisc.sendLoadingLog)
            {
                loadLog.push((formatter.format(new Date()) + _arg_1));
            };
        }

        public static function clear():void
        {
            messages.length = 0;
            missingLoca = new Dictionary();
        }

        public static function error(_arg_1:Error):void
        {
            log(((((((("Error #" + _arg_1.errorID) + " ") + getQualifiedClassName(_arg_1)) + "\n") + _arg_1.message) + "\n") + _arg_1.getStackTrace()));
        }

        public static function getLog(_arg_1:Boolean=true):String
        {
            var _local_3:String;
            var _local_2:String = messages.join("\n");
            if (_arg_1)
            {
                _local_2 = (_local_2 + "\n\nMISSING LOCAs:");
                for (_local_3 in missingLoca)
                {
                    _local_2 = (_local_2 + ((("\n\t" + _local_3) + ": ") + missingLoca[_local_3]));
                };
            };
            return (_local_2);
        }

        public static function logWithoutDate(_arg_1:String):void
        {
            add(_arg_1, false);
        }

        private static function genFormatter():DateFormatter
        {
            var _local_1:DateFormatter = new DateFormatter();
            _local_1.formatString = "[DD/MM/YYYY J:NN:SS:QQQ] ";
            return (_local_1);
        }


    }
}
