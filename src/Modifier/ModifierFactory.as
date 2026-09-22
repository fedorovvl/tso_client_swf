package Modifier
{
    import Modifier.Modifier;
    import flash.utils.getDefinitionByName;
    import flash.utils.Dictionary;
    import Interface.cGeneralInterface;
    import Modifier.Modifiers.Common.SearchTime;
    import Modifier.Modifiers.AdventureSearch.SearchCost;
    import Modifier.Modifiers.SearchDeposit.DepositCapacity;
    import Modifier.Modifiers.Common.ModifierEffect;
    import Modifier.Modifiers.SearchDeposit.FailoverGroupID;
    import Modifier.Modifiers.Deposit.SpeedUp;
    import Modifier.Modifiers.Common.AddLoot;
    import Modifier.Modifiers.Common.ChangeLoot;
    import Modifier.Modifiers.Common.RemoveLoot;
    import Modifier.Modifiers.Common.ChangeLootPrio;
    import Modifier.Modifiers.Common.ChangeLootChance;
    import Modifier.Modifiers.Common.ChangeLootCount;
    import Modifier.Modifiers.Common.ChangeLoottableRolls;
    import Modifier.Modifiers.Productions.ProductionTimes;
    import Modifier.Modifiers.Productions.ResourceProductionSpeedUp;
    import Modifier.Modifiers.Common.UnlockTask;
    import Modifier.Modifiers.Common.MoveCost;
    import Modifier.Modifiers.Common.SpeedUpSettler;
    import Modifier.Modifiers.Common.SpeedUpSettlerNotAttacking;
    import Modifier.Modifiers.Common.FindDeposit;
    import Modifier.Modifiers.Combat.CombatModifier;
    import Modifier.Modifiers.Productions.ProductionFinishCost;
    import Modifier.Modifiers.Productions.CollectionBuyFinishCost;
    import Modifier.Modifiers.Skins.SkinModifier;
    import Modifier.Modifiers.Common.GeneralRecoverySpeed;
    import Modifier.Modifiers.Combat.CombatRoundDuration;
    import Modifier.Modifiers.Combat.UnitCapacity;
    import Modifier.Modifiers.Common.ChangeLootXP;
    import Modifier.Modifiers.Common.ZoneTravelSpeed;
    import nLib.cLog;
    import nLib.gMisc;

    public final class ModifierFactory 
    {

        private static var map:Dictionary = initClasses();

        private var gi:cGeneralInterface;

        public function ModifierFactory(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
        }

        private static function initClasses():Dictionary
        {
            var map:Dictionary = new Dictionary();
            try
            {
                map[SearchTime.xml_string] = SearchTime;
                map[SearchCost.xml_string] = SearchCost;
                map[DepositCapacity.xml_string] = DepositCapacity;
                map[ModifierEffect.xml_string] = ModifierEffect;
                map[FailoverGroupID.xml_string] = FailoverGroupID;
                map[SpeedUp.xml_string] = SpeedUp;
                map[AddLoot.xml_string] = AddLoot;
                map[ChangeLoot.xml_string] = ChangeLoot;
                map[RemoveLoot.xml_string] = RemoveLoot;
                map[ChangeLootPrio.xml_string] = ChangeLootPrio;
                map[ChangeLootChance.xml_string] = ChangeLootChance;
                map[ChangeLootCount.xml_string] = ChangeLootCount;
                map[ChangeLoottableRolls.xml_string] = ChangeLoottableRolls;
                map[ProductionTimes.xml_string] = ProductionTimes;
                map[ResourceProductionSpeedUp.xml_string] = ResourceProductionSpeedUp;
                map[UnlockTask.xml_string] = UnlockTask;
                map[MoveCost.xml_string] = MoveCost;
                map[SpeedUpSettler.xml_string] = SpeedUpSettler;
                map[SpeedUpSettlerNotAttacking.xml_string] = SpeedUpSettlerNotAttacking;
                map[FindDeposit.xml_string] = FindDeposit;
                map[CombatModifier.xml_string] = CombatModifier;
                map[ProductionFinishCost.xml_string] = ProductionFinishCost;
                map[CollectionBuyFinishCost.xml_string] = CollectionBuyFinishCost;
                map[SkinModifier.xml_string] = SkinModifier;
                map[GeneralRecoverySpeed.xml_string] = GeneralRecoverySpeed;
                map[CombatRoundDuration.xml_string] = CombatRoundDuration;
                map[UnitCapacity.xml_string] = UnitCapacity;
                map[ChangeLootXP.xml_string] = ChangeLootXP;
                map[ZoneTravelSpeed.xml_string] = ZoneTravelSpeed;
            }
            catch(e:Error)
            {
                cLog.error(("Unknown Modifier Class init failed : " + e));
                gMisc.Assert(false, ("Unknown Modifier Class init failed : " + e));
            };
            return (map);
        }


        public function create(_arg_1:ModifierVO):Modifier
        {
            var _local_2:Modifier;
            var _local_3:String = _arg_1.modifier_string.toLowerCase();
            var _local_4:Class = Class(map[_local_3]);
            if (_local_4 != null)
            {
                _local_2 = new (_local_4)();
            }
            else
            {
                cLog.error(("Unknown Modifier action : " + _arg_1.modifier_string));
                gMisc.Assert(false, ("Unknown Modifier Class : " + _arg_1.modifier_string));
                _local_4 = getDefinitionByName("Modifier.Modifier") as Class;
                _local_2 = new _local_4();
            };
            _local_2.init(_arg_1, this.gi);
            return (_local_2);
        }


    }
}
