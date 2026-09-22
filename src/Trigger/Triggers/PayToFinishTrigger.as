package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import ServerState.cPlayerData;
    import ServerState.cResources;

    public class PayToFinishTrigger extends InstantTrigger 
    {

        public function PayToFinishTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        override public function check():Boolean
        {
            return (false);
        }

        override public function getCurrentAmount():Number
        {
            var _local_1:cPlayerData = (para as cGeneralInterface).mCurrentPlayer;
            var _local_2:cResources = (para as cGeneralInterface).mCurrentPlayerZone.GetResources(_local_1);
            var _local_3:Number = _local_2.GetPlayerResource(definition.item_string).amount;
            return (Math.min(definition.amount, _local_3));
        }


    }
}
