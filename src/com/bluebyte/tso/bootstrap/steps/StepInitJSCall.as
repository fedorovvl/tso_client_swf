package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import flash.external.ExternalInterface;
    import com.bluebyte.tso.util.ClientLogger;

    public class StepInitJSCall extends BootstrapStep 
    {


        override protected function execute():void
        {
            this.CallJSInit();
        }

        private function CallJSInit():void
        {
            if (((!(global.m_JSInitCall == "")) && (ExternalInterface.available)))
            {
                try
                {
                    ClientLogger.log(("Calling javascript function: " + global.m_JSInitCall));
                    ExternalInterface.call(global.m_JSInitCall);
                    global.m_JSInitCall = "";
                }
                catch(e:Error)
                {
                    ClientLogger.log(("could not send initilize JS call. " + e.message));
                };
            };
            next(this);
        }


    }
}
