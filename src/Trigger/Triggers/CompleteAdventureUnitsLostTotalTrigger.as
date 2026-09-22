package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Map.cPlayerZoneScreen;
    import flash.utils.Dictionary;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Trigger.vo.CompletePvPColonyUnitsTriggerVO;
    import Utils.PVPUtil;
    import Model.Notifier;

    public class CompleteAdventureUnitsLostTotalTrigger extends InstantTrigger implements Observer 
    {

        private var playerZone:cPlayerZoneScreen;
        private var casualties:Dictionary;

        public function CompleteAdventureUnitsLostTotalTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.playerZone = _arg_3.mCurrentPlayerZone;
            this.playerZone.addPropertyObserver(TriggerUtils.ADVENTURE_PVP_COMPLETED_CHECK_UNITS_PROPERTY_NAME, this);
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_2:String;
            var _local_1:int;
            if (this.casualties == null)
            {
                return (int.MAX_VALUE);
            };
            for (_local_2 in this.casualties)
            {
                _local_1 = (_local_1 + this.casualties[_local_2]);
            };
            return (_local_1);
        }

        private function checkType(_arg_1:CompletePvPColonyUnitsTriggerVO):Boolean
        {
            return ((definition.isTypeEmpty()) || (TriggerUtils.CheckAdventureSize(definition.GetTypeString(), _arg_1.mapLevel)));
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (_local_1 <= definition.max)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        private function checkTier(_arg_1:CompletePvPColonyUnitsTriggerVO):Boolean
        {
            return ((definition.tier == 0) || (definition.tier == PVPUtil.getColonyTier(int(Math.floor((_arg_1.mapLevel / 10))))));
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:CompletePvPColonyUnitsTriggerVO = (_arg_3 as CompletePvPColonyUnitsTriggerVO);
            if (_local_4 == null)
            {
                return;
            };
            if (((this.checkType(_local_4)) && (this.checkTier(_local_4))))
            {
                this.casualties = _local_4.casualties;
                this.check();
                this.casualties = null;
            };
        }

        override public function dispose():void
        {
            if (this.playerZone != null)
            {
                this.playerZone.removePropertyObserver(TriggerUtils.ADVENTURE_PVP_COMPLETED_CHECK_UNITS_PROPERTY_NAME, this);
                this.playerZone = null;
            };
            this.casualties = null;
            super.dispose();
        }


    }
}
