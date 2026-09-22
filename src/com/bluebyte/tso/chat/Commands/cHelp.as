package com.bluebyte.tso.chat.Commands
{
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;

    public class cHelp extends SlashCommand 
    {

        public static const COMMAND_HELP:String = "commandHelp";

        public function cHelp()
        {
            super();
            _regExArray.push(/\/help/);
        }

        override protected function internalEvaluate(_arg_1:String):String
        {
            var _local_2:* = "\n";
            _local_2 = (_local_2 + "Type /w username \n");
            _local_2 = (_local_2 + "Type /joinChat global-X (X = number)\n");
            _local_2 = (_local_2 + "Type /findFriend Friendname\n");
            _local_2 = (_local_2 + "Type /ignoreshow\n");
            _local_2 = (_local_2 + "Type /ignoreadd username\n");
            _local_2 = (_local_2 + "Type /ignoreremove username\n");
            _local_2 = (_local_2 + "Type /report Username Reason\n");
            return (COMMAND_HELP);
        }


    }
}
