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
    import flash.events.NetStatusEvent;
    import flash.media.SoundTransform;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.net.NetStreamAppendBytesAction;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;
    import mx.events.VideoEvent;
    import __AS3__.vec.*;

    public class TSOVideoDisplay extends VideoDisplay 
    {

        private var usedCDNs:Vector.<uint> = new Vector.<uint>();
        private var lastCDN:int;
        public var filename:String;
        private var embeddedBytes:ByteArray;
        private var embeddedConnection:NetConnection;
        private var embeddedStream:NetStream;
        private var embeddedVideo:Video;
        private var embeddedVolume:Number = 1;
        private var preparingEmbeddedFrame:Boolean = false;

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

        public function setEmbeddedSource(_arg_1:ByteArray):void
        {
            this.embeddedBytes = new ByteArray();
            _arg_1.position = 0;
            _arg_1.readBytes(this.embeddedBytes, 0, _arg_1.length);
            this.embeddedBytes.position = 0;
            if (this.embeddedVideo == null)
            {
                this.embeddedVideo = new Video(width, height);
                this.embeddedVideo.smoothing = true;
                addChild(this.embeddedVideo);
            };
            this.startEmbeddedStream(true);
        }

        public function setEmbeddedVolume(_arg_1:Number):void
        {
            this.embeddedVolume = _arg_1;
            if (this.embeddedStream != null)
            {
                this.embeddedStream.soundTransform = new SoundTransform(_arg_1);
            };
        }

        public function rewindEmbedded():void
        {
            if (this.embeddedStream != null)
            {
                this.embeddedStream.close();
                this.embeddedStream = null;
            };
        }

        public function playEmbedded():void
        {
            if (this.embeddedBytes == null)
            {
                return;
            };
            this.startEmbeddedStream(false);
        }

        private function startEmbeddedStream(_arg_1:Boolean):void
        {
            this.rewindEmbedded();
            this.preparingEmbeddedFrame = _arg_1;
            this.embeddedConnection = new NetConnection();
            this.embeddedConnection.connect(null);
            this.embeddedStream = new NetStream(this.embeddedConnection);
            this.embeddedStream.client = {onMetaData:function(_arg_1:Object):void
                {
                }};
            this.embeddedStream.soundTransform = new SoundTransform((_arg_1) ? 0 : this.embeddedVolume);
            this.embeddedStream.addEventListener(NetStatusEvent.NET_STATUS, this.embeddedNetStatusHandler);
            this.embeddedVideo.attachNetStream(this.embeddedStream);
            this.embeddedStream.play(null);
            this.embeddedStream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
            this.embeddedBytes.position = 0;
            this.embeddedStream.appendBytes(this.embeddedBytes);
            this.embeddedStream.appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
        }

        private function pauseOnFirstEmbeddedFrame():void
        {
            if (((this.preparingEmbeddedFrame) && (!(this.embeddedStream == null))))
            {
                this.embeddedStream.pause();
                this.embeddedStream.seek((1 / 30));
                this.embeddedStream.soundTransform = new SoundTransform(this.embeddedVolume);
                this.preparingEmbeddedFrame = false;
            };
        }

        private function embeddedNetStatusHandler(_arg_1:NetStatusEvent):void
        {
            if (((_arg_1.info.code == "NetStream.Play.Start") && (this.preparingEmbeddedFrame)))
            {
                setTimeout(this.pauseOnFirstEmbeddedFrame, 40);
                return;
            };
            if (_arg_1.info.code == "NetStream.Play.Stop")
            {
                dispatchEvent(new VideoEvent(VideoEvent.COMPLETE));
            };
        }


    }
}
