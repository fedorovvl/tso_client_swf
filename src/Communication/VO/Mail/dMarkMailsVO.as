package Communication.VO.Mail
{
    import flash.events.IEventDispatcher;
    import mx.collections.ArrayCollection;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class dMarkMailsVO implements IEventDispatcher 
    {

        private var _3496342read:Boolean;
        private var _1859284964mailIds_collection:ArrayCollection;
        private var _bindingEventDispatcher:EventDispatcher;

        public function dMarkMailsVO()
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

        public function set read(_arg_1:Boolean):void
        {
            var _local_2:Object = this._3496342read;
            if (_local_2 !== _arg_1)
            {
                this._3496342read = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "read", _local_2, _arg_1));
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function toString():String
        {
            var _local_1:* = "<dMailVO ";
            _local_1 = (_local_1 + (("read='" + this.read) + "' "));
            _local_1 = (_local_1 + (("mailIds_collection='" + this.mailIds_collection) + "' "));
            return (_local_1 + " />\n");
        }

        [Bindable(event="propertyChange")]
        public function get read():Boolean
        {
            return (this._3496342read);
        }

        public function set mailIds_collection(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._1859284964mailIds_collection;
            if (_local_2 !== _arg_1)
            {
                this._1859284964mailIds_collection = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mailIds_collection", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get mailIds_collection():ArrayCollection
        {
            return (this._1859284964mailIds_collection);
        }


    }
}
