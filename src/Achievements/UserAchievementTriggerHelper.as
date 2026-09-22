package Achievements
{
    import Utils.HashMapWrapper;
    import Communication.VO.Achievements.AchievementTriggerUIDetailVO;
    import nLib.gMisc;
    import Communication.VO.TriggerVO;

    public class UserAchievementTriggerHelper 
    {

        private static var triggerHashMap:HashMapWrapper;

        public function UserAchievementTriggerHelper()
        {
            super();
            throw (new Error("Do not instantiate this, it is only a helper class!"));
        }

        public static function setTriggerHashmap(_arg_1:HashMapWrapper):void
        {
            triggerHashMap = _arg_1;
        }

        public static function getTriggerType(_arg_1:TriggerVO):String
        {
            var _local_2:AchievementTriggerUIDetailVO = (triggerHashMap.getItem(_arg_1.action_string) as AchievementTriggerUIDetailVO);
            if (_local_2 != null)
            {
                if ((((_arg_1.min == 1) && (_arg_1.max == 1)) || (_arg_1.amount == 1)))
                {
                    return (AchievementConsts.TRIGGER_TYPE_CHECKBOX);
                };
                return (_local_2.getType());
            };
            gMisc.Assert(false, ("Unknown achievement trigger type:" + _arg_1.action_string));
            return (null);
        }

        public static function getTriggerProgress(_arg_1:TriggerVO, _arg_2:int):Number
        {
            var _local_4:Number;
            var _local_3:AchievementTriggerUIDetailVO = (triggerHashMap.getItem(_arg_1.action_string) as AchievementTriggerUIDetailVO);
            gMisc.Assert((!(_local_3 == null)), ("Unknown trigger type:" + _arg_1.action_string));
            gMisc.Assert((_local_3.getType() == AchievementConsts.TRIGGER_TYPE_PROGRESS), (("Trigger [" + _arg_1.action_string) + "] is not a progress trigger type!"));
            var _local_5:String = _local_3.getProgress();
            if ((((!(_local_5 == "")) && (!(_arg_1[_local_5] == null))) && (int(_arg_1[_local_5]) > 0)))
            {
                _local_4 = (_arg_2 / int(_arg_1[_local_5]));
                return ((_local_4 > 1) ? 1 : _local_4);
            };
            gMisc.Assert(false, (("Progress parameter is set wrong for [" + _arg_1.action_string) + "]!"));
            return (0);
        }

        public static function getTriggerMaxValue(_arg_1:TriggerVO):int
        {
            var _local_2:AchievementTriggerUIDetailVO = (triggerHashMap.getItem(_arg_1.action_string) as AchievementTriggerUIDetailVO);
            gMisc.Assert((!(_local_2 == null)), ("Unknown trigger type:" + _arg_1.action_string));
            gMisc.Assert((_local_2.getType() == AchievementConsts.TRIGGER_TYPE_PROGRESS), (("Trigger [" + _arg_1.action_string) + "] is not a progress trigger type!"));
            var _local_3:String = _local_2.getProgress();
            if ((((!(_local_3 == "")) && (!(_arg_1[_local_3] == null))) && (int(_arg_1[_local_3]) > 0)))
            {
                return (int(_arg_1[_local_3]));
            };
            gMisc.Assert(false, (("Progress parameter is set wrong for [" + _arg_1.action_string) + "]!"));
            return (0);
        }


        public function getTriggerLocalizedText(_arg_1:TriggerVO):String
        {
            return (null);
        }


    }
}
