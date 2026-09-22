package com.bluebyte.bluefire.puremvc.view.xiff
{
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.puremvc.as3.multicore.interfaces.IMediator;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import flash.events.Event;
    import com.bluebyte.bluefire.api.controller.RoomManager;
    import org.igniterealtime.xiff.core.XMPPConnection;
    import org.igniterealtime.xiff.events.RoomEvent;
    import com.bluebyte.bluefire.api.event.RoomManagerEvent;
    import com.bluebyte.bluefire.api.model.vo.RoomJoinRequestVO;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.igniterealtime.xiff.conference.RoomOccupant;
    import com.bluebyte.bluefire.api.model.vo.RoomOccupantVO;
    import org.igniterealtime.xiff.conference.Room;
    import com.bluebyte.bluefire.api.model.vo.RoomVO;

    public class XIFFRoomManagerMediator extends Mediator implements IMediator 
    {

        public static const NAME:String = "XIFFRoomManagerMediator";

        private var _connectionProxy:ConnectionProxy;

        public function XIFFRoomManagerMediator(_arg_1:String=null, _arg_2:Object=null)
        {
            super(NAME);
        }

        override public function listNotificationInterests():Array
        {
            return ([BlueFireFacade.CONNECTED, BlueFireFacade.ROOM_JOIN, BlueFireFacade.ROOM_JOIN_EXPLICIT, BlueFireFacade.ROOM_LEAVE, BlueFireFacade.ROOM_JOIN_ALL, BlueFireFacade.ROOM_JOINED]);
        }

        private function roomHandler_AllRoomsJoinedHandler(_arg_1:Event):void
        {
        }

        override public function onRegister():void
        {
            this._connectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            switch (_arg_1.getName())
            {
                case BlueFireFacade.CONNECTED:
                    viewComponent = new RoomManager((facade as BlueFireFacade), (_arg_1.getBody() as XMPPConnection));
                    this.roomManager.addEventListener(RoomEvent.ROOM_JOIN, this.roomManager_RoomJoinHandler);
                    this.roomManager.addEventListener(RoomEvent.ROOM_LEAVE, this.roomManager_RoomLeaveHandler);
                    this.roomManager.addEventListener(RoomManagerEvent.ALL_ROOMS_JOINED, this.roomHandler_AllRoomsJoinedHandler);
                    this.roomManager.addEventListener(RoomEvent.USER_JOIN, this.roomManager_RoomUserJoinHandler);
                    this.roomManager.addEventListener(RoomEvent.USER_DEPARTURE, this.roomManager_RoomUserDepartureHandler);
                    return;
                case BlueFireFacade.ROOM_JOIN_EXPLICIT:
                    if (this.roomManager != null)
                    {
                        this.roomManager.joinRoomExplicit((_arg_1.getBody() as RoomJoinRequestVO));
                    };
                    return;
                case BlueFireFacade.ROOM_JOIN:
                    this.roomManager.joinRoomByCommand((_arg_1.getBody() as String));
                    return;
                case BlueFireFacade.ROOM_LEAVE:
                    if (this.roomManager != null)
                    {
                        this.roomManager.leaveRoomByCommand((_arg_1.getBody() as String));
                    };
                    return;
                case BlueFireFacade.ROOM_JOIN_ALL:
                    this.roomManager.joinRooms();
                    return;
                case BlueFireFacade.ROOM_JOINED:
                    this.roomManager.resetJoinInProgress();
                    return;
            };
        }

        private function roomManager_RoomUserJoinHandler(_arg_1:RoomEvent):void
        {
        }

        private function roomManager_RoomUserDepartureHandler(_arg_1:RoomEvent):void
        {
        }

        private function get roomManager():RoomManager
        {
            return (viewComponent as RoomManager);
        }

        private function roomManager_RoomJoinHandler(_arg_1:RoomManagerEvent):void
        {
            var _local_4:RoomOccupant;
            var _local_5:RoomOccupantVO;
            var _local_2:Room = Room(_arg_1.data);
            var _local_3:RoomVO = new RoomVO();
            _local_3.name = _local_2.roomName;
            for each (_local_4 in _local_2.source)
            {
                _local_5 = new RoomOccupantVO();
                _local_5.name = _local_4.nickname;
                _local_3.addOccupant(_local_5);
            };
            this._connectionProxy.addRoom(_local_3);
            sendNotification(BlueFireFacade.ROOM_JOINED, _local_3);
        }

        private function roomManager_RoomLeaveHandler(_arg_1:RoomManagerEvent):void
        {
            var _local_2:Room = Room(_arg_1.data);
            sendNotification(BlueFireFacade.ROOM_LEFT, _local_2.roomName);
        }


    }
}
