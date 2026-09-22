package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Trigger.InteractivityTrigger;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Observers.OneHitUIObserver;
    import Communication.VO.InputVO;
    import Enums.COMMAND;
    import Model.Notifier;

    public final class ClickGUITrigger extends InstantTrigger implements Observer, InteractivityTrigger 
    {

        public function ClickGUITrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            global.getApplication().inputNotifier.addPropertyObserver(_arg_2.action_string, this);
            _arg_3.inputNotifier.addPropertyObserver(_arg_2.action_string, this);
        }

        public function createUIObserver():void
        {
            OneHitUIObserver.create("click", definition.item_string);
        }

        override public function check():Boolean
        {
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_6:cGeneralInterface;
            var _local_7:InputVO;
            if ("click" != _arg_2)
            {
                return;
            };
            var _local_4:String = (_arg_3 as String);
            var _local_5:Array = definition.item_string.split(".");
            if (((_local_4.indexOf(definition.item_string) >= 0) || ((_local_4.indexOf(_local_5[0]) >= 0) && (_local_4.indexOf(_local_5[(_local_5.length - 1)]) >= 0))))
            {
                _local_6 = (para as cGeneralInterface);
                _local_7 = new InputVO();
                _local_7.action = _arg_2;
                _local_7.input = _local_4;
                _local_6.mClientMessages.SendMessagetoServer(COMMAND.INPUT_ACTION, _local_6.mCurrentPlayer.GetPlayerId(), _local_7);
                global.getApplication().inputNotifier.removePropertyObserver(definition.action_string, this);
                _local_6.inputNotifier.removePropertyObserver(definition.action_string, this);
                trigger();
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).inputNotifier.removePropertyObserver(definition.action_string, this);
            global.getApplication().inputNotifier.removePropertyObserver(definition.action_string, this);
            super.dispose();
        }


    }
}
