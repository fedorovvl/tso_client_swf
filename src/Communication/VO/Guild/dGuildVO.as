package Communication.VO.Guild
{
    import flash.events.IEventDispatcher;
    import mx.collections.ArrayCollection;
    import flash.events.EventDispatcher;
    import mx.events.PropertyChangeEvent;
    import flash.events.Event;

    public class dGuildVO implements IEventDispatcher 
    {

        private var _3357586motd:String;
        private var _1106754295leader:dGuildPlayerListItemVO;
        private var _1855820473bannerID:int;
        private var _1491115587leaderChangeReason:int;
        private var _3373707name:String;
        private var _2085016493currentSuccessor:int;
        private var _107332log:ArrayCollection;
        private var _796894272hasAppliedToGuildInTheLast24Hours:Boolean;
        private var _760689403playerTabsPermissions:ArrayCollection;
        private var _3530753size:int;
        private var _3355id:int;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _844081029maxSize:int;
        private var _1872501475playerPermissions:dGuildPlayerPermissionVO;
        private var _209571183foundTime:Number;
        private var _114586tag:String;
        private var _1724546052description:String;
        private var _1848867633guildBank:dGuildBankVO;
        private var _108280263ranks:ArrayCollection;
        private var _948881689members:ArrayCollection;
        private var _180022196cacheTimestamp:Number;

        public function dGuildVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function set hasAppliedToGuildInTheLast24Hours(_arg_1:Boolean):void
        {
            var _local_2:Object = this._796894272hasAppliedToGuildInTheLast24Hours;
            if (_local_2 !== _arg_1)
            {
                this._796894272hasAppliedToGuildInTheLast24Hours = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "hasAppliedToGuildInTheLast24Hours", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get size():int
        {
            return (this._3530753size);
        }

        public function set size(_arg_1:int):void
        {
            var _local_2:Object = this._3530753size;
            if (_local_2 !== _arg_1)
            {
                this._3530753size = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "size", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get description():String
        {
            return (this._1724546052description);
        }

        [Bindable(event="propertyChange")]
        public function get maxSize():int
        {
            return (this._844081029maxSize);
        }

        [Bindable(event="propertyChange")]
        public function get leader():dGuildPlayerListItemVO
        {
            return (this._1106754295leader);
        }

        public function set maxSize(_arg_1:int):void
        {
            var _local_2:Object = this._844081029maxSize;
            if (_local_2 !== _arg_1)
            {
                this._844081029maxSize = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxSize", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get name():String
        {
            return (this._3373707name);
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set log(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._107332log;
            if (_local_2 !== _arg_1)
            {
                this._107332log = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "log", _local_2, _arg_1));
            };
        }

        public function set playerTabsPermissions(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._760689403playerTabsPermissions;
            if (_local_2 !== _arg_1)
            {
                this._760689403playerTabsPermissions = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "playerTabsPermissions", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get motd():String
        {
            return (this._3357586motd);
        }

        public function set bannerID(_arg_1:int):void
        {
            var _local_2:Object = this._1855820473bannerID;
            if (_local_2 !== _arg_1)
            {
                this._1855820473bannerID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "bannerID", _local_2, _arg_1));
            };
        }

        public function set leader(_arg_1:dGuildPlayerListItemVO):void
        {
            var _local_2:Object = this._1106754295leader;
            if (_local_2 !== _arg_1)
            {
                this._1106754295leader = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "leader", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get tag():String
        {
            return (this._114586tag);
        }

        [Bindable(event="propertyChange")]
        public function get id():int
        {
            return (this._3355id);
        }

        public function set guildBank(_arg_1:dGuildBankVO):void
        {
            var _local_2:Object = this._1848867633guildBank;
            if (_local_2 !== _arg_1)
            {
                this._1848867633guildBank = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "guildBank", _local_2, _arg_1));
            };
        }

        public function set motd(_arg_1:String):void
        {
            var _local_2:Object = this._3357586motd;
            if (_local_2 !== _arg_1)
            {
                this._3357586motd = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "motd", _local_2, _arg_1));
            };
        }

        public function set name(_arg_1:String):void
        {
            var _local_2:Object = this._3373707name;
            if (_local_2 !== _arg_1)
            {
                this._3373707name = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", _local_2, _arg_1));
            };
        }

        public function set ranks(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._108280263ranks;
            if (_local_2 !== _arg_1)
            {
                this._108280263ranks = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "ranks", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get playerTabsPermissions():ArrayCollection
        {
            return (this._760689403playerTabsPermissions);
        }

        [Bindable(event="propertyChange")]
        public function get members():ArrayCollection
        {
            return (this._948881689members);
        }

        [Bindable(event="propertyChange")]
        public function get currentSuccessor():int
        {
            return (this._2085016493currentSuccessor);
        }

        public function set members(_arg_1:ArrayCollection):void
        {
            var _local_2:Object = this._948881689members;
            if (_local_2 !== _arg_1)
            {
                this._948881689members = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "members", _local_2, _arg_1));
            };
        }

        public function set tag(_arg_1:String):void
        {
            var _local_2:Object = this._114586tag;
            if (_local_2 !== _arg_1)
            {
                this._114586tag = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "tag", _local_2, _arg_1));
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
        public function get leaderChangeReason():int
        {
            return (this._1491115587leaderChangeReason);
        }

        [Bindable(event="propertyChange")]
        public function get cacheTimestamp():Number
        {
            return (this._180022196cacheTimestamp);
        }

        [Bindable(event="propertyChange")]
        public function get log():ArrayCollection
        {
            return (this._107332log);
        }

        [Bindable(event="propertyChange")]
        public function get bannerID():int
        {
            return (this._1855820473bannerID);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function set playerPermissions(_arg_1:dGuildPlayerPermissionVO):void
        {
            var _local_2:Object = this._1872501475playerPermissions;
            if (_local_2 !== _arg_1)
            {
                this._1872501475playerPermissions = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "playerPermissions", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get ranks():ArrayCollection
        {
            return (this._108280263ranks);
        }

        [Bindable(event="propertyChange")]
        public function get guildBank():dGuildBankVO
        {
            return (this._1848867633guildBank);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        [Bindable(event="propertyChange")]
        public function get hasAppliedToGuildInTheLast24Hours():Boolean
        {
            return (this._796894272hasAppliedToGuildInTheLast24Hours);
        }

        public function set currentSuccessor(_arg_1:int):void
        {
            var _local_2:Object = this._2085016493currentSuccessor;
            if (_local_2 !== _arg_1)
            {
                this._2085016493currentSuccessor = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "currentSuccessor", _local_2, _arg_1));
            };
        }

        public function set foundTime(_arg_1:Number):void
        {
            var _local_2:Object = this._209571183foundTime;
            if (_local_2 !== _arg_1)
            {
                this._209571183foundTime = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "foundTime", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get playerPermissions():dGuildPlayerPermissionVO
        {
            return (this._1872501475playerPermissions);
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get foundTime():Number
        {
            return (this._209571183foundTime);
        }

        public function set cacheTimestamp(_arg_1:Number):void
        {
            var _local_2:Object = this._180022196cacheTimestamp;
            if (_local_2 !== _arg_1)
            {
                this._180022196cacheTimestamp = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cacheTimestamp", _local_2, _arg_1));
            };
        }

        public function set description(_arg_1:String):void
        {
            var _local_2:Object = this._1724546052description;
            if (_local_2 !== _arg_1)
            {
                this._1724546052description = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "description", _local_2, _arg_1));
            };
        }

        public function set leaderChangeReason(_arg_1:int):void
        {
            var _local_2:Object = this._1491115587leaderChangeReason;
            if (_local_2 !== _arg_1)
            {
                this._1491115587leaderChangeReason = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "leaderChangeReason", _local_2, _arg_1));
            };
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }


    }
}
