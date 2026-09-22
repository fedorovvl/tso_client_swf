package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.ShopWindow;
    import ShopSystem.cShopItem;
    import Communication.VO.dPlayerListItemVO;
    import ShopSystem.cShopItemGroup;
    import flash.events.MouseEvent;
    import ShopSystem.cItemContent;
    import Specialists.cSpecialist;
    import mx.events.FlexEvent;
    import AdventureSystem.cAdventureDefinition;
    import Enums.SPECIALIST_TYPE;
    import mx.events.ToolTipEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.ITEM_CONTENT_TYPE;
    import GUI.Effects.gHintManager;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ListEvent;
    import ShopSystem.dBanner;
    import GUI.Components.TSOImage;
    import com.bluebyte.tso.util.ClientLogger;
    import GUI.FloatingItemsManager;
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import nLib.gMisc;
    import Utils.StringUtils;
    import ServerState.cResources;
    import GUI.Assets.gAssetManager;
    import GUI.helpers.GraphicsHelpers;

    public class cShopWindow extends cBasicPanel 
    {

        private var mGI:cGameInterface;
        protected var mPanel:ShopWindow;
        private var mSelectedItem:cShopItem = null;
        private var mIsDeepLink:Boolean = false;
        private var mBannersMap:Object = {};
        public var origin:int = 0;
        private var mIsBuyingHardCurrency:Boolean = false;
        private var setGroupByString:Boolean = false;
        private var useShopBannerGroup:String = "UNDEFINED";
        private var mGiftPlayer:dPlayerListItemVO;


        public function ShowDeepLink(_arg_1:String, _arg_2:int, _arg_3:int=0, _arg_4:int=-1):void
        {
            this.mIsDeepLink = true;
            this.Show();
            var _local_5:cShopItem = cShopItem.GetShopItem(_arg_2);
            if (((_local_5) && ((!(this.mGI.mSpecificShopItems)) || (this.mGI.mEnabledShopItems_vector.contains(_local_5.GetId())))))
            {
                this.mPanel.groupsList.selectedItem = cShopItemGroup.GetShopItemGroup(_local_5.GetGroupId());
                this.SelectGroup(null);
                this.mPanel.shopItems.selectedItem = _local_5;
                this.ShowItemDetails(null);
                return;
            };
            if (_arg_3 <= 0)
            {
                return;
            };
            var _local_6:cShopItemGroup = cShopItemGroup.GetShopItemGroup(_arg_3);
            if (_local_6)
            {
                this.mPanel.groupsList.selectedItem = _local_6;
                this.SelectGroup(null);
                this.mPanel.itemsStack.selectedIndex = 0;
                if (_arg_4 > 0)
                {
                    _local_5 = cShopItem.GetShopItem(_arg_4);
                    if (_local_5)
                    {
                        this.mPanel.shopItems.selectedItem = _local_5;
                        this.mPanel.shopItems.validateNow();
                        this.mPanel.shopItems.scrollToIndex(this.mPanel.shopItems.selectedIndex);
                    };
                };
                return;
            };
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.origin = defines.TRANSACTION_FROM_SHOP;
            this.Hide();
        }

        private function EnterDetailsState(_arg_1:FlexEvent):void
        {
            var _local_5:cItemContent;
            var _local_6:int;
            var _local_7:Number;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:cSpecialist;
            var _local_13:int;
            if (!this.mPanel.frame)
            {
                this.mPanel.itemDetails.addEventListener(FlexEvent.CREATION_COMPLETE, this.EnterDetailsState);
                return;
            };
            if (this.mSelectedItem == null)
            {
                return;
            };
            if (_arg_1)
            {
                this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.EnterDetailsState);
            };
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(this.mSelectedItem.GetShopItemContent_vector()[0].GetResourceName_string());
            if (_local_2)
            {
                this.mPanel.frame.adventureType = _local_2.GetType_string();
                this.mPanel.frame.adventureDifficulty = _local_2.GetDifficulty();
            }
            else
            {
                this.mPanel.frame.adventureType = "";
                this.mPanel.frame.adventureDifficulty = 0;
            };
            this.mPanel.frame.content = this.mSelectedItem.GetName_string();
            this.mPanel.frame.type = this.mSelectedItem.GetFrameType_string();
            var _local_3:String = this.mSelectedItem.GetShopItemContent_vector()[0].GetName_string();
            if (((SPECIALIST_TYPE.isNameValid(_local_3)) && (SPECIALIST_TYPE.IsGeneral(SPECIALIST_TYPE.parse(_local_3)))))
            {
                this.mPanel.frame.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.ShowGeneralTooltip);
                this.mPanel.frame.toolTip = _local_3;
                _local_11 = SPECIALIST_TYPE.parse((this.mSelectedItem as cShopItem).GetShopItemContent_vector()[0].GetName_string());
                _local_12 = new cSpecialist(false).InitSpecialistFromType(_local_11, null, global.ui.mHomePlayer.getPlayerID(), global.ui.mHomePlayer.getPlayerID(), global.ui);
                this.mPanel.itemGeneralStats.setData(_local_12);
                this.mPanel.itemGeneralStats.skillLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Traits");
                this.mPanel.itemGeneralStats.visible = (this.mPanel.itemGeneralStats.includeInLayout = true);
                this.mPanel.itemDescription3.visible = (this.mPanel.itemDescription3.includeInLayout = false);
            }
            else
            {
                this.mPanel.frame.removeEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.ShowGeneralTooltip);
                this.mPanel.frame.toolTip = "";
                this.mPanel.itemGeneralStats.visible = (this.mPanel.itemGeneralStats.includeInLayout = false);
                this.mPanel.itemDescription3.visible = (this.mPanel.itemDescription3.includeInLayout = true);
            };
            this.mPanel.nameLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.SHOP_ITEMS, this.mSelectedItem.GetName_string());
            this.mPanel.costsLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Costs");
            var _local_4:Boolean = true;
            for each (_local_5 in this.mSelectedItem.GetShopItemContent_vector())
            {
                if (((!(_local_5.GetType() == ITEM_CONTENT_TYPE.RESOURCE)) || (_local_5.GetResourceName_string() == defines.HARD_CURRENCY_RESOURCE_NAME_string)))
                {
                    _local_4 = false;
                    break;
                };
            };
            _local_6 = this.mGI.mCurrentPlayer.GetPurchasedShopItemAmount(this.mSelectedItem.GetId());
            _local_7 = this.mGI.mCurrentPlayer.GetTimeSinceLastPurchased(this.mSelectedItem.GetId());
            _local_8 = this.mGI.mCurrentPlayer.GetPurchasedDuringEvent(this.mSelectedItem.GetId(), this.mSelectedItem.GetRequiresEvent());
            _local_9 = this.mGI.mCurrentPlayer.GetPurchasedInVoteRound(this.mSelectedItem.GetId());
            _local_10 = this.mGI.shopManager.GetRemainingShopItemCount(this.mSelectedItem);
            this.mPanel.remainingItemsBadge.visible = false;
            this.mPanel.headerContent.setStyle("horizontalCenter", 0);
            this.mPanel.itemOnCooldownBadge.visible = false;
            if (_local_10 != defines.NO_LIMIT)
            {
                this.mPanel.remainingItemsBadge.visible = true;
                this.mPanel.headerContent.setStyle("horizontalCenter", -50);
            };
            if (this.mSelectedItem.GetCooldownPerPlayer() > 0)
            {
                if (_local_7 < this.mSelectedItem.GetCooldownPerPlayer())
                {
                    this.mPanel.headerContent.setStyle("horizontalCenter", -50);
                    this.mPanel.itemOnCooldownBadge.visible = true;
                    _local_13 = (this.mSelectedItem.GetCooldownPerPlayer() - _local_7);
                    this.mPanel.itemOnCooldownTime.text = cLocaManager.GetInstance().FormatDuration((_local_13 * 60000), cLocaManager.DURATION_FORMAT_NORMAL);
                };
            };
            this.mPanel.remainingItems.text = (_local_10 + "x");
            if (_local_10 > 0)
            {
                this.mPanel.remainingItemsBadge.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "RemainingItemsPerPlayer", [_local_10.toString()]);
                this.mPanel.remainingItems.setStyle("color", 0xFFFFFF);
            }
            else
            {
                this.mPanel.remainingItemsBadge.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LimitPerPlayerReached");
                this.mPanel.remainingItems.setStyle("color", 11040372);
            };
            this.mPanel.itemDescription1.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.SHOP_ITEM_DESCRIPTIONS_1, this.mSelectedItem.GetName_string());
            this.mPanel.itemDescription2.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.SHOP_ITEM_DESCRIPTIONS_2, this.mSelectedItem.GetName_string());
            if (_local_4)
            {
                this.mPanel.itemDescription3.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.SHOP_ITEM_DESCRIPTIONS_3, "YouGet");
                for each (_local_5 in this.mSelectedItem.GetShopItemContent_vector())
                {
                    this.mPanel.itemDescription3.text = (this.mPanel.itemDescription3.text + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.SHOP_ITEM_DESCRIPTIONS_3, "StandardResourceList", [_local_5.GetCount().toString(), _local_5.GetResourceName_string()])));
                };
            }
            else
            {
                this.mPanel.itemDescription3.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.SHOP_ITEM_DESCRIPTIONS_3, this.mSelectedItem.GetName_string());
            };
            this.mPanel.costsList.dataProvider = this.mSelectedItem.GetCosts_vector();
            if (this.mGI.mCurrentPlayer.GetPlayerLevel() < this.mSelectedItem.GetPlayerLevel())
            {
                this.mPanel.btnBuy.enabled = false;
                this.mPanel.btnBuy.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LevelRequired", [this.mSelectedItem.GetPlayerLevel()]);
            }
            else
            {
                if (this.mGI.mCurrentPlayer.GetPlayerPvPLevel() < this.mSelectedItem.GetPvPLevel())
                {
                    this.mPanel.btnBuy.enabled = false;
                    this.mPanel.btnBuy.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PvpLevelRequired", [this.mSelectedItem.GetPvPLevel()]);
                }
                else
                {
                    if ((((((this.mSelectedItem.GetPerPlayer() > 0) && (_local_6 >= this.mSelectedItem.GetPerPlayer())) || ((this.mSelectedItem.GetPerEvent() > 0) && (_local_8 >= this.mSelectedItem.GetPerEvent()))) || ((this.mSelectedItem.GetPerVoteRound() > 0) && (_local_9 >= this.mSelectedItem.GetPerVoteRound()))) || ((this.mGI.mItemRegistry.IsLimitedShopItem(this.mSelectedItem)) && (this.mGI.mItemRegistry.GetRemainingAmountForShopItem(this.mSelectedItem) < 1))))
                    {
                        this.mPanel.btnBuy.enabled = false;
                        this.mPanel.btnBuy.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LimitPerPlayerReached");
                    }
                    else
                    {
                        if (((this.mSelectedItem.GetCooldownPerPlayer() > 0) && (_local_7 < this.mSelectedItem.GetCooldownPerPlayer())))
                        {
                            this.mPanel.btnBuy.enabled = false;
                            this.mPanel.btnBuy.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "ItemOnCooldown", [(this.mPanel.itemOnCooldownTime.text = cLocaManager.GetInstance().FormatDuration((_local_13 * 60000), cLocaManager.DURATION_FORMAT_NORMAL))]);
                        }
                        else
                        {
                            this.mPanel.btnBuy.enabled = true;
                            this.mPanel.btnBuy.toolTip = "";
                        };
                    };
                };
            };
            this.mPanel.btnBuy.addEventListener(MouseEvent.CLICK, this.BuyItem);
        }

        private function ChangedGroupList(_arg_1:FlexEvent):void
        {
            gHintManager.TryRemainingHints();
        }

        private function ShowGeneralTooltip(_arg_1:ToolTipEvent):void
        {
            var _local_2:int = SPECIALIST_TYPE.parse((this.mSelectedItem as cShopItem).GetShopItemContent_vector()[0].GetName_string());
            var _local_3:cSpecialist = new cSpecialist(false).InitSpecialistFromType(_local_2, null, global.ui.mHomePlayer.getPlayerID(), global.ui.mHomePlayer.getPlayerID(), global.ui);
            cToolTipUtil.createToolTip(cToolTipUtil.MILITARY_UNIT_GENERAL_string, _arg_1, _local_3);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnAddCash.addEventListener(MouseEvent.CLICK, this.AddHardCurrency);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.groupsList.addEventListener(ListEvent.ITEM_CLICK, this.SelectGroup);
            this.mPanel.groupsList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.ChangedGroupList);
            this.mPanel.shopItems.addEventListener("ShowItemDetails", this.ShowItemDetails);
        }

        private function SelectGroup(_arg_1:ListEvent):void
        {
            var _local_4:cShopItem;
            this.mIsDeepLink = false;
            if (!this.mPanel.groupsList.selectedItem)
            {
                return;
            };
            gHintManager.HideHintsForParent(this.mPanel.shopItems, true);
            var _local_2:cShopItemGroup = (this.mPanel.groupsList.selectedItem as cShopItemGroup);
            var _local_3:Array = new Array();
            for each (_local_4 in _local_2.getSortedItems_vector(this.mGI, (!(this.mGiftPlayer == null))))
            {
                _local_3.push(_local_4);
            };
            this.mPanel.shopItems.dataProvider = _local_3;
            this.mPanel.shopItems.windowID = ((mUiElement.id + ".") + _local_2.GetName_string());
            this.mPanel.itemsStack.selectedIndex = 0;
        }

        public function SetGiftPlayer(_arg_1:dPlayerListItemVO):void
        {
            this.mGiftPlayer = _arg_1;
        }

        public function activateBanners(_arg_1:String="UNDEFINED"):void
        {
            var _local_2:dBanner;
            var _local_3:TSOImage;
            for each (_local_2 in dBanner.mShopBannerList[_arg_1])
            {
                switch (_local_2.slot)
                {
                    case 3:
                        _local_3 = this.mPanel.bannerLarge1;
                        break;
                    case 4:
                        _local_3 = this.mPanel.bannerLarge2;
                        break;
                    case 5:
                        _local_3 = this.mPanel.bannerLarge3;
                        break;
                    default:
                        _local_3 = null;
                };
                if (_local_3)
                {
                    this.mBannersMap[_local_3] = _local_2;
                    _local_3.source = _local_2.url;
                    _local_3.addEventListener(MouseEvent.CLICK, this.BannerClick);
                };
            };
        }

        private function BuyItem(_arg_1:Event):void
        {
            var _local_2:cShopItem = this.mSelectedItem;
            var _local_3:int;
            if (this.mGiftPlayer != null)
            {
                _local_3 = this.mGiftPlayer.id;
            };
            ClientLogger.log(("Origin From Shop " + this.origin));
            if (!this.mGI.shopManager.buy(_local_2, this.origin, _local_3))
            {
                return;
            };
            this.mIsBuyingHardCurrency = false;
            if (((_local_2.GetShopItemContent_vector().length == 1) && (_local_2.GetShopItemContent_vector()[0].GetResourceName_string() == defines.HARD_CURRENCY_RESOURCE_NAME_string)))
            {
                this.mIsBuyingHardCurrency = true;
            };
            this.mPanel.itemsStack.selectedIndex = 0;
            FloatingItemsManager.jumpOutsideWindow(this.mPanel.frame, this.mPanel);
        }

        private function BannerClick(_arg_1:MouseEvent):void
        {
            var _local_2:dBanner;
            var _local_3:cShopItemGroup;
            var _local_4:cShopItem;
            _local_2 = this.mBannersMap[_arg_1.currentTarget];
            if (_local_2 == null)
            {
                return;
            };
            switch (_local_2.linkType)
            {
                case "ext":
                    navigateToURL(new URLRequest(_local_2.target), "_blank");
                    return;
                case "group":
                    _local_3 = cShopItemGroup.GetShopItemGroup(_local_2.id);
                    if (_local_3)
                    {
                        this.mPanel.groupsList.selectedItem = _local_3;
                        this.SelectGroup(null);
                        this.mPanel.itemsStack.selectedIndex = 0;
                    }
                    else
                    {
                        gMisc.MessageBox(("Could not find link target - group-id: " + _local_2.id));
                    };
                    return;
                case "item":
                    _local_4 = cShopItem.GetShopItem(_local_2.id);
                    if (_local_4)
                    {
                        this.mPanel.groupsList.selectedItem = cShopItemGroup.GetShopItemGroup(_local_4.GetGroupId());
                        this.SelectGroup(null);
                        this.mPanel.shopItems.selectedItem = _local_4;
                        this.ShowItemDetails(null);
                    }
                    else
                    {
                        gMisc.MessageBox(("Could not find link target - item-id: " + _local_2.id));
                    };
                    return;
            };
        }

        override public function SetDataByString(_arg_1:String):void
        {
            var _local_3:cShopItemGroup;
            var _local_2:Array = cShopItemGroup.GetAllShopItemGroups(false, this.mGI);
            for each (_local_3 in _local_2)
            {
                if (StringUtils.equalsIgnoreCase(_local_3.name_string, _arg_1))
                {
                    this.mPanel.groupsList.selectedItem = _local_3;
                    this.setGroupByString = true;
                };
            };
        }

        public function SetData():void
        {
            var _local_1:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            this.mPanel.resourceIconHardCurrency.source = gAssetManager.GetResourceIcon("HardCurrency");
            this.mPanel.resourceLabelHardCurrency.text = Math.floor(_local_1.GetPlayerResource("HardCurrency").amount).toString();
            this.mPanel.hardCurrency.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "HardCurrency");
            this.mPanel.groupsList.dataProvider = cShopItemGroup.GetAllShopItemGroups(false, this.mGI);
            if (this.mIsDeepLink)
            {
                return;
            };
            if (!this.setGroupByString)
            {
                this.mPanel.groupsList.selectedIndex = 0;
            };
            this.SelectGroup(null);
            this.setGroupByString = false;
        }

        private function ShowItemDetails(_arg_1:Event):void
        {
            this.mSelectedItem = (this.mPanel.shopItems.selectedItem as cShopItem);
            this.EnterDetailsState(null);
            this.mPanel.itemsStack.selectedIndex = 1;
        }

        override protected function HideWithoutQueue():void
        {
            if (this.mGiftPlayer == null)
            {
                if (this.mIsBuyingHardCurrency)
                {
                    FloatingItemsManager.releaseStack("GAMESTATE_ID_INFO_BAR.infoBarRight");
                }
                else
                {
                    FloatingItemsManager.releaseStack("GAMESTATE_ID_ACTIONBAR.actionBarCenter.btnActionBar04");
                };
            }
            else
            {
                FloatingItemsManager.releaseStack(("GAMESTATE_ID_FRIENDS_LIST." + this.mGiftPlayer.username));
            };
            this.mGiftPlayer = null;
            super.HideWithoutQueue();
        }

        public function Init(_arg_1:ShopWindow):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.initBanners();
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        override public function Show():void
        {
            if (this.mGiftPlayer)
            {
                this.mPanel.giftPlayerName.text = this.mGiftPlayer.username;
                this.mPanel.giftPlayerAvatar.data = this.mGiftPlayer;
                this.mPanel.currentState = "";
            }
            else
            {
                this.mPanel.currentState = "collapsed";
            };
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PayShop");
            try
            {
                this.mPanel.dragon.source = gAssetManager.GetClass(GraphicsHelpers.getUIComponentHeaderClassName(this.mGI, this.mPanel.id));
            }
            catch(e:Error)
            {
                ClientLogger.error(e);
            };
            this.SetData();
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }

        public function showItem(_arg_1:cShopItem):void
        {
            this.mSelectedItem = _arg_1;
            this.Show();
            this.EnterDetailsState(null);
            this.mPanel.itemsStack.selectedIndex = 1;
        }

        public function initBanners():void
        {
            var _local_1:String;
            this.activateBanners();
            for each (_local_1 in this.mGI.mEventManager.GetActiveEventNames())
            {
                this.activateBanners(_local_1);
            };
        }

        public function Refresh():void
        {
            var _local_1:cResources = this.mGI.mCurrentPlayerZone.GetResources(this.mGI.mCurrentPlayer);
            this.mPanel.resourceLabelHardCurrency.text = Math.floor(_local_1.GetPlayerResource("HardCurrency").amount).toString();
            var _local_2:Number = this.mPanel.shopItems.verticalScrollPosition;
            var _local_3:int = this.mPanel.shopItems.selectedIndex;
            this.mPanel.shopItems.dataProvider.refresh();
            this.mPanel.shopItems.verticalScrollPosition = _local_2;
            this.mPanel.shopItems.selectedIndex = _local_3;
            this.mPanel.shopItems.validateNow();
            this.EnterDetailsState(null);
        }

        public function AddHardCurrency(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest((global.baseUri + defines.PAYMENT_URL)), "_blank");
        }


    }
}
