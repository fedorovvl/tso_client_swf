package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Model.Notifier;
    import Utils.StringUtils;
    import Utils.TriggerUtils;
    import Enums.ADVENTURE_MODE;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGameInterface;
    import Trigger.vo.GeneralTravelTriggerVO;

    public class GeneralsVisitAdventure extends DeltaTrigger implements Observer 
    {

        private var notifier:Notifier;
        private var nameList:Array;
        private var modes:int;

        public function GeneralsVisitAdventure(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGameInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.nameList = StringUtils.split(_arg_3.item_string, StringUtils.COMMA);
            this.notifier = _arg_4.channels.SPECIALIST;
            this.notifier.addPropertyObserver(TriggerUtils.GENERAL_TRAVEL_PROPERTY_NAME, this);
            this.modes = ADVENTURE_MODE.stringToBitField(_arg_3.mode_string);
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

        override public function dispose():void
        {
            if (this.notifier != null)
            {
                this.notifier.removePropertyObserver(TriggerUtils.GENERAL_TRAVEL_PROPERTY_NAME, this);
                this.notifier = null;
            };
            this.nameList = null;
            super.dispose();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:GeneralTravelTriggerVO = (_arg_3 as GeneralTravelTriggerVO);
            var _local_5:String = _local_4.getGeneralName();
            if (((_local_4.getZoneId() < 0) && ((this.nameList.length == 0) || (TriggerUtils.contains(this.nameList, _local_5)))))
            {
                getDelta().add(1);
                sendTriggerValueUpdated();
                this.check();
            };
        }


    }
}
