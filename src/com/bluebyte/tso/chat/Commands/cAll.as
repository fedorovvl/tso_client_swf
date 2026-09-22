package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cAll extends SlashCommand 
    {

        public static const COMMAND_ALL:String = "commandAll";

        public function cAll()
        {
            super();
            _regExArray.push(/\/all\s.+/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            return (COMMAND_ALL);
        }


    }
}
