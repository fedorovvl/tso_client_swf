package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.IDataInput;
    import mx.events.PropertyChangeEvent;
    import flash.utils.IDataOutput;

    public class dSpecialistResultVO implements IEventDispatcher 
    {

        private var _bindingEventDispatcher:EventDispatcher;
        private var _3575610type:int;
        private var _886715680withCosts:Boolean;
        private var _294460244uniqueID:dUniqueID;

        public function dSpecialistResultVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function readExternal(_arg_1:IDataInput):void
        {
            this.type = _arg_1.readInt();
            this.uniqueID = (_arg_1.readObject() as dUniqueID);
            this.withCosts = _arg_1.readBoolean();
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

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set withCosts(_arg_1:Boolean):void
        {
            var _local_2:Object = this._886715680withCosts;
            if (_local_2 !== _arg_1)
            {
                this._886715680withCosts = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "withCosts", _local_2, _arg_1));
            };
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.type);
            _arg_1.writeObject(this.uniqueID);
            _arg_1.writeBoolean(this.withCosts);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
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
        public function get withCosts():Boolean
        {
            return (this._886715680withCosts);
        }

        [Bindable(event="propertyChange")]
        public function get uniqueID():dUniqueID
        {
            return (this._294460244uniqueID);
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
