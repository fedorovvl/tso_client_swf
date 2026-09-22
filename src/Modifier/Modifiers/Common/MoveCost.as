package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import Utils.ModifiableCost;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import ServerState.dResource;

    public class MoveCost extends Modifier 
    {

        public static const xml_string:String = "movecost";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(ModifiableCost.MOVE_COST);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_3:dResource;
            var _local_2:ModifiableCost = (_arg_1 as ModifiableCost);
            for each (_local_3 in _local_2.cost)
            {
                _local_3.amount = int(((_local_3.amount * modifierVO.multiplier) + modifierVO.adder));
            };
            _local_2.setModified(this);
            return (_local_2);
        }


    }
}
