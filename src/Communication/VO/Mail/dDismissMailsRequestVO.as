package Communication.VO.Mail
{
    import flash.events.IEventDispatcher;
    import mx.collections.ArrayCollection;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dDismissMailsRequestVO implements IEventDispatcher 
    {

        private var _94742588claim:Boolean;
        private var _1165609183mailsIDs_collection:ArrayCollection;
        private var _bindingEventDispatcher:EventDispatcher;

        public function dDismissMailsRequestVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get mailsIDs_collection():ArrayCollection
        {
            return (this._1165609183mailsIDs_collection);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set mailsIDs_collection(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._1165609183mailsIDs_collection;
            if (_local_2 !== _arg_1)
            {
                this._1165609183mailsIDs_collection = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mailsIDs_collection", _local_2, _arg_1));
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set claim(_arg_1:Boolean):void
        {
            var _local_2:Object = this._94742588claim;
            if (_local_2 !== _arg_1)
            {
                this._94742588claim = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "claim", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get claim():Boolean
        {
            return (this._94742588claim);
        }


    }
}
