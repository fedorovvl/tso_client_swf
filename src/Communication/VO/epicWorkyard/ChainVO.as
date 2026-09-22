package Communication.VO.epicWorkyard
{
    import Communication.VO.dQuestElementVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Utils.StringUtils;
    import Interface.cGeneralInterface;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import Interface.cGameInterface;
    import nLib.gMisc;
    import GO.cGOGroup;
    import GO.cGOSpriteLibContainer;
    import __AS3__.vec.Vector;
    import BuffSystem.cBuffDefinition;

    public class ChainVO 
    {

        private var mRequirementQuest:String;
        private var mRequirementLevel:int;
        private var mUnlockToolTipLoca:String;
        private var productivityInput:Number;
        private var mBuildingName:String;
        private var mRank:int;
        private var productivityOutput:Number;

        public function ChainVO(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:String, _arg_5:String)
        {
            super();
            this.mBuildingName = _arg_1;
            this.mRank = _arg_2;
            this.mRequirementLevel = _arg_3;
            this.mRequirementQuest = _arg_4;
            this.mUnlockToolTipLoca = _arg_5;
            this.productivityInput = -1;
            this.productivityOutput = -1;
        }

        public function getName():String
        {
            return (this.mBuildingName);
        }

        public function getToolTipText(_arg_1:cGeneralInterface):String
        {
            var _local_3:dQuestElementVO;
            var _local_2:* = (cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ConditionsToUnlockChain") + "\n");
            if (!StringUtils.isEmpty(this.mUnlockToolTipLoca))
            {
                _local_2 = (_local_2 + (("- " + cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, this.mUnlockToolTipLoca)) + "\n"));
            }
            else
            {
                if (((this.mRequirementLevel > 0) && (_arg_1.mCurrentPlayer.GetPlayerLevel() < this.mRequirementLevel)))
                {
                    _local_2 = (_local_2 + (((("- " + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TriggerRequiredPlayerLevel")) + " ") + this.mRequirementLevel) + "\n"));
                };
                if (this.mRequirementQuest.length > 0)
                {
                    _local_3 = _arg_1.mNewQuestManager.getQuest(this.mRequirementQuest);
                    if (((!(_local_3 == null)) && (!(_local_3.IsRewardCollected()))))
                    {
                        _local_2 = (_local_2 + (((("- " + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TriggerRequiredCompletedQuest")) + " ") + cLocaManager.GetInstance().GetText(LOCA_GROUP.QUEST_LABELS, this.mRequirementQuest)) + "\n"));
                    };
                };
            };
            return (_local_2);
        }

        public function getChainIsEquivalentToBuilding(_arg_1:EpicWorkyardSubBuilding):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            return ((_arg_1.GetBuildingName_string() == this.mBuildingName) && (this.mRank == _arg_1.GetUpgradeLevel()));
        }

        public function getRank():int
        {
            return (this.mRank);
        }

        public function getIsUnlocked(_arg_1:cGeneralInterface):Boolean
        {
            if (((this.mRequirementLevel > 0) && (_arg_1.mCurrentPlayer.GetPlayerLevel() < this.mRequirementLevel)))
            {
                return (false);
            };
            if (!(_arg_1 as cGameInterface).mRequirements.chainRequirements_vector[((this.mBuildingName + "Rank") + this.mRank)].isFulfilled())
            {
                return (false);
            };
            return (true);
        }

        public function getProductivityOutput():Number
        {
            return (this.productivityOutput);
        }

        public function getRequirementsAvailable(_arg_1:cGeneralInterface):Boolean
        {
            var _local_2:dQuestElementVO;
            if (this.mRequirementLevel > 0)
            {
                return (true);
            };
            if (this.mRequirementQuest.length > 0)
            {
                _local_2 = _arg_1.mNewQuestManager.getQuest(this.mRequirementQuest);
                return (!(_local_2 == null));
            };
            return (true);
        }

        public function getProductivityInput():Number
        {
            return (this.productivityInput);
        }

        public function computeInputOutput():void
        {
            gMisc.Assert(global.buildingGroup.IsSpriteInGroup(this.getName()), ("Building definition of EpicWorkyard subBuilding missing: " + this.getName()));
            if (((this.productivityInput >= 0) && (this.productivityOutput >= 0)))
            {
                return;
            };
            var _local_1:cGOGroup = global.buildingGroup;
            var _local_2:cGOSpriteLibContainer = _local_1.GetSpriteLibContainer(this.mBuildingName);
            var _local_3:Vector.<cBuffDefinition> = _local_2.buildingUpgradeBonuses_vector;
            var _local_4:cBuffDefinition = _local_3[this.mRank];
            this.productivityInput = (_local_4.getProductivityInputPercent() / 100);
            this.productivityOutput = (_local_4.getProductivityOutputPercent() / 100);
        }

        public function getUnlockToolTipLoca_string():String
        {
            return (this.mUnlockToolTipLoca);
        }

        public function getRequirementQuest_string():String
        {
            return (this.mRequirementQuest);
        }


    }
}
