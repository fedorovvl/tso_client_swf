package Communication.VO
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.IDataInput;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.PropertyChangeEvent;
    import flash.utils.IDataOutput;

    public class dResourceVO implements Tradeable, IEventDispatcher 
    {

        private var _1649780484producedAmount:int;
        private var _1413853096amount:int;
        private var _324534341name_string:String;
        private var _bindingEventDispatcher:EventDispatcher;

        public function dResourceVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public static function cloneDResourceVO(_arg_1:dResourceVO):dResourceVO
        {
            var _local_2:dResourceVO = new (dResourceVO)();
            _local_2.name_string = _arg_1.name_string;
            _local_2.amount = _arg_1.amount;
            _local_2.producedAmount = _arg_1.producedAmount;
            return (_local_2);
        }


        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function readExternal(_arg_1:IDataInput):void
        {
            this.name_string = _arg_1.readUTF();
            this.amount = _arg_1.readInt();
        }

        [Bindable(event="propertyChange")]
        public function get name_string():String
        {
            return (this._324534341name_string);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function getName():String
        {
            return (cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.name_string));
        }

        public function set name_string(_arg_1:String):void
        {
            var _local_2:Object = this._324534341name_string;
            if (_local_2 !== _arg_1)
            {
                this._324534341name_string = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name_string", _local_2, _arg_1));
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function getAmount():int
        {
            return (this.amount);
        }

        public function init(_arg_1:String, _arg_2:int):dResourceVO
        {
            this.name_string = _arg_1;
            this.amount = _arg_2;
            return (this);
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeUTF(this.name_string);
            _arg_1.writeInt(this.amount);
        }

        [Bindable(event="propertyChange")]
        public function get amount():int
        {
            return (this._1413853096amount);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function toString():String
        {
            return (((("<ResourceVO name='" + this.name_string) + "' amount='") + this.amount) + "' />");
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

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function set producedAmount(_arg_1:int):void
        {
            var _local_2:Object = this._1649780484producedAmount;
            if (_local_2 !== _arg_1)
            {
                this._1649780484producedAmount = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "producedAmount", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get producedAmount():int
        {
            return (this._1649780484producedAmount);
        }


    }
}
