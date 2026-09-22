package converted.bluebyte.tso.cooldown
{
    import Model.Observer;
    import Interface.cGeneralInterface;
    import Utils.HashMapWrapper;
    import Model.Notifiers.TickChannel;
    import Communication.VO.CooldownVO;
    import Model.Notifier;

    public class CooldownManagerBase implements Observer 
    {

        protected var gi:cGeneralInterface;

        protected var cooldowns:HashMapWrapper = new HashMapWrapper();
        protected var bonusProviders:HashMapWrapper = new HashMapWrapper();

        public function CooldownManagerBase(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
            _arg_1.channels.TICK.addPropertyObserver(TickChannel.GAME_TICK, this);
        }

        public function getBonusProvider(_arg_1:int):CooldownTimeBonusProvider
        {
            return (this.bonusProviders.getItem(_arg_1) as CooldownTimeBonusProvider);
        }

        public function getRemainingCooldown(_arg_1:int):Number
        {
            var _local_2:Number = this.getEndTime(_arg_1);
            var _local_3:Number = (_local_2 - this.gi.GetClientTime());
            return ((_local_3 > 0) ? _local_3 : 0);
        }

        public function setCooldown(_arg_1:int, _arg_2:Number):void
        {
            this.set(_arg_1, _arg_2);
        }

        protected function set(_arg_1:int, _arg_2:Number):void
        {
            var _local_3:CooldownVO;
            if (this.cooldowns.hasKey(_arg_1))
            {
                _local_3 = (this.cooldowns.getItem(_arg_1) as CooldownVO);
                _local_3.dirtyIndicator.strongModified();
            }
            else
            {
                _local_3 = new CooldownVO();
                _local_3.id = _arg_1;
                _local_3.dirtyIndicator.created();
                this.cooldowns.putItem(_arg_1, _local_3);
            };
            _local_3.starttime = this.gi.GetClientTime();
            _local_3.duration = _arg_2;
        }

        public function getEndTime(_arg_1:int):Number
        {
            if (!this.cooldowns.hasKey(_arg_1))
            {
                return (0);
            };
            var _local_2:CooldownVO = (this.cooldowns.getItem(_arg_1) as CooldownVO);
            var _local_3:Number = _local_2.duration;
            if (_local_3 == 0)
            {
                return (0);
            };
            if (this.hasBonusProvider(_arg_1))
            {
                _local_3 = (_local_3 / (this.getBonusProvider(_arg_1).getCooldownTimeBonus() / 100));
            };
            return (_local_2.starttime + _local_3);
        }

        public function registerBonusProvider(_arg_1:int, _arg_2:CooldownTimeBonusProvider):void
        {
            if (!this.hasBonusProvider(_arg_1))
            {
                this.bonusProviders.putItem(_arg_1, _arg_2);
            };
        }

        public function hasBonusProvider(_arg_1:int):Boolean
        {
            return (this.bonusProviders.hasKey(_arg_1));
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:int;
            for each (_local_4 in this.cooldowns.keySet())
            {
                if (((this.getEndTime(_local_4) > 0) && (this.getRemainingCooldown(_local_4) <= 0)))
                {
                    this.gi.channels.ZONE.cooldownExpired(_local_4);
                    this.resetCooldown(_local_4);
                };
            };
        }

        public function resetCooldown(_arg_1:int):void
        {
            this.set(_arg_1, 0);
        }


    }
}
