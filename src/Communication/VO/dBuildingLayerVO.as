package Communication.VO
{
    import Enums.BUILDING_LAYER_COMPUTED_EFFECT;
    import nLib.cXML;

    public final class dBuildingLayerVO 
    {

        public var gosetlistName:String;
        public var offsetX:int;
        public var computedEffectData:Number = 0;
        public var offsetY:int;
        public var isGoset:Boolean;
        public var conditions:TriggerListVO;
        public var computedEffect:int = 0;


        public static function createFromXML(_arg_1:cXML):dBuildingLayerVO
        {
            var _local_2:dBuildingLayerVO = new (dBuildingLayerVO)();
            _local_2.gosetlistName = _arg_1.GetAttributeString_string("gosetlist", "");
            if ("" == _local_2.gosetlistName)
            {
                _local_2.isGoset = true;
                _local_2.gosetlistName = _arg_1.GetAttributeString_string("goset", "");
            }
            else
            {
                _local_2.isGoset = false;
            };
            _local_2.offsetX = _arg_1.GetAttributeInt("offsetX");
            _local_2.offsetY = _arg_1.GetAttributeInt("offsetY");
            _local_2.computedEffect = BUILDING_LAYER_COMPUTED_EFFECT.fromString(_arg_1.GetAttributeString_string("effect").toLowerCase());
            _local_2.computedEffectData = _arg_1.GetAttributeFloatingPoint("effectData", 1);
            _local_2.conditions = TriggerListVO.fromXML(_arg_1, "conditions");
            return (_local_2);
        }


    }
}
