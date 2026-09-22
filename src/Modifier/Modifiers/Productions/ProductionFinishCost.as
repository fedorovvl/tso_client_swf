package Modifier.Modifiers.Productions
{
    import Modifier.Modifier;
    import TimedProduction.cAbstractTimedProductionOrder;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;

    public class ProductionFinishCost extends Modifier 
    {

        public static const xml_string:String = "productionfinishcost";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cAbstractTimedProductionOrder.PRODUCTION_START);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cAbstractTimedProductionOrder = (_arg_1 as cAbstractTimedProductionOrder);
            _local_2.SetInstantFinishCostModifiers(modifierVO.multiplier, modifierVO.adder);
            setModified(this);
            return (_local_2);
        }


    }
}
