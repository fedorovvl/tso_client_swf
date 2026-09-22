package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cLeaveChat extends SlashCommand 
    {

        public static const COMMAND_LEAVE_CHAT:String = "commandLeaveChat";

        public function cLeaveChat()
        {
            super();
            _regExArray.push(/\/leavechat/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_LEAVE_CHAT);
        }


    }
}
