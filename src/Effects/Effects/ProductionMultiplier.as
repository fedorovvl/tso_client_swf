package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Utils.HashSetWrapper;
    import GO.cBuilding;
    import __AS3__.vec.Vector;
    import Utils.DictionaryUtils;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;

    public class ProductionMultiplier extends Effect 
    {

        public static const XML_string:String = "productionmultiplier";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_5:HashSetWrapper;
            var _local_1:cBuilding;
            var _local_2:Vector.<cBuilding> = gi.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector();
            var _local_3:int;
            var _local_4:int = _local_2.length;
            _local_5 = DictionaryUtils.fromCommaSeparatedList(effect.item_string);
            var _local_6:Boolean = _local_5.contains("Workyard");
            while (_local_3 < _local_4)
            {
                _local_1 = _local_2[_local_3];
                if (_local_1 != null)
                {
                    if (((((_local_6) && (!(_local_1 is EpicWorkyardSubBuilding))) && (_local_1.isWorkyard())) || (_local_5.contains(_local_1.GetBuildingName_string()))))
                    {
                        _local_1.buffMultiplier = effect.value;
                    };
                };
                _local_3++;
            };
        }


    }
}
