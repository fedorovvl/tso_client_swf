package Communication.VO.TradeWindow
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.utils.IDataInput;
    import mx.events.PropertyChangeEvent;
    import flash.utils.IDataOutput;
    import flash.events.Event;

    public class dTradeObjectVO implements IEventDispatcher 
    {

        private var _105650780offer:String;
        private var _1086538152slotType:int;
        private var _1028554472created:Number;
        private var _3575610type:int;
        private var _1247963664senderID:int;
        private var _1755333922isTradeCancled:Boolean;
        private var _1550463001deleted:Number;
        private var _1518175480coolDownTime:Number;
        private var _717811500lotsRemaining:int;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _3355id:int;
        private var _997385824senderName:String;
        private var _209269578receiverID:int;
        private var _460098019remainingTime:Number = 0;
        private var _2113263754slotPos:int;
        private var _2124738946offerAcceptedID:int;
        private var _1091836000removed:int;

        public function dTradeObjectVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function readExternal(_arg_1:IDataInput):void
        {
            this.id = _arg_1.readInt();
            this.senderID = _arg_1.readInt();
            this.receiverID = _arg_1.readInt();
            this.type = _arg_1.readInt();
            this.slotType = _arg_1.readInt();
            this.slotPos = _arg_1.readInt();
            this.created = _arg_1.readDouble();
            this.remainingTime = _arg_1.readDouble();
            this.offer = _arg_1.readUTF();
            this.lotsRemaining = _arg_1.readInt();
            this.deleted = _arg_1.readDouble();
            this.removed = _arg_1.readInt();
            this.offerAcceptedID = _arg_1.readInt();
            this.senderName = _arg_1.readUTF();
            this.coolDownTime = _arg_1.readDouble();
            this.isTradeCancled = _arg_1.readBoolean();
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set receiverID(_arg_1:int):void
        {
            var _local_2:Object = this._209269578receiverID;
            if (_local_2 !== _arg_1)
            {
                this._209269578receiverID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "receiverID", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get senderID():int
        {
            return (this._1247963664senderID);
        }

        public function set senderID(_arg_1:int):void
        {
            var _local_2:Object = this._1247963664senderID;
            if (_local_2 !== _arg_1)
            {
                this._1247963664senderID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "senderID", _local_2, _arg_1));
            };
        }

        public function set lotsRemaining(_arg_1:int):void
        {
            var _local_2:Object = this._717811500lotsRemaining;
            if (_local_2 !== _arg_1)
            {
                this._717811500lotsRemaining = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lotsRemaining", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get id():int
        {
            return (this._3355id);
        }

        public function set slotType(_arg_1:int):void
        {
            var _local_2:Object = this._1086538152slotType;
            if (_local_2 !== _arg_1)
            {
                this._1086538152slotType = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "slotType", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get deleted():Number
        {
            return (this._1550463001deleted);
        }

        public function set deleted(_arg_1:Number):void
        {
            var _local_2:Object = this._1550463001deleted;
            if (_local_2 !== _arg_1)
            {
                this._1550463001deleted = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "deleted", _local_2, _arg_1));
            };
        }

        public function set offer(_arg_1:String):void
        {
            var _local_2:Object = this._105650780offer;
            if (_local_2 !== _arg_1)
            {
                this._105650780offer = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "offer", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get type():int
        {
            return (this._3575610type);
        }

        public function set isTradeCancled(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1755333922isTradeCancled;
            if (_local_2 !== _arg_1)
            {
                this._1755333922isTradeCancled = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "isTradeCancled", _local_2, _arg_1));
            };
        }

        public function set id(_arg_1:int):void
        {
            var _local_2:Object = this._3355id;
            if (_local_2 !== _arg_1)
            {
                this._3355id = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", _local_2, _arg_1));
            };
        }

        public function set senderName(_arg_1:String):void
        {
            var _local_2:Object = this._997385824senderName;
            if (_local_2 !== _arg_1)
            {
                this._997385824senderName = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "senderName", _local_2, _arg_1));
            };
        }

        public function set remainingTime(_arg_1:Number):void
        {
            var _local_2:Object = this._460098019remainingTime;
            if (_local_2 !== _arg_1)
            {
                this._460098019remainingTime = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "remainingTime", _local_2, _arg_1));
            };
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.id);
            _arg_1.writeInt(this.senderID);
            _arg_1.writeInt(this.receiverID);
            _arg_1.writeInt(this.type);
            _arg_1.writeInt(this.slotType);
            _arg_1.writeInt(this.slotPos);
            _arg_1.writeDouble(this.created);
            _arg_1.writeDouble(this.remainingTime);
            _arg_1.writeUTF(this.offer);
            _arg_1.writeInt(this.lotsRemaining);
            _arg_1.writeDouble(this.deleted);
            _arg_1.writeInt(this.removed);
            _arg_1.writeInt(this.offerAcceptedID);
            _arg_1.writeUTF(this.senderName);
            _arg_1.writeDouble(this.coolDownTime);
            _arg_1.writeBoolean(this.isTradeCancled);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function set created(_arg_1:Number):void
        {
            var _local_2:Object = this._1028554472created;
            if (_local_2 !== _arg_1)
            {
                this._1028554472created = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "created", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get receiverID():int
        {
            return (this._209269578receiverID);
        }

        [Bindable(event="propertyChange")]
        public function get lotsRemaining():int
        {
            return (this._717811500lotsRemaining);
        }

        [Bindable(event="propertyChange")]
        public function get slotType():int
        {
            return (this._1086538152slotType);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get offer():String
        {
            return (this._105650780offer);
        }

        [Bindable(event="propertyChange")]
        public function get isTradeCancled():Boolean
        {
            return (this._1755333922isTradeCancled);
        }

        [Bindable(event="propertyChange")]
        public function get senderName():String
        {
            return (this._997385824senderName);
        }

        public function set removed(_arg_1:int):void
        {
            var _local_2:Object = this._1091836000removed;
            if (_local_2 !== _arg_1)
            {
                this._1091836000removed = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "removed", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get remainingTime():Number
        {
            return (this._460098019remainingTime);
        }

        [Bindable(event="propertyChange")]
        public function get removed():int
        {
            return (this._1091836000removed);
        }

        [Bindable(event="propertyChange")]
        public function get created():Number
        {
            return (this._1028554472created);
        }

        public function set slotPos(_arg_1:int):void
        {
            var _local_2:Object = this._2113263754slotPos;
            if (_local_2 !== _arg_1)
            {
                this._2113263754slotPos = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "slotPos", _local_2, _arg_1));
            };
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function set coolDownTime(_arg_1:Number):void
        {
            var _local_2:Object = this._1518175480coolDownTime;
            if (_local_2 !== _arg_1)
            {
                this._1518175480coolDownTime = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "coolDownTime", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get slotPos():int
        {
            return (this._2113263754slotPos);
        }

        [Bindable(event="propertyChange")]
        public function get coolDownTime():Number
        {
            return (this._1518175480coolDownTime);
        }

        public function set type(_arg_1:int):void
        {
            var _local_2:Object = this._3575610type;
            if (_local_2 !== _arg_1)
            {
                this._3575610type = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", _local_2, _arg_1));
            };
        }

        public function set offerAcceptedID(_arg_1:int):void
        {
            var _local_2:Object = this._2124738946offerAcceptedID;
            if (_local_2 !== _arg_1)
            {
                this._2124738946offerAcceptedID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "offerAcceptedID", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get offerAcceptedID():int
        {
            return (this._2124738946offerAcceptedID);
        }


    }
}
