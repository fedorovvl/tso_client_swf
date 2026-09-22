package Model.Observers
{
    import Model.Observer;
    import Model.Notifier;
    import GUI.cGuiBaseElement;
    import Communication.VO.InputVO;
    import Utils.StringUtils;
    import Enums.COMMAND;

    public class OneHitUIObserver implements Observer 
    {

        private static var observers:Object = new Object();
        private static const DELIMETER:String = "]-#-[";

        private var guiAddress:String = "";
        private var action:String = "";

        public function OneHitUIObserver(_arg_1:String, _arg_2:String)
        {
            super();
            this.guiAddress = _arg_2;
            this.action = _arg_1;
            var _local_3:Notifier = global.getApplication().inputNotifier;
            if (_arg_1 != "click")
            {
                _local_3 = cGuiBaseElement.GetPanelController(_arg_2);
                if (_local_3 == null)
                {
                    _local_3 = global.getApplication().inputNotifier;
                };
            };
            if (_local_3 != null)
            {
                _local_3.addPropertyObserver(_arg_1, this);
            };
        }

        public static function create(_arg_1:String, _arg_2:String):void
        {
            var _local_3:String = ((_arg_1 + DELIMETER) + _arg_2);
            if (!observers[_local_3])
            {
                observers[_local_3] = new OneHitUIObserver(_arg_1, _arg_2);
            };
        }


        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_5:String;
            var _local_6:Array;
            var _local_4:InputVO = new InputVO();
            _local_4.action = _arg_2;
            _local_4.input = this.guiAddress;
            if (this.action == "click")
            {
                _local_5 = (_arg_3 as String);
                _local_6 = this.guiAddress.split(".");
                if (!((_local_5.indexOf(this.guiAddress) >= 0) || ((_local_5.indexOf(_local_6[0]) >= 0) && (_local_5.indexOf(_local_6[(_local_6.length - 1)]) >= 0))))
                {
                    return;
                };
                _local_4.input = (_arg_3 as String);
            }
            else
            {
                if (!StringUtils.contains((_arg_3 as String), this.guiAddress))
                {
                    return;
                };
            };
            global.ui.mClientMessages.SendMessagetoServer(COMMAND.INPUT_ACTION, global.ui.mCurrentPlayer.GetPlayerId(), _local_4);
            _arg_1.removePropertyObserver(_arg_2, this);
            delete observers[((this.action + DELIMETER) + this.guiAddress)];
        }


    }
}
