package Modifier.Modifiers.Combat
{
    import Modifier.Modifier;
    import Model.Notifiers.SpecialistNotifier;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import Specialists.cSpecialistTask_AttackBuilding;

    public class CombatRoundDuration extends Modifier 
    {

        public static const xml_string:String = "combatroundduration";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(SpecialistNotifier.TASK_ATTACK_BUILDING_STARTED);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cSpecialistTask_AttackBuilding;
            setModified(this);
            if ((_arg_1 is cSpecialistTask_AttackBuilding))
            {
                _local_2 = (_arg_1 as cSpecialistTask_AttackBuilding);
                _local_2.SetCombatRoundTimeMultiplier(modifierVO.multiplier);
            };
            return (_arg_1);
        }


    }
}
