package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorManager;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorDefinitions;
    import Interface.cGeneralInterface;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Communication.VO.dContentGeneratorRollVO;
    import Utils.StringUtils;
    import Model.Notifier;

    public class RollCollectionTrigger extends DeltaTrigger implements Observer 
    {

        private static const dummy1:ContentGeneratorManager = null;
        private static const dummy2:ContentGeneratorDefinitions = null;

        private var gi:cGeneralInterface;

        public function RollCollectionTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:Object)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            this.gi = (_arg_4 as cGeneralInterface);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:dContentGeneratorRollVO = (_arg_3 as dContentGeneratorRollVO);
            if (((StringUtils.isEmpty(definition.item_string)) || (definition.id == _local_4.compilationId)))
            {
                getDelta().add(_local_4.rollAmount);
                sendTriggerValueUpdated();
                this.check();
            };
        }

        override public function dispose():void
        {
            super.dispose();
        }

        override public function check():Boolean
        {
            if (getCurrentAmount() >= definition.amount)
            {
                trigger();
                return (true);
            };
            return (false);
        }


    }
}
