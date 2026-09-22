package GUI.GAME
{
    import flash.filters.BitmapFilter;
    import flash.filters.GlowFilter;
    import GUI.Components.ItemRenderer.AdventDoorRenderer;
    import GUI.Components.AdventWindow;
    import GUI.Loca.cLocaManager;
    import Interface.cGameInterface;
    import GUI.Components.ItemRenderer.AdventRewardRenderer;
    import Enums.LOCA_GROUP;
    import ServerState.cResources;
    import mx.controls.Alert;
    import GUI.Components.CustomAlert;
    import Sound.cSoundManager;
    import mx.events.CloseEvent;
    import mx.events.ListEvent;
    import mx.events.FlexEvent;
    import GUI.Assets.gAssetManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import GUI.Decorator.GUIDecorator;
    import GUI.Effects.gHintManager;
    import Enums.ADVENT_CALENDAR_DOOR_REWARD_TYPE;
    import Communication.VO.dAdventCalendarDoorVO;
    import GUI.DataEvent;

    public final class cAdventWindow extends cBasicPanel 
    {

        private static const SELECTED_GLOW:BitmapFilter = new GlowFilter(11184691, 1, 8, 8);

        private var selectedItem:AdventDoorRenderer;
        private var mPanel:AdventWindow;
        private var chosenRewardID:int;
        private var loca:cLocaManager = cLocaManager.GetInstance();
        private var gi:cGameInterface;
        private var selectedReward:AdventRewardRenderer;


        private function getDescription(_arg_1:String, _arg_2:*=null):String
        {
            return (this.loca.GetText(LOCA_GROUP.DESCRIPTIONS, _arg_1, _arg_2));
        }

        private function openDoorWithGemsHandler(_arg_1:CloseEvent):void
        {
            var _local_2:cResources;
            if (_arg_1.detail == Alert.OK)
            {
                _local_2 = this.gi.mCurrentPlayerZone.GetResources(this.gi.mCurrentPlayer);
                if (!_local_2.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.selectedItem.vo.openGemCost))
                {
                    CustomAlert.show("NotEnoughGemsToOpenDoor", "NotEnoughGemsToOpenDoor", Alert.OK);
                    return;
                };
                if (this.selectedItem.vo.IsSpecial())
                {
                    if (this.selectedItem.vo.rewards.length > 1)
                    {
                        this.showRewardSelection();
                        return;
                    };
                    this.selectedItem.vo.chosenRewardId = 0;
                };
                this.selectedItem.waiting = true;
                this.gi.mAdventCalendarManager.OpenDoorWithGems(this.selectedItem.vo, this.selectedItem);
                cSoundManager.getInstance().playEffect("BuffPlace");
            };
        }

        protected function rewardChosenHandler(_arg_1:ListEvent):void
        {
            this.mPanel.selectRewardButton.enabled = true;
            this.selectedReward = AdventRewardRenderer(_arg_1.itemRenderer);
            this.selectedItem.vo.chosenRewardId = this.selectedReward.rewardID;
            this.showRewards(this.selectedItem.vo);
        }

        public function init(_arg_1:AdventWindow):void
        {
            this.mPanel = _arg_1;
            AddBaseElement(_arg_1);
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.gi = (global.ui as cGameInterface);
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.headerImage.source = gAssetManager.GetClass((global.adventAssetPrefix + "AdventHeader"));
            this.mPanel.backgroundImage.source = gAssetManager.GetClass((global.adventAssetPrefix + "AdventBackground"));
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.headline.text = this.getLabel(("AdventCalendarHeadline_" + global.adventAssetPrefix));
            this.mPanel.headline.setStyle("top", 12);
            this.mPanel.headline.styleName = "headlineWhite";
            this.mPanel.headlineSubpanel1.text = this.getLabel("AdventCalendarSubhead1");
            this.mPanel.headlineSubpanel2.text = this.getLabel("AdventCalendarSubhead2");
            this.mPanel.featuredItemLbl.text = this.getLabel("AdventCalendarFeaturedItem");
            this.mPanel.rewardSelectionCaption.text = this.getLabel("AdventCalendarSelectReward");
            this.mPanel.rewardSelectionDescription.text = this.getDescription("AdventCalendarSelectReward");
            this.mPanel.rewardCaption.text = this.getLabel("AdventCalendarReward");
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.mPanel.close.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.mPanel.dayList.addEventListener(AdventDoorRenderer.DOOR_SELECTED, this.doorSelected, true);
            this.mPanel.rewardSelectionList.addEventListener(ListEvent.ITEM_CLICK, this.rewardChosenHandler);
            this.mPanel.featuredItemItm.addEventListener(MouseEvent.CLICK, this.featuredItemSelected);
            this.mPanel.selectRewardButton.addEventListener(MouseEvent.CLICK, this.redeemRewardHandler);
            this.mPanel.cancelRewardButton.addEventListener(MouseEvent.CLICK, this.hideRewardHandler);
        }

        public function UpdateGUI():void
        {
            if (this.gi.mAdventCalendarManager.finalReward != null)
            {
                this.mPanel.featuredItemItm.data = this.gi.mAdventCalendarManager.finalReward;
            };
            this.mPanel.dayList.dataProvider = this.gi.mAdventCalendarManager.calendarDoors;
        }

        private function resizeModal(_arg_1:Event):void
        {
            this.mPanel.rewardSelectionModal.width = this.mPanel.stage.width;
            this.mPanel.rewardSelectionModal.height = this.mPanel.stage.height;
        }

        private function redeemRewardHandler(_arg_1:MouseEvent):void
        {
            if (this.selectedItem.vo.chosenRewardId > -1)
            {
                CustomAlert.show("ConfirmRewardSelection", "ConfirmRewardSelection", (Alert.OK | Alert.CANCEL), null, this.selectRewardHandler);
            }
            else
            {
                this.hideRewardSelection(null);
            };
        }

        private function showRewardSelection():void
        {
            var _local_1:Object;
            this.resizeModal(null);
            this.mPanel.rewardSelectionModal.visible = true;
            this.mPanel.rewardSelectionPanel.visible = true;
            this.mPanel.selectRewardButton.enabled = false;
            for each (_local_1 in this.mPanel.rewardList.dataProvider)
            {
                if (_local_1.choiceDone === true)
                {
                    this.mPanel.selectRewardButton.enabled = true;
                    break;
                };
            };
            this.mPanel.stage.addEventListener(Event.RESIZE, this.resizeModal);
        }

        override public function Show():void
        {
            this.UpdateGUI();
            if (this.selectedItem != null)
            {
                GUIDecorator.removeFilter(this.selectedItem, SELECTED_GLOW);
                this.selectedItem = null;
                this.mPanel.rewardList.dataProvider = null;
            };
            gHintManager.HideCalendarNotification();
            super.Show();
        }

        private function showRewards(_arg_1:dAdventCalendarDoorVO):void
        {
            var _local_2:Array = [];
            if (this.selectedReward != null)
            {
                GUIDecorator.removeFilter(this.selectedReward, AdventRewardRenderer.HIGHLIGHT);
            };
            var _local_3:* = (_arg_1.chosenRewardId >= 0);
            var _local_4:int;
            while (_local_4 < _arg_1.rewards.length)
            {
                if (_arg_1.rewardType == ADVENT_CALENDAR_DOOR_REWARD_TYPE.SHOW_FIRST)
                {
                    _local_2.push({
                        "reward":this.gi.effectFactory.createEffect(_arg_1.rewards[_local_4]),
                        "chosen":(_arg_1.chosenRewardId == _local_4),
                        "choiceDone":_local_3,
                        "id":_local_4
                    });
                    break;
                };
                if (((!(_arg_1.rewardType == ADVENT_CALENDAR_DOOR_REWARD_TYPE.HIDDEN)) || (_arg_1.chosenRewardId == _local_4)))
                {
                    _local_2.push({
                        "reward":this.gi.effectFactory.createEffect(_arg_1.rewards[_local_4]),
                        "chosen":(_arg_1.chosenRewardId == _local_4),
                        "choiceDone":_local_3,
                        "id":_local_4
                    });
                };
                _local_4++;
            };
            this.mPanel.rewardList.dataProvider = _local_2;
            this.mPanel.rewardSelectionList.dataProvider = _local_2;
        }

        public function ResetDoorWaiting(_arg_1:dAdventCalendarDoorVO):void
        {
            var _local_2:AdventDoorRenderer = (this.mPanel.dayList.itemToItemRenderer(_arg_1) as AdventDoorRenderer);
            if (_local_2)
            {
                _local_2.waiting = false;
            };
            if (((_arg_1.IsSpecial()) && (!(this.selectedItem == null))))
            {
                this.showRewards(this.selectedItem.vo);
            };
        }

        protected function doorSelected(_arg_1:DataEvent):void
        {
            var _local_2:cResources;
            if (this.selectedItem != null)
            {
                GUIDecorator.removeFilter(this.selectedItem, SELECTED_GLOW);
            };
            this.selectedItem = AdventDoorRenderer(_arg_1.target);
            GUIDecorator.addFilter(this.selectedItem, SELECTED_GLOW);
            this.showRewards(this.selectedItem.vo);
            this.mPanel.mysteryOverlay.visible = ((this.selectedItem.vo.rewardType == ADVENT_CALENDAR_DOOR_REWARD_TYPE.HIDDEN) && (this.selectedItem.vo.chosenRewardId == -1));
            this.mPanel.rewardList.visible = (!(this.mPanel.mysteryOverlay.visible));
            if (this.gi.mAdventCalendarManager.openable(this.selectedItem.vo))
            {
                if (this.selectedItem.vo.IsSpecial())
                {
                    if (this.selectedItem.vo.rewards.length > 1)
                    {
                        this.showRewardSelection();
                        return;
                    };
                    this.selectedItem.vo.chosenRewardId = 0;
                };
                this.selectedItem.waiting = true;
                this.gi.mAdventCalendarManager.OpenDoor(this.selectedItem.vo, this.selectedItem);
                cSoundManager.getInstance().playEffect("BuffPlace");
            }
            else
            {
                if (this.gi.mAdventCalendarManager.openableWithGems(this.selectedItem.vo))
                {
                    _local_2 = this.gi.mCurrentPlayerZone.GetResources(this.gi.mCurrentPlayer);
                    if (!_local_2.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.selectedItem.vo.openGemCost))
                    {
                        CustomAlert.show("ItemPurchaseSwitchToBuyGems", "", (Alert.OK | Alert.CANCEL), null, this.gi.shopManager.ConfirmAddHardCurrency, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
                        return;
                    };
                    CustomAlert.show("OpenAdventCalendarDoorWithGems", "OpenAdventCalendarDoorWithGems", (Alert.OK | Alert.CANCEL), null, this.openDoorWithGemsHandler);
                };
            };
        }

        private function featuredItemSelected(_arg_1:MouseEvent):void
        {
            this.gi.mAdventCalendarManager.OpenDoor(this.mPanel.featuredItemItm.vo, this.mPanel.featuredItemItm);
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.hideRewardSelection(null);
            Hide();
        }

        private function hideRewardHandler(_arg_1:MouseEvent):void
        {
            this.hideRewardSelection(null);
        }

        private function hideRewardSelection(_arg_1:MouseEvent):void
        {
            this.mPanel.rewardSelectionPanel.visible = false;
            this.mPanel.rewardSelectionModal.visible = false;
            this.mPanel.stage.removeEventListener(Event.RESIZE, this.resizeModal);
        }

        private function getLabel(_arg_1:String, _arg_2:*=null):String
        {
            return (this.loca.GetText(LOCA_GROUP.LABELS, _arg_1, _arg_2));
        }

        private function selectRewardHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                this.selectedItem.waiting = true;
                this.selectedItem.vo.chosenRewardId = this.selectedReward.rewardID;
                if (this.gi.mAdventCalendarManager.openable(this.selectedItem.vo))
                {
                    this.gi.mAdventCalendarManager.OpenDoor(this.selectedItem.vo, this.selectedItem);
                }
                else
                {
                    if (this.gi.mAdventCalendarManager.openableWithGems(this.selectedItem.vo))
                    {
                        this.gi.mAdventCalendarManager.OpenDoorWithGems(this.selectedItem.vo, this.selectedItem);
                    };
                };
                cSoundManager.getInstance().playEffect("BuffPlace");
                this.hideRewardSelection(null);
                this.showRewards(this.selectedItem.vo);
            };
        }


    }
}
