package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import LootTableSystem.cLootTable;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import LootTableSystem.cLootTableItemContent;
    import __AS3__.vec.Vector;

    public final class ChangeLootPrio extends Modifier 
    {

        public static const xml_string:String = "changelootprio";


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
                if ((((modifierVO.item_string.length <= 0) || (modifierVO.item_string == _local_4.GetResourceName_string())) || (modifierVO.item_string == _local_4.GetName_string())))
                {
                    if (modifierVO.value != 0)
                    {
                        _local_4.SetPrio(modifierVO.value);
                    };
                    _local_4.SetPrio((((_local_4.GetPrio() * modifierVO.multiplier) + modifierVO.adder) as int));
                    setModified(this);
                };
            };
            return (_arg_1);
        }


    }
}
