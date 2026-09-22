package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.utils.IDataInput;
    import mx.events.PropertyChangeEvent;
    import flash.utils.IDataOutput;
    import flash.events.Event;

    public class dStartSpecialistTaskVO implements IEventDispatcher 
    {

        private var _294460244uniqueID:dUniqueID;
        private var _820971262paramString:String;
        private var _374477888subTaskID:int;
        private var _bindingEventDispatcher:EventDispatcher;

        public function dStartSpecialistTaskVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        [Bindable(event="propertyChange")]
        public function get subTaskID():int
        {
            return (this._374477888subTaskID);
        }

        public function readExternal(_arg_1:IDataInput):void
        {
            this.uniqueID = (_arg_1.readObject() as dUniqueID);
            this.subTaskID = _arg_1.readInt();
            this.paramString = _arg_1.readUTF();
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set subTaskID(_arg_1:int):void
        {
            var _local_2:Object = this._374477888subTaskID;
            if (_local_2 !== _arg_1)
            {
                this._374477888subTaskID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subTaskID", _local_2, _arg_1));
            };
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeObject(this.uniqueID);
            _arg_1.writeInt(this.subTaskID);
            _arg_1.writeUTF(this.paramString);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
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

        public function toString():String
        {
            return (((((("<dStartSpecialistTaskVO uniqueID=" + this.uniqueID) + " subTaskID=") + this.subTaskID) + " paramString=") + this.paramString) + " >");
        }

        [Bindable(event="propertyChange")]
        public function get uniqueID():dUniqueID
        {
            return (this._294460244uniqueID);
        }

        public function set paramString(_arg_1:String):void
        {
            var _local_2:Object = this._820971262paramString;
            if (_local_2 !== _arg_1)
            {
                this._820971262paramString = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "paramString", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get paramString():String
        {
            return (this._820971262paramString);
        }


    }
}
