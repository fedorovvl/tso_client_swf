package Specialists
{
    import Enums.SPECIALIST_TASK_TYPES;
    import Interface.cGeneralInterface;
    import Communication.VO.dSpecialistTask_TravelToStarMenuVO;
    import Modifier.Modifier;
    import nLib.cLog;
    import Enums.SPECIALIST_TYPE;
    import Enums.AVATAR_MESSAGE_TYPE;
    import GO.cBuilding;
    import Enums.TASK_PHASES_TRAVEL_TO_STAR_MENU;
    import nLib.gMisc;
    import Modifier.ModifierVO;
    import Communication.VO.dSpecialistTaskVO;

    public class cSpecialistTask_TravelToStarMenu extends cSpecialistTask_WithSettler 
    {

        private var mDestinationZoneID:int;
        private var modified:Boolean;
        private var mGarrisonGridIdx:int;
        private var landingFieldId:int;

        public function cSpecialistTask_TravelToStarMenu(_arg_1:cGeneralInterface, _arg_2:cSpecialist, _arg_3:int, _arg_4:int)
        {
            super(_arg_1, SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU, _arg_2, _arg_3, _arg_4);
            mNeededTime = mTaskDefinition.duration;
            this.mGarrisonGridIdx = _arg_2.GetGarrisonGridIdx();
            _arg_2.notifyPropertyObserver(TASK_START, this);
        }

        public static function CreateTaskFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistTask_TravelToStarMenuVO, _arg_3:cSpecialist):cSpecialistTask_TravelToStarMenu
        {
            var _local_4:cSpecialistTask_TravelToStarMenu = new cSpecialistTask_TravelToStarMenu(_arg_1, _arg_3, _arg_2.collectedTime, _arg_2.phase);
            _local_4.SetPathPos(_arg_2.pathPos);
            _local_4.mGarrisonGridIdx = _arg_2.garrisonGridIdx;
            if (_local_4.GetGarrisonGridIdx() > -1)
            {
                _local_4.SetDestinationPath(_arg_1.mPathFinder.CalculatePathForWarehouse(_local_4.GetGarrisonGridIdx(), _arg_3.getPlayerID()));
            };
            return (_local_4);
        }


        override public function isModified():Boolean
        {
            return (this.modified);
        }

        override public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function GetGarrisonGridIdx():int
        {
            return (this.mGarrisonGridIdx);
        }

        override public function StartTask():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(("Starting " + this));
            };
            super.StartTask();
            globalFlash.gui.mAvatarMessageList.AddMessage(((mOwner.GetBaseType() == SPECIALIST_TYPE.ADMIRAL) ? AVATAR_MESSAGE_TYPE.ADMIRAL_TRAVELS_TO_STAR_MENU : AVATAR_MESSAGE_TYPE.GENERAL_TRAVELS_TO_STAR_MENU), mOwner);
            globalFlash.gui.mSpecialistTravelPanel.SetBusyOff();
            var _local_1:cBuilding = mOwner.GetGarrison();
            if (_local_1 != null)
            {
                SetTaskPhase(TASK_PHASES_TRAVEL_TO_STAR_MENU.DISBAND_ARMY);
            };
        }

        public function toString():String
        {
            return ("<cSpecialistTask_TravelToStarMenu />");
        }

        override protected function PerformTaskPhase(_arg_1:int, _arg_2:int):void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_TRAVEL_TO_STAR_MENU.DISBAND_ARMY:
                    if (mOwner.GetArmy().HasUnits())
                    {
                        mOwner.GetArmy().DisbandArmy(mGeneralInterface.mCurrentPlayerZone.GetArmy(mOwner.getPlayerID()));
                    };
                    NextPhase();
                    return;
                case TASK_PHASES_TRAVEL_TO_STAR_MENU.DECONSTRUCT_GARRISON:
                    if (((mOwner.GetGarrison() == null) || (mOwner.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_DESTRUCTED)))
                    {
                        mCollectedTime = 0;
                        mOwner.SetGarrison(null);
                        if (((!(GetDestinationPath() == null)) && (GetDestinationPath().dest_vector.length > 0)))
                        {
                            SetPathPos(GetDestinationPath().pathLenX10000);
                            SpawnSettler(0, 0);
                            NextPhase();
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info((("Finished phase 'Deconstruct Garrison' of specialist " + mOwner.GetUniqueID()) + " -> TASK_PHASES_TRAVEL_TO_STAR_MENU.MOVE_TO_WAREHOUSE"));
                            };
                        }
                        else
                        {
                            SetTaskPhase(TASK_PHASES_TRAVEL_TO_STAR_MENU.ARRIVED_AT_WAREHOUSE);
                            if (cLog.isInfoEnabled())
                            {
                                cLog.info((("Finished phase 'Deconstruct Garrison' of specialist " + mOwner.GetUniqueID()) + " -> TASK_PHASES_TRAVEL_TO_STAR_MENU.ARRIVED_AT_WAREHOUSE"));
                            };
                        };
                    }
                    else
                    {
                        if (mOwner.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES)
                        {
                            SetDestinationPath(mGeneralInterface.mPathFinder.CalculatePathForWarehouse(mOwner.GetGarrison().GetStreetGridEntry(), mOwner.getPlayerID()));
                            mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.DeconstructBuildingGridPos(mOwner.GetGarrison().GetGrid());
                        };
                    };
                    return;
                case TASK_PHASES_TRAVEL_TO_STAR_MENU.MOVE_TO_WAREHOUSE:
                    speed = nonAttackSpeed;
                    IncPathPos(int(_arg_1));
                    if (GetPathPos() >= GetDestinationPath().pathLenX20000)
                    {
                        if (cLog.isInfoEnabled())
                        {
                            cLog.info((("Finished phase 'Move to Warehouse' of specialist " + mOwner.GetUniqueID()) + " -> Arrived At Warehouse()"));
                        };
                        mCollectedTime = 0;
                        NextPhase();
                    };
                    return;
                case TASK_PHASES_TRAVEL_TO_STAR_MENU.ARRIVED_AT_WAREHOUSE:
                    mOwner.SetGarrison(null);
                    globalFlash.gui.mAvatarMessageList.AddMessage(((mOwner.GetBaseType() == SPECIALIST_TYPE.ADMIRAL) ? AVATAR_MESSAGE_TYPE.ADMIRAL_RETURNED_TO_STAR : AVATAR_MESSAGE_TYPE.GENERAL_RETURNED_TO_STAR), mOwner);
                    mOwner.SetTask(null);
                    return;
                default:
                    gMisc.Assert(false, (("Could not interpret task phase " + GetTaskPhase()) + "!"));
            };
        }

        override public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            var _local_2:String = (mTaskDefinition.mainTask.taskName_string + mTaskDefinition.taskType_string);
            if (((_arg_1.type_string.length > 0) && (!(_arg_1.type_string == _local_2))))
            {
                return (false);
            };
            return (true);
        }

        override public function CreateTaskVOFromSpecialistTask():dSpecialistTaskVO
        {
            var _local_1:dSpecialistTask_TravelToStarMenuVO = new dSpecialistTask_TravelToStarMenuVO();
            _local_1.type = GetType();
            _local_1.phase = GetTaskPhase();
            _local_1.collectedTime = GetCollectedTime();
            _local_1.destinationZoneID = this.mDestinationZoneID;
            _local_1.pathPos = GetPathPos();
            return (_local_1);
        }

        override protected function CheckSettler():void
        {
            switch (GetTaskPhase())
            {
                case TASK_PHASES_TRAVEL_TO_STAR_MENU.DECONSTRUCT_GARRISON:
                case TASK_PHASES_TRAVEL_TO_STAR_MENU.ARRIVED_AT_WAREHOUSE:
                    if (GetSettler() != null)
                    {
                        RemoveSettler();
                    };
                    return;
                case TASK_PHASES_TRAVEL_TO_STAR_MENU.MOVE_TO_WAREHOUSE:
                    if ((((GetSettler() == null) && (!(GetDestinationPath() == null))) && (GetDestinationPath().dest_vector.length > 0)))
                    {
                        SpawnSettler(0, 0);
                    };
                    return;
                default:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Could not interpret task phase " + GetTaskPhase()));
                    };
            };
        }


    }
}
