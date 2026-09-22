package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import AdventureSystem.ModifiableXP;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;

    public final class ChangeLootXP extends Modifier 
    {

        public static const xml_string:String = "changelootxp";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(ModifiableXP.USE_LOOT_XP);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:ModifiableXP = (_arg_1 as ModifiableXP);
            _local_2.xp = int(((_local_2.xp * modifierVO.multiplier) + modifierVO.adder));
            setModified(this);
            return (_arg_1);
        }


    }
}
