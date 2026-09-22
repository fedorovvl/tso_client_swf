package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cIgnoreShow extends SlashCommand 
    {

        public static const COMMAND_IGNORE_SHOW:String = "commandIgnoreShow";

        public function cIgnoreShow()
        {
            super();
            _regExArray.push(/\/ignoreshow/);
            _regExArray.push(/\/is/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_IGNORE_SHOW);
        }


    }
}
