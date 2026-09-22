package Specialists
{
    import Model.Notifier;
    import MilitarySystem.iMilitaryUnitHolder;
    import Skill.Skilled;
    import Model.Observer;
    import Utils.Disposable;
    import Modifier.Modifieable;
    import Interface.cGeneralInterface;
    import Skill.cSkillList;
    import Skill.cSkillTree;
    import MilitarySystem.cArmy;
    import Communication.VO.dUniqueID;
    import GO.cBuilding;
    import Enums.DIRTY_INDICATOR;
    import ServerState.cResources;
    import Enums.COMMAND;
    import __AS3__.vec.Vector;
    import ServerState.dResource;
    import nLib.cXML;
    import Communication.VO.Skill.SkillVO;
    import Enums.SPECIALIST_TYPE;
    import Communication.VO.dSpecialistVO;
    import Communication.VO.dSquadVO;
    import Enums.CHANNELS;
    import Model.Notifiers.SpecialistNotifier;
    import nLib.gMisc;
    import MilitarySystem.cSquad;
    import Communication.VO.dSpecialistTaskVO;
    import Skill.cSkill;
    import Modifier.ModifierVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import mx.events.PropertyChangeEvent;
    import Modifier.Modifier;
    import mx.collections.ArrayCollection;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.ARMY_OWNER_TYPE;
    import Skill.SkillTreeDefinition;
    import Enums.SKILL_OWNER;
    import Enums.GENERAL_STATE_SPRITE;
    import Enums.TASK_PHASES_ATTACK_BUILDING;
    import Enums.TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT;
    import nLib.cLog;
    import __AS3__.vec.*;

    public class cSpecialist extends Notifier implements iMilitaryUnitHolder, Skilled, Observer, Disposable, Modifieable 
    {

        public static const SLOT_STATE_INVALID:int = -1;
        public static const SLOT_STATE_FREE:int = 0;
        public static const SLOT_STATE_OCCUPIED:int = 1;
        public static const SLOT_STATE_WAIT_FOR_SERVER:int = 2;
        private static var map_SpecialistType_SpecialistDescription:Object = new Object();
        private static var map_SpecialistType_CostList:Object = new Object();

        private const TIMEOUT:int = 30000;

        private var gi:cGeneralInterface;
        private var _103263122mTask:cSpecialistTask;
        private var mBattlesWon:int = 0;
        public var mDirtyIndicator:int;
        private var mUnitsDefeated:int = 0;
        public var skills:cSkillList;
        private var mLastServerCall:int = 0;
        private var mXp:int;
        private var mPlayerID:int;
        private var _58515489mTaskProgress:Number = 0;
        private var mUnitCapacityModifier:int = 0;
        private var mTimeBonus:int = 0;
        public var insertedAt:uint;
        private var mWaitingForServerResponse:Boolean = false;
        private var skillTree:cSkillTree;
        private var mZoneID:int;
        private var mName_string:String;
        private var army:cArmy;
        private var mSpecialistDescription:cSpecialistDescription;
        private var uniqueID:dUniqueID;
        private var mGarrison:cBuilding = null;
        private var mFaceType:int;
        private var mGarrisonGridIdx:int = -1;
        private var modified:Boolean = false;
        private var mDiceBonus:int = 0;
        private var currentHitPoints:int;
        private var mBuildingsDestroyed:int = 0;
        private var mXpProduced:int = 0;
        private var mRetreatThreshold:int = 0;

        public function cSpecialist(_arg_1:Boolean)
        {
            super();
            if (_arg_1)
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
        }

        public static function BuySpecialist(_arg_1:int, _arg_2:cGeneralInterface):void
        {
            var _local_3:cResources = _arg_2.mCurrentPlayerZone.GetResources(_arg_2.mCurrentPlayer);
            if (!_local_3.HasPlayerResourcesInListOne(GetCostsToBuy_vector(_arg_1, _arg_2.mCurrentPlayer.GetSpecialistAmount(_arg_1))))
            {
                return;
            };
            _arg_2.SendServerAction(COMMAND.BUY_SPECIALIST, _arg_1, 0, 0, 0);
        }

        public static function GetCostsToBuy_vector(_arg_1:int, _arg_2:int):Vector.<dResource>
        {
            if (map_SpecialistType_CostList[_arg_1].length > _arg_2)
            {
                return (map_SpecialistType_CostList[_arg_1][_arg_2]);
            };
            return (null);
        }

        public static function InitData(_arg_1:cXML):void
        {
            var _local_3:cXML;
            var _local_4:cSpecialistDescription;
            var _local_5:Vector.<cXML>;
            var _local_6:Vector.<Vector.<dResource>>;
            var _local_7:Vector.<SkillVO>;
            var _local_8:cXML;
            var _local_9:Vector.<dResource>;
            var _local_10:cXML;
            var _local_11:SkillVO;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_3 in _local_2)
            {
                _local_4 = new cSpecialistDescription();
                _local_4.setType(_local_3.GetAttributeInt("type"));
                _local_4.setBaseType(_local_3.GetAttributeInt("baseType"));
                _local_4.setName_string(_local_3.GetAttributeString_string("name"));
                _local_4.setDiceBonus(_local_3.GetAttributeInt("diceBonus"));
                _local_4.setTimeBonus(_local_3.GetAttributeInt("timeBonus"));
                _local_4.SetMaxUnits(_local_3.GetAttributeInt("maxUnits"));
                _local_4.setMilitaryUnitType_string(_local_3.GetAttributeString_string("militaryUnitType"));
                _local_4.setSortIndex(_local_3.GetAttributeInt("sortIndex"));
                _local_4.setSkillType_string(_local_3.GetAttributeString_string("skillType"));
                _local_4.setgarrisonName_string(_local_3.GetAttributeString_string("garrison", "Garrison"));
                global.buildingDefaultParameterDoNotCountList_dictionary.Put(_local_4.getGarrisonName_string(), 1);
                _local_4.setuseHomeZoneLandingFieldsOnly(_local_3.GetAttributeBool("useHomeZoneLandingFieldsOnly", true));
                _local_4.setSpecialIconRequiresEvent_string(_local_3.GetAttributeString_string("specialIconRequiresEvent", ""));
                _local_4.setSpeed(_local_3.GetAttributeInt("onMapSpeed", 3));
                _local_4.setManaOnKill(_local_3.GetAttributeInt("manaOnKill"));
                _local_4.setManaOnDeath(_local_3.GetAttributeInt("manaOnDeath"));
                _local_4.setManaRescue(_local_3.GetAttributeInt("manaRescue"));
                _local_4.setManaRescueCap(_local_3.GetAttributeInt("manaRescueCap"));
                _local_4.SetAdventureMapLimitCount(_local_3.GetAttributeInt("adventureMapLimitCount"));
                _local_4.setTimeOverwriteTravelToZone((_local_3.GetAttributeInt("timeOverwriteTravelToZone", -1) * 1000));
                _local_4.setTimeOverwriteTravelFromZone((_local_3.GetAttributeInt("timeOverwriteTravelFromZone", -1) * 1000));
                _local_4.setTimeOverwriteRecover((_local_3.GetAttributeInt("timeOverwriteRecovery", -1) * 1000));
                _local_4.setCanAttack(_local_3.GetAttributeBool("canAttack", true));
                _local_5 = new Vector.<cXML>();
                _local_6 = new Vector.<Vector.<dResource>>();
                if (_local_3.HasSubNode("CostList"))
                {
                    _local_5 = _local_3.MoveToSubNodeAndCreateChildrenArray("CostList");
                    for each (_local_8 in _local_5)
                    {
                        _local_9 = gParse.ParseCosts(_local_8);
                        _local_6.push(_local_9);
                    };
                };
                _local_4.setRecruitable((_local_6.length > 0));
                map_SpecialistType_CostList[_local_4.GetType()] = _local_6;
                _local_7 = new Vector.<SkillVO>();
                if (_local_3.HasSubNode("Traits"))
                {
                    _local_5 = _local_3.MoveToSubNodeAndCreateChildrenArray("Traits");
                    for each (_local_10 in _local_5)
                    {
                        _local_11 = new SkillVO();
                        _local_11.id = _local_10.GetAttributeInt("id");
                        _local_11.level = _local_10.GetAttributeInt("level");
                        _local_7.push(_local_11);
                    };
                };
                _local_4.setTraits_vector(_local_7);
                SPECIALIST_TYPE.AddToSpecialistTypeDictionary(_local_4.getName_string());
                map_SpecialistType_SpecialistDescription[_local_4.GetType()] = _local_4;
            };
        }

        public static function GetSpecialistDescriptionForType(_arg_1:int):cSpecialistDescription
        {
            return (map_SpecialistType_SpecialistDescription[_arg_1] as cSpecialistDescription);
        }

        public static function GetAllSpecialistDescriptions():Array
        {
            var _local_2:String;
            var _local_3:cSpecialistDescription;
            var _local_1:Array = [];
            for (_local_2 in map_SpecialistType_SpecialistDescription)
            {
                _local_3 = (map_SpecialistType_SpecialistDescription[_local_2] as cSpecialistDescription);
                if (_local_3.IsRecruitable())
                {
                    _local_1.push(_local_3);
                };
            };
            return (_local_1);
        }

        public static function CreateSpecialistFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistVO, _arg_3:Boolean):cSpecialist
        {
            var _local_4:cSpecialist = CreateSpecialistWithOutTasksFromVO(_arg_1, _arg_2, _arg_3);
            return (LoadSpecialistTasks(_arg_1, _arg_2, _arg_3, _local_4));
        }

        public static function CreateSpecialistWithOutTasksFromVO(_arg_1:cGeneralInterface, _arg_2:dSpecialistVO, _arg_3:Boolean):cSpecialist
        {
            var _local_5:dSquadVO;
            var _local_4:cSpecialist = new cSpecialist(_arg_3).InitSpecialistFromType(_arg_2.specialistType, _arg_2.uniqueID, _arg_2.playerID, _arg_1.mCurrentViewedZoneID, _arg_1);
            _local_4.mapTo(_arg_1.channels.CHANNEL_MAP, CHANNELS.SPECIALIST);
            _local_4.mName_string = _arg_2.name_string;
            _local_4.currentHitPoints = _arg_2.currentHitPoints;
            _local_4.mFaceType = _arg_2.faceType;
            _local_4.mXp = _arg_2.xp;
            _local_4.mRetreatThreshold = _arg_2.retreatThreshold;
            _local_4.mGarrisonGridIdx = _arg_2.garrisonBuildingGridPos;
            if (_arg_2.garrisonBuildingGridPos != -1)
            {
                _local_4.SetGarrison(_arg_1.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_2.garrisonBuildingGridPos));
            };
            for each (_local_5 in _arg_2.armyVO.squads)
            {
                _local_4.GetArmy().AddSquadVO(_local_5, _arg_3);
            };
            if (_arg_2.skills != null)
            {
                _local_4.skillTree.setData(_arg_2.skills);
                _local_4.notifyPropertyObserver(SpecialistNotifier.SKILLS_CHANGED, _local_4);
            };
            if (_arg_2.eventSkills != null)
            {
                _local_4.skills.init(_arg_2.eventSkills, _local_4, _arg_1);
            };
            _local_4.mXpProduced = _arg_2.xpProduced;
            _local_4.mBattlesWon = _arg_2.battlesWon;
            _local_4.mUnitsDefeated = _arg_2.unitsDefeated;
            _local_4.mBuildingsDestroyed = _arg_2.buildingsDestroyed;
            _local_4.insertedAt = _arg_2.insertedAt;
            return (_local_4);
        }

        public static function LoadSpecialistTasks(_arg_1:cGeneralInterface, _arg_2:dSpecialistVO, _arg_3:Boolean, _arg_4:cSpecialist):cSpecialist
        {
            _arg_4.mTask = cSpecialistTask.CreateTaskFromVO(_arg_1, _arg_2.task, _arg_4);
            if (((!(_arg_4.mTask == null)) && (_arg_3)))
            {
                _arg_4.GetTask().mDirtyIndicator = (_arg_4.GetTask().mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
            return (_arg_4);
        }


        public function SetWaitingForServer(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.mLastServerCall = gMisc.GetTimeSinceStartup();
            }
            else
            {
                this.mLastServerCall = 0;
            };
            this.mWaitingForServerResponse = _arg_1;
            if (!_arg_1)
            {
                globalFlash.gui.mSpecialistPanel.Refresh(this);
            };
        }

        public function GetUniqueID():dUniqueID
        {
            return (this.uniqueID);
        }

        public function GetBaseType():int
        {
            return (this.mSpecialistDescription.getBaseType());
        }

        public function setNotModified():void
        {
            this.modified = false;
        }

        public function GetUnitsDefeated():int
        {
            return (this.mUnitsDefeated);
        }

        public function setName(_arg_1:String):void
        {
            this.mName_string = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            this.gi.channels.SPECIALIST.nameChanged(this);
        }

        private function CheckForOverCapacity():void
        {
            var _local_1:int;
            var _local_2:cArmy;
            var _local_3:String;
            var _local_4:int;
            if (this.GetMaxMilitaryUnits() < this.army.GetUnitsCount())
            {
                _local_1 = (this.army.GetUnitsCount() - this.GetMaxMilitaryUnits());
                _local_2 = this.gi.mCurrentPlayerZone.GetArmy(this.getPlayerID());
                while (_local_1 > 0)
                {
                    _local_3 = this.army.GetSquads_vector()[0].GetType();
                    _local_4 = this.army.RemoveUnits(_local_3, _local_1);
                    _local_2.AddUnits(_local_3, _local_4, 0, true);
                    _local_1 = (_local_1 - _local_4);
                };
            };
        }

        public function CreateSpecialistVOFromSpecialist():dSpecialistVO
        {
            var _local_2:cSquad;
            var _local_3:dSpecialistTaskVO;
            var _local_4:dSquadVO;
            var _local_1:dSpecialistVO = new dSpecialistVO();
            _local_1.uniqueID = this.GetUniqueID();
            _local_1.specialistType = this.GetType();
            _local_1.currentHitPoints = this.GetCurrentHitPoints();
            _local_1.playerID = this.getPlayerID();
            _local_1.faceType = this.GetFaceType();
            _local_1.xp = this.GetXP();
            _local_1.diceBonus = this.GetDiceBonus();
            _local_1.retreatThreshold = this.GetRetreatThreshold();
            if (this.GetGarrison() != null)
            {
                _local_1.garrisonBuildingGridPos = this.GetGarrison().GetGrid();
            }
            else
            {
                _local_1.garrisonBuildingGridPos = -1;
            };
            for each (_local_2 in this.army.GetSquads_vector())
            {
                _local_4 = new dSquadVO().init(_local_2.GetType(), _local_2.GetAmount(), _local_2.GetCurrentHitPoints());
                _local_1.armyVO.squads.addItem(_local_4);
            };
            _local_3 = null;
            if (this.GetTask() != null)
            {
                _local_3 = this.GetTask().CreateTaskVOFromSpecialistTask();
            };
            _local_1.task = _local_3;
            _local_1.xpProduced = this.mXpProduced;
            _local_1.battlesWon = this.mBattlesWon;
            _local_1.unitsDefeated = this.mUnitsDefeated;
            _local_1.buildingsDestroyed = this.mBuildingsDestroyed;
            _local_1.name_string = this.mName_string;
            _local_1.skills = this.getSkillTree().getSkillVOs();
            _local_1.eventSkills = this.skills.getSkillVOs();
            _local_1.insertedAt = this.insertedAt;
            return (_local_1);
        }

        public function GetAllActiveModifiers():Vector.<ModifierVO>
        {
            var _local_2:cSkill;
            var _local_3:SkillVO;
            var _local_4:int;
            var _local_5:cSkill;
            var _local_1:Vector.<ModifierVO> = new Vector.<ModifierVO>();
            for each (_local_2 in this.skillTree.getItems_vector())
            {
                if (_local_2.getLevel() > 0)
                {
                    _local_1 = _local_1.concat(_local_2.getDefinition().level_vector[(_local_2.getLevel() - 1)]);
                };
            };
            for each (_local_3 in this.GetSpecialistDescription().getTraits())
            {
                _local_4 = 1;
                _local_5 = this.skills.getItemByID(_local_3.id);
                if (_local_5.getLevel() > 0)
                {
                    _local_1 = _local_1.concat(_local_5.getDefinition().level_vector[(_local_5.getLevel() - 1)]);
                };
            };
            return (_local_1.concat(this.gi.mZoneBuffManager.getActiveCombatModifiers_vector()));
        }

        public function isModified():Boolean
        {
            return (this.modified);
        }

        public function HasUnits():Boolean
        {
            return (this.army.HasUnits());
        }

        public function getName(_arg_1:Boolean):String
        {
            if (!_arg_1)
            {
                if (((this.mName_string == null) || (this.mName_string == "")))
                {
                    return (("<b>" + cLocaManager.GetInstance().GetText(LOCA_GROUP.SPECIALISTS, SPECIALIST_TYPE.toString(this.GetType()))) + "</b>");
                };
                return (((("<b>" + this.mName_string) + "</b> <font size='-3'>(") + cLocaManager.GetInstance().GetText(LOCA_GROUP.SPECIALISTS, SPECIALIST_TYPE.toString(this.GetType()))) + ")</font>");
            };
            return (this.mName_string);
        }

        public function getNotifier():Notifier
        {
            return (this);
        }

        override public function dispose():void
        {
            if (((!(this.GetTask() == null)) && (this.GetTask() is Disposable)))
            {
                (this.GetTask() as Disposable).dispose();
            };
            super.dispose();
        }

        public function GetDiceBonus():int
        {
            return (this.mDiceBonus);
        }

        private function set mTask(_arg_1:cSpecialistTask):void
        {
            var _local_2:Object = this._103263122mTask;
            if (_local_2 !== _arg_1)
            {
                this._103263122mTask = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mTask", _local_2, _arg_1));
            };
        }

        public function SetPlayerID(_arg_1:int):void
        {
            this.mPlayerID = _arg_1;
        }

        public function GetModifier(_arg_1:String, _arg_2:String):ModifierVO
        {
            var _local_3:ModifierVO;
            for each (_local_3 in this.GetAllActiveModifiers())
            {
                if (((_local_3.modifier_string == _arg_1) && ((_arg_2 == null) || (_arg_2 == _local_3.item_string))))
                {
                    return (_local_3);
                };
            };
            return (null);
        }

        public function getPlayerID():int
        {
            return (this.mPlayerID);
        }

        public function GetTaskProgress():Number
        {
            return (this.mTaskProgress);
        }

        public function GetSortIndex():int
        {
            return (this.mSpecialistDescription.GetSortIndex());
        }

        public function SetCurrentHitPoints(_arg_1:int):void
        {
            if (((_arg_1 >= 0) && (!(_arg_1 == this.currentHitPoints))))
            {
                this.currentHitPoints = _arg_1;
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
        }

        public function getIconID():String
        {
            return (("icon_" + SPECIALIST_TYPE.toString(this.GetType()).toLowerCase()) + ".png");
        }

        public function GetCurrentHitPoints():int
        {
            return (this.currentHitPoints);
        }

        public function setSkillTree(_arg_1:cSkillTree):void
        {
            if (this.skillTree != null)
            {
                this.skillTree.removePropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
            };
            this.skillTree = _arg_1;
            this.skillTree.addPropertyObserver(cSkillList.SKILLLIST_CHANGED, this);
            this.notifyPropertyObserver(SpecialistNotifier.SKILLS_CHANGED, this);
        }

        public function setModified(_arg_1:Modifier):void
        {
            this.modified = true;
        }

        public function PerformTask(_arg_1:int):void
        {
            if (this.mTask != null)
            {
                this.mTaskProgress = this.mTask.GetTaskProgress();
                this.mTask.Perform(_arg_1);
            };
        }

        override public function toString():String
        {
            return (((((("<Specialist type='" + SPECIALIST_TYPE.toString(this.GetType())) + "' uniqueID='") + this.GetUniqueID()) + " playerId='") + this.getPlayerID()) + "' />");
        }

        public function GetBuildingsDestroyed():int
        {
            return (this.mBuildingsDestroyed);
        }

        public function GetXpProduced():int
        {
            return (this.mXpProduced);
        }

        public function GetSpecialistDescription():cSpecialistDescription
        {
            return (this.mSpecialistDescription);
        }

        public function AddUnitCapacityModifier(_arg_1:int):void
        {
            this.mUnitCapacityModifier = (this.mUnitCapacityModifier + _arg_1);
        }

        public function getGeneralTraits():ArrayCollection
        {
            var _local_2:cSkill;
            var _local_1:ArrayCollection = new ArrayCollection();
            for each (_local_2 in this.skills.getItems_vector())
            {
                if (((_local_2.isTrait()) && (_local_2.getLevel() > 0)))
                {
                    _local_1.addItem(_local_2);
                };
            };
            return (_local_1);
        }

        public function GetGarrison():cBuilding
        {
            return (this.mGarrison);
        }

        public function getMilitaryUnitType():String
        {
            return (this.mSpecialistDescription.GetMilitaryUnitType_string());
        }

        public function IncUnitsDefeated(_arg_1:int):void
        {
            this.mUnitsDefeated = (this.mUnitsDefeated + _arg_1);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function SetGarrison(_arg_1:cBuilding):void
        {
            if (_arg_1 != null)
            {
                this.mGarrisonGridIdx = _arg_1.GetGrid();
            }
            else
            {
                this.mGarrisonGridIdx = -1;
                this.DisableWaitForCommandAnimation();
            };
            this.mGarrison = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function GetType():int
        {
            return (this.mSpecialistDescription.GetType());
        }

        public function DisplayTaskProgress():Boolean
        {
            if (this.mTask == null)
            {
                return (false);
            };
            switch (this.mTask.GetType())
            {
                case SPECIALIST_TASK_TYPES.WAIT_FOR_CONFIRMATION:
                case SPECIALIST_TASK_TYPES.MOVE:
                case SPECIALIST_TASK_TYPES.ATTACK_BUILDING:
                case SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT:
                case SPECIALIST_TASK_TYPES.TRAVEL_TO_STAR_MENU:
                    return (false);
                default:
                    return (true);
            };
        }

        public function GetFaceType():int
        {
            return (this.mFaceType);
        }

        [Bindable(event="propertyChange")]
        private function get mTask():cSpecialistTask
        {
            return (this._103263122mTask);
        }

        public function GetZoneID():int
        {
            return (this.mZoneID);
        }

        public function InitSpecialistFromType(_arg_1:int, _arg_2:dUniqueID, _arg_3:int, _arg_4:int, _arg_5:cGeneralInterface):cSpecialist
        {
            this.gi = _arg_5;
            this.uniqueID = _arg_2;
            this.mPlayerID = _arg_3;
            this.mZoneID = _arg_4;
            this.army = new cArmy(_arg_4, _arg_3, ARMY_OWNER_TYPE.SPECIALIST, this);
            this.skills = new cSkillList(_arg_5);
            this.setSpecialistDescription(map_SpecialistType_SpecialistDescription[_arg_1]);
            this.setSkillTree(new cSkillTree(SkillTreeDefinition.nameToID(this.mSpecialistDescription.GetSkillType_string()), this, _arg_5));
            return (this);
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            if (_arg_1.modifier_string == "UnitCapacity")
            {
                return (true);
            };
            return (false);
        }

        public function GetUnitCapacityModifier():int
        {
            return (this.mUnitCapacityModifier);
        }

        public function GetXP():int
        {
            return (this.mXp);
        }

        public function GetBattlesWon():int
        {
            return (this.mBattlesWon);
        }

        public function GetMaxMilitaryUnits():int
        {
            if (this.mSpecialistDescription.GetMaxUnits() > 0)
            {
                return (Math.max(1, (this.mSpecialistDescription.GetMaxUnits() + this.GetUnitCapacityModifier())));
            };
            return (0);
        }

        public function SetUnitCapacityModifier(_arg_1:int):void
        {
            this.mUnitCapacityModifier = _arg_1;
        }

        private function set mTaskProgress(_arg_1:Number):void
        {
            var _local_2:Object = this._58515489mTaskProgress;
            if (_local_2 !== _arg_1)
            {
                this._58515489mTaskProgress = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "mTaskProgress", _local_2, _arg_1));
            };
        }

        public function GetRetreatThreshold():int
        {
            return (this.mRetreatThreshold);
        }

        public function DisableWaitForCommandAnimation():void
        {
            if (this.mGarrison != null)
            {
                this.mGarrison.SetIsGarrisonWaitForCommand(false);
            };
        }

        public function SetRetreatThreshold(_arg_1:int):void
        {
            this.mRetreatThreshold = _arg_1;
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }

        public function ClearModifiers():void
        {
            this.mUnitCapacityModifier = 0;
        }

        private function setSpecialistDescription(_arg_1:cSpecialistDescription):void
        {
            var _local_3:SkillVO;
            this.mSpecialistDescription = _arg_1;
            this.mDiceBonus = this.mSpecialistDescription.GetDiceBonus();
            this.mTimeBonus = this.mSpecialistDescription.GetTimeBonus();
            this.setSkillTree(new cSkillTree(SkillTreeDefinition.nameToID(this.mSpecialistDescription.GetSkillType_string()), this, this.gi));
            var _local_2:Vector.<SkillVO> = this.mSpecialistDescription.getTraits();
            if (_local_2.length > 0)
            {
                for each (_local_3 in _local_2)
                {
                    this.skills.addSkill(_local_3, this, this.gi, false, true, true);
                };
            };
        }

        public function getOwnerType():int
        {
            return (SKILL_OWNER.SPECIALIST);
        }

        public function getOwnerID():dUniqueID
        {
            return (this.uniqueID);
        }

        public function getSkillTree():cSkillTree
        {
            return (this.skillTree);
        }

        public function GetTask():cSpecialistTask
        {
            return (this.mTask);
        }

        public function GetGarrisonGridIdx():int
        {
            return (this.mGarrisonGridIdx);
        }

        public function GetGeneralState():int
        {
            if (this.GetTask() == null)
            {
                return (GENERAL_STATE_SPRITE.STATE_OK);
            };
            switch (this.GetTask().GetType())
            {
                case SPECIALIST_TASK_TYPES.RECOVER:
                    return (GENERAL_STATE_SPRITE.STATE_RECOVER);
                case SPECIALIST_TASK_TYPES.ATTACK_BUILDING:
                    switch (this.GetTask().GetTaskPhase())
                    {
                        case TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON:
                            return (GENERAL_STATE_SPRITE.STATE_RETREAT);
                        case TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET:
                        case TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET:
                        case TASK_PHASES_ATTACK_BUILDING.WAIT_AT_TARGET:
                            return (GENERAL_STATE_SPRITE.STATE_ATTACK);
                        default:
                            return (GENERAL_STATE_SPRITE.STATE_OK);
                    };
                case SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT:
                    switch (this.GetTask().GetTaskPhase())
                    {
                        case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON:
                            return (GENERAL_STATE_SPRITE.STATE_RETREAT);
                        case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET:
                        case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.BEGIN_ATTACK:
                        case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.GO_TO_TARGET:
                        case TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_AT_TARGET:
                            return (GENERAL_STATE_SPRITE.STATE_ATTACK);
                        default:
                            return (GENERAL_STATE_SPRITE.STATE_OK);
                    };
                default:
                    return (-1);
            };
            return (-1); //dead code
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == cSkillList.SKILLLIST_CHANGED)
            {
                this.ClearModifiers();
                this.notifyPropertyObserver(SpecialistNotifier.SKILLS_CHANGED, this);
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
                this.CheckForOverCapacity();
            };
        }

        public function ResetTaskNoSideEffect():void
        {
            this.mTask = null;
        }

        public function isTravellingAway():Boolean
        {
            var _local_1:cSpecialistTask_TravelToZone;
            if (((!(this.GetTask() == null)) && (this.GetTask().GetOriginalType() == SPECIALIST_TASK_TYPES.TRAVEL_TO_ZONE)))
            {
                if ((this.GetTask() is cSpecialistTask_WaitForConfirmation))
                {
                    return (true);
                };
                _local_1 = (this.GetTask() as cSpecialistTask_TravelToZone);
                return (!(_local_1.GetDestinationZoneID() == this.gi.mCurrentViewedZoneID));
            };
            return (false);
        }

        public function GetSortValue():Number
        {
            if (this.GetTask() != null)
            {
                return (this.GetTask().GetSortValue());
            };
            return (0);
        }

        public function SetTask(_arg_1:cSpecialistTask):void
        {
            this.mTask = _arg_1;
            if (this.mTask != null)
            {
                this.mTask.StartTask();
            }
            else
            {
                globalFlash.gui.mSpecialistCooldownPanel.Hide();
            };
        }

        public function GetArmy():cArmy
        {
            return (this.army);
        }

        public function GetWaitingForServer():Boolean
        {
            if (((this.mLastServerCall > 0) && (this.mLastServerCall < (gMisc.GetTimeSinceStartup() - this.TIMEOUT))))
            {
                this.mWaitingForServerResponse = false;
                if (cLog.isInfoEnabled())
                {
                    cLog.info(("No server response for 30 seconds in: " + this));
                };
            };
            return (this.mWaitingForServerResponse);
        }

        [Bindable(event="propertyChange")]
        private function get mTaskProgress():Number
        {
            return (this._58515489mTaskProgress);
        }

        public function IsInUse():Boolean
        {
            return (!(this.mTask == null));
        }

        public function IncBuildingsDestroyed(_arg_1:int):void
        {
            this.mBuildingsDestroyed = (this.mBuildingsDestroyed + _arg_1);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
        }


    }
}
