package Modifier.Modifiers.Deposit
{
    import Modifier.Modifier;
    import ServerState.cComputeResourceCreation;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import GO.cBuilding;

    public final class SpeedUp extends Modifier 
    {

        public static const xml_string:String = "depositspeedup";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cComputeResourceCreation.DEPOSIT_WORK_BEGIN);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cBuilding = (_arg_1 as cBuilding);
            if (modifierVO.multiplier != 0)
            {
                _local_2.mStartWorkCounter = (_local_2.mStartWorkCounter + ((_local_2.GetResourceCreation().GetWorkTime() * 1000) * (1 - (1 / modifierVO.multiplier))));
            };
            _local_2.mStartWorkCounter = (_local_2.mStartWorkCounter - modifierVO.adder);
            setModified(this);
            return (_local_2);
        }


    }
}
