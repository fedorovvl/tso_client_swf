package GUI
{
    import org.puremvc.as3.patterns.facade.Facade;
    import GUI.Notifications.ApplicationNotifications;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    public class ApplicationFacade extends Facade 
    {


        public static function getInstance():ApplicationFacade
        {
            if (instance == null)
            {
                instance = new (ApplicationFacade)();
            };
            return (instance as ApplicationFacade);
        }

        public static function sendNotification(_arg_1:String, _arg_2:Object=null, _arg_3:String=null):void
        {
            getInstance().sendNotification(_arg_1, _arg_2, _arg_3);
        }


        override protected function initializeController():void
        {
            super.initializeController();
            registerCommand(ApplicationNotifications.INITIALIZE, SimpleCommand);
            registerCommand(ApplicationNotifications.ENTERGAME, SimpleCommand);
        }


    }
}
