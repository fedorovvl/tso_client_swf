package MilitarySystem
{
    import Enums.MILLITARY_UNIT_SKILLS;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import nLib.cXML;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class cMilitaryUnitDescription extends cMilitaryUnitBase 
    {

        private static var map_UnitType_UnitDescription:Object = new Object();

        private var mHitPercentage:int;
        private var mCombatantType:String;
        private var mMap_SkillType_Skill:Object = new Object();
        private var mHitDamage:int;
        private var mMissDamage:int;

        public function cMilitaryUnitDescription(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:Boolean, _arg_9:int, _arg_10:int, _arg_11:int, _arg_12:int, _arg_13:Vector.<dResource>, _arg_14:Vector.<cMilitaryUnitSkill>, _arg_15:Boolean, _arg_16:Boolean, _arg_17:Boolean, _arg_18:String)
        {
            var _local_19:cMilitaryUnitSkill;
            super(1, _arg_2, _arg_3, _arg_10, _arg_11, _arg_13);
            SetId(_arg_1);
            SetCombatPriority(_arg_4);
            this.mHitPercentage = _arg_5;
            this.mCombatantType = _arg_18;
            this.mHitDamage = _arg_6;
            this.mMissDamage = _arg_7;
            SetIsProducible(_arg_8);
            SetProductionTime(_arg_9);
            SetInstantBuildCost(_arg_12);
            SetIsElite(_arg_15);
            SetIsAttackable(_arg_16);
            SetCanAttack(_arg_17);
            for each (_local_19 in _arg_14)
            {
                this.mMap_SkillType_Skill[_local_19.GetType()] = _local_19;
                if (_local_19.GetType() == MILLITARY_UNIT_SKILLS.IS_SPECIALIST)
                {
                    SetIsSpecialist(true);
                };
            };
        }

        public static function GetUnitDescriptionForType(_arg_1:String):cMilitaryUnitDescription
        {
            return (map_UnitType_UnitDescription[_arg_1]);
        }

        public static function GetAllUnitDescriptions(_arg_1:Boolean):Array
        {
            var _local_3:String;
            var _local_2:Array = [];
            for (_local_3 in map_UnitType_UnitDescription)
            {
                if ((((map_UnitType_UnitDescription[_local_3] as cMilitaryUnitDescription).IsProducible()) || (!(_arg_1))))
                {
                    _local_2.push(map_UnitType_UnitDescription[_local_3]);
                };
            };
            _local_2.sort(cMilitaryUnitBase.SortUnits);
            return (_local_2);
        }

        public static function InitData(_arg_1:cXML):void
        {
            var _local_4:cXML;
            var _local_5:int;
            var _local_6:String;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:String;
            var _local_11:int;
            var _local_12:Boolean;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:Boolean;
            var _local_18:Boolean;
            var _local_19:Boolean;
            var _local_20:int;
            var _local_21:Vector.<dResource>;
            var _local_22:cXML;
            var _local_23:Vector.<cXML>;
            var _local_24:cXML;
            var _local_25:Vector.<cMilitaryUnitSkill>;
            var _local_26:cXML;
            var _local_27:Vector.<cXML>;
            var _local_28:cXML;
            var _local_29:cMilitaryUnitDescription;
            var _local_30:dResource;
            var _local_31:int;
            var _local_32:int;
            var _local_2:Vector.<int> = new Vector.<int>();
            var _local_3:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_4 in _local_3)
            {
                _local_5 = _local_4.GetAttributeInt("id");
                _local_6 = _local_4.GetAttributeString_string("type");
                _local_7 = _local_4.GetAttributeInt("hitPoints", 1);
                _local_8 = _local_4.GetAttributeInt("hitPercentage");
                _local_9 = _local_4.GetAttributeInt("hitDamage");
                _local_10 = _local_4.GetAttributeString_string("combatantType");
                _local_11 = _local_4.GetAttributeInt("missDamage");
                _local_12 = _local_4.GetAttributeBool("produceable");
                _local_13 = (_local_4.GetAttributeInt("productionTimeSeconds") * 1000);
                _local_14 = _local_4.GetAttributeInt("xpForDefeat");
                _local_15 = _local_4.GetAttributeInt("pvpXpForDefeat");
                _local_16 = _local_4.GetAttributeInt("instantBuildCosts");
                _local_17 = _local_4.GetAttributeBool("isElite");
                _local_18 = _local_4.GetAttributeBool("isAttackable", true);
                _local_19 = _local_4.GetAttributeBool("canAttack", true);
                _local_20 = _local_4.GetAttributeInt("sequencePrio");
                if (_local_2.indexOf(_local_20) != -1)
                {
                    gMisc.Assert(false, (("sequencePrio " + _local_20) + " is already assigned."));
                };
                _local_2.push(_local_20);
                _local_21 = new Vector.<dResource>();
                _local_22 = _local_4.MoveToSubNode("Costs");
                _local_23 = _local_22.CreateChildrenArray();
                for each (_local_24 in _local_23)
                {
                    _local_30 = new dResource();
                    _local_30.name_string = _local_24.GetAttributeString_string("name");
                    _local_30.amount = _local_24.GetAttributeInt("count");
                    _local_21.push(_local_30);
                };
                _local_25 = new Vector.<cMilitaryUnitSkill>();
                _local_26 = _local_4.MoveToSubNode("Skills");
                _local_27 = _local_26.CreateChildrenArray();
                for each (_local_28 in _local_27)
                {
                    _local_31 = _local_28.GetAttributeInt("type");
                    _local_32 = _local_28.GetAttributeInt("data");
                    _local_25.push(new cMilitaryUnitSkill(_local_31, _local_32));
                };
                _local_29 = new cMilitaryUnitDescription(_local_5, _local_6, _local_7, _local_20, _local_8, _local_9, _local_11, _local_12, _local_13, _local_14, _local_15, _local_16, _local_21, _local_25, _local_17, _local_18, _local_19, _local_10);
                map_UnitType_UnitDescription[_local_6] = _local_29;
                cMilitaryUnitBase.AddUnitToMaps(_local_29);
            };
        }


        public function GetMissDamage():int
        {
            return (this.mMissDamage);
        }

        public function toString():String
        {
            return (((("<MilitaryUnitDescription '" + GetType()) + "' ") + this.GetSkills()) + " >");
        }

        public function GetHitDamage():int
        {
            return (this.mHitDamage);
        }

        public function GetRequieredEvent():String
        {
            return ("");
        }

        public function GetHitPercentage():int
        {
            return (this.mHitPercentage);
        }

        public function GetSkill(_arg_1:int):cMilitaryUnitSkill
        {
            return (this.mMap_SkillType_Skill[_arg_1]);
        }

        public function GetCombatantType():String
        {
            return (this.mCombatantType);
        }

        public function GetSkills():Vector.<cMilitaryUnitSkill>
        {
            var _local_2:cMilitaryUnitSkill;
            var _local_1:Vector.<cMilitaryUnitSkill> = new Vector.<cMilitaryUnitSkill>();
            for each (_local_2 in this.mMap_SkillType_Skill)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }


    }
}
