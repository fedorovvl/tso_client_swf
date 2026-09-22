package Modifier.Modifiers.Productions
{
    import Modifier.Modifier;
    import Communication.VO.collectibles.CollectionVO;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;

    public class CollectionBuyFinishCost extends Modifier 
    {

        public static const xml_string:String = "collectionbuyfinishcost";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(CollectionVO.UPDATING_HARD_CURRENCY_PRICE);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:CollectionVO = (_arg_1 as CollectionVO);
            _local_2.setInstantBuildCostModifiers(modifierVO.multiplier, modifierVO.adder);
            _local_2.setModified(this);
            return (_local_2);
        }


    }
}
