package ServerState
{
    import Interface.cGeneralInterface;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;
    import Communication.VO.TradeWindow.dTradeObjectVO;
    import Communication.VO.dAcceptTradeVO;
    import Communication.VO.dTradeCompleteVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.TRADE_STATUS;
    import Enums.COMMAND;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Enums.TRADE_SLOT_TYPE;
    import mx.collections.Sort;
    import mx.collections.SortField;
    import __AS3__.vec.*;

    public class cTradeWindowData 
    {

        private var mTrigerredOnce:Boolean = false;
        private var mGI:cGeneralInterface;

        private var mPlacedOffer_vector:ArrayCollection = new ArrayCollection();
        private var mTradeHistoryVector:ArrayCollection = new ArrayCollection();
        public var acceptedOffers:Vector.<cTradeObject> = new Vector.<cTradeObject>();

        public function cTradeWindowData(_arg_1:cGeneralInterface)
        {
            super();
            this.mGI = _arg_1;
        }

        public function setUserPlacedOffers(_arg_1:ArrayCollection):void
        {
            var _local_2:dTradeObjectVO;
            var _local_3:cTradeObject;
            for each (_local_2 in _arg_1)
            {
                if (!this.entryAlreadyExists(_local_2.id, this.mPlacedOffer_vector))
                {
                    _local_3 = new cTradeObject(_local_2.offer, _local_2.type);
                    _local_3.tradeID = _local_2.id;
                    _local_3.senderID = _local_2.senderID;
                    _local_3.receiverID = _local_2.receiverID;
                    _local_3.slotType = _local_2.slotType;
                    _local_3.slotPos = _local_2.slotPos;
                    _local_3.senderName = _local_2.senderName;
                    _local_3.createdTime = _local_2.created;
                    _local_3.remainingTime = _local_2.remainingTime;
                    _local_3.remainingLots = _local_2.lotsRemaining;
                    _local_3.deleted = _local_2.deleted;
                    _local_3.isTradeCancled = _local_2.isTradeCancled;
                    _local_3.coolDownTime = _local_2.coolDownTime;
                    _local_3.status = this.getTradeStatus(_local_3);
                    this.mPlacedOffer_vector.addItem(_local_3);
                };
            };
            this.rearrangeOffers(null);
            globalFlash.gui.mTradeWindow.setPaidSlotsPrice();
            globalFlash.gui.mTradeWindow.setWaitingForServer(false);
        }

        public function updateHistoryWithBoughtTrade(_arg_1:dAcceptTradeVO):void
        {
            var _local_3:cTradeObject;
            var _local_4:cTradeObject;
            if (this.entryAlreadyExists(_arg_1.id, this.mTradeHistoryVector))
            {
                return;
            };
            var _local_2:Boolean;
            for each (_local_3 in this.acceptedOffers)
            {
                if (_local_3.tradeID == _arg_1.id)
                {
                    _local_4 = new cTradeObject(null, 0);
                    _local_4.tradeID = _arg_1.id;
                    _local_4.senderID = this.mGI.mCurrentPlayer.GetPlayerId();
                    _local_4.receiverID = _arg_1.senderID;
                    _local_4.senderName = _local_3.senderName;
                    _local_4.slotType = _local_3.slotType;
                    _local_4.slotPos = _local_3.slotPos;
                    _local_4.slotValue = _local_3.slotValue;
                    _local_4.offer = _local_3.offer;
                    _local_4.costs = _local_3.costs;
                    _local_4.createdTime = new Date().getTime();
                    _local_4.remainingTime = _local_3.remainingTime;
                    _local_4.totalLots = _local_3.totalLots;
                    _local_4.remainingLots = 1;
                    _local_4.deleted = _local_3.deleted;
                    _local_4.coolDownTime = _local_3.coolDownTime;
                    _local_4.isTradeCancled = _local_3.isTradeCancled;
                    _local_4.isAffordable = _local_3.isAffordable;
                    _local_4.status = this.getTradeStatus(_local_4);
                    this.mTradeHistoryVector.addItem(_local_4);
                    globalFlash.gui.mTradeWindow.setTradeHistoryData(this.mTradeHistoryVector);
                    _local_2 = true;
                    break;
                };
            };
            if (!_local_2)
            {
                globalFlash.gui.mTradeWindow.reloadHistory();
            };
        }

        public function setTradeHistroyData(_arg_1:ArrayCollection):void
        {
            var _local_2:dTradeObjectVO;
            var _local_4:int;
            var _local_5:cTradeObject;
            var _local_3:Vector.<int> = new Vector.<int>();
            for each (_local_2 in _arg_1)
            {
                _local_3.push(_local_2.id);
            };
            _local_4 = (this.mTradeHistoryVector.length - 1);
            while (_local_4 >= 0)
            {
                if (_local_3.lastIndexOf(this.mTradeHistoryVector.getItemAt(_local_4).tradeID) >= 0)
                {
                    this.mTradeHistoryVector.removeItemAt(_local_4);
                };
                _local_4--;
            };
            for each (_local_2 in _arg_1)
            {
                _local_5 = new cTradeObject(_local_2.offer, _local_2.type);
                _local_5.tradeID = _local_2.id;
                _local_5.senderID = _local_2.senderID;
                _local_5.receiverID = _local_2.receiverID;
                _local_5.slotType = _local_2.slotType;
                _local_5.slotPos = _local_2.slotPos;
                _local_5.senderName = _local_2.senderName;
                _local_5.createdTime = _local_2.created;
                _local_5.remainingTime = _local_2.remainingTime;
                _local_5.remainingLots = _local_2.lotsRemaining;
                _local_5.deleted = _local_2.deleted;
                _local_5.isTradeCancled = _local_2.isTradeCancled;
                _local_5.coolDownTime = _local_2.coolDownTime;
                _local_5.status = this.getTradeStatus(_local_5);
                this.mTradeHistoryVector.addItem(_local_5);
            };
            globalFlash.gui.mTradeWindow.setTradeHistoryData(this.mTradeHistoryVector);
        }

        public function removeTradeOffer(_arg_1:cTradeObject):void
        {
            var _local_2:int = this.mPlacedOffer_vector.getItemIndex(_arg_1);
            if (_local_2 >= 0)
            {
                this.mPlacedOffer_vector.removeItemAt(_local_2);
                this.rearrangeOffers(null);
            };
        }

        public function updateHistoryWithAcceptedTrade(_arg_1:dTradeCompleteVO, _arg_2:int):void
        {
            var _local_4:cTradeObject;
            var _local_5:cTradeObject;
            if (this.entryAlreadyExists(_arg_1.tradeID, this.mTradeHistoryVector))
            {
                return;
            };
            var _local_3:Boolean;
            for each (_local_4 in this.mPlacedOffer_vector)
            {
                if (_local_4.tradeID == _arg_1.offerAcceptedID)
                {
                    _local_4.remainingLots--;
                    _local_5 = new cTradeObject(null, 0);
                    _local_5.tradeID = _arg_1.tradeID;
                    _local_5.senderID = _arg_1.buyerID;
                    _local_5.receiverID = _arg_2;
                    _local_5.senderName = _arg_1.buyerName;
                    _local_5.slotType = _local_4.slotType;
                    _local_5.slotPos = _local_4.slotPos;
                    _local_5.slotValue = _local_4.slotValue;
                    _local_5.offer = _local_4.offer;
                    _local_5.costs = _local_4.costs;
                    _local_5.createdTime = new Date().getTime();
                    _local_5.remainingTime = _local_4.remainingTime;
                    _local_5.totalLots = _local_4.totalLots;
                    _local_5.remainingLots = 1;
                    _local_5.deleted = _local_4.deleted;
                    _local_5.coolDownTime = _local_4.coolDownTime;
                    _local_5.isTradeCancled = _local_4.isTradeCancled;
                    _local_5.isAffordable = _local_4.isAffordable;
                    _local_5.status = this.getTradeStatus(_local_5);
                    this.mTradeHistoryVector.addItem(_local_5);
                    globalFlash.gui.mTradeWindow.setTradeHistoryData(this.mTradeHistoryVector);
                    if (_local_4.remainingLots > 0)
                    {
                        globalFlash.gui.mTradeWindow.refreshUserOfferList();
                    }
                    else
                    {
                        this.rearrangeOffers(null);
                    };
                    _local_3 = true;
                    break;
                };
            };
            if (!_local_3)
            {
                globalFlash.gui.mTradeWindow.reloadHistory();
            };
        }

        private function getTradeStatus(_arg_1:cTradeObject):int
        {
            var _local_2:Number = _arg_1.remainingTime;
            var _local_3:int = _arg_1.totalLots;
            var _local_4:int = _arg_1.remainingLots;
            if (_arg_1.receiverID > 0)
            {
                if (_arg_1.receiverID != this.mGI.mHomePlayer.GetPlayerId())
                {
                    _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Bought");
                    return (TRADE_STATUS.TRADE_EXPIRED_SOLDTO);
                };
                _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Sold");
                return (TRADE_STATUS.TRADE_EXPIRED_SOLDTO);
            };
            if (_arg_1.isTradeCancled)
            {
                if (_arg_1.coolDownTime > 0)
                {
                    _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "CancledAndCoolDown", [cLocaManager.GetInstance().FormatDuration(_arg_1.coolDownTime, cLocaManager.DURATION_FORMAT_SHORT)]);
                    return (TRADE_STATUS.TRADE_EXPIRED);
                };
                _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Cancled");
                return (TRADE_STATUS.TRADE_EXPIRED);
            };
            if (_local_4 == 0)
            {
                _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Sold");
                return (TRADE_STATUS.TRADE_EXPIRED_SOLDTO);
            };
            if (_local_2 <= 0)
            {
                if (_local_3 == 1)
                {
                    if (_local_4 == 0)
                    {
                        _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Sold");
                        return (TRADE_STATUS.TRADE_EXPIRED_SOLDTO);
                    };
                    _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Expired");
                    return (TRADE_STATUS.TRADE_EXPIRED);
                };
                if (_local_3 > 1)
                {
                    if (_local_4 == 0)
                    {
                        _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Sold");
                        return (TRADE_STATUS.TRADE_EXPIRED_ALL_SOLD);
                    };
                    if (_local_4 == _local_3)
                    {
                        _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Expired");
                        return (TRADE_STATUS.TRADE_EXPIRED);
                    };
                    _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Expired");
                    return (TRADE_STATUS.TRADE_EXPIRED_SOME_SOLD);
                };
            };
            if (((_local_2 <= 0) || (!(_arg_1.deleted == 0))))
            {
                _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Expired");
                return (TRADE_STATUS.TRADE_EXPIRED);
            };
            _arg_1.runningTime = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Expires", [cLocaManager.GetInstance().FormatDuration(_local_2, cLocaManager.DURATION_FORMAT_SHORT)]);
            return (TRADE_STATUS.TRADE_TIMER_STATE);
        }

        private function entryAlreadyExists(_arg_1:int, _arg_2:ArrayCollection):Boolean
        {
            var _local_3:cTradeObject;
            for each (_local_3 in _arg_2)
            {
                if (_local_3.tradeID == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function removeTradeHistory(_arg_1:cTradeObject):void
        {
            var _local_2:int = this.mTradeHistoryVector.getItemIndex(_arg_1);
            if (_local_2 >= 0)
            {
                this.mTradeHistoryVector.removeItemAt(_local_2);
            };
        }

        public function getNextFreeSlotForType(_arg_1:int):int
        {
            var _local_5:cTradeObject;
            var _local_2:int;
            var _local_3:int = this.mPlacedOffer_vector.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = (this.mPlacedOffer_vector[_local_4] as cTradeObject);
                if ((((_local_5.slotType == _arg_1) && (_local_5.slotPos == _local_2)) && ((_local_5.status == TRADE_STATUS.TRADE_TIMER_STATE) || (_local_5.coolDownTime > 0))))
                {
                    _local_2++;
                    _local_4 = -1;
                };
                _local_4++;
            };
            return (_local_2);
        }

        public function refreshUserPlacedOffers():void
        {
            if (!this.mTrigerredOnce)
            {
                this.mTrigerredOnce = true;
                globalFlash.gui.mTradeWindow.setWaitingForServer(true);
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.TRADE_GET_USER_TRADES, this.mGI.mCurrentViewedZoneID, null);
                this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_TRADE_HISTORY, this.mGI.mCurrentViewedZoneID, null);
            };
        }

        public function computeTradeWindow():void
        {
            var _local_4:cTradeObject;
            var _local_5:cTradeObject;
            if (this.mGI.mCurrentPlayerZone.IsBuildingOnMap(defines.LOGISTICS_NAME_string))
            {
                if (globalFlash.gui.mTradeWindow.mOffersRefreshed)
                {
                    globalFlash.gui.mTradeWindow.mUpdateRefreshTimer++;
                    globalFlash.gui.mTradeWindow.updateRefreshOffersTooltip();
                    if (globalFlash.gui.mTradeWindow.mUpdateRefreshTimer == global.tradeRefreshInterval)
                    {
                        globalFlash.gui.mTradeWindow.mUpdateRefreshTimer = 0;
                        globalFlash.gui.mTradeWindow.enableRefreshOffers(true);
                    };
                };
            };
            var _local_1:int = globalFlash.gui.mTradeWindow.mAvailableOfferVector.length;
            var _local_2:int = (_local_1 - 1);
            while (_local_2 >= 0)
            {
                _local_5 = globalFlash.gui.mTradeWindow.mAvailableOfferVector[_local_2];
                if (_local_5.remainingTime > 0)
                {
                    _local_5.remainingTime = (_local_5.remainingTime - (1000 * this.mGI.mGlobalTimeScale));
                };
                _local_2--;
            };
            var _local_3:Boolean;
            for each (_local_4 in this.mPlacedOffer_vector)
            {
                if (_local_4.remainingLots == 0)
                {
                    if (_local_4.remainingTime != -(_local_4.tradeID))
                    {
                        _local_3 = true;
                        _local_4.remainingTime = -(_local_4.tradeID);
                    };
                }
                else
                {
                    _local_4.remainingTime = (_local_4.remainingTime - (1000 * this.mGI.mGlobalTimeScale));
                    if (((_local_4.remainingTime <= 0) && (_local_4.deleted == 0)))
                    {
                        _local_3 = true;
                    };
                    if (_local_4.coolDownTime > 0)
                    {
                        _local_4.coolDownTime = (_local_4.coolDownTime - (1000 * this.mGI.mGlobalTimeScale));
                        if (((_local_4.coolDownTime <= 0) && (!(_local_4.deleted == 0))))
                        {
                            _local_3 = true;
                            _local_4.remainingTime = -(_local_4.tradeID);
                        };
                    };
                };
                _local_4.status = this.getTradeStatus(_local_4);
                if (((_local_4.status == TRADE_STATUS.TRADE_EXPIRED) || (_local_4.status == TRADE_STATUS.TRADE_EXPIRED_SOME_SOLD)))
                {
                    if (_local_4.coolDownTime <= 0)
                    {
                        _local_3 = true;
                    };
                    if (((_local_4.deleted == 0) && (this.mGI.GetClientTime() > 0)))
                    {
                        _local_4.deleted = ((_local_4.createdTime + global.tradeExpirationTime) - ((_local_4.remainingTime <= 0) ? 0 : _local_4.remainingTime));
                        if (_local_4.remainingLots > 0)
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TRADE_EXPIRED);
                        };
                    };
                };
            };
            if (_local_3)
            {
                this.rearrangeOffers(null);
            };
            globalFlash.gui.mTradeWindow.setPaidSlotsPrice();
        }

        public function rearrangeOffers(_arg_1:dTradeCompleteVO):void
        {
            var _local_3:int;
            var _local_6:cTradeObject;
            var _local_11:cTradeObject;
            var _local_12:cTradeObject;
            var _local_13:int;
            var _local_14:int;
            var _local_2:ArrayCollection = new ArrayCollection();
            if (this.mPlacedOffer_vector.length > 0)
            {
                _local_3 = (this.mPlacedOffer_vector.length - 1);
                while (_local_3 >= 0)
                {
                    if (((this.mPlacedOffer_vector[_local_3].remainingLots <= 0) || ((!(this.mPlacedOffer_vector[_local_3].deleted == 0)) && (this.mPlacedOffer_vector[_local_3].coolDownTime <= 0))))
                    {
                        if (this.mPlacedOffer_vector[_local_3].remainingLots > 0)
                        {
                            _local_2.addItem(this.mPlacedOffer_vector[_local_3]);
                        };
                        this.mPlacedOffer_vector.removeItemAt(_local_3);
                    };
                    _local_3--;
                };
            };
            var _local_4:ArrayCollection = new ArrayCollection();
            var _local_5:cTradeObject;
            for each (_local_6 in this.mPlacedOffer_vector)
            {
                if (_local_6.slotType == TRADE_SLOT_TYPE.FREE_SLOT)
                {
                    _local_6.slotValue = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Free");
                    _local_5 = _local_6;
                    break;
                };
            };
            if (_local_5 == null)
            {
                _local_5 = new cTradeObject(null, 0);
                _local_5.slotType = TRADE_SLOT_TYPE.FREE_SLOT;
                _local_5.slotValue = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Free");
            };
            _local_4.addItem(_local_5);
            var _local_7:ArrayCollection = new ArrayCollection();
            var _local_8:ArrayCollection = new ArrayCollection();
            _local_3 = 0;
            while (_local_3 < this.mPlacedOffer_vector.length)
            {
                switch (this.mPlacedOffer_vector[_local_3].slotType)
                {
                    case TRADE_SLOT_TYPE.PAID_SLOT_WITH_COINS:
                        _local_8.addItem(this.mPlacedOffer_vector[_local_3]);
                        break;
                    case TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS:
                        _local_7.addItem(this.mPlacedOffer_vector[_local_3]);
                        break;
                };
                _local_3++;
            };
            var _local_9:Sort = new Sort();
            _local_9.fields = [new SortField("remainingTime", false, false)];
            _local_8.sort = _local_9;
            _local_8.refresh();
            _local_7.sort = _local_9;
            _local_7.refresh();
            var _local_10:ArrayCollection = new ArrayCollection();
            _local_3 = 0;
            while (_local_3 < global.activateSlotsWithCoins_vector.length)
            {
                if (_local_8.length == 0) break;
                _local_14 = _local_8.length;
                _local_13 = 0;
                while (_local_13 < _local_14)
                {
                    _local_12 = (_local_8[_local_13] as cTradeObject);
                    if (_local_12.slotPos == _local_3)
                    {
                        _local_12.slotValue = global.activateSlotsWithCoins_vector[_local_3].toString();
                        _local_11 = _local_12;
                        _local_8.removeItemAt(_local_13);
                        break;
                    };
                    _local_13++;
                };
                if (_local_11 == null)
                {
                    _local_11 = new cTradeObject(null, 0);
                    _local_11.slotType = TRADE_SLOT_TYPE.PAID_SLOT_WITH_COINS;
                    _local_11.slotPos = _local_3;
                    _local_11.slotValue = global.activateSlotsWithCoins_vector[_local_3].toString();
                };
                _local_4.addItem(_local_11);
                _local_11 = null;
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < global.activateSlotsWithGems_vector.length)
            {
                if (_local_7.length == 0) break;
                _local_14 = _local_7.length;
                _local_13 = 0;
                while (_local_13 < _local_14)
                {
                    _local_12 = (_local_7[_local_13] as cTradeObject);
                    if (_local_12.slotPos == _local_3)
                    {
                        _local_12.slotValue = global.activateSlotsWithGems_vector[_local_3].toString();
                        _local_11 = _local_12;
                        _local_7.removeItemAt(_local_13);
                        break;
                    };
                    _local_13++;
                };
                if (_local_11 == null)
                {
                    _local_11 = new cTradeObject(null, 0);
                    _local_11.slotType = TRADE_SLOT_TYPE.PAID_SLOT_WITH_GEMS;
                    _local_11.slotPos = _local_3;
                    _local_11.slotValue = global.activateSlotsWithGems_vector[_local_3].toString();
                };
                _local_4.addItem(_local_11);
                _local_11 = null;
                _local_3++;
            };
            if (_local_2.length > 0)
            {
                this.mTradeHistoryVector.addAll(_local_2);
                globalFlash.gui.mTradeWindow.setTradeHistoryData(this.mTradeHistoryVector);
            };
            globalFlash.gui.mTradeWindow.setUserPlacedOffersData(_local_4, true);
        }


    }
}
