package GUI.Components
{
    import mx.controls.VideoDisplay;
    import __AS3__.vec.Vector;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import ServerState.cClientMessagesII;
    import mx.rpc.events.FaultEvent;
    import nLib.cFilenameUtil;
    import flash.events.ErrorEvent;
    import __AS3__.vec.*;

    public class TSOVideoDisplay extends VideoDisplay 
    {

        private var usedCDNs:Vector.<uint> = new Vector.<uint>();
        private var lastCDN:int;
        public var filename:String;

        public function TSOVideoDisplay()
        {
            super();
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
            addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
        }

        private function errorHandler(_arg_1:ErrorEvent):void
        {
            if (this.usedCDNs.length < global.staticFilesURLList.length)
            {
                cClientMessagesII.LogMessageToBigBrother(new FaultEvent((((((("CDN ERROR EVENT: While loading video [" + this.filename) + "] from CDN [") + this.lastCDN) + "] an error occured: [") + _arg_1.text) + "] Trying again...")), null);
                cFilenameUtil.incrementBadCDN(this.lastCDN);
                this.setURLSource(this.filename);
            }
            else
            {
                cClientMessagesII.LogMessageToBigBrother(new FaultEvent((((((("CDN ERROR EVENT: While loading video [" + this.filename) + "] from CDN [") + this.lastCDN) + "] an error occured: [") + _arg_1.text) + "] No additional CDN available!")), null);
                this.source = null;
            };
        }

        private function setURLSource(_arg_1:String):void
        {
            this.filename = _arg_1;
            this.lastCDN = cFilenameUtil.getBestCDN(this.usedCDNs);
            this.usedCDNs.push(this.lastCDN);
            super.source = cFilenameUtil.getCompleteURL(this.lastCDN, _arg_1);
        }

        override public function set source(_arg_1:String):void
        {
            this.usedCDNs.length = 0;
            this.setURLSource(_arg_1);
        }


    }
}
