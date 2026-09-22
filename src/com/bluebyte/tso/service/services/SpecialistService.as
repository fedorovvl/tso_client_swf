package com.bluebyte.tso.service.services
{
    import com.bluebyte.tso.service.AbstractService;
    import Utils.StringUtils;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Communication.VO.dStartSpecialistTaskVO;
    import Specialists.cSpecialistTask_WaitForConfirmation;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.COMMAND;
    import Specialists.cSpecialist;
    import Specialists.cSpecialistSubTaskDefinition;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import AdventureSystem.cAdventureDefinition;

    public class SpecialistService extends AbstractService 
    {


        public function startTask(_arg_1:cSpecialist, _arg_2:cSpecialistSubTaskDefinition):void
        {
            if (((!(_arg_1)) || (!(_arg_2))))
            {
                return;
            };
            if (StringUtils.startsWith(_arg_2.taskType_string, "PvP"))
            {
                AdventureManager.getInstance().SetScoutingForPvP(true);
            };
            var _local_3:dStartSpecialistTaskVO = new dStartSpecialistTaskVO();
            _local_3.subTaskID = _arg_2.subTaskID;
            _local_3.uniqueID = _arg_1.GetUniqueID();
            _arg_1.SetTask(new cSpecialistTask_WaitForConfirmation(getGI(), _arg_1, 0, SPECIALIST_TASK_TYPES.parse(_arg_2.mainTask.taskName_string)));
            sendServerAction(SPECIALIST_TASK_TYPES.parse(_arg_2.mainTask.taskName_string), _local_3, null, 0, 0, COMMAND.SET_TASK);
        }

        public function sendToZone(_arg_1:cSpecialist, _arg_2:int):void
        {
            var _local_4:dAdventureClientInfoVO;
            var _local_5:cAdventureDefinition;
            var _local_6:dAdventureClientInfoVO;
            var _local_7:cAdventureDefinition;
            if (((!(_arg_1)) || (_arg_2 == 0)))
            {
                return;
            };
            _arg_1.SetTask(new cSpecialistTask_WaitForConfirmation(getGI(), _arg_1, 0, SPECIALIST_TASK_TYPES.TRAVEL_TO_ZONE));
            var _local_3:dStartSpecialistTaskVO = new dStartSpecialistTaskVO();
            _local_3.uniqueID = _arg_1.GetUniqueID();
            if (_arg_2 < defines.ADVENTUREZONEID)
            {
                _local_4 = AdventureManager.getInstance().getAdventure(_arg_2);
                if (_local_4 != null)
                {
                    _local_5 = cAdventureDefinition.FindAdventureDefinition(_local_4.adventureName);
                    if (((_local_5.IsColony()) || (_local_5.IsExpedition())))
                    {
                        _local_4.troopLimit = (_local_4.troopLimit - _arg_1.GetArmy().GetUnitsCount());
                        _local_4.admiralCount = (_local_4.admiralCount + _arg_1.GetSpecialistDescription().GetAdventureMapLimitCount());
                    };
                };
            };
            if (((_arg_2 == _arg_1.getPlayerID()) && (getGI().mCurrentViewedZoneID < defines.ADVENTUREZONEID)))
            {
                _local_6 = AdventureManager.getInstance().getAdventure(getGI().mCurrentViewedZoneID);
                if (_local_6 != null)
                {
                    _local_7 = cAdventureDefinition.FindAdventureDefinition(_local_6.adventureName);
                    if (((_local_7.IsColony()) || (_local_7.IsExpedition())))
                    {
                        _local_6.troopLimit = (_local_6.troopLimit + _arg_1.GetArmy().GetUnitsCount());
                        _local_6.admiralCount = (_local_6.admiralCount - _arg_1.GetSpecialistDescription().GetAdventureMapLimitCount());
                    };
                };
            };
            sendServerAction(SPECIALIST_TASK_TYPES.TRAVEL_TO_ZONE, _local_3, null, _arg_2, 0, COMMAND.SET_TASK);
        }


    }
}
