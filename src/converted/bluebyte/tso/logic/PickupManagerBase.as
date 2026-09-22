package converted.bluebyte.tso.logic
{
    import Model.Notifier;
    import Interface.cGeneralInterface;
    import mx.collections.ArrayCollection;
    import Effects.EffectFactory;
    import Interface.cGameInterface;
    import Communication.VO.EffectVO;
    import Effects.Effects.Reward;
    import Communication.VO.dPersistedPickupItemVO;
    import Communication.VO.dUniqueID;

    public class PickupManagerBase extends Notifier 
    {

        protected var gi:cGeneralInterface;
        protected var pickups:ArrayCollection = new ArrayCollection();
        protected var effectFactory:EffectFactory;

        public function PickupManagerBase(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
            this.effectFactory = (_arg_1 as cGameInterface).effectFactory;
        }

        protected function executePickup(_arg_1:dPersistedPickupItemVO):void
        {
            var _local_2:EffectVO;
            if (_arg_1.getAmount() > 0)
            {
                _local_2 = new EffectVO();
                _local_2.effect_string = Reward.XML_string;
                _local_2.type_string = "resource";
                _local_2.name_string = _arg_1.item_string;
                _local_2.amount = _arg_1.getAmount();
                _local_2.uniqueID = _arg_1.uniqueID;
                this.effectFactory.createEffect(_local_2).apply();
            };
            this.pickups.removeItemAt(this.pickups.getItemIndex(_arg_1));
        }

        public function pickup(_arg_1:dUniqueID):Boolean
        {
            var _local_2:dPersistedPickupItemVO;
            for each (_local_2 in this.pickups)
            {
                if (_local_2.uniqueID.eq(_arg_1))
                {
                    this.executePickup(_local_2);
                    return (true);
                };
            };
            return (false);
        }


    }
}
