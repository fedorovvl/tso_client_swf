package GUI.GAME
{
    import Model.Observer;
    import mx.collections.ArrayCollection;
    import GO.cBuilding;
    import GUI.Components.ItemRenderer.Combat3ArmyToolTipRenderer;
    import Interface.cGameInterface;
    import GUI.Components.CombatScenarioTooltip;
    import GUI.Components.circularmenu.ScenarioCircleSlot;
    import flash.events.MouseEvent;
    import Enums.TRIGGER_ACTION;
    import Model.Notifiers.ZoneChannel;
    import Model.Notifier;
    import BuffSystem.cBuff;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    import Enums.COMMAND;
    import Specialists.cSpecialist;
    import MilitarySystem.cArmy;
    import Communication.VO.dBuffListVO;
    import Communication.VO.dBuffVO;
    import nLib.cPosInt;
    import GUI.event.Combat3StartAttackEvent;
    import BuffSystem.cBuffDefinition;
    import GUI.Components.circularmenu.ScenarioBuffData;
    import MilitarySystem.cSquad;
    import mx.collections.Sort;
    import mx.collections.SortField;
    import GUI.Components.data.dCombatUnitData;

    public class cCombatScenarioTooltip extends cCombatUIBase implements Observer 
    {

        private var mBuildingUnitDataProvider:ArrayCollection;
        private var mBuilding:cBuilding;
        private var _selectedSquadRenderer:Combat3ArmyToolTipRenderer = null;
        private var _selectedSquadName:String = null;
        private var mScaleFactor:Number = 1;
        private var mGridId:int = 0;
        private var mGI:cGameInterface;
        private var mPanel:CombatScenarioTooltip;
        private var _timeoutForSelectSquad:Number = 0;
        private var waitingBuffToBeApplied:int = 0;
        private var mBuffsDataProvider:ArrayCollection;


        private function clickSlotHandler(_arg_1:MouseEvent):void
        {
            var _local_2:ScenarioCircleSlot = (_arg_1.target as ScenarioCircleSlot);
            if (_local_2 != null)
            {
                this.applyBuff(this.getAvailableBuff(_local_2.data.definiton.GetName_string()), _local_2.amountSlider.value);
            };
        }

        public function SetDataByClick(_arg_1:cBuilding):void
        {
            this.selectedSquadName = null;
            this.SetData(_arg_1, null, _arg_1.GetArmy(), null, _arg_1.GetGrid(), global.getApplication().mGameInterface.mZoom.GetScaleFactor());
            this.selectSquadItem();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (((_arg_2 == TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string) && (this.waitingBuffToBeApplied > 0)))
            {
                if (this.mGI.mCurrentPlayerZone.GetBuildingFromGridPosition(this.mGridId) != null)
                {
                    this.waitingBuffToBeApplied--;
                    if (this.mBuilding.GetArmy() != null)
                    {
                        this.mBuildingUnitDataProvider = this.populateDataArrayFromArmy(this.mBuilding.GetArmy(), true);
                        this.selectedSquadName = null;
                        this.renderUnitsTopRow();
                    };
                }
                else
                {
                    this.waitingBuffToBeApplied = 0;
                    this.mBuilding = null;
                    this.selectedSquadName = null;
                    super.Hide();
                };
            }
            else
            {
                if (_arg_2 == ZoneChannel.ZONE_REFRESHED)
                {
                    this.waitingBuffToBeApplied = 0;
                    this.mBuilding = null;
                    this.selectedSquadName = null;
                    if (IsVisible())
                    {
                        super.Hide();
                    };
                };
            };
        }

        public function get selectedSquadName():String
        {
            return (this._selectedSquadName);
        }

        private function getAvailableBuff(_arg_1:String):cBuff
        {
            var _local_2:cBuff;
            for each (_local_2 in this.mGI.mCurrentPlayer.getAvailableBuffs_vector())
            {
                if (_local_2.GetBuffDefinition().GetName_string() == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        private function selectSquadItem(_arg_1:Boolean=true):void
        {
            var _local_2:Object;
            clearTimeout(this._timeoutForSelectSquad);
            this._timeoutForSelectSquad = 0;
            if (_arg_1)
            {
                this._timeoutForSelectSquad = setTimeout(this.selectSquadItem, 300, false);
                this.selectedSquadName = null;
                this.mPanel.slot1.visible = (this.mPanel.slot2.visible = (this.mPanel.slot3.visible = false));
                return;
            };
            if (this.mGI.mCurrentCursor.GetEditMode() == COMMAND.APPLY_BUFF)
            {
                for each (_local_2 in this.mBuildingUnitDataProvider)
                {
                    if (this.mGI.mCurrentCursor.mCurrentBuff.GetBuffDefinition().HasBattleBuffTarget(_local_2.name_string))
                    {
                        this.selectedSquadName = _local_2.name_string;
                        return;
                    };
                };
            };
            if ((((this.mBuildingUnitDataProvider) && (this.mBuildingUnitDataProvider.length > 0)) && (this.mPanel.campUnitsList.indexToItemRenderer(0))))
            {
                this.selectedSquadName = this.mPanel.campUnitsList.indexToItemRenderer(0).data.name_string;
            };
        }

        private function SetPosition():void
        {
            this.mPanel.gridPos = this.mGridId;
            this.mPanel.offsetPoint.x = (-(this.mPanel.width) / 2);
            this.mPanel.offsetPoint.y = (-(95) - (100 * (this.mScaleFactor / 1000)));
            globalFlash.nLibFlexBridgeManager.updateBridge(this.mPanel);
        }

        override public function SetData(_arg_1:cBuilding, _arg_2:cSpecialist, _arg_3:cArmy, _arg_4:cArmy, _arg_5:int, _arg_6:Number):void
        {
            if (((!(this.mGI.mCurrentCursor.GetEditMode() == COMMAND.APPLY_BUFF)) && ((this.selectedSquadName) || (this._timeoutForSelectSquad > 0))))
            {
                return;
            };
            this.mBuilding = _arg_1;
            this.mGridId = _arg_5;
            this.mScaleFactor = _arg_6;
            this.mBuildingUnitDataProvider = new ArrayCollection();
            this.mBuffsDataProvider = new ArrayCollection();
            if (_arg_3 != null)
            {
                this.mBuildingUnitDataProvider = this.populateDataArrayFromArmy(_arg_3, true);
            };
            this.SetMode(mMode);
            this.SetPosition();
            this.selectedSquadName = null;
            if (this.mGI.mCurrentCursor.GetEditMode() == COMMAND.APPLY_BUFF)
            {
                this.selectSquadItem();
            };
        }

        override public function SetMode(_arg_1:int):void
        {
            mMode = _arg_1;
            this.renderUnitsTopRow();
        }

        public function set selectedSquadName(_arg_1:String):void
        {
            var _local_2:Object;
            var _local_3:Combat3ArmyToolTipRenderer;
            if (_arg_1 != this._selectedSquadName)
            {
                if (this._selectedSquadRenderer)
                {
                    this._selectedSquadRenderer.selected = false;
                };
                this.mPanel.buffsContainer.visible = Boolean(_arg_1);
                if (_arg_1)
                {
                    this._selectedSquadRenderer = this.squadNameToItemRenderer(_arg_1);
                    if (this._selectedSquadRenderer)
                    {
                        this._selectedSquadRenderer.selected = true;
                        this.selectSquad(_arg_1, this._selectedSquadRenderer.data.current);
                    };
                };
                this._selectedSquadName = _arg_1;
            };
            for each (_local_2 in this.mBuildingUnitDataProvider)
            {
                if (_local_2.name_string != _arg_1)
                {
                    _local_3 = this.squadNameToItemRenderer(_local_2.name_string);
                    if (_local_3 != null)
                    {
                        _local_3.greyOut = (!(_arg_1 == null));
                    };
                };
            };
        }

        override public function Show():void
        {
            if (this.waitingBuffToBeApplied == 0)
            {
                super.Show();
                this.SetScaleFactor(this.mGI.mZoom.GetScaleFactor());
            };
        }

        private function applyBuff(_arg_1:cBuff, _arg_2:int):void
        {
            var _local_3:dBuffListVO;
            var _local_4:dBuffVO;
            if (((_arg_1) && (_arg_2 > 0)))
            {
                _local_3 = new dBuffListVO();
                _local_3.buffList = new ArrayCollection();
                _arg_2 = Math.min(_arg_2, _arg_1.GetAmount());
                _local_4 = new dBuffVO();
                _local_4.uniqueId1 = _arg_1.GetUniqueId().uniqueID1;
                _local_4.uniqueId2 = _arg_1.GetUniqueId().uniqueID2;
                _local_4.amount = _arg_2;
                _local_3.buffList.addItem(_local_4);
                _local_3.target_string = this.selectedSquadName;
                _arg_1.SetWaitingForServerCount(_arg_2, this.mGI);
                this.mGI.SendServerAction(COMMAND.APPLY_BUFF_LIST, 0, this.mBuilding.GetGrid(), 0, _local_3);
                this.HideByClick();
                this.waitingBuffToBeApplied++;
            };
        }

        override public function Hide():void
        {
            if (((!(this.selectedSquadName)) && (this._timeoutForSelectSquad == 0)))
            {
                super.Hide();
            };
        }

        private function SetScaleFactor(_arg_1:int=1):void
        {
            if (((!(_arg_1 == this.mScaleFactor)) && (_arg_1 <= 2)))
            {
                this.mScaleFactor = _arg_1;
            };
        }

        private function getAmountOfAvailableBuffs(_arg_1:String):int
        {
            var _local_3:cBuff;
            var _local_2:int;
            for each (_local_3 in this.mGI.mCurrentPlayer.getAvailableBuffs_vector())
            {
                if (_local_3.GetBuffDefinition().GetName_string() == _arg_1)
                {
                    _local_2 = (_local_2 + _local_3.GetAmount());
                };
            };
            return (_local_2);
        }

        private function renderUnitsTopRow():void
        {
            this.mPanel.campUnitsList.dataProvider = this.mBuildingUnitDataProvider;
            if (((this.mBuildingUnitDataProvider == null) || (this.mBuildingUnitDataProvider.length < 1)))
            {
                this.mPanel.campUnitsCanvas.visible = false;
                this.mPanel.campUnitsCanvas.includeInLayout = false;
            }
            else
            {
                this.mPanel.campUnitsCanvas.visible = true;
                this.mPanel.campUnitsCanvas.includeInLayout = true;
            };
        }

        public function HideByClick():void
        {
            this.selectedSquadName = null;
            this.Hide();
        }

        public function Init(_arg_1:CombatScenarioTooltip):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.offsetPoint = new cPosInt();
            this.mBuildingUnitDataProvider = new ArrayCollection();
            this.mBuffsDataProvider = new ArrayCollection();
            this.mPanel.buildingClickZone.addEventListener(MouseEvent.CLICK, this.onClickOnBuilding);
            this.mPanel.campUnitsList.addEventListener(Combat3StartAttackEvent.INITIATE_COMBAT, this.startAttackEventHandler);
            this.mPanel.slot1.addEventListener(MouseEvent.CLICK, this.clickSlotHandler);
            this.mPanel.slot2.addEventListener(MouseEvent.CLICK, this.clickSlotHandler);
            this.mPanel.slot3.addEventListener(MouseEvent.CLICK, this.clickSlotHandler);
            this.mGI.channels.ZONE.addPropertyObserver(ZoneChannel.ZONE_REFRESHED, this);
            this.mGI.channels.BUFF.addPropertyObserver(TRIGGER_ACTION.ACTION_BUFF_APPLIED_ON_ADVENTURE_string, this);
        }

        private function selectSquad(_arg_1:String, _arg_2:int):void
        {
            var _local_3:cBuffDefinition;
            var _local_4:int;
            this.mPanel.buffsContainer.visible = true;
            this.mPanel.slot1.data = null;
            this.mPanel.slot2.data = null;
            this.mPanel.slot3.data = null;
            for each (_local_3 in global.map_BuffId_BuffDefinition)
            {
                if (_local_3.HasBattleBuffTarget(_arg_1))
                {
                    _local_4 = this.getAmountOfAvailableBuffs(_local_3.GetName_string());
                    _local_4 = Math.min(_local_4, _arg_2);
                    if (this.mPanel.slot2.data == null)
                    {
                        this.mPanel.slot2.data = new ScenarioBuffData(_local_3, _local_4, _arg_2);
                    }
                    else
                    {
                        if (this.mPanel.slot1.data == null)
                        {
                            this.mPanel.slot1.data = new ScenarioBuffData(_local_3, _local_4, _arg_2);
                        }
                        else
                        {
                            if (this.mPanel.slot3.data == null)
                            {
                                this.mPanel.slot3.data = new ScenarioBuffData(_local_3, _local_4, _arg_2);
                                break;
                            };
                        };
                    };
                };
            };
            this.mPanel.slot1.visible = this.mPanel.slot1.data;
            this.mPanel.slot2.visible = this.mPanel.slot2.data;
            this.mPanel.slot3.visible = this.mPanel.slot3.data;
        }

        private function squadNameToItemRenderer(_arg_1:String):Combat3ArmyToolTipRenderer
        {
            var _local_2:ArrayCollection = (this.mPanel.campUnitsList.dataProvider as ArrayCollection);
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].name_string == _arg_1)
                {
                    return (this.mPanel.campUnitsList.indexToItemRenderer(_local_3) as Combat3ArmyToolTipRenderer);
                };
                _local_3++;
            };
            return (null);
        }

        private function populateDataArrayFromArmy(_arg_1:cArmy, _arg_2:Boolean=false, _arg_3:Boolean=false):ArrayCollection
        {
            var _local_4:ArrayCollection;
            var _local_5:cSquad;
            var _local_6:Sort;
            var _local_7:SortField;
            var _local_8:dCombatUnitData;
            if (_arg_1 != null)
            {
                _local_4 = new ArrayCollection();
                for each (_local_5 in _arg_1.GetSquads_vector())
                {
                    _local_8 = new dCombatUnitData();
                    _local_8.isNPC = true;
                    _local_8.name_string = _local_5.name_string;
                    _local_8.armorType = 0;
                    _local_8.bonusDamage1 = -1;
                    _local_8.bonusDamage2 = -1;
                    _local_8.isAttackable = _local_5.GetUnitBase().IsAttackable();
                    _local_8.current = _local_5.GetAmount();
                    _local_4.addItem(_local_8);
                };
                _local_6 = new Sort();
                _local_7 = new SortField("isFirstUnit");
                _local_6.fields = [_local_7];
                _local_6.reverse();
                _local_4.sort = _local_6;
                _local_4.refresh();
            };
            return (_local_4);
        }

        protected function startAttackEventHandler(_arg_1:Combat3StartAttackEvent):void
        {
            var _local_2:Object;
            _arg_1.stopPropagation();
            for each (_local_2 in this.mBuildingUnitDataProvider)
            {
                if (_local_2.name_string == _arg_1.unitName)
                {
                    this.selectedSquadName = _local_2.name_string;
                    return;
                };
            };
        }

        protected function onClickOnBuilding(_arg_1:MouseEvent):void
        {
            if (!this._selectedSquadName)
            {
                this.selectSquadItem();
            };
        }


    }
}
