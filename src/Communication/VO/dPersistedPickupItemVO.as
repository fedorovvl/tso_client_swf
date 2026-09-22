package Communication.VO
{
    import ServerOnly.DirtyIndicator;
    import mx.events.PropertyChangeEvent;

    public class dPersistedPickupItemVO extends dPickupItemVO 
    {

        [Transient]
        private var _1090974990executing:Boolean;
        private var _294460244uniqueID:dUniqueID;
        private var _1227528611dirtyIndicator:DirtyIndicator = new DirtyIndicator();

        public function dPersistedPickupItemVO()
        {
            super();
            this.dirtyIndicator.created();
        }

        [Bindable(event="propertyChange")]
        public function get dirtyIndicator():DirtyIndicator
        {
            return (this._1227528611dirtyIndicator);
        }

        public function set dirtyIndicator(_arg_1:DirtyIndicator):void
        {
            var _local_2:Object = this._1227528611dirtyIndicator;
            if (_local_2 !== _arg_1)
            {
                this._1227528611dirtyIndicator = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dirtyIndicator", _local_2, _arg_1));
            };
        }

        public function set executing(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1090974990executing;
            if (_local_2 !== _arg_1)
            {
                this._1090974990executing = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "executing", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get uniqueID():dUniqueID
        {
            return (this._294460244uniqueID);
        }

        [Transient]
        [Bindable(event="propertyChange")]
        public function get executing():Boolean
        {
            return (this._1090974990executing);
        }

        public function set uniqueID(_arg_1:dUniqueID):void
        {
            var _local_2:Object = this._294460244uniqueID;
            if (_local_2 !== _arg_1)
            {
                this._294460244uniqueID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "uniqueID", _local_2, _arg_1));
            };
        }

        override public function setAmount(_arg_1:int):void
        {
            var _local_2:int = getAmount();
            super.setAmount(_arg_1);
            if (getAmount() != _local_2)
            {
                this.dirtyIndicator.weakModified();
            };
        }

        public function copyFromPickup(_arg_1:dPickupItemVO):void
        {
            this.zoneID = _arg_1.zoneID;
            this.providerType = _arg_1.providerType;
            this.item_string = _arg_1.item_string;
            this.setAmount(_arg_1.getAmount());
        }

        public function applyChange(_arg_1:dPickupItemVO):Boolean
        {
            if ((((_arg_1.zoneID == this.zoneID) && (_arg_1.providerType == this.providerType)) && ((!(_arg_1.item_string == null)) && (_arg_1.item_string == item_string))))
            {
                this.setAmount((this.getAmount() + _arg_1.getAmount()));
                return (true);
            };
            return (false);
        }


    }
}
