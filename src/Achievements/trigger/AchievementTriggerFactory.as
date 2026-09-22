package Achievements.trigger
{
    import Trigger.ITriggerFactory;
    import Trigger.TriggerFactory;
    import Interface.cGeneralInterface;
    import Achievements.UserAchievement;
    import Trigger.Trigger;
    import Communication.VO.TriggerVO;
    import Trigger.Triggerable;
    import Communication.VO.Achievements.UserAchievementTriggerVO;

    public class AchievementTriggerFactory implements ITriggerFactory 
    {

        private var triggerFactory:TriggerFactory;

        public function AchievementTriggerFactory(_arg_1:cGeneralInterface)
        {
            super();
            this.triggerFactory = new TriggerFactory(_arg_1);
        }

        public function createTriggerWithInitData(_arg_1:TriggerVO, _arg_2:Triggerable, _arg_3:UserAchievementTriggerVO):Trigger
        {
            var _local_4:UserAchievement = (_arg_2 as UserAchievement);
            if (_local_4 == null)
            {
                return (null);
            };
            var _local_5:PersistedAchievementTriggerDeltaValue = new PersistedAchievementTriggerDeltaValue(_local_4, _arg_3.clone());
            this.triggerFactory.setDeltaValue(_local_5);
            var _local_6:Trigger = this.triggerFactory.createTrigger(_arg_1, _arg_2);
            return (new AchievementTrigger(_local_6));
        }

        public function createTrigger(_arg_1:TriggerVO, _arg_2:Triggerable):Trigger
        {
            var _local_3:UserAchievement = (_arg_2 as UserAchievement);
            if (_local_3 == null)
            {
                return (null);
            };
            var _local_4:PersistedAchievementTriggerDeltaValue = new PersistedAchievementTriggerDeltaValue(_local_3, new UserAchievementTriggerVO());
            this.triggerFactory.setDeltaValue(_local_4);
            var _local_5:Trigger = this.triggerFactory.createTrigger(_arg_1, _arg_2);
            return (new AchievementTrigger(_local_5));
        }


    }
}
