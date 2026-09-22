package Trigger.Triggers
{
    import Trigger.DeltaTrigger;
    import Model.Observer;
    import Model.Notifiers.ResourceChannel;
    import Trigger.TriggerDeltaValue;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGameInterface;
    import Utils.Pair;
    import Model.Notifier;
    import Interface.cGeneralInterface;

    public class ResourceDonatedTrigger extends DeltaTrigger implements Observer 
    {

        public static const XML_string:String = "resourcedonated";

        public function ResourceDonatedTrigger(_arg_1:TriggerDeltaValue, _arg_2:Triggerable, _arg_3:TriggerVO, _arg_4:cGameInterface)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
            if (_arg_3.type_string.toLowerCase() == "guildbank")
            {
                _arg_4.channels.RESOURCE.addPropertyObserver(ResourceChannel.GUILDBANK_DONATED_string, this);
            }
            else
            {
                _arg_4.channels.RESOURCE.addPropertyObserver(ResourceChannel.EVENT_DONATED_string, this);
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

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:Pair = (_arg_3 as Pair);
            if (definition.name_string == _local_4.getLeft())
            {
                getDelta().add((_local_4.getRight() as int));
                sendTriggerValueUpdated();
                this.check();
            };
        }

        override public function dispose():void
        {
            if (para != null)
            {
                if (definition.type_string.toLowerCase() == "guildbank")
                {
                    (para as cGeneralInterface).channels.RESOURCE.removePropertyObserver(ResourceChannel.GUILDBANK_DONATED_string, this);
                }
                else
                {
                    (para as cGeneralInterface).channels.RESOURCE.removePropertyObserver(ResourceChannel.EVENT_DONATED_string, this);
                };
            };
            super.dispose();
        }


    }
}
