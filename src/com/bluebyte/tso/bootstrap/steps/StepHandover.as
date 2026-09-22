package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import nLib.gMisc;
    import Tracks.TrackManager;

    public class StepHandover extends BootstrapStep 
    {


        override protected function execute():void
        {
            global.getApplication().blueFireComponent.visible = true;
            gMisc.sendLoadingLog = false;
            globalFlash.gui.mNewsWindow.Enable();
            globalFlash.gui.mEventInfoPanel.StartEventInfoState();
            TrackManager.getInstance().trackClientLoaded();
            if (!global.useExternalServer)
            {
                global.ui.ZoneFinished();
            };
            next(this);
        }


    }
}
