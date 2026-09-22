package com.bluebyte.tso.bootstrap
{
    import com.bluebyte.tso.util.ClientLogger;

    public class Bootstrap extends BootstrapSequentialStep 
    {


        override public function start():void
        {
            ClientLogger.log("[BOOT] starting");
            this.next(null);
        }

        override public function next(_arg_1:BootstrapStep):void
        {
            if (steps.length > 0)
            {
                dispatchEvent(new BootstrapEvent(BootstrapEvent.NEXT, _arg_1));
                steps.shift()._execute();
            }
            else
            {
                ClientLogger.log("[BOOT] finished");
                dispatchEvent(new BootstrapEvent(BootstrapEvent.COMPLETE, this));
            };
        }


    }
}
