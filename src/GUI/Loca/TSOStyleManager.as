package GUI.Loca
{
    import ServerState.cClientMessagesII;
    import mx.rpc.events.FaultEvent;
    import nLib.gMisc;
    import mx.events.StyleEvent;
    import flash.events.IEventDispatcher;

    public class TSOStyleManager 
    {

        public var filename:String;


        private function errorHandler(_arg_1:StyleEvent):void
        {
            cClientMessagesII.LogMessageToBigBrother(new FaultEvent((((("CDN ERROR EVENT: While loading style [" + this.filename) + "] an error occurred: [") + _arg_1.errorText) + "]")), null);
            gMisc.MessageBox(this.filename);
        }

        public function loadStyleDeclarations(_arg_1:String):IEventDispatcher
        {
            this.filename = _arg_1;
            var _local_2:TSOStyleLoader = new TSOStyleLoader(_arg_1, this.errorHandler);
            _local_2.load();
            return (_local_2);
        }


    }
}
