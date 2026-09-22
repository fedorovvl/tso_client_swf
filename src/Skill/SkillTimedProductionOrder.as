package Skill
{
    import TimedProduction.EffectTimedProductionOrder;
    import Communication.VO.dTimedProductionVO;
    import Interface.cGeneralInterface;
    import Enums.AVATAR_MESSAGE_TYPE;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import ServerState.cResources;
    import Communication.VO.EffectVO;
    import Effects.Effects.Reward;
    import Tracks.TrackManager;
    import ServerState.cPlayerData;
    import Interface.cGameInterface;

    public final class SkillTimedProductionOrder extends EffectTimedProductionOrder 
    {

        private var usedSkillpointLevel:SkillpointLevelDefinition;
        private var usedSkillpoint:SkillpointDefinition;

        public function SkillTimedProductionOrder(_arg_1:dTimedProductionVO, _arg_2:cGeneralInterface)
        {
            var _local_3:SkillpointDefinition;
            var _local_4:int;
            var _local_5:SkillpointLevelDefinition;
            super(_arg_1, _arg_2, false);
            GetProductionVO().amount = 1;
            for each (_local_3 in global.skillPoints_vector)
            {
                if (GetProductionVO().type_string == _local_3.id_string)
                {
                    this.usedSkillpoint = _local_3;
                    break;
                };
            };
            if (this.usedSkillpoint != null)
            {
                _local_4 = _arg_2.mCurrentPlayerZone.GetResources(_arg_2.mCurrentPlayer).GetPlayerResource(GetProductionVO().type_string).producedAmount;
                this.usedSkillpointLevel = this.usedSkillpoint.levels_vector[0];
                for each (_local_5 in this.usedSkillpoint.levels_vector)
                {
                    if (_local_5.amountProduced > _local_4) break;
                    this.usedSkillpointLevel = _local_5;
                };
            };
        }

        override public function GetOnFinishedAvatarMessageType():String
        {
            return (AVATAR_MESSAGE_TYPE.SKILLPOINT_PICK_UP);
        }

        override public function GetInstantBuildCostsUnmodified():int
        {
            return (this.usedSkillpoint.instantFinishCost);
        }

        override public function GetCostsToBuy_vector():Vector.<dResource>
        {
            return (this.usedSkillpointLevel.costs);
        }

        override public function GetInstantBuildCosts():int
        {
            return (int(((this.usedSkillpoint.instantFinishCost * timedProductionVO.modifiedInstantFinishCostMultiplier) + timedProductionVO.modifiedInstantFinishCostAdder)));
        }

        override public function GetProductionTime():int
        {
            return (this.usedSkillpointLevel.productionTime);
        }

        override public function CreateItem(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):void
        {
            var _local_4:cResources = _arg_2.mCurrentPlayerZone.GetResources(_arg_2.mCurrentPlayer);
            var _local_5:dTimedProductionVO = GetProductionVO();
            var _local_6:EffectVO = new EffectVO();
            _local_6.effect_string = Reward.XML_string;
            _local_6.type_string = "resource";
            _local_6.amount = _local_5.amount;
            _local_6.name_string = _local_5.type_string;
            effectVOs_vector.push(_local_6);
            super.CreateItem(_arg_1, _arg_2, _arg_3);
            _local_4.GetPlayerResource(_local_5.type_string).producedAmount++;
            var _local_7:int = _local_4.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
            TrackManager.getInstance().trackGainSkillPoint(_arg_1, _local_5.type_string, _local_5.amount, null, _local_7);
        }

        override public function IsProduceable(_arg_1:cGameInterface):Boolean
        {
            return (!(this.usedSkillpoint == null));
        }

        override public function GetResourceName():String
        {
            return (this.usedSkillpoint.id_string);
        }


    }
}
