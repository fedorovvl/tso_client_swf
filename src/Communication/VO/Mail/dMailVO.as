package Communication.VO.Mail
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import mx.collections.ArrayCollection;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;
    import Enums.MAIL_TYPE;

    public class dMailVO implements IEventDispatcher 
    {

        private var _1867885268subject:String;
        private var _3575610type:int;
        private var _1247963696senderId:int;
        private var _668327396expirationTime:Number;
        private var _738997328attachments:Object;
        private var _3355id:int;
        private var _997385824senderName:String;
        private var _3496342read:Boolean;
        private var _3029410body:String;
        private var _bindingEventDispatcher:EventDispatcher;
        [Transient]
        private var _1191572123selected:Boolean;
        private var _265443074recipientIds_collection:ArrayCollection;
        private var _1297018337reciepientId:int;
        private var _770356270recipientNames_collection:ArrayCollection;
        private var _358705620deletedAt:int;
        private var _55126294timestamp:Number;

        public function dMailVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get recipientIds_collection():ArrayCollection
        {
            return (this._265443074recipientIds_collection);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get read():Boolean
        {
            return (this._3496342read);
        }

        public function isExpired():Boolean
        {
            return ((this.expirationTime > 0) && (this.expirationTime <= (24 * 60000)));
        }

        [Bindable(event="propertyChange")]
        public function get expirationTime():Number
        {
            return (this._668327396expirationTime);
        }

        [Bindable(event="propertyChange")]
        public function get timestamp():Number
        {
            return (this._55126294timestamp);
        }

        [Bindable(event="propertyChange")]
        public function get body():String
        {
            return (this._3029410body);
        }

        [Bindable(event="propertyChange")]
        public function get id():int
        {
            return (this._3355id);
        }

        [Bindable(event="propertyChange")]
        public function get subject():String
        {
            return (this._1867885268subject);
        }

        [Bindable(event="propertyChange")]
        public function get recipientNames_collection():ArrayCollection
        {
            return (this._770356270recipientNames_collection);
        }

        [Bindable(event="propertyChange")]
        public function get attachments():Object
        {
            return (this._738997328attachments);
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

        public function set id(_arg_1:int):void
        {
            var _local_2:Object = this._3355id;
            if (_local_2 !== _arg_1)
            {
                this._3355id = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get senderId():int
        {
            return (this._1247963696senderId);
        }

        public function set expirationTime(_arg_1:Number):void
        {
            var _local_2:Object = this._668327396expirationTime;
            if (_local_2 !== _arg_1)
            {
                this._668327396expirationTime = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "expirationTime", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get type():int
        {
            return (this._3575610type);
        }

        public function set timestamp(_arg_1:Number):void
        {
            var _local_2:Object = this._55126294timestamp;
            if (_local_2 !== _arg_1)
            {
                this._55126294timestamp = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "timestamp", _local_2, _arg_1));
            };
        }

        [Transient]
        [Bindable(event="propertyChange")]
        public function get selected():Boolean
        {
            return (this._1191572123selected);
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

        public function set body(_arg_1:String):void
        {
            var _local_2:Object = this._3029410body;
            if (_local_2 !== _arg_1)
            {
                this._3029410body = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "body", _local_2, _arg_1));
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

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function set reciepientId(_arg_1:int):void
        {
            var _local_2:Object = this._1297018337reciepientId;
            if (_local_2 !== _arg_1)
            {
                this._1297018337reciepientId = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "reciepientId", _local_2, _arg_1));
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        [Bindable(event="propertyChange")]
        public function get deletedAt():int
        {
            return (this._358705620deletedAt);
        }

        public function isActive():Boolean
        {
            return ((this.deletedAt == 0) && (this.expirationTime >= 0));
        }

        public function get isDeletable():Boolean
        {
            return (MAIL_TYPE.isDeletable(this.type));
        }

        public function set subject(_arg_1:String):void
        {
            var _local_2:Object = this._1867885268subject;
            if (_local_2 !== _arg_1)
            {
                this._1867885268subject = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subject", _local_2, _arg_1));
            };
        }

        public function set recipientNames_collection(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._770356270recipientNames_collection;
            if (_local_2 !== _arg_1)
            {
                this._770356270recipientNames_collection = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "recipientNames_collection", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get senderName():String
        {
            return (this._997385824senderName);
        }

        [Bindable(event="propertyChange")]
        public function get reciepientId():int
        {
            return (this._1297018337reciepientId);
        }

        public function set attachments(_arg_1:Object):void
        {
            var _local_2:Object = this._738997328attachments;
            if (_local_2 !== _arg_1)
            {
                this._738997328attachments = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "attachments", _local_2, _arg_1));
            };
        }

        public function toString():String
        {
            var _local_1:* = "<dMailVO ";
            _local_1 = (_local_1 + (("id='" + this.id) + "' "));
            _local_1 = (_local_1 + (("type='" + this.type) + "' "));
            _local_1 = (_local_1 + (("read='" + this.read) + "' "));
            _local_1 = (_local_1 + (("timestamp='" + this.timestamp) + "' "));
            _local_1 = (_local_1 + (("subject='" + this.subject) + "' "));
            _local_1 = (_local_1 + (("body='" + this.body) + "' "));
            _local_1 = (_local_1 + (("attachments='" + this.attachments) + "' "));
            _local_1 = (_local_1 + (("senderName='" + this.senderName) + "' "));
            _local_1 = (_local_1 + (("senderId='" + this.senderId) + "' "));
            _local_1 = (_local_1 + (("reciepientId='" + this.reciepientId) + "' "));
            _local_1 = (_local_1 + (("deletedAt='" + this.deletedAt) + "' "));
            _local_1 = (_local_1 + (("recipientIds_collection='" + this.recipientIds_collection) + "' "));
            return (_local_1 + " />\n");
        }

        public function set senderId(_arg_1:int):void
        {
            var _local_2:Object = this._1247963696senderId;
            if (_local_2 !== _arg_1)
            {
                this._1247963696senderId = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "senderId", _local_2, _arg_1));
            };
        }

        public function set deletedAt(_arg_1:int):void
        {
            var _local_2:Object = this._358705620deletedAt;
            if (_local_2 !== _arg_1)
            {
                this._358705620deletedAt = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "deletedAt", _local_2, _arg_1));
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
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

        public function set recipientIds_collection(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._265443074recipientIds_collection;
            if (_local_2 !== _arg_1)
            {
                this._265443074recipientIds_collection = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "recipientIds_collection", _local_2, _arg_1));
            };
        }


    }
}
