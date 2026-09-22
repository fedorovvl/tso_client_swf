package Modifier.Modifiers.Common
{
    import Modifier.Modifier;
    import Modifier.ModifierVO;
    import Interface.cGeneralInterface;
    import Communication.VO.EffectVO;
    import __AS3__.vec.Vector;
    import Specialists.cSpecialistTask;
    import Effects.EffectEnricher;
    import __AS3__.vec.*;

    public final class ModifierEffect extends Modifier 
    {

        public static const xml_string:String = "modifiereffect";


        override public function init(_arg_1:ModifierVO, _arg_2:cGeneralInterface):void
        {
            super.init(_arg_1, _arg_2);
            registerPropertySignal(_arg_1.property_string);
        }

        override public function modify(_arg_1:Object):Object
        {
            var _local_3:EffectVO;
            var _local_4:EffectVO;
            var _local_5:Vector.<EffectVO>;
            var _local_6:EffectVO;
            var _local_7:cSpecialistTask;
            var _local_2:EffectEnricher = (_arg_1 as EffectEnricher);
            for each (_local_3 in modifierVO.effects_vector)
            {
                _local_4 = _local_3.clone();
                _local_5 = new Vector.<EffectVO>();
                if (_local_2 != null)
                {
                    _local_2.enrichEffect(_local_4);
                    _local_5 = _local_2.enrichExtraEffects(_local_4);
                };
                _local_4.skillID = ownerSkill.getId();
                _local_4.skillLevel = ownerSkill.getLevel();
                gi.effectFactory.createEffect(_local_4).applyControlled();
                if (_local_5 != null)
                {
                    for each (_local_6 in _local_5)
                    {
                        _local_6.skillID = ownerSkill.getId();
                        _local_6.skillLevel = ownerSkill.getLevel();
                        gi.effectFactory.createEffect(_local_6).applyControlled();
                    };
                };
                setModified(this);
            };
            if ((_arg_1 is cSpecialistTask))
            {
                _local_7 = (_arg_1 as cSpecialistTask);
            };
            return (_arg_1);
        }


    }
}
