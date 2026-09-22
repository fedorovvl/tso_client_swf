package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cShowModLog extends SlashCommand 
    {

        public static const COMMAND_SHOW_MOD_LOG:String = "commandShowModLog";

        public function cShowModLog()
        {
            super();
            _regExArray.push(/\/showmodlog\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_SHOW_MOD_LOG);
        }


    }
}
