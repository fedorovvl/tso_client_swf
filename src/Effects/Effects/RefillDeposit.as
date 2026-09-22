package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import GO.cDeposit;
    import Communication.VO.Skill.SkillVO;

    public final class RefillDeposit extends Effect 
    {

        public static const XML_string:String = "refilldeposit";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:int;
            var _local_2:cDeposit;
            var _local_3:SkillVO;
            if (effect.randomSeed == 0)
            {
                effect.randomSeed = gi.getSeed();
                _local_1 = int((effect.effectDelay * gi.mGlobalTimeScale));
            }
            else
            {
                _local_2 = gi.mCurrentPlayerZone.mStreetDataMap.getRandomDepositByType(effect.type_string, effect.randomSeed);
                if (_local_2 != null)
                {
                    if (effect.amount > 0)
                    {
                        _local_2.AddAmount(effect.amount);
                    };
                    if (effect.skillID > 0)
                    {
                        _local_3 = new SkillVO();
                        _local_3.id = effect.skillID;
                        _local_3.level = effect.skillLevel;
                        _local_2.skills.addSkill(_local_3, _local_2, gi, false, false, true);
                    };
                };
            };
        }


    }
}
