package ShopSystem
{
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import nLib.cXML;
    import Interface.cGameInterface;
    import __AS3__.vec.*;

    public class cShopItem 
    {

        private static var map_ShopItemName_ShopItem:Object = new Object();

        private var pvpLevel:int;
        private var includeItemsInLimit:String;
        private var groupId:int;
        private var requiresEvent:String;
        private var indicator:String;
        private var mIsGroupHidden:Boolean;
        private var mGiftable:Boolean;
        private var id:int;
        private var playerLevel:int;
        public var perVoteRound:int;
        private var cooldownPerPlayer:int;
        private var sortIdx:int;
        public var enabled:Boolean = true;
        private var name_string:String;
        private var frameType:String;
        private var votePoolName:String;
        private var targetZone:String;
        private var perPlayer:int;
        private var mHideInShop:Boolean;
        private var toolTipIdentifier:String;
        private var percentIncCosts:int;
        private var perEvent:int;
        private var quality:int;

        private var costs_vector:Vector.<dResource> = new Vector.<dResource>();
        private var itemContent_vector:Vector.<cItemContent> = new Vector.<cItemContent>();

        public function cShopItem(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:Vector.<dResource>, _arg_5:int, _arg_6:Vector.<cItemContent>, _arg_7:int, _arg_8:int, _arg_9:int, _arg_10:String, _arg_11:int, _arg_12:Boolean, _arg_13:String, _arg_14:String, _arg_15:String, _arg_16:Boolean, _arg_17:String, _arg_18:int, _arg_19:int, _arg_20:int, _arg_21:String, _arg_22:String, _arg_23:int)
        {
            super();
            this.id = _arg_1;
            this.name_string = _arg_2;
            this.groupId = _arg_3;
            this.costs_vector = _arg_4;
            this.itemContent_vector = _arg_6;
            this.sortIdx = _arg_7;
            this.playerLevel = _arg_8;
            this.quality = _arg_9;
            this.indicator = _arg_10;
            this.perPlayer = _arg_11;
            this.mHideInShop = _arg_12;
            this.frameType = _arg_13;
            this.toolTipIdentifier = _arg_14;
            this.percentIncCosts = _arg_5;
            this.targetZone = _arg_15;
            this.mGiftable = _arg_16;
            this.requiresEvent = _arg_17;
            this.cooldownPerPlayer = _arg_18;
            this.pvpLevel = _arg_19;
            this.perEvent = _arg_20;
            this.includeItemsInLimit = _arg_21;
            this.votePoolName = _arg_22;
            this.perVoteRound = _arg_23;
        }

        public static function CreateShopItemFromXml(_arg_1:cXML, _arg_2:int):cShopItem
        {
            var _local_20:Boolean;
            var _local_24:cXML;
            var _local_25:String;
            var _local_26:String;
            var _local_27:int;
            var _local_28:cShopItem;
            var _local_29:cItemContent;
            var _local_3:int = _arg_1.GetAttributeInt("id");
            var _local_4:String = _arg_1.GetAttributeString_string("name");
            var _local_5:int = _arg_1.GetAttributeInt("sortIndex");
            var _local_6:int = _arg_1.GetAttributeInt("playerLevel");
            var _local_7:int = _arg_1.GetAttributeInt("pvpLevel", 0);
            var _local_8:int = _arg_1.GetAttributeInt("quality");
            var _local_9:String = _arg_1.GetAttributeString_string("indicator");
            var _local_10:String = _arg_1.GetAttributeString_string("tooltip");
            var _local_11:int = _arg_1.GetAttributeInt("perPlayer");
            var _local_12:String = _arg_1.GetAttributeString_string("frameType");
            var _local_13:Boolean = _arg_1.GetAttributeBool("hideInShop");
            var _local_14:String = _arg_1.GetAttributeString_string("requiresEvent");
            var _local_15:int = _arg_1.GetAttributeInt("percentIncCosts");
            var _local_16:Vector.<dResource> = gParse.ParseCosts(_arg_1.MoveToSubNode("Costs"));
            var _local_17:String = _arg_1.GetAttributeString_string("giftable");
            var _local_18:int = _arg_1.GetAttributeInt("perEvent");
            var _local_19:String = _arg_1.GetAttributeString_string("includeItemsInLimit", "");
            _local_13 = ((_local_13) || (!(gParse.parseIsAvailableForLocation(_arg_1, global.realmLanguage))));
            if (_local_17.length == 0)
            {
                _local_20 = ((_local_11 <= 0) && (_local_18 <= 0));
            }
            else
            {
                _local_20 = (_local_17 == "true");
            };
            var _local_21:int = _arg_1.GetAttributeInt("cooldownPerPlayer");
            var _local_22:Vector.<cItemContent> = new Vector.<cItemContent>();
            var _local_23:Vector.<cXML> = _arg_1.MoveToSubNodeAndCreateChildrenArray("Content");
            for each (_local_24 in _local_23)
            {
                _local_29 = cItemContent.CreateItemContentFromXml(_local_24);
                _local_22.push(_local_29);
            };
            _local_25 = _arg_1.GetAttributeString_string("targetZones");
            _local_26 = _arg_1.GetAttributeString_string("votePoolName");
            _local_27 = _arg_1.GetAttributeInt("perVoteRound");
            _local_28 = new cShopItem(_local_3, _local_4, _arg_2, _local_16, _local_15, _local_22, _local_5, _local_6, _local_8, _local_9, _local_11, _local_13, _local_12, _local_10, _local_25, _local_20, _local_14, _local_21, _local_7, _local_18, _local_19, _local_26, _local_27);
            map_ShopItemName_ShopItem[_local_3] = _local_28;
            return (_local_28);
        }

        public static function SetShopItem(_arg_1:cShopItem):void
        {
            map_ShopItemName_ShopItem[_arg_1.id] = _arg_1;
        }

        public static function GetShopItem(_arg_1:int):cShopItem
        {
            return (map_ShopItemName_ShopItem[_arg_1] as cShopItem);
        }


        public function setSortIdx(_arg_1:int):void
        {
            this.sortIdx = _arg_1;
        }

        public function giftable():Boolean
        {
            return (this.mGiftable);
        }

        public function GetItemsInLimit():Vector.<int>
        {
            var _local_3:String;
            var _local_1:Array = this.includeItemsInLimit.split(",");
            var _local_2:Vector.<int> = new Vector.<int>();
            for each (_local_3 in _local_1)
            {
                if (_local_3.length > 0)
                {
                    _local_2.push(parseInt(_local_3));
                };
            };
            return (_local_2);
        }

        public function GetPlayerLevel():int
        {
            return (this.playerLevel);
        }

        public function GetPerVoteRound():int
        {
            return (this.perVoteRound);
        }

        public function toString():String
        {
            var _local_2:cItemContent;
            var _local_1:* = (((("<cShopItem id='" + this.id) + "' name='") + this.name_string) + "' >\n");
            for each (_local_2 in this.itemContent_vector)
            {
                _local_1 = (_local_1 + (("  " + _local_2) + "\n"));
            };
            return (_local_1 + "</cShopItem>\n");
        }

        public function GetToolTipIdentifier_string():String
        {
            return (this.toolTipIdentifier);
        }

        public function GetCooldownPerPlayer():int
        {
            return (this.cooldownPerPlayer);
        }

        public function GetShopItemContent_vector():Vector.<cItemContent>
        {
            return (this.itemContent_vector);
        }

        public function GetSortIdx():int
        {
            return (this.sortIdx);
        }

        public function hideInShop(_arg_1:cGameInterface):Boolean
        {
            return (((((this.mHideInShop) || (this.mIsGroupHidden)) || (((!(this.requiresEvent == null)) && (!(this.requiresEvent == ""))) && (!(_arg_1.mEventManager.isEventStarted(this.requiresEvent))))) || (cShopItemGroup.GetShopItemGroup(this.groupId).isHiddenInShop(_arg_1))) || (this.IsHiddenVotedItem(_arg_1)));
        }

        public function GetName_string():String
        {
            return (this.name_string);
        }

        public function GetCosts_vector():Vector.<dResource>
        {
            if (this.percentIncCosts > 0)
            {
                return (this.GetIncCosts_vector(-1));
            };
            return (this.costs_vector);
        }

        public function IsHiddenVotedItem(_arg_1:cGameInterface):Boolean
        {
            return ((cShopItemGroup.GetShopItemGroup(this.groupId).name_string == global.vote_shop_group.name_string) && (!(_arg_1.mVotesManager.IsItemInCurrentShopItems(this.id))));
        }

        public function setIsGroupHidden(_arg_1:Boolean):void
        {
            this.mIsGroupHidden = _arg_1;
        }

        public function GetIncCosts_vector(_arg_1:int):Vector.<dResource>
        {
            var _local_4:dResource;
            var _local_5:dResource;
            if (((_arg_1 == -1) && (global.ui == null)))
            {
                return (this.costs_vector);
            };
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            var _local_3:int = ((global.ui != null) ? global.ui.mCurrentPlayer.GetPurchasedShopItemAmount(this.GetId()) : _arg_1);
            for each (_local_4 in this.costs_vector)
            {
                _local_5 = new dResource();
                _local_5.name_string = _local_4.name_string;
                _local_5.amount = (_local_4.amount * (1 + ((this.percentIncCosts * _local_3) / 100)));
                _local_2.push(_local_5);
            };
            return (_local_2);
        }

        public function GetPerPlayer():int
        {
            return (this.perPlayer);
        }

        public function GetVotePoolName():String
        {
            return (this.votePoolName);
        }

        public function GetTargetZone():String
        {
            return (this.targetZone);
        }

        public function GetPerEvent():int
        {
            return (this.perEvent);
        }

        public function GetFrameType_string():String
        {
            return (this.frameType);
        }

        public function GetGroupId():int
        {
            return (this.groupId);
        }

        public function SethideInShop(_arg_1:Boolean):void
        {
            this.mHideInShop = _arg_1;
        }

        public function GetPvPLevel():int
        {
            return (this.pvpLevel);
        }

        public function GetId():int
        {
            return (this.id);
        }

        public function isItemHiddenInGroup(_arg_1:cGameInterface):Boolean
        {
            return ((this.mHideInShop) || (((!(this.requiresEvent == null)) && (!(this.requiresEvent == ""))) && (!(_arg_1.mEventManager.isEventStarted(this.requiresEvent)))));
        }

        public function GetRequiresEvent():String
        {
            return (this.requiresEvent);
        }


    }
}
