package ItemRegistry
{
    import Model.Notifier;
    import Interface.cGeneralInterface;
    import Utils.HashMapWrapper;
    import Communication.VO.dPersistedItemRegistryVO;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;
    import ShopSystem.cItemContent;
    import ShopSystem.cShopItem;

    public class ItemRegistry extends Notifier 
    {

        public static const ITEM_REGISTERED_string:String = "ItemRegistered";

        private var gi:cGeneralInterface;
        public var mRegistry:HashMapWrapper;

        public function ItemRegistry(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
            this.mRegistry = new HashMapWrapper();
        }

        public function GetItemsForPersistence():Array
        {
            return (this.mRegistry.valueSet());
        }

        public function IsLimitedItem(_arg_1:int, _arg_2:String, _arg_3:String):Boolean
        {
            var _local_4:IRItem;
            for each (_local_4 in global.itemLimits)
            {
                if (((((_local_4.itemType == _arg_1) && (_local_4.itemName_string == _arg_2)) && (_local_4.resourceName_string == _arg_3)) && ((_local_4.requiresEvent_string.length < 1) || (global.ui.mEventManager.isEventStarted(_local_4.requiresEvent_string)))))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function RegisterAllItems(_arg_1:ArrayCollection):void
        {
            var _local_2:dPersistedItemRegistryVO;
            var _local_3:dPersistedItemRegistryVO;
            this.mRegistry.clear();
            for each (_local_2 in _arg_1)
            {
                this.RegisterItem(_local_2.itemType, _local_2.itemName_string, _local_2.resource_name_string, _local_2.amount);
            };
            for each (_local_3 in this.mRegistry.valueSet())
            {
                _local_3.dirtyIndicator.clean();
            };
        }

        public function GetRegisteredAmount(_arg_1:int, _arg_2:String, _arg_3:String):int
        {
            var _local_4:String = ((((_arg_1.toString() + "_") + _arg_2) + "_") + _arg_3);
            var _local_5:dPersistedItemRegistryVO = (this.mRegistry.getItem(_local_4) as dPersistedItemRegistryVO);
            if (_local_5 != null)
            {
                return (_local_5.amount);
            };
            return (0);
        }

        private function MakeKey(_arg_1:int, _arg_2:String, _arg_3:String):String
        {
            return ((((_arg_1.toString() + "_") + _arg_2) + "_") + _arg_3);
        }

        public function RegisterItem(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int):int
        {
            var _local_7:int;
            var _local_8:dPersistedItemRegistryVO;
            var _local_9:dPersistedItemRegistryVO;
            var _local_5:String = this.MakeKey(_arg_1, _arg_2, _arg_3);
            var _local_6:int;
            if (this.mRegistry.hasKey(_local_5))
            {
                _local_7 = this.GetRegisteredAmountByKey(_local_5);
                _local_6 = (_local_7 + _arg_4);
                _local_8 = (this.mRegistry.getItem(_local_5) as dPersistedItemRegistryVO);
                _local_8.amount = _local_6;
                _local_8.dirtyIndicator.strongModified();
                this.mRegistry.putItem(_local_5, _local_8);
            }
            else
            {
                _local_9 = new dPersistedItemRegistryVO();
                _local_9.itemType = _arg_1;
                _local_9.itemName_string = _arg_2;
                _local_9.resource_name_string = _arg_3;
                _local_9.amount = _arg_4;
                _local_9.dirtyIndicator.created();
                this.mRegistry.putItem(_local_5, _local_9);
                _local_6 = _arg_4;
            };
            return (_local_6);
        }

        public function GetRemainingAmount(_arg_1:int, _arg_2:String, _arg_3:String):int
        {
            var _local_6:IRItem;
            var _local_4:int;
            var _local_5:Vector.<IRItem> = global.itemLimits;
            for each (_local_6 in global.itemLimits)
            {
                if (((((_local_6.itemType == _arg_1) && (_local_6.itemName_string == _arg_2)) && (_local_6.resourceName_string == _arg_3)) && ((_local_6.requiresEvent_string.length < 1) || (this.gi.mEventManager.isEventStarted(_local_6.requiresEvent_string)))))
                {
                    _local_4 = (_local_4 + _local_6.amount);
                };
            };
            if (_local_4 > 0)
            {
                return (_local_4 - this.GetRegisteredAmount(_arg_1, _arg_2, _arg_3));
            };
            return (defines.NO_LIMIT);
        }

        public function IsLimitedShopItem(_arg_1:cShopItem):Boolean
        {
            var _local_2:cItemContent;
            for each (_local_2 in _arg_1.GetShopItemContent_vector())
            {
                if (this.IsLimitedItem(_local_2.GetType(), _local_2.GetName_string(), _local_2.GetResourceName_string()))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function GetRemainingAmountForShopItem(_arg_1:cShopItem):int
        {
            var _local_3:cItemContent;
            var _local_2:* = 999;
            for each (_local_3 in _arg_1.GetShopItemContent_vector())
            {
                if (((this.IsLimitedItem(_local_3.GetType(), _local_3.GetName_string(), _local_3.GetResourceName_string())) && (this.GetRemainingAmount(_local_3.GetType(), _local_3.GetName_string(), _local_3.GetResourceName_string()) < _local_2)))
                {
                    _local_2 = this.GetRemainingAmount(_local_3.GetType(), _local_3.GetName_string(), _local_3.GetResourceName_string());
                };
            };
            return (_local_2);
        }

        public function GetRegisteredAmountByKey(_arg_1:String):int
        {
            var _local_2:dPersistedItemRegistryVO = (this.mRegistry.getItem(_arg_1) as dPersistedItemRegistryVO);
            if (_local_2 != null)
            {
                return (_local_2.amount);
            };
            return (0);
        }


    }
}
