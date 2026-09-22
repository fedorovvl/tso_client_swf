package GuildSystem
{
    import ServerState.IResourceContainer;
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.collections.ArrayCollection;
    import ServerState.dResourceDefaultDefinition;
    import ServerState.dResource;
    import ServerState.gEconomics;
    import nLib.gMisc;
    import BuffSystem.cBuff;
    import Communication.VO.dBuffVO;
    import mx.events.PropertyChangeEvent;
    import Communication.VO.dResourceVO;
    import Communication.VO.Guild.dGuildBankTabVO;

    public class cGuildBankTab implements IResourceContainer, IEventDispatcher 
    {

        private var mMap_ResourceName_Resource:Object = new Object();
        private var sortedResource_array:Array = new Array();
        private var _3373707name:String;
        public var maxResource:int;
        public var maxBuff:int;
        public var id:int;
        public var currMaxSizeUpdate:int;
        private var sortedBuffs_array:Array = new Array();
        public var hasAccess:Boolean;
        public var defaultName:String;
        public var isPaymentTab:Boolean;
        private var _bindingEventDispatcher:EventDispatcher;

        public function cGuildBankTab():void
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            this.InitResourcesMap();
        }

        public static function mergeSort(_arg_1:Array, _arg_2:Function):Boolean
        {
            if (_arg_1.length < 2)
            {
                return (false);
            };
            var _local_3:uint = uint(Math.floor((_arg_1.length / 2)));
            var _local_4:uint = (_arg_1.length - _local_3);
            var _local_5:Array = new Array(_local_3);
            var _local_6:Array = new Array(_local_4);
            var _local_7:uint;
            _local_7 = 0;
            while (_local_7 < _local_3)
            {
                _local_5[_local_7] = _arg_1[_local_7];
                _local_7++;
            };
            _local_7 = _local_3;
            while (_local_7 < (_local_3 + _local_4))
            {
                _local_6[(_local_7 - _local_3)] = _arg_1[_local_7];
                _local_7++;
            };
            mergeSort(_local_5, _arg_2);
            mergeSort(_local_6, _arg_2);
            _local_7 = 0;
            var _local_8:uint;
            var _local_9:uint;
            while (((!(_local_5.length == _local_8)) && (!(_local_6.length == _local_9))))
            {
                if (!_arg_2(_local_5[_local_8], _local_6[_local_9]))
                {
                    _arg_1[_local_7] = _local_5[_local_8];
                    _local_7++;
                    _local_8++;
                }
                else
                {
                    _arg_1[_local_7] = _local_6[_local_9];
                    _local_7++;
                    _local_9++;
                };
            };
            while (_local_5.length != _local_8)
            {
                _arg_1[_local_7] = _local_5[_local_8];
                _local_7++;
                _local_8++;
            };
            while (_local_6.length != _local_9)
            {
                _arg_1[_local_7] = _local_6[_local_9];
                _local_7++;
                _local_9++;
            };
            return (true);
        }


        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function GetResourcesVector():ArrayCollection
        {
            var _local_2:*;
            var _local_1:ArrayCollection = new ArrayCollection();
            for each (_local_2 in this.mMap_ResourceName_Resource)
            {
                _local_1.addItem(_local_2);
            };
            return (_local_1);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        private function InitResourcesMap():void
        {
            var resourceDefaultDefinition:dResourceDefaultDefinition;
            var resource:dResource;
            for each (resourceDefaultDefinition in gEconomics.mResourceDefaultDefinition_vector)
            {
                if (this.mMap_ResourceName_Resource[resourceDefaultDefinition.resourceName_string])
                {
                    (this.mMap_ResourceName_Resource[resourceDefaultDefinition.resourceName_string] as dResource).amount = 0;
                }
                else
                {
                    resource = new dResource();
                    resource.name_string = resourceDefaultDefinition.resourceName_string;
                    resource.group_string = resourceDefaultDefinition.group_string;
                    resource.amount = 0;
                    resource.maxLimit = gMisc.GetMaxIntValue();
                    this.mMap_ResourceName_Resource[resource.name_string] = resource;
                    this.sortedResource_array.push(resource);
                };
            };
            mergeSort(this.sortedResource_array, function (_arg_1:dResource, _arg_2:dResource):Boolean
            {
                return (_arg_1.group_string > _arg_2.group_string);
            });
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function AddBuffVOToBankTab(_arg_1:dBuffVO):void
        {
            this.sortedBuffs_array.push(cBuff.CreateBuffFromVO(_arg_1));
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

        public function GetSortedResources():Array
        {
            return (this.sortedResource_array);
        }

        [Bindable(event="propertyChange")]
        public function get name():String
        {
            return (this._3373707name);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function GetPlayerResource(_arg_1:String):dResource
        {
            return (this.GetResource(_arg_1));
        }

        public function HasPlayerResource(_arg_1:String, _arg_2:int):Boolean
        {
            return (this.GetPlayerResource(_arg_1).amount >= _arg_2);
        }

        public function AddBuffToBankTab(_arg_1:cBuff):void
        {
            this.sortedBuffs_array.push(_arg_1);
        }

        public function GetResource(_arg_1:String):dResource
        {
            return (this.mMap_ResourceName_Resource[_arg_1]);
        }

        public function GetSortedBuffs():Array
        {
            return (this.sortedBuffs_array);
        }

        public function Init(_arg_1:dGuildBankTabVO):void
        {
            var _local_2:dResourceVO;
            var _local_3:dBuffVO;
            for each (_local_2 in _arg_1.resources_vector)
            {
                this.mMap_ResourceName_Resource[_local_2.name_string].amount = _local_2.amount;
            };
            this.id = _arg_1.id;
            this.name = _arg_1.name;
            this.maxResource = _arg_1.maxResource;
            this.maxBuff = _arg_1.maxBuff;
            this.currMaxSizeUpdate = _arg_1.currMaxSizeUpdate;
            for each (_local_3 in _arg_1.guildBankBuffs)
            {
                this.AddBuffVOToBankTab(_local_3);
            };
            this.hasAccess = _arg_1.hasAccess;
            this.isPaymentTab = _arg_1.isPaymentTab;
            this.sortedBuffs_array.sortOn(["sortKey", "amount"], [null, (Array.NUMERIC | Array.DESCENDING)]);
        }


    }
}
