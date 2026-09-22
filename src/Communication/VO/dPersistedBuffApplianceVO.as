package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import ServerOnly.DirtyIndicator;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dPersistedBuffApplianceVO extends dBuffApplianceVO implements IEventDispatcher 
    {

        private var _bindingEventDispatcher:EventDispatcher;
        private var _1227528611dirtyIndicator:DirtyIndicator = new DirtyIndicator();

        public function dPersistedBuffApplianceVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.dirtyIndicator.created();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function set dirtyIndicator(_arg_1:DirtyIndicator):void
        {
            var _local_2:Object = this._1227528611dirtyIndicator;
            if (_local_2 !== _arg_1)
            {
                this._1227528611dirtyIndicator = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dirtyIndicator", _local_2, _arg_1));
            };
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get dirtyIndicator():DirtyIndicator
        {
            return (this._1227528611dirtyIndicator);
        }

        public function copyFromBuffApplicance(_arg_1:dBuffApplianceVO):void
        {
            this.uniqueId = _arg_1.uniqueId;
            this.applianceMode = _arg_1.applianceMode;
            this.buffID = _arg_1.buffID;
            this.nextTickTime = _arg_1.nextTickTime;
            this.resourceName_string = _arg_1.resourceName_string;
            this.sourceZoneId = _arg_1.sourceZoneId;
            this.startTime = _arg_1.startTime;
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }


    }
}
