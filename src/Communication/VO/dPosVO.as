package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import mx.events.PropertyChangeEvent;

    public class dPosVO implements IEventDispatcher 
    {

        private var _120x:Number;
        private var _121y:Number;
        private var _bindingEventDispatcher:EventDispatcher;

        public function dPosVO()
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
            this.x = _arg_1.readDouble();
            this.y = _arg_1.readDouble();
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeDouble(this.x);
            _arg_1.writeDouble(this.y);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function set y(_arg_1:Number):void
        {
            var _local_2:Object = this._121y;
            if (_local_2 !== _arg_1)
            {
                this._121y = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "y", _local_2, _arg_1));
            };
        }

        public function set x(_arg_1:Number):void
        {
            var _local_2:Object = this._120x;
            if (_local_2 !== _arg_1)
            {
                this._120x = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "x", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get x():Number
        {
            return (this._120x);
        }

        [Bindable(event="propertyChange")]
        public function get y():Number
        {
            return (this._121y);
        }


    }
}
