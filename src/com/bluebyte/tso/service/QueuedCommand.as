package com.bluebyte.tso.service
{
    import ServerState.Responding;

    public class QueuedCommand 
    {

        public var data:Object;
        public var responder:Responding;
        public var command:int;
        public var targetZone:int;

        public function QueuedCommand(_arg_1:int, _arg_2:Object, _arg_3:int, _arg_4:Responding)
        {
            super();
            this.command = _arg_1;
            this.data = _arg_2;
            this.targetZone = _arg_3;
            this.responder = _arg_4;
        }

    }
}
