package Communication.VO
{
    import mx.collections.ArrayCollection;
    import flash.utils.Dictionary;

    public class ExpeditionMapSizeVO 
    {

        public var expeditionMapSizeData:ArrayCollection = new ArrayCollection();
        // AMF may supply a plain object; locally the lookup is built as a Dictionary.
        public var expeditionMapSizeDictionary:Object = null;


        public function GetMapSizeDataForMapLevel(_arg_1:int):ExpeditionMapSizeDataVO
        {
            if (this.expeditionMapSizeDictionary == null)
            {
                this.CreateDictionary();
            };
            return (this.expeditionMapSizeDictionary[_arg_1]);
        }

        private function CreateDictionary():void
        {
            var _local_1:ExpeditionMapLevelGroupDataVO;
            var _local_2:ExpeditionMapSizeDataVO;
            var _local_3:int;
            var _local_4:int;
            this.expeditionMapSizeDictionary = new Dictionary();
            for each (_local_2 in this.expeditionMapSizeData)
            {
                _local_3 = _local_2.minLevelGroup;
                while (_local_3 <= _local_2.maxLevelGroup)
                {
                    _local_1 = global.expeditionMapLevelGroupVO.GetExpeditionMapLevelGroupDataVO(_local_3);
                    _local_4 = _local_1.levelMin;
                    while (_local_4 <= _local_1.levelMax)
                    {
                        this.expeditionMapSizeDictionary[_local_4] = _local_2;
                        _local_4++;
                    };
                    _local_3++;
                };
            };
        }


    }
}
