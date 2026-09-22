package GUI.Events
{
    import mx.events.ItemClickEvent;
    import flash.display.InteractiveObject;
    import flash.events.Event;

    public class TrackMissionEvent extends ItemClickEvent 
    {

        public static const TRACK_MISSION:String = "trackMission";

        public var track:Boolean = false;

        public function TrackMissionEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false, _arg_4:String=null, _arg_5:int=-1, _arg_6:InteractiveObject=null, _arg_7:Object=null)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        override public function clone():Event
        {
            var _local_1:TrackMissionEvent = new TrackMissionEvent(type, bubbles, cancelable, label, index, relatedObject, item);
            _local_1.track = this.track;
            return (_local_1);
        }


    }
}
