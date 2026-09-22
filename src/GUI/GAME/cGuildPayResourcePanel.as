package GUI.GAME
{
    import Communication.VO.dResourceVO;
    import GuildSystem.cGuildBankTab;
    import Communication.VO.dBuffVO;
    import Interface.cGameInterface;
    import GUI.Components.GuildPayResourcePanel;
    import nLib.gMisc;
    import BuffSystem.cBuff;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import ServerState.dResource;
    import __AS3__.vec.Vector;
    import GUI.Assets.gAssetManager;
    import mx.events.ListEvent;
    import flash.events.Event;
    import TimedProduction.iTimedProductionDefinition;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import mx.events.SliderEvent;
    import Communication.VO.dUniqueID;
    import BuffSystem.cBuffDefinition;
    import ServerState.cResources;
    import ServerState.cPlayerData;
    import Enums.RESOURCE_GROUP;
    import ServerState.gEconomics;
    import Communication.VO.dBankDonationVO;
    import Enums.COMMAND;
    import __AS3__.vec.*;

    public class cGuildPayResourcePanel extends cBasicPanel 
    {

        private var mSelectedResourceVO:dResourceVO = null;
        private var mGuildBankTab:cGuildBankTab;
        private var mSelectedBuffVO:dBuffVO = null;
        private var mGI:cGameInterface;
        protected var mPanel:GuildPayResourcePanel;


        private function searchFilter(_arg_1:Object, _arg_2:int=0, _arg_3:Vector.<Object>=null):Boolean
        {
            var _local_4:String = gMisc.Trim_string(this.mPanel.searchColumn.searchInput.text.toLocaleLowerCase());
            if (!this.mGuildBankTab.isPaymentTab)
            {
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
            }
            else
            {
                if ((((_arg_1 is dResource) && (!(cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, dResource(_arg_1).name_string).toLocaleLowerCase().search(_local_4) == -1))) && ((!(this.mGuildBankTab.isPaymentTab)) || (!(global.guildBankPayTabAllowedResources.indexOf(dResource(_arg_1).name_string) == -1)))))
                {
                    return (true);
                };
            };
            return (false);
        }

        private function SelectResource(_arg_1:ListEvent):void
        {
            if (((this.mPanel.resourceList.selectedItem is cBuff) || (this.mPanel.resourceList.selectedItem is dBuffVO)))
            {
                this.SelectBuff();
                return;
            };
            if ((this.mPanel.resourceList.selectedItem as dResource).amount == 0)
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
            this.mPanel.amountSlider.maximum = (this.mPanel.resourceList.selectedItem as dResource).amount;
            this.mPanel.amountSlider.enabled = ((this.mPanel.resourceList.selectedItem as dResource).amount > 1);
            this.mPanel.amountSlider.value = 1;
            this.mPanel.btnOK.enabled = (this.mPanel.amountSlider.maximum > 0);
            this.SetAmount(null);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
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

        private function refreshFilteredList(_arg_1:Event=null):void
        {
            var _local_2:Vector.<Object> = this.mPanel.searchColumn.getPreFilteredVector();
            this.mPanel.resourceList.dataProvider = gMisc.iterableToArray(_local_2.filter(this.searchFilter));
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.resourceList.addEventListener(ListEvent.ITEM_CLICK, this.SelectResource);
            this.mPanel.amountSlider.addEventListener(SliderEvent.CHANGE, this.SetAmount);
            this.mPanel.selectedCount.addEventListener(Event.CHANGE, this.ChangeResourceInputAmount);
            this.mPanel.searchColumn.filterList.addEventListener(ListEvent.ITEM_CLICK, this.refreshFilteredList);
            this.mPanel.searchColumn.addEventListener(Event.CHANGE, this.refreshFilteredList);
            this.mPanel.searchColumn.searchBtn.addEventListener(MouseEvent.CLICK, this.refreshFilteredList);
            this.mPanel.searchColumn.searchInput.addEventListener(Event.CHANGE, this.refreshFilteredList);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.PayResource);
            this.mPanel.searchColumn.searchBtn.visible = true;
            this.mPanel.searchColumn.searchBtn.includeInLayout = true;
        }

        public function ResetAfterError():void
        {
            var uniqueID:dUniqueID;
            try
            {
                if (this.mSelectedBuffVO != null)
                {
                    uniqueID = new dUniqueID();
                    uniqueID.uniqueID1 = this.mSelectedBuffVO.uniqueId1;
                    uniqueID.uniqueID2 = this.mSelectedBuffVO.uniqueId2;
                    if (((this.mGI.mHomePlayer.getBuffByUniqueID(uniqueID)) && (this.mGI.mHomePlayer.getBuffByUniqueID(uniqueID).GetWaitingForServer())))
                    {
                        this.mGI.mHomePlayer.getBuffByUniqueID(uniqueID).DecWaitingForServerCount(this.mGI);
                    };
                };
            }
            catch(e:Error)
            {
            };
        }

        private function ChangeResourceInputAmount(_arg_1:Event):void
        {
            if (int(this.mPanel.selectedCount.text) == 0)
            {
                this.mPanel.selectedCount.text = "1";
                this.mPanel.selectedCount.setSelection(0, 1);
            };
            if (int(this.mPanel.selectedCount.text) > this.mPanel.amountSlider.maximum)
            {
                this.mPanel.selectedCount.text = String(this.mPanel.amountSlider.maximum);
            };
            this.mPanel.amountSlider.value = int(this.mPanel.selectedCount.text);
        }

        private function SetFilteredResourceList():void
        {
            var _local_2:dBuffVO;
            var _local_3:cBuffDefinition;
            var _local_5:cResources;
            var _local_6:Vector.<dResource>;
            var _local_7:dResource;
            var _local_8:cBuff;
            var _local_9:dResource;
            var _local_1:Vector.<Object> = new Vector.<Object>();
            var _local_4:cPlayerData = this.mGI.mCurrentPlayer;
            if (_local_4 != null)
            {
                _local_5 = this.mGI.mCurrentPlayerZone.GetResources(_local_4);
                _local_6 = _local_5.GetPlayerResources_vector(RESOURCE_GROUP.ALL);
                for each (_local_7 in _local_6)
                {
                    if (gEconomics.GetResourcesDefaultDefinition(_local_7.name_string).tradable)
                    {
                        _local_9 = _local_7.clone();
                        _local_1.push(_local_9);
                    };
                };
                for each (_local_8 in this.mGI.mCurrentPlayer.getBuffsSortedForStarMenu())
                {
                    if (((!(_local_8.GetWaitingForServer())) && (_local_8.GetBuffDefinition().IsTradable(_local_8.GetResourceName_string()))))
                    {
                        _local_1.push(_local_8);
                    };
                };
                this.mPanel.searchColumn.setData(_local_1, false);
                this.refreshFilteredList();
            };
        }

        private function SelectBuff():void
        {
            var _local_2:Boolean;
            var _local_3:String;
            var _local_5:cBuff;
            var _local_6:dBuffVO;
            var _local_7:cBuffDefinition;
            var _local_8:String;
            this.mPanel.buffIcon.data = this.mPanel.resourceList.selectedItem;
            this.mPanel.buffIcon.removeIcon.visible = false;
            this.mSelectedResourceVO = null;
            var _local_1:int = 1;
            if ((this.mPanel.resourceList.selectedItem is cBuff))
            {
                _local_5 = (this.mPanel.resourceList.selectedItem as cBuff);
                _local_2 = _local_5.GetBuffDefinition().IsProducible();
                this.mSelectedBuffVO = _local_5.CreateBuffVOFromBuff();
                _local_3 = this.mSelectedBuffVO.buffName_string;
                if ((((_local_3.indexOf(defines.ADD_RESOURCE_BUFF) == 0) || (_local_3.indexOf(defines.FILL_DEPOSIT_BUFF) == 0)) || (_local_3.indexOf(defines.HIRED_MILITARY_BUFF) == 0)))
                {
                    _local_1 = this.mSelectedBuffVO.amount;
                }
                else
                {
                    if (((_local_2) || (_local_3.indexOf(defines.PRODUCTIVITY_BUFF) == 0)))
                    {
                        _local_1 = this.mSelectedBuffVO.amount;
                    };
                };
                this.mPanel.amountSlider.value = _local_1;
            }
            else
            {
                _local_6 = (this.mPanel.resourceList.selectedItem as dBuffVO);
                this.mSelectedBuffVO = new dBuffVO();
                this.mSelectedBuffVO.buffName_string = _local_6.buffName_string;
                this.mSelectedBuffVO.resourceName_string = _local_6.resourceName_string;
                this.mSelectedBuffVO.amount = _local_6.amount;
                _local_3 = this.mSelectedBuffVO.buffName_string;
                _local_7 = cBuff.getBuffDefinitionByName(_local_3);
                _local_2 = ((_local_7.IsProducible()) || (this.isProducebleInImprovedWarehouse(_local_3)));
                if ((((_local_3.indexOf(defines.ADD_RESOURCE_BUFF) == 0) || (_local_3.indexOf(defines.FILL_DEPOSIT_BUFF) == 0)) || (_local_3.indexOf(defines.HIRED_MILITARY_BUFF) == 0)))
                {
                    _local_1 = global.tradeMaxSearchAmount;
                }
                else
                {
                    if (_local_2)
                    {
                        _local_1 = 25;
                    };
                };
                this.mPanel.amountSlider.value = 1;
            };
            this.mPanel.amountSlider.maximum = _local_1;
            var _local_4:String = this.mSelectedBuffVO.resourceName_string;
            this.mPanel.buffIcon.visible = true;
            this.mPanel.resourceIcon.visible = false;
            if (_local_3 == defines.ADVENTURE_BUFF)
            {
                this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.ADVENTURE_NAME, _local_4);
            }
            else
            {
                if (_local_3 == defines.BUILD_BUILDING_BUFF)
                {
                    this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, _local_4);
                }
                else
                {
                    if ((((_local_3.indexOf(defines.ADD_RESOURCE_BUFF) == 0) || (_local_3.indexOf(defines.FILL_DEPOSIT_BUFF) == 0)) || (_local_3 == defines.HIRED_MILITARY_BUFF)))
                    {
                        _local_8 = _local_3;
                        if (((_local_8 == defines.FILL_DEPOSIT_BUFF) && (_local_4 == "")))
                        {
                            _local_8 = (_local_8 + "Any");
                        };
                        this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_8, [_local_5.GetAmount(), _local_4]);
                    }
                    else
                    {
                        if (_local_3.indexOf(defines.CHANGE_COLOR_SCHEME_BUFF) == 0)
                        {
                            this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, ((defines.CHANGE_COLOR_SCHEME_BUFF + "_") + _local_4));
                        }
                        else
                        {
                            this.mPanel.resourceName.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_3);
                        };
                    };
                };
            };
            this.mPanel.amountSlider.visible = false;
            this.mPanel.amountSlider.enabled = false;
            this.mPanel.selectedCount.visible = false;
            this.mPanel.maximumCount.visible = false;
            this.mPanel.btnOK.enabled = true;
            this.SetAmount(null);
        }

        public function SetGuildBankTab(_arg_1:cGuildBankTab):void
        {
            this.mGuildBankTab = _arg_1;
        }

        override public function Show():void
        {
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
            this.mPanel.btnOK.enabled = false;
            this.mPanel.selectedCount.visible = false;
            this.mPanel.amountSlider.visible = false;
            this.mPanel.maximumCount.visible = false;
            this.mPanel.buffIcon.visible = false;
            this.mPanel.resourceIcon.visible = false;
            this.mPanel.resourceName.text = "";
            this.SetFilteredResourceList();
            this.mPanel.resourceList.selectedIndex = 1;
            this.refreshFilteredList();
        }

        public function Init(_arg_1:GuildPayResourcePanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.x = ((this.mPanel.stage.stageWidth - this.mPanel.width) / 2);
            this.mPanel.y = ((this.mPanel.stage.stageHeight - this.mPanel.height) / 2);
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function PayResource(_arg_1:Event):void
        {
            var _local_4:dUniqueID;
            var _local_2:dBuffVO = new dBuffVO();
            if (this.mSelectedResourceVO != null)
            {
                _local_2.amount = this.mSelectedResourceVO.amount;
                _local_2.buffName_string = defines.DONATE_TEMP_BUFF;
                _local_2.resourceName_string = this.mSelectedResourceVO.name_string;
            }
            else
            {
                if (this.mSelectedBuffVO != null)
                {
                    _local_2 = this.mSelectedBuffVO;
                    _local_4 = new dUniqueID();
                    _local_4.uniqueID1 = _local_2.uniqueId1;
                    _local_4.uniqueID2 = _local_2.uniqueId2;
                    this.mGI.mHomePlayer.getBuffByUniqueID(_local_4).IncWaitingForServerCount(this.mGI);
                };
            };
            var _local_3:dBankDonationVO = new dBankDonationVO();
            _local_3.buff = _local_2;
            _local_3.tabId = globalFlash.gui.mGuildBankWindow.GetCurrentTabId();
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GUILD_DONATE_RESOURCE, this.mGI.mCurrentViewedZoneID, _local_3);
            Hide();
            globalFlash.gui.mGuildBankWindow.Show();
            globalFlash.gui.mGuildBankWindow.SetBusy(true);
        }

        private function SetAmount(_arg_1:SliderEvent):void
        {
            if (this.mSelectedResourceVO)
            {
                this.mSelectedResourceVO.amount = this.mPanel.amountSlider.value;
                this.mPanel.selectedCount.text = this.mPanel.amountSlider.value.toString();
                this.mPanel.maximumCount.text = (" / " + this.mPanel.amountSlider.maximum);
            }
            else
            {
                this.mSelectedBuffVO.amount = this.mPanel.amountSlider.value;
            };
            this.mPanel.selectedCount.maxChars = String(this.mPanel.amountSlider.maximum).length;
            this.mPanel.selectedCount.width = (12 + (8 * (String(this.mPanel.amountSlider.maximum).length - 1)));
        }


    }
}
