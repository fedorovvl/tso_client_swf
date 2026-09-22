package Achievements.rewards.vo
{
    import Achievements.rewards.IAchievementReward;
    import Achievements.rewards.AchievementRewardFactory;
    import nLib.cXML;
    import ServerState.dResource;
    import ServerState.cPlayerData;
    import ServerState.cResources;
    import Interface.cGameInterface;
    import Enums.ModifyReason;
    import Communication.VO.AddResourceResponseVO;
    import Tracks.TrackManager;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Interface.cGeneralInterface;
    import Communication.VO.dUniqueID;

    public class HardCurrencyAchievementReward implements IAchievementReward 
    {

        private var amount:int;


        public function init(_arg_1:cXML):void
        {
            this.amount = _arg_1.GetAttributeInt(AchievementRewardFactory.ATTRIBUTE_AMOUNT);
        }

        public function getName():String
        {
            return (defines.HARD_CURRENCY_RESOURCE_NAME_string);
        }

        public function getAmount():int
        {
            return (this.amount);
        }

        public function reward(_arg_1:cGeneralInterface, _arg_2:dUniqueID):void
        {
            var _local_3:dResource = new dResource().Init(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.amount);
            var _local_4:cPlayerData = _arg_1.mCurrentPlayer;
            var _local_5:cResources = _arg_1.mCurrentPlayerZone.GetResources(_local_4);
            var _local_6:int = _local_5.GetResourceAmount(defines.HARD_CURRENCY_RESOURCE_NAME_string);
            var _local_7:AddResourceResponseVO = (_arg_1 as cGameInterface).addPlayerResource(_local_3, _local_5, _local_4, _arg_2, ModifyReason.REWARD_ACHIEVEMENT);
            TrackManager.getInstance().trackGemQuestRewarded(_local_4, "Achievement", _local_3.amount, _local_6, "Achievement");
            if (_local_7.getAddedDirectly())
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ACHIEVEMENT_RESOURCE_RECEIVED, _local_3);
            };
        }


    }
}
