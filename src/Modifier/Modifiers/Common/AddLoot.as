package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import LootTableSystem.cLootTable;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import Communication.VO.EffectVO;
    import LootTableSystem.cLootTableItemContent;

    public final class AddLoot extends Modifier 
    {

        public static const xml_string:String = "addloot";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cLootTable.USE_LOOTTABLE);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_3:EffectVO;
            var _local_2:cLootTable = (_arg_1 as cLootTable);
            for each (_local_3 in modifierVO.effects_vector)
            {
                _local_2.mItemContents_vector.push(cLootTableItemContent.CreateLootTableItemContentFromEffectVO(_local_3));
            };
            setModified(this);
            return (_arg_1);
        }


    }
}
