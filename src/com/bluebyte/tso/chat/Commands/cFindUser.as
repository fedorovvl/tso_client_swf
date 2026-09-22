package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cFindUser extends SlashCommand 
    {

        public static const COMMAND_FIND_USER:String = "commandFindUser";

        public function cFindUser()
        {
            super();
            _regExArray.push(/\/finduser\s.+/);
            _regExArray.push(/\/fu\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_FIND_USER);
        }


    }
}
