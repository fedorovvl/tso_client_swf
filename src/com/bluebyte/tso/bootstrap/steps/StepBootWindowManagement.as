package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import GUI.ApplicationFacade;
    import GUI.Notifications.ApplicationNotifications;
    import mx.events.FlexEvent;
    import Interface.gInitStaticForAllZones;

    public class StepBootWindowManagement extends BootstrapStep 
    {


        private function enterStateHandler(_arg_1:FlexEvent):void
        {
            ApplicationFacade.sendNotification(ApplicationNotifications.ENTERGAME, global.getApplication());
            global.getApplication().runningState.removeEventListener(FlexEvent.ENTER_STATE, this.enterStateHandler);
            next(this);
        }

        override protected function execute():void
        {
            gInitStaticForAllZones.ClearScreen();
            global.getApplication().runningState.addEventListener(FlexEvent.ENTER_STATE, this.enterStateHandler);
            global.getApplication().currentState = global.getApplication().runningState.name;
        }


    }
}
