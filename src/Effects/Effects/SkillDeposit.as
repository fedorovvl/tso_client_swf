package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Communication.VO.Skill.SkillVO;
    import GO.cDeposit;
    import nLib.cLog;

    public final class SkillDeposit extends Effect 
    {

        public static const XML_string:String = "skilldeposit";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_3:SkillVO;
            var _local_1:cDeposit;
            if (effect.index > 0)
            {
                _local_1 = gi.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(effect.index);
            };
            if (_local_1 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info(((("Effect failed - No Deposit found on GridIdx = " + effect.index) + " ") + effect));
                };
                return;
            };
            if (effect.skillID > 0)
            {
                _local_3 = new SkillVO();
                _local_3.id = effect.skillID;
                _local_3.level = effect.skillLevel;
                _local_1.skills.addSkill(_local_3, _local_1, gi, false, false, true);
            };
            var _local_2:SkillVO = new SkillVO();
            _local_2.id = effect.id;
            _local_2.level = effect.value;
            _local_1.skills.addSkill(_local_2, _local_1, gi, false, false, true);
        }


    }
}
