package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cFindBan extends SlashCommand 
    {

        public static const COMMAND_FIND_BAN:String = "commandFindBan";

        public function cFindBan()
        {
            super();
            _regExArray.push(/\/findban\s.+/);
            _regExArray.push(/\/fb\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_FIND_BAN);
        }


    }
}
