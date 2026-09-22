package GUI.Components.ItemRenderer
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;

    public class InfoBarResourceItemRendererData implements IEventDispatcher 
    {

        private var _3175821glow:Boolean = false;
        private var _102976443limit:int = -1;
        private var _466743410visible:Boolean = true;
        private var _3226745icon:Object;
        private var _1413853096amount:int;
        private var _1140107293toolTip:String;
        private var _bindingEventDispatcher:EventDispatcher;

        public function InfoBarResourceItemRendererData()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        [Bindable(event="propertyChange")]
        public function get limit():int
        {
            return (this._102976443limit);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function set toolTip(_arg_1:String):void
        {
            var _local_2:Object = this._1140107293toolTip;
            if (_local_2 !== _arg_1)
            {
                this._1140107293toolTip = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toolTip", _local_2, _arg_1));
            };
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get icon():Object
        {
            return (this._3226745icon);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get glow():Boolean
        {
            return (this._3175821glow);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set glow(_arg_1:Boolean):void
        {
            var _local_2:Object = this._3175821glow;
            if (_local_2 !== _arg_1)
            {
                this._3175821glow = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "glow", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get amount():int
        {
            return (this._1413853096amount);
        }

        [Bindable(event="propertyChange")]
        public function get toolTip():String
        {
            return (this._1140107293toolTip);
        }

        public function set visible(_arg_1:Boolean):void
        {
            var _local_2:Object = this._466743410visible;
            if (_local_2 !== _arg_1)
            {
                this._466743410visible = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "visible", _local_2, _arg_1));
            };
        }

        public function set amount(_arg_1:int):void
        {
            var _local_2:Object = this._1413853096amount;
            if (_local_2 !== _arg_1)
            {
                this._1413853096amount = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "amount", _local_2, _arg_1));
            };
        }

        public function set icon(_arg_1:Object):void
        {
            var _local_2:Object = this._3226745icon;
            if (_local_2 !== _arg_1)
            {
                this._3226745icon = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "icon", _local_2, _arg_1));
            };
        }

        public function set limit(_arg_1:int):void
        {
            var _local_2:Object = this._102976443limit;
            if (_local_2 !== _arg_1)
            {
                this._102976443limit = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "limit", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get visible():Boolean
        {
            return (this._466743410visible);
        }


    }
}
