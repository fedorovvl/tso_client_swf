package com.bluebyte.bluefire.puremvc.view
{
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import flash.utils.Timer;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import flash.events.KeyboardEvent;
    import mx.events.ItemClickEvent;
    import mx.collections.SortField;
    import mx.collections.Sort;
    import mx.collections.ArrayCollection;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import flash.ui.Keyboard;
    import com.bluebyte.bluefire.api.controller.TextController;
    import mx.utils.StringUtil;
    import com.bluebyte.bluefire.api.model.vo.OccupantVO;
    import com.bluebyte.bluefire.api.model.vo.ChannelVO;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import mx.events.ListEvent;

    public class ChatPanelMediator extends Mediator implements IMediator 
    {

        public static const NAME:String = "ChatPanelMediator";

        protected var _roomSendCoolDown:Timer = new Timer(5000, 1);
        private var _connectionProxy:ConnectionProxy;

        public function ChatPanelMediator(_arg_1:IChatPanel)
        {
            super(NAME, _arg_1);
            this.panel.messageInput.addEventListener(KeyboardEvent.KEY_UP, this.KeyDown);
            this.panel.mucs.addEventListener(ItemClickEvent.ITEM_CLICK, this.HandleTabClick);
            this.panel.whispers.addEventListener(ItemClickEvent.ITEM_CLICK, this.HandleTabClick);
            var _local_2:SortField = new SortField();
            _local_2.name = "sortingIndex";
            _local_2.caseInsensitive = true;
            _local_2.numeric = true;
            var _local_3:Sort = new Sort();
            _local_3.fields = [_local_2];
            (this.panel.mucs.dataProvider as ArrayCollection).sort = _local_3;
            (this.panel.mucs.dataProvider as ArrayCollection).refresh();
        }

        override public function listNotificationInterests():Array
        {
            return ([BlueFireFacade.ADD_CHANNEL, BlueFireFacade.REMOVE_CHANNEL, BlueFireFacade.ADD_WHISPER, BlueFireFacade.MESSAGE_CREATED_ADDED, BlueFireFacade.REMOVE_WHISPER]);
        }

        override public function onRegister():void
        {
            this._connectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
        }

        private function KeyDown(_arg_1:KeyboardEvent):void
        {
            var _local_3:String;
            var _local_4:MessageVO;
            var _local_5:int;
            var _local_6:Array;
            var _local_7:String;
            if (((this.panel.selectedChannel == null) || (!(this.panel.editable))))
            {
                return;
            };
            var _local_2:String = this.panel.messageInput.text;
            if (this.panel.messageInput.text.substr(0, 1) == "\\")
            {
                _local_2 = ("/" + _local_2.slice(1));
            };
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                if (_local_2 == "")
                {
                    return;
                };
                if (!this._connectionProxy.isJoiningInProgress())
                {
                    if (_local_2.substr(0, 1) == "/")
                    {
                        if (_local_2.substr(0, 5) == "/all ")
                        {
                            if (!this._roomSendCoolDown.running)
                            {
                                this._roomSendCoolDown.reset();
                                this._roomSendCoolDown.start();
                            }
                            else
                            {
                                this.PutMessageToChannelWithoutServer(this.panel.selectedChannel.name, new Date(), "SERVER", TextController.instance.getText("ClientRoomSendCooldown", [(this._roomSendCoolDown.delay / 1000)]), true, false);
                                this.panel.messageInput.setFocus();
                                return;
                            };
                        };
                        sendNotification(BlueFireFacade.EVALUATE_SLASH_COMMAND, _local_2);
                    }
                    else
                    {
                        _local_3 = this.panel.selectedChannel.name;
                        if (((!(_local_3 == "news")) && (!(_local_3 == "whisper"))))
                        {
                            if (((!(this._roomSendCoolDown.running)) || (!(this.RoomIsAffectedByCooldown(_local_3)))))
                            {
                                _local_4 = new MessageVO();
                                _local_4.room = _local_3;
                                _local_4.text = this.panel.messageInput.text;
                                _local_5 = this.panel.mucs.dataProvider.getItemIndex(this.panel.selectedChannel);
                                if (_local_5 != -1)
                                {
                                    _local_4.groupMessage = true;
                                };
                                sendNotification(BlueFireFacade.SEND_MESSAGE, _local_4);
                                if (((this.RoomIsAffectedByCooldown(_local_3)) && (!(this.IsModOrBB(_local_4.sender.name.toLowerCase())))))
                                {
                                    this._roomSendCoolDown.reset();
                                    this._roomSendCoolDown.start();
                                };
                            }
                            else
                            {
                                this.PutMessageToChannelWithoutServer(this.panel.selectedChannel.name, new Date(), "SERVER", TextController.instance.getText("ClientRoomSendCooldown", [(this._roomSendCoolDown.delay / 1000)]), true, false);
                                this.panel.messageInput.setFocus();
                                return;
                            };
                        };
                    };
                };
                this.CleanMessageInput();
                this.panel.messageInput.setFocus();
            }
            else
            {
                if (_local_2.substr(0, 1) == "/")
                {
                    if (_local_2.search(/\/w\s[^\s]+\s/) != -1)
                    {
                        _local_6 = this.panel.messageInput.text.split(" ");
                        _local_7 = StringUtil.trim(_local_6[1]);
                        this.CleanMessageInput();
                        if (_local_6.length > 2)
                        {
                            this.panel.messageInput.text = _local_6[2];
                        };
                        this.ActivatePrivateChat(_local_7);
                        return;
                    };
                    if (_local_2.search(/\/g\s/) != -1)
                    {
                        this.CleanMessageInput();
                    };
                };
            };
        }

        public function PutMessageToChannelWithoutServer(_arg_1:String, _arg_2:Date, _arg_3:String, _arg_4:String, _arg_5:Boolean, _arg_6:Boolean):void
        {
            var _local_7:MessageVO = new MessageVO();
            _local_7.room = _arg_1;
            _local_7.time = _arg_2;
            _local_7.sender = new OccupantVO();
            _local_7.sender.name = _arg_3;
            _local_7.text = _arg_4;
            _local_7.important = _arg_5;
            _local_7.clickable = _arg_6;
            _local_7.groupMessage = true;
            sendNotification(BlueFireFacade.ADD_MESSAGE, _local_7);
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            var _local_2:ChannelVO;
            var _local_3:String;
            var _local_4:ChannelVO;
            var _local_5:int;
            var _local_6:ChannelVO;
            var _local_7:ChannelVO;
            switch (_arg_1.getName())
            {
                case BlueFireFacade.ADD_CHANNEL:
                    _local_2 = (_arg_1.getBody() as ChannelVO);
                    for each (_local_4 in this.panel.mucs.dataProvider)
                    {
                        if (_local_4.name == _local_2.name)
                        {
                            return;
                        };
                    };
                    this.panel.mucs.dataProvider.addItem(_local_2);
                    if (_local_2.name.indexOf("*coop*") < 0)
                    {
                        this.panel.selectedChannel = this.panel.mucs.dataProvider.getItemAt(0);
                    };
                    return;
                case BlueFireFacade.ADD_WHISPER:
                    this.panel.whispers.dataProvider.addItem(_arg_1.getBody());
                    return;
                case BlueFireFacade.REMOVE_WHISPER:
                    this.panel.whispers.dataProvider.removeItemAt(this.panel.whispers.dataProvider.getItemIndex(_arg_1.getBody()));
                    return;
                case BlueFireFacade.REMOVE_CHANNEL:
                    _local_3 = (_arg_1.getBody() as String);
                    _local_5 = 0;
                    while (_local_5 < this.panel.mucs.dataProvider.length)
                    {
                        if ((this.panel.mucs.dataProvider[_local_5] as ChannelVO).name == _local_3)
                        {
                            if (this.panel.mucs.dataProvider.getItemAt(_local_5) == this.panel.selectedChannel)
                            {
                                this.panel.selectedChannel = this.panel.mucs.dataProvider.getItemAt(0);
                            };
                            this.panel.mucs.dataProvider.removeItemAt(_local_5);
                            break;
                        };
                        _local_5++;
                    };
                    return;
                case BlueFireFacade.MESSAGE_CREATED_ADDED:
                    for each (_local_4 in this._connectionProxy.channels)
                    {
                        if (_local_4.hasRoom((_arg_1.getBody() as MessageVO).room))
                        {
                            _local_4.newMessages = true;
                        };
                    };
                    for each (_local_6 in this._connectionProxy.whispers)
                    {
                        if (_local_6.hasRoom((_arg_1.getBody() as MessageVO).room))
                        {
                            _local_6.newMessages = true;
                            this._connectionProxy.getChannel("whisper").newMessages = true;
                            break;
                        };
                    };
                    if (this.panel.selectedChannel)
                    {
                        this.panel.selectedChannel.newMessages = false;
                    };
                    for each (_local_7 in this._connectionProxy.whispers)
                    {
                        if (_local_7 == this.panel.selectedChannel)
                        {
                            this._connectionProxy.getChannel("whisper").newMessages = false;
                            break;
                        };
                    };
                    return;
            };
        }

        private function CleanMessageInput():void
        {
            this.panel.messageInput.text = "";
        }

        public function ActivatePrivateChat(_arg_1:String):void
        {
            this.panel.selectedChannel = this._connectionProxy.getWhisper(_arg_1);
            this.panel.mucs.selectedItem = this._connectionProxy.getChannel("whisper");
            this.panel.whispers.selectedItem = this.panel.selectedChannel;
            this.panel.activateWhisper();
        }

        protected function setRoomSendCooldown(_arg_1:int):void
        {
            this._roomSendCoolDown = new Timer(_arg_1, 1);
        }

        private function IsModOrBB(_arg_1:String):Boolean
        {
            return ((_arg_1.indexOf("mod_") == 0) || (_arg_1.indexOf("bb_") == 0));
        }

        protected function get connectionProxy():ConnectionProxy
        {
            return (this._connectionProxy);
        }

        protected function HandleTabClick(_arg_1:ListEvent):void
        {
            var _local_2:ChannelVO = (_arg_1.itemRenderer.data as ChannelVO);
            _local_2.newMessages = false;
            if (_local_2.name == "whisper")
            {
                this.panel.activateWhisper();
                this.panel.selectedChannel = (this.panel.whispers.selectedItem as ChannelVO);
                if (!this.panel.selectedChannel)
                {
                    this.panel.selectedChannel = _local_2;
                };
            }
            else
            {
                if (this.panel.mucs.dataProvider.getItemIndex(_local_2) != -1)
                {
                    this.panel.deactivateWhisper();
                };
                this.panel.selectedChannel = _local_2;
            };
        }

        private function get panel():IChatPanel
        {
            return (viewComponent as IChatPanel);
        }

        private function RoomIsAffectedByCooldown(_arg_1:String):Boolean
        {
            return (((((_arg_1 == "help") || (_arg_1 == "trade")) || (_arg_1.indexOf("global-") == 0)) || (_arg_1.indexOf("gc_") == 0)) || (_arg_1.indexOf("gco_") == 0));
        }


    }
}
