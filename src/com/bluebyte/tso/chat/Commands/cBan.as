package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cBan extends SlashCommand 
    {

        public static const COMMAND_BAN:String = "commandBan";

        public function cBan()
        {
            super();
            _regExArray.push(/\/ban\s.+\s[0-9]+\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_BAN);
        }


    }
}
