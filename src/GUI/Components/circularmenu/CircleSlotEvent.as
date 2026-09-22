package GUI.Components.circularmenu
{
    import flash.events.Event;

    public class CircleSlotEvent extends Event 
    {

        public static const SLOT_CLICKED:String = "slotClicked";

        public var data:Object;
        public var slot:int;

        public function CircleSlotEvent(_arg_1:Object, _arg_2:int, _arg_3:String, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            super(_arg_3, _arg_4, _arg_5);
            this.data = _arg_1;
            this.slot = _arg_2;
        }

        override public function clone():Event
        {
            return (new CircleSlotEvent(this.data, this.slot, type, bubbles, cancelable));
        }


    }
}
