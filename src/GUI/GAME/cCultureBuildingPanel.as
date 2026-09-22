package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.CultureBuildingPanel;
    import TimedProduction.EffectTimedProductionDefinition;
    import mx.collections.ArrayCollection;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import GUI.Components.data.dSelectableDataObject;
    import mx.controls.Alert;
    import Enums.COMMAND;
    import mx.events.CloseEvent;
    import BuffSystem.cBuffDefinition;
    import __AS3__.vec.Vector;
    import Communication.VO.dPersistedBuffApplianceVO;
    import GUI.Components.CustomAlert;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.events.MouseEvent;
    import ServerState.cResources;
    import GUI.Assets.gAssetManager;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    import flash.events.Event;
    import Communication.VO.dTimedProductionVO;
    import ServerState.dResource;
    import GUI.Components.Frame;
    import Communication.VO.dRequirementsVO;
    import nLib.gMisc;
    import Utils.RequirementsHelper;

    public class cCultureBuildingPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:CultureBuildingPanel;
        private var mSelectedOrderType:EffectTimedProductionDefinition;
        private var mRecipes:ArrayCollection = new ArrayCollection();


        private function createToolTipHandler(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.INSTANT_BUILD_string, _arg_1, this.mBuilding.GetSkipCooldownGemCost());
        }

        private function updateSelected():void
        {
            var _local_1:dSelectableDataObject;
            this.mRecipes.disableAutoUpdate();
            for each (_local_1 in this.mRecipes)
            {
                if (((!(this.mSelectedOrderType == null)) && ((_local_1.data as EffectTimedProductionDefinition).name_string == this.mSelectedOrderType.name_string)))
                {
                    _local_1.selected = true;
                }
                else
                {
                    _local_1.selected = false;
                };
            };
            this.mRecipes.enableAutoUpdate();
        }

        private function HandleResetCooldownCommand(_arg_1:CloseEvent):void
        {
            this.mPanel.btnSkipCooldown.enabled = true;
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            global.ui.SendServerActionSimple(COMMAND.RESET_CULTURE_BUILDING_COOLDOWN_WITH_GEMS, this.mBuilding.GetUniqueId());
            this.SetIsWaitingForServer(true);
        }

        private function HandleOrderClick(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            var _local_4:String;
            var _local_7:cBuffDefinition;
            var _local_8:String;
            _local_2 = this.mSelectedOrderType.effects_vector[0].name_string;
            var _local_3:cBuffDefinition = cBuffDefinition.GetByName(_local_2);
            var _local_5:Vector.<dPersistedBuffApplianceVO> = this.mGI.mZoneBuffManager.getBuffInExclusivityGroup_vector(_local_3.GetExclusivityGroup());
            var _local_6:Boolean = this.mGI.mZoneBuffManager.isBuffRunning(_local_2);
            if (_local_6)
            {
                CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ZoneTimedBuffExtend", [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_2)]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ZoneTimedBuff"), (Alert.OK | Alert.CANCEL), null, this.PlaceOrder, null, 4, false);
            }
            else
            {
                if (_local_5.length > 0)
                {
                    _local_7 = cBuffDefinition.GetById(_local_5[0].buffID);
                    _local_8 = (_local_7.GetName_string() + ((_local_5[0].resourceName_string.length > 0) ? ("_" + _local_5[0].resourceName_string) : ""));
                    CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ZoneTimedBuffReplace", [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_2), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_8)]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ZoneTimedBuff"), (Alert.OK | Alert.CANCEL), null, this.PlaceOrder, null, 4, false);
                }
                else
                {
                    this.PlaceOrder(new CloseEvent("dummy", false, false, Alert.OK));
                };
            };
        }

        public function SetIsWaitingForServer(_arg_1:Boolean):void
        {
            var _local_2:Number = this.mBuilding.getRemainingCooldown();
            this.mPanel.busy.visible = _arg_1;
            this.mPanel.busyAnim.visible = _arg_1;
            this.mPanel.btnOK.visible = (_local_2 < 1);
            this.SelectOrderType(this.mSelectedOrderType);
            this.mPanel.cooldownRemainingLabel.text = ((cLocaManager.GetInstance().getLabel("Cooldown") + " : ") + cLocaManager.GetInstance().FormatDuration(_local_2, cLocaManager.DURATION_FORMAT_SHORT));
            this.mPanel.btnSkipCooldown.enabled = ((_local_2 > 0) && (this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer).HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.mBuilding.GetSkipCooldownGemCost())));
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_4:Number;
            this.mBuilding = _arg_1;
            this.mPanel.enableUpgradeColumn = (!(this.mBuilding.GetUpgradeLevelBonusesForLevel(2) == null));
            this.mPanel.upgradeColumn.SetData(this.mBuilding, this, this.mPanel);
            var _local_2:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            var _local_3:String = this.mBuilding.GetBuildingName_string();
            this.mPanel.data = _local_3;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_3);
            this.mPanel.buildingHeader.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_3);
            this.mPanel.buildingHeader.image.source = gAssetManager.GetBuildingIcon(_local_3);
            this.mPanel.buildingHeader.payshopItemIndicator.visible = this.mBuilding.IsRecurringBuilding();
            this.GetTimedProductions();
            this.mPanel.buildingStacksPanel.SetData(this.mBuilding, "DuplicatedBuildingCultureTip");
            if (this.mRecipes.length > 0)
            {
                (this.mRecipes.getItemAt(0) as dSelectableDataObject).selected = true;
                this.SelectOrderType(((this.mRecipes.getItemAt(0) as dSelectableDataObject).data as EffectTimedProductionDefinition));
            };
            this.mPanel.availableOrdersList.dataProvider = this.mRecipes;
            this.mPanel.availableOrdersList.columnCount = this.mRecipes.length;
            this.mPanel.availableOrdersList.selectedIndex = 0;
            _local_4 = this.mBuilding.getRemainingCooldown();
            this.mPanel.btnOK.visible = (_local_4 < 1);
            this.mPanel.cooldownRemainingLabel.text = ((cLocaManager.GetInstance().getLabel("Cooldown") + " : ") + cLocaManager.GetInstance().FormatDuration(_local_4, cLocaManager.DURATION_FORMAT_SHORT));
            this.mPanel.btnSkipCooldown.enabled = ((_local_4 > 0) && (this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer).HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.mBuilding.GetSkipCooldownGemCost())));
            this.mPanel.busy.visible = false;
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.availableOrdersList.addEventListener(ListEvent.ITEM_CLICK, this.HandleOrderItemClick);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.HandleOrderClick);
            this.mPanel.btnSkipCooldown.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.createToolTipHandler);
            this.mPanel.btnSkipCooldown.addEventListener(MouseEvent.CLICK, this.HandleResetCooldownClick);
            EnableDragging();
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        override public function Show():void
        {
            if (!IsVisible())
            {
                this.mPanel.x = ((global.getApplication().stage.width / 2) - (this.mPanel.width / 2));
                this.mPanel.y = Math.max(22, (((global.getApplication().stage.height / 2) - (this.mPanel.height / 2)) - globalFlash.mainHudBottomPos));
            };
            super.Show();
        }

        private function PlaceOrder(_arg_1:CloseEvent):void
        {
            var _local_2:dTimedProductionVO;
            if (_arg_1.detail == Alert.OK)
            {
                _local_2 = new dTimedProductionVO();
                _local_2.productionType = this.mBuilding.productionQueue.mProductionType;
                _local_2.type_string = this.mSelectedOrderType.GetType();
                _local_2.amount = 1;
                _local_2.stacks = 1;
                _local_2.buildingGrid = this.mBuilding.GetGrid();
                this.mPanel.btnOK.enabled = false;
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.START_TIMED_PRODUCTION, this.mGI.mCurrentViewedZoneID, _local_2);
                this.mBuilding.productionQueue.SetWaitingForServer(true);
                this.SetData(this.mBuilding);
                this.SetIsWaitingForServer(true);
            };
        }

        private function SelectOrderType(_arg_1:EffectTimedProductionDefinition):void
        {
            var _local_2:cBuffDefinition;
            var _local_10:dResource;
            var _local_11:cResources;
            this.mSelectedOrderType = _arg_1;
            this.updateSelected();
            if (!this.mSelectedOrderType)
            {
                return;
            };
            if (this.mSelectedOrderType.effects_vector.length > 0)
            {
                _local_2 = cBuffDefinition.GetByName(this.mSelectedOrderType.effects_vector[0].name_string);
            };
            if (_local_2 != null)
            {
                this.mPanel.descriptionField.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2.GetName_string());
                this.mPanel.buffFrame.contentType = Frame.CONTENT_TYPE_BUFF;
                this.mPanel.buffFrame.type = Frame.BUFF_ZONE_TIMED;
                this.mPanel.buffFrame.content = _local_2.GetName_string();
                this.mPanel.buffFrame.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_2.GetName_string());
            };
            var _local_3:Vector.<dResource> = this.mSelectedOrderType.GetCosts_vector();
            var _local_4:Array = [];
            var _local_5:Boolean = true;
            var _local_6:int = 1;
            var _local_7:dRequirementsVO = global.ui.mRequirements.timedProductionRequirements_vector[this.mSelectedOrderType.GetType()];
            this.mPanel.btnOK.enabled = _local_7.isFulfilledForSkillList(global.ui.mCurrentPlayer.getSkills());
            var _local_8:Number = this.mBuilding.getRemainingCooldown();
            this.mPanel.coolDownTimeLabel.text = (cLocaManager.GetInstance().getLabel("Cooldown") + " : ");
            var _local_9:int = int((_local_2.GetCultureBuildingCooldown() / (this.mBuilding.getCooldownTimeBonus() / 100)));
            this.mPanel.coolDownTimeText.text = cLocaManager.GetInstance().FormatDuration(_local_9, cLocaManager.DURATION_FORMAT_SHORT);
            for each (_local_10 in _local_3)
            {
                _local_11 = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
                if (_local_10.name_string == defines.POPULATION_RESOURCE_NAME_string)
                {
                    _local_5 = (_local_11.GetFree() >= (_local_6 * _local_10.amount));
                }
                else
                {
                    _local_5 = _local_11.HasPlayerResource(_local_10.name_string, (_local_6 * _local_10.amount));
                };
                _local_4.push({
                    "amount":null,
                    "resource":_local_10,
                    "canAfford":_local_5,
                    "inStorage":_local_11.GetResourceAmount(_local_10.name_string)
                });
                if ((((this.mPanel.btnOK.enabled) && (!(_local_5))) || (_local_8 > 0)))
                {
                    this.mPanel.btnOK.enabled = false;
                };
            };
            this.mPanel.orderCostsList.dataProvider = _local_4;
            _local_10 = new dResource();
            _local_10.name_string = _local_2.GetName_string();
            _local_10.amount = this.mSelectedOrderType.GetProductionAmount();
            this.mPanel.orderProductList.dataProvider = [{
                "amount":null,
                "resource":_local_10,
                "canAfford":true
            }];
        }

        private function HandleOrderItemClick(_arg_1:ListEvent):void
        {
            this.SelectOrderType((_arg_1.itemRenderer.data.data as EffectTimedProductionDefinition));
        }

        private function HandleResetCooldownClick(_arg_1:Event):void
        {
            this.mPanel.btnSkipCooldown.enabled = false;
            CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ResetCultureBuildingCooldown"), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ResetCultureBuildingCooldown"), (Alert.OK | Alert.CANCEL), null, this.HandleResetCooldownCommand, null, 4, false);
        }

        public function Init(_arg_1:CultureBuildingPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function GetTimedProductions():void
        {
            var _local_1:EffectTimedProductionDefinition;
            this.mRecipes.disableAutoUpdate();
            this.mRecipes.removeAll();
            for each (_local_1 in gMisc.iterableToArray(global.timedProductions_vector[this.mBuilding.productionQueue.mProductionType]))
            {
                if ((((RequirementsHelper.checkRequirements(this.mGI, _local_1.requiresEvent, _local_1.requiresQuest)) && (this.mBuilding.GetUpgradeLevel() >= _local_1.requiresUpgradeLevelMin)) && (this.mBuilding.GetUpgradeLevel() <= _local_1.requiresUpgradeLevelMax)))
                {
                    this.mRecipes.addItem(new dSelectableDataObject(false, _local_1, this.mBuilding));
                };
            };
            this.mRecipes.enableAutoUpdate();
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }


    }
}
