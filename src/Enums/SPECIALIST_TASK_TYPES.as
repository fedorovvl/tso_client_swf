package Enums
{
    import nLib.gMisc;
    import Specialists.cSpecialistTaskDefinition;
    import Specialists.cSpecialistSubTaskDefinition;
    import Communication.VO.TaskIDVO;

    public class SPECIALIST_TASK_TYPES 
    {

        public static const DEPOSIT_SEARCH:int = 0;
        public static const DEPOSIT_SEARCH_string:String = "FindDeposit";
        public static const FIND_TREASURE:int = 1;
        public static const FIND_TREASURE_string:String = "FindTreasure";
        public static const FIND_ADVENTURE_ZONE:int = 2;
        public static const FIND_ADVENTURE_ZONE_string:String = "FindAdventureZone";
        public static const EXPLORE:int = 3;
        public static const EXPLORE_string:String = "Explore";
        public static const MOVE:int = 4;
        public static const MOVE_string:String = "Move";
        public static const ATTACK_BUILDING:int = 5;
        public static const ATTACK_BUILDING_string:String = "AttackBuilding";
        public static const ATTACK_BUILDING_NEW_COMBAT:int = 9;
        public static const ATTACK_BUILDING_NEW_COMBAT_string:String = "AttackBuildingNewCombat";
        public static const RECOVER:int = 6;
        public static const RECOVER_string:String = "Recover";
        public static const TRAVEL_TO_ZONE:int = 7;
        public static const TRAVEL_TO_ZONE_string:String = "TravelToZone";
        public static const WAIT_FOR_CONFIRMATION:int = 8;
        public static const WAIT_FOR_CONFIRMATION_string:String = "WaitForConfirmation";
        public static const FIND_EXPEDITION:int = 10;
        public static const FIND_EXPEDITION_string:String = "FindExpedition";
        public static const EXPEDITION_RECOVER:int = 11;
        public static const EXPEDITION_RECOVER_string:String = "ExpeditionRecover";
        public static const FIND_TREASURE_SHORT:String = "FindTreasureShort";
        public static const FIND_TREASURE_MEDIUM:String = "FindTreasureMedium";
        public static const FIND_TREASURE_LONG:String = "FindTreasureLong";
        public static const FIND_TREASURE_EVEN_LONGER:String = "FindTreasureEvenLonger";
        public static const FIND_TREASURE_BEANACOLLADA:String = "FindTreasureBeanACollada";
        public static const FIND_TREASURE_PROLONGED:String = "FindTreasureProlonged";
        public static const TRAVEL_TO_STAR_MENU:int = 12;
        public static const TRAVEL_TO_STAR_MENU_string:String = "TravelToStarMenu";
        public static const REPEAT_PREVIOUS_GROUP_TASK:int = 13;
        public static const REPEAT_PREVIOUS_GROUP_TASK_string:String = "RepeatPreviousGroupTask";
        private static var specialistTaskTypes:Array;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case DEPOSIT_SEARCH:
                    return (DEPOSIT_SEARCH_string);
                case FIND_TREASURE:
                    return (FIND_TREASURE_string);
                case FIND_ADVENTURE_ZONE:
                    return (FIND_ADVENTURE_ZONE_string);
                case EXPLORE:
                    return (EXPLORE_string);
                case MOVE:
                    return (MOVE_string);
                case ATTACK_BUILDING:
                    return (ATTACK_BUILDING_string);
                case ATTACK_BUILDING_NEW_COMBAT:
                    return (ATTACK_BUILDING_NEW_COMBAT_string);
                case RECOVER:
                    return (RECOVER_string);
                case TRAVEL_TO_ZONE:
                    return (TRAVEL_TO_ZONE_string);
                case WAIT_FOR_CONFIRMATION:
                    return (WAIT_FOR_CONFIRMATION_string);
                case FIND_EXPEDITION:
                    return (FIND_EXPEDITION_string);
                case EXPEDITION_RECOVER:
                    return (EXPEDITION_RECOVER_string);
                case TRAVEL_TO_STAR_MENU:
                    return (TRAVEL_TO_STAR_MENU_string);
                case REPEAT_PREVIOUS_GROUP_TASK:
                    return (REPEAT_PREVIOUS_GROUP_TASK_string);
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function parse(_arg_1:String):int
        {
            if (_arg_1 == DEPOSIT_SEARCH_string)
            {
                return (DEPOSIT_SEARCH);
            };
            if (_arg_1 == FIND_TREASURE_string)
            {
                return (FIND_TREASURE);
            };
            if (_arg_1 == FIND_ADVENTURE_ZONE_string)
            {
                return (FIND_ADVENTURE_ZONE);
            };
            if (_arg_1 == EXPLORE_string)
            {
                return (EXPLORE);
            };
            if (_arg_1 == MOVE_string)
            {
                return (MOVE);
            };
            if (_arg_1 == ATTACK_BUILDING_string)
            {
                return (ATTACK_BUILDING);
            };
            if (_arg_1 == ATTACK_BUILDING_NEW_COMBAT_string)
            {
                return (ATTACK_BUILDING_NEW_COMBAT);
            };
            if (_arg_1 == RECOVER_string)
            {
                return (RECOVER);
            };
            if (_arg_1 == TRAVEL_TO_ZONE_string)
            {
                return (TRAVEL_TO_ZONE);
            };
            if (_arg_1 == WAIT_FOR_CONFIRMATION_string)
            {
                return (WAIT_FOR_CONFIRMATION);
            };
            if (_arg_1 == FIND_EXPEDITION_string)
            {
                return (FIND_EXPEDITION);
            };
            if (_arg_1 == EXPEDITION_RECOVER_string)
            {
                return (EXPEDITION_RECOVER);
            };
            if (_arg_1 == TRAVEL_TO_STAR_MENU_string)
            {
                return (TRAVEL_TO_STAR_MENU);
            };
            if (_arg_1 == REPEAT_PREVIOUS_GROUP_TASK_string)
            {
                return (REPEAT_PREVIOUS_GROUP_TASK);
            };
            gMisc.Assert(false, (("Could not interpret '" + _arg_1) + "' for a task string!"));
            return (-1);
        }

        public static function parseOldTaskName(_arg_1:String):TaskIDVO
        {
            var _local_3:cSpecialistTaskDefinition;
            var _local_4:cSpecialistSubTaskDefinition;
            var _local_2:TaskIDVO;
            for each (_local_3 in global.specialistTaskDefinitions_vector)
            {
                if (_arg_1.indexOf(_local_3.taskName_string) >= 0)
                {
                    _local_2 = new TaskIDVO();
                    _local_2.mainTaskID = parse(_local_3.taskName_string);
                    for each (_local_4 in _local_3.subtasks_vector)
                    {
                        if (_arg_1.indexOf(_local_4.taskType_string) >= 0)
                        {
                            _local_2.subTaskID = _local_4.subTaskID;
                        };
                    };
                    return (_local_2);
                };
            };
            return (_local_2);
        }

        public static function getSpecialistTaskTypeArray():Array
        {
            var _local_1:cSpecialistTaskDefinition;
            var _local_2:cSpecialistSubTaskDefinition;
            if (specialistTaskTypes == null)
            {
                specialistTaskTypes = new Array();
                for each (_local_1 in global.specialistTaskDefinitions_vector)
                {
                    for each (_local_2 in _local_1.subtasks_vector)
                    {
                        specialistTaskTypes.push((_local_1.taskName_string + _local_2.taskType_string));
                    };
                };
            };
            return (specialistTaskTypes);
        }


    }
}
