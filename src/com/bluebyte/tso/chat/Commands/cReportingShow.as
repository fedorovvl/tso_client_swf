package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cReportingShow extends SlashCommand 
    {

        public static const COMMAND_REPORTING_SHOW:String = "commandReportingShow";

        public function cReportingShow()
        {
            super();
            _regExArray.push(/\/showreporting/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_REPORTING_SHOW);
        }


    }
}
