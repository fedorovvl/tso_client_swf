package Communication.VO
{
    import nLib.cXML;

    public final class ReactionVO 
    {

        public var effects:EffectListVO;
        public var name_string:String;
        public var triggers:TriggerListVO;


        public static function createFromXML(_arg_1:cXML):ReactionVO
        {
            var _local_2:ReactionVO = new (ReactionVO)();
            _local_2.name_string = _arg_1.GetAttributeString_string("name");
            _local_2.triggers = TriggerListVO.fromXML(_arg_1, "triggers");
            _local_2.triggers._doInstantChecks = true;
            _local_2.effects = EffectListVO.fromXML(_arg_1, "effects");
            return (_local_2);
        }


        public function toString():String
        {
            return (this.name_string);
        }


    }
}
