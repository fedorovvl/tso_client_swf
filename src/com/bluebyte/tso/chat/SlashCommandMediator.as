package com.bluebyte.tso.chat
{
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import mx.collections.ArrayCollection;
    import com.bluebyte.bluefire.puremvc.BlueFireFacade;
    import com.bluebyte.bluefire.api.controller.slashCommands.SlashCommand;
    import org.puremvc.as3.multicore.interfaces.INotification;

    public class SlashCommandMediator extends Mediator 
    {

        public static const NAME:String = "SlashCommandMediator";
        private static const _commands:ArrayCollection = new ArrayCollection();

        public function SlashCommandMediator()
        {
            super(NAME);
        }

        override public function listNotificationInterests():Array
        {
            return ([BlueFireFacade.REGISTER_SLASH_COMMAND, BlueFireFacade.EVALUATE_SLASH_COMMAND]);
        }

        override public function handleNotification(_arg_1:INotification):void
        {
            var _local_2:SlashCommand;
            var _local_3:String;
            switch (_arg_1.getName())
            {
                case BlueFireFacade.REGISTER_SLASH_COMMAND:
                    _commands.addItem(_arg_1.getBody());
                    return;
                case BlueFireFacade.EVALUATE_SLASH_COMMAND:
                    for each (_local_2 in _commands)
                    {
                        _local_3 = _local_2.execute((_arg_1.getBody() as String));
                        if (_local_3)
                        {
                            sendNotification(_local_3, _arg_1.getBody());
                            break;
                        };
                    };
                    return;
            };
        }


    }
}
