package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;

    public class StepHideLoadingscreen extends BootstrapStep 
    {


        override protected function execute():void
        {
            global.getApplication().loadingScreen.hide();
            globalFlash.gui.mEventInfoPanel.StartLoadingInfoState();
            next(this);
        }


    }
}
