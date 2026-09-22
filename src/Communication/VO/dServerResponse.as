package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;
    import Enums.COMMAND;

    public class dServerResponse implements IEventDispatcher 
    {

        private var _3575610type:int;
        private var _696323641zoneID:int;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _3076010data:Object;

        public function dServerResponse()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get zoneID():int
        {
            return (this._696323641zoneID);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
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

        public function set data(_arg_1:Object):void
        {
            var _local_2:Object = this._3076010data;
            if (_local_2 !== _arg_1)
            {
                this._3076010data = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "data", _local_2, _arg_1));
            };
        }

        public function set type(_arg_1:int):void
        {
            var _local_2:Object = this._3575610type;
            if (_local_2 !== _arg_1)
            {
                this._3575610type = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", _local_2, _arg_1));
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        [Bindable(event="propertyChange")]
        public function get data():Object
        {
            return (this._3076010data);
        }

        public function toString():String
        {
            return (((("<ServerResponse type=" + COMMAND.GetString(this.type)) + " zone=") + this.zoneID) + ">");
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get type():int
        {
            return (this._3575610type);
        }


    }
}
