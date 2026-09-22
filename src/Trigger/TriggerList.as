package Trigger
{
    import Model.Observer;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import Communication.VO.TriggerListVO;
    import Model.Notifiers.TickChannel;
    import Communication.VO.TriggerVO;
    import nLib.cLog;
    import Model.Notifier;
    import __AS3__.vec.*;

    public class TriggerList implements Trigger, Triggerable, Observer 
    {

        private var targetGridIdx:int = -1;
        private var triggers_vector:Vector.<Trigger> = null;
        private var triggerable:Triggerable = null;
        private var checkOnNextTick:Boolean = false;
        private var gi:cGeneralInterface;
        private var vo:TriggerListVO = null;

        public function TriggerList(_arg_1:Triggerable, _arg_2:TriggerListVO, _arg_3:cGeneralInterface)
        {
            super();
            this.vo = _arg_2;
            this.gi = _arg_3;
            this.triggerable = _arg_1;
            this.triggers_vector = this.createTriggers();
            if (_arg_2._doInstantChecks)
            {
                _arg_3.channels.TICK.addPropertyObserver(TickChannel.GAME_TICK, this);
            };
        }

        public static function instantCheckWithTarget(_arg_1:TriggerListVO, _arg_2:cGeneralInterface, _arg_3:int):Boolean
        {
            if (_arg_1 == null)
            {
                return (true);
            };
            var _local_4:TriggerList = new TriggerList(null, _arg_1, _arg_2);
            _local_4.targetGridIdx = _arg_3;
            var _local_5:Boolean = _local_4.check();
            _local_4.dispose();
            return (_local_5);
        }

        public static function instantCheck(_arg_1:TriggerListVO, _arg_2:cGeneralInterface):Boolean
        {
            return (instantCheckWithTarget(_arg_1, _arg_2, -1));
        }


        public function getCurrentAmount():Number
        {
            if ((((this.vo == null) || (this.vo.list == null)) || (this.triggers_vector == null)))
            {
                return (0);
            };
            return (this.vo.getTriggerCount() - this.triggers_vector.length);
        }

        public function check():Boolean
        {
            var _local_1:TriggerListVO;
            if (((this.vo == null) || (this.vo.list == null)))
            {
                return (true);
            };
            if (this.vo._doInstantChecks)
            {
                this.checkOnNextTick = false;
                _local_1 = (this.vo.clone() as TriggerListVO);
                _local_1._doInstantChecks = false;
                return (instantCheckWithTarget(_local_1, this.gi, this.targetGridIdx));
            };
            if (this.vo.is_OR_operator)
            {
                if (this.vo.getTriggerCount() > this.triggers_vector.length)
                {
                    this.triggersCompleted();
                    return (true);
                };
            }
            else
            {
                if (this.triggers_vector.length == 0)
                {
                    this.triggersCompleted();
                    return (true);
                };
            };
            return (false);
        }

        public function getDefinition():TriggerVO
        {
            return (this.vo);
        }

        public function setTriggerable(_arg_1:Triggerable):void
        {
            this.triggerable = _arg_1;
        }

        public function reset():void
        {
            this.disposeTriggers();
            this.triggers_vector = this.createTriggers();
            this.checkOnNextTick = false;
        }

        private function createTriggers():Vector.<Trigger>
        {
            var _local_2:Trigger;
            var _local_4:TriggerVO;
            var _local_1:TriggerFactory = new TriggerFactory(this.gi);
            var _local_3:Vector.<Trigger> = new Vector.<Trigger>();
            for each (_local_4 in this.vo.list)
            {
                if (this.targetGridIdx > -1)
                {
                    _local_4 = _local_4.clone();
                    _local_4.targetGridIdx = this.targetGridIdx;
                };
                _local_2 = _local_1.createTrigger(_local_4, this);
                if (((this.vo._doInstantChecks) || (!(_local_2.check()))))
                {
                    _local_3.push(_local_2);
                }
                else
                {
                    _local_2.dispose();
                };
            };
            return (_local_3);
        }

        public function getTriggerable():Triggerable
        {
            return (this.triggerable);
        }

        public function dispose():void
        {
            if (this.vo._doInstantChecks)
            {
                this.gi.channels.TICK.removePropertyObserver(TickChannel.GAME_TICK, this);
            };
            this.disposeTriggers();
            this.vo = null;
            this.gi = null;
            this.triggerable = null;
        }

        private function triggersCompleted():void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info("Triggerlist completed");
            };
            this.disposeTriggers();
            if (this.triggerable != null)
            {
                this.triggerable.trigger(this);
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:TriggerListVO;
            if (this.checkOnNextTick)
            {
                _local_4 = (this.vo.clone() as TriggerListVO);
                _local_4._doInstantChecks = false;
                if (instantCheckWithTarget(_local_4, this.gi, this.targetGridIdx))
                {
                    this.triggersCompleted();
                };
                this.checkOnNextTick = false;
            };
        }

        public function isRunning():Boolean
        {
            return (true);
        }

        public function trigger(_arg_1:Trigger):void
        {
            var _local_2:int;
            if (((!(this.triggers_vector == null)) && (!(this.vo._doInstantChecks))))
            {
                _local_2 = this.triggers_vector.indexOf(_arg_1);
                if (_local_2 > -1)
                {
                    this.triggers_vector.splice(_local_2, 1);
                };
                _arg_1.dispose();
                this.check();
            };
            if (((!(this.vo == null)) && (this.vo._doInstantChecks)))
            {
                this.checkOnNextTick = true;
            };
        }

        private function disposeTriggers():void
        {
            var _local_1:Trigger;
            if (this.triggers_vector != null)
            {
                for each (_local_1 in this.triggers_vector)
                {
                    _local_1.dispose();
                };
                this.triggers_vector = null;
            };
        }

        public function isReversible():Boolean
        {
            return (true);
        }


    }
}
