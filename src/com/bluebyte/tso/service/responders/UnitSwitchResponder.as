package com.bluebyte.tso.service.responders
{
    import ServerState.Responding;
    import Specialists.cSpecialist;
    import Communication.VO.CombatCommandVO;
    import Enums.COMMAND;
    import Communication.VO.dServerActionResult;
    import Specialists.cSpecialistTask_AttackBuildingNewCombat;
    import Interface.cGameInterface;

    public class UnitSwitchResponder implements Responding 
    {

        private var specialist:cSpecialist;
        public var command:CombatCommandVO;
        private var failcounter:int = 0;

        public function UnitSwitchResponder(_arg_1:cSpecialist, _arg_2:String)
        {
            super();
            this.specialist = _arg_1;
            this.command = CombatCommandVO.Create(_arg_1.GetUniqueID(), COMMAND.COMBAT_UNIT_SWITCH, _arg_2);
        }

        public function onResult(_arg_1:int, _arg_2:dServerActionResult):void
        {
            this.checkResult((_arg_2.data as Boolean));
        }

        public function onFault(_arg_1:int, _arg_2:dServerActionResult):void
        {
            this.checkResult((_arg_2.data as Boolean));
        }

        private function checkResult(_arg_1:Boolean):void
        {
            var _local_2:cSpecialistTask_AttackBuildingNewCombat;
            if (_arg_1)
            {
                (global.ui as cGameInterface).executeCombatUnitSwitch(this.specialist.getPlayerID(), this.command);
            }
            else
            {
                if (this.failcounter >= 3)
                {
                    _local_2 = (this.specialist.GetTask() as cSpecialistTask_AttackBuildingNewCombat);
                    if (((_local_2) && (_local_2.GetCombat())))
                    {
                        _local_2.GetCombat().unitSwitchFailed();
                    };
                }
                else
                {
                    this.failcounter++;
                    global.services.combat.selectNextUnit(this.specialist, this.command.value, this);
                };
            };
        }


    }
}
