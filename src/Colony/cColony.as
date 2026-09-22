package Colony
{
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import Communication.VO.ColonyVO;
    import Enums.COMMAND;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import nLib.cLog;
    import Interface.cGameInterface;
    import Communication.VO.ColonyCommandVO;

    public class cColony 
    {

        public static const STATUS_NPC_OWNED:int = 0;
        public static const STATUS_UNDER_PVP_ATTACK:int = 1;
        public static const STATUS_READY_FOR_DEFENSE_MODE:int = 2;
        public static const STATUS_WAIT_FOR_ASSIGNMENT:int = 3;
        public static const STATUS_ASSIGNED:int = 4;
        public static const STATUS_REMOVED:int = 5;


        public static function IsUnderAttackState(_arg_1:int):Boolean
        {
            return (_arg_1 == STATUS_UNDER_PVP_ATTACK);
        }

        public static function HandleColonyCommand(_arg_1:cGameInterface, _arg_2:ColonyCommandVO):Boolean
        {
            var _local_5:int;
            var _local_6:dAdventureClientInfoVO;
            var _local_3:Boolean;
            var _local_4:ColonyVO = _arg_1.mCurrentPlayerZone.ColonyGet(_arg_2.colonyId);
            if (_local_4 != null)
            {
                _local_5 = _local_4.state;
                if (((_arg_2.commandId == COMMAND.COLONY_ASSIGN) && (IsAssignableState(_local_4.state))))
                {
                    _local_5 = STATUS_ASSIGNED;
                    _local_3 = true;
                }
                else
                {
                    if (((_arg_2.commandId == COMMAND.COLONY_REMOVE) && (((_local_4.state == STATUS_ASSIGNED) || (_local_4.state == STATUS_WAIT_FOR_ASSIGNMENT)) || (_local_4.state == STATUS_READY_FOR_DEFENSE_MODE))))
                    {
                        _local_5 = STATUS_REMOVED;
                        _local_3 = true;
                    };
                };
                if (_local_3)
                {
                    _local_6 = AdventureManager.getInstance().getAdventureForColony(_local_4.colonyId);
                    if (_local_5 == STATUS_ASSIGNED)
                    {
                        _local_4.colonyYieldStartTime = _arg_2.serverTimeStamp;
                        if (_arg_1.mCurrentPlayer.GetColonySlotCountUsed() >= (_arg_1.mCurrentPlayer.GetColonySlotCountMax() + _arg_1.mCurrentPlayer.GetColonySlotCountPermanent()))
                        {
                            _local_4.isAssignedToTempSlot = true;
                        };
                        if (_local_6)
                        {
                            AdventureManager.getInstance().removeAdventure(_local_6.zoneID);
                        };
                    }
                    else
                    {
                        if (_local_5 == STATUS_REMOVED)
                        {
                            _arg_1.mCurrentPlayerZone.ColonyRemove(_local_4.colonyId);
                            if (_local_6)
                            {
                                AdventureManager.getInstance().removeAdventure(_local_6.zoneID);
                            };
                            if (_local_4.state == STATUS_ASSIGNED)
                            {
                                if (_local_4.isAssignedToTempSlot)
                                {
                                    _arg_1.mCurrentPlayer.SetColonySlotCountTemp((_arg_1.mCurrentPlayer.GetColonySlotCountTemp() - 1));
                                };
                            };
                        };
                    };
                    _local_4.state = _local_5;
                    if (((_local_5 == STATUS_ASSIGNED) || (_local_5 == STATUS_REMOVED)))
                    {
                        globalFlash.gui.mTrackedMissionList.Refresh();
                        globalFlash.gui.mColonyWindow.Clear();
                        globalFlash.gui.mColonyWindow.Refresh();
                        globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = false;
                    };
                };
            }
            else
            {
                cLog.error(("cGameInterface.HandleColonyCommand: could not find colony! " + _arg_2.toString()));
            };
            return (_local_3);
        }

        public static function IsWaitForAssignmentState(_arg_1:int):Boolean
        {
            return (_arg_1 == STATUS_WAIT_FOR_ASSIGNMENT);
        }

        public static function IsAssignedState(_arg_1:int):Boolean
        {
            return (_arg_1 == STATUS_ASSIGNED);
        }

        public static function IsAssignableState(_arg_1:int):Boolean
        {
            return ((_arg_1 == STATUS_WAIT_FOR_ASSIGNMENT) || (_arg_1 == STATUS_READY_FOR_DEFENSE_MODE));
        }


    }
}
