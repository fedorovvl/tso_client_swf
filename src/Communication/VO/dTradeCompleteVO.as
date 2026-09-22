package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dTradeCompleteVO implements IEventDispatcher 
    {

        private var _1067372161tradeID:int;
        private var _273490210buyerName:String;
        private var _294460244uniqueID:dUniqueID;
        private var _6241813tradeDeleted:Boolean;
        private var _245525006buyerID:int;
        private var _2124738946offerAcceptedID:int;
        private var _1326787970returnedItem:Object;
        private var _717811500lotsRemaining:int;
        private var _bindingEventDispatcher:EventDispatcher;

        public function dTradeCompleteVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function set offerAcceptedID(_arg_1:int):void
        {
            var _local_2:Object = this._2124738946offerAcceptedID;
            if (_local_2 !== _arg_1)
            {
                this._2124738946offerAcceptedID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "offerAcceptedID", _local_2, _arg_1));
            };
        }

        public function set tradeID(_arg_1:int):void
        {
            var _local_2:Object = this._1067372161tradeID;
            if (_local_2 !== _arg_1)
            {
                this._1067372161tradeID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "tradeID", _local_2, _arg_1));
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get offerAcceptedID():int
        {
            return (this._2124738946offerAcceptedID);
        }

        [Bindable(event="propertyChange")]
        public function get buyerID():int
        {
            return (this._245525006buyerID);
        }

        [Bindable(event="propertyChange")]
        public function get returnedItem():Object
        {
            return (this._1326787970returnedItem);
        }

        public function set returnedItem(_arg_1:Object):void
        {
            var _local_2:Object = this._1326787970returnedItem;
            if (_local_2 !== _arg_1)
            {
                this._1326787970returnedItem = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "returnedItem", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get lotsRemaining():int
        {
            return (this._717811500lotsRemaining);
        }

        [Bindable(event="propertyChange")]
        public function get tradeDeleted():Boolean
        {
            return (this._6241813tradeDeleted);
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

        [Bindable(event="propertyChange")]
        public function get buyerName():String
        {
            return (this._273490210buyerName);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set lotsRemaining(_arg_1:int):void
        {
            var _local_2:Object = this._717811500lotsRemaining;
            if (_local_2 !== _arg_1)
            {
                this._717811500lotsRemaining = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lotsRemaining", _local_2, _arg_1));
            };
        }

        public function set tradeDeleted(_arg_1:Boolean):void
        {
            var _local_2:Object = this._6241813tradeDeleted;
            if (_local_2 !== _arg_1)
            {
                this._6241813tradeDeleted = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "tradeDeleted", _local_2, _arg_1));
            };
        }

        public function set buyerID(_arg_1:int):void
        {
            var _local_2:Object = this._245525006buyerID;
            if (_local_2 !== _arg_1)
            {
                this._245525006buyerID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "buyerID", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get uniqueID():dUniqueID
        {
            return (this._294460244uniqueID);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function set buyerName(_arg_1:String):void
        {
            var _local_2:Object = this._273490210buyerName;
            if (_local_2 !== _arg_1)
            {
                this._273490210buyerName = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "buyerName", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get tradeID():int
        {
            return (this._1067372161tradeID);
        }


    }
}
