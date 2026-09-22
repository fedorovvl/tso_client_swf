package nLib
{
    import __AS3__.vec.Vector;
    import GUI.Assets.gAssetManager;
    import __AS3__.vec.*;
    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;
    import flash.utils.ByteArray;

    public class cFilenameUtil 
    {

        private static var MAPPING_COUNT:int;
        private static var CDNs:Vector.<Object>;

        private static const MAPPING:Object = new Object();
        public static var MAPPING_OPEN:Object = new Object();

        {
            ((function ():void
            {
                var _local_3:*;
                var _local_4:*;
                var _local_5:*;
                var _local_1:* = new gAssetManager.FileHashing_Mapping();
                var _local_6:* = loadExternalMapping();
                if (_local_6 != null)
                {
                    _local_1 = _local_6;
                };
                var _local_8:* = loadVersionOverride();
                if (_local_8 != null)
                {
                    defines.VERSION_NR = _local_8;
                };
                var _local_7:* = defines.VERSION_NR;
                trace(("defines.VERSION_NR at boot = " + _local_7));
                if (_local_1.bytesAvailable > 0)
                {
                    while (_local_1.bytesAvailable > 0)
                    {
                        _local_4 = _local_1.readUTF();
                        _local_5 = _local_1.readUTF();
                        MAPPING[_local_4] = _local_5;
                        MAPPING_OPEN[_local_4] = _local_5;
                    };
                };
                var _local_2:* = 0;
                for (_local_3 in MAPPING)
                {
                    _local_2++;
                };
                MAPPING_COUNT = _local_2;
                trace((MAPPING_COUNT + " filename mappings loaded"));
            })());
        }


        private static function loadExternalMapping():*
        {
            var _local_1:File;
            var _local_2:FileStream;
            var _local_3:ByteArray;
            try
            {
                _local_1 = new File(File.applicationDirectory.resolvePath("filehash.mapping").nativePath);
                if (!(_local_1.exists) || _local_1.size == 0)
                {
                    trace(("filehash.mapping override not found at: " + File.applicationDirectory.resolvePath("filehash.mapping").nativePath + ", using embedded mapping"));
                    return (null);
                };
                _local_2 = new FileStream();
                _local_2.open(_local_1, FileMode.READ);
                _local_3 = new ByteArray();
                _local_2.readBytes(_local_3);
                _local_2.close();
                _local_3.position = 0;
                while (_local_3.bytesAvailable > 0)
                {
                    _local_3.readUTF();
                    _local_3.readUTF();
                };
                _local_3.position = 0;
                trace(("filehash.mapping override loaded: " + _local_1.nativePath + " (" + _local_3.length + " bytes)"));
                return (_local_3);
            }
            catch (e:Error)
            {
                trace(("filehash.mapping override not used (" + e.message + "), using embedded mapping"));
            };
            return (null);
        }

        private static function loadVersionOverride():*
        {
            var _local_1:File;
            var _local_2:FileStream;
            var _local_3:String;
            try
            {
                _local_1 = new File(File.applicationDirectory.resolvePath("version.txt").nativePath);
                if (!(_local_1.exists) || _local_1.size == 0)
                {
                    trace(("version.txt override not found at: " + File.applicationDirectory.resolvePath("version.txt").nativePath + ", using built-in VERSION_NR"));
                    return (null);
                };
                _local_2 = new FileStream();
                _local_2.open(_local_1, FileMode.READ);
                _local_3 = _local_2.readUTFBytes(_local_2.bytesAvailable);
                _local_2.close();
                _local_3 = _local_3.replace(/^\s+|\s+$/g, "");
                if (_local_3.length == 0)
                {
                    trace("version.txt override is empty, using built-in VERSION_NR");
                    return (null);
                };
                trace(("version.txt override applied, VERSION_NR = " + _local_3));
                return (_local_3);
            }
            catch (e:Error)
            {
                trace(("version.txt override not used (" + e.message + "), using built-in VERSION_NR"));
            };
            return (null);
        }


        public static function getCompleteURL(_arg_1:uint, _arg_2:String):String
        {
            var _local_3:String = global.staticFilesURLList[_arg_1];
            _local_3 = (_local_3 + "/GFX_HASHED/");
            return (_local_3 + cFilenameUtil.findHashMapping(_arg_2));
        }

        public static function findHashMapping(_arg_1:String):String
        {
            var _local_2:String;
            var _local_3:int;
            if (MAPPING_COUNT == 0)
            {
                return (toLowercase(_arg_1));
            };
            _arg_1 = _arg_1.replace(/\\/g, "/");
            while (_arg_1.indexOf("//") > -1)
            {
                _arg_1 = _arg_1.replace("//", "/");
            };
            _local_2 = (MAPPING[_arg_1.toLowerCase()] as String);
            if (_local_2 == null)
            {
                if (_arg_1.search(/\/[\da-f]{40}\.[\da-z]{3}(_enc|)$/) == -1)
                {
                    trace(("filehashing entry not found - lookUp-String: " + _arg_1.toLowerCase()));
                };
                return (toLowercase(_arg_1));
            };
            _local_3 = _arg_1.lastIndexOf("/");
            _local_2 = (_arg_1.substr(0, (_local_3 + 1)) + _local_2);
            return (toLowercase(_local_2));
        }

        public static function filterRelativePath(_arg_1:String):String
        {
            var _local_2:int;
            var _local_3:String;
            if (_arg_1.search("/") != -1)
            {
                _local_2 = (_arg_1.lastIndexOf("/") + 1);
                _local_3 = _arg_1.substr(_local_2);
                return (_arg_1.substr(0, _local_2));
            };
            return ("");
        }

        public static function getBestCDN(_arg_1:Vector.<uint>):uint
        {
            var _local_4:Object;
            if (_arg_1.length == 0)
            {
                return (CDNs[0].no);
            };
            var _local_2:Object;
            var _local_3:int = (CDNs.length - 1);
            while (_local_3 >= 0)
            {
                _local_4 = CDNs[_local_3];
                if (((_arg_1.indexOf(_local_4.no) == -1) && ((_local_2 == null) || (_local_2.count > _local_4.count))))
                {
                    _local_2 = _local_4;
                };
                _local_3--;
            };
            return (_local_2.no);
        }

        public static function resetCDNs():void
        {
            CDNs = new Vector.<Object>(global.staticFilesURLList.length);
            var _local_1:int;
            while (_local_1 < CDNs.length)
            {
                CDNs[_local_1] = {
                    "no":_local_1,
                    "count":0
                };
                _local_1++;
            };
        }

        public static function toLowercase(_arg_1:String):String
        {
            var _local_2:int;
            var _local_3:String;
            if (_arg_1.search("/") != -1)
            {
                _local_2 = (_arg_1.lastIndexOf("/") + 1);
                _local_3 = _arg_1.substr(_local_2);
                return (_arg_1.substr(0, _local_2) + _local_3.toLowerCase());
            };
            return (_arg_1.toLowerCase());
        }

        public static function incrementBadCDN(cdnNo:uint):void
        {
            var i:int = (CDNs.length - 1);
            while (i >= 0)
            {
                if (CDNs[i].no == cdnNo)
                {
                    CDNs[i].count++;
                    break;
                };
                i = (i - 1);
            };
            CDNs = CDNs.sort(function (_arg_1:Object, _arg_2:Object):Number
            {
                return (_arg_1.count - _arg_2.count);
            });
        }


    }
}
