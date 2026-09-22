package Trigger.vo
{
    import flash.utils.Dictionary;

    public class CompletePvPColonyUnitsTriggerVO 
    {

        public var kills:Dictionary;
        public var mapLevel:int;
        public var casualties:Dictionary;

        public function CompletePvPColonyUnitsTriggerVO(_arg_1:Dictionary, _arg_2:Dictionary, _arg_3:int)
        {
            super();
            this.mapLevel = _arg_3;
            this.casualties = _arg_1;
            this.kills = _arg_2;
        }

    }
}
