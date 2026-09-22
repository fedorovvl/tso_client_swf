package Tasks
{
    import Fulfilments.FulfilmentPool;
    import __AS3__.vec.Vector;
    import Fulfilments.WeeklyRewardDefinition;
    import Utils.HashSetWrapper;
    import Fulfilments.CategoryDefinition;
    import Fulfilments.IdentityDefinition;
    import nLib.cXML;
    import Communication.VO.TriggerVO;
    import Communication.VO.EffectVO;
    import __AS3__.vec.*;

    public class TaskPool extends FulfilmentPool 
    {

        private static var singletonInstance:TaskPool;
        private static const NAME_ELEMENT_CATEGORIES:String = "categories";
        private static const NAME_ELEMENT_TASKS:String = "tasks";
        private static const NAME_ELEMENT_MAIN_CATEGORY:String = "mainCategory";
        private static const NAME_ELEMENT_WEEKLY_REWARDS:String = "weekRewards";
        private static const NAME_CATEGORY_ID:String = "id";
        private static const NAME_CATEGORY_NAME:String = "name";
        private static const NAME_CATEGORY_PARENT_ID:String = "parentId";
        private static const NAME_TASK_ID:String = "id";
        private static const NAME_TASK_NAME:String = "name";
        private static const NAME_TASK_CATEGORY_ID:String = "categoryId";
        private static const NAME_TASK_DISABLED:String = "disabled";
        private static const NAME_TASK_TRIGGER_SUBNODE:String = "triggers";
        private static const NAME_TASK_REWARDS_SUBNODE:String = "rewards";
        private static const NAME_TASK_IS_PVP:String = "isPvp";

        private var weeklyRewards:Vector.<WeeklyRewardDefinition>;
        private var taskBuildingNames:HashSetWrapper = new HashSetWrapper();

        public function TaskPool(_arg_1:Vector.<IdentityDefinition>, _arg_2:Vector.<CategoryDefinition>, _arg_3:Vector.<WeeklyRewardDefinition>)
        {
            var _local_4:CategoryDefinition;
            super(_arg_1, _arg_2);
            this.weeklyRewards = _arg_3;
            for each (_local_4 in _arg_2)
            {
                if (_local_4.isMainCategory())
                {
                    this.taskBuildingNames.add(_local_4.getName());
                };
            };
        }

        public static function getInstance():TaskPool
        {
            return (singletonInstance);
        }

        private static function parseTasks(_arg_1:cXML):Vector.<IdentityDefinition>
        {
            var _local_4:int;
            var _local_5:String;
            var _local_6:int;
            var _local_7:Boolean;
            var _local_9:cXML;
            var _local_10:Vector.<TriggerVO>;
            var _local_11:Vector.<EffectVO>;
            var _local_12:Vector.<cXML>;
            var _local_13:int;
            var _local_14:cXML;
            var _local_15:Vector.<cXML>;
            var _local_16:cXML;
            var _local_17:TriggerVO;
            var _local_18:EffectVO;
            var _local_2:Vector.<IdentityDefinition> = new Vector.<IdentityDefinition>();
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            var _local_8:Boolean;
            for each (_local_9 in _local_3)
            {
                _local_10 = new Vector.<TriggerVO>();
                _local_11 = new Vector.<EffectVO>();
                _local_4 = _local_9.GetAttributeInt(NAME_TASK_ID);
                _local_5 = _local_9.GetAttributeString_string(NAME_TASK_NAME);
                _local_6 = _local_9.GetAttributeInt(NAME_TASK_CATEGORY_ID);
                _local_7 = _local_9.GetAttributeBool(NAME_TASK_DISABLED);
                _local_8 = _local_9.GetAttributeBool(NAME_TASK_IS_PVP);
                _local_12 = _local_9.MoveToSubNode(NAME_TASK_TRIGGER_SUBNODE).CreateChildrenArray();
                _local_13 = 0;
                for each (_local_14 in _local_12)
                {
                    _local_17 = TriggerVO.createFromXML(_local_14, _local_13);
                    _local_10.push(_local_17);
                    _local_13++;
                };
                _local_15 = _local_9.MoveToSubNode(NAME_TASK_REWARDS_SUBNODE).CreateChildrenArray();
                for each (_local_16 in _local_15)
                {
                    _local_18 = EffectVO.CreateFromXML(_local_16);
                    _local_11.push(_local_18);
                };
                _local_2.push(new TaskDefinition(_local_4, _local_5, _local_6, _local_7, _local_8, _local_10, _local_11));
            };
            return (_local_2);
        }

        public static function setInstance(_arg_1:TaskPool):void
        {
            singletonInstance = _arg_1;
        }

        private static function parseWeeklyReward(_arg_1:cXML):Vector.<WeeklyRewardDefinition>
        {
            var _local_4:cXML;
            var _local_5:WeeklyRewardDefinition;
            var _local_6:Vector.<cXML>;
            var _local_7:cXML;
            var _local_8:EffectVO;
            var _local_2:Vector.<WeeklyRewardDefinition> = new Vector.<WeeklyRewardDefinition>();
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_4 in _local_3)
            {
                _local_5 = new WeeklyRewardDefinition();
                _local_5.id = _local_4.GetAttributeInt(NAME_TASK_ID);
                _local_5.rewards = new Vector.<EffectVO>();
                _local_6 = _local_4.MoveToSubNode(NAME_TASK_REWARDS_SUBNODE).CreateChildrenArray();
                for each (_local_7 in _local_6)
                {
                    _local_8 = EffectVO.CreateFromXML(_local_7);
                    _local_5.rewards.push(_local_8);
                };
                _local_2.push(_local_5);
            };
            return (_local_2);
        }

        public static function parseXML(_arg_1:cXML):TaskPool
        {
            return (new TaskPool(parseTasks(_arg_1.MoveToSubNode(NAME_ELEMENT_TASKS)), parseCategories(_arg_1.MoveToSubNode(NAME_ELEMENT_CATEGORIES)), parseWeeklyReward(_arg_1.MoveToSubNode(NAME_ELEMENT_WEEKLY_REWARDS))));
        }

        private static function parseCategories(_arg_1:cXML):Vector.<CategoryDefinition>
        {
            var _local_4:int;
            var _local_5:String;
            var _local_6:int;
            var _local_7:Boolean;
            var _local_8:cXML;
            var _local_2:Vector.<CategoryDefinition> = new Vector.<CategoryDefinition>();
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_8 in _local_3)
            {
                _local_4 = _local_8.GetAttributeInt(NAME_CATEGORY_ID);
                _local_5 = _local_8.GetAttributeString_string(NAME_CATEGORY_NAME);
                _local_6 = _local_8.GetAttributeInt(NAME_CATEGORY_PARENT_ID);
                _local_7 = (_local_8.GetName_string() == NAME_ELEMENT_MAIN_CATEGORY);
                _local_2.push(new CategoryDefinition(_local_4, _local_5, _local_6, _local_7));
            };
            return (_local_2);
        }


        public function isTaskBuilding(_arg_1:String):Boolean
        {
            return (this.taskBuildingNames.contains(_arg_1));
        }

        public function getTaskBuildingNames_vector():Vector.<String>
        {
            var _local_2:Object;
            var _local_1:Vector.<String> = new Vector.<String>();
            for each (_local_2 in this.taskBuildingNames.toArray())
            {
                _local_1.push((_local_2 as String));
            };
            return (_local_1);
        }

        public function getWeeklyRewards(_arg_1:int):WeeklyRewardDefinition
        {
            var _local_2:WeeklyRewardDefinition;
            for each (_local_2 in this.weeklyRewards)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }


    }
}
