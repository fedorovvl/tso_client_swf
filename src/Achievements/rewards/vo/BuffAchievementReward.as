package Achievements.rewards.vo
{
    import Achievements.rewards.IAchievementReward;
    import Communication.VO.dBuffVO;
    import BuffSystem.cBuffDefinition;
    import BuffSystem.cBuff;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Interface.cGeneralInterface;
    import Communication.VO.dUniqueID;
    import Achievements.rewards.AchievementRewardFactory;
    import nLib.cXML;

    public class BuffAchievementReward implements IAchievementReward 
    {

        private var name:String;
        private var recurringChance:int;
        private var item:String;
        private var amount:int;


        public function getName():String
        {
            return (this.name);
        }

        public function getItem():String
        {
            return (this.item);
        }

        public function getAmount():int
        {
            return (this.amount);
        }

        public function reward(_arg_1:cGeneralInterface, _arg_2:dUniqueID):void
        {
            var _local_3:dBuffVO = new dBuffVO();
            _local_3.buffName_string = this.item;
            var _local_4:cBuffDefinition = cBuffDefinition.GetByName(this.item);
            if (((!(_local_4 == null)) && (_local_4.GetAmount() > 0)))
            {
                _local_3.amount = this.amount;
            }
            else
            {
                _local_3.amount = 1;
            };
            _local_3.resourceName_string = ((this.name != null) ? this.name : "");
            _local_3.recurringChance = this.recurringChance;
            _local_3.uniqueId1 = _arg_2.uniqueID1;
            _local_3.uniqueId2 = _arg_2.uniqueID2;
            var _local_5:cBuff = cBuff.CreateBuffFromVO(_local_3);
            _arg_1.mCurrentPlayer.addBuff(_local_5);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ACHIEVEMENT_BUFF_RECEIVED, _local_3);
        }

        public function init(_arg_1:cXML):void
        {
            this.item = _arg_1.GetAttributeString_string(AchievementRewardFactory.ATTRIBUTE_ITEM);
            this.name = _arg_1.GetAttributeString_string(AchievementRewardFactory.ATTRIBUTE_NAME);
            this.amount = _arg_1.GetAttributeInt(AchievementRewardFactory.ATTRIBUTE_AMOUNT);
            this.recurringChance = _arg_1.GetAttributeInt(AchievementRewardFactory.ATTRIBUTE_RECURRING_CHANCE);
        }

        public function getRecurringChance():int
        {
            return (this.recurringChance);
        }


    }
}
