package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import mx.collections.ArrayCollection;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;

    public class dDepositVO implements IEventDispatcher 
    {

        private var _287344023gridIdx:uint;
        private var _1141400650accessible:int;
        private var _1266057854depositGroupdId:int;
        private var _1623837028emptied:uint;
        private var _474299536refillable:Boolean;
        private var _1413853096amount:int;
        private var _1935748339goSetListName_string:String;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _900562878skills:ArrayCollection;
        private var _1098889508maxAmount:int;
        private var _324534341name_string:String;

        public function dDepositVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function set skills(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._900562878skills;
            if (_local_2 !== _arg_1)
            {
                this._900562878skills = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "skills", _local_2, _arg_1));
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set name_string(_arg_1:String):void
        {
            var _local_2:Object = this._324534341name_string;
            if (_local_2 !== _arg_1)
            {
                this._324534341name_string = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name_string", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get goSetListName_string():String
        {
            return (this._1935748339goSetListName_string);
        }

        [Bindable(event="propertyChange")]
        public function get refillable():Boolean
        {
            return (this._474299536refillable);
        }

        [Bindable(event="propertyChange")]
        public function get gridIdx():uint
        {
            return (this._287344023gridIdx);
        }

        public function set goSetListName_string(_arg_1:String):void
        {
            var _local_2:Object = this._1935748339goSetListName_string;
            if (_local_2 !== _arg_1)
            {
                this._1935748339goSetListName_string = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "goSetListName_string", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get emptied():uint
        {
            return (this._1623837028emptied);
        }

        public function set refillable(_arg_1:Boolean):void
        {
            var _local_2:Object = this._474299536refillable;
            if (_local_2 !== _arg_1)
            {
                this._474299536refillable = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "refillable", _local_2, _arg_1));
            };
        }

        public function set gridIdx(_arg_1:uint):void
        {
            var _local_2:Object = this._287344023gridIdx;
            if (_local_2 !== _arg_1)
            {
                this._287344023gridIdx = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "gridIdx", _local_2, _arg_1));
            };
        }

        public function set amount(_arg_1:int):void
        {
            var _local_2:Object = this._1413853096amount;
            if (_local_2 !== _arg_1)
            {
                this._1413853096amount = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "amount", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get accessible():int
        {
            return (this._1141400650accessible);
        }

        public function set emptied(_arg_1:uint):void
        {
            var _local_2:Object = this._1623837028emptied;
            if (_local_2 !== _arg_1)
            {
                this._1623837028emptied = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "emptied", _local_2, _arg_1));
            };
        }

        public function set maxAmount(_arg_1:int):void
        {
            var _local_2:Object = this._1098889508maxAmount;
            if (_local_2 !== _arg_1)
            {
                this._1098889508maxAmount = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxAmount", _local_2, _arg_1));
            };
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get skills():ArrayCollection
        {
            return (this._900562878skills);
        }

        [Bindable(event="propertyChange")]
        public function get name_string():String
        {
            return (this._324534341name_string);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        [Bindable(event="propertyChange")]
        public function get amount():int
        {
            return (this._1413853096amount);
        }

        [Bindable(event="propertyChange")]
        public function get maxAmount():int
        {
            return (this._1098889508maxAmount);
        }

        public function set accessible(_arg_1:int):void
        {
            var _local_2:Object = this._1141400650accessible;
            if (_local_2 !== _arg_1)
            {
                this._1141400650accessible = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "accessible", _local_2, _arg_1));
            };
        }

        public function toString():String
        {
            return (((((((((((((((((((("<dDepositVO name_string='" + this.name_string) + "' amount='") + this.amount) + "' maxAmount='") + this.maxAmount) + "' gridIdx='") + this.gridIdx) + "' depositGroupdId='") + this.depositGroupdId) + "' accessible='") + this.accessible) + "' accessibleString='") + DEPOSIT_ACCESSIBLE_TYPES.toString(this.accessible)) + "' emptied='") + this.emptied) + "' goSetListName_string='") + this.goSetListName_string) + "' refillable='") + this.refillable) + "' />");
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function set depositGroupdId(_arg_1:int):void
        {
            var _local_2:Object = this._1266057854depositGroupdId;
            if (_local_2 !== _arg_1)
            {
                this._1266057854depositGroupdId = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "depositGroupdId", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get depositGroupdId():int
        {
            return (this._1266057854depositGroupdId);
        }


    }
}
