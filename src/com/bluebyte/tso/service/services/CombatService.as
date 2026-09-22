package com.bluebyte.tso.service.services
{
    import com.bluebyte.tso.service.AbstractService;
    import com.bluebyte.tso.service.responders.UnitSwitchResponder;
    import Enums.COMMAND;
    import Specialists.cSpecialist;

    public class CombatService extends AbstractService 
    {


        public function selectNextUnit(_arg_1:cSpecialist, _arg_2:String, _arg_3:UnitSwitchResponder=null):void
        {
            if (!_arg_3)
            {
                _arg_3 = new UnitSwitchResponder(_arg_1, _arg_2);
            };
            sendServerAction(COMMAND.COMBAT_UNIT_SWITCH, _arg_3.command, _arg_3);
        }


    }
}
