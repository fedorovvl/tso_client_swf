package GUI.event
{
    import flash.events.Event;

    public class VolumeBarClickEvent extends Event 
    {

        public static const VOLUME_BAR_CLICK:String = "volumeBarClick";

        public var val:int;

        public function VolumeBarClickEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false, _arg_4:int=0)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.val = _arg_4;
        }

    }
}
