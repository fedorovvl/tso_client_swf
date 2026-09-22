package ServerState
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.PropertyChangeEvent;

    public class dResource implements Tradeable, IEventDispatcher 
    {

        public var active:Boolean = true;
        public var group_string:String;
        private var _1413853096amount:int;
        private var _324534341name_string:String;
        private var _bindingEventDispatcher:EventDispatcher;
        public var producedAmount:int;
        public var maxLimit:int;

        public function dResource()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function readExternal(_arg_1:IDataInput):void
        {
            this.name_string = _arg_1.readUTF();
            this.amount = _arg_1.readInt();
            this.maxLimit = _arg_1.readInt();
            this.group_string = _arg_1.readUTF();
        }

        [Bindable(event="propertyChange")]
        public function get name_string():String
        {
            return (this._324534341name_string);
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeUTF(this.name_string);
            _arg_1.writeInt(this.amount);
            _arg_1.writeInt(this.maxLimit);
            _arg_1.writeUTF(this.group_string);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function getName():String
        {
            return (cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.name_string));
        }

        public function getAmount():int
        {
            return (this.amount);
        }

        [Bindable(event="propertyChange")]
        public function get amount():int
        {
            return (this._1413853096amount);
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

        public function clone():dResource
        {
            var _local_1:dResource = new dResource();
            _local_1.amount = this.amount;
            _local_1.name_string = this.name_string;
            _local_1.group_string = this.group_string;
            _local_1.maxLimit = this.maxLimit;
            return (_local_1);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function toString():String
        {
            return (((((((("<Resource '" + this.name_string) + "' amount=") + this.amount) + "' maxLimit=") + this.maxLimit) + "' group_string=") + this.group_string) + " >");
        }

        public function Init(_arg_1:String, _arg_2:int):dResource
        {
            this.name_string = _arg_1;
            this.amount = _arg_2;
            return (this);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
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


    }
}
