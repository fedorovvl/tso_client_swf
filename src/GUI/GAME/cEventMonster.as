package GUI.GAME
{
    import Model.Observer;
    import GO.cBuilding;
    import Interface.cGameInterface;
    import GUI.Components.EventMonster;
    import MilitarySystem.cSquad;
    import BuffSystem.cBuffDefinition;
    import BuffSystem.cBuff;
    import Model.Notifier;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import flash.events.MouseEvent;
    import mx.events.SliderEvent;
    import flash.events.Event;
    import mx.events.FlexEvent;
    import mx.events.ToolTipEvent;
    import GUI.Components.ToolTips.cToolTipUtil;
    import Communication.VO.dBuffVO;
    import mx.collections.ArrayCollection;
    import Communication.VO.dBuffListVO;
    import Enums.COMMAND;
    import Model.Notifiers.ZoneChannel;
    import Communication.VO.dBuffEfficiencyVO;
    import Utils.RequirementsHelper;
    import Utils.StringUtils;
    import __AS3__.vec.Vector;

    public class cEventMonster extends cBasicInfoPanel implements Observer 
    {

        protected var mBuilding:cBuilding;
        private var mGI:cGameInterface;
        protected var mPanel:EventMonster;
        protected var buffEfficiency:int;
        protected var selectedSquad:cSquad;
        protected var usedBuffDefinition:cBuffDefinition;
        protected var usedBuff:cBuff;


        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (IsVisible())
            {
                this.Refresh();
                this.ChangeResourceInputAmount(null);
                this.SetAmount(null);
            };
        }

        override public function SetData(_arg_1:cBuilding):void
        {
            var _local_2:String;
            this.mBuilding = _arg_1;
            _local_2 = _arg_1.GetBuildingName_string();
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_2);
            this.mPanel.image.source = gAssetManager.GetBuildingIcon(_local_2);
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _local_2);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            EnableDragging();
            if (!this.mBuilding.IsBuildingActive())
            {
                this.mPanel.SetToConstructionView();
                this.mPanel.constructionTimeLabel.text = cLocaManager.GetInstance().FormatDuration(this.mBuilding.GetRemainingConstructionDuration());
            }
            else
            {
                this.mPanel.SetToBuffApplyView();
                this.mPanel.amountSlider.addEventListener(SliderEvent.CHANGE, this.SetAmount);
                this.mPanel.selectedCount.addEventListener(Event.CHANGE, this.ChangeResourceInputAmount);
                this.mPanel.btnSend.addEventListener(MouseEvent.CLICK, this.HitMonster);
                this.mPanel.btnAbort.addEventListener(MouseEvent.CLICK, this.ClosePanel);
                this.mPanel.btnKill.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, ("ButtonDefeatEnemy_" + this.mBuilding.GetBuildingName_string()), [this.mBuilding.GetBuildingName_string().toLowerCase()]);
                this.mPanel.btnKillIcon.source = gAssetManager.GetGfx((this.mBuilding.GetBuildingName_string().toLowerCase() + "_defeat.png"));
                if (((this.mGI.isOnHomzone()) && ((this.selectedSquad == null) || (this.selectedSquad.amount == 0))))
                {
                    this.mPanel.btnKill.addEventListener(MouseEvent.CLICK, this.KillMonster);
                    this.mPanel.btnKill.enabled = true;
                }
                else
                {
                    this.mPanel.btnKill.enabled = false;
                };
            };
            this.Refresh();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.x = ((this.mPanel.stage.stageWidth - this.mPanel.width) / 2);
            this.mPanel.y = ((this.mPanel.stage.stageHeight - this.mPanel.height) / 2);
            this.mPanel.buffIcon.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.buffTipCreate);
            this.mPanel.heartToDestroy.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.unitTipCreate);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        private function SelectBuff():void
        {
            var _local_3:cBuff;
            var _local_1:int;
            var _local_2:Array = this.mGI.mCurrentPlayer.getBuffsSortedForStarMenu();
            this.usedBuff = null;
            for each (_local_3 in _local_2)
            {
                if (_local_3.GetBuffDefinition() == this.usedBuffDefinition)
                {
                    this.usedBuff = _local_3;
                    break;
                };
            };
            this.buffEfficiency = this.CalculateEfficiency(this.usedBuffDefinition);
            if (this.usedBuff != null)
            {
                _local_1 = this.usedBuff.amount;
            };
            this.mPanel.buffContentSide.visible = (this.mPanel.enemyContentSide.visible = true);
            this.mPanel.arrow.source = gAssetManager.GetClass("ProductionArrow");
            if (this.mBuilding.GetGOContainer().mEventMonsterPreventOverbuff)
            {
                if ((((this.mGI.isOnHomzone()) && (!(this.selectedSquad == null))) && (this.selectedSquad.amount > 0)))
                {
                    _local_1 = Math.min(this.selectedSquad.amount, _local_1);
                }
                else
                {
                    _local_1 = 0;
                    this.mPanel.buffContentSide.visible = (this.mPanel.enemyContentSide.visible = false);
                };
            };
            this.mPanel.amountSlider.value = _local_1;
            this.mPanel.amountSlider.maximum = _local_1;
            this.mPanel.buffIcon.source = gAssetManager.GetBuffIcon(this.usedBuffDefinition.GetName_string());
            this.mPanel.buffIcon.toolTip = this.usedBuffDefinition.GetName_string();
            this.mPanel.buffIcon.visible = true;
            if (_local_1 > 0)
            {
                this.mPanel.amountSlider.enabled = true;
            }
            else
            {
                this.mPanel.amountSlider.enabled = false;
                this.mPanel.btnSend.enabled = false;
            };
            this.mPanel.selectedCount.visible = true;
            this.mPanel.maximumCount.visible = true;
            this.mPanel.buffCount.text = ("/ " + _local_1);
            this.SetAmount(null);
        }

        protected function unitTipCreate(_arg_1:ToolTipEvent):void
        {
            if (this.selectedSquad != null)
            {
                cToolTipUtil.createToolTip(cToolTipUtil.MILITARY_UNIT_EXTENDED_string, _arg_1);
            };
        }

        override public function Hide():void
        {
            this.mPanel.amountSlider.removeEventListener(SliderEvent.CHANGE, this.SetAmount);
            this.mPanel.selectedCount.removeEventListener(Event.CHANGE, this.ChangeResourceInputAmount);
            this.mPanel.btnSend.removeEventListener(MouseEvent.CLICK, this.HitMonster);
            this.mPanel.btnAbort.removeEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnKill.removeEventListener(MouseEvent.CLICK, this.KillMonster);
            super.Hide();
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
            this.updateUnit();
        }

        public function handleKillEventMonster():void
        {
            this.mBuilding.mBuildingDestructionTime = this.mGI.GetClientTime();
            this.mBuilding.SetBuildingMode(cBuilding.BUILDING_MODE_EPIC_MONSTER_DYING_EFFECT);
        }

        private function HitMonster(_arg_1:MouseEvent):void
        {
            var _local_4:int;
            var _local_5:cBuff;
            var _local_7:dBuffVO;
            var _local_2:ArrayCollection = new ArrayCollection();
            var _local_3:int = this.mPanel.amountSlider.value;
            if (_local_3 == 0)
            {
                return;
            };
            while (_local_3 > 0)
            {
                _local_4 = Math.min(_local_3, this.usedBuff.GetAmount());
                _local_7 = new dBuffVO();
                _local_7.uniqueId1 = this.usedBuff.GetUniqueId().uniqueID1;
                _local_7.uniqueId2 = this.usedBuff.GetUniqueId().uniqueID2;
                _local_7.amount = _local_4;
                _local_2.addItem(_local_7);
                this.usedBuff.SetWaitingForServerCount(_local_4, this.mGI);
                _local_3 = (_local_3 - _local_4);
            };
            var _local_6:dBuffListVO = new dBuffListVO();
            _local_6.buffList = _local_2;
            this.mGI.SendServerAction(COMMAND.APPLY_BUFF_LIST, 0, this.mBuilding.GetGrid(), 0, _local_6);
            this.mPanel.busyOverlay.visible = true;
        }

        protected function buffTipCreate(_arg_1:ToolTipEvent):void
        {
            if (this.usedBuffDefinition != null)
            {
                cToolTipUtil.createToolTip(cToolTipUtil.BUFF_string, _arg_1, this.usedBuffDefinition.GetResourceName_string());
            };
        }

        private function updateUnit():void
        {
            var _local_2:String;
            var _local_1:Number = 0;
            if (this.selectedSquad != null)
            {
                this.mPanel.heartContainer.visible = true;
                _local_1 = (this.selectedSquad.amount - (this.mPanel.amountSlider.value * this.buffEfficiency));
                this.mPanel.heartToDestroy.source = gAssetManager.GetMilitaryIcon(this.selectedSquad.GetType());
                this.mPanel.heartToDestroy.toolTip = this.selectedSquad.GetUnitDescription().GetType();
            }
            else
            {
                _local_2 = ((this.mBuilding != null) ? this.mBuilding.GetBuildingName_string() : "");
                this.mPanel.heartToDestroy.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("GolemNoHeartsLeft_" + _local_2));
                _local_1 = (0 - (this.mPanel.amountSlider.value * this.buffEfficiency));
                this.mPanel.heartToDestroy.source = gAssetManager.GetMilitaryIcon(("BrokenHeart_" + _local_2));
                if (!this.mPanel.enemyContentSide.visible)
                {
                    this.mPanel.arrow.source = gAssetManager.GetMilitaryIcon(("BrokenHeart_" + _local_2));
                }
                else
                {
                    this.mPanel.arrow.source = gAssetManager.GetClass("ProductionArrow");
                };
            };
            if (_local_1 < 0)
            {
                this.mPanel.heartsRemaining.text = "0";
                this.mPanel.overbuffed.includeInLayout = (this.mPanel.overbuffed.visible = true);
                this.mPanel.heartsRemaining.setStyle("color", "Red");
            }
            else
            {
                this.mPanel.heartsRemaining.text = ("" + _local_1);
                this.mPanel.overbuffed.includeInLayout = (this.mPanel.overbuffed.visible = false);
                this.mPanel.heartsRemaining.setStyle("color", "#FFFFFF");
            };
        }

        public function Init(_arg_1:EventMonster):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mGI.channels.ZONE.addPropertyObserver(ZoneChannel.ZONE_REFRESHED, this);
        }

        private function CalculateEfficiency(_arg_1:cBuffDefinition):int
        {
            var _local_3:dBuffEfficiencyVO;
            var _local_4:Array;
            var _local_5:Boolean;
            var _local_6:String;
            var _local_2:String = _arg_1.GetTargetDescription_string();
            if (((_arg_1.isQuestProduceable()) && ((StringUtils.isEmpty(_arg_1.GetRedeemableEventName())) || (RequirementsHelper.checkEvent(this.mGI, _arg_1.GetRedeemableEventName())))))
            {
                if (!this.mGI.mNewQuestManager.GetQuestPool().IsQuestActiveList(_arg_1.GetRequiredQuest()))
                {
                    return (0);
                };
            };
            if (_local_2.indexOf(",") == -1)
            {
                if (_local_2 != this.mBuilding.GetBuildingName_string())
                {
                    return (0);
                };
            }
            else
            {
                _local_4 = StringUtils.split(_local_2, ",");
                _local_5 = false;
                for each (_local_6 in _local_4)
                {
                    if (_local_6 == this.mBuilding.GetBuildingName_string())
                    {
                        _local_5 = true;
                    };
                };
                if (!_local_5)
                {
                    return (0);
                };
            };
            for each (_local_3 in _arg_1.GetBuffEfficiencies_vector())
            {
                if (((!(this.selectedSquad == null)) && (!(_local_3.buffName == this.selectedSquad.GetUnitDescription().GetType()))))
                {
                    return (0);
                };
                return (_local_3.efficiency);
            };
            return (0);
        }

        private function SetAmount(_arg_1:SliderEvent):void
        {
            this.mPanel.selectedCount.text = this.mPanel.amountSlider.value.toString();
            this.mPanel.maximumCount.text = (" / " + this.mPanel.amountSlider.maximum);
            this.mPanel.selectedCount.maxChars = String(this.mPanel.amountSlider.maximum).length;
            this.mPanel.selectedCount.width = (12 + (8 * (String(this.mPanel.amountSlider.maximum).length - 1)));
            this.updateUnit();
        }

        public function Refresh():void
        {
            var _local_2:cBuffDefinition;
            if (((((!(this.mGI == null)) && (!(this.mGI.mCurrentPlayerZone == null))) && (!(this.mGI.mCurrentPlayerZone.mStreetDataMap == null))) && (!(this.mBuilding == null))))
            {
                this.mBuilding = this.mGI.mCurrentPlayerZone.mStreetDataMap.GetBuildingByGridPos(this.mBuilding.GetGrid());
            };
            if (this.mBuilding == null)
            {
                this.Hide();
                return;
            };
            var _local_1:Vector.<cSquad> = this.mBuilding.GetArmy().GetSquads_vector();
            if (_local_1.length > 0)
            {
                this.selectedSquad = _local_1[0];
                this.mPanel.heartToDestroy.source = gAssetManager.GetMilitaryIcon(_local_1[0].GetType());
            }
            else
            {
                this.selectedSquad = null;
            };
            this.mPanel.busyOverlay.visible = false;
            for each (_local_2 in global.map_BuffId_BuffDefinition)
            {
                if (this.CalculateEfficiency(_local_2) != 0)
                {
                    this.usedBuffDefinition = _local_2;
                    break;
                };
            };
            this.SelectBuff();
            if (((this.mGI.isOnHomzone()) && ((this.selectedSquad == null) || (this.selectedSquad.amount == 0))))
            {
                this.mPanel.btnKill.addEventListener(MouseEvent.CLICK, this.KillMonster);
                this.mPanel.btnKill.enabled = true;
            }
            else
            {
                this.mPanel.btnKill.enabled = false;
            };
        }

        private function KillMonster(_arg_1:MouseEvent):void
        {
            if (((this.selectedSquad == null) || ((!(this.selectedSquad == null)) && (this.selectedSquad.amount == 0))))
            {
                this.mGI.SendServerAction(COMMAND.KILL_EVENT_MONSTER, 0, this.mBuilding.GetGrid(), 0, null);
                this.Hide();
            };
        }


    }
}
