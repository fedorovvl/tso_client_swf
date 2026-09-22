package ShopSystem
{
    import flash.utils.Dictionary;
    import Interface.cGeneralInterface;
    import Interface.cGameInterface;
    import ServerState.dResource;
    import ServerState.cResources;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import Communication.VO.dBuyShopItemVO;
    import Enums.COMMAND;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import mx.events.CloseEvent;
    import mx.events.*;
    import flash.net.*;

    public class cShopUtl 
    {

        public const transactionCounter:Dictionary = new Dictionary();

        private var gi:cGeneralInterface;
        private var gameI:cGameInterface;

        public function cShopUtl(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
            this.gameI = (_arg_1 as cGameInterface);
        }

        public function buyable(_arg_1:cShopItem):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            var _local_2:int = this.gi.mCurrentPlayer.GetPurchasedShopItemAmount(_arg_1.GetId());
            var _local_3:Number = this.gi.mCurrentPlayer.GetTimeSinceLastPurchased(_arg_1.GetId());
            var _local_4:int = this.gi.mCurrentPlayer.GetPurchasedDuringEvent(_arg_1.GetId(), _arg_1.GetRequiresEvent());
            var _local_5:int = this.gi.mCurrentPlayer.GetPurchasedInVoteRound(_arg_1.GetId());
            var _local_6:int;
            if (this.transactionCounter[_arg_1])
            {
                _local_6 = this.transactionCounter[_arg_1];
            };
            if (this.gi.mCurrentPlayer.GetPlayerLevel() < _arg_1.GetPlayerLevel())
            {
                return (false);
            };
            if (this.gi.mCurrentPlayer.GetPlayerPvPLevel() < _arg_1.GetPvPLevel())
            {
                return (false);
            };
            if (((_arg_1.GetPerPlayer() > 0) && ((_local_2 + _local_6) >= _arg_1.GetPerPlayer())))
            {
                return (false);
            };
            if (((_arg_1.GetCooldownPerPlayer() > 0) && (_local_3 < _arg_1.GetCooldownPerPlayer())))
            {
                return (false);
            };
            if (((_arg_1.GetPerEvent() > 0) && (_local_4 < _arg_1.GetPerEvent())))
            {
                return (false);
            };
            if (((_arg_1.GetPerVoteRound() > 0) && (_local_5 >= _arg_1.GetPerVoteRound())))
            {
                return (false);
            };
            if (((_arg_1.hideInShop(this.gameI)) || (cShopItemGroup.GetShopItemGroup(_arg_1.GetGroupId()).isHiddenInShop(this.gameI))))
            {
                return (false);
            };
            return (true);
        }

        public function GetRemainingShopItemCount(_arg_1:cShopItem):int
        {
            var _local_13:int;
            var _local_14:int;
            var _local_15:cShopItem;
            var _local_2:int;
            var _local_3:int;
            var _local_4:Boolean = this.gi.mItemRegistry.IsLimitedShopItem(_arg_1);
            var _local_5:Boolean = (((_arg_1.GetPerPlayer() > 0) || (_arg_1.GetPerEvent() > 0)) || (_arg_1.GetPerVoteRound() > 0));
            var _local_6:int = this.gi.mCurrentPlayer.GetPurchasedShopItemAmount(_arg_1.GetId());
            var _local_7:Number = this.gi.mCurrentPlayer.GetTimeSinceLastPurchased(_arg_1.GetId());
            var _local_8:int = this.gi.mCurrentPlayer.GetPurchasedDuringEvent(_arg_1.GetId(), _arg_1.GetRequiresEvent());
            var _local_9:int = this.gi.mCurrentPlayer.GetPurchasedInVoteRound(_arg_1.GetId());
            var _local_10:int = Math.max((_arg_1.GetPerPlayer() - _local_6), 0);
            var _local_11:int = Math.max((_arg_1.GetPerEvent() - _local_8), 0);
            var _local_12:int = Math.max((1 - _local_9), 0);
            if (((_local_7 > 0) && (_local_7 < _arg_1.GetCooldownPerPlayer())))
            {
                return (0);
            };
            if (((!(_local_4)) && (!(_local_5))))
            {
                return (defines.NO_LIMIT);
            };
            _local_2 = (((_arg_1.GetPerPlayer() > 0) && (_arg_1.GetPerEvent() > 0)) ? Math.min(_local_10, _local_11) : Math.max(_local_10, _local_11));
            if (_arg_1.GetPerVoteRound() > 0)
            {
                _local_2 = (((_arg_1.GetPerPlayer() == 0) && (_arg_1.GetPerEvent() == 0)) ? _local_12 : Math.min(_local_12, _local_2));
            };
            if (_local_4)
            {
                _local_13 = 0;
                for each (_local_14 in _arg_1.GetItemsInLimit())
                {
                    _local_15 = cShopItem.GetShopItem(_local_14);
                    if (((_local_15.GetRequiresEvent().length > 0) && (this.gi.mEventManager.isEventStarted(_local_15.GetRequiresEvent()))))
                    {
                        _local_13 = (_local_13 + Math.max((_local_15.GetPerEvent() - this.gi.mCurrentPlayer.GetPurchasedDuringEvent(_local_15.GetId(), _local_15.GetRequiresEvent())), 0));
                    };
                    if (_local_15.GetPerPlayer() > 0)
                    {
                        _local_13 = (_local_13 + Math.max((_local_15.GetPerPlayer() - this.gi.mCurrentPlayer.GetPurchasedShopItemAmount(_local_15.GetId())), 0));
                    };
                };
                _local_3 = (this.gi.mItemRegistry.GetRemainingAmountForShopItem(_arg_1) - _local_13);
            };
            if (_local_4)
            {
                if (_local_5)
                {
                    return (Math.max(0, Math.min(_local_2, _local_3)));
                };
                return (Math.max(0, _local_3));
            };
            return (Math.max(0, _local_2));
        }

        public function buy(_arg_1:cShopItem, _arg_2:int, _arg_3:int=0):Boolean
        {
            var _local_6:dResource;
            var _local_4:cResources = this.gi.mCurrentPlayerZone.GetResources(this.gi.mCurrentPlayer);
            if (!_local_4.HasPlayerResourcesInListOne(_arg_1.GetCosts_vector()))
            {
                for each (_local_6 in _arg_1.GetCosts_vector())
                {
                    if (((_local_6.name_string == defines.HARD_CURRENCY_RESOURCE_NAME_string) && (!(_local_4.HasPlayerResource(_local_6.name_string, _local_6.amount)))))
                    {
                        CustomAlert.show("ItemPurchaseSwitchToBuyGems", "", (Alert.OK | Alert.CANCEL), null, this.ConfirmAddHardCurrency, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
                        return (false);
                    };
                    CustomAlert.show("ItemPurchaseMissingResource", "ItemPurchaseMissingResource", Alert.OK);
                    return (false);
                };
            };
            var _local_5:dBuyShopItemVO = new dBuyShopItemVO();
            _local_5.itemID = _arg_1.GetId();
            _local_5.transactionFrom = _arg_2;
            _local_5.giftedPlayerID = _arg_3;
            this.gi.mClientMessages.SendMessagetoServer(COMMAND.BUY_SHOP_ITEM, this.gi.mCurrentViewedZoneID, _local_5);
            if (this.transactionCounter[_arg_1])
            {
                this.transactionCounter[_arg_1]++;
            }
            else
            {
                this.transactionCounter[_arg_1] = 1;
            };
            return (true);
        }

        public function showDetails(_arg_1:cShopItem):void
        {
            globalFlash.gui.mShopWindow.showItem(_arg_1);
        }

        public function ConfirmAddHardCurrency(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                navigateToURL(new URLRequest((global.baseUri + defines.PAYMENT_URL)), "_blank");
            };
        }


    }
}
