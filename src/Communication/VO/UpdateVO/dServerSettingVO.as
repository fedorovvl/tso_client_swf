package Communication.VO.UpdateVO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;

    public class dServerSettingVO implements IEventDispatcher 
    {

        private var _3575610type:uint;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _111972721value:String;

        public function dServerSettingVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public static function create(_arg_1:uint, _arg_2:String):dServerSettingVO
        {
            var _local_3:dServerSettingVO = new (dServerSettingVO)();
            _local_3.type = _arg_1;
            _local_3.value = _arg_2;
            return (_local_3);
        }


        [Bindable(event="propertyChange")]
        public function get type():uint
        {
            return (this._3575610type);
        }

        public function set value(_arg_1:String):void
        {
            var _local_2:Object = this._111972721value;
            if (_local_2 !== _arg_1)
            {
                this._111972721value = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "value", _local_2, _arg_1));
            };
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
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
        public function get value():String
        {
            return (this._111972721value);
        }

        public function set type(_arg_1:uint):void
        {
            var _local_2:Object = this._3575610type;
            if (_local_2 !== _arg_1)
            {
                this._3575610type = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", _local_2, _arg_1));
            };
        }


    }
}
