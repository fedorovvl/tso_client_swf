package GUI.Components.circularmenu
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class BattleDamageDisplayData implements IEventDispatcher 
    {

        private var _113913253hasBonus:Boolean;
        private var _1413853096amount:int;
        private var _bindingEventDispatcher:EventDispatcher;

        public function BattleDamageDisplayData(_arg_1:int, _arg_2:Boolean)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.amount = _arg_1;
            this.hasBonus = _arg_2;
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
        public function get hasBonus():Boolean
        {
            return (this._113913253hasBonus);
        }

        public function set hasBonus(_arg_1:Boolean):void
        {
            var _local_2:Object = this._113913253hasBonus;
            if (_local_2 !== _arg_1)
            {
                this._113913253hasBonus = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasBonus", _local_2, _arg_1));
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
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

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get amount():int
        {
            return (this._1413853096amount);
        }


    }
}
