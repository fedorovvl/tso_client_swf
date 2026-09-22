package com.bluebyte.tso.service
{
    import Model.Observer;
    import com.bluebyte.tso.service.services.SpecialistService;
    import com.bluebyte.tso.service.services.PickupService;
    import com.bluebyte.tso.service.services.ColonyService;
    import com.bluebyte.tso.service.services.CombatService;
    import __AS3__.vec.Vector;
    import Model.Notifiers.TickChannel;
    import Model.Notifier;
    import ServerState.Responding;
    import Interface.cGameInterface;
    import __AS3__.vec.*;

    public class ServiceManager implements Observer 
    {

        private static var _inst:ServiceManager;

        public const specialist:SpecialistService = new SpecialistService();
        public const pickup:PickupService = new PickupService();
        public const colony:ColonyService = new ColonyService();
        public const combat:CombatService = new CombatService();
        private var commandQueue:Vector.<QueuedCommand> = new Vector.<QueuedCommand>();

        public function ServiceManager()
        {
            super();
            if (_inst)
            {
                throw (new Error("Multiple instances of ServiceManager!"));
            };
            _inst = this;
            this.getGI().channels.TICK.addPropertyObserver(TickChannel.GAME_TICK, this);
        }

        public static function getInstance():ServiceManager
        {
            if (!_inst)
            {
                new (ServiceManager)();
            };
            return (_inst);
        }


        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:QueuedCommand;
            if (this.commandQueue.length > 0)
            {
                _local_4 = this.commandQueue.pop();
                this.getGI().mClientMessages.SendMessagetoServer(_local_4.command, _local_4.targetZone, _local_4.data, _local_4.responder);
            };
        }

        internal function send(_arg_1:int, _arg_2:Object, _arg_3:int, _arg_4:Responding=null):void
        {
            this.commandQueue.push(new QueuedCommand(_arg_1, _arg_2, _arg_3, _arg_4));
        }

        private function getGI():cGameInterface
        {
            return (global.getApplication().mGameInterface as cGameInterface);
        }


    }
}
