package GUI.GAME
{
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.ConstructionInfoPanel;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import ServerState.dResource;
    import GUI.Components.ItemRenderer.ResourceItemRenderer;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import ServerState.cResources;
    import Enums.COMMAND;
    import Communication.VO.dBuyOneClickShopItemVO;
    import Enums.ONE_CLICK_SHOPITEM;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import flash.events.Event;
    import mx.events.CloseEvent;
    import __AS3__.vec.Vector;
    import nLib.gMisc;
    import GUI.Decorator.GUIDecorator;
    import GUI.Components.ResourceAlert;

    public class cConstructionInfoPanel extends cBasicInfoPanel 
    {

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:ConstructionInfoPanel;


        override public function Show():void
        {
            super.Show();
        }

        override public function Hide():void
        {
            super.Hide();
        }

        private function CreateKnockDownToolTip(_arg_1:ToolTipEvent):void
        {
            if (((this.mBuilding.IsRecurringBuilding()) || (this.mBuilding.GetBuildingMode() == cBuilding.BUILDING_MODE_QUEUED)))
            {
                cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
            }
            else
            {
                cToolTipUtil.createToolTip(cToolTipUtil.DEMOLISH_BUILDING_string, _arg_1, this.mBuilding);
            };
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_3:Boolean;
            var _local_4:dResource;
            var _local_5:dResource;
            var _local_6:int;
            var _local_7:ResourceItemRenderer;
            var _local_8:dResource;
            var _local_9:Array;
            var _local_10:int;
            var _local_2:String = _arg_1.GetBuildingName_string();
            this.mBuilding = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.buildingHeader.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mPanel.buildingHeader.image.source = gAssetManager.GetBuildingIcon(_local_2);
            this.mPanel.btnKnockDown.enabled = _arg_1.IsKnockdownAllowed();
            if (this.mBuilding.IsRecurringBuilding())
            {
                this.mPanel.buildingHeader.payshopItemIndicator.visible = true;
                this.mPanel.btnKnockDown.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "KnockDownRecurring");
            }
            else
            {
                if (this.mBuilding.GetBuildingMode() == cBuilding.BUILDING_MODE_QUEUED)
                {
                    this.mPanel.btnKnockDown.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "CancelQueuedConstruction");
                }
                else
                {
                    this.mPanel.buildingHeader.payshopItemIndicator.visible = false;
                    this.mPanel.btnKnockDown.toolTip = "KnockDown";
                };
            };
            if (this.mBuilding.IsConstructionStarted())
            {
                this.mPanel.costsLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TimeRemaining");
                this.mPanel.timeLabel.text = cLocaManager.GetInstance().FormatDuration(this.mBuilding.GetRemainingConstructionDuration());
                this.mPanel.costsList.visible = false;
                this.mPanel.timeLabel.visible = true;
                this.mPanel.btnInstant.toolTip = "BuildInstant";
                this.mPanel.btnInstant.visible = true;
            }
            else
            {
                this.mPanel.costsLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Costs");
                this.mPanel.costsList.visible = true;
                this.mPanel.timeLabel.visible = false;
                this.mPanel.btnInstant.visible = false;
                this.mPanel.costsList.removeAllChildren();
                _local_3 = false;
                if (!_arg_1.IsRecurringBuilding())
                {
                    for each (_local_4 in global.buildingGroup.GetCostListFromName_vector(_local_2))
                    {
                        _local_5 = global.ui.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer).GetPlayerResource(_local_4.name_string);
                        _local_6 = (_local_5.amount - _local_4.amount);
                        _local_7 = new ResourceItemRenderer();
                        if (_local_6 >= 0)
                        {
                            _local_7.data = _local_4;
                            this.mPanel.costsList.addChild(_local_7);
                        }
                        else
                        {
                            _local_7.color = 0xFF0000;
                            _local_7.enableAmountCheck = false;
                            _local_8 = new dResource();
                            _local_8.name_string = _local_4.name_string;
                            _local_8.amount = -(_local_6);
                            _local_7.data = _local_8;
                            this.mPanel.costsList.addChild(_local_7);
                            _local_3 = true;
                        };
                    };
                };
                if (_local_3)
                {
                    this.mPanel.costsLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "MissingResourcesShort");
                    _local_9 = this.mPanel.costsList.getChildren();
                    _local_10 = 0;
                    while (_local_10 < _local_9.length)
                    {
                        if (_local_9[_local_10].color != 0xFF0000)
                        {
                            this.mPanel.costsList.removeChild(_local_9[_local_10]);
                        };
                        _local_10++;
                    };
                };
            };
        }

        private function InstantBuild(_arg_1:MouseEvent):void
        {
            var _local_2:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            if (_local_2.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.mBuilding.GetBuildInstantCosts()))
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, this.mGI.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().InitWithBuildingGrid(ONE_CLICK_SHOPITEM.INSTANT_BUILDING_CONSTRUCTION, this.mBuilding.GetGrid()));
            }
            else
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
            this.Hide();
        }

        public function Init(_arg_1:ConstructionInfoPanel):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnKnockDown.addEventListener(MouseEvent.CLICK, this.ConfirmRemoveBuilding);
            this.mPanel.btnKnockDown.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateKnockDownToolTip);
            this.mPanel.btnInstant.addEventListener(MouseEvent.CLICK, this.InstantBuild);
            this.mPanel.btnInstant.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateInstantBuildTip);
        }

        private function CreateInstantBuildTip(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.INSTANT_BUILD_string, _arg_1, this.mBuilding.GetBuildInstantCosts());
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        private function ConfirmRemoveBuilding(_arg_1:Event):void
        {
            var _local_2:String;
            var _local_3:Vector.<dResource>;
            if (this.mBuilding.GetGOContainer().mAddDepositName != null)
            {
                CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ConfirmTeardownWithDeposit", [this.mBuilding.GetGOContainer().mAddDepositAmount, gMisc.GetSubString_string(this.mBuilding.GetGOContainer().mAddDepositName, 7, (this.mBuilding.GetGOContainer().mAddDepositName.length - 7)), this.mBuilding.GetBuildingName_string()]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmTeardownWithDeposit", [this.mBuilding.GetBuildingName_string()]), (Alert.CANCEL | Alert.OK), null, this.RemoveBuilding, GUIDecorator.overlay(gAssetManager.GetBitmap("icon_exclamationmark_large.png"), gAssetManager.GetBuildingIcon(this.mBuilding.GetBuildingName_string()), 3, 3), 4, false, CustomAlert.STYLE_DEFAULT, null, "left");
            }
            else
            {
                _local_3 = null;
                if (!this.mBuilding.IsRecurringBuilding())
                {
                    _local_2 = "ConfirmTeardown";
                    if (this.mBuilding.GetBuildingMode() == cBuilding.BUILDING_MODE_QUEUED)
                    {
                        _local_3 = global.buildingGroup.GetCostListFromName_vector(this.mBuilding.GetBuildingName_string());
                    }
                    else
                    {
                        _local_3 = this.mBuilding.GetRefundResources();
                    };
                }
                else
                {
                    _local_2 = "ConfirmTeardownBuff";
                };
                ResourceAlert.show(_local_2, null, "ConfirmTeardown", null, _local_3, (Alert.CANCEL | Alert.OK), null, this.RemoveBuilding, null, true, ResourceAlert.STYLE_WHITE_RESOURCES);
            };
        }

        public function Refresh():void
        {
            if (this.mBuilding)
            {
                this.SetData(this.mBuilding);
            };
        }

        private function RemoveBuilding(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mGI.mCurrentPlayerZone.SendDestructBuildingCommand(this.mBuilding, "cConstructionInfoPanel");
            this.Hide();
        }


    }
}
