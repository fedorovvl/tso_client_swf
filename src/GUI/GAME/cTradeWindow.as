package GUI.GAME
{
    import Interface.cGameInterface;
    import mx.collections.ArrayCollection;
    import ServerState.cTradeObject;
    import GUI.Components.TradeWindow;
    import __AS3__.vec.Vector;
    import mx.collections.SortField;
    import mx.collections.Sort;
    import Enums.KILL_SWITCH;
    import flash.events.MouseEvent;
    import flash.utils.getTimer;
    import Enums.COMMAND;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.TRADE_SLOT_TYPE;
    import GO.cBuilding;
    import nLib.gMisc;
    import flash.events.Event;
    import GUI.Components.CustomAlert;
    import mx.events.DataGridEvent;
    import mx.events.FlexEvent;
    import mx.events.ItemClickEvent;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import ServerState.dResourceDefaultDefinition;
    import Communication.VO.TradeWindow.dTradeObjectVO;
    import ServerState.gEconomics;
    import Communication.VO.TradeWindow.dTradeWindowResultVO;
    import Communication.VO.dBuffVO;
    import BuffSystem.cBuffDefinition;
    import Communication.VO.dResourceVO;
    import mx.utils.ObjectUtil;
    import nLib.cLog;
    import mx.events.ListEvent;
    import ServerState.cResources;
    import ServerState.dResource;
    import Communication.VO.dIntegerVO;
    import GUI.greyFilter;
    import mx.controls.DataGrid;
    import flash.events.KeyboardEvent;
    import Enums.AVATAR_MESSAGE_TYPE;
    import GUI.Components.ItemRenderer.TradeOfferHeader;
    import __AS3__.vec.*;

    public class cTradeWindow extends cBasicInfoPanel 
    {

        public static const DELETE_TRADE:String = "DeleteTrade";
        private static const PAGE_SIZE:int = 50;

        private var mGI:cGameInterface;
        private var mUserPlacedOffers:ArrayCollection;
        private var offersListPageIndex:int;
        private var mIsTradeAcceptedRecently:Boolean = false;
        private var mSlotPos:int = 0;
        private var lastSellingUpdate:int;
        private var mGetUserPlacedOffers:Boolean = false;
        private var mMarketOffersSortDesc:Boolean = false;
        public var allowSellingUpdate:Boolean = false;
        private var mSlotCost:int = 0;
        private var selectedOffer:cTradeObject = null;
        private var lastHistoryUpdate:int;
        private var mWaitingForServerResponse:Boolean = true;
        private var userAcceptedTradeIDs:ArrayCollection;
        protected var mPanel:TradeWindow;
        private var waitForServerStartTime:int;
        private var reverseSort:Boolean = false;
        private var mGetServerResponse:Boolean = false;
        public var allowHistoryUpdate:Boolean = false;
        public var mOffersRefreshed:Boolean = false;
        private var mHasPlacedOffers:Boolean = true;
        private var mMarketOffersSortLastIndex:int = -1;
        public var mUpdateRefreshTimer:int = 0;
        private var currentSortOn:String = "offer";

        public var mAvailableOfferVector:Vector.<cTradeObject> = new Vector.<cTradeObject>();
        private var gemObj:Object = new Object();
        private var coinObj:Object = new Object();
        private var mOffersOnDisplay:ArrayCollection = new ArrayCollection();
        private var dataSortField:SortField = new SortField();
        private var historySort:Sort = new Sort();
        private var mMarketOffersSort:Sort = new Sort();


        private function placeNewOfferHandler(_arg_1:MouseEvent):void
        {
            if (((this.mWaitingForServerResponse) || (this.mGI.killswitch.isLocked(KILL_SWITCH.TRADE_CREATE))))
            {
                return;
            };
            this.Hide();
            globalFlash.gui.mTradingPanel.SetData(null);
            globalFlash.gui.mTradingPanel.Show();
        }

        public function showSellingTab():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, false);
            this.showTradeTabGlassAnimation();
            if ((((this.lastSellingUpdate + 15000) < getTimer()) && (this.allowSellingUpdate)))
            {
                this.allowSellingUpdate = false;
                this.lastSellingUpdate = getTimer();
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.TRADE_GET_USER_TRADES, this.mGI.mCurrentViewedZoneID, null);
            };
            this.mPanel.detailsStack.selectedIndex = (this.mPanel.buttonBar.selectedIndex = 1);
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BranchOfficeSell");
        }

        public function setPaidSlotsPrice():void
        {
            if (!this.mPanel.initialized)
            {
                return;
            };
            var _local_1:int = this.mGI.mHomePlayer.mTradeData.getNextFreeSlotForType(TRADE_SLOT_TYPE.FREE_SLOT);
            if (_local_1 < 1)
            {
                this.mPanel.btnStack.selectedIndex = 0;
            }
            else
            {
                this.mPanel.btnStack.selectedIndex = 1;
                _local_1 = this.mGI.mHomePlayer.mTradeData.getNextFreeSlotForType(TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS);
                if (_local_1 < global.activateSlotsWithGems_vector.length)
                {
                    this.gemObj.amount = global.activateSlotsWithGems_vector[_local_1];
                    this.mPanel.gemPriceRenderer.data = this.gemObj;
                    this.mPanel.btnBuySlotWithGem.enabled = true;
                }
                else
                {
                    this.mPanel.btnBuySlotWithGem.enabled = false;
                };
                _local_1 = this.mGI.mHomePlayer.mTradeData.getNextFreeSlotForType(TRADE_SLOT_TYPE.PAID_SLOT_WITH_COINS);
                if (_local_1 < global.activateSlotsWithCoins_vector.length)
                {
                    this.coinObj.amount = global.activateSlotsWithCoins_vector[_local_1];
                    this.mPanel.coinPriceRenderer.data = this.coinObj;
                    this.mPanel.btnBuySlot.enabled = true;
                }
                else
                {
                    this.mPanel.btnBuySlot.enabled = false;
                };
            };
        }

        override public function SetData(_arg_1:cBuilding):void
        {
        }

        protected function prevOfferPage(_arg_1:MouseEvent):void
        {
            if (this.offersListPageIndex >= 1)
            {
                this.refreshOffersListDataProvider((this.offersListPageIndex - 1), this.mOffersOnDisplay);
            };
        }

        private function refreshList(_arg_1:Event):void
        {
            this.sortAndFilterTrades(_arg_1);
            this.selectedOffer = null;
            this.mPanel.btnAcceptOffer.enabled = false;
            this.mPanel.SearchNoResultFound.visible = ((this.mOffersOnDisplay.source.length == 0) && (gMisc.Trim_string(this.mPanel.offerSearch.searchInput.text).length > 0));
        }

        override public function Show():void
        {
            if (((!(global.useExternalServer)) || (this.mGI.mCurrentPlayerZone.IsBuildingOnMap(defines.LOGISTICS_NAME_string))))
            {
                this.mPanel.detailsStack.selectedIndex = 0;
                this.mPanel.buttonBar.selectedIndex = 0;
                this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BranchOfficeBuy");
                this.mPanel.x = ((this.mPanel.stage.stageWidth - this.mPanel.width) / 2);
                this.mPanel.y = ((this.mPanel.stage.stageHeight - this.mPanel.height) / 2);
                this.setPaidSlotsPrice();
                super.Show();
                globalFlash.gui.windowController.closeModal();
                this.refreshGUI();
                if (((this.mWaitingForServerResponse) && ((getTimer() - this.waitForServerStartTime) > 20000)))
                {
                    this.setWaitingForServer(false);
                };
            }
            else
            {
                CustomAlert.show("NoTradeWithoutLogistics", "NoTradeWithoutLogistics");
            };
        }

        private function sortAndFilterTrades(_arg_1:Event, _arg_2:Boolean=false):void
        {
            var _local_3:Vector.<Object> = this.mPanel.offerSearch.getPreFilteredVector();
            this.mOffersOnDisplay.source = gMisc.iterableToArray(_local_3.filter(this.searchFilter));
            this.headerClicked(new DataGridEvent("refresh"));
            this.mPanel.SearchNoResultFound.visible = (this.mAvailableOfferVector.length <= 0);
            var _local_4:int = ((_arg_2) ? this.offersListPageIndex : 0);
            this.refreshOffersListDataProvider(_local_4, this.mOffersOnDisplay);
        }

        public function setWaitingForServer(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.waitForServerStartTime = getTimer();
            };
            this.mWaitingForServerResponse = _arg_1;
            if (((((this.mPanel.sellTabGlassAnimLayer) && (this.mPanel.sellTabGlassAnim)) && (this.mPanel.sellTabGlassAnimLayer.stage)) && (this.mPanel.sellTabGlassAnim.stage)))
            {
                this.showTradeTabGlassAnimation();
            }
            else
            {
                this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.mPanelCreationCompleteHandler);
            };
        }

        private function togglePanelHandler(_arg_1:ItemClickEvent):void
        {
            if (this.mPanel.buttonBar.selectedIndex == 0)
            {
                this.mPanel.detailsStack.selectedIndex = 0;
                this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BranchOfficeBuy");
                this.refreshList(null);
            }
            else
            {
                if (this.mPanel.buttonBar.selectedIndex == 1)
                {
                    this.showSellingTab();
                }
                else
                {
                    if (this.mPanel.buttonBar.selectedIndex == 2)
                    {
                        this.showHistoryTab();
                    };
                };
            };
        }

        private function addHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        public function setData(_arg_1:dTradeWindowResultVO=null):void
        {
            var _local_3:cTradeObject;
            var _local_4:dResourceDefaultDefinition;
            var _local_5:dResourceDefaultDefinition;
            var _local_6:Boolean;
            var _local_7:dTradeObjectVO;
            this.selectedOffer = null;
            this.mPanel.btnAcceptOffer.enabled = false;
            this.userAcceptedTradeIDs = _arg_1.userAcceptedTradeIDs;
            var _local_2:Vector.<cTradeObject> = new Vector.<cTradeObject>();
            for each (_local_7 in _arg_1.tradeOffers)
            {
                _local_4 = gEconomics.mMap_EventResourceDefaultDefinition[_local_7.offer.split(",")[0]];
                _local_5 = gEconomics.mMap_EventResourceDefaultDefinition[_local_7.offer.split("|")[1].split(",")[0]];
                _local_6 = (((_local_4 == null) || (this.mGI.mEventManager.isEventStarted(_local_4.requiredEventName_string))) && ((_local_5 == null) || (this.mGI.mEventManager.isEventStarted(_local_5.requiredEventName_string))));
                if ((((((!(_local_7.senderID == this.mGI.mCurrentPlayer.GetPlayerId())) && (_local_7.lotsRemaining > 0)) && ((global.tradeExpirationTime - (_arg_1.currentTime - _local_7.created)) > 0)) && (!(this.isTradeAlreadyAccepted(_local_7.id)))) && (_local_6)))
                {
                    _local_3 = cTradeObject.getTradeObject(_local_7.offer, _local_7.type);
                    _local_3.tradeID = _local_7.id;
                    _local_3.senderName = _local_7.senderName;
                    _local_3.createdTime = _local_7.created;
                    _local_3.remainingTime = (global.tradeExpirationTime - (_arg_1.currentTime - _local_7.created));
                    _local_3.runningTime = this.getTimeString(Number(_local_3.remainingTime));
                    _local_2.push(_local_3);
                };
            };
            this.mAvailableOfferVector = _local_2;
            this.refreshGUI();
        }

        private function getTimeString(_arg_1:Number):String
        {
            return (cLocaManager.GetInstance().FormatDuration(_arg_1, cLocaManager.DURATION_FORMAT_SHORT));
        }

        public function Init(_arg_1:TradeWindow):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function offerCompareHandler(_arg_1:cTradeObject, _arg_2:cTradeObject, _arg_3:Array):int
        {
            var _local_4:String;
            var _local_5:String;
            var _local_7:dBuffVO;
            var _local_8:cBuffDefinition;
            var _local_9:String;
            var _local_6:String = ((_arg_3[0] is SortField) ? _arg_3[0].name : _arg_3[0]);
            if (((_local_6 == "offer") || (_local_6 == "costs")))
            {
                if ((_arg_1[_local_6] is dResourceVO))
                {
                    _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _arg_1[_local_6].name_string);
                }
                else
                {
                    if ((_arg_1[_local_6] is dBuffVO))
                    {
                        _local_7 = (_arg_1[_local_6] as dBuffVO);
                        _local_8 = cBuffDefinition.GetByName(_local_7.buffName_string);
                        if (_local_8.GetType() == "Adventure")
                        {
                            _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_NAME, _local_7.resourceName_string);
                        }
                        else
                        {
                            if (((_local_8.GetType() == "BuildBuilding") || (_local_8.GetType() == "BuildDefenseModeBuilding")))
                            {
                                _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_7.resourceName_string);
                            }
                            else
                            {
                                if (((_local_7.buffName_string.indexOf("AddResource") > -1) || (_local_7.buffName_string.indexOf("FillDeposit") > -1)))
                                {
                                    _local_9 = _local_7.buffName_string;
                                    if (((_local_9 == "FillDeposit") && (_local_7.resourceName_string == "")))
                                    {
                                        _local_9 = (_local_9 + "Any");
                                    };
                                    _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_9, [_local_7.amount, _local_7.resourceName_string]);
                                }
                                else
                                {
                                    _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_7.buffName_string);
                                };
                            };
                        };
                    };
                };
                if ((_arg_2[_local_6] is dResourceVO))
                {
                    _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _arg_2[_local_6].name_string);
                }
                else
                {
                    if ((_arg_2[_local_6] is dBuffVO))
                    {
                        _local_7 = (_arg_2[_local_6] as dBuffVO);
                        _local_8 = cBuffDefinition.GetByName(_local_7.buffName_string);
                        if (_local_8.GetType() == "Adventure")
                        {
                            _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_NAME, _local_7.resourceName_string);
                        }
                        else
                        {
                            if (((_local_8.GetType() == "BuildBuilding") || (_local_8.GetType() == "BuildDefenseModeBuilding")))
                            {
                                _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_7.resourceName_string);
                            }
                            else
                            {
                                if (((_local_7.buffName_string.indexOf("AddResource") > -1) || (_local_7.buffName_string.indexOf("FillDeposit") > -1)))
                                {
                                    _local_9 = _local_7.buffName_string;
                                    if (((_local_9 == "FillDeposit") && (_local_7.resourceName_string == "")))
                                    {
                                        _local_9 = (_local_9 + "Any");
                                    };
                                    _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_9, [_local_7.amount, _local_7.resourceName_string]);
                                }
                                else
                                {
                                    _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_7.buffName_string);
                                };
                            };
                        };
                    };
                };
            }
            else
            {
                if (((_local_6 == "senderName") || (_local_6 == "remainingTime")))
                {
                    _local_4 = _arg_1[_local_6];
                    _local_5 = _arg_2[_local_6];
                };
            };
            return (ObjectUtil.stringCompare(_local_4, _local_5));
        }

        public function showHistoryTab():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, false);
            this.showTradeTabGlassAnimation();
            if ((((this.lastHistoryUpdate + 15000) < getTimer()) && (this.allowHistoryUpdate)))
            {
                this.allowHistoryUpdate = false;
                this.reloadHistory();
            };
            this.mPanel.detailsStack.selectedIndex = (this.mPanel.buttonBar.selectedIndex = 2);
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BranchOfficeHistory");
        }

        public function deleteAllPlacedTrades():void
        {
            if (ArrayCollection(this.mPanel.userPlaceOffersList.dataProvider).length > 0)
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.DELETE_TRADES_BY_DEMOLITION, this.mGI.mCurrentViewedZoneID, null);
            };
        }

        public function searchFilter(_arg_1:cTradeObject, _arg_2:int=0, _arg_3:Vector.<Object>=null):Boolean
        {
            var _local_4:String = gMisc.Trim_string(this.mPanel.offerSearch.searchInput.text.toLocaleLowerCase());
            if (_arg_1.senderName.toLocaleLowerCase().search(_local_4) != -1)
            {
                return (true);
            };
            if (Tradeable(_arg_1.offer).getName().toLocaleLowerCase().search(_local_4) != -1)
            {
                return (true);
            };
            if (Tradeable(_arg_1.costs).getName().toLocaleLowerCase().search(_local_4) != -1)
            {
                return (true);
            };
            return (false);
        }

        private function deleteHistoryTradeHandler(_arg_1:ListEvent):void
        {
            var _local_2:ArrayCollection = ArrayCollection(this.mPanel.tradeHistoryList.dataProvider);
            if (this.mPanel.tradeHistoryList.selectedItem == null)
            {
                cLog.warning("DeleteTrade(): mPanel.tradeHistoryList.selectedItem is null");
                return;
            };
            var _local_3:cTradeObject = (this.mPanel.tradeHistoryList.selectedItem as cTradeObject);
            var _local_4:int = _local_2.getItemIndex(_local_3);
            if (_local_4 < 0)
            {
                cLog.warning(("DeleteTrade(): index of trade is " + _local_4));
                return;
            };
            var _local_5:dTradeObjectVO = new dTradeObjectVO();
            _local_5.id = _local_3.tradeID;
            _local_5.senderID = _local_3.senderID;
            _local_5.receiverID = _local_3.receiverID;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.REMOVE_TRADE, this.mGI.mCurrentViewedZoneID, _local_5);
            _local_2.removeItemAt(_local_4);
            this.mPanel.tradeHistoryList.invalidateList();
            this.mGI.mHomePlayer.mTradeData.removeTradeHistory(_local_3);
        }

        private function mPanelCreationCompleteHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.mPanelCreationCompleteHandler);
            this.showTradeTabGlassAnimation();
        }

        protected function nextOfferPage(_arg_1:MouseEvent):void
        {
            if (this.offersListPageIndex < int((this.mOffersOnDisplay.length / PAGE_SIZE)))
            {
                this.refreshOffersListDataProvider((this.offersListPageIndex + 1), this.mOffersOnDisplay);
            };
        }

        public function refreshGUI(_arg_1:Boolean=false):void
        {
            this.mPanel.offerSearch.setData(this.mAvailableOfferVector, true);
            this.sortAndFilterTrades(null, _arg_1);
            this.mPanel.SearchNoResultFound.visible = false;
        }

        private function removeTradeAndRearrange(_arg_1:cTradeObject):void
        {
            var _local_2:dTradeObjectVO = new dTradeObjectVO();
            _local_2.id = _arg_1.tradeID;
            _local_2.senderID = _arg_1.senderID;
            _local_2.receiverID = _arg_1.receiverID;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.REMOVE_TRADE, this.mGI.mCurrentViewedZoneID, _local_2);
            var _local_3:int = (this.mPanel.userPlaceOffersList.dataProvider as ArrayCollection).getItemIndex(_arg_1);
            (this.mPanel.userPlaceOffersList.dataProvider as ArrayCollection).removeItemAt(_local_3);
            this.mGI.mHomePlayer.mTradeData.removeTradeOffer(_arg_1);
        }

        private function isTradeAlreadyAccepted(_arg_1:int):Boolean
        {
            var _local_2:int;
            if (this.userAcceptedTradeIDs)
            {
                _local_2 = 0;
                while (_local_2 < this.userAcceptedTradeIDs.length)
                {
                    if (this.userAcceptedTradeIDs[_local_2] == _arg_1)
                    {
                        return (true);
                    };
                    _local_2++;
                };
            };
            return (false);
        }

        private function selectOfferHandler(_arg_1:ListEvent):void
        {
            var _local_2:cResources;
            var _local_3:dResource;
            var _local_4:dBuffVO;
            this.mPanel.btnAcceptOffer.enabled = false;
            if ((this.mPanel.offersList.selectedItem is cTradeObject))
            {
                this.selectedOffer = (this.mPanel.offersList.selectedItem as cTradeObject);
                if ((this.selectedOffer.costs is dResourceVO))
                {
                    _local_2 = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mHomePlayer);
                    _local_3 = _local_2.GetPlayerResource((this.selectedOffer.costs as dResourceVO).name_string);
                    this.mPanel.btnAcceptOffer.enabled = (_local_3.amount >= (this.selectedOffer.costs as dResourceVO).amount);
                }
                else
                {
                    if ((this.selectedOffer.costs is dBuffVO))
                    {
                        _local_4 = (this.selectedOffer.costs as dBuffVO);
                        this.mPanel.btnAcceptOffer.enabled = this.mGI.mHomePlayer.hasBuffByBuffVO(_local_4);
                    };
                };
            };
        }

        public function setUserPlacedOffersData(_arg_1:ArrayCollection, _arg_2:Boolean=false):void
        {
            if (!_arg_2)
            {
                this.showTradeTabGlassAnimation();
            };
            this.setDataProviderMaintainingScrollPosition(this.mPanel.userPlaceOffersList, _arg_1);
        }

        private function acceptTradeHandler(_arg_1:MouseEvent):void
        {
            if (!this.selectedOffer)
            {
                return;
            };
            this.mPanel.buyTabGlassAnimLayer.visible = true;
            this.mPanel.buyTabGlassAnim.visible = true;
            this.mPanel.btnAcceptOffer.enabled = false;
            if (this.selectedOffer == null)
            {
                cLog.warning("DeleteAcceptedOffer(): mPanel.resourceList.selectedItem is null");
                return;
            };
            var _local_2:int = (this.mPanel.offersList.dataProvider as ArrayCollection).getItemIndex(this.selectedOffer);
            if (_local_2 < 0)
            {
                cLog.warning(("DeleteAcceptedOffer(): index of trade is " + _local_2));
                return;
            };
            var _local_3:int;
            while (_local_3 < this.mAvailableOfferVector.length)
            {
                if (this.mAvailableOfferVector[_local_3].tradeID == this.selectedOffer.tradeID)
                {
                    this.mGI.mCurrentPlayer.mTradeData.acceptedOffers.push(cTradeObject(this.mAvailableOfferVector.splice(_local_3, 1)[0]));
                    break;
                };
                _local_3++;
            };
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.ACCEPT_TRADE_MARKET, this.mGI.mCurrentPlayer.GetPlayerId(), new dIntegerVO(this.selectedOffer.tradeID));
            this.refreshGUI(true);
        }

        public function refreshUserOfferList():void
        {
            this.mPanel.userPlaceOffersList.invalidateList();
        }

        public function enableRefreshOffers(_arg_1:Boolean):void
        {
            this.mPanel.refreshOffers.enabled = _arg_1;
            this.mOffersRefreshed = (!(_arg_1));
            if (this.mPanel.refreshOffers.enabled)
            {
                this.mPanel.refreshOffers.filters = [];
            }
            else
            {
                this.mPanel.refreshOffers.filters = [greyFilter(0.45)];
            };
            if (_arg_1)
            {
                this.mPanel.refreshOffers.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "RerfreshOffers");
            }
            else
            {
                this.mPanel.refreshOffers.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CantRerfreshOffers", [(global.tradeRefreshInterval - this.mUpdateRefreshTimer)]);
            };
        }

        private function deleteTradeHandler(event:ListEvent):void
        {
            var tradeObject:cTradeObject;
            if (this.mPanel.userPlaceOffersList.selectedItem == null)
            {
                cLog.warning("DeleteTrade(): mPanel.userPlaceOffersList.selectedItem is null");
                return;
            };
            tradeObject = (this.mPanel.userPlaceOffersList.selectedItem as cTradeObject);
            var index:int = (this.mPanel.userPlaceOffersList.dataProvider as ArrayCollection).getItemIndex(tradeObject);
            if (index < 0)
            {
                cLog.warning(("DeleteTrade(): index of trade is " + index));
                return;
            };
            if ((((tradeObject.deleted == 0) && (!(tradeObject.isTradeCancled))) && (tradeObject.remainingLots > 0)))
            {
                CustomAlert.show("DeleteTrade", "DeleteTrade", (Alert.YES | Alert.NO), null, function removeTradeFromList (_arg_1:CloseEvent):void
                {
                    if (_arg_1.detail == Alert.YES)
                    {
                        tradeObject.isTradeCancled = true;
                        tradeObject.coolDownTime = global.tradeCoolDownTime;
                        tradeObject.deleted = (tradeObject.createdTime + (global.tradeExpirationTime - ((tradeObject.remainingTime <= 0) ? 0 : tradeObject.remainingTime)));
                        mGI.mClientMessages.SendMessagetoServer(COMMAND.DELETE_TRADE_BY_USER, mGI.mCurrentViewedZoneID, new dIntegerVO(tradeObject.tradeID));
                    };
                });
            }
            else
            {
                if (tradeObject.coolDownTime <= 0)
                {
                    this.removeTradeAndRearrange(tradeObject);
                };
            };
        }

        private function refreshOffersHandler(_arg_1:Event):void
        {
            if (!this.mIsTradeAcceptedRecently)
            {
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.TRADE_GET_UPDATES, this.mGI.mCurrentViewedZoneID, null);
                this.enableRefreshOffers(false);
            };
            cTradeObject.dispose();
        }

        private function confirmPlaceNewOfferWithGemsHandler(_arg_1:MouseEvent):void
        {
            if (this.mWaitingForServerResponse)
            {
                return;
            };
            var _local_2:cResources = global.ui.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer);
            var _local_3:int = this.mGI.mHomePlayer.mTradeData.getNextFreeSlotForType(TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS);
            if (_local_3 < global.activateSlotsWithGems_vector.length)
            {
                this.mSlotCost = global.activateSlotsWithGems_vector[_local_3];
                this.mSlotPos = _local_3;
                if (!_local_2.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, this.mSlotCost))
                {
                    CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.addHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
                }
                else
                {
                    CustomAlert.show("ConfirmPlaceNewOfferWithGems", "ConfirmPlaceNewOfferWithGems", (Alert.OK | Alert.CANCEL), null, this.placeNewOfferWithGemsHandler);
                };
            }
            else
            {
                cLog.info("No further tradeslot avialable for Gems.");
                return;
            };
        }

        override protected function HideWithoutQueue():void
        {
            this.mPanel.btnPin.selected = false;
            super.HideWithoutQueue();
        }

        private function setDataProviderMaintainingScrollPosition(_arg_1:DataGrid, _arg_2:ArrayCollection):void
        {
            var _local_3:int;
            if (_arg_1.dataProvider == null)
            {
                _arg_1.dataProvider = new ArrayCollection();
            };
            var _local_4:ArrayCollection = (_arg_1.dataProvider as ArrayCollection);
            var _local_5:int = _arg_2.length;
            var _local_6:int = _local_4.length;
            _local_3 = 0;
            while (_local_3 < _local_5)
            {
                if (_local_3 < _local_6)
                {
                    _local_4.setItemAt(_arg_2[_local_3], _local_3);
                }
                else
                {
                    _local_4.addItem(_arg_2[_local_3]);
                };
                _local_3++;
            };
            while (_local_3 < _local_6)
            {
                _local_4.removeItemAt(_local_3);
                _local_6--;
            };
            _arg_1.invalidateList();
        }

        private function placeNewOfferWithCoinsHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.Hide();
            globalFlash.gui.mTradingPanel.SetData(null, TRADE_SLOT_TYPE.PAID_SLOT_WITH_COINS, this.mSlotCost, this.mSlotPos);
            globalFlash.gui.mTradingPanel.Show();
        }

        protected function changeSearchHandler(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == 13)
            {
                this.sortAndFilterTrades(_arg_1);
            };
        }

        public function updateRefreshOffersTooltip():void
        {
            this.mPanel.refreshOffers.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CantRerfreshOffers", [(global.tradeRefreshInterval - this.mUpdateRefreshTimer)]);
        }

        public function setTradeStatus(_arg_1:String):void
        {
            this.mPanel.buyTabGlassAnimLayer.visible = false;
            this.mPanel.buyTabGlassAnim.visible = false;
            CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _arg_1), cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGE_LABELS, _arg_1), 4, null, null, null, 4, false);
            if (_arg_1 == "TradeFailed")
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADE_UNSUCESSFULL);
            };
        }

        private function placeNewOfferWithGemsHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.Hide();
            globalFlash.gui.mTradingPanel.SetData(null, TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS, this.mSlotCost, this.mSlotPos);
            globalFlash.gui.mTradingPanel.Show();
        }

        private function closePanelHandler(_arg_1:Event):void
        {
            if (this.mPanel.btnPin.selected)
            {
                HideCurrentActivePanel();
            };
            this.selectedOffer = null;
            this.mPanel.btnAcceptOffer.enabled = false;
            this.Hide();
        }

        public function reloadHistory():void
        {
            this.lastHistoryUpdate = getTimer();
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_TRADE_HISTORY, this.mGI.mCurrentViewedZoneID, null);
        }

        private function hackFilterDuplicatedTrades(_arg_1:ArrayCollection):void
        {
            var _local_3:int;
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = (_local_2 + 1);
                while (_local_3 < _arg_1.length)
                {
                    if (_arg_1[_local_2].tradeID == _arg_1[_local_3].tradeID)
                    {
                        _arg_1.removeItemAt(_local_3);
                    };
                    _local_3++;
                };
                _local_2++;
            };
        }

        private function showTradeTabGlassAnimation():void
        {
            this.mPanel.sellTabGlassAnimLayer.visible = this.mWaitingForServerResponse;
            this.mPanel.sellTabGlassAnim.visible = this.mWaitingForServerResponse;
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.x = ((this.mPanel.stage.stageWidth - this.mPanel.width) / 2);
            this.mPanel.y = ((this.mPanel.stage.stageHeight - this.mPanel.height) / 2);
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BranchOfficeBuy");
            this.mPanel.buttonBar.dataProvider = [cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Buying"), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Selling"), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "History")];
            this.mPanel.btnPin.visible = true;
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.closePanelHandler);
            this.mPanel.btnPin.addEventListener(MouseEvent.CLICK, this.pinPanelHandler);
            this.mPanel.refreshOffers.addEventListener(MouseEvent.CLICK, this.refreshOffersHandler);
            this.mPanel.buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK, this.togglePanelHandler);
            this.mPanel.btnPlaceOffer.addEventListener(MouseEvent.CLICK, this.placeNewOfferHandler);
            this.mPanel.btnBuySlot.addEventListener(MouseEvent.CLICK, this.confirmPlaceNewOfferWithCoinsHandler);
            this.mPanel.btnBuySlotWithGem.addEventListener(MouseEvent.CLICK, this.confirmPlaceNewOfferWithGemsHandler);
            this.mPanel.offersList.addEventListener(ListEvent.ITEM_CLICK, this.selectOfferHandler);
            this.mPanel.offersList.addEventListener(DataGridEvent.HEADER_RELEASE, this.headerClicked);
            this.mPanel.userPlaceOffersList.addEventListener(cTradeWindow.DELETE_TRADE, this.deleteTradeHandler);
            this.mPanel.tradeHistoryList.addEventListener(cTradeWindow.DELETE_TRADE, this.deleteHistoryTradeHandler);
            this.mPanel.btnAcceptOffer.addEventListener(MouseEvent.CLICK, this.acceptTradeHandler);
            this.mPanel.btnOffersPrevPage.addEventListener(MouseEvent.CLICK, this.prevOfferPage);
            this.mPanel.btnOffersNextPage.addEventListener(MouseEvent.CLICK, this.nextOfferPage);
            this.mPanel.offerSearch.filterList.addEventListener(ListEvent.ITEM_CLICK, this.refreshList);
            this.mPanel.offerSearch.addEventListener(Event.CHANGE, this.refreshList);
            this.mPanel.offerSearch.searchBtn.addEventListener(MouseEvent.CLICK, this.sortAndFilterTrades);
            this.mPanel.offerSearch.searchInput.addEventListener(KeyboardEvent.KEY_UP, this.changeSearchHandler);
            this.gemObj.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
            this.gemObj.amount = 0;
            this.mPanel.gemPriceRenderer.data = this.gemObj;
            this.coinObj.name_string = defines.COIN_RESOURCE_NAME_string;
            this.coinObj.amount = 0;
            this.mPanel.coinPriceRenderer.data = this.coinObj;
            this.dataSortField.name = "createdTime";
            this.dataSortField.numeric = true;
            this.dataSortField.descending = true;
            this.historySort.fields = [this.dataSortField];
            this.mMarketOffersSort.compareFunction = this.offerCompareHandler;
            this.mMarketOffersSort.fields = [new SortField("offer", false, true)];
            this.setWaitingForServer(false);
            EnableDragging();
        }

        private function confirmPlaceNewOfferWithCoinsHandler(_arg_1:MouseEvent):void
        {
            if (this.mWaitingForServerResponse)
            {
                return;
            };
            var _local_2:cResources = global.ui.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer);
            var _local_3:int = this.mGI.mHomePlayer.mTradeData.getNextFreeSlotForType(TRADE_SLOT_TYPE.PAID_SLOT_WITH_COINS);
            if (_local_3 < global.activateSlotsWithCoins_vector.length)
            {
                this.mSlotCost = global.activateSlotsWithCoins_vector[_local_3];
                this.mSlotPos = _local_3;
                if (!_local_2.HasPlayerResource(defines.COIN_RESOURCE_NAME_string, this.mSlotCost))
                {
                    CustomAlert.show("ItemPurchaseMissingResource", "ItemPurchaseMissingResource", Alert.OK);
                }
                else
                {
                    CustomAlert.show("ConfirmPlaceNewOfferWithCoins", "ConfirmPlaceNewOfferWithCoins", (Alert.OK | Alert.CANCEL), null, this.placeNewOfferWithCoinsHandler);
                };
            }
            else
            {
                cLog.info("No further tradeslot avialable for Coins.");
                return;
            };
        }

        protected function headerClicked(_arg_1:DataGridEvent):void
        {
            if (((this.currentSortOn == _arg_1.dataField) && (!(this.reverseSort))))
            {
                this.reverseSort = true;
            }
            else
            {
                if (_arg_1.type != "refresh")
                {
                    this.reverseSort = false;
                    this.currentSortOn = _arg_1.dataField;
                };
                TradeOfferHeader.selectedHeader = this.currentSortOn;
                if (this.currentSortOn == "remainingTime")
                {
                    this.mOffersOnDisplay.source.sortOn((this.currentSortOn + "Sort"), (Array.NUMERIC | Array.DESCENDING));
                }
                else
                {
                    if (this.currentSortOn == "senderName")
                    {
                        this.mOffersOnDisplay.source.sortOn((this.currentSortOn + "Sort"), Array.CASEINSENSITIVE);
                    }
                    else
                    {
                        this.mOffersOnDisplay.source.sortOn([(this.currentSortOn + "NameSort"), (this.currentSortOn + "Sort")], [null, Array.NUMERIC]);
                    };
                };
            };
            if (this.reverseSort)
            {
                this.mOffersOnDisplay.source.reverse();
            };
            if (_arg_1.type != "refresh")
            {
                this.refreshOffersListDataProvider(0, this.mOffersOnDisplay);
            };
            _arg_1.stopImmediatePropagation();
        }

        private function pinPanelHandler(_arg_1:Event):void
        {
            this.mPanel.btnPin.selected = (!(this.mPanel.btnPin.selected));
            if (this.mPanel.btnPin.selected)
            {
                global.ui.mQuestClientCallbacks.InitiateWindowOpen("PinTrade");
                global.getApplication().inputNotifier.notifyClick("PinTrade");
                mCurrentActivePanel = null;
            }
            else
            {
                HideCurrentActivePanel();
                mCurrentActivePanel = this;
            };
        }

        public function setTradeHistoryData(_arg_1:ArrayCollection):void
        {
            var _local_3:cTradeObject;
            var _local_2:int;
            this.hackFilterDuplicatedTrades(_arg_1);
            for each (_local_3 in _arg_1)
            {
                if (_local_3.receiverID == 0)
                {
                    _local_3.createdTime = _local_3.deleted;
                };
            };
            _arg_1.source.sortOn("createdTime", Array.NUMERIC);
            _arg_1.sort = this.historySort;
            _arg_1.refresh();
            this.mPanel.tradeHistoryList.dataProvider = _arg_1;
            this.mPanel.tradeHistoryList.invalidateList();
        }

        private function refreshOffersListDataProvider(_arg_1:uint, _arg_2:ArrayCollection):void
        {
            this.offersListPageIndex = _arg_1;
            var _local_3:int = (_arg_1 * PAGE_SIZE);
            var _local_4:ArrayCollection = new ArrayCollection(_arg_2.source.slice(_local_3, (_local_3 + PAGE_SIZE)));
            this.mPanel.offersList.dataProvider = _local_4;
            this.mPanel.txtOffersPage.text = (((_arg_1 + 1) + "/") + (int((_arg_2.length / PAGE_SIZE)) + 1));
        }

        public function setSortForAvailableOffers(_arg_1:DataGridEvent=null):void
        {
            if (_arg_1)
            {
                if (_arg_1.columnIndex == this.mMarketOffersSortLastIndex)
                {
                    this.mMarketOffersSortDesc = (!(this.mMarketOffersSortDesc));
                }
                else
                {
                    this.mMarketOffersSortDesc = false;
                    this.mMarketOffersSortLastIndex = _arg_1.columnIndex;
                };
                this.mMarketOffersSort.fields = [new SortField(_arg_1.dataField, false, this.mMarketOffersSortDesc)];
            };
        }


    }
}
