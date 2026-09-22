package GUI.GAME
{
    import mx.collections.ArrayCollection;
    import GO.cBuilding;
    import GUI.Components.data.dCombatUnitData;
    import Interface.cGameInterface;
    import mx.binding.utils.ChangeWatcher;
    import GUI.Components.Combat30ToolTip;
    import GUI.Loca.cLocaManager;
    import AdventureSystem.cAdventureDefinition;
    import Enums.COMMAND;
    import flash.events.MouseEvent;
    import Specialists.cSpecialist;
    import Communication.VO.dStartSpecialistTaskVO;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.SPECIALIST_TASK_ATTACK_BUILDING_MODE;
    import Specialists.cSpecialistTask_WaitForConfirmation;
    import Sound.cSoundManager;
    import GUI.event.Combat3StartAttackEvent;
    import __AS3__.vec.Vector;
    import MilitarySystem.cSquad;
    import mx.collections.Sort;
    import MilitarySystem.cMilitaryUnitData;
    import MilitarySystem.cMilitaryUnitDescription;
    import MilitarySystem.cMilitaryUnitAbility;
    import MilitarySystem.cMilitaryUnitBase;
    import Enums.MILLITARY_UNIT_SKILLS;
    import Enums.MILITARY_UNIT_ARMORTYPE;
    import MilitarySystem.cArmy;
    import flash.events.Event;
    import nLib.cPosInt;

    public class cCombat30ToolTip extends cCombatUIBase 
    {

        public static const EVENT_REPOSITION:String = "eventReposition";

        private var mBuildingUnitDataProvider:ArrayCollection;
        private var mBuilding:cBuilding;
        private var mBossData:dCombatUnitData;
        private var mScaleFactor:Number = 1;
        private var mGridId:int = 0;
        private var mGI:cGameInterface;
        private var heightWatcher:ChangeWatcher;
        private var widthWatcher:ChangeWatcher;
        public var mPanel:Combat30ToolTip;
        private var mLM:cLocaManager = cLocaManager.GetInstance();
        private var mHasBoss:Boolean = false;
        private var mSpecialistUnitDataProvider:ArrayCollection;


        override public function SetMode(_arg_1:int):void
        {
            var _local_3:cAdventureDefinition;
            var _local_4:int;
            var _local_5:int;
            mMode = _arg_1;
            this.mPanel.chooseUnitLabel.visible = false;
            var _local_2:Boolean;
            if (global.ui.IsAdventureZone())
            {
                _local_3 = cAdventureDefinition.FindAdventureDefinition(this.mGI.getAdventureName());
                _local_2 = (((global.ui.IsAdventureZone()) && (!(_local_3 == null))) && ((_local_3.IsColony()) || (_local_3.IsTrainingExpedition())));
            };
            switch (mMode)
            {
                case MODE_SELECT_UNIT:
                    this.mPanel.chooseUnitLabel.visible = true;
                    _local_4 = 0;
                    while (_local_4 < this.mBuildingUnitDataProvider.length)
                    {
                        this.mBuildingUnitDataProvider[_local_4].isEnabled = false;
                        _local_4++;
                    };
                    _local_5 = 0;
                    while (_local_5 < this.mSpecialistUnitDataProvider.length)
                    {
                        this.mSpecialistUnitDataProvider[_local_5].isSelectable = true;
                        _local_5++;
                    };
                    break;
                case MODE_PRE_ATTACK:
                    this.mPanel.specialistUnitsContainer.visible = _local_2;
                    this.mPanel.buildingClickZone.visible = _local_2;
                    break;
                case MODE_NORMAL:
                    this.mPanel.specialistUnitsContainer.visible = false;
                    this.mPanel.buildingClickZone.visible = false;
                    break;
            };
            this.renderBoss();
            this.renderUnitsTopRow();
            this.renderUnitsBottomRow();
        }

        private function buildingClickZoneMouseClickHander(_arg_1:MouseEvent):void
        {
            switch (mMode)
            {
                case MODE_PRE_ATTACK:
                    if (this.mGI.UsesCombatThree())
                    {
                        this.SetMode(MODE_SELECT_UNIT);
                        this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.COMBAT3_CHOOSE_UNIT);
                        this.mGI.LockPreviewPath(this.mBuilding.GetGrid());
                    }
                    else
                    {
                        this.startAttack();
                    };
                    return;
                case MODE_SELECT_UNIT:
                    return;
            };
        }

        private function startAttack():void
        {
            var _local_1:cSpecialist = this.mGI.mCurrentCursor.mCurrentSpecialist;
            var _local_2:dStartSpecialistTaskVO = new dStartSpecialistTaskVO();
            _local_2.uniqueID = _local_1.GetUniqueID();
            global.ui.SendServerAction(COMMAND.SET_TASK, SPECIALIST_TASK_TYPES.ATTACK_BUILDING, this.mBuilding.GetGrid(), SPECIALIST_TASK_ATTACK_BUILDING_MODE.BUILDING_ONLY, _local_2);
            _local_1.SetTask(new cSpecialistTask_WaitForConfirmation(this.mGI, _local_1, 0, SPECIALIST_TASK_TYPES.ATTACK_BUILDING));
            this.mGI.mCurrentCursor.mCurrentSpecialist = null;
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            cSoundManager.getInstance().playEffect("GeneralAttack");
            this.mGI.UnlockPreviewPath();
            globalFlash.gui.mCancelActionPanel.Hide();
            this.Hide();
        }

        protected function SetPosition():void
        {
            this.mPanel.gridPos = this.mGridId;
            this.mPanel.offsetPoint.x = (-(globalFlash.gui.mCombat30ToolTip.mPanel.width) / 2);
            this.mPanel.offsetPoint.y = (-(110) - (110 * (this.mScaleFactor / 1000)));
            if (((this.mPanel.bossBox.visible) && (this.mPanel.campUnitsCanvas.visible)))
            {
                this.mPanel.offsetPoint.y = (this.mPanel.offsetPoint.y - this.mPanel.bossBox.height);
            };
            globalFlash.nLibFlexBridgeManager.updateBridge(this.mPanel);
        }

        protected function startAttackEventHandler(_arg_1:Combat3StartAttackEvent):void
        {
            var _local_2:cSpecialist;
            var _local_3:dStartSpecialistTaskVO;
            _arg_1.stopPropagation();
            if (mMode == MODE_SELECT_UNIT)
            {
                _local_2 = this.mGI.mCurrentCursor.mCurrentSpecialist;
                _local_3 = new dStartSpecialistTaskVO();
                _local_3.uniqueID = _local_2.GetUniqueID();
                _local_3.paramString = _arg_1.unitName;
                global.ui.SendServerAction(COMMAND.SET_TASK, SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT, this.mBuilding.GetGrid(), SPECIALIST_TASK_ATTACK_BUILDING_MODE.BUILDING_ONLY, _local_3);
                _local_2.SetTask(new cSpecialistTask_WaitForConfirmation(this.mGI, _local_2, 0, SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT));
                this.mGI.mCurrentCursor.mCurrentSpecialist = null;
                this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                cSoundManager.getInstance().playEffect("GeneralAttack");
                this.mGI.UnlockPreviewPath();
                globalFlash.gui.mCancelActionPanel.Hide();
                this.Hide();
            }
            else
            {
                this.buildingClickZoneMouseClickHander(null);
            };
        }

        private function populateDataArrayFromArmy(_arg_1:cSpecialist, _arg_2:cArmy, _arg_3:Boolean=false, _arg_4:Boolean=false):ArrayCollection
        {
            var _local_5:ArrayCollection;
            var _local_6:Vector.<cSquad>;
            var _local_7:cSquad;
            var _local_8:Sort;
            var _local_9:dCombatUnitData;
            var _local_10:cMilitaryUnitData;
            var _local_11:cMilitaryUnitDescription;
            var _local_12:cMilitaryUnitAbility;
            var _local_13:dCombatUnitData;
            if (_arg_2 != null)
            {
                _local_5 = new ArrayCollection();
                _local_6 = _arg_2.GetSquads_vector().sort(cMilitaryUnitBase.SortSquads);
                if (_arg_3)
                {
                    this.mPanel.nextArrow.visible = false;
                };
                for each (_local_7 in _local_6)
                {
                    _local_9 = new dCombatUnitData();
                    _local_10 = _local_7.GetUnitData();
                    if (!((!(_local_7.IsCombat3())) && (_arg_4)))
                    {
                        if (_local_7.IsCombat3())
                        {
                            if (((_local_7 == _arg_2.GetFirstDefenseNPCUnit()) && (!(_local_10.IsBoss()))))
                            {
                                _local_9.isFirstUnit = true;
                                this.mPanel.nextArrow.visible = true;
                            }
                            else
                            {
                                _local_9.isFirstUnit = false;
                            };
                        }
                        else
                        {
                            _local_11 = cMilitaryUnitDescription.GetUnitDescriptionForType(_local_7.GetType());
                            _local_9.hasACBonus = false;
                            if (((!(_local_11 == null)) && (_local_11.GetSkill(MILLITARY_UNIT_SKILLS.BONUS_AC_IN_TOWER))))
                            {
                                _local_9.hasACBonus = true;
                            };
                        };
                        if ((((!(_local_10 == null)) && (_local_10.IsNPC())) || ((_local_10 == null) && (_arg_2.isNPC()))))
                        {
                            _local_9.isNPC = true;
                        }
                        else
                        {
                            _local_9.isNPC = false;
                        };
                        _local_9.name_string = _local_7.name_string;
                        if (_local_10 != null)
                        {
                            _local_9.armorType = _local_10.GetArmorType();
                        }
                        else
                        {
                            _local_9.armorType = -1;
                        };
                        _local_9.bonusDamage1 = -1;
                        _local_9.bonusDamage2 = -1;
                        _local_9.isEnabled = true;
                        _local_9.isSelectable = false;
                        switch (_local_9.armorType)
                        {
                            case MILITARY_UNIT_ARMORTYPE.MEDIUM:
                                _local_9.sortOrder = 1;
                                break;
                            case MILITARY_UNIT_ARMORTYPE.HEAVY:
                                _local_9.sortOrder = 2;
                                break;
                            case MILITARY_UNIT_ARMORTYPE.LIGHT:
                                _local_9.sortOrder = 3;
                                break;
                            case MILITARY_UNIT_ARMORTYPE.TANK:
                                _local_9.sortOrder = 4;
                                break;
                            default:
                                _local_9.sortOrder = 0;
                        };
                        if (_local_10 != null)
                        {
                            for each (_local_12 in _local_10.GetAbilities())
                            {
                                if (_local_9.bonusDamage1 == -1)
                                {
                                    _local_9.bonusDamage1 = _local_12.GetType();
                                }
                                else
                                {
                                    _local_9.bonusDamage2 = _local_12.GetType();
                                };
                            };
                        };
                        _local_9.isAttackable = _local_7.GetUnitBase().IsAttackable();
                        _local_9.current = _local_7.GetAmount();
                        _local_9.displayPrio = cMilitaryUnitBase.GetUnitBaseForType(_local_7.GetType()).GetSequencePrio();
                        if (((_local_10 == null) || (!(_local_10.IsBoss()))))
                        {
                            _local_5.addItem(_local_9);
                        }
                        else
                        {
                            if (_local_10.IsBoss())
                            {
                                _local_9.hitPoints = (_local_7.currentHitPoints / 1);
                                this.mBossData = _local_9;
                                this.mHasBoss = true;
                            };
                        };
                        _local_9.specialist = _arg_1;
                    };
                };
                if ((((((!(this.mGI.UsesCombatThree())) && (!(this.mBuilding.isGarrison()))) && (this.mBuilding.getBuildingIsAttackable())) && (this.mBuilding.getPlayerID() < 0)) && (!(this.mBuilding.getPlayerID() == global.ui.mHomePlayer.GetPlayerId()))))
                {
                    _local_13 = new dCombatUnitData();
                    _local_13.isBuilding = true;
                    _local_13.armorType = -1;
                    _local_13.hitPoints = this.mBuilding.GetMaxHitPoints();
                    _local_13.displayPrio = int.MAX_VALUE;
                    _local_13.name_string = this.mBuilding.GetBuildingName_string();
                    _local_5.addItem(_local_13);
                };
                _local_8 = new Sort();
                _local_8.compareFunction = this.sortCombatUnitData;
                _local_5.sort = _local_8;
                _local_5.refresh();
            };
            return (_local_5);
        }

        override public function SetData(_arg_1:cBuilding, _arg_2:cSpecialist, _arg_3:cArmy, _arg_4:cArmy, _arg_5:int, _arg_6:Number):void
        {
            this.mPanel.nextArrow.visible = false;
            this.mBuilding = _arg_1;
            this.mGridId = _arg_5;
            this.mScaleFactor = _arg_6;
            this.mBuildingUnitDataProvider = new ArrayCollection();
            this.mSpecialistUnitDataProvider = new ArrayCollection();
            this.mBossData = new dCombatUnitData();
            this.mHasBoss = false;
            if (_arg_3 != null)
            {
                this.mBuildingUnitDataProvider = this.populateDataArrayFromArmy(_arg_2, _arg_3, true);
            };
            if (_arg_4 != null)
            {
                this.mSpecialistUnitDataProvider = this.populateDataArrayFromArmy(_arg_2, _arg_4, false, true);
            };
            this.SetMode(mMode);
            this.SetPosition();
            this.mBuilding.notifyPropertyObserver(cBuilding.BUILDING_COMBATTOOLTIP_string, true);
        }

        override public function Show():void
        {
            super.Show();
            this.SetScaleFactor(this.mGI.mZoom.GetScaleFactor());
        }

        private function sortCombatUnitData(_arg_1:dCombatUnitData, _arg_2:dCombatUnitData, _arg_3:Array=null):int
        {
            if (((_arg_1.isFirstUnit) && (!(_arg_2.isFirstUnit))))
            {
                return (-1);
            };
            if (((_arg_2.isFirstUnit) && (!(_arg_1.isFirstUnit))))
            {
                return (1);
            };
            if (_arg_1.displayPrio < _arg_2.displayPrio)
            {
                return (-1);
            };
            if (_arg_1.displayPrio > _arg_2.displayPrio)
            {
                return (1);
            };
            return (0);
        }

        override public function Hide():void
        {
            super.Hide();
            this.mGI.UnlockPreviewPath();
            this.mBuilding.notifyPropertyObserver(cBuilding.BUILDING_COMBATTOOLTIP_string, false);
        }

        protected function enterFrameHandler(_arg_1:Event):void
        {
            this.mPanel.nextArrow.y = this.mGI.mWobblingInt;
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

        private function SetScaleFactor(_arg_1:int=1):void
        {
            if (((!(_arg_1 == this.mScaleFactor)) && (_arg_1 <= 2)))
            {
                this.mScaleFactor = _arg_1;
                this.mPanel.buildingClickZone.height = (45 * this.mScaleFactor);
            };
        }

        public function getSelectedBuilding():cBuilding
        {
            return (this.mBuilding);
        }

        public function Init(_arg_1:Combat30ToolTip):void
        {
            globalFlash.gui.windowController.addWindow(_arg_1);
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.horizontalScrollPolicy = "none";
            this.mPanel.verticalScrollPolicy = "none";
            this.mPanel.offsetPoint = new cPosInt();
            this.mBuildingUnitDataProvider = new ArrayCollection();
            this.mSpecialistUnitDataProvider = new ArrayCollection();
            this.mPanel.buildingClickZone.addEventListener(MouseEvent.CLICK, this.buildingClickZoneMouseClickHander);
            this.mPanel.specialistUnitsList.addEventListener(Combat3StartAttackEvent.INITIATE_COMBAT, this.startAttackEventHandler);
            this.mPanel.addEventListener(cCombat30ToolTip.EVENT_REPOSITION, this.repositionEventHandler);
            this.mPanel.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
            this.widthWatcher = ChangeWatcher.watch(this.mPanel, "width", this.repositionEventHandler);
            this.heightWatcher = ChangeWatcher.watch(this.mPanel, "height", this.repositionEventHandler);
        }

        private function renderBoss():void
        {
            if (this.mHasBoss)
            {
                this.mPanel.bossBox.visible = true;
                this.mPanel.bossBox.dataProvider = [this.mBossData];
            }
            else
            {
                this.mPanel.bossBox.data = null;
                this.mPanel.bossBox.visible = false;
            };
        }

        private function renderUnitsBottomRow():void
        {
            this.mPanel.specialistUnitsList.dataProvider = this.mSpecialistUnitDataProvider;
        }

        protected function repositionEventHandler(_arg_1:Event):void
        {
            this.SetPosition();
        }


    }
}
