package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import Model.Observer;
    import Model.Notifiers.TickChannel;
    import Model.Notifier;

    public class StepBootEngine extends BootstrapStep implements Observer 
    {


        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            global.ui.channels.TICK.removePropertyObserver(TickChannel.RENDER_TICK, this);
            next(this);
        }

        override protected function execute():void
        {
            global.getApplication().isoengine.bootup();
            global.ui.channels.TICK.addPropertyObserver(TickChannel.RENDER_TICK, this);
        }


    }
}
