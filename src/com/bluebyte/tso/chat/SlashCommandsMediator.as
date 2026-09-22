package com.bluebyte.tso.chat
{
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import com.bluebyte.bluefire.puremvc.view.IChatPanel;
    import com.bluebyte.tso.chat.Commands.cAll;
    import com.bluebyte.tso.chat.Commands.cBan;
    import com.bluebyte.tso.chat.Commands.cChatInfoCommand;
    import com.bluebyte.tso.chat.Commands.cFindBan;
    import com.bluebyte.tso.chat.Commands.cFindFriend;
    import com.bluebyte.tso.chat.Commands.cFindUser;
    import com.bluebyte.tso.chat.Commands.cHelp;
    import com.bluebyte.tso.chat.Commands.cIgnoreAdd;
    import com.bluebyte.tso.chat.Commands.cIgnoreRemove;
    import com.bluebyte.tso.chat.Commands.cIgnoreShow;
    import com.bluebyte.tso.chat.Commands.cJoinChat;
    import com.bluebyte.tso.chat.Commands.cLeaveChat;
    import com.bluebyte.tso.chat.Commands.cReport;
    import com.bluebyte.tso.chat.Commands.cShowModLog;
    import com.bluebyte.tso.chat.Commands.cUnban;
    import com.bluebyte.tso.chat.Commands.cReportingShow;
    import com.bluebyte.tso.chat.Commands.cUnblock;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import com.bluebyte.bluefire.api.model.vo.MessageVO;
    import com.bluebyte.bluefire.api.controller.TextController;
    import com.bluebyte.bluefire.api.model.vo.OccupantVO;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class SlashCommandsMediator extends Mediator 
    {

        public static const NAME:String = "SlashCommandsMediator";

        public function SlashCommandsMediator(_arg_1:IChatPanel)
        {
            super(NAME, _arg_1);
        }

        override public function listNotificationInterests():Array
        {
            return ([cAll.COMMAND_ALL, cBan.COMMAND_BAN, cChatInfoCommand.COMMAND_CHAT_INFO, cFindBan.COMMAND_FIND_BAN, cFindFriend.COMMAND_FIND_FRIEND, cFindUser.COMMAND_FIND_USER, cHelp.COMMAND_HELP, cIgnoreAdd.COMMAND_IGNORE_ADD, cIgnoreRemove.COMMAND_IGNORE_REMOVE, cIgnoreShow.COMMAND_IGNORE_SHOW, cJoinChat.COMMAND_JOIN_CHAT, cLeaveChat.COMMAND_LEAVE_CHAT, cReport.COMMAND_REPORT, cShowModLog.COMMAND_SHOW_MOD_LOG, cUnban.COMMAND_UNBAN, cReportingShow.COMMAND_REPORTING_SHOW, cUnblock.COMMAND_UNBLOCK]);
        }

        protected function registerSlashCommand(_arg_1:SlashCommand):void
        {
            sendNotification(BlueFireFacade.REGISTER_SLASH_COMMAND, _arg_1);
        }

        protected function get panel():IChatPanel
        {
            return (viewComponent as IChatPanel);
        }

        override public function onRegister():void
        {
            super.onRegister();
            this.registerSlashCommand(new cAll());
            this.registerSlashCommand(new cBan());
            this.registerSlashCommand(new cChatInfoCommand());
            this.registerSlashCommand(new cFindBan());
            this.registerSlashCommand(new cFindFriend());
            this.registerSlashCommand(new cFindUser());
            this.registerSlashCommand(new cHelp());
            this.registerSlashCommand(new cIgnoreAdd());
            this.registerSlashCommand(new cIgnoreRemove());
            this.registerSlashCommand(new cIgnoreShow());
            this.registerSlashCommand(new cJoinChat());
            this.registerSlashCommand(new cLeaveChat());
            this.registerSlashCommand(new cReport());
            this.registerSlashCommand(new cShowModLog());
            this.registerSlashCommand(new cUnban());
            this.registerSlashCommand(new cReportingShow());
            this.registerSlashCommand(new cUnblock());
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            var _local_5:ConnectionProxy;
            var _local_2:MessageVO = (_arg_1.getBody() as MessageVO);
            var _local_3:MessageVO = new MessageVO();
            var _local_4:int = this.panel.mucs.dataProvider.getItemIndex(this.panel.selectedChannel);
            switch (_arg_1.getName())
            {
                case cAll.COMMAND_ALL:
                case cBan.COMMAND_BAN:
                case cChatInfoCommand.COMMAND_CHAT_INFO:
                case cFindBan.COMMAND_FIND_BAN:
                case cFindFriend.COMMAND_FIND_FRIEND:
                case cFindUser.COMMAND_FIND_USER:
                case cIgnoreAdd.COMMAND_IGNORE_ADD:
                case cIgnoreRemove.COMMAND_IGNORE_REMOVE:
                case cIgnoreShow.COMMAND_IGNORE_SHOW:
                case cShowModLog.COMMAND_SHOW_MOD_LOG:
                case cReport.COMMAND_REPORT:
                case cUnban.COMMAND_UNBAN:
                case cReportingShow.COMMAND_REPORTING_SHOW:
                case cUnblock.COMMAND_UNBLOCK:
                    _local_3.text = (_arg_1.getBody() as String);
                    _local_3.room = this.panel.selectedChannel.name;
                    if (_local_4 != -1)
                    {
                        _local_3.groupMessage = true;
                    };
                    sendNotification(BlueFireFacade.SEND_MESSAGE, _local_3);
                    return;
                case cHelp.COMMAND_HELP:
                    _local_3.room = this.panel.selectedChannel.name;
                    _local_3.text = TextController.instance.getText("ChatHelpCommand");
                    _local_3.sender = new OccupantVO();
                    _local_3.time = new Date();
                    _local_5 = (facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy);
                    _local_3.sender.name = TextController.instance.getText("SenderHelp");
                    _local_3.sender.id = _local_5.player.id;
                    _local_3.important = true;
                    if (_local_4 != -1)
                    {
                        _local_3.groupMessage = true;
                    };
                    sendNotification(BlueFireFacade.ADD_MESSAGE, _local_3);
                    return;
                case cJoinChat.COMMAND_JOIN_CHAT:
                    sendNotification(BlueFireFacade.ROOM_JOIN, (_arg_1.getBody() as String).split(" ")[1]);
                    return;
                case cLeaveChat.COMMAND_LEAVE_CHAT:
                    sendNotification(BlueFireFacade.LEAVE_CHAT, _local_3);
                    return;
            };
        }


    }
}
