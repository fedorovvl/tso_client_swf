package GUI.GAME
{
    import Model.Observer;
    import mx.controls.TextInput;
    import Interface.cGameInterface;
    import GUI.Components.TimedProductionInfoPanel;
    import GO.cBuilding;
    import TimedProduction.iTimedProductionDefinition;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import BuffSystem.cBuffDefinition;
    import TimedProduction.EffectTimedProductionDefinition;
    import MilitarySystem.cMilitaryUnitDescription;
    import flash.events.MouseEvent;
    import mx.events.SliderEvent;
    import mx.events.FlexEvent;
    import com.bluebyte.tso.util.HotkeyManager;
    import Enums.TIMED_PRODUCTION_TYPE;
    import TimedProduction.cTimedProduction;
    import Communication.VO.dQuestElementVO;
    import MilitarySystem.cMilitaryUnitData;
    import BuffSystem.cBuff;
    import BuffSystem.BuffAdventureController;
    import nLib.gMisc;
    import Utils.RequirementsHelper;
    import flash.events.Event;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import Communication.VO.dContextItemVO;
    import Enums.COMMAND;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import mx.events.ListEvent;
    import Enums.ONE_CLICK_SHOPITEM;
    import ServerState.cResources;
    import Communication.VO.dBuyOneClickShopItemVO;
    import Communication.VO.dTimedProductionQueueChangeVO;
    import BuffSystem.BuffAppliance;
    import Communication.VO.dPersistedBuffApplianceVO;
    import Skill.cSkillList;
    import Skill.cSkill;
    import ServerState.dResource;
    import Modifier.ModifierVO;
    import GUI.Effects.gHintManager;
    import Modifier.Modifiers.Productions.ProductionTimes;
    import TimedProduction.cTimedProductionQueue;
    import mx.collections.ArrayCollection;
    import mx.events.ItemClickEvent;
    import mx.events.CloseEvent;
    import Communication.VO.dTimedProductionVO;
    import Model.Notifier;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import ServerState.cPlayerData;
    import __AS3__.vec.*;

    public class cTimedProductionInfoPanel extends cBasicInfoPanel implements Observer 
    {

        public static const MOVE_UP:String = "ProductionMoveUp";
        public static const MOVE_DOWN:String = "ProductionMoveDown";
        public static const CONTEXT_MENU:String = "ProductionContextMenu";
        public static const REMOVE:String = "ProductionRemove";
        public static const INSTANT_FINISH:String = "ProductionInstantFinish";
        private static const NUM_UNIT_TIERS:int = 4;

        private var mSelectedTabIndex:int = 0;
        private var defaultInput:TextInput;
        private var mGI:cGameInterface;
        protected var mUpgradeTooltip:String;
        protected var mPanel:TimedProductionInfoPanel;
        private var mCurrentSelectedUnitTier:int = 3;
        protected var mBuilding:cBuilding;
        private var mSelectedOrderProductionTime:Number = 1;
        private var mShowMiddleColumnBarracks:Boolean = false;
        protected var mProductionType:int;
        private var mSelectedOrderType:iTimedProductionDefinition;
        private var defaultAmount:int;


        private function EnterManageOrderState(_arg_1:FlexEvent):void
        {
            this.mPanel.selectedUnitIcon.source = gAssetManager.GetResourceIcon(this.mSelectedOrderType.GetType());
            this.mPanel.selectedUnitIcon.toolTip = "";
            this.mPanel.selectedUnitIcon2.source = gAssetManager.GetResourceIcon(this.mSelectedOrderType.GetType());
            this.mPanel.selectedUnitIcon2.toolTip = "";
            this.mPanel.selectedUnitName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.mSelectedOrderType.GetType());
            if ((this.mSelectedOrderType is cBuffDefinition))
            {
                this.mPanel.selectedUnitDescription.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.mSelectedOrderType.GetType(), [(this.mSelectedOrderType as cBuffDefinition).GetAmount().toString(), (this.mSelectedOrderType as cBuffDefinition).GetResourceName_string()]);
            };
            if ((this.mSelectedOrderType is EffectTimedProductionDefinition))
            {
                this.mPanel.selectedUnitDescription.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.mSelectedOrderType.GetType(), [(this.mSelectedOrderType as EffectTimedProductionDefinition).GetProductionAmount().toString(), (this.mSelectedOrderType as EffectTimedProductionDefinition).effects_vector[0].name_string]);
            }
            else
            {
                if ((this.mSelectedOrderType is cMilitaryUnitDescription))
                {
                    this.mPanel.selectedUnitDescription.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.mSelectedOrderType.GetType(), [this.mSelectedOrderType.GetProductionAmount().toString(), this.mSelectedOrderType.GetProductionName_string()]);
                    this.mPanel.selectedUnitIcon.toolTip = this.mSelectedOrderType.GetType();
                    this.mPanel.selectedUnitIcon2.toolTip = this.mSelectedOrderType.GetType();
                }
                else
                {
                    this.mPanel.selectedUnitDescription.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, this.mSelectedOrderType.GetType(), [this.mSelectedOrderType.GetProductionAmount().toString(), this.mSelectedOrderType.GetProductionName_string()]);
                };
            };
            this.mPanel.amountSlider.enabled = true;
            this.mPanel.amountSlider.value = 1;
            this.mPanel.amountSlider.minimum = 1;
            this.mPanel.amountSlider.maximum = defines.MAX_PRODUCTION_AMOUNT;
            this.mPanel.stackSlider.enabled = true;
            this.mPanel.stackSlider.value = 1;
            this.mPanel.stackSlider.minimum = 1;
            this.mPanel.stackSlider.maximum = defines.MAX_PRODUCTION_STACKS;
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.Order);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.CancelOrder);
            this.mPanel.amountSlider.addEventListener(SliderEvent.CHANGE, this.CalculateCosts);
            this.mPanel.stackSlider.addEventListener(SliderEvent.CHANGE, this.CalculateCosts);
            this.mPanel.orderCostsList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.ChangedItemList);
            this.mSelectedOrderProductionTime = this.mSelectedOrderType.GetProductionTime();
            this.mPanel.bonusStar.visible = false;
            this.mPanel.orderTime.setStyle("color", "#ffffff");
            HotkeyManager.getInstance().setConfirmActions(this.Order, this.CancelOrder);
            if (TIMED_PRODUCTION_TYPE.isMilitaryProductionType(this.mProductionType))
            {
                this.mPanel.amountSlider.value = this.GetMaximumAffordableAmount();
            };
            this.CalculateCosts();
            this.defaultInput.setSelection(0, 1);
            this.defaultInput.setFocus();
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_5:Array;
            var _local_6:cTimedProduction;
            var _local_7:Array;
            var _local_8:Array;
            var _local_9:dQuestElementVO;
            var _local_10:cBuffDefinition;
            var _local_11:cMilitaryUnitData;
            var _local_12:cMilitaryUnitDescription;
            var _local_13:EffectTimedProductionDefinition;
            var _local_2:String = _arg_1.GetBuildingName_string();
            if (_arg_1.productionQueue.mProductionType != this.mProductionType)
            {
                this.mSelectedTabIndex = 0;
            };
            this.mProductionType = _arg_1.productionQueue.mProductionType;
            this.setCurrentState();
            if (TIMED_PRODUCTION_TYPE.isMilitaryProductionType(this.mProductionType))
            {
                this.defaultAmount = -1;
                this.defaultInput = this.mPanel.stackInput;
            }
            else
            {
                this.defaultAmount = 1;
                this.defaultInput = this.mPanel.amountInput;
            };
            this.mBuilding = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_2);
            this.mPanel.upgradeColumn.SetData(_arg_1, this, this.mPanel);
            this.mPanel.buildingHeader.data = this.mBuilding;
            if (TIMED_PRODUCTION_TYPE.isSimpleProduction(this.mProductionType))
            {
                this.mPanel.middleColumn.height = 210;
                this.mPanel.middleColumn.x = 8;
                this.mPanel.rightColumnRecruite.setStyle("left", 8);
                this.mPanel.width = 485;
                this.mPanel.buildingStacksCanvas.visible = true;
                this.mPanel.buildingStacks.SetData(this.mBuilding, "DuplicatedBuildingSimpleProductionTip");
                this.mPanel.upgradeColumnCanvas.visible = false;
            }
            else
            {
                this.mPanel.middleColumn.height = 294;
                this.mPanel.middleColumn.x = 166;
                this.mPanel.rightColumnRecruite.setStyle("left", 166);
                this.mPanel.width = 640;
                this.mPanel.upgradeColumnCanvas.visible = true;
                this.mPanel.buildingStacksCanvas.visible = ((!(_arg_1.productionQueue == null)) && (_arg_1.productionQueue.hasStackingBonus));
                if (this.mPanel.buildingStacksCanvas.visible)
                {
                    this.mPanel.buildingStacks.SetData(this.mBuilding, "DuplicatedBuildingTimedProductionTip");
                    this.mPanel.buildingStacks.titleLoca = "ExpansionBonus";
                    this.mPanel.middleColumn.height = 210;
                }
                else
                {
                    this.mPanel.buildingStacks.titleLoca = "DuplicateBonus";
                    this.mPanel.middleColumn.height = 294;
                };
            };
            if (this.mBuilding.productionQueue != null)
            {
                _local_5 = [];
                for each (_local_6 in this.mBuilding.productionQueue.mTimedProductions_vector)
                {
                    _local_5[_local_5.length] = _local_6;
                };
                this.mPanel.currentOrdersList.dataProvider = _local_5;
                this.mPanel.busy = this.mBuilding.productionQueue.GetWaitingForServer();
                this.mPanel.emptyQueue.visible = (_local_5.length == 0);
            }
            else
            {
                this.mPanel.currentOrdersList.dataProvider = null;
                this.mPanel.emptyQueue.visible = true;
            };
            var _local_3:Array = [];
            var _local_4:Array = [];
            switch (this.mProductionType)
            {
                case TIMED_PRODUCTION_TYPE.BUFF:
                case TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS:
                case TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS_2:
                    for each (_local_10 in cBuff.GetProduceableBuffDefinitions(this.mGI))
                    {
                        if ((((_local_3.indexOf(_local_10.GetGroup_string()) == -1) && ((((this.mProductionType == TIMED_PRODUCTION_TYPE.BUFF) && ((!(_local_10.GetGroup_string() == "5")) && (!(_local_10.GetGroup_string() == "11")))) || ((this.mProductionType == TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS) && (_local_10.GetGroup_string() == "5"))) || ((this.mProductionType == TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS_2) && (_local_10.GetGroup_string() == "11")))) && (!(BuffAdventureController.isBuffAdventureBuff(_local_10.GetName_string())))))
                        {
                            _local_3.push(_local_10.GetGroup_string());
                            _local_4.push({
                                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("BuffGroup" + _local_10.GetGroup_string())),
                                "group":_local_10.GetGroup_string()
                            });
                        };
                    };
                    if (((!(this.mProductionType == TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS)) && (!(this.mProductionType == TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS_2))))
                    {
                        this.AddBuffAdventureGroup(_local_4);
                    };
                    _local_4.sort(this.SortGroups);
                    this.mPanel.buttonBar.visible = (_local_4.length > 1);
                    this.mPanel.buttonBar.dataProvider = _local_4;
                    this.mPanel.buttonBar.selectedIndex = this.mSelectedTabIndex;
                    this.SetFilteredReciepeList();
                    this.mUpgradeTooltip = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "UpgradeProvisionhouse");
                    return;
                case TIMED_PRODUCTION_TYPE.COMBAT_THREE_UNITS:
                    for each (_local_11 in cMilitaryUnitData.GetAllUnitDataByTier(true, this.mCurrentSelectedUnitTier))
                    {
                        if (_local_3.indexOf(_local_11.GetGroup()) == -1)
                        {
                            _local_3.push(_local_11.GetGroup());
                            _local_4.push({
                                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_11.GetGroup()),
                                "group":_local_11.GetGroup()
                            });
                        };
                    };
                    this.mPanel.buttonBar.visible = (_local_4.length > 1);
                    this.mPanel.buttonBar.dataProvider = _local_4;
                    this.mPanel.buttonBar.selectedIndex = this.mSelectedTabIndex;
                    this.SetFilteredReciepeList();
                    return;
                case TIMED_PRODUCTION_TYPE.MILITARY_UNIT:
                case TIMED_PRODUCTION_TYPE.ELITE_UNITS:
                    this.mPanel.buttonBar.dataProvider = null;
                    _local_7 = [];
                    for each (_local_12 in cMilitaryUnitDescription.GetAllUnitDescriptions(true))
                    {
                        if ((((_local_12.GetIsElite()) && (this.mProductionType == TIMED_PRODUCTION_TYPE.ELITE_UNITS)) || ((!(_local_12.GetIsElite())) && (this.mProductionType == TIMED_PRODUCTION_TYPE.MILITARY_UNIT))))
                        {
                            _local_7.push([_local_12, this.GetAmountInProduction(_local_12)]);
                        };
                    };
                    this.mPanel.availableOrdersList.dataProvider = _local_7;
                    this.mPanel.availableOrdersList.windowID = "";
                    this.mUpgradeTooltip = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "UpgradeBarracks");
                    return;
                default:
                    this.mPanel.buttonBar.dataProvider = null;
                    _local_8 = gMisc.iterableToArray(global.timedProductions_vector[this.mProductionType]);
                    _local_9 = null;
                    for each (_local_13 in _local_8)
                    {
                        if ((((_local_3.indexOf(_local_13.GetGroup()) == -1) && (RequirementsHelper.checkRequirements(this.mGI, _local_13.requiresEvent, _local_13.requiresQuest))) && (!(BuffAdventureController.isBuffAdventureBuff(_local_13.GetProductionName_string())))))
                        {
                            _local_3.push(_local_13.GetGroup());
                            _local_4.push({
                                "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ((TIMED_PRODUCTION_TYPE.toString(this.mProductionType) + "Group") + _local_13.GetGroup())),
                                "group":_local_13.GetGroup()
                            });
                        };
                    };
                    if (((this.mProductionType == TIMED_PRODUCTION_TYPE.BUFF) || (this.mProductionType == TIMED_PRODUCTION_TYPE.RARE_BUFFS)))
                    {
                        this.AddBuffAdventureGroup(_local_4);
                    };
                    _local_4.sort(this.SortGroups);
                    this.mPanel.buttonBar.visible = (_local_4.length > 1);
                    this.mPanel.buttonBar.dataProvider = _local_4;
                    this.mPanel.buttonBar.selectedIndex = this.mSelectedTabIndex;
                    this.SetFilteredReciepeList();
                    this.mUpgradeTooltip = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "UpgradeProvisionhouse");
            };
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function ProductionContextMenu(_event:ListEvent):void
        {
            var pos:Point = _event.itemRenderer.localToGlobal(new Point((_event.itemRenderer.width / 2), _event.itemRenderer.height));
            var items:Vector.<dContextItemVO> = new Vector.<dContextItemVO>();
            items.push(new dContextItemVO("ProductionMoveToTop", function ():void
            {
                ProductionMove(_event, COMMAND.PRODUCTION_MOVE_TOP);
            }, (_event.rowIndex > 1), "ProductionMoveToTop"));
            items.push(new dContextItemVO("ProductionMoveToBottom", function ():void
            {
                ProductionMove(_event, COMMAND.PRODUCTION_MOVE_BOTTOM);
            }, (_event.rowIndex < (this.mBuilding.productionQueue.mTimedProductions_vector.length - 1)), "ProductionMoveToBottom"));
            items.push(new dContextItemVO("ProductionCancelAllWaiting", function ():void
            {
                CustomAlert.show("RemoveAllWaitingProductions", "RemoveAllWaitingProductions", (Alert.OK | Alert.CANCEL), null, removeAllWaitingProductions, null, Alert.OK, true);
            }, true, "RemoveAllWaitingProductions"));
            globalFlash.gui.ShowContextMenu(items, pos.x, pos.y);
            _event.preventDefault();
        }

        public function setCurrentState():void
        {
            if (((!(this.mBuilding == null)) && (this.mBuilding.productionQueue.hasStackingBonus)))
            {
                this.mPanel.currentState = "stateNormalWithBonus";
                this.mPanel.buildingStacksCanvas.x = (((!(this.mBuilding == null)) && (this.mBuilding.GetGOContainer().buildingUpgradeBonuses_vector.length == 0)) ? 8 : 166);
            }
            else
            {
                this.mPanel.currentState = "defaultState";
                this.mPanel.buildingStacksCanvas.visible = false;
                this.mPanel.buildingStacksCanvas.x = 166;
            };
        }

        private function productionInstantFinish(_arg_1:ListEvent):void
        {
            var _local_2:cTimedProduction = this.mBuilding.productionQueue.mTimedProductions_vector[0];
            var _local_3:int;
            if (this.mProductionType == TIMED_PRODUCTION_TYPE.MILITARY_UNIT)
            {
                _local_3 = ONE_CLICK_SHOPITEM.INSTANT_BARRACKS_PRODUCTION;
            }
            else
            {
                if (this.mProductionType == TIMED_PRODUCTION_TYPE.BUFF)
                {
                    _local_3 = ONE_CLICK_SHOPITEM.INSTANT_PROVISIONHOUSE_PRODUCTION;
                }
                else
                {
                    if (this.mProductionType == TIMED_PRODUCTION_TYPE.RARE_BUFFS)
                    {
                        _local_3 = ONE_CLICK_SHOPITEM.INSTANT_PROVISIONHOUSE_PRODUCTION;
                    }
                    else
                    {
                        if (this.mProductionType == TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS)
                        {
                            _local_3 = ONE_CLICK_SHOPITEM.INSTANT_EXPEDITION_PRODUCTION;
                        }
                        else
                        {
                            if (this.mProductionType == TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS_2)
                            {
                                _local_3 = ONE_CLICK_SHOPITEM.INSTANT_EXPEDITION_PRODUCTION;
                            }
                            else
                            {
                                if (this.mProductionType == TIMED_PRODUCTION_TYPE.COMBAT_THREE_UNITS)
                                {
                                    _local_3 = ONE_CLICK_SHOPITEM.INSTANT_EXPEDITION_UNIT_PRODUCTION;
                                }
                                else
                                {
                                    if (this.mProductionType == TIMED_PRODUCTION_TYPE.ELITE_UNITS)
                                    {
                                        _local_3 = ONE_CLICK_SHOPITEM.INSTANT_ELITE_UNIT_PRODUCTION;
                                    }
                                    else
                                    {
                                        if (TIMED_PRODUCTION_TYPE.isSimpleProduction(this.mProductionType))
                                        {
                                            _local_3 = ONE_CLICK_SHOPITEM.INSTANT_SIMPLE_TIMED_PRODUCTION;
                                        }
                                        else
                                        {
                                            if (TIMED_PRODUCTION_TYPE.isTimedProduction(this.mProductionType))
                                            {
                                                _local_3 = ONE_CLICK_SHOPITEM.INSTANT_PROVISIONHOUSE_PRODUCTION;
                                            }
                                            else
                                            {
                                                _local_3 = ONE_CLICK_SHOPITEM.INVALID_SHOPITEM;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            var _local_4:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            if (_local_4.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_2.GetInstantBuildCosts()))
            {
                this.mBuilding.productionQueue.SetAllProductionWaitingForServer(true);
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, this.mGI.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().InitWithBuildingGrid(_local_3, this.mBuilding.GetGrid()));
            }
            else
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
        }

        private function productionRemove(_arg_1:ListEvent):void
        {
            var _local_2:cTimedProduction = this.mBuilding.productionQueue.mTimedProductions_vector[_arg_1.rowIndex];
            this.mBuilding.productionQueue.SetAllProductionWaitingForServer(true);
            var _local_3:dTimedProductionQueueChangeVO = new dTimedProductionQueueChangeVO();
            _local_3.productionType = this.mProductionType;
            _local_3.itemID = _local_2.GetUniqueID();
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.PRODUCTION_REMOVE, this.mGI.mCurrentViewedZoneID, _local_3);
        }

        private function CalculateCosts(_arg_1:SliderEvent=null):void
        {
            var _local_9:BuffAppliance;
            var _local_10:dPersistedBuffApplianceVO;
            var _local_11:cSkillList;
            var _local_12:cSkill;
            var _local_14:dResource;
            var _local_15:cBuffDefinition;
            var _local_16:Vector.<ModifierVO>;
            var _local_17:ModifierVO;
            var _local_18:String;
            var _local_19:int;
            var _local_20:cResources;
            if (!this.mSelectedOrderType)
            {
                return;
            };
            gHintManager.HideHintsForParent(this.mPanel.orderCostsList, false);
            var _local_2:Vector.<dResource> = this.mSelectedOrderType.GetCosts_vector();
            var _local_3:Array = [];
            var _local_4:Boolean = true;
            var _local_5:int = (this.mPanel.amountSlider.value * this.mPanel.stackSlider.value);
            this.mPanel.btnOK.enabled = true;
            var _local_6:Number = 1;
            var _local_7:Number = 1;
            var _local_8:Number = 1;
            if (this.mBuilding.GetUpgradeLevelBonuses() != null)
            {
                _local_6 = (_local_6 * (this.mBuilding.GetUpgradeLevelBonuses().getRecruitingTime() / 100));
            };
            for each (_local_9 in this.mBuilding.mBuffs_vector)
            {
                _local_7 = (_local_7 * (_local_9.GetBuffDefinition().getRecruitingTime() / 100));
            };
            for each (_local_10 in this.mGI.mZoneBuffManager.getBuffAppliancesForBuilding(this.mBuilding.GetBuildingName_string()))
            {
                _local_15 = cBuffDefinition.GetById(_local_10.buffID);
                if (_local_15 != null)
                {
                    _local_7 = (_local_7 + ((_local_15.getRecruitingTime() - 100) / 100));
                };
            };
            _local_11 = this.mGI.mCurrentPlayer.getSkills();
            for each (_local_12 in _local_11.getItems_vector())
            {
                for each (_local_16 in _local_12.getDefinition().level_vector)
                {
                    for each (_local_17 in _local_16)
                    {
                        if (_local_17.modifier_string == ProductionTimes.xml_string)
                        {
                            _local_18 = "invalid";
                            if ((this.mSelectedOrderType is cBuffDefinition))
                            {
                                _local_19 = new int((this.mSelectedOrderType as cBuffDefinition).GetGroup_string());
                                _local_18 = TIMED_PRODUCTION_TYPE.toString((((_local_19 == 11) || (_local_19 == 5)) ? TIMED_PRODUCTION_TYPE.COMBAT_THREE_WEAPONS : TIMED_PRODUCTION_TYPE.BUFF));
                            }
                            else
                            {
                                if ((this.mSelectedOrderType is EffectTimedProductionDefinition))
                                {
                                    _local_18 = TIMED_PRODUCTION_TYPE.toString(this.mBuilding.productionQueue.mProductionType);
                                }
                                else
                                {
                                    if ((this.mSelectedOrderType is cMilitaryUnitDescription))
                                    {
                                        _local_18 = TIMED_PRODUCTION_TYPE.toString((((this.mSelectedOrderType as cMilitaryUnitDescription).GetIsElite()) ? TIMED_PRODUCTION_TYPE.ELITE_UNITS : TIMED_PRODUCTION_TYPE.MILITARY_UNIT));
                                    }
                                    else
                                    {
                                        if ((this.mSelectedOrderType is cMilitaryUnitData))
                                        {
                                            _local_18 = TIMED_PRODUCTION_TYPE.toString(TIMED_PRODUCTION_TYPE.COMBAT_THREE_UNITS);
                                        };
                                    };
                                };
                            };
                            if ((((_local_17.type_string == "") || (_local_17.type_string == _local_18)) && ((_local_17.item_string == "") || (_local_17.item_string == this.mSelectedOrderType.GetType()))))
                            {
                                _local_8 = (_local_8 * _local_17.multiplier);
                            };
                        };
                    };
                };
            };
            if (_local_8 != 1)
            {
                this.mPanel.bonusStar.visible = true;
                this.mPanel.bonusStar.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TimedInfoPanelOrderBonus", [Math.round(((1 - _local_8) * 100))]);
                this.mPanel.orderTime.setStyle("color", "#4cf002");
            };
            var _local_13:Number = (((this.mSelectedOrderProductionTime * _local_5) / (_local_6 * _local_7)) * _local_8);
            this.mPanel.orderTime.text = cLocaManager.GetInstance().FormatDuration(_local_13, cLocaManager.DURATION_FORMAT_SHORT);
            for each (_local_14 in _local_2)
            {
                _local_20 = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
                if (_local_14.name_string == defines.POPULATION_RESOURCE_NAME_string)
                {
                    _local_4 = (_local_20.GetFree() >= (_local_5 * _local_14.amount));
                }
                else
                {
                    _local_4 = _local_20.HasPlayerResource(_local_14.name_string, (_local_5 * _local_14.amount));
                };
                _local_3.push({
                    "amount":_local_5,
                    "resource":_local_14,
                    "canAfford":_local_4,
                    "inStorage":_local_20.GetResourceAmount(_local_14.name_string)
                });
                if (((this.mPanel.btnOK.enabled) && (!(_local_4))))
                {
                    this.mPanel.btnOK.enabled = false;
                };
            };
            this.mPanel.orderCostsList.dataProvider = _local_3;
            _local_14 = new dResource();
            _local_14.name_string = this.mSelectedOrderType.GetProductionName_string();
            _local_14.amount = this.mSelectedOrderType.GetProductionAmount();
            this.mPanel.orderProductList.dataProvider = [{
                "amount":_local_5,
                "resource":_local_14,
                "canAfford":true
            }];
        }

        override public function Show():void
        {
            this.setCurrentState();
            this.mPanel.x = ((global.getApplication().stage.width / 2) - (this.mPanel.width / 2));
            this.mPanel.y = Math.max(34, (((global.getApplication().stage.height / 2) - (this.mPanel.height / 2)) - globalFlash.mainHudBottomPos));
            super.Show();
            if (this.mBuilding != null)
            {
                this.mBuilding.productionQueue.addPropertyObserver(cTimedProductionQueue.PRODUCTION_START, this);
                this.mBuilding.productionQueue.addPropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, this);
                notifyPropertyObserver("show", ((mUiElement.id + "|") + this.mBuilding.GetBuildingName_string()));
            };
        }

        private function SetFilteredReciepeList(_arg_1:ItemClickEvent=null):void
        {
            var _local_4:cMilitaryUnitData;
            var _local_5:cBuffDefinition;
            var _local_6:EffectTimedProductionDefinition;
            var _local_7:cBuffDefinition;
            var _local_2:Array = [];
            if (_arg_1)
            {
                this.mSelectedTabIndex = _arg_1.index;
            };
            var _local_3:String = (this.mPanel.buttonBar.dataProvider as ArrayCollection).getItemAt(this.mSelectedTabIndex).group;
            if (this.IsVisible())
            {
                gHintManager.HideHintsForParent(this.mPanel.availableOrdersList, true);
            };
            if (this.mProductionType == TIMED_PRODUCTION_TYPE.COMBAT_THREE_UNITS)
            {
                for each (_local_4 in cMilitaryUnitData.GetAllUnitDataByTier(true, this.mCurrentSelectedUnitTier))
                {
                    if (_local_4.GetGroup() == _local_3)
                    {
                        _local_2.push([_local_4, this.GetAmountInProduction(_local_4), this.mBuilding]);
                    };
                };
            }
            else
            {
                if (this.mProductionType == TIMED_PRODUCTION_TYPE.BUFF)
                {
                    for each (_local_5 in cBuff.GetProduceableBuffDefinitions(this.mGI))
                    {
                        if (_local_5.GetGroup_string() == _local_3.toString())
                        {
                            if (BuffAdventureController.isActiveBuffAdventureBuffOrNormalBuff(_local_5.GetName_string()))
                            {
                                _local_2.push([_local_5, this.GetAmountInProduction(_local_5), this.mBuilding]);
                            };
                        };
                    };
                }
                else
                {
                    if ((((this.mProductionType == TIMED_PRODUCTION_TYPE.RARE_BUFFS) || (TIMED_PRODUCTION_TYPE.isSimpleProduction(this.mProductionType))) || (TIMED_PRODUCTION_TYPE.isTimedProduction(this.mProductionType))))
                    {
                        for each (_local_6 in gMisc.iterableToArray(global.timedProductions_vector[this.mProductionType]))
                        {
                            if (((((_local_6.GetGroup().toString() == _local_3) && (RequirementsHelper.checkRequirements(this.mGI, _local_6.requiresEvent, _local_6.requiresQuest))) && (this.mBuilding.GetUpgradeLevel() >= _local_6.requiresUpgradeLevelMin)) && (this.mBuilding.GetUpgradeLevel() <= _local_6.requiresUpgradeLevelMax)))
                            {
                                if (BuffAdventureController.isActiveBuffAdventureBuffOrNormalBuff(_local_6.GetProductionName_string()))
                                {
                                    _local_2.push([_local_6, this.GetAmountInProduction(_local_6), this.mBuilding]);
                                };
                            };
                        };
                    }
                    else
                    {
                        for each (_local_7 in cBuff.GetProduceableBuffDefinitions(this.mGI))
                        {
                            if (_local_7.GetGroup_string() == _local_3)
                            {
                                _local_2.push([_local_7, this.GetAmountInProduction(_local_7), this.mBuilding]);
                            };
                        };
                    };
                };
            };
            this.mPanel.availableOrdersList.dataProvider = _local_2;
            this.mPanel.availableOrdersList.windowID = ((this.mPanel.id + ".") + _local_3);
            this.setCurrentState();
        }

        private function ChangedItemList(_arg_1:FlexEvent):void
        {
            gHintManager.TryRemainingHints();
        }

        private function removeAllWaitingProductions(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.PRODUCTION_CANCEL_ALL_WAITING, this.mGI.mCurrentViewedZoneID, this.mProductionType);
                this.mBuilding.productionQueue.SetAllProductionWaitingForServer(true);
            };
        }

        public function Init(_arg_1:TimedProductionInfoPanel, _arg_2:Boolean=false):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mShowMiddleColumnBarracks = _arg_2;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function SortGroups(_arg_1:Object, _arg_2:Object):int
        {
            return (parseInt(_arg_1.group) - parseInt(_arg_2.group));
        }

        private function Order(_arg_1:MouseEvent=null):void
        {
            if (!this.mPanel.btnOK.enabled)
            {
                return;
            };
            var _local_2:dTimedProductionVO = new dTimedProductionVO();
            _local_2.productionType = this.mProductionType;
            _local_2.type_string = this.mSelectedOrderType.GetType();
            _local_2.amount = this.mPanel.amountSlider.value;
            _local_2.stacks = this.mPanel.stackSlider.value;
            _local_2.buildingGrid = this.mBuilding.GetGrid();
            this.mSelectedOrderType = null;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.START_TIMED_PRODUCTION, this.mGI.mCurrentViewedZoneID, _local_2);
            this.mBuilding.productionQueue.SetWaitingForServer(true);
            this.SetData(this.mBuilding);
            this.CancelOrder();
        }

        private function IncreaseCurrentTier(_arg_1:Event):void
        {
            if (this.mCurrentSelectedUnitTier < NUM_UNIT_TIERS)
            {
                this.mCurrentSelectedUnitTier++;
            };
        }

        public function Refresh():void
        {
            var _local_1:cBuilding;
            if (this.mBuilding)
            {
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

        private function ProductionMoveUp(_arg_1:ListEvent):void
        {
            this.ProductionMove(_arg_1, COMMAND.PRODUCTION_MOVE_UP);
        }

        private function GetAmountInProduction(_arg_1:iTimedProductionDefinition):int
        {
            var _local_4:cTimedProduction;
            var _local_2:String = _arg_1.GetProductionSourceName_string();
            var _local_3:int;
            for each (_local_4 in this.mBuilding.productionQueue.mTimedProductions_vector)
            {
                if (_local_4.GetType() == _local_2)
                {
                    _local_3 = (_local_3 + _local_4.GetAmount());
                };
            };
            return (_local_3);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:Array;
            var _local_5:int;
            if (((_arg_2 == cTimedProductionQueue.PRODUCTION_START) || (_arg_2 == cTimedProductionQueue.PRODUCTION_FINISH)))
            {
                _local_4 = gMisc.iterableToArray(this.mBuilding.productionQueue.mTimedProductions_vector);
                _local_5 = this.mPanel.currentOrdersList.verticalScrollPosition;
                this.mPanel.currentOrdersList.dataProvider = _local_4;
                this.mPanel.currentOrdersList.verticalScrollPosition = _local_5;
                this.mPanel.busy = this.mBuilding.productionQueue.GetWaitingForServer();
                this.mPanel.emptyQueue.visible = (_local_4.length == 0);
            };
        }

        private function ProductionMove(_arg_1:ListEvent, _arg_2:int):void
        {
            var _local_3:cTimedProduction = this.mBuilding.productionQueue.mTimedProductions_vector[_arg_1.rowIndex];
            this.mBuilding.productionQueue.SetAllProductionWaitingForServer(true);
            var _local_4:dTimedProductionQueueChangeVO = new dTimedProductionQueueChangeVO();
            _local_4.productionType = this.mProductionType;
            _local_4.itemID = _local_3.GetUniqueID();
            this.mGI.mClientMessages.SendMessagetoServer(_arg_2, this.mGI.mCurrentViewedZoneID, _local_4);
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.stateManageOrders.addEventListener(FlexEvent.ENTER_STATE, this.EnterManageOrderState);
            this.mPanel.currentOrdersList.addEventListener(cTimedProductionInfoPanel.MOVE_UP, this.ProductionMoveUp);
            this.mPanel.currentOrdersList.addEventListener(cTimedProductionInfoPanel.MOVE_DOWN, this.ProductionMoveDown);
            this.mPanel.currentOrdersList.addEventListener(cTimedProductionInfoPanel.CONTEXT_MENU, this.ProductionContextMenu);
            this.mPanel.currentOrdersList.addEventListener(cTimedProductionInfoPanel.REMOVE, this.productionRemove);
            this.mPanel.currentOrdersList.addEventListener(cTimedProductionInfoPanel.INSTANT_FINISH, this.productionInstantFinish);
            this.mPanel.availableOrdersList.addEventListener(ListEvent.ITEM_CLICK, this.SelectOrderType);
            this.mPanel.availableOrdersList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.ChangedItemList);
            this.mPanel.buttonBar.addEventListener(ListEvent.ITEM_CLICK, this.SetFilteredReciepeList);
            this.mPanel.buttonBar.addEventListener(FlexEvent.UPDATE_COMPLETE, this.ChangedItemList);
            EnableDragging();
        }

        private function ProductionMoveDown(_arg_1:ListEvent):void
        {
            this.ProductionMove(_arg_1, COMMAND.PRODUCTION_MOVE_DOWN);
        }

        private function CancelOrder(_arg_1:MouseEvent=null):void
        {
            this.setCurrentState();
            this.mPanel.setFocus();
            HotkeyManager.getInstance().setConfirmActions(null, this.Hide);
        }

        public function SelectTab(_arg_1:int):void
        {
            this.mPanel.buttonBar.selectedIndex = _arg_1;
            var _local_2:ItemClickEvent = new ItemClickEvent("", false, false, "", _arg_1);
            this.SetFilteredReciepeList(_local_2);
        }

        private function GetMaximumAffordableAmount():Number
        {
            var _local_3:dResource;
            var _local_4:cResources;
            var _local_5:int;
            var _local_1:Vector.<dResource> = this.mSelectedOrderType.GetCosts_vector();
            var _local_2:int = int.MAX_VALUE;
            if (this.defaultAmount != -1)
            {
                _local_2 = this.defaultAmount;
            };
            for each (_local_3 in _local_1)
            {
                _local_4 = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
                _local_5 = _local_4.GetResourceAmount(_local_3.name_string);
                _local_2 = int(Math.min(Math.floor((_local_5 / _local_3.getAmount())), _local_2));
            };
            return (_local_2);
        }

        private function DecreaseCurrentTier(_arg_1:Event):void
        {
            if (this.mCurrentSelectedUnitTier > 1)
            {
                this.mCurrentSelectedUnitTier--;
            };
        }

        override public function Hide():void
        {
            HotkeyManager.getInstance().clearConfirmActions();
            this.mSelectedTabIndex = 0;
            gHintManager.HideHintsForParent(this.mPanel.buttonBar, true);
            if (this.mBuilding != null)
            {
                this.mBuilding.productionQueue.removePropertyObserver(cTimedProductionQueue.PRODUCTION_START, this);
                this.mBuilding.productionQueue.removePropertyObserver(cTimedProductionQueue.PRODUCTION_FINISH, this);
            };
            super.Hide();
        }

        private function AddBuffAdventureGroup(_arg_1:Array):void
        {
            var _local_2:cAdventureDefinition;
            var _local_3:dAdventureClientInfoVO;
            for each (_local_3 in AdventureManager.getInstance().getAdventures())
            {
                _local_2 = cAdventureDefinition.FindAdventureDefinition(_local_3.adventureName);
                if (((_local_2.IsUsingAdventureSpecificBuffs()) && (!(_local_2.GetConnectedBuffGroup() == ""))))
                {
                    _arg_1.push({
                        "label":cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("BuffGroup" + _local_2.GetConnectedBuffGroup())),
                        "group":_local_2.GetConnectedBuffGroup()
                    });
                };
            };
        }

        private function SelectOrderType(_arg_1:ListEvent):void
        {
            var _local_2:cPlayerData = this.mGI.mCurrentPlayer;
            var _local_3:iTimedProductionDefinition = (this.mPanel.availableOrdersList.selectedItem[0] as iTimedProductionDefinition);
            if (_local_3 == null)
            {
                return;
            };
            if (!this.mGI.mRequirements.timedProductionRequirements_vector[_local_3.GetType()].isFulfilledForSkillList(_local_2.getSkills()))
            {
                return;
            };
            this.mSelectedOrderType = (this.mPanel.availableOrdersList.selectedItem[0] as iTimedProductionDefinition);
            this.mPanel.currentState = "manageOrders";
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen(((mUiElement.id + ".") + _local_3.GetType()));
            global.getApplication().inputNotifier.notifyClick(((mUiElement.id + ".") + _local_3.GetType()));
        }


    }
}
