package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import LootTableSystem.cLootTable;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import LootTableSystem.cLootTableItemContent;
    import __AS3__.vec.Vector;
    import Enums.ITEM_CONTENT_TYPE;

    public final class ChangeLootCount extends Modifier 
    {

        public static const xml_string:String = "changelootcount";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cLootTable.USE_LOOTTABLE);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_4:cLootTableItemContent;
            var _local_2:cLootTable = (_arg_1 as cLootTable);
            var _local_3:Vector.<cLootTableItemContent> = _local_2.mItemContents_vector;
            for each (_local_4 in _local_3)
            {
                if ("type" == modifierVO.property_string)
                {
                    if (modifierVO.item_string != ITEM_CONTENT_TYPE.toString(_local_4.GetType())) continue;
                }
                else
                {
                    if ("name" == modifierVO.property_string)
                    {
                        if (modifierVO.item_string != _local_4.GetName_string()) continue;
                    }
                    else
                    {
                        if (((modifierVO.item_string.length > 0) && (!((modifierVO.item_string == _local_4.GetResourceName_string()) || (modifierVO.item_string == _local_4.GetName_string()))))) continue;
                    };
                };
                if (modifierVO.value != 0)
                {
                    _local_4.SetCount(modifierVO.value);
                };
                _local_4.SetCount(((((_local_4.GetCount() * modifierVO.multiplier) + modifierVO.adder) + 0.5) as int));
                setModified(this);
            };
            return (_arg_1);
        }


    }
}
