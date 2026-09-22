package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cIgnoreAdd extends SlashCommand 
    {

        public static const COMMAND_IGNORE_ADD:String = "commandIgnoreAdd";

        public function cIgnoreAdd()
        {
            super();
            _regExArray.push(/\/ignoreadd\s.+/);
            _regExArray.push(/\/ia\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_IGNORE_ADD);
        }


    }
}
