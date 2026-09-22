package Communication.VO.UpdateVO
{
    import flash.events.IEventDispatcher;
    import mx.collections.ArrayCollection;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dEnabledResourceDonationsVO implements IEventDispatcher 
    {

        private var _1983070683resources:Object;
        private var _989452712phases:ArrayCollection = new ArrayCollection();
        private var _bindingEventDispatcher:EventDispatcher;

        public function dEnabledResourceDonationsVO()
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
        public function get resources():Object
        {
            return (this._1983070683resources);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set resources(_arg_1:Object):void
        {
            var _local_2:Object = this._1983070683resources;
            if (_local_2 !== _arg_1)
            {
                this._1983070683resources = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "resources", _local_2, _arg_1));
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set phases(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._989452712phases;
            if (_local_2 !== _arg_1)
            {
                this._989452712phases = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "phases", _local_2, _arg_1));
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get phases():ArrayCollection
        {
            return (this._989452712phases);
        }


    }
}
