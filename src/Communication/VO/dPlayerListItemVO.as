package Communication.VO
{
    import flash.events.IEventDispatcher;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import mx.events.PropertyChangeEvent;

    public class dPlayerListItemVO implements IEventDispatcher 
    {

        private var _1159866405onlineStatus:Boolean;
        public var adventureVO:dAdventureClientInfoVO = null;
        public var username:String;
        public var avatarId:int;
        public var id:int;
        public var playerLevel:int;
        private var _bindingEventDispatcher:EventDispatcher;
        public var friendSince:Number;

        public function dPlayerListItemVO()
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
            this.id = _arg_1.readInt();
            this.avatarId = _arg_1.readInt();
            this.username = _arg_1.readUTF();
            this.playerLevel = _arg_1.readInt();
            this.onlineStatus = _arg_1.readBoolean();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.id);
            _arg_1.writeInt(this.avatarId);
            _arg_1.writeUTF(this.username);
            _arg_1.writeInt(this.playerLevel);
            _arg_1.writeBoolean(this.onlineStatus);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set onlineStatus(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1159866405onlineStatus;
            if (_local_2 !== _arg_1)
            {
                this._1159866405onlineStatus = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "onlineStatus", _local_2, _arg_1));
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get onlineStatus():Boolean
        {
            return (this._1159866405onlineStatus);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }


    }
}
