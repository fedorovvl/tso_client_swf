package Communication.VO.UpdateVO
{
    import Communication.VO.dUniqueID;
    import Communication.VO.Mail.dMailVO;
    import mx.collections.ArrayCollection;
    import Communication.VO.dBuffVO;
    import Communication.VO.dSpecialistVO;
    import Communication.VO.dResourceVO;
    import Communication.VO.EffectVO;
    import flash.utils.Dictionary;

    public class dLootItemsVO 
    {

        public var shopItemId:int;
        public var uniqueID:dUniqueID;
        public var mailVO:dMailVO;

        public var items:ArrayCollection = new ArrayCollection();
        public var uniqueIDs:ArrayCollection = new ArrayCollection();
        public var premiumItems:ArrayCollection = new ArrayCollection();
        public var premiumUniqueIDs:ArrayCollection = new ArrayCollection();


        public static function createWithItems(... _args):dLootItemsVO
        {
            var _local_3:dBuffVO;
            var _local_2:dLootItemsVO = new (dLootItemsVO)();
            for each (_local_3 in _args)
            {
                _local_2.items.addItem(_local_3);
            };
            return (_local_2);
        }


        public function toSummedString():String
        {
            var _local_3:String;
            var _local_4:Object;
            var _local_5:String;
            var _local_6:Object;
            var _local_7:dBuffVO;
            var _local_8:dSpecialistVO;
            var _local_9:dResourceVO;
            var _local_10:EffectVO;
            var _local_1:Array = this.items.source.concat();
            var _local_2:Dictionary = new Dictionary();
            for each (_local_4 in _local_1)
            {
                if ((_local_4 is dBuffVO))
                {
                    _local_7 = (_local_4 as dBuffVO);
                    _local_3 = ((((("Buff_" + _local_7.buffName_string) + "_") + _local_7.resourceName_string) + "_") + _local_7.amount);
                }
                else
                {
                    if ((_local_4 is dSpecialistVO))
                    {
                        _local_8 = (_local_4 as dSpecialistVO);
                        _local_3 = ((("Specialist_" + _local_8.specialistType) + "_") + _local_8.name_string);
                    }
                    else
                    {
                        if ((_local_4 is dResourceVO))
                        {
                            _local_9 = (_local_4 as dResourceVO);
                            _local_3 = ((("Resource_" + _local_9.name_string) + "_") + _local_9.amount);
                        }
                        else
                        {
                            if ((_local_4 is EffectVO))
                            {
                                _local_10 = (_local_4 as EffectVO);
                                _local_3 = ((((((("Effect_" + _local_10.effect_string) + "_") + _local_10.name_string) + "_") + _local_10.type_string) + "_") + _local_10.amount);
                            }
                            else
                            {
                                _local_3 = _local_4.toString();
                            };
                        };
                    };
                };
                if (!_local_2[_local_3])
                {
                    _local_2[_local_3] = 0;
                };
                _local_2[_local_3]++;
            };
            _local_5 = "";
            _local_5 = (_local_5 + "<dLootItemsVO>\n");
            for (_local_6 in _local_2)
            {
                _local_5 = (_local_5 + (((_local_2[_local_6] + "   ") + _local_6) + "\n"));
            };
            _local_5 = (_local_5 + "</dLootItemsVO>\n");
            return (_local_5);
        }

        public function toString():String
        {
            var _local_2:Object;
            var _local_3:Object;
            var _local_4:Object;
            var _local_5:Object;
            var _local_1:* = "";
            _local_1 = (_local_1 + (((((("<dLootItemsVO shopItemId='" + this.shopItemId) + " mailVO='") + ((this.mailVO != null) ? this.mailVO.toString() : "")) + "' uniqueID='") + _local_4) + "' >"));
            for each (_local_2 in this.items)
            {
                _local_1 = (_local_1 + (("  " + _local_2) + "\n"));
            };
            for each (_local_3 in this.premiumItems)
            {
                _local_1 = (_local_1 + (("  " + _local_3) + "\n"));
            };
            for each (_local_4 in this.uniqueIDs)
            {
                _local_1 = (_local_1 + (("  " + _local_4) + "\n"));
            };
            for each (_local_5 in this.premiumUniqueIDs)
            {
                _local_1 = (_local_1 + (("  " + _local_5) + "\n"));
            };
            return (_local_1 + "</dLootItemsVO>\n");
        }


    }
}
