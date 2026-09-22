package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGameInterface;
    import Model.Notifier;
    import Achievements.UserAchievementCategory;

    public class AchievementsPointsTrigger extends InstantTrigger implements Observer 
    {

        public static var ACHIEVEMENT_COMPLETED:String = "ACHIEVEMENT_COMPLETED";

        public function AchievementsPointsTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGameInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.ZONE.addPropertyObserver(ACHIEVEMENT_COMPLETED, this);
        }

        override public function dispose():void
        {
            (para as cGameInterface).channels.ZONE.removePropertyObserver(ACHIEVEMENT_COMPLETED, this);
            super.dispose();
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= definition.min)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_1:cGameInterface = (para as cGameInterface);
            if (_local_1.getCurrentUserAchievementManager() == null)
            {
                return (getCurrentAmount());
            };
            var _local_2:UserAchievementCategory = _local_1.getCurrentUserAchievementManager().getAchievementCategoryForName(definition.item_string);
            return (_local_2.getPoints());
        }


    }
}
