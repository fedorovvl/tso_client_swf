package com.bluebyte.bluefire.api.controller.slashCommands
{
    public class SlashCommand 
    {

        protected var _regExArray:Array = new Array();


        final public function execute(_arg_1:String):String
        {
            var _local_2:*;
            for each (_local_2 in this._regExArray)
            {
                if (_arg_1.toLowerCase().search(_local_2) != -1)
                {
                    return (this.internalEvaluate(_arg_1));
                };
            };
            return (null);
        }

        protected function internalEvaluate(_arg_1:String):String
        {
            throw (new Error("Abstract Method!"));
        }


    }
}
