package com.bluebyte.tso.logic
{
    import converted.bluebyte.tso.logic.PickupManagerBase;
    import flash.utils.Dictionary;
    import Interface.cGeneralInterface;
    import mx.collections.ArrayCollection;
    import Communication.VO.dPersistedPickupItemVO;
    import Communication.VO.dRequirementVO;
    import Enums.PICKUP_PROVIDER_TYPE;
    import Interface.cGameInterface;
    import Communication.VO.dRequirementsVO;
    import Communication.VO.dPickupItemVO;

    public class PickupManager extends PickupManagerBase 
    {

        private var pickupAmountTotals:Dictionary = new Dictionary();

        public function PickupManager(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
        }

        public function getPickups():ArrayCollection
        {
            return (pickups);
        }

        public function getUsedSpace(_arg_1:int):int
        {
            return (this.pickupAmountTotals[_arg_1]);
        }

        private function mapPickupsByUniqueID():Dictionary
        {
            var _local_2:dPersistedPickupItemVO;
            var _local_1:Dictionary = new Dictionary(true);
            for each (_local_2 in pickups)
            {
                _local_1[_local_2.uniqueID.toKeyString()] = _local_2;
            };
            return (_local_1);
        }

        public function getTotalSpace(_arg_1:int):int
        {
            return (global.pickupManagerLimitsPerType.getItem(_arg_1) + this.getExtraSpace(_arg_1));
        }

        public function getExtraSpace(_arg_1:int):int
        {
            var _local_4:dRequirementVO;
            var _local_2:int;
            var _local_3:dRequirementsVO = (gi as cGameInterface).mRequirements.pickupManagerRequirements_vector[PICKUP_PROVIDER_TYPE.toString(_arg_1)];
            for each (_local_4 in _local_3.requirements)
            {
                if (((_local_4.fulfilled) && (_local_4.amount > _local_2)))
                {
                    _local_2 = _local_4.amount;
                };
            };
            return (_local_2);
        }

        public function updatePickups(_arg_1:ArrayCollection):void
        {
            var _local_4:dPersistedPickupItemVO;
            var _local_5:dPickupItemVO;
            var _local_6:String;
            var _local_7:dPersistedPickupItemVO;
            var _local_8:int;
            this.pickupAmountTotals = new Dictionary();
            var _local_2:Dictionary = this.mapPickupsByUniqueID();
            var _local_3:Dictionary = new Dictionary(true);
            for each (_local_4 in _arg_1)
            {
                _local_6 = _local_4.uniqueID.toKeyString();
                _local_7 = _local_2[_local_6];
                if (_local_7)
                {
                    _local_7.setAmount(_local_4.getAmount());
                }
                else
                {
                    pickups.addItem(_local_4);
                    _local_2[_local_6] = _local_4;
                    _local_7 = _local_4;
                };
                _local_3[_local_6] = _local_7;
            };
            for (_local_6 in _local_2)
            {
                if (!(_local_6 in _local_3))
                {
                    _local_8 = pickups.getItemIndex(_local_2[_local_6]);
                    if (_local_8 > -1)
                    {
                        pickups.removeItemAt(_local_8);
                    };
                };
            };
            for each (_local_5 in pickups)
            {
                if (!this.pickupAmountTotals[_local_5.providerType])
                {
                    this.pickupAmountTotals[_local_5.providerType] = 0;
                };
                this.pickupAmountTotals[_local_5.providerType] = (this.pickupAmountTotals[_local_5.providerType] + _local_5.amount);
            };
            globalFlash.gui.mColonyWindow.mPanel.yieldPanel.Update();
        }


    }
}
