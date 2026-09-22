package MilitarySystem
{
    import Communication.VO.dSquadVO;
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import Utils.HashMapWrapper;
    import Enums.DIRTY_INDICATOR;
    import Modifier.ModifierVO;
    import Enums.COMBAT_MODIFIER_ATTRIBUTE;
    import flash.events.Event;
    import Modifier.Modifiers.Combat.CombatModifier;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import Enums.MILLITARY_UNIT_SKILLS;
    import mx.events.PropertyChangeEvent;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class cSquad extends dSquadVO implements IEventDispatcher 
    {

        private var _bindingEventDispatcher:EventDispatcher;
        private var _2088099370mHealthBar:Number = 1;
        private var casualties:int;
        public var dirtyIndicator:int;
        public var mCombatModifiers:HashMapWrapper = new HashMapWrapper();

        public function cSquad(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean)
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            init(_arg_1, _arg_2, _arg_3);
            if (_arg_4)
            {
                this.dirtyIndicator = (this.dirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
        }

        public static function SortByUniqueId(_arg_1:cSquad, _arg_2:cSquad):int
        {
            return ((_arg_2.GetUnitBase().GetUniqueId() > _arg_1.GetUnitBase().GetUniqueId()) ? -1 : 1);
        }

        public static function SortByCombatPriorityUnitqueIdDesc(_arg_1:cSquad, _arg_2:cSquad):int
        {
            var _local_3:int = (_arg_2.GetUnitBase().GetCombatPriority() - _arg_1.GetUnitBase().GetCombatPriority());
            if (_local_3 == 0)
            {
                _local_3 = ((_arg_2.GetUnitBase().GetUniqueId() > _arg_1.GetUnitBase().GetUniqueId()) ? 1 : -1);
            };
            return (_local_3);
        }

        public static function SortByCombatPriority(_arg_1:cSquad, _arg_2:cSquad):int
        {
            return (cMilitaryUnitBase.SortByCombatPriority(_arg_1.GetUnitBase(), _arg_2.GetUnitBase()));
        }

        public static function SortByCombatPriorityDesc(_arg_1:cSquad, _arg_2:cSquad):int
        {
            return (_arg_2.GetUnitBase().GetCombatPriority() - _arg_1.GetUnitBase().GetCombatPriority());
        }


        public function GetHitPoints():int
        {
            var _local_3:ModifierVO;
            var _local_1:int = GetUnitBase().GetHitPoints();
            var _local_2:int = GetUnitBase().GetHitPoints();
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.UNIT_HP)))
            {
                for each (_local_3 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.UNIT_HP)))
                {
                    if (_local_3.adder > 0)
                    {
                        _local_2 = (_local_2 + _local_3.adder);
                    };
                };
                for each (_local_3 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.UNIT_HP)))
                {
                    if (_local_3.multiplier != 1)
                    {
                        _local_2 = (_local_2 + (int((_local_1 * _local_3.multiplier)) - _local_1));
                    };
                };
            };
            return (Math.max(1, _local_2));
        }

        public function GetHealthBar():Number
        {
            return (this.mHealthBar);
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function AddApplicableCombatModifiers(_arg_1:Vector.<ModifierVO>):void
        {
            var _local_2:ModifierVO;
            if (IsCombat3())
            {
                return;
            };
            for each (_local_2 in _arg_1)
            {
                if (CombatModifier.combatModifierAppliesToSide(_local_2, GetUnitDescription()))
                {
                    if (CombatModifier.combatModifierTypeAppliesToUnit(_local_2, GetUnitDescription()))
                    {
                        this.getModifierList_vector(_local_2.item_string).push(_local_2);
                    };
                };
            };
            if (currentHitPoints > 0)
            {
                currentHitPoints = this.GetHitPoints();
            };
        }

        public function SetAmount(_arg_1:int):void
        {
            amount = _arg_1;
            this.dirtyIndicator = (this.dirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function GetHitDamage(_arg_1:cGeneralInterface):int
        {
            var _local_2:ModifierVO;
            var _local_3:int = GetUnitDescription().GetHitDamage();
            var _local_4:int = _local_3;
            if (((!(_arg_1.IsAdventureZone())) && (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MAX_ATTACK_DAMAGE_HOMEZONE)))))
            {
                for each (_local_2 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MAX_ATTACK_DAMAGE_HOMEZONE)))
                {
                    if (GetUnitDescription().GetIsElite())
                    {
                        _local_3 = int((_local_3 + int((_local_2.adder / 2))));
                    }
                    else
                    {
                        _local_3 = (_local_3 + _local_2.adder);
                    };
                };
            };
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MAX_ATTACK_DAMAGE)))
            {
                for each (_local_2 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MAX_ATTACK_DAMAGE)))
                {
                    _local_3 = (_local_3 + _local_2.adder);
                };
            };
            if (((!(_arg_1.IsAdventureZone())) && (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MAX_ATTACK_DAMAGE_HOMEZONE)))))
            {
                for each (_local_2 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MAX_ATTACK_DAMAGE_HOMEZONE)))
                {
                    if (GetUnitDescription().GetIsElite())
                    {
                        _local_3 = CombatModifier.applyDamageMultiplier(_local_4, _local_3, (((_local_2.multiplier - 1) * 0.5) + 1));
                    }
                    else
                    {
                        _local_3 = CombatModifier.applyDamageMultiplier(_local_4, _local_3, _local_2.multiplier);
                    };
                };
            };
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MAX_ATTACK_DAMAGE)))
            {
                for each (_local_2 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MAX_ATTACK_DAMAGE)))
                {
                    _local_3 = CombatModifier.applyDamageMultiplier(_local_4, _local_3, _local_2.multiplier);
                };
            };
            return (Math.max(0, _local_3));
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function Heal(_arg_1:int):void
        {
            currentHitPoints = Math.min((currentHitPoints + _arg_1), this.GetHitPoints());
            this.mHealthBar = Math.min((currentHitPoints / this.GetHitPoints()), 1);
            this.dirtyIndicator = (this.dirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function HasSplashDamage(_arg_1:Boolean):Boolean
        {
            var _local_3:ModifierVO;
            var _local_2:Boolean;
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.ADD_SPLASH)))
            {
                for each (_local_3 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.ADD_SPLASH)))
                {
                    _local_2 = ((_arg_1) ? true : (Math.random() <= _local_3.chance));
                    if (_local_2) break;
                };
            };
            return ((_local_2) || (!(GetUnitDescription().GetSkill(MILLITARY_UNIT_SKILLS.SPLASH_DAMAGE) == null)));
        }

        private function AddCasualty():void
        {
            this.casualties++;
            if (this.GetLivingUnits() > 0)
            {
                currentHitPoints = this.GetHitPoints();
            };
            this.dirtyIndicator = (this.dirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function HasDoubleAttack():Boolean
        {
            return (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.DOUBLE_ATTACK)));
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

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function GetSkills(_arg_1:Boolean=false):Vector.<cMilitaryUnitSkill>
        {
            var _local_4:cMilitaryUnitSkill;
            var _local_6:cMilitaryUnitSkill;
            var _local_2:Vector.<cMilitaryUnitSkill> = GetUnitDescription().GetSkills();
            var _local_3:Array = new Array();
            for each (_local_4 in _local_2)
            {
                _local_3[_local_4.GetType()] = _local_4;
            };
            _local_3[MILLITARY_UNIT_SKILLS.SPLASH_DAMAGE] = ((this.HasSplashDamage(_arg_1)) ? new cMilitaryUnitSkill(MILLITARY_UNIT_SKILLS.SPLASH_DAMAGE, 0) : null);
            _local_3[MILLITARY_UNIT_SKILLS.ATTACK_WEAKEST_TARGET] = ((this.HasFlanking()) ? new cMilitaryUnitSkill(MILLITARY_UNIT_SKILLS.ATTACK_WEAKEST_TARGET, 0) : null);
            var _local_5:Vector.<cMilitaryUnitSkill> = new Vector.<cMilitaryUnitSkill>();
            for each (_local_6 in _local_3)
            {
                if (_local_6 != null)
                {
                    _local_5.push(_local_6);
                };
            };
            return (_local_5);
        }

        public function GetBuildingDamage(_arg_1:cGeneralInterface):int
        {
            var _local_2:cMilitaryUnitDescription = GetUnitDescription();
            var _local_3:int = this.GetHitDamage(_arg_1);
            var _local_4:cMilitaryUnitSkill = _local_2.GetSkill(MILLITARY_UNIT_SKILLS.BONUS_DAMAGE_BUILDINGS);
            if (_local_4 != null)
            {
                _local_3 = int((_local_3 + ((_local_3 * _local_4.GetData()) / 100)));
            };
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.DOUBLE_ATTACK)))
            {
                _local_3 = (_local_3 + _local_3);
            };
            return (Math.max(0, _local_3));
        }

        public function DecAmount(_arg_1:int):void
        {
            if (_arg_1 != 0)
            {
                amount = Math.max(0, (amount - _arg_1));
                this.dirtyIndicator = (this.dirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        public function GetMissDamage(_arg_1:cGeneralInterface):int
        {
            var _local_2:ModifierVO;
            var _local_3:int = GetUnitDescription().GetMissDamage();
            var _local_4:int = _local_3;
            if (((!(_arg_1.IsAdventureZone())) && (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MIN_ATTACK_DAMAGE_HOMEZONE)))))
            {
                for each (_local_2 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MIN_ATTACK_DAMAGE_HOMEZONE)))
                {
                    if (GetUnitDescription().GetIsElite())
                    {
                        _local_3 = int((_local_3 + int((_local_2.adder / 2))));
                    }
                    else
                    {
                        _local_3 = (_local_3 + _local_2.adder);
                    };
                };
            };
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MIN_ATTACK_DAMAGE)))
            {
                for each (_local_2 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MIN_ATTACK_DAMAGE)))
                {
                    _local_3 = (_local_3 + _local_2.adder);
                };
            };
            if (((!(_arg_1.IsAdventureZone())) && (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MIN_ATTACK_DAMAGE_HOMEZONE)))))
            {
                for each (_local_2 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MIN_ATTACK_DAMAGE_HOMEZONE)))
                {
                    if (GetUnitDescription().GetIsElite())
                    {
                        _local_3 = CombatModifier.applyDamageMultiplier(_local_4, _local_3, (((_local_2.multiplier - 1) * 0.5) + 1));
                    }
                    else
                    {
                        _local_3 = CombatModifier.applyDamageMultiplier(_local_4, _local_3, _local_2.multiplier);
                    };
                };
            };
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MIN_ATTACK_DAMAGE)))
            {
                for each (_local_2 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.MIN_ATTACK_DAMAGE)))
                {
                    _local_3 = CombatModifier.applyDamageMultiplier(_local_4, _local_3, _local_2.multiplier);
                };
            };
            return (Math.max(0, _local_3));
        }

        public function applyCasualties():Boolean
        {
            amount = (amount - this.casualties);
            this.casualties = 0;
            return (amount <= 0);
        }

        public function GetCasualties():int
        {
            return (this.casualties);
        }

        public function GetUnitDamage(_arg_1:cGeneralInterface):int
        {
            var _local_8:ModifierVO;
            var _local_2:int;
            var _local_3:int = gMisc.GetRandomMinMaxInt(1, 100);
            var _local_4:cMilitaryUnitDescription = GetUnitDescription();
            var _local_5:int = this.GetHitPercentage(_arg_1);
            if (_local_3 <= _local_5)
            {
                _local_2 = this.GetHitDamage(_arg_1);
            }
            else
            {
                _local_2 = this.GetMissDamage(_arg_1);
            };
            var _local_6:int = _local_2;
            var _local_7:cMilitaryUnitSkill = _local_4.GetSkill(MILLITARY_UNIT_SKILLS.BONUS_DAMAGE_UNITS);
            if (_local_7 != null)
            {
                _local_2 = int((_local_2 + ((_local_6 * _local_7.GetData()) / 100)));
            };
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.TOTAL_DAMAGE)))
            {
                for each (_local_8 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.TOTAL_DAMAGE)))
                {
                    if (_local_8.adder > 0)
                    {
                        _local_2 = (_local_2 + _local_8.adder);
                    };
                };
            };
            if (((this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.TOTAL_DAMAGE_ON_HOMEZONE))) && (_arg_1.isOnHomzone())))
            {
                for each (_local_8 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.TOTAL_DAMAGE_ON_HOMEZONE)))
                {
                    if (_local_8.adder > 0)
                    {
                        _local_2 = int((_local_2 + (_local_8.adder / ((GetUnitDescription().GetIsElite()) ? 2 : 1))));
                    };
                };
            };
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.TOTAL_DAMAGE)))
            {
                for each (_local_8 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.TOTAL_DAMAGE)))
                {
                    if (_local_8.multiplier != 1)
                    {
                        _local_2 = CombatModifier.applyDamageMultiplier(_local_6, _local_2, _local_8.multiplier);
                    };
                };
            };
            if (((this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.TOTAL_DAMAGE_ON_HOMEZONE))) && (_arg_1.isOnHomzone())))
            {
                for each (_local_8 in this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.TOTAL_DAMAGE_ON_HOMEZONE)))
                {
                    if (_local_8.multiplier != 1)
                    {
                        if (GetUnitDescription().GetIsElite())
                        {
                            _local_2 = CombatModifier.applyDamageMultiplier(_local_6, _local_2, (((_local_8.multiplier - 1) * 0.5) + 1));
                        }
                        else
                        {
                            _local_2 = CombatModifier.applyDamageMultiplier(_local_6, _local_2, _local_8.multiplier);
                        };
                    };
                };
            };
            return (Math.max(0, _local_2));
        }

        public function GetTotalHealth():int
        {
            if (this.GetLivingUnits() == 0)
            {
                return (0);
            };
            return (this.GetLivingUnits() * this.GetHitPoints());
        }

        public function HasFlanking():Boolean
        {
            var _local_1:Boolean;
            _local_1 = ((this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.ADD_FLANKING))) || (!(GetUnitDescription().GetSkill(MILLITARY_UNIT_SKILLS.ATTACK_WEAKEST_TARGET) == null)));
            if (((_local_1) && (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.LOSE_FLANKING)))))
            {
                _local_1 = false;
            };
            return (_local_1);
        }

        public function toString():String
        {
            return (((((("<Squad type='" + GetType()) + "' amount='") + GetAmount()) + "' currentHitPoints='") + GetCurrentHitPoints()) + "' />");
        }

        public function AddUnits(_arg_1:int, _arg_2:Boolean):void
        {
            amount = (amount + _arg_1);
            if (_arg_2)
            {
                this.dirtyIndicator = (this.dirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        public function GetLivingUnits():int
        {
            return (amount - this.casualties);
        }

        [Bindable(event="propertyChange")]
        private function get mHealthBar():Number
        {
            return (this._2088099370mHealthBar);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function getModifierList_vector(_arg_1:String):Vector.<ModifierVO>
        {
            var _local_2:Vector.<ModifierVO> = (this.mCombatModifiers.getItem(_arg_1) as Vector.<ModifierVO>);
            if (_local_2 == null)
            {
                _local_2 = new Vector.<ModifierVO>();
                this.mCombatModifiers.putItem(_arg_1, _local_2);
            };
            return (_local_2);
        }

        public function GetHitPercentage(_arg_1:cGeneralInterface):int
        {
            var _local_3:Vector.<ModifierVO>;
            var _local_4:ModifierVO;
            var _local_2:int = GetUnitDescription().GetHitPercentage();
            if (this.mCombatModifiers.hasKey(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.ACCURACY)))
            {
                _local_3 = this.getModifierList_vector(COMBAT_MODIFIER_ATTRIBUTE.toString(COMBAT_MODIFIER_ATTRIBUTE.ACCURACY));
                for each (_local_4 in _local_3)
                {
                    if (_local_4.rules_string != "replace")
                    {
                        _local_2 = (_local_2 + _local_4.adder);
                    };
                };
                for each (_local_4 in _local_3)
                {
                    if (_local_4.rules_string != "replace")
                    {
                        _local_2 = (_local_2 * _local_4.multiplier);
                    };
                };
                for each (_local_4 in _local_3)
                {
                    if (_local_4.rules_string == "replace")
                    {
                        _local_2 = _local_4.value;
                    };
                };
            };
            return (Math.min(100, Math.max(0, _local_2)));
        }

        public function CreateSquadVO():dSquadVO
        {
            return (new dSquadVO().init(GetType(), GetAmount(), GetCurrentHitPoints()));
        }


    }
}
