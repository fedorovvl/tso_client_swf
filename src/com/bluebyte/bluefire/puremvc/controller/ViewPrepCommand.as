package com.bluebyte.bluefire.puremvc.controller
{
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import com.bluebyte.bluefire.puremvc.view.xiff.XIFFConnectionMediator;
    import com.bluebyte.bluefire.puremvc.view.xiff.XIFFRoomManagerMediator;
    import com.bluebyte.bluefire.puremvc.view.xiff.XIFFRosterMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class ViewPrepCommand extends SimpleCommand 
    {


        override public function execute(_arg_1:INotification):void
        {
            var _local_2:Array = (_arg_1.getBody() as Array);
            facade.registerMediator(new (_local_2[1])(_local_2[0]));
            facade.registerMediator(new XIFFConnectionMediator());
            facade.registerMediator(new XIFFRoomManagerMediator());
            facade.registerMediator(new XIFFRosterMediator());
        }


    }
}
