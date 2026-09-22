package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.BuildQueue;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import Enums.COMMAND;
    import Communication.VO.dBuyOneClickShopItemVO;
    import Enums.ONE_CLICK_SHOPITEM;
    import mx.events.ListEvent;
    import GO.cBuilding;
    import ServerState.cResources;
    import GUI.Components.CustomAlert;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import Communication.VO.dTempBuildSlotVO;
    import GO.cBuildSlot;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import __AS3__.vec.Vector;
    import ShopSystem.cShopItem;

    public class cBuildQueue extends cGuiBaseElement 
    {

        public static const MOVE_UP:String = "BuildQueueMoveUp";
        public static const MOVE_DOWN:String = "BuildQueueMoveDown";
        public static const REMOVE:String = "BuildQueueRemove";
        public static const INSTANT_BUILD:String = "BuildQueueInstantBuild";

        private var mIndexToDelete:int = -1;
        private var mGI:cGameInterface;
        protected var mBuildQueue:BuildQueue;


        private function Remove(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mGI.mCurrentPlayer.mBuildQueue.RemoveGui(this.mIndexToDelete);
        }

        private function AddATempBuildSlot(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, global.ui.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().Init(ONE_CLICK_SHOPITEM.BUY_TEMP_BUILD_QUEUE_SLOT));
            }
            else
            {
                this.SetEnableBuyTempBuildSlot(true);
            };
        }

        private function MoveUp(_arg_1:ListEvent):void
        {
            this.mGI.mCurrentPlayer.mBuildQueue.MoveUpGui(_arg_1.rowIndex);
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("BuildingQueueUp");
            global.getApplication().inputNotifier.notifyClick("BuildingQueueUp");
        }

        private function InstantBuild(_arg_1:ListEvent):void
        {
            var _local_2:cBuilding = this.mGI.mCurrentPlayerZone.GetBuildingFromGridPosition(_arg_1.rowIndex);
            var _local_3:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            if (_local_3.HasPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string, _local_2.GetBuildInstantCosts()))
            {
                global.ui.mClientMessages.SendMessagetoServer(COMMAND.BUY_ONE_CLICK_SHOP_ITEM, this.mGI.mCurrentViewedZoneID, new dBuyOneClickShopItemVO().InitWithBuildingGrid(ONE_CLICK_SHOPITEM.INSTANT_BUILDING_CONSTRUCTION, _local_2.GetGrid()));
            }
            else
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mBuildQueue.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mBuildQueue.addEventListener(cBuildQueue.MOVE_UP, this.MoveUp);
            this.mBuildQueue.addEventListener(cBuildQueue.MOVE_DOWN, this.MoveDown);
            this.mBuildQueue.addEventListener(cBuildQueue.REMOVE, this.ConfirmRemoveBuilding);
            this.mBuildQueue.addEventListener(cBuildQueue.INSTANT_BUILD, this.InstantBuild);
            this.mBuildQueue.buildExtension.btnBuyTempSlot.addEventListener(MouseEvent.CLICK, this.BuyTempSlot);
        }

        private function MoveDown(_arg_1:ListEvent):void
        {
            this.mGI.mCurrentPlayer.mBuildQueue.MoveDownGui(_arg_1.rowIndex);
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("BuildingQueueDown");
            global.getApplication().inputNotifier.notifyClick("BuildingQueueDown");
        }

        private function AddHardCurrencyHandler(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.OK)
            {
                globalFlash.gui.mShopWindow.AddHardCurrency(null);
            };
        }

        public function Init(_arg_1:BuildQueue):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mBuildQueue = _arg_1;
            this.mBuildQueue.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function ConfirmRemoveBuilding(_arg_1:ListEvent):void
        {
            this.mIndexToDelete = _arg_1.rowIndex;
            var _local_2:CustomAlert = CustomAlert.show("ConfirmBuildingCancel", "ConfirmBuildingCancel", (Alert.CANCEL | Alert.OK), null, this.Remove);
            _local_2.addEventListener(CloseEvent.CLOSE, this.Remove);
        }

        public function SetData(_arg_1:Vector.<cBuilding>):void
        {
            var _local_4:cBuilding;
            var _local_7:dTempBuildSlotVO;
            var _local_8:int;
            var _local_9:cBuildSlot;
            var _local_2:Array = [];
            var _local_3:int = this.mGI.mHomePlayer.GetPermanentBuildQueueSlotsCount();
            for each (_local_4 in _arg_1)
            {
                _local_2.push(_local_4);
            };
            if (_local_2.length > 0)
            {
                while (_local_2.length < this.mGI.mHomePlayer.mBuildQueue.GetTotalAvailableSlots())
                {
                    if (_local_2.length < (this.mGI.mHomePlayer.mBuildQueue.GetMaxCount() + _local_3))
                    {
                        _local_9 = new cBuildSlot(0, 0, 0);
                        _local_9.mType = ((_local_2.length >= this.mGI.mHomePlayer.mBuildQueue.GetMaxCount()) ? cBuildSlot.PERMANENT_BUILDSLOT : cBuildSlot.REGULAR_BUILDSLOT);
                    }
                    else
                    {
                        _local_9 = this.mGI.mHomePlayer.mBuildQueue.GetTempSlots_vector()[(_local_2.length - (_local_3 + this.mGI.mHomePlayer.mBuildQueue.GetMaxCount()))];
                    };
                    _local_2.push(_local_9);
                };
            };
            if (((_local_2.length > 0) && (!(this.IsVisible()))))
            {
                this.Show();
            }
            else
            {
                if (_local_2.length == 0)
                {
                    this.Hide();
                };
            };
            var _local_5:Number = this.mBuildQueue.list.verticalScrollPosition;
            this.mBuildQueue.list.dataProvider = _local_2;
            this.mBuildQueue.list.verticalScrollPosition = _local_5;
            var _local_6:int;
            for each (_local_7 in this.mGI.mHomePlayer.mAvailableTempSlots_vector)
            {
                if (_local_7.isPremiumSlot())
                {
                    _local_6++;
                };
            };
            _local_8 = (this.mGI.mHomePlayer.mBuildQueue.GetTempSlots_vector().length - _local_6);
            if (_local_8 < 0)
            {
                _local_8 = 0;
            };
            this.mBuildQueue.buildExtension.btnBuyTempSlot.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.SHOP_ITEMS, "TempBuildSlot", [_local_8, global.maxTempSlotsAvailablePerPlayer, cLocaManager.GetInstance().FormatDuration(global.tempSlotDuration)]);
            this.mBuildQueue.width = ((this.mBuildQueue.list.measureHeightOfItems() > this.mBuildQueue.list.height) ? 110 : 93);
        }

        public function SetEnableBuyTempBuildSlot(_arg_1:Boolean):void
        {
            this.mBuildQueue.buildExtension.btnBuyTempSlot.enabled = _arg_1;
        }

        private function BuyTempSlot(_arg_1:MouseEvent):void
        {
            var _local_2:cShopItem = cShopItem.GetShopItem(ONE_CLICK_SHOPITEM.BUY_TEMP_BUILD_QUEUE_SLOT);
            var _local_3:cResources = global.ui.mCurrentPlayerZone.GetResources(global.ui.mCurrentPlayer);
            if (_local_3.HasPlayerResourcesInList(_local_2.GetCosts_vector(), 1))
            {
                this.SetEnableBuyTempBuildSlot(false);
                CustomAlert.show("ConfirmAddTempBuildQueueSlot", "ConfirmAddTempBuildQueueSlot", (Alert.OK | Alert.CANCEL), null, this.AddATempBuildSlot, null, Alert.OK, true, CustomAlert.STYLE_DEFAULT);
            }
            else
            {
                CustomAlert.show("MissingHardCurrency", "", (Alert.OK | Alert.CANCEL), null, this.AddHardCurrencyHandler, null, Alert.OK, true, CustomAlert.STYLE_PAYMENT);
            };
        }


    }
}
