package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import Model.Observer;
    import Model.Notifier;
    import Model.Notifiers.ZoneChannel;

    public class StepStartCommuncation extends BootstrapStep implements Observer 
    {


        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            next(this);
        }

        override protected function execute():void
        {
            global.ui.channels.ZONE.addPropertyObserver(ZoneChannel.ZONE_REFRESHED_CLIENT, this);
            global.ui.mClientMessages.InitializeServerCommunication();
            if (!global.useExternalServer)
            {
                next(this);
            };
        }


    }
}
