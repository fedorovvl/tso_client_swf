package GUI.Components.ItemRenderer
{
    import flash.events.IEventDispatcher;
    import Specialists.cSpecialist;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;

    public class SpecialistTravelItemData implements IEventDispatcher 
    {

        private var _997953231specialist:cSpecialist;
        private var _307323572useElite:Boolean;
        private var _1250913378usesCombatThree:Boolean;
        private var _1191572123selected:Boolean;
        private var _bindingEventDispatcher:EventDispatcher;

        public function SpecialistTravelItemData(_arg_1:cSpecialist, _arg_2:Boolean, _arg_3:Boolean)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.specialist = _arg_1;
            this.usesCombatThree = _arg_2;
            this.useElite = _arg_3;
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
        public function get selected():Boolean
        {
            return (this._1191572123selected);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get useElite():Boolean
        {
            return (this._307323572useElite);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set useElite(_arg_1:Boolean):void
        {
            var _local_2:Object = this._307323572useElite;
            if (_local_2 !== _arg_1)
            {
                this._307323572useElite = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "useElite", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get usesCombatThree():Boolean
        {
            return (this._1250913378usesCombatThree);
        }

        public function set specialist(_arg_1:cSpecialist):void
        {
            var _local_2:Object = this._997953231specialist;
            if (_local_2 !== _arg_1)
            {
                this._997953231specialist = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "specialist", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get specialist():cSpecialist
        {
            return (this._997953231specialist);
        }

        public function set usesCombatThree(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1250913378usesCombatThree;
            if (_local_2 !== _arg_1)
            {
                this._1250913378usesCombatThree = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "usesCombatThree", _local_2, _arg_1));
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


    }
}
