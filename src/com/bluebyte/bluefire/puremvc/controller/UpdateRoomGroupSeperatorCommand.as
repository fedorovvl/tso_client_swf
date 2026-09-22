package com.bluebyte.bluefire.puremvc.controller
{
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class UpdateRoomGroupSeperatorCommand extends SimpleCommand 
    {


        override public function execute(_arg_1:INotification):void
        {
            var _local_2:ConnectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
            _local_2.CONSTANTS.ROOM_GROUP_SEPERATOR = (_arg_1.getBody() as String);
        }


    }
}
