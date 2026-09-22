package GUI.Components.ItemRenderer
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class MailTypeFilterItemRendererData implements IEventDispatcher 
    {

        private var _bindingEventDispatcher:EventDispatcher;
        private var _1191572123selected:Boolean;
        private var _270940796disabled:Boolean;
        private var _330499320mailGroup:int;

        public function MailTypeFilterItemRendererData(_arg_1:Boolean, _arg_2:Boolean, _arg_3:int)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.selected = _arg_1;
            this.disabled = _arg_2;
            this.mailGroup = _arg_3;
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
        public function get mailGroup():int
        {
            return (this._330499320mailGroup);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set mailGroup(_arg_1:int):void
        {
            var _local_2:Object = this._330499320mailGroup;
            if (_local_2 !== _arg_1)
            {
                this._330499320mailGroup = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mailGroup", _local_2, _arg_1));
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

        public function set disabled(_arg_1:Boolean):void
        {
            var _local_2:Object = this._270940796disabled;
            if (_local_2 !== _arg_1)
            {
                this._270940796disabled = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "disabled", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get selected():Boolean
        {
            return (this._1191572123selected);
        }

        [Bindable(event="propertyChange")]
        public function get disabled():Boolean
        {
            return (this._270940796disabled);
        }


    }
}
