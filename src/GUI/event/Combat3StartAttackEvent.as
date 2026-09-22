package GUI.event
{
    import flash.events.Event;

    public class Combat3StartAttackEvent extends Event 
    {

        public static const INITIATE_COMBAT:String = "initiateCombat";

        public var unitName:String;

        public function Combat3StartAttackEvent(_arg_1:String, _arg_2:String=null)
        {
            super(_arg_1, true, true);
            this.unitName = _arg_2;
        }

        override public function clone():Event
        {
            return (new Combat3StartAttackEvent(type, this.unitName));
        }


    }
}
