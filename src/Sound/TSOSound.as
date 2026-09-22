package Sound
{
    import flash.media.Sound;
    import __AS3__.vec.Vector;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import ServerState.cClientMessagesII;
    import mx.rpc.events.FaultEvent;
    import nLib.cFilenameUtil;
    import flash.events.ErrorEvent;
    import __AS3__.vec.*;

    public class TSOSound extends Sound 
    {

        private var usedCDNs:Vector.<uint> = new Vector.<uint>();
        private var lastCDN:int;
        public var filename:String;
        public var name:String;

        public function TSOSound(_arg_1:URLRequest=null)
        {
            super(_arg_1);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
            addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
        }

        private function errorHandler(_arg_1:ErrorEvent):void
        {
            if (this.usedCDNs.length < global.staticFilesURLList.length)
            {
                cClientMessagesII.LogMessageToBigBrother(new FaultEvent((((((("CDN ERROR EVENT: While loading sound [" + this.filename) + "] from CDN [") + this.lastCDN) + "] an error occured: [") + _arg_1.text) + "] Trying again...")), null);
                cFilenameUtil.incrementBadCDN(this.lastCDN);
                this.loadSound(this.filename);
            };
        }

        public function loadSound(_arg_1:String, _arg_2:String):void
        {
            this.filename = _arg_1;
            this.name = _arg_2;
            this.lastCDN = cFilenameUtil.getBestCDN(this.usedCDNs);
            this.usedCDNs.push(this.lastCDN);
            super.load(new URLRequest(cFilenameUtil.getCompleteURL(this.lastCDN, _arg_1)));
        }


    }
}
