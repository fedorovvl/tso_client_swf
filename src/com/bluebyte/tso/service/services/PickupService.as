package com.bluebyte.tso.service.services
{
    import com.bluebyte.tso.service.AbstractService;
    import Enums.COMMAND;
    import Communication.VO.dUniqueID;
    import Communication.VO.dPickupItemVO;

    public class PickupService extends AbstractService 
    {


        public function executePickup(_arg_1:dUniqueID):Boolean
        {
            if (_arg_1)
            {
                sendToCurrentZone(COMMAND.EXECUTE_PICKUP, _arg_1);
                return (true);
            };
            return (false);
        }

        public function add(_arg_1:dPickupItemVO):void
        {
            if (_arg_1)
            {
                sendToCurrentZone(COMMAND.ADD_PICKUP, _arg_1);
            };
        }


    }
}
