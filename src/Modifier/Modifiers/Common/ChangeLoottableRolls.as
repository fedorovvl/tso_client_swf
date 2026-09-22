package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import LootTableSystem.cLootTable;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;

    public final class ChangeLoottableRolls extends Modifier 
    {

        public static const xml_string:String = "changeloottablerolls";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cLootTable.USE_LOOTTABLE);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cLootTable = (_arg_1 as cLootTable);
            if (modifierVO.value != 0)
            {
                _local_2.SetChanceItemsAmount(modifierVO.value);
            };
            _local_2.SetChanceItemsAmount((((_local_2.GetChanceItemsAmount() * modifierVO.multiplier) + modifierVO.adder) as int));
            setModified(this);
            return (_arg_1);
        }


    }
}
