package com.bluebyte.bluefire.puremvc
{
    import org.puremvc.as3.multicore.patterns.facade.Facade;
    import org.puremvc.as3.multicore.interfaces.IFacade;
    import mx.logging.targets.TraceTarget;
    import mx.logging.LogEventLevel;
    import mx.logging.Log;
    import com.bluebyte.bluefire.puremvc.controller.StartupCommand;
    import com.bluebyte.bluefire.puremvc.controller.AddMessageCommand;
    import com.bluebyte.bluefire.puremvc.controller.SendMessageCommand;
    import com.bluebyte.bluefire.puremvc.controller.UpdatePlayerDataCommand;
    import com.bluebyte.bluefire.puremvc.controller.UpdateServerDataCommand;
    import com.bluebyte.bluefire.puremvc.controller.UpdateRoomGroupSeperatorCommand;
    import com.bluebyte.bluefire.puremvc.controller.AddChannelCommand;
    import com.bluebyte.bluefire.puremvc.controller.RemoveChannelCommand;

    public class BlueFireFacade extends Facade implements IFacade 
    {

        public static const STARTUP:String = "startup";
        public static const CONNECTED:String = "connected";
        public static const LOGGED_IN:String = "loggedIn";
        public static const CONNECTION_ERROR:String = "connectionError";
        public static const ADD_MESSAGE:String = "addMessage";
        public static const MESSAGE_CREATED:String = "messageCreated";
        public static const ROOM_JOIN:String = "roomJoin";
        public static const ROOM_JOIN_EXPLICIT:String = "roomJoinExplicit";
        public static const ROOM_LEAVE:String = "roomLeave";
        public static const ROOM_LEFT:String = "roomLeft";
        public static const SEND_MESSAGE_CREATED:String = "sendMessageCreated";
        public static const SEND_MESSAGE:String = "sendMessage";
        public static const EVALUATE_SLASH_COMMAND:String = "evaluateSlashcommand";
        public static const UPDATE_PLAYER_DATA:String = "updatePlayerData";
        public static const UPDATE_SERVER_DATA:String = "updateServerData";
        public static const UPDATE_ROOM_GROUP_SEPERATOR:String = "updateRoomGroupSeperator";
        public static const ADD_CHANNEL:String = "addChannel";
        public static const REMOVE_CHANNEL:String = "removeChannel";
        public static const ROOM_JOINED:String = "roomJoined";
        public static const ROOM_JOIN_ALL:String = "roomJoinAll";
        public static const ADD_WHISPER:String = "addWhisper";
        public static const MESSAGE_CREATED_ADDED:String = "messageCreatedAdded";
        public static const REMOVE_WHISPER:String = "removeWhisper";
        public static const REGISTER_SLASH_COMMAND:String = "registerSlashCommand";
        public static const MESSAGE_CREATED_ADDED_AFTER:String = "messageCreatedAddedAfter";
        public static const FRIEND_PRESENCE_UPDATED:String = "friendPresenceUpdated";
        public static const ROOM_OCCUPANT_PRESENCE_UPDATED:String = "roomOccupantPresenceUpdated";
        public static const MESSAGE_CUSTOMALERT:String = "messageCustomAlert";
        public static const LEAVE_CHAT:String = "leaveChat";

        public function BlueFireFacade(_arg_1:String)
        {
            super(_arg_1);
            var _local_2:TraceTarget = new TraceTarget();
            _local_2.filters = ["com.bluebyte.*"];
            _local_2.level = LogEventLevel.ALL;
            _local_2.includeDate = true;
            _local_2.includeTime = true;
            _local_2.includeCategory = true;
            _local_2.includeLevel = true;
            Log.addTarget(_local_2);
        }

        public static function getInstance(_arg_1:String):BlueFireFacade
        {
            if (instanceMap[_arg_1] == null)
            {
                instanceMap[_arg_1] = new BlueFireFacade(_arg_1);
            };
            return (instanceMap[_arg_1]);
        }


        override protected function initializeController():void
        {
            super.initializeController();
            registerCommand(STARTUP, StartupCommand);
            registerCommand(ADD_MESSAGE, AddMessageCommand);
            registerCommand(SEND_MESSAGE, SendMessageCommand);
            registerCommand(UPDATE_PLAYER_DATA, UpdatePlayerDataCommand);
            registerCommand(UPDATE_SERVER_DATA, UpdateServerDataCommand);
            registerCommand(UPDATE_ROOM_GROUP_SEPERATOR, UpdateRoomGroupSeperatorCommand);
            registerCommand(ADD_CHANNEL, AddChannelCommand);
            registerCommand(REMOVE_CHANNEL, RemoveChannelCommand);
        }

        public function startup(_arg_1:Object, _arg_2:Class):void
        {
            sendNotification(STARTUP, [_arg_1, _arg_2]);
        }


    }
}
