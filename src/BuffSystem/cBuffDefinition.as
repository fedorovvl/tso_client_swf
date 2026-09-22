package BuffSystem
{
    import TimedProduction.iTimedProductionDefinition;
    import __AS3__.vec.Vector;
    import Communication.VO.EffectListVO;
    import Communication.VO.dBattleBuffTarget;
    import Communication.VO.dBuffEfficiencyVO;
    import Communication.VO.PropagatingBuffListVO;
    import Communication.VO.TriggerVO;
    import ServerState.dResource;
    import Communication.VO.TriggerListVO;
    import Communication.VO.grid.GridOffsetVO;
    import Communication.VO.AdventureTargetListVO;
    import Modifier.ModifierListVO;
    import nLib.cXML;
    import Enums.BUFF_TYPE;
    import Utils.StringUtils;
    import Enums.BUFF_UI;
    import Enums.BUFF_APPLIANCE_MODE;
    import nLib.gMisc;
    import Enums.BUFF_TARGET_ZONE;
    import Enums.BUFF_TARGET_TYPE;
    import Enums.BUFF_PARAMETER_NAME;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.EffectVO;
    import Effects.Effects.ChangeSkin;
    import GO.cGOSpriteLibContainer;
    import Effects.Effects.ChangeDefaultSkin;
    import __AS3__.vec.*;

    public class cBuffDefinition implements iTimedProductionDefinition 
    {

        public static var targetGroups:BuffTargetGroups;

        private var targetGroup_string:String;
        private var mStackingGroupHash:int;
        private var militaryUnitCapacity:int;
        private var exclusivityGroup:String;
        private var durations_vector:Vector.<int>;
        private var buffUI:int;
        private var buffType:int;
        private var goodsCapacity:int;
        private var damageBoostPercent:int;
        private var produceable:Boolean;
        private var postEffects:EffectListVO;
        private var limitedPerCamp:Boolean;
        private var name_string:String = "";
        private var recruitingTimePercentage:int;
        private var battleBuffTarget_vector:Vector.<dBattleBuffTarget>;
        private var productivityOutputPercent:int;
        private var mInstantBuildCosts:int;
        private var deletable:Boolean;
        private var hitPoints:int;
        private var min:int;
        private var buffEfficiencies_vector:Vector.<dBuffEfficiencyVO>;
        private var propagatingBuffs:PropagatingBuffListVO;
        private var group:String = "";
        private var repeatingEffects:EffectListVO;
        private var hitChance:int;
        private var conditions_vector:Vector.<TriggerVO>;
        private var allowInstantApplyOnProduce:Boolean;
        private var mTargetDescription_string:String;
        private var redeemable_vector:Vector.<dResource>;
        private var mTargetType:int;
        private var renderAreaRings:int;
        private var checkSectorOwner:Boolean;
        private var applyConditions:TriggerListVO;
        private var upgradeLevel:int;
        private var mStackingGroup:String;
        private var mCultureBuildingCooldown:int;
        private var areaOffsets:GridOffsetVO;
        private var productivityInputPercent:int;
        private var id:int;
        private var mAmount:int;
        private var productionTime:int;
        private var isNotUpdatable:Boolean;
        private var redeemableEvent:String;
        private var costs_vector:Vector.<dResource>;
        private var max:int;
        private var mTargetZoneTypes:int;
        private var ignoreAreaOrigin:Boolean;
        private var useCountInsteadOfAmount:Boolean;
        private var requiresEvent:String;
        private var avatarMessageOverride_string:String = "";
        private var zoneCancelable:Boolean;
        private var preventDefaultAvatarMessage:Boolean;
        private var mResourceName_string:String;
        private var applyEffects:EffectListVO;
        private var mParameter:Object = null;
        private var adventureTargets:AdventureTargetListVO;
        private var sortIndex:int;
        private var requiresQuest:String;
        private var combatModifiers:ModifierListVO;
        private var tradable:Boolean;

        public function cBuffDefinition(_arg_1:int, _arg_2:String)
        {
            super();
            this.id = _arg_1;
            this.name_string = _arg_2;
        }

        public static function GetById(_arg_1:int):cBuffDefinition
        {
            return (global.map_BuffId_BuffDefinition[_arg_1]);
        }

        public static function CreateBuffDefinitionFromXml(_arg_1:cXML):cBuffDefinition
        {
            var _local_41:cXML;
            var _local_42:int;
            var _local_43:int;
            var _local_44:String;
            var _local_63:cXML;
            var _local_64:Vector.<dBattleBuffTarget>;
            var _local_65:Vector.<cXML>;
            var _local_66:cXML;
            var _local_67:GridOffsetVO;
            var _local_68:int;
            var _local_70:int;
            var _local_71:int;
            var _local_72:int;
            var _local_73:Array;
            var _local_74:String;
            var _local_75:Array;
            var _local_76:String;
            var _local_77:int;
            var _local_78:dBattleBuffTarget;
            var _local_79:cXML;
            var _local_2:int = _arg_1.GetAttributeInt("id");
            var _local_3:String = _arg_1.GetAttributeString_string("name");
            var _local_4:Boolean = _arg_1.GetAttributeBool("tradable", false);
            var _local_5:Boolean = _arg_1.GetAttributeBool("deletable");
            var _local_6:int = BUFF_TYPE.Parse(_arg_1.GetAttributeString_string("buffType"));
            var _local_7:int = (_arg_1.GetAttributeInt("productionTime") * 1000);
            var _local_8:int = _arg_1.GetAttributeInt("level");
            var _local_9:Boolean = _arg_1.GetAttributeBool("produceable");
            var _local_10:String = _arg_1.GetAttributeString_string("requiresEvent");
            var _local_11:String = _arg_1.GetAttributeString_string("requiresQuest");
            var _local_12:int = _arg_1.GetAttributeInt("sortIndex");
            var _local_13:int = _arg_1.GetAttributeInt("hitPointsAmount");
            var _local_14:int = _arg_1.GetAttributeInt("goodsCapacityAmount");
            var _local_15:int = _arg_1.GetAttributeInt("militaryUnitCapacityAmount");
            var _local_16:int = _arg_1.GetAttributeInt("productivityInputPercent");
            var _local_17:int = _arg_1.GetAttributeInt("productivityOutputPercent");
            var _local_18:int = _arg_1.GetAttributeInt("recruitingTimePercent");
            var _local_19:String = _arg_1.GetAttributeString_string("group");
            var _local_20:int = _arg_1.GetAttributeInt("amount");
            var _local_21:String = _arg_1.GetAttributeString_string("resourceName");
            var _local_22:int = _arg_1.GetAttributeInt("instantBuildCosts");
            var _local_23:int = _arg_1.GetAttributeInt("min");
            var _local_24:int = _arg_1.GetAttributeInt("max");
            var _local_25:int = (_arg_1.GetAttributeInt("cultureBuildingCooldown", 0) * 1000);
            var _local_26:String = _arg_1.GetAttributeString_string("stackingGroup").toLowerCase();
            var _local_27:int = StringUtils.GetHashCode(_local_26);
            var _local_28:Boolean = _arg_1.GetAttributeBool("isNotUpdatable");
            var _local_29:Boolean = _arg_1.GetAttributeBool("limitedPerCamp");
            var _local_30:Boolean = _arg_1.GetAttributeBool("allowInstantApplyOnProduce");
            var _local_31:Boolean = _arg_1.GetAttributeBool("useCountInsteadOfAmount");
            var _local_32:String = _arg_1.GetAttributeString_string("exclusivityGroup");
            var _local_33:int = _arg_1.GetAttributeInt("hitChance", -1);
            var _local_34:int = _arg_1.GetAttributeInt("damageBoostPercent", 0);
            var _local_35:String = _arg_1.GetAttributeString_string("avatarMessageOverride", "default");
            var _local_36:Boolean = _arg_1.GetAttributeBool("preventDefaultAvatarMessage");
            var _local_37:Boolean = _arg_1.GetAttributeBool("zoneCancelable", true);
            var _local_38:int = BUFF_UI.toInt(_arg_1.GetAttributeString_string("ui", "default"));
            if (!gParse.parseIsAvailableForLocation(_arg_1, global.realmLanguage))
            {
                _local_4 = (_local_9 = false);
            };
            var _local_39:Vector.<int> = new Vector.<int>();
            var _local_40:Vector.<cXML> = _arg_1.MoveToSubNodeAndCreateChildrenArray("Durations");
            for each (_local_41 in _local_40)
            {
                _local_70 = BUFF_APPLIANCE_MODE.parseString(_local_41.GetAttributeString_string("applianceMode"));
                _local_71 = _local_41.GetAttributeInt("days", -1);
                if (_local_71 != -1)
                {
                    _local_72 = _local_71;
                }
                else
                {
                    _local_72 = (_local_41.GetAttributeInt("seconds") * 1000);
                };
                gMisc.Assert((_local_70 == _local_39.length), ("Duration applianceMode was defined at the wrong position: " + _local_70));
                _local_39.push(_local_72);
            };
            _local_42 = BUFF_TARGET_ZONE.parse(_arg_1.GetAttributeString_string("targetZones"));
            _local_43 = -1;
            _local_44 = _arg_1.GetAttributeString_string("targetType");
            if (_local_44.length > 0)
            {
                _local_43 = BUFF_TARGET_TYPE.parse(_local_44);
            };
            var _local_45:String = _arg_1.GetAttributeString_string("targetDescription");
            var _local_46:Vector.<dResource> = gParse.ParseCosts(_arg_1.MoveToSubNode("Costs"));
            var _local_47:Vector.<TriggerVO> = gParse.ParseConditions(_arg_1.MoveToSubNode("Conditions"));
            var _local_48:String = _arg_1.GetAttributeString_string("targetGroup");
            var _local_49:Boolean = _arg_1.GetAttributeBool("checkSectorOwner");
            var _local_50:Boolean = _arg_1.GetAttributeBool("ignoreAreaOrigin");
            var _local_51:EffectListVO = EffectListVO.fromXML(_arg_1, "applyEffects");
            var _local_52:EffectListVO = EffectListVO.fromXML(_arg_1, "repeatingEffects");
            var _local_53:EffectListVO = EffectListVO.fromXML(_arg_1, "postEffects");
            var _local_54:AdventureTargetListVO = AdventureTargetListVO.fromXML(_arg_1, "adventureTargets");
            var _local_55:PropagatingBuffListVO = PropagatingBuffListVO.fromXML(_arg_1, "propagatingBuffs");
            var _local_56:ModifierListVO = ModifierListVO.fromXML(_arg_1, "combatModifiers");
            var _local_57:Vector.<dBuffEfficiencyVO> = new Vector.<dBuffEfficiencyVO>();
            var _local_58:String = _arg_1.GetAttributeString_string("buffEfficiency");
            if (_local_58 != "")
            {
                _local_73 = _local_58.split(",");
                for each (_local_74 in _local_73)
                {
                    _local_75 = _local_74.split("|");
                    _local_57.push(new dBuffEfficiencyVO(_local_75[0], _local_75[1]));
                };
            };
            var _local_59:Vector.<dResource> = gParse.ParseCosts(_arg_1.MoveToSubNode("Redeemable"));
            var _local_60:* = "";
            if (_local_59.length != 0)
            {
                _local_60 = _arg_1.MoveToSubNode("Redeemable").GetAttributeString_string("event");
            };
            var _local_61:Object = new Object();
            var _local_62:Vector.<cXML> = _arg_1.MoveToSubNodeAndCreateChildrenArray("Parameters");
            for each (_local_63 in _local_62)
            {
                _local_76 = _local_63.GetAttributeString_string("name");
                _local_77 = BUFF_PARAMETER_NAME.Parse(_local_76);
                if (_local_77 > 0)
                {
                    _local_61[_local_77] = _local_63.GetAttributeFloatingPoint("value", 0);
                }
                else
                {
                    gMisc.Assert(false, ((("unknown buff parameter name: " + _local_76) + " BuffId: ") + _local_2));
                };
            };
            _local_64 = new Vector.<dBattleBuffTarget>();
            _local_65 = _arg_1.MoveToSubNodeAndCreateChildrenArray("BattleBuffTargets");
            for each (_local_66 in _local_65)
            {
                _local_78 = new dBattleBuffTarget();
                _local_78.unitType = _local_66.GetAttributeString_string("name", "");
                _local_78.combatantType = _local_66.GetAttributeString_string("type", "");
                _local_78.min = _local_66.GetAttributeInt("min", 1);
                _local_78.max = _local_66.GetAttributeInt("max", 1);
                _local_64.push(_local_78);
            };
            _local_67 = null;
            _local_68 = 0;
            if (_arg_1.HasSubNode("areaSizes"))
            {
                _local_79 = _arg_1.MoveToSubNode("areaSizes").MoveToSubNode("area");
                _local_67 = new GridOffsetVO(_local_79.GetAttributeInt("rows"), _local_79.GetAttributeInt("columns"));
                _local_68 = Math.max(0, (Math.min(_local_67.columnOffset, _local_67.rowOffset) - (_local_79.GetAttributeInt("renderRings") * 2)));
            };
            var _local_69:cBuffDefinition = new cBuffDefinition(_local_2, _local_3);
            _local_69.tradable = _local_4;
            _local_69.deletable = _local_5;
            _local_69.buffType = _local_6;
            _local_69.productionTime = _local_7;
            _local_69.upgradeLevel = _local_8;
            _local_69.durations_vector = _local_39;
            _local_69.produceable = _local_9;
            _local_69.requiresEvent = _local_10;
            _local_69.requiresQuest = _local_11;
            _local_69.costs_vector = _local_46;
            _local_69.conditions_vector = _local_47;
            _local_69.hitPoints = _local_13;
            _local_69.goodsCapacity = _local_14;
            _local_69.militaryUnitCapacity = _local_15;
            _local_69.productivityInputPercent = _local_16;
            _local_69.productivityOutputPercent = _local_17;
            _local_69.recruitingTimePercentage = _local_18;
            _local_69.group = _local_19;
            _local_69.mAmount = _local_20;
            _local_69.mResourceName_string = _local_21;
            _local_69.mTargetZoneTypes = _local_42;
            _local_69.mTargetType = _local_43;
            _local_69.mTargetDescription_string = _local_45;
            _local_69.sortIndex = _local_12;
            _local_69.mInstantBuildCosts = _local_22;
            _local_69.applyEffects = _local_51;
            _local_69.repeatingEffects = _local_52;
            _local_69.postEffects = _local_53;
            _local_69.propagatingBuffs = _local_55;
            _local_69.combatModifiers = _local_56;
            _local_69.buffEfficiencies_vector = _local_57;
            _local_69.redeemable_vector = _local_59;
            _local_69.areaOffsets = _local_67;
            _local_69.renderAreaRings = _local_68;
            _local_69.redeemableEvent = _local_60;
            _local_69.targetGroup_string = _local_48;
            _local_69.checkSectorOwner = _local_49;
            _local_69.min = _local_23;
            _local_69.max = _local_24;
            _local_69.mCultureBuildingCooldown = _local_25;
            _local_69.mStackingGroup = _local_26;
            _local_69.mStackingGroupHash = _local_27;
            _local_69.isNotUpdatable = _local_28;
            _local_69.limitedPerCamp = _local_29;
            _local_69.mParameter = _local_61;
            _local_69.allowInstantApplyOnProduce = _local_30;
            _local_69.useCountInsteadOfAmount = _local_31;
            _local_69.exclusivityGroup = _local_32;
            _local_69.battleBuffTarget_vector = _local_64;
            _local_69.hitChance = _local_33;
            _local_69.damageBoostPercent = _local_34;
            _local_69.avatarMessageOverride_string = _local_35;
            _local_69.buffUI = _local_38;
            _local_69.preventDefaultAvatarMessage = _local_36;
            _local_69.zoneCancelable = _local_37;
            _local_69.adventureTargets = _local_54;
            _local_69.applyConditions = TriggerListVO.fromXML(_arg_1, "applyConditions");
            _local_69.ignoreAreaOrigin = _local_50;
            return (_local_69);
        }

        public static function GetByName(_arg_1:String):cBuffDefinition
        {
            return (global.map_BuffName_BuffDefinition[_arg_1]);
        }


        public function GetProductionTime():int
        {
            return (this.productionTime);
        }

        public function GetDamageBoostPercent():int
        {
            return (this.damageBoostPercent);
        }

        public function GetApplyEffects():EffectListVO
        {
            return (this.applyEffects);
        }

        public function isLimitedPerCamp():Boolean
        {
            return (this.limitedPerCamp);
        }

        public function GetHitChance():int
        {
            return (this.hitChance);
        }

        public function GetConditions_vector():Vector.<TriggerVO>
        {
            return (this.conditions_vector);
        }

        public function isPreventDefaultAvatarMessage():Boolean
        {
            return (this.preventDefaultAvatarMessage);
        }

        public function GetRedeemable_vector():Vector.<dResource>
        {
            return (this.redeemable_vector);
        }

        public function getIsNotUpdatable():Boolean
        {
            return (this.isNotUpdatable);
        }

        public function GetGroup_string():String
        {
            return (this.group);
        }

        public function IsCheckSectorOwner():Boolean
        {
            return (this.checkSectorOwner);
        }

        public function IsDeletable():Boolean
        {
            return (this.deletable);
        }

        public function GetProductionName_string():String
        {
            if (this.name_string.indexOf("AddResource") != -1)
            {
                return (this.mResourceName_string);
            };
            return (this.name_string);
        }

        public function GetTargetType():int
        {
            return (this.mTargetType);
        }

        public function GetResourceName_string():String
        {
            return (this.mResourceName_string);
        }

        public function IsTargetingAdventure(_arg_1:cAdventureDefinition):Boolean
        {
            if (this.adventureTargets == null)
            {
                return (true);
            };
            return (this.adventureTargets.isTargetingAdventure(_arg_1));
        }

        public function GetMax():int
        {
            return (this.max);
        }

        public function GetProductionSourceName_string():String
        {
            return (this.name_string);
        }

        public function GetStackingGroupHash():int
        {
            return (this.mStackingGroupHash);
        }

        public function IsTypeCombatTimed():Boolean
        {
            return (this.GetBuffType() == BUFF_TYPE.COMBAT_TIMED);
        }

        public function ShouldRenderTimeLeftTooltip():Boolean
        {
            if ((((this.buffType == BUFF_TYPE.TIMED) || (this.buffType == BUFF_TYPE.COMBAT_TIMED)) || (this.buffType == BUFF_TYPE.TIMED_HIDDEN)))
            {
                return (true);
            };
            return (false);
        }

        public function toString():String
        {
            var _local_1:* = "<cBuffDefinition ";
            _local_1 = (_local_1 + (("buffType='" + this.buffType) + "'"));
            return (_local_1 + " />");
        }

        public function GetTargetDescription_string():String
        {
            return (this.mTargetDescription_string);
        }

        public function getGoodsCapacity():int
        {
            return (this.goodsCapacity);
        }

        public function getProductivityInputPercent():int
        {
            return (this.productivityInputPercent);
        }

        public function GetBuffEfficiencies_vector():Vector.<dBuffEfficiencyVO>
        {
            return (this.buffEfficiencies_vector);
        }

        public function getMilitaryUnitCapacity():int
        {
            return (this.militaryUnitCapacity);
        }

        public function isEventProduceable():Boolean
        {
            return ((!(this.requiresEvent == null)) && (!(this.requiresEvent == "")));
        }

        public function getApplyConditions():TriggerListVO
        {
            return (this.applyConditions);
        }

        public function getRenderAreaRings():int
        {
            return (this.renderAreaRings);
        }

        public function GetInstantBuildCosts():int
        {
            return (this.mInstantBuildCosts);
        }

        public function GetTooltipRenderPriority():int
        {
            if (this.IsChangeSkinBuff())
            {
                return (1);
            };
            return (2);
        }

        public function GetStackingGroup():String
        {
            return (this.mStackingGroup);
        }

        public function GetBattleBuffTargets():Vector.<dBattleBuffTarget>
        {
            return (this.battleBuffTarget_vector);
        }

        public function GetEffectByName(_arg_1:String):EffectVO
        {
            if (this.applyEffects == null)
            {
                return (null);
            };
            return (this.applyEffects.getEffectByName(_arg_1));
        }

        public function isIgnoreAreaOrigin():Boolean
        {
            return (this.ignoreAreaOrigin);
        }

        public function GetRedeemableEventName():String
        {
            return (this.redeemableEvent);
        }

        public function IsProducible():Boolean
        {
            return (this.produceable);
        }

        public function IsAdventure():Boolean
        {
            return (StringUtils.startsWith(this.GetName_string(), "Adventure"));
        }

        public function GetRequiredQuest():String
        {
            return (this.requiresQuest);
        }

        public function GetId():int
        {
            return (this.id);
        }

        public function isUseCountInsteadOfAmount():Boolean
        {
            return (this.useCountInsteadOfAmount);
        }

        public function IsTypeCombatInstant():Boolean
        {
            return (this.GetBuffType() == BUFF_TYPE.COMBAT_INSTANT);
        }

        public function getDuration(_arg_1:int):int
        {
            var _local_2:int;
            var _local_3:Number;
            if (_arg_1 == BUFF_APPLIANCE_MODE.FRIEND_OR_GUILD_MEMBER_PREMIUM)
            {
                _local_3 = (1 + (global.premiumAccount.GetFriendZoneBuffTimeBonus() / 100));
                _local_2 = (Math.round((this.durations_vector[BUFF_APPLIANCE_MODE.FRIEND] * _local_3)) as int);
            }
            else
            {
                if (_arg_1 < this.durations_vector.length)
                {
                    _local_2 = this.durations_vector[_arg_1];
                }
                else
                {
                    _local_2 = -1;
                };
            };
            return (_local_2);
        }

        public function GetParameter(_arg_1:int):Number
        {
            var _local_2:Number = this.mParameter[_arg_1];
            if (isNaN(_local_2))
            {
                _local_2 = 0;
            };
            return (_local_2);
        }

        public function getBuffUI():int
        {
            return (this.buffUI);
        }

        public function GetAdventureTargets():AdventureTargetListVO
        {
            return (this.adventureTargets);
        }

        public function IsChangeSkinBuff():Boolean
        {
            return ((!(this.applyEffects == null)) && (this.applyEffects.contains(ChangeSkin.XML_string)));
        }

        public function GetAmount():int
        {
            return (this.mAmount);
        }

        public function GetName_string():String
        {
            return (this.name_string);
        }

        public function GetPostEffects():EffectListVO
        {
            return (this.postEffects);
        }

        public function GetMin():int
        {
            return (this.min);
        }

        public function HasBattleBuffTarget(_arg_1:String):Boolean
        {
            var _local_2:dBattleBuffTarget;
            for each (_local_2 in this.battleBuffTarget_vector)
            {
                if (StringUtils.equalsIgnoreCase(_arg_1, _local_2.unitType))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function getUpgradeLevel():int
        {
            return (this.upgradeLevel);
        }

        public function isQuestProduceable():Boolean
        {
            return ((!(this.requiresQuest == null)) && (!(this.requiresQuest == "")));
        }

        public function GetSortIndex():int
        {
            return (this.sortIndex);
        }

        public function RequiredEventName():String
        {
            return (this.requiresEvent);
        }

        public function GetRequieredEvent():String
        {
            return (this.requiresEvent);
        }

        public function IsTradable(_arg_1:String):Boolean
        {
            var _local_2:int;
            var _local_3:cGOSpriteLibContainer;
            var _local_4:cAdventureDefinition;
            switch (this.id)
            {
                case defines.BUILD_BUILDING_BUFF_ID:
                    if (_arg_1 != null)
                    {
                        _local_2 = global.buildingGroup.GetNrFromName(_arg_1);
                        if (_local_2 >= 0)
                        {
                            _local_3 = global.buildingGroup.mGOList_vector[_local_2];
                            return (_local_3.isTradable());
                        };
                    };
                    break;
                case defines.ADVENTURE_BUFF_ID:
                    if (_arg_1 != null)
                    {
                        _local_4 = cAdventureDefinition.FindAdventureDefinition(_arg_1);
                        if (_local_4 != null)
                        {
                            return (_local_4.IsTradable());
                        };
                    };
                    break;
                default:
                    return (this.tradable);
            };
            return (false);
        }

        public function getTargetZoneTypes():int
        {
            return (this.mTargetZoneTypes);
        }

        public function isZoneCancelable():Boolean
        {
            if (this.GetBuffType() == BUFF_TYPE.ZONE_TIMED)
            {
                return (this.zoneCancelable);
            };
            return (true);
        }

        public function GetExclusivityGroup():String
        {
            return (this.exclusivityGroup);
        }

        public function isAllowInstantApplyOnProduce():Boolean
        {
            return (this.allowInstantApplyOnProduce);
        }

        public function GetBuffType():int
        {
            return (this.buffType);
        }

        public function GetType():String
        {
            return (this.name_string);
        }

        public function getProductivityOutputPercent():int
        {
            return (this.productivityOutputPercent);
        }

        public function getHitPoints():int
        {
            return (this.hitPoints);
        }

        public function GetCosts_vector():Vector.<dResource>
        {
            return (this.costs_vector);
        }

        public function IsTypeCombat():Boolean
        {
            return ((this.GetBuffType() == BUFF_TYPE.COMBAT_INSTANT) || (this.GetBuffType() == BUFF_TYPE.COMBAT_TIMED));
        }

        public function getAreaOffsets():GridOffsetVO
        {
            return (this.areaOffsets);
        }

        public function getRecruitingTime():int
        {
            return (this.recruitingTimePercentage);
        }

        public function GetProductionAmount():int
        {
            return ((this.mAmount == 0) ? 1 : this.mAmount);
        }

        public function IsChangeDefaultSkinBuff():Boolean
        {
            return ((!(this.applyEffects == null)) && (this.applyEffects.contains(ChangeDefaultSkin.XML_string)));
        }

        public function GetTargetGroup_string():String
        {
            return (this.targetGroup_string);
        }

        public function GetCombatModifiers():ModifierListVO
        {
            return (this.combatModifiers);
        }

        public function GetPropagatingBuffs():PropagatingBuffListVO
        {
            return (this.propagatingBuffs);
        }

        public function GetAvatarMessageOverride_string():String
        {
            return (this.avatarMessageOverride_string);
        }

        public function GetRepeatingEffects():EffectListVO
        {
            return (this.repeatingEffects);
        }

        public function GetCultureBuildingCooldown():int
        {
            return (this.mCultureBuildingCooldown);
        }


    }
}
