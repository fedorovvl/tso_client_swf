package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cFindFriend extends SlashCommand 
    {

        public static const COMMAND_FIND_FRIEND:String = "commandFindFriend";

        public function cFindFriend()
        {
            super();
            _regExArray.push(/\/findfriend\s.+/);
            _regExArray.push(/\/ff\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_FIND_FRIEND);
        }


    }
}
