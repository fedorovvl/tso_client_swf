package GameEvent
{
    import Interface.cGameInterface;

    public class EventWindowDefinition 
    {

        public var requiresEvent_string:String = "";
        public var eventWindowText_string:String = "";
        public var includesRanking:Boolean = false;
        public var eventWindowImage_string:String = "";


        public static function GetFirstValidWindowDefinition():EventWindowDefinition
        {
            var _local_1:EventWindowDefinition;
            for each (_local_1 in global.eventWindowDefinitions)
            {
                if ((global.ui as cGameInterface).mEventManager.isEventStarted(_local_1.requiresEvent_string))
                {
                    return (_local_1);
                };
            };
            return (null);
        }

        public static function GetEventWindowDefinition(_arg_1:String):EventWindowDefinition
        {
            var _local_2:EventWindowDefinition;
            for each (_local_2 in global.eventWindowDefinitions)
            {
                if (_local_2.requiresEvent_string == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }


    }
}
