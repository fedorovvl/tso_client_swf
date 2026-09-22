package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cUnban extends SlashCommand 
    {

        public static const COMMAND_UNBAN:String = "commandUnban";

        public function cUnban()
        {
            super();
            _regExArray.push(/\/unban\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_UNBAN);
        }


    }
}
