package Communication.VO.Guild
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import mx.events.PropertyChangeEvent;
    import GuildSystem.PERMISSIONS;
    import flash.events.Event;

    public class dGuildRankTabPermissionVO implements IEventDispatcher 
    {

        private var _381346684maxBuffs:Number;
        private var _938280377rankID:int;
        private var _888604961maxResources:Number;
        private var _1880183383collapsed:Boolean = true;
        private var _110114672tabID:int;
        private var _517618225permission:int;
        private var _838708374resourcesLimit:int;
        private var _1553802304tabName:String;
        private var _830023249itemsPermission:int;
        private var _3355id:int;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _1363031027minResources:int;
        private var _1415754789itemsLimit:int;
        private var _1417459156resourcesPermission:int;

        public function dGuildRankTabPermissionVO()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function set tabName(_arg_1:String):void
        {
            var _local_2:Object = this._1553802304tabName;
            if (_local_2 !== _arg_1)
            {
                this._1553802304tabName = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "tabName", _local_2, _arg_1));
            };
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function set rankID(_arg_1:int):void
        {
            var _local_2:Object = this._938280377rankID;
            if (_local_2 !== _arg_1)
            {
                this._938280377rankID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "rankID", _local_2, _arg_1));
            };
        }

        public function ItemsPermission():Boolean
        {
            return ((this.itemsPermission >= PERMISSIONS.WRITE) ? true : false);
        }

        [Bindable(event="propertyChange")]
        public function get id():int
        {
            return (this._3355id);
        }

        [Bindable(event="propertyChange")]
        public function get resourcesLimit():int
        {
            return (this._838708374resourcesLimit);
        }

        [Bindable(event="propertyChange")]
        public function get maxResources():Number
        {
            return (this._888604961maxResources);
        }

        public function TabPermission():Boolean
        {
            return ((this.permission >= PERMISSIONS.WRITE) ? true : false);
        }

        public function set resourcesLimit(_arg_1:int):void
        {
            var _local_2:Object = this._838708374resourcesLimit;
            if (_local_2 !== _arg_1)
            {
                this._838708374resourcesLimit = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "resourcesLimit", _local_2, _arg_1));
            };
        }

        public function set permission(_arg_1:int):void
        {
            var _local_2:Object = this._517618225permission;
            if (_local_2 !== _arg_1)
            {
                this._517618225permission = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "permission", _local_2, _arg_1));
            };
        }

        public function set resourcesPermission(_arg_1:int):void
        {
            var _local_2:Object = this._1417459156resourcesPermission;
            if (_local_2 !== _arg_1)
            {
                this._1417459156resourcesPermission = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "resourcesPermission", _local_2, _arg_1));
            };
        }

        public function ResourcesPermission():Boolean
        {
            return ((this.resourcesPermission >= PERMISSIONS.WRITE) ? true : false);
        }

        public function set collapsed(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1880183383collapsed;
            if (_local_2 !== _arg_1)
            {
                this._1880183383collapsed = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "collapsed", _local_2, _arg_1));
            };
        }

        public function set itemsLimit(_arg_1:int):void
        {
            var _local_2:Object = this._1415754789itemsLimit;
            if (_local_2 !== _arg_1)
            {
                this._1415754789itemsLimit = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "itemsLimit", _local_2, _arg_1));
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
        public function get itemsPermission():int
        {
            return (this._830023249itemsPermission);
        }

        public function equals(_arg_1:Object):Boolean
        {
            if (this == _arg_1)
            {
                return (true);
            };
            if (_arg_1 == null)
            {
                return (false);
            };
            if (!(_arg_1 is dGuildRankTabPermissionVO))
            {
                return (false);
            };
            var _local_2:dGuildRankTabPermissionVO = (_arg_1 as dGuildRankTabPermissionVO);
            if (this.id != _local_2.id)
            {
                return (false);
            };
            if (this.itemsLimit != _local_2.itemsLimit)
            {
                return (false);
            };
            if (this.itemsPermission != _local_2.itemsPermission)
            {
                return (false);
            };
            if (this.permission != _local_2.permission)
            {
                return (false);
            };
            if (this.rankID != _local_2.rankID)
            {
                return (false);
            };
            if (this.resourcesLimit != _local_2.resourcesLimit)
            {
                return (false);
            };
            if (this.resourcesPermission != _local_2.resourcesPermission)
            {
                return (false);
            };
            if (this.tabID != _local_2.tabID)
            {
                return (false);
            };
            return (true);
        }

        [Bindable(event="propertyChange")]
        public function get tabName():String
        {
            return (this._1553802304tabName);
        }

        public function set maxResources(_arg_1:Number):void
        {
            var _local_2:Object = this._888604961maxResources;
            if (_local_2 !== _arg_1)
            {
                this._888604961maxResources = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxResources", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get rankID():int
        {
            return (this._938280377rankID);
        }

        [Bindable(event="propertyChange")]
        public function get permission():int
        {
            return (this._517618225permission);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        [Bindable(event="propertyChange")]
        public function get resourcesPermission():int
        {
            return (this._1417459156resourcesPermission);
        }

        [Bindable(event="propertyChange")]
        public function get collapsed():Boolean
        {
            return (this._1880183383collapsed);
        }

        [Bindable(event="propertyChange")]
        public function get itemsLimit():int
        {
            return (this._1415754789itemsLimit);
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function clone():dGuildRankTabPermissionVO
        {
            var _local_1:dGuildRankTabPermissionVO = new dGuildRankTabPermissionVO();
            _local_1.id = this.id;
            _local_1.rankID = this.rankID;
            _local_1.tabID = this.tabID;
            _local_1.permission = this.permission;
            _local_1.resourcesPermission = this.resourcesPermission;
            _local_1.resourcesLimit = this.resourcesLimit;
            _local_1.itemsPermission = this.itemsPermission;
            _local_1.itemsLimit = this.itemsLimit;
            _local_1.tabName = this.tabName;
            _local_1.maxResources = this.maxResources;
            _local_1.maxBuffs = this.maxBuffs;
            _local_1.minResources = this.minResources;
            return (_local_1);
        }

        public function set itemsPermission(_arg_1:int):void
        {
            var _local_2:Object = this._830023249itemsPermission;
            if (_local_2 !== _arg_1)
            {
                this._830023249itemsPermission = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "itemsPermission", _local_2, _arg_1));
            };
        }

        public function set tabID(_arg_1:int):void
        {
            var _local_2:Object = this._110114672tabID;
            if (_local_2 !== _arg_1)
            {
                this._110114672tabID = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "tabID", _local_2, _arg_1));
            };
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function set minResources(_arg_1:int):void
        {
            var _local_2:Object = this._1363031027minResources;
            if (_local_2 !== _arg_1)
            {
                this._1363031027minResources = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "minResources", _local_2, _arg_1));
            };
        }

        [Bindable(event="propertyChange")]
        public function get tabID():int
        {
            return (this._110114672tabID);
        }

        [Bindable(event="propertyChange")]
        public function get minResources():int
        {
            return (this._1363031027minResources);
        }

        public function set maxBuffs(_arg_1:Number):void
        {
            var _local_2:Object = this._381346684maxBuffs;
            if (_local_2 !== _arg_1)
            {
                this._381346684maxBuffs = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxBuffs", _local_2, _arg_1));
            };
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        [Bindable(event="propertyChange")]
        public function get maxBuffs():Number
        {
            return (this._381346684maxBuffs);
        }


    }
}
