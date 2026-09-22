package Modifier.Modifiers.Combat
{
    import Modifier.Modifier;
    import Utils.StringUtils;
    import Enums.COMBAT_MODIFIER_SIDE;
    import Modifier.ModifierVO;
    import MilitarySystem.cMilitaryUnitDescription;
    import Model.Notifiers.SpecialistNotifier;
    import Interface.cGeneralInterface;

    public final class CombatModifier extends Modifier 
    {

        public static const xml_string:String = "combatmodifier";


        public static function combatModifierAppliesToSide(_arg_1:ModifierVO, _arg_2:cMilitaryUnitDescription):Boolean
        {
            return ((StringUtils.equalsIgnoreCase(_arg_1.modifier_string, CombatModifier.xml_string)) && (((((!(_arg_2.IsNPC())) || (_arg_2.IsSpecialist())) && (StringUtils.equalsIgnoreCase(_arg_1.name_string, COMBAT_MODIFIER_SIDE.PLAYER_string))) || (((_arg_2.IsNPC()) && (!(_arg_2.IsSpecialist()))) && (StringUtils.equalsIgnoreCase(_arg_1.name_string, COMBAT_MODIFIER_SIDE.ENEMY_string)))) || (StringUtils.isEmpty(_arg_1.name_string))));
        }

        public static function combatModifierTypeAppliesToUnit(_arg_1:ModifierVO, _arg_2:cMilitaryUnitDescription):Boolean
        {
            return (((StringUtils.isEmpty(_arg_1.type_string)) || (StringUtils.equalsIgnoreCase(_arg_1.type_string, _arg_2.GetType()))) || (StringUtils.equalsIgnoreCase(_arg_1.type_string, _arg_2.GetCombatantType())));
        }

        public static function saveMulti(_arg_1:int, _arg_2:Number):int
        {
            return (int(((((_arg_1 as Number) * 1000) * (_arg_2 * 1000)) / 1000000)));
        }

        public static function applyDamageMultiplier(_arg_1:int, _arg_2:int, _arg_3:Number):int
        {
            if (_arg_3 > 1)
            {
                return ((_arg_2 + saveMulti(_arg_1, _arg_3)) - _arg_1);
            };
            return (saveMulti(_arg_2, _arg_3));
        }


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(SpecialistNotifier.TASK_ATTACK_BUILDING_STARTED);
        }

        override public function modify(_arg_1:Object):Object
        {
            setModified(this);
            return (_arg_1);
        }


    }
}
