package GUI.Components
{
    import mx.controls.Image;
    import __AS3__.vec.Vector;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import com.bluebyte.tso.util.ClientLogger;
    import ServerState.cClientMessagesII;
    import mx.rpc.events.FaultEvent;
    import nLib.cFilenameUtil;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.ErrorEvent;
    import __AS3__.vec.*;

    public class TSOImage extends Image 
    {

        private var usedCDNs:Vector.<uint> = new Vector.<uint>();
        private var lastCDN:int;
        public var filename:String;

        public function TSOImage()
        {
            super();
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
            addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
        }

        private function errorHandler(_arg_1:ErrorEvent):void
        {
            ClientLogger.loadingLog(("! file loading failed: " + this.filename));
            if (this.usedCDNs.length < global.staticFilesURLList.length)
            {
                cClientMessagesII.LogMessageToBigBrother(new FaultEvent((((((("CDN ERROR EVENT: While loading image [" + this.filename) + "] from CDN [") + this.lastCDN) + "] an error occured: [") + _arg_1.text) + "] Trying again...")), null);
                cFilenameUtil.incrementBadCDN(this.lastCDN);
                this.setURLSource(this.filename);
            }
            else
            {
                cClientMessagesII.LogMessageToBigBrother(new FaultEvent((((((("CDN ERROR EVENT: While loading image [" + this.filename) + "] from CDN [") + this.lastCDN) + "] an error occured: [") + _arg_1.text) + "] No additional CDN available!")), null);
                this.source = new Bitmap(new BitmapData(1, 1));
            };
        }

        private function setURLSource(_arg_1:String):void
        {
            this.filename = _arg_1;
            this.lastCDN = cFilenameUtil.getBestCDN(this.usedCDNs);
            this.usedCDNs.push(this.lastCDN);
            var _local_2:String = cFilenameUtil.getCompleteURL(this.lastCDN, _arg_1);
            ClientLogger.loadingLog(("loading file: " + _local_2));
            super.source = _local_2;
        }

        override public function set source(_arg_1:Object):void
        {
            if ((_arg_1 is String))
            {
                this.usedCDNs.length = 0;
                this.setURLSource((_arg_1 as String));
            }
            else
            {
                super.source = _arg_1;
            };
        }


    }
}
