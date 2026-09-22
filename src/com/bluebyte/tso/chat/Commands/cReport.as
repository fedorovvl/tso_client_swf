package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cReport extends SlashCommand 
    {

        public static const COMMAND_REPORT:String = "commandReport";

        public function cReport()
        {
            super();
            _regExArray.push(/\/report\s.+\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_REPORT);
        }


    }
}
