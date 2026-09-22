package com.bluebyte.bluefire.puremvc.controller
{
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import org.igniterealtime.xiff.core.EscapedJID;
    import com.bluebyte.bluefire.api.extensions.IMessageExtension;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import org.igniterealtime.xiff.data.Message;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import com.bluebyte.bluefire.api.model.vo.OccupantVO;
    import com.bluebyte.bluefire.api.model.vo.MessageVOContainer;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import com.bluebyte.bluefire.puremvc.view.xiff.XIFFConnectionMediator;
    import org.igniterealtime.xiff.events.MessageEvent;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class SendMessageCommand extends SimpleCommand 
    {


        private function createMessage(_arg_1:MessageVO):Message
        {
            var _local_3:EscapedJID;
            var _local_6:IMessageExtension;
            var _local_2:ConnectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
            var _local_4:String;
            if (_arg_1.groupMessage)
            {
                _local_3 = new EscapedJID(((_arg_1.receiver.name + "@conference.") + _local_2.server.ip));
                _local_4 = Message.TYPE_GROUPCHAT;
            }
            else
            {
                _local_3 = new EscapedJID(((_arg_1.receiver.name + "@") + _local_2.server.ip));
            };
            var _local_5:Message = new Message(_local_3, null, _arg_1.text, null, _local_4);
            _local_5.from = new EscapedJID(((_arg_1.sender.name + "@") + _local_2.server.ip));
            for each (_local_6 in _arg_1.getAllExtensions())
            {
                _local_5.addExtension(_local_6);
            };
            return (_local_5);
        }

        override public function execute(_arg_1:INotification):void
        {
            var _local_2:ConnectionProxy = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
            var _local_3:MessageVO = (_arg_1.getBody() as MessageVO);
            _local_3.receiver = new OccupantVO();
            _local_3.receiver.name = _local_3.room;
            _local_3.receiver.id = -1;
            _local_3.sender = new OccupantVO();
            _local_3.sender.name = _local_2.player.name;
            _local_3.sender.id = _local_2.player.id;
            _local_3.time = new Date();
            var _local_4:MessageVOContainer = new MessageVOContainer(_local_3);
            sendNotification(BlueFireFacade.SEND_MESSAGE_CREATED, _local_4);
            var _local_5:Message = this.createMessage(_local_4.message);
            sendNotification(XIFFConnectionMediator.XIFF_SEND_MESSAGE, _local_5);
            var _local_6:MessageEvent = new MessageEvent();
            _local_5.from = _local_5.to;
            _local_6.data = _local_5;
            sendNotification(BlueFireFacade.ADD_MESSAGE, _local_4.message);
        }


    }
}
