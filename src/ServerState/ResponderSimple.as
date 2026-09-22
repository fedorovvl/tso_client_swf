package ServerState
{
    import Communication.VO.dServerActionResult;

    public class ResponderSimple implements Responding 
    {

        private var onResultCallback:Function;
        private var onFaultCallback:Function;

        public function ResponderSimple(_arg_1:Function, _arg_2:Function=null)
        {
            super();
            this.onResultCallback = _arg_1;
            this.onFaultCallback = ((_arg_2 != null) ? _arg_2 : _arg_1);
        }

        public function onFault(_arg_1:int, _arg_2:dServerActionResult):void
        {
            this.onFaultCallback(_arg_1, _arg_2);
        }

        public function onResult(_arg_1:int, _arg_2:dServerActionResult):void
        {
            this.onResultCallback(_arg_1, _arg_2);
        }


    }
}
