package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cJoinChat extends SlashCommand 
    {

        public static const COMMAND_JOIN_CHAT:String = "commandJoinChat";

        public function cJoinChat()
        {
            super();
            _regExArray.push(/\/joinchat global-[\d]+/);
            _regExArray.push(/\/j global-[\d]+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_JOIN_CHAT);
        }


    }
}
