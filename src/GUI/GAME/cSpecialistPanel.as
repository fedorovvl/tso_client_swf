package GUI.GAME
{
    import ServerState.Responding;
    import Model.Observer;
    import Interface.cGameInterface;
    import GUI.Components.SpecialistPanel;
    import GO.cBuilding;
    import Specialists.cSpecialistSubTaskDefinition;
    import flash.utils.Dictionary;
    import Specialists.cSpecialist;
    import ServerState.dResource;
    import GUI.Components.ItemRenderer.ResourceItemRenderer;
    import mx.containers.HBox;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import GUI.Components.CustomAlert;
    import mx.controls.Alert;
    import flash.events.MouseEvent;
    import GUI.Components.StandardButton;
    import GUI.Components.CustomText;
    import Enums.COMMAND;
    import Enums.ERROR_CODES;
    import Communication.VO.dServerActionResult;
    import GUI.Loca.cLocaManager;
    import Skill.cSkill;
    import Enums.LOCA_GROUP;
    import Enums.SPECIALIST_TYPE;
    import GUI.Assets.gAssetManager;
    import Skill.SkillDefinition;
    import nLib.gMisc;
    import Enums.UNIT_COST_SOURCE;
    import Specialists.cSpecialistTask_ExploreSector;
    import Enums.TASK_PHASES_EXPLORE_SECTOR;
    import Specialists.cSpecialistTask_FindTreasure;
    import Enums.TASK_PHASES_FIND_TREASURE;
    import Specialists.cSpecialistTask_FindEventZone;
    import Enums.TASK_PHASES_FIND_EVENT_ZONE;
    import Specialists.cSpecialistTask_FindExpedition;
    import Enums.TASK_PHASES_FIND_EXPEDITION;
    import Specialists.cSpecialistTask_FindDeposit;
    import Enums.TASK_PHASES_FIND_DEPOSIT;
    import Modifier.ModifierVO;
    import Communication.VO.dContextItemVO;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import AdventureSystem.cAdventureDefinition;
    import mx.core.Application;
    import mx.events.CloseEvent;
    import mx.collections.ArrayCollection;
    import Communication.VO.dSquadVO;
    import MilitarySystem.cMilitaryUnitDescription;
    import flash.events.KeyboardEvent;
    import Enums.SPECIALIST_TASK_TYPES;
    import flash.events.Event;
    import Enums.GENERAL_STATE_SPRITE;
    import nLib.cLog;
    import GUI.Effects.gHintManager;
    import mx.events.FlexEvent;
    import Specialists.cSpecialistTask_AttackBuildingNewCombat;
    import Specialists.cSpecialistTask_AttackBuilding;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.events.ToolTipEvent;
    import MilitarySystem.cSquad;
    import Communication.VO.dRequirementsVO;
    import GUI.Decorator.GUIDecorator;
    import Enums.KILL_SWITCH;
    import mx.controls.Button;
    import mx.controls.Text;
    import Communication.VO.ColonyVO;
    import Modifier.Modifieable;
    import mx.controls.Image;
    import GUI.Components.ToolTips.SkillToolTipData;
    import mx.containers.Canvas;
    import Specialists.cSpecialistTaskDefinition;
    import MilitarySystem.cMilitaryUtil;
    import GUI.Components.Combat3UnitManager;
    import MilitarySystem.cArmy;
    import Communication.VO.ChangeNameVO;
    import Specialists.cSpecialistTask;
    import Communication.VO.dStartSpecialistTaskVO;
    import Specialists.cSpecialistTask_WaitForConfirmation;
    import Model.Notifier;
    import com.bluebyte.tso.service.ServiceManager;
    import GUI.Components.ItemRenderer.FriendsListMenuItemRenderer;
    import mx.core.UITextField;
    import Enums.TASK_PHASES_ATTACK_BUILDING;
    import __AS3__.vec.*;

    public class cSpecialistPanel extends cBasicPanel implements Responding, Observer 
    {

        public static const CLICK_ITEM:String = "CLICK_ITEM";
        public static const CLICK_DELETE_BUTTON:String = "CLICK_DELETE_BUTTON";
        private static const NUM_ADMIRAL_UNITS:int = 6;

        private var mPreviousUnitsAmount:int = 0;
        private var mGI:cGameInterface;
        protected var mPanel:SpecialistPanel;
        private var mMarkedBuilding:cBuilding;
        private var mSelectedSubTaskDefinition:cSpecialistSubTaskDefinition;
        private var mAdmiralTroops:Array = [];
        private var oldNameTmpString:String;
        private var activeAdmiralItemImages:Array = [];
        private var usingElite:Boolean = false;
        private var mIsCombatRunning:Boolean = false;
        private var taskPrototypes:Dictionary;
        private var mSpecialist:cSpecialist;


        private function createCostsList(_arg_1:Vector.<dResource>):DisplayObject
        {
            var _local_3:dResource;
            var _local_4:ResourceItemRenderer;
            var _local_2:HBox = new HBox();
            for each (_local_3 in _arg_1)
            {
                _local_4 = new ResourceItemRenderer();
                _local_4.data = _local_3;
                _local_2.addChild(_local_4);
            };
            return (_local_2);
        }

        public function IsCombatRunning():Boolean
        {
            return (this.mIsCombatRunning);
        }

        private function StartTravelHandler(_arg_1:MouseEvent):void
        {
            CustomAlert.show("StartTravel", "StartTravel", (Alert.OK | Alert.CANCEL), null, this.StartTravel, null, Alert.OK);
        }

        private function deselectButtons(_arg_1:Vector.<cSpecialistSubTaskDefinition>):void
        {
            var _local_2:cSpecialistSubTaskDefinition;
            var _local_3:String;
            var _local_4:StandardButton;
            var _local_5:CustomText;
            for each (_local_2 in _arg_1)
            {
                _local_3 = (_local_2.mainTask.taskName_string + _local_2.taskType_string);
                _local_4 = (this.mPanel[("btn" + _local_3)] as StandardButton);
                _local_4.selected = false;
                _local_5 = (this.mPanel[("text" + _local_3)] as CustomText);
                if (_local_4.data != null)
                {
                    _local_5.setStyle("color", "#FFD06A");
                }
                else
                {
                    _local_5.setStyle("color", "#FFFFFF");
                };
            };
        }

        public function GetSpecialist():cSpecialist
        {
            return (this.mSpecialist);
        }

        public function onFault(_arg_1:int, _arg_2:dServerActionResult):void
        {
            if (_arg_1 == COMMAND.CHANGE_SPECIALIST_NAME)
            {
                this.mSpecialist.setName(this.oldNameTmpString);
                this.mPanel.title.htmlText = this.mSpecialist.getName(false);
                if (_arg_2.errorCode == ERROR_CODES.BLACKLIST_MATCH)
                {
                };
                if (_arg_2.errorCode == ERROR_CODES.COULD_NOT_FIND_SPECIALIST)
                {
                };
            };
        }

        private function getTaskDurationText(_arg_1:Vector.<cSkill>):String
        {
            var _local_2:Number = this.mSelectedSubTaskDefinition.duration;
            var _local_3:String = (this.mSelectedSubTaskDefinition.mainTask.taskName_string + this.mSelectedSubTaskDefinition.taskType_string);
            _local_2 = this.calculateSkillsOnTaskDuration(_arg_1, _local_2, _local_3);
            return (cLocaManager.GetInstance().FormatDuration(_local_2));
        }

        public function SetData(_arg_1:cSpecialist):void
        {
            var _local_2:uint;
            var _local_3:uint;
            var _local_4:uint;
            var _local_5:cSkill;
            this.mSpecialist = _arg_1;
            this.SetUpTasks(_arg_1);
            this.removeLandmark();
            this.mPanel.title.htmlText = this.mSpecialist.getName(false);
            this.mPanel.description.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, SPECIALIST_TYPE.toString(this.mSpecialist.GetType()));
            this.mPanel.nameInput.visible = false;
            this.mPanel.iconPlaceholder.source = gAssetManager.GetBitmap(_arg_1.getIconID());
            this.mPanel.iconPlaceholder.toolTip = ((_arg_1.GetSpecialistDescription().isGeneral()) ? _arg_1.getMilitaryUnitType() : null);
            this.mPanel.editcontrol.normalState(null);
            this.mPanel.isOnHomezone = this.mGI.isOnHomzone();
            if (_arg_1.getSkillTree() != null)
            {
                _local_2 = 0;
                _local_3 = 0;
                _local_4 = 0;
                for each (_local_5 in _arg_1.getSkillTree().getItems_vector())
                {
                    if (_local_5.getSkillPointType_string() == SkillDefinition.TYPE_BRONZE)
                    {
                        _local_2 = (_local_2 + _local_5.getLevel());
                    }
                    else
                    {
                        if (_local_5.getSkillPointType_string() == SkillDefinition.TYPE_SILVER)
                        {
                            _local_3 = (_local_3 + _local_5.getLevel());
                        }
                        else
                        {
                            if (_local_5.getSkillPointType_string() == SkillDefinition.TYPE_GOLD)
                            {
                                _local_4 = (_local_4 + _local_5.getLevel());
                            };
                        };
                    };
                };
            };
            this.mPanel.bronzeResource.data = {
                "name_string":SkillDefinition.BRONZE_RESOURCE,
                "amount":_local_2
            };
            this.mPanel.silverResource.data = {
                "name_string":SkillDefinition.SILVER_RESOURCE,
                "amount":_local_3
            };
            this.mPanel.goldResource.data = {
                "name_string":SkillDefinition.GOLD_RESOURCE,
                "amount":_local_4
            };
            this.mPanel.currentState = "";
            switch (this.mSpecialist.GetBaseType())
            {
                case SPECIALIST_TYPE.TRANSPORTER_GENERAL:
                case SPECIALIST_TYPE.GENERAL:
                    if (this.mPanel.currentState != "General")
                    {
                        this.mPanel.currentState = "General";
                    };
                    this.EnterGeneralState(null);
                    break;
                case SPECIALIST_TYPE.ADMIRAL:
                    if (this.mPanel.currentState != "Admiral")
                    {
                        this.mPanel.currentState = "Admiral";
                    };
                    this.EnterAdmiralState(null);
                    break;
                case SPECIALIST_TYPE.GEOLOGIST:
                    if (this.mPanel.currentState == "Geologist")
                    {
                        this.EnterGeologistState(null);
                    }
                    else
                    {
                        this.mPanel.currentState = "Geologist";
                    };
                    break;
                case SPECIALIST_TYPE.EXPLORER:
                    this.mPanel.currentState = "Explorer";
                    break;
                default:
                    gMisc.Assert(false, ((((("Could not interpret specialist type " + this.mSpecialist.GetType()) + " (") + SPECIALIST_TYPE.toString(this.mSpecialist.GetType())) + ") called from: ") + gMisc.GetCallingMethodName()));
            };
            this.mPanel.title.validateDisplayList();
            this.usingElite = false;
            this.mPanel.switchToNewUnits = (!(this.usingElite));
        }

        private function ResetArmyChangesAdmiral(_arg_1:MouseEvent):void
        {
            this.mPanel.admiralUnitManager.SetData(this.mSpecialist, null, this.mGI.mCurrentPlayerZone.GetArmy(this.mGI.mCurrentPlayer.GetPlayerId()), 3, UNIT_COST_SOURCE.UNIT);
            this.mPanel.btnCommitArmyChangesAdmiral.enabled = false;
            this.mPanel.btnResetArmyChangesAdmiral.enabled = false;
        }

        private function SetUpTasks(_arg_1:cSpecialist):void
        {
            this.taskPrototypes = new Dictionary();
            this.taskPrototypes["ExploreSector"] = new cSpecialistTask_ExploreSector(this.mGI, _arg_1, 0, TASK_PHASES_EXPLORE_SECTOR.EXPLORE_SECTOR, 0);
            this.taskPrototypes["ExploreIsland"] = new cSpecialistTask_ExploreSector(this.mGI, _arg_1, 0, TASK_PHASES_EXPLORE_SECTOR.EXPLORE_SECTOR, 1);
            var _local_2:String = this.mGI.mEventManager.GetActiveTwoStepEventName();
            this.taskPrototypes["FindTreasureShort"] = new cSpecialistTask_FindTreasure(this.mGI, _arg_1, 0, TASK_PHASES_FIND_TREASURE.FIND_TREASURE, 0, _local_2);
            this.taskPrototypes["FindTreasureMedium"] = new cSpecialistTask_FindTreasure(this.mGI, _arg_1, 0, TASK_PHASES_FIND_TREASURE.FIND_TREASURE, 1, _local_2);
            this.taskPrototypes["FindTreasureLong"] = new cSpecialistTask_FindTreasure(this.mGI, _arg_1, 0, TASK_PHASES_FIND_TREASURE.FIND_TREASURE, 2, _local_2);
            this.taskPrototypes["FindTreasureEvenLonger"] = new cSpecialistTask_FindTreasure(this.mGI, _arg_1, 0, TASK_PHASES_FIND_TREASURE.FIND_TREASURE, 3, _local_2);
            this.taskPrototypes["FindTreasureProlonged"] = new cSpecialistTask_FindTreasure(this.mGI, _arg_1, 0, TASK_PHASES_FIND_TREASURE.FIND_TREASURE, 6, _local_2);
            this.taskPrototypes["FindTreasureTravellingErudite"] = new cSpecialistTask_FindTreasure(this.mGI, _arg_1, 0, TASK_PHASES_FIND_TREASURE.FIND_TREASURE, 4, _local_2);
            this.taskPrototypes["FindTreasureBeanACollada"] = new cSpecialistTask_FindTreasure(this.mGI, _arg_1, 0, TASK_PHASES_FIND_TREASURE.FIND_TREASURE, 5, _local_2);
            this.taskPrototypes["FindAdventureZoneShort"] = new cSpecialistTask_FindEventZone(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EVENT_ZONE.FIND_EVENT_ZONE, 0);
            this.taskPrototypes["FindAdventureZoneMedium"] = new cSpecialistTask_FindEventZone(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EVENT_ZONE.FIND_EVENT_ZONE, 1);
            this.taskPrototypes["FindAdventureZoneLong"] = new cSpecialistTask_FindEventZone(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EVENT_ZONE.FIND_EVENT_ZONE, 2);
            this.taskPrototypes["FindAdventureZoneVeryLong"] = new cSpecialistTask_FindEventZone(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EVENT_ZONE.FIND_EVENT_ZONE, 3);
            this.taskPrototypes["FindExpeditionGenerated"] = new cSpecialistTask_FindExpedition(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EXPEDITION.FIND_EXPEDITION, 0);
            this.taskPrototypes["FindExpeditionPvPSmall"] = new cSpecialistTask_FindExpedition(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EXPEDITION.FIND_EXPEDITION, 1);
            this.taskPrototypes["FindExpeditionPvPMedium"] = new cSpecialistTask_FindExpedition(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EXPEDITION.FIND_EXPEDITION, 2);
            this.taskPrototypes["FindExpeditionPvPBig"] = new cSpecialistTask_FindExpedition(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EXPEDITION.FIND_EXPEDITION, 3);
            this.taskPrototypes["FindExpeditionPvE"] = new cSpecialistTask_FindExpedition(this.mGI, _arg_1, 0, TASK_PHASES_FIND_EXPEDITION.FIND_EXPEDITION, 4);
            this.taskPrototypes["FindDepositStone"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 0);
            this.taskPrototypes["FindDepositBronzeOre"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 1);
            this.taskPrototypes["FindDepositMarble"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 2);
            this.taskPrototypes["FindDepositIronOre"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 3);
            this.taskPrototypes["FindDepositGoldOre"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 4);
            this.taskPrototypes["FindDepositCoal"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 5);
            this.taskPrototypes["FindDepositGranite"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 6);
            this.taskPrototypes["FindDepositTitaniumOre"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 7);
            this.taskPrototypes["FindDepositSalpeter"] = new cSpecialistTask_FindDeposit(this.mGI, _arg_1, 0, TASK_PHASES_FIND_DEPOSIT.WAIT_FOR_ORDERS, 8);
        }

        private function getRealCosts(_arg_1:Vector.<dResource>, _arg_2:Vector.<cSkill>):Vector.<dResource>
        {
            var _local_5:cSkill;
            var _local_6:Vector.<dResource>;
            var _local_7:dResource;
            var _local_8:ModifierVO;
            var _local_9:int;
            var _local_3:String = (this.mSelectedSubTaskDefinition.mainTask.taskName_string + this.mSelectedSubTaskDefinition.taskType_string);
            var _local_4:Vector.<ModifierVO> = new Vector.<ModifierVO>();
            for each (_local_5 in _arg_2)
            {
                for each (_local_8 in _local_5.getDefinition().level_vector[(_local_5.getLevel() - 1)])
                {
                    if ((((_local_8.type_string.length == 0) || (_local_8.type_string == _local_3)) && (_local_8.modifier_string.toLowerCase() == "searchcost")))
                    {
                        _local_4.push(_local_8);
                    };
                };
            };
            _local_6 = new Vector.<dResource>();
            for each (_local_7 in _arg_1)
            {
                _local_7 = _local_7.clone();
                _local_9 = 0;
                while (_local_9 < _local_4.length)
                {
                    _local_8 = _local_4[_local_9];
                    if (((_local_8.replace_string.length == 0) || (_local_8.replace_string == _local_7.name_string)))
                    {
                        if (_local_8.value != 0)
                        {
                            _local_7.amount = _local_8.value;
                        };
                        _local_7.amount = int(((_local_7.amount * _local_8.multiplier) + _local_8.adder));
                        if (_local_8.replace_string == _local_7.name_string)
                        {
                            _local_4.splice(_local_9, 1);
                            _local_9--;
                        };
                    };
                    _local_9++;
                };
                _local_6.push(_local_7);
            };
            for each (_local_8 in _local_4)
            {
                if (_local_8.replace_string.length > 0)
                {
                    _local_7 = new dResource();
                    _local_7.Init(_local_8.replace_string, _local_8.value);
                    _local_6.push(_local_7);
                };
            };
            return (_local_6);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        private function StartTravel(_arg_1:CloseEvent):void
        {
            var _local_2:Vector.<dContextItemVO>;
            var _local_3:dAdventureClientInfoVO;
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            if (this.mGI.isOnHomzone())
            {
                if (AdventureManager.getInstance().getAdventures().length > 1)
                {
                    _arg_1.stopImmediatePropagation();
                    _local_2 = new Vector.<dContextItemVO>();
                    for each (_local_3 in AdventureManager.getInstance().getAdventures())
                    {
                        _local_2.push(new dContextItemVO(_local_3.adventureName, this.StartTravelToAdventureHandler, ((this.IsAdventureValid(_local_3)) && (!(cAdventureDefinition.FindAdventureDefinition(_local_3.adventureName).IsPreventTravel()))), "", null, null, null, LOCA_GROUP.ADVENTURE_NAME));
                    };
                    globalFlash.gui.ShowContextMenu(_local_2, Application.application.mouseX, Application.application.mouseY);
                }
                else
                {
                    global.services.specialist.sendToZone(this.mSpecialist, AdventureManager.getInstance().getAdventures()[0].zoneID);
                    this.ClosePanel(null);
                };
            }
            else
            {
                global.services.specialist.sendToZone(this.mSpecialist, this.mGI.mCurrentPlayer.GetHomeZoneId());
                this.ClosePanel(null);
            };
        }

        private function ClearCurrentAssignedUnits(_arg_1:MouseEvent=null):void
        {
            var _local_4:Object;
            var _local_2:ArrayCollection = (this.mPanel.manageArmyList.dataProvider as ArrayCollection);
            var _local_3:Array = [];
            for each (_local_4 in _local_2)
            {
                _local_4.current = 0;
                _local_3.push(_local_4);
            };
            this.mPanel.manageArmyList.dataProvider = _local_3;
            this.mPanel.btnCommitArmyChanges.enabled = true;
            this.mPanel.btnResetArmyChanges.enabled = true;
        }

        private function CommitArmyChanges(_arg_1:MouseEvent):void
        {
            var _local_3:Object;
            var _local_2:Vector.<dSquadVO> = new Vector.<dSquadVO>();
            for each (_local_3 in this.mPanel.manageArmyList.dataProvider)
            {
                if (_local_3.current > 0)
                {
                    _local_2.push(new dSquadVO().init(_local_3.name_string, _local_3.current, cMilitaryUnitDescription.GetUnitDescriptionForType(_local_3.name_string).GetHitPoints()));
                };
            };
            this.DisableGeneralButtons();
            this.CommitArmyChangesHelper(_local_2);
        }

        protected function nameInputKeyUp(_arg_1:KeyboardEvent):void
        {
            if (((_arg_1.keyCode == 13) || (_arg_1.keyCode == 45)))
            {
                this.changeName(this.mPanel.nameInput.text);
            };
        }

        override public function Show():void
        {
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            if ((((((this.mSpecialist.GetTask() == null) || (this.mSpecialist.GetTask().GetType() == SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU)) || (this.mSpecialist.GetTask().GetType() == SPECIALIST_TASK_TYPES.RECOVER)) || (this.mSpecialist.GetTask().GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING)) || (this.mSpecialist.GetTask().GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT)))
            {
                super.Show();
                this.Refresh(this.mSpecialist);
            };
        }

        protected function enableCommit(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
            this.mPanel.btnResetArmyChangesAdmiral.enabled = true;
            this.mPanel.btnCommitArmyChangesAdmiral.enabled = true;
            this.mPanel.btnAttackAdmiral.enabled = false;
            this.mPanel.btnTransferAdmiral.enabled = false;
        }

        private function removeLandmark():void
        {
            if (this.mMarkedBuilding != null)
            {
                this.mMarkedBuilding.renderAttackCursor = false;
                this.mMarkedBuilding = null;
            };
        }

        private function setGeneralState():void
        {
            if (this.mSpecialist.GetTask())
            {
                switch (this.mSpecialist.GetTask().GetType())
                {
                    case SPECIALIST_TASK_TYPES.RECOVER:
                        switch (this.mPanel.currentState)
                        {
                            case "Admiral":
                                this.mPanel.admiralStatusPanel.recoveryLabel.text = cLocaManager.GetInstance().getLabel("RecoveryTime");
                                this.mPanel.busy = true;
                                this.mPanel.admiralRecovering.visible = true;
                                this.mPanel.admiralStatusPanel.data = this.mSpecialist.GetGeneralState();
                                this.mPanel.admiralStatusPanel.visible = true;
                                this.mPanel.admiralBusyAnim.visible = false;
                                this.mPanel.admiralStatusPanel.recoveryTimeRemaining.text = cLocaManager.GetInstance().FormatDuration(this.mSpecialist.GetTask().GetRemainingTime(), cLocaManager.DURATION_FORMAT_SHORT);
                                break;
                            case "General":
                                this.mPanel.generalStatusPanel.recoveryLabel.text = cLocaManager.GetInstance().getLabel("RecoveryTime");
                                this.mPanel.busy = true;
                                this.mPanel.generalRecovering.visible = true;
                                this.mPanel.generalStatusPanel.data = this.mSpecialist.GetGeneralState();
                                this.mPanel.generalStatusPanel.visible = true;
                                this.mPanel.generalBusyAnim.visible = false;
                                this.mPanel.generalStatusPanel.recoveryTimeRemaining.text = cLocaManager.GetInstance().FormatDuration(this.mSpecialist.GetTask().GetRemainingTime(), cLocaManager.DURATION_FORMAT_SHORT);
                                break;
                        };
                        break;
                    case SPECIALIST_TASK_TYPES.ATTACK_BUILDING:
                        this.mPanel.busy = true;
                        this.mPanel.generalRecovering.visible = true;
                        this.mPanel.generalStatusPanel.data = this.mSpecialist.GetGeneralState();
                        this.mPanel.generalStatusPanel.visible = (!(this.mSpecialist.GetGeneralState() == GENERAL_STATE_SPRITE.STATE_OK));
                        this.mPanel.generalBusyAnim.visible = false;
                        break;
                    case SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT:
                        this.mPanel.busy = true;
                        this.mPanel.admiralRecovering.visible = true;
                        this.mPanel.admiralStatusPanel.data = this.mSpecialist.GetGeneralState();
                        this.mPanel.admiralStatusPanel.visible = (!(this.mSpecialist.GetGeneralState() == GENERAL_STATE_SPRITE.STATE_OK));
                        this.mPanel.admiralBusyAnim.visible = false;
                        break;
                    default:
                        this.mPanel.busy = false;
                        if (this.mPanel.admiralRecovering != null)
                        {
                            this.mPanel.admiralRecovering.visible = false;
                            this.mPanel.admiralStatusPanel.visible = false;
                            this.mPanel.admiralBusyAnim.visible = false;
                        };
                        if (this.mPanel.generalRecovering != null)
                        {
                            this.mPanel.generalRecovering.visible = false;
                            this.mPanel.generalStatusPanel.visible = false;
                            this.mPanel.generalBusyAnim.visible = false;
                        };
                };
                this.mPanel.skillTreeBtn.enabled = false;
            }
            else
            {
                this.mPanel.busy = this.mSpecialist.GetWaitingForServer();
                this.mPanel.progressVisible = false;
                this.mPanel.skillTreeBtn.enabled = true;
                if (this.mPanel.currentState == "Admiral")
                {
                    this.mPanel.admiralRecovering.visible = false;
                    this.mPanel.admiralStatusPanel.visible = false;
                    this.mPanel.admiralBusyAnim.visible = this.mSpecialist.GetWaitingForServer();
                }
                else
                {
                    if (this.mPanel.currentState == "General")
                    {
                        this.mPanel.btnStartTravel.enabled = this.GetGeneralTravelButtonEnabledState();
                        this.mPanel.generalRecovering.visible = false;
                        this.mPanel.generalStatusPanel.visible = false;
                        this.mPanel.generalBusyAnim.visible = this.mSpecialist.GetWaitingForServer();
                    };
                };
            };
        }

        private function cancelName(_arg_1:MouseEvent):void
        {
            this.mPanel.nameInput.visible = false;
        }

        private function SelectExplorerTask(_arg_1:MouseEvent):void
        {
            var _local_6:Vector.<dResource>;
            var _local_2:StandardButton = (_arg_1.currentTarget as StandardButton);
            var _local_3:int;
            this.removeAllCosts();
            switch (_arg_1.currentTarget)
            {
                case this.mPanel.btnExploreSector:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.EXPLORE, "Sector");
                    break;
                case this.mPanel.btnExploreIsland:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.EXPLORE, "Island");
                    break;
                case this.mPanel.btnFindTreasureShort:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_TREASURE, "Short");
                    break;
                case this.mPanel.btnFindTreasureMedium:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_TREASURE, "Medium");
                    break;
                case this.mPanel.btnFindTreasureLong:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_TREASURE, "Long");
                    break;
                case this.mPanel.btnFindTreasureEvenLonger:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_TREASURE, "EvenLonger");
                    break;
                case this.mPanel.btnFindTreasureProlonged:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_TREASURE, "Prolonged");
                    break;
                case this.mPanel.btnFindTreasureTravellingErudite:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_TREASURE, "TravellingErudite");
                    break;
                case this.mPanel.btnFindTreasureBeanACollada:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_TREASURE, "BeanACollada");
                    break;
                case this.mPanel.btnFindAdventureZoneShort:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE, "Short");
                    break;
                case this.mPanel.btnFindAdventureZoneMedium:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE, "Medium");
                    break;
                case this.mPanel.btnFindAdventureZoneLong:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE, "Long");
                    break;
                case this.mPanel.btnFindAdventureZoneVeryLong:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE, "VeryLong");
                    break;
                case this.mPanel.btnFindExpeditionGenerated:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_EXPEDITION, "Generated");
                    break;
                case this.mPanel.btnFindExpeditionPvPSmall:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_EXPEDITION, "PvPSmall");
                    _local_3 = this.calculateSkillsOnTaskDuration(this.mSpecialist.skills.getItems_vector(), global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER].subtasks_vector[0].duration, SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER_string);
                    break;
                case this.mPanel.btnFindExpeditionPvPMedium:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_EXPEDITION, "PvPMedium");
                    _local_3 = this.calculateSkillsOnTaskDuration(this.mSpecialist.skills.getItems_vector(), global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER].subtasks_vector[0].duration, SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER_string);
                    break;
                case this.mPanel.btnFindExpeditionPvPBig:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_EXPEDITION, "PvPBig");
                    _local_3 = this.calculateSkillsOnTaskDuration(this.mSpecialist.skills.getItems_vector(), global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER].subtasks_vector[0].duration, SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER_string);
                    break;
                case this.mPanel.btnFindExpeditionPvE:
                    this.selectSubTask(SPECIALIST_TASK_TYPES.FIND_EXPEDITION, "PvE");
                    _local_3 = this.calculateSkillsOnTaskDuration(this.mSpecialist.skills.getItems_vector(), global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER].subtasks_vector[0].duration, SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER_string);
                    break;
                default:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Could not interpret currentTarget: " + _arg_1.currentTarget));
                    };
                    return;
            };
            this.ToggleExplorerButtons(_arg_1);
            this.mPanel.taskDuration = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TaskDuration", [this.getTaskDurationText((_local_2.data as Vector.<cSkill>))]);
            this.mPanel.taskExpRecovery.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "TaskRecovery", [cLocaManager.GetInstance().FormatDuration(_local_3)]);
            var _local_4:* = "#FFFFFF";
            if (((!(((global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.EXPEDITION_RECOVER].subtasks_vector[0].duration * this.mSpecialist.GetSpecialistDescription().GetTimeBonus()) * 100) == _local_3)) && (!(_local_3 == 0))))
            {
                _local_4 = "#FFEF00";
            };
            this.mPanel.taskExpRecovery.setStyle("color", _local_4);
            var _local_5:Vector.<dResource> = this.mSelectedSubTaskDefinition.costs;
            if (_local_5.length > 0)
            {
                _local_6 = this.getRealCosts(_local_5, (_local_2.data as Vector.<cSkill>));
                this.mPanel.resourceHolder.addChildAt(this.createCostsList(_local_6), 0);
                this.mPanel.btnOK.enabled = this.mGI.mCurrentPlayerZone.GetResourcesForPlayerID(this.mGI.mCurrentPlayer.GetPlayerId()).HasPlayerResourcesInListOne(_local_6);
            }
            else
            {
                this.mPanel.btnOK.enabled = true;
            };
        }

        private function ChangedUnitItemList(_arg_1:FlexEvent):void
        {
            gHintManager.TryRemainingHints();
        }

        private function SetCurrentAssignedUnits(_arg_1:MouseEvent=null):void
        {
            this.AssignUnits(((this.mSpecialist.GetArmy().GetUnitsCount() > 0) ? this.mSpecialist.GetArmy().HasEliteUnits() : this.usingElite));
        }

        private function titleHtmlTextChanged(_arg_1:Event):void
        {
            this.mPanel.title.validateDisplayList();
        }

        private function ReturnToStarHandler(_arg_1:MouseEvent):void
        {
            CustomAlert.show("ReturnToStar", "ReturnToStar", (Alert.OK | Alert.CANCEL), null, this.ReturnToStar, null, Alert.OK);
        }

        private function calculateSkillsOnTaskDuration(_arg_1:Vector.<cSkill>, _arg_2:Number, _arg_3:String):Number
        {
            var _local_4:cSkill;
            var _local_5:ModifierVO;
            for each (_local_4 in _arg_1)
            {
                for each (_local_5 in _local_4.getDefinition().level_vector[(_local_4.getLevel() - 1)])
                {
                    if ((((_local_5.type_string.length == 0) || (_local_5.type_string == _arg_3)) && (_local_5.modifier_string.toLowerCase() == "searchtime")))
                    {
                        if (_local_5.value != 0)
                        {
                            _arg_2 = _local_5.value;
                        };
                        _arg_2 = ((_arg_2 * _local_5.multiplier) + _local_5.adder);
                    };
                };
            };
            return ((_arg_2 / this.mSpecialist.GetSpecialistDescription().GetTimeBonus()) * 100);
        }

        public function Init(_arg_1:SpecialistPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        override protected function HideWithoutQueue():void
        {
            gHintManager.HideHintsForParent(this.mPanel.manageArmyList, false);
            gHintManager.HideHintsForParent(this.mPanel.admiralUnitManager, false);
            gHintManager.HideHintsForParent(this.mPanel, true);
            switch (this.mSpecialist.GetBaseType())
            {
                case SPECIALIST_TYPE.EXPLORER:
                    this.ToggleExplorerButtons();
                    break;
                case SPECIALIST_TYPE.GEOLOGIST:
                    this.ToggleGeologistButtons();
                    break;
            };
            this.removeLandmark();
            super.HideWithoutQueue();
        }

        private function acceptName(_arg_1:MouseEvent):void
        {
            this.changeName(this.mPanel.nameInput.text);
        }

        private function editName(_arg_1:MouseEvent):void
        {
            this.mPanel.nameInput.text = this.mSpecialist.getName(true);
            this.mPanel.nameInput.visible = true;
            this.mPanel.nameInput.setFocus();
        }

        private function Retreat(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            if (((this.mSpecialist.GetTask()) && ((this.mSpecialist.GetTask() is cSpecialistTask_AttackBuilding) || (this.mSpecialist.GetTask() is cSpecialistTask_AttackBuildingNewCombat))))
            {
                _local_2 = -1;
                if ((this.mSpecialist.GetTask() is cSpecialistTask_AttackBuilding))
                {
                    _local_2 = (this.mSpecialist.GetTask() as cSpecialistTask_AttackBuilding).GetArmyDestinationGridIdx();
                    this.mGI.mCurrentPlayerZone.mStreetDataMap.mLandmarkContainer.remove(_local_2);
                    (this.mSpecialist.GetTask() as cSpecialistTask_AttackBuilding).Retreat();
                }
                else
                {
                    _local_2 = (this.mSpecialist.GetTask() as cSpecialistTask_AttackBuildingNewCombat).GetArmyDestinationGridIdx();
                    this.mGI.mCurrentPlayerZone.mStreetDataMap.mLandmarkContainer.remove(_local_2);
                    (this.mSpecialist.GetTask() as cSpecialistTask_AttackBuildingNewCombat).Retreat();
                };
            };
            this.Hide();
        }

        private function CreateGeneralTooltip(_arg_1:ToolTipEvent):void
        {
            cToolTipUtil.createToolTip(cToolTipUtil.MILITARY_UNIT_GENERAL_string, _arg_1, this.mSpecialist);
        }

        private function AssignUnits(_arg_1:Boolean):void
        {
            var _local_5:cMilitaryUnitDescription;
            var _local_6:Object;
            var _local_7:cSquad;
            this.usingElite = _arg_1;
            this.mPanel.btnCommitArmyChanges.enabled = false;
            this.mPanel.btnResetArmyChanges.enabled = false;
            var _local_2:Vector.<cSquad> = this.mGI.mCurrentPlayerZone.GetArmy(this.mGI.mCurrentPlayer.GetPlayerId()).GetSquads_vector();
            var _local_3:Array = [];
            var _local_4:int;
            for each (_local_5 in cMilitaryUnitDescription.GetAllUnitDescriptions(true))
            {
                if (this.usingElite == _local_5.GetIsElite())
                {
                    _local_6 = {};
                    _local_6.name_string = _local_5.GetType();
                    _local_6.current = 0;
                    _local_6.available = 0;
                    _local_6.maximum = 0;
                    _local_6.enabled = (this.mSpecialist.GetTask() == null);
                    _local_6.id = _local_5.GetId();
                    _local_6.general = this.mSpecialist;
                    for each (_local_7 in _local_2)
                    {
                        if (_local_7.GetType() == _local_6.name_string)
                        {
                            _local_6.available = (_local_6.available + _local_7.GetAmount());
                        };
                    };
                    _local_4 = 0;
                    for each (_local_7 in this.mSpecialist.GetArmy().GetSquads_vector())
                    {
                        if (_local_7.GetType() == _local_6.name_string)
                        {
                            _local_6.current = (_local_6.current + _local_7.GetAmount());
                        };
                        _local_4 = (_local_4 + _local_6.current);
                    };
                    _local_6.available = (_local_6.available + _local_6.current);
                    _local_6.maximum = _local_6.available;
                    if (_local_6.maximum > this.mSpecialist.GetMaxMilitaryUnits())
                    {
                        _local_6.maximum = ((_local_6.current > this.mSpecialist.GetMaxMilitaryUnits()) ? _local_6.current : this.mSpecialist.GetMaxMilitaryUnits());
                    };
                    _local_3.push(_local_6);
                };
            };
            this.mPreviousUnitsAmount = _local_4;
            this.mPanel.manageArmyList.dataProvider = _local_3;
            this.UpdateUnitsAmounts(null);
        }

        private function EnterExplorerState(_arg_1:FlexEvent):void
        {
            var _local_2:String;
            var _local_3:dRequirementsVO;
            this.removeAllCosts();
            this.mPanel.taskDuration = "";
            this.mPanel.taskExpRecovery.text = "";
            this.mPanel.btnOK.enabled = false;
            this.mPanel.skillTreeBtn.enabled = true;
            this.mPanel.subContentExplorerBase.visible = true;
            this.mPanel.subContentExplore.visible = false;
            this.mPanel.subContentFindAdventure.visible = false;
            this.mPanel.subContentFindTreasure.visible = false;
            this.mPanel.subContentFindExpedition.visible = false;
            var _local_4:ArrayCollection = new ArrayCollection();
            _local_3 = this.mGI.mRequirements.specialistTaskRequirements_vector["ExploreSector"];
            this.mPanel.btnExplore.enabled = _local_3.isFulfilledForSkillList(this.mSpecialist.getSkillTree());
            if (this.mPanel.btnExplore.enabled)
            {
                _local_2 = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "Explore");
            }
            else
            {
                _local_2 = _local_3.locaString;
            };
            GUIDecorator.setToolTip(this.mPanel.btnExplore, cToolTipUtil.SIMPLE_ERROR_string, _local_2, (!(this.mPanel.btnExplore.enabled)));
            _local_3 = this.mGI.mRequirements.specialistTaskRequirements_vector["FindTreasureShort"];
            this.mPanel.btnFindTreasure.enabled = _local_3.isFulfilledForSkillList(this.mSpecialist.getSkillTree());
            if (this.mPanel.btnFindTreasure.enabled)
            {
                _local_2 = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "FindTreasure");
            }
            else
            {
                _local_2 = _local_3.locaString;
            };
            GUIDecorator.setToolTip(this.mPanel.btnFindTreasure, cToolTipUtil.SIMPLE_ERROR_string, _local_2, (!(this.mPanel.btnFindTreasure.enabled)));
            _local_3 = this.mGI.mRequirements.specialistTaskRequirements_vector["FindAdventureZoneShort"];
            this.mPanel.btnFindAdventureZone.enabled = ((_local_3.isFulfilledForSkillList(this.mSpecialist.getSkillTree())) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.ADVENTURE_SEARCH)));
            if (this.mPanel.btnFindAdventureZone.enabled)
            {
                _local_2 = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "FindAdventure");
            }
            else
            {
                _local_2 = _local_3.locaString;
            };
            GUIDecorator.setToolTip(this.mPanel.btnFindAdventureZone, cToolTipUtil.SIMPLE_ERROR_string, _local_2, (!(this.mPanel.btnFindAdventureZone.enabled)));
            _local_3 = this.mGI.mRequirements.specialistTaskRequirements_vector["FindExpeditionGenerated"];
            this.mPanel.btnFindExpedition.enabled = ((_local_3.isFulfilledForSkillList(this.mSpecialist.getSkillTree())) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.PVP_COLONY_SEARCH)));
            if (this.mPanel.btnFindExpedition.enabled)
            {
                _local_2 = cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "FindExpedition");
            }
            else
            {
                _local_2 = _local_3.locaString;
            };
            GUIDecorator.setToolTip(this.mPanel.btnFindExpedition, cToolTipUtil.SIMPLE_ERROR_string, _local_2, (!(this.mPanel.btnFindExpedition.enabled)));
            this.setupTaskUI(global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.EXPLORE], this.SelectExplorerTask);
            this.setupTaskUI(global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.FIND_TREASURE], this.SelectExplorerTask);
            this.setupTaskUI(global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE], this.SelectExplorerTask, this.mGI.killswitch.isLocked(KILL_SWITCH.ADVENTURE_SEARCH));
            this.setupTaskUI(global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.FIND_EXPEDITION], this.SelectExplorerTask);
        }

        public function Refresh(_arg_1:cSpecialist):void
        {
            if (((!(_arg_1 == this.mSpecialist)) || (!(this.IsVisible()))))
            {
                return;
            };
            switch (this.mPanel.currentState)
            {
                case "General":
                case "TransporterGeneral":
                    this.EnterGeneralState(null);
                    return;
                case "Admiral":
                    this.EnterAdmiralState(null);
                    return;
                case "Geologist":
                    this.EnterGeologistState(null);
                    return;
                case "Explorer":
                    this.EnterExplorerState(null);
                    return;
            };
        }

        private function AttackBuilding(_arg_1:MouseEvent):void
        {
            this.mGI.mCurrentCursor.mCurrentSpecialist = this.mSpecialist;
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.ATTACK_BUILDING);
            this.Hide();
        }

        private function ToggleExplorerButtons(_arg_1:MouseEvent=null):void
        {
            var _local_2:Vector.<cSpecialistSubTaskDefinition> = global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.EXPLORE].subtasks_vector.concat(global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.FIND_ADVENTURE_ZONE].subtasks_vector, global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.FIND_EXPEDITION].subtasks_vector, global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.FIND_TREASURE].subtasks_vector);
            this.deselectButtons(_local_2);
            if (!_arg_1)
            {
                return;
            };
            (_arg_1.currentTarget as Button).selected = true;
            (this.mPanel[(("text" + this.mSelectedSubTaskDefinition.mainTask.taskName_string) + this.mSelectedSubTaskDefinition.taskType_string)] as Text).setStyle("color", 0xFFEF00);
        }

        private function ToggleGeologistButtons(_arg_1:MouseEvent=null):void
        {
            this.deselectButtons(global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.DEPOSIT_SEARCH].subtasks_vector);
            if (!_arg_1)
            {
                return;
            };
            (_arg_1.currentTarget as Button).selected = true;
            (this.mPanel[("textFindDeposit" + this.mSelectedSubTaskDefinition.taskType_string)] as Text).setStyle("color", "#FFEF00");
        }

        private function UpdateUnitsAmountsHelper(_arg_1:FlexEvent, _arg_2:int):void
        {
            var _local_3:Object;
            this.mPreviousUnitsAmount = _arg_2;
            if (((_arg_2 > this.mSpecialist.GetMaxMilitaryUnits()) && (!(_arg_1 == null))))
            {
                _local_3 = _arg_1.target.data;
                _local_3.current = (_local_3.current - (_arg_2 - this.mSpecialist.GetMaxMilitaryUnits()));
                _arg_1.target.data = _local_3;
            };
        }

        private function UpdateUnitsAmounts(_arg_1:FlexEvent):void
        {
            var _local_3:Object;
            var _local_2:int;
            for each (_local_3 in this.mPanel.manageArmyList.dataProvider)
            {
                _local_2 = (_local_2 + _local_3.current);
            };
            this.mPanel.manageUnitsAmountLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "UnitsAttached", [_local_2.toString(), this.mSpecialist.GetMaxMilitaryUnits().toString()]);
            this.mPanel.manageUnitsAmountLabel.setStyle("color", ((_local_2 > this.mSpecialist.GetMaxMilitaryUnits()) ? 0xFF0000 : 0xFFFFFF));
            this.mPanel.btnCommitArmyChanges.enabled = ((this.mPanel.btnCommitArmyChanges.enabled) || ((!(this.mPreviousUnitsAmount == _local_2)) && (_local_2 <= this.mSpecialist.GetMaxMilitaryUnits())));
            this.mPanel.btnResetArmyChanges.enabled = ((this.mPanel.btnResetArmyChanges.enabled) || (!(this.mPreviousUnitsAmount == _local_2)));
            this.mPanel.btnUnloadUnits.enabled = (!(_local_2 == 0));
            this.UpdateUnitsAmountsHelper(_arg_1, _local_2);
        }

        private function setupTaskUI(_arg_1:cSpecialistTaskDefinition, _arg_2:Function, _arg_3:Boolean=false):void
        {
            var _local_4:cSpecialistSubTaskDefinition;
            var _local_5:Vector.<ColonyVO>;
            var _local_6:String;
            var _local_7:dRequirementsVO;
            var _local_8:Modifieable;
            var _local_9:StandardButton;
            var _local_10:Image;
            var _local_11:Vector.<cSkill>;
            var _local_12:ArrayCollection;
            var _local_13:Vector.<cSkill>;
            var _local_14:cSkill;
            var _local_15:SkillToolTipData;
            var _local_16:String;
            var _local_17:String;
            var _local_18:CustomText;
            var _local_19:ModifierVO;
            for each (_local_4 in _arg_1.subtasks_vector)
            {
                _local_6 = (_arg_1.taskName_string + _local_4.taskType_string);
                _local_7 = this.mGI.mRequirements.specialistTaskRequirements_vector[_local_6];
                _local_8 = this.taskPrototypes[_local_6];
                _local_9 = (this.mPanel[("btn" + _local_6)] as StandardButton);
                if (_local_7 != null)
                {
                    _local_9.enabled = ((!(_arg_3)) && (_local_7.isFulfilledForSkillList(this.mSpecialist.getSkillTree())));
                }
                else
                {
                    _local_9.enabled = (!(_arg_3));
                };
                if (_arg_2 != null)
                {
                    _local_9.addEventListener(MouseEvent.CLICK, _arg_2);
                };
                _local_10 = (this.mPanel[("StarIcon" + _local_6)] as Image);
                _local_10.visible = false;
                _local_11 = new Vector.<cSkill>();
                _local_12 = new ArrayCollection();
                _local_13 = this.mSpecialist.getSkillTree().getItems_vector();
                _local_13 = _local_13.concat(this.mSpecialist.skills.getItems_vector());
                for each (_local_14 in _local_13)
                {
                    if (_local_14.getLevel() > 0)
                    {
                        for each (_local_19 in _local_14.getDefinition().level_vector[(_local_14.getLevel() - 1)])
                        {
                            if (((!(_local_8 == null)) && (_local_8.isModifierApplyable(_local_19))))
                            {
                                _local_11.push(_local_14);
                                _local_12.addItem(_local_14.getVO());
                                if (((this.mSpecialist.skills.getItems_vector().indexOf(_local_14) > -1) && (!(_local_14.isTrait()))))
                                {
                                    _local_10.visible = _local_9.visible;
                                };
                                break;
                            };
                        };
                    };
                };
                _local_15 = new SkillToolTipData();
                _local_15.resourceIcon = new ((_local_9.getStyle("icon") as Class))();
                _local_16 = null;
                _local_17 = cLocaManager.GetInstance().GetTextPure(LOCA_GROUP.TOOLTIP, (_local_6 + "Description"));
                if (_local_17 != null)
                {
                    _local_16 = _local_17;
                };
                if (!_local_9.enabled)
                {
                    _local_15.requirements = _local_7.locaString;
                };
                _local_15.additionalText = _local_16;
                _local_15.skills = _local_12;
                GUIDecorator.setToolTip(_local_9, cToolTipUtil.SKILL_LIST_string, _local_6, _local_15);
                GUIDecorator.setToolTipDelays(_local_9, 0, Infinity);
                _local_18 = (this.mPanel[("text" + _local_6)] as CustomText);
                if (_local_11.length > 0)
                {
                    _local_18.setStyle("color", "#FFD06A");
                    _local_18.setStyle("fontWeight", "bold");
                    (this.mPanel[("box" + _local_6)] as Canvas).setStyle("backgroundAlpha", 0.35);
                    _local_9.data = _local_11;
                }
                else
                {
                    _local_18.setStyle("color", "#FFFFFF");
                    _local_18.setStyle("fontWeight", "normal");
                    (this.mPanel[("box" + _local_6)] as Canvas).setStyle("backgroundAlpha", 0.1);
                    _local_9.data = null;
                };
            };
            _local_5 = global.ui.mCurrentPlayerZone.ColonyGetAll();
            if ((((!(this.mPanel.btnFindExpeditionPvPSmall == null)) && (!(this.mPanel.btnFindExpeditionPvPMedium == null))) && (!(this.mPanel.btnFindExpeditionPvPBig == null))))
            {
                if (((AdventureManager.getInstance().getStartedAdventuresCount() >= global.adventureMaximumOwner) || (!(AdventureManager.getInstance().getWaitingColonies() == null))))
                {
                    this.mPanel.btnFindExpeditionPvPSmall.enabled = (this.mPanel.btnFindExpeditionPvPMedium.enabled = (this.mPanel.btnFindExpeditionPvPBig.enabled = false));
                    GUIDecorator.setToolTip(this.mPanel.btnFindExpeditionPvPSmall, cToolTipUtil.SIMPLE_ERROR_string, cLocaManager.GetInstance().getLabel("AdventuresStartedLimitReachedShort"), true);
                    GUIDecorator.setToolTip(this.mPanel.btnFindExpeditionPvPMedium, cToolTipUtil.SIMPLE_ERROR_string, cLocaManager.GetInstance().getLabel("AdventuresStartedLimitReachedShort"), true);
                    GUIDecorator.setToolTip(this.mPanel.btnFindExpeditionPvPBig, cToolTipUtil.SIMPLE_ERROR_string, cLocaManager.GetInstance().getLabel("AdventuresStartedLimitReachedShort"), true);
                }
                else
                {
                    this.mPanel.btnFindExpeditionPvPSmall.enabled = (this.mPanel.btnFindExpeditionPvPMedium.enabled = (this.mPanel.btnFindExpeditionPvPBig.enabled = ((!(AdventureManager.getInstance().IsScoutingForPvP())) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.PVP_COLONY_SEARCH)))));
                };
            };
        }

        private function CommitArmyChangesAdmiral(_arg_1:MouseEvent):void
        {
            this.DisableAdmiralButtons();
            this.CommitArmyChangesHelper(this.mPanel.admiralUnitManager.GetUnitAllocation());
        }

        private function admiralUnitManagerModeToggleHandler(_arg_1:Event):void
        {
            _arg_1.stopPropagation();
            if (this.mPanel.admiralLeftColumn.visible)
            {
                this.mPanel.admiralLeftColumn.visible = false;
                this.mPanel.admiralRightColumn.setStyle("left", 31);
                this.mPanel.btnCommitArmyChangesAdmiral.enabled = false;
                this.mPanel.btnResetArmyChangesAdmiral.enabled = false;
            }
            else
            {
                this.mPanel.admiralLeftColumn.visible = true;
                this.mPanel.admiralRightColumn.setStyle("left", 215);
                this.mPanel.btnCommitArmyChangesAdmiral.enabled = true;
                this.mPanel.btnResetArmyChangesAdmiral.enabled = true;
            };
        }

        private function removeAllCosts():void
        {
            var _local_1:DisplayObject;
            for each (_local_1 in this.mPanel.resourceHolder.getChildren())
            {
                this.mPanel.resourceHolder.removeChild(_local_1);
            };
        }

        private function CommitArmyChangesHelper(_arg_1:Vector.<dSquadVO>):void
        {
            this.mPanel.busy = true;
            this.mSpecialist.SetWaitingForServer(true);
            cMilitaryUtil.SendRaiseArmyToServer(this.mGI, this.mSpecialist, _arg_1);
        }

        private function EnterAdmiralState(_arg_1:FlexEvent):void
        {
            var _local_3:int;
            this.EnterGeneralOrAdmiralStateHelper();
            this.mPanel.btnCommitArmyChangesAdmiral.addEventListener(MouseEvent.CLICK, this.CommitArmyChangesAdmiral);
            this.mPanel.btnResetArmyChangesAdmiral.addEventListener(MouseEvent.CLICK, this.ResetArmyChangesAdmiral);
            this.mPanel.btnAttackAdmiral.enabled = (((this.mSpecialist.HasUnits()) && (this.mSpecialist.GetTask() == null)) && (this.mGI.UsesCombatThree()));
            this.mPanel.btnAttackAdmiral.addEventListener(MouseEvent.CLICK, this.AttackBuilding);
            this.mPanel.btnTransferAdmiral.enabled = (this.mSpecialist.GetTask() == null);
            this.mPanel.btnTransferAdmiral.addEventListener(MouseEvent.CLICK, this.MoveGarisson);
            this.mPanel.btnRetreatAdmiral.enabled = ((this.CanRetreat()) && (this.mGI.UsesCombatThree()));
            this.mPanel.btnRetreatAdmiral.addEventListener(MouseEvent.CLICK, this.Retreat);
            this.mPanel.addEventListener(Combat3UnitManager.TOGGLE_MODE_EVENT, this.admiralUnitManagerModeToggleHandler);
            this.mPanel.btnAdmiralReturnToStar.addEventListener(MouseEvent.CLICK, this.ReturnToStarHandler);
            this.mPanel.addEventListener(Combat3UnitManager.ENABLE_COMMIT, this.enableCommit);
            this.mPanel.addEventListener(Combat3UnitManager.DISABLE_COMMIT, this.disableCommit);
            if (this.mSpecialist.GetWaitingForServer())
            {
                this.DisableAdmiralButtons();
            };
            this.mPanel.attackAdmiralButtonContainer.visible = (this.mPanel.attackAdmiralButtonContainer.includeInLayout = (this.mPanel.retreatAdmiralButtonContainer.visible = (this.mPanel.retreatAdmiralButtonContainer.includeInLayout = this.mSpecialist.GetSpecialistDescription().isCanAttack())));
            this.mPanel.admiralLeftColumn.visible = true;
            this.mPanel.admiralRightColumn.setStyle("left", 215);
            var _local_2:cArmy = this.mGI.mCurrentPlayerZone.GetArmy(this.mGI.mCurrentPlayer.GetPlayerId());
            this.mPanel.admiralUnitManager.SetData(this.mSpecialist, null, _local_2, 3, UNIT_COST_SOURCE.UNIT);
            this.mAdmiralTroops = new Array();
            if (this.mAdmiralTroops.length == 0)
            {
                _local_3 = 0;
                while (_local_3 < NUM_ADMIRAL_UNITS)
                {
                    this.mAdmiralTroops.push({
                        "position":_local_3,
                        "empty":true
                    });
                    _local_3++;
                };
            };
            this.mPanel.btnAdmiralReturnToStar.enabled = ((this.mGI.isOnHomzone()) && (this.mSpecialist.GetTask() == null));
            this.mPanel.admiralStatusPanel.visible = false;
            this.mPanel.admiralBusyAnim.visible = false;
            this.setGeneralState();
            this.mPanel.btnCommitArmyChangesAdmiral.enabled = false;
            this.mPanel.btnResetArmyChangesAdmiral.enabled = false;
            if (((!(this.mSpecialist.GetTask() == null)) && (this.mSpecialist.GetTask().GetType() == SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU)))
            {
                this.DisableAdmiralButtons();
            }
            else
            {
                this.mPanel.admiralUnitManager.visible = true;
            };
        }

        private function IsAdventureValid(_arg_1:dAdventureClientInfoVO):Boolean
        {
            if (this.mSpecialist.GetTask() != null)
            {
                return (false);
            };
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName);
            if (((this.mSpecialist.GetArmy().HasEliteUnits()) && (!(_local_2.UseElite()))))
            {
                return (false);
            };
            if (_arg_1.IsColony())
            {
                return (false);
            };
            return (true);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.close.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.editcontrol.editButton.addEventListener(MouseEvent.CLICK, this.editName);
            this.mPanel.editcontrol.cancelButton.addEventListener(MouseEvent.CLICK, this.cancelName);
            this.mPanel.editcontrol.acceptButton.addEventListener(MouseEvent.CLICK, this.acceptName);
            this.mPanel.nameInput.addEventListener(KeyboardEvent.KEY_UP, this.nameInputKeyUp);
            this.mPanel.stateGeologist.addEventListener(FlexEvent.ENTER_STATE, this.EnterGeologistState);
            this.mPanel.stateExplorer.addEventListener(FlexEvent.ENTER_STATE, this.EnterExplorerState);
            this.mPanel.stateGeneral.addEventListener(FlexEvent.ENTER_STATE, this.EnterGeneralState);
            this.mPanel.stateAdmiral.addEventListener(FlexEvent.ENTER_STATE, this.EnterAdmiralState);
            this.mPanel.skillTreeBtn.addEventListener(MouseEvent.CLICK, this.openSkillTree);
            this.mPanel.title.addEventListener("htmlTextChanged", this.titleHtmlTextChanged);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.StartTask);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mGI.killswitch.addPropertyObserver(KILL_SWITCH.PVP_COLONY_SEARCH, this);
        }

        private function GetGeneralTravelButtonEnabledState():Boolean
        {
            var _local_2:dAdventureClientInfoVO;
            var _local_1:Boolean;
            for each (_local_2 in AdventureManager.getInstance().getTravelableAdventures())
            {
                if (this.IsAdventureValid(_local_2))
                {
                    _local_1 = true;
                };
            };
            if (!_local_1)
            {
                return (false);
            };
            return (true);
        }

        protected function disableCommit(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
            this.mPanel.btnResetArmyChangesAdmiral.enabled = false;
            this.mPanel.btnCommitArmyChangesAdmiral.enabled = false;
            this.mPanel.btnAttackAdmiral.enabled = true;
            this.mPanel.btnTransferAdmiral.enabled = true;
        }

        private function selectSubTask(_arg_1:int, _arg_2:String):void
        {
            var _local_3:cSpecialistSubTaskDefinition;
            for each (_local_3 in global.specialistTaskDefinitions_vector[_arg_1].subtasks_vector)
            {
                if (_local_3.taskType_string == _arg_2)
                {
                    this.mSelectedSubTaskDefinition = _local_3;
                    break;
                };
            };
        }

        private function EnterGeologistState(_arg_1:FlexEvent):void
        {
            this.removeAllCosts();
            this.mPanel.taskDuration = "";
            this.mPanel.btnOK.enabled = false;
            this.mPanel.skillTreeBtn.enabled = true;
            this.setupTaskUI(global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.DEPOSIT_SEARCH], this.SelectDeposit);
            gHintManager.TryRemainingHints();
        }

        private function DisableAdmiralButtons():void
        {
            this.mPanel.btnAttackAdmiral.enabled = false;
            this.mPanel.btnRetreatAdmiral.enabled = false;
            this.mPanel.btnTransferAdmiral.enabled = false;
            this.mPanel.btnCommitArmyChangesAdmiral.enabled = false;
            this.mPanel.btnResetArmyChangesAdmiral.enabled = false;
            this.mPanel.admiralUnitManager.visible = false;
            this.mPanel.skillTreeBtn.enabled = false;
        }

        private function changeName(_arg_1:String):void
        {
            this.mPanel.nameInput.text = "";
            this.mPanel.editcontrol.normalState(null);
            this.mPanel.nameInput.visible = false;
            if (_arg_1.indexOf("<") >= 0)
            {
                return;
            };
            this.oldNameTmpString = this.mSpecialist.getName(true);
            this.mSpecialist.setName(_arg_1);
            this.mPanel.title.htmlText = this.mSpecialist.getName(false);
            this.mPanel.title.validateDisplayList();
            this.mPanel.nameInput.text = "";
            this.mPanel.editcontrol.normalState(null);
            var _local_2:ChangeNameVO = new ChangeNameVO();
            _local_2.name = _arg_1;
            _local_2.uniqueID = this.mSpecialist.GetUniqueID();
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.CHANGE_SPECIALIST_NAME, this.mGI.mCurrentViewedZoneID, _local_2, this);
        }

        private function GetCurrentTaskText():String
        {
            var _local_3:cSpecialistSubTaskDefinition;
            var _local_1:* = "";
            var _local_2:cSpecialistTask = this.mSpecialist.GetTask();
            if (_local_2 != null)
            {
                _local_3 = global.specialistTaskDefinitions_vector[_local_2.GetType()].subtasks_vector[_local_2.GetSubType()];
                _local_1 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, ("SpecialistTask" + _local_3.mainTask.taskName_string), [_local_3.taskType_string]);
            }
            else
            {
                _local_1 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "SpecialistTaskNone");
            };
            return (_local_1);
        }

        private function ReturnToStar(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            this.mGI.mCurrentCursor.mCurrentSpecialist = this.mSpecialist;
            var _local_2:dStartSpecialistTaskVO = new dStartSpecialistTaskVO();
            _local_2.uniqueID = this.mSpecialist.GetUniqueID();
            global.ui.SendServerAction(COMMAND.SET_TASK, SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU, this.mGI.mCurrentCursor.GetGridPosition(), 0, _local_2);
            this.mSpecialist.SetTask(new cSpecialistTask_WaitForConfirmation(this.mGI, this.mSpecialist, 0, SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU));
            if (this.mPanel.btnAttack != null)
            {
                this.DisableGeneralButtons();
            };
            if (this.mPanel.btnAttackAdmiral != null)
            {
                this.DisableAdmiralButtons();
            };
            this.Hide();
            global.getApplication().inputNotifier.notifyClick("ReturnToStarClick");
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if ((((this.mPanel.btnFindExpeditionPvPSmall) && (this.mPanel.btnFindExpeditionPvPMedium)) && (this.mPanel.btnFindExpeditionPvPBig)))
            {
                this.mPanel.btnFindExpeditionPvPSmall.enabled = (this.mPanel.btnFindExpeditionPvPMedium.enabled = (this.mPanel.btnFindExpeditionPvPBig.enabled = ((!(AdventureManager.getInstance().IsScoutingForPvP())) && (this.mGI.killswitch.isAccessible(KILL_SWITCH.PVP_COLONY_SEARCH)))));
            };
        }

        private function SwitchEliteTroops(_arg_1:MouseEvent):void
        {
            this.AssignUnits((!(this.usingElite)));
            this.CommitArmyChanges(null);
            this.mPanel.switchToNewUnits = (!(this.usingElite));
        }

        private function MoveGarisson(_arg_1:MouseEvent):void
        {
            this.mPanel.visible = false;
            this.mGI.mCurrentCursor.mCurrentSpecialist = this.mSpecialist;
            this.mGI.SelectBuilding(this.mSpecialist.GetGarrison());
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.MOVE_GARISSON);
            this.Hide();
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen("MoveGarrison");
            global.getApplication().inputNotifier.notifyClick("MoveGarrison");
        }

        private function SelectDeposit(_arg_1:MouseEvent):void
        {
            var _local_2:StandardButton = (_arg_1.currentTarget as StandardButton);
            var _local_3:String = _local_2.id.substr(14);
            this.selectSubTask(SPECIALIST_TASK_TYPES.DEPOSIT_SEARCH, _local_3);
            this.ToggleGeologistButtons(_arg_1);
            this.mPanel.taskDuration = this.getTaskDurationText((_local_2.data as Vector.<cSkill>));
            this.mPanel.btnOK.enabled = true;
        }

        protected function openSkillTree(_arg_1:MouseEvent):void
        {
            Hide();
            globalFlash.gui.mSkillTreeWindow.SetData(this.mSpecialist.getSkillTree());
            globalFlash.gui.mSkillTreeWindow.Show();
        }

        private function StartTask(_arg_1:MouseEvent):void
        {
            ServiceManager.getInstance().specialist.startTask(this.mSpecialist, this.mSelectedSubTaskDefinition);
            this.Hide();
        }

        private function StartTravelToAdventureHandler(_arg_1:MouseEvent):void
        {
            var _local_2:FriendsListMenuItemRenderer = ((_arg_1.target is FriendsListMenuItemRenderer) ? (_arg_1.target as FriendsListMenuItemRenderer) : ((_arg_1.target as UITextField).parent.parent as FriendsListMenuItemRenderer));
            var _local_3:int = _local_2.parent.getChildIndex(_local_2);
            global.services.specialist.sendToZone(this.mSpecialist, AdventureManager.getInstance().getAdventures()[_local_3].zoneID);
            this.ClosePanel(null);
        }

        public function onResult(_arg_1:int, _arg_2:dServerActionResult):void
        {
            if (_arg_1 == COMMAND.CHANGE_SPECIALIST_NAME)
            {
            };
        }

        private function EnterGeneralState(_arg_1:FlexEvent):void
        {
            this.EnterGeneralOrAdmiralStateHelper();
            this.mPanel.iconPlaceholder.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, this.CreateGeneralTooltip);
            this.mPanel.btnCommitArmyChanges.addEventListener(MouseEvent.CLICK, this.CommitArmyChanges);
            this.mPanel.btnResetArmyChanges.addEventListener(MouseEvent.CLICK, this.SetCurrentAssignedUnits);
            this.mPanel.btnUnloadUnits.addEventListener(MouseEvent.CLICK, this.ClearCurrentAssignedUnits);
            this.mPanel.manageArmyList.addEventListener(FlexEvent.DATA_CHANGE, this.UpdateUnitsAmounts);
            this.mPanel.manageArmyList.addEventListener(FlexEvent.UPDATE_COMPLETE, this.ChangedUnitItemList);
            this.mPanel.btnAttack.enabled = (((this.mSpecialist.HasUnits()) && (this.mSpecialist.GetTask() == null)) && (!(this.mGI.UsesCombatThree())));
            this.mPanel.btnAttack.addEventListener(MouseEvent.CLICK, this.AttackBuilding);
            this.mPanel.btnPreCombat.enabled = (((this.mSpecialist.HasUnits()) && (this.mSpecialist.GetTask() == null)) && (!(this.mGI.UsesCombatThree())));
            this.mPanel.btnPreCombat.addEventListener(MouseEvent.CLICK, this.PreCombatCheck);
            this.mPanel.btnTransfer.enabled = ((this.mSpecialist.GetTask() == null) && (!(this.mGI.UsesCombatThree())));
            this.mPanel.btnTransfer.addEventListener(MouseEvent.CLICK, this.MoveGarisson);
            this.mPanel.btnGeneralReturnToStar.addEventListener(MouseEvent.CLICK, this.ReturnToStarHandler);
            this.mPanel.btnRetreat.enabled = ((this.CanRetreat()) && (!(this.mGI.UsesCombatThree())));
            this.mPanel.btnRetreat.addEventListener(MouseEvent.CLICK, this.Retreat);
            this.mPanel.btnSwitch.enabled = ((this.mGI.mRequirements.miscRequirements_vector["GarrisonSwitchButton"].isFulfilled()) && (this.mSpecialist.GetTask() == null));
            this.mPanel.btnSwitch.addEventListener(MouseEvent.CLICK, this.SwitchEliteTroops);
            this.mPanel.btnStartTravel.enabled = this.GetGeneralTravelButtonEnabledState();
            this.mPanel.btnStartTravel.addEventListener(MouseEvent.CLICK, this.StartTravelHandler);
            var _local_2:String = ((this.mPanel.btnSwitch.enabled) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.TOOLTIP, "GarrisonSwitch") : this.mGI.mRequirements.miscRequirements_vector["GarrisonSwitchButton"].locaString);
            GUIDecorator.setToolTip(this.mPanel.btnSwitch, cToolTipUtil.SIMPLE_ERROR_string, _local_2, (!(this.mPanel.btnSwitch.enabled)));
            this.mPanel.progressVisible = this.mSpecialist.DisplayTaskProgress();
            this.mPanel.attackButtonContainer.visible = (this.mPanel.attackButtonContainer.includeInLayout = (this.mPanel.precombatButtonContainer.visible = (this.mPanel.precombatButtonContainer.includeInLayout = (this.mPanel.retreatButtonContainer.visible = (this.mPanel.retreatButtonContainer.includeInLayout = this.mSpecialist.GetSpecialistDescription().isCanAttack())))));
            this.mPanel.generalRecovering.visible = false;
            this.mPanel.generalStatusPanel.visible = false;
            this.mPanel.generalBusyAnim.visible = false;
            this.mPanel.btnGeneralReturnToStar.enabled = (this.mSpecialist.GetTask() == null);
            this.SetCurrentAssignedUnits();
            this.setGeneralState();
            if (((!(this.mSpecialist.GetTask() == null)) && (this.mSpecialist.GetTask().GetType() == SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU)))
            {
                this.DisableGeneralButtons();
            };
        }

        private function PreCombatCheck(_arg_1:MouseEvent):void
        {
            this.mGI.mCurrentCursor.mCurrentSpecialist = this.mSpecialist;
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.GET_COMBAT_PREVIEW);
            this.Hide();
        }

        public function getTaskPrototypes():Dictionary
        {
            return (this.taskPrototypes);
        }

        private function CanRetreat():Boolean
        {
            var _local_2:int;
            var _local_1:Boolean;
            if ((((!(this.mSpecialist.GetWaitingForServer())) && (!(this.mSpecialist.GetTask() == null))) && ((this.mSpecialist.GetTask() is cSpecialistTask_AttackBuilding) || (this.mSpecialist.GetTask() is cSpecialistTask_AttackBuildingNewCombat))))
            {
                _local_2 = -1;
                if ((this.mSpecialist.GetTask() is cSpecialistTask_AttackBuilding))
                {
                    _local_2 = (this.mSpecialist.GetTask() as cSpecialistTask_AttackBuilding).GetTaskPhase();
                }
                else
                {
                    _local_2 = (this.mSpecialist.GetTask() as cSpecialistTask_AttackBuildingNewCombat).GetTaskPhase();
                };
                if (((_local_2 == TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET) || (_local_2 == TASK_PHASES_ATTACK_BUILDING.WAIT_AT_TARGET)))
                {
                    _local_1 = true;
                };
            };
            return (_local_1);
        }

        private function DisableGeneralButtons():void
        {
            this.mPanel.btnAttack.enabled = false;
            this.mPanel.btnPreCombat.enabled = false;
            this.mPanel.btnRetreat.enabled = false;
            this.mPanel.btnTransfer.enabled = false;
            this.mPanel.btnCommitArmyChanges.enabled = false;
            this.mPanel.btnResetArmyChanges.enabled = false;
            this.mPanel.btnUnloadUnits.enabled = false;
            this.mPanel.btnSwitch.enabled = false;
            this.mPanel.skillTreeBtn.enabled = false;
            this.mPanel.btnStartTravel.enabled = false;
        }

        private function EnterGeneralOrAdmiralStateHelper():void
        {
            var _local_1:cBuilding;
            if (((!(this.mSpecialist.GetTask() == null)) && ((this.mSpecialist.GetTask() is cSpecialistTask_AttackBuilding) || (this.mSpecialist.GetTask() is cSpecialistTask_AttackBuildingNewCombat))))
            {
                _local_1 = null;
                if ((this.mSpecialist.GetTask() is cSpecialistTask_AttackBuilding))
                {
                    _local_1 = (this.mSpecialist.GetTask() as cSpecialistTask_AttackBuilding).GetArmyDestination();
                }
                else
                {
                    _local_1 = (this.mSpecialist.GetTask() as cSpecialistTask_AttackBuildingNewCombat).GetArmyDestination();
                };
                if (_local_1 != null)
                {
                    _local_1.renderAttackCursor = true;
                    this.mMarkedBuilding = _local_1;
                };
            };
            this.mPanel.busy = this.mSpecialist.GetWaitingForServer();
            if (this.mSpecialist.GetTask())
            {
                this.mPanel.progressProxy.progress = this.mSpecialist.GetTaskProgress();
            };
        }


    }
}
