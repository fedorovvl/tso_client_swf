package Modifier.Modifiers.Combat
{
    import Modifier.Modifier;
    import Model.Notifiers.SpecialistNotifier;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import Specialists.cSpecialist;

    public class UnitCapacity extends Modifier 
    {

        public static const xml_string:String = "unitcapacity";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(SpecialistNotifier.SKILLS_CHANGED);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cSpecialist = (_arg_1 as cSpecialist);
            if (((!(_local_2 == null)) && (_local_2.isModifierApplyable(modifierVO))))
            {
                _local_2.setModified(this);
                if (modifierVO.adder != 0)
                {
                    _local_2.AddUnitCapacityModifier(modifierVO.adder);
                };
            };
            return (_local_2);
        }


    }
}
