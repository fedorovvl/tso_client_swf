package ShopSystem
{
    import __AS3__.vec.Vector;
    import Interface.cGameInterface;
    import nLib.cXML;
    import Votes.cVoteDefinition;
    import __AS3__.vec.*;

    public class cShopItemGroup 
    {

        private static var map_ShopItemGroupId_ShopItemGroup:Object = new Object();

        public const shopItems_vector:Vector.<cShopItem> = new Vector.<cShopItem>();

        private var id:int;
        public var name_string:String;
        private var mHideInShop:Boolean;
        private var requiresEvent:String;
        private var sortIndex:int;

        public function cShopItemGroup(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:Boolean)
        {
            super();
            this.id = _arg_1;
            this.name_string = _arg_2;
            this.sortIndex = _arg_3;
            this.mHideInShop = _arg_4;
        }

        public static function GetShopItemGroup(_arg_1:int):cShopItemGroup
        {
            return (map_ShopItemGroupId_ShopItemGroup[_arg_1] as cShopItemGroup);
        }

        public static function GetAllShopItemGroups(_arg_1:Boolean, _arg_2:cGameInterface):Array
        {
            var _local_4:String;
            var _local_5:cShopItemGroup;
            var _local_3:Array = [];
            for (_local_4 in map_ShopItemGroupId_ShopItemGroup)
            {
                _local_5 = map_ShopItemGroupId_ShopItemGroup[_local_4];
                if (((_arg_1) || (!(_local_5.isHiddenInShop(_arg_2)))))
                {
                    _local_3.push(_local_5);
                };
            };
            _local_3.sort(SortGroups);
            return (_local_3);
        }

        public static function SortGroups(_arg_1:cShopItemGroup, _arg_2:cShopItemGroup):int
        {
            return (_arg_1.GetSortIndex() - _arg_2.GetSortIndex());
        }

        protected static function SortShopItems(_arg_1:cShopItem, _arg_2:cShopItem):int
        {
            return (_arg_1.GetSortIdx() - _arg_2.GetSortIdx());
        }

        public static function ReadShopItemGroupFromXml(_arg_1:cXML, _arg_2:Boolean):cShopItemGroup
        {
            var _local_3:int = _arg_1.GetAttributeInt("id");
            var _local_4:String = _arg_1.GetAttributeString_string("name");
            var _local_5:int = _arg_1.GetAttributeInt("sortIndex");
            var _local_6:Boolean = _arg_1.GetAttributeBool("hideInShop");
            var _local_7:String = _arg_1.GetAttributeString_string("requiresEvent");
            _local_6 = ((_local_6) || (!(gParse.parseIsAvailableForLocation(_arg_1, global.realmLanguage))));
            var _local_8:cShopItemGroup;
            if (((_arg_2) || ((!(global.vote_shop_group == null)) && (global.vote_shop_group.name_string == _local_4))))
            {
                _local_8 = new VoteShopItemGroup(_local_3, _local_4, _local_5, _local_6);
            }
            else
            {
                _local_8 = new cShopItemGroup(_local_3, _local_4, _local_5, _local_6);
            };
            _local_8.requiresEvent = _local_7;
            map_ShopItemGroupId_ShopItemGroup[_local_3] = _local_8;
            return (_local_8);
        }


        public function GetId():int
        {
            return (this.id);
        }

        public function toString():String
        {
            var _local_2:cShopItem;
            var _local_1:* = (((("<cShopItemGroup id='" + this.id) + "' name='") + this.name_string) + "' >\n");
            for each (_local_2 in this.shopItems_vector)
            {
                _local_1 = (_local_1 + (_local_2 + "\n"));
            };
            return (_local_1 + "</cShopItemGroup>");
        }

        public function isHiddenInShop(_arg_1:cGameInterface):Boolean
        {
            return ((((this.mHideInShop) || ((((!(_arg_1 == null)) && (!(this.requiresEvent == null))) && (!(this.requiresEvent == ""))) && (!(_arg_1.mEventManager.isEventStarted(this.requiresEvent))))) || ((!(_arg_1 == null)) && (this.isGroupEmpty(_arg_1)))) || (this.isHiddenVote(_arg_1)));
        }

        public function isHiddenVote(_arg_1:cGameInterface):Boolean
        {
            var _local_2:Boolean = (((!(_arg_1 == null)) && (global.vote_shop_group.name_string == this.name_string)) && (!(_arg_1.mVotesManager.IsVoteEnabled())));
            var _local_3:cVoteDefinition = (global.vote_definitions.getItem(global.vote_shop_group.name_string) as cVoteDefinition);
            if (((!(_local_2)) && (this.name_string == _local_3.altShopGroup)))
            {
                if (((!(_arg_1 == null)) && (!(_arg_1.mVotesManager.IsVoteEnabled()))))
                {
                    return (false);
                };
                return ((_arg_1 == null) ? false : true);
            };
            return (_local_2);
        }

        public function GetName_string():String
        {
            return (this.name_string);
        }

        public function getSortedItems_vector(_arg_1:cGameInterface, _arg_2:Boolean):Vector.<cShopItem>
        {
            var _local_4:cShopItem;
            var _local_3:Vector.<cShopItem> = new Vector.<cShopItem>();
            for each (_local_4 in this.shopItems_vector)
            {
                if (!_local_4.hideInShop(_arg_1))
                {
                    if (_arg_2)
                    {
                        if (_local_4.giftable())
                        {
                            _local_4.enabled = (!(_arg_1.mSpecificShopItems));
                            _local_3.push(_local_4);
                        };
                    }
                    else
                    {
                        _local_4.enabled = ((_arg_1.mSpecificShopItems) ? _arg_1.mEnabledShopItems_vector.contains(_local_4.GetId()) : ((_local_4.GetTargetZone() == "Friend") ? false : true));
                        _local_3.push(_local_4);
                    };
                };
            };
            _local_3.sort(SortShopItems);
            return (_local_3);
        }

        public function AddShopItem(_arg_1:cShopItem):void
        {
            this.shopItems_vector.push(_arg_1);
        }

        public function isGroupEmpty(_arg_1:cGameInterface):Boolean
        {
            var _local_2:cShopItem;
            for each (_local_2 in this.shopItems_vector)
            {
                if (!_local_2.isItemHiddenInGroup(_arg_1))
                {
                    return (false);
                };
            };
            return (true);
        }

        public function GetRequiresEvent():String
        {
            return (this.requiresEvent);
        }

        public function GetSortIndex():int
        {
            return (this.sortIndex);
        }


    }
}
