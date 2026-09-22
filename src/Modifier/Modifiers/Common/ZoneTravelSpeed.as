package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import Specialists.cSpecialistTask_TravelToZone;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import Modifier.Modifiers.Combat.CombatModifier;

    public class ZoneTravelSpeed extends Modifier 
    {

        public static const xml_string:String = "zonetravelspeed";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(cSpecialistTask_TravelToZone.TASK_TRAVEL_TO_ZONE_START);
            registerPropertySignal(cSpecialistTask_TravelToZone.TASK_PERFORM_TRAVEL);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_2:cSpecialistTask_TravelToZone = (_arg_1 as cSpecialistTask_TravelToZone);
            if (_local_2 != null)
            {
                if (modifierVO.value != 0)
                {
                    _local_2.SetNeededTime(modifierVO.value);
                };
                _local_2.SetNeededTime((CombatModifier.saveMulti(_local_2.GetNeededTime(), modifierVO.multiplier) + modifierVO.adder));
                _local_2.setModified(this);
                return (_local_2);
            };
            return (_arg_1);
        }


    }
}
