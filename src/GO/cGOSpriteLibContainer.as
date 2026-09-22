package GO
{
    import nLib.cSpriteLibContainer;
    import Enums.GO_SUBTYPE;
    import __AS3__.vec.Vector;
    import Communication.VO.EffectVO;
    import ServerState.dResource;
    import BuffSystem.cBuffDefinition;
    import nLib.cXML;
    import Enums.HOMEZONE_SECTOR_TYPE;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class cGOSpriteLibContainer extends cSpriteLibContainer 
    {

        public static const UI_TYPE_UNDEFINED:int = -1;
        public static const UI_TYPE_CL1_BUILDING:int = 0;
        public static const UI_TYPE_CL2_BUILDING:int = 1;
        public static const UI_TYPE_CL3_BUILDING:int = 2;
        public static const UI_TYPE_CL4_BUILDING:int = 3;
        public static const UI_TYPE_CL5_BUILDING:int = 4;
        public static const UI_TYPE_DEFENSE_MODE_BUILDING_L1:int = 5;
        public static const UI_TYPE_DEFENSE_MODE_BUILDING_L2:int = 6;
        public static const UI_TYPE_DEFENSE_MODE_BUILDING_L3:int = 7;
        public static const UI_TYPE_DEFENSE_MODE_TRAP:int = 8;

        public var mIsLeaderCamp:Boolean = false;
        public var mAddDepositAmount:int = 0;
        public var mHiddenLandscape:String = null;
        public var mUITyp:int = -1;
        public var mIsWarehouse:Boolean = false;
        public var mLootTableId:int = 0;
        public var requiresBuff:String = null;
        public var mInfoPanelShortcutItem:String;
        public var mDamagePercentForDefendingUnits:int = 100;
        public var mEnumGoSubType:int = GO_SUBTYPE.DEFAULT;
        public var mXP:int = 0;
        public var mIgnoreWarehousePath:Boolean = false;
        public var mEnumSettlerKiTyp:int = 0;
        public var mAddDepositRefillable:Boolean = false;
        public var waitForPickupSpriteIndex:int;
        public var mIncreaseMaxResourceLimit:int = 0;
        public var mRenderOffsetY:int = 0;
        public var productionReadyAvatarType:String = null;
        public var uiContent:int;
        public var mMovable:Boolean = true;
        public var mGoGroup:cGOGroup;
        public var stackingBuffs_vector:Vector.<String> = null;
        public var mReplaceable:Boolean = false;
        public var mBlocking_vector:Vector.<cBlockingData> = new Vector.<cBlockingData>();
        public var mRestrictPlacingToDeposit:String = null;
        public var mHitPoints:int = 500;
        public var useCustomTeardownMessage:Boolean = false;
        public var mGfxResourceListName_string:String = "";
        public var buildingDestroyEffects_vector:Vector.<EffectVO> = null;
        public var mInfoPanelShortcut:String;
        public var mConstructionAnimSpeed:Number = 1;
        public var mIsAttackable:Boolean = true;
        public var buildingMovementCosts_vector:Vector.<Vector.<dResource>> = null;
        public var mShadowOffsetX:int = 0;
        private var mTradable:Boolean = false;
        public var mShowMissingResources:Boolean;
        public var mWatchAreaId:int = 0;
        public var requiresEvent:String = null;
        public var mFlagEffectSetName_string:String = null;
        public var mUILevelOverwrite:int = 0;
        public var mConstructionDuration:int = 100;
        public var productionType:int;
        public var mBuildInstantCosts:int = 0;
        public var mSmokeEffectSetName_string:String = null;
        public var mIsInstantUpgradeAvailable:Boolean = true;
        public var minProductionLevel:int = 1;
        public var mGfxResourceListNr:int = 0;
        public var buildingUpgradeBonuses_vector:Vector.<cBuffDefinition> = null;
        private var destroyOnClick:Boolean = false;
        public var mHasShadowSprite:Boolean = false;
        public var ui:String;
        public var mIsFloating:Boolean = false;
        public var mSkipCooldownGemCost:int = 0;
        public var mShadowOffsetY:int = 0;
        public var mEventMonsterPreventOverbuff:Boolean = false;
        public var mLevelNeededToDestroy:int;
        public var mIsWaterBuilding:Boolean = false;
        public var mAddDepositName:String = null;
        public var waitForPickup:Boolean = false;
        public var mIgnoreOnSectorClaim:Boolean = true;
        public var mDestructionDuration:int = 50;
        public var mShowSmokeEvenIfNotWorking:Boolean = false;
        public var mBuffable:Boolean = true;
        public var mDepositAnimName_string:String = null;
        public var preventDeletion:Boolean;
        public var mUpgradeInstantBonusPercentage:int = 0;
        public var mCostList_vector:Vector.<dResource> = null;
        public var mFloatingRangeMultiplier:Number = 0;
        public var mGlobalSnapping:Number = 0;
        public var depletedMineExtension:String;
        public var mBattleAnimation_string:String = null;
        public var showWaitForPickupIcon:Boolean = false;
        public var mDecorationType:String;
        public var mGfxResourceSettlerName_string:String = "";
        public var mShowInGui:int = 1;
        public var mEffectDefaultAnimSpeed:Number = 0;
        public var mMaxBuildingLimit:int = global.defaultMaximumBuildingCount;
        public var mMaxUnits:int = 0;
        public var mHomezoneSectorTypes:int;
        public var mConstructBuildingWithoutSettler:Boolean = false;

        public function cGOSpriteLibContainer(_arg_1:cGOGroup, _arg_2:String, _arg_3:Function, _arg_4:int, _arg_5:Boolean, _arg_6:Boolean, _arg_7:int)
        {
            super(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            this.mGoGroup = _arg_1;
        }

        public function isTradable():Boolean
        {
            return (this.mTradable);
        }

        public function GetShadowOffsetX():int
        {
            return (this.mShadowOffsetX);
        }

        public function IsFloatingBuilding():Boolean
        {
            return (this.mIsFloating);
        }

        public function GetShadowOffsetY():int
        {
            return (this.mShadowOffsetY);
        }

        public function parseXML(_arg_1:cXML):Boolean
        {
            var _local_4:cXML;
            var _local_10:dResource;
            var _local_11:cXML;
            var _local_12:String;
            var _local_13:Vector.<cXML>;
            var _local_14:Vector.<dResource>;
            var _local_15:cXML;
            var _local_16:cXML;
            var _local_17:Vector.<cXML>;
            var _local_18:cBuffDefinition;
            var _local_19:String;
            var _local_20:cXML;
            var _local_21:cXML;
            var _local_22:cXML;
            var _local_23:Vector.<cXML>;
            var _local_24:cXML;
            var _local_25:EffectVO;
            var _local_26:cXML;
            var _local_27:Vector.<cXML>;
            var _local_28:cXML;
            this.mConstructionDuration = Math.max(1, _arg_1.GetAttributeInt("constructionDuration", global.buildingDefaultParameterConstructionDuration));
            this.mDestructionDuration = _arg_1.GetAttributeInt("destructionDuration", global.buildingDefaultParameterDestructionDuration);
            var _local_2:cXML = _arg_1.MoveToSubNode("Blocks");
            var _local_3:Vector.<cXML> = _local_2.CreateChildrenArray();
            for each (_local_4 in _local_3)
            {
                this.mBlocking_vector.push(new cBlockingData(_local_4));
            };
            this.mWatchAreaId = _arg_1.GetAttributeInt("watchAreaId");
            this.mIsWarehouse = _arg_1.GetAttributeBool("isWarehouse");
            this.mIsInstantUpgradeAvailable = _arg_1.GetAttributeBool("InstantUpgradeEnabled", true);
            this.mInfoPanelShortcut = _arg_1.GetAttributeString_string("InfoPanelShortcut", "none");
            this.mInfoPanelShortcutItem = _arg_1.GetAttributeString_string("InfoPanelShortcutItem", "none");
            this.mIgnoreOnSectorClaim = _arg_1.GetAttributeBool("ignoreOnSectorClaim");
            this.mLootTableId = _arg_1.GetAttributeInt("LootTableId");
            this.mConstructBuildingWithoutSettler = _arg_1.GetAttributeBool("constructWithoutSettler");
            this.mMaxUnits = _arg_1.GetAttributeInt("maxUnits");
            this.mHitPoints = _arg_1.GetAttributeInt("hitPoints");
            this.mBuildInstantCosts = _arg_1.GetAttributeInt("InstantBuildCosts");
            this.mUpgradeInstantBonusPercentage = _arg_1.GetAttributeInt("InstantUpgradeBonusPercentage");
            this.mBuffable = _arg_1.GetAttributeBool("buffable", true);
            this.mMovable = _arg_1.GetAttributeBool("movable", true);
            this.mReplaceable = _arg_1.GetAttributeBool("replaceable", false);
            this.mIsWaterBuilding = _arg_1.GetAttributeBool("isWaterBuilding", false);
            this.mIgnoreWarehousePath = _arg_1.GetAttributeBool("ignoreWarehousePath", false);
            this.mLevelNeededToDestroy = _arg_1.GetAttributeInt("levelNeededToDestroy");
            this.mHomezoneSectorTypes = HOMEZONE_SECTOR_TYPE.parse(_arg_1.GetAttributeString_string("homezoneSectorTypes", "All"));
            this.destroyOnClick = _arg_1.GetAttributeBool("destroyOnClick", false);
            this.mIsFloating = _arg_1.GetAttributeBool("isFloating", false);
            this.mFloatingRangeMultiplier = _arg_1.GetAttributeFloatingPoint("floatRangeMultiplier", 0);
            this.mShadowOffsetY = _arg_1.GetAttributeInt("shadowOffsetY", 0);
            this.mShadowOffsetX = _arg_1.GetAttributeInt("shadowOffsetX", 0);
            this.mRenderOffsetY = _arg_1.GetAttributeInt("renderOffsetY", 0);
            this.mHasShadowSprite = _arg_1.GetAttributeBool("hasShadowSprite", false);
            this.mIsLeaderCamp = _arg_1.GetAttributeBool("isLeaderCamp", false);
            this.mIsAttackable = _arg_1.GetAttributeBool("isAttackable", true);
            this.depletedMineExtension = _arg_1.GetAttributeString_string("depletedMineExtension");
            this.preventDeletion = _arg_1.GetAttributeBool("preventDeletion");
            if (_arg_1.HasSubNode("BuildingMoveCosts"))
            {
                this.buildingMovementCosts_vector = new Vector.<Vector.<dResource>>();
                _local_13 = _arg_1.MoveToSubNodeAndCreateChildrenArray("BuildingMoveCosts");
                for each (_local_15 in _local_13)
                {
                    _local_14 = gParse.ParseCosts(_local_15);
                    this.buildingMovementCosts_vector.push(_local_14);
                };
            };
            if (_arg_1.HasSubNode("BuildingUpgradeBonuses"))
            {
                this.buildingUpgradeBonuses_vector = new Vector.<cBuffDefinition>();
                _local_16 = _arg_1.MoveToSubNode("BuildingUpgradeBonuses");
                this.mUILevelOverwrite = _local_16.GetAttributeInt("uiLevelOverwrite", 0);
                _local_17 = _local_16.CreateChildrenArray();
                for each (_local_20 in _local_17)
                {
                    _local_18 = cBuffDefinition.CreateBuffDefinitionFromXml(_local_20);
                    if (_local_18.getUpgradeLevel() != this.buildingUpgradeBonuses_vector.length)
                    {
                        _local_19 = _arg_1.GetAttributeString_string("name");
                        gMisc.Assert(false, (((((("cGOSpriteLibContainer: (" + _local_19) + ") Want to add upgrade bonuses at the wrong position: ") + _local_18.getUpgradeLevel()) + " != ") + this.buildingUpgradeBonuses_vector.length) + ". Please check the game settings!"));
                    };
                    this.buildingUpgradeBonuses_vector.push(_local_18);
                };
            };
            this.mDamagePercentForDefendingUnits = _arg_1.GetAttributeInt("damagePercentForDefendingUnits", 100);
            this.mShowInGui = (1 - _arg_1.GetAttributeInt("noGui"));
            this.mIncreaseMaxResourceLimit = _arg_1.GetAttributeInt("incMaxResourceLimit");
            this.mMaxBuildingLimit = _arg_1.GetAttributeInt("maxBuildingLimit", global.defaultMaximumBuildingCount);
            var _local_5:String = _arg_1.GetAttributeString_string("uiType");
            if (_local_5 == "CL1")
            {
                this.mUITyp = cGOSpriteLibContainer.UI_TYPE_CL1_BUILDING;
            }
            else
            {
                if (_local_5 == "CL2")
                {
                    this.mUITyp = cGOSpriteLibContainer.UI_TYPE_CL2_BUILDING;
                }
                else
                {
                    if (_local_5 == "CL3")
                    {
                        this.mUITyp = cGOSpriteLibContainer.UI_TYPE_CL3_BUILDING;
                    }
                    else
                    {
                        if (_local_5 == "CL4")
                        {
                            this.mUITyp = cGOSpriteLibContainer.UI_TYPE_CL4_BUILDING;
                        }
                        else
                        {
                            if (_local_5 == "CL5")
                            {
                                this.mUITyp = cGOSpriteLibContainer.UI_TYPE_CL5_BUILDING;
                            }
                            else
                            {
                                if (_local_5 == "DEF_MODE_L1")
                                {
                                    this.mUITyp = cGOSpriteLibContainer.UI_TYPE_DEFENSE_MODE_BUILDING_L1;
                                }
                                else
                                {
                                    if (_local_5 == "DEF_MODE_L2")
                                    {
                                        this.mUITyp = cGOSpriteLibContainer.UI_TYPE_DEFENSE_MODE_BUILDING_L2;
                                    }
                                    else
                                    {
                                        if (_local_5 == "DEF_MODE_L3")
                                        {
                                            this.mUITyp = cGOSpriteLibContainer.UI_TYPE_DEFENSE_MODE_BUILDING_L3;
                                        }
                                        else
                                        {
                                            if (_local_5 == "DEF_MODE_TRAP")
                                            {
                                                this.mUITyp = cGOSpriteLibContainer.UI_TYPE_DEFENSE_MODE_TRAP;
                                            }
                                            else
                                            {
                                                this.mUITyp = cGOSpriteLibContainer.UI_TYPE_UNDEFINED;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            this.mXP = _arg_1.GetAttributeInt("xp", global.buildingDefaultParameterXP);
            var _local_6:String = _arg_1.GetAttributeString_string("restrictPlacingToDeposit");
            if (_local_6 != "")
            {
                this.mRestrictPlacingToDeposit = _local_6;
            };
            var _local_7:String = _arg_1.GetAttributeString_string("hiddenLandscape");
            if (_local_7 != "")
            {
                this.mHiddenLandscape = _local_7;
            };
            if (_arg_1.HasSubNode("AddDeposit"))
            {
                _local_21 = _arg_1.MoveToSubNode("AddDeposit");
                this.mAddDepositName = _local_21.GetAttributeString_string("name");
                this.mAddDepositAmount = _local_21.GetAttributeInt("amount");
                this.mAddDepositRefillable = _local_21.GetAttributeBool("refillable", true);
            }
            else
            {
                this.mAddDepositAmount = -1;
            };
            this.mCostList_vector = new Vector.<dResource>();
            var _local_8:cXML = _arg_1.MoveToSubNode("Costs");
            var _local_9:Vector.<cXML> = _local_8.CreateChildrenArray();
            for each (_local_11 in _local_9)
            {
                _local_10 = new dResource();
                _local_10.amount = _local_11.GetAttributeInt("count");
                _local_10.name_string = _local_11.GetAttributeString_string("name");
                this.mCostList_vector.push(_local_10);
            };
            _local_12 = _arg_1.GetAttributeString_string("subType");
            if (_local_12 == "Cursor")
            {
                this.mEnumGoSubType = GO_SUBTYPE.CURSOR;
            }
            else
            {
                if (_local_12 == "Deco")
                {
                    this.mEnumGoSubType = GO_SUBTYPE.DECORATION;
                }
                else
                {
                    this.mEnumGoSubType = GO_SUBTYPE.DEFAULT;
                };
            };
            this.mDecorationType = _arg_1.GetAttributeString_string("type");
            this.mTradable = _arg_1.GetAttributeBool("tradable", false);
            this.mSkipCooldownGemCost = _arg_1.GetAttributeInt("skipCooldownGemCost", 0);
            this.minProductionLevel = _arg_1.GetAttributeInt("minProductionLevel", 1);
            this.mEventMonsterPreventOverbuff = _arg_1.GetAttributeBool("preventOverbuff", false);
            this.useCustomTeardownMessage = _arg_1.GetAttributeBool("customTeardownMessage", false);
            this.buildingDestroyEffects_vector = new Vector.<EffectVO>();
            if (_arg_1.HasSubNode("DestroyEffects"))
            {
                _local_22 = _arg_1.MoveToSubNode("DestroyEffects");
                _local_23 = _local_22.CreateChildrenArray();
                for each (_local_24 in _local_23)
                {
                    _local_25 = EffectVO.CreateFromXML(_local_24);
                    this.buildingDestroyEffects_vector.push(_local_25);
                };
            };
            this.stackingBuffs_vector = new Vector.<String>();
            if (_arg_1.HasSubNode("StackingBuff"))
            {
                _local_26 = _arg_1.MoveToSubNode("StackingBuff");
                _local_27 = _local_26.CreateChildrenArray();
                for each (_local_28 in _local_27)
                {
                    this.stackingBuffs_vector.push(_local_28.GetAttributeString_string("name"));
                };
            };
            return (true);
        }

        public function isDestroyOnClick():Boolean
        {
            return (this.destroyOnClick);
        }

        public function GetRenderOffSetY():int
        {
            return (this.mRenderOffsetY);
        }

        public function GetHasShadowSprite():Boolean
        {
            return (this.mHasShadowSprite);
        }

        public function GetFloatingRangeMultiplier():Number
        {
            return (this.mFloatingRangeMultiplier);
        }


    }
}
