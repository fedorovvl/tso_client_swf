package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cUnblock extends SlashCommand 
    {

        public static const COMMAND_UNBLOCK:String = "commandUnblock";

        public function cUnblock()
        {
            super();
            _regExArray.push(/\/unblock\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_UNBLOCK);
        }


    }
}
