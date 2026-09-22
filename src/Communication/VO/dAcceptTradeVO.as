package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dAcceptTradeVO implements IEventDispatcher 
    {

        private var _105650780offer:Object;
        private var _1086538152slotType:int;
        private var _94849606costs:Object;
        private var _2113263754slotPos:int;
        private var _1247963664senderID:int;
        private var _3355id:int;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _294460244uniqueID:dUniqueID;

        public function dAcceptTradeVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get costs():Object
        {
            return (this._94849606costs);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function set costs(_arg_1:Object):void
        {
            var _local_2:Object = this._94849606costs;
            if (_local_2 !== _arg_1)
            {
                this._94849606costs = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "costs", _local_2, _arg_1));
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get senderID():int
        {
            return (this._1247963664senderID);
        }

        [Bindable(event="propertyChange")]
        public function get slotType():int
        {
            return (this._1086538152slotType);
        }

        [Bindable(event="propertyChange")]
        public function get id():int
        {
            return (this._3355id);
        }

        [Bindable(event="propertyChange")]
        public function get offer():Object
        {
            return (this._105650780offer);
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

        public function set senderID(_arg_1:int):void
        {
            var _local_2:Object = this._1247963664senderID;
            if (_local_2 !== _arg_1)
            {
                this._1247963664senderID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "senderID", _local_2, _arg_1));
            };
        }

        public function set slotPos(_arg_1:int):void
        {
            var _local_2:Object = this._2113263754slotPos;
            if (_local_2 !== _arg_1)
            {
                this._2113263754slotPos = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "slotPos", _local_2, _arg_1));
            };
        }

        public function set slotType(_arg_1:int):void
        {
            var _local_2:Object = this._1086538152slotType;
            if (_local_2 !== _arg_1)
            {
                this._1086538152slotType = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "slotType", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get uniqueID():dUniqueID
        {
            return (this._294460244uniqueID);
        }

        public function set id(_arg_1:int):void
        {
            var _local_2:Object = this._3355id;
            if (_local_2 !== _arg_1)
            {
                this._3355id = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", _local_2, _arg_1));
            };
        }

        public function set offer(_arg_1:Object):void
        {
            var _local_2:Object = this._105650780offer;
            if (_local_2 !== _arg_1)
            {
                this._105650780offer = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "offer", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get slotPos():int
        {
            return (this._2113263754slotPos);
        }


    }
}
