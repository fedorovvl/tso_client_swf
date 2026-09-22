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

    public final class WindowCloseTrigger extends InstantTrigger implements Observer, InteractivityTrigger 
    {

        private var gi:cGeneralInterface = null;
        private var closedWindow:String = "";

        public function WindowCloseTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            var _local_4:IGUIBase = cGuiBaseElement.GetPanelController(_arg_2.item_string.split("|")[0]);
            if (_local_4 == null)
            {
                cLog.error(("WindowOpenTrigger GUI Element not found! " + _arg_2.toString()));
            }
            else
            {
                Notifier(_local_4).addPropertyObserver("hide", this);
            };
            super(_arg_1, _arg_2, _local_4);
            _arg_2.min = (_arg_2.max = 1);
            this.gi = _arg_3;
            _arg_3.inputNotifier.addPropertyObserver("hide", this);
        }

        public function createUIObserver():void
        {
            OneHitUIObserver.create("hide", definition.item_string);
        }

        override public function check():Boolean
        {
            if (this.closedWindow == definition.item_string)
            {
                if (para != null)
                {
                    (para as Notifier).removePropertyObserver("hide", this);
                };
                this.gi.inputNotifier.removePropertyObserver("hide", this);
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.closedWindow = (_arg_3 as String);
            this.check();
        }

        override public function dispose():void
        {
            if (para != null)
            {
                (para as Notifier).removePropertyObserver("hide", this);
            };
            this.gi.inputNotifier.removePropertyObserver("hide", this);
            this.gi = null;
            super.dispose();
        }


    }
}
