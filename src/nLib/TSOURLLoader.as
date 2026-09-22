package nLib
{
    import flash.net.URLLoader;
    import __AS3__.vec.Vector;
    import flash.net.URLLoaderDataFormat;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import com.bluebyte.tso.util.ClientLogger;
    import flash.filesystem.File;
    import flash.events.Event;
    import ServerState.cClientMessagesII;
    import mx.rpc.events.FaultEvent;
    import mx.controls.Alert;
    import flash.events.ErrorEvent;
    import flash.filesystem.FileStream;
    import flash.filesystem.FileMode;

    public class TSOURLLoader extends URLLoader 
    {

        private var usedCDNs:Vector.<uint>;
        private var lastCDN:int;
        private var sha:SHA1 = new SHA1();
        public var filename:String;

        public function TSOURLLoader(param1:URLRequest=null)
        {
            while (true)
            {
                _loop_1:
                while (true)
                {
                    switch (1)
                    {
                        case 0:
                            break _loop_1;
                        case 1:
                            this.usedCDNs = new Vector.<uint>();
                            super(param1);
                            dataFormat = URLLoaderDataFormat.BINARY;
                            addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler, false, 0, true);
                            addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler, false, 0, true);
                            return;
                    };
                };
            };
        }

        public function dispose():void
        {
            while (true)
            {
                _loop_1:
                while (true)
                {
                    switch (28)
                    {
                        case 0:
                            break;
                        case 1:
                            break _loop_1;
                        default:
                            removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
                            removeEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
                            this.usedCDNs = new Vector.<uint>();
                            if (data)
                            {
                                if ((data is ByteArray))
                                {
                                    (data as ByteArray).clear();
                                };
                                data = null;
                            };
                            return;
                    };
                };
            };
        }

        public function loadFile(param1:String):void
        {
            while (true)
            {
                switch (0)
                {
                    case 0:
                        this.filename = param1;
                        this.lastCDN = cFilenameUtil.getBestCDN(this.usedCDNs);
                        this.usedCDNs.push(this.lastCDN);
                        var _loc2_:String = cFilenameUtil.getCompleteURL(this.lastCDN, param1);
                        ClientLogger.loadingLog(("loading file: " + _loc2_));
                        var hashName:String = ("gfx_cache/" + cFilenameUtil.findHashMapping(param1));
                        var file:File = new File(File.applicationDirectory.resolvePath(hashName).nativePath);
                        if (((file.exists) && (file.size > 0)))
                        {
                            _loc2_ = file.url;
                        }
                        else
                        {
                            addEventListener(Event.COMPLETE, this.staticLoaded, false, 0, true);
                        };
                        super.load(new URLRequest(_loc2_));
                        return;
                };
            };
        }

        private function errorHandler(param1:ErrorEvent):void
        {
            while (true)
            {
                switch (0)
                {
                    case 0:
                        var _loc2_:String = null;
                        ClientLogger.loadingLog(("! file loading failed: " + this.filename));
                        if (this.usedCDNs.length < global.staticFilesURLList.length)
                        {
                            cClientMessagesII.LogMessageToBigBrother(new FaultEvent((((((("CDN ERROR EVENT: While loading file [" + this.filename) + "] from CDN [") + this.lastCDN) + "] an error occured: [") + param1.text) + "] Trying again...")), null);
                            cFilenameUtil.incrementBadCDN(this.lastCDN);
                            this.loadFile(this.filename);
                        }
                        else
                        {
                            cClientMessagesII.LogMessageToBigBrother(new FaultEvent((((((("CDN ERROR EVENT: While loading file [" + this.filename) + "] from CDN [") + this.lastCDN) + "] an error occured: [") + param1.text) + "] No additional CDN available!")), null);
                            _loc2_ = "File loading failed! Please check your network connection, clean your browser cache or try again later.";
                            Alert.show(_loc2_);
                        };
                        return;
                };
            };
        }

        private function staticLoaded(_arg_1:Event):void
        {
            var _local_2:TSOURLLoader = (_arg_1.target as TSOURLLoader);
            if ((!(defines.GFX_CACHE)))
            {
                return;
            };
            if (_local_2.data == null)
            {
                _local_2.load(new URLRequest(cFilenameUtil.getCompleteURL(this.lastCDN, _local_2.filename)));
                return;
            };
            _local_2.removeEventListener(Event.COMPLETE, this.staticLoaded);
            if (cFilenameUtil.findHashMapping(_local_2.filename).indexOf(sha.hash(_local_2.data)) == -1)
            {
                trace((_local_2.filename + " size mismatch"));
                return;
            };
            var fileStream:FileStream = new FileStream();
            var streamOpened:Boolean = false;
            var file:File = new File(File.applicationDirectory.resolvePath(("gfx_cache/" + cFilenameUtil.findHashMapping(_local_2.filename))).nativePath);
            try
            {
                file.parent.createDirectory();
                fileStream.open(file, FileMode.WRITE);
                streamOpened = true;
                fileStream.writeBytes(_local_2.data);
            }
            catch(e:Error)
            {
                trace(("Error writing to file: " + e.message));
            }
            finally
            {
                if (streamOpened)
                {
                    fileStream.close();
                };
            };
        }


    }
}
