package GUI.GAME.avatarSelection.command
{
    import org.puremvc.as3.patterns.command.SimpleCommand;
    import GUI.GAME.avatarSelection.vo.SendServerVO;
    import Interface.cGeneralInterface;
    import Communication.VO.avatarSelection.CheckUsernameVO;
    import Enums.COMMAND;
    import org.puremvc.as3.interfaces.INotification;

    public class SendCheckUsernameCommand extends SimpleCommand 
    {


        override public function execute(_arg_1:INotification):void
        {
            var _local_2:SendServerVO = (_arg_1.getBody() as SendServerVO);
            var _local_3:cGeneralInterface = _local_2.getGeneralInterface();
            var _local_4:CheckUsernameVO = (_local_2.getRequestVO() as CheckUsernameVO);
            _local_3.mClientMessages.SendMessagetoServer(COMMAND.CHECK_AVATAR_NAME, _local_3.mCurrentViewedZoneID, _local_4);
        }


    }
}
