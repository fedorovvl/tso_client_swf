package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Trigger.InteractivityTrigger;
    import Interface.cGeneralInterface;
    import GUI.cGuiBaseElement;
    import Interface.IGUIBase;
    import nLib.cLog;
    import Model.Notifier;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Model.Observers.OneHitUIObserver;

    public final class WindowOpenTrigger extends InstantTrigger implements Observer, InteractivityTrigger 
    {

        private var gi:cGeneralInterface = null;

        public function WindowOpenTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            var _local_4:IGUIBase = cGuiBaseElement.GetPanelController(_arg_2.item_string.split("|")[0]);
            if (_local_4 == null)
            {
                cLog.error(("WindowOpenTrigger GUI Element not found! " + _arg_2.toString()));
            }
            else
            {
                Notifier(_local_4).addPropertyObserver("show", this);
            };
            super(_arg_1, _arg_2, _local_4);
            _arg_2.min = (_arg_2.max = 1);
            this.gi = _arg_3;
            _arg_3.inputNotifier.addPropertyObserver("show", this);
        }

        public function createUIObserver():void
        {
            OneHitUIObserver.create("show", definition.item_string);
        }

        override public function check():Boolean
        {
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (definition.item_string == _arg_3)
            {
                trigger();
            };
        }

        override public function dispose():void
        {
            if (para != null)
            {
                (para as Notifier).removePropertyObserver("show", this);
            };
            this.gi.inputNotifier.removePropertyObserver("show", this);
            this.gi = null;
            super.dispose();
        }


    }
}
