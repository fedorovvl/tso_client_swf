package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import LootTableSystem.cLootTable;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import Communication.VO.EffectVO;
    import __AS3__.vec.Vector;
    import LootTableSystem.cLootTableItemContent;

    public final class RemoveLoot extends Modifier 
    {

        public static const xml_string:String = "removeloot";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cLootTable.USE_LOOTTABLE);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_3:EffectVO;
            var _local_4:Vector.<cLootTableItemContent>;
            var _local_5:cLootTableItemContent;
            var _local_6:cLootTableItemContent;
            var _local_2:cLootTable = (_arg_1 as cLootTable);
            for each (_local_3 in modifierVO.effects_vector)
            {
                _local_4 = _local_2.mItemContents_vector;
                _local_5 = cLootTableItemContent.CreateLootTableItemContentFromEffectVO(_local_3);
                for each (_local_6 in _local_4)
                {
                    if (((((_local_3.type_string.length <= 0) || (_local_5.GetType() == _local_6.GetType())) && ((_local_5.GetName_string().length <= 0) || (_local_5.GetName_string() == _local_6.GetName_string()))) && ((_local_5.GetResourceName_string().length <= 0) || (_local_5.GetResourceName_string() == _local_6.GetResourceName_string()))))
                    {
                        _local_4.splice(_local_4.indexOf(_local_6), 1);
                        setModified(this);
                    };
                };
            };
            return (_arg_1);
        }


    }
}
