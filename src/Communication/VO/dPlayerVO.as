package Communication.VO
{
    import mx.collections.ArrayCollection;
    import Map.cSector;
    import Enums.SECTOR_DISCOVERY_TYPE;
    import Interface.cGeneralInterface;

    public class dPlayerVO 
    {

        public var bonusValipXp:int;
        public var explorersAmount:int;
        public var premiumExpiredNotified:Number;
        public var guildMaxSize:int;
        public var colonySlotCountPermanent:int;
        public var username_string:String;
        public var pvpModifier:int;
        public var playerLevel:int;
        public var userID:int;
        public var hideHelp:Boolean;
        public var uniqueID:dUniqueID;
        public var admiralAmount:int;
        public var pvpXp:int;
        public var generalsAmount:int;
        public var landingZoneID:int;
        public var zoneID:int;
        public var currentMaximumBuildingsCountAll:int;
        public var premiumUntil:Number;
        public var permanentBuildQueueSlotsCount:int = 0;
        public var avatarId:int;
        public var cityLevel:int;
        public var colonySlotCountTemp:int;
        public var canCheat:Boolean;
        public var guildId:int;
        public var geologistsAmount:int;
        public var claimedPvpLevel:int;
        public var xp:int;
        public var pvpLevel:int;
        public var blackMarketUnlocked:Boolean;

        public var resources:ArrayCollection = new ArrayCollection();
        public var discoveredSectors:ArrayCollection = new ArrayCollection();
        public var availableBuffs_vector:ArrayCollection = new ArrayCollection();
        public var purchasedShopItems_vector:ArrayCollection = new ArrayCollection();
        public var availableTempSlots_vector:ArrayCollection = new ArrayCollection();
        public var knownHelp_vector:ArrayCollection = new ArrayCollection();
        public var skills:ArrayCollection = new ArrayCollection();


        public static function CreateVisitorPlayer(_arg_1:cGeneralInterface, _arg_2:int):dPlayerVO
        {
            var _local_4:cSector;
            var _local_5:dSectorDiscoveryVO;
            var _local_3:dPlayerVO = new (dPlayerVO)();
            _local_3.userID = _arg_2;
            _local_3.uniqueID = new dUniqueID();
            if (((!(_arg_1.IsAdventureZone())) || (!(_arg_1.mCurrentPlayerZone.mStreetDataMap.useContinentalFog))))
            {
                for each (_local_4 in _arg_1.mCurrentPlayerZone.mSectorList_vector)
                {
                    _local_5 = new dSectorDiscoveryVO();
                    _local_5.sectorID = _local_4.GetSectorID();
                    _local_5.discoveryType = SECTOR_DISCOVERY_TYPE.EXPLORED;
                    _local_3.discoveredSectors.addItem(_local_5);
                };
            };
            return (_local_3);
        }


        public function toString():String
        {
            var _local_2:dResourceVO;
            var _local_3:dSectorDiscoveryVO;
            var _local_4:dBuffVO;
            var _local_5:dPurchasedShopItemVO;
            var _local_6:dTempBuildSlotVO;
            var _local_1:* = (((((((((((((((((((((((((((((((((("<PlayerVO username='" + this.username_string) + "' userID='") + this.userID) + "' zoneID='") + this.zoneID) + "' xp='") + this.xp) + "' bonusValidXp='") + this.bonusValipXp) + "' cityLevel='") + this.cityLevel) + "' playerLevel='") + this.playerLevel) + "' avatarId='") + this.avatarId) + "' uniqueID='") + this.uniqueID) + "' canCheat='") + this.canCheat) + "' admiralAmount='") + this.admiralAmount) + "' generalsAmount='") + this.generalsAmount) + "' explorersAmount='") + this.explorersAmount) + "' geologistsAmount='") + this.geologistsAmount) + "' currentMaximumBuildingsCountAll='") + this.currentMaximumBuildingsCountAll) + "' premiumUntil='") + this.premiumUntil) + "' premiumExpireNotified='") + this.premiumExpiredNotified) + "' >\n");
            _local_1 = (_local_1 + "  <Resources>\n");
            if (this.resources != null)
            {
                for each (_local_2 in this.resources)
                {
                    _local_1 = (_local_1 + (("    " + _local_2) + "\n"));
                };
            };
            _local_1 = (_local_1 + "  </Resources>\n");
            _local_1 = (_local_1 + "  <DiscoveredSectors>\n");
            if (this.discoveredSectors != null)
            {
                for each (_local_3 in this.discoveredSectors)
                {
                    _local_1 = (_local_1 + (("    " + _local_3) + "\n"));
                };
            };
            _local_1 = (_local_1 + "  </DiscoveredSectors>\n");
            _local_1 = (_local_1 + "  <AvailableBuffs>\n");
            if (this.availableBuffs_vector != null)
            {
                for each (_local_4 in this.availableBuffs_vector)
                {
                    _local_1 = (_local_1 + (("    " + _local_4) + "\n"));
                };
            };
            _local_1 = (_local_1 + "  </AvailableBuffs>\n");
            _local_1 = (_local_1 + "  <PurchasedShopItems>\n");
            if (this.purchasedShopItems_vector != null)
            {
                for each (_local_5 in this.purchasedShopItems_vector)
                {
                    _local_1 = (_local_1 + (("    " + _local_5) + "\n"));
                };
            };
            _local_1 = (_local_1 + "  </PurchasedShopItems>\n");
            _local_1 = (_local_1 + "  <AvailableTempSlots>\n");
            if (this.availableTempSlots_vector != null)
            {
                for each (_local_6 in this.availableTempSlots_vector)
                {
                    _local_1 = (_local_1 + (("    " + _local_6) + "\n"));
                };
            };
            _local_1 = (_local_1 + "  </AvailableTempSlots>\n");
            return (_local_1 + "</PlayerVO>\n");
        }


    }
}
