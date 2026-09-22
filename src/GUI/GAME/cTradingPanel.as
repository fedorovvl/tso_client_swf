package GUI.GAME
{
    import Communication.VO.dResourceVO;
    import Communication.VO.dBuffVO;
    import Interface.cGameInterface;
    import GUI.Components.TradingPanel;
    import Communication.VO.dPlayerListItemVO;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import Interface.cGeneralInterface;
    import GUI.Assets.gAssetManager;
    import Enums.AVATAR_SIZE;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import __AS3__.vec.Vector;
    import TimedProduction.iTimedProductionDefinition;
    import flash.events.MouseEvent;
    import BuffSystem.cBuff;
    import Communication.VO.dTradeOfferVO;
    import Communication.VO.dUniqueID;
    import Enums.TRADE_SLOT_TYPE;
    import Enums.COMMAND;
    import Enums.AVATAR_MESSAGE_TYPE;
    import GUI.Components.CustomAlert;
    import mx.events.ListEvent;
    import mx.events.SliderEvent;
    import flash.events.Event;
    import mx.events.FlexEvent;
    import nLib.gMisc;
    import ServerState.dResource;
    import ServerState.cResources;
    import BuffSystem.cBuffDefinition;
    import ServerState.dResourceDefaultDefinition;
    import flash.utils.Dictionary;
    import ShopSystem.cShopItemGroup;
    import AdventureSystem.cAdventureDefinition;
    import GO.cGOSpriteLibContainer;
    import ShopSystem.cShopItem;
    import ShopSystem.cItemContent;
    import ServerState.cPlayerData;
    import Enums.RESOURCE_GROUP;
    import ServerState.gEconomics;
    import Utils.RequirementsHelper;
    import __AS3__.vec.*;

    public class cTradingPanel extends cBasicPanel 
    {

        private static const RESOURCE_SLOT_OFFER:int = 1;
        private static const RESOURCE_SLOT_COSTS:int = 2;

        private var mCostsResourceVO:dResourceVO = null;
        private var mCostsBuffVO:dBuffVO = null;
        private var mGI:cGameInterface;
        private var mSelectedBuffVO:dBuffVO = null;
        private var mSelectedResourceVO:dResourceVO = null;
        protected var mPanel:TradingPanel;
        private var mUnlimitLotsActivated:Boolean = false;
        private var mOfferBuffVO:dBuffVO = null;
        private var mOfferResourceVO:dResourceVO = null;
        private var mDestinationPlayer:dPlayerListItemVO;
        private var mResourceSlot:int = 0;
        private var mWaitingForServerToPlaceOffer:Boolean = false;
        private var mSlotPos:int;
        private var mSlotType:int;
        private var mSlotCost:int;


        private function UnlimitLots(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mUnlimitLotsActivated = true;
            this.SetLotSliderMaxValue();
        }

        public function SetData(_arg_1:dPlayerListItemVO, _arg_2:int=0, _arg_3:int=0, _arg_4:int=0):void
        {
            this.ensureViewIsAvailable();
            this.mDestinationPlayer = _arg_1;
            this.mSlotType = _arg_2;
            this.mSlotPos = _arg_4;
            this.mSlotCost = _arg_3;
            var _local_5:int = this.mGI.mCurrentPlayer.GetAvatarId();
            this.mPanel.playerName.text = cGeneralInterface.getComputedPlayerName(this.mGI.mCurrentPlayer.GetPlayerName_string());
            this.mPanel.playerAvatar.source = gAssetManager.GetAvatarUrl(_local_5, AVATAR_SIZE.SMALL);
            this.mPanel.btnBackToWindow.visible = (!(this.mDestinationPlayer));
            if (this.mDestinationPlayer)
            {
                this.mPanel.labelMiddleColumn.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "SendTradeRequest");
                this.mPanel.btnSendTrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "SelectTradeResources");
                this.mPanel.btnSendTrade.setStyle("icon", gAssetManager.GetClass("ButtonIconDiplomacy"));
                this.mPanel.reciepientName.text = this.mDestinationPlayer.username;
                this.mPanel.reciepientAvatar.source = gAssetManager.GetAvatarUrl(this.mDestinationPlayer.avatarId, AVATAR_SIZE.SMALL);
                this.mPanel.lotAmountSlider.enabled = false;
                this.mPanel.lotsCount.text = "1";
                this.mPanel.lotsCount.editable = false;
                this.mPanel.btnUnlimitedLots.enabled = false;
                this.mPanel.lotSection.visible = false;
                this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "TradingIntroductionPlayer");
            }
            else
            {
                this.mPanel.lotSection.visible = true;
                this.mPanel.labelMiddleColumn.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TradeOfferAdd");
                this.mPanel.btnSendTrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "SelectTradeResources");
                this.mPanel.btnSendTrade.setStyle("icon", gAssetManager.GetClass("ButtonIconTrade"));
                this.mPanel.reciepientName.text = "Marketplace";
                this.mPanel.reciepientName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Marketplace");
                this.mPanel.reciepientAvatar.source = gAssetManager.GetBitmap("AvatarSmall00");
                this.mPanel.lotsCount.restrict = "1-4";
                this.mPanel.lotsCount.editable = true;
                this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "TradingIntroduction");
            };
            this.mPanel.lotsCount.width = 12;
        }

        private function isProducebleInImprovedWarehouse(_arg_1:String):Boolean
        {
            var _local_2:Vector.<iTimedProductionDefinition>;
            var _local_3:iTimedProductionDefinition;
            for each (_local_2 in global.timedProductions_vector)
            {
                for each (_local_3 in _local_2)
                {
                    if (_arg_1.indexOf(_local_3.GetProductionName_string()) >= 0)
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        private function SetResourceSlot(_arg_1:MouseEvent):void
        {
            this.mPanel.lotsCount.text = "1";
            this.mPanel.lotAmountSlider.value = 1;
            switch (_arg_1.currentTarget)
            {
                case this.mPanel.btnSelectCost:
                    this.mResourceSlot = RESOURCE_SLOT_COSTS;
                    break;
                case this.mPanel.btnSelectOffer:
                    this.mResourceSlot = RESOURCE_SLOT_OFFER;
                    break;
            };
            this.mPanel.currentState = "select";
        }

        private function SendTrade(_arg_1:MouseEvent):void
        {
            var _local_3:cBuff;
            if (!this.mDestinationPlayer)
            {
                globalFlash.gui.mTradeWindow.setWaitingForServer(true);
            };
            this.mPanel.btnSendTrade.enabled = false;
            this.Hide();
            var _local_2:dTradeOfferVO = new dTradeOfferVO();
            if (this.mOfferResourceVO)
            {
                _local_2.offerRes = this.mOfferResourceVO;
                _local_2.offerBuff = null;
            }
            else
            {
                _local_2.offerRes = null;
                _local_2.offerBuff = this.mOfferBuffVO;
                _local_3 = this.mGI.mCurrentPlayer.getBuffByUniqueID(dUniqueID.Create(this.mOfferBuffVO.uniqueId1, this.mOfferBuffVO.uniqueId2));
                if (_local_3)
                {
                    _local_3.IncWaitingForServerCount(this.mGI);
                    this.mGI.mCurrentPlayer.resetLastFetchedBuff();
                };
            };
            if (this.mCostsResourceVO)
            {
                _local_2.costsRes = this.mCostsResourceVO;
                _local_2.costsBuff = null;
            }
            else
            {
                _local_2.costsRes = null;
                _local_2.costsBuff = this.mCostsBuffVO;
            };
            if (this.mDestinationPlayer)
            {
                _local_2.receipientId = this.mDestinationPlayer.id;
                _local_2.lots = 0;
                _local_2.slotType = TRADE_SLOT_TYPE.FRIEND_TO_FRIEND;
                _local_2.slotPos = 0;
            }
            else
            {
                _local_2.receipientId = 0;
                _local_2.lots = this.mPanel.lotAmountSlider.value;
                _local_2.slotType = this.mSlotType;
                _local_2.slotPos = this.mSlotPos;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.INITIATE_TRADE, this.mGI.mCurrentViewedZoneID, _local_2);
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADE_INITIATED);
            this.mPanel.btnSendTrade.enabled = false;
            this.Hide();
            if (!this.mDestinationPlayer)
            {
                globalFlash.gui.mTradeWindow.showSellingTab();
            };
        }

        private function ApplySelectionPreCheck(_arg_1:MouseEvent):void
        {
            if ((((this.mSelectedBuffVO) && (this.mPanel.amountSlider.maximum > 1)) && (this.mPanel.amountSlider.value == 1)))
            {
                if (this.mResourceSlot == RESOURCE_SLOT_COSTS)
                {
                    CustomAlert.show("SmallTradeAmountSearch", "SmallTradeAmount", (Alert.YES | Alert.NO), null, this.CheckApplySelectionAnswer);
                }
                else
                {
                    CustomAlert.show("SmallTradeAmountOffer", "SmallTradeAmount", (Alert.YES | Alert.NO), null, this.CheckApplySelectionAnswer);
                };
            }
            else
            {
                this.ApplySelection();
            };
        }

        private function EnterSelectState(_arg_1:FlexEvent):void
        {
            this.mPanel.btnOK.enabled = false;
            this.mPanel.selectedCount.visible = false;
            this.mPanel.amountSlider.visible = false;
            this.mPanel.maximumCount.visible = false;
            this.SetFilteredResourceList();
            this.mPanel.resourceList.selectedIndex = 1;
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.ApplySelectionPreCheck);
            this.mPanel.resourceList.addEventListener(ListEvent.ITEM_CLICK, this.SelectResource);
            this.mPanel.amountSlider.addEventListener(SliderEvent.CHANGE, this.SetAmount);
            this.mPanel.selectedCount.addEventListener(Event.CHANGE, this.ChangeResourceInputAmount);
            this.mPanel.searchColumn.filterList.addEventListener(ListEvent.ITEM_CLICK, this.refreshFilteredList);
            this.mPanel.searchColumn.addEventListener(Event.CHANGE, this.refreshFilteredList);
            this.mPanel.searchColumn.searchBtn.addEventListener(MouseEvent.CLICK, this.refreshFilteredList);
            this.mPanel.searchColumn.searchInput.addEventListener(Event.CHANGE, this.refreshFilteredList);
            this.mPanel.searchColumn.searchBtn.visible = true;
            this.mPanel.searchColumn.searchBtn.includeInLayout = true;
        }

        private function SelectBuff():void
        {
            var _local_2:String;
            var _local_6:String;
            this.mPanel.buffIcon.data = this.mPanel.resourceList.selectedItem;
            this.mPanel.buffIcon.removeIcon.visible = false;
            this.mSelectedResourceVO = null;
            var _local_1:int = 1;
            var _local_3:cBuff;
            var _local_4:dBuffVO;
            if ((this.mPanel.resourceList.selectedItem is cBuff))
            {
                _local_3 = (this.mPanel.resourceList.selectedItem as cBuff);
                this.mSelectedBuffVO = _local_3.CreateBuffVOFromBuff();
                _local_2 = this.mSelectedBuffVO.buffName_string;
                _local_1 = this.mSelectedBuffVO.amount;
                this.mPanel.amountSlider.value = _local_1;
            }
            else
            {
                _local_4 = (this.mPanel.resourceList.selectedItem as dBuffVO);
                this.mSelectedBuffVO = new dBuffVO();
                this.mSelectedBuffVO.buffName_string = _local_4.buffName_string;
                this.mSelectedBuffVO.resourceName_string = _local_4.resourceName_string;
                this.mSelectedBuffVO.amount = 1;
                _local_2 = this.mSelectedBuffVO.buffName_string;
                _local_1 = global.tradeMaxSearchAmount;
                this.mPanel.amountSlider.value = 1;
            };
            var _local_5:String = this.mSelectedBuffVO.resourceName_string;
            this.mPanel.buffIcon.visible = true;
            this.mPanel.resourceIcon.visible = false;
            if (_local_2 == defines.ADVENTURE_BUFF)
            {
                _local_1 = Math.min(_local_1, global.tradeMaxAdventureAmount);
                this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_NAME, _local_5);
            }
            else
            {
                if (((_local_2 == defines.BUILD_BUILDING_BUFF) || (_local_2 == defines.BUILD_DEFENSE_MODE_BUILDING_BUFF)))
                {
                    _local_1 = Math.min(_local_1, global.tradeMaxBuildingAmount);
                    this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_5);
                }
                else
                {
                    if ((((_local_2.indexOf(defines.ADD_RESOURCE_BUFF) == 0) || (_local_2.indexOf(defines.FILL_DEPOSIT_BUFF) == 0)) || (_local_2 == defines.HIRED_MILITARY_BUFF)))
                    {
                        _local_1 = Math.min(_local_1, global.tradeMaxSearchAmount);
                        _local_6 = _local_2;
                        if (((_local_6 == defines.FILL_DEPOSIT_BUFF) && (_local_5 == "")))
                        {
                            _local_6 = (_local_6 + "Any");
                        };
                        this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_6, [this.mSelectedBuffVO.amount, _local_5]);
                    }
                    else
                    {
                        if (_local_2.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == 0)
                        {
                            _local_1 = Math.min(_local_1, global.tradeMaxBuffAmount);
                            this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, ((defines.CHANGE_COLOR_SCHEME_BUFF + "_") + _local_5));
                        }
                        else
                        {
                            _local_1 = Math.min(_local_1, global.tradeMaxBuffAmount);
                            this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_2);
                        };
                    };
                };
            };
            this.mPanel.amountSlider.maximum = _local_1;
            if (((_local_1 > 1) && (!((_local_4 == null) && (_local_3.isNotMerged())))))
            {
                this.mPanel.amountSlider.visible = true;
                this.mPanel.amountSlider.enabled = true;
                this.mPanel.selectedCount.visible = true;
                this.mPanel.maximumCount.visible = true;
            }
            else
            {
                this.mPanel.amountSlider.visible = false;
                this.mPanel.amountSlider.enabled = false;
                this.mPanel.selectedCount.visible = false;
                this.mPanel.maximumCount.visible = false;
            };
            this.SetAmount(null);
        }

        private function CheckApplySelectionAnswer(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.YES)
            {
                this.ApplySelection();
            };
        }

        override public function Show():void
        {
            this.ensureViewIsAvailable();
            if (this.mWaitingForServerToPlaceOffer)
            {
                return;
            };
            this.Clear();
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        private function Clear():void
        {
            this.mSelectedResourceVO = null;
            this.mSelectedBuffVO = null;
            this.mCostsResourceVO = null;
            this.mCostsBuffVO = null;
            this.mOfferResourceVO = null;
            this.mOfferBuffVO = null;
            this.mUnlimitLotsActivated = false;
            this.mPanel.offerResourceRenderer.data = null;
            this.mPanel.offerResourceRenderer.visible = false;
            this.mPanel.offerBuffRenderer.data = null;
            this.mPanel.offerBuffRenderer.visible = false;
            this.mPanel.costResourceRenderer.data = null;
            this.mPanel.costResourceRenderer.visible = false;
            this.mPanel.costBuffVORenderer.data = null;
            this.mPanel.costBuffVORenderer.visible = false;
            this.mPanel.btnSendTrade.enabled = false;
            this.mPanel.btnUnlimitedLots.enabled = false;
            this.mPanel.lotsCount.enabled = false;
            this.mPanel.lotAmountSlider.enabled = false;
            this.mPanel.lotsCount.text = "1";
            this.mPanel.lotsCount.width = 12;
            this.mPanel.lotAmountSlider.value = 1;
            this.mPanel.lotAmountSlider.maximum = 4;
            this.mPanel.maxLotLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "FreeLots", [4]);
        }

        public function Init(_panel:TradingPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_panel);
            this.mPanel = _panel;
            this.mPanel.close.addEventListener(MouseEvent.CLICK, function ():void
            {
                globalFlash.gui.mTradingPanel.Hide();
            });
            this.mPanel.btnSelectCost.addEventListener(MouseEvent.CLICK, this.SetResourceSlot, false, 0, true);
            this.mPanel.btnSelectOffer.addEventListener(MouseEvent.CLICK, this.SetResourceSlot, false, 0, true);
            this.mPanel.btnUnlimitedLots.addEventListener(MouseEvent.CLICK, this.ConfirmUnlimitLots, false, 0, true);
            this.mPanel.lotsCount.addEventListener(Event.CHANGE, this.ChangeInputAmount, false, 0, true);
            this.mPanel.stateSelect.addEventListener(FlexEvent.ENTER_STATE, this.EnterSelectState, false, 0, true);
            this.mPanel.stateSelect.addEventListener(FlexEvent.EXIT_STATE, this.ExitSelectState, false, 0, true);
            this.mPanel.btnSendTrade.addEventListener(MouseEvent.CLICK, this.SendTrade, false, 0, true);
            this.mPanel.btnBackToWindow.addEventListener(MouseEvent.CLICK, this.goBackToTradeWindow, false, 0, true);
        }

        private function SetAmount(_arg_1:SliderEvent):void
        {
            if (this.mSelectedResourceVO)
            {
                this.mSelectedResourceVO.amount = this.mPanel.amountSlider.value;
            }
            else
            {
                this.mSelectedBuffVO.amount = this.mPanel.amountSlider.value;
            };
            this.mPanel.selectedCount.text = this.mPanel.amountSlider.value.toString();
            this.mPanel.maximumCount.text = (" / " + this.mPanel.amountSlider.maximum);
            this.mPanel.btnOK.enabled = true;
            this.mPanel.selectedCount.width = (12 + (8 * (String(this.mPanel.amountSlider.maximum).length - 1)));
        }

        private function searchFilter(_arg_1:Object, _arg_2:int=0, _arg_3:Vector.<Object>=null):Boolean
        {
            var _local_4:String = gMisc.Trim_string(this.mPanel.searchColumn.searchInput.text.toLocaleLowerCase());
            if (((_arg_1 is dBuffVO) && (!(cBuff.CreateBuffFromVO(dBuffVO(_arg_1)).getLocalizedBuffName().toLocaleLowerCase().search(_local_4) == -1))))
            {
                return (true);
            };
            if (((_arg_1 is cBuff) && (!(cBuff(_arg_1).getLocalizedBuffName().toLocaleLowerCase().search(_local_4) == -1))))
            {
                return (true);
            };
            if (((_arg_1 is dResource) && (!(cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, dResource(_arg_1).name_string).toLocaleLowerCase().search(_local_4) == -1))))
            {
                return (true);
            };
            return (false);
        }

        private function ensureViewIsAvailable():void
        {
            var _local_1:TradingPanel;
            if (!this.mPanel)
            {
                _local_1 = new TradingPanel();
                _local_1.id = "GAMESTATE_ID_TRADING_PANEL";
                global.getApplication().isoengine.addChild(_local_1);
                this.Init(_local_1);
            };
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        private function refreshFilteredList(_arg_1:Event=null):void
        {
            var _local_2:Vector.<Object> = this.mPanel.searchColumn.getPreFilteredVector();
            this.mPanel.resourceList.dataProvider = gMisc.iterableToArray(_local_2.filter(this.searchFilter));
        }

        private function SelectResource(_arg_1:ListEvent):void
        {
            if (((this.mPanel.resourceList.selectedItem is cBuff) || (this.mPanel.resourceList.selectedItem is dBuffVO)))
            {
                this.SelectBuff();
                return;
            };
            if ((((this.mPanel.resourceList.selectedItem as dResource).amount == 0) && (this.mResourceSlot == RESOURCE_SLOT_OFFER)))
            {
                return;
            };
            if ((((this.mPanel.resourceList.selectedItem as dResource).amount >= (this.mPanel.resourceList.selectedItem as dResource).maxLimit) && (this.mResourceSlot == RESOURCE_SLOT_COSTS)))
            {
                return;
            };
            this.mSelectedResourceVO = new dResourceVO();
            this.mSelectedResourceVO.name_string = (this.mPanel.resourceList.selectedItem as dResource).name_string;
            this.mSelectedBuffVO = null;
            this.mPanel.buffIcon.visible = false;
            this.mPanel.resourceIcon.visible = true;
            this.mPanel.resourceIcon.source = gAssetManager.GetResourceIcon(this.mSelectedResourceVO.name_string);
            this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, this.mSelectedResourceVO.name_string);
            this.mPanel.selectedCount.visible = true;
            this.mPanel.maximumCount.visible = true;
            this.mPanel.amountSlider.visible = true;
            if (this.mResourceSlot == RESOURCE_SLOT_OFFER)
            {
                this.mPanel.amountSlider.maximum = Math.floor((this.mPanel.resourceList.selectedItem as dResource).amount);
                this.mPanel.amountSlider.enabled = ((this.mPanel.resourceList.selectedItem as dResource).amount > 1);
            }
            else
            {
                this.mPanel.amountSlider.maximum = (Math.floor((this.mPanel.resourceList.selectedItem as dResource).maxLimit) - Math.floor((this.mPanel.resourceList.selectedItem as dResource).amount));
                this.mPanel.amountSlider.enabled = true;
            };
            this.mPanel.amountSlider.value = 1;
            this.mPanel.btnOK.enabled = true;
            this.SetAmount(null);
            this.mPanel.selectedCount.setFocus();
            this.mPanel.selectedCount.setSelection(0, this.mPanel.selectedCount.text.length);
        }

        private function ChangeInputAmount(_arg_1:Event):void
        {
            var _local_2:Number;
            if (this.mOfferResourceVO)
            {
                _local_2 = Math.min(int(this.mPanel.lotsCount.text), this.mPanel.lotAmountSlider.maximum);
                _local_2 = Math.max(1, _local_2);
                this.mPanel.lotsCount.text = _local_2.toString();
                this.mPanel.lotAmountSlider.value = _local_2;
            };
        }

        private function ExitSelectState(_arg_1:FlexEvent):void
        {
            this.mPanel.resourceIcon.source = null;
            this.mPanel.resourceIcon.visible = false;
            this.mPanel.buffIcon.data = null;
            this.mPanel.buffIcon.visible = false;
            this.mPanel.resourceName.text = "";
            this.mPanel.maximumCount.text = "";
            this.mPanel.selectedCount.text = "";
            this.mPanel.amountSlider.enabled = false;
            this.mPanel.btnOK.removeEventListener(MouseEvent.CLICK, this.ApplySelectionPreCheck);
            this.mPanel.resourceList.removeEventListener(ListEvent.ITEM_CLICK, this.SelectResource);
            this.mPanel.amountSlider.removeEventListener(SliderEvent.CHANGE, this.SetAmount);
            this.mPanel.selectedCount.removeEventListener(Event.CHANGE, this.ChangeResourceInputAmount);
            this.mPanel.searchColumn.filterList.removeEventListener(ListEvent.ITEM_CLICK, this.refreshFilteredList);
            this.mPanel.searchColumn.searchBtn.removeEventListener(MouseEvent.CLICK, this.refreshFilteredList);
            this.mPanel.searchColumn.searchInput.addEventListener(Event.CHANGE, this.refreshFilteredList);
            this.mPanel.searchColumn.searchBtn.visible = false;
            this.mPanel.searchColumn.searchBtn.includeInLayout = false;
        }

        private function goBackToTradeWindow(_arg_1:MouseEvent):void
        {
            this.Hide();
            globalFlash.gui.mTradeWindow.Show();
        }

        private function ApplySelection():void
        {
            switch (this.mResourceSlot)
            {
                case RESOURCE_SLOT_COSTS:
                    if (this.mSelectedResourceVO)
                    {
                        this.mCostsBuffVO = null;
                        this.mCostsResourceVO = this.mSelectedResourceVO;
                        this.mPanel.costResourceRenderer.data = this.mCostsResourceVO;
                        this.mPanel.costResourceRenderer.visible = true;
                        this.mPanel.costBuffVORenderer.visible = false;
                    }
                    else
                    {
                        if (this.mSelectedBuffVO)
                        {
                            this.mCostsResourceVO = null;
                            this.mCostsBuffVO = this.mSelectedBuffVO;
                            this.mPanel.costBuffVORenderer.data = this.mCostsBuffVO;
                            this.mPanel.costBuffVORenderer.removeIcon.visible = false;
                            this.mPanel.costBuffVORenderer.visible = true;
                            this.mPanel.costResourceRenderer.visible = false;
                        };
                    };
                    break;
                case RESOURCE_SLOT_OFFER:
                    this.mUnlimitLotsActivated = false;
                    if (this.mSelectedResourceVO)
                    {
                        this.mOfferBuffVO = null;
                        this.mOfferResourceVO = this.mSelectedResourceVO;
                        this.mPanel.offerResourceRenderer.data = this.mOfferResourceVO;
                        this.mPanel.offerResourceRenderer.visible = true;
                        this.mPanel.offerBuffRenderer.visible = false;
                    }
                    else
                    {
                        if (this.mSelectedBuffVO)
                        {
                            this.mOfferResourceVO = null;
                            this.mOfferBuffVO = this.mSelectedBuffVO;
                            this.mPanel.offerBuffRenderer.data = this.mOfferBuffVO;
                            this.mPanel.offerBuffRenderer.removeIcon.visible = false;
                            this.mPanel.offerBuffRenderer.visible = true;
                            this.mPanel.offerResourceRenderer.visible = false;
                        };
                    };
                    break;
            };
            this.mPanel.currentState = "";
            this.SetLotSliderMaxValue();
            if (((!((this.mOfferResourceVO) || (this.mOfferBuffVO))) || (!((this.mCostsResourceVO) || (this.mCostsBuffVO)))))
            {
                this.mPanel.btnSendTrade.enabled = false;
                this.mPanel.btnSendTrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "SelectTradeResources");
            }
            else
            {
                if ((((this.mOfferResourceVO) && (this.mCostsResourceVO)) && (this.mOfferResourceVO.name_string == this.mCostsResourceVO.name_string)))
                {
                    this.mPanel.btnSendTrade.enabled = false;
                    this.mPanel.btnSendTrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotTradeEqualResources");
                }
                else
                {
                    if (((((this.mOfferBuffVO) && (this.mCostsBuffVO)) && (this.mOfferBuffVO.resourceName_string == this.mCostsBuffVO.resourceName_string)) && (this.mOfferBuffVO.buffName_string == this.mCostsBuffVO.buffName_string)))
                    {
                        this.mPanel.btnSendTrade.enabled = false;
                        this.mPanel.btnSendTrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CannotTradeEqualResources");
                    }
                    else
                    {
                        this.mPanel.btnSendTrade.enabled = true;
                        if (this.mDestinationPlayer)
                        {
                            this.mPanel.btnSendTrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "SendTradeRequest");
                        }
                        else
                        {
                            this.mPanel.btnSendTrade.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TradeOfferAdd");
                        };
                    };
                };
            };
        }

        private function ConfirmUnlimitLots(_arg_1:MouseEvent):void
        {
            var _local_2:cResources = global.ui.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer);
            var _local_3:int = global.costOfUnlimitingLots;
            if (this.mSlotType == TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS)
            {
                _local_3 = (_local_3 + this.mSlotCost);
            };
            if (!_local_2.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_3))
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            }
            else
            {
                CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ConfirmUnlimitLots", [global.costOfUnlimitingLots]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmUnlimitLots"), (Alert.OK | Alert.CANCEL), null, this.UnlimitLots, null, 4, false);
            };
        }

        private function ChangeResourceInputAmount(_arg_1:Event):void
        {
            var _local_2:Number = Math.min(int(this.mPanel.selectedCount.text), this.mPanel.amountSlider.maximum);
            _local_2 = Math.max(1, _local_2);
            this.mPanel.selectedCount.text = _local_2.toString();
            this.mPanel.amountSlider.value = _local_2;
        }

        private function SetFilteredResourceList():void
        {
            var _local_2:dBuffVO;
            var _local_3:cBuffDefinition;
            var _local_5:cResources;
            var _local_6:Vector.<dResource>;
            var _local_7:dResourceDefaultDefinition;
            var _local_8:dResource;
            var _local_9:dResource;
            var _local_10:cBuff;
            var _local_11:Dictionary;
            var _local_12:Array;
            var _local_13:String;
            var _local_14:cShopItemGroup;
            var _local_15:cAdventureDefinition;
            var _local_16:cGOSpriteLibContainer;
            var _local_17:String;
            var _local_18:String;
            var _local_19:String;
            var _local_20:int;
            var _local_21:cShopItem;
            var _local_22:cItemContent;
            var _local_1:Vector.<Object> = new Vector.<Object>();
            var _local_4:cPlayerData = this.mGI.mCurrentPlayer;
            if (_local_4 != null)
            {
                _local_5 = this.mGI.mCurrentPlayerZone.GetResources(_local_4);
                if (_local_5 == null)
                {
                    return;
                };
                _local_6 = _local_5.GetPlayerResources_vector(RESOURCE_GROUP.ALL);
                for each (_local_8 in _local_6)
                {
                    _local_7 = gEconomics.mMap_EventResourceDefaultDefinition[_local_8.name_string];
                    if (((gEconomics.GetResourcesDefaultDefinition(_local_8.name_string).tradable) && ((_local_7 == null) || (this.mGI.mEventManager.isEventStarted(_local_7.requiredEventName_string)))))
                    {
                        _local_9 = _local_8.clone();
                        if (((this.mSlotType == TRADE_SLOT_TYPE.PAID_SLOT_WITH_COINS) && (_local_9.name_string == defines.COIN_RESOURCE_NAME_string)))
                        {
                            _local_9.amount = (_local_9.amount - this.mSlotCost);
                        };
                        _local_1.push(_local_9);
                    };
                };
                if (this.mResourceSlot == RESOURCE_SLOT_OFFER)
                {
                    for each (_local_10 in this.mGI.mCurrentPlayer.getBuffsSortedForStarMenu())
                    {
                        if (((!(_local_10.GetWaitingForServer())) && (_local_10.GetBuffDefinition().IsTradable(_local_10.GetResourceName_string()))))
                        {
                            if (_local_10.GetBuffDefinition().GetName_string() == defines.FILL_DEPOSIT_BUFF)
                            {
                                _local_7 = gEconomics.mMap_EventResourceDefaultDefinition[_local_10.GetResourceName_string()];
                                if (((_local_10.GetResourceName_string() == "") || (((!(_local_10.GetResourceName_string() == "")) && (gEconomics.GetResourcesDefaultDefinition(_local_10.GetResourceName_string()).tradable)) && ((_local_7 == null) || (this.mGI.mEventManager.isEventStarted(_local_7.requiredEventName_string))))))
                                {
                                    _local_1.push(_local_10);
                                };
                            }
                            else
                            {
                                _local_1.push(_local_10);
                            };
                        };
                    };
                }
                else
                {
                    if (this.mResourceSlot == RESOURCE_SLOT_COSTS)
                    {
                        _local_11 = new Dictionary();
                        _local_12 = [];
                        for each (_local_3 in global.map_BuffName_BuffDefinition)
                        {
                            _local_17 = _local_3.GetName_string();
                            if (!((((((_local_3.GetId() == defines.ADVENTURE_BUFF_ID) || (_local_3.GetId() == defines.BUILD_BUILDING_BUFF_ID)) || (_local_3.GetId() == defines.HIRED_MILITARY_BUFF_ID)) || (_local_17.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == 0)) || (_local_3.IsChangeSkinBuff())) || (_local_3.IsChangeDefaultSkinBuff())))
                            {
                                _local_18 = _local_3.GetResourceName_string();
                                _local_19 = ((_local_17 + "|") + _local_18);
                                if ((((!(_local_19 in _local_11)) && (_local_3.IsTradable(_local_18))) && (RequirementsHelper.checkEvent(this.mGI, _local_3.GetRequieredEvent()))))
                                {
                                    if (_local_17 == defines.FILL_DEPOSIT_BUFF)
                                    {
                                        _local_12 = _local_18.split(",");
                                    }
                                    else
                                    {
                                        _local_2 = new dBuffVO();
                                        _local_2.buffName_string = _local_17;
                                        _local_2.resourceName_string = _local_18;
                                        if (_local_17.indexOf(defines.FILL_DEPOSIT_BUFF) == 0)
                                        {
                                            _local_20 = 1;
                                        }
                                        else
                                        {
                                            _local_20 = _local_3.GetAmount();
                                        };
                                        _local_2.amount = _local_20;
                                        _local_1.push(_local_2);
                                        _local_11[_local_19] = 1;
                                    };
                                };
                            };
                        };
                        for each (_local_13 in _local_12)
                        {
                            _local_2 = new dBuffVO();
                            _local_2.buffName_string = defines.FILL_DEPOSIT_BUFF;
                            _local_2.resourceName_string = _local_13;
                            _local_2.amount = 1;
                            _local_7 = gEconomics.mMap_EventResourceDefaultDefinition[_local_13];
                            if (((_local_13 == "") || (((!(_local_13 == "")) && (gEconomics.GetResourcesDefaultDefinition(_local_13).tradable)) && ((_local_7 == null) || (this.mGI.mEventManager.isEventStarted(_local_7.requiredEventName_string))))))
                            {
                                _local_1.push(_local_2);
                                _local_11[((defines.FILL_DEPOSIT_BUFF + "|") + _local_13)] = 1;
                            };
                        };
                        for each (_local_14 in cShopItemGroup.GetAllShopItemGroups(true, this.mGI))
                        {
                            for each (_local_21 in _local_14.shopItems_vector)
                            {
                                for each (_local_22 in _local_21.GetShopItemContent_vector())
                                {
                                    _local_17 = _local_22.GetName_string();
                                    _local_3 = cBuffDefinition.GetByName(_local_17);
                                    if (((!(_local_3 == null)) && ((((_local_3.GetId() == defines.HIRED_MILITARY_BUFF_ID) || (_local_17.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == 0)) || (_local_3.IsChangeSkinBuff())) || (_local_3.IsChangeDefaultSkinBuff()))))
                                    {
                                        _local_18 = _local_22.GetResourceName_string();
                                        _local_19 = ((_local_17 + "|") + _local_18);
                                        if (((!(_local_19 in _local_11)) && (_local_3.IsTradable(_local_18))))
                                        {
                                            _local_2 = new dBuffVO();
                                            _local_2.buffName_string = _local_17;
                                            _local_2.resourceName_string = _local_18;
                                            _local_2.amount = _local_3.GetAmount();
                                            _local_1.push(_local_2);
                                            _local_11[_local_19] = 1;
                                        };
                                    };
                                };
                            };
                        };
                        for each (_local_15 in cAdventureDefinition.map_AdventureName_AdventureDefinition.valueSet())
                        {
                            _local_19 = ((defines.ADVENTURE_BUFF + "|") + _local_15.mName_string);
                            if (((_local_15.IsTradable()) && (!(_local_19 in _local_11))))
                            {
                                _local_2 = new dBuffVO();
                                _local_2.buffName_string = defines.ADVENTURE_BUFF;
                                _local_2.resourceName_string = _local_15.mName_string;
                                _local_2.amount = 0;
                                _local_1.push(_local_2);
                                _local_11[_local_19] = 1;
                            };
                        };
                        for each (_local_16 in global.buildingGroup.mGOList_vector)
                        {
                            _local_19 = ((defines.BUILD_BUILDING_BUFF + "|") + _local_16.mGfxResourceListName_string);
                            if (((_local_16.isTradable()) && (!(_local_19 in _local_11))))
                            {
                                _local_2 = new dBuffVO();
                                _local_2.buffName_string = defines.BUILD_BUILDING_BUFF;
                                _local_2.resourceName_string = _local_16.mGfxResourceListName_string;
                                _local_2.amount = 0;
                                _local_1.push(_local_2);
                                _local_11[_local_19] = 1;
                            };
                        };
                    };
                };
                this.mPanel.searchColumn.setData(_local_1, false);
                this.refreshFilteredList();
            };
        }

        private function SetLotSliderMaxValue():void
        {
            var _local_1:cResources;
            var _local_2:int;
            var _local_3:int;
            if (this.mOfferResourceVO)
            {
                _local_1 = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
                _local_2 = _local_1.GetPlayerResource(this.mOfferResourceVO.name_string).amount;
                _local_3 = int(Math.floor((_local_2 / this.mOfferResourceVO.amount)));
                this.mPanel.lotAmountSlider.maximum = ((this.mUnlimitLotsActivated) ? ((_local_3 > 16) ? 16 : _local_3) : ((_local_3 <= 4) ? _local_3 : 4));
                this.mPanel.lotsCount.width = (12 + (8 * (String(this.mPanel.lotAmountSlider.maximum).length - 1)));
                if (!this.mUnlimitLotsActivated)
                {
                    this.mPanel.lotsCount.restrict = "1-4";
                    this.mPanel.maxLotLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "FreeLots", [this.mPanel.lotAmountSlider.maximum]);
                }
                else
                {
                    this.mPanel.lotsCount.restrict = "0-9";
                    this.mPanel.maxLotLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TotalLots", [this.mPanel.lotAmountSlider.maximum]);
                };
                this.mPanel.lotsCount.enabled = true;
                this.mPanel.lotAmountSlider.enabled = true;
                this.mPanel.btnUnlimitedLots.enabled = (((!(this.mDestinationPlayer)) && (_local_3 > 4)) && (!(this.mUnlimitLotsActivated)));
            }
            else
            {
                if (this.mOfferBuffVO)
                {
                    this.mPanel.maxLotLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "FreeLots", [1]);
                }
                else
                {
                    this.mPanel.maxLotLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "FreeLots", [4]);
                };
                this.mPanel.lotsCount.enabled = false;
                this.mPanel.lotAmountSlider.enabled = false;
                this.mPanel.btnUnlimitedLots.enabled = false;
            };
        }


    }
}
