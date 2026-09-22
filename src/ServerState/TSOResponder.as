package ServerState
{
    import mx.rpc.AsyncResponder;
    import mx.rpc.Fault;
    import nLib.cLog;
    import Communication.VO.dServerResponse;
    import Communication.VO.dServerActionResult;

    public final class TSOResponder extends AsyncResponder 
    {

        private var responder:Responding;

        public function TSOResponder(_arg_1:Function, _arg_2:Function, _arg_3:Responding, _arg_4:Object=null)
        {
            super(_arg_1, _arg_2, _arg_4);
            this.responder = _arg_3;
        }

        override public function fault(_arg_1:Object):void
        {
            var _local_2:Fault;
            super.fault(_arg_1);
            if (this.responder)
            {
                _local_2 = (_arg_1.fault as Fault);
                cLog.error(("Server Response Fault: " + _local_2.toString()));
                this.responder.onFault(0, null);
            };
        }

        override public function result(_arg_1:Object):void
        {
            var _local_2:dServerResponse;
            var _local_3:dServerActionResult;
            super.result(_arg_1);
            if (this.responder)
            {
                _local_2 = (_arg_1.result as dServerResponse);
                _local_3 = (_local_2.data as dServerActionResult);
                if (_local_3.errorCode == 0)
                {
                    this.responder.onResult(_local_2.type, _local_3);
                }
                else
                {
                    this.responder.onFault(_local_2.type, _local_3);
                };
            };
        }


    }
}
