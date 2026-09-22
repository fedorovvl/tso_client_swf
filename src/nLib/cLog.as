package nLib
{
    import mx.controls.Alert;
    import GUI.Loca.cLocaManager;
    import GUI.Components.CustomAlert;
    import Communication.VO.dClientLogMessagesVO;
    import com.bluebyte.tso.util.ClientLogger;
    import Enums.COMMAND;

    public class cLog 
    {


        public static function showErrorMessage(_arg_1:String):void
        {
            Alert.show(_arg_1);
            error(_arg_1);
        }

        public static function showWarning(_arg_1:String):void
        {
            Alert.show(_arg_1);
            warning(_arg_1);
        }

        public static function error(_arg_1:String):void
        {
            clientLog("error", _arg_1);
        }

        public static function showIOErrorMessage(_arg_1:String):void
        {
            var _local_2:String;
            var _local_3:String;
            error(("Could not load file: " + _arg_1));
            if (cLocaManager.GetInstance().IsInitialized())
            {
                CustomAlert.show("IOError", "IOError");
            }
            else
            {
                _local_2 = "File loading failed";
                _local_3 = "The client was unable to load a data file.\nDelete your browser cache and try again.";
                CustomAlert.show(_local_3, _local_2, 4, null, null, null, 4, false);
            };
        }

        public static function sendLogMessagesToServer():void
        {
            var _local_1:dClientLogMessagesVO;
            if (global.enableClientLogTransfer)
            {
                _local_1 = new dClientLogMessagesVO();
                _local_1.logMessages = ClientLogger.getLog(false);
                global.ui.SendServerActionSimple(COMMAND.LOGGER_SEND_CLIENT_LOG, _local_1);
            };
        }

        public static function info(_arg_1:String):void
        {
            clientLog("info", _arg_1);
        }

        public static function sendUncaughtExceptionToServer(_arg_1:String):void
        {
            global.ui.SendServerActionSimple(COMMAND.LOGGER_SEND_UNCAUGHT_EXCEPTION, _arg_1);
        }

        public static function isInfoEnabled():Boolean
        {
            return (true);
        }

        private static function clientLog(_arg_1:String, _arg_2:String):void
        {
            ClientLogger.log(((_arg_1 + " ") + _arg_2));
        }

        public static function warning(_arg_1:String):void
        {
            clientLog("warning", _arg_1);
        }

        public static function showGameInfo(_arg_1:String):void
        {
            Alert.show(_arg_1);
        }

        public static function statusText(_arg_1:String):void
        {
            clientLog("status", _arg_1);
        }


    }
}
