package Communication.VO
{
    import mx.collections.ArrayCollection;
    import ServerState.dResource;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ExpeditionMapLevelGroupVO 
    {

        public var expeditionMapLevelGroupData:ArrayCollection = new ArrayCollection();
        public var pvpRewardAmountAdjustmentModifierPlayerOwned:int;
        public var pvpRewardAmountAdjustmentModifierNPCOwned:int;


        public static function Create(_arg_1:int, _arg_2:int):ExpeditionMapLevelGroupVO
        {
            var _local_3:ExpeditionMapLevelGroupVO = new (ExpeditionMapLevelGroupVO)();
            _local_3.pvpRewardAmountAdjustmentModifierNPCOwned = _arg_1;
            _local_3.pvpRewardAmountAdjustmentModifierPlayerOwned = _arg_2;
            return (_local_3);
        }


        public function GetExpeditionCreationCost(_arg_1:int):Vector.<dResource>
        {
            var _local_4:ExpeditionMapLevelGroupCostVO;
            var _local_5:dResource;
            var _local_2:Vector.<dResource> = new Vector.<dResource>();
            var _local_3:ExpeditionMapLevelGroupDataVO = this.GetExpeditionMapLevelGroupDataVO(_arg_1);
            for each (_local_4 in _local_3.mapStartCost)
            {
                _local_5 = new dResource();
                _local_5.name_string = _local_4.resourceType;
                _local_5.amount = _local_4.amount;
                _local_2.push(_local_5);
            };
            return (_local_2);
        }

        public function GetTacticPointsLimit(_arg_1:int):int
        {
            var _local_2:int = -1;
            var _local_3:ExpeditionMapLevelGroupDataVO = this.GetExpeditionMapLevelGroupDataVO(_arg_1);
            if (_local_3 != null)
            {
                _local_2 = _local_3.tacticPointLimit;
            };
            return (_local_2);
        }

        public function toString():String
        {
            return ("<ExpeditionMapLevelGroupVO />");
        }

        public function GetGeneralsLimit(_arg_1:int):int
        {
            var _local_2:int = -1;
            var _local_3:ExpeditionMapLevelGroupDataVO = this.GetExpeditionMapLevelGroupDataVO(_arg_1);
            if (_local_3 != null)
            {
                _local_2 = _local_3.admiralLimit;
            };
            return (_local_2);
        }

        public function GetExpeditionMapLevelGroupDataVO(_arg_1:int):ExpeditionMapLevelGroupDataVO
        {
            var _local_2:ExpeditionMapLevelGroupDataVO;
            for each (_local_2 in this.expeditionMapLevelGroupData)
            {
                if (_local_2.levelGroup == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function CalcTroopLimit(_arg_1:int, _arg_2:int):int
        {
            var _local_3:ExpeditionMapLevelGroupDataVO = this.GetExpeditionMapLevelGroupDataVO(_arg_1);
            if (_local_3 != null)
            {
                return (_local_3.troopLimit);
            };
            return (-1);
        }


    }
}
