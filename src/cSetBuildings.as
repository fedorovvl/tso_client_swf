package 
{
    import GUI.Components.CustomAlert;
    import GUI.Components.ResourceAlert;
    import ServerState.cPlayerData;
    import Map.cPlayerZoneScreen;
    import Interface.cGeneralInterface;
    import PathFinding.cPathObject;
    import nLib.cPosInt;
    import Specialists.cSpecialist;
    import BuffSystem.cBuff;
    import Communication.VO.dServerAction;
    import Utils.ModifiableCost;
    import ServerState.dResource;
    import Communication.VO.dStartSpecialistTaskVO;
    import MilitarySystem.cSquad;
    import GO.cDeposit;
    import __AS3__.vec.Vector;
    import GO.cBuilding;
    import GO.buildings.DestroyOnClickBuilding;
    import Enums.COMMAND;
    import Sound.cSoundManager;
    import Communication.VO.SetBuildingVO;
    import nLib.gMisc;
    import mx.controls.Alert;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.SPECIALIST_TASK_ATTACK_BUILDING_MODE;
    import Specialists.cSpecialistTask_WaitForConfirmation;
    import Enums.KILL_SWITCH;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Decorator.GUIDecorator;
    import GUI.Assets.gAssetManager;
    import Enums.TIMED_PRODUCTION_TYPE;
    import GO.cGO;
    import GO.cIsoGO;
    import Enums.HALLOWEEN_EVENT;
    import Utils.StringUtils;
    import mx.events.CloseEvent;
    import Enums.BUFF_UI;
    import GO.cBlockingData;
    import PathFinding.PFAdditionalData;
    import Map.GridPosition;
    import GO.cGOSpriteLibContainer;
    import ServerState.cResources;
    import nLib.cXML;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import Enums.DIRTY_INDICATOR;
    import PathFinding.dPathObjectItem;
    import ServerState.dResourceCreationDefinition;
    import Enums.OBJECTTYPE;
    import GO.cStreet;
    import ServerState.gEconomics;
    import ServerState.cComputeResourceCreation;
    import PathFinding.cPathFinder;
    import nLib.cBackbuffer;
    import BuffSystem.cBuffDefinition;
    import nLib.cLog;
    import GO.epicWorkyard.EpicWorkyardMasterBuilding;
    import ServerState.cResourceCreation;
    import Communication.VO.dMoveBuildingVO;
    import __AS3__.vec.*;

    public class cSetBuildings 
    {

        private var mPreviewPathOldCursorGridIdx:int = -1;
        private var mCursorGrid:int = 0;
        private var mForceRenderTransportDuration:Boolean;
        public var mMilitaryPathVisible:Boolean;
        private var mPathTime:int = 0;
        private var gridWhenClicked:int = 0;
        private var mIsFillUpBuilding:Boolean = false;
        private var customAlert:CustomAlert = null;
        private var resourceAlert:ResourceAlert = null;
        private var mMilitaryPathStartingPositionGridIdx:int;
        private var mPlayerData:cPlayerData = null;
        private var mPlayerZone:cPlayerZoneScreen = null;
        private var mGeneralInterface:cGeneralInterface;

        public var mPreviewPathObject:cPathObject = new cPathObject();
        private var mTempPos:cPosInt = new cPosInt();

        public function cSetBuildings(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function MouseClickOnMap(_playerData:cPlayerData, _playerZone:cPlayerZoneScreen):Boolean
        {
            var specialist:cSpecialist;
            var buff:cBuff;
            var action:dServerAction;
            var cursorGrid:int;
            var buildByBuff:Boolean;
            var moveCosts:ModifiableCost;
            var gemRes:dResource;
            var startSpecialistTaskVO:dStartSpecialistTaskVO;
            var specialState:Boolean;
            var squad:cSquad;
            var moveCosts1:ModifiableCost;
            var deposit:cDeposit;
            var remainingAmount:int;
            var textMessage:String;
            var refundResources:cBasicResourceCollection;
            var surplusResources:Vector.<dResource>;
            var teardownKey:String;
            var building2:cBuilding;
            var startSpecialistTaskVO2:dStartSpecialistTaskVO;
            var goToBuff:Object;
            var building:cBuilding;
            var cursorPosX:int = this.mGeneralInterface.mCurrentCursor.GetCursorXPixelPos();
            var cursorPosY:int = this.mGeneralInterface.mCurrentCursor.GetCursorYPixelPos();
            cursorGrid = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
            switch (this.mGeneralInterface.mCurrentCursor.GetEditMode())
            {
                case COMMAND.SELECT_BUILDING:
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        if (globalFlash.gui.mCombatScenarioToolTip.IsVisible())
                        {
                            globalFlash.gui.mCombatScenarioToolTip.HideByClick();
                        };
                        return (false);
                    };
                    building = _playerZone.GetBuildingFromGridPosition(cursorGrid);
                    if (building == null)
                    {
                        building = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(cursorGrid);
                    };
                    building = building.getBuildingSelection();
                    if (((((((_playerData.mIsPlayerZone) && (!(building == null))) && (building.IsBuildingSelectable())) && (!(building.GetBuildingName_string() == null))) && (!(building.getPlayerID() == 0))) && (!(building.GetBuildingMode() == cBuilding.BUILDING_DESTRUCTION_READY))))
                    {
                        if (((!(building.IsEngagedInCombat())) || (this.mGeneralInterface.UsesCombatThree())))
                        {
                            this.mGeneralInterface.SelectBuilding(building);
                        };
                    }
                    else
                    {
                        if (((!(building == null)) && (building.mIsEventMonster)))
                        {
                            this.mGeneralInterface.SelectBuilding(building);
                        }
                        else
                        {
                            if (((((!(building == null)) && (building is DestroyOnClickBuilding)) && (!(_playerData.GetPlayerId() == building.getPlayerID()))) && (!(_playerData.mIsAdventureZone))))
                            {
                                this.mGeneralInterface.SelectBuilding(building);
                            }
                            else
                            {
                                if ((((!(building == null)) && (building.GetBuildingMode() == cBuilding.BUILDING_DESTRUCTION_READY)) && (_playerData.GetHomeZoneId() == this.mGeneralInterface.mCurrentViewedZoneID)))
                                {
                                    building.StartDestroySequence();
                                };
                            };
                        };
                    };
                    return (true);
                case COMMAND.SET_BUILDING_IN_DEFENSE_MODE:
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        return (false);
                    };
                    this.mGeneralInterface.SendServerAction(this.mGeneralInterface.mCurrentCursor.GetEditMode(), global.buildingGroup.GetNrFromName(this.mGeneralInterface.mCurrentCursor.mLevelObject_string), cursorGrid, 0, null);
                    _playerZone.mStreetDataMap.mBuildingContainer.get(cursorGrid).SetBuildingMode(cBuilding.BUILDING_MODE_PLACED);
                    cSoundManager.getInstance().playEffect("BuildingPlace");
                    globalFlash.gui.mToolboxPanel.Refresh();
                    this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                    return (true);
                case COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF:
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        return (false);
                    };
                    this.mGeneralInterface.SendServerAction(this.mGeneralInterface.mCurrentCursor.GetEditMode(), global.buildingGroup.GetNrFromName(this.mGeneralInterface.mCurrentCursor.mLevelObject_string), cursorGrid, 0, this.mGeneralInterface.mCurrentCursor.mCurrentBuff.GetUniqueId());
                    this.mGeneralInterface.mCurrentCursor.mCurrentBuff.IncWaitingForServerCount(this.mGeneralInterface);
                    _playerZone.mStreetDataMap.mBuildingContainer.get(cursorGrid).SetBuildingMode(cBuilding.BUILDING_MODE_PLACED);
                    cSoundManager.getInstance().playEffect("BuildingPlace");
                    globalFlash.gui.mToolboxPanel.Refresh();
                    this.mGeneralInterface.mCurrentCursor.mCurrentBuff.IncWaitingForServerCount(this.mGeneralInterface);
                    this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                    return (true);
                case COMMAND.SET_BUILDING_IN_GAME:
                case COMMAND.SET_BUILDING_BY_BUFF:
                    buildByBuff = (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_BY_BUFF);
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                        return (false);
                    };
                    if (!buildByBuff)
                    {
                        if (_playerData.IsMaximumPlacedBuildingCountReached(this.mGeneralInterface.mCurrentCursor.mLevelObject_string))
                        {
                            CustomAlert.show("MaxBuildingCountReached", "MaxBuildingCountReached");
                            this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                            return (false);
                        };
                    };
                    if (((buildByBuff) || ((!(_playerData.mBuildQueue.IsFull())) && (!(_playerData.mBuildQueue.IsBlockedUntilBuildQueueIsProceed())))))
                    {
                        _playerData.mBuildQueue.SetBlockedUntilBuildQueueIsProceed();
                        this.mGeneralInterface.SendServerAction(this.mGeneralInterface.mCurrentCursor.GetEditMode(), global.buildingGroup.GetNrFromName(this.mGeneralInterface.mCurrentCursor.mLevelObject_string), cursorGrid, 0, ((buildByBuff) ? SetBuildingVO.Init(this.mGeneralInterface.mCurrentCursor.mCurrentBuff.GetUniqueId()) : null));
                        if (buildByBuff)
                        {
                            this.mGeneralInterface.mCurrentCursor.mCurrentBuff.IncWaitingForServerCount(this.mGeneralInterface);
                        };
                        globalFlash.gui.mToolboxPanel.Refresh();
                        if (_playerZone.mStreetDataMap.SetPrePlaceBuildingGridPos(_playerData, this.mGeneralInterface.mCurrentCursor.mLevelObject_string, cursorGrid, ((buildByBuff) ? this.mGeneralInterface.mCurrentCursor.mCurrentBuff.GetRecurrentChance() : 0)))
                        {
                            cSoundManager.getInstance().playEffect("BuildingPlace");
                        }
                        else
                        {
                            gMisc.MessageBox("Could not set building - illegal Position!");
                        };
                    }
                    else
                    {
                        this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                    };
                    if (((!(buildByBuff)) || (this.mGeneralInterface.mCurrentCursor.mCurrentBuff.GetAmount() <= this.mGeneralInterface.mCurrentCursor.mCurrentBuff.GetWaitingForServerCount())))
                    {
                        this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                    }
                    else
                    {
                        if (buildByBuff)
                        {
                            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.InitRenderCursorInfo();
                            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RenderCursorInfo();
                        };
                    };
                    return (true);
                case COMMAND.MOVE_BUILDING:
                    if (this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        this.mPlayerData = _playerData;
                        this.mPlayerZone = _playerZone;
                        this.mCursorGrid = cursorGrid;
                        building = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding;
                        moveCosts = new ModifiableCost();
                        if (building.mMoveMethod == cBuilding.BUILDING_MOVE_WITH_GEM)
                        {
                            gemRes = new dResource();
                            gemRes.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                            gemRes.amount = building.GetGemMovementCosts();
                            moveCosts.cost.push(gemRes);
                        }
                        else
                        {
                            moveCosts = building.GetMovementCosts();
                        };
                        if (moveCosts == null)
                        {
                            this.MoveBuilding();
                        }
                        else
                        {
                            ResourceAlert.show("ConfirmMoveBuilding", null, "ConfirmMoveBuilding", null, moveCosts.cost, (Alert.CANCEL | Alert.OK), null, this.MoveBuilding);
                        };
                    };
                    return (true);
                case COMMAND.ATTACK_BUILDING:
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        return (false);
                    };
                    building = _playerZone.GetBuildingFromGridPosition(cursorGrid);
                    if (((((!(building == null)) && (building.IsBuildingSelectable())) && (_playerData.mIsPlayerZone)) && (!(building.GetBuildingName_string() == null))))
                    {
                        if (!this.mGeneralInterface.UsesCombatThree())
                        {
                            specialist = this.mGeneralInterface.mCurrentCursor.mCurrentSpecialist;
                            startSpecialistTaskVO = new dStartSpecialistTaskVO();
                            startSpecialistTaskVO.uniqueID = specialist.GetUniqueID();
                            global.ui.SendServerAction(COMMAND.SET_TASK, SPECIALIST_TASK_TYPES.ATTACK_BUILDING, building.GetGrid(), SPECIALIST_TASK_ATTACK_BUILDING_MODE.BUILDING_ONLY, startSpecialistTaskVO);
                            specialist.SetTask(new cSpecialistTask_WaitForConfirmation(this.mGeneralInterface, specialist, 0, SPECIALIST_TASK_TYPES.ATTACK_BUILDING));
                            this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                            this.mGeneralInterface.mCurrentCursor.mCurrentSpecialist = null;
                            this.mMilitaryPathVisible = false;
                            cSoundManager.getInstance().playEffect("GeneralAttack");
                        };
                    };
                    return (true);
                case COMMAND.GET_COMBAT_PREVIEW:
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        return (false);
                    };
                    building = _playerZone.GetBuildingFromGridPosition(cursorGrid);
                    if (((((!(building == null)) && (building.IsBuildingSelectable())) && (_playerData.mIsPlayerZone)) && (!(building.GetBuildingName_string() == null))))
                    {
                        specialist = this.mGeneralInterface.mCurrentCursor.mCurrentSpecialist;
                        this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                        globalFlash.gui.mCombatPreviewPanel.SetGeneralInterception(this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsWatchAreaInterfering(building.GetStreetGridEntry()));
                        specialState = false;
                        if (building.mSpecialCombatPreview != null)
                        {
                            for each (squad in building.GetArmy().GetSquads_vector())
                            {
                                if (squad.name_string == building.mSpecialCombatPreview.GetUnitType())
                                {
                                    if (squad.amount > building.mSpecialCombatPreview.GetUnitCount())
                                    {
                                        specialState = true;
                                    };
                                    break;
                                };
                            };
                        };
                        if (specialState)
                        {
                            globalFlash.gui.mCombatPreviewPanel.SetData("SpecialState", building.mPreCombatTipType, building.mPreCombatType);
                            globalFlash.gui.mCombatPreviewPanel.Show();
                        }
                        else
                        {
                            global.getApplication().mGameInterface.SendServerAction(COMMAND.GET_COMBAT_PREVIEW, 0, building.GetGrid(), 0, specialist.GetUniqueID());
                            globalFlash.gui.mCombatPreviewPanel.SetData("IdleState");
                            globalFlash.gui.mCombatPreviewPanel.Show();
                        };
                    };
                    return (true);
                case COMMAND.SELECT_BUILDING_TO_MOVE:
                    if (((!(this.mGeneralInterface.mCurrentCursor.IsCursorValid())) || (this.mGeneralInterface.killswitch.isLocked(KILL_SWITCH.TOOLBOX_MOVEBUILDING))))
                    {
                        return (false);
                    };
                    building = _playerZone.mStreetDataMap.mBuildingContainer.get(cursorGrid);
                    if (building == null)
                    {
                        building = _playerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(cursorGrid);
                    };
                    building = building.getBuildingSelection();
                    moveCosts1 = building.GetMovementCosts();
                    if (moveCosts1 != null)
                    {
                        this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                        globalFlash.gui.mMoveBuildingPanel.SetData(building);
                        globalFlash.gui.mMoveBuildingPanel.Show();
                    }
                    else
                    {
                        if ((((building.IsMovable()) || (building.IsDecoration())) || (!(building.IsBought()))))
                        {
                            this.mGeneralInterface.mCurrentCursor.mCurrentBuilding = building;
                            this.mGeneralInterface.mCurrentCursor.SetCursorEditModeObjectName(COMMAND.MOVE_BUILDING, building.GetGOContainer().mGfxResourceListName_string);
                            this.mGeneralInterface.mCurrentCursor.SetCursor(building.GetLevelEnumObjectType(), building.GetGOContainer().mGfxResourceListName_string);
                            this.mGeneralInterface.mCurrentCursor.SetCursorGfxWithUpgradeLevel(building.GetLevelEnumObjectType(), building.GetGOContainer().mGfxResourceListName_string, building.GetUpgradeLevel());
                            globalFlash.gui.mCancelActionPanel.Show();
                        };
                    };
                    return (true);
                case COMMAND.DELETE_BUILDING:
                    if (this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        this.mPlayerData = _playerData;
                        this.mPlayerZone = _playerZone;
                        this.mCursorGrid = cursorGrid;
                        this.gridWhenClicked = cursorGrid;
                        building = this.mPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mCursorGrid);
                        if (building == null)
                        {
                            building = this.mPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(this.mCursorGrid);
                        };
                        building = building.getBuildingSelection();
                        remainingAmount = 0;
                        this.resourceAlert = null;
                        this.customAlert = null;
                        if (building.GetGOContainer().mAddDepositName != null)
                        {
                            deposit = this.mPlayerZone.mStreetDataMap.mDepositContainer.get(this.mCursorGrid);
                            if (deposit == null)
                            {
                                remainingAmount = building.GetGOContainer().mAddDepositAmount;
                            }
                            else
                            {
                                remainingAmount = deposit.GetAmount();
                            };
                            this.customAlert = CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ConfirmTeardownWithDeposit", [remainingAmount, gMisc.GetSubString_string(building.GetGOContainer().mAddDepositName, 7, (building.GetGOContainer().mAddDepositName.length - 7)), building.GetBuildingName_string()]), cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_TITLES, "ConfirmTeardownWithDeposit", [building.GetBuildingName_string()]), (Alert.CANCEL | Alert.OK), null, this.RemoveBuilding, GUIDecorator.overlay(gAssetManager.GetGfx("icon_exclamationmark_large.png"), gAssetManager.GetBuildingIcon(building.GetBuildingName_string()), 3, 3), 4, false, CustomAlert.STYLE_DEFAULT, null, "center");
                        }
                        else
                        {
                            refundResources = new cBasicResourceCollection();
                            if (!building.IsRecurringBuilding())
                            {
                                textMessage = "ConfirmTeardown";
                                refundResources.AddResources(building.GetRefundResources());
                                if (((building.IsDefenseModeGarrison()) && (!(building.GetArmy() == null))))
                                {
                                    refundResources.AddResources(building.GetArmy().GetTotalUnitResourceCosts());
                                };
                            }
                            else
                            {
                                if (((building.IsDefenseModeGarrison()) && (!(building.GetArmy() == null))))
                                {
                                    refundResources.AddResources(building.GetArmy().GetTotalUnitResourceCosts());
                                };
                                textMessage = "ConfirmTeardownBuff";
                            };
                            if (((!(building.productionQueue == null)) && (TIMED_PRODUCTION_TYPE.isCultureBuilding(building.productionQueue.mProductionType))))
                            {
                                if (0 == this.mGeneralInterface.mZoneBuffManager.getNumberOfExtraBuildingBuffs(building.GetBuildingName_string()))
                                {
                                    textMessage = (textMessage + "ZoneBuffs");
                                };
                            };
                            surplusResources = null;
                            if (building.IsWarehouseType())
                            {
                                surplusResources = building.getSurplusResources();
                            };
                            teardownKey = "ConfirmTeardown";
                            if (building.GetGOContainer().useCustomTeardownMessage)
                            {
                                teardownKey = (teardownKey + ("_" + building.GetBuildingName_string()));
                                textMessage = (textMessage + ("_" + building.GetBuildingName_string()));
                            };
                            if (((surplusResources) && (surplusResources.length)))
                            {
                                this.resourceAlert = ResourceAlert.show(textMessage, null, teardownKey, null, refundResources.GetResourcesVector(), (Alert.CANCEL | Alert.OK), null, this.RemoveBuilding, null, true, ResourceAlert.STYLE_RESOURCE_LOSS, surplusResources);
                            }
                            else
                            {
                                this.resourceAlert = ResourceAlert.show(textMessage, null, teardownKey, null, refundResources.GetResourcesVector(), (Alert.CANCEL | Alert.OK), null, this.RemoveBuilding, null, true, ResourceAlert.STYLE_WHITE_RESOURCES);
                            };
                        };
                    };
                    return (true);
                case COMMAND.MOVE_GARISSON:
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        return (false);
                    };
                    if (_playerData.mIsPlayerZone)
                    {
                        if (_playerZone.mStreetDataMap.SetPrePlaceBuildingGridPos(_playerData, this.mGeneralInterface.mCurrentCursor.mLevelObject_string, cursorGrid, 0))
                        {
                            building2 = _playerZone.mStreetDataMap.mBuildingContainer.get(cursorGrid);
                            building2.mIsSelectable = false;
                            specialist = this.mGeneralInterface.mCurrentCursor.mCurrentSpecialist;
                            startSpecialistTaskVO2 = new dStartSpecialistTaskVO();
                            startSpecialistTaskVO2.uniqueID = specialist.GetUniqueID();
                            global.ui.SendServerAction(COMMAND.SET_TASK, SPECIALIST_TASK_TYPES.MOVE, this.mGeneralInterface.mCurrentCursor.GetGridPosition(), 0, startSpecialistTaskVO2);
                            specialist.SetTask(new cSpecialistTask_WaitForConfirmation(this.mGeneralInterface, specialist, 0, SPECIALIST_TASK_TYPES.MOVE));
                            this.mGeneralInterface.mSetBlockingPathPreview.removePath(cursorGrid);
                        }
                        else
                        {
                            gMisc.MessageBox("Could not set building - illegal Position!");
                        };
                        this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                        this.mGeneralInterface.mCurrentCursor.mCurrentSpecialist = null;
                        this.mMilitaryPathVisible = false;
                    };
                    return (true);
                case COMMAND.APPLY_BUFF:
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        return (false);
                    };
                    global.buffingBlockedUntil[cursorGrid] = (gMisc.GetTimeSinceStartup() + defines.BUFF_BLOCKING_DURATION);
                    buff = this.mGeneralInterface.mCurrentCursor.mCurrentBuff;
                    goToBuff = buff.IsApplyable(_playerData, this.mGeneralInterface, cursorGrid);
                    if ((goToBuff is cGO))
                    {
                        if ((goToBuff is cIsoGO))
                        {
                            global.buffingBlockedUntil[(goToBuff as cIsoGO).GetGrid()] = (gMisc.GetTimeSinceStartup() + defines.BUFF_BLOCKING_DURATION);
                        };
                        if (((goToBuff is cBuilding) && (goToBuff.mIsEventMonster)))
                        {
                            globalFlash.gui.mEventMonster.SetData((goToBuff as cBuilding));
                            globalFlash.gui.mEventMonster.Show();
                        }
                        else
                        {
                            if (buff.GetBuffDefinition().GetName_string().indexOf(HALLOWEEN_EVENT.BUFF_HIT_MONSTER) == 0)
                            {
                                this.mGeneralInterface.SendServerAction(COMMAND.APPLY_BUFF, 0, cursorGrid, buff.GetAmount(), buff.GetUniqueId());
                                buff.SetWaitingForServerCount(buff.GetAmount(), this.mGeneralInterface);
                            }
                            else
                            {
                                if (((goToBuff is cBuilding) && (StringUtils.startsWith((goToBuff as cBuilding).GetBuildingName_string(), defines.DESTROYABLE_MOUNTAIN_string))))
                                {
                                    CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.ALERT_MESSAGES, "ChangeColorSchemeInstant"), buff.getName(), (Alert.CANCEL | Alert.OK), null, function (_arg_1:CloseEvent):void
                                    {
                                        if (_arg_1.detail == Alert.OK)
                                        {
                                            global.ui.SendServerAction(COMMAND.APPLY_BUFF, 0, cursorGrid, 0, buff.GetUniqueId());
                                            buff.IncWaitingForServerCount(mGeneralInterface);
                                            if (((buff.GetInstantAmount() <= 0) || (!(buff.GetBuffDefinition().GetType().indexOf(HALLOWEEN_EVENT.BUFF_HIT_MONSTER) == -1))))
                                            {
                                                mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                                                mGeneralInterface.mCurrentCursor.mCurrentBuff = null;
                                            };
                                        };
                                    }, null, 4, false, CustomAlert.STYLE_DEFAULT, null, "left");
                                    return (false);
                                };
                                if (((((buff.GetBuffDefinition().GetName_string().indexOf(defines.ADD_RESOURCE_BUFF) == 0) || (buff.GetBuffDefinition().GetName_string().indexOf(defines.FILL_DEPOSIT_BUFF) == 0)) || (StringUtils.startsWith(buff.GetBuffDefinition().GetName_string(), defines.HIRED_MILITARY_BUFF))) || (buff.GetBuffDefinition().getBuffUI() == BUFF_UI.STACK_RESOURCE)))
                                {
                                    cursorGrid = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
                                    globalFlash.gui.mApplyBuffResourcePanel.setData(buff, cursorGrid);
                                    globalFlash.gui.mApplyBuffResourcePanel.Show();
                                }
                                else
                                {
                                    if (buff.GetBuffDefinition().GetTargetDescription_string().indexOf("PartyCrashers") == 0)
                                    {
                                        if (buff.GetAmount() == 1)
                                        {
                                            this.mGeneralInterface.SendServerAction(COMMAND.APPLY_BUFF, 0, cursorGrid, 1, buff.GetUniqueId());
                                            buff.IncWaitingForServerCount(this.mGeneralInterface);
                                        }
                                        else
                                        {
                                            cursorGrid = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
                                            globalFlash.gui.mApplyBuffResourcePanel.setData(buff, cursorGrid);
                                            globalFlash.gui.mApplyBuffResourcePanel.Show();
                                        };
                                    }
                                    else
                                    {
                                        this.mGeneralInterface.SendServerAction(COMMAND.APPLY_BUFF, 0, cursorGrid, 0, buff.GetUniqueId());
                                        buff.IncWaitingForServerCount(this.mGeneralInterface);
                                    };
                                };
                            };
                        };
                    };
                    if (((buff.GetInstantAmount() <= 0) || (!(buff.GetBuffDefinition().GetType().indexOf(HALLOWEEN_EVENT.BUFF_HIT_MONSTER) == -1))))
                    {
                        this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
                        this.mGeneralInterface.mCurrentCursor.mCurrentBuff = null;
                    };
                    return (true);
            };
            return (false);
        }

        public function AddBlockingData(_arg_1:cGOSpriteLibContainer, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Vector.<PFAdditionalData>):void
        {
            var _local_6:cBlockingData;
            var _local_7:int;
            var _local_8:int;
            for each (_local_6 in _arg_1.mBlocking_vector)
            {
                if (((_local_6.getBlockingType() == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING) || (_local_6.getBlockingType() == cBlockingData.BLOCK_TYPE_ALLOW_SAFE)))
                {
                    _local_7 = int((_arg_2 + ((_local_6.getXPixelOffset() * global.streetGridX) / 100)));
                    _local_8 = int((_arg_3 + ((_local_6.getYPixelOffset() * global.streetGridY) / 100)));
                    _arg_5.push(new PFAdditionalData(new GridPosition(gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _local_7, _local_8)), _arg_4));
                };
            };
        }

        public function SetDepositMode(_arg_1:cGeneralInterface, _arg_2:cPlayerZoneScreen, _arg_3:cPlayerData, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:int, _arg_8:int, _arg_9:int, _arg_10:Boolean):cDeposit
        {
            var _local_13:cResources;
            var _local_14:cXML;
            var _local_15:Vector.<cXML>;
            var _local_16:cXML;
            var _local_11:cDeposit;
            if (_arg_4 != null)
            {
                _local_13 = _arg_1.mCurrentPlayerZone.GetResources(_arg_3);
                if (!_local_13.CanPlayerAffordBuilding(_arg_4))
                {
                    return (null);
                };
                _local_13.RemoveBuildingResourcesFromPlayerResources(_arg_4);
            };
            _local_11 = (_arg_2.SetAtGridPosition(_arg_3, _arg_7, _arg_6, _arg_9) as cDeposit);
            var _local_12:String = _local_11.GetGOSetListName_string();
            if (_arg_5 != null)
            {
                _local_14 = global.gfxSettingsGameObjectsXML.MoveToSubNode("Deposits");
                _local_15 = _local_14.CreateChildrenArray();
                for each (_local_16 in _local_15)
                {
                    if (_arg_5 == _local_16.GetAttributeString_string("name"))
                    {
                        _local_12 = _local_16.GetAttributeString_string("gosetlist");
                        _arg_1.mCurrentPlayerZone.mStreetDataMap.RefreshDepositGfx(_local_11.GetGrid());
                    };
                };
            };
            _local_11.Init(gMisc.GetSubString_string(_arg_6, 7, (_arg_6.length - 7)), _arg_9, _arg_8, _arg_8, -1, DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE, 0, _local_12, _arg_10, null);
            if (_local_11 != null)
            {
                _local_11.mDirtyIndicator = (_local_11.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
            return (_local_11);
        }

        private function RemoveBuilding(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail != Alert.OK)
            {
                return;
            };
            var _local_2:cBuilding = this.mPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mCursorGrid);
            if (_local_2 == null)
            {
                _local_2 = this.mPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(this.mCursorGrid);
            };
            _local_2 = _local_2.getBuildingSelection();
            var _local_3:* = "";
            var _local_4:* = "";
            var _local_5:int;
            var _local_6:int;
            if (this.mGeneralInterface.mCurrentCursor != null)
            {
                _local_3 = this.mGeneralInterface.mCurrentCursor.mLevelObject_string;
            };
            if (this.mGeneralInterface.mCurrentPlayer != null)
            {
                _local_5 = this.mGeneralInterface.mCurrentPlayer.GetPlayerId();
            };
            if (this.mGeneralInterface.mHomePlayer != null)
            {
                _local_6 = this.mGeneralInterface.mHomePlayer.getPlayerID();
            };
            if (((!(_local_2.GetGOContainer().mAddDepositName == null)) && (!(this.customAlert == null))))
            {
                _local_4 = this.customAlert.titleLabel.text;
            }
            else
            {
                if (((_local_2.GetGOContainer().mAddDepositName == null) && (!(this.resourceAlert == null))))
                {
                    _local_4 = this.resourceAlert.titleLabel.text;
                };
            };
            this.mPlayerZone.SendDestructBuildingCommand(_local_2, ((((((((((("cSetBuilding-" + this.mCursorGrid) + "-") + this.gridWhenClicked) + " # Cursor: ") + _local_3) + " # Alert Title: ") + _local_4) + " # Owner: ") + _local_6) + " # Current Player: ") + _local_5));
        }

        public function ShowPreviewPath(_arg_1:int, _arg_2:Boolean=false, _arg_3:String="", _arg_4:Boolean=true):void
        {
            var _local_6:Boolean;
            var _local_7:int;
            var _local_8:int;
            var _local_9:Vector.<PFAdditionalData>;
            var _local_10:cPathObject;
            var _local_11:dPathObjectItem;
            var _local_12:String;
            var _local_13:String;
            var _local_14:dResourceCreationDefinition;
            var _local_15:cGOSpriteLibContainer;
            var _local_16:cPosInt;
            var _local_17:*;
            var _local_18:int;
            var _local_5:cBuilding = this.mGeneralInterface.GetSelectedBuilding();
            if (((((((((((this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ATTACK_BUILDING) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_GARISSON)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.COMBAT3_CHOOSE_UNIT)) || (!(_local_5 == null))) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.GET_COMBAT_PREVIEW)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_GAME)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_DEFENSE_MODE)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_BY_BUFF)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BUILDING)))
            {
                _local_8 = -1;
                if (((!(_local_5 == null)) && (!(this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_GARISSON))))
                {
                    _local_8 = _local_5.GetGrid();
                }
                else
                {
                    if (this.mGeneralInterface.isPreviewPathLocked())
                    {
                        _local_8 = this.mGeneralInterface.mLockedPreviewPathEndGrid;
                    }
                    else
                    {
                        _local_8 = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
                    };
                };
                if (((!(this.mPreviewPathOldCursorGridIdx == _local_8)) || (_arg_2)))
                {
                    this.mPreviewPathOldCursorGridIdx = _local_8;
                    this.mPathTime = -1;
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.ResetStreetPreview();
                    if (((((this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ATTACK_BUILDING) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.GET_COMBAT_PREVIEW)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_GARISSON)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.COMBAT3_CHOOSE_UNIT)))
                    {
                        if (this.mMilitaryPathVisible)
                        {
                            if (_local_8 == this.mMilitaryPathStartingPositionGridIdx)
                            {
                                this.mPreviewPathObject = new cPathObject();
                            }
                            else
                            {
                                _local_9 = new Vector.<PFAdditionalData>();
                                _local_9.push(new PFAdditionalData(new GridPosition(_local_8), cBlockingData.BLOCK_TYPE_ALLOW_NOTHING));
                                if (this.mGeneralInterface.isPreviewPathLocked())
                                {
                                    this.mPreviewPathObject = this.mGeneralInterface.mPathFinder.CalculatePath(gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, this.mGeneralInterface.mLockedPreviewPathEndGrid, defines.DIR8_SOUTH_EAST), this.mMilitaryPathStartingPositionGridIdx, _local_9, true);
                                }
                                else
                                {
                                    this.mPreviewPathObject = this.mGeneralInterface.mPathFinder.CalculatePath(gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _local_8, defines.DIR8_SOUTH_EAST), this.mMilitaryPathStartingPositionGridIdx, _local_9, true);
                                    if (((this.mPreviewPathObject.dest_vector.length == 0) && (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_GARISSON)))
                                    {
                                        _local_10 = this.mGeneralInterface.mPathFinder.CalculatePathForWarehouse(gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _local_8, defines.DIR8_SOUTH_EAST), this.mGeneralInterface.mCurrentPlayer.getPlayerID());
                                        if (((!(_local_10 == null)) && (_local_10.dest_vector.length > 0)))
                                        {
                                            this.mPreviewPathObject = this.mGeneralInterface.mPathFinder.CalculatePathForWarehouse(this.mMilitaryPathStartingPositionGridIdx, this.mGeneralInterface.mCurrentPlayer.getPlayerID());
                                            for each (_local_11 in _local_10.dest_vector)
                                            {
                                                this.mPreviewPathObject.AddPathPoint(this.mGeneralInterface, _local_11.streetGridIdx);
                                            };
                                        };
                                    };
                                };
                            };
                            if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ATTACK_BUILDING)
                            {
                                if (this.mPreviewPathObject.pathLenX10000 == 0)
                                {
                                    this.mGeneralInterface.mCurrentCursor.SetCursorGfx(OBJECTTYPE.STREET, "Street_AttackCursor_Disabled");
                                }
                                else
                                {
                                    this.mGeneralInterface.mCurrentCursor.SetCursorGfx(OBJECTTYPE.STREET, "Street_AttackCursor");
                                };
                            }
                            else
                            {
                                if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.GET_COMBAT_PREVIEW)
                                {
                                    if (this.mPreviewPathObject.pathLenX10000 == 0)
                                    {
                                        this.mGeneralInterface.mCurrentCursor.SetCursorGfx(OBJECTTYPE.STREET, "Street_AttackCursor_Disabled");
                                    }
                                    else
                                    {
                                        this.mGeneralInterface.mCurrentCursor.SetCursorGfx(OBJECTTYPE.STREET, "Street_BattlePreviewCursor");
                                    };
                                };
                            };
                            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CreatePreviewPath(this.mPreviewPathObject, cStreet.TYPE_ARMY);
                        };
                    }
                    else
                    {
                        if (((((((!(_local_5 == null)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_GAME)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_DEFENSE_MODE)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_BY_BUFF)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BUILDING)))
                        {
                            if (((!(_local_5 == null)) || (this.mGeneralInterface.mCurrentCursor.IsCursorValid())))
                            {
                                _local_12 = null;
                                _local_13 = null;
                                if (_local_5 != null)
                                {
                                    _local_12 = _local_5.GetBuildingName_string();
                                    if (_arg_3 != "")
                                    {
                                        _local_13 = _arg_3;
                                    }
                                    else
                                    {
                                        _local_13 = _local_5.GetResourceCreationBuildingName_string();
                                    };
                                }
                                else
                                {
                                    if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BUILDING)
                                    {
                                        _local_12 = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetBuildingName_string();
                                        if (_arg_3 != "")
                                        {
                                            _local_13 = _arg_3;
                                        }
                                        else
                                        {
                                            _local_13 = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetResourceCreationBuildingName_string();
                                        };
                                    }
                                    else
                                    {
                                        _local_12 = this.mGeneralInterface.mCurrentCursor.mLevelObject_string;
                                        if (_arg_3 != "")
                                        {
                                            _local_13 = _arg_3;
                                        }
                                        else
                                        {
                                            _local_13 = this.mGeneralInterface.mCurrentCursor.GetCursorGoObject().GetResourceCreationBuildingName_string();
                                        };
                                    };
                                };
                                _local_14 = gEconomics.GetResourcesCreationDefinitionForBuilding(_local_13);
                                if (_local_14 != null)
                                {
                                    _local_9 = new Vector.<PFAdditionalData>();
                                    if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BUILDING)
                                    {
                                        _local_16 = new cPosInt();
                                        gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetGrid(), _local_16);
                                        this.AddBlockingData(this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetGOContainer(), _local_16.x, _local_16.y, cBlockingData.BLOCK_TYPE_ALLOW_ALL, _local_9);
                                    };
                                    _local_15 = global.buildingGroup.mGOListDictionary[_local_12];
                                    if (_local_5 != null)
                                    {
                                        _local_16 = new cPosInt();
                                        gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _local_5.GetGrid(), _local_16);
                                        this.AddBlockingData(_local_15, _local_16.x, _local_16.y, cBlockingData.BLOCK_TYPE_ALLOW_NOTHING, _local_9);
                                    }
                                    else
                                    {
                                        this.AddBlockingData(_local_15, this.mGeneralInterface.mCurrentCursor.GetCursorXPixelPos(), this.mGeneralInterface.mCurrentCursor.GetCursorYPixelPos(), cBlockingData.BLOCK_TYPE_ALLOW_NOTHING, _local_9);
                                    };
                                    _local_7 = _local_8;
                                    do 
                                    {
                                        _local_7 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _local_7, defines.DIR8_SOUTH_EAST);
                                        _local_6 = false;
                                        for each (_local_17 in _local_9)
                                        {
                                            if (((_local_17.left.gridIndex() == _local_7) && (_local_17.right == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING)))
                                            {
                                                _local_6 = true;
                                                break;
                                            };
                                        };
                                    } while (_local_6);
                                    this.mPreviewPathObject = this.mGeneralInterface.mPathFinder.CalculatePathForDestinations(_local_7, this.mGeneralInterface.mPathFinder.GetWarehouseDestinations(_arg_1), _local_9);
                                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CreatePreviewPath(this.mPreviewPathObject, cStreet.TYPE_PRODUCTION_WORKYARD);
                                    this.mPathTime = ((this.mPreviewPathObject.pathLenX20000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT) / this.mGeneralInterface.mGlobalTimeScale);
                                    if (_local_14.externalResource_string != "")
                                    {
                                        if (((_local_15.mAddDepositAmount == -1) && (_local_15.mRestrictPlacingToDeposit == null)))
                                        {
                                            _local_18 = -1;
                                            if (_local_14.amountRemoved >= 0)
                                            {
                                                _local_18 = cPathFinder.AMOUNT_TYPE_ABOVE_ZERO;
                                                this.mIsFillUpBuilding = false;
                                            }
                                            else
                                            {
                                                _local_18 = cPathFinder.AMOUNT_TYPE_BELOW_MAX;
                                                this.mIsFillUpBuilding = true;
                                            };
                                            this.mPreviewPathObject = this.mGeneralInterface.mPathFinder.CalculatePathForDestinations(_local_7, this.mGeneralInterface.mPathFinder.GetDepositDestinations(_local_14.externalResource_string, _arg_1, _local_18), _local_9);
                                            if (this.mPreviewPathObject.pathLenX10000 != 0)
                                            {
                                                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CreatePreviewPath(this.mPreviewPathObject, cStreet.TYPE_PRODUCTION_DEPOSIT);
                                                this.mPathTime = (this.mPathTime + ((this.mPreviewPathObject.pathLenX20000 / cComputeResourceCreation.SETTLER_WALK_SPEED_INT) / this.mGeneralInterface.mGlobalTimeScale));
                                            }
                                            else
                                            {
                                                this.mPathTime = 0;
                                            };
                                        };
                                    }
                                    else
                                    {
                                        this.mPathTime = (this.mPathTime * 2);
                                    };
                                    gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _local_8, this.mTempPos);
                                };
                            };
                        };
                    };
                };
                if (_arg_4)
                {
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.ShowStreetPreview();
                    if (((_local_5 == null) || (this.mForceRenderTransportDuration)))
                    {
                        if (this.mPathTime > 0)
                        {
                            this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (((cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Transportduration") + ":") + "\n") + cLocaManager.GetInstance().FormatDuration(this.mPathTime)), this.mTempPos.x, ((this.mTempPos.y - (global.streetGridY * 2)) + 15));
                        }
                        else
                        {
                            if (this.mPathTime == 0)
                            {
                                this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (((cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Transportduration") + ":") + "\n") + ((this.mIsFillUpBuilding) ? cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DepositFull") : cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "DepositMissing"))), this.mTempPos.x, ((this.mTempPos.y - (global.streetGridY * 2)) + 15));
                            };
                        };
                    };
                };
            }
            else
            {
                if (this.mPreviewPathOldCursorGridIdx != -1)
                {
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.ResetStreetPreview();
                    this.mPreviewPathOldCursorGridIdx = -1;
                };
            };
        }

        private function MoveBuilding(_arg_1:CloseEvent=null):void
        {
            var _local_7:cBuffDefinition;
            var _local_8:dResource;
            var _local_9:cResources;
            var _local_10:dResource;
            var _local_11:cBuilding;
            var _local_2:cBuilding = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding;
            if (_arg_1 == null)
            {
                if (((((_local_2 == null) || (this.mPlayerData == null)) || (this.mPlayerZone == null)) || (this.mCursorGrid == 0)))
                {
                    this.ResetMovedBuilding();
                    return;
                };
            }
            else
            {
                if (((((((!(_arg_1.detail == Alert.OK)) || (_local_2 == null)) || (_local_2.GetMovementCosts() == null)) || (this.mPlayerData == null)) || (this.mPlayerZone == null)) || (this.mCursorGrid == 0)))
                {
                    this.ResetMovedBuilding();
                    return;
                };
            };
            var _local_3:Number = 0;
            if (_local_2.IsUpgradeInProgress())
            {
                _local_7 = _local_2.GetUpgradeLevelBonusesForLevel((_local_2.GetUpgradeLevel() + 1));
                if (_local_7 != null)
                {
                    _local_3 = (_local_7.GetProductionTime() - (this.mGeneralInterface.GetClientTime() - _local_2.GetUpgradeStartTime()));
                    if (_local_3 < defines.MIN_UPGRADE_TIME_TO_MOVE_UPGRADING_BUILDING_FOR_GUI)
                    {
                        CustomAlert.show("MoveBuildingErrorUpgradeTooClose", "MoveBuildingError");
                        this.ResetMovedBuilding();
                        return;
                    };
                };
            };
            var _local_4:ModifiableCost = new ModifiableCost();
            if (this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.mMoveMethod == cBuilding.BUILDING_MOVE_WITH_GEM)
            {
                _local_8 = new dResource();
                _local_8.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_8.amount = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetGemMovementCosts();
                _local_4.cost.push(_local_8);
            }
            else
            {
                _local_4 = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetMovementCosts();
            };
            if (_local_4 != null)
            {
                _local_9 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(this.mPlayerData);
                for each (_local_10 in _local_4.cost)
                {
                    if (!_local_9.HasPlayerResource(_local_10.name_string, _local_10.amount))
                    {
                        ResourceAlert.show("MoveBuildingErrorMissingResources", null, "MoveBuildingError", null, _local_4.cost);
                        cLog.error("Player has not enough resources to move building!");
                        this.ResetMovedBuilding();
                        return;
                    };
                };
            };
            if (((!(this.mGeneralInterface.mCurrentCursor.IsCursorValid())) || (!(this.mPlayerZone.mStreetDataMap.SetPrePlaceBuildingGridPosWithLevel(this.mPlayerData, this.mGeneralInterface.mCurrentCursor.mLevelObject_string, this.mCursorGrid, this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetUpgradeLevel(), _local_2.GetRecurringChance())))))
            {
                cLog.error("Could not move building - illegal position!");
                this.ResetMovedBuilding();
                return;
            };
            if (cLog.isInfoEnabled())
            {
                cLog.info(((((("COMMAND.MOVE_BUILDING, type:" + global.buildingGroup.GetNrFromName(this.mGeneralInterface.mCurrentCursor.mLevelObject_string)) + ", grid:") + this.mCursorGrid) + ", data:") + this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetGrid()));
            };
            cSoundManager.getInstance().playEffect("BuildingPlace");
            this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.SetBuildingMode(cBuilding.BUILDING_MODE_MOVING);
            if ((this.mGeneralInterface.mCurrentCursor.mCurrentBuilding is EpicWorkyardMasterBuilding))
            {
                for each (_local_11 in (this.mGeneralInterface.mCurrentCursor.mCurrentBuilding as EpicWorkyardMasterBuilding).getSubBuildings())
                {
                    _local_11.SetBuildingMode(cBuilding.BUILDING_MODE_MOVING);
                };
            };
            var _local_5:cResourceCreation = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetResourceCreation();
            if (_local_5 != null)
            {
                _local_5.SetKIStateMoving();
            };
            var _local_6:dMoveBuildingVO = new dMoveBuildingVO();
            _local_6.gridPosition = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.GetGrid();
            _local_6.paymentType = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.mMoveMethod;
            this.mGeneralInterface.mCurrentCursor.mCurrentBuilding.SetIsMoveInitiated(true);
            this.mGeneralInterface.SendServerAction(COMMAND.MOVE_BUILDING, global.buildingGroup.GetNrFromName(this.mGeneralInterface.mCurrentCursor.mLevelObject_string), this.mCursorGrid, 0, _local_6);
            globalFlash.gui.mToolboxPanel.buildingMoved();
            this.ResetMovedBuilding();
        }

        public function GetMilitaryPathStartingPositionGridIdx():int
        {
            return (this.mMilitaryPathStartingPositionGridIdx);
        }

        private function ResetMovedBuilding():void
        {
            this.mGeneralInterface.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
            this.mGeneralInterface.mCurrentCursor.mCurrentBuilding = null;
            this.mPlayerData = null;
            this.mPlayerZone = null;
            this.mCursorGrid = 0;
        }

        public function setForceRenderTransportDuration(_arg_1:Boolean):void
        {
            this.mForceRenderTransportDuration = _arg_1;
        }

        public function InitMilitaryPath(_arg_1:int):void
        {
            this.mMilitaryPathStartingPositionGridIdx = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, defines.DIR8_SOUTH_EAST);
            this.mMilitaryPathVisible = true;
        }

        public function MouseMove(_arg_1:cPlayerZoneScreen):Boolean
        {
            return (this.MouseDownOnMap(_arg_1));
        }

        public function Init():void
        {
        }

        public function MouseDownOnMap(_arg_1:cPlayerZoneScreen):Boolean
        {
            return (false);
        }


    }
}
