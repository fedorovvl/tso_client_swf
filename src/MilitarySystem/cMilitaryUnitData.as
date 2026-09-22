package MilitarySystem
{
    import Enums.MILITARY_UNIT_PROPERTY;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import nLib.cXML;
    import Enums.MILITARY_UNIT_ARMORTYPE;
    import nLib.cLog;
    import GUI.Components.data.dCombatUnitData;
    import Enums.UNIT_COST_SOURCE;
    import __AS3__.vec.*;

    public class cMilitaryUnitData extends cMilitaryUnitBase 
    {

        private static var map_UnitType_UnitData:Object = new Object();

        private var mGroup:String;
        private var mCombatBatchSize:int;
        private var mArmorType:int;
        private var mBaseDamage:int;
        private var mTier:int;

        private var mAbility:Object = new Object();
        private var mProperty:Object = new Object();

        public function cMilitaryUnitData(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:String, _arg_9:int, _arg_10:Vector.<dResource>, _arg_11:Vector.<cMilitaryUnitAbility>, _arg_12:Vector.<cMilitaryUnitProperty>)
        {
            var _local_14:cMilitaryUnitAbility;
            var _local_15:cMilitaryUnitProperty;
            super(2, _arg_1, _arg_3, _arg_5, _arg_6, _arg_10);
            this.mArmorType = _arg_2;
            this.mBaseDamage = _arg_4;
            this.mTier = _arg_7;
            this.mGroup = _arg_8;
            this.mCombatBatchSize = _arg_9;
            if (_arg_11 != null)
            {
                for each (_local_14 in _arg_11)
                {
                    this.mAbility[_local_14.GetType()] = _local_14;
                };
            };
            if (_arg_12 != null)
            {
                for each (_local_15 in _arg_12)
                {
                    this.mProperty[_local_15.GetType()] = _local_15;
                };
            };
            var _local_13:cMilitaryUnitProperty = this.GetProperty(MILITARY_UNIT_PROPERTY.INSTANT_BUILD_COST);
            if (_local_13 != null)
            {
                SetInstantBuildCost(_local_13.GetValue());
            };
            _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.PRODUCTION_TIME);
            if (_local_13 != null)
            {
                SetProductionTime((_local_13.GetValue() * 1000));
            };
            _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.ID);
            if (_local_13 != null)
            {
                SetId(_local_13.GetValue());
            };
            _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.IS_BOSS);
            if (_local_13 != null)
            {
                SetIsBoss((_local_13.GetValue() > 0));
            };
            _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.IS_PRODUCIBLE);
            if (_local_13 != null)
            {
                SetIsProducible((_local_13.GetValue() > 0));
            };
            _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.IS_SPECIALIST);
            if (_local_13 != null)
            {
                SetIsSpecialist((_local_13.GetValue() > 0));
            };
            if (IsNPC())
            {
                _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.INITIATIVE);
            }
            else
            {
                _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.ATTACK_PRIORITY);
            };
            if (_local_13 != null)
            {
                SetCombatPriority(_local_13.GetValue());
            };
            if (IsNPC())
            {
                _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.DEFENSE_PRIORITY);
                if (_local_13 != null)
                {
                    SetDefensePriority(_local_13.GetValue());
                };
            };
            _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.UI_PRIORITY);
            if (_local_13 != null)
            {
                SetUIPriority(_local_13.GetValue());
            };
            _local_13 = this.GetProperty(MILITARY_UNIT_PROPERTY.UNIT_CATEGORY);
            if (_local_13 != null)
            {
                SetUnitCategory(_local_13.GetValue());
            };
            SetIsAttackable(true);
            SetCanAttack(true);
        }

        public static function GetAllUnitDataByTier(_arg_1:Boolean, _arg_2:int):Array
        {
            var _local_4:String;
            var _local_5:cMilitaryUnitData;
            var _local_3:Array = [];
            for (_local_4 in map_UnitType_UnitData)
            {
                _local_5 = (map_UnitType_UnitData[_local_4] as cMilitaryUnitData);
                if ((((_local_5.IsProducible()) || (!(_arg_1))) && (_local_5.GetTier() == _arg_2)))
                {
                    _local_3.push(_local_5);
                };
            };
            _local_3.sort(cMilitaryUnitBase.SortByUIPriority);
            return (_local_3);
        }

        public static function GetAllUnitData(_arg_1:Boolean, _arg_2:Boolean):Array
        {
            var _local_4:String;
            var _local_3:Array = [];
            for (_local_4 in map_UnitType_UnitData)
            {
                if ((((map_UnitType_UnitData[_local_4] as cMilitaryUnitData).IsProducible()) || (!(_arg_1))))
                {
                    _local_3.push(map_UnitType_UnitData[_local_4]);
                };
            };
            if (_arg_2)
            {
                _local_3.sort(cMilitaryUnitBase.SortByUIPriority);
            }
            else
            {
                _local_3.sort(cMilitaryUnitBase.SortUnits);
            };
            return (_local_3);
        }

        public static function InitData(_arg_1:cXML):void
        {
            var _local_3:cXML;
            var _local_4:String;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:String;
            var _local_13:Vector.<dResource>;
            var _local_14:cXML;
            var _local_15:Vector.<cXML>;
            var _local_16:cXML;
            var _local_17:cXML;
            var _local_18:Vector.<cXML>;
            var _local_19:Vector.<cMilitaryUnitAbility>;
            var _local_20:cXML;
            var _local_21:Vector.<cXML>;
            var _local_22:Vector.<cMilitaryUnitProperty>;
            var _local_23:cMilitaryUnitData;
            var _local_24:dResource;
            var _local_25:cMilitaryUnitAbility;
            var _local_26:cMilitaryUnitProperty;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                _local_4 = _local_3.GetAttributeString_string("Type");
                _local_5 = MILITARY_UNIT_ARMORTYPE.parse(_local_3.GetAttributeString_string("ArmorType"));
                _local_6 = _local_3.GetAttributeInt("HP");
                _local_7 = _local_3.GetAttributeInt("BaseDamage");
                _local_8 = _local_3.GetAttributeInt("XP");
                _local_9 = _local_3.GetAttributeInt("PvPXP");
                _local_10 = _local_3.GetAttributeInt("Tier");
                _local_11 = _local_3.GetAttributeInt("CombatBatchSize", 0);
                _local_12 = _local_3.GetAttributeString_string("group");
                _local_13 = new Vector.<dResource>();
                _local_14 = _local_3.MoveToSubNode("Costs");
                _local_15 = _local_14.CreateChildrenArray();
                for each (_local_16 in _local_15)
                {
                    _local_24 = new dResource();
                    _local_24.name_string = _local_16.GetAttributeString_string("Type");
                    _local_24.amount = _local_16.GetAttributeInt("Amount");
                    _local_13.push(_local_24);
                };
                _local_17 = _local_3.MoveToSubNode("Abilities");
                _local_18 = _local_17.CreateChildrenArray();
                _local_19 = new Vector.<cMilitaryUnitAbility>();
                for each (_local_16 in _local_18)
                {
                    _local_25 = cMilitaryUnitAbility.create(_local_16);
                    if (_local_25 != null)
                    {
                        _local_19.push(_local_25);
                    };
                };
                _local_20 = _local_3.MoveToSubNode("Properties");
                _local_21 = _local_20.CreateChildrenArray();
                _local_22 = new Vector.<cMilitaryUnitProperty>();
                for each (_local_16 in _local_21)
                {
                    _local_26 = cMilitaryUnitProperty.create(_local_16);
                    if (_local_26 != null)
                    {
                        _local_22.push(_local_26);
                    };
                };
                _local_23 = new cMilitaryUnitData(_local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10, _local_12, _local_11, _local_13, _local_19, _local_22);
                map_UnitType_UnitData[_local_4] = _local_23;
                cMilitaryUnitBase.AddUnitToMaps(_local_23);
            };
        }

        public static function GetAllUnitDataInCategory(_arg_1:int):Array
        {
            var _local_3:String;
            var _local_4:cMilitaryUnitData;
            var _local_2:Array = [];
            for (_local_3 in map_UnitType_UnitData)
            {
                _local_4 = (map_UnitType_UnitData[_local_3] as cMilitaryUnitData);
                if (_local_4.GetUnitCategory() == _arg_1)
                {
                    _local_2.push(_local_4);
                };
            };
            return (_local_2);
        }

        public static function GetUnitDataForType(_arg_1:String):cMilitaryUnitData
        {
            var _local_2:cMilitaryUnitData = map_UnitType_UnitData[_arg_1];
            if (_local_2 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((("cMilitaryUnitData.GetUnitDataForType failed (type: " + _arg_1) + ")"));
                };
            };
            return (_local_2);
        }


        public function GetArmorType():int
        {
            return (this.mArmorType);
        }

        public function GetUnitClassLabelString():String
        {
            switch (this.GetArmorType())
            {
                case MILITARY_UNIT_ARMORTYPE.LIGHT:
                    return ("UnitDetailsTypeLight");
                case MILITARY_UNIT_ARMORTYPE.MEDIUM:
                    return ("UnitDetailsTypeMedium");
                case MILITARY_UNIT_ARMORTYPE.HEAVY:
                    return ("UnitDetailsTypeHeavy");
                case MILITARY_UNIT_ARMORTYPE.TANK:
                    return ("UnitDetailsTypeTank");
                default:
                    return ("InvalidClass");
            };
        }

        public function GetObjectForItemRenderer(_arg_1:int):dCombatUnitData
        {
            var _local_3:cMilitaryUnitAbility;
            var _local_4:dResource;
            var _local_2:dCombatUnitData = new dCombatUnitData();
            _local_2.itemMode = 0;
            _local_2.name_string = this.GetType();
            _local_2.tier = this.GetTier();
            _local_2.armorType = this.GetArmorType();
            _local_2.bonusDamage1 = -1;
            _local_2.bonusDamage2 = -1;
            _local_2.current = 0;
            _local_2.costAmount = 0;
            _local_2.available = 0;
            _local_2.isEnabled = false;
            _local_2.isEmpty = false;
            _local_2.isSelected = false;
            _local_2.available = 0;
            _local_2.isSelectable = false;
            switch (_arg_1)
            {
                case UNIT_COST_SOURCE.UNIT:
                    _local_2.costName = this.GetType();
                    _local_2.costAmount = 1;
                    break;
                case UNIT_COST_SOURCE.COST:
                    for each (_local_4 in this.GetCosts_vector())
                    {
                        _local_2.costName = _local_4.name_string;
                        _local_2.costAmount = _local_4.amount;
                    };
                    break;
            };
            for each (_local_3 in this.GetAbilities())
            {
                if (_local_2.bonusDamage1 == -1)
                {
                    _local_2.bonusDamage1 = _local_3.GetType();
                }
                else
                {
                    _local_2.bonusDamage2 = _local_3.GetType();
                };
            };
            return (_local_2);
        }

        public function IsArmorTypeMedium():Boolean
        {
            return (this.GetArmorType() == MILITARY_UNIT_ARMORTYPE.MEDIUM);
        }

        public function GetAbility(_arg_1:int):cMilitaryUnitAbility
        {
            return (this.mAbility[_arg_1]);
        }

        public function IsArmorTypeHeavy():Boolean
        {
            return (this.GetArmorType() == MILITARY_UNIT_ARMORTYPE.HEAVY);
        }

        public function IsArmorTypeLight():Boolean
        {
            return (this.GetArmorType() == MILITARY_UNIT_ARMORTYPE.LIGHT);
        }

        public function GetGroup():String
        {
            return (this.mGroup);
        }

        public function GetProperty(_arg_1:int):cMilitaryUnitProperty
        {
            return (this.mProperty[_arg_1]);
        }

        public function GetCombatBatchSize():int
        {
            return (this.mCombatBatchSize);
        }

        public function GetAbilities():Vector.<cMilitaryUnitAbility>
        {
            var _local_2:cMilitaryUnitAbility;
            var _local_1:Vector.<cMilitaryUnitAbility> = new Vector.<cMilitaryUnitAbility>();
            for each (_local_2 in this.mAbility)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }

        public function GetBaseDamage():int
        {
            return (this.mBaseDamage);
        }

        public function GetTier():int
        {
            return (this.mTier);
        }

        public function IsArmorTypeTank():Boolean
        {
            return (this.GetArmorType() == MILITARY_UNIT_ARMORTYPE.TANK);
        }

        public function toString():String
        {
            return (((("<MilitaryUnitData'" + GetType()) + "' ") + this.GetAbilities()) + " >");
        }


    }
}
