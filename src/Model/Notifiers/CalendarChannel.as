package Model.Notifiers
{
    public class CalendarChannel extends Channel 
    {

        public static const CALENDAR_LOADED:String = "LOADED";
        public static const DOOR_OPENED:String = "DOOR_OPENED";


        public function loaded():void
        {
            send(CALENDAR_LOADED, null);
        }


    }
}
