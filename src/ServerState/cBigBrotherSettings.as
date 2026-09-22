package ServerState
{
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.utils.Timer;
    import flash.net.URLLoaderDataFormat;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IEventDispatcher;

    public class cBigBrotherSettings 
    {

        private static var UNDEFINED:String = "UNDEFINED";

        private var mResumeLoading:Function;
        private var mLoadingResumed:Boolean;
        private var mURLRequest:URLRequest;
        private var mURLLoader:URLLoader;
        private var mTimer:Timer;
        private var mStatus:int;

        public function cBigBrotherSettings(_arg_1:Function)
        {
            super();
            this.mURLRequest = new URLRequest();
            this.mURLRequest.url = ((global.bigBrotherURL + "settingsdefine") + new Date().getTime());
            this.mURLLoader = new URLLoader();
            this.mURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
            this.ConfigureListeners(this.mURLLoader);
            this.mURLLoader.load(this.mURLRequest);
            this.mTimer = new Timer(2000, 1);
            this.mTimer.addEventListener(TimerEvent.TIMER, this.FailedLoadingUrl);
            this.mTimer.start();
            this.mResumeLoading = _arg_1;
        }

        private function ResumeLoading():void
        {
            this.mLoadingResumed = true;
            this.mResumeLoading();
        }

        private function CompleteHandler(_arg_1:Event):void
        {
            var _local_2:Array = String(URLLoader(_arg_1.target).data).split("|");
            if (((this.mStatus == 200) && (!(this.mLoadingResumed))))
            {
                global.eventLoadingScreen = UNDEFINED;
                this.mTimer.stop();
                this.mTimer.removeEventListener(TimerEvent.TIMER, this.FailedLoadingUrl);
                this.mTimer = null;
            }
            else
            {
                global.eventLoadingScreen = UNDEFINED;
            };
            if (!this.mLoadingResumed)
            {
                this.ResumeLoading();
            };
        }

        private function HttpStatusHandler(_arg_1:HTTPStatusEvent):void
        {
            this.mStatus = _arg_1.status;
        }

        private function ConfigureListeners(_arg_1:IEventDispatcher):void
        {
            _arg_1.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.HttpStatusHandler);
            _arg_1.addEventListener(Event.COMPLETE, this.CompleteHandler);
            _arg_1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.FailedLoadingUrl);
        }

        private function FailedLoadingUrl(_arg_1:Event):void
        {
            global.eventLoadingScreen = UNDEFINED;
            this.ResumeLoading();
        }


    }
}
