package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import LootTableSystem.cLootTable;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import LootTableSystem.cLootTableItemContent;
    import __AS3__.vec.Vector;
    import nLib.cLog;
    import __AS3__.vec.*;

    public final class ChangeLootChance extends Modifier 
    {

        public static const xml_string:String = "changelootchance";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cLootTable.USE_LOOTTABLE);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_9:cLootTableItemContent;
            var _local_10:Number;
            var _local_2:cLootTable = (_arg_1 as cLootTable);
            var _local_3:Vector.<cLootTableItemContent> = _local_2.mItemContents_vector;
            var _local_4:Vector.<cLootTableItemContent> = new Vector.<cLootTableItemContent>();
            var _local_5:Vector.<cLootTableItemContent> = new Vector.<cLootTableItemContent>();
            var _local_6:int;
            var _local_7:int;
            var _local_8:Number = 0;
            for each (_local_9 in _local_3)
            {
                if ((((modifierVO.item_string.length <= 0) || (modifierVO.item_string == _local_9.GetResourceName_string())) || (modifierVO.item_string == _local_9.GetName_string())))
                {
                    _local_4.push(_local_9);
                    _local_6 = (_local_6 + _local_9.GetPrio());
                    setModified(this);
                }
                else
                {
                    _local_5.push(_local_9);
                    _local_7 = (_local_7 + _local_9.GetPrio());
                };
            };
            _local_8 = (_local_6 + _local_7);
            _local_10 = ((100 / _local_8) * _local_6);
            if (modifierVO.value != 0)
            {
                _local_10 = modifierVO.value;
            };
            _local_10 = (((_local_10 * modifierVO.multiplier) + modifierVO.adder) as int);
            this.distributePrioRelative(_local_4, ((_local_8 * 0.01) * _local_10));
            this.distributePrioRelative(_local_5, ((_local_8 * 0.01) * (100 - _local_10)));
            _local_4 = _local_4.concat(_local_5);
            _local_2.mItemContents_vector = _local_4;
            if (cLog.isInfoEnabled())
            {
                cLog.info(("TEST OUTPUT for loot chance Change:" + _local_2));
            };
            return (_local_2);
        }

        private function distributePrioRelative(_arg_1:Vector.<cLootTableItemContent>, _arg_2:Number):void
        {
            var _local_4:Number;
            var _local_5:cLootTableItemContent;
            var _local_6:int;
            var _local_3:int;
            for each (_local_5 in _arg_1)
            {
                _local_3 = (_local_3 + _local_5.GetPrio());
            };
            _local_4 = (_arg_2 / _local_3);
            for each (_local_5 in _arg_1)
            {
                _local_6 = ((_local_5.GetPrio() * _local_4) as int);
                _local_5.SetPrio(Math.max(_local_6, 1));
            };
        }


    }
}
