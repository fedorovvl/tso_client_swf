package ServerState
{
    import flash.utils.Dictionary;
    import mx.rpc.remoting.RemoteObject;
    import nLib.cLog;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.utils.getTimer;
    import mx.messaging.ChannelSet;
    import mx.messaging.Channel;
    import mx.messaging.channels.AMFChannel;
    import mx.messaging.channels.SecureAMFChannel;

    public class cConnectionManager 
    {

        private static const DEST_SMC:String = "SMC";
        private static const DEST_PLAYER:String = "PLAYER";
        private static const DEST_MAIL:String = "MAIL";
        private static const DEST_LOGS:String = "LOGS";
        private static const DEST_GUILD:String = "GUILD";
        private static const DEST_TRADEWINDOW:String = "TRADE";
        private static const EVENT_HANDLER:String = "com.bluebyte.game.servlet.EventHandler";
        private static const PLAYER_HANDLER:String = "com.bluebyte.game.servlet.PlayerHandler";
        private static const MAIL_HANDLER:String = "com.bluebyte.game.servlet.MailHandler";
        private static const GUILD_HANDLER:String = "com.bluebyte.game.servlet.GuildHandler";
        private static const TRADEWINDOW_HANDLER:String = "com.bluebyte.game.servlet.TradeWindowHandler";
        private static const ENDPOINT:String = "SMC-Endpoint";
        private static const DICT:Dictionary = new Dictionary();
        private static var mInstance:cConnectionManager;

        public var mRemoteService:RemoteObject;
        public var mPlayerService:RemoteObject;
        public var mTradeWindowService:RemoteObject;
        public var mGuildService:RemoteObject;
        public var mMailService:RemoteObject;
        private var mServerName:String = "";

        public function cConnectionManager(_arg_1:cSingletonEnforcer)
        {
            super();
            if (_arg_1 == null)
            {
                throw (new Error("cConnectionManager is a Singleton. Use GetInstance() to use this class."));
            };
        }

        public static function GetInstance():cConnectionManager
        {
            if (mInstance == null)
            {
                mInstance = new cConnectionManager(new cSingletonEnforcer());
            };
            return (mInstance);
        }


        private function KeepAliveErrorHandler(_arg_1:Event):void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info("Error sending keep alive ping.");
            };
        }

        public function SendKeepAlivePing():int
        {
            var request:URLRequest;
            var loader:URLLoader;
            if (definesMaster.MASTER_VERSION)
            {
                try
                {
                    request = new URLRequest(defines.KEEP_ALIVE_URL);
                    loader = new URLLoader();
                    loader.load(request);
                    loader.addEventListener(IOErrorEvent.IO_ERROR, this.KeepAliveErrorHandler);
                    loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.KeepAliveErrorHandler);
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Sending keep alive ping to: " + defines.KEEP_ALIVE_URL));
                    };
                }
                catch(e:Error)
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info("Error sending keep alive ping.");
                    };
                };
            };
            return (getTimer() + ((defines.KEEP_ALIVE_INTERVAL * 60) * 1000));
        }

        public function CreateServices(_arg_1:String):void
        {
            var _local_2:ChannelSet;
            var _local_3:Channel;
            if (this.mServerName != _arg_1)
            {
                this.mRemoteService = new RemoteObject();
                this.mMailService = new RemoteObject();
                this.mPlayerService = new RemoteObject();
                this.mGuildService = new RemoteObject();
                this.mTradeWindowService = new RemoteObject();
                if (DICT[_arg_1] == null)
                {
                    _local_2 = new ChannelSet();
                    if (_arg_1 != null && _arg_1.indexOf("https://") == 0)
                    {
                        _local_3 = new SecureAMFChannel(ENDPOINT, _arg_1);
                    }
                    else
                    {
                        _local_3 = new AMFChannel(ENDPOINT, _arg_1);
                    };
                    _local_2.addChannel(_local_3);
                    DICT[_arg_1] = _local_2;
                };
                this.mRemoteService.channelSet = DICT[_arg_1];
                this.mRemoteService.destination = DEST_SMC;
                this.mRemoteService.source = EVENT_HANDLER;
                this.mMailService.channelSet = DICT[_arg_1];
                this.mMailService.destination = DEST_MAIL;
                this.mMailService.source = MAIL_HANDLER;
                this.mPlayerService.channelSet = DICT[_arg_1];
                this.mPlayerService.destination = DEST_PLAYER;
                this.mPlayerService.source = PLAYER_HANDLER;
                this.mGuildService.channelSet = DICT[_arg_1];
                this.mGuildService.destination = DEST_GUILD;
                this.mGuildService.source = GUILD_HANDLER;
                this.mTradeWindowService.channelSet = DICT[_arg_1];
                this.mTradeWindowService.destination = DEST_TRADEWINDOW;
                this.mTradeWindowService.source = TRADEWINDOW_HANDLER;
                this.mServerName = _arg_1;
            };
        }


    }
}//package ServerState

class cSingletonEnforcer 
{

    public function cSingletonEnforcer()
    {
        super();
    }

}


