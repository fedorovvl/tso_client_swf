package Achievements
{
    import __AS3__.vec.Vector;
    import Communication.VO.Achievements.AchievementVO;
    import Communication.VO.Achievements.AchievementCategoriesVO;
    import flash.utils.Dictionary;
    import GUI.achievement.vo.CategoryGUIDetailVO;
    import GUI.achievement.vo.AchievementGUIDetailVO;

    public class AchievementsManager 
    {

        private static var singletonInstance:AchievementsManager;
        private static var maxNumberOfAchievementAvatarPopupsToShow:int;

        private var achievementsVector:Vector.<AchievementVO>;
        private var achievementCategoriesVector:Vector.<AchievementCategoriesVO>;

        private var disabledAchievements:Dictionary = new Dictionary();
        private var achievementGUIHashMap:Dictionary = new Dictionary();
        private var categoryGUIHashMap:Dictionary = new Dictionary();
        private var achievementMap:Dictionary = new Dictionary();
        private var achievementCategoryMap:Dictionary = new Dictionary();

        public function AchievementsManager(_arg_1:Vector.<AchievementVO>, _arg_2:Vector.<AchievementCategoriesVO>)
        {
            var _local_3:AchievementVO;
            var _local_4:AchievementCategoriesVO;
            super();
            this.achievementsVector = _arg_1;
            for each (_local_3 in _arg_1)
            {
                this.achievementMap[_local_3.getAchievementID()] = _local_3;
            };
            this.achievementCategoriesVector = _arg_2;
            for each (_local_4 in _arg_2)
            {
                this.achievementCategoryMap[_local_4.getCategoryID()] = _local_4;
            };
            this.buildDisabledAchievements();
        }

        public static function getMaxNumberOfAchievementAvatarPopupsToShow():int
        {
            return (maxNumberOfAchievementAvatarPopupsToShow);
        }

        public static function getInstance():AchievementsManager
        {
            return (singletonInstance);
        }

        public static function setInstance(_arg_1:AchievementsManager):void
        {
            singletonInstance = _arg_1;
        }


        public function setGUIDetails(_arg_1:Dictionary, _arg_2:Dictionary, _arg_3:int):void
        {
            this.achievementGUIHashMap = _arg_1;
            this.categoryGUIHashMap = _arg_2;
            maxNumberOfAchievementAvatarPopupsToShow = ((_arg_3 == 0) ? int.MAX_VALUE : _arg_3);
        }

        private function buildDisabledAchievements():void
        {
            var _local_3:AchievementVO;
            var _local_1:int;
            var _local_2:int = this.achievementsVector.length;
            while (_local_1 < _local_2)
            {
                _local_3 = this.achievementsVector[_local_1];
                if (_local_3.getDisabled())
                {
                    this.disabledAchievements[_local_3.getAchievementID()] = _local_3;
                };
                _local_1++;
            };
        }

        public function getCategoryGUIDetailVO(_arg_1:int):CategoryGUIDetailVO
        {
            return (this.categoryGUIHashMap[_arg_1]);
        }

        public function getAchievementById(_arg_1:int):AchievementVO
        {
            return (this.achievementMap[_arg_1]);
        }

        public function getAchievementGUIDetailVO(_arg_1:int):AchievementGUIDetailVO
        {
            return (this.achievementGUIHashMap[_arg_1]);
        }

        public function getAchievementCategoryById(_arg_1:int):AchievementCategoriesVO
        {
            return (this.achievementCategoryMap[(this.achievementMap[_arg_1] as AchievementVO).getCategoryID()]);
        }

        public function getAchievementCategoryByCategoryId(_arg_1:int):AchievementCategoriesVO
        {
            return (this.achievementCategoryMap[_arg_1]);
        }

        public function getAchievementCategoriesVector():Vector.<AchievementCategoriesVO>
        {
            return (this.achievementCategoriesVector);
        }

        public function getAchievementsVector():Vector.<AchievementVO>
        {
            return (this.achievementsVector);
        }

        public function getAchievementIsDisabled(_arg_1:int):Boolean
        {
            return (!(this.disabledAchievements[_arg_1] == null));
        }


    }
}
