package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Utils.StringUtils;
    import Enums.ADVENTURE_MODE;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Utils.TriggerUtils;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.dZoneVO;
    import Model.Notifier;

    public class VisitAdventureTrigger extends InstantTrigger implements Observer 
    {

        private var modes:int;
        private var adventureName_string:String = "";
        private var colonyState:int = 0;
        private var adventureList:Array;

        public function VisitAdventureTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
            _arg_3.channels.ZONE.addPropertyObserver("VISIT_ADVENTURE", this);
            this.adventureList = StringUtils.split(_arg_2.item_string, StringUtils.COMMA);
            this.modes = ADVENTURE_MODE.stringToBitField(_arg_2.mode_string);
        }

        override public function check():Boolean
        {
            if ((((this.checkMode(this.adventureName_string)) && (TriggerUtils.contains(this.adventureList, this.adventureName_string))) && ((this.definition.state == 0) || (this.definition.state == this.colonyState))))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        private function checkMode(_arg_1:String):Boolean
        {
            var _local_3:int;
            if (StringUtils.isEmpty(_arg_1))
            {
                return (false);
            };
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1);
            if (_local_2 != null)
            {
                _local_3 = (1 << _local_2.GetMode());
                return ((this.modes & _local_3) == _local_3);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if ((_arg_3 is dZoneVO))
            {
                this.adventureName_string = (_arg_3 as dZoneVO).adventureName;
                this.colonyState = (_arg_3 as dZoneVO).colonyState;
                this.check();
            };
        }

        override public function dispose():void
        {
            (para as cGeneralInterface).channels.ZONE.removePropertyObserver("VISIT_ADVENTURE", this);
            super.dispose();
            this.adventureList = null;
        }


    }
}
