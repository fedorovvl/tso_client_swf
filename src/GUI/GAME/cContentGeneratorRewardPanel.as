package GUI.GAME
{
    import GUI.Loca.cLocaManager;
    import mx.collections.ArrayCollection;
    import Interface.cGameInterface;
    import com.bluebyte.tso.contentgenerator.view.ui.panel.ContentGeneratorRewardPanel;
    import flash.events.MouseEvent;
    import com.bluebyte.tso.contentgenerator.view.ui.component.ContentGeneratorRewardList;
    import mx.containers.HBox;
    import com.bluebyte.tso.contentgenerator.view.ui.itemrenderer.ContentGeneratorRewardItemRenderer;
    import Communication.VO.EffectVO;
    import flash.geom.Point;
    import Sound.cSoundManager;
    import GUI.FloatingItemsManager;
    import flash.events.Event;
    import mx.events.FlexEvent;

    public final class cContentGeneratorRewardPanel extends cBasicPanel 
    {

        private var loca:cLocaManager = cLocaManager.GetInstance();
        private var rewardLists:ArrayCollection;
        private var gi:cGameInterface;
        private var mPanel:ContentGeneratorRewardPanel;
        private var hasJackpot:Boolean = false;


        protected function claimRewardsMouseOutHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.claimRewards.setStyle("styleName", "contentGeneratorCategoryButton");
        }

        protected function claimRewardsClickhandler(_arg_1:MouseEvent):void
        {
            var _local_2:ContentGeneratorRewardList;
            var _local_3:HBox;
            var _local_4:ContentGeneratorRewardItemRenderer;
            var _local_5:EffectVO;
            var _local_6:Point;
            this.mPanel.claimRewards.setStyle("styleName", "contentGeneratorCategoryButtonSelected");
            cSoundManager.getInstance().playEffect("BuffPlace");
            for each (_local_2 in this.rewardLists)
            {
                for each (_local_3 in _local_2.getChildren())
                {
                    for each (_local_4 in _local_3.getChildren())
                    {
                        _local_5 = (_local_4.data as EffectVO);
                        if (_local_5.type_string == "collectionpart")
                        {
                            _local_6 = globalFlash.gui.mContentGeneratorPanel.GetPanelPoint();
                            _local_6.x = (_local_6.x + 640);
                            _local_6.y = (_local_6.y + 340);
                            FloatingItemsManager.createJumpFlyDestroy(_local_4, "GAMESTATE_ID_CONTENT_GENERATOR_PANEL.mainPanel.collectionDescriptionCanvas.completeCollectionButton", _local_6);
                        }
                        else
                        {
                            if (_local_5.name_string != "Crystal")
                            {
                                FloatingItemsManager.jumpOutsideWindow(_local_4, globalFlash.gui.mContentGeneratorPanel.GetPanel());
                            };
                        };
                    };
                    _local_2.removeChild(_local_3);
                };
            };
            this.Hide();
        }

        override public function ShowSecondaryPanel():void
        {
            hideCurrentSecondary();
            mCurrentActiveSecondaryPanel = this;
            mUiElement.visible = true;
            global.ui.mQuestClientCallbacks.InitiateWindowOpen(mUiElement.id);
            notifyPropertyObserver("show", mUiElement.id);
            dispatchEvent(new Event("visibilityChanged"));
            globalFlash.gui.windowController.setTop(mUiElement, true);
            this.mPanel.showEffect.stop();
            this.mPanel.showEffect.play();
            if (this.hasJackpot)
            {
                cSoundManager.getInstance().playEffect(cSoundManager.CG_JACKPOT);
            };
        }

        public function Init(_arg_1:ContentGeneratorRewardPanel):void
        {
            this.mPanel = _arg_1;
            AddBaseElement(_arg_1);
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.gi = (global.ui as cGameInterface);
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.claimRewards.addEventListener(MouseEvent.CLICK, this.claimRewardsClickhandler);
            this.mPanel.claimRewards.addEventListener(MouseEvent.MOUSE_OVER, this.claimRewardsMouseOverHandler);
            this.mPanel.claimRewards.addEventListener(MouseEvent.MOUSE_OUT, this.claimRewardsMouseOutHandler);
        }

        public function SetRewards(_arg_1:ArrayCollection):void
        {
            var _local_4:ArrayCollection;
            var _local_5:ArrayCollection;
            var _local_8:ContentGeneratorRewardList;
            var _local_9:ContentGeneratorRewardList;
            this.mPanel.contentBox.removeAllChildren();
            this.hasJackpot = false;
            this.rewardLists = new ArrayCollection();
            var _local_2:int = _arg_1.length;
            var _local_3:ArrayCollection = new ArrayCollection();
            _local_4 = new ArrayCollection();
            _local_5 = new ArrayCollection();
            var _local_6:int;
            while (_local_6 < _local_2)
            {
                if ((_arg_1.getItemAt(_local_6) as EffectVO).action_string == "isJackpot")
                {
                    this.hasJackpot = true;
                };
                if (_local_6 < 4)
                {
                    _local_3.addItem(_arg_1.getItemAt(_local_6));
                }
                else
                {
                    if (_local_6 < 8)
                    {
                        _local_4.addItem(_arg_1.getItemAt(_local_6));
                    }
                    else
                    {
                        _local_5.addItem(_arg_1.getItemAt(_local_6));
                    };
                };
                _local_6++;
            };
            this.mPanel.height = 324;
            this.mPanel.resizeEffect.heightTo = 324;
            var _local_7:ContentGeneratorRewardList = new ContentGeneratorRewardList();
            _local_7.percentWidth = 100;
            _local_7.height = 133;
            this.mPanel.contentBox.addChild(_local_7);
            _local_7.dataPovider = _local_3;
            this.rewardLists.addItem(_local_7);
            if (_local_2 > 4)
            {
                this.mPanel.height = 450;
                this.mPanel.resizeEffect.heightTo = 450;
                _local_8 = new ContentGeneratorRewardList();
                _local_8.percentWidth = 100;
                _local_8.height = 133;
                this.mPanel.contentBox.addChild(_local_8);
                _local_8.dataPovider = _local_4;
                this.rewardLists.addItem(_local_8);
            };
            if (_local_2 > 8)
            {
                this.mPanel.height = 580;
                this.mPanel.resizeEffect.heightTo = 580;
                _local_9 = new ContentGeneratorRewardList();
                _local_9.percentWidth = 100;
                _local_9.height = 133;
                this.mPanel.contentBox.addChild(_local_9);
                _local_9.dataPovider = _local_5;
            };
        }

        protected function claimRewardsMouseOverHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.claimRewards.setStyle("styleName", "contentGeneratorCategoryButtonMouseOver");
        }

        override public function Hide():void
        {
            super.Hide();
            globalFlash.gui.windowController.closeModal();
            globalFlash.gui.mContentGeneratorPanel.Show();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }


    }
}
