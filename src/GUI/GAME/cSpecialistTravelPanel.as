package GUI.GAME
{
    import Interface.cGameInterface;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import GUI.Components.SpecialistTravelPanel;
    import GUI.Components.ItemRenderer.SpecialistTravelItemData;
    import Specialists.cSpecialist;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;
    import AdventureSystem.cAdventureDefinition;
    import mx.collections.ArrayCollection;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.KILL_SWITCH;
    import Specialists.cSpecialistDescription;
    import Enums.SPECIALIST_TYPE;
    import GUI.Components.ItemRenderer.SpecialistTravelItemRenderer;
    import Skill.cSkill;
    import Modifier.ModifierVO;
    import Modifier.Modifiers.Common.ZoneTravelSpeed;
    import Enums.SPECIALIST_TASK_TYPES;
    import Modifier.Modifiers.Combat.CombatModifier;

    public class cSpecialistTravelPanel extends cBasicPanel 
    {

        private var mIsOwnAdventureZone:Boolean = false;
        private var mGI:cGameInterface;
        private var mTargetAdventure:dAdventureClientInfoVO;
        protected var mPanel:SpecialistTravelPanel;
        private var lockedByKillSwitch:Boolean = false;
        private var mMaxTroopLimit:int;
        private var mTargetZoneId:int;
        private var isSkilled:Boolean = false;
        private var mMaxGeneralsLimit:int;


        private function ClearHighlights():void
        {
            var _local_1:SpecialistTravelItemData;
            if (this.mPanel.availableSpecialists.dataProvider != null)
            {
                for each (_local_1 in this.mPanel.availableSpecialists.dataProvider)
                {
                    _local_1.selected = false;
                };
            };
        }

        private function SendSpecialist(_arg_1:MouseEvent):void
        {
            var _local_2:SpecialistTravelItemData;
            var _local_3:cSpecialist;
            for each (_local_2 in this.mPanel.availableSpecialists.dataProvider)
            {
                if (_local_2.selected)
                {
                    _local_3 = (_local_2.specialist as cSpecialist);
                    if (((_local_3) && (!(this.lockedByKillSwitch))))
                    {
                        this.mPanel.btnOK.enabled = false;
                        global.services.specialist.sendToZone(_local_3, (((this.mGI.mCurrentPlayer.mIsAdventureZone) && (this.mTargetZoneId == this.mGI.mCurrentViewedZoneID)) ? this.mGI.mCurrentPlayer.GetHomeZoneId() : this.mTargetZoneId));
                    };
                };
            };
            if (!this.mPanel.btnOK.enabled)
            {
                this.Hide();
            };
            this.mPanel.fetchingData.visible = true;
            this.mPanel.btnOK.enabled = false;
        }

        public function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.SendSpecialist);
            this.mPanel.availableSpecialists.addEventListener(ListEvent.ITEM_CLICK, this.SelectSpecialist);
        }

        public function SetBusyOff():void
        {
            var _local_1:SpecialistTravelItemData;
            this.SetData(this.mTargetZoneId);
            this.mPanel.fetchingData.visible = false;
            this.mPanel.btnOK.enabled = false;
            for each (_local_1 in this.mPanel.availableSpecialists.dataProvider)
            {
                if (_local_1.selected)
                {
                    this.mPanel.btnOK.enabled = true;
                    break;
                };
            };
        }

        public function SetData(_arg_1:int):void
        {
            var _local_6:cSpecialist;
            var _local_7:cAdventureDefinition;
            this.mIsOwnAdventureZone = (this.mGI.mCurrentViewedZoneID == _arg_1);
            this.mTargetZoneId = _arg_1;
            this.lockedByKillSwitch = false;
            var _local_2:Boolean;
            var _local_3:Boolean = true;
            var _local_4:ArrayCollection = new ArrayCollection();
            this.ClearHighlights();
            var _local_5:dAdventureClientInfoVO = AdventureManager.getInstance().getAdventure(this.mTargetZoneId);
            if (_local_5 != null)
            {
                _local_7 = cAdventureDefinition.FindAdventureDefinition(_local_5.adventureName);
                _local_2 = _local_7.UsesCombatThree();
                _local_3 = _local_7.UseElite();
            };
            this.mTargetAdventure = _local_5;
            if ((((!(_local_7 == null)) && (_local_2)) && (!(this.mIsOwnAdventureZone))))
            {
                this.mMaxGeneralsLimit = global.expeditionMapLevelGroupVO.GetGeneralsLimit(_local_7.GetLevelRangeExpedition());
                this.mMaxTroopLimit = _local_5.troopLimit;
                this.mPanel.troopsLabel.text = ("0 / " + this.mMaxTroopLimit.toString());
                this.mPanel.admiralsLabel.text = ((this.mTargetAdventure.admiralCount.toString() + " / ") + this.mMaxGeneralsLimit.toString());
                this.mPanel.lblSendArmyDescription.text = ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "TroopLimitCompleteData"));
                this.mPanel.colonyLimitsPanel.visible = true;
                this.mPanel.troopsLabel.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TroopLimitCompleteData", [0, this.mMaxTroopLimit, this.mMaxTroopLimit]);
                this.mPanel.admiralsLabel.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GeneralLimitCompleteData", [this.mTargetAdventure.admiralCount, this.mMaxGeneralsLimit, this.mMaxGeneralsLimit]);
                this.lockedByKillSwitch = this.mGI.killswitch.isLocked(KILL_SWITCH.PVP_COLONY_TRAVEL);
            }
            else
            {
                this.mPanel.lblSendArmyDescription.text = "";
                this.mPanel.colonyLimitsPanel.visible = false;
                this.lockedByKillSwitch = this.mGI.killswitch.isLocked(KILL_SWITCH.ADVENTURE_TRAVEL);
            };
            for each (_local_6 in this.mGI.mCurrentPlayerZone.GetSpecialists_vector().sort(cSpecialistDescription.CompareBySortIndex))
            {
                if ((((_local_6.getPlayerID() == this.mGI.mCurrentPlayer.GetPlayerId()) && (_local_6.GetTask() == null)) && ((((_local_6.GetBaseType() == SPECIALIST_TYPE.GENERAL) || (_local_6.GetBaseType() == SPECIALIST_TYPE.TRANSPORTER_GENERAL)) && (!(_local_2))) || ((_local_6.GetBaseType() == SPECIALIST_TYPE.ADMIRAL) && (_local_2)))))
                {
                    _local_4.addItem(new SpecialistTravelItemData(_local_6, _local_2, _local_3));
                };
            };
            this.mPanel.availableSpecialists.dataProvider = _local_4;
            this.mPanel.btnOK.enabled = false;
        }

        override public function Show():void
        {
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, (((this.mGI.mCurrentPlayer.mIsAdventureZone) && (this.mTargetZoneId == this.mGI.mCurrentViewedZoneID)) ? "SendArmyBack" : "SendArmy"));
            this.mPanel.taskDuration.text = "";
            super.Show();
        }

        private function SelectSpecialist(_arg_1:ListEvent):void
        {
            var _local_9:SpecialistTravelItemData;
            var _local_10:cSpecialist;
            var _local_11:Number;
            var _local_12:Boolean;
            var _local_2:SpecialistTravelItemData = (_arg_1.itemRenderer.data as SpecialistTravelItemData);
            if (((!(_local_2)) || (!((_arg_1.itemRenderer as SpecialistTravelItemRenderer).canUse))))
            {
                return;
            };
            _local_2.selected = (!(_local_2.selected));
            var _local_3:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(this.mTargetAdventure.adventureName);
            var _local_4:Boolean = _local_3.UsesCombatThree();
            var _local_5:Number = 0;
            var _local_6:int;
            var _local_7:int;
            this.mPanel.btnOK.enabled = false;
            this.mPanel.btnOK.toolTip = null;
            this.mPanel.taskDuration.text = "";
            this.isSkilled = false;
            var _local_8:Boolean;
            for each (_local_9 in this.mPanel.availableSpecialists.dataProvider)
            {
                if (_local_9.selected)
                {
                    this.mPanel.btnOK.enabled = (!(this.lockedByKillSwitch));
                    _local_10 = (_local_9.specialist as cSpecialist);
                    _local_11 = this.GetTravelTime(_local_10);
                    _local_5 = Math.max(_local_11, _local_5);
                    _local_6 = (_local_6 + _local_10.GetArmy().GetUnitsCount());
                    if (_local_10.GetSpecialistDescription().GetAdventureMapLimitCount() > 0)
                    {
                        _local_7++;
                    };
                    _local_8 = true;
                };
            };
            this.isSkilled = ((this.IsSkilledTimeEffective()) && (_local_8));
            this.mPanel.taskDuration.text = cLocaManager.GetInstance().FormatDuration(_local_5);
            if (this.isSkilled)
            {
                this.mPanel.taskDuration.setStyle("color", "#4cf002");
            }
            else
            {
                this.mPanel.taskDuration.setStyle("color", "#ffffff");
            };
            if ((((!(this.mIsOwnAdventureZone)) && (_local_4)) && (this.mGI.mHomePlayer.GetPlayerId() > 0)))
            {
                _local_12 = true;
                if ((this.mTargetAdventure.admiralCount + _local_7) > this.mMaxGeneralsLimit)
                {
                    this.mPanel.admiralsLabel.setStyle("color", 0xFF0000);
                    _local_12 = false;
                }
                else
                {
                    this.mPanel.admiralsLabel.setStyle("color", 0xFFFFFF);
                };
                if (_local_6 > this.mMaxTroopLimit)
                {
                    this.mPanel.troopsLabel.setStyle("color", 0xFF0000);
                    _local_12 = false;
                }
                else
                {
                    this.mPanel.troopsLabel.setStyle("color", 0xFFFFFF);
                };
                if (!_local_12)
                {
                    this.mPanel.btnOK.enabled = false;
                    this.mPanel.btnOK.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TroopLimitForbidden");
                };
            };
            this.mPanel.troopsLabel.text = ((_local_6.toString() + " / ") + this.mMaxTroopLimit.toString());
            this.mPanel.troopsLabel.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TroopLimitCompleteData", [_local_6, this.mMaxTroopLimit, this.mMaxTroopLimit]);
            this.mPanel.admiralsLabel.text = (((this.mTargetAdventure.admiralCount + _local_7).toString() + " / ") + this.mMaxGeneralsLimit.toString());
            this.mPanel.admiralsLabel.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GeneralLimitCompleteData", [(this.mTargetAdventure.admiralCount + _local_7), this.mMaxGeneralsLimit, this.mMaxGeneralsLimit]);
        }

        public function Init(_arg_1:SpecialistTravelPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function IsSkilledTimeEffective():Boolean
        {
            var _local_2:SpecialistTravelItemData;
            var _local_3:Boolean;
            var _local_4:cSkill;
            var _local_5:cSkill;
            var _local_6:ModifierVO;
            var _local_7:ModifierVO;
            var _local_1:Boolean;
            if (this.mPanel.availableSpecialists.selectedIndices.length < 1)
            {
                return (false);
            };
            for each (_local_2 in this.mPanel.availableSpecialists.dataProvider)
            {
                if (_local_2.selected)
                {
                    _local_3 = false;
                    for each (_local_4 in _local_2.specialist.skills.getItems_vector())
                    {
                        for each (_local_6 in _local_4.getDefinition().level_vector[(_local_4.getLevel() - 1)])
                        {
                            if (_local_6.modifier_string == ZoneTravelSpeed.xml_string)
                            {
                                _local_3 = true;
                            };
                        };
                    };
                    for each (_local_5 in _local_2.specialist.getSkillTree().getItems_vector())
                    {
                        if (_local_5.getLevel() > 0)
                        {
                            for each (_local_7 in _local_5.getDefinition().level_vector[(_local_5.getLevel() - 1)])
                            {
                                if (_local_7.modifier_string == ZoneTravelSpeed.xml_string)
                                {
                                    _local_3 = true;
                                };
                            };
                        };
                    };
                    if (!_local_3)
                    {
                        _local_1 = true;
                    };
                };
            };
            return (!(_local_1));
        }

        private function GetTravelTime(_arg_1:cSpecialist):Number
        {
            var _local_2:Number;
            var _local_3:cSkill;
            var _local_4:cSkill;
            var _local_5:ModifierVO;
            var _local_6:ModifierVO;
            if (global.ui.mCurrentViewedZoneID == _arg_1.getPlayerID())
            {
                _local_2 = _arg_1.GetSpecialistDescription().GetTimeOverwriteTravelToZone();
            }
            else
            {
                _local_2 = _arg_1.GetSpecialistDescription().GetTimeOverwriteTravelFromZone();
            };
            if (_local_2 <= 0)
            {
                _local_2 = global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.TRAVEL_TO_ZONE].subtasks_vector[0].duration;
            };
            for each (_local_3 in _arg_1.skills.getItems_vector())
            {
                for each (_local_5 in _local_3.getDefinition().level_vector[(_local_3.getLevel() - 1)])
                {
                    if (_local_5.modifier_string == ZoneTravelSpeed.xml_string)
                    {
                        if (_local_5.value != 0)
                        {
                            _local_2 = _local_5.value;
                        };
                        _local_2 = (CombatModifier.saveMulti(_local_2, _local_5.multiplier) + _local_5.adder);
                        break;
                    };
                };
            };
            for each (_local_4 in _arg_1.getSkillTree().getItems_vector())
            {
                if (_local_4.getLevel() > 0)
                {
                    for each (_local_6 in _local_4.getDefinition().level_vector[(_local_4.getLevel() - 1)])
                    {
                        if (_local_6.modifier_string == ZoneTravelSpeed.xml_string)
                        {
                            if (_local_6.value != 0)
                            {
                                _local_2 = _local_6.value;
                            };
                            _local_2 = (CombatModifier.saveMulti(_local_2, _local_6.multiplier) + _local_6.adder);
                        };
                    };
                };
            };
            return ((_local_2 / _arg_1.GetSpecialistDescription().GetTimeBonus()) * 100);
        }


    }
}
