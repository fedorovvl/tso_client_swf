package com.bluebyte.bluefire.puremvc.controller
{
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import com.bluebyte.bluefire.api.model.vo.MessageVOContainer;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class AddMessageCommand extends SimpleCommand 
    {


        override public function execute(_arg_1:INotification):void
        {
            var _local_2:MessageVO = (_arg_1.getBody() as MessageVO);
            if (!_local_2)
            {
                return;
            };
            var _local_3:MessageVOContainer = new MessageVOContainer(_local_2);
            var _local_4:ConnectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
            sendNotification(BlueFireFacade.MESSAGE_CREATED, _local_3);
            _local_4.addMessage(_local_3.message);
            sendNotification(BlueFireFacade.MESSAGE_CREATED_ADDED, _local_3.message);
            sendNotification(BlueFireFacade.MESSAGE_CREATED_ADDED_AFTER, _local_3.message);
        }


    }
}
