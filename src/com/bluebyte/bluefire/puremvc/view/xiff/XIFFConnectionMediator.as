package com.bluebyte.bluefire.puremvc.view.xiff
{
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import flash.utils.Timer;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import __AS3__.vec.Vector;
    import org.igniterealtime.xiff.events.MessageEvent;
    import mx.collections.ArrayCollection;
    import org.igniterealtime.xiff.core.XMPPBOSHConnection;
    import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
    import org.igniterealtime.xiff.events.XIFFErrorEvent;
    import org.igniterealtime.xiff.events.LoginEvent;
    import flash.events.TimerEvent;
    import mx.core.Application;
    import flash.events.Event;
    import flash.utils.getTimer;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import com.bluebyte.bluefire.api.enum.ConnectionStatus;
    import com.bluebyte.bluefire.api.extensions.IMessageExtension;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import com.bluebyte.bluefire.api.model.vo.OccupantVO;
    import com.bluebyte.bluefire.api.controller.TextController;
    import org.igniterealtime.xiff.core.XMPPConnection;
    import org.igniterealtime.xiff.auth.Plain;
    import org.igniterealtime.xiff.data.Message;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import __AS3__.vec.*;

    public class XIFFConnectionMediator extends Mediator implements IMediator 
    {

        public static const NAME:String = "XIFFConnectionMediator";
        public static const XIFF_CONNECTION_CREATED:String = "xiffConnectionCreated";
        public static const XIFF_CONNECT:String = "login";
        public static const XIFF_SEND_MESSAGE:String = "xiffSendMessage";
        public static const XIFF_CREATE_NEW_CONNECTION:String = "createNewConnection";
        public static const XIFF_DISCONNECT:String = "closeConnection";

        private var _joiningChatInProgress:Boolean;
        private var _messageQueueLastTime:Number = 0;
        private var _keepAlive:Timer;
        private var _connectionProxy:ConnectionProxy;

        private var _messageQueueTime:Vector.<Number> = new Vector.<Number>();
        private var _messageQueueEvent:Vector.<MessageEvent> = new Vector.<MessageEvent>();
        private var _messageReceiveInterceptors:ArrayCollection = new ArrayCollection();
        private var _messageSendInterceptors:ArrayCollection = new ArrayCollection();

        public function XIFFConnectionMediator()
        {
            super(NAME, new XMPPBOSHConnection());
            this.connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, this.connection_ConnectSuccessHandler);
            this.connection.addEventListener(XIFFErrorEvent.XIFF_ERROR, this.connection_XiffErrorHandler);
            this.connection.addEventListener(LoginEvent.LOGIN, this.connection_LoginHandler);
            this.connection.addEventListener(MessageEvent.MESSAGE, this.connection_MessageHandler);
            this._keepAlive = new Timer(((2 * 60) * 1000));
            this._keepAlive.addEventListener(TimerEvent.TIMER, this.keepAlive_TimerHandler);
            Application.application.addEventListener(Event.ENTER_FRAME, this.application_EnterFrameHandler);
        }

        private function application_EnterFrameHandler(_arg_1:Event):void
        {
            var _local_3:MessageEvent;
            if (this._messageQueueTime.length == 0)
            {
                return;
            };
            var _local_2:Number = getTimer();
            while (((this._messageQueueTime.length > 0) && (this._messageQueueTime[0] < _local_2)))
            {
                this._messageQueueTime.shift();
                _local_3 = this._messageQueueEvent.shift();
                sendNotification(BlueFireFacade.ADD_MESSAGE, this.generateMessage(_local_3));
            };
        }

        private function connection_LoginHandler(_arg_1:LoginEvent):void
        {
            this._connectionProxy.status = ConnectionStatus.LOGGED_IN;
            sendNotification(BlueFireFacade.LOGGED_IN);
        }

        private function connection_ConnectSuccessHandler(_arg_1:ConnectionSuccessEvent):void
        {
            this._connectionProxy.status = ConnectionStatus.LOGGING_IN;
            sendNotification(BlueFireFacade.CONNECTED, this.connection);
            this._keepAlive.start();
        }

        private function createNewConnection():void
        {
            this.disconnect();
            this.connection = new XMPPBOSHConnection();
            this.connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, this.connection_ConnectSuccessHandler);
            this.connection.addEventListener(XIFFErrorEvent.XIFF_ERROR, this.connection_XiffErrorHandler);
            this.connection.addEventListener(LoginEvent.LOGIN, this.connection_LoginHandler);
            this.connection.addEventListener(MessageEvent.MESSAGE, this.connection_MessageHandler);
            this._keepAlive.start();
        }

        private function connection_XiffErrorHandler(_arg_1:XIFFErrorEvent):void
        {
            this._connectionProxy.errorCondition = _arg_1.errorCondition;
            if (_arg_1.errorCondition == "Authentication Error")
            {
                this._connectionProxy.status = ConnectionStatus.LOGIN_FAILED;
            }
            else
            {
                if (_arg_1.errorCondition == "not-authorized")
                {
                    this._connectionProxy.status = ConnectionStatus.SERVER_NOT_AVAILABLE;
                }
                else
                {
                    if (_arg_1.errorCondition == "service-unavailable")
                    {
                        this._connectionProxy.status = ConnectionStatus.SERVER_NOT_AVAILABLE;
                    };
                };
            };
            sendNotification(BlueFireFacade.CONNECTION_ERROR, this._connectionProxy.status);
        }

        private function disconnect():void
        {
            this.connection.removeEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, this.connection_ConnectSuccessHandler);
            this.connection.removeEventListener(XIFFErrorEvent.XIFF_ERROR, this.connection_XiffErrorHandler);
            this.connection.removeEventListener(LoginEvent.LOGIN, this.connection_LoginHandler);
            this.connection.removeEventListener(MessageEvent.MESSAGE, this.connection_MessageHandler);
            this.connection.disconnect();
            this.connection = null;
            this._keepAlive.stop();
            this._connectionProxy.status = ConnectionStatus.SERVER_NOT_AVAILABLE;
        }

        private function get connection():XMPPBOSHConnection
        {
            return (viewComponent as XMPPBOSHConnection);
        }

        override public function listNotificationInterests():Array
        {
            return ([XIFFConnectionMediator.XIFF_CONNECT, XIFFConnectionMediator.XIFF_SEND_MESSAGE, XIFFConnectionMediator.XIFF_CREATE_NEW_CONNECTION, XIFFConnectionMediator.XIFF_DISCONNECT]);
        }

        private function generateMessage(_arg_1:MessageEvent):MessageVO
        {
            var _local_4:*;
            var _local_5:String;
            var _local_6:Array;
            var _local_7:Array;
            var _local_8:IMessageExtension;
            var _local_2:ConnectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
            var _local_3:MessageVO = new MessageVO();
            _local_3.sender = new OccupantVO();
            _local_3.time = new Date();
            for each (_local_4 in _arg_1.data.getAllExtensions())
            {
                if ((_local_4 is IMessageExtension))
                {
                    _local_3.addExtension(_local_4);
                };
            };
            if (_arg_1.data.errorCondition == "item-not-found")
            {
                _local_3.sender.name = "SERVER";
                _local_3.important = true;
                _local_3.room = _arg_1.data.from.localpart;
                _local_3.text = TextController.instance.getText("UserOffline");
                return (_local_3);
            };
            switch (_arg_1.data.type)
            {
                case "error":
                    _local_5 = _arg_1.data.body.split("|")[0];
                    _local_6 = _arg_1.data.body.split("|");
                    _local_6 = _local_6.slice(1);
                    _local_3.text = TextController.instance.getText(_local_5, _local_6);
                    if (_local_3.text == TextController.UNDEFINED)
                    {
                        _local_3.text = _arg_1.data.body;
                    };
                    _local_3.sender.name = "SERVER";
                    _local_3.removeAllExtensions("bbmsg");
                    _local_3.important = true;
                    _local_3.room = _arg_1.data.from.localpart;
                    if (_arg_1.data.from.domain.indexOf("conference") != -1)
                    {
                        _local_3.groupMessage = true;
                    };
                    break;
                case "groupchat":
                    _local_3.groupMessage = true;
                    _local_3.room = ((_arg_1.data.from.localpart + "@") + _arg_1.data.from.domain);
                    if (((_arg_1.data.body == null) && (!(_arg_1.data.subject == null))))
                    {
                        _local_7 = _arg_1.data.from.localpart.split("-");
                        if (_local_7.length > 1)
                        {
                            _local_3.sender.name = TextController.instance.getText("ChatLabelInstance", [("chat" + _local_7[0]), "ChatDelimiter", _local_7[1]]);
                        }
                        else
                        {
                            _local_3.sender.name = TextController.instance.getText(("chat" + _local_7[0]));
                        };
                        if (_local_3.sender.name == TextController.UNDEFINED)
                        {
                            _local_3.sender.name = _arg_1.data.from.localpart;
                        };
                        _local_3.text = TextController.instance.getText("ClientWelcomeRoom", [_local_3.sender.name]);
                    }
                    else
                    {
                        _local_3.sender.clickable = true;
                        _local_8 = _local_3.getExtension("delay");
                        if (((_arg_1.data.from.resource == _local_2.player.name.toLowerCase()) && (!(_local_8))))
                        {
                            return (null);
                        };
                        _local_3.text = _arg_1.data.body;
                        if (_local_3.text == "This room is locked from entry until configuration is confirmed.")
                        {
                            return (null);
                        };
                        if (_local_3.text == "This room is now unlocked.")
                        {
                            return (null);
                        };
                        if (((_arg_1.data.from.resource == null) && (!(_arg_1.data.from.localpart == "reporting"))))
                        {
                            _local_3.sender.name = _local_2.player.name;
                        }
                        else
                        {
                            if (_arg_1.data.from.localpart == "reporting")
                            {
                                _local_3.sender.name = "Reporting";
                            }
                            else
                            {
                                _local_3.sender.name = _arg_1.data.from.resource;
                            };
                        };
                    };
                    break;
                default:
                    if (_arg_1.data.from.toString() == _local_2.server.ip)
                    {
                        _local_3.sender.name = "SERVER";
                        _local_3.text = _arg_1.data.body;
                        _local_3.room = _arg_1.data.from.localpart;
                        sendNotification(BlueFireFacade.MESSAGE_CUSTOMALERT, _local_3);
                        return (null);
                    };
                    _local_3.sender.clickable = true;
                    if (_arg_1.data.body == null)
                    {
                        return (null);
                    };
                    _local_3.text = _arg_1.data.body;
                    _local_3.room = _arg_1.data.from.localpart;
            };
            if (_local_3.room.indexOf("@") != -1)
            {
                _local_3.room = _local_3.room.split("@")[0];
            };
            return (_local_3);
        }

        private function connection_MessageHandler(_arg_1:MessageEvent):void
        {
            var _local_3:Number;
            var _local_2:Number = (100 + ((Math.random() * Math.random()) * 200));
            if (this._messageQueueLastTime < getTimer())
            {
                _local_3 = (getTimer() + _local_2);
            }
            else
            {
                _local_3 = (this._messageQueueLastTime + _local_2);
            };
            this._messageQueueLastTime = _local_3;
            this._messageQueueTime.push(_local_3);
            this._messageQueueEvent.push(_arg_1);
        }

        override public function onRegister():void
        {
            this._connectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            switch (_arg_1.getName())
            {
                case XIFFConnectionMediator.XIFF_CONNECT:
                    this.connection.username = this._connectionProxy.player.name;
                    this.connection.password = this._connectionProxy.player.password;
                    this.connection.port = 443;
                    this.connection.secure = true;
                    this.connection.server = this._connectionProxy.server.ip;
                    sendNotification(XIFFConnectionMediator.XIFF_CONNECTION_CREATED, this.connection);
                    this.connection.disableSASLMechanism("ANONYMOUS");
                    this.connection.disableSASLMechanism("DIGEST-MD5");
                    this.connection.disableSASLMechanism("EXTERNAL");
                    this.connection.enableSASLMechanism("PLAIN", Plain);
                    this.connection.connect(XMPPConnection.STREAM_TYPE_FLASH);
                    return;
                case XIFFConnectionMediator.XIFF_SEND_MESSAGE:
                    this.connection.send((_arg_1.getBody() as Message));
                    return;
                case XIFFConnectionMediator.XIFF_CREATE_NEW_CONNECTION:
                    this.createNewConnection();
                    return;
                case XIFFConnectionMediator.XIFF_DISCONNECT:
                    this.disconnect();
                    return;
            };
        }

        private function keepAlive_TimerHandler(_arg_1:TimerEvent):void
        {
            this.connection.sendKeepAlive();
        }

        private function set connection(_arg_1:XMPPBOSHConnection):void
        {
            viewComponent = _arg_1;
        }


    }
}
