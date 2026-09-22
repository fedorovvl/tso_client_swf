package com.bluebyte.tso.service.responders
{
    import ServerState.Responding;
    import Communication.VO.dServerActionResult;

    public class ColonyYieldResponder implements Responding 
    {


        public function onFault(_arg_1:int, _arg_2:dServerActionResult):void
        {
        }

        public function onResult(_arg_1:int, _arg_2:dServerActionResult):void
        {
            if ((_arg_2.data is Number))
            {
                global.ui.lastColonyYieldCalculationTime = (_arg_2.data as Number);
            };
        }


    }
}
