package TimedProduction
{
    import Interface.cGameInterface;
    import Interface.cGeneralInterface;
    import nLib.cLog;
    import Communication.VO.dTimedProductionVO;
    import Communication.VO.EffectVO;
    import __AS3__.vec.Vector;
    import Effects.Effects.ApplyZoneBuff;
    import BuffSystem.cBuffDefinition;
    import BuffSystem.cBuffProductionOrder;
    import Enums.TIMED_PRODUCTION_TYPE;
    import MilitarySystem.cMilitaryUnitProductionOrder;
    import Skill.SkillTimedProductionOrder;
    import Collections.CollectionsTimedProductionOrder;
    import ServerState.cResources;
    import Enums.DIRTY_INDICATOR;

    public class cTimedProductionUtl 
    {

        private var gi:cGameInterface;

        public function cTimedProductionUtl(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = (_arg_1 as cGameInterface);
        }

        public function continueTimedProduction(_arg_1:dTimedProductionVO):void
        {
            var _local_2:cTimedProduction = new cTimedProduction(this.CreateProductionOrderFromVO(_arg_1, false));
            var _local_3:cTimedProductionQueue = this.gi.mCurrentPlayerZone.GetProductionQueue(_arg_1.productionType);
            if (_local_3 == null)
            {
                cLog.error(("Coninue Production failed: No queue found for type: " + _arg_1.productionType));
                return;
            };
            _local_3.SetWaitingForServer(false);
            if (_local_2.GetProductionOrder() != null)
            {
                _local_3.addProduction(_local_2);
            };
        }

        public function cancelAllZoneBuffProductions(_arg_1:int):void
        {
            var _local_3:iTimedProductionDefinition;
            var _local_4:EffectVO;
            var _local_2:Vector.<iTimedProductionDefinition> = global.timedProductions_vector[_arg_1];
            for each (_local_3 in _local_2)
            {
                if (!(_local_3 is EffectTimedProductionDefinition))
                {
                    return;
                };
                for each (_local_4 in (_local_3 as EffectTimedProductionDefinition).effects_vector)
                {
                    if (_local_4.effect_string == ApplyZoneBuff.XML_string)
                    {
                        this.gi.mZoneBuffManager.removeBuff(cBuffDefinition.GetByName(_local_4.name_string).GetId(), 0);
                    };
                };
            };
        }

        private function CreateProductionOrderFromVO(_arg_1:dTimedProductionVO, _arg_2:Boolean):iProductionOrder
        {
            var _local_3:iProductionOrder;
            if (!this.gi.mRequirements.timedProductionRequirements_vector[_arg_1.type_string].isFulfilledForSkillList(this.gi.mCurrentPlayer.getSkills()))
            {
                cLog.error(((("Cant create Production: Player dont fullfill requirements for" + _arg_1) + " cause: ") + this.gi.mRequirements.timedProductionRequirements_vector[_arg_1.type_string]));
                return (null);
            };
            if (_arg_1.amount > defines.MAX_PRODUCTION_AMOUNT)
            {
                cLog.error(((("Cant create Production: Production Amount higher then allowed." + _arg_1) + " MAX_AMOUNT=") + defines.MAX_PRODUCTION_AMOUNT));
                return (null);
            };
            switch (_arg_1.productionType)
            {
                case TIMED_PRODUCTION_TYPE.BUFF:
                    _local_3 = new cBuffProductionOrder(_arg_1, this.gi, false);
                    break;
                case TIMED_PRODUCTION_TYPE.MILITARY_UNIT:
                case TIMED_PRODUCTION_TYPE.ELITE_UNITS:
                    _local_3 = new cMilitaryUnitProductionOrder(_arg_1, this.gi);
                    break;
                case TIMED_PRODUCTION_TYPE.SKILL:
                    _local_3 = new SkillTimedProductionOrder(_arg_1, this.gi);
                    break;
                case TIMED_PRODUCTION_TYPE.COLLECTIONS:
                    _local_3 = new CollectionsTimedProductionOrder(_arg_1, this.gi);
                    break;
                case TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS:
                    _local_3 = new cBuffProductionOrder(_arg_1, this.gi, true);
                    break;
                case TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS_2:
                    _local_3 = new cBuffProductionOrder(_arg_1, this.gi, true);
                    break;
                case TIMED_PRODUCTION_TYPE.COMBAT_THREE_UNITS:
                    _local_3 = new cMilitaryUnitProductionOrder(_arg_1, this.gi);
                    break;
                default:
                    _local_3 = new EffectTimedProductionOrder(_arg_1, this.gi, true);
                    if (_local_3.GetDefinition() == null)
                    {
                        _local_3 = new cBuffProductionOrder(_arg_1, this.gi, false);
                    };
            };
            if (((_arg_2) && (!(_local_3.IsProduceable(this.gi)))))
            {
                cLog.error(("Cant create Production: Is NOT producable. " + _arg_1));
                return (null);
            };
            if (_local_3.GetBuilding() == null)
            {
                cLog.error(("Cant create Production: Order has NO production building set. " + _arg_1));
                return (null);
            };
            return (_local_3);
        }

        public function startTimedProduction(_arg_1:dTimedProductionVO):void
        {
            var _local_5:cTimedProduction;
            _arg_1.producedItems = 0;
            _arg_1.collectedTime = 0;
            var _local_2:iProductionOrder = this.CreateProductionOrderFromVO(_arg_1, true);
            if (_local_2 == null)
            {
                cLog.error("Start Production failed: cant create ProductionOrder see error above. ");
                return;
            };
            var _local_3:cTimedProductionQueue = this.gi.mCurrentPlayerZone.GetProductionQueue(_arg_1.productionType);
            if (((_local_3 == null) || ((_local_3.waitForPickup) && (!(_local_3.mTimedProductions_vector.length == 0)))))
            {
                cLog.error(("Start Production failed: Queue not found or already producing. " + _local_3));
                return;
            };
            var _local_4:cResources = this.gi.mCurrentPlayerZone.GetResources(this.gi.mCurrentPlayer);
            if (_local_2.CanAfford(_local_4))
            {
                _local_2.Pay(_local_4);
                _local_5 = new cTimedProduction(_local_2);
                _local_5.mDirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
                _local_3.SetWaitingForServer(false);
                _local_3.addProduction(_local_5);
            };
        }


    }
}
