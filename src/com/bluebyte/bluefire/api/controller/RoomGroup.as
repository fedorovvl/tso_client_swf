package com.bluebyte.bluefire.api.controller
{
    import flash.events.EventDispatcher;
    import com.bluebyte.bluefire.api.model.vo.RoomJoinRequestVO;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import org.igniterealtime.xiff.conference.Room;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import org.igniterealtime.xiff.core.XMPPConnection;
    import mx.collections.ArrayCollection;
    import mx.collections.SortField;
    import mx.collections.Sort;
    import org.igniterealtime.xiff.data.Presence;
    import com.bluebyte.bluefire.api.model.vo.RoomPresenceUpdatedVO;
    import org.igniterealtime.xiff.events.RoomEvent;
    import com.bluebyte.bluefire.api.event.RoomManagerEvent;
    import org.igniterealtime.xiff.core.UnescapedJID;
    import org.igniterealtime.xiff.conference.RoomOccupant;
    import com.bluebyte.bluefire.api.controller.*;

    internal class RoomGroup extends EventDispatcher 
    {

        private var _currentInstanceIdx:int = 0;
        private var _autoJoin:Boolean = false;
        private var _lastRoomInstance:int = -1;
        private var _name:String;
        private var _roomJoinRequest:RoomJoinRequestVO;
        private var _connectionProxy:ConnectionProxy;
        private var _currentRoom:Room;
        // XIFF-quiet Room has no isActive member (proxy would throw Unknown Property).
        // Track join state locally from ROOM_JOIN / ROOM_LEAVE instead.
        private var _currentRoomActive:Boolean = false;
        private var _facade:BlueFireFacade;
        private var _connection:XMPPConnection;
        private var _instances:ArrayCollection = new ArrayCollection();

        public function RoomGroup(_arg_1:BlueFireFacade, _arg_2:RoomJoinRequestVO, _arg_3:XMPPConnection)
        {
            super();
            this._facade = _arg_1;
            this._connectionProxy = (this._facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
            this._roomJoinRequest = _arg_2;
            var _local_4:SortField = new SortField();
            _local_4.numeric = true;
            var _local_5:Sort = new Sort();
            _local_5.fields = [_local_4];
            this._instances.sort = _local_5;
            var _local_6:Array = _arg_2.name.split(this._connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR);
            this._name = _local_6[0];
            this._connection = _arg_3;
        }

        public function leaveGroupChat():void
        {
            if (this._currentRoom != null)
            {
                this._currentRoom.leave();
                this._currentRoom = null;
                this._currentRoomActive = false;
            };
        }

        private function autoJoinGroupChat():void
        {
            this.joinGroupChatInstance(this._instances[this._currentInstanceIdx]);
            this._currentInstanceIdx++;
            if (this._currentInstanceIdx > this._instances.length)
            {
                this._currentInstanceIdx = 0;
            };
        }

        private function HandleGuildRoomUserLeave(_arg_1:RoomEvent):void
        {
            var _local_2:Presence = _arg_1.data;
            this._facade.sendNotification(BlueFireFacade.ROOM_OCCUPANT_PRESENCE_UPDATED, new RoomPresenceUpdatedVO(_local_2.from.resource, _local_2.from.localpart, false));
        }

        private function handleRoomMaxUsers(_arg_1:RoomEvent):void
        {
            this._currentRoomActive = false;
            this._currentRoom.removeEventListener(RoomEvent.ROOM_JOIN, this.handleRoomJoin);
            this._currentRoom.removeEventListener(RoomEvent.MAX_USERS_ERROR, this.handleRoomMaxUsers);
            this._currentRoom.removeEventListener(RoomEvent.ROOM_LEAVE, this.handleRoomLeave);
            if (this._lastRoomInstance == -1)
            {
                this.autoJoinGroupChat();
            }
            else
            {
                this.joinGroupChatInstance(this._lastRoomInstance);
            };
        }

        public function get name():String
        {
            return (this._name);
        }

        public function join():void
        {
            this.autoJoinGroupChat();
        }

        public function addRoomInstance(_arg_1:int=-1):void
        {
            var _local_2:int;
            for each (_local_2 in this._instances)
            {
                if (_local_2 == _arg_1)
                {
                    return;
                };
            };
            this._instances.addItem(_arg_1);
            this._instances.refresh();
        }

        public function get autojoin():Boolean
        {
            return (this._autoJoin);
        }

        private function handleRoomLeave(_arg_1:RoomEvent):void
        {
            var _local_2:RoomManagerEvent = new RoomManagerEvent(RoomEvent.ROOM_LEAVE);
            _local_2.data = _arg_1.target;
            if (_arg_1.target == this._currentRoom)
            {
                this._currentRoomActive = false;
            };
            this.dispatchEvent(_local_2);
        }

        public function isInstancePresent(_arg_1:int):Boolean
        {
            var _local_2:int;
            for each (_local_2 in this._instances)
            {
                if (_local_2 == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function joinGroupChatInstance(_arg_1:int):void
        {
            var _local_2:UnescapedJID;
            if (_arg_1 != -1)
            {
                _local_2 = new UnescapedJID(((((this._name + this._connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR) + _arg_1) + "@conference.") + this._connectionProxy.server.ip));
            }
            else
            {
                _local_2 = new UnescapedJID(((this._name + "@conference.") + this._connectionProxy.server.ip));
            };
            if (((this._currentRoom) && (this._currentRoomActive)))
            {
                if (this._currentRoom.roomJID.equals(_local_2, false))
                {
                    return;
                };
                this._currentRoom.leave();
                this._currentRoomActive = false;
            };
            this._currentRoom = new Room(this._connection);
            this._currentRoom.roomJID = _local_2;
            this._currentRoom.addEventListener(RoomEvent.ROOM_JOIN, this.handleRoomJoin);
            this._currentRoom.addEventListener(RoomEvent.MAX_USERS_ERROR, this.handleRoomMaxUsers);
            this._currentRoom.addEventListener(RoomEvent.ROOM_LEAVE, this.handleRoomLeave);
            if (this._roomJoinRequest.useForOnlineStatus)
            {
                this._currentRoom.addEventListener(RoomEvent.USER_JOIN, this.HandleGuildRoomUserJoin);
                this._currentRoom.addEventListener(RoomEvent.USER_DEPARTURE, this.HandleGuildRoomUserLeave);
            };
            this._currentRoom.join();
        }

        private function handleRoomError(_arg_1:RoomEvent):void
        {
        }

        private function handleRoomJoin(_arg_1:RoomEvent):void
        {
            var _local_4:RoomOccupant;
            var _local_2:Room = Room(_arg_1.target);
            if (_arg_1.target == this._currentRoom)
            {
                this._currentRoomActive = true;
            };
            this._lastRoomInstance = -1;
            if (_local_2.roomName.split(this._connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR).length > 1)
            {
                this._lastRoomInstance = _local_2.roomName.split(this._connectionProxy.CONSTANTS.ROOM_GROUP_SEPERATOR)[1];
            };
            if (this._roomJoinRequest.useForOnlineStatus)
            {
                for each (_local_4 in _local_2.source)
                {
                    this._facade.sendNotification(BlueFireFacade.ROOM_OCCUPANT_PRESENCE_UPDATED, new RoomPresenceUpdatedVO(_local_4.nickname, _local_2.roomName, true));
                };
            };
            var _local_3:RoomManagerEvent = new RoomManagerEvent(RoomEvent.ROOM_JOIN);
            _local_3.data = _arg_1.target;
            this.dispatchEvent(_local_3);
        }

        public function set autojoin(_arg_1:Boolean):void
        {
            this._autoJoin = _arg_1;
        }

        private function HandleGuildRoomUserJoin(_arg_1:RoomEvent):void
        {
            var _local_2:Presence = _arg_1.data;
            this._facade.sendNotification(BlueFireFacade.ROOM_OCCUPANT_PRESENCE_UPDATED, new RoomPresenceUpdatedVO(_local_2.from.resource, _local_2.from.localpart, true));
        }


    }
}
