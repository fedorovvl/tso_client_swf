package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Specialists.cSpecialist;
    import Utils.HashSetWrapper;
    import __AS3__.vec.Vector;
    import nLib.cLog;
    import Communication.VO.Skill.SkillVO;
    import Enums.SPECIALIST_TYPE;
    import Specialists.cSpecialistTask;

    public class SkillSpecialist extends Effect 
    {

        public static const XML_string:String = "skillspecialist";
        public static const TYPE_TEMP:String = "temp";
        public static const TYPE_PERSISTED:String = "persisted";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_3:cSpecialist;
            var _local_4:HashSetWrapper;
            var _local_5:Vector.<cSpecialist>;
            var _local_6:cSpecialist;
            var _local_7:String;
            var _local_1:* = (effect.type_string == TYPE_TEMP);
            if (((!(_local_1)) && (!(effect.type_string == TYPE_PERSISTED))))
            {
                cLog.warning(("No type specified for SkillSpecialist effect! " + effect));
                return;
            };
            var _local_2:SkillVO = new SkillVO();
            _local_2.id = effect.id;
            _local_2.level = effect.value;
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            if (effect.targetGridPos > 0)
            {
                _local_3 = gi.mCurrentPlayerZone.getSpecialistByGarrison(effect.targetGridPos);
                if (_local_3 != null)
                {
                    _local_3.skills.addSkill(_local_2, _local_3, gi, _local_1, false, true);
                }
                else
                {
                    cLog.warning(("Specialist not found for grid: " + effect.targetGridPos));
                };
            }
            else
            {
                _local_4 = new HashSetWrapper();
                if (effect.item_string.length == 0)
                {
                    _local_4.add(SPECIALIST_TYPE.EXPLORER);
                    _local_4.add(SPECIALIST_TYPE.GENERAL);
                    _local_4.add(SPECIALIST_TYPE.GEOLOGIST);
                    _local_4.add(SPECIALIST_TYPE.ADMIRAL);
                    _local_4.add(SPECIALIST_TYPE.TRANSPORTER_GENERAL);
                    _local_4.add(SPECIALIST_TYPE.TRANSPORTER_ADMIRAL);
                }
                else
                {
                    for each (_local_7 in effect.item_string.toLowerCase().split(","))
                    {
                        switch (_local_7)
                        {
                            case "explorer":
                                _local_4.add(SPECIALIST_TYPE.EXPLORER);
                                break;
                            case "general":
                                _local_4.add(SPECIALIST_TYPE.GENERAL);
                                break;
                            case "geologist":
                                _local_4.add(SPECIALIST_TYPE.GEOLOGIST);
                                break;
                            case "admiral":
                                _local_4.add(SPECIALIST_TYPE.ADMIRAL);
                                break;
                            case "transportergeneral":
                                _local_4.add(SPECIALIST_TYPE.TRANSPORTER_GENERAL);
                                break;
                            case "transporteradmiral":
                                _local_4.add(SPECIALIST_TYPE.TRANSPORTER_ADMIRAL);
                                break;
                        };
                    };
                };
                _local_5 = gi.mCurrentPlayerZone.GetSpecialists_vector();
                for each (_local_6 in _local_5)
                {
                    if (_local_4.contains(_local_6.GetBaseType()))
                    {
                        _local_6.skills.addSkill(_local_2, _local_6, gi, _local_1, false, true);
                        if (_local_6.GetTask() != null)
                        {
                            _local_6.notifyPropertyObserver(cSpecialistTask.TASK_RUNNING_UPDATE, _local_6.GetTask());
                        };
                    };
                };
            };
        }


    }
}
