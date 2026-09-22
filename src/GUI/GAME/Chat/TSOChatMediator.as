package GUI.GAME.Chat
{
    import com.bluebyte.bluefire.puremvc.view.ChatPanelMediator;
    import Communication.VO.HandShakeVO;
    import flash.utils.Timer;
    import com.bluebyte.tso.chat.TSODataProxy;
    import com.bluebyte.bluefire.puremvc.view.IChatPanel;
    import flash.events.TimerEvent;
    import __AS3__.vec.Vector;
    import nLib.cXML;
    import nLib.gMisc;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import com.bluebyte.bluefire.api.model.vo.RoomJoinRequestVO;
    import GUI.Components.ChatPanel;
    import com.bluebyte.tso.util.ClientLogger;
    import com.bluebyte.bluefire.api.model.vo.PlayerVO;
    import Interface.cGameInterface;
    import flash.events.FocusEvent;
    import com.bluebyte.bluefire.api.enum.ConnectionStatus;
    import com.bluebyte.bluefire.api.model.vo.ChannelVO;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import com.bluebyte.tso.chat.SlashCommandMediator;
    import com.bluebyte.tso.chat.SlashCommandsMediator;
    import com.bluebyte.tso.chat.MessageMediator;
    import flash.events.TextEvent;
    import GUI.Components.ItemRenderer.ChatTabPrivateListItemRenderer;
    import flash.events.Event;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import com.bluebyte.bluefire.api.controller.TextController;
    import flash.events.MouseEvent;
    import com.bluebyte.bluefire.api.model.vo.RoomPresenceUpdatedVO;
    import com.bluebyte.bluefire.api.model.vo.PresenceUpdatedVO;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import com.bluebyte.bluefire.api.model.vo.RoomVO;
    import com.bluebyte.bluefire.api.model.vo.MessageVOContainer;
    import com.bluebyte.tso.chat.DelayExtension;
    import ServerState.cClientMessagesII;
    import mx.rpc.events.FaultEvent;
    import com.bluebyte.bluefire.puremvc.view.xiff.XIFFConnectionMediator;
    import Utils.StringUtils;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Sound.cSoundManager;
    import Enums.COMMAND;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import Communication.VO.Guild.dGuildVO;
    import com.bluebyte.bluefire.api.model.vo.ServerVO;
    import Interface.cGeneralInterface;
    import mx.utils.URLUtil;
    import mx.events.CloseEvent;
    import Communication.VO.dPlayerListItemVO;
    import mx.events.ListEvent;

    public class TSOChatMediator extends ChatPanelMediator 
    {

        public static var received:int = 0;
        public static const COOP_NAME_MY:String = "coopMy";
        public static const COOP_NAME_FRIENDS:String = "coopFriends";
        private static var _userNotified:Boolean;
        private static var mHandShakeObject:HandShakeVO;
        private static var channelNotifications:Object;
        private static var reconnectTimer:Timer = null;

        private var _myCoopChannelAdventureID:int = 0;
        private var _connectionCreationInProgress:Boolean = false;
        private var _guildChannelJoined:Boolean = false;
        private var _friendsCoopChannelJoined:Boolean = false;
        private var _officersChannelJoined:Boolean = false;
        private var _friendsCoopChannelAdventureID:int = 0;
        private var _tsoDataProxy:TSODataProxy;
        private var _myCoopChannelJoined:Boolean = false;
        private var _connectionEstablished:Boolean = false;
        private var _tabSortingIndices:Object = new Object();

        public function TSOChatMediator(_arg_1:IChatPanel)
        {
            super(_arg_1);
            _roomSendCoolDown = new Timer(global.chatRoomSendCooldown, 1);
        }

        public static function InitChat(_arg_1:Boolean):void
        {
            if (((!(globalFlash.gui.mChatPanel == null)) && (globalFlash.gui.mChatPanel.connectionEstablished)))
            {
                return;
            };
            if (reconnectTimer == null)
            {
                reconnectTimer = new Timer(global.chatReconnectInterval, 0);
                reconnectTimer.addEventListener(TimerEvent.TIMER, reconnectToChatTimer);
                reconnectTimer.start();
                _userNotified = false;
            };
            if (_arg_1)
            {
                reconnectToChatTimer(null);
            };
        }

        public static function registerChannelNotifications(_arg_1:cXML):void
        {
            var _local_2:Vector.<cXML>;
            var _local_3:cXML;
            channelNotifications = new Object();
            if (_arg_1 != null)
            {
                _local_2 = _arg_1.CreateChildrenArray();
                for each (_local_3 in _local_2)
                {
                    channelNotifications[_local_3.GetAttributeString_string("channel").toLowerCase()] = _local_3.GetAttributeString_string("notification");
                };
            };
        }

        public static function setHandShakeObject(_arg_1:HandShakeVO):void
        {
            if (defines.CLIENT_ZONEID != 0)
            {
                return;
            };
            mHandShakeObject = _arg_1;
            received = 1;
            gMisc.CheatWindowConsoleOut(("chat connection received " + _arg_1));
            reconnectToChatTimer(null);
        }

        public static function reconnectToChatTimer(_arg_1:TimerEvent):void
        {
            if (globalFlash.gui.mChatPanel != null)
            {
                globalFlash.gui.mChatPanel.Reconnect(mHandShakeObject);
            };
        }


        private function KeyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
            };
        }

        public function joinFriendsCoopAdventureChatrom(_arg_1:int):void
        {
            this._friendsCoopChannelAdventureID = _arg_1;
            sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO((defines.COOP_ADVENTURE_CHATROOM_PREFIX + Math.abs(this._friendsCoopChannelAdventureID))));
            this._friendsCoopChannelJoined = true;
        }

        protected function get panel():ChatPanel
        {
            return (viewComponent as ChatPanel);
        }

        public function leaveMyCoopAdventureChatroom():void
        {
            if (this._myCoopChannelJoined)
            {
                try
                {
                    sendNotification(BlueFireFacade.ROOM_LEAVE, (defines.COOP_ADVENTURE_CHATROOM_PREFIX + Math.abs(this._myCoopChannelAdventureID)));
                    this._myCoopChannelJoined = false;
                }
                catch(e:Error)
                {
                    ClientLogger.error(e);
                };
            };
        }

        public function setPlayerName(_arg_1:String):void
        {
            if (!connectionProxy.player)
            {
                connectionProxy.player = new PlayerVO();
            };
            connectionProxy.player.name = _arg_1;
        }

        public function Show():void
        {
            this.panel.visible = true;
        }

        private function handleFocusOut(_arg_1:FocusEvent):void
        {
            (global.ui as cGameInterface).ActivateChatWindow(false);
        }

        public function changeTradeChannelStatus():void
        {
            if (connectionProxy.status != ConnectionStatus.LOGGED_IN)
            {
                return;
            };
            if (global.ui.mCurrentPlayer.GetPlayerId() == global.ui.mHomePlayer.GetPlayerId())
            {
                if (global.ui.mCurrentPlayerZone.mStreetDataMap.GetLogisticsHouse() != null)
                {
                    sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO("trade"));
                }
                else
                {
                    sendNotification(BlueFireFacade.ROOM_LEAVE, "trade");
                };
            };
        }

        public function addChannel(_arg_1:String, _arg_2:Array, _arg_3:Boolean, _arg_4:int, _arg_5:String=null):void
        {
            var _local_7:String;
            var _local_6:ChannelVO = new ChannelVO();
            _local_6.name = _arg_1;
            _local_6.label = _arg_5;
            if (!_local_6.label)
            {
                _local_6.label = _local_6.name;
            };
            for each (_local_7 in _arg_2)
            {
                _local_6.addRoom(_local_7);
            };
            _local_6.visible = _arg_3;
            _local_6.sortingIndex = _arg_4;
            facade.sendNotification(BlueFireFacade.ADD_CHANNEL, _local_6);
        }

        public function IsFriendsCoopChatroomOpen():Boolean
        {
            return (this._friendsCoopChannelJoined);
        }

        override public function onRegister():void
        {
            var _local_2:String;
            var _local_3:String;
            super.onRegister();
            this._tsoDataProxy = new TSODataProxy();
            facade.registerProxy(this._tsoDataProxy);
            ConnectionProxy.VERSION = defines["VERSION_INFO"];
            facade.registerMediator(new SlashCommandMediator());
            facade.registerMediator(new SlashCommandsMediator(this.panel));
            facade.registerMediator(new MessageMediator());
            facade.sendNotification(BlueFireFacade.UPDATE_ROOM_GROUP_SEPERATOR, "-");
            global.getApplication().GAMESTATE_ID_CHAT_PANEL = this.panel;
            globalFlash.gui.mChatPanel = this;
            global.getApplication().blueFireComponent.visible = true;
            this.panel.messageHistory.addEventListener(TextEvent.LINK, this.HandleLink);
            this.panel.whispers.addEventListener(ChatTabPrivateListItemRenderer.PRIVATE_LIST_REMOVE, this.whispers_RemoveHandler);
            this.panel.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
            var _local_1:Object = cLocaManager.GetInstance().GetGroup(LOCA_GROUP.CHAT_MESSAGES);
            for (_local_2 in _local_1)
            {
                TextController.instance.registerIdentifier(_local_2, _local_1[_local_2]);
            };
            _local_1 = cLocaManager.GetInstance().GetGroup(LOCA_GROUP.LABELS);
            for (_local_3 in _local_1)
            {
                TextController.instance.registerIdentifier(_local_3, _local_1[_local_3]);
            };
            this._tabSortingIndices["global"] = 0;
            this._tabSortingIndices["help"] = 1;
            this._tabSortingIndices["trade"] = 2;
            this._tabSortingIndices["gc"] = 3;
            this._tabSortingIndices["gco"] = 4;
            this._tabSortingIndices["findcoop"] = 5;
            this._tabSortingIndices["whisper"] = 6;
            this._tabSortingIndices["news"] = 7;
            this._tabSortingIndices["all"] = 8;
            this._tabSortingIndices[COOP_NAME_MY] = 9;
            this._tabSortingIndices[COOP_NAME_FRIENDS] = 10;
            this.panel.messageInput.addEventListener(KeyboardEvent.KEY_UP, this.KeyDown);
            this.panel.addEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
        }

        public function IsConnectionEstablished():Boolean
        {
            return ((reconnectTimer == null) || (!(received)));
        }

        private function HandleMessageHistoryStopClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            _arg_1.preventDefault();
            this.panel.messageHistory.removeEventListener(MouseEvent.CLICK, this.HandleMessageHistoryStopClick);
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            var _local_2:RoomPresenceUpdatedVO;
            var _local_3:PresenceUpdatedVO;
            var _local_4:MessageVO;
            var _local_5:String;
            var _local_6:Array;
            var _local_7:int;
            var _local_8:int;
            var _local_9:ChannelVO;
            var _local_10:int;
            var _local_11:ChannelVO;
            var _local_12:int;
            var _local_13:RoomVO;
            var _local_14:Array;
            var _local_15:String;
            var _local_16:int;
            var _local_17:String;
            var _local_18:Boolean;
            var _local_19:String;
            var _local_20:int;
            var _local_21:MessageVOContainer;
            var _local_22:DelayExtension;
            var _local_23:Date;
            var _local_24:MessageVO;
            var _local_25:int;
            var _local_26:String;
            var _local_27:cGameInterface;
            var _local_28:String;
            var _local_29:int;
            var _local_30:ChannelVO;
            super.handleNotification(_arg_1);
            switch (_arg_1.getName())
            {
                case BlueFireFacade.ADD_CHANNEL:
                case BlueFireFacade.REMOVE_CHANNEL:
                    this.panel.mucs.dataProvider.refresh();
                    return;
                case BlueFireFacade.CONNECTION_ERROR:
                    this._connectionCreationInProgress = false;
                    this._connectionEstablished = false;
                    _local_7 = (_arg_1.getBody() as int);
                    switch (_local_7)
                    {
                        case ConnectionStatus.LOGIN_FAILED:
                            PutMessageToChannelWithoutServer("news", new Date(), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "chatnews"), cLocaManager.GetInstance().GetText(LOCA_GROUP.CHAT_MESSAGES, "ClientLoginFailed"), false, false);
                            _local_8 = 0;
                            while (_local_8 < connectionProxy.channels.length)
                            {
                                _local_9 = connectionProxy.channels[_local_8];
                                if (_local_9.name != "news")
                                {
                                    sendNotification(BlueFireFacade.REMOVE_CHANNEL, _local_9.name);
                                    _local_8--;
                                };
                                _local_8++;
                            };
                            this.panel.chatstatusbox.visible = false;
                            this.panel.chatInput.visible = false;
                            this.panel.selectedChannel = connectionProxy.getChannel("news");
                            cClientMessagesII.LogMessageToBigBrother(new FaultEvent(((("Chat/LOGIN_FAILED " + _arg_1.getName()) + "/") + connectionProxy.errorCondition)));
                            this.stopConnecting();
                            break;
                        case ConnectionStatus.SERVER_NOT_AVAILABLE:
                            this._connectionEstablished = false;
                            if (!_userNotified)
                            {
                                _userNotified = true;
                                PutMessageToChannelWithoutServer("news", new Date(), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "chatnews"), cLocaManager.GetInstance().GetText(LOCA_GROUP.CHAT_MESSAGES, "ClientNoServer"), false, false);
                            };
                            _local_10 = 0;
                            while (_local_10 < connectionProxy.channels.length)
                            {
                                _local_11 = connectionProxy.channels[_local_10];
                                if (_local_11.name != "news")
                                {
                                    sendNotification(BlueFireFacade.REMOVE_CHANNEL, _local_11.name);
                                    _local_10--;
                                };
                                _local_10++;
                            };
                            this._guildChannelJoined = false;
                            this._officersChannelJoined = false;
                            this.panel.chatstatusbox.visible = true;
                            this.panel.chatInput.visible = false;
                            this.panel.selectedChannel = connectionProxy.getChannel("news");
                            cClientMessagesII.LogMessageToBigBrother(new FaultEvent(((("Chat/SERVER_NOT_AVAILABLE " + _arg_1.getName()) + "/") + connectionProxy.errorCondition)));
                            InitChat(false);
                            break;
                        case ConnectionStatus.TRYING_TO_CONNECT:
                            this._connectionEstablished = false;
                            this.panel.chatstatusbox.visible = true;
                            cClientMessagesII.LogMessageToBigBrother(new FaultEvent(((("Chat/TRYING_TO_CONNECT " + _arg_1.getName()) + "/") + connectionProxy.errorCondition)));
                            InitChat(false);
                            break;
                    };
                    return;
                case BlueFireFacade.ROOM_OCCUPANT_PRESENCE_UPDATED:
                    _local_2 = (_arg_1.getBody() as RoomPresenceUpdatedVO);
                    globalFlash.gui.mFriendsList.SetOnlineStatus(_local_2.name.toLowerCase(), _local_2.online, true);
                    return;
                case BlueFireFacade.FRIEND_PRESENCE_UPDATED:
                    _local_3 = (_arg_1.getBody() as PresenceUpdatedVO);
                    global.ui.channels.ZONE.send("CHAT_MESSAGE", _local_3);
                    globalFlash.gui.mFriendsList.SetOnlineStatus(_local_3.name.toLowerCase(), _local_3.online, false);
                    return;
                case XIFFConnectionMediator.XIFF_CONNECT:
                    this.panel.chatstatusbox.visible = true;
                    this._connectionCreationInProgress = false;
                    return;
                case BlueFireFacade.CONNECTED:
                    this.panel.chatstatusbox.visible = false;
                    this._connectionCreationInProgress = false;
                    return;
                case BlueFireFacade.LOGGED_IN:
                    this._connectionEstablished = true;
                    _local_12 = cSettingsManager.getInstance().currentGlobalChatInstance;
                    this.stopConnecting();
                    if (_local_12 != 0)
                    {
                        sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO(("global-" + _local_12)));
                    }
                    else
                    {
                        this.joinGlobalRoomDependingOnCountry();
                    };
                    sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO("help"));
                    sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO("findcoop"));
                    this.changeTradeChannelStatus();
                    global.ui.joinGuildChannels();
                    if ((((global.ui.mRequirements.miscRequirements_vector["ChatUnlock"].isFulfilled()) || (StringUtils.startsWith(global.ui.mCurrentPlayer.GetPlayerName_string(), "BB_"))) || (StringUtils.startsWith(global.ui.mCurrentPlayer.GetPlayerName_string(), "MOD_"))))
                    {
                        this.panel.chatInput.editable = true;
                        this.panel.chatInput.text = "";
                        this.panel.chatInput.toolTip = "";
                    };
                    return;
                case BlueFireFacade.ROOM_JOINED:
                    _local_13 = (_arg_1.getBody() as RoomVO);
                    _local_14 = _local_13.name.split("-");
                    if (_local_14.length > 1)
                    {
                        _local_15 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ChatLabelInstance", [("chat" + _local_14[0]), "ChatDelimiter", _local_14[1]]);
                        cSettingsManager.getInstance().currentGlobalChatInstance = _local_14[1];
                        cSettingsManager.getInstance().saveToServer();
                    }
                    else
                    {
                        _local_15 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("chat" + _local_14[0]));
                    };
                    if (_local_13.name.indexOf("gc_") == 0)
                    {
                        _local_15 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "chatguild");
                    }
                    else
                    {
                        if (_local_13.name.indexOf("gco_") == 0)
                        {
                            _local_15 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "chatofficers");
                        };
                    };
                    _local_16 = 0;
                    _local_17 = _local_13.name.toLowerCase().split("_")[0].split("-")[0];
                    if (_local_13.name.indexOf("findco") == 0)
                    {
                        _local_15 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "chatfindcooperation");
                    };
                    if (_local_13.name.indexOf(defines.COOP_ADVENTURE_CHATROOM_PREFIX) == 0)
                    {
                        _local_19 = _local_13.name.substr(defines.COOP_ADVENTURE_CHATROOM_PREFIX.length, (_local_13.name.length - defines.COOP_ADVENTURE_CHATROOM_PREFIX.length));
                        _local_20 = -(parseInt(_local_19));
                        if (!isNaN(_local_20))
                        {
                            if (AdventureManager.getInstance().getAdventure(_local_20).ownerPlayerID != global.ui.mCurrentPlayer.getPlayerID())
                            {
                                _local_15 = ("frAdv" + AdventureManager.getInstance().getAdventure(_local_20).adventureName);
                                _local_17 = COOP_NAME_FRIENDS;
                            }
                            else
                            {
                                _local_15 = ("myAdv" + AdventureManager.getInstance().getAdventure(_local_20).adventureName);
                                _local_17 = COOP_NAME_MY;
                            };
                        };
                    };
                    if (this._tabSortingIndices.hasOwnProperty(_local_17))
                    {
                        _local_16 = this._tabSortingIndices[_local_17];
                    };
                    _local_18 = true;
                    this.addChannel(_local_13.name, [_local_13.name], _local_18, _local_16, _local_15);
                    this.UpdateChannelInfoDisplay();
                    return;
                case BlueFireFacade.ROOM_LEFT:
                    if (StringUtils.startsWith((_arg_1.getBody() as String), "gco_"))
                    {
                        this.leaveOfficesChannel();
                    };
                    sendNotification(BlueFireFacade.REMOVE_CHANNEL, _arg_1.getBody());
                    return;
                case BlueFireFacade.MESSAGE_CREATED:
                    _local_21 = (_arg_1.getBody() as MessageVOContainer);
                    global.ui.channels.ZONE.send("CHAT_MESSAGE", _local_21.message);
                    if (_local_21.message.text.indexOf(TextController.instance.getText("ClientWelcomeRoom", [_local_21.message.sender.name])) != -1)
                    {
                        _local_21.message.time = null;
                    }
                    else
                    {
                        if (((!(_local_21 == null)) && (_local_21.message.getExtension(DelayExtension.ELEMENT_NAME))))
                        {
                            _local_22 = (_local_21.message.getExtension(DelayExtension.ELEMENT_NAME) as DelayExtension);
                            _local_23 = _local_22.mSendDate;
                            if (_local_23)
                            {
                                _local_21.message.time = _local_23;
                            };
                        };
                    };
                    return;
                case BlueFireFacade.MESSAGE_CREATED_ADDED:
                    _local_24 = (_arg_1.getBody() as MessageVO);
                    if (TextController.instance.getText("ClientWelcomeRoom", [_local_24.sender.name]))
                    {
                        if (_local_24.sender.name.indexOf("gc_") == 0)
                        {
                            _local_24.sender.name = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "chatguild");
                            _local_24.text = global.ui.GetCurrentPlayerGuild().motd;
                        }
                        else
                        {
                            if (_local_24.sender.name.indexOf("gco_") == 0)
                            {
                                _local_24.sender.name = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "chatofficers");
                                _local_24.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.CHAT_MESSAGES, "ClientWelcomeOfficers");
                            };
                        };
                    };
                    if ((((!(_local_24.groupMessage)) && (!(this.panel.selectedChannel.name.toLowerCase() == _local_24.sender.name.toLowerCase()))) && (!(global.ui.mCurrentPlayer.GetPlayerName_string().toLowerCase() == _local_24.sender.name.toLowerCase()))))
                    {
                        cSoundManager.getInstance().playEffect("ChatWhisper");
                    };
                    if (((!(_local_24.text == null)) && (_local_24.text.indexOf("/unblock") == 0)))
                    {
                        _local_25 = _local_24.text.indexOf(" ");
                        if (_local_25 != -1)
                        {
                            _local_26 = _local_24.text.substr((_local_25 + 1));
                            _local_27 = (global.ui as cGameInterface);
                            _local_27.mClientMessages.SendMessagetoServer(COMMAND.UNBLOCK_SENDER, _local_27.mCurrentViewedZoneID, _local_26);
                        };
                    };
                    return;
                case BlueFireFacade.MESSAGE_CUSTOMALERT:
                    _local_4 = (_arg_1.getBody() as MessageVO);
                    _local_5 = "";
                    _local_6 = _local_4.text.split("|");
                    if (_local_6.length > 1)
                    {
                        _local_28 = _local_6[0];
                        _local_6 = _local_6.slice(1);
                        _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.CHAT_MESSAGES, _local_28, _local_6);
                    }
                    else
                    {
                        _local_5 = _local_4.text;
                    };
                    CustomAlert.show(_local_5, _local_4.sender.name, Alert.OK, null, null, null, 4, false);
                    return;
                case BlueFireFacade.LEAVE_CHAT:
                    if (((connectionProxy.player.name.toLowerCase().indexOf("bb_") == 0) || (connectionProxy.player.name.toLowerCase().indexOf("mod_") == 0)))
                    {
                        _local_29 = 0;
                        while (_local_29 < connectionProxy.channels.length)
                        {
                            _local_30 = connectionProxy.channels[_local_29];
                            if (_local_30.name != "news")
                            {
                                sendNotification(BlueFireFacade.REMOVE_CHANNEL, _local_30.name);
                                _local_29--;
                            };
                            _local_29++;
                        };
                        sendNotification(XIFFConnectionMediator.XIFF_DISCONNECT);
                        this.panel.chatstatusbox.visible = false;
                        this.panel.chatInput.visible = false;
                        this.panel.selectedChannel = connectionProxy.getChannel("news");
                        this._guildChannelJoined = false;
                        this._officersChannelJoined = false;
                    };
                    return;
            };
        }

        public function sendIgnoreChatMessage(_arg_1:String):void
        {
            var _local_2:MessageVO = new MessageVO();
            _local_2.room = this.panel.selectedChannel.name;
            _local_2.text = ("/ignoreadd " + _arg_1);
            _local_2.groupMessage = true;
            sendNotification(BlueFireFacade.SEND_MESSAGE, _local_2);
        }

        private function InputFocusInHandler(_arg_1:FocusEvent):void
        {
            (global.ui as cGameInterface).ActivateChatWindow(true);
            if (this.panel.messageInput.text == cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ChatInputHelp"))
            {
                this.panel.messageInput.text = "";
            };
        }

        public function Refresh():void
        {
            if ((((global.ui.mRequirements.miscRequirements_vector["ChatUnlock"].isFulfilled()) || (StringUtils.startsWith(global.ui.mCurrentPlayer.GetPlayerName_string(), "BB_"))) || (StringUtils.startsWith(global.ui.mCurrentPlayer.GetPlayerName_string(), "MOD_"))))
            {
                this.panel.chatInput.editable = true;
                this.panel.chatInput.text = "";
                this.panel.chatInput.toolTip = "";
            };
        }

        public function joinOfficersChannel(_arg_1:dGuildVO):void
        {
            if (connectionProxy.status != ConnectionStatus.LOGGED_IN)
            {
                return;
            };
            if (!this._officersChannelJoined)
            {
                facade.sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO(("gco_" + _arg_1.id)));
            };
            this._officersChannelJoined = true;
            if (this._tsoDataProxy.playerTag == "")
            {
                this.setGuildTag(_arg_1.tag);
            };
        }

        protected function handleEnterFrame(_arg_1:Event):void
        {
        }

        public function Reconnect(_arg_1:HandShakeVO):void
        {
            var _local_2:ServerVO;
            if (this._connectionCreationInProgress)
            {
                return;
            };
            if ((((mHandShakeObject == null) || (mHandShakeObject.chatPassword == null)) || (mHandShakeObject.chatConnection == null)))
            {
                return;
            };
            if (global.ui.mCurrentPlayer.GetPlayerId() == 0)
            {
                return;
            };
            if (!globalFlash.gui.mFriendsList.IsLoaded())
            {
                return;
            };
            if (cGeneralInterface.isDefaultPlayerName(mHandShakeObject.chatName))
            {
                return;
            };
            if (!connectionProxy.player)
            {
                connectionProxy.player = new PlayerVO();
                connectionProxy.player.name = _arg_1.chatName;
            };
            if (connectionProxy.player.id == 0)
            {
                connectionProxy.player.id = global.ui.mCurrentPlayer.GetPlayerId();
                connectionProxy.player.password = _arg_1.chatPassword;
                _local_2 = new ServerVO();
                _local_2.port = URLUtil.getPort(_arg_1.chatConnection);
                _local_2.ip = URLUtil.getServerName(_arg_1.chatConnection);
                facade.sendNotification(BlueFireFacade.UPDATE_SERVER_DATA, _local_2);
            }
            else
            {
                connectionProxy.player.password = _arg_1.chatPassword;
                facade.sendNotification(XIFFConnectionMediator.XIFF_CREATE_NEW_CONNECTION);
            };
            this.addChannel("news", ["news"], true, this._tabSortingIndices["news"], cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ChatNews"));
            this.addChannel("whisper", [], true, this._tabSortingIndices["whisper"], cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ChatWhisper"));
            facade.sendNotification(XIFFConnectionMediator.XIFF_CONNECT);
            this._connectionCreationInProgress = true;
            this.panel.chatstatusbox.visible = true;
            if (globalFlash.gui.GetDefaultGuiElementsLoaded())
            {
                this.Show();
            };
        }

        public function joinMyCoopAdventureChatroom(_arg_1:int):void
        {
            this._myCoopChannelAdventureID = _arg_1;
            sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO((defines.COOP_ADVENTURE_CHATROOM_PREFIX + Math.abs(this._myCoopChannelAdventureID))));
            this._myCoopChannelJoined = true;
        }

        public function setGuildTag(_arg_1:String=null):void
        {
            this._tsoDataProxy.playerTag = _arg_1;
        }

        public function setPlayerID(_arg_1:int):void
        {
            if (!connectionProxy.player)
            {
                connectionProxy.player = new PlayerVO();
            };
            connectionProxy.player.id = _arg_1;
        }

        public function get roomSeperator():String
        {
            return (connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR);
        }

        public function IsMyCoopChatroomOpen():Boolean
        {
            return (this._myCoopChannelJoined);
        }

        public function Expand():void
        {
            this.panel.Expand();
        }

        public function Collapse():void
        {
            this.panel.Collapse();
        }

        public function leaveFriendsCoopAdventureChatroom():void
        {
            if (this._friendsCoopChannelJoined)
            {
                sendNotification(BlueFireFacade.ROOM_LEAVE, (defines.COOP_ADVENTURE_CHATROOM_PREFIX + Math.abs(this._friendsCoopChannelAdventureID)));
                this._friendsCoopChannelJoined = false;
            };
        }

        public function get connectionEstablished():Boolean
        {
            return (this._connectionEstablished);
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        private function stopConnecting():void
        {
            if (reconnectTimer != null)
            {
                reconnectTimer.stop();
                reconnectTimer = null;
            };
            this._connectionCreationInProgress = false;
            this.panel.chatstatusbox.visible = false;
        }

        private function HandleLink(_arg_1:TextEvent):void
        {
            var _local_4:String;
            var _local_5:Array;
            var _local_6:dPlayerListItemVO;
            var _local_2:Array = _arg_1.text.split("?");
            var _local_3:Object = new Object();
            for each (_local_4 in _local_2)
            {
                _local_5 = _local_4.split("=");
                _local_3[_local_5[0]] = _local_5[1];
            };
            if (_local_3["action"] == "whisper")
            {
                globalFlash.gui.mFriendsListMenu.Move(global.getApplication().mouseX, global.getApplication().mouseY);
                _local_6 = new dPlayerListItemVO();
                _local_6.username = _local_3["fname"].split("|")[0];
                _local_6.id = _local_3["fname"].split("|")[1];
                globalFlash.gui.mFriendsListMenu.SetData(_local_6, "ChatWindow");
                globalFlash.gui.mFriendsListMenu.Show();
                this.panel.messageHistory.addEventListener(MouseEvent.CLICK, this.HandleMessageHistoryStopClick);
            }
            else
            {
                gMisc.Assert(false, "Wrong link type!");
            };
        }

        public function leaveOfficesChannel():void
        {
            this._officersChannelJoined = false;
        }

        override public function listNotificationInterests():Array
        {
            var _local_1:Array = super.listNotificationInterests();
            _local_1.push(BlueFireFacade.CONNECTED);
            _local_1.push(XIFFConnectionMediator.XIFF_CONNECT);
            _local_1.push(BlueFireFacade.LOGGED_IN);
            _local_1.push(BlueFireFacade.ROOM_JOINED);
            _local_1.push(BlueFireFacade.MESSAGE_CREATED);
            _local_1.push(BlueFireFacade.MESSAGE_CREATED_ADDED);
            _local_1.push(BlueFireFacade.FRIEND_PRESENCE_UPDATED);
            _local_1.push(BlueFireFacade.ROOM_OCCUPANT_PRESENCE_UPDATED);
            _local_1.push(BlueFireFacade.ROOM_LEFT);
            _local_1.push(BlueFireFacade.CONNECTION_ERROR);
            _local_1.push(BlueFireFacade.MESSAGE_CUSTOMALERT);
            _local_1.push(BlueFireFacade.LEAVE_CHAT);
            return (_local_1);
        }

        public function joinGuildChannel(_arg_1:dGuildVO):void
        {
            if (connectionProxy.status != ConnectionStatus.LOGGED_IN)
            {
                return;
            };
            if (!this._guildChannelJoined)
            {
                facade.sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO(("gc_" + _arg_1.id), true));
            };
            this._guildChannelJoined = true;
            if (this._tsoDataProxy.playerTag == "")
            {
                this.setGuildTag(_arg_1.tag);
            };
        }

        override protected function HandleTabClick(_arg_1:ListEvent):void
        {
            super.HandleTabClick(_arg_1);
            _arg_1.target.dataProvider.refresh();
            var _local_2:ChannelVO = (_arg_1.itemRenderer.data as ChannelVO);
            if (_local_2.name == "news")
            {
                this.panel.messageInput.visible = false;
                this.panel.vbox.visible = true;
            }
            else
            {
                this.panel.messageInput.visible = true;
                this.panel.vbox.visible = true;
                this.panel.messageInput.visible = true;
            };
            this.UpdateChannelInfoDisplay();
        }

        public function leaveGuildChannels():void
        {
            this._guildChannelJoined = false;
            this._officersChannelJoined = false;
        }

        private function joinGlobalRoomDependingOnCountry():void
        {
            if (global.defaultChatChannels[global.userCountry] != null)
            {
                sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO(("global-" + global.defaultChatChannels[global.userCountry])));
            }
            else
            {
                sendNotification(BlueFireFacade.ROOM_JOIN_EXPLICIT, new RoomJoinRequestVO("global-1"));
            };
        }

        private function whispers_RemoveHandler(_arg_1:Event):void
        {
            var _local_2:ChannelVO = (_arg_1.target.data as ChannelVO);
            connectionProxy.removeWhisper(_local_2.name);
            if (this.panel.selectedChannel == _local_2)
            {
                this.panel.selectedChannel = connectionProxy.getChannel("whisper");
            };
        }

        private function UpdateChannelInfoDisplay():void
        {
            if (channelNotifications[this.panel.selectedChannel.name] != null)
            {
                this.panel.channelInfoDisplay.text = channelNotifications[this.panel.selectedChannel.name];
                this.panel.channelInfoDisplay.text = this.panel.channelInfoDisplay.text.replace(/\\n/, "\n");
                this.panel.channelInfoDisplay.scaleY = 1;
                this.panel.channelInfoDisplay.visible = (this.panel.channelInfoDisplay.includeInLayout = true);
            }
            else
            {
                this.panel.channelInfoDisplay.scaleY = 0;
                this.panel.channelInfoDisplay.visible = (this.panel.channelInfoDisplay.includeInLayout = false);
            };
        }


    }
}
