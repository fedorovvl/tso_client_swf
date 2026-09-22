package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import GO.cBuilding;
    import nLib.cLog;
    import MilitarySystem.cMilitaryUtil;

    public final class HireMilitary extends Effect 
    {

        public static const XML_string:String = "hiremilitary";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            effect.calculateGridPosFromXY(gi.mCurrentPlayerZone.mMapWidth);
            var _local_1:cBuilding = gi.mCurrentPlayerZone.GetBuildingFromGridPosition(effect.targetGridPos);
            if (_local_1 == null)
            {
                cLog.error("Invalid target for HireMilitary effect. Building not found!");
            }
            else
            {
                if (!_local_1.isGarrison())
                {
                    cLog.error("Invalid target for HireMilitary effect. Building is not a garrison!");
                }
                else
                {
                    (gi as cGameInterface).hireMilitaryUnits(_local_1.mPlayerData.GetPlayerId(), cMilitaryUtil.GetSpecialistFromGarrison(_local_1, gi), effect.name_string, effect.amount);
                };
            };
        }


    }
}
