package GUI.Components.data
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import GO.cBuilding;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dSelectableDataObject implements IEventDispatcher 
    {

        private var _bindingEventDispatcher:EventDispatcher;
        private var _1191572123selected:Boolean;
        private var _1430646092building:cBuilding;
        private var _3076010data:Object;

        public function dSelectableDataObject(_arg_1:Boolean, _arg_2:Object, _arg_3:cBuilding)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.selected = _arg_1;
            this.data = _arg_2;
            this.building = _arg_3;
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

        [Bindable(event="propertyChange")]
        public function get data():Object
        {
            return (this._3076010data);
        }

        [Bindable(event="propertyChange")]
        public function get building():cBuilding
        {
            return (this._1430646092building);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
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

        public function set selected(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1191572123selected;
            if (_local_2 !== _arg_1)
            {
                this._1191572123selected = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", _local_2, _arg_1));
            };
        }

        public function set building(_arg_1:cBuilding):void
        {
            var _local_2:Object = this._1430646092building;
            if (_local_2 !== _arg_1)
            {
                this._1430646092building = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "building", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get selected():Boolean
        {
            return (this._1191572123selected);
        }


    }
}
