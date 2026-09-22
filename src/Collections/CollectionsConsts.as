package Collections
{
    public class CollectionsConsts 
    {

        public static const COLLECTION_RESOURCE_TEXT_COLOR_UNAVAILABLE:int = 0xFF0000;
        public static const COLLECTION_RESOURCE_TEXT_COLOR_AVAILABLE:int = 0xFFFFFF;
        public static const COLOR_PROPERTY_NAME:String = "color";
        public static const MINIMUM_DISTANCE_BETWEEN_GRIDS:int = 5;
        public static const INACTIVE_SECTOR_ID:int = 0;
        public static const STAR_MENU_DISPLAY_LIST_IDENTIFIER:String = "GAMESTATE_ID_ACTIONBAR.actionBarCenter.btnActionBar04";
        public static const ADD_RESOURCE_BUFF_NAME:String = "AddResource";
        public static const NAME_RESOURCE_NOTHING:String = "Nothing";
        public static const REVEAL_COLLECTIBLES_BUFF:String = "RevealCollectiblesBuff";
        public static const REVEAL_FRIENDS_COLLECTIBLES_BUFF:String = "RevealFriendsCollectiblesBuff";
        public static const WAREHOUSE_COLLECTIONS_TAB_LOCA_NAME:String = "WarehouseTab7";
        public static const BUY_COLLECTIBLE_COMPONENTS:String = "BuyCollectibleComponents";
        public static const COMPLETE_COLLECTION:String = "CompleteCollection";
        public static const BUY_COLLECTIBLE_COMPONENT_MISSING_LEVEL:String = "BuyCollectibleComponentsMissingLevel";
        public static const BUILD_COLLECTION_MISSING_LEVEL:String = "BuildCollectionMissingLevel";
        public static const BUY_COLLECTIBLE_COMPONENTS_PRICE:String = "BuyCollectibleComponentsPrice";
        public static const BUILD_COLLECTION_MISSING_RESOURCES:String = "BuildCollectionMissingResources";
        public static const DETAILS_COLLECTIONS_PRODUCTION:String = "DetailsCollectionsProduction";
        public static const COLLECTIONS_PICKUP:String = "Pickup";
        public static const COLLECTION_ITEM_BACKROUND_CLASS_NAME:String = "CollectionItemBackground";
        public static const COLLECTION_RESOURCE_BACKGROUND_NEUTRAL:String = "CollectionResourceBackgroundNeutral";
        public static const COLLECTION_RESOURCE_BACKGROUND_RARITY_MAP:Array = ["CollectionResourceBackgroundRarity0", "CollectionResourceBackgroundRarity1", "CollectionResourceBackgroundRarity2", "CollectionResourceBackgroundRarity3"];
        public static const COLLECTIBLE_BUILDING_TYPE_NORMAL:String = "normal";
        public static const COLLECTIBLE_BUILDING_TYPE_EVENT:String = "event";
        public static const COLLECTIBLE_LOOT_TABLE_ALL:String = "allLootTables";
        public static const COLLECTIBLE_BUILDING_NORMAL:int = 0;
        public static const COLLECTIBLE_BUILDING_EVENT:int = 1;

        public function CollectionsConsts()
        {
            super();
            throw (new Error("Do not instantiate this class!"));
        }

    }
}
