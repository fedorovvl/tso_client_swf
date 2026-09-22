package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import Interface.IGFXProgressReceiver;
    import Interface.gInitStaticForAllZones;
    import flash.events.Event;
    import com.bluebyte.tso.util.ClientLogger;
    import com.bluebyte.tso.bootstrap.BootstrapEvent;

    public class StepLoadGFXResource extends BootstrapStep implements IGFXProgressReceiver 
    {

        private const MAX:int = 6353;

        private var count:int = 0;


        override public function getProgress():Number
        {
            return ((1 / this.MAX) * this.count);
        }

        override protected function execute():void
        {
            gInitStaticForAllZones.setCallback(this.settingsCompleteHandler);
            gInitStaticForAllZones.setPogressReceiver(this);
            gInitStaticForAllZones.loadGfxResourceHandler(null);
        }

        override public function getProgressWeight():Number
        {
            return (20);
        }

        private function settingsCompleteHandler(_arg_1:Event):void
        {
            next(this);
        }

        public function setLoadedCount(_arg_1:int):void
        {
            if (_arg_1 > this.MAX)
            {
                ClientLogger.log("IMPORTANT: #################################################################################");
                ClientLogger.log(("IMPORTANT: Maximum amount of gameobjects changed. Set StepLoadGFXResource.MAX to " + _arg_1));
                ClientLogger.log("IMPORTANT: #################################################################################");
            }
            else
            {
                this.count = _arg_1;
                if ((_arg_1 % 100) == 0)
                {
                    getBootstrap().dispatchEvent(new BootstrapEvent(BootstrapEvent.PROGRESS, this));
                };
            };
        }


    }
}
