package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dPickupItemVO implements IEventDispatcher 
    {

        private var _419059509providerType:uint;
        private var _696323641zoneID:int;
        private var _382085443item_string:String = "";
        private var _1413853096amount:int;
        private var _bindingEventDispatcher:EventDispatcher;

        public function dPickupItemVO()
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

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get providerType():uint
        {
            return (this._419059509providerType);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        [Bindable(event="propertyChange")]
        public function get zoneID():int
        {
            return (this._696323641zoneID);
        }

        public function getAmount():int
        {
            return (this.amount);
        }

        public function set providerType(_arg_1:uint):void
        {
            var _local_2:Object = this._419059509providerType;
            if (_local_2 !== _arg_1)
            {
                this._419059509providerType = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "providerType", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get amount():int
        {
            return (this._1413853096amount);
        }

        public function set zoneID(_arg_1:int):void
        {
            var _local_2:Object = this._696323641zoneID;
            if (_local_2 !== _arg_1)
            {
                this._696323641zoneID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "zoneID", _local_2, _arg_1));
            };
        }

        public function setAmount(_arg_1:int):void
        {
            if (_arg_1 < 0)
            {
                this.amount = 0;
            }
            else
            {
                this.amount = _arg_1;
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

        public function set item_string(_arg_1:String):void
        {
            var _local_2:Object = this._382085443item_string;
            if (_local_2 !== _arg_1)
            {
                this._382085443item_string = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "item_string", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get item_string():String
        {
            return (this._382085443item_string);
        }


    }
}
