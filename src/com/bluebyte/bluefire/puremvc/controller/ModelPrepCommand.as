package com.bluebyte.bluefire.puremvc.controller
{
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import com.bluebyte.bluefire.puremvc.model.ConnectionProxy;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class ModelPrepCommand extends SimpleCommand 
    {


        override public function execute(_arg_1:INotification):void
        {
            facade.registerProxy(new ConnectionProxy());
        }


    }
}
