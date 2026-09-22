package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cIgnoreRemove extends SlashCommand 
    {

        public static const COMMAND_IGNORE_REMOVE:String = "commandIgnoreRemove";

        public function cIgnoreRemove()
        {
            super();
            _regExArray.push(/\/ignoreremove\s.+/);
            _regExArray.push(/\/ir\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_IGNORE_REMOVE);
        }


    }
}
