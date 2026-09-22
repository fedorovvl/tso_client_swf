package com.bluebyte.bluefire.api.controller
{
    import flash.events.EventDispatcher;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import org.igniterealtime.xiff.core.XMPPConnection;
    import __AS3__.vec.Vector;
    import mx.collections.ArrayCollection;
    import org.igniterealtime.xiff.events.RoomEvent;
    import com.bluebyte.bluefire.api.model.vo.RoomJoinRequestVO;
    import com.bluebyte.bluefire.api.event.RoomManagerEvent;
    import org.igniterealtime.xiff.core.Browser;
    import org.igniterealtime.xiff.core.EscapedJID;
    import org.igniterealtime.xiff.data.disco.ItemDiscoExtension;
    import org.igniterealtime.xiff.data.IQ;
    import __AS3__.vec.*;

    public class RoomManager extends EventDispatcher 
    {

        private var _connectionProxy:ConnectionProxy;
        private var _joinRoomInProgress:Boolean = false;
        private var _facade:BlueFireFacade;
        private var _connection:XMPPConnection;

        private var _roomGroups:Vector.<RoomGroup> = new Vector.<RoomGroup>();
        private var _pendingRoomsToJoin:ArrayCollection = new ArrayCollection();

        public function RoomManager(_arg_1:BlueFireFacade, _arg_2:XMPPConnection)
        {
            super();
            this._connection = _arg_2;
            this._facade = _arg_1;
            this._connectionProxy = (this._facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
        }

        public function joinRoomExplicit(_arg_1:RoomJoinRequestVO):void
        {
            var _local_2:Array = _arg_1.name.split(this._connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR);
            var _local_3:RoomGroup = this.findRoomGroupByName(_local_2[0]);
            if (!_local_3)
            {
                _local_3 = new RoomGroup((this._facade as BlueFireFacade), _arg_1, this._connection);
                _local_3.addEventListener(RoomEvent.ROOM_JOIN, this.handleRoomJoin);
                _local_3.addEventListener(RoomEvent.ROOM_LEAVE, this.handleRoomLeave);
                if (_local_2.length > 1)
                {
                    _local_3.addRoomInstance(_local_2[1]);
                }
                else
                {
                    _local_3.addRoomInstance(-1);
                };
                this._roomGroups.push(_local_3);
            };
            var _local_4:int = -1;
            if (_local_2.length != 1)
            {
                _local_4 = int(_local_2[1]);
            };
            _local_3.joinGroupChatInstance(_local_4);
        }

        public function setChannelAutoJoin(_arg_1:String, _arg_2:Boolean):void
        {
            var _local_3:Array = _arg_1.split(this._connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR);
            var _local_4:String = _local_3[0];
            var _local_5:RoomGroup = this.findRoomGroupByName(_local_4);
            if (!_local_5)
            {
                _local_5 = new RoomGroup(this._facade, new RoomJoinRequestVO(_local_4), this._connection);
                _local_5.addEventListener(RoomEvent.ROOM_JOIN, this.handleRoomJoin);
                _local_5.addEventListener(RoomEvent.ROOM_LEAVE, this.handleRoomLeave);
                if (_local_3.length > 1)
                {
                    _local_5.addRoomInstance(_local_3[1]);
                }
                else
                {
                    _local_5.addRoomInstance(-1);
                };
                this._roomGroups.push(_local_5);
            };
            _local_5.autojoin = _arg_2;
        }

        private function findRoomGroupByName(_arg_1:String):RoomGroup
        {
            var _local_2:RoomGroup;
            for each (_local_2 in this._roomGroups)
            {
                if (_local_2.name == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function leaveRoomByCommand(_arg_1:String):int
        {
            var _local_2:Array = _arg_1.split(this._connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR);
            var _local_3:RoomGroup = this.findRoomGroupByName(_local_2[0]);
            if (!_local_3)
            {
                return (0);
            };
            var _local_4:int = -1;
            if (_local_2.length != 1)
            {
                _local_4 = int(_local_2[1]);
            };
            if (!_local_3.isInstancePresent(_local_4))
            {
                return (0);
            };
            _local_3.leaveGroupChat();
            return (1);
        }

        public function resetJoinInProgress():void
        {
            this._joinRoomInProgress = false;
        }

        private function handleRoomJoin(_arg_1:RoomManagerEvent):void
        {
            if (this._pendingRoomsToJoin.getItemIndex(_arg_1.target) != -1)
            {
                this._pendingRoomsToJoin.removeItemAt(this._pendingRoomsToJoin.getItemIndex(_arg_1.target));
            };
            this.dispatchEvent(_arg_1);
            if (this._pendingRoomsToJoin.length > 0)
            {
                this._pendingRoomsToJoin[0].join();
            }
            else
            {
                dispatchEvent(new RoomManagerEvent(RoomManagerEvent.ALL_ROOMS_JOINED));
            };
        }

        public function joinRoomByCommand(_arg_1:String):int
        {
            if (this._joinRoomInProgress)
            {
                return (2);
            };
            var _local_2:Array = _arg_1.split(this._connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR);
            var _local_3:RoomGroup = this.findRoomGroupByName(_local_2[0]);
            if (!_local_3)
            {
                return (0);
            };
            var _local_4:int = -1;
            if (_local_2.length != 1)
            {
                _local_4 = int(_local_2[1]);
            };
            if (!_local_3.isInstancePresent(_local_4))
            {
                return (0);
            };
            _local_3.joinGroupChatInstance(_local_4);
            this._joinRoomInProgress = true;
            return (1);
        }

        private function handleRoomLeave(_arg_1:RoomManagerEvent):void
        {
            this.dispatchEvent(_arg_1);
        }

        public function joinRooms():void
        {
            var _local_1:Browser = new Browser(this._connection);
            _local_1.getServiceItems(new EscapedJID(("conference." + this._connectionProxy.server.ip)), this.getRoomNames);
        }

        public function getRoomNames(_arg_1:IQ):void
        {
            var _local_4:RoomGroup;
            var _local_5:ItemDiscoExtension;
            var _local_6:Array;
            var _local_7:uint;
            var _local_8:RoomGroup;
            var _local_9:Object;
            var _local_10:String;
            var _local_11:Array;
            var _local_12:String;
            var _local_13:int;
            var _local_2:Array = _arg_1.getAllExtensions();
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _local_5 = _local_2[_local_3];
                _local_6 = _local_5.items;
                _local_7 = 0;
                while (_local_7 < _local_6.length)
                {
                    _local_8 = null;
                    _local_9 = (_local_6[_local_7] as Object);
                    _local_10 = _local_9.name;
                    _local_11 = _local_10.split("-");
                    _local_12 = _local_11[0];
                    _local_13 = -1;
                    _local_8 = this.findRoomGroupByName(_local_12);
                    if (_local_11.length != 1)
                    {
                        _local_13 = int(_local_11[1]);
                    };
                    if (!_local_8)
                    {
                        _local_8 = new RoomGroup(this._facade, new RoomJoinRequestVO(_local_12), this._connection);
                        _local_8.addEventListener(RoomEvent.ROOM_JOIN, this.handleRoomJoin);
                        _local_8.addEventListener(RoomEvent.ROOM_LEAVE, this.handleRoomLeave);
                        if (_local_8.name == "trade")
                        {
                            _local_8.autojoin = false;
                        };
                        this._roomGroups.push(_local_8);
                    };
                    _local_8.addRoomInstance(_local_13);
                    _local_7++;
                };
                _local_3++;
            };
            for each (_local_4 in this._roomGroups)
            {
                if (_local_4.autojoin)
                {
                    this._pendingRoomsToJoin.addItem(_local_4);
                };
            };
            if (this._pendingRoomsToJoin.length > 0)
            {
                this._pendingRoomsToJoin[0].join();
            };
        }


    }
}
