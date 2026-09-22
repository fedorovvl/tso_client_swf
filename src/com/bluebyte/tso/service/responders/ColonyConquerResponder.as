package com.bluebyte.tso.service.responders
{
    import ServerState.Responding;
    import Communication.VO.dServerActionResult;

    public class ColonyConquerResponder implements Responding 
    {

        private var zoneId:int = 0;

        public function ColonyConquerResponder(_arg_1:int)
        {
            super();
            this.zoneId = _arg_1;
        }

        public function onFault(_arg_1:int, _arg_2:dServerActionResult):void
        {
            globalFlash.gui.mPvPColoniesWindow.handleConquerFailed(this.zoneId, (_arg_2.data as int));
        }

        public function onResult(_arg_1:int, _arg_2:dServerActionResult):void
        {
            if (_arg_2.errorCode > 0)
            {
                globalFlash.gui.mPvPColoniesWindow.handleConquerFailed(this.zoneId, _arg_2.errorCode);
            }
            else
            {
                globalFlash.gui.mPvPColoniesWindow.handleConquerSuccessful(this.zoneId);
            };
        }


    }
}
