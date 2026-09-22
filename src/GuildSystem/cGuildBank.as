package GuildSystem
{
    import flash.events.IEventDispatcher;
    import mx.collections.ArrayCollection;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;
    import mx.collections.Sort;
    import mx.collections.SortField;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Communication.VO.Guild.dGuildBankTabVO;
    import Communication.VO.Guild.dGuildBankTransactionVO;
    import Communication.VO.Guild.dGuildBankVO;

    public class cGuildBank implements IEventDispatcher 
    {

        public static const ACTIVATED:Boolean = false;

        private var mGuildTransactionHistory:ArrayCollection;
        public var currUpdateCoin:int;
        private var mGuildBankPayTab:cGuildBankTab;
        public var mIsInitialized:Boolean = false;
        private var mLastRefreshTime:int = 0;
        public var currUpdateGem:int;
        private var mMap_TabID_Tab:Object;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _700576929mRefreshButtonEnabled:Boolean = true;
        private var tabNumber:int;

        public function cGuildBank()
        {
            this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return (this._bindingEventDispatcher.dispatchEvent(_arg_1));
        }

        public function set mRefreshButtonEnabled(_arg_1:Boolean):void
        {
            var _local_2:Object = this._700576929mRefreshButtonEnabled;
            if (_local_2 !== _arg_1)
            {
                this._700576929mRefreshButtonEnabled = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mRefreshButtonEnabled", _local_2, _arg_1));
            };
        }

        public function DisableRefreshButton():void
        {
            this.mRefreshButtonEnabled = false;
            this.mLastRefreshTime = 0;
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.willTrigger(_arg_1));
        }

        public function ComputeGuildBank():void
        {
            this.mLastRefreshTime++;
            if (((!(this.mRefreshButtonEnabled)) && (this.mLastRefreshTime > global.guildBankRefreshInterval)))
            {
                this.mRefreshButtonEnabled = true;
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this._bindingEventDispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._bindingEventDispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function GetGuildTransactionHistory():ArrayCollection
        {
            return (this.mGuildTransactionHistory);
        }

        public function GetPaymentTab():cGuildBankTab
        {
            var _local_1:*;
            for each (_local_1 in this.mMap_TabID_Tab)
            {
                if (_local_1.isPaymentTab)
                {
                    return (_local_1);
                };
            };
            return (null);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return (this._bindingEventDispatcher.hasEventListener(_arg_1));
        }

        public function GetGuildBankTabs():ArrayCollection
        {
            var _local_2:*;
            var _local_3:Sort;
            var _local_1:ArrayCollection = new ArrayCollection();
            for each (_local_2 in this.mMap_TabID_Tab)
            {
                if (_local_2.hasAccess)
                {
                    _local_1.addItem(_local_2);
                };
            };
            _local_3 = new Sort();
            _local_3.fields = [new SortField("id")];
            _local_1.sort = _local_3;
            _local_1.refresh();
            return (_local_1);
        }

        public function GetGuildBankTab(_arg_1:int):cGuildBankTab
        {
            return (this.mMap_TabID_Tab[_arg_1]);
        }

        [Bindable(event="propertyChange")]
        public function get mRefreshButtonEnabled():Boolean
        {
            return (this._700576929mRefreshButtonEnabled);
        }

        public function AddGuildBankTab(_arg_1:int):void
        {
            var _local_2:cGuildBankTab = new cGuildBankTab();
            _local_2.id = _arg_1;
            _local_2.maxResource = global.guildBankInitialGoodsCapacity;
            _local_2.name = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankTabDefaultName", [this.tabNumber]);
            _local_2.hasAccess = true;
            this.mMap_TabID_Tab[_arg_1] = _local_2;
            this.tabNumber++;
        }

        public function RemoveResourceFromPaytab(_arg_1:String, _arg_2:int):void
        {
            this.GetPaymentTab().GetResource(_arg_1).amount = (this.GetPaymentTab().GetResource(_arg_1).amount + _arg_2);
        }

        public function Init(_arg_1:dGuildBankVO):void
        {
            var _local_2:dGuildBankTabVO;
            var _local_3:dGuildBankTransactionVO;
            this.mMap_TabID_Tab = new Object();
            this.tabNumber = 0;
            for each (_local_2 in _arg_1.bankTabs)
            {
                this.mMap_TabID_Tab[_local_2.id] = new cGuildBankTab();
                this.mMap_TabID_Tab[_local_2.id].Init(_local_2);
                if (_local_2.isPaymentTab)
                {
                    this.mMap_TabID_Tab[_local_2.id].defaultName = (this.mMap_TabID_Tab[_local_2.id].name = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankPaymentTab"));
                }
                else
                {
                    this.mMap_TabID_Tab[_local_2.id].defaultName = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankTabDefaultName", [this.tabNumber]);
                    this.mMap_TabID_Tab[_local_2.id].name = ((_local_2.name != null) ? _local_2.name : this.mMap_TabID_Tab[_local_2.id].defaultName);
                };
                this.tabNumber++;
            };
            this.mGuildTransactionHistory = _arg_1.bankHistory;
            this.currUpdateCoin = _arg_1.currUpdateCoin;
            this.currUpdateGem = _arg_1.currUpdateGem;
            for each (_local_3 in this.mGuildTransactionHistory)
            {
                if (((_local_3.tabID > 0) && (_local_3.tabName == null)))
                {
                    _local_3.tabName = this.mMap_TabID_Tab[_local_3.tabID].defaultName;
                };
                if (((_local_3.targetTabID > 0) && (_local_3.targetTabName == null)))
                {
                    _local_3.targetTabName = this.mMap_TabID_Tab[_local_3.targetTabID].defaultName;
                };
            };
            this.mIsInitialized = true;
        }

        public function AddTransactionHistory(_arg_1:dGuildBankTransactionVO):void
        {
            this.mGuildTransactionHistory.addItemAt(_arg_1, 0);
            if (this.mGuildTransactionHistory.length == 11)
            {
                this.mGuildTransactionHistory.removeItemAt(10);
            };
        }

        public function EnlargeTabs(_arg_1:int):void
        {
            this.mMap_TabID_Tab[_arg_1].currMaxSizeUpdate++;
            this.mMap_TabID_Tab[_arg_1].maxResource = (this.mMap_TabID_Tab[_arg_1].maxResource + global.guildBankEnlargeAmount[this.mMap_TabID_Tab[_arg_1].currMaxSizeUpdate]);
            this.mMap_TabID_Tab[_arg_1].maxBuff = (this.mMap_TabID_Tab[_arg_1].maxBuff + global.guildBankEnlargeBuffAmount[this.mMap_TabID_Tab[_arg_1].currMaxSizeUpdate]);
        }


    }
}
