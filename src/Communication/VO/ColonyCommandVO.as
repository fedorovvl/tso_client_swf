package Communication.VO
{
    import Enums.COMMAND;

    public class ColonyCommandVO 
    {

        public var serverTimeStamp:Number = 0;
        public var colonyId:int;
        public var commandId:int;


        public static function Create(_arg_1:int, _arg_2:int):ColonyCommandVO
        {
            var _local_3:ColonyCommandVO = new (ColonyCommandVO)();
            _local_3.commandId = _arg_1;
            _local_3.colonyId = _arg_2;
            return (_local_3);
        }


        public function IsValid():Boolean
        {
            switch (this.commandId)
            {
                case COMMAND.COLONY_ASSIGN:
                case COMMAND.COLONY_REMOVE:
                case COMMAND.COLONY_REQUEST_YIELD:
                    return (true);
            };
            return (false);
        }

        public function toString():String
        {
            return (((("<ColonyCommandVO commandId='" + this.commandId) + "' colonyId='") + this.colonyId) + "' />");
        }


    }
}
