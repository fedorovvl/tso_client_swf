package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Utils.TriggerUtils;
    import Enums.ADVENTURE_MODE;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.dBuffVO;
    import mx.collections.ArrayCollection;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import Model.Notifier;

    public class LootedResourcesTrigger extends DeltaTrigger implements Observer 
    {

        private var modes:int = 0;

        public function LootedResourcesTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            _arg_4.mCurrentPlayer.addPropertyObserver(TriggerUtils.LOOT_RESOURCE_NAME, this);
            this.modes = ADVENTURE_MODE.stringToBitField(_arg_3.mode_string);
        }

        private function checkAdventureType(_arg_1:cAdventureDefinition):Boolean
        {
            return ((((definition.target_string.length == 0) || (StringUtils.contains(_arg_1.GetType_string(), definition.target_string))) || (StringUtils.contains(_arg_1.GetTheme_string(), definition.target_string))) || (StringUtils.contains(_arg_1.GetCampaign_string(), definition.target_string)));
        }

        private function checkDifficulty(_arg_1:String):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1);
            return ((definition.tier == 0) || (_local_2.GetDifficulty() >= definition.tier));
        }

        private function countValidAmount(_arg_1:ArrayCollection):int
        {
            var _local_4:Object;
            var _local_5:dBuffVO;
            var _local_2:int;
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = _arg_1[_local_3];
                if ((_local_4 is dBuffVO))
                {
                    _local_5 = (_local_4 as dBuffVO);
                    if (_local_5.buffName_string == defines.ADD_RESOURCE_BUFF)
                    {
                        if (((definition.isTypeEmpty()) || (definition.typeContains(_local_5.resourceName_string))))
                        {
                            _local_2 = (_local_2 + _local_5.amount);
                        };
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        override public function check():Boolean
        {
            var _local_1:Number = getDelta().getValue();
            if (_local_1 >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        private function checkMode(_arg_1:String):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1);
            var _local_3:* = (1 << _local_2.GetMode());
            return ((this.modes & _local_3) == _local_3);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_6:int;
            var _local_4:dLootItemsVO = (_arg_3 as dLootItemsVO);
            var _local_5:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_local_4.mailVO.senderName);
            if (((((!(_local_5 == null)) && (this.checkMode(_local_5.GetName()))) && (this.checkDifficulty(_local_5.GetName()))) && (this.checkAdventureType(_local_5))))
            {
                _local_6 = this.countValidAmount(_local_4.items);
                _local_6 = (_local_6 + this.countValidAmount(_local_4.premiumItems));
                if (_local_6 > 0)
                {
                    getDelta().add(_local_6);
                    sendTriggerValueUpdated();
                    this.check();
                };
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).mCurrentPlayer.removePropertyObserver(TriggerUtils.LOOT_RESOURCE_NAME, this);
            super.dispose();
        }


    }
}
