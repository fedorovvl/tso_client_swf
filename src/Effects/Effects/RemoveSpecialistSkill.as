package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Specialists.cSpecialist;
    import Utils.HashSetWrapper;
    import __AS3__.vec.Vector;
    import nLib.cLog;
    import Enums.SPECIALIST_TYPE;

    public class RemoveSpecialistSkill extends Effect 
    {

        public static const XML_string:String = "removespecialistskill";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:cSpecialist;
            var _local_2:HashSetWrapper;
            var _local_3:Vector.<cSpecialist>;
            var _local_4:cSpecialist;
            var _local_5:String;
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            if (effect.targetGridPos > 0)
            {
                _local_1 = gi.mCurrentPlayerZone.getSpecialistByGarrison(effect.targetGridPos);
                if (_local_1 != null)
                {
                    _local_1.skills.removeSkill(effect.id);
                }
                else
                {
                    cLog.warning(("Specialist not found for grid: " + effect.targetGridPos));
                };
            }
            else
            {
                _local_2 = new HashSetWrapper();
                if (effect.item_string.length == 0)
                {
                    _local_2.add(SPECIALIST_TYPE.EXPLORER);
                    _local_2.add(SPECIALIST_TYPE.GENERAL);
                    _local_2.add(SPECIALIST_TYPE.GEOLOGIST);
                    _local_2.add(SPECIALIST_TYPE.ADMIRAL);
                    _local_2.add(SPECIALIST_TYPE.TRANSPORTER_GENERAL);
                    _local_2.add(SPECIALIST_TYPE.TRANSPORTER_ADMIRAL);
                }
                else
                {
                    for each (_local_5 in effect.item_string.toLowerCase().split(","))
                    {
                        switch (_local_5)
                        {
                            case "explorer":
                                _local_2.add(SPECIALIST_TYPE.EXPLORER);
                                break;
                            case "general":
                                _local_2.add(SPECIALIST_TYPE.GENERAL);
                                break;
                            case "geologist":
                                _local_2.add(SPECIALIST_TYPE.GEOLOGIST);
                                break;
                            case "admiral":
                                _local_2.add(SPECIALIST_TYPE.ADMIRAL);
                                break;
                            case "transportergeneral":
                                _local_2.add(SPECIALIST_TYPE.TRANSPORTER_GENERAL);
                                break;
                            case "transporteradmiral":
                                _local_2.add(SPECIALIST_TYPE.TRANSPORTER_ADMIRAL);
                                break;
                        };
                    };
                };
                _local_3 = gi.mCurrentPlayerZone.GetSpecialists_vector();
                for each (_local_4 in _local_3)
                {
                    if (_local_2.contains(_local_4.GetBaseType()))
                    {
                        _local_4.skills.removeSkill(effect.id);
                    };
                };
            };
        }


    }
}
