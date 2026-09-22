package MilitarySystem
{
    import TimedProduction.iTimedProductionDefinition;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import Utils.StringUtils;
    import Communication.VO.dRequirementsVO;
    import Communication.VO.dRequirementVO;
    import Interface.cGameInterface;
    import Enums.REQUIREMENT_TYPE;
    import nLib.cLog;

    public class cMilitaryUnitBase implements iTimedProductionDefinition 
    {

        private static const FLAG_BOSS:int = (1 << 0);
        private static const FLAG_PRODUCIBLE:int = (1 << 1);
        private static const FLAG_SPECIALIST:int = (1 << 2);
        private static const FLAG_IS_ATTACKABLE:int = (1 << 3);
        private static const FLAG_CAN_ATTACK:int = (1 << 4);
        private static var map_UnitType_UnitBase:Object = new Object();
        private static var map_UnitType_UnitBaseProducible:Object = new Object();

        private var mCombatPriority:int = 1;
        private var mUIPriority:int = 1;
        private var mPvPXP:int = 0;
        private var mFlags:int;
        private var mXP:int = 0;
        private var mUnitCategory:int = 0;
        private var mHP:int = 0;
        private var mBaseType:int;
        private var mType:String;
        private var mInstantBuildCosts:int = 0;
        private var mDefensePriority:int = 0;
        private var mUniqueId:int = 0;
        private var mCost:Vector.<dResource> = null;
        private var mIsElite:Boolean = false;
        private var mId:int = 0;
        private var mProductionTime:int = 0;

        public function cMilitaryUnitBase(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:Vector.<dResource>)
        {
            super();
            this.mBaseType = _arg_1;
            this.mType = _arg_2;
            this.mHP = _arg_3;
            this.mXP = _arg_4;
            this.mPvPXP = _arg_5;
            this.mCost = _arg_6;
            this.mUniqueId = StringUtils.GetHashCode(this.GetType());
        }

        public static function SortByUIPriority(_arg_1:cMilitaryUnitBase, _arg_2:cMilitaryUnitBase):int
        {
            return (_arg_1.GetUIPriority() - _arg_2.GetUIPriority());
        }

        public static function SortUnits(_arg_1:cMilitaryUnitBase, _arg_2:cMilitaryUnitBase):int
        {
            var _local_3:int;
            var _local_4:dRequirementsVO;
            var _local_5:int;
            var _local_6:dRequirementsVO;
            var _local_7:Vector.<dRequirementVO>;
            var _local_8:Vector.<dRequirementVO>;
            if ((global.ui is cGameInterface))
            {
                _local_3 = -1;
                _local_4 = (global.ui as cGameInterface).mRequirements.timedProductionRequirements_vector[_arg_1.GetType()];
                if (_local_4 != null)
                {
                    _local_7 = _local_4.getRequirementsByType(REQUIREMENT_TYPE.LEVEL);
                    if (_local_7.length > 0)
                    {
                        _local_3 = parseInt(_local_7.pop().value);
                    };
                };
                _local_5 = -1;
                _local_6 = (global.ui as cGameInterface).mRequirements.timedProductionRequirements_vector[_arg_2.GetType()];
                if (_local_6 != null)
                {
                    _local_8 = _local_6.getRequirementsByType(REQUIREMENT_TYPE.LEVEL);
                    if (_local_8.length > 0)
                    {
                        _local_5 = parseInt(_local_8.pop().value);
                    };
                };
                if (_local_3 > -1)
                {
                    if (_local_5 > -1)
                    {
                        if (_local_3 == _local_5)
                        {
                            return (_arg_1.GetId() - _arg_2.GetId());
                        };
                        return (_local_3 - _local_5);
                    };
                    return (-1);
                };
                if (_local_5 > -1)
                {
                    return (1);
                };
            };
            return (0);
        }

        public static function GetHitPointsForUnit(_arg_1:String):int
        {
            return (GetUnitBaseForType(_arg_1).GetHitPoints());
        }

        public static function GetAllUnit(_arg_1:Boolean):Array
        {
            var _local_3:String;
            var _local_4:String;
            var _local_2:Array = [];
            if (_arg_1)
            {
                for (_local_3 in map_UnitType_UnitBaseProducible)
                {
                    _local_2.push(map_UnitType_UnitBaseProducible[_local_3]);
                };
            }
            else
            {
                for (_local_4 in map_UnitType_UnitBase)
                {
                    _local_2.push(map_UnitType_UnitBase[_local_4]);
                };
            };
            _local_2.sort(SortUnits);
            return (_local_2);
        }

        public static function AddUnitToMaps(_arg_1:cMilitaryUnitBase):void
        {
            if (map_UnitType_UnitBase[_arg_1.GetType()] == null)
            {
                map_UnitType_UnitBase[_arg_1.GetType()] = _arg_1;
                if (_arg_1.IsProducible())
                {
                    map_UnitType_UnitBaseProducible[_arg_1.GetType()] = _arg_1;
                };
            }
            else
            {
                throw (new Error((("cMilitaryUnitBase.AddUnitToMaps: duplicate unit (Unit: " + _arg_1.GetType()) + ")")));
            };
        }

        public static function GetUnitBaseForType(_arg_1:String):cMilitaryUnitBase
        {
            var _local_2:cMilitaryUnitBase = map_UnitType_UnitBase[_arg_1];
            if (_local_2 == null)
            {
                if (cLog.isInfoEnabled())
                {
                    cLog.info((("cMilitaryUnitBase.GetUnitBaseForType failed (type: " + _arg_1) + ")"));
                };
            };
            return (_local_2);
        }

        public static function SortByCombatPriority(_arg_1:cMilitaryUnitBase, _arg_2:cMilitaryUnitBase):int
        {
            return (_arg_1.GetCombatPriority() - _arg_2.GetCombatPriority());
        }

        public static function SortSquads(_arg_1:cSquad, _arg_2:cSquad):int
        {
            return (cMilitaryUnitBase.SortUnits(_arg_1.GetUnitBase(), _arg_2.GetUnitBase()));
        }


        public function GetBaseType():int
        {
            return (this.mBaseType);
        }

        public function GetProductionTime():int
        {
            return (this.mProductionTime);
        }

        public function SetUnitCategory(_arg_1:int):void
        {
            this.mUnitCategory = _arg_1;
        }

        public function SetProductionTime(_arg_1:int):void
        {
            this.mProductionTime = _arg_1;
        }

        public function GetType():String
        {
            return (this.mType);
        }

        public function IsAttackable():Boolean
        {
            return ((this.mFlags & FLAG_IS_ATTACKABLE) > 0);
        }

        protected function SetCanAttack(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_CAN_ATTACK);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_CAN_ATTACK)));
            };
        }

        protected function SetIsBoss(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_BOSS);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_BOSS)));
            };
        }

        public function IsSpecialist():Boolean
        {
            return ((this.mFlags & FLAG_SPECIALIST) > 0);
        }

        public function GetCombatPriority():int
        {
            return (this.mCombatPriority);
        }

        public function CanAttack():Boolean
        {
            return ((this.mFlags & FLAG_CAN_ATTACK) > 0);
        }

        public function SetCombatPriority(_arg_1:int):void
        {
            this.mCombatPriority = _arg_1;
        }

        public function GetUniqueId():int
        {
            return (this.mUniqueId);
        }

        public function GetCost():Vector.<dResource>
        {
            return (this.mCost);
        }

        public function GetUIPriority():int
        {
            return (this.mUIPriority);
        }

        public function SetUIPriority(_arg_1:int):void
        {
            this.mUIPriority = _arg_1;
        }

        public function GetInstantBuildCosts():int
        {
            return (this.mInstantBuildCosts);
        }

        public function GetProductionName_string():String
        {
            return (this.GetType());
        }

        public function IsNPC():Boolean
        {
            return (!(this.IsProducible()));
        }

        public function GetHitPoints():int
        {
            return (this.mHP);
        }

        public function GetCosts_vector():Vector.<dResource>
        {
            return (this.GetCost());
        }

        protected function SetIsProducible(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_PRODUCIBLE);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_PRODUCIBLE)));
            };
        }

        public function GetXP():int
        {
            return (this.mXP);
        }

        protected function SetIsAttackable(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_IS_ATTACKABLE);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_IS_ATTACKABLE)));
            };
        }

        public function GetProductionAmount():int
        {
            return (1);
        }

        protected function SetIsSpecialist(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mFlags = (this.mFlags | FLAG_SPECIALIST);
            }
            else
            {
                this.mFlags = (this.mFlags & (~(FLAG_SPECIALIST)));
            };
        }

        public function GetSequencePrio():int
        {
            return (this.GetCombatPriority());
        }

        public function IsCombatThree():Boolean
        {
            return (this.GetBaseType() == 2);
        }

        public function GetID_Int():int
        {
            return (this.GetId());
        }

        public function GetProductionSourceName_string():String
        {
            return (this.GetProductionName_string());
        }

        public function SetInstantBuildCost(_arg_1:int):void
        {
            this.mInstantBuildCosts = _arg_1;
        }

        public function SetIsElite(_arg_1:Boolean):void
        {
            this.mIsElite = _arg_1;
        }

        public function SetDefensePriority(_arg_1:int):void
        {
            this.mDefensePriority = _arg_1;
        }

        public function GetPvPXP():int
        {
            return (this.mPvPXP);
        }

        public function GetDefensePriority():int
        {
            return (this.mDefensePriority);
        }

        public function IsBoss():Boolean
        {
            return ((this.mFlags & FLAG_BOSS) > 0);
        }

        public function GetId():int
        {
            return (this.mId);
        }

        public function GetUnitCategory():int
        {
            return (this.mUnitCategory);
        }

        public function IsProducible():Boolean
        {
            return ((this.mFlags & FLAG_PRODUCIBLE) > 0);
        }

        public function GetIsElite():Boolean
        {
            return (this.mIsElite);
        }

        public function SetId(_arg_1:int):void
        {
            this.mId = _arg_1;
        }


    }
}
