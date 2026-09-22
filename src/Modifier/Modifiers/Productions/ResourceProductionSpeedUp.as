package Modifier.Modifiers.Productions
{
    import Modifier.Modifier;
    import ServerState.cResourceCreation;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;

    public final class ResourceProductionSpeedUp extends Modifier 
    {

        public static const xml_string:String = "productionspeedup";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cResourceCreation.RESOURCE_CREATION_APPLY_MODIFIERS);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cResourceCreation = (_arg_1 as cResourceCreation);
            _local_2.SetProductionTimeModifiers(modifierVO.multiplier, (modifierVO.adder * 1000));
            setModified(this);
            return (_local_2);
        }


    }
}
