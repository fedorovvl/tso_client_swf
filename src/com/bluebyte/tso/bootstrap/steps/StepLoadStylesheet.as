package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import flash.events.Event;

    public class StepLoadStylesheet extends BootstrapStep 
    {


        private function loaderSWFCompleteHandler(_arg_1:Event):void
        {
            global.getApplication().loadingScreenLoader.removeEventListener(Event.COMPLETE, this.loaderSWFCompleteHandler);
            next(this);
        }

        override protected function execute():void
        {
            global.getApplication().loadingScreenLoader.addEventListener(Event.COMPLETE, this.loaderSWFCompleteHandler);
            global.getApplication().loadingScreenLoader.resumeLoading();
        }


    }
}
