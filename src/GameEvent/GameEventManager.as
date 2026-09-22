package GameEvent
{
    import GameEvent.GameEvent;
    import flash.utils.getDefinitionByName;
    import __AS3__.vec.Vector;
    import Communication.VO.GameEventVO;
    import Interface.cGameInterface;
    import __AS3__.vec.*;

    public final class GameEventManager 
    {

        private var gameEvent_vector:Vector.<GameEvent>;

        public function GameEventManager()
        {
            super();
            this.gameEvent_vector = new Vector.<GameEvent>();
            this.createTriggers();
        }

        public function createTriggers():void
        {
            var _local_2:GameEventVO;
            var eventClass:Class = getDefinitionByName("GameEvent.GameEvent") as Class;
            var _local_1:Vector.<GameEventVO> = global.gameEvent_vector;
            for each (_local_2 in _local_1)
            {
                this.gameEvent_vector.push(new eventClass(_local_2, (global.ui as cGameInterface)));
            };
        }

        public function dispose():void
        {
            var _local_1:GameEvent;
            for each (_local_1 in this.gameEvent_vector)
            {
                _local_1.dispose();
            };
            this.gameEvent_vector = new Vector.<GameEvent>();
        }


    }
}
