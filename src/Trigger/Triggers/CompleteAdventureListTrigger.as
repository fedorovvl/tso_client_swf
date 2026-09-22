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

    public class CompleteAdventureListTrigger extends DeltaTrigger implements Observer 
    {

        private var playerZone:cPlayerZoneScreen;
        private var adventureList:Array;
        private var modes:int = 0;
        private var typeList:Array;

        public function CompleteAdventureListTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.adventureList = StringUtils.split(_arg_3.item_string, StringUtils.COMMA);
            this.typeList = StringUtils.split(_arg_3.type_string, StringUtils.COMMA);
            this.playerZone = _arg_4.mCurrentPlayerZone;
            this.playerZone.addPropertyObserver(TriggerUtils.ADVENTURE_COMPLETED_PROPERTY_NAME, this);
            this.modes = ADVENTURE_MODE.stringToBitField(_arg_3.mode_string);
        }

        private function checkDifficulty(_arg_1:dRemovedAdventureVO):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName);
            return ((definition.tier == 0) || (_local_2.GetDifficulty() >= definition.tier));
        }

        private function checkIfIsNotExpedition(_arg_1:dRemovedAdventureVO):Boolean
        {
            return (_arg_1.colonyId == 0);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dRemovedAdventureVO = (_arg_3 as dRemovedAdventureVO);
            if ((((this.checkAdventureList(_local_4)) && (this.checkIfIsNotExpedition(_local_4))) && (this.checkDifficulty(_local_4))))
            {
                getDelta().add(1);
                sendTriggerValueUpdated();
                this.check();
            };
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

        private function checkAdventureList(_arg_1:dRemovedAdventureVO):Boolean
        {
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName);
            var _local_3:* = (1 << _local_2.GetMode());
            if ((this.modes & _local_3) != _local_3)
            {
                return (false);
            };
            var _local_4:* = (!(this.adventureList.length() == 0));
            var _local_5:* = (!(this.typeList.length() == 0));
            var _local_6:Boolean = ((_local_4) && (TriggerUtils.contains(this.adventureList, _arg_1.adventureName)));
            var _local_7:Boolean = ((_local_5) && (((TriggerUtils.contains(this.typeList, _local_2.GetType_string())) || (TriggerUtils.contains(this.typeList, _local_2.GetTheme_string()))) || (TriggerUtils.contains(this.typeList, _local_2.GetCampaign_string()))));
            return (((_local_6) || (_local_7)) || ((!(_local_4)) && (!(_local_5))));
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


    }
}
