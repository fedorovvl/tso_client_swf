package GameEvent
{
    import Trigger.Triggerable;
    import Communication.VO.GameEventVO;
    import __AS3__.vec.Vector;
    import Trigger.Trigger;
    import Effects.Effect;
    import Communication.VO.TriggerVO;
    import Communication.VO.EffectVO;
    import Trigger.TriggerFactory;
    import nLib.gMisc;
    import Effects.Effects.Reward;
    import Interface.cGameInterface;
    import __AS3__.vec.*;

    public class GameEvent implements Triggerable 
    {

        private var gameEventVO:GameEventVO;
        private var trigger_vector:Vector.<Trigger>;
        private var effect_vector:Vector.<Effect>;

        public function GameEvent(_arg_1:GameEventVO, _arg_2:cGameInterface)
        {
            var _local_4:Trigger;
            var _local_5:TriggerVO;
            var _local_6:EffectVO;
            super();
            this.gameEventVO = _arg_1;
            this.trigger_vector = new Vector.<Trigger>();
            this.effect_vector = new Vector.<Effect>();
            var _local_3:TriggerFactory = new TriggerFactory(_arg_2);
            for each (_local_5 in _arg_1.trigger_vector)
            {
                _local_4 = _local_3.createTrigger(_local_5, this);
                gMisc.Assert((!(_local_4.isReversible())), "Reversible trigger not supported by GameEvent");
                if (!_local_4.check())
                {
                    this.trigger_vector.push(_local_4);
                }
                else
                {
                    _local_4.dispose();
                };
            };
            for each (_local_6 in _arg_1.effect_vector)
            {
                if (_local_6.effect_string == Reward.XML_string)
                {
                    trace("NO GameEvent Rewards on Client only possible, UniqueID needed");
                }
                else
                {
                    this.effect_vector.push(_arg_2.effectFactory.createEffect(_local_6));
                };
            };
            if (this.trigger_vector.length == 0)
            {
                this.startEvent();
            };
        }

        public function dispose():void
        {
            var _local_1:Trigger;
            for each (_local_1 in this.trigger_vector)
            {
                _local_1.dispose();
            };
        }

        public function trigger(_arg_1:Trigger):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < this.trigger_vector.length)
            {
                if (_local_2 >= 0)
                {
                    this.trigger_vector.splice(_local_2, 1);
                    if (this.trigger_vector.length == 0)
                    {
                        this.startEvent();
                    };
                    return;
                };
                _local_2++;
            };
        }

        public function reset():void
        {
        }

        private function startEvent():void
        {
            var _local_1:int;
            var _local_2:int = this.effect_vector.length;
            _local_1 = 0;
            while (_local_1 < _local_2)
            {
                this.effect_vector[_local_1].apply();
                _local_1++;
            };
        }


    }
}
