package GUI.GAME
{
    import Model.Observer;
    import Skill.SkillpointDefinition;
    import mx.containers.Canvas;
    import Interface.cGameInterface;
    import GUI.Components.SkillProductionPanel;
    import GO.cBuilding;
    import mx.binding.utils.ChangeWatcher;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import TimedProduction.cTimedProduction;
    import flash.utils.Dictionary;
    import BuffSystem.BuffAppliance;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import mx.controls.Image;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import GUI.FloatingItemsManager;
    import Enums.COMMAND;
    import Enums.ONE_CLICK_SHOPITEM;
    import ServerState.cResources;
    import Communication.VO.dBuyOneClickShopItemVO;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import TimedProduction.cTimedProductionQueue;
    import Communication.VO.dTimedProductionQueueChangeVO;
    import mx.events.ListEvent;
    import mx.events.ToolTipEvent;
    import Communication.VO.dTimedProductionVO;
    import Skill.SkillpointLevelDefinition;
    import BuffSystem.cBuffDefinition;
    import ServerState.cPlayerData;
    import nLib.gMisc;
    import GUI.Components.ToolTips.cToolTipUtil;
    import Communication.VO.dRequirementsVO;
    import Model.Notifier;
    import GUI.Components.tooltipData.MissingResourcesTooltipData;
    import mx.events.CloseEvent;
    import GUI.coloringFilter;
    import __AS3__.vec.*;

    public class cSkillProductionPanel extends cBasicInfoPanel implements Observer 
    {

        public static const REMOVE:String = "ProductionRemove";
        public static const INSTANT_FINISH:String = "ProductionInstantFinish";
        public static const PICK_UP:String = "ProductionPickUp";

        private var mSelectedSkillPoint:SkillpointDefinition;
        private var orderSelected:Canvas;
        private var mGI:cGameInterface;
        protected var mPanel:SkillProductionPanel;
        protected var mBuilding:cBuilding;
        private var watcher:ChangeWatcher;
        private var toolTipClass:String = "Multiline";
        private var missingResources:Vector.<dResource>;
        protected var mProductionType:int;
        private var mOrder:cTimedProduction;
        public var colors:Dictionary;


        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_2:String;
            var _local_4:SkillpointDefinition;
            var _local_5:BuffAppliance;
            var _local_6:String;
            var _local_7:cTimedProduction;
            this.mProductionType = _arg_1.productionQueue.mProductionType;
            this.mBuilding = _arg_1;
            _local_2 = this.mBuilding.GetContainerName_string();
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mPanel.image.source = gAssetManager.GetBuildingIcon(_local_2);
            this.mPanel.upgradeColumn.SetData(_arg_1, this, this.mPanel);
            this.mPanel.payshopItemIndicator.visible = this.mBuilding.IsRecurringBuilding();
            this.mPanel.control.visible = false;
            var _local_3:int;
            while (_local_3 < 3)
            {
                _local_4 = global.skillPoints_vector[_local_3];
                (this.mPanel[("orderImage" + _local_3)] as Image).source = gAssetManager.GetResourceIcon(_local_4.id_string);
                (this.mPanel[("orderBtn" + _local_3)] as Canvas).toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("Skillpoint_" + _local_4.id_string));
                _local_3++;
            };
            if (this.mBuilding.mBuffs_vector.length > 0)
            {
                _local_5 = this.mBuilding.mBuffs_vector[0];
                _local_6 = cLocaManager.GetInstance().FormatDuration((_local_5.GetBuffDefinition().getDuration(_local_5.GetApplicanceMode()) - (global.ui.GetClientTime() - _local_5.GetStartTime())), cLocaManager.DURATION_FORMAT_SHORT);
                this.mPanel.buffIndicator.visible = true;
                this.mPanel.buffIndicator.source = gAssetManager.GetResourceIcon((_local_5.GetBuffDefinition().GetName_string() + ((_local_5.GetResourceName_string().length > 0) ? ("_" + _local_5.GetResourceName_string()) : "")));
                this.mPanel.buffTimer.visible = true;
                this.mPanel.buffTimer.text = _local_6;
            }
            else
            {
                this.mPanel.buffIndicator.visible = false;
                this.mPanel.buffTimer.visible = false;
            };
            if (((!(this.mBuilding.productionQueue == null)) && (this.mBuilding.productionQueue.mTimedProductions_vector.length > 0)))
            {
                _local_7 = this.mBuilding.productionQueue.mTimedProductions_vector[0];
                this.mPanel.busy = true;
                this.mPanel.production.visible = true;
                this.setProductionOrder(_local_7, this.colors[_local_7.GetType()]);
                this.mPanel.busyAnim.visible = false;
                this.setProductionOrder(_local_7, this.colors[_local_7.GetType()]);
            };
            this.mPanel.busy = this.mBuilding.productionQueue.GetWaitingForServer();
            this.setOrder(this.mSelectedSkillPoint);
        }

        private function RollOver(_arg_1:MouseEvent):void
        {
            if (this.orderSelected != _arg_1.currentTarget)
            {
                (_arg_1.currentTarget as Canvas).setStyle("backgroundImage", gAssetManager.GetClass("BackgroundHighlight"));
            };
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        protected function pickUpHandler(_arg_1:Event):void
        {
            this.mPanel.pickUp.visible = false;
            FloatingItemsManager.createJumpFlyDestroy(this.mPanel.pickUpIcon, "GAMESTATE_ID_INFO_BAR.infoBarMiddle");
            var _local_2:cTimedProduction = this.mBuilding.productionQueue.mTimedProductions_vector[0];
            _local_2.SetWaitingForServer(true);
            this.mPanel.busy = true;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.DELIVER_PRODUCTION, this.mGI.mCurrentViewedZoneID, this.mProductionType);
        }

        private function productionInstantFinish(_arg_1:Event):void
        {
            var _local_2:cTimedProduction = this.mBuilding.productionQueue.mTimedProductions_vector[0];
            var _local_3:int = ONE_CLICK_SHOPITEM.INSTANT_SKILL_TIMED_PRODUCTION;
            var _local_4:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            if (_local_4.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_2.GetInstantBuildCosts()))
            {
                _local_2.SetWaitingForServer(true);
                this.mPanel.busy = true;
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, this.mGI.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().InitWithBuildingGrid(_local_3, this.mBuilding.GetGrid()));
            }
            else
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
        }

        override public function Show():void
        {
            this.mBuilding.productionQueue.addPropertyObserver(cTimedProductionQueue.PRODUCTION_START, this);
            this.mBuilding.productionQueue.addPropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, this);
            this.mGI.mCurrentPlayerZone.getResourcesFromCurrentZone().addPropertyObserver(cResources.RESOURCE_CHANGE, this);
            super.Show();
        }

        private function productionRemove(_arg_1:ListEvent):void
        {
            var _local_2:cTimedProduction = this.mBuilding.productionQueue.mTimedProductions_vector[_arg_1.rowIndex];
            _local_2.SetWaitingForServer(true);
            var _local_3:dTimedProductionQueueChangeVO = new dTimedProductionQueueChangeVO();
            _local_3.productionType = this.mProductionType;
            _local_3.itemID = _local_2.GetUniqueID();
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.PRODUCTION_REMOVE, this.mGI.mCurrentViewedZoneID, _local_3);
        }

        public function Init(_arg_1:SkillProductionPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.colors = new Dictionary();
            this.colors[global.skillPoints_vector[0].id_string] = 13408108;
            this.colors[global.skillPoints_vector[1].id_string] = 11121848;
            this.colors[global.skillPoints_vector[2].id_string] = 14865549;
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.orderBtn0.addEventListener(MouseEvent.CLICK, this.SelectOrder0);
            this.mPanel.orderBtn1.addEventListener(MouseEvent.CLICK, this.SelectOrder1);
            this.mPanel.orderBtn2.addEventListener(MouseEvent.CLICK, this.SelectOrder2);
            this.mPanel.orderBtn0.addEventListener(MouseEvent.ROLL_OVER, this.RollOver);
            this.mPanel.orderBtn0.addEventListener(MouseEvent.ROLL_OUT, this.RollOut);
            this.mPanel.orderBtn1.addEventListener(MouseEvent.ROLL_OVER, this.RollOver);
            this.mPanel.orderBtn1.addEventListener(MouseEvent.ROLL_OUT, this.RollOut);
            this.mPanel.orderBtn2.addEventListener(MouseEvent.ROLL_OVER, this.RollOver);
            this.mPanel.orderBtn2.addEventListener(MouseEvent.ROLL_OUT, this.RollOut);
            this.mPanel.btnProduce.addEventListener(MouseEvent.CLICK, this.Order);
            this.mPanel.btnPickUp.addEventListener(MouseEvent.CLICK, this.pickUpHandler);
            this.mPanel.btnInstantFinish.addEventListener(MouseEvent.CLICK, this.productionInstantFinish);
            this.mPanel.btnProduce.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.createSelectTooltip);
        }

        private function SortGroups(_arg_1:Object, _arg_2:Object):int
        {
            return (parseInt(_arg_1.group) - parseInt(_arg_2.group));
        }

        private function selectOrderStyles(_arg_1:Canvas):void
        {
            this.orderSelected = _arg_1;
            if (_arg_1 != this.mPanel.orderBtn0)
            {
                this.mPanel.orderBtn0.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            }
            else
            {
                this.mPanel.orderBtn0.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundHighlight"));
            };
            if (_arg_1 != this.mPanel.orderBtn1)
            {
                this.mPanel.orderBtn1.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            }
            else
            {
                this.mPanel.orderBtn1.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundHighlight"));
            };
            if (_arg_1 != this.mPanel.orderBtn2)
            {
                this.mPanel.orderBtn2.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            }
            else
            {
                this.mPanel.orderBtn2.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundHighlight"));
            };
        }

        private function Order(_arg_1:Event):void
        {
            var _local_2:dTimedProductionVO = new dTimedProductionVO();
            _local_2.productionType = this.mProductionType;
            _local_2.type_string = this.mSelectedSkillPoint.id_string;
            _local_2.amount = 1;
            _local_2.buildingGrid = this.mBuilding.GetGrid();
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.START_TIMED_PRODUCTION, this.mGI.mCurrentViewedZoneID, _local_2);
            this.mBuilding.productionQueue.SetWaitingForServer(true);
            this.mPanel.busy = true;
            this.mPanel.control.visible = false;
        }

        private function setOrder(_arg_1:SkillpointDefinition):void
        {
            var _local_6:SkillpointLevelDefinition;
            var _local_7:cBuffDefinition;
            var _local_9:BuffAppliance;
            var _local_10:Vector.<dResource>;
            var _local_11:cResources;
            var _local_12:int;
            this.mSelectedSkillPoint = _arg_1;
            if (this.mSelectedSkillPoint == null)
            {
                this.mPanel.bookSelected = false;
                return;
            };
            this.mPanel.bookSelected = true;
            var _local_2:cPlayerData = global.ui.mCurrentPlayer;
            var _local_3:int = global.ui.mCurrentPlayerZone.GetResources(_local_2).GetPlayerResource(_arg_1.id_string).producedAmount;
            var _local_4:SkillpointLevelDefinition = _arg_1.levels_vector[0];
            var _local_5:SkillpointLevelDefinition = _arg_1.levels_vector[0];
            for each (_local_6 in _arg_1.levels_vector)
            {
                if (_local_6.amountProduced <= _local_3)
                {
                    _local_4 = _local_6;
                };
                if (_local_6.amountProduced <= (_local_3 + 1))
                {
                    _local_5 = _local_6;
                };
            };
            this.mPanel.maxCostReached = (_arg_1.levels_vector.indexOf(_local_4) == (_arg_1.levels_vector.length - 1));
            _local_7 = this.mBuilding.GetUpgradeLevelBonuses();
            if (_local_7 == null)
            {
                gMisc.Assert(false, ((((((("GetUpgradeLevelBonuses() not found for " + this.mBuilding.GetBuildingName_string()) + " (") + this.mBuilding.GetUpgradeLevel()) + ") at ") + this.mBuilding.GetGrid()) + " with GetGOContainer().buildingUpgradeBonuses_vector: ") + this.mBuilding.GetGOContainer().buildingUpgradeBonuses_vector));
            };
            var _local_8:Number = (_local_7.getRecruitingTime() / 100);
            for each (_local_9 in this.mBuilding.mBuffs_vector)
            {
                _local_8 = (_local_8 * (_local_9.GetBuffDefinition().getRecruitingTime() / 100));
            };
            this.mPanel.duration.text = cLocaManager.GetInstance().FormatDuration((_local_4.productionTime / _local_8));
            this.mPanel.nextDuration.text = cLocaManager.GetInstance().FormatDuration((_local_5.productionTime / _local_8));
            _local_10 = _local_4.costs;
            _local_11 = global.ui.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer);
            this.missingResources = new Vector.<dResource>();
            _local_12 = 0;
            while (_local_12 < _local_10.length)
            {
                this.mPanel[("cost" + _local_12)].data = _local_10[_local_12];
                if (!_local_11.HasPlayerResource(_local_10[_local_12].name_string, _local_10[_local_12].amount))
                {
                    this.mPanel[("cost" + _local_12)].amountLabel.setStyle("color", 0xFF0000);
                    this.mPanel.btnProduce.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("Skillpoint_" + _arg_1.id_string));
                    this.missingResources.push(new dResource().Init(_local_10[_local_12].name_string, (_local_10[_local_12].amount - _local_11.GetPlayerResource(_local_10[_local_12].name_string).amount)));
                    this.toolTipClass = cToolTipUtil.MISSING_RESOURCES_string;
                }
                else
                {
                    this.mPanel[("cost" + _local_12)].amountLabel.setStyle("color", 0xFFFFFF);
                };
                _local_12++;
            };
            var _local_13:Vector.<dResource> = _local_5.costs;
            _local_12 = 0;
            while (_local_12 < _local_13.length)
            {
                this.mPanel[("nextCost" + _local_12)].data = _local_13[_local_12];
                if (!_local_11.HasPlayerResource(_local_13[_local_12].name_string, _local_13[_local_12].amount))
                {
                    this.mPanel[("nextCost" + _local_12)].amountLabel.setStyle("color", 0xFF0000);
                }
                else
                {
                    this.mPanel[("nextCost" + _local_12)].amountLabel.setStyle("color", 0xFFFFFF);
                };
                _local_12++;
            };
            var _local_14:dResource = new dResource();
            _local_14.name_string = _arg_1.id_string;
            _local_14.amount = 1;
            this.mPanel.orderBook.data = _local_14;
            this.mPanel.nextOrderBook.data = _local_14;
            if (((this.mBuilding.productionQueue == null) || (this.mBuilding.productionQueue.mTimedProductions_vector.length == 0)))
            {
                this.mPanel.control.visible = true;
                this.mPanel.production.visible = false;
                this.mPanel.pickUp.visible = false;
            }
            else
            {
                this.mPanel.control.visible = false;
            };
            var _local_15:dRequirementsVO = (global.ui as cGameInterface).mRequirements.timedProductionRequirements_vector[_arg_1.id_string];
            if (_local_15.isFulfilled())
            {
                this.mPanel.btnProduce.enabled = _local_11.HasPlayerResourcesInList(_local_4.costs, 1);
                this.mPanel.btnProduce.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Produce");
            }
            else
            {
                this.mPanel.btnProduce.enabled = false;
                this.mPanel.btnProduce.toolTip = _local_15.locaString;
                this.toolTipClass = cToolTipUtil.SIMPLE_ERROR_string;
            };
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen(((mUiElement.id + ".") + this.mSelectedSkillPoint.id_string));
        }

        public function UpdateResources():void
        {
            var _local_1:cResources;
            trace("skill prod updateresources");
            if (this.mPanel.production.visible == false)
            {
                _local_1 = this.mGI.mCurrentPlayerZone.getResourcesFromCurrentZone();
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:cTimedProduction;
            if (_arg_2 == cTimedProductionQueue.PRODUCTION_START)
            {
                _local_4 = (_arg_3 as cTimedProduction);
                this.mPanel.production.visible = true;
                this.setProductionOrder(_local_4, this.colors[_local_4.GetType()]);
                this.mPanel.busyAnim.visible = false;
                this.mPanel.busy = false;
            }
            else
            {
                if (_arg_2 == cTimedProductionQueue.PRODUCTION_FINISH)
                {
                    this.mPanel.production.visible = false;
                    this.mPanel.busy = false;
                    this.setOrder(this.mSelectedSkillPoint);
                }
                else
                {
                    if (_arg_2 == cResources.RESOURCE_CHANGE)
                    {
                        this.UpdateResources();
                    };
                };
            };
        }

        private function createSelectTooltip(_arg_1:ToolTipEvent):void
        {
            var _local_2:MissingResourcesTooltipData;
            var _local_3:String;
            var _local_4:String;
            if (!this.mPanel.btnProduce.enabled)
            {
                if (this.toolTipClass == cToolTipUtil.MISSING_RESOURCES_string)
                {
                    _local_3 = this.mPanel.btnProduce.toolTip;
                    _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.toolTipClass);
                    _local_2 = new MissingResourcesTooltipData(_local_3, _local_4, this.missingResources);
                    cToolTipUtil.createToolTip(this.toolTipClass, _arg_1, _local_2);
                }
                else
                {
                    if (this.toolTipClass == cToolTipUtil.SIMPLE_ERROR_string)
                    {
                        cToolTipUtil.createToolTip(this.toolTipClass, _arg_1, true);
                    };
                };
            }
            else
            {
                cToolTipUtil.createToolTip(cToolTipUtil.SIMPLE_string, _arg_1);
            };
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        private function setProductionOrder(_arg_1:cTimedProduction, _arg_2:uint):void
        {
            this.mOrder = _arg_1;
            this.mPanel.instantBuildCost = _arg_1.GetInstantBuildCosts();
            this.mPanel.instantBuildCostUnmodified = _arg_1.GetInstantBuildCostsUnmodified();
            if (((this.watcher == null) && (!(this.mOrder.mProductionProgress == 1))))
            {
                this.watcher = ChangeWatcher.watch(this.mOrder, "mProductionProgress", this.onProgressChange);
            };
            this.mPanel.productionItem.filters = [coloringFilter(_arg_2)];
            this.mPanel.pickUpItem.filters = [coloringFilter(_arg_2)];
            this.mPanel.progressBar.visible = (!(this.mOrder.mProductionProgress == 1));
            this.mPanel.progressTime.visible = this.mPanel.progressBar.visible;
            this.mPanel.productionIcon.source = gAssetManager.GetResourceIcon(this.mOrder.GetType());
            this.mPanel.productionIcon.visible = (!(_arg_1.GetWaitingForServer()));
            this.mPanel.pickUp.visible = (!(this.mPanel.progressBar.visible));
            this.mPanel.pickUp.enabled = (!(_arg_1.GetWaitingForServer()));
            this.mPanel.pickUpIcon.source = gAssetManager.GetResourceIcon(_arg_1.GetType());
            this.mPanel.pickUpIcon.visible = this.mPanel.pickUp.visible;
            this.mPanel.control.visible = false;
            this.mPanel.bookSelected = false;
            this.mPanel.orderBtn0.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            this.mPanel.orderBtn1.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            this.mPanel.orderBtn2.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            this.mSelectedSkillPoint = null;
            this.onProgressChange();
        }

        private function unwatch():void
        {
            if (this.watcher != null)
            {
                this.watcher.unwatch();
                this.watcher = null;
            };
        }

        public function refresh():void
        {
            var _local_1:cBuilding;
            if (this.mBuilding)
            {
                this.unwatch();
                this.mBuilding.productionQueue.removePropertyObserver(cTimedProductionQueue.PRODUCTION_START, this);
                this.mBuilding.productionQueue.removePropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, this);
                _local_1 = global.ui.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mBuilding.GetGrid());
                if (_local_1 == null)
                {
                    _local_1 = this.mBuilding;
                };
                _local_1.productionQueue.addPropertyObserver(cTimedProductionQueue.PRODUCTION_START, this);
                _local_1.productionQueue.addPropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, this);
                this.SetData(_local_1);
            };
        }

        private function SelectOrder0(_arg_1:MouseEvent):void
        {
            this.selectOrderStyles((_arg_1.currentTarget as Canvas));
            this.setOrder(global.skillPoints_vector[0]);
        }

        override public function Hide():void
        {
            this.unwatch();
            this.mBuilding.productionQueue.removePropertyObserver(cTimedProductionQueue.PRODUCTION_START, this);
            this.mBuilding.productionQueue.removePropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, this);
            this.mGI.mCurrentPlayerZone.getResourcesFromCurrentZone().removePropertyObserver(cResources.RESOURCE_CHANGE, this);
            super.Hide();
            this.mPanel.control.visible = false;
            this.mPanel.orderBtn0.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            this.mPanel.orderBtn1.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            this.mPanel.orderBtn2.setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            this.mSelectedSkillPoint = null;
        }

        private function SelectOrder1(_arg_1:MouseEvent):void
        {
            this.selectOrderStyles((_arg_1.currentTarget as Canvas));
            this.setOrder(global.skillPoints_vector[1]);
        }

        private function SelectOrder2(_arg_1:MouseEvent):void
        {
            this.selectOrderStyles((_arg_1.currentTarget as Canvas));
            this.setOrder(global.skillPoints_vector[2]);
        }

        private function RollOut(_arg_1:MouseEvent):void
        {
            if (this.orderSelected != _arg_1.currentTarget)
            {
                (_arg_1.currentTarget as Canvas).setStyle("backgroundImage", gAssetManager.GetClass("BackgroundNormal"));
            };
        }

        private function onProgressChange(_arg_1:Event=null):void
        {
            if (((!(this.mOrder == null)) && (this.mOrder.mProductionProgress == 1)))
            {
                this.unwatch();
                this.mPanel.production.visible = false;
                this.mPanel.pickUp.visible = (!(this.mPanel.progressBar.visible));
                this.mPanel.pickUp.enabled = (!(this.mOrder.GetWaitingForServer()));
            }
            else
            {
                this.mPanel.production.visible = true;
                this.mPanel.progressBar.value = this.mOrder.mProductionProgress;
                this.mPanel.progressBar.validateNow();
                this.mPanel.progressTime.text = cLocaManager.GetInstance().FormatDuration((((1 - this.mOrder.mProductionProgress) * this.mOrder.GetProductionTime()) / (this.mOrder.GetProductionOrder().GetTimeBonus() * global.ui.mGlobalTimeScale)));
            };
            this.mPanel.control.visible = false;
        }


    }
}
