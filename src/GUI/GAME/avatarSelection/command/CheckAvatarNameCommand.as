package GUI.GAME.avatarSelection.command
{
    import org.puremvc.as3.patterns.command.SimpleCommand;
    import GUI.GAME.avatarSelection.AvatarSelectionPanel;
    import mx.utils.StringUtil;
    import consts.GameConstants;
    import org.puremvc.as3.interfaces.INotification;

    public class CheckAvatarNameCommand extends SimpleCommand 
    {


        override public function execute(_arg_1:INotification):void
        {
            var _local_2:String = (_arg_1.getBody() as String);
            var _local_3:AvatarSelectionPanel = (facade.retrieveMediator(AvatarSelectionPanel.NAME) as AvatarSelectionPanel);
            _local_2 = StringUtil.trim(_local_2);
            if (_local_2.length == 0)
            {
                _local_3.localCheckFailed(GameConstants.AVATAR_NAME_ERROR_EMPTY);
                return;
            };
            if (_local_2.length < GameConstants.MIN_CHARACTERS)
            {
                _local_3.localCheckFailed(GameConstants.AVATAR_NAME_ERROR_INVALID_TOO_SHORT);
                return;
            };
            if (_local_2.length > GameConstants.MAX_CHARACTERS)
            {
                _local_3.localCheckFailed(GameConstants.AVATAR_NAME_ERROR_INVALID_TOO_LONG);
                return;
            };
            _local_3.localCheckSucceeded(_local_2);
        }


    }
}
