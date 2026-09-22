package Utils
{
    import Communication.VO.EffectVO;
    import Effects.Effects.FulfillCondition;
    import Communication.VO.ExpeditionMapLevelGroupResourceRewardVO;
    import Communication.VO.ExpeditionDifficultyDataVO;
    import ServerState.dResource;
    import AdventureSystem.cAdventureDefinition;
    import Interface.cGeneralInterface;
    import GUI.Components.data.dPvPLevelUnlockData;
    import mx.collections.ArrayCollection;

    public class PVPUtil 
    {


        public static function getColonyTier(_arg_1:int):int
        {
            return (((_arg_1 - 10) % 3) + 1);
        }

        public static function GetActiveColonyYieldBonusForPvPLevel(_arg_1:int):int
        {
            var _local_3:EffectVO;
            var _local_2:int = (_arg_1 - 1);
            while (_local_2 >= 0)
            {
                for each (_local_3 in global.playerPvPLevelEffects_vector[_local_2])
                {
                    if (_local_3.effect_string == FulfillCondition.XML_string)
                    {
                        if (_local_3.name_string == "ColonyYieldBonus")
                        {
                            return (_local_3.amount);
                        };
                    };
                };
                _local_2--;
            };
            return (0);
        }

        public static function calculateColonyYield(_arg_1:cGeneralInterface, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:String, _arg_6:Number, _arg_7:Number, _arg_8:Number):dResource
        {
            var _local_12:ExpeditionMapLevelGroupResourceRewardVO;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:ExpeditionDifficultyDataVO;
            var _local_19:Number;
            var _local_20:Number;
            var _local_21:int;
            var _local_9:dResource = new dResource();
            var _local_10:Number = Math.max(_arg_8, _arg_7);
            var _local_11:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_5);
            if (_local_11 != null)
            {
                _local_12 = global.expeditionMapLevelGroupVO.GetExpeditionMapLevelGroupDataVO(_local_11.GetLevelRangeExpedition()).GetResourceReward(_arg_3);
                if (_local_12 != null)
                {
                    _local_13 = Math.min(_arg_6, (_arg_8 + (_local_12.GetDuration() * 1000)));
                    _local_14 = ((_local_13 - _local_10) / 1000);
                    if (_local_14 > 0)
                    {
                        _local_15 = 1;
                        _local_16 = 1;
                        _local_17 = 1;
                        _local_18 = global.expeditionDifficultyVO.GetDifficultyData(_local_11.GetDifficulty());
                        _local_15 = (_local_15 + (_local_18.GetRewardAmountAdjustmentPercent() / 100));
                        _local_17 = (_local_17 + (_arg_1.mCurrentPlayer.GetColonyYieldBonus() / 100));
                        if (_local_11.IsPvP())
                        {
                            if (_arg_2)
                            {
                                _local_16 = (_local_16 + (global.expeditionMapLevelGroupVO.pvpRewardAmountAdjustmentModifierNPCOwned / 100));
                            }
                            else
                            {
                                _local_16 = (_local_16 + (global.expeditionMapLevelGroupVO.pvpRewardAmountAdjustmentModifierPlayerOwned / 100));
                            };
                        };
                        _local_19 = (((((_local_14 * _local_12.GetAmount()) / _local_12.GetDuration()) * _local_15) * _local_16) * _local_17);
                        _local_20 = ((((_local_14 * _local_12.GetAmount()) / _local_12.GetDuration()) * _local_15) * _local_16);
                        _local_21 = int(Math.round(_local_19));
                        _local_9.name_string = _local_12.GetResourceName();
                        _local_9.amount = _local_21;
                        _local_9.producedAmount = int(_local_20);
                        _local_9.maxLimit = _local_12.GetDuration();
                    };
                };
            };
            return (_local_9);
        }

        public static function GetPvPRewardsForLevelInQuestListFormat(_arg_1:int):ArrayCollection
        {
            var _local_3:EffectVO;
            var _local_4:dPvPLevelUnlockData;
            var _local_2:ArrayCollection = new ArrayCollection();
            if (_arg_1 > global.playerPvPLevelEffects_vector.length)
            {
                throw (new Error("Invalid PvP level passed to PvPUtil.GetPvPRewardsForLevelInQuestListFormat"));
            };
            for each (_local_3 in global.playerPvPLevelEffects_vector[(_arg_1 - 1)])
            {
                if (_local_3.effect_string == FulfillCondition.XML_string)
                {
                    _local_4 = new dPvPLevelUnlockData();
                    _local_4.effectName = _local_3.name_string;
                    _local_4.effectType = _local_3.type_string;
                    _local_4.level = _local_3.index;
                    _local_4.enabled = true;
                    _local_4.value = _local_3.amount;
                    _local_2.addItem(_local_4);
                }
                else
                {
                    _local_2.addItem(_local_3);
                };
            };
            return (_local_2);
        }

        public static function getColonyTierFromAdventureName(_arg_1:String):int
        {
            return (getColonyTier(int(_arg_1.split("_")[1])));
        }


    }
}
