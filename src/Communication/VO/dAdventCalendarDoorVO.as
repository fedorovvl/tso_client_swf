package Communication.VO
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;
    import Enums.ADVENT_CALENDAR_DOOR_SPECIAL_TYPE;
    import Enums.ADVENT_CALENDAR_DOOR_BACKGROUND;
    import Enums.ADVENT_CALENDAR_DOOR_STATUS;
    import Enums.ADVENT_CALENDAR_DOOR_REWARD_TYPE;

    public class dAdventCalendarDoorVO 
    {

        public var rewards:ArrayCollection = new ArrayCollection();
        public var backgroundType:int;
        public var rewardType:int;
        public var openGemCost:int;
        public var specialType:int;
        public var id:String;
        public var openDateTimestamp:Number;
        public var status:int;
        public var openDay:int;
        public var chosenRewardId:int;


        public static function createFromXml(_arg_1:cXML):dAdventCalendarDoorVO
        {
            var _local_3:cXML;
            var _local_2:dAdventCalendarDoorVO = new (dAdventCalendarDoorVO)();
            _local_2.id = _arg_1.GetAttributeString_string("id");
            _local_2.specialType = ADVENT_CALENDAR_DOOR_SPECIAL_TYPE.Parse(_arg_1.GetAttributeString_string("specialType", "normal"));
            _local_2.backgroundType = ADVENT_CALENDAR_DOOR_BACKGROUND.Parse(_arg_1.GetAttributeString_string("backgroundType", "normal"));
            _local_2.openDay = _arg_1.GetAttributeInt("openDay");
            _local_2.openGemCost = _arg_1.GetAttributeInt("openGemCost");
            _local_2.status = ADVENT_CALENDAR_DOOR_STATUS.INACTIVE;
            _local_2.rewardType = ADVENT_CALENDAR_DOOR_REWARD_TYPE.Parse(_arg_1.GetAttributeString_string("rewardType", "normal"));
            for each (_local_3 in _arg_1.CreateChildrenArray())
            {
                _local_2.rewards.addItem(EffectVO.CreateFromXML(_local_3));
            };
            _local_2.chosenRewardId = -1;
            return (_local_2);
        }


        public function IsFinal():Boolean
        {
            return (this.specialType == ADVENT_CALENDAR_DOOR_SPECIAL_TYPE.FINAL_REWARD);
        }

        public function IsSpecial():Boolean
        {
            return (!(this.specialType == ADVENT_CALENDAR_DOOR_SPECIAL_TYPE.NORMAL));
        }

        public function IsFreeOpenable():Boolean
        {
            return (this.openGemCost == 0);
        }

        public function toString():String
        {
            var _local_1:String;
            var _local_2:EffectVO;
            _local_1 = ((((((((((((((((("<dAdventCalenderVO id='" + this.id) + "' ") + "status='") + this.status) + "' specialType='") + this.specialType) + "' backgroundType='") + this.backgroundType) + "' openDay='") + this.openDay) + "' openGemCost='") + this.openGemCost) + "' chosenRewardId='") + this.chosenRewardId) + "' rewardType '") + this.rewardType) + "'>\n");
            for each (_local_2 in this.rewards)
            {
                _local_1 = (_local_1 + (_local_2.toString() + "\n"));
            };
            return (_local_1 + "</dAdventCalenderVO>");
        }

        public function isOpened():Boolean
        {
            return ((this.status == ADVENT_CALENDAR_DOOR_STATUS.OPENED) || (this.status == ADVENT_CALENDAR_DOOR_STATUS.OPENED_WITH_GEMS));
        }

        public function Clone():dAdventCalendarDoorVO
        {
            var _local_2:EffectVO;
            var _local_1:dAdventCalendarDoorVO = new dAdventCalendarDoorVO();
            _local_1.id = this.id;
            _local_1.status = this.status;
            _local_1.specialType = this.specialType;
            _local_1.backgroundType = this.backgroundType;
            _local_1.openDay = this.openDay;
            _local_1.openDateTimestamp = this.openDateTimestamp;
            _local_1.openGemCost = this.openGemCost;
            _local_1.rewards = new ArrayCollection();
            for each (_local_2 in this.rewards)
            {
                _local_1.rewards.addItem(_local_2.clone());
            };
            _local_1.chosenRewardId = this.chosenRewardId;
            _local_1.rewardType = this.rewardType;
            return (_local_1);
        }


    }
}
