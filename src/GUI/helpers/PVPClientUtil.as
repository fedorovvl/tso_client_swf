package GUI.helpers
{
    import ServerState.dResource;
    import Utils.PVPUtil;
    import Interface.cGeneralInterface;
    import Communication.VO.ColonyVO;
    import AdventureSystem.cAdventureDefinition;

    public class PVPClientUtil 
    {


        public static function getNextColonyYield(_arg_1:cGeneralInterface, _arg_2:ColonyVO, _arg_3:Number):dResource
        {
            if (((!(_arg_2)) || (_arg_2.colonyYieldStartTime == 0)))
            {
                return (new dResource());
            };
            return (PVPUtil.calculateColonyYield(_arg_1, _arg_2.IsFromMapPool(), _arg_2.rewardId, _arg_2.mapLevel, _arg_2.adventureName, (_arg_1.lastColonyYieldCalculationTime + (global.colonyYieldTickTime * 1000)), _arg_1.lastColonyYieldCalculationTime, _arg_2.colonyYieldStartTime));
        }

        public static function getColonyYieldPerTick(_arg_1:int, _arg_2:cAdventureDefinition, _arg_3:Boolean):dResource
        {
            if (!_arg_2)
            {
                return (new dResource());
            };
            return (PVPUtil.calculateColonyYield(global.ui, _arg_3, _arg_1, _arg_2.GetLevelRangeExpedition(), _arg_2.GetName(), (global.colonyYieldTickTime * 1000), 0, 0));
        }


    }
}
