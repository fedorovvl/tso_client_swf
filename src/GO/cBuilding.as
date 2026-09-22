package GO
{
    import MilitarySystem.iMilitaryUnitHolder;
    import Modifier.Modifieable;
    import MilitarySystem.cSpecialCombatPreview;
    import nLib.cSpriteLib;
    import ServerState.cPlayerData;
    import BuffSystem.BuffAppliance;
    import GOSets.cGOSetList;
    import ServerState.cResourceCreation;
    import MilitarySystem.cArmy;
    import TimedProduction.cTimedProductionQueue;
    import __AS3__.vec.Vector;
    import ServerOnly.DirtyIndicator;
    import Communication.VO.dUniqueID;
    import Enums.RENDER_LAYER;
    import Enums.ARMY_OWNER_TYPE;
    import Interface.cGeneralInterface;
    import Enums.OBJECTTYPE;
    import Utils.StringUtils;
    import Enums.COOLDOWN_TYPE;
    import converted.bluebyte.tso.cooldown.CultureBuildingCooldownTimeBonusProvider;
    import GO.buildings.AirshipBuilding;
    import Collections.CollectionsManager;
    import GO.buildings.CollectibleBuildingNormal;
    import GO.buildings.CollectibleEventBuilding;
    import EpicWorkyard.EpicWorkyardsManager;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import GO.epicWorkyard.EpicWorkyardMasterBuilding;
    import GO.buildings.DestroyOnClickBuilding;
    import GO.buildings.FloatingBuilding;
    import nLib.gMisc;
    import BuffSystem.cBuffDefinition;
    import ServerState.dResource;
    import Specialists.cSpecialist;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.SPECIALIST_TYPE;
    import Enums.AVATAR_MESSAGE_TYPE;
    import GOSets.cGOSetManager;
    import Enums.BUFF_APPLIANCE_MODE;
    import GUI.Assets.gAssetManager;
    import nLib.cLog;
    import nLib.cBackbuffer;
    import ServerState.cResources;
    import Enums.ModifyReason;
    import MilitarySystem.cSquad;
    import nLib.cSpriteLibContainer;
    import Enums.RENDER_ORDER;
    import Communication.VO.dSquadVO;
    import Communication.VO.dBuildingVO;
    import mx.events.PropertyChangeEvent;
    import Communication.VO.dServerAction;
    import Enums.COMMAND;
    import Utils.ModifiableCost;
    import Communication.VO.EffectVO;
    import Enums.BUFF_TYPE;
    import Enums.HALLOWEEN_EVENT;
    import Collections.CollectionsConsts;
    import Enums.BUFF_PARAMETER_NAME;
    import Enums.DIRTY_INDICATOR;
    import Effects.Effects.AvatarMessage;
    import ServerState.cComputeResourceCreation;
    import BuffSystem.cBuff;
    import Modifier.ModifierVO;
    import Enums.CAMP_TYPE;
    import ServerState.dResourceDefaultDefinition;
    import ServerState.dExpandMaxLimit;
    import ServerState.gEconomics;
    import Enums.CURSOR_PLACABLE;
    import Effects.EffectFactory;
    import Interface.cGameInterface;
    import Effects.Effects.ChangeDefaultSkin;
    import Communication.VO.dBuffApplianceVO;
    import Communication.VO.dPersistedBuffApplianceVO;
    import mx.collections.ArrayCollection;
    import Modifier.Modifier;
    import Enums.CURSOR_RENDERMODE;
    import Enums.RENDER_MODE;
    import GOSets.cGOSetListControllerPercentage;
    import Enums.GO_SUBTYPE;
    import Sound.cSoundManager;
    import flash.display.BlendMode;
    import Enums.FILTER;
    import Map.AdditionalDataTSO;
    import PathFinding.cPathObject;
    import Skill.cSkill;
    import PathFinding.cPathFinder;
    import Modifier.Modifiers.Deposit.SpeedUp;
    import Modifier.Modifiers.Productions.ResourceProductionSpeedUp;
    import SettlerKI.cSettlerKI;
    import __AS3__.vec.*;

    public class cBuilding extends cIsoGO implements iMilitaryUnitHolder, Modifieable 
    {

        public static const DAMAGE_LEVEL_AMOUNT:int = 10;
        public static const BUILDING_MODE_NONE:int = 0;
        public static const BUILDING_MODE_QUEUED:int = 1;
        public static const BUILDING_MODE_SET_BUILDING_GROUND_PLACE:int = 2;
        public static const BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE:int = 3;
        public static const BUILDING_MODE_CONSTRUCTION:int = 4;
        public static const BUILDING_MODE_DESTRUCTION:int = 5;
        public static const BUILDING_MODE_DESTRUCTED:int = 6;
        public static const BUILDING_MODE_PLACED:int = 7;
        public static const BUILDING_MODE_MOVING:int = 8;
        public static const BUILDING_MOVE_WITH_RESOURCE:int = 9;
        public static const BUILDING_MOVE_WITH_GEM:int = 10;
        public static const BUILDING_MODE_EPIC_MONSTER_DYING_EFFECT:int = 11;
        public static const BUILDING_DESTRUCTION_READY:int = 12;
        public static const MOUNTAIN_BLOWING_UP_STEP_1:int = 13;
        public static const MOUNTAIN_BLOWING_UP_STEP_2:int = 14;
        public static const MOUNTAIN_BLOWING_UP_STEP_3:int = 15;
        public static const MOUNTAIN_DESTROYED:int = 16;
        public static const BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:int = 20;
        public static const BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE:int = 21;
        public static const BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:int = 22;
        public static const BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_LOCAL_WORKYARD_SYSTEM:int = 23;
        public static const BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_EXTERNAL_WORKYARD_SYSTEM_ACTIVE:int = 24;
        public static const BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE:int = 25;
        public static const BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE:int = 26;
        public static const BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT:int = 27;
        public static const BUILDING_MODE_PRODUCES_NO_RESOURCES:int = 28;
        public static const BUILDING_MODE_BUILDING_IS_ACTIVE_MIN:int = BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE;//20
        public static const BUILDING_MODE_BUILDING_IS_IN_PRODUCTION_MIN:int = BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE;//21
        public static const BUILDING_ORIGIN_FROM_GAME:int = 0;
        public static const BUILDING_ORIGIN_FROM_BUFF:int = 1;
        public static const BUILDING_SELECTED_string:String = "buildingSelected";
        public static const BUILDING_DESTROYED_string:String = "buildingDestroyed";
        public static const BUILDING_UPGRADED_string:String = "buildingUpgraded";
        public static const BUILDING_DAMAGED_string:String = "buildingDamaged";
        public static const BUILDING_REMOVED_string:String = "buildingRemoved";
        public static const BUILDING_COMBATTOOLTIP_string:String = "buildingCombatTooltip";
        public static const PVP_PROGRESSION_BUILDING_string:String = "pvp_progression_building";
        public static const BUILDING_CATEGORY_GARRISON:String = "garrison";
        public static const BUILDING_INVALID_GRIDPOSOLD:int = -1;
        public static const COLLECTIBLE_BUILDING_WOBBLE_ICON_OFFSET:int = 30;
        public static const FLAG_BOUGHT:int = (1 << 0);
        public static const FLAG_ENGAGED_IN_COMBAT:int = (1 << 1);
        public static const FLAG_WAIT_FOR_COMMAND:int = (1 << 2);
        public static const FLAG_PRODUCTION_ACTIVE:int = (1 << 3);
        public static const FLAG_DEFENSE_BUILDING:int = (1 << 4);
        public static const FLAG_GARRISON_WAT_FOR_COMMAND:int = (1 << 5);
        public static const FLAG_MOVE_INITIATED:int = (1 << 6);
        public static const FLAG_UPGRADE_INITIATED:int = (1 << 7);
        public static const FLAG_DESTRUCTION_INITIATED:int = (1 << 8);
        public static const FLAG_UPGRADE_IN_PROGRESS:int = (1 << 9);
        public static const FLAG_UPGRADE_INITIATED_WITH_GEM:int = (1 << 10);
        public static const FLAG_INITIAL_SET_ON_MAP:int = (1 << 11);
        public static const FLAG_PREVENT_DELETION:int = (1 << 12);
        public static const FLAG_IS_LEADER:int = (1 << 13);
        public static const FLAG_IS_SPECIAL_UPGRADE_BUILDING:int = (1 << 14);
        public static const FLAG_HAS_LAYERS:int = (1 << 15);
        public static var REMOVE_SURPLUS_RESOURCES_ON_WAREHOUSE_DESTROY:Boolean = true;

        public var mSpecialCombatPreview:cSpecialCombatPreview = null;
        public var mOrigin:int = 0;
        private var mOverallTime:Number;
        public var mBuildingDestructionTime:Number = 0;
        private var _isSpecialUpgradeBuilding:Boolean = false;
        private var destroyedByPlayerID:int = 0;
        public var mIsSelectable:Boolean = true;
        private var mProgressTimeRemainingInMS:int = 0;
        public var waitForPickupSpriteIndex:int;
        private var mRecurringChance:int;
        private var mRecoveringHitPoints:int = 0;
        private var productionReadyAvatarType:String;
        private var mBuildingModeBeforeMoving:int = 0;
        public var mMoveMethod:int;
        public var mIsMouseOver:Boolean = false;
        private var mMaxHitPoints:int = 0;
        private var mSpriteWorkAnim:cSpriteLib = null;
        public var mStartWorkCounter:int;
        public var mPlayerData:cPlayerData;
        private var mBuildingSubMode:int = 0;
        public var renderAttackCursor:Boolean = false;
        public var buffMultiplier:int = 1;
        public var mIsDepositInfoShowing:Boolean = false;
        private var mSpecialUpgradeReady:Boolean = false;
        public var ui:String;
        public var productionBuff:BuffAppliance = null;
        public var waitForPickup:Boolean;
        private var mConstructionAnimEffectSet:cGOSetList = null;
        public var mWarningIsLeaderBanditCamp:Boolean;
        private var modified:Boolean;
        private var _2088099370mHealthBar:Number = 1;
        private var mProductionTime:Number;
        private var mWayWorkyardToDeposit:Number;
        protected var mOffsetX:int = 0;
        protected var mOffsetY:int = 0;
        private var mInterceptIndex:int = 0;
        private var mCampType:int = 0;
        private var mLastRepairTime:Number = 0;
        private var mBuildingInfoIconDelayEndTime:Number = -1;
        private var mDamageAnimEffectSet:cGOSetList = null;
        private var mProgressPercent:int = 0;
        public var mBuildingCreationTime:Number = 0;
        protected var mBuildingName_string:String = null;
        public var uiContent:int;
        private var mPlayerID:int = -1;
        public var mGoGroup:cGOGroup;
        public var mInstantUpgradeEnabled:Boolean = true;
        private var mCurrentDamageLevel:int;
        private var mCurrentHitPoints:int;
        private var _renderSpecialistName:String = null;
        private var skin:String = null;
        private var mBuildingMode:int = 0;
        public var mPreCombatTipType:String;
        public var mIsAreaBuffOver:Boolean = false;
        private var mFlagEffectSet:cGOSetList = null;
        private var mResourceCreation:cResourceCreation = null;
        private var _renderPlayerName:String = null;
        private var _1324158862mBuildingProgress:Number = 0;
        public var depletedMineExtension:String;
        private var mArmy:cArmy;
        public var productionType:int;
        private var _nextLabelUpdate:Number = 0;
        private var mBuffTwinkleEffectSet:cGOSetList = null;
        public var showWaitForPickupIcon:Boolean;
        public var mCursorHighlight:Boolean;
        private var mUpgradeLevel:int = 1;
        public var productionQueue:cTimedProductionQueue;
        private var mStreetGridEntry:int;
        public var mPreCombatType:int;
        private var mWayWarehouseToWorkyard:Number;
        public var mBuildingUpgradeProgress:int;
        private var mLastProgress:Number = 0;
        private var mBuildingUpgradeStartTime:Number;
        public var mIsEventMonster:Boolean = false;
        private var mDestructionAnimEffectSet:cGOSetList = null;
        private var originalSprite:cSpriteLib;

        private var mFlags:int = FLAG_PRODUCTION_ACTIVE;
        public var mBuffs_vector:Vector.<BuffAppliance> = new Vector.<BuffAppliance>();
        public var mDirtyIndicator:DirtyIndicator = new DirtyIndicator();
        private var mUniqueId:dUniqueID = new dUniqueID();
        private var mSmokeEffectSet:Vector.<cGOSetList> = new Vector.<cGOSetList>();
        private var currentBuffSkin:String = global.defaultGosetBuffTwinkleName;
        private var currentFriendBuffSkin:String = global.defaultGosetFriendBuffTwinkleName;

        public function cBuilding(_arg_1:cGeneralInterface, _arg_2:int)
        {
            super(_arg_1);
            renderLayers = (RENDER_LAYER.STATIC | RENDER_LAYER.LABELS);
            if (_arg_1 != null)
            {
                this.mPlayerID = _arg_2;
                this.mArmy = new cArmy(_arg_1.mCurrentViewedZoneID, this.mPlayerID, ARMY_OWNER_TYPE.BUILDING, this);
            };
        }

        public static function GetBuildingModeString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case BUILDING_MODE_NONE:
                    return ("None");
                case BUILDING_MODE_QUEUED:
                    return ("Queued");
                case BUILDING_MODE_SET_BUILDING_GROUND_PLACE:
                    return ("SetBuildingGroundPlace");
                case BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE:
                    return ("SettlerWalksToBuildingGroundPlace");
                case BUILDING_MODE_CONSTRUCTION:
                    return ("Construction");
                case BUILDING_MODE_DESTRUCTION:
                    return ("Destruction");
                case BUILDING_MODE_DESTRUCTED:
                    return ("Destructed");
                case BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                    return ("BuilderWalksFromResourceCreationHouseToStorehouse");
                case BUILDING_MODE_SETTLER_WALKS_FROM_STOREHOUSE_TO_RESOURCECREATIONHOUSE:
                    return ("SettlerWalksFromStorehouseToResourceCreationHouse");
                case BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                    return ("SettlerWalksFromResourceCreationHouseToStorehouse");
                case BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_LOCAL_WORKYARD_SYSTEM:
                    return ("WorkanimIsWorkingAtWorkyardLocalWorkyardSystem");
                case BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_EXTERNAL_WORKYARD_SYSTEM_ACTIVE:
                    return ("WorkanimIsWorkingAtWorkyardExternalWorkyardSystemActive");
                case BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE:
                    return ("SettlerWalksFromResourceCreationHouseToExternalResource");
                case BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE:
                    return ("SettlerWalksFromExternalResourceToResourceCreationHouse");
                case BUILDING_MODE_WORKANIM_IS_WORKING_AT_EXTERNAL_DEPOSIT:
                    return ("WorkanimIsWorkingAtExternalDeposit");
                case BUILDING_MODE_PRODUCES_NO_RESOURCES:
                    return ("ProducesNoResources");
                case BUILDING_MODE_EPIC_MONSTER_DYING_EFFECT:
                    return ("EpicMonsterDyingEffect");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function CreateFromString(_arg_1:cPlayerData, _arg_2:cGOGroup, _arg_3:String, _arg_4:cGeneralInterface):cBuilding
        {
            var _local_5:cBuilding = createBuilding(_arg_3, _arg_2, _arg_4, ((_arg_1 != null) ? _arg_1.GetPlayerId() : -1));
            var _local_6:cGOSpriteLibContainer = _arg_2.GetSpriteLibContainer(_arg_3);
            _local_5.mGoGroup = _arg_2;
            _local_5.setSkin(_arg_3);
            _local_5.originalSprite = _local_5.mSprite;
            _local_5.SetBuildingName_string(_arg_3);
            _local_5.mStartWorkCounter = 0;
            _local_5.SetIsBought(false);
            _local_5.SetIsWaitForCommand(false);
            _local_5.SetIsGarrisonWaitForCommand(false);
            _local_5.mBuildingMode = BUILDING_MODE_NONE;
            _local_5.mCurrentHitPoints = _local_5.GetMaxHitPoints();
            _local_5.mPlayerData = _arg_1;
            _local_5.ui = _local_6.ui;
            _local_5.uiContent = _local_6.uiContent;
            _local_5.productionType = _local_6.productionType;
            _local_5.waitForPickup = _local_6.waitForPickup;
            _local_5.showWaitForPickupIcon = _local_6.showWaitForPickupIcon;
            _local_5.waitForPickupSpriteIndex = _local_6.waitForPickupSpriteIndex;
            _local_5.productionReadyAvatarType = _local_6.productionReadyAvatarType;
            _local_5.depletedMineExtension = _local_6.depletedMineExtension;
            _local_5.SetIsPreventDeletion(_local_6.preventDeletion);
            if (_arg_1 != null)
            {
                _local_5.mPlayerID = _arg_1.GetPlayerId();
            }
            else
            {
                _local_5.mPlayerID = -1;
            };
            _local_5.mLevelEnumObjectType = OBJECTTYPE.BUILDING;
            if (StringUtils.startsWith(_local_5.ui, defines.DEFENSE_MODE_BUILDINGS_UI_string))
            {
                _local_5.SetIsDefenseBuilding(true);
            };
            if (_local_5.productionType >= 0)
            {
                _local_5.productionQueue = _arg_4.mCurrentPlayerZone.GetProductionQueue(_local_5.productionType);
                if (_local_5.productionQueue == null)
                {
                    _local_5.productionQueue = new cTimedProductionQueue(_arg_4, _local_5.productionType, _local_5, _local_5.waitForPickup, _local_5.productionReadyAvatarType, (_local_5.GetGOContainer().stackingBuffs_vector.length > 0));
                };
                _arg_4.cooldownManager.registerBonusProvider(COOLDOWN_TYPE.fromTimedProduction(_local_5.productionType), new CultureBuildingCooldownTimeBonusProvider(_arg_4, _local_5.mBuildingName_string));
            };
            if (_local_5.mBuildingName_string.indexOf(defines.EVENT_MONSTER_NAME_string) != -1)
            {
                _local_5.mIsEventMonster = true;
            };
            var _local_7:int = _arg_2.GetNrFromName(_local_5.mBuildingName_string);
            var _local_8:String = _arg_2.GetGoSpriteLibContainerFromNr(_local_7).mFlagEffectSetName_string;
            if (((!(_local_8 == null)) && (!(_local_8 == ""))))
            {
                _local_5.CreateFlagEffectSet(_local_8);
            };
            _local_5.setIsSpecialUpgradeBuilding((((_local_5.GetGOContainer().ui == "genericLink") || (_local_5.GetGOContainer().ui == "achievementWarehouse")) || (_local_5.GetGOContainer().ui == "achievementWorkyard")));
            return (_local_5);
        }

        private static function createBuilding(_arg_1:String, _arg_2:cGOGroup, _arg_3:cGeneralInterface, _arg_4:int):cBuilding
        {
            var _local_5:cGOSpriteLibContainer = _arg_2.GetSpriteLibContainer(_arg_1);
            if (StringUtils.startsWith(_arg_1, "AirshipExcelsior"))
            {
                return (new AirshipBuilding(_arg_3, _arg_4, _local_5.GetShadowOffsetY(), _local_5.GetShadowOffsetX(), _local_5.GetRenderOffSetY(), _local_5.GetFloatingRangeMultiplier(), _local_5.GetHasShadowSprite()));
            };
            if (CollectionsManager.getInstance().getBuildingIsNormalCollectible(_arg_1))
            {
                return (new CollectibleBuildingNormal(_arg_3, _arg_4));
            };
            if (CollectionsManager.getInstance().getBuildingIsEventCollectible(_arg_1))
            {
                return (new CollectibleEventBuilding(_arg_3, _arg_4));
            };
            if (EpicWorkyardsManager.getInstance().getIsEpicSubBuilding(_arg_1))
            {
                return (new EpicWorkyardSubBuilding(_arg_3, _arg_4));
            };
            if (EpicWorkyardsManager.getInstance().getIsEpicMasterBuilding(_arg_1))
            {
                return (new EpicWorkyardMasterBuilding(_arg_3, _arg_4));
            };
            if (_local_5.isDestroyOnClick())
            {
                return (new DestroyOnClickBuilding(_arg_3, _arg_4));
            };
            if (_local_5.IsFloatingBuilding())
            {
                return (new FloatingBuilding(_arg_3, _arg_4, _local_5.GetShadowOffsetY(), _local_5.GetShadowOffsetX(), _local_5.GetRenderOffSetY(), _local_5.GetFloatingRangeMultiplier(), _local_5.GetHasShadowSprite()));
            };
            return (new cBuilding(_arg_3, _arg_4));
        }


        public function IsDefenseModeGhostGarrison():Boolean
        {
            return (this.IsDefenseSlot());
        }

        public function SetIsUpgradeInProgress(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_UPGRADE_IN_PROGRESS);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_UPGRADE_IN_PROGRESS)));
            };
        }

        public function Upgrade():Boolean
        {
            this.SetIsUpgradeInitiatedWithGem(false);
            this.SetIsUpgradeInProgress(false);
            this.mBuildingUpgradeProgress = 100;
            var _local_1:int = this.GetMaxHitPoints();
            this.mUpgradeLevel++;
            this.mMaxHitPoints = 0;
            this.SetCurrentHitPoints((this.mCurrentHitPoints + (this.GetMaxHitPoints() - _local_1)));
            this.mBuildingUpgradeStartTime = 0;
            mGeneralInterface.mConditionManager.destroyTriggers(this);
            mGeneralInterface.mConditionManager.createTriggers(this, mGeneralInterface);
            this.mDirtyIndicator.strongModified();
            return (true);
        }

        public function ModifyOffsetY(_arg_1:int):void
        {
            this.mOffsetY = (this.mOffsetY + _arg_1);
        }

        public function GetHealthBar():Number
        {
            return (this.mHealthBar);
        }

        public function GetLastRepairTime():Number
        {
            return (this.mLastRepairTime);
        }

        public function GetInfoPanelShortcut():String
        {
            return (this.GetGOContainer().mInfoPanelShortcut);
        }

        public function GetOffsetX():int
        {
            return (this.mOffsetX);
        }

        public function shouldPlayDestroyEffect():Boolean
        {
            if (this.isGarrison())
            {
                return (false);
            };
            return (true);
        }

        public function isModified():Boolean
        {
            return (this.modified);
        }

        public function IsLeaderCamp():Boolean
        {
            return (!((this.mFlags & FLAG_IS_LEADER) == 0));
        }

        public function IsBuildingInfoIconDelayPassed():Boolean
        {
            return ((this.IsProductionActive()) && (this.mBuildingInfoIconDelayEndTime < gMisc.GetTimeSinceStartup()));
        }

        public function GetUpgradeLevelBonuses():cBuffDefinition
        {
            return (this.GetUpgradeLevelBonusesForLevel(this.mUpgradeLevel));
        }

        private function SetIsEngagedInCombat(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_ENGAGED_IN_COMBAT);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_ENGAGED_IN_COMBAT)));
            };
        }

        public function handleSelectBuilding():Boolean
        {
            return (false);
        }

        public function IsEngagedInCombat():Boolean
        {
            return (!((this.mFlags & FLAG_ENGAGED_IN_COMBAT) == 0));
        }

        public function SetGoGroup(_arg_1:cGOGroup):Boolean
        {
            this.mGoGroup = _arg_1;
            return (true);
        }

        public function hasBuff(_arg_1:String):Boolean
        {
            var _local_2:BuffAppliance;
            for each (_local_2 in this.mBuffs_vector)
            {
                if (_local_2.GetBuffDefinition().GetName_string() == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function GetOffsetY():int
        {
            return (this.mOffsetY);
        }

        public function GetUniqueId():dUniqueID
        {
            return (this.mUniqueId);
        }

        public function GetUpgradeInstantCosts():int
        {
            var _local_3:dResource;
            var _local_4:Number;
            var _local_5:int;
            var _local_1:int;
            var _local_2:Vector.<dResource> = this.GetUpgradeCosts_vector();
            if (_local_2 != null)
            {
                for each (_local_3 in _local_2)
                {
                    if (global.resourceHardcurrencyValues.hasOwnProperty(_local_3.name_string))
                    {
                        _local_1 = (_local_1 + int((_local_3.amount * global.resourceHardcurrencyValues[_local_3.name_string])));
                    };
                };
                _local_4 = this.GetGOContainer().mUpgradeInstantBonusPercentage;
                if (_local_4 <= 0)
                {
                    _local_4 = global.defaultUpgradeInstantBonusPercentage;
                };
                _local_5 = int(int(((_local_4 / 100) * _local_1)));
                _local_1 = (_local_1 - _local_5);
            };
            return (_local_1);
        }

        public function _setGridRaw(_arg_1:int):void
        {
            super.SetGrid(_arg_1);
        }

        override public function Compute():void
        {
            var _local_2:Number;
            var _local_4:cSpecialist;
            var _local_5:String;
            var _local_6:BuffAppliance;
            var _local_7:cGOSetList;
            var _local_8:Number;
            var _local_9:cGOSetList;
            var _local_10:String;
            var _local_11:Array;
            var _local_12:String;
            var _local_13:String;
            super.Compute();
            if (this.mResourceCreation != null)
            {
                if (this.IsProductionLevelTooLow())
                {
                    if (this.mResourceCreation.GetProductionState() == cResourceCreation.PRODUCTIONSTATE_WORKING)
                    {
                        globalFlash.gui.mBuildingInfoPanel.DisplayProductionState(this);
                    };
                }
                else
                {
                    if (this.mResourceCreation.GetProductionState() == cResourceCreation.PRODUCTIONSTATE_UPGRADELEVEL_TOO_LOW)
                    {
                        globalFlash.gui.mBuildingInfoPanel.DisplayProductionState(this);
                    };
                };
            };
            if (this.mPlayerData != null)
            {
                if (this._nextLabelUpdate < mGeneralInterface.GetClientTime())
                {
                    this._renderPlayerName = cGeneralInterface.getComputedPlayerName(this.mPlayerData.GetPlayerName_string());
                    this._renderSpecialistName = null;
                    if (((this.getPlayerID() == mGeneralInterface.mCurrentPlayer.GetPlayerId()) && (this.GetGOContainer().mMaxUnits > 0)))
                    {
                        for each (_local_4 in mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
                        {
                            if (_local_4.GetGarrisonGridIdx() == GetGrid())
                            {
                                _local_5 = _local_4.getName(true);
                                if (StringUtils.isEmpty(_local_5))
                                {
                                    _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.SPECIALISTS, SPECIALIST_TYPE.toString(_local_4.GetType()));
                                };
                                this._renderSpecialistName = _local_5;
                                this._renderPlayerName = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "garrison_playername", [this._renderPlayerName]);
                                break;
                            };
                        };
                    };
                    this._nextLabelUpdate = (mGeneralInterface.GetClientTime() + 1000);
                };
            };
            var _local_1:int;
            while (_local_1 < this.mBuffs_vector.length)
            {
                _local_6 = this.mBuffs_vector[_local_1];
                if (!_local_6.IsActive(mGeneralInterface.GetClientTime()))
                {
                    _local_6.BuffRemoved(mGeneralInterface);
                    this.mBuffs_vector.splice(_local_1, 1);
                    _local_1--;
                    if (_local_6 == this.productionBuff)
                    {
                        this.productionBuff = null;
                    };
                    if (_local_6.GetBuffDefinition().GetName_string().indexOf("MountainDemolition") > -1)
                    {
                        this.SetBuildingMode(BUILDING_DESTRUCTION_READY);
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.DESTROY_MOUNTAIN_READY, this);
                    };
                };
                _local_1++;
            };
            var _local_3:Number = 0;
            if (this.mBuildingMode == BUILDING_MODE_CONSTRUCTION)
            {
                this.mLastProgress = _local_3;
                this.mProgressPercent = int((this.mBuildingProgress / defines.BUILDING_PROGRESS_SCALE_FACTOR));
                this.mProgressTimeRemainingInMS = this.GetRemainingConstructionDuration();
                if (this.mResourceCreation == null)
                {
                    this.mBuildingProgress = (this.mBuildingProgress + ((mGeneralInterface.mClientDeltaTime * 1000) / this.GetGOContainer().mConstructionDuration));
                    if (this.mBuildingProgress >= (100 * defines.BUILDING_PROGRESS_SCALE_FACTOR))
                    {
                        this.mBuildingProgress = (100 * defines.BUILDING_PROGRESS_SCALE_FACTOR);
                        this.SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
                        mGeneralInterface.mCurrentPlayer.RefreshBuildingList();
                    };
                };
            }
            else
            {
                if (this.mBuildingMode == BUILDING_MODE_DESTRUCTION)
                {
                    _local_3 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetDestructionProgressInPercent(this);
                    if (_local_3 != this.mLastProgress)
                    {
                        this.mProgressPercent = (100 - int(mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetDestructionProgressInPercent(this)));
                        this.mProgressTimeRemainingInMS = this.GetRemainingDestructionDurationInMS();
                        if (_local_3 == 100)
                        {
                            this.removeBuilding(true);
                        };
                    };
                    this.mLastProgress = _local_3;
                }
                else
                {
                    if (this.mBuildingMode == BUILDING_MODE_EPIC_MONSTER_DYING_EFFECT)
                    {
                        _local_3 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetDestructionProgressInPercent(this);
                        if (((!(_local_3 == this.mLastProgress)) && (_local_3 == 100)))
                        {
                            this.DamageBuilding(this.GetCurrentHitPoints(), mGeneralInterface.mCurrentPlayer);
                        };
                    }
                    else
                    {
                        if (this.mBuildingMode == MOUNTAIN_DESTROYED)
                        {
                            mGeneralInterface.mCurrentPlayerZone.RemoveAtGridPosition(this.mPlayerData, OBJECTTYPE.BUILDING, GetGrid());
                        }
                        else
                        {
                            if (this.IsUpgradeInProgress())
                            {
                                this.mProgressPercent = this.mBuildingUpgradeProgress;
                                _local_8 = ((this.GetUpgradeStartTime() + this.GetUpgradeDuration()) - mGeneralInterface.GetClientTime());
                                this.mProgressTimeRemainingInMS = ((_local_8 <= 0) ? 0 : _local_8);
                            };
                            if (this.mSpriteWorkAnim != null)
                            {
                                if (((this.IsProductionActive()) && (!(this.IsProductionLevelTooLow()))))
                                {
                                    _local_2 = (0.75 + (Math.random() * 0.5));
                                    this.mSpriteWorkAnim.Animate((mGeneralInterface.mCalculateTicks.mDeltaTicksOne * _local_2));
                                }
                                else
                                {
                                    this.mSpriteWorkAnim.SetFrame(0);
                                };
                            };
                            _local_7 = this.getDamageAnimEffectSet();
                            if (_local_7 != null)
                            {
                                _local_2 = (0.75 + (Math.random() * 0.5));
                                _local_7.Animate((mGeneralInterface.mCalculateTicks.mDeltaTicksOne * _local_2));
                            };
                        };
                    };
                };
            };
            if (this.getShouldComputeSmokeEffect())
            {
                if (this.mSmokeEffectSet.length != 0)
                {
                    _local_2 = (0.75 + (Math.random() * 0.5));
                    for each (_local_9 in this.mSmokeEffectSet)
                    {
                        _local_9.Animate((mGeneralInterface.mCalculateTicks.mDeltaTicksOne * _local_2));
                    };
                }
                else
                {
                    _local_10 = this.GetGOContainer().mSmokeEffectSetName_string;
                    if (!StringUtils.isNullOrEmpty(_local_10))
                    {
                        _local_11 = _local_10.split(",");
                        for each (_local_12 in _local_11)
                        {
                            this.mSmokeEffectSet.push(cGOSetManager.CreateGOSetList(_local_12, null));
                        };
                    };
                };
            };
            if (((!(this.productionBuff == null)) && (!(this.hideBuffAnimation()))))
            {
                if (this.mBuffTwinkleEffectSet != null)
                {
                    this.mBuffTwinkleEffectSet.Animate(mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
                }
                else
                {
                    if (this.productionBuff.GetApplicanceMode() == BUFF_APPLIANCE_MODE.PLAYER)
                    {
                        _local_13 = gAssetManager.GetBuffCursorType_string(this.productionBuff.GetBuffDefinition().GetName_string());
                        if (_local_13 == null)
                        {
                            _local_13 = this.currentBuffSkin;
                        };
                        this.mBuffTwinkleEffectSet = cGOSetManager.CreateGOSetList(_local_13, null);
                        this.mBuffTwinkleEffectSet.randomize();
                    }
                    else
                    {
                        if (((this.productionBuff.GetApplicanceMode() == BUFF_APPLIANCE_MODE.FRIEND) || (this.productionBuff.GetApplicanceMode() == BUFF_APPLIANCE_MODE.FRIEND_OR_GUILD_MEMBER_PREMIUM)))
                        {
                            _local_13 = gAssetManager.GetBuffCursorTypeForeign_string(this.productionBuff.GetBuffDefinition().GetName_string());
                            if (_local_13 == null)
                            {
                                _local_13 = this.currentFriendBuffSkin;
                            };
                            this.mBuffTwinkleEffectSet = cGOSetManager.CreateGOSetList(_local_13, null);
                            this.mBuffTwinkleEffectSet.randomize();
                        };
                    };
                };
            };
            this.mSpecialUpgradeReady = ((this.isSpecialUpgradeBuilding()) && (this.IsUpgradeAllowed(false)));
            if (((this.isSpecialUpgradeBuilding()) && (this.IsUpgradeInProgress())))
            {
                if (this.mBuffTwinkleEffectSet != null)
                {
                    this.mBuffTwinkleEffectSet.Animate(mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
                }
                else
                {
                    this.mBuffTwinkleEffectSet = cGOSetManager.CreateGOSetList("pvp_upgrade_fxSet", null);
                };
            };
        }

        public function setMovedBuildingGrid(_arg_1:int):void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(((((("##### setMovedBuildingGrid() " + this.mBuildingName_string) + " before: mBuildingGrid: ") + GetGrid()) + ", _grid: ") + _arg_1));
            };
            this.SetGrid(_arg_1);
            if (cLog.isInfoEnabled())
            {
                cLog.info(((((("##### setMovedBuildingGrid() " + this.mBuildingName_string) + " after: mBuildingGrid: ") + GetGrid()) + ", _grid: ") + _arg_1));
            };
        }

        public function SetHasBuildingLayers(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_HAS_LAYERS);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_HAS_LAYERS)));
            };
        }

        public function HasBuildingLayers():Boolean
        {
            return (!((this.mFlags & FLAG_HAS_LAYERS) == 0));
        }

        public function SetUpgradeLevel(_arg_1:int):void
        {
            this.mUpgradeLevel = _arg_1;
            this.mMaxHitPoints = 0;
        }

        public function GetBuildingModeBeforeMoving():int
        {
            return (this.mBuildingModeBeforeMoving);
        }

        public function GetCurrentHitPoints():int
        {
            return (this.mCurrentHitPoints);
        }

        protected function RenderBuildingName():void
        {
            var _local_1:String;
            if (this._renderSpecialistName != null)
            {
                mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, this._renderSpecialistName, GetXInt(), ((GetYInt() - (global.streetGridY * 2)) + 34));
            }
            else
            {
                _local_1 = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, this.GetBuildingName_string());
                mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, _local_1, GetXInt(), ((GetYInt() - (global.streetGridY * 2)) + 34));
            };
        }

        public function RemoveSurplusResources():void
        {
            var _local_2:cResources;
            var _local_1:Vector.<dResource> = this.getSurplusResources();
            if (((!(_local_1 == null)) && (_local_1.length > 0)))
            {
                _local_2 = mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData);
                _local_2.RemovePlayerResourcesFromResourcesInList(_local_1, 1, ModifyReason.DESTROY_WAREHOUSE);
            };
        }

        public function GetStreetGridEntry():int
        {
            return (this.mStreetGridEntry);
        }

        public function setPlayerID(_arg_1:int):void
        {
            if (this.mFlagEffectSet != null)
            {
                this.mFlagEffectSet.SetSubTypeCurrentGOSetItem(mGeneralInterface.mCurrentPlayerZone.GetPlayerColorIdx(_arg_1));
            };
            this.mPlayerID = _arg_1;
        }

        public function SetInterceptIndex(_arg_1:int):void
        {
            this.mInterceptIndex = _arg_1;
        }

        public function GetUIUpgradeLevel():int
        {
            if (this.GetGOContainer().mUILevelOverwrite > 0)
            {
                return (this.GetGOContainer().mUILevelOverwrite);
            };
            return (this.mUpgradeLevel);
        }

        public function IsInConstructionMode():Boolean
        {
            return ((((this.mBuildingMode == cBuilding.BUILDING_MODE_QUEUED) || (this.mBuildingMode == cBuilding.BUILDING_MODE_CONSTRUCTION)) || (this.mBuildingMode == cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE)) || (this.mBuildingMode == cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE));
        }

        public function SetEngagedInCombat(_arg_1:Boolean, _arg_2:Boolean):void
        {
            var _local_3:cSquad;
            if (this.IsEngagedInCombat() != _arg_1)
            {
                this.SetIsEngagedInCombat(_arg_1);
                if (!this.IsEngagedInCombat())
                {
                    if (_arg_2)
                    {
                        for each (_local_3 in this.mArmy.GetSquads_vector())
                        {
                            _local_3.Heal(_local_3.GetUnitBase().GetHitPoints());
                        };
                    };
                }
                else
                {
                    this.SetRecoveringHitPoints(0);
                };
            };
        }

        private function RenderFlag():void
        {
            if (this.mFlagEffectSet == null)
            {
                return;
            };
            if (((((this.mBuildingMode == BUILDING_MODE_CONSTRUCTION) || (this.mBuildingMode == BUILDING_MODE_QUEUED)) || (this.mBuildingMode == BUILDING_MODE_SET_BUILDING_GROUND_PLACE)) || (this.mBuildingMode == BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE)))
            {
                return;
            };
            this.mFlagEffectSet.Render(int(mXNotScaled), int(mYNotScaled));
        }

        public function handleBuildingDeconstructed():void
        {
            mGeneralInterface.mConditionManager.destroyTriggers(this);
        }

        public function IsReadyToIntercept():Boolean
        {
            if (((!(this.mArmy.HasUnits())) || (this.IsEngagedInCombat())))
            {
                return (false);
            };
            return (true);
        }

        protected function hideBuffAnimation():Boolean
        {
            return (false);
        }

        public function getProdutionTime():Number
        {
            return (this.mProductionTime);
        }

        protected function SetIsProductionActive(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_PRODUCTION_ACTIVE);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_PRODUCTION_ACTIVE)));
            };
        }

        public function StartBuildingUpgrade():void
        {
            this.SetIsUpgradeInProgress(true);
            this.mBuildingUpgradeStartTime = mGeneralInterface.GetClientTime();
            this.mDirtyIndicator.strongModified();
            this.mBuildingUpgradeProgress = 0;
        }

        [Bindable(event="propertyChange")]
        private function get mHealthBar():Number
        {
            return (this._2088099370mHealthBar);
        }

        public function GetRecurringChance():int
        {
            return (this.mRecurringChance);
        }

        public function GetInfoPanelShortcutItem():String
        {
            return (this.GetGOContainer().mInfoPanelShortcutItem);
        }

        public function SetRecoveringHitPoints(_arg_1:int):void
        {
        }

        public function SetWorkAnimation(_arg_1:cSpriteLib):void
        {
            var _local_2:cSpriteLibContainer;
            var _local_3:Number;
            this.mSpriteWorkAnim = _arg_1;
            if (this.mSpriteWorkAnim != null)
            {
                _local_2 = (this.mSpriteWorkAnim.GetContainer() as cSpriteLibContainer);
                _local_3 = _local_2.mAnimationSpeed;
                this.mSpriteWorkAnim.SetAnim(_local_2.mAnimationSpeed, true);
            };
        }

        public function GetResourceCreation():cResourceCreation
        {
            return (this.mResourceCreation);
        }

        public function ignoreOnSectorClaim():Boolean
        {
            return (this.mGoGroup.ignoreOnSectorClaim(this.mBuildingName_string));
        }

        public function SetIsDefenseBuilding(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_DEFENSE_BUILDING);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_DEFENSE_BUILDING)));
            };
        }

        public function IsSpecialUpgradeAvailable():Boolean
        {
            return (((this.GetUpgradeCosts_vector() == null) || (this.GetUpgradeCosts_vector().length == 0)) && (this.isSpecialUpgradeConditionsMet()));
        }

        public function IsDefenseBuilding():Boolean
        {
            return (!((this.mFlags & FLAG_DEFENSE_BUILDING) == 0));
        }

        public function isSpecialUpgradeConditionsMet():Boolean
        {
            return (mGeneralInterface.mConditionManager.triggersFinished(this));
        }

        override public function toString():String
        {
            return (((((((((((("<Building name='" + this.mBuildingName_string) + "' grid='") + GetGrid()) + "' player='") + this.mPlayerID) + "' mode='") + GetBuildingModeString(this.mBuildingMode)) + "' health='") + this.GetCurrentHitPoints()) + "' Buff='") + this.mBuffs_vector) + "' />");
        }

        public function Buy():void
        {
            if (!this.IsBought())
            {
                this.SetIsBought(true);
                mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData).RemoveBuildingResourcesFromPlayerResources(this.GetGOContainer().mGfxResourceListName_string);
                this.mDirtyIndicator.strongModified();
            }
            else
            {
                gMisc.MessageBox("Error: Building has already been bought!");
            };
        }

        public function SetIsMoveInitiated(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_MOVE_INITIATED);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_MOVE_INITIATED)));
            };
        }

        override public function getRenderSortSubGrid():int
        {
            return (RENDER_ORDER.ORDER_1);
        }

        public function GetGoGroup():cGOGroup
        {
            return (this.mGoGroup);
        }

        protected function renderSmokeEffect(_arg_1:int, _arg_2:int):void
        {
            var _local_3:cGOSetList;
            for each (_local_3 in this.mSmokeEffectSet)
            {
                _local_3.Render(_arg_1, _arg_2);
            };
        }

        public function SetIsInitialSetOnMap(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_INITIAL_SET_ON_MAP);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_INITIAL_SET_ON_MAP)));
            };
        }

        public function IsInitialSetOnMap():Boolean
        {
            return (!((this.mFlags & FLAG_INITIAL_SET_ON_MAP) == 0));
        }

        public function GetArmy():cArmy
        {
            return (this.mArmy);
        }

        public function IsProductionLevelTooLow():Boolean
        {
            if (!(this.originalSprite.GetContainer() is cGOSpriteLibContainer))
            {
                return (false);
            };
            return (this.mUpgradeLevel < this.GetGOContainer().minProductionLevel);
        }

        public function CheckIfFlagged(_arg_1:int):Boolean
        {
            return ((this.mUpgradeLevel & _arg_1) > 0);
        }

        public function IsEqualToVOIgnoreGrid(_arg_1:dBuildingVO):Boolean
        {
            var _local_2:dSquadVO;
            var _local_3:cSquad;
            if (_arg_1.buildingCreationTime != this.mBuildingCreationTime)
            {
                return (false);
            };
            if (_arg_1.buildingName_string != this.mBuildingName_string)
            {
                return (false);
            };
            if (_arg_1.upgradeStartTime != this.mBuildingUpgradeStartTime)
            {
                return (false);
            };
            for each (_local_2 in _arg_1.armyVO.squads)
            {
                _local_3 = this.mArmy.GetSquad(_local_2.GetType());
                if (((_local_3 == null) || (!(_local_3.GetAmount() == _local_2.GetAmount()))))
                {
                    return (false);
                };
            };
            return (true);
        }

        protected function RenderGeneralStateIcon():void
        {
            var _local_4:cSpecialist;
            var _local_1:int = GetXInt();
            var _local_2:int = (GetYInt() - 10);
            var _local_3:int = mGeneralInterface.mCurrentPlayerZone.GetPlayerColorIdx(this.getPlayerID());
            gGfxResource.mUpgradeLevelIcons.SetSubType(_local_3);
            gGfxResource.mUpgradeLevelIcons.RenderPos(_local_1, (_local_2 - (global.streetGridY * 2)));
            for each (_local_4 in mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
            {
                if (_local_4.GetGarrisonGridIdx() == GetGrid())
                {
                    if (_local_4.GetGeneralState() >= 0)
                    {
                        gGfxResource.mGeneralStateIcons.SetSubType(_local_4.GetGeneralState());
                        gGfxResource.mGeneralStateIcons.RenderPos((_local_1 - 16), (_local_2 - (global.streetGridY * 2)));
                    };
                    break;
                };
            };
        }

        public function CheckForRepairRound():Boolean
        {
            if ((mGeneralInterface.GetClientTime() - this.mLastRepairTime) >= global.repairRoundDuration)
            {
                this.mLastRepairTime = mGeneralInterface.GetClientTime();
                this.mDirtyIndicator.strongModified();
                return (true);
            };
            return (false);
        }

        public function IsGarrisonWaitForCommand():Boolean
        {
            return (!((this.mFlags & FLAG_GARRISON_WAT_FOR_COMMAND) == 0));
        }

        private function renderProgressTimeRemaining():void
        {
            var _local_1:* = "";
            var _local_2:* = "";
            var _local_3:* = "";
            var _local_4:int;
            _local_1 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TimeRemaining");
            _local_2 = cLocaManager.GetInstance().FormatDuration(this.mProgressTimeRemainingInMS, cLocaManager.DURATION_FORMAT_SHORT);
            var _local_5:int;
            while (_local_5 < ((_local_1.length - _local_2.length) / 1.5))
            {
                _local_3 = (_local_3 + " ");
                _local_5++;
            };
            if (this.mIsDepositInfoShowing)
            {
                mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (((_local_1 + "\n") + _local_3) + _local_2), GetXInt(), (GetYInt() + (50 * (1 - mGeneralInterface.mZoom.mFactorDivDefaultZoom))));
            }
            else
            {
                mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (((_local_1 + "\n") + _local_3) + _local_2), GetXInt(), (GetYInt() - (50 * mGeneralInterface.mZoom.mFactorDivDefaultZoom)));
            };
        }

        public function IsRecurringBuilding():Boolean
        {
            return (this.mRecurringChance > 0);
        }

        public function IsProductionActive():Boolean
        {
            return (!((this.mFlags & FLAG_PRODUCTION_ACTIVE) == 0));
        }

        private function set mHealthBar(_arg_1:Number):void
        {
            var _local_2:Object = this._2088099370mHealthBar;
            if (_local_2 !== _arg_1)
            {
                this._2088099370mHealthBar = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mHealthBar", _local_2, _arg_1));
            };
        }

        public function GetUpgradeCosts_vector():Vector.<dResource>
        {
            var _local_1:cBuffDefinition = this.GetUpgradeLevelBonusesForLevel((this.mUpgradeLevel + 1));
            if (_local_1 == null)
            {
                return (null);
            };
            return (_local_1.GetCosts_vector());
        }

        public function setDestroyedByPlayerID(_arg_1:int):void
        {
            this.destroyedByPlayerID = _arg_1;
        }

        public function SetProductionActiveCommand(_arg_1:Boolean):void
        {
            var _local_2:dServerAction = new dServerAction();
            _local_2.grid = GetGrid();
            _local_2.type = ((_arg_1) ? 1 : 0);
            mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.STOP_PRODUCTION, mGeneralInterface.mCurrentViewedZoneID, _local_2);
            this.SetIsWaitForCommand(true);
        }

        public function getBuildingSelection():cBuilding
        {
            return (this);
        }

        public function GetMovementCostsForLevel(_arg_1:int):ModifiableCost
        {
            var _local_2:ModifiableCost;
            if (this.GetGOContainer().buildingMovementCosts_vector == null)
            {
                return (null);
            };
            if (this.mBuildingName_string == defines.GUILDHOUSE_NAME_string)
            {
                _arg_1 = 1;
            };
            if (((this.IsRecurringBuilding()) && (_arg_1 == 1)))
            {
                return (null);
            };
            if (((_arg_1 > 0) && (_arg_1 <= this.GetGOContainer().buildingMovementCosts_vector.length)))
            {
                if (this.GetGOContainer().buildingMovementCosts_vector[(_arg_1 - 1)].length > 0)
                {
                    _local_2 = new ModifiableCost();
                    _local_2.cost = this.GetGOContainer().buildingMovementCosts_vector[(_arg_1 - 1)];
                    mGeneralInterface.mCurrentPlayer.notifyPropertyObserver(ModifiableCost.MOVE_COST, _local_2);
                    return (_local_2);
                };
            };
            return (null);
        }

        public function AddBuff(_arg_1:cBuff, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            var _local_9:BuffAppliance;
            var _local_10:EffectVO;
            var _local_11:Boolean;
            var _local_12:Boolean;
            var _local_5:cBuffDefinition = _arg_1.GetBuffDefinition();
            var _local_6:String = _local_5.GetName_string();
            if (_local_5.GetBuffType() != BUFF_TYPE.TIMED_HIDDEN)
            {
                if (_local_6.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) > -1)
                {
                    if (((!(this.productionBuff == null)) && (this.productionBuff.GetBuffDefinition().GetName_string().indexOf("ChangeColorScheme") > -1)))
                    {
                        this.removeBuff(this.productionBuff);
                    };
                }
                else
                {
                    if (_local_6.indexOf(HALLOWEEN_EVENT.BUFF_GHOSTBUSTER) > -1)
                    {
                        if (((!(this.productionBuff == null)) && ((this.productionBuff.GetBuffDefinition().GetName_string().indexOf(HALLOWEEN_EVENT.BUFF_DARKNESS) > -1) || (this.productionBuff.GetBuffDefinition().GetName_string().indexOf(HALLOWEEN_EVENT.BUFF_HORROR) > -1))))
                        {
                            this.removeBuff(this.productionBuff);
                        };
                    }
                    else
                    {
                        if (((_local_6.indexOf(CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF) > -1) && (this.canHandleCollectibleBuff())))
                        {
                            this.handleCollectibleBuffAdded(_local_6);
                        }
                        else
                        {
                            if (_local_5.IsTypeCombatTimed())
                            {
                                if (_local_5.GetParameter(BUFF_PARAMETER_NAME.TIME_STACKING) > 0)
                                {
                                    for each (_local_9 in this.GetBuffs())
                                    {
                                        if (_local_9.GetBuffDefinition().GetId() == _local_5.GetId())
                                        {
                                            _local_9.SetStartTime((_local_9.GetStartTime() + _local_5.getDuration(_arg_2)));
                                            _local_9.mDirtyIndicator = (_local_9.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                                            return;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            var _local_7:Boolean;
            if (_local_5.GetApplyEffects() != null)
            {
                for each (_local_10 in _local_5.GetApplyEffects().list)
                {
                    if (StringUtils.equalsIgnoreCase(_local_10.effect_string, AvatarMessage.XML_string))
                    {
                        _local_7 = true;
                        break;
                    };
                };
            };
            if (!_local_7)
            {
                if (_local_6.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) > -1)
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.FILTER_ACTIVE, _arg_1.GetResourceName_string(), _local_5.isPreventDefaultAvatarMessage());
                }
                else
                {
                    if (_local_6.indexOf(HALLOWEEN_EVENT.BUFF_GHOSTBUSTER) > -1)
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.HALLOWEEN_BRIGHT_LIGHT, _arg_1, _local_5.isPreventDefaultAvatarMessage());
                    }
                    else
                    {
                        if (((_local_6.indexOf(CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF) > -1) && (this.canHandleCollectibleBuff())))
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.REVEAL_FRIEND_COLLECTIBLES, _arg_1, _local_5.isPreventDefaultAvatarMessage());
                        }
                        else
                        {
                            if (((!(mGeneralInterface.mCurrentPlayer.mIsPlayerZone)) && (!(_local_5.IsTypeCombatTimed()))))
                            {
                                _local_11 = false;
                                if ((((_local_5.getProductivityOutputPercent() == 0) && (_local_5.getRecruitingTime() < 100)) || ((_local_5.getRecruitingTime() == 0) && (_local_5.getProductivityOutputPercent() < 100))))
                                {
                                    _local_11 = true;
                                };
                                globalFlash.gui.mAvatarMessageList.AddMessage(((_local_11) ? AVATAR_MESSAGE_TYPE.PLACED_BUFF_ON_FRIEND_NEGATIVE : AVATAR_MESSAGE_TYPE.PLACED_BUFF_ON_FRIEND), this, _local_5.isPreventDefaultAvatarMessage());
                            }
                            else
                            {
                                if (_local_6.indexOf(defines.ADD_RECIPE_BUFF) > -1)
                                {
                                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADDED_RECIPE, _local_6, _local_5.isPreventDefaultAvatarMessage());
                                }
                                else
                                {
                                    if (_local_6.indexOf("BuffAd_") > -1)
                                    {
                                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.BUFF_ADVENTURE_APPLIED, _local_5, _local_5.isPreventDefaultAvatarMessage());
                                    }
                                    else
                                    {
                                        if (_local_6.indexOf(defines.REMOVE_BUFF_BUFF) > -1)
                                        {
                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.REMOVED_BUFF, this, _local_5.isPreventDefaultAvatarMessage());
                                        }
                                        else
                                        {
                                            if (_local_5.IsChangeSkinBuff())
                                            {
                                                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.CHANGE_SKIN_BUFF_APPLIED, this, _local_5.isPreventDefaultAvatarMessage());
                                            }
                                            else
                                            {
                                                if (((StringUtils.startsWith(_local_6, "MountainDemolition")) || (_local_5.GetBuffType() == BUFF_TYPE.WAIT_FOR_ACTION)))
                                                {
                                                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.PLACED_DESTROY_MOUNTAIN_BUFF, [this, _arg_1], _local_5.isPreventDefaultAvatarMessage());
                                                }
                                                else
                                                {
                                                    if (_local_6.indexOf("QuestStart_") <= -1)
                                                    {
                                                        if ((((_arg_2 == BUFF_APPLIANCE_MODE.FRIEND) || (_arg_2 == BUFF_APPLIANCE_MODE.GUILD_MEMBER)) || (_arg_2 == BUFF_APPLIANCE_MODE.FRIEND_OR_GUILD_MEMBER_PREMIUM)))
                                                        {
                                                            _local_12 = false;
                                                            if ((((_local_5.getProductivityOutputPercent() == 0) && (_local_5.getRecruitingTime() < 100)) || ((_local_5.getRecruitingTime() == 0) && (_local_5.getProductivityOutputPercent() < 100))))
                                                            {
                                                                _local_12 = true;
                                                            };
                                                            globalFlash.gui.mAvatarMessageList.AddMessage(((_local_12) ? AVATAR_MESSAGE_TYPE.PLACED_BUFF_BY_FRIEND_NEGATIVE : AVATAR_MESSAGE_TYPE.PLACED_BUFF_BY_FRIEND), this, _local_5.isPreventDefaultAvatarMessage());
                                                        }
                                                        else
                                                        {
                                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.PLACED_BUFF, this, _local_5.isPreventDefaultAvatarMessage());
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (_local_5.GetBuffType() == BUFF_TYPE.INSTANT)
            {
                return;
            };
            var _local_8:BuffAppliance = new BuffAppliance(this, this.GetUniqueId(), _local_5, _arg_2, _arg_1.GetResourceName_string(), _arg_4, _arg_1.GetNextTickTime());
            _local_8.SetStartTime(mGeneralInterface.GetClientTime());
            this.mBuffs_vector.push(_local_8);
            if (((this.productionBuff == null) && (((_local_8.GetBuffDefinition().GetBuffType() == BUFF_TYPE.TIMED) || (_local_8.GetBuffDefinition().GetBuffType() == BUFF_TYPE.ZONE)) || (_local_8.GetBuffDefinition().GetBuffType() == BUFF_TYPE.WAIT_FOR_ACTION))))
            {
                this.productionBuff = _local_8;
            };
            _local_8.mDirtyIndicator = (_local_8.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            mGeneralInterface.channels.PRODUCTION.send(cComputeResourceCreation.PRODUCTION_TIMES_CHANGED, this);
            mGeneralInterface.channels.PRODUCTION.send(cComputeResourceCreation.PRODUCTION_VALUES, this);
            this.mBuffTwinkleEffectSet = null;
        }

        public function IsBuildOnWater():Boolean
        {
            return (this.GetGOContainer().mIsWaterBuilding);
        }

        public function calculateWarehouseTransporttime():Number
        {
            if (((!(this.mResourceCreation == null)) && (!(this.mResourceCreation.GetPath() == null))))
            {
                return ((this.mResourceCreation.GetPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT) / mGeneralInterface.mGlobalTimeScale);
            };
            return (-1);
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            var _local_2:String = this.GetResourceCreation().GetResourceCreationDefinition().externalResource_string;
            if (((_arg_1.type_string.length > 0) && (!(_arg_1.type_string == _local_2))))
            {
                return (false);
            };
            return (true);
        }

        override public function SetGrid(_arg_1:int):void
        {
            var _local_4:cBlockingData;
            super.SetGrid(_arg_1);
            this.mStreetGridEntry = GetGrid();
            var _local_2:Boolean = true;
            var _local_3:int;
            while (_local_2)
            {
                this.mStreetGridEntry = gCalculations.MoveStreetGridToDir8(mGeneralInterface.mCurrentPlayerZone, this.mStreetGridEntry, defines.DIR8_SOUTH_EAST);
                _local_2 = false;
                _local_3 = (_local_3 + 50);
                for each (_local_4 in this.GetGOContainer().mBlocking_vector)
                {
                    if (((_local_4.getXPixelOffset() == _local_3) && (_local_4.getYPixelOffset() == _local_3)))
                    {
                        if (cBlockingData.isFullyBlocked(_local_4.getBlockingType()))
                        {
                            _local_2 = true;
                        };
                        break;
                    };
                };
            };
        }

        public function createStackingBuffs():void
        {
            var _local_1:String;
            var _local_2:cBuffDefinition;
            var _local_3:cBuff;
            if (((!(this.GetGOContainer() == null)) && (!(this.GetGOContainer().stackingBuffs_vector == null))))
            {
                for each (_local_1 in this.GetGOContainer().stackingBuffs_vector)
                {
                    _local_2 = cBuffDefinition.GetByName(_local_1);
                    _local_3 = new cBuff(_local_2, new dUniqueID(), 1);
                    mGeneralInterface.mZoneBuffManager.addExtraBuildingBuff(_local_3);
                };
            };
        }

        public function IsInstantUpgradeEnabled():Boolean
        {
            return (this.GetGOContainer().mIsInstantUpgradeAvailable);
        }

        public function flagDirtyModified():void
        {
            this.mDirtyIndicator.value = DIRTY_INDICATOR.DATA_MODIFIED_BIT;
        }

        public function GetCampType():int
        {
            return (this.mCampType);
        }

        public function IsDefenseSlot():Boolean
        {
            return (this.GetCampType() == CAMP_TYPE.DEFENSE_SLOT);
        }

        public function IgnoreWarehousePath():Boolean
        {
            return (this.GetGOContainer().mIgnoreWarehousePath);
        }

        public function GetMaxMilitaryUnits():int
        {
            var _local_1:cBuffDefinition = this.GetUpgradeLevelBonuses();
            if (_local_1 != null)
            {
                return (this.GetGOContainer().mMaxUnits + _local_1.getMilitaryUnitCapacity());
            };
            return (this.GetGOContainer().mMaxUnits);
        }

        public function IsKnockdownAllowed():Boolean
        {
            if ((((((this.mBuildingMode == BUILDING_MODE_DESTRUCTION) || (this.mBuildingMode == BUILDING_MODE_DESTRUCTED)) || (this.IsPreventDeletion())) || (this.IsInitialSetOnMap())) || (this.IsDestroyableMountain())))
            {
                return (false);
            };
            return (true);
        }

        public function RenderBuffTimeLeft():void
        {
            var _local_1:BuffAppliance = this.GetBuffToRenderTooltip();
            if (_local_1 == null)
            {
                return;
            };
            var _local_2:* = (_local_1.GetBuffDefinition().GetName_string().indexOf("ChangeColorScheme") > -1);
            var _local_3:String = ((_local_2) ? ((_local_1.GetBuffDefinition().GetName_string() + "_") + _local_1.GetResourceName_string()) : _local_1.GetBuffDefinition().GetName_string());
            var _local_4:String = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_3);
            var _local_5:String = cLocaManager.GetInstance().FormatDuration((_local_1.GetBuffDefinition().getDuration(_local_1.GetApplicanceMode()) - (global.getApplication().mGameInterface.GetClientTime() - _local_1.GetStartTime())), cLocaManager.DURATION_FORMAT_SHORT);
            var _local_6:Number = ((GetYInt() - (global.streetGridY * 2)) + ((this.mIsDepositInfoShowing) ? 130 : 68));
            mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, cLocaManager.GetInstance().getLabel("BuffNameAndTimeOnBuilding", [_local_4, _local_5]), GetXInt(), _local_6);
        }

        public function getWarehouseToWorkyardTime():Number
        {
            return (this.mWayWarehouseToWorkyard);
        }

        public function isSpecialUpgradeBuilding():Boolean
        {
            return (!((this.mFlags & FLAG_IS_SPECIAL_UPGRADE_BUILDING) == 0));
        }

        public function SetIsGarrisonWaitForCommand(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_GARRISON_WAT_FOR_COMMAND);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_GARRISON_WAT_FOR_COMMAND)));
            };
        }

        public function getRemainingCooldown():Number
        {
            return (mGeneralInterface.cooldownManager.getRemainingCooldown(COOLDOWN_TYPE.fromTimedProduction(this.productionType)));
        }

        public function LevelNeededToDestroy():int
        {
            return (this.GetGOContainer().mLevelNeededToDestroy);
        }

        public function SetIsUpgradeInitiatedWithGem(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_UPGRADE_INITIATED_WITH_GEM);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_UPGRADE_INITIATED_WITH_GEM)));
            };
        }

        public function IsUpgradeInitiatedWithGem():Boolean
        {
            return (!((this.mFlags & FLAG_UPGRADE_INITIATED_WITH_GEM) == 0));
        }

        public function getSurplusResources():Vector.<dResource>
        {
            var _local_6:dResourceDefaultDefinition;
            var _local_7:int;
            var _local_8:dExpandMaxLimit;
            if ((((!(REMOVE_SURPLUS_RESOURCES_ON_WAREHOUSE_DESTROY)) || (!(this.IsWarehouseType()))) || (!(this.IsInUpgradableBuildingMode()))))
            {
                return (null);
            };
            var _local_1:cResources = mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData);
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            if (this.GetUpgradeLevelBonuses() == null)
            {
                return (null);
            };
            var _local_3:int = this.GetUpgradeLevelBonuses().getGoodsCapacity();
            var _local_4:dResource;
            var _local_5:int;
            while (_local_5 < gEconomics.mResourceDefaultDefinition_vector.length)
            {
                _local_6 = gEconomics.mResourceDefaultDefinition_vector[_local_5];
                _local_7 = 0;
                _local_4 = _local_1.GetPlayerResource(_local_6.resourceName_string);
                for each (_local_8 in _local_6.expandMaxLimitList_vector)
                {
                    if (_local_8.name_string == this.GetBuildingName_string())
                    {
                        _local_7 = (_local_7 + (_local_8.amount + _local_3));
                        break;
                    };
                };
                if (_local_4 == null)
                {
                    cLog.warning((("Possible java.lang.NullPointerException in CalculateMaxLimitsForResources(" + _local_6.resourceName_string) + ")"));
                }
                else
                {
                    if ((_local_4.maxLimit - _local_7) < _local_4.amount)
                    {
                        _local_4 = _local_4.clone();
                        _local_4.amount = (_local_4.amount - (_local_4.maxLimit - _local_7));
                        _local_2.push(_local_4);
                    };
                };
                _local_5++;
            };
            return (_local_2);
        }

        public function IsBuildingActive():Boolean
        {
            if (this.mBuildingMode >= BUILDING_MODE_BUILDING_IS_ACTIVE_MIN)
            {
                return (true);
            };
            return (false);
        }

        public function IsBought():Boolean
        {
            return (!((this.mFlags & FLAG_BOUGHT) == 0));
        }

        public function BuyUpgrade():void
        {
            mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData).RemovePlayerResourcesFromResourcesInList(this.GetUpgradeCosts_vector(), 1, ModifyReason.BUY_BUILDING_UPGRADE);
        }

        override public function IsCursorPlacable(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            var _local_4:cBuilding;
            if (_arg_3 == COMMAND.SELECT_BUILDING)
            {
                _local_4 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_1);
                if (_local_4 != null)
                {
                    if (_local_4.mGoGroup == global.buildingGroup)
                    {
                        return (CURSOR_PLACABLE.BASEBUILDING_PLACE);
                    };
                }
                else
                {
                    _local_4 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(_arg_1);
                    if (_local_4 != null)
                    {
                        return (CURSOR_PLACABLE.BASEBUILDING_PLACE);
                    };
                };
                return (CURSOR_PLACABLE.UNPLACABLE);
            };
            return (CURSOR_PLACABLE.BASEBUILDING_PLACE);
        }

        override public function RenderTransform(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:Number, _arg_5:Number, _arg_6:Number):void
        {
            super.RenderTransform(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
        }

        public function IsDestructionInitiated():Boolean
        {
            return (!((this.mFlags & FLAG_DESTRUCTION_INITIATED) == 0));
        }

        public function GetBuildingMode():int
        {
            return (this.mBuildingMode);
        }

        public function IsConstructionStarted():Boolean
        {
            return (((this.mBuildingMode == cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE) || (this.mBuildingMode == cBuilding.BUILDING_MODE_CONSTRUCTION)) || (this.mBuildingMode == cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE));
        }

        public function GetDecorationType():String
        {
            return (this.GetGOContainer().mDecorationType);
        }

        public function GetBuildingNrFromName():int
        {
            return (this.mGoGroup.GetNrFromName(this.mBuildingName_string));
        }

        protected function renderProductionActive(_arg_1:int, _arg_2:int):void
        {
            if (((((!(this.mResourceCreation == null)) && (!(this.IsProductionLevelTooLow()))) && (!(this.IsProductionActive()))) && (cSettingsManager.getInstance().showStoppedProduction)))
            {
                gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION);
                gGfxResource.mBuildingInfoIcons.RenderPos(_arg_1, ((_arg_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
            };
        }

        public function GetUpgradeStartTime():Number
        {
            return (this.mBuildingUpgradeStartTime);
        }

        public function GetBuffs():Vector.<BuffAppliance>
        {
            return (this.mBuffs_vector);
        }

        public function shouldDestroyBuildingFromUnexploredSector():Boolean
        {
            if (((this.getPlayerID() >= 0) || (this.ignoreOnSectorClaim())))
            {
                return (false);
            };
            return (true);
        }

        public function FlagBandit(_arg_1:int):Boolean
        {
            this.mUpgradeLevel = (this.mUpgradeLevel | _arg_1);
            this.mDirtyIndicator.strongModified();
            return (true);
        }

        public function GetFlags():int
        {
            return (this.mFlags);
        }

        public function IsMoveInitiated():Boolean
        {
            return (!((this.mFlags & FLAG_MOVE_INITIATED) == 0));
        }

        public function IsBuildingInProduction():Boolean
        {
            if (this.mBuildingMode >= BUILDING_MODE_BUILDING_IS_IN_PRODUCTION_MIN)
            {
                return (true);
            };
            return (false);
        }

        public function InitOffsets(_arg_1:int, _arg_2:int):void
        {
            this.mOffsetX = _arg_1;
            this.mOffsetY = _arg_2;
        }

        private function GetBuffToRenderTooltip():BuffAppliance
        {
            var _local_2:cBuffDefinition;
            var _local_3:BuffAppliance;
            if (this.mBuffs_vector.length == 0)
            {
                return (null);
            };
            var _local_1:BuffAppliance;
            var _local_4:int;
            while (_local_4 < this.mBuffs_vector.length)
            {
                _local_3 = this.mBuffs_vector[_local_4];
                _local_2 = _local_3.GetBuffDefinition();
                if (((_local_2.ShouldRenderTimeLeftTooltip()) && ((_local_1 == null) || (_local_2.GetTooltipRenderPriority() >= _local_1.GetBuffDefinition().GetTooltipRenderPriority()))))
                {
                    _local_1 = _local_3;
                };
                _local_4++;
            };
            return (_local_1);
        }

        public function IsInstantUpgradeAllowed(_arg_1:Boolean):Boolean
        {
            if ((((((((((!(mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData) == null)) && (this.GetUpgradeInstantCosts() == 0)) || ((_arg_1) && (!(mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData).HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.GetUpgradeInstantCosts()))))) || (this.mBuildingMode == BUILDING_MODE_DESTRUCTION)) || (this.mBuildingMode == BUILDING_MODE_DESTRUCTED)) || (!(this.IsInUpgradableBuildingMode()))) || (this.IsUpgradeInitiatedWithGem())) || (!(this.isSpecialUpgradeConditionsMet()))) || (!(this.IsInstantUpgradeEnabled()))))
            {
                return (false);
            };
            return (true);
        }

        public function GetRemainingConstructionDuration():int
        {
            var _local_1:Number = 0;
            switch (this.mBuildingMode)
            {
                case cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE:
                case cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE:
                    if (((!(this.GetResourceCreation() == null)) && (!(this.GetResourceCreation().GetPath() == null))))
                    {
                        _local_1 = (_local_1 + (((this.GetResourceCreation().GetPath().pathLenX10000 - this.GetResourceCreation().pathPos) / cComputeResourceCreation.SETTLER_WALK_SPEED_INT) / mGeneralInterface.mGlobalTimeScale));
                    };
                case cBuilding.BUILDING_MODE_CONSTRUCTION:
                    if (this.GetGOContainer() != null)
                    {
                        _local_1 = (_local_1 + ((this.GetGOContainer().mConstructionDuration * 1000) * (1 - (this.mBuildingProgress / (100 * defines.BUILDING_PROGRESS_SCALE_FACTOR)))));
                    };
                    break;
            };
            return (int(_local_1));
        }

        public function removeBuff(_arg_1:BuffAppliance):void
        {
            var _local_2:int;
            while (_local_2 < this.mBuffs_vector.length)
            {
                if (this.mBuffs_vector[_local_2] == _arg_1)
                {
                    _arg_1.BuffRemoved(mGeneralInterface);
                    if (this.productionBuff == _arg_1)
                    {
                        this.productionBuff = null;
                    };
                    this.mBuffs_vector.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function executeOnDestroyEffects():void
        {
            var _local_1:EffectFactory;
            var _local_2:EffectVO;
            var _local_3:EffectVO;
            if (((!(this.GetGOContainer() == null)) && (!(this.GetGOContainer().buildingDestroyEffects_vector == null))))
            {
                _local_1 = (mGeneralInterface as cGameInterface).effectFactory;
                for each (_local_2 in this.GetGOContainer().buildingDestroyEffects_vector)
                {
                    _local_3 = _local_2.clone();
                    _local_3.targetX = (GetGrid() % mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                    _local_3.targetY = int((GetGrid() / mGeneralInterface.mCurrentPlayerZone.mMapWidth));
                    if (this.destroyedByPlayerID != 0)
                    {
                        _local_3.playerId = this.destroyedByPlayerID;
                    };
                    _local_1.createEffect(_local_3).apply();
                };
            };
        }

        public function setSkin(_arg_1:String):void
        {
            var _local_2:int;
            var _local_3:EffectVO;
            var _local_4:int;
            if (_arg_1 == this.mBuildingName_string)
            {
                _local_2 = this.mBuffs_vector.length;
                _local_4 = 0;
                while (_local_4 < _local_2)
                {
                    _local_3 = this.mBuffs_vector[_local_4].GetBuffDefinition().GetEffectByName(ChangeDefaultSkin.XML_string);
                    if (_local_3 != null)
                    {
                        _arg_1 = _local_3.name_string;
                        break;
                    };
                    _local_4++;
                };
            };
            this.skin = _arg_1;
            this.mDirtyIndicator.strongModified();
            setSpriteLib(this.mGoGroup.GetSpriteLibFromNameGOList(_arg_1));
            this.SetWorkAnimation(this.mGoGroup.GetSpriteLibFromAnimList(_arg_1));
            PostInit();
        }

        public function GetRecoveringHitPoints():int
        {
            return (this.mRecoveringHitPoints);
        }

        public function IsBuildingSelectable():Boolean
        {
            if (!this.mIsSelectable)
            {
                return (false);
            };
            return (((((!(this.mBuildingMode == BUILDING_MODE_NONE)) && (!(this.mBuildingMode == BUILDING_MODE_DESTRUCTION))) && (!(this.mBuildingMode == BUILDING_MODE_DESTRUCTED))) && (!(this.IsDestructionInitiated()))) && (!(this.IsMoveInitiated())));
        }

        public function isWorkyard():Boolean
        {
            return ((!(this.GetResourceCreation() == null)) && (!(this.GetResourceCreation().GetResourceCreationDefinition() == null)));
        }

        public function SetIsBought(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_BOUGHT);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_BOUGHT)));
            };
        }

        public function SetIsPreventDeletion(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_PREVENT_DELETION);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_PREVENT_DELETION)));
            };
        }

        private function renderProgressPercent():void
        {
            if (!((this.isSpecialUpgradeBuilding()) && (this.IsUpgradeInProgress())))
            {
                mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (this.mProgressPercent + "%"), GetXInt(), (GetYInt() - (global.streetGridYHalf * 1.75)));
            };
        }

        public function IsPreventDeletion():Boolean
        {
            return (!((this.mFlags & FLAG_PREVENT_DELETION) == 0));
        }

        public function GetUpgradeLevel():int
        {
            return (this.mUpgradeLevel);
        }

        public function IsInDestruction():Boolean
        {
            if ((((this.mBuildingMode == BUILDING_MODE_DESTRUCTION) || (this.mBuildingMode == BUILDING_MODE_DESTRUCTED)) || (this.IsDestructionInitiated())))
            {
                return (true);
            };
            return (false);
        }

        public function RenderBuildingLabels():void
        {
            if (this.mInterceptIndex > 0)
            {
                this.RenderInterceptionIndex(this.mInterceptIndex);
                this.mInterceptIndex = 0;
            };
            if (mGeneralInterface.mHomePlayer.GetPlayerId() <= defines.ADVENTUREZONEID)
            {
                if (this.mPlayerID > 0)
                {
                    if ((((!(mGeneralInterface.UsesCombatThree())) && (this.GetGOContainer().mMaxUnits > 0)) || ((mGeneralInterface.UsesCombatThree()) && (this.isGarrison()))))
                    {
                        this.RenderGeneralStateIcon();
                        if (((cSettingsManager.getInstance().showGeneralName) || (this.mIsMouseOver)))
                        {
                            this.RenderPlayerName();
                        };
                        if (this.IsGarrisonWaitForCommand())
                        {
                            if (mGeneralInterface.IsMoreThanOnePlayerOnMap())
                            {
                                gGfxResource.mWaitForCommandIcon.RenderPos(int((mXNotScaled + this.mOffsetX)), (int((mYNotScaled + this.mOffsetY)) - (global.streetGridY * 2)));
                            };
                        };
                    };
                };
            }
            else
            {
                if (this.mPlayerID > 0)
                {
                    if (((((!(mGeneralInterface.UsesCombatThree())) && (this.GetGOContainer().mMaxUnits > 0)) && (!(this.IsDecoration()))) || ((mGeneralInterface.UsesCombatThree()) && (this.isGarrison()))))
                    {
                        this.RenderGeneralStateIcon();
                    };
                };
            };
            if (this.mIsAreaBuffOver)
            {
                this.RenderUpgradeLevelAndPlayerColor();
                this.mIsAreaBuffOver = false;
            }
            else
            {
                if (this.productionBuff != null)
                {
                    if (StringUtils.startsWith(this.mBuildingName_string, defines.DESTROYABLE_MOUNTAIN_string))
                    {
                        this.renderMountainDemolitionPrepProgress();
                    };
                };
                if (this.mIsMouseOver)
                {
                    if ((((this.getPlayerID() > 0) && (!(this.GetUpgradeLevelBonusesForLevel(2) == null))) && (!(this.hasBuff(CollectionsConsts.REVEAL_FRIENDS_COLLECTIBLES_BUFF)))))
                    {
                        this.RenderUpgradeLevelAndPlayerColor();
                    };
                    if (!(((((mGeneralInterface.mHomePlayer.GetPlayerId() <= defines.ADVENTUREZONEID) && (mGeneralInterface.UsesCombatThree())) && (this.isGarrison())) && (this.getPlayerID() > 0)) && (this.GetGOContainer().mMaxUnits > 0)))
                    {
                        if (((this.mIsSelectable) && (!(this.isGarrison()))))
                        {
                            this.RenderBuildingName();
                        };
                    };
                    if ((((global.ui.isOnHomzone()) && (this.getPlayerID() > 0)) && (this.GetGOContainer().mMaxUnits > 0)))
                    {
                        this.RenderBuildingName();
                    };
                    if ((((!(CollectionsManager.getInstance().getBuildingIsCollectible(this.GetBuildingName_string()))) && ((this.mPlayerID == mGeneralInterface.mCurrentPlayer.GetPlayerId()) || (this.mPlayerID == -1))) && (((this.mBuildingMode == BUILDING_MODE_DESTRUCTION) || (this.mBuildingMode == BUILDING_MODE_CONSTRUCTION)) || (this.IsUpgradeInProgress()))))
                    {
                        this.renderProgressTimeRemaining();
                    };
                    if ((((((this.mPlayerID == mGeneralInterface.mHomePlayer.GetPlayerId()) && (!(this.IsUpgradeInProgress()))) && (!(this.mBuildingMode == BUILDING_MODE_DESTRUCTION))) && (!(StringUtils.startsWith(this.mBuildingName_string, defines.DESTROYABLE_MOUNTAIN_string)))) && (!(CollectionsManager.getInstance().getBuildingIsCollectible(this.GetBuildingName_string())))))
                    {
                        this.RenderBuffTimeLeft();
                    };
                    this.mIsMouseOver = false;
                }
                else
                {
                    if (((((!(CollectionsManager.getInstance().getBuildingIsCollectible(this.GetBuildingName_string()))) && (this.mBuildingMode == BUILDING_MODE_DESTRUCTION)) || (this.mBuildingMode == BUILDING_MODE_CONSTRUCTION)) || (this.IsUpgradeInProgress())))
                    {
                        this.renderProgressPercent();
                    };
                };
            };
            if (this.renderAttackCursor)
            {
                gGfxResource.mAttackCursor.RenderPos(mXNotScaled, (mYNotScaled - global.streetGridYHalf));
            };
        }

        public function IsResourceEnough(_arg_1:Vector.<dResource>):Boolean
        {
            if (!mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData).HasPlayerResourcesInListOne(_arg_1))
            {
                return (false);
            };
            return (true);
        }

        public function SetUniqueId(_arg_1:dUniqueID):void
        {
            this.mUniqueId = _arg_1;
            if (this.mResourceCreation != null)
            {
                this.mResourceCreation.SetUniqueID(_arg_1);
            };
        }

        public function InitFromVO(_arg_1:dBuildingVO):void
        {
            var _local_2:dSquadVO;
            var _local_3:dBuffApplianceVO;
            var _local_4:BuffAppliance;
            this.mUniqueId = _arg_1.uniqueId;
            this.mBuildingCreationTime = _arg_1.buildingCreationTime;
            this.mStartWorkCounter = _arg_1.startWorkCounter;
            this.mUpgradeLevel = _arg_1.upgradeLevel;
            this.SetCurrentHitPoints(_arg_1.hitPoints);
            this.mLastRepairTime = _arg_1.lastRepairTime;
            this.mRecoveringHitPoints = _arg_1.recoveringHitPoints;
            this.SetIsInitialSetOnMap(_arg_1.initialSetOnXMLMap);
            this.SetIsBought(_arg_1.isBought);
            this.SetIsProductionActive(_arg_1.isProductionActive);
            this.mBuildingDestructionTime = _arg_1.destructionTime;
            this.mBuildingUpgradeProgress = _arg_1.upgradeProgress;
            this.SetIsUpgradeInProgress(_arg_1.upgradeIsInProgress);
            this.mBuildingUpgradeStartTime = _arg_1.upgradeStartTime;
            this.mBuildingProgress = _arg_1.buildingProgress;
            this.mBuildingMode = _arg_1.buildingMode;
            this.mOffsetX = _arg_1.offsetX;
            this.mOffsetY = _arg_1.offsetY;
            this.mOrigin = _arg_1.origin;
            this.SetIsEngagedInCombat(_arg_1.isEngagedInCombat);
            this.mCampType = _arg_1.campType;
            this.mRecurringChance = _arg_1.recurringChance;
            if (_arg_1.specialCombatPreviewVO != null)
            {
                this.mSpecialCombatPreview = new cSpecialCombatPreview().createFromVO(_arg_1.specialCombatPreviewVO);
            };
            this.mPreCombatTipType = _arg_1.preCombatTipType;
            for each (_local_2 in _arg_1.armyVO.squads)
            {
                this.mArmy.AddSquadVO(_local_2, false);
            };
            for each (_local_3 in _arg_1.buffs)
            {
                _local_4 = BuffAppliance.CreateBuffApplianceFromVO(this, _local_3);
                this.mBuffs_vector.push(_local_4);
                if (BUFF_TYPE.isVisibleBuff(_local_4.GetBuffDefinition().GetBuffType()))
                {
                    this.productionBuff = _local_4;
                };
                if (_local_4.GetBuffDefinition().GetName_string().indexOf("ChangeColorScheme") > -1)
                {
                    gGfxResource.applyFilter(_local_4.GetResourceName_string(), mGeneralInterface);
                };
            };
            this.setSkin(_arg_1.skin);
            if (StringUtils.startsWith(this.ui, defines.DEFENSE_MODE_BUILDINGS_UI_string))
            {
                this.SetIsDefenseBuilding(true);
            };
            mGeneralInterface.mConditionManager.destroyTriggers(this);
            mGeneralInterface.mConditionManager.createTriggers(this, mGeneralInterface);
            mXScaled = ((mXNotScaled * mGeneralInterface.mZoom.mFactorDivDefaultZoom) + (this.mOffsetX * mGeneralInterface.mZoom.mFactorDivDefaultZoom));
            mYScaled = ((mYNotScaled * mGeneralInterface.mZoom.mFactorDivDefaultZoom) + (this.mOffsetY * mGeneralInterface.mZoom.mFactorDivDefaultZoom));
        }

        public function GetGemMovementCosts():int
        {
            var _local_3:dResource;
            var _local_1:int;
            var _local_2:ModifiableCost = this.GetMovementCosts();
            if (_local_2 != null)
            {
                for each (_local_3 in _local_2.cost)
                {
                    if (global.resourceHardcurrencyValues.hasOwnProperty(_local_3.name_string))
                    {
                        _local_1 = (_local_1 + int(((_local_3.amount * global.resourceHardcurrencyValues[_local_3.name_string]) * 0.05)));
                    };
                };
                if (!_local_2.isModified())
                {
                    _local_1 = Math.max(1, _local_1);
                };
            };
            return (_local_1);
        }

        override public function getPlayerID():int
        {
            return (this.mPlayerID);
        }

        private function removeExtraBuildingBuff():void
        {
            var _local_1:String;
            var _local_2:cBuffDefinition;
            if (((!(this.GetGOContainer() == null)) && (!(this.GetGOContainer().stackingBuffs_vector == null))))
            {
                for each (_local_1 in this.GetGOContainer().stackingBuffs_vector)
                {
                    _local_2 = cBuffDefinition.GetByName(_local_1);
                    mGeneralInterface.mZoneBuffManager.removeExtraBuildingBuff(_local_2);
                };
            };
        }

        public function GetResourceOutputFactor():int
        {
            var _local_7:BuffAppliance;
            var _local_9:cBuffDefinition;
            var _local_10:dPersistedBuffApplianceVO;
            var _local_1:cBuffDefinition = this.GetUpgradeLevelBonuses();
            if (_local_1 == null)
            {
                gMisc.Assert(false, ((((((("GetUpgradeLevelBonuses() not found for " + this.mBuildingName_string) + " (") + this.mUpgradeLevel) + ") at ") + GetGrid()) + " with GetGOContainer().buildingUpgradeBonuses_vector: ") + this.GetGOContainer().buildingUpgradeBonuses_vector));
            };
            var _local_2:int = int((_local_1.getProductivityOutputPercent() / 100));
            var _local_3:ArrayCollection = mGeneralInterface.mZoneBuffManager.getBuffAppliancesForBuilding(this.GetBuildingName_string());
            var _local_4:int = 100;
            var _local_5:int;
            var _local_6:int = this.mBuffs_vector.length;
            while (_local_5 < _local_6)
            {
                _local_7 = this.mBuffs_vector[_local_5];
                if (((_local_7.GetBuffDefinition().GetBuffType() == BUFF_TYPE.TIMED) || (_local_7.GetBuffDefinition().GetBuffType() == BUFF_TYPE.ZONE)))
                {
                    _local_4 = int((_local_4 * ((_local_7.GetBuffDefinition().getProductivityOutputPercent() / 100) * this.buffMultiplier)));
                };
                _local_5++;
            };
            var _local_8:int = 1;
            for each (_local_10 in _local_3)
            {
                _local_9 = cBuffDefinition.GetById(_local_10.buffID);
                _local_8 = int((_local_8 + ((_local_9.getProductivityOutputPercent() / 100) - 1)));
            };
            return (int(Math.ceil(((_local_2 + (_local_2 * ((_local_4 / 100) - 1))) + (_local_2 * (_local_8 - 1))))));
        }

        public function getSkin():String
        {
            return (this.skin);
        }

        public function set mBuildingProgress(_arg_1:Number):void
        {
            var _local_2:Object = this._1324158862mBuildingProgress;
            if (_local_2 !== _arg_1)
            {
                this._1324158862mBuildingProgress = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mBuildingProgress", _local_2, _arg_1));
            };
        }

        public function SetCurrentHitPoints(_arg_1:int):void
        {
            this.mCurrentHitPoints = Math.max(0, Math.min(this.GetMaxHitPoints(), _arg_1));
            var _local_2:cGOSetList = this.getDamageAnimEffectSet();
            if (_local_2 != null)
            {
                _local_2.SetValue(this.mCurrentHitPoints);
            };
            var _local_3:int = int((this.GetMaxHitPoints() / DAMAGE_LEVEL_AMOUNT));
            this.mCurrentDamageLevel = Math.round((this.mCurrentHitPoints / _local_3));
            this.mHealthBar = Math.min((this.mCurrentHitPoints / this.GetMaxHitPoints()), 1);
        }

        public function StartDestroySequence():void
        {
            if (this.mBuildingSubMode == BUILDING_MODE_NONE)
            {
                this.mBuildingSubMode = MOUNTAIN_BLOWING_UP_STEP_1;
            };
        }

        public function GetMovementCosts():ModifiableCost
        {
            return (this.GetMovementCostsForLevel(this.mUpgradeLevel));
        }

        public function GetSkipCooldownGemCost():int
        {
            return (this.GetGOContainer().mSkipCooldownGemCost);
        }

        private function renderPreBuild(_arg_1:int, _arg_2:int):void
        {
            if (this.mIsEventMonster)
            {
                return;
            };
            if (this.IsBuildOnWater())
            {
                gGfxResource.mPreBuildWater.mSprite.SetSubType(0);
                gGfxResource.mPreBuildWater.mSprite.RenderPosNoScaling(_arg_1, _arg_2);
            }
            else
            {
                gGfxResource.mPreBuild.mSprite.SetSubType(0);
                gGfxResource.mPreBuild.mSprite.RenderPosNoScaling(_arg_1, _arg_2);
            };
        }

        public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        protected function renderBuildingModeDestruction(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:cGOSetList = this.getDestructionAnimEffectSet();
            if (_local_6 != null)
            {
                _local_6.Animate(mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
                _local_6.Render(GetXInt(), GetYInt());
            };
        }

        public function SetBuildingName_string(_arg_1:String):void
        {
            this.mBuildingName_string = _arg_1;
            this.SetIsLeaderCamp(((this.GetGOContainer().mIsLeaderCamp) || (!(this.mBuildingName_string.indexOf("leader") == -1))));
            this.SetHasBuildingLayers(global.buildingLayerManager.hasLayers(_arg_1));
            if (this.HasBuildingLayers())
            {
                global.buildingLayerManager.initLayers(_arg_1);
            };
        }

        public function IsInUpgradableBuildingMode():Boolean
        {
            return ((((!(this.mBuildingMode == cBuilding.BUILDING_MODE_QUEUED)) && (!(this.mBuildingMode == cBuilding.BUILDING_MODE_CONSTRUCTION))) && (!(this.mBuildingMode == cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE))) && (!(this.mBuildingMode == cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE)));
        }

        public function UpdatedProductionState():void
        {
        }

        public function IsDestroyableMountain():Boolean
        {
            return (StringUtils.startsWith(this.GetBuildingName_string(), defines.DESTROYABLE_MOUNTAIN_string));
        }

        public function SetIsUpgradeInitiated(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_UPGRADE_INITIATED);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_UPGRADE_INITIATED)));
            };
        }

        public function SetIsLeaderCamp(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_IS_LEADER);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_IS_LEADER)));
            };
        }

        public function getWorkyardToDepositTime():Number
        {
            return (this.mWayWorkyardToDeposit);
        }

        public function removeBuilding(_arg_1:Boolean):void
        {
            if (this.GetGOContainer().mAddDepositAmount != -1)
            {
                mGeneralInterface.mCurrentPlayerZone.RemoveAtGridPosition(this.mPlayerData, OBJECTTYPE.DEPOSIT, GetGrid());
            };
            mGeneralInterface.mCurrentPlayerZone.RemoveAtGridPosition(this.mPlayerData, OBJECTTYPE.BUILDING, GetGrid());
            var _local_2:cResources = mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData);
            if (_local_2 != null)
            {
                _local_2.CalculateMaxLimitsForResources(this.mPlayerData.GetPlayerId());
            };
            this.removeExtraBuildingBuff();
            if (_arg_1)
            {
                this.executeOnDestroyEffects();
            };
            mGeneralInterface.channels.BUILDING.send(BUILDING_REMOVED_string, this);
        }

        public function CreateFlagEffectSet(_arg_1:String):void
        {
            this.mFlagEffectSet = cGOSetManager.CreateGOSetList(_arg_1, null);
            this.mFlagEffectSet.SetSubTypeCurrentGOSetItem(mGeneralInterface.mCurrentPlayerZone.GetPlayerColorIdx(this.getPlayerID()));
        }

        protected function RenderPlayerName():void
        {
            if (this._renderPlayerName == null)
            {
                return;
            };
            if (this._renderSpecialistName != null)
            {
                mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, this._renderSpecialistName, GetXInt(), ((GetYInt() - (global.streetGridY * 2)) + 68));
            };
            mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, this._renderPlayerName, GetXInt(), ((GetYInt() - (global.streetGridY * 2)) + 34));
        }

        public function DamageBuilding(_arg_1:int, _arg_2:cPlayerData):int
        {
            if (_arg_1 == 0)
            {
                return (0);
            };
            var _local_3:int;
            this.SetCurrentHitPoints((this.mCurrentHitPoints - _arg_1));
            notifyPropertyObserver(BUILDING_DAMAGED_string, this.mCurrentHitPoints);
            if (this.mCurrentHitPoints <= 0)
            {
                _local_3 = mGeneralInterface.mCurrentPlayerZone.DestroyBuildingByAttack(this, _arg_2);
                mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RemoveBuildingFromGameLogic(this);
            };
            this.mDirtyIndicator.strongModified();
            return (_local_3);
        }

        private function RenderInterceptionIndex(_arg_1:int):void
        {
            mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, _arg_1.toString(), GetXInt(), ((GetYInt() - (global.streetGridY * 2)) + 85));
        }

        public function isGarrison():Boolean
        {
            return (this.GetGOContainer().ui == BUILDING_CATEGORY_GARRISON);
        }

        public function SetResourceCreation(_arg_1:cResourceCreation):void
        {
            this.mResourceCreation = _arg_1;
        }

        public function setIsSpecialUpgradeBuilding(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_IS_SPECIAL_UPGRADE_BUILDING);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_IS_SPECIAL_UPGRADE_BUILDING)));
            };
        }

        public function IsWarehouseType():Boolean
        {
            return (this.mGoGroup.IsWarehouse(this.mBuildingName_string));
        }

        public function IsGemEnough(_arg_1:int):Boolean
        {
            if (!mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData).HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _arg_1))
            {
                return (false);
            };
            return (true);
        }

        public function IsBuildingOfType(_arg_1:String):Boolean
        {
            return (this.mBuildingName_string == _arg_1);
        }

        public function GetRefundResources():Vector.<dResource>
        {
            var _local_2:dResource;
            var _local_1:Vector.<dResource> = this.mPlayerData.GetRefundResourcesByReturnRate(this.GetGOContainer().mGfxResourceListName_string);
            if (((this.mOrigin == cBuilding.BUILDING_ORIGIN_FROM_GAME) && (this.mPlayerData.IsBuildingCounted(this.mBuildingName_string))))
            {
                _local_2 = new dResource();
                _local_2.name_string = "Building";
                _local_2.amount = 1;
                _local_1.push(_local_2);
            };
            return (_local_1);
        }

        public function GetUpgradeLevelBonusesForLevel(_arg_1:int):cBuffDefinition
        {
            var _local_2:Vector.<cBuffDefinition> = this.GetGOContainer().buildingUpgradeBonuses_vector;
            if (_local_2 == null)
            {
                _local_2 = global.buildingUpgradeBonuses_vector;
            };
            if (_arg_1 < _local_2.length)
            {
                return (_local_2[_arg_1]);
            };
            return (null);
        }

        public function getCooldownTimeBonus():Number
        {
            if (mGeneralInterface.cooldownManager.hasBonusProvider(COOLDOWN_TYPE.fromTimedProduction(this.productionType)))
            {
                return (mGeneralInterface.cooldownManager.getBonusProvider(COOLDOWN_TYPE.fromTimedProduction(this.productionType)).getCooldownTimeBonus());
            };
            return (100);
        }

        public function IsWaitForCommand():Boolean
        {
            return (!((this.mFlags & FLAG_WAIT_FOR_COMMAND) == 0));
        }

        override public function GetGOContainer():cGOSpriteLibContainer
        {
            return (this.originalSprite.GetContainer() as cGOSpriteLibContainer);
        }

        public function SetIsDestructionInitiated(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_DESTRUCTION_INITIATED);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_DESTRUCTION_INITIATED)));
            };
        }

        override public function RenderCursorTypeXY(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:int = ((_arg_3 == CURSOR_RENDERMODE.PLACABLE) ? RENDER_MODE.HIGHLIGHT : RENDER_MODE.NOT_PLACABLE);
            if (this.HasBuildingLayers())
            {
                global.buildingLayerManager.renderBefore(this.mBuildingName_string, false, _arg_1, _arg_2, _local_4);
            };
            super.RenderCursorTypeXY(_arg_1, _arg_2, _arg_3);
            if (this.HasBuildingLayers())
            {
                global.buildingLayerManager.renderBefore(this.mBuildingName_string, false, _arg_1, _arg_2, _local_4);
            };
        }

        public function RepairBuilding(_arg_1:int):void
        {
            if (_arg_1 == 0)
            {
                return;
            };
            this.SetCurrentHitPoints((this.mCurrentHitPoints + _arg_1));
            if (this.mCurrentHitPoints > this.GetMaxHitPoints())
            {
                this.mCurrentHitPoints = this.GetMaxHitPoints();
            };
            this.mDirtyIndicator.strongModified();
        }

        public function SetSpriteWorkAnim(_arg_1:cSpriteLib):void
        {
            this.mSpriteWorkAnim = _arg_1;
        }

        public function GetSpriteWorkAnim():cSpriteLib
        {
            return (this.mSpriteWorkAnim);
        }

        override public function GetResourceCreationBuildingName_string():String
        {
            return (this.mBuildingName_string);
        }

        public function SetProductionActive(_arg_1:Boolean):void
        {
            this.SetIsProductionActive(_arg_1);
            this.mDirtyIndicator.strongModified();
            this.SetIsWaitForCommand(false);
            if (this.GetResourceCreation() != null)
            {
                if (!_arg_1)
                {
                    this.GetResourceCreation().SetProductionState(cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION);
                }
                else
                {
                    this.GetResourceCreation().SetProductionState(cResourceCreation.PRODUCTIONSTATE_WORKING);
                };
            };
            globalFlash.gui.mBuildingInfoPanel.DisplayProductionState(this);
        }

        public function GetRemainingDestructionDurationInMS():int
        {
            return ((this.GetGOContainer().mDestructionDuration * 1000) - int((mGeneralInterface.GetClientTime() - this.mBuildingDestructionTime)));
        }

        [Bindable(event="propertyChange")]
        public function get mBuildingProgress():Number
        {
            return (this._1324158862mBuildingProgress);
        }

        override public function render(_arg_1:uint):void
        {
            if (_arg_1 == RENDER_LAYER.LABELS)
            {
                this.RenderBuildingLabels();
            }
            else
            {
                this.Render();
            };
        }

        public function IsBuffable():Boolean
        {
            return (this.mGoGroup.IsBuffable(this.mBuildingName_string));
        }

        public function getDamageAnimEffectSet():cGOSetList
        {
            if (this.GetCurrentHitPoints() >= this.GetMaxHitPoints())
            {
                this.mDamageAnimEffectSet = null;
                return (null);
            };
            if (this.mDamageAnimEffectSet == null)
            {
                if (this.GetCurrentHitPoints() < this.GetMaxHitPoints())
                {
                    this.mDamageAnimEffectSet = cGOSetManager.CreateGOSetList("damageAnimEffectSet", new cGOSetListControllerPercentage(this.GetMaxHitPoints()));
                    this.mDamageAnimEffectSet.SetValue(this.GetCurrentHitPoints());
                };
            };
            return (this.mDamageAnimEffectSet);
        }

        public function IsUpgradeInProgress():Boolean
        {
            return (!((this.mFlags & FLAG_UPGRADE_IN_PROGRESS) == 0));
        }

        public function SetCollectibleMode():void
        {
        }

        public function SetOffsets(_arg_1:int, _arg_2:int):void
        {
            this.mOffsetX = _arg_1;
            this.mOffsetY = _arg_2;
            this.mDirtyIndicator.strongModified();
        }

        public function IsUpgradeInitiated():Boolean
        {
            return (!((this.mFlags & FLAG_UPGRADE_INITIATED) == 0));
        }

        public function refundUpgrade():void
        {
            mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData).RefundPlayerResourcesFromResourcesInListInPercent(this.GetUpgradeCosts_vector(), 100, this.mPlayerData, false);
        }

        public function Refund():void
        {
            if (this.IsBought())
            {
                mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData).RefundBuildingResourcesToPlayerResources(this.GetGOContainer().mGfxResourceListName_string, this.mPlayerData);
            };
        }

        public function IsDecoration():Boolean
        {
            return (this.GetGOContainer().mEnumGoSubType == GO_SUBTYPE.DECORATION);
        }

        override public function SetPosition(_arg_1:Number, _arg_2:Number):void
        {
            mXNotScaled = _arg_1;
            mYNotScaled = _arg_2;
            mXScaled = ((_arg_1 * mGeneralInterface.mZoom.mFactorDivDefaultZoom) + (this.mOffsetX * mGeneralInterface.mZoom.mFactorDivDefaultZoom));
            mYScaled = ((_arg_2 * mGeneralInterface.mZoom.mFactorDivDefaultZoom) + (this.mOffsetY * mGeneralInterface.mZoom.mFactorDivDefaultZoom));
            updateRenderPosition();
        }

        public function getProductionBuildingName():String
        {
            return (this.GetBuildingName_string());
        }

        public function GetMaxHitPoints():int
        {
            var _local_1:cBuffDefinition;
            if (this.mMaxHitPoints <= 0)
            {
                this.mMaxHitPoints = this.GetGOContainer().mHitPoints;
                if (this.mUpgradeLevel > 1)
                {
                    _local_1 = this.GetUpgradeLevelBonuses();
                    if (_local_1 == null)
                    {
                        gMisc.Assert(false, ((((((("GetUpgradeLevelBonuses() not found for " + this.mBuildingName_string) + " (") + this.mUpgradeLevel) + ") at ") + GetGrid()) + " with GetGOContainer().buildingUpgradeBonuses_vector: ") + this.GetGOContainer().buildingUpgradeBonuses_vector));
                    };
                    this.mMaxHitPoints = (this.mMaxHitPoints + _local_1.getHitPoints());
                };
            };
            return (Math.max(1, this.mMaxHitPoints));
        }

        public function IsDefenseModeGarrison():Boolean
        {
            return ((((StringUtils.startsWith(this.mBuildingName_string, defines.PLAYER_CAV_EXPEDITION_CAMP_string)) || (StringUtils.startsWith(this.mBuildingName_string, defines.PLAYER_MELEE_EXPEDITION_CAMP_string))) || (StringUtils.startsWith(this.mBuildingName_string, defines.PLAYER_MIXED_EXPEDITION_CAMP_string))) || (StringUtils.startsWith(this.mBuildingName_string, defines.PLAYER_RANGED_EXPEDITION_CAMP_string)));
        }

        public function SetWorkAnimSubtype(_arg_1:int):void
        {
            this.mSpriteWorkAnim.SetSubType(_arg_1);
        }

        public function renderMountainDemolitionPrepProgress():void
        {
            var _local_1:int = int((mXNotScaled + this.mOffsetX));
            var _local_2:int = ((int((mYNotScaled + this.mOffsetY)) - (global.streetGridY * 1.5)) + 20);
            var _local_3:int = int((mGeneralInterface.GetClientTime() - this.mBuffs_vector[0].GetStartTime()));
            var _local_4:Number = ((_local_3 * 10) / this.mBuffs_vector[0].GetBuffDefinition().getDuration(0));
            gGfxResource.mProgressBarIcons.SetSubTypeAndFrame((_local_4 + 1), 0);
            gGfxResource.mProgressBarIcons.RenderPos((_local_1 - (gGfxResource.mProgressBarIcons.mSprite.GetWidth() / 2)), _local_2);
            var _local_5:Number = (this.mBuffs_vector[0].GetBuffDefinition().getDuration(0) - _local_3);
            var _local_6:String = cLocaManager.GetInstance().FormatDuration(_local_5, cLocaManager.DURATION_FORMAT_SHORT);
            mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, _local_6, _local_1, (_local_2 + 12));
        }

        public function getShouldComputeSmokeEffect():Boolean
        {
            if (this.GetGOContainer().mShowSmokeEvenIfNotWorking)
            {
                return (true);
            };
            if (((this.mBuildingMode == BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_LOCAL_WORKYARD_SYSTEM) || (this.mBuildingMode == BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_EXTERNAL_WORKYARD_SYSTEM_ACTIVE)))
            {
                if (((!(this.mResourceCreation == null)) && (this.mResourceCreation.GetProductionState() == cResourceCreation.PRODUCTIONSTATE_WORKING)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function GetUpgradeDuration():int
        {
            var _local_1:cBuffDefinition = this.GetUpgradeLevelBonusesForLevel((this.mUpgradeLevel + 1));
            if (_local_1 == null)
            {
                return (-1);
            };
            return (_local_1.GetProductionTime());
        }

        public function GetRepairCosts():Vector.<dResource>
        {
            var _local_2:dResource;
            var _local_3:dResource;
            var _local_1:Vector.<dResource> = new Vector.<dResource>();
            if (this.GetCurrentHitPoints() < this.GetMaxHitPoints())
            {
                for each (_local_2 in this.GetGOContainer().mCostList_vector)
                {
                    _local_3 = new dResource();
                    _local_3.name_string = _local_2.name_string;
                    _local_3.amount = int((((_local_2.amount * global.repairCostFactor) * this.mHealthBar) / 100));
                    _local_1.push(_local_3);
                };
            };
            return (_local_1);
        }

        public function GetResourceInputFactor():int
        {
            var _local_4:BuffAppliance;
            var _local_1:cBuffDefinition = this.GetUpgradeLevelBonuses();
            if (_local_1 == null)
            {
                gMisc.Assert(false, ((((((("GetUpgradeLevelBonuses() not found for " + this.mBuildingName_string) + " (") + this.mUpgradeLevel) + ") at ") + GetGrid()) + " with GetGOContainer().buildingUpgradeBonuses_vector: ") + this.GetGOContainer().buildingUpgradeBonuses_vector));
            };
            var _local_2:int = int((_local_1.getProductivityInputPercent() / 100));
            var _local_3:int;
            while (_local_3 < this.mBuffs_vector.length)
            {
                _local_4 = this.mBuffs_vector[_local_3];
                if (((_local_4.GetBuffDefinition().GetBuffType() == BUFF_TYPE.TIMED) || (_local_4.GetBuffDefinition().GetBuffType() == BUFF_TYPE.ZONE)))
                {
                    _local_2 = int((_local_2 * (_local_4.GetBuffDefinition().getProductivityInputPercent() / 100)));
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function SetCampType(_arg_1:int):void
        {
            this.mCampType = _arg_1;
        }

        protected function canHandleCollectibleBuff():Boolean
        {
            return (false);
        }

        public function GetExactOutputFactor():int
        {
            var _local_1:cBuffDefinition = this.GetUpgradeLevelBonuses();
            if (_local_1 == null)
            {
                gMisc.Assert(false, ((((((("GetUpgradeLevelBonuses() not found for " + this.mBuildingName_string) + " (") + this.mUpgradeLevel) + ") at ") + GetGrid()) + " with GetGOContainer().buildingUpgradeBonuses_vector: ") + this.GetGOContainer().buildingUpgradeBonuses_vector));
            };
            return (_local_1.getProductivityOutputPercent() / 100);
        }

        public function SetIsWaitForCommand(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_WAIT_FOR_COMMAND);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_WAIT_FOR_COMMAND)));
            };
        }

        public function IsMovable():Boolean
        {
            return (this.mGoGroup.IsMovable(this.mBuildingName_string));
        }

        override public function Render():void
        {
            var _local_3:int;
            var _local_4:Boolean;
            var _local_5:cGOSetList;
            var _local_6:Number;
            var _local_7:cGOSetList;
            var _local_1:int = int((mXNotScaled + this.mOffsetX));
            var _local_2:int = int((mYNotScaled + this.mOffsetY));
            switch (this.mBuildingMode)
            {
                case BUILDING_MODE_PLACED:
                    this.renderPreBuild(mXScaled, mYScaled);
                    return;
                case BUILDING_MODE_QUEUED:
                    this.renderPreBuild(mXScaled, mYScaled);
                    if (this.mResourceCreation != null)
                    {
                        _local_3 = this.mResourceCreation.GetProductionStateIconIndex();
                        if (_local_3 > -1)
                        {
                            if (((!(_local_3 == cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING)) || ((_local_3 == cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING) && (cSettingsManager.getInstance().showMissingResources))))
                            {
                                gGfxResource.mBuildingInfoIcons.SetSubType(_local_3);
                                gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridYHalf)) - mGeneralInterface.mWobblingInt));
                            };
                        }
                        else
                        {
                            gGfxResource.mBuildingQueuedIcon.RenderPos(_local_1, (_local_2 - (global.streetGridY * 2)));
                        };
                    };
                    return;
                case BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE:
                case BUILDING_MODE_SET_BUILDING_GROUND_PLACE:
                    this.renderPreBuild(mXScaled, mYScaled);
                    if (this.mResourceCreation != null)
                    {
                        _local_3 = this.mResourceCreation.GetProductionStateIconIndex();
                        if (_local_3 > -1)
                        {
                            gGfxResource.mBuildingInfoIcons.SetSubType(_local_3);
                            gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridYHalf)) - mGeneralInterface.mWobblingInt));
                        };
                    };
                    return;
                case BUILDING_MODE_CONSTRUCTION:
                    this.renderPreBuild(mXScaled, mYScaled);
                    if (this.getConstructionAnimEffectSet() != null)
                    {
                        this.getConstructionAnimEffectSet().SetValue(this.mProgressPercent);
                        this.getConstructionAnimEffectSet().Animate(mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
                        this.getConstructionAnimEffectSet().Render(GetXInt(), GetYInt());
                    };
                    return;
                case BUILDING_MODE_DESTRUCTION:
                    this.renderBuildingModeDestruction(this.mProgressPercent, mXScaled, mYScaled, _local_1, _local_2);
                    return;
                case BUILDING_MODE_EPIC_MONSTER_DYING_EFFECT:
                    this.renderBuildingModeDestruction(this.mProgressPercent, mXScaled, mYScaled, _local_1, _local_2);
                    return;
                case BUILDING_DESTRUCTION_READY:
                    if (this.getConstructionAnimEffectSet() != null)
                    {
                        this.getConstructionAnimEffectSet().AnimateUntilFinished(0);
                    };
                    if (this.getDestructionAnimEffectSet() != null)
                    {
                        this.getDestructionAnimEffectSet().AnimateUntilFinished(0);
                    };
                    switch (this.mBuildingSubMode)
                    {
                        case MOUNTAIN_BLOWING_UP_STEP_1:
                            super.Render();
                            if (this.getConstructionAnimEffectSet() != null)
                            {
                                if (this.getConstructionAnimEffectSet().AnimateUntilFinished(mGeneralInterface.mCalculateTicks.mDeltaTicksOne))
                                {
                                    this.mBuildingSubMode = MOUNTAIN_BLOWING_UP_STEP_2;
                                    cSoundManager.getInstance().playEffect("MountainDestruction");
                                };
                                this.getConstructionAnimEffectSet().Render((GetXInt() - (global.streetGridX * 0.25)), (GetYInt() - (global.streetGridY * 3)));
                            }
                            else
                            {
                                cLog.info("Can't find Mountain 'Construction'-Animation");
                            };
                            break;
                        case MOUNTAIN_BLOWING_UP_STEP_2:
                            if (this.getDestructionAnimEffectSet() != null)
                            {
                                if (this.getDestructionAnimEffectSet().AnimateUntilFinished(mGeneralInterface.mCalculateTicks.mDeltaTicksOne))
                                {
                                    this.mBuildingSubMode = MOUNTAIN_BLOWING_UP_STEP_3;
                                };
                                this.getDestructionAnimEffectSet().Render(GetXInt(), GetYInt());
                            }
                            else
                            {
                                super.Render();
                                cLog.info("Can't find Mountain 'Destruction'-Animation");
                            };
                            break;
                        case MOUNTAIN_BLOWING_UP_STEP_3:
                            mGeneralInterface.mCurrentPlayerZone.SendDestructMountainCommand(GetGrid());
                            break;
                        default:
                            super.Render();
                            if (this.mCursorHighlight)
                            {
                                super.mSprite.RenderTransform2NoScaling(mXScaled, (mYScaled + (mRenderOffsetY * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), BlendMode.SCREEN, 1, 1, 0);
                            };
                            gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.MOUNTAIN_DESTRUCTION_PREPARATION);
                            gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY * 2)) - mGeneralInterface.mWobblingInt));
                    };
                    return;
                default:
                    if (mSprite.GetContainer().mNofStreamUpgrades != 0)
                    {
                        SetSubType(gCalculations.CalculateGFXUpgradeLevel(this.mUpgradeLevel, (mSprite.GetContainer().mNofStreamUpgrades - 1)));
                    }
                    else
                    {
                        SetSubType(gCalculations.CalculateGFXUpgradeLevel(this.mUpgradeLevel, (GetNofSubTypes() - 1)));
                    };
                    _local_4 = ((((this.mCursorHighlight) || (((mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.APPLY_BUFF) && ((!(global.buffingBlockedUntil[GetGrid()])) || (global.buffingBlockedUntil[GetGrid()] < gMisc.GetTimeSinceStartup()))) && (mGeneralInterface.mCurrentCursor.canApplyBuff(mGeneralInterface.mCurrentPlayer, mGeneralInterface, GetGrid()) === this))) || ((((mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ATTACK_BUILDING) && (this.mPlayerID < 0)) && (!(this.mPlayerID == mGeneralInterface.mHomePlayer.GetPlayerId()))) && (this.getBuildingIsAttackable()))) && (!(this.mPlayerID == 0)));
                    if (this.HasBuildingLayers())
                    {
                        global.buildingLayerManager.renderBefore(this.mBuildingName_string, ((this.IsProductionActive()) && (!(this.IsProductionLevelTooLow()))), (_local_1 + (mRenderOffsetX * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), (_local_2 + (mRenderOffsetY * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), ((_local_4) ? RENDER_MODE.HIGHLIGHT : RENDER_MODE.NORMAL));
                    };
                    if (_local_4)
                    {
                        if (((this.GetGOContainer().useDefaultHighlight) || (!(gGfxResource.gUseFilterType == FILTER.TUNDRA))))
                        {
                            super.Render();
                            super.mSprite.RenderTransform2NoScaling((mXScaled + (mRenderOffsetX * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), (mYScaled + (mRenderOffsetY * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), BlendMode.SCREEN, 1, 1, 0);
                        }
                        else
                        {
                            super.mSprite.RenderOutline((mXScaled + (mRenderOffsetX * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), (mYScaled + (mRenderOffsetY * mGeneralInterface.mZoom.mFactorDivDefaultZoom)));
                        };
                    }
                    else
                    {
                        super.Render();
                    };
                    if (this.mSpriteWorkAnim != null)
                    {
                        this.mSpriteWorkAnim.RenderPosNoScaling((mXScaled + (mRenderOffsetX * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), (mYScaled + (mRenderOffsetY * mGeneralInterface.mZoom.mFactorDivDefaultZoom)));
                    };
                    if (this.HasBuildingLayers())
                    {
                        global.buildingLayerManager.renderAfter(this.mBuildingName_string, ((this.IsProductionActive()) && (!(this.IsProductionLevelTooLow()))), (_local_1 + (mRenderOffsetX * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), (_local_2 + (mRenderOffsetY * mGeneralInterface.mZoom.mFactorDivDefaultZoom)), ((_local_4) ? RENDER_MODE.HIGHLIGHT : RENDER_MODE.NORMAL));
                    };
                    if (this.mRecoveringHitPoints > 0)
                    {
                        gGfxResource.mBuildingRepairIcon.RenderPos(_local_1, int(((_local_2 - (global.streetGridY * 1.75)) + 10)));
                    };
                    if (this.mCurrentHitPoints < this.mMaxHitPoints)
                    {
                        gGfxResource.mHealthBarIcons.SetSubTypeAndFrame(this.mCurrentDamageLevel, 0);
                        gGfxResource.mHealthBarIcons.RenderPos((_local_1 - (gGfxResource.mHealthBarIcons.mSprite.GetWidth() / 2)), ((_local_2 - (global.streetGridY * 1)) + 10));
                    };
                    _local_5 = this.getDamageAnimEffectSet();
                    if (_local_5 != null)
                    {
                        _local_5.Render(GetXInt(), GetYInt());
                    };
                    if (this.IsUpgradeInProgress())
                    {
                        if (this.isSpecialUpgradeBuilding())
                        {
                            if (this.mBuffTwinkleEffectSet != null)
                            {
                                this.mBuffTwinkleEffectSet.Render((_local_1 + 10), _local_2);
                            };
                        }
                        else
                        {
                            gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.BUILDINGUPGRADE_PRODUCTIONSTATE_UPDATE_IN_PROGRESS);
                            gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                        };
                    }
                    else
                    {
                        this.renderProductionActive(_local_1, _local_2);
                        if (((!(this.mResourceCreation == null)) && (!(this.IsProductionLevelTooLow()))))
                        {
                            _local_3 = this.mResourceCreation.GetProductionStateIconIndex();
                            if (_local_3 > -1)
                            {
                                _local_6 = (mGeneralInterface.GetClientTime() - this.mBuildingCreationTime);
                                if (_local_6 < defines.BUILDING_INFO_ICON_TIME_FOR_DELAY)
                                {
                                    if (this.mBuildingInfoIconDelayEndTime == -1)
                                    {
                                        this.mBuildingInfoIconDelayEndTime = (gMisc.GetTimeSinceStartup() + global.buildingInfoIconDelay);
                                    };
                                }
                                else
                                {
                                    this.mBuildingInfoIconDelayEndTime = -1;
                                };
                                if (((this.IsProductionActive()) && (this.mBuildingInfoIconDelayEndTime < gMisc.GetTimeSinceStartup())))
                                {
                                    switch (_local_3)
                                    {
                                        case cResourceCreation.PRODUCTIONSTATE_ERROR_WAREHOUSE_FULL:
                                            if (cSettingsManager.getInstance().showFullWarehouse)
                                            {
                                                gGfxResource.mBuildingInfoIcons.SetSubType(_local_3);
                                                gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                                            };
                                            break;
                                        case cResourceCreation.PRODUCTIONSTATE_ERROR_WAITING_FOR_SETTLER:
                                            if (cSettingsManager.getInstance().showMissingSettler)
                                            {
                                                gGfxResource.mBuildingInfoIcons.SetSubType(_local_3);
                                                gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                                            };
                                            break;
                                        case cResourceCreation.PRODUCTIONSTATE_ERROR_NECESSARY_RESOURCE_MISSING:
                                            if (cSettingsManager.getInstance().showMissingResources)
                                            {
                                                gGfxResource.mBuildingInfoIcons.SetSubType(_local_3);
                                                gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                                            };
                                            break;
                                        default:
                                            gGfxResource.mBuildingInfoIcons.SetSubType(_local_3);
                                            gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                                    };
                                };
                            }
                            else
                            {
                                this.mBuildingInfoIconDelayEndTime = -1;
                                if (((this.mBuildingMode == BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_LOCAL_WORKYARD_SYSTEM) || (this.mBuildingMode == BUILDING_MODE_WORKANIM_IS_WORKING_AT_WORKYARD_EXTERNAL_WORKYARD_SYSTEM_ACTIVE)))
                                {
                                    if (((!(this.mSmokeEffectSet == null)) && (cSettingsManager.getInstance().showSmoke)))
                                    {
                                        this.renderSmokeEffect(_local_1, _local_2);
                                    };
                                };
                            };
                            if (((!(this.IsProductionActive())) && (cSettingsManager.getInstance().showStoppedProduction)))
                            {
                                gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.PRODUCTIONSTATE_STOPPED_PRODUCTION);
                                gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                            };
                        }
                        else
                        {
                            if (((((!(this.productionQueue == null)) && (this.productionQueue.mTimedProductions_vector.length > 0)) && (this.productionQueue.mTimedProductions_vector[0].readyForDeliver)) && (this.showWaitForPickupIcon)))
                            {
                                gGfxResource.mBuildingInfoIcons.SetSubType(this.waitForPickupSpriteIndex);
                                gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                            };
                            if (this.GetGOContainer().mShowSmokeEvenIfNotWorking)
                            {
                                for each (_local_7 in this.mSmokeEffectSet)
                                {
                                    _local_7.Render(_local_1, _local_2);
                                };
                            };
                        };
                    };
                    if (((this.mSpecialUpgradeReady) && (!(this.IsUpgradeInProgress()))))
                    {
                        gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.BUILDINGUPGRADE_TRIGGERS_FULFILLED);
                        gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                    };
                    this.RenderFlag();
                    if (((!(this.mSpecialCombatPreview == null)) && (this.IsLeaderCamp())))
                    {
                        gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.DIFFICULT_LEADER_BANDIT_STATE);
                        gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                        this.mPreCombatType = cResourceCreation.DIFFICULT_LEADER_BANDIT_STATE;
                    }
                    else
                    {
                        if (this.mSpecialCombatPreview != null)
                        {
                            gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.DIFFICULT_BANDIT_STATE);
                            gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                            this.mPreCombatType = cResourceCreation.DIFFICULT_BANDIT_STATE;
                        }
                        else
                        {
                            if (((this.IsLeaderCamp()) && (this.mBuildingName_string.indexOf("Deco") == -1)))
                            {
                                gGfxResource.mBuildingInfoIcons.SetSubType(cResourceCreation.LEADER_BANDIT_STATE);
                                gGfxResource.mBuildingInfoIcons.RenderPos(_local_1, ((_local_2 - (global.streetGridY + global.streetGridY)) - mGeneralInterface.mWobblingInt));
                                this.mPreCombatType = cResourceCreation.LEADER_BANDIT_STATE;
                            };
                        };
                    };
                    if (this.productionBuff != null)
                    {
                        if ((((!(this.mBuffTwinkleEffectSet == null)) && (!(StringUtils.startsWith(this.mBuildingName_string, defines.DESTROYABLE_MOUNTAIN_string)))) && (cSettingsManager.getInstance().showBuffAnimations)))
                        {
                            this.mBuffTwinkleEffectSet.Render(_local_1, _local_2);
                        };
                    };
            };
        }

        public function IsLastWarehouseInSector():Boolean
        {
            var _local_3:cBuilding;
            var _local_1:cGeneralInterface = global.ui;
            var _local_2:int = _local_1.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(GetGrid(), AdditionalDataTSO.Sector);
            for each (_local_3 in _local_1.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if (_local_3 != null)
                {
                    if (_local_1.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_3.GetGrid(), AdditionalDataTSO.Sector) == _local_2)
                    {
                        if (((((_local_3.IsWarehouseType()) && (!(_local_3.GetGrid() == GetGrid()))) && (_local_3.GetBuildingMode() > BUILDING_MODE_PLACED)) && (!(_local_3.IsDestructionInitiated()))))
                        {
                            return (false);
                        };
                    };
                };
            };
            return (true);
        }

        public function CreateBuildingVOFromBuilding():dBuildingVO
        {
            var _local_2:cSquad;
            var _local_3:BuffAppliance;
            var _local_1:dBuildingVO = new dBuildingVO();
            _local_1.buildingCreationTime = this.mBuildingCreationTime;
            _local_1.buildingName_string = this.GetBuildingName_string();
            _local_1.buildingGrid = GetGrid();
            _local_1.uniqueId = this.GetUniqueId();
            _local_1.buildingMode = this.GetBuildingMode();
            _local_1.startWorkCounter = this.mStartWorkCounter;
            _local_1.upgradeLevel = this.GetUpgradeLevel();
            _local_1.hitPoints = this.GetCurrentHitPoints();
            _local_1.lastRepairTime = this.mLastRepairTime;
            _local_1.recoveringHitPoints = this.GetRecoveringHitPoints();
            _local_1.initialSetOnXMLMap = this.IsInitialSetOnMap();
            _local_1.isBought = this.IsBought();
            _local_1.isProductionActive = this.IsProductionActive();
            _local_1.destructionTime = this.mBuildingDestructionTime;
            _local_1.buildingProgress = this.mBuildingProgress;
            _local_1.upgradeIsInProgress = this.IsUpgradeInProgress();
            _local_1.upgradeProgress = this.mBuildingUpgradeProgress;
            _local_1.upgradeStartTime = this.mBuildingUpgradeStartTime;
            _local_1.offsetX = (this.mOffsetX as int);
            _local_1.offsetY = (this.mOffsetY as int);
            _local_1.origin = this.mOrigin;
            _local_1.isEngagedInCombat = this.IsEngagedInCombat();
            _local_1.skin = this.skin;
            _local_1.campType = this.GetCampType();
            _local_1.recurringChance = this.mRecurringChance;
            if (this.mSpecialCombatPreview != null)
            {
                _local_1.specialCombatPreviewVO = this.mSpecialCombatPreview.createVO();
            };
            _local_1.preCombatTipType = this.mPreCombatTipType;
            _local_1.playerID = this.getPlayerID();
            for each (_local_2 in this.mArmy.GetSquads_vector())
            {
                _local_1.armyVO.squads.addItem(new dSquadVO().init(_local_2.GetType(), _local_2.GetAmount(), _local_2.GetCurrentHitPoints()));
            };
            for each (_local_3 in this.mBuffs_vector)
            {
                _local_1.buffs.addItem(_local_3.CreateBuffApplianceVO());
            };
            return (_local_1);
        }

        public function CalculateWays():Number
        {
            var _local_2:cPathObject;
            var _local_3:Number;
            var _local_4:String;
            var _local_5:cDeposit;
            var _local_6:cSkill;
            var _local_7:ModifierVO;
            var _local_8:String;
            var _local_9:cSkill;
            var _local_10:ModifierVO;
            var _local_11:String;
            var _local_1:Number = mGeneralInterface.mGlobalTimeScale;
            this.mWayWarehouseToWorkyard = 0;
            this.mWayWorkyardToDeposit = 0;
            this.mProductionTime = 0;
            this.mOverallTime = 0;
            this.mWayWarehouseToWorkyard = this.calculateWarehouseTransporttime();
            this.mWayWorkyardToDeposit = -1;
            if (((!(this.mResourceCreation == null)) && (!(this.mResourceCreation.GetDepositPath() == null))))
            {
                this.mWayWorkyardToDeposit = ((this.mResourceCreation.GetDepositPath().pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT) / _local_1);
            }
            else
            {
                if (((((!(this.mResourceCreation == null)) && (!(this.mResourceCreation.GetPath() == null))) && (!(this.mResourceCreation.GetResourceCreationDefinition() == null))) && (this.mResourceCreation.GetResourceCreationDefinition().externalResource_string == "")))
                {
                    this.mWayWorkyardToDeposit = this.mWayWarehouseToWorkyard;
                }
                else
                {
                    if (((((!(this.mResourceCreation == null)) && (this.mResourceCreation.GetDepositPath() == null)) && (!(this.mResourceCreation.GetResourceCreationDefinition() == null))) && (this.mResourceCreation.GetResourceCreationDefinition().amountRemoved < 0)))
                    {
                        _local_2 = mGeneralInterface.mPathFinder.CalculatePathForDeposit(this.mResourceCreation.GetResourceCreationDefinition().externalResource_string, this.mStreetGridEntry, this.mResourceCreation.GetPlayerID(), cPathFinder.AMOUNT_TYPE_ABOVE_ZERO);
                        if (_local_2 != null)
                        {
                            this.mWayWorkyardToDeposit = ((_local_2.pathLenX10000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT) / _local_1);
                        };
                    };
                };
            };
            if (((!(this.mResourceCreation == null)) && (!(this.mResourceCreation.GetResourceCreationDefinition() == null))))
            {
                _local_3 = this.mResourceCreation.GetWorkTime();
                _local_4 = this.mResourceCreation.GetResourceCreationDefinition().externalResource_string;
                if (((!(_local_4 == "")) && (!(this.mResourceCreation.GetDepositBuildingGridPos() == -1))))
                {
                    _local_5 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(this.mResourceCreation.GetDepositBuildingGridPos());
                    if (_local_5 != null)
                    {
                        for each (_local_6 in _local_5.skills.getItems_vector())
                        {
                            if (_local_6.getLevel() > 0)
                            {
                                for each (_local_7 in _local_6.getDefinition().level_vector[(_local_6.getLevel() - 1)])
                                {
                                    _local_8 = _local_7.modifier_string.toLowerCase();
                                    if (_local_8 == SpeedUp.xml_string)
                                    {
                                        if (_local_7.multiplier == 0)
                                        {
                                            _local_3 = 0;
                                        }
                                        else
                                        {
                                            _local_3 = (_local_3 / _local_7.multiplier);
                                        };
                                        _local_3 = (_local_3 + _local_7.adder);
                                    };
                                };
                            };
                        };
                    }
                    else
                    {
                        for each (_local_9 in this.mPlayerData.getSkills().getItems_vector())
                        {
                            for each (_local_10 in _local_9.getDefinition().level_vector[(_local_9.getLevel() - 1)])
                            {
                                _local_11 = _local_10.modifier_string.toLowerCase();
                                if (_local_11 == ResourceProductionSpeedUp.xml_string)
                                {
                                    _local_3 = ((_local_3 * _local_10.multiplier) + _local_10.adder);
                                };
                            };
                        };
                    };
                };
                this.mProductionTime = ((_local_3 * 1000) / _local_1);
            }
            else
            {
                this.mProductionTime = -1;
            };
            if (((((this.mWayWarehouseToWorkyard < 0) || (this.mWayWorkyardToDeposit < 0)) || (this.mProductionTime < 0)) || (this.IsUpgradeInProgress())))
            {
                this.mOverallTime = -1;
            }
            else
            {
                this.mOverallTime = (((2 * this.mWayWarehouseToWorkyard) + (2 * this.mWayWorkyardToDeposit)) + this.mProductionTime);
            };
            return (this.mOverallTime);
        }

        public function updateDefaultBuffSkins(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.currentBuffSkin = global.customGosetBuffTwinkleName;
                this.currentFriendBuffSkin = global.customGosetFriendBuffTwinkleName;
            }
            else
            {
                this.currentBuffSkin = global.defaultGosetBuffTwinkleName;
                this.currentFriendBuffSkin = global.defaultGosetFriendBuffTwinkleName;
            };
            this.mBuffTwinkleEffectSet = null;
        }

        public function SetRecurringChance(_arg_1:int):void
        {
            this.mRecurringChance = _arg_1;
        }

        protected function handleCollectibleBuffAdded(_arg_1:String):void
        {
        }

        public function hasHiddenTimedBuff(_arg_1:cBuffDefinition):Boolean
        {
            var _local_2:BuffAppliance;
            for each (_local_2 in this.mBuffs_vector)
            {
                if (((_local_2.GetBuffDefinition().GetBuffType() == BUFF_TYPE.TIMED_HIDDEN) && (_local_2.GetBuffDefinition().GetType() == _arg_1.GetType())))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function IsUpgradeAllowed(_arg_1:Boolean):Boolean
        {
            if ((((((((((((!(mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData) == null)) && (_arg_1)) && (!(mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData).HasPlayerResourcesInListOne(this.GetUpgradeCosts_vector())))) || ((!(_arg_1)) && (this.GetUpgradeCosts_vector() == null))) || (this.mBuildingMode == BUILDING_MODE_DESTRUCTION)) || (this.mBuildingMode == BUILDING_MODE_DESTRUCTED)) || (this.IsUpgradeInProgress())) || (!(this.IsInUpgradableBuildingMode()))) || (this.IsUpgradeInitiatedWithGem())) || (this.IsUpgradeInitiated())) || ((this.isSpecialUpgradeBuilding()) && (!(this.isSpecialUpgradeConditionsMet())))))
            {
                return (false);
            };
            return (true);
        }

        public function SetBuildingMode(_arg_1:int):Boolean
        {
            if (_arg_1 == BUILDING_MODE_QUEUED)
            {
                this.mLastProgress = -1;
            }
            else
            {
                if (_arg_1 == BUILDING_MODE_SET_BUILDING_GROUND_PLACE)
                {
                    this.mLastProgress = -1;
                }
                else
                {
                    if (_arg_1 == BUILDING_MODE_CONSTRUCTION)
                    {
                        this.mLastProgress = -1;
                    }
                    else
                    {
                        if (_arg_1 == BUILDING_MODE_DESTRUCTION)
                        {
                            mGeneralInterface.mCurrentPlayer.mBuildQueue.RemoveBuildingFromQueue(GetGrid());
                        }
                        else
                        {
                            if (_arg_1 == BUILDING_MODE_PRODUCES_NO_RESOURCES)
                            {
                                if (this.mResourceCreation != null)
                                {
                                    this.mResourceCreation.SetSettlerKIStateDeactivate();
                                };
                            }
                            else
                            {
                                if (_arg_1 == BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE)
                                {
                                    if (this.mResourceCreation != null)
                                    {
                                        this.mResourceCreation.SetSettlerKIState(cSettlerKI.SETTLER_STATE_WALKING_ON_RESOURCE_PATH);
                                    };
                                }
                                else
                                {
                                    if (_arg_1 == BUILDING_MODE_MOVING)
                                    {
                                        this.mBuildingModeBeforeMoving = this.mBuildingMode;
                                        this.mBuildingMode = _arg_1;
                                        return (true);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (((!(this.mBuildingMode == BUILDING_MODE_NONE)) && (!(this.mBuildingMode == BUILDING_MODE_MOVING))))
            {
                if (this.IsBuildingInProduction())
                {
                    this.mDirtyIndicator.weakModified();
                }
                else
                {
                    this.mDirtyIndicator.strongModified();
                };
            };
            this.mBuildingMode = _arg_1;
            if (((!(this.mResourceCreation == null)) && (this.mResourceCreation.HasInvalidatedPaths())))
            {
                switch (this.GetBuildingMode())
                {
                    case BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE:
                    case BUILDING_MODE_BUILDER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                    case BUILDING_MODE_SETTLER_WALKS_FROM_EXTERNAL_RESOURCE_TO_RESOURCECREATIONHOUSE:
                    case BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_STOREHOUSE:
                    case BUILDING_MODE_SETTLER_WALKS_FROM_RESOURCECREATIONHOUSE_TO_EXTERNAL_RESOURCE:
                        mGeneralInterface.mComputeResourceCreation.CalculateProductionPaths(this, true);
                        this.mResourceCreation.SetInvalidatePaths(false);
                        break;
                };
            };
            return (true);
        }

        public function GetBuildingName_string():String
        {
            return (this.mBuildingName_string);
        }

        public function GetBuildInstantCosts():int
        {
            if (this.GetGOContainer().mBuildInstantCosts > 0)
            {
                return (this.GetGOContainer().mBuildInstantCosts);
            };
            return (global.defaultBuildInstantCosts);
        }

        public function GetDefenseModeType():String
        {
            if (StringUtils.startsWith(this.mBuildingName_string, defines.PLAYER_CAV_EXPEDITION_CAMP_string))
            {
                return (defines.PLAYER_CAMP_TYPE_CAV_string);
            };
            if (StringUtils.startsWith(this.mBuildingName_string, defines.PLAYER_MELEE_EXPEDITION_CAMP_string))
            {
                return (defines.PLAYER_CAMP_TYPE_MELEE_string);
            };
            if (StringUtils.startsWith(this.mBuildingName_string, defines.PLAYER_MIXED_EXPEDITION_CAMP_string))
            {
                return (defines.PLAYER_CAMP_TYPE_MIXED_string);
            };
            if (StringUtils.startsWith(this.mBuildingName_string, defines.PLAYER_RANGED_EXPEDITION_CAMP_string))
            {
                return (defines.PLAYER_CAMP_TYPE_RANGED_string);
            };
            return ("unknown");
        }

        public function getBuildingIsAttackable():Boolean
        {
            if (((this.mBuildingMode == BUILDING_MODE_CONSTRUCTION) || (!(this.GetGOContainer().mIsAttackable))))
            {
                return (false);
            };
            return (true);
        }

        protected function RenderUpgradeLevelAndPlayerColor():void
        {
            var _local_1:int = GetXInt();
            var _local_2:int = GetYInt();
            var _local_3:int = mGeneralInterface.mCurrentPlayerZone.GetPlayerColorIdx(this.getPlayerID());
            gGfxResource.mUpgradeLevelIcons.SetSubType(_local_3);
            gGfxResource.mUpgradeLevelIcons.RenderPos(_local_1, (_local_2 - (global.streetGridY * 2)));
            gGfxResource.mUpgradeLevelNumbers.SetSubType(this.GetUIUpgradeLevel());
            gGfxResource.mUpgradeLevelNumbers.RenderPos(_local_1, ((_local_2 - (global.streetGridY * 2)) + 6));
        }

        public function ModifyOffsetX(_arg_1:int):void
        {
            this.mOffsetX = (this.mOffsetX + _arg_1);
        }

        public function getConstructionAnimEffectSet():cGOSetList
        {
            var _local_1:int;
            var _local_2:String;
            if (this.mConstructionAnimEffectSet == null)
            {
                _local_1 = this.mGoGroup.GetNrFromName(this.mBuildingName_string);
                _local_2 = this.mGoGroup.mConstructionFileName_vector[_local_1];
                if (_local_2 != null)
                {
                    this.mConstructionAnimEffectSet = cGOSetManager.CreateGOSetList(_local_2, new cGOSetListControllerPercentage(100));
                };
            };
            return (this.mConstructionAnimEffectSet);
        }

        public function getDestructionAnimEffectSet():cGOSetList
        {
            var _local_1:int;
            var _local_2:String;
            if (this.mDestructionAnimEffectSet == null)
            {
                _local_1 = this.mGoGroup.GetNrFromName(this.mBuildingName_string);
                _local_2 = this.mGoGroup.mDestructionFileName_vector[_local_1];
                if (_local_2 != null)
                {
                    this.mDestructionAnimEffectSet = cGOSetManager.CreateGOSetList(_local_2, new cGOSetListControllerPercentage(100));
                };
            };
            return (this.mDestructionAnimEffectSet);
        }


    }
}
