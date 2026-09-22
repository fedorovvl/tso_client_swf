package ServerState
{
    import flash.utils.Timer;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.net.URLVariables;
    import flash.net.URLRequestMethod;
    import flash.net.URLLoaderDataFormat;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import mx.rpc.events.FaultEvent;
    import flash.events.IOErrorEvent;
    import flash.events.HTTPStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IEventDispatcher;
    import Enums.ERROR_CODES;

    public class cBigBrotherMessage 
    {

        public static const ERROR_RETRIES:int = 5;

        private var errorRetry:int = 0;
        private var mType:int;
        private var mObject:Object;
        private var mResponder:Responding;
        private var mLoginQueueStatus:cLoginQueueStatus = null;
        private var mTimer:Timer = null;
        private var mURLRequest:URLRequest;
        private var mZoneId:int;
        private var mURLLoader:URLLoader;
        private var mReplaceEndpoint:Boolean;
        private var mStatus:int;

        public function cBigBrotherMessage(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:Boolean=false, _arg_5:Responding=null)
        {
            super();
            this.mResponder = _arg_5;
            this.mType = _arg_1;
            this.mZoneId = _arg_2;
            this.mObject = _arg_3;
            this.mReplaceEndpoint = _arg_4;
            var _local_6:URLVariables = new URLVariables();
            _local_6.zoneID = _arg_2;
            _local_6.DSOAUTHTOKEN = cClientMessagesII.mAuthToken;
            _local_6.DSOAUTHUSER = cClientMessagesII.mAuthUser;
            this.mURLRequest = new URLRequest();
            this.mURLRequest.url = global.bigBrotherURL;
            this.mURLRequest.method = URLRequestMethod.POST;
            this.mURLRequest.data = _local_6;
            this.mURLRequest.url = ((global.bigBrotherURL + "Z") + new Date().getTime());
            this.mURLLoader = new URLLoader();
            this.mURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
            this.ConfigureListeners(this.mURLLoader);
            this.mURLLoader.load(this.mURLRequest);
            this.mTimer = new Timer(5000, 1);
            this.mTimer.addEventListener(TimerEvent.TIMER, this.Retry);
            this.mLoginQueueStatus = new cLoginQueueStatus();
        }

        private function Retry(_arg_1:TimerEvent):void
        {
            if (this.mTimer != null)
            {
                this.mURLRequest.url = ((global.bigBrotherURL + "Z") + new Date().getTime());
                this.mURLLoader.load(this.mURLRequest);
            };
        }

        private function CompleteHandler(_arg_1:Event):void
        {
            if (this.mTimer == null)
            {
                return;
            };
            var _local_2:String = String(URLLoader(_arg_1.target).data).replace(":123443", "");
            if (_local_2.indexOf("http://") == 0 && _local_2.indexOf(":443/") >= 0)
            {
                _local_2 = "https://" + _local_2.substr("http://".length);
            }
            if (this.mStatus != 202)
            {
                global.ui.mClientMessages.bigBrotherMessageCompleteHandler(this.mType, this.mZoneId, this.mObject, _local_2, this.mReplaceEndpoint, this.mResponder);
                this.mTimer.stop();
                this.mTimer.removeEventListener(TimerEvent.TIMER, this.Retry);
                this.mTimer = null;
                this.mLoginQueueStatus.dispose();
                this.mLoginQueueStatus = null;
            }
            else
            {
                this.mLoginQueueStatus.update(_local_2);
                this.mTimer.start();
            };
        }

        private function IoErrorHandler(_arg_1:IOErrorEvent):void
        {
            if (this.errorRetry < ERROR_RETRIES)
            {
                this.errorRetry++;
                this.mTimer.start();
            }
            else
            {
                global.ui.mClientMessages.FaultHandler(new FaultEvent(((("cBigBrotherMessage " + _arg_1.type) + " ") + _arg_1.text)));
            };
        }

        private function ConfigureListeners(_arg_1:IEventDispatcher):void
        {
            _arg_1.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.HttpStatusHandler);
            _arg_1.addEventListener(Event.COMPLETE, this.CompleteHandler);
            _arg_1.addEventListener(IOErrorEvent.IO_ERROR, this.IoErrorHandler);
            _arg_1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.SecurityErrorHandler);
        }

        private function SecurityErrorHandler(_arg_1:SecurityErrorEvent):void
        {
            if (this.errorRetry < ERROR_RETRIES)
            {
                this.errorRetry++;
                this.mTimer.start();
            }
            else
            {
                global.ui.mClientMessages.FaultHandler(new FaultEvent(((("cBigBrotherMessage " + _arg_1.type) + " ") + _arg_1.text)));
            };
        }

        public function cancelLoadingZone():void
        {
            if (this.mTimer != null)
            {
                this.mTimer.stop();
                this.mTimer.removeEventListener(TimerEvent.TIMER, this.Retry);
                this.mTimer = null;
            };
            if (this.mLoginQueueStatus != null)
            {
                this.mLoginQueueStatus.dispose();
                this.mLoginQueueStatus = null;
            };
        }

        private function HttpStatusHandler(_arg_1:HTTPStatusEvent):void
        {
            this.mStatus = _arg_1.status;
            switch (this.mStatus)
            {
                case 403:
                    global.ui.mClientMessages.FaultHandler(new FaultEvent(((ERROR_CODES.BB_AUTH_FAILED + " BigBrother returned : ") + this.mStatus)));
                    return;
                case 404:
                    global.ui.mClientMessages.FaultHandler(new FaultEvent(((ERROR_CODES.BB_SERVERS_FULL + " BigBrother returned : ") + this.mStatus)));
                    return;
                case 405:
                case 503:
                    global.ui.mClientMessages.FaultHandler(new FaultEvent(((ERROR_CODES.BB_SERVICE_FAILED + " BigBrother returned : ") + this.mStatus)));
                    return;
            };
        }


    }
}
