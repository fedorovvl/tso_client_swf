package GUI.GAME
{
    import mx.collections.ArrayCollection;
    import Interface.cGameInterface;
    import GUI.Components.PvPLevelRewardPanel;
    import GUI.Loca.cLocaManager;
    import Utils.PVPUtil;
    import GUI.Assets.gAssetManager;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import mx.core.IChildList;
    import GUI.FloatingItemsManager;
    import mx.containers.HBox;
    import Enums.COMMAND;
    import Communication.VO.dIntegerVO;

    public class cPvPLevelRewardsPanel extends cBasicPanel 
    {

        private var unlockLevel:int = 0;
        private var unlockList:ArrayCollection;
        private var rewardList:ArrayCollection;
        private var mGI:cGameInterface;
        protected var mPanel:PvPLevelRewardPanel;


        public function SetData(_arg_1:int):void
        {
            this.unlockList = new ArrayCollection();
            this.rewardList = new ArrayCollection();
            this.unlockLevel = _arg_1;
            var _local_2:cGameInterface = (global.ui as cGameInterface);
            this.mPanel.rewardLabel.text = cLocaManager.GetInstance().getLabel("YourPvPRewards");
            this.mPanel.rewards.dataProvider = PVPUtil.GetPvPRewardsForLevelInQuestListFormat(this.unlockLevel);
            this.mPanel.btnClaimRewards.visible = true;
            var _local_3:int = int((this.unlockLevel / 10));
            var _local_4:int = (this.unlockLevel % 10);
            this.mPanel.digit2.source = gAssetManager.GetBitmap(("PvPProgressionDigitSmall" + _local_4));
            if (_local_3 == 0)
            {
                this.mPanel.digit1.visible = false;
            }
            else
            {
                this.mPanel.digit1.source = gAssetManager.GetBitmap(("PvPProgressionDigitSmall" + _local_3));
                this.mPanel.digit1.visible = true;
            };
        }

        public function Init(_arg_1:PvPLevelRewardPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        protected function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.btnClaimRewards.addEventListener(MouseEvent.CLICK, this.rewardsToStarHandler);
        }

        override public function ShowSecondaryPanel():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        private function createFloatingLootItems(_arg_1:HBox):void
        {
            var _local_3:int;
            var _local_2:IChildList = _arg_1.rawChildren;
            var _local_4:int = _arg_1.rawChildren.numChildren;
            FloatingItemsManager.flyRewards(this.mPanel.rewards.getRewardFrames());
            _arg_1.removeAllChildren();
        }

        protected function rewardsToStarHandler(_arg_1:MouseEvent):void
        {
            this.mGI.SendServerActionSimple(COMMAND.CLAIM_PVP_LEVEL_REWARDS, new dIntegerVO(this.unlockLevel));
            this.mGI.mCurrentPlayer.SetClaimedPvPLevel(this.unlockLevel);
            this.createFloatingLootItems(this.mPanel.rewards.list);
            globalFlash.gui.mPvPProgressionPanel.Show();
            Hide();
        }


    }
}
