package ServerState
{
    import Model.Notifier;
    import Skill.Skilled;
    import Skill.cSkillList;
    import Communication.VO.dPlayerListItemVO;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import BuffSystem.cBuff;
    import flash.utils.Dictionary;
    import Communication.VO.dUniqueID;
    import GO.cBuilding;
    import Map.cSectorDiscovery;
    import Communication.VO.dPurchasedShopItemVO;
    import Communication.VO.dTempBuildSlotVO;
    import mx.events.PropertyChangeEvent;
    import Enums.DIRTY_INDICATOR;
    import AdventureSystem.cAdventureDefinition;
    import Interface.cGameInterface;
    import Enums.BUFF_TARGET_ZONE;
    import Utils.StringUtils;
    import nLib.cLog;
    import Communication.VO.dRequirementVO;
    import Communication.VO.dRequirementsVO;
    import Utils.TriggerUtils;
    import Communication.VO.ExpeditionMapLevelGroupDataVO;
    import Enums.ADVENTURE_MODE;
    import nLib.gMisc;
    import Communication.VO.Skill.SkillVO;
    import Enums.SPECIALIST_TYPE;
    import Communication.VO.Guild.dGuildPlayerPermissionVO;
    import Enums.SECTOR_DISCOVERY_TYPE;
    import Communication.VO.dSectorDiscoveryVO;
    import Communication.VO.dBuffVO;
    import ShopSystem.cShopItem;
    import Communication.VO.dPlayerVO;
    import mx.collections.ArrayCollection;
    import Map.cSector;
    import Utils.IntegerUtils;
    import Communication.VO.Guild.dGuildVO;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Skill.cSkillTree;
    import com.bluebyte.tso.util.TimeUtil;
    import Communication.VO.ColonyVO;
    import Colony.cColony;
    import Tracks.TrackManager;
    import flash.events.Event;
    import Enums.SKILL_OWNER;
    import ServerState.*;
    import __AS3__.vec.*;
    import Tracks.*;

    public class cPlayerData extends Notifier implements Skilled, LootHolder 
    {

        public static const PLAYER_STATE_UNDEFINED:int = -1;
        public static const PLAYER_STATE_START_GAME:int = 0;
        public static const PLAYER_LEVEL_CHANGED:String = "mPlayerLevel";
        public static const PLAYER_PVP_LEVEL_CHANGED:String = "mPlayerPvPLevel";

        private var mGeologistsAmount:int;
        private var guildMaxSize:int;
        private var mColonySlotCountPermanent:int = 0;
        private var mXP:int = 0;
        public var mDirtyIndicator:int = 0;
        private var _60205487mIsColony:Boolean = false;
        private var skills:cSkillList = null;
        private var guildID:int;
        private var mPremiumUntil:Number;
        private var mPlayerPvPLevel:int = 1;
        public var mAvatarPictureDirtyIndicator:int = 0;
        private var mPlayerLevel:int = 1;
        public var mCurrentBuildingsCountAll:int;
        public var mUpdateCheckCounter:int = 0;
        private var resortBuffsForStarMenu:Boolean = false;
        private var mPlayerPvPXp:int = 0;
        private var mGeneralsAmount:int;
        private var mColonySlotCountTemp:int = 0;
        private var mPlayerListItem:dPlayerListItemVO;
        private var mPlayerCanCheat:Boolean;
        private var _1900481957mIsAdventureZone:Boolean = true;
        private var mXPChanged:Boolean;
        private var _1779503100mIsPlayerZone:Boolean = true;
        private var _625721612mIsDefenseMode:Boolean = false;
        private var mCityLevel:int = 0;
        public var mHideHelp:Boolean;
        public var mTradeData:cTradeWindowData = null;
        private var mClaimedPvpLevel:int = 1;
        private var mAdmiralAmount:int;
        public var mKnownHelp_vector:Vector.<String>;
        private var mLastUpdate:Number;
        public var mLandingZoneID:int = 0;
        private var mExplorersAmount:int;
        private var mPlayerId:int = -1;
        private var mPvpModifier:int = 0;
        private var mPlayerState:int = -1;
        public var mBuildQueue:cBuildQueueData = null;
        private var mCurrentMaximumBuildingsCountAll:int = 0;
        private var mPremiumExpireNotified:Number;
        private var mPlayerName_string:String = "";
        private var mGeneralInterface:cGeneralInterface;
        private var mPlayerLevelHomeZone:int = 1;
        private var mPermanentBuildQueueSlotsCount:int = 0;
        private var mAvatarId:int = 1;
        private var mBonusValidXP:int = 0;
        private var mAvailableBuffsCurrentIndex:int = -1;
        public var mBlackMarketUnlocked:Boolean = false;

        public const mAvailableBuffs_vector:Vector.<cBuff> = new Vector.<cBuff>();
        private var mCurrentlyBuildingsCount:Dictionary = new Dictionary();
        private var mUnique:dUniqueID = new dUniqueID();
        private const mPrePlacedBuildingCounter_vector:Vector.<cBuilding> = new Vector.<cBuilding>();
        private var mDiscoveredSector_vector:Vector.<cSectorDiscovery> = new Vector.<cSectorDiscovery>();
        public const mPurchasedShopItems_vector:Vector.<dPurchasedShopItemVO> = new Vector.<dPurchasedShopItemVO>();
        public const mAvailableTempSlots_vector:Vector.<dTempBuildSlotVO> = new Vector.<dTempBuildSlotVO>();
        private const sortedBuffsForStarMenu:Array = new Array();

        public function cPlayerData(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mBuildQueue = new cBuildQueueData(this.mGeneralInterface, this);
            this.mTradeData = new cTradeWindowData(this.mGeneralInterface);
            if (definesMaster.MASTER_VERSION)
            {
                this.mPlayerCanCheat = false;
            }
            else
            {
                this.mPlayerCanCheat = true;
            };
        }

        public function removeAllBuffs():void
        {
            this.mAvailableBuffs_vector.length = 0;
            notifyPropertyObserver("mAvailableBuffs_vector", null);
            this.resortBuffsForStarMenu = true;
        }

        [Bindable(event="propertyChange")]
        public function get mIsPlayerZone():Boolean
        {
            return (this._1779503100mIsPlayerZone);
        }

        public function set mIsPlayerZone(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1779503100mIsPlayerZone;
            if (_local_2 !== _arg_1)
            {
                this._1779503100mIsPlayerZone = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mIsPlayerZone", _local_2, _arg_1));
            };
        }

        public function GetUniqueID():dUniqueID
        {
            return (this.mUnique);
        }

        public function IsMaximumPlacedBuildingCountReached(_arg_1:String):Boolean
        {
            var _local_4:cBuilding;
            var _local_5:cBuilding;
            var _local_6:int;
            var _local_7:int;
            var _local_2:int = this.mCurrentlyBuildingsCount[_arg_1];
            var _local_3:int;
            for each (_local_4 in this.mBuildQueue.GetQueue_vector())
            {
                if (_local_4.GetBuildingName_string() == _arg_1)
                {
                    _local_3++;
                };
            };
            for each (_local_5 in this.mPrePlacedBuildingCounter_vector)
            {
                if (_local_5.GetBuildingName_string() == _arg_1)
                {
                    _local_3++;
                };
            };
            _local_2 = (_local_2 + _local_3);
            _local_6 = global.buildingGroup.GetNrFromName(_arg_1);
            _local_7 = global.buildingGroup.mGOList_vector[_local_6].mMaxBuildingLimit;
            if (_local_2 >= _local_7)
            {
                return (true);
            };
            if (this.IsBuildingCounted(_arg_1))
            {
                if (this.mCurrentBuildingsCountAll >= this.mCurrentMaximumBuildingsCountAll)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function ResetProgression():void
        {
            if (this.GetHomeZoneId() == this.mGeneralInterface.mCurrentViewedZoneID)
            {
                return;
            };
            if (((!(this.mXP == 0)) || (!(this.mPlayerLevel == 0))))
            {
                this.mXP = 0;
                this.mPlayerLevel = 0;
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        [Bindable(event="levelChanged")]
        public function GetPlayerLevel():int
        {
            return (this.mPlayerLevel);
        }

        public function GetPlayerName_string():String
        {
            return (this.mPlayerName_string);
        }

        public function getBuffsSortedForStarMenu():Array
        {
            var _local_1:int;
            var _local_2:Boolean;
            var _local_3:cBuff;
            var _local_4:cAdventureDefinition;
            var _local_5:String;
            if (this.resortBuffsForStarMenu)
            {
                this.sortedBuffsForStarMenu.length = 0;
                _local_1 = this.mGeneralInterface.getZoneTypes(this.mPlayerId);
                _local_2 = false;
                for each (_local_3 in this.mAvailableBuffs_vector)
                {
                    _local_2 = false;
                    if (((_local_3.GetBuffDefinition().GetRedeemable_vector().length > 0) && (!((this.mGeneralInterface as cGameInterface).mEventManager.isEventStarted(_local_3.GetBuffDefinition().GetRedeemableEventName())))))
                    {
                        _local_3.enable = (((_local_1 & BUFF_TARGET_ZONE.HOME) > 0) || ((_local_1 & BUFF_TARGET_ZONE.ADVENTURE) > 0));
                    }
                    else
                    {
                        if (_local_3.GetBuffDefinition().IsAdventure())
                        {
                            _local_4 = cAdventureDefinition.FindAdventureDefinition(_local_3.GetResourceName_string());
                            _local_3.enable = (((_local_4.GetRequiresEvent() == "") || (this.mGeneralInterface.mEventManager.isEventStarted(_local_4.GetRequiresEvent()))) && ((_local_1 & _local_3.GetBuffDefinition().getTargetZoneTypes()) > 0));
                        }
                        else
                        {
                            if (_local_3.GetBuffDefinition().GetId() == defines.ADD_RESOURCE_BUFF_ID)
                            {
                                _local_3.enable = ((_local_1 & _local_3.GetBuffDefinition().getTargetZoneTypes()) > 0);
                                if (_local_3.GetResourceName_string() != "")
                                {
                                    _local_5 = gEconomics.GetResourcesDefaultDefinition(_local_3.GetResourceName_string()).requiredEventName_string;
                                    if (((_local_3.enable) && (!(StringUtils.isEmpty(_local_5)))))
                                    {
                                        _local_3.enable = this.mGeneralInterface.mEventManager.isEventStarted(_local_5);
                                        _local_2 = (!(_local_3.enable));
                                    };
                                }
                                else
                                {
                                    cLog.warning(("Found add resource buff without resource on getBuffsSortedForStarMenu(): " + _local_3));
                                };
                            }
                            else
                            {
                                _local_3.enable = ((_local_1 & _local_3.GetBuffDefinition().getTargetZoneTypes()) > 0);
                            };
                        };
                    };
                    if (((!(_local_2)) && ((_local_3.enable) || ((_local_1 & BUFF_TARGET_ZONE.HOME) > 0))))
                    {
                        if (((_local_3.GetAmount() > 0) || (_local_3.GetBuffDefinition().GetAmount() == 0)))
                        {
                            this.sortedBuffsForStarMenu.push(_local_3);
                        };
                    };
                };
                this.sortedBuffsForStarMenu.sortOn(["sortKey", "amount"], [null, (Array.NUMERIC | Array.DESCENDING)]);
                this.resortBuffsForStarMenu = false;
            };
            return (this.sortedBuffsForStarMenu);
        }

        public function addBuffNoMergeChecks(_arg_1:cBuff):void
        {
            this.mAvailableBuffs_vector.push(_arg_1);
            this.resortBuffsForStarMenu = true;
        }

        public function getGuildID():int
        {
            return (this.guildID);
        }

        public function updateFrom(_arg_1:cPlayerData):void
        {
            var _local_2:cSectorDiscovery;
            for each (_local_2 in _arg_1.mDiscoveredSector_vector)
            {
                this.SetSectorDiscovery(_local_2.GetSectorID(), _local_2.GetDiscoveryType());
            };
            this.mLandingZoneID = _arg_1.mLandingZoneID;
        }

        private function GetBonusFromRequirements(_arg_1:String):int
        {
            var _local_4:dRequirementVO;
            var _local_2:int;
            var _local_3:dRequirementsVO = (this.mGeneralInterface as cGameInterface).mRequirements.miscRequirements_vector[_arg_1];
            for each (_local_4 in _local_3.requirements)
            {
                if (((_local_4.fulfilled) && (_local_4.amount > _local_2)))
                {
                    _local_2 = _local_4.amount;
                };
            };
            return (_local_2);
        }

        public function IncAnyBuildingCount(_arg_1:cBuilding):void
        {
            var _local_2:String = _arg_1.GetBuildingName_string();
            if (isNaN(this.mCurrentlyBuildingsCount[_local_2]))
            {
                this.mCurrentlyBuildingsCount[_local_2] = 0;
            };
            this.mCurrentlyBuildingsCount[_local_2] = (this.mCurrentlyBuildingsCount[_local_2] + 1);
            this.mGeneralInterface.channels.ZONE.send(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, _local_2);
        }

        public function set mIsDefenseMode(_arg_1:Boolean):void
        {
            var _local_2:Object = this._625721612mIsDefenseMode;
            if (_local_2 !== _arg_1)
            {
                this._625721612mIsDefenseMode = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mIsDefenseMode", _local_2, _arg_1));
            };
        }

        public function GetAdventureMapLevel(_arg_1:int, _arg_2:int):int
        {
            var _local_6:ExpeditionMapLevelGroupDataVO;
            var _local_3:int = -1;
            var _local_4:Number = 1;
            var _local_5:Number = 130;
            switch (_arg_2)
            {
                case ADVENTURE_MODE.MODE_CLASSIC:
                case ADVENTURE_MODE.MODE_BUFF_ADVENTURE:
                case ADVENTURE_MODE.MODE_MIXED_ADVENTURE:
                    _local_3 = this.GetPlayerLevel();
                    break;
                case ADVENTURE_MODE.MODE_EXPEDITION:
                case ADVENTURE_MODE.MODE_EXPEDITION_PVE:
                    _local_6 = global.expeditionMapLevelGroupVO.GetExpeditionMapLevelGroupDataVO(_arg_1);
                    if (_local_6 != null)
                    {
                        _local_4 = _local_6.levelMin;
                        _local_5 = _local_6.levelMax;
                    };
                    _local_3 = int(Math.max(_local_4, Math.min(_local_5, (cAdventureDefinition.CalcAdventureMapLevel(this.GetPlayerLevel()) + 0.5))));
                    break;
                case ADVENTURE_MODE.MODE_EXPEDITION_PVP:
                    gMisc.Assert(false, "This is deprecated");
                    break;
            };
            return (_local_3);
        }

        public function getExistingBuffItem(_arg_1:cBuff):cBuff
        {
            var _local_5:cBuff;
            if (_arg_1.isNotMerged())
            {
                return (null);
            };
            var _local_2:String = _arg_1.GetBuffDefinition().GetName_string();
            this.mAvailableBuffsCurrentIndex = -1;
            var _local_3:int = this.mAvailableBuffs_vector.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = this.mAvailableBuffs_vector[_local_4];
                if (StringUtils.equalsCase(_local_5.getMergeUniqueKey(), _arg_1.getMergeUniqueKey()))
                {
                    return (_local_5);
                };
                _local_4++;
            };
            return (null);
        }

        public function copyBuffWaitingForServerCount(_arg_1:cPlayerData):void
        {
            var _local_2:cBuff;
            var _local_3:cBuff;
            for each (_local_2 in this.mAvailableBuffs_vector)
            {
                if (_local_2.GetWaitingForServer())
                {
                    _local_3 = _arg_1.getBuffByUniqueID(_local_2.GetUniqueId());
                    if (_local_3 != null)
                    {
                        _local_3.SetWaitingForServerCount(_local_2.GetWaitingForServerCount(), this.mGeneralInterface);
                        _arg_1.resetLastFetchedBuff();
                        this.resortBuffsForStarMenu = true;
                    };
                };
            };
        }

        public function addSkill(_arg_1:SkillVO, _arg_2:Skilled, _arg_3:cGeneralInterface, _arg_4:Boolean):void
        {
            this.getSkills().addSkill(_arg_1, _arg_2, _arg_3, _arg_4, false, true);
        }

        public function DecAnyBuildingCount(_arg_1:cBuilding):void
        {
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mCurrentlyBuildingsCount[_local_2]--;
            this.mGeneralInterface.channels.ZONE.send(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, _local_2);
        }

        public function GetPlayerPvPXp():int
        {
            return (this.mPlayerPvPXp);
        }

        public function hasActivePremiumAccount():Boolean
        {
            return (this.mPremiumUntil > gMisc.GetEpochMillis());
        }

        public function SetPlayerId(_arg_1:int):void
        {
            this.mPlayerId = _arg_1;
        }

        public function GetSpecialistAmount(_arg_1:int):int
        {
            switch (_arg_1)
            {
                case SPECIALIST_TYPE.ADMIRAL:
                    return (this.mAdmiralAmount);
                case SPECIALIST_TYPE.GENERAL:
                    return (this.mGeneralsAmount);
                case SPECIALIST_TYPE.EXPLORER:
                    return (this.mExplorersAmount);
                case SPECIALIST_TYPE.GEOLOGIST:
                    return (this.mGeologistsAmount);
                default:
                    return (0);
            };
        }

        public function GetBuildingCountAll():int
        {
            return (this.mCurrentBuildingsCountAll);
        }

        public function GetPlayerPermissions():dGuildPlayerPermissionVO
        {
            if (this.mGeneralInterface.GetCurrentPlayerGuild() == null)
            {
                return (null);
            };
            return (this.mGeneralInterface.GetCurrentPlayerGuild().playerPermissions);
        }

        public function SetSectorDiscovery(_arg_1:int, _arg_2:int):void
        {
            var _local_3:cSectorDiscovery;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            if (!(_arg_1 < this.mDiscoveredSector_vector.length))
            {
                _local_4 = this.mDiscoveredSector_vector.length;
                _local_5 = ((_arg_1 - this.mDiscoveredSector_vector.length) + 1);
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    _local_3 = new cSectorDiscovery(_local_4, ((_local_4 == _arg_1) ? _arg_2 : SECTOR_DISCOVERY_TYPE.UNEXPLORED));
                    _local_3.mDirtyIndicator = (_local_3.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
                    this.mDiscoveredSector_vector.push(_local_3);
                    _local_4++;
                    _local_6++;
                };
            }
            else
            {
                _local_3 = this.mDiscoveredSector_vector[_arg_1];
                _local_3.SetDiscoveryType(_arg_2);
                _local_3.mDirtyIndicator = (_local_3.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
            notifyPropertyObserver("mDiscoveredSector_vector", this.mDiscoveredSector_vector);
        }

        public function getIconID():String
        {
            return ("");
        }

        public function GetCityLevel():int
        {
            return (this.mCityLevel);
        }

        public function getPremiumDurationInHours():int
        {
            var _local_1:Number = (this.mPremiumUntil - gMisc.GetEpochMillis());
            _local_1 = (_local_1 / 3600000);
            if (_local_1 < 1)
            {
                return (0);
            };
            return (_local_1 as int);
        }

        public function GetPlayerLevelHomeZone():int
        {
            return (this.mPlayerLevelHomeZone);
        }

        public function CreatePlayerVOFromPlayer(_arg_1:Boolean):dPlayerVO
        {
            var _local_3:cSectorDiscovery;
            var _local_4:cBuff;
            var _local_5:dSectorDiscoveryVO;
            var _local_6:dBuffVO;
            var _local_7:dPurchasedShopItemVO;
            var _local_8:dTempBuildSlotVO;
            var _local_9:String;
            var _local_10:cShopItem;
            var _local_2:dPlayerVO = new dPlayerVO();
            _local_2.userID = this.GetPlayerId();
            _local_2.username_string = this.GetPlayerName_string();
            _local_2.playerLevel = this.GetPlayerLevel();
            _local_2.uniqueID = this.mUnique;
            _local_2.discoveredSectors = new ArrayCollection();
            for each (_local_3 in this.mDiscoveredSector_vector)
            {
                _local_5 = new dSectorDiscoveryVO();
                _local_5.sectorID = _local_3.GetSectorID();
                _local_5.discoveryType = _local_3.GetDiscoveryType();
                _local_2.discoveredSectors.addItem(_local_5);
            };
            for each (_local_4 in this.mAvailableBuffs_vector)
            {
                _local_6 = _local_4.CreateBuffVOFromBuff();
                _local_2.availableBuffs_vector.addItem(_local_6);
                this.resortBuffsForStarMenu = true;
            };
            _local_2.guildId = this.getGuildID();
            _local_2.guildMaxSize = this.getGuildMaxSize();
            _local_2.landingZoneID = this.mLandingZoneID;
            if (!_arg_1)
            {
                _local_2.xp = this.GetXP();
                _local_2.bonusValipXp = this.GetBonusValidXP();
                _local_2.cityLevel = this.GetCityLevel();
                _local_2.pvpXp = this.GetPlayerPvPXp();
                _local_2.pvpLevel = this.GetPlayerPvPLevel();
                _local_2.claimedPvpLevel = this.GetClaimedPvPLevel();
                _local_2.pvpModifier = this.GetPvpModifier();
                _local_2.zoneID = this.GetHomeZoneId();
                _local_2.avatarId = this.GetAvatarId();
                _local_2.canCheat = this.getPlayerCanCheat();
                _local_2.admiralAmount = this.GetSpecialistAmount(SPECIALIST_TYPE.ADMIRAL);
                _local_2.generalsAmount = this.GetSpecialistAmount(SPECIALIST_TYPE.GENERAL);
                _local_2.explorersAmount = this.GetSpecialistAmount(SPECIALIST_TYPE.EXPLORER);
                _local_2.geologistsAmount = this.GetSpecialistAmount(SPECIALIST_TYPE.GEOLOGIST);
                _local_2.currentMaximumBuildingsCountAll = this.mCurrentMaximumBuildingsCountAll;
                _local_2.permanentBuildQueueSlotsCount = this.mPermanentBuildQueueSlotsCount;
                _local_2.premiumUntil = this.mPremiumUntil;
                _local_2.premiumExpiredNotified = this.mPremiumExpireNotified;
                _local_2.colonySlotCountPermanent = this.GetColonySlotCountPermanent();
                _local_2.colonySlotCountTemp = this.GetColonySlotCountTemp();
                _local_2.skills = this.skills.getSkillVOs();
                for each (_local_7 in this.mPurchasedShopItems_vector)
                {
                    _local_10 = cShopItem.GetShopItem(_local_7.shopItemID);
                    if (((!(_local_10 == null)) && ((((_local_10.GetCooldownPerPlayer() > 0) || (_local_10.GetPerEvent() > 0)) || (_local_10.GetPerPlayer() > 0)) || (_local_10.GetPerVoteRound() > 0))))
                    {
                        _local_2.purchasedShopItems_vector.addItem(_local_7);
                    };
                };
                for each (_local_8 in this.mAvailableTempSlots_vector)
                {
                    _local_2.availableTempSlots_vector.addItem(_local_8);
                };
                _local_2.hideHelp = this.mHideHelp;
                for each (_local_9 in this.mKnownHelp_vector)
                {
                    _local_2.knownHelp_vector.addItem(_local_9);
                };
            }
            else
            {
                _local_2.zoneID = _local_2.userID;
                _local_2.avatarId = this.GetAvatarId();
            };
            return (_local_2);
        }

        [Bindable(event="propertyChange")]
        public function get mIsColony():Boolean
        {
            return (this._60205487mIsColony);
        }

        override public function toString():String
        {
            return (("<cPlayerData playerId=" + this.mPlayerId) + " >");
        }

        public function getNextExplorableSector(_arg_1:Boolean):cSector
        {
            var _local_2:cSector;
            var _local_6:Vector.<cSector>;
            var _local_7:cSector;
            var _local_8:Vector.<int>;
            var _local_9:int;
            var _local_10:int;
            var _local_3:int = -1;
            var _local_4:int = this.GetPlayerId();
            var _local_5:cSector;
            if (_arg_1)
            {
                _local_6 = new Vector.<cSector>();
                _local_7 = null;
                for each (_local_2 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
                {
                    if (!((_local_2.GetSectorID() == 0) || (!(_arg_1 == _local_2.IsIsland()))))
                    {
                        if (((_local_2.GetOwnerPlayerID() == _local_4) || ((_local_2.GetOwnerPlayerID() == 0) && (this.GetSectorDiscovery(_local_2.GetSectorID()) >= SECTOR_DISCOVERY_TYPE.EXPLORED))))
                        {
                            if (((_local_7 == null) || (_local_7.GetExplorePriority() < _local_2.GetExplorePriority())))
                            {
                                _local_7 = _local_2;
                            };
                        }
                        else
                        {
                            if (this.GetSectorDiscovery(_local_2.GetSectorID()) == SECTOR_DISCOVERY_TYPE.RESERVED)
                            {
                                return (null);
                            };
                            _local_6.push(_local_2);
                        };
                    };
                };
                if (_local_6.length > 0)
                {
                    for each (_local_2 in _local_6)
                    {
                        if (((_local_5 == null) || ((_local_2.GetExplorePriority() < _local_5.GetExplorePriority()) && ((_local_7 == null) || (_local_2.GetExplorePriority() > _local_7.GetExplorePriority())))))
                        {
                            _local_5 = _local_2;
                        };
                    };
                };
                if (cLog.isInfoEnabled())
                {
                    if (_local_7 != null)
                    {
                        cLog.info(("Highest explored sector " + _local_7));
                    };
                    if (_local_5 != null)
                    {
                        cLog.info(("Found exploration candidate " + _local_5));
                    };
                };
            }
            else
            {
                _local_8 = new Vector.<int>();
                for each (_local_2 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
                {
                    if (((_local_2.GetOwnerPlayerID() == _local_4) || ((_local_2.GetOwnerPlayerID() == 0) && (this.GetSectorDiscovery(_local_2.GetSectorID()) == SECTOR_DISCOVERY_TYPE.EXPLORED))))
                    {
                        for each (_local_9 in _local_2.mAdjactedSectorIds_vector)
                        {
                            if (((_local_9 > 0) && (_local_8.indexOf(_local_9) == -1)))
                            {
                                _local_8.push(_local_9);
                            };
                        };
                    };
                };
                if (cLog.isInfoEnabled())
                {
                    _local_10 = _local_8.length;
                    cLog.info(((("Found " + _local_10) + " reachable sectors: ") + _local_8));
                };
                for each (_local_2 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
                {
                    if (((!(_local_8.indexOf(_local_2.GetSectorID()) == -1)) && (this.GetSectorDiscovery(_local_2.GetSectorID()) == SECTOR_DISCOVERY_TYPE.UNEXPLORED)))
                    {
                        if (_local_2.GetExplorePriority() > _local_3)
                        {
                            if ((((_arg_1) && (_local_2.IsIsland())) || ((!(_arg_1)) && (!(_local_2.IsIsland())))))
                            {
                                _local_5 = _local_2;
                                _local_3 = _local_2.GetExplorePriority();
                            };
                        };
                    }
                    else
                    {
                        if (cLog.isInfoEnabled())
                        {
                            if (!(!(_local_8.indexOf(_local_2.GetSectorID()) == -1)))
                            {
                                cLog.info((("Could not explore " + _local_2) + ", because it is not reachable."));
                            }
                            else
                            {
                                if (this.GetSectorDiscovery(_local_2.GetSectorID()) != SECTOR_DISCOVERY_TYPE.UNEXPLORED)
                                {
                                    cLog.info(((("Could not explore " + _local_2) + ", because it's discovery type is ") + SECTOR_DISCOVERY_TYPE.toString(this.GetSectorDiscovery(_local_2.GetSectorID()))));
                                };
                            };
                        };
                    };
                };
            };
            return (_local_5);
        }

        public function GetPremiumExpireNotified():Number
        {
            return (this.mPremiumExpireNotified);
        }

        public function SetPvpModifier(_arg_1:int):void
        {
            this.mPvpModifier = _arg_1;
        }

        public function getGuildMaxSize():int
        {
            return (this.guildMaxSize);
        }

        public function GetColonyYieldBonus():int
        {
            return (this.GetBonusFromRequirements("ColonyYieldBonus"));
        }

        public function AddPrePlacesBuildingToList(_arg_1:cBuilding):void
        {
            this.mPrePlacedBuildingCounter_vector.push(_arg_1);
        }

        public function SetXPChanged():void
        {
            (this.mGeneralInterface as cGameInterface).ResetResourceViewUpdate();
            this.mXPChanged = true;
        }

        public function addBuff(_arg_1:cBuff):cBuff
        {
            var _local_3:cBuff;
            var _local_2:dBuffVO;
            if (((StringUtils.startsWith(_arg_1.GetType(), defines.ADD_RESOURCE_BUFF)) && (!(StringUtils.equalsCase(_arg_1.GetType(), defines.ADD_RESOURCE_BUFF)))))
            {
                _local_2 = _arg_1.CreateBuffVOFromBuff();
                _local_2.buffName_string = defines.ADD_RESOURCE_BUFF;
                _arg_1 = cBuff.CreateBuffFromVO(_local_2);
            }
            else
            {
                if (((StringUtils.startsWith(_arg_1.GetType(), defines.FILL_DEPOSIT_BUFF)) && (!(StringUtils.equalsCase(_arg_1.GetType(), defines.FILL_DEPOSIT_BUFF)))))
                {
                    _local_2 = _arg_1.CreateBuffVOFromBuff();
                    _local_2.buffName_string = defines.FILL_DEPOSIT_BUFF;
                    _arg_1 = cBuff.CreateBuffFromVO(_local_2);
                };
            };
            var _local_4:cBuff = this.getExistingBuffItem(_arg_1);
            if (_local_4 != null)
            {
                _local_4.SetAmount(IntegerUtils.addAndCheck(_local_4.GetAmount(), _arg_1.GetAmount()));
                _local_3 = _local_4;
            }
            else
            {
                this.mAvailableBuffs_vector.push(_arg_1);
                _local_3 = _arg_1;
            };
            this.resortBuffsForStarMenu = true;
            notifyPropertyObserver("mAvailableBuffs_vector", this.mAvailableBuffs_vector);
            notifyPropertyObserver("mAvailableBuffs_vector#added", _arg_1);
            notifyPropertyObserver(TriggerUtils.STAR_MENU_UPDATED_PROPERTY_NAME, _arg_1);
            return (_local_3);
        }

        public function SetPremiumUntil(_arg_1:Number):void
        {
            this.mPremiumUntil = _arg_1;
            notifyPropertyObserver("mPremiumAccountDuration", this);
        }

        public function updateGuild(_arg_1:dGuildVO):void
        {
            if (((!(_arg_1 == null)) && (_arg_1.id == this.guildID)))
            {
                this.guildMaxSize = _arg_1.maxSize;
            };
        }

        public function ClipToExpeditionLevelRange(_arg_1:int):int
        {
            return (int(Math.max(1, Math.min(130, _arg_1))));
        }

        public function IsMaximumBuildingCountReached(_arg_1:String):Boolean
        {
            var _local_2:int = this.mCurrentlyBuildingsCount[_arg_1];
            var _local_3:int = global.buildingGroup.GetNrFromName(_arg_1);
            var _local_4:int = global.buildingGroup.mGOList_vector[_local_3].mMaxBuildingLimit;
            if (_local_2 >= _local_4)
            {
                return (true);
            };
            if (((this.IsBuildingCounted(_arg_1)) && (this.mCurrentBuildingsCountAll >= this.mCurrentMaximumBuildingsCountAll)))
            {
                return (true);
            };
            return (false);
        }

        public function GetXP():int
        {
            return (this.mXP);
        }

        public function hasBuffByBuffVO(_arg_1:dBuffVO):Boolean
        {
            var _local_2:* = (!(this.getBuffByBuffVO(_arg_1) == null));
            this.mAvailableBuffsCurrentIndex = -1;
            return (_local_2);
        }

        private function IncreaseCityLevelHandler(_arg_1:int):void
        {
            var _local_4:cSector;
            var _local_2:Boolean = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RecalculateStreetVariations(_arg_1);
            var _local_3:Boolean;
            if (((!(this.mGeneralInterface.IsAdventureZone())) || (!(this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.useContinentalFog))))
            {
                for each (_local_4 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
                {
                    if (((_local_4.GetCityLevelAtWhichSectorIsActivated() > 0) && (_arg_1 >= _local_4.GetCityLevelAtWhichSectorIsActivated())))
                    {
                        this.mGeneralInterface.mCurrentPlayerZone.SetFogForSector(_local_4.GetSectorID());
                        this.SetSectorDiscovery(_local_4.GetSectorID(), SECTOR_DISCOVERY_TYPE.EXPLORED);
                        _local_3 = true;
                    };
                };
            };
            if (_local_3)
            {
                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CalculateBorders();
            };
            if (_local_2)
            {
                this.mGeneralInterface.mCurrentPlayerZone.SetBackgroundHasChanged(true);
            };
        }

        public function CheckXPChanged():Boolean
        {
            var _local_1:Boolean = this.mXPChanged;
            this.mXPChanged = false;
            return (_local_1);
        }

        public function SetAvatarId(_arg_1:int):void
        {
            this.mAvatarId = _arg_1;
        }

        public function SetColonySlotCountTemp(_arg_1:int):void
        {
            if (_arg_1 != this.GetColonySlotCountTemp())
            {
                this.mColonySlotCountTemp = Math.max(0, _arg_1);
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        public function GetMissingPvPXPForNextLevel():int
        {
            if (this.mPlayerPvPLevel == global.playerPvPLevels_vector.length)
            {
                return (-1);
            };
            return (global.playerPvPLevels_vector[this.mPlayerPvPLevel].pvpXp - this.mPlayerPvPXp);
        }

        public function IncBuildingCountAll(_arg_1:cBuilding, _arg_2:Boolean):void
        {
            if (_arg_1.getPlayerID() != this.GetPlayerId())
            {
                return;
            };
            if (_arg_1.mOrigin == cBuilding.BUILDING_ORIGIN_FROM_GAME)
            {
                if (this.IsBuildingCounted(_arg_1.GetBuildingName_string()))
                {
                    this.mCurrentBuildingsCountAll++;
                    if (((this.mCurrentMaximumBuildingsCountAll == this.mCurrentBuildingsCountAll) && (_arg_2)))
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.LAST_BUILDING_LICENSE_USED);
                    };
                    if (_arg_2)
                    {
                        globalFlash.gui.mInfoBar.SetBuildingsCount(this.mCurrentBuildingsCountAll, this.mCurrentMaximumBuildingsCountAll);
                    };
                };
            };
        }

        public function IncSpecialistAmount(_arg_1:int):void
        {
            switch (_arg_1)
            {
                case SPECIALIST_TYPE.ADMIRAL:
                    this.mAdmiralAmount++;
                    break;
                case SPECIALIST_TYPE.GENERAL:
                    this.mGeneralsAmount++;
                    break;
                case SPECIALIST_TYPE.EXPLORER:
                    this.mExplorersAmount++;
                    break;
                case SPECIALIST_TYPE.GEOLOGIST:
                    this.mGeologistsAmount++;
                    break;
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function GetSectorDiscovery(_arg_1:int):int
        {
            var _local_2:int = SECTOR_DISCOVERY_TYPE.UNEXPLORED;
            if (_arg_1 < this.mDiscoveredSector_vector.length)
            {
                _local_2 = this.mDiscoveredSector_vector[_arg_1].GetDiscoveryType();
            };
            return (_local_2);
        }

        public function GetLastUpdate():Number
        {
            return (this.mLastUpdate);
        }

        public function getOwnerID():dUniqueID
        {
            return (null);
        }

        public function getSkillTree():cSkillTree
        {
            return (null);
        }

        public function set mIsColony(_arg_1:Boolean):void
        {
            var _local_2:Object = this._60205487mIsColony;
            if (_local_2 !== _arg_1)
            {
                this._60205487mIsColony = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mIsColony", _local_2, _arg_1));
            };
        }

        public function ClearSectorDiscoveryDirty(_arg_1:int):void
        {
            if (_arg_1 < this.mDiscoveredSector_vector.length)
            {
                this.mDiscoveredSector_vector[_arg_1].mDirtyIndicator = DIRTY_INDICATOR.CLEAN;
            };
        }

        public function SetLastUpdate(_arg_1:Number):void
        {
            this.mLastUpdate = _arg_1;
        }

        public function WillLevelUp(_arg_1:int):Boolean
        {
            if (this.mPlayerLevel == global.playerLevels_vector.length)
            {
                return (false);
            };
            return (global.playerLevels_vector[this.mPlayerLevel] <= (this.mXP + _arg_1));
        }

        public function SetPlayerName(_arg_1:String):void
        {
            this.mPlayerName_string = _arg_1;
        }

        public function GetSectorsAmount():int
        {
            return (this.mDiscoveredSector_vector.length);
        }

        public function SetClaimedPvPLevel(_arg_1:int):void
        {
            if (_arg_1 != this.mClaimedPvpLevel)
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                this.mClaimedPvpLevel = _arg_1;
            };
        }

        public function invalidatePlayerListItem():void
        {
            this.mPlayerListItem = null;
        }

        public function GetPremiumDuration():Number
        {
            var _local_1:Number = (this.mPremiumUntil - gMisc.GetEpochMillis());
            if (_local_1 < 0)
            {
                _local_1 = 0;
            };
            return (_local_1);
        }

        public function GetTimeSinceLastPurchased(_arg_1:int):Number
        {
            var _local_3:dPurchasedShopItemVO;
            var _local_2:Number = 0;
            for each (_local_3 in this.mPurchasedShopItems_vector)
            {
                if (_local_3.shopItemID == _arg_1)
                {
                    if (_local_3.timeOfPurchase > _local_2)
                    {
                        _local_2 = _local_3.timeOfPurchase;
                    };
                };
            };
            return ((TimeUtil.getServerTime() - _local_2) / 60000);
        }

        public function RemovePrePlacesBuildingToList(_arg_1:cBuilding):void
        {
            var _local_2:int;
            while (_local_2 < this.mPrePlacedBuildingCounter_vector.length)
            {
                if (_arg_1 == this.mPrePlacedBuildingCounter_vector[_local_2])
                {
                    this.mPrePlacedBuildingCounter_vector.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function SetColonySlotCountPermanent(_arg_1:int):void
        {
            if (_arg_1 != this.GetColonySlotCountPermanent())
            {
                this.mColonySlotCountPermanent = Math.max(0, _arg_1);
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        public function SetPvPLevel(_arg_1:int):void
        {
            this.mPlayerPvPLevel = _arg_1;
            notifyPropertyObserver(PLAYER_PVP_LEVEL_CHANGED, _arg_1);
        }

        public function GetRefundResourcesByReturnRate(_arg_1:String):Vector.<dResource>
        {
            var _local_5:dResource;
            var _local_6:dResource;
            var _local_2:int = ((this.mGeneralInterface.mIsDefenseMode) ? 100 : global.returnRate);
            var _local_3:Vector.<dResource> = global.buildingGroup.GetCostListFromName_vector(_arg_1);
            var _local_4:Vector.<dResource> = new Vector.<dResource>();
            if (_local_3 == null)
            {
                return (_local_4);
            };
            for each (_local_5 in _local_3)
            {
                _local_6 = new dResource();
                _local_6.amount = ((_local_5.amount * _local_2) / 100);
                _local_6.group_string = _local_5.group_string;
                _local_6.maxLimit = _local_5.maxLimit;
                _local_6.name_string = _local_5.name_string;
                _local_4.push(_local_6);
            };
            return (_local_4);
        }

        public function getName(_arg_1:Boolean):String
        {
            return ("");
        }

        public function SetPremiumExpireNotified(_arg_1:Number):void
        {
            this.mPremiumExpireNotified = _arg_1;
        }

        public function InitMaxBuildingCount(_arg_1:int):void
        {
            this.mCurrentMaximumBuildingsCountAll = _arg_1;
        }

        public function DecBuildingAll(_arg_1:cBuilding):void
        {
            if (_arg_1.getPlayerID() != this.GetPlayerId())
            {
                return;
            };
            if (_arg_1.mOrigin == cBuilding.BUILDING_ORIGIN_FROM_GAME)
            {
                if (this.IsBuildingCounted(_arg_1.GetBuildingName_string()))
                {
                    this.mCurrentBuildingsCountAll--;
                    if (globalFlash.gui.mInfoBar != null)
                    {
                        globalFlash.gui.mInfoBar.SetBuildingsCount(this.mCurrentBuildingsCountAll, this.mCurrentMaximumBuildingsCountAll);
                    };
                };
            };
        }

        [Bindable(event="propertyChange")]
        public function get mIsDefenseMode():Boolean
        {
            return (this._625721612mIsDefenseMode);
        }

        public function GetMaxBuildingCount():int
        {
            return (this.mCurrentMaximumBuildingsCountAll);
        }

        public function SetUniqueID(_arg_1:dUniqueID):void
        {
            this.mUnique = _arg_1;
        }

        public function GetPvpModifier():int
        {
            return (this.mPvpModifier);
        }

        public function getNotifier():Notifier
        {
            return (this);
        }

        public function GetColonySlotCountUsed():int
        {
            var _local_2:ColonyVO;
            var _local_1:int;
            for each (_local_2 in (this.mGeneralInterface as cGameInterface).mCurrentPlayerZone.ColonyGetAll())
            {
                if (((cColony.IsAssignedState(_local_2.state)) || (cColony.IsUnderAttackState(_local_2.state))))
                {
                    _local_1++;
                };
            };
            return (_local_1);
        }

        public function resetLastFetchedBuff():void
        {
            this.mAvailableBuffsCurrentIndex = -1;
            this.resortBuffsForStarMenu = true;
        }

        public function GetBuildingCount(_arg_1:String):int
        {
            return (this.mCurrentlyBuildingsCount[_arg_1]);
        }

        public function GetBonusValidXP():int
        {
            return (this.mBonusValidXP);
        }

        public function GetPurchasedShopItemAmount(_arg_1:int):int
        {
            var _local_3:dPurchasedShopItemVO;
            var _local_2:int;
            for each (_local_3 in this.mPurchasedShopItems_vector)
            {
                if (((_local_3.shopItemID == _arg_1) && (_local_3.giftedToPlayerId == 0)))
                {
                    _local_2++;
                };
            };
            return (_local_2);
        }

        public function GetPrePlacesBuildingCounter():int
        {
            return (this.mPrePlacedBuildingCounter_vector.length);
        }

        public function GetPlayerId():int
        {
            return (this.mPlayerId);
        }

        public function GetColonySlotCountTemp():int
        {
            return (this.mColonySlotCountTemp);
        }

        public function replaceBuff(_arg_1:dUniqueID):void
        {
            var _local_2:cBuff;
            var _local_3:int;
            while (_local_3 < this.mAvailableBuffs_vector.length)
            {
                if (this.mAvailableBuffs_vector[_local_3].GetUniqueId().equals(_arg_1))
                {
                    if (_local_2 != null)
                    {
                        notifyPropertyObserver("mAvailableBuffs_vector#removed", this.mAvailableBuffs_vector[_local_3]);
                        this.mAvailableBuffs_vector[_local_3] = _local_2;
                        notifyPropertyObserver("mAvailableBuffs_vector#added", _local_2);
                    }
                    else
                    {
                        notifyPropertyObserver("mAvailableBuffs_vector#removed", this.mAvailableBuffs_vector[_local_3]);
                        this.mAvailableBuffs_vector.splice(_local_3, 1);
                    };
                    notifyPropertyObserver("mAvailableBuffs_vector", this.mAvailableBuffs_vector);
                    this.resortBuffsForStarMenu = true;
                    return;
                };
                _local_3++;
            };
        }

        public function Init(_arg_1:int):void
        {
            this.mPlayerState = PLAYER_STATE_START_GAME;
            if (global.playerInitialLevel <= global.playerLevels_vector.length)
            {
                this.mXP = global.playerLevels_vector[(global.playerInitialLevel - 1)];
            }
            else
            {
                this.mXP = global.playerLevels_vector[(global.playerLevels_vector.length - 1)];
            };
            this.mXPChanged = true;
            this.SetPlayerLevel(global.playerInitialLevel);
            this.mCurrentMaximumBuildingsCountAll = global.defaultMaximumBuildingsCountAll;
            var _local_2:int;
            var _local_3:int;
            while (_local_3 < global.cityLevels_vector.length)
            {
                if (global.cityLevels_vector[_local_3] <= this.mXP)
                {
                    _local_2 = (_local_3 + 1);
                }
                else
                {
                    break;
                };
                _local_3++;
            };
            this.mCityLevel = _local_2;
        }

        public function getSkills():cSkillList
        {
            if (this.skills == null)
            {
                this.skills = new cSkillList(this.mGeneralInterface);
            };
            return (this.skills);
        }

        public function AddXP(_arg_1:int):int
        {
            var _local_2:int;
            if (_arg_1 == 0)
            {
                return (_local_2);
            };
            if (((this.mXP == 0) && (!(this.GetHomeZoneId() == this.mGeneralInterface.mCurrentViewedZoneID))))
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            this.mXPChanged = true;
            this.mXP = (this.mXP + _arg_1);
            var _local_3:int = this.mPlayerLevel;
            var _local_4:int = this.mPlayerLevel;
            while (((_local_3 < global.playerLevels_vector.length) && (this.mXP >= global.playerLevels_vector[_local_3])))
            {
                this.SetPlayerLevel(++_local_3);
            };
            this.mPlayerListItem = null;
            if (_local_3 == global.playerLevels_vector.length)
            {
                _local_2 = (this.mXP - global.playerLevels_vector[(_local_3 - 1)]);
                this.mXP = global.playerLevels_vector[(_local_3 - 1)];
            };
            if (!this.mGeneralInterface.IsAdventureZoneID(this.mGeneralInterface.mHomePlayer.GetPlayerId()))
            {
                if (_local_4 != this.mPlayerLevel)
                {
                    TrackManager.getInstance().trackLevelUp(this, ("Zone: " + this.mGeneralInterface.mCurrentViewedZoneID), 0);
                };
            };
            _local_3 = 0;
            var _local_5:int;
            while (_local_5 < global.cityLevels_vector.length)
            {
                if (global.cityLevels_vector[_local_5] <= this.mXP)
                {
                    _local_3 = (((_local_5 + 1) == global.cityLevels_vector.length) ? _local_5 : (_local_5 + 1));
                }
                else
                {
                    break;
                };
                _local_5++;
            };
            if (_local_3 > this.mCityLevel)
            {
                this.IncreaseCityLevelHandler(_local_3);
            };
            this.mCityLevel = _local_3;
            return (_local_2);
        }

        public function resetHelp():void
        {
            this.mHideHelp = false;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            this.mKnownHelp_vector = new Vector.<String>();
        }

        public function setSkillTree(_arg_1:cSkillTree):void
        {
        }

        public function removeLastFetchedBuff():void
        {
            var _local_1:cBuff;
            var _local_2:int;
            var _local_3:int;
            if (this.mAvailableBuffsCurrentIndex != -1)
            {
                _local_1 = this.mAvailableBuffs_vector[this.mAvailableBuffsCurrentIndex];
                _local_2 = _local_1.GetAmount();
                _local_3 = 1;
                if (_local_2 > _local_3)
                {
                    _local_1.SetAmount((_local_2 - _local_3));
                }
                else
                {
                    _local_1.SetAmount(0);
                    this.mAvailableBuffs_vector.splice(this.mAvailableBuffsCurrentIndex, 1);
                };
                this.resortBuffsForStarMenu = true;
                notifyPropertyObserver("mAvailableBuffs_vector", this.mAvailableBuffs_vector);
                notifyPropertyObserver("mAvailableBuffs_vector#removed", _local_1);
            };
        }

        public function GetNewUniqueID():dUniqueID
        {
            this.mUnique.uniqueID1++;
            if (this.mUnique.uniqueID1 < 0)
            {
                this.mUnique.uniqueID1 = 0;
                this.mUnique.uniqueID2++;
            };
            var _local_1:dUniqueID = new dUniqueID();
            _local_1.uniqueID1 = this.mUnique.uniqueID1;
            _local_1.uniqueID2 = this.mUnique.uniqueID2;
            cLog.info(("Created new unique ID: " + _local_1));
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            return (_local_1);
        }

        public function set mIsAdventureZone(_arg_1:Boolean):void
        {
            var _local_2:Object = this._1900481957mIsAdventureZone;
            if (_local_2 !== _arg_1)
            {
                this._1900481957mIsAdventureZone = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mIsAdventureZone", _local_2, _arg_1));
            };
        }

        public function GetSectorsDiscAmount():int
        {
            var _local_2:cSectorDiscovery;
            var _local_1:int;
            for each (_local_2 in this.mDiscoveredSector_vector)
            {
                if (SECTOR_DISCOVERY_TYPE.isExplored(_local_2.GetDiscoveryType()))
                {
                    _local_1++;
                };
            };
            return (_local_1);
        }

        public function forceResortBuffsForStarMenu():void
        {
            this.resortBuffsForStarMenu = true;
        }

        public function InitBaseData(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int, _arg_9:int, _arg_10:int, _arg_11:int, _arg_12:dUniqueID, _arg_13:Boolean, _arg_14:int, _arg_15:int, _arg_16:int, _arg_17:int, _arg_18:int, _arg_19:int, _arg_20:int, _arg_21:int, _arg_22:ArrayCollection, _arg_23:Boolean):cPlayerData
        {
            this.mPlayerId = _arg_1;
            this.mPlayerName_string = _arg_2;
            this.mXP = _arg_3;
            this.mBonusValidXP = _arg_4;
            this.SetPlayerLevel(_arg_5);
            this.mCityLevel = _arg_6;
            this.mPlayerPvPXp = _arg_7;
            this.mPlayerPvPLevel = _arg_8;
            this.mClaimedPvpLevel = _arg_9;
            this.mPvpModifier = _arg_10;
            this.mAvatarId = _arg_11;
            this.mUnique = _arg_12;
            this.mPlayerCanCheat = _arg_13;
            this.mAdmiralAmount = _arg_14;
            this.mGeneralsAmount = _arg_15;
            this.mExplorersAmount = _arg_16;
            this.mBlackMarketUnlocked = _arg_23;
            this.mGeologistsAmount = _arg_17;
            this.mCurrentMaximumBuildingsCountAll = _arg_18;
            this.mPermanentBuildQueueSlotsCount = _arg_19;
            this.mColonySlotCountPermanent = _arg_20;
            this.mColonySlotCountTemp = _arg_21;
            this.resetHelp();
            this.skills = new cSkillList(this.mGeneralInterface);
            this.skills.init(_arg_22, this, this.mGeneralInterface);
            return (this);
        }

        public function getBuffByBuffVO(_arg_1:dBuffVO):cBuff
        {
            var _local_4:cBuff;
            this.mAvailableBuffsCurrentIndex = -1;
            var _local_2:int = this.mAvailableBuffs_vector.length;
            var _local_3:int;
            for (;_local_3 < _local_2;_local_3++)
            {
                _local_4 = this.mAvailableBuffs_vector[_local_3];
                if (_local_4.GetType() == _arg_1.buffName_string)
                {
                    if (!((((!(_local_4.GetType().indexOf(defines.LOOTTABLE_BUFF) == 0)) && (!(_local_4.GetResourceName_string() == null))) && ((!(_local_4.GetResourceName_string() == "")) || (_local_4.GetType() == defines.FILL_DEPOSIT_BUFF))) && (!(_local_4.GetResourceName_string() == _arg_1.resourceName_string))))
                    {
                        if (!_local_4.isDeleted())
                        {
                            if ((((_local_4.GetType().indexOf(defines.ADD_RESOURCE_BUFF) == 0) || (_local_4.GetType().indexOf(defines.FILL_DEPOSIT_BUFF) == 0)) || (_local_4.GetType().indexOf(defines.HIRED_MILITARY_BUFF) == 0)))
                            {
                                if (_local_4.GetAmount() < _arg_1.amount) continue;
                            }
                            else
                            {
                                if (_local_4.GetAmount() < _arg_1.amount) continue;
                            };
                            this.mAvailableBuffsCurrentIndex = _local_3;
                            return (_local_4);
                        };
                    };
                };
            };
            return (null);
        }

        public function GetPlayerPvPLevel():int
        {
            return (this.mPlayerPvPLevel);
        }

        public function IncPermanentBuildSlotsAvailable(_arg_1:int):void
        {
            this.mPermanentBuildQueueSlotsCount = (this.mPermanentBuildQueueSlotsCount + _arg_1);
            this.mBuildQueue.ReadjustGridPositionsOfTempSlotsFrom(-1);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            this.mBuildQueue.UpdateGUI();
        }

        public function getPlayerID():int
        {
            return (this.mPlayerId);
        }

        public function GetClaimedPvPLevel():int
        {
            return (this.mClaimedPvpLevel);
        }

        public function SetPlayerLevel(_arg_1:int):void
        {
            this.mPlayerLevel = _arg_1;
            notifyPropertyObserver(PLAYER_LEVEL_CHANGED, _arg_1);
            if (this.mGeneralInterface != null)
            {
                this.mGeneralInterface.channels.ZONE.levelup();
            };
            dispatchEvent(new Event("levelChanged"));
        }

        public function addKnownHelp(_arg_1:String):void
        {
            this.mKnownHelp_vector.push(_arg_1);
        }

        public function GetHomeZoneId():int
        {
            return (this.mPlayerId);
        }

        public function setGuildID(_arg_1:int):void
        {
            this.guildID = _arg_1;
        }

        public function setGuildMaxSize(_arg_1:int):void
        {
            this.guildMaxSize = _arg_1;
        }

        public function IncMaxBuildingCount(_arg_1:int):void
        {
            this.mCurrentMaximumBuildingsCountAll = (this.mCurrentMaximumBuildingsCountAll + _arg_1);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function InitSectorDiscovery(_arg_1:ArrayCollection):void
        {
            var _local_2:dSectorDiscoveryVO;
            for each (_local_2 in _arg_1)
            {
                this.SetSectorDiscovery(_local_2.sectorID, _local_2.discoveryType);
                this.ClearSectorDiscoveryDirty(_local_2.sectorID);
            };
            notifyPropertyObserver("mDiscoveredSector_vector", this.mDiscoveredSector_vector);
        }

        public function getAvailableBuffs_vector():Vector.<cBuff>
        {
            return (this.mAvailableBuffs_vector);
        }

        public function GetPremiumUntil():Number
        {
            return (this.mPremiumUntil);
        }

        [Bindable(event="propertyChange")]
        public function get mIsAdventureZone():Boolean
        {
            return (this._1900481957mIsAdventureZone);
        }

        public function AddPvPXp(_arg_1:int):void
        {
            this.mPlayerPvPXp = (this.mPlayerPvPXp + _arg_1);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            var _local_2:int = this.mPlayerPvPLevel;
            var _local_3:int = _local_2;
            while (((_local_2 < global.playerPvPLevels_vector.length) && (this.mPlayerPvPXp >= global.playerPvPLevels_vector[_local_2].pvpXp)))
            {
                this.SetPvPLevel(++_local_2);
            };
            if (!this.mGeneralInterface.IsAdventureZoneID(this.mGeneralInterface.mHomePlayer.GetPlayerId()))
            {
                if (_local_3 != this.mPlayerPvPLevel)
                {
                    TrackManager.getInstance().trackPvpLevelUp(this, this.mPlayerPvPLevel);
                };
            };
            if (_local_2 == global.playerPvPLevels_vector.length)
            {
                this.mPlayerPvPXp = global.playerPvPLevels_vector[(_local_2 - 1)].pvpXp;
            };
        }

        public function GetAvatarId():int
        {
            return (this.mAvatarId);
        }

        public function IncBuildingCount(_arg_1:cBuilding):void
        {
            if (_arg_1.getPlayerID() != this.GetPlayerId())
            {
                return;
            };
            var _local_2:String = _arg_1.GetBuildingName_string();
            if (isNaN(this.mCurrentlyBuildingsCount[_local_2]))
            {
                this.mCurrentlyBuildingsCount[_local_2] = 0;
            };
            this.mCurrentlyBuildingsCount[_local_2] = (this.mCurrentlyBuildingsCount[_local_2] + 1);
            this.mGeneralInterface.channels.ZONE.send(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, _local_2);
            notifyPropertyObserver(defines.NOTIFIER_BUILDING_READY, _arg_1);
        }

        public function GetPlayerListItem():dPlayerListItemVO
        {
            if (this.mPlayerListItem != null)
            {
                return (this.mPlayerListItem);
            };
            this.mPlayerListItem = new dPlayerListItemVO();
            this.mPlayerListItem.id = this.GetPlayerId();
            this.mPlayerListItem.avatarId = this.GetAvatarId();
            this.mPlayerListItem.username = this.GetPlayerName_string();
            this.mPlayerListItem.playerLevel = this.GetPlayerLevel();
            return (this.mPlayerListItem);
        }

        public function setSectorDiscoveryFromList(_arg_1:ArrayCollection):void
        {
            var _local_2:cSectorDiscovery;
            for each (_local_2 in _arg_1)
            {
                this.SetSectorDiscovery(_local_2.GetSectorID(), _local_2.GetDiscoveryType());
                this.ClearSectorDiscoveryDirty(_local_2.GetSectorID());
            };
            notifyPropertyObserver("mDiscoveredSector_vector", this.mDiscoveredSector_vector);
        }

        public function GetPurchasedDuringEvent(_arg_1:int, _arg_2:String):int
        {
            var _local_6:dPurchasedShopItemVO;
            if (_arg_2 == "")
            {
                return (0);
            };
            var _local_3:int;
            var _local_4:Number = this.mGeneralInterface.mEventManager.GetEventStartDate(_arg_2);
            var _local_5:Number = this.mGeneralInterface.mEventManager.GetEventStopDate(_arg_2);
            for each (_local_6 in this.mPurchasedShopItems_vector)
            {
                if (((((_local_6.shopItemID == _arg_1) && (_local_6.giftedToPlayerId == 0)) && (_local_6.timeOfPurchase >= _local_4)) && (_local_6.timeOfPurchase <= _local_5)))
                {
                    _local_3++;
                };
            };
            return (_local_3);
        }

        public function GetPermanentBuildQueueSlotsCount():int
        {
            return (this.mPermanentBuildQueueSlotsCount);
        }

        public function ChangeAvatarIdBy(_arg_1:int):void
        {
            this.mAvatarId = (this.mAvatarId + _arg_1);
            this.mAvatarPictureDirtyIndicator = (this.mAvatarPictureDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            this.mPlayerListItem = null;
        }

        public function GetSectorDiscoveries_vector():Vector.<cSectorDiscovery>
        {
            return (this.mDiscoveredSector_vector);
        }

        public function SetPlayerCanCheat(_arg_1:Boolean):void
        {
            this.mPlayerCanCheat = _arg_1;
        }

        public function ActivatePremiumAccount(_arg_1:Number, _arg_2:Number):void
        {
            var _local_4:dTempBuildSlotVO;
            this.SetPremiumUntil(_arg_2);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            var _local_3:dTempBuildSlotVO;
            for each (_local_4 in this.mAvailableTempSlots_vector)
            {
                if (_local_4.isPremiumSlot())
                {
                    _local_3 = _local_4;
                    _local_3.dirtyIndicator = DIRTY_INDICATOR.MODIFIED_BIT;
                    _local_3.expireAt = _arg_2;
                    this.mBuildQueue.updateTempSlots();
                    break;
                };
            };
            if (_local_3 == null)
            {
                _local_3 = new dTempBuildSlotVO();
                _local_3.timeOfPurchase = _arg_1;
                _local_3.dirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
                _local_3.expireAt = _arg_2;
                this.mAvailableTempSlots_vector.push(_local_3);
                this.mBuildQueue.updateTempSlots();
            };
        }

        public function getBuffByUniqueID(_arg_1:dUniqueID):cBuff
        {
            this.mAvailableBuffsCurrentIndex = -1;
            var _local_2:int = this.mAvailableBuffs_vector.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                if (this.mAvailableBuffs_vector[_local_3].GetUniqueId().equals(_arg_1))
                {
                    this.mAvailableBuffsCurrentIndex = _local_3;
                    return (this.mAvailableBuffs_vector[_local_3]);
                };
                _local_3++;
            };
            return (null);
        }

        public function GetMaxXP():int
        {
            return (global.playerLevels_vector[(global.playerLevels_vector.length - 1)]);
        }

        public function UpdateGridPositionForAvailableTempSlotsWith(_arg_1:Number, _arg_2:int):void
        {
            var _local_3:int;
            while (_local_3 < this.mAvailableTempSlots_vector.length)
            {
                if (this.mAvailableTempSlots_vector[_local_3].timeOfPurchase == _arg_1)
                {
                    this.mAvailableTempSlots_vector[_local_3].buildingGridPos = _arg_2;
                    return;
                };
                _local_3++;
            };
        }

        public function GetColonySlotCount():int
        {
            return ((this.GetColonySlotCountMax() + this.GetColonySlotCountTemp()) + this.GetColonySlotCountPermanent());
        }

        public function SetPlayerLevelHomeZone(_arg_1:int):void
        {
            this.mPlayerLevelHomeZone = _arg_1;
        }

        public function RefreshBuildingList():void
        {
            var _local_1:cBuilding;
            pauseNotifications();
            this.mPrePlacedBuildingCounter_vector.length = 0;
            this.mCurrentBuildingsCountAll = 0;
            this.mCurrentlyBuildingsCount = new Dictionary();
            for each (_local_1 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if (null != _local_1)
                {
                    if (_local_1.getPlayerID() == -1)
                    {
                        this.IncAnyBuildingCount(_local_1);
                    }
                    else
                    {
                        if (_local_1.getPlayerID() == this.GetPlayerId())
                        {
                            if (_local_1.GetBuildingMode() >= cBuilding.BUILDING_MODE_QUEUED)
                            {
                                this.IncBuildingCountAll(_local_1, false);
                            };
                            if (_local_1.GetBuildingMode() >= cBuilding.BUILDING_MODE_BUILDING_IS_ACTIVE_MIN)
                            {
                                this.IncBuildingCount(_local_1);
                            };
                            if (_local_1.GetBuildingMode() == cBuilding.BUILDING_MODE_PLACED)
                            {
                                this.AddPrePlacesBuildingToList(_local_1);
                            };
                        }
                        else
                        {
                            if (_local_1.getPlayerID() == 0)
                            {
                                this.IncAnyBuildingCount(_local_1);
                            };
                        };
                    };
                };
            };
            resumeNotifications();
        }

        public function getOwnerType():int
        {
            return (SKILL_OWNER.PLAYER);
        }

        public function getPlayerCanCheat():Boolean
        {
            return (this.mPlayerCanCheat);
        }

        public function GetMaxPvPXP():int
        {
            return (global.playerPvPLevels_vector[(global.playerPvPLevels_vector.length - 1)].pvpXp);
        }

        public function GetColonySlotCountMax():int
        {
            return (this.GetBonusFromRequirements("ColonySlots"));
        }

        public function removeBuffFromVector(_arg_1:dUniqueID):void
        {
            var _local_2:int;
            while (_local_2 < this.mAvailableBuffs_vector.length)
            {
                if (this.mAvailableBuffs_vector[_local_2].GetUniqueId().equals(_arg_1))
                {
                    this.mAvailableBuffs_vector.splice(_local_2, 1);
                    if (this.mAvailableBuffsCurrentIndex == _local_2)
                    {
                        this.resetLastFetchedBuff();
                    }
                    else
                    {
                        if (this.mAvailableBuffsCurrentIndex > _local_2)
                        {
                            this.mAvailableBuffsCurrentIndex--;
                        };
                    };
                };
                _local_2++;
            };
            this.resortBuffsForStarMenu = true;
        }

        public function GetColonySlotCountPermanent():int
        {
            return (this.mColonySlotCountPermanent);
        }

        public function GetColonySlotCountTempMax():int
        {
            return (this.GetBonusFromRequirements("ColonySlotsTempAmount"));
        }

        public function GetMissingXPForNextLevel():int
        {
            if (this.mPlayerLevel == global.playerLevels_vector.length)
            {
                return (-1);
            };
            return (global.playerLevels_vector[this.mPlayerLevel] - this.mXP);
        }

        public function GetPurchasedInVoteRound(_arg_1:int):int
        {
            var _local_4:dPurchasedShopItemVO;
            var _local_2:int;
            var _local_3:Number = this.mGeneralInterface.mVotesManager.GetPlayerVote().batchStartTime;
            for each (_local_4 in this.mPurchasedShopItems_vector)
            {
                if ((((_local_4.shopItemID == _arg_1) && (_local_4.giftedToPlayerId == 0)) && (_local_4.timeOfPurchase >= _local_3)))
                {
                    _local_2++;
                };
            };
            return (_local_2);
        }

        public function AddBonusValidXP(_arg_1:int):void
        {
            this.mBonusValidXP = (this.mBonusValidXP + _arg_1);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function IsBuildingCounted(_arg_1:String):Boolean
        {
            return (!(global.buildingDefaultParameterDoNotCountList_dictionary.Contains(_arg_1)));
        }

        public function DecBuildingCount(_arg_1:cBuilding):void
        {
            if (_arg_1.getPlayerID() != this.GetPlayerId())
            {
                return;
            };
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mCurrentlyBuildingsCount[_local_2]--;
            this.mGeneralInterface.channels.ZONE.send(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, _local_2);
        }

        public function GetBuildingCountType(_arg_1:String):int
        {
            var _local_3:cBuilding;
            var _local_2:int;
            for each (_local_3 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if (((!(null == _local_3)) && (_local_3.ui == _arg_1)))
                {
                    _local_2++;
                };
            };
            return (_local_2);
        }


    }
}
