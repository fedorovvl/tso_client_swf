package MilitarySystem
{
    import Communication.VO.dSquadVO;
    import Communication.VO.dArmyVO;
    import __AS3__.vec.Vector;
    import Modifier.ModifierVO;
    import ServerState.dResource;
    import Interface.cGeneralInterface;
    import Specialists.cSpecialist;
    import Utils.StringUtils;
    import __AS3__.vec.*;

    public class cArmy 
    {

        private var mOwner:Object;
        private var mPlayerID:int;
        private var mBuildingDamage:int = 0;
        private var mZoneID:int;
        private var map_UnitType_Squad:Object = new Object();
        private var mOwnerType:int;

        public function cArmy(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Object)
        {
            super();
            this.mZoneID = _arg_1;
            this.mPlayerID = _arg_2;
            this.mOwnerType = _arg_3;
            this.mOwner = _arg_4;
        }

        public function ApplyArmyVO(_arg_1:dArmyVO):void
        {
            var _local_2:dSquadVO;
            this.map_UnitType_Squad = new Object();
            for each (_local_2 in _arg_1.squads)
            {
                this.AddSquadVO(_local_2, true);
            };
        }

        public function GetUnitsCount():int
        {
            var _local_2:cSquad;
            var _local_1:int;
            for each (_local_2 in this.map_UnitType_Squad)
            {
                _local_1 = (_local_1 + _local_2.GetAmount());
            };
            return (_local_1);
        }

        public function KillUnits(_arg_1:String, _arg_2:int, _arg_3:KillUnitsResult):void
        {
            var _local_4:cSquad = this.GetSquad(_arg_1);
            var _local_5:int = this.RemoveUnits(_arg_1, _arg_2);
            _arg_3.amount = (_arg_3.amount + _local_5);
            _arg_3.xp = (_arg_3.xp + (_local_4.GetUnitBase().GetXP() * _local_5));
            _arg_3.pvpXp = (_arg_3.pvpXp + (_local_4.GetUnitBase().GetPvPXP() * _local_5));
        }

        public function HasAttackableUnits():Boolean
        {
            var _local_1:cSquad;
            for each (_local_1 in this.map_UnitType_Squad)
            {
                if (((_local_1.GetUnitBase().IsAttackable()) && (_local_1.GetAmount() > 0)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function HasUnits():Boolean
        {
            var _local_1:cSquad;
            for each (_local_1 in this.map_UnitType_Squad)
            {
                if (_local_1.GetAmount() > 0)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function isNPC():Boolean
        {
            return (this.mPlayerID < 0);
        }

        public function GetChecksum():int
        {
            var _local_2:cSquad;
            var _local_1:int;
            for each (_local_2 in this.map_UnitType_Squad)
            {
                _local_1 = (_local_1 ^ (_local_2.GetUnitBase().GetCombatPriority() + (_local_2.GetAmount() << 6)));
            };
            return (_local_1);
        }

        public function AddCombatModifiersToSquads(_arg_1:Vector.<ModifierVO>):void
        {
            var _local_2:String;
            for (_local_2 in this.map_UnitType_Squad)
            {
                (this.map_UnitType_Squad[_local_2] as cSquad).AddApplicableCombatModifiers(_arg_1);
            };
        }

        public function GetCasualtiesVO(_arg_1:dArmyVO):dArmyVO
        {
            var _local_3:String;
            var _local_4:dSquadVO;
            var _local_5:Boolean;
            var _local_6:dSquadVO;
            var _local_2:dArmyVO = new dArmyVO();
            for (_local_3 in this.map_UnitType_Squad)
            {
                _local_4 = new dSquadVO();
                _local_4.name_string = _local_3;
                _local_5 = false;
                for each (_local_6 in _arg_1.squads)
                {
                    if (_local_6.name_string == _local_3)
                    {
                        _local_4.amount = ((this.map_UnitType_Squad[_local_3] as cSquad).amount - _local_6.amount);
                        _local_5 = true;
                    };
                };
                if (!_local_5)
                {
                    _local_4.amount = (this.map_UnitType_Squad[_local_3] as cSquad).amount;
                };
                _local_2.squads.addItem(_local_4);
            };
            return (_local_2);
        }

        public function HasUnit(_arg_1:String):Boolean
        {
            var _local_2:cSquad;
            for each (_local_2 in this.map_UnitType_Squad)
            {
                if (((_local_2.name_string == _arg_1) && (_local_2.GetAmount() > 0)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function GetFirstDefenseNPCUnit():cSquad
        {
            var _local_4:cSquad;
            var _local_5:cMilitaryUnitData;
            var _local_1:Vector.<cSquad> = this.GetSquads_vector();
            var _local_2:int;
            var _local_3:cSquad;
            for each (_local_4 in _local_1)
            {
                _local_5 = cMilitaryUnitData.GetUnitDataForType(_local_4.GetType());
                if (((!(_local_5 == null)) && (_local_5.GetDefensePriority() > _local_2)))
                {
                    _local_2 = _local_4.GetUnitBase().GetDefensePriority();
                    _local_3 = _local_4;
                };
            };
            _local_1.sort(cSquad.SortByCombatPriorityUnitqueIdDesc);
            if (((_local_3 == null) && (_local_1.length >= 1)))
            {
                _local_3 = _local_1[0];
            };
            if ((((!(_local_3 == null)) && (_local_3.GetUnitBase().IsNPC())) && (_local_3.GetUnitBase().IsCombatThree())))
            {
                return (_local_3);
            };
            return (null);
        }

        public function DisbandArmy(_arg_1:cArmy):void
        {
            var _local_2:cSquad;
            if (_arg_1 != null)
            {
                for each (_local_2 in this.map_UnitType_Squad)
                {
                    if (!_local_2.GetUnitBase().IsSpecialist())
                    {
                        _arg_1.AddUnits(_local_2.GetType(), _local_2.GetAmount(), 0, true);
                    };
                };
            };
            this.map_UnitType_Squad = new Object();
        }

        public function CreateArmyVO():dArmyVO
        {
            var _local_2:cSquad;
            var _local_1:dArmyVO = new dArmyVO();
            for each (_local_2 in this.map_UnitType_Squad)
            {
                _local_1.squads.addItem(_local_2.CreateSquadVO());
            };
            return (_local_1);
        }

        public function GetSquad(_arg_1:String):cSquad
        {
            return (this.map_UnitType_Squad[_arg_1]);
        }

        public function GetTotalUnitResourceCosts():Vector.<dResource>
        {
            var _local_2:cSquad;
            var _local_3:dResource;
            var _local_4:dResource;
            var _local_1:Vector.<dResource> = new Vector.<dResource>();
            for each (_local_2 in this.GetSquads_vector())
            {
                for each (_local_3 in cMilitaryUnitData.GetUnitDataForType(_local_2.GetType()).GetCosts_vector())
                {
                    _local_4 = _local_3.clone();
                    _local_4.amount = (_local_3.amount * _local_2.amount);
                    _local_1.push(_local_4);
                };
            };
            return (_local_1);
        }

        public function CalculateBuildingDamage(_arg_1:cGeneralInterface):int
        {
            var _local_2:cSquad;
            this.mBuildingDamage = 0;
            for each (_local_2 in this.map_UnitType_Squad)
            {
                this.mBuildingDamage = (this.mBuildingDamage + _local_2.GetBuildingDamage(_arg_1));
            };
            return (this.mBuildingDamage);
        }

        public function RemoveUnits(_arg_1:String, _arg_2:int):int
        {
            var _local_4:int;
            var _local_3:cSquad = this.map_UnitType_Squad[_arg_1];
            if (_local_3 == null)
            {
                return (0);
            };
            _local_4 = _local_3.GetAmount();
            if (_arg_2 < _local_4)
            {
                _local_4 = _arg_2;
            };
            _local_3.AddUnits(-(_local_4), true);
            if (_local_3.GetAmount() == 0)
            {
                delete this.map_UnitType_Squad[_arg_1];
            };
            return (_local_4);
        }

        public function toString():String
        {
            var _local_2:cSquad;
            var _local_1:* = "<Army>";
            for each (_local_2 in this.map_UnitType_Squad)
            {
                _local_1 = (_local_1 + _local_2);
            };
            return (_local_1 + "</Army>");
        }

        public function AddUnits(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            var _local_6:cMilitaryUnitBase;
            var _local_7:cSpecialist;
            var _local_5:cSquad = this.map_UnitType_Squad[_arg_1];
            if (_local_5 == null)
            {
                _local_6 = cMilitaryUnitBase.GetUnitBaseForType(_arg_1);
                _local_5 = new cSquad(_arg_1, _arg_2, ((_arg_3 > 0) ? _arg_3 : _local_6.GetHitPoints()), _arg_4);
                this.map_UnitType_Squad[_arg_1] = _local_5;
            }
            else
            {
                _local_5.AddUnits(_arg_2, _arg_4);
            };
            if (((!(this.mOwner == null)) && (this.mOwner is cSpecialist)))
            {
                _local_7 = (this.mOwner as cSpecialist);
                if (_local_7 != null)
                {
                    _local_5.mCombatModifiers.clear();
                    _local_5.AddApplicableCombatModifiers(_local_7.GetAllActiveModifiers());
                };
            };
        }

        public function AddSquadVO(_arg_1:dSquadVO, _arg_2:Boolean):void
        {
            this.AddUnits(_arg_1.GetType(), _arg_1.GetAmount(), 0, _arg_2);
        }

        public function GetSquadsCollection_vector():Vector.<cSquad>
        {
            return (this.GetSquads_vector());
        }

        public function HasInvincibleUnits():Boolean
        {
            var _local_1:cSquad;
            for each (_local_1 in this.map_UnitType_Squad)
            {
                if (((!(_local_1.GetUnitBase().IsAttackable())) && (_local_1.GetAmount() > 0)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function GetSquads_vector():Vector.<cSquad>
        {
            var _local_2:cSquad;
            var _local_1:Vector.<cSquad> = new Vector.<cSquad>();
            for each (_local_2 in this.map_UnitType_Squad)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }

        public function ApplyArmyForCheat(_arg_1:dArmyVO):void
        {
            var _local_2:dSquadVO;
            for each (_local_2 in _arg_1.squads)
            {
                if (this.GetSquad(_local_2.name_string) != null)
                {
                    this.AddUnits(_local_2.name_string, (_local_2.amount - this.GetSquad(_local_2.name_string).amount), _local_2.currentHitPoints, true);
                }
                else
                {
                    this.AddSquadVO(_local_2, true);
                };
            };
        }

        public function HasEliteUnits():Boolean
        {
            var _local_1:cSquad;
            if (this.HasUnits())
            {
                for each (_local_1 in this.GetSquads_vector())
                {
                    if (_local_1.GetUnitBase().GetIsElite())
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function GetSquadsByCombatantType(_arg_1:String):Vector.<cSquad>
        {
            var _local_3:cSquad;
            var _local_4:cMilitaryUnitDescription;
            var _local_2:Vector.<cSquad> = new Vector.<cSquad>();
            for each (_local_3 in this.map_UnitType_Squad)
            {
                _local_4 = (cMilitaryUnitBase.GetUnitBaseForType(_local_3.GetType()) as cMilitaryUnitDescription);
                if (((!(_local_4 == null)) && (StringUtils.equalsIgnoreCase(_local_4.GetCombatantType(), _arg_1))))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }


    }
}
