package GUI.GAME.avatarSelection.command
{
    import org.puremvc.as3.patterns.command.SimpleCommand;
    import Interface.cGeneralInterface;
    import ServerState.cPlayerData;
    import org.puremvc.as3.interfaces.INotification;

    public class CheckShowAvatarSelectionPanelCommand extends SimpleCommand 
    {


        override public function execute(_arg_1:INotification):void
        {
            var _local_2:cGeneralInterface = (_arg_1.getBody() as cGeneralInterface);
            var _local_3:cPlayerData = _local_2.mCurrentPlayer;
            if (_local_2.mCurrentViewedZoneID != _local_3.getPlayerID())
            {
                return;
            };
            if (((cGeneralInterface.isDefaultPlayerName(_local_3.GetPlayerName_string())) || (_local_3.GetAvatarId() <= 0)))
            {
                globalFlash.gui.mNewsWindow.Hide();
                globalFlash.gui.mEventInfoPanel.Hide();
                globalFlash.gui.mAvatarSelectionPanel.setInitialData(_local_3.GetPlayerName_string(), _local_3.GetAvatarId());
                globalFlash.gui.mAvatarSelectionPanel.Show();
            };
        }


    }
}
