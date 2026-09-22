package GUI.GAME
{
    import Model.Observer;
    import ServerState.cResources;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorDefinitions;
    import mx.collections.ArrayCollection;
    import com.bluebyte.tso.contentgenerator.view.ui.panel.ContentGeneratorPanel;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorContent;
    import __AS3__.vec.Vector;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorCategory;
    import Interface.cGameInterface;
    import converted.bluebyte.tso.contentgenerator.logic.ContentGeneratorManager;
    import GUI.Loca.cLocaManager;
    import flash.utils.Timer;
    import GUI.Assets.gAssetManager;
    import flash.events.TimerEvent;
    import GO.cBuilding;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    import mx.events.VideoEvent;
    import nLib.cFilenameUtil;
    import ServerState.dResource;
    import converted.bluebyte.tso.contentgenerator.logic.CollectionPart;
    import com.bluebyte.tso.contentgenerator.view.ui.component.CGDecrementButton;
    import com.bluebyte.tso.contentgenerator.view.ui.component.CGIncrementButton;
    import GUI.FloatingItemsManager;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import LootTableSystem.cLootTableItemContent;
    import Enums.LOCA_GROUP;
    import Enums.KILL_SWITCH;
    import Sound.cSoundManager;
    import com.bluebyte.tso.util.ClientLogger;
    import Model.Notifier;
    import GUI.Components.CustomAlert;
    import com.bluebyte.tso.contentgenerator.view.ui.itemrenderer.ContentGeneratorRewardItemRenderer;
    import flash.geom.Point;
    import Communication.VO.EffectVO;
    import __AS3__.vec.*;

    public final class cContentGeneratorPanel extends cBasicInfoPanel implements Observer 
    {

        private var isFirstOpen:Boolean = true;
        private var lastRollTimestamp:Number = 0;
        private var resources:cResources;
        private var crystalCost:int = 0;
        private var contentDefinitions:ContentGeneratorDefinitions;
        private var numberOfRolls:int = 0;
        private var contentCategories:ArrayCollection;
        private var isVideoPlaying:Boolean = false;
        private var mPanel:ContentGeneratorPanel;
        private var selectedCollection:ContentGeneratorContent;
        private var _isActionsEnabled:Boolean = true;
        private var lastEnabledItems:Vector.<String>;
        private var selectedCategory:ContentGeneratorCategory;
        private var gemCost:int = 0;
        private var numberOfCollectionParts:int = 0;
        private var gi:cGameInterface;
        public var isWaitingForServer:Boolean = false;
        private var collectionRewardObjects:ArrayCollection;
        private var contentManager:ContentGeneratorManager;

        private var loca:cLocaManager = cLocaManager.GetInstance();
        private var incrementRepeatTimer:Timer = new Timer(200, 0);
        private var decrementRepeatTimer:Timer = new Timer(200, 0);
        private var collectionRewardTimer:Timer = new Timer(1000, 1);
        private var spinButtonTimer:Timer = new Timer(200, 1);
        public var enableActionsDelayTimer:Timer = new Timer(1500, 1);
        private var defaultActionUnlockTimer:Timer = new Timer(30000, 1);


        protected function spinButtonTimerCompleteHandler(_arg_1:TimerEvent):void
        {
            this.mPanel.spinButton.source = gAssetManager.GetClass("congen_button");
        }

        override public function SetData(_arg_1:cBuilding):void
        {
        }

        private function selectCategory(_arg_1:ContentGeneratorCategory):void
        {
            var _local_4:ContentGeneratorContent;
            this.selectedCategory = _arg_1;
            var _local_2:ArrayCollection = new ArrayCollection();
            var _local_3:Boolean = true;
            for each (_local_4 in this.selectedCategory.getCollections())
            {
                if (_local_3)
                {
                    _local_4.selected = true;
                    _local_3 = false;
                };
                _local_2.addItem(_local_4);
            };
            this.mPanel.collectionButtonContainer.dataProvider = _local_2;
            this.selectCollection(this.selectedCategory.getCollections()[0]);
        }

        override public function Show():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
            this.resources = this.gi.mCurrentPlayerZone.GetResources(this.gi.mCurrentPlayer);
            this.updateContentDefinitions();
            if (this.isFirstOpen)
            {
                this.updateLastEnabledItems(true);
                this.isFirstOpen = false;
            };
            this.resetRolls();
        }

        private function addHardCurrencyClick(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mShopWindow.AddHardCurrency(_arg_1);
        }

        protected function spinButtonMouseOverHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.spinButton.source = gAssetManager.GetClass("congen_button_mouseover");
        }

        public function IsGemsRequired():Boolean
        {
            return (this.gemCost > 0);
        }

        public function Init(_arg_1:ContentGeneratorPanel):void
        {
            this.mPanel = _arg_1;
            AddBaseElement(_arg_1);
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.gi = (global.ui as cGameInterface);
            this.contentManager = this.gi.mContentGeneratorManager;
            this.contentDefinitions = ContentGeneratorDefinitions.getInstance();
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.mPanel.btnAddCash.addEventListener(MouseEvent.CLICK, this.addHardCurrencyClick);
            this.mPanel.categoryButtonContainer.addEventListener(ListEvent.ITEM_CLICK, this.contentCategoryClickHandler);
            this.mPanel.collectionButtonContainer.addEventListener(ListEvent.ITEM_CLICK, this.collectionClickHandler);
            this.mPanel.spinButton.addEventListener(MouseEvent.MOUSE_UP, this.spinButtonClickHandler);
            this.mPanel.spinButton.addEventListener(MouseEvent.MOUSE_OVER, this.spinButtonMouseOverHandler);
            this.mPanel.spinButton.addEventListener(MouseEvent.MOUSE_OUT, this.spinButtonMouseOutHandler);
            this.mPanel.completeCollectionButton.addEventListener(MouseEvent.CLICK, this.completeCollectionClickHandler);
            this.mPanel.incrementButton.addEventListener(MouseEvent.MOUSE_DOWN, this.incrementRollsDownHandler);
            this.mPanel.decrementButton.addEventListener(MouseEvent.MOUSE_DOWN, this.decrementRollsDownHandler);
            this.mPanel.incrementButton.addEventListener(MouseEvent.MOUSE_UP, this.incrementRollsUpHandler);
            this.mPanel.decrementButton.addEventListener(MouseEvent.MOUSE_UP, this.decrementRollsUpHandler);
            this.mPanel.incrementButton.addEventListener(MouseEvent.MOUSE_OUT, this.incrementRollsOutHandler);
            this.mPanel.decrementButton.addEventListener(MouseEvent.MOUSE_OUT, this.decrementRollsOutHandler);
            this.enableActionsDelayTimer.addEventListener(TimerEvent.TIMER, this.enabledActionsDelayTimerHandler);
            this.incrementRepeatTimer.addEventListener(TimerEvent.TIMER, this.incrementTimerHandler);
            this.decrementRepeatTimer.addEventListener(TimerEvent.TIMER, this.decrementTimerHandler);
            this.collectionRewardTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.collectionRewardTimerCompleteHandler);
            this.spinButtonTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.spinButtonTimerCompleteHandler);
            this.defaultActionUnlockTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.defaultActionUnlockTimerHandler);
            this.defaultActionUnlockTimer.reset();
            this.defaultActionUnlockTimer.start();
            this.mPanel.ani.addEventListener(VideoEvent.COMPLETE, this.videoCompleteHandler);
            this.mPanel.ani.source = cFilenameUtil.findHashMapping("video/content_generator_roll_animation.mp4");
        }

        public function WasItemEnabled(_arg_1:String):Boolean
        {
            var _local_2:String;
            for each (_local_2 in this.lastEnabledItems)
            {
                if (_arg_1 == _local_2)
                {
                    return (true);
                };
            };
            return (false);
        }

        private function updateCurrentRollCosts(_arg_1:int):void
        {
            var _local_2:Vector.<dResource>;
            var _local_3:dResource;
            this.crystalCost = 0;
            this.gemCost = 0;
            if (((!(this.selectedCategory == null)) && (!(this.selectedCollection == null))))
            {
                _local_2 = this.contentManager.CalculateRollCost(this.selectedCategory.getId(), this.selectedCollection.getId(), this.numberOfRolls);
                for each (_local_3 in _local_2)
                {
                    if (_local_3.name_string == "Crystal")
                    {
                        this.crystalCost = (this.crystalCost + _local_3.getAmount());
                    };
                    if (_local_3.name_string == "HardCurrency")
                    {
                        this.gemCost = (this.gemCost + _local_3.getAmount());
                    };
                };
                this.mPanel.crystalSpinner.SetDesiredValue(this.crystalCost);
                this.mPanel.gemSpinner.SetDesiredValue(this.gemCost);
                this.UpdateResources();
            }
            else
            {
                this.mPanel.crystalSpinner.SetDesiredValue(0);
                this.mPanel.gemSpinner.SetDesiredValue(0);
            };
        }

        public function UpdateResources():void
        {
            var _local_1:CollectionPart;
            if (this.resources)
            {
                this.mPanel.crystalResourceLabel.text = this.resources.GetPlayerResource("Crystal").amount.toString();
                this.mPanel.gemResourceLabel.text = this.resources.GetPlayerResource("HardCurrency").amount.toString();
            };
            if (this.selectedCollection)
            {
                _local_1 = this.contentManager.GetPartWithName(this.selectedCollection.getPartName());
                this.numberOfCollectionParts = ((_local_1 != null) ? _local_1.GetAmount() : 0);
                this.mPanel.collectionCountText.text = ((this.numberOfCollectionParts + " / ") + this.selectedCollection.getPartAmount());
                this.mPanel.completeCollectionButton.enabled = (this.numberOfCollectionParts >= this.selectedCollection.getPartAmount());
            };
        }

        private function decrementRollsOutHandler(_arg_1:MouseEvent):void
        {
            (_arg_1.target as CGDecrementButton).bg.source = gAssetManager.GetClass("congen_down");
            this.decrementRepeatTimer.stop();
        }

        protected function enabledActionsDelayTimerHandler(_arg_1:TimerEvent):void
        {
            this.IsActionsEnabled = true;
        }

        private function incrementTimerHandler(_arg_1:TimerEvent):void
        {
            if (this.incrementRepeatTimer.delay > 100)
            {
                this.incrementRepeatTimer.delay = (this.incrementRepeatTimer.delay - 100);
            };
            this.incrementRolls();
        }

        private function collectionClickHandler(_arg_1:ListEvent):void
        {
            if ((_arg_1.itemRenderer.data as ContentGeneratorContent).GetIsEnabled())
            {
                this.selectCollection((_arg_1.itemRenderer.data as ContentGeneratorContent));
            };
        }

        private function incrementRollsDownHandler(_arg_1:MouseEvent):void
        {
            if (this.IsActionsEnabled)
            {
                (_arg_1.target as CGIncrementButton).bg.source = gAssetManager.GetClass("congen_up_pressed");
                this.incrementRolls();
                this.incrementRepeatTimer.delay = 500;
                this.incrementRepeatTimer.reset();
                this.incrementRepeatTimer.start();
            };
        }

        override public function Hide():void
        {
            if (this.IsActionsEnabled)
            {
                super.Hide();
                FloatingItemsManager.releaseStack("GAMESTATE_ID_ACTIONBAR.actionBarCenter.btnActionBar04");
                this.updateLastEnabledItems(false);
            };
        }

        private function notEnoughGemsPopupHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            globalFlash.gui.mShopWindow.AddHardCurrency(new MouseEvent(MouseEvent.CLICK));
        }

        private function incrementRolls():void
        {
            if (this.numberOfRolls == 99)
            {
                this.numberOfRolls = 1;
            }
            else
            {
                this.numberOfRolls++;
            };
            this.mPanel.selectorSpinner.SetDesiredValue(this.numberOfRolls);
            this.updateCurrentRollCosts(this.numberOfRolls);
        }

        public function GetPanel():ContentGeneratorPanel
        {
            return (this.mPanel);
        }

        public function get AutoRewind():Boolean
        {
            return (this.mPanel.mAutoRewindEnabled);
        }

        public function CompleteCollectionHandler(_arg_1:ArrayCollection):void
        {
            this.isWaitingForServer = false;
            this.enableActionsDelayTimer.reset();
            this.enableActionsDelayTimer.start();
            this.ShowCompleteCollectionRewards(_arg_1);
            this.UpdateResources();
        }

        public function RollCompleteHandler():void
        {
            this.isWaitingForServer = false;
            if (!this.isVideoPlaying)
            {
                this.ProcessRollComplete();
            };
        }

        public function get IsActionsEnabled():Boolean
        {
            return (this._isActionsEnabled);
        }

        private function decrementTimerHandler(_arg_1:TimerEvent):void
        {
            if (this.decrementRepeatTimer.delay > 100)
            {
                this.decrementRepeatTimer.delay = (this.decrementRepeatTimer.delay - 100);
            };
            this.decrementRolls();
        }

        private function decrementRollsDownHandler(_arg_1:MouseEvent):void
        {
            if (this.IsActionsEnabled)
            {
                (_arg_1.target as CGDecrementButton).bg.source = gAssetManager.GetClass("congen_down_pressed");
                this.decrementRolls();
                this.decrementRepeatTimer.delay = 500;
                this.decrementRepeatTimer.reset();
                this.decrementRepeatTimer.start();
            };
        }

        private function resetRolls():void
        {
            this.numberOfRolls = 1;
            this.mPanel.selectorSpinner.SetDesiredValue(this.numberOfRolls);
            this.updateCurrentRollCosts(this.numberOfRolls);
            this.UpdateResources();
        }

        private function incrementRollsUpHandler(_arg_1:MouseEvent):void
        {
            (_arg_1.target as CGIncrementButton).bg.source = gAssetManager.GetClass("congen_up_highlight");
            this.incrementRepeatTimer.stop();
        }

        private function updateLastEnabledItems(_arg_1:Boolean=false):void
        {
            var _local_2:ContentGeneratorCategory;
            var _local_3:ContentGeneratorContent;
            this.lastEnabledItems = new Vector.<String>();
            for each (_local_2 in this.contentDefinitions.getActiveDefinitions())
            {
                for each (_local_3 in _local_2.getCollections())
                {
                    if (((_local_3.GetIsEnabled()) || (_arg_1)))
                    {
                        this.lastEnabledItems.push(_local_3.getName());
                    };
                };
                if (((_local_2.GetIsEnabled()) || (_arg_1)))
                {
                    this.lastEnabledItems.push(_local_2.getName());
                };
            };
        }

        private function decrementRollsUpHandler(_arg_1:MouseEvent):void
        {
            (_arg_1.target as CGDecrementButton).bg.source = gAssetManager.GetClass("congen_down_highlight");
            this.decrementRepeatTimer.stop();
        }

        private function selectCollection(_arg_1:ContentGeneratorContent):void
        {
            var _local_4:cLootTableItemContent;
            var _local_5:ArrayCollection;
            var _local_6:ContentGeneratorContent;
            this.selectedCollection = _arg_1;
            var _local_2:CollectionPart = this.contentManager.GetPartWithName(this.selectedCollection.getPartName());
            this.numberOfCollectionParts = ((_local_2 != null) ? _local_2.GetAmount() : 0);
            this.mPanel.collectionDescriptionText.text = this.loca.GetText(LOCA_GROUP.DESCRIPTIONS, this.selectedCollection.getName());
            this.mPanel.collectionCountText.text = ((this.numberOfCollectionParts + " / ") + this.selectedCollection.getPartAmount());
            this.mPanel.completeCollectionButton.enabled = (this.numberOfCollectionParts >= this.selectedCollection.getPartAmount());
            var _local_3:ArrayCollection = new ArrayCollection();
            for each (_local_4 in this.selectedCollection.getContent().mItemContents_vector)
            {
                _local_3.addItem(_local_4.GetEffectVOFromLootTableItemContent());
            };
            this.mPanel.resultsList.dataProvider = _local_3;
            this.mPanel.collectionDescriptionText.verticalScrollPosition = 0;
            this.mPanel.partImage.source = gAssetManager.GetResourceIcon(this.selectedCollection.getPartName());
            this.updateCurrentRollCosts(this.numberOfRolls);
            _local_5 = new ArrayCollection();
            for each (_local_6 in this.selectedCategory.getCollections())
            {
                if (_local_6 == _arg_1)
                {
                    _local_6.selected = true;
                }
                else
                {
                    _local_6.selected = false;
                };
                _local_5.addItem(_local_6);
            };
            this.mPanel.collectionButtonContainer.dataProvider = _local_5;
        }

        private function decrementRolls():void
        {
            if (this.numberOfRolls == 1)
            {
                this.numberOfRolls = 99;
            }
            else
            {
                this.numberOfRolls--;
            };
            this.mPanel.selectorSpinner.SetDesiredValue(this.numberOfRolls);
            this.updateCurrentRollCosts(this.numberOfRolls);
        }

        private function ProcessRollComplete():void
        {
            globalFlash.gui.mContentGeneratorRewardPanel.ShowSecondaryPanel();
            this.resetRolls();
            this.enableActionsDelayTimer.reset();
            this.enableActionsDelayTimer.start();
            this.UpdateResources();
        }

        protected function DoRoll(useHardCurrency:Boolean=false):void
        {
            var volume:Number;
            if (this.gi.killswitch.isLocked(KILL_SWITCH.CONTENT_GENERATOR_ROLL))
            {
                return;
            };
            var now:Number = new Date().getTime();
            if (this.lastRollTimestamp > (now - 1000))
            {
                return;
            };
            this.lastRollTimestamp = now;
            this.gi.mContentGeneratorManager.RollCollection(this.selectedCategory.getId(), this.selectedCollection.getId(), this.numberOfRolls, useHardCurrency);
            this.IsActionsEnabled = false;
            this.isWaitingForServer = true;
            try
            {
                volume = ((cSettingsManager.getInstance().sfxVolume * 1) / (defines.VOLUME_MAX_VALUE * 1));
                if (cSettingsManager.getInstance().sfxMuted)
                {
                    volume = 0;
                };
                this.mPanel.ani.volume = volume;
                this.mPanel.ani.playheadTime = 0;
                this.mPanel.ani.play();
                this.isVideoPlaying = true;
                cSoundManager.getInstance().playEffect(cSoundManager.CG_START_ROLL);
            }
            catch(e:Error)
            {
                ClientLogger.error(e);
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == cResources.RESOURCE_CHANGE)
            {
                this.UpdateResources();
            };
        }

        private function rollWithGemsHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.DoRoll(true);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.gemResourceLabel.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "HardCurrency");
            if (this.resources)
            {
                this.resources.addPropertyObserver(cResources.RESOURCE_CHANGE, this);
            };
        }

        public function set AutoRewind(_arg_1:Boolean):void
        {
            this.mPanel.mAutoRewindEnabled = _arg_1;
        }

        private function spinButtonClickHandler(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            ClientLogger.log(((((("BREA: " + this.selectedCategory) + "###") + this.selectedCollection) + "###") + this.IsActionsEnabled));
            if ((((!(this.selectedCategory == null)) && (!(this.selectedCollection == null))) && (this.IsActionsEnabled)))
            {
                this.mPanel.spinButton.source = gAssetManager.GetClass("congen_button_pushed");
                this.spinButtonTimer.reset();
                this.spinButtonTimer.start();
                _local_2 = 0;
                _local_2 = (this.gemCost - this.resources.GetResource("HardCurrency").amount);
                if (_local_2 > 0)
                {
                    CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "NotEnoughGemsForContentGenRoll"), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "NotEnoughGemsForContentGenRoll"), (Alert.OK | Alert.CANCEL), null, this.notEnoughGemsPopupHandler, null, 4, false, CustomAlert.STYLE_PAYMENT);
                }
                else
                {
                    if (this.gemCost > 0)
                    {
                        CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ContentGeneratorGemRoll"), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ContentGeneratorGemRoll"), (Alert.OK | Alert.CANCEL), null, this.rollWithGemsHandler, null, 4, false, CustomAlert.STYLE_PAYMENT);
                    }
                    else
                    {
                        this.DoRoll();
                    };
                };
            };
        }

        private function collectionRewardTimerCompleteHandler(_arg_1:TimerEvent):void
        {
            var _local_2:ContentGeneratorRewardItemRenderer;
            for each (_local_2 in this.collectionRewardObjects)
            {
                FloatingItemsManager.jumpOutsideWindow(_local_2, this.mPanel);
                this.mPanel.removeChild(_local_2);
            };
        }

        public function GetPanelPoint():Point
        {
            var _local_1:Point = new Point();
            _local_1.x = this.mPanel.x;
            _local_1.y = this.mPanel.y;
            return (_local_1);
        }

        public function set IsActionsEnabled(_arg_1:Boolean):void
        {
            this._isActionsEnabled = _arg_1;
            this.UpdateResources();
            if (!_arg_1)
            {
                this.mPanel.completeCollectionButton.enabled = _arg_1;
            }
            else
            {
                this.defaultActionUnlockTimer.reset();
                this.defaultActionUnlockTimer.start();
            };
            this.mPanel.btnClose.enabled = _arg_1;
        }

        protected function videoCompleteHandler(_arg_1:VideoEvent):void
        {
            this.isVideoPlaying = false;
            this.mPanel.ani.playheadTime = 0;
            this.mPanel.spinButton.source = gAssetManager.GetClass("congen_button");
            if (!this.isWaitingForServer)
            {
                this.ProcessRollComplete();
            };
        }

        public function ShowCompleteCollectionRewards(_arg_1:ArrayCollection):void
        {
            var _local_2:EffectVO;
            var _local_3:ContentGeneratorRewardItemRenderer;
            this.collectionRewardObjects = new ArrayCollection();
            for each (_local_2 in _arg_1)
            {
                _local_3 = new ContentGeneratorRewardItemRenderer();
                _local_3.height = 120;
                _local_3.width = 80;
                _local_3.x = 640;
                _local_3.y = 300;
                _local_3.data = _local_2;
                this.mPanel.addChild(_local_3);
                this.collectionRewardObjects.addItem(_local_3);
            };
            this.collectionRewardTimer.reset();
            this.collectionRewardTimer.start();
        }

        private function contentCategoryClickHandler(_arg_1:ListEvent):void
        {
            var _local_2:ArrayCollection;
            var _local_3:ContentGeneratorCategory;
            if ((_arg_1.itemRenderer.data as ContentGeneratorCategory).GetIsEnabled())
            {
                _local_2 = new ArrayCollection();
                this.selectCategory((_arg_1.itemRenderer.data as ContentGeneratorCategory));
                for each (_local_3 in this.contentCategories)
                {
                    if (_local_3 == (_arg_1.itemRenderer.data as ContentGeneratorCategory))
                    {
                        _local_3.selected = true;
                    }
                    else
                    {
                        _local_3.selected = false;
                    };
                    _local_2.addItem(_local_3);
                };
                this.mPanel.categoryButtonContainer.dataProvider = _local_2;
            };
        }

        private function incrementRollsOutHandler(_arg_1:MouseEvent):void
        {
            (_arg_1.target as CGIncrementButton).bg.source = gAssetManager.GetClass("congen_up");
            this.incrementRepeatTimer.stop();
        }

        private function defaultActionUnlockTimerHandler(_arg_1:TimerEvent):void
        {
            this.IsActionsEnabled = true;
        }

        protected function spinButtonMouseOutHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.spinButton.source = gAssetManager.GetClass("congen_button");
        }

        public function updateContentDefinitions():void
        {
            var _local_3:ContentGeneratorCategory;
            var _local_4:ContentGeneratorContent;
            this.contentDefinitions = ContentGeneratorDefinitions.getInstance();
            this.contentCategories = this.contentDefinitions.getActiveDefinitions();
            this.numberOfRolls = 1;
            if (this.contentDefinitions == null)
            {
                return;
            };
            var _local_1:Boolean = true;
            var _local_2:ArrayCollection = new ArrayCollection();
            for each (_local_3 in this.contentCategories)
            {
                if (this.selectedCategory == null)
                {
                    if (_local_1)
                    {
                        _local_3.selected = true;
                        this.selectedCategory = _local_3;
                        _local_1 = false;
                    }
                    else
                    {
                        _local_3.selected = false;
                    };
                }
                else
                {
                    if (_local_3.getName() == this.selectedCategory.getName())
                    {
                        _local_3.selected = true;
                    }
                    else
                    {
                        _local_3.selected = false;
                    };
                };
                _local_2.addItem(_local_3);
            };
            if (this.selectedCollection == null)
            {
                this.selectCollection(this.selectedCategory.getCollections()[0]);
            }
            else
            {
                for each (_local_4 in this.selectedCategory.getCollections())
                {
                    if (_local_4.getName() == this.selectedCollection.getName())
                    {
                        this.selectCollection(_local_4);
                    };
                };
            };
            this.mPanel.categoryButtonContainer.dataProvider = _local_2;
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            if (this.IsActionsEnabled)
            {
                this.Hide();
            };
        }

        protected function completeCollectionClickHandler(_arg_1:MouseEvent):void
        {
            if ((((((!(this.selectedCategory == null)) && (!(this.selectedCollection == null))) && (this.mPanel.completeCollectionButton.enabled)) && (this.IsActionsEnabled)) && (this.gi.killswitch.isAccessible(KILL_SWITCH.CONTENT_GENERATOR_COMPLETE))))
            {
                this.contentManager.CompleteCollection(this.selectedCategory.getId(), this.selectedCollection.getId());
                this.UpdateResources();
                this.IsActionsEnabled = false;
                this.isWaitingForServer = true;
            };
        }


    }
}
