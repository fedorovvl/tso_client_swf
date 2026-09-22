package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Map.cPlayerZoneScreen;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import Enums.ADVENTURE_MODE;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.UpdateVO.dRemovedAdventureVO;
    import Model.Notifier;

    public class TimeInAdventureListTrigger extends DeltaTrigger implements Observer 
    {

        private var playerZone:cPlayerZoneScreen;
        private var adventureList:Array;
        private var modes:int;

        public function TimeInAdventureListTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.adventureList = StringUtils.split(_arg_3.item_string, StringUtils.COMMA);
            this.playerZone = _arg_4.mCurrentPlayerZone;
            this.playerZone.addPropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
            this.modes = ADVENTURE_MODE.stringToBitField(_arg_3.mode_string);
        }

        private function checkType(_arg_1:String):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1);
            var _local_3:* = (1 << _local_2.GetMode());
            if ((this.modes & _local_3) != _local_3)
            {
                return (false);
            };
            return ((((definition.type_string.length == 0) || (StringUtils.contains(_local_2.GetType_string(), definition.type_string))) || (StringUtils.contains(_local_2.GetTheme_string(), definition.type_string))) || (StringUtils.contains(_local_2.GetCampaign_string(), definition.type_string)));
        }

        override public function dispose():void
        {
            if (this.playerZone != null)
            {
                this.playerZone.removePropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
                this.playerZone = null;
            };
            this.adventureList = null;
            super.dispose();
        }

        override public function check():Boolean
        {
            var _local_1:Number = getCurrentAmount();
            if (_local_1 >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dRemovedAdventureVO = (_arg_3 as dRemovedAdventureVO);
            var _local_5:String = _local_4.adventureName;
            var _local_6:Number = 0;
            if (((this.checkType(_local_5)) && ((this.adventureList.length == 0) || (TriggerUtils.contains(this.adventureList, _local_5)))))
            {
                getDelta().add(_local_6);
                sendTriggerValueUpdated();
                this.check();
            };
        }


    }
}
