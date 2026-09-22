package com.bluebyte.tso.chat
{
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import com.bluebyte.bluefire.api.model.vo.MessageVOContainer;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import com.bluebyte.bluefire.api.model.vo.ChannelVO;
    import com.bluebyte.bluefire.api.controller.TextController;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class MessageMediator extends Mediator 
    {

        public static const NAME:String = "MessageMediator";

        private var _connectionProxy:ConnectionProxy;
        private var _tsoDataProxy:TSODataProxy;

        public function MessageMediator()
        {
            super(NAME);
        }

        override public function listNotificationInterests():Array
        {
            return ([BlueFireFacade.MESSAGE_CREATED, BlueFireFacade.SEND_MESSAGE_CREATED, BlueFireFacade.MESSAGE_CREATED_ADDED_AFTER]);
        }

        override public function onRegister():void
        {
            this._connectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
            this._tsoDataProxy = (facade.retrieveProxy(TSODataProxy.NAME) as TSODataProxy);
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            var _local_2:MessageVOContainer;
            var _local_3:CustomMessageVO;
            var _local_4:CustomOccupantVO;
            var _local_5:MessageVO;
            var _local_6:SWMMOChatMessage;
            var _local_7:SWMMOChatMessage;
            var _local_8:ChannelVO;
            if (!this._connectionProxy)
            {
                this._connectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
            };
            if (!this._tsoDataProxy)
            {
                this._tsoDataProxy = (facade.retrieveProxy(TSODataProxy.NAME) as TSODataProxy);
            };
            switch (_arg_1.getName())
            {
                case BlueFireFacade.MESSAGE_CREATED:
                    _local_2 = (_arg_1.getBody() as MessageVOContainer);
                    _local_2.message = new CustomMessageVO(_local_2.message);
                    _local_3 = (_local_2.message as CustomMessageVO);
                    _local_4 = new CustomOccupantVO(_local_3.sender);
                    if (_local_3.getExtension("bbmsg"))
                    {
                        _local_7 = (_local_3.getExtension("bbmsg") as SWMMOChatMessage);
                        if (_local_7 != null)
                        {
                            _local_4.id = _local_7.mPlayerID;
                            _local_4.name = _local_7.mPlayerName;
                            _local_4.tag = _local_7.mPlayerTag;
                            if ((((_local_4.tag == "null") || (_local_3.room.indexOf("gc_") == 0)) || (_local_3.room.indexOf("gco_") == 0)))
                            {
                                _local_4.tag = "";
                            };
                            if ((((_local_4.id == 0) && (_local_4.name == null)) && (!(_local_4.tag == null))))
                            {
                                _local_4.name = _local_4.tag;
                                _local_4.tag = null;
                            };
                            _local_3.clickable = true;
                        }
                        else
                        {
                            _local_3.clickable = false;
                        };
                    };
                    _local_3.sender = _local_4;
                    if (((!(_local_3.groupMessage)) && (_local_3.room.toLowerCase() == _local_3.sender.name.toLowerCase())))
                    {
                        _local_3.room = _local_3.sender.name;
                    };
                    if (_local_3.groupMessage)
                    {
                        if ((((((_local_3.text) && (this._connectionProxy)) && (this._connectionProxy.player)) && (this._connectionProxy.player.name)) && (!(_local_3.text.toLowerCase().indexOf(this._connectionProxy.player.name.toLowerCase()) == -1))))
                        {
                            _local_3.ownname = true;
                            this._connectionProxy.getChannel(_local_3.room.split("@")[0]).newMessages = false;
                            this._connectionProxy.getChannel(_local_3.room.split("@")[0]).important = true;
                            this._connectionProxy.getChannel(_local_3.room.split("@")[0]).newMessages = true;
                        };
                    };
                    if (((_local_3.sender.name.toLowerCase().indexOf("bb_") == 0) || (_local_3.sender.name.toLowerCase().indexOf("ubi_") == 0)))
                    {
                        _local_3.bluebyte = true;
                    }
                    else
                    {
                        if (_local_3.sender.name.toLowerCase().indexOf("mod_") == 0)
                        {
                            _local_3.moderator = true;
                        }
                        else
                        {
                            if (_local_3.sender.name.toLowerCase().indexOf("cl_") == 0)
                            {
                                _local_3.communityLead = true;
                            };
                        };
                    };
                    return;
                case BlueFireFacade.MESSAGE_CREATED_ADDED_AFTER:
                    _local_3 = new CustomMessageVO((_arg_1.getBody() as MessageVO));
                    _local_5 = (_arg_1.getBody() as MessageVO);
                    if (_local_5.text.indexOf(TextController.instance.getText("ClientWelcomeRoom", [_local_5.sender.name])) != -1)
                    {
                        for each (_local_8 in this._connectionProxy.channels)
                        {
                            if (_local_8.hasRoom((_arg_1.getBody() as MessageVO).room))
                            {
                                _local_8.newMessages = false;
                            };
                        };
                    };
                    return;
                case BlueFireFacade.SEND_MESSAGE_CREATED:
                    _local_2 = (_arg_1.getBody() as MessageVOContainer);
                    _local_2.message = new CustomMessageVO(_local_2.message);
                    _local_3 = (_local_2.message as CustomMessageVO);
                    _local_6 = new SWMMOChatMessage();
                    _local_6.mPlayerID = this._connectionProxy.player.id;
                    _local_6.mPlayerName = this._connectionProxy.player.name;
                    _local_6.mPlayerTag = this._tsoDataProxy.playerTag;
                    _local_3.addExtension(_local_6);
                    return;
            };
        }


    }
}
