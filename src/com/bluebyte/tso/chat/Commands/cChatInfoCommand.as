package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cChatInfoCommand extends SlashCommand 
    {

        public static const COMMAND_CHAT_INFO:String = "commandChatInfo";

        public function cChatInfoCommand()
        {
            super();
            _regExArray.push(/\/chatinfo/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_CHAT_INFO);
        }


    }
}
