package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Interface.cGeneralInterface;
    import BuffSystem.cBuffDefinition;
    import BuffSystem.cBuff;
    import Utils.TriggerUtils;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Model.Notifier;
    import GO.cBuilding;

    public final class BuffInsufficientTargetBuildingsTrigger extends InstantTrigger implements Observer 
    {

        private var targets:String;
        private var gi:cGeneralInterface;
        private var buffTargets:Array;

        public function BuffInsufficientTargetBuildingsTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.channels.BUFF);
            this.gi = _arg_3;
            this.buffTargets = cBuffDefinition.GetByName(_arg_2.item_string).GetTargetDescription_string().split(",");
            this.targets = cBuffDefinition.GetByName(_arg_2.item_string).GetTargetDescription_string();
            currentAmount = 0;
            _arg_3.channels.BUFF.addPropertyObserver(cBuff.BUFF_APPLIED_string, this);
            _arg_3.channels.ZONE.addPropertyObserver(TriggerUtils.ZONE_LOADED, this);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.check();
        }

        private function CalculateAppliances():int
        {
            var _local_2:String;
            var _local_3:cBuilding;
            var _local_1:int;
            if (this.gi.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector().length == 0)
            {
                return (definition.min);
            };
            for each (_local_2 in this.buffTargets)
            {
                if (this.gi.mCurrentPlayerZone.mStreetDataMap.getBuildingsByName_vector(_local_2) != null)
                {
                    for each (_local_3 in this.gi.mCurrentPlayerZone.mStreetDataMap.getBuildingsByName_vector(_local_2))
                    {
                        if (((_local_3.productionBuff == null) || (_local_3.productionBuff.GetBuffDefinition().GetName_string() == definition.item_string)))
                        {
                            _local_1++;
                        };
                    };
                };
            };
            return (_local_1);
        }

        override public function check():Boolean
        {
            if (this.CalculateAppliances() < definition.min)
            {
                trigger();
                return (true);
            };
            return (false);
        }

        override public function dispose():void
        {
            this.gi.channels.BUFF.removePropertyObserver(cBuff.BUFF_APPLIED_string, this);
            this.gi.channels.ZONE.removePropertyObserver(TriggerUtils.ZONE_LOADED, this);
            super.dispose();
        }


    }
}
