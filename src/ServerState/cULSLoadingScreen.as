package ServerState
{
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.utils.Timer;

    public class cULSLoadingScreen
    {
        private var mResumeLoading:Function;
        private var mURLLoader:URLLoader;
        private var mTimer:Timer;
        private var mLoadingResumed:Boolean;
        private var mStatus:int;

        public function cULSLoadingScreen(resumeLoading:Function)
        {
            this.mResumeLoading = resumeLoading;
            cClientMessagesII.fetchStartupArguments();
            var base:String = global.ulsURL;
            while (base.charAt(base.length - 1) == "/")
            {
                base = base.substr(0, base.length - 1);
            };

            var request:URLRequest = new URLRequest(base + "/v1/territories/" + encodeURIComponent(global.territory) + "/realms/" + encodeURIComponent(global.realm) + "/loadingscreen");
            request.method = URLRequestMethod.POST;
            var fields:URLVariables = new URLVariables();
            fields.DSOAUTHUSER = cClientMessagesII.mAuthUser;
            fields.DSOAUTHTOKEN = cClientMessagesII.mAuthToken;
            request.data = fields;

            this.mURLLoader = new URLLoader();
            this.mURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
            this.mURLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.HttpStatusHandler);
            this.mURLLoader.addEventListener(Event.COMPLETE, this.CompleteHandler);
            this.mURLLoader.addEventListener(IOErrorEvent.IO_ERROR, this.FailedLoadingUrl);
            this.mURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.FailedLoadingUrl);
            this.mURLLoader.load(request);

            this.mTimer = new Timer(2000, 1);
            this.mTimer.addEventListener(TimerEvent.TIMER, this.FailedLoadingUrl);
            this.mTimer.start();
        }

        private function HttpStatusHandler(event:HTTPStatusEvent):void
        {
            this.mStatus = event.status;
        }

        private function CompleteHandler(event:Event):void
        {
            if (this.mStatus == 200)
            {
                try
                {
                    var response:Object = JSON.parse(String(URLLoader(event.target).data));
                    if (response.assetName != null)
                    {
                        global.eventLoadingScreen = String(response.assetName);
                    }
                    else
                    {
                        global.eventLoadingScreen = defines.DEFAULT_UNDEFINED;
                    };
                }
                catch (error:Error)
                {
                    global.eventLoadingScreen = defines.DEFAULT_UNDEFINED;
                };
            }
            else
            {
                global.eventLoadingScreen = defines.DEFAULT_UNDEFINED;
            };
            this.ResumeLoading();
        }

        private function FailedLoadingUrl(event:Event):void
        {
            global.eventLoadingScreen = defines.DEFAULT_UNDEFINED;
            this.ResumeLoading();
        }

        private function ResumeLoading():void
        {
            if (this.mLoadingResumed)
            {
                return;
            };
            this.mLoadingResumed = true;
            if (this.mTimer != null)
            {
                this.mTimer.stop();
                this.mTimer.removeEventListener(TimerEvent.TIMER, this.FailedLoadingUrl);
                this.mTimer = null;
            };
            if (this.mURLLoader != null)
            {
                this.mURLLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.HttpStatusHandler);
                this.mURLLoader.removeEventListener(Event.COMPLETE, this.CompleteHandler);
                this.mURLLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.FailedLoadingUrl);
                this.mURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.FailedLoadingUrl);
                this.mURLLoader = null;
            };
            this.mResumeLoading();
            this.mResumeLoading = null;
        }
    }
}
