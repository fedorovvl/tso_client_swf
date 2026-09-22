package Communication.VO
{
    import mx.collections.ArrayCollection;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.REQUIREMENT_TYPE;
    import __AS3__.vec.Vector;
    import Skill.cSkill;
    import Skill.cSkillList;
    import __AS3__.vec.*;

    public class dRequirementsVO 
    {

        public var requirements:ArrayCollection = new ArrayCollection();


        public function get locaString():String
        {
            var _local_2:dRequirementVO;
            var _local_1:* = (cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Requires") + ":");
            for each (_local_2 in this.requirements)
            {
                if (((!(_local_2.fulfilled)) && (_local_2.type == REQUIREMENT_TYPE.LEVEL)))
                {
                    _local_1 = (_local_1 + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Level", [_local_2.value])));
                };
            };
            for each (_local_2 in this.requirements)
            {
                if (((!(_local_2.fulfilled)) && (_local_2.type == REQUIREMENT_TYPE.QUEST)))
                {
                    _local_1 = (_local_1 + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "FinishedQuest", [cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_LABELS, _local_2.value)])));
                };
            };
            for each (_local_2 in this.requirements)
            {
                if (((!(_local_2.fulfilled)) && (_local_2.type == REQUIREMENT_TYPE.SKILL)))
                {
                    if (_local_2.value.toLowerCase().indexOf("recipe") != -1)
                    {
                        _local_1 = (_local_1 + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Recipe", [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_2.value)])));
                    }
                    else
                    {
                        _local_1 = (_local_1 + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Skill", [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_2.value)])));
                    };
                };
            };
            return (_local_1);
        }

        public function isFulfilled():Boolean
        {
            var _local_2:dRequirementVO;
            var _local_1:Boolean = true;
            for each (_local_2 in this.requirements)
            {
                _local_1 = ((_local_1) && (_local_2.fulfilled));
            };
            return (_local_1);
        }

        public function getRequirementsByType(_arg_1:int):Vector.<dRequirementVO>
        {
            var _local_3:dRequirementVO;
            var _local_2:Vector.<dRequirementVO> = new Vector.<dRequirementVO>();
            for each (_local_3 in this.requirements)
            {
                if (_local_3.type == _arg_1)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function isFulfilledForSkillList(_arg_1:cSkillList):Boolean
        {
            var _local_3:dRequirementVO;
            var _local_4:Boolean;
            var _local_5:cSkill;
            var _local_2:Boolean = true;
            for each (_local_3 in this.requirements)
            {
                if (_local_3.type == REQUIREMENT_TYPE.SKILL)
                {
                    _local_4 = false;
                    for each (_local_5 in _arg_1.getItems_vector())
                    {
                        if (_local_5.getDefinition().name_string == _local_3.value)
                        {
                            if (_local_5.getLevel() > 0)
                            {
                                _local_4 = true;
                            };
                            break;
                        };
                    };
                    _local_2 = ((_local_2) && (_local_4));
                }
                else
                {
                    _local_2 = ((_local_2) && (_local_3.fulfilled));
                };
            };
            return (_local_2);
        }

        public function contains(_arg_1:int, _arg_2:String):Boolean
        {
            var _local_3:dRequirementVO;
            for each (_local_3 in this.requirements)
            {
                if (((_local_3.type == _arg_1) && (_arg_2 == _local_3.value)))
                {
                    return (true);
                };
            };
            return (false);
        }


    }
}
