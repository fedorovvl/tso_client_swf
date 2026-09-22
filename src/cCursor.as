package 
{
    import BuffSystem.cBuff;
    import GO.cSettler;
    import GO.cBuilding;
    import Specialists.cSpecialist;
    import Interface.cGeneralInterface;
    import GO.cGO;
    import nLib.cPosInt;
    import Enums.CURSOR_GRID_MODE;
    import flash.utils.Dictionary;
    import Enums.COMMAND;
    import GO.cBlockingData;
    import Map.AdditionalDataTSO;
    import flash.events.MouseEvent;
    import Enums.CURSOR_VALID;
    import Enums.ERROR_CODES;
    import nLib.gMisc;
    import GO.buildings.cCollectibleBuilding;
    import Enums.CURSOR_PLACABLE;
    import ServerState.cPlayerData;
    import Enums.GO_SUBTYPE;
    import ServerState.dResourceCreationDefinition;
    import Enums.OBJECTTYPE;
    import ServerState.gEconomics;
    import GUI.GAME.cBasicPanel;
    import Utils.StringUtils;
    import Enums.BUFF_TARGET_TYPE;
    import Enums.CURSOR_RENDERMODE;
    import GO.cDeposit;
    import GUI.Components.ToolTips.SkillToolTipData;
    import Utils.ModifiableCost;
    import GUI.Components.ToolTips.cToolTipUtil;
    import mx.managers.ToolTipManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import Map.SubMaps.cBackgroundRectangleDataMap;
    import nLib.cBackbuffer;
    import __AS3__.vec.Vector;
    import Communication.VO.grid.AreaGridVO;
    import GO.cLandscape;
    import flash.display.BlendMode;
    import MilitarySystem.cArmy;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import AdventureSystem.cAdventureDefinition;
    import GUI.GAME.cCombatUIBase;
    import GO.cCombatPreviewPath;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import __AS3__.vec.*;

    public class cCursor 
    {

        private var lastBuff:cBuff = null;
        private var mCursorGridPos:int = -32767;
        private var mCurrentEnumCursorEditMode:int = 3000;
        private var areaBuffToRender:cBuff;
        public var mCurrentSettler:cSettler = null;
        public var mCurrentBuilding:cBuilding = null;
        public var mCurrentSpecialist:cSpecialist = null;
        private var mLastEnumCursorEditMode:int = 3000;
        private var mCursorValidReason:int = 15;
        private var mGeneralInterface:cGeneralInterface;
        public var mCurrentBuff:cBuff = null;
        private var mVisible:Boolean = true;
        public var mLevelObject_string:String;
        private var mGOCursor:cGO = null;
        private var areaBuffOriginToRender:cBuilding;
        private var mLastBuilding:cBuilding = null;
        public var mLevelEnumObjectType:int = 9;

        public var mLastMousePosition:cPosInt = new cPosInt();
        public var mLastConvertedMousePosition:cPosInt = new cPosInt();
        private var mCursorSpritePosition:cPosInt = new cPosInt();
        private var mEnumCursorGridMode:int = CURSOR_GRID_MODE.UNDEFINED;
        private var mTempPos:cPosInt = new cPosInt();
        private var mSuitableAreaBuildingsForGridCache:Dictionary = new Dictionary(true);
        private var mSuitableAreaGridCache:Dictionary = new Dictionary(true);
        private var cacheBuffApplicableGrid:Dictionary = new Dictionary();

        public function cCursor(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function SetToLastEditMode():void
        {
            this.SetCursorEditMode(this.mLastEnumCursorEditMode);
        }

        public function invalidateBuffTarget(_arg_1:int):void
        {
            delete this.cacheBuffApplicableGrid[_arg_1];
        }

        private function IsStreetCursorType():Boolean
        {
            return (this.mCurrentEnumCursorEditMode == COMMAND.SELECT_BUILDING);
        }

        public function SetCursorEditModeObjectName(_arg_1:int, _arg_2:String):void
        {
            this.SetCursorEditModeObjectNameLocal(_arg_1, _arg_2);
        }

        private function SetCursorPosition():void
        {
            if (this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_STREET)
            {
                this.mGOCursor.SetPosition(this.mCursorSpritePosition.x, this.mCursorSpritePosition.y);
            }
            else
            {
                if (this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_FREEPOS)
                {
                    this.mGOCursor.SetPosition(this.mCursorSpritePosition.x, this.mCursorSpritePosition.y);
                }
                else
                {
                    if (this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_BUILDING)
                    {
                        this.mGOCursor.SetPosition(this.mCursorSpritePosition.x, (this.mCursorSpritePosition.y + global.streetGridYHalf));
                    };
                };
            };
        }

        private function markGridForCursor(_arg_1:int):void
        {
            var _local_3:cBlockingData;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_2:cPosInt = new cPosInt();
            gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _local_2);
            for each (_local_3 in this.mGOCursor.GetGOContainer().mBlocking_vector)
            {
                if (_local_3.getBlockingType() == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING)
                {
                    _local_4 = int((_local_2.x + ((_local_3.getXPixelOffset() * global.streetGridX) / 100)));
                    _local_5 = int((_local_2.y + ((_local_3.getYPixelOffset() * global.streetGridY) / 100)));
                    _local_6 = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _local_4, _local_5);
                    _local_7 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_6, AdditionalDataTSO.Cursor);
                    if (_local_7 == 0)
                    {
                        this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.set(_local_6, AdditionalDataTSO.Cursor, 1);
                    }
                    else
                    {
                        if ((_local_7 & 0x08))
                        {
                            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.set(_local_6, AdditionalDataTSO.Cursor, uint(-2).valueOf());
                        };
                    };
                };
            };
        }

        public function MouseMove(_arg_1:MouseEvent):void
        {
            this.mLastMousePosition.x = _arg_1.stageX;
            this.mLastMousePosition.y = _arg_1.stageY;
        }

        public function setAreaBuffToRender(_arg_1:cBuff, _arg_2:cBuilding):void
        {
            this.areaBuffOriginToRender = _arg_2;
            if (_arg_1 != this.areaBuffToRender)
            {
                this.areaBuffToRender = _arg_1;
                this.mSuitableAreaBuildingsForGridCache = new Dictionary(true);
                this.mSuitableAreaGridCache = new Dictionary(true);
            };
        }

        public function CheckIfCursorIsPlacableInGame(_arg_1:int):int
        {
            var _local_2:cBuilding;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Object;
            var _local_7:int;
            if (((((((((this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_BY_BUFF) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_GAME)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)) || (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_BUILDING)) || (this.mCurrentEnumCursorEditMode == COMMAND.BUILD_WAY)) || (this.mCurrentEnumCursorEditMode == COMMAND.BUILD_WAY_SECONDARY)) && (!(this.mGeneralInterface.mIsDefenseMode))))
            {
                _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector);
                _local_4 = 0;
                if (this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector.length > _local_3)
                {
                    _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_3].GetOwnerPlayerID();
                    if (_local_4 < 0)
                    {
                        return (CURSOR_VALID.SECTOR_BELONGS_TO_BANDITS);
                    };
                };
            };
            if (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData2.get(_arg_1, AdditionalDataTSO.Fog) != 0)
            {
                return (CURSOR_VALID.PLACE_IS_COVERED_WITH_FOG);
            };
            if (this.IsInSetBuildingMode())
            {
                _local_5 = this.mGeneralInterface.mCurrentPlayerZone.IsBuildingPlacableGridPosition(this.mGOCursor, this.mGeneralInterface.mCurrentPlayer, _arg_1);
                if (_local_5 != 0)
                {
                    switch (_local_5)
                    {
                        case ERROR_CODES.BUILDING_IS_ON_FOG:
                            return (CURSOR_VALID.BUILDING_PLACED_PLACE_IS_COVERED_WITH_FOG);
                        case ERROR_CODES.PLAYER_IS_NOT_SECTOR_OWNER:
                            return (CURSOR_VALID.SECTOR_DOES_NOT_BELONG_TO_PLAYER);
                        case ERROR_CODES.SECTOR_IS_OWNED_BY_BANDITS:
                            return (CURSOR_VALID.GARISSON_SECTOR_IS_OWNED_BY_BANDITS);
                        case ERROR_CODES.PLACE_IS_NOT_REACHABLE:
                            return (CURSOR_VALID.PLACE_IS_NOT_REACHABLE_BY_PATH_FINDING);
                        case ERROR_CODES.MINE_TYPE_PLACE_IS_BLOCKED:
                            return (CURSOR_VALID.MINE_PLACED_OVER_BUILDING_BUT_IT_IS_NOT_A_DEPLETED_DEPOSIT);
                        case ERROR_CODES.MINE_TYPE_BUILDING_IS_NOT_PLACED_ON_DEPOSIT:
                            return (CURSOR_VALID.MINE_PLACED_NO_DEPOSIT_HERE);
                        case ERROR_CODES.TRY_TO_BUILD_ON_DEPOSIT:
                            return (CURSOR_VALID.BUILDING_PLACED_TRY_TO_PLACE_NORMAL_BUILDING_OVER_DEPOSIT);
                        case ERROR_CODES.PLACE_IS_BLOCKED_BY_BUILDING_IN_LIST:
                            return (CURSOR_VALID.BUILDING_PLACED_BUILDING_IS_IN_LIST_SNH);
                        case ERROR_CODES.PLACE_IS_BLOCKED_BY_BLOCKING_SYSTEM:
                            return (CURSOR_VALID.BUILDING_PLACED_BLOCKED_BY_BLOCKING);
                        default:
                            return (CURSOR_VALID.BUILDING_PLACED_BUILDING_IS_ALREADY_THERE);
                    };
                };
            };
            if (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_GARISSON)
            {
                if (this.mGeneralInterface.mSetBuildings.mMilitaryPathVisible)
                {
                    if (this.mGeneralInterface.mSetBuildings.mPreviewPathObject.pathLenX10000 == 0)
                    {
                        return (CURSOR_VALID.PLACE_IS_NOT_REACHABLE_BY_PATH_FINDING);
                    };
                };
            };
            if (((this.mCurrentEnumCursorEditMode == COMMAND.ATTACK_BUILDING) || (this.mCurrentEnumCursorEditMode == COMMAND.GET_COMBAT_PREVIEW)))
            {
                if (this.mGeneralInterface.mSetBuildings.mMilitaryPathVisible)
                {
                    if (this.mGeneralInterface.mSetBuildings.mPreviewPathObject.pathLenX10000 == 0)
                    {
                        return (CURSOR_VALID.PLACE_IS_NOT_REACHABLE_BY_PATH_FINDING);
                    };
                };
                _local_2 = this.mGeneralInterface.mCurrentPlayerZone.GetBuildingFromGridPosition(_arg_1);
                if (_local_2 == null)
                {
                    return (CURSOR_VALID.ATTACK_MODE_NO_BUILDING_AT_DESTINATION);
                };
                if (!_local_2.getBuildingIsAttackable())
                {
                    return (CURSOR_VALID.ATTACK_MODE_BUILDING_IS_NOT_ATTACKABLE);
                };
                if (_local_2.getPlayerID() == 0)
                {
                    return (CURSOR_VALID.ATTACK_MODE_PLAYER_ID_OF_BUILDING_IS_ZERO_SNH);
                };
                if (_local_2.getPlayerID() == this.mGeneralInterface.mCurrentPlayer.GetPlayerId())
                {
                    return (CURSOR_VALID.ATTACK_MODE_BUILDING_BELONGS_TO_CURRENT_PLAYER);
                };
                if (_local_2.getPlayerID() == this.mGeneralInterface.mHomePlayer.GetPlayerId())
                {
                    return (CURSOR_VALID.ATTACK_MODE_BUILDING_BELONGS_TO_HOMEZONE_PLAYER);
                };
                if (((this.mGeneralInterface.IsAdventureZoneID(this.mGeneralInterface.mCurrentViewedZoneID)) && (_local_2.getPlayerID() > 0)))
                {
                    return (CURSOR_VALID.ATTACK_MODE_ON_ADVENTURE_ZONE_BUT_NOT_PVP);
                };
            };
            if (this.mCurrentEnumCursorEditMode == COMMAND.APPLY_BUFF)
            {
                _local_6 = this.canApplyBuff(this.mGeneralInterface.mCurrentPlayer, this.mGeneralInterface, _arg_1);
                if (!(_local_6 is cGO))
                {
                    return (_local_6 as int);
                };
                if (global.buffingBlockedUntil[_arg_1] > gMisc.GetTimeSinceStartup())
                {
                    return (CURSOR_VALID.APPLY_BUFF_TEMPORARILY_BLOCKED);
                };
            };
            if (this.mCurrentEnumCursorEditMode == COMMAND.SELECT_BUILDING_TO_MOVE)
            {
                _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_1);
                if (_local_2 == null)
                {
                    _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(_arg_1);
                };
                if (_local_2 == null)
                {
                    return (CURSOR_VALID.MOVE_BUILDING_RESTRICTED);
                };
                _local_2 = _local_2.getBuildingSelection();
                if (_local_2.getPlayerID() != this.mGeneralInterface.mCurrentPlayer.GetPlayerId())
                {
                    return (CURSOR_VALID.MOVE_BUILDING_RESTRICTED);
                };
                if ((((_local_2.IsMovable() == false) || (_local_2.IsMoveInitiated())) || (_local_2.IsDestructionInitiated())))
                {
                    return (CURSOR_VALID.MOVE_BUILDING_RESTRICTED);
                };
                if ((((((((_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_QUEUED) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_CONSTRUCTION)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_DESTRUCTION)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_DESTRUCTED)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_PLACED)))
                {
                    return (CURSOR_VALID.MOVE_BUILDING_RESTRICTED);
                };
                if (_local_2.GetMovementCosts() == null)
                {
                    if (((!(_local_2.IsRecurringBuilding())) && (_local_2.GetUpgradeLevel() > 1)))
                    {
                        return (CURSOR_VALID.MOVE_BUILDING_RESTRICTED);
                    };
                };
            };
            if (this.mCurrentEnumCursorEditMode == COMMAND.DELETE_BUILDING)
            {
                _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_1);
                if (_local_2 == null)
                {
                    _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(_arg_1);
                };
                if (_local_2 == null)
                {
                    return (CURSOR_VALID.DELETE_BUILDING_RESTRICTED);
                };
                _local_2 = _local_2.getBuildingSelection();
                if (((!(_local_2.getPlayerID() == this.mGeneralInterface.mCurrentPlayer.GetPlayerId())) && ((!(this.mGeneralInterface.mIsDefenseMode)) || (!(_local_2.getPlayerID() == this.mGeneralInterface.mCurrentViewedZoneID)))))
                {
                    return (CURSOR_VALID.DELETE_BUILDING_RESTRICTED);
                };
                if (((_local_2.IsDestructionInitiated()) || (_local_2.IsMoveInitiated())))
                {
                    return (CURSOR_VALID.DELETE_BUILDING_RESTRICTED);
                };
                if ((((((((_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_QUEUED) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_SET_BUILDING_GROUND_PLACE)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_SETTLER_WALKS_TO_BUILDING_GROUND_PLACE)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_CONSTRUCTION)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_DESTRUCTION)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_DESTRUCTED)) || (_local_2.GetBuildingMode() == cBuilding.BUILDING_MODE_PLACED)))
                {
                    return (CURSOR_VALID.DELETE_BUILDING_RESTRICTED);
                };
                if ((((_local_2.GetBuildingName_string() == defines.MAYORHOUSE_NAME_string) || (_local_2.isGarrison())) || (_local_2.IsLastWarehouseInSector())))
                {
                    return (CURSOR_VALID.DELETE_BUILDING_RESTRICTED);
                };
                if (((_local_2.GetGOContainer().ui == defines.BUILDING_UI_CULTURE) && (_local_2.productionQueue.GetWaitingForServer())))
                {
                    return (CURSOR_VALID.CULTURE_BUILDING_ON_COOLDOWN);
                };
                if (((!(_local_2.IsRecurringBuilding())) && (!(_local_2.IsKnockdownAllowed()))))
                {
                    return (CURSOR_VALID.DELETE_BUILDING_RESTRICTED);
                };
                if ((_local_2 is cCollectibleBuilding))
                {
                    return (CURSOR_VALID.DELETE_BUILDING_RESTRICTED);
                };
            };
            if (this.IsInSetStreetMode())
            {
                _local_7 = this.mGeneralInterface.mCurrentPlayerZone.IsStreetPlacableAtGridPosition(this.mGOCursor, _arg_1);
                if (_local_7 != CURSOR_VALID.OK)
                {
                    return (_local_7);
                };
            };
            if (this.IsPlayerMapGridType())
            {
                if (this.mGOCursor.IsCursorPlacable(_arg_1, this.mEnumCursorGridMode, this.mCurrentEnumCursorEditMode) == CURSOR_PLACABLE.UNPLACABLE)
                {
                    return (CURSOR_VALID.PLACE_IS_BLOCKED_BY_BUILDING);
                };
            };
            if (((this.mCurrentEnumCursorEditMode == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START) || (this.mCurrentEnumCursorEditMode == COMMAND.ADD_BLOCKING_PATH_PREVIEW_START)))
            {
                if (this.mGeneralInterface.mCurrentPlayerZone.IsBuildingPlacableGridPositionWithExlusions(this.mGOCursor, this.mGeneralInterface.mCurrentPlayer, _arg_1, true, true, true, false))
                {
                    return (CURSOR_VALID.BUILDING_PLACED_BLOCKED_BY_BLOCKING);
                };
            };
            return (CURSOR_VALID.OK);
        }

        public function SetCursorVisible(_arg_1:Boolean):void
        {
            this.mVisible = _arg_1;
        }

        private function drawBuffAmount(_arg_1:Number):void
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_2:Number = 0;
            var _local_5:Number = (this.mCursorSpritePosition.x + (this.mGOCursor.mSprite.GetWidth() / 8));
            var _local_6:Number = (this.mCursorSpritePosition.y - (this.mGOCursor.mSprite.GetHeight() / 8));
            if (this.mCurrentBuff.IsExhausted)
            {
                globalFlash.gui.mCancelActionPanel.CancelAction();
                return;
            };
            gGfxResource.mBuildingCountBG.RenderPos(_local_5, _local_6);
            if (_arg_1 > 99)
            {
                gGfxResource.mUpgradeLevelNumbers.SetSubType(9);
                _local_4 = gGfxResource.mUpgradeLevelNumbers.mSprite.GetWidth();
                gGfxResource.mUpgradeLevelNumbers.RenderPos((_local_5 + 1), (_local_6 + 4));
                gGfxResource.mUpgradeLevelNumbers.SetSubType(9);
                _local_3 = gGfxResource.mUpgradeLevelNumbers.mSprite.GetWidth();
                _local_2 = (_local_2 + ((_local_4 + _local_3) / 2));
                _local_4 = _local_3;
                gGfxResource.mUpgradeLevelNumbers.RenderPos(((_local_2 + _local_5) + 1), (_local_6 + 4));
                gGfxResource.mUpgradeLevelNumbers.SetSubType(31);
                _local_3 = gGfxResource.mUpgradeLevelNumbers.mSprite.GetWidth();
                _local_2 = (_local_2 + ((_local_4 + _local_3) / 2));
                _local_4 = _local_3;
                gGfxResource.mUpgradeLevelNumbers.RenderPos(((_local_2 + _local_5) + 1), (_local_6 + 4));
            }
            else
            {
                if (_arg_1 > 9)
                {
                    gGfxResource.mUpgradeLevelNumbers.SetSubType((_arg_1 / 10));
                    _local_4 = gGfxResource.mUpgradeLevelNumbers.mSprite.GetWidth();
                    gGfxResource.mUpgradeLevelNumbers.RenderPos((_local_5 + 6), (_local_6 + 4));
                    gGfxResource.mUpgradeLevelNumbers.SetSubType(((_arg_1 % 10) as int));
                    _local_3 = gGfxResource.mUpgradeLevelNumbers.mSprite.GetWidth();
                    _local_2 = (_local_2 + ((_local_4 + _local_3) / 2));
                    _local_4 = _local_3;
                    gGfxResource.mUpgradeLevelNumbers.RenderPos(((_local_2 + _local_5) + 6), (_local_6 + 4));
                }
                else
                {
                    gGfxResource.mUpgradeLevelNumbers.SetSubType(Math.max(0, _arg_1));
                    gGfxResource.mUpgradeLevelNumbers.RenderPos((_local_5 + 11), (_local_6 + 4));
                };
            };
        }

        public function canApplyBuff(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):Object
        {
            if (this.lastBuff != this.mCurrentBuff)
            {
                this.lastBuff = this.mCurrentBuff;
                this.cacheBuffApplicableGrid = new Dictionary();
            }
            else
            {
                if ((_arg_3 in this.cacheBuffApplicableGrid))
                {
                    return (this.cacheBuffApplicableGrid[_arg_3]);
                };
            };
            return (this.cacheBuffApplicableGrid[_arg_3] = this.mCurrentBuff.IsApplyable(_arg_1, _arg_2, _arg_3));
        }

        public function SetCursorGfx(_arg_1:int, _arg_2:String):void
        {
            this.mGOCursor = cGO.CreateGoFromLevelObject(this.mGeneralInterface.mCurrentPlayer, _arg_1, _arg_2, this.mGeneralInterface);
        }

        public function GetEditMode():int
        {
            return (this.mCurrentEnumCursorEditMode);
        }

        public function CheckIfGarrisonIsPlacableInGame(_arg_1:int, _arg_2:Boolean):int
        {
            var _local_3:int;
            var _local_4:cBuilding;
            var _local_5:Boolean;
            if (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData2.get(_arg_1, AdditionalDataTSO.Fog) != 0)
            {
                return (CURSOR_VALID.PLACE_IS_COVERED_WITH_FOG);
            };
            if (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_GARISSON)
            {
                _local_3 = this.mGeneralInterface.mCurrentPlayerZone.IsGarrisonPlacableGridPosition(this.mGOCursor, this.mGeneralInterface.mCurrentPlayer, _arg_1, _arg_2);
                if (_local_3 != ERROR_CODES.NO_ERROR)
                {
                    switch (_local_3)
                    {
                        case ERROR_CODES.BUILDING_IS_ON_FOG:
                            return (CURSOR_VALID.BUILDING_PLACED_PLACE_IS_COVERED_WITH_FOG);
                        case ERROR_CODES.PLAYER_IS_NOT_SECTOR_OWNER:
                            return (CURSOR_VALID.SECTOR_DOES_NOT_BELONG_TO_PLAYER);
                        case ERROR_CODES.SECTOR_IS_OWNED_BY_BANDITS:
                            return (CURSOR_VALID.GARISSON_SECTOR_IS_OWNED_BY_BANDITS);
                        case ERROR_CODES.PLACE_IS_NOT_REACHABLE:
                            return (CURSOR_VALID.PLACE_IS_NOT_REACHABLE_BY_PATH_FINDING);
                        case ERROR_CODES.MINE_TYPE_PLACE_IS_BLOCKED:
                            return (CURSOR_VALID.MINE_PLACED_OVER_BUILDING_BUT_IT_IS_NOT_A_DEPLETED_DEPOSIT);
                        case ERROR_CODES.MINE_TYPE_BUILDING_IS_NOT_PLACED_ON_DEPOSIT:
                            return (CURSOR_VALID.MINE_PLACED_NO_DEPOSIT_HERE);
                        case ERROR_CODES.TRY_TO_BUILD_ON_DEPOSIT:
                            return (CURSOR_VALID.BUILDING_PLACED_TRY_TO_PLACE_NORMAL_BUILDING_OVER_DEPOSIT);
                        case ERROR_CODES.PLACE_IS_BLOCKED_BY_BUILDING_IN_LIST:
                            return (CURSOR_VALID.BUILDING_PLACED_BUILDING_IS_IN_LIST_SNH);
                        case ERROR_CODES.PLACE_IS_BLOCKED_BY_BLOCKING_SYSTEM:
                            return (CURSOR_VALID.BUILDING_PLACED_BLOCKED_BY_BLOCKING);
                        default:
                            return (CURSOR_VALID.BUILDING_PLACED_BUILDING_IS_ALREADY_THERE);
                    };
                };
                this.markGridForCursor(_arg_1);
            }
            else
            {
                if ((((((((this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_GAME) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_BY_BUFF)) || (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_BUILDING)) || (this.mCurrentEnumCursorEditMode == COMMAND.ADD_BLOCKING_PATH_PREVIEW_START)) || (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START)))
                {
                    _local_5 = false;
                    if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BUILDING)
                    {
                        _local_4 = this.mGeneralInterface.mCurrentCursor.mCurrentBuilding;
                    }
                    else
                    {
                        _local_4 = cBuilding.CreateFromString(this.mGeneralInterface.mCurrentPlayer, global.buildingGroup, this.mLevelObject_string, this.mGeneralInterface);
                        _local_5 = true;
                    };
                    if (((this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_BLOCKING_PATH_PREVIEW_START) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START)))
                    {
                        if (this.mGeneralInterface.mCurrentPlayerZone.IsBuildingPlacableGridPositionWithExlusions(_local_4, this.mGeneralInterface.mCurrentPlayer, _arg_1, false, true, true, false) != ERROR_CODES.NO_ERROR)
                        {
                            if (_local_5)
                            {
                                _local_4.dispose();
                            };
                            return (CURSOR_VALID.BUILDING_PLACED_BLOCKED_BY_BLOCKING);
                        };
                    }
                    else
                    {
                        if (this.mGeneralInterface.mCurrentPlayerZone.IsBuildingPlacableGridPosition(_local_4, this.mGeneralInterface.mCurrentPlayer, _arg_1) != ERROR_CODES.NO_ERROR)
                        {
                            if (_local_5)
                            {
                                _local_4.dispose();
                            };
                            return (CURSOR_VALID.BUILDING_PLACED_BLOCKED_BY_BLOCKING);
                        };
                    };
                    this.markGridForCursor(_arg_1);
                    if (_local_5)
                    {
                        _local_4.dispose();
                    };
                };
            };
            return (CURSOR_VALID.OK);
        }

        public function IsCursorValid():Boolean
        {
            return (this.mCursorValidReason == CURSOR_VALID.OK);
        }

        public function IsACursorGoSubType():Boolean
        {
            return (this.mGOCursor.GetGOContainer().mEnumGoSubType == GO_SUBTYPE.CURSOR);
        }

        public function Init():void
        {
            this.mCursorGridPos = defines.ILLEGAL_INT_POS;
            this.mCursorValidReason = CURSOR_VALID.ILLEGAL_POS;
        }

        public function SetCursorEditMode(_arg_1:int):void
        {
            this.SetCursorEditModeObjectName(_arg_1, null);
        }

        public function RenderUnderBuildings():void
        {
            var _local_1:cGO;
            if (((this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)))
            {
                _local_1 = this.mGeneralInterface.mWatchAreas[this.mGOCursor.GetGOContainer().mWatchAreaId];
                _local_1.SetPosition(int(this.mGOCursor.GetX()), (int(this.mGOCursor.GetY()) - global.streetGridYHalf));
                _local_1.Render();
            };
        }

        public function SetCursor(_arg_1:int, _arg_2:String):void
        {
            this.mLevelEnumObjectType = _arg_1;
            this.mLevelObject_string = _arg_2;
            this.SetCursorGfx(_arg_1, _arg_2);
            this.mCursorGridPos = defines.ILLEGAL_INT_POS;
            this.mCursorValidReason = CURSOR_VALID.ILLEGAL_POS;
            this.ConvertMouseToCursorPos();
            if (this.IsInCursorInfoMode())
            {
                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.InitRenderCursorInfo();
            };
        }

        private function SetCursorEditModeObjectNameLocal(_arg_1:int, _arg_2:String):void
        {
            var _local_3:dResourceCreationDefinition;
            var _local_4:cBuilding;
            var _local_5:cBuilding;
            var _local_6:int;
            var _local_7:cBuilding;
            this.mLastEnumCursorEditMode = this.mCurrentEnumCursorEditMode;
            this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit = false;
            if ((((!(_arg_1 == COMMAND.ADD_BLOCKING_PATH_PREVIEW_TARGET)) && (!(_arg_1 == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START))) && (!(_arg_1 == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET))))
            {
                this.mGeneralInterface.mSetBlockingPathPreview.CancelBlockingPreview();
            };
            if ((((((_arg_1 == COMMAND.SET_BUILDING_IN_GAME) || (_arg_1 == COMMAND.SET_BUILDING_IN_DEFENSE_MODE)) || (_arg_1 == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)) || (_arg_1 == COMMAND.SET_BUILDING_BY_BUFF)) || (_arg_1 == COMMAND.MOVE_BUILDING)))
            {
                if (this.mCurrentEnumCursorEditMode != _arg_1)
                {
                    this.mGeneralInterface.UnselectBuilding();
                    globalFlash.gui.mCancelActionPanel.Show();
                    this.mCurrentEnumCursorEditMode = _arg_1;
                    this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_BUILDING;
                    if (((!(this.mLevelEnumObjectType == OBJECTTYPE.BUILDING)) || (this.IsACursorGoSubType())))
                    {
                        this.SetCursor(OBJECTTYPE.BUILDING, "Farm");
                    };
                };
                _local_3 = gEconomics.GetResourcesCreationDefinitionForBuilding(_arg_2);
                if ((((!(_local_3 == null)) && (!(_local_3.externalResource_string == null))) && (_local_3.externalResource_string.length > 0)))
                {
                    this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit_string = _local_3.externalResource_string;
                    this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit = true;
                };
                return;
            };
            if (_arg_1 == COMMAND.SELECT_BUILDING)
            {
                if (globalFlash.gui.mCancelActionPanel.IsVisible())
                {
                    globalFlash.gui.mCancelActionPanel.Hide();
                };
                if (this.mCurrentEnumCursorEditMode != COMMAND.SELECT_BUILDING)
                {
                    globalFlash.gui.ShowQuestWindowDelayed();
                };
                if ((((this.mLastEnumCursorEditMode == COMMAND.ADD_BLOCKING_PATH_PREVIEW_TARGET) || (this.mLastEnumCursorEditMode == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START)) || (this.mLastEnumCursorEditMode == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET)))
                {
                    this.mGeneralInterface.mSetBlockingPathPreview.CancelBlockingPreview();
                };
                this.mCurrentEnumCursorEditMode = COMMAND.SELECT_BUILDING;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_BUILDING;
                this.setAreaBuffToRender(null, null);
                this.SetCursor(OBJECTTYPE.BUILDING, "BuildingCursorGreen");
                return;
            };
            if (_arg_1 == COMMAND.BUILD_WAY)
            {
                this.mGeneralInterface.UnselectBuilding();
                globalFlash.gui.mCancelActionPanel.Show();
                this.mGeneralInterface.mSetStreets.mSetStartPoint = true;
                this.mCurrentEnumCursorEditMode = COMMAND.BUILD_WAY;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_PathCursor");
                return;
            };
            if (_arg_1 == COMMAND.BUILD_WAY_SECONDARY)
            {
                this.mCurrentEnumCursorEditMode = COMMAND.BUILD_WAY;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_PathCursor");
                return;
            };
            if (_arg_1 == COMMAND.ERASE_WAY)
            {
                globalFlash.gui.mCancelActionPanel.Show();
                this.mCurrentEnumCursorEditMode = COMMAND.ERASE_WAY;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_PathCursor");
                return;
            };
            if (_arg_1 == COMMAND.ATTACK_BUILDING)
            {
                globalFlash.gui.mCancelActionPanel.Show();
                _local_4 = this.mGeneralInterface.GetSelectedBuilding();
                if (_local_4 != null)
                {
                    this.mGeneralInterface.mSetBuildings.InitMilitaryPath(this.mCurrentSpecialist.GetGarrisonGridIdx());
                };
                this.mCurrentEnumCursorEditMode = COMMAND.ATTACK_BUILDING;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_AttackCursor");
                return;
            };
            if (_arg_1 == COMMAND.COMBAT3_CHOOSE_UNIT)
            {
                this.mCurrentEnumCursorEditMode = COMMAND.COMBAT3_CHOOSE_UNIT;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_FREEPOS;
                return;
            };
            if (_arg_1 == COMMAND.GET_COMBAT_PREVIEW)
            {
                globalFlash.gui.mCancelActionPanel.Show();
                _local_5 = this.mGeneralInterface.GetSelectedBuilding();
                if (_local_5 != null)
                {
                    _local_6 = _local_5.GetGrid();
                    this.mGeneralInterface.mSetBuildings.InitMilitaryPath(_local_6);
                };
                this.mCurrentEnumCursorEditMode = COMMAND.GET_COMBAT_PREVIEW;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_BattlePreviewCursor");
                return;
            };
            if (_arg_1 == COMMAND.DELETE_BUILDING)
            {
                globalFlash.gui.mCancelActionPanel.Show();
                cBasicPanel.HideCurrentActivePanel();
                this.mCurrentEnumCursorEditMode = COMMAND.DELETE_BUILDING;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_DeleteBuildingCursor");
                return;
            };
            if (_arg_1 == COMMAND.SELECT_BUILDING_TO_MOVE)
            {
                globalFlash.gui.mCancelActionPanel.Show();
                cBasicPanel.HideCurrentActivePanel();
                this.mCurrentEnumCursorEditMode = COMMAND.SELECT_BUILDING_TO_MOVE;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_MoveBuildingCursor");
                return;
            };
            if (_arg_1 == COMMAND.MOVE_GARISSON)
            {
                globalFlash.gui.mCancelActionPanel.Show();
                _local_7 = this.mGeneralInterface.GetSelectedBuilding();
                if (_local_7 != null)
                {
                    this.mGeneralInterface.mSetBuildings.InitMilitaryPath(_local_7.GetGrid());
                }
                else
                {
                    this.mGeneralInterface.mSetBuildings.mMilitaryPathVisible = false;
                };
                this.mCurrentEnumCursorEditMode = COMMAND.MOVE_GARISSON;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_BUILDING;
                if (this.mCurrentSpecialist != null)
                {
                    this.SetCursor(OBJECTTYPE.BUILDING, this.mCurrentSpecialist.GetSpecialistDescription().getGarrisonName_string());
                }
                else
                {
                    this.SetCursor(OBJECTTYPE.BUILDING, defines.GARRISON_NAME_string);
                };
                return;
            };
            if (_arg_1 == COMMAND.APPLY_BUFF)
            {
                globalFlash.gui.mCancelActionPanel.Show();
                globalFlash.gui.mCombatScenarioToolTip.HideByClick();
                this.setAreaBuffToRender(null, null);
                this.mCurrentEnumCursorEditMode = COMMAND.APPLY_BUFF;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                if (StringUtils.startsWith(this.mCurrentBuff.GetBuffDefinition().GetName_string(), "MountainDemolition"))
                {
                    this.SetCursor(OBJECTTYPE.STREET, "Street_MountainDemolitionCursor");
                }
                else
                {
                    this.SetCursor(OBJECTTYPE.STREET, "Street_BuffCursor");
                };
                if (((this.mCurrentBuff.GetBuffDefinition().GetTargetType() == BUFF_TARGET_TYPE.DEPOSIT) && (!(this.mCurrentBuff.GetResourceName_string() == null))))
                {
                    this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit_string = this.mCurrentBuff.GetResourceName_string();
                    this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit = true;
                };
                return;
            };
            if (_arg_1 == COMMAND.ADD_BLOCKING_PATH_PREVIEW_START)
            {
                globalFlash.gui.mCancelActionPanel.Show();
                this.mCurrentEnumCursorEditMode = COMMAND.ADD_BLOCKING_PATH_PREVIEW_START;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.BUILDING, "GhostGarrison");
                return;
            };
            if (_arg_1 == COMMAND.ADD_BLOCKING_PATH_PREVIEW_TARGET)
            {
                this.mCurrentEnumCursorEditMode = COMMAND.ADD_BLOCKING_PATH_PREVIEW_TARGET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_GhostFlagCursor");
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                return;
            };
            if (_arg_1 == COMMAND.DELETE_BLOCKING_PATH_PREVIEW)
            {
                this.mGeneralInterface.UnselectBuilding();
                this.SetCursor(OBJECTTYPE.STREET, "Street_DeleteBuildingCursor");
                this.mCurrentEnumCursorEditMode = COMMAND.DELETE_BLOCKING_PATH_PREVIEW;
                return;
            };
            if (_arg_1 == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START)
            {
                this.mCurrentEnumCursorEditMode = COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.BUILDING, "GhostGarrison");
                return;
            };
            if (_arg_1 == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET)
            {
                this.mCurrentEnumCursorEditMode = COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET;
                this.mEnumCursorGridMode = CURSOR_GRID_MODE.SET_STREET;
                this.SetCursor(OBJECTTYPE.STREET, "Street_GhostFlagCursor");
                return;
            };
            gMisc.Assert(false, ("unknown cursor mode " + _arg_1));
        }

        public function GetCursorXPixelPos():int
        {
            return (this.mCursorSpritePosition.x);
        }

        private function RenderCursor():void
        {
            var _local_1:int;
            if (this.mGOCursor == null)
            {
                return;
            };
            if (((this.IsPlayerMapGridType()) && (this.mVisible)))
            {
                if (this.IsStreetCursorType())
                {
                    return;
                };
                if (!((this.mCurrentEnumCursorEditMode == COMMAND.APPLY_BUFF) || (this.mCurrentEnumCursorEditMode == COMMAND.COMBAT3_CHOOSE_UNIT)))
                {
                    if (this.mCursorValidReason == CURSOR_VALID.OK)
                    {
                        this.mGOCursor.RenderCursorTypeXY(int(this.mGOCursor.GetX()), int(this.mGOCursor.GetY()), CURSOR_RENDERMODE.PLACABLE);
                    }
                    else
                    {
                        this.mGOCursor.RenderCursorTypeXY(int(this.mGOCursor.GetX()), int(this.mGOCursor.GetY()), CURSOR_RENDERMODE.UNPLACABLE);
                    };
                };
            };
        }

        public function GridPosChanged():void
        {
            var _local_1:cDeposit;
            var _local_2:cBuilding;
            var _local_3:String;
            var _local_4:String;
            var _local_5:SkillToolTipData;
            var _local_6:dResourceCreationDefinition;
            var _local_7:ModifiableCost;
            cToolTipUtil.clearInGameToolTip();
            ToolTipManager.showDelay = 500;
            ToolTipManager.hideDelay = 10000;
            if (this.mCurrentEnumCursorEditMode == COMMAND.SELECT_BUILDING)
            {
                _local_1 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(this.mCursorGridPos);
                _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mCursorGridPos);
                if (((_local_1) && (_local_1.skills.getItems_vector().length > 0)))
                {
                    _local_3 = _local_1.GetAmount().toString();
                    if (((!(_local_2 == null)) && (!(_local_2.GetResourceCreation() == null))))
                    {
                        _local_6 = _local_2.GetResourceCreation().GetResourceCreationDefinition();
                        if ((((!(_local_6 == null)) && (_local_6.externalResource_string == _local_1.GetName_string())) && (_local_6.amountRemoved == 0)))
                        {
                            _local_3 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "Unlimited");
                        };
                    };
                    _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_1.GetName_string());
                    _local_5 = new SkillToolTipData();
                    _local_5.resourceIcon = gAssetManager.GetResourceIcon(_local_1.GetName_string());
                    _local_5.skills = _local_1.skills.getSkillVOs();
                    ToolTipManager.showDelay = 0;
                    ToolTipManager.hideDelay = Infinity;
                    cToolTipUtil.showInGameToolTip(cToolTipUtil.SKILL_LIST_string, ((_local_3 + " ") + _local_4), _local_5);
                };
            }
            else
            {
                if (this.mCurrentEnumCursorEditMode == COMMAND.SELECT_BUILDING_TO_MOVE)
                {
                    _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mCursorGridPos);
                    if (_local_2 == null)
                    {
                        _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(this.mCursorGridPos);
                    };
                    if (((_local_2) && (this.IsCursorValid())))
                    {
                        _local_7 = _local_2.GetMovementCosts();
                        if (((!(_local_7 == null)) && (!(_local_2.GetBuildingName_string() == defines.MAYORHOUSE_NAME_string))))
                        {
                            cToolTipUtil.showInGameToolTip(cToolTipUtil.MOVE_BUILDING_string, "MoveCosts", _local_2);
                        };
                    };
                }
                else
                {
                    if (this.mCurrentEnumCursorEditMode == COMMAND.DELETE_BUILDING)
                    {
                        _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mCursorGridPos);
                        if (_local_2 == null)
                        {
                            _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(this.mCursorGridPos);
                        };
                        if (_local_2 != null)
                        {
                            _local_2 = _local_2.getBuildingSelection();
                        };
                        if (((_local_2) && (_local_2.getPlayerID() == this.mGeneralInterface.mCurrentPlayer.GetPlayerId())))
                        {
                            if (this.IsCursorValid())
                            {
                                if (((_local_2.IsKnockdownAllowed()) && (!(_local_2.isGarrison()))))
                                {
                                    if (_local_2.IsRecurringBuilding())
                                    {
                                        cToolTipUtil.showInGameToolTip(cToolTipUtil.DEMOLISH_BUILDING_string, "KnockDownShopItem");
                                    }
                                    else
                                    {
                                        cToolTipUtil.showInGameToolTip(cToolTipUtil.DEMOLISH_BUILDING_string, "KnockDown", _local_2);
                                    };
                                };
                            }
                            else
                            {
                                if (_local_2.GetBuildingName_string() == defines.MAYORHOUSE_NAME_string)
                                {
                                    cToolTipUtil.showInGameToolTip(cToolTipUtil.DEMOLISH_BUILDING_string, "KnockDownDisabledMayorhouse");
                                }
                                else
                                {
                                    if (_local_2.GetGOContainer().ui == defines.BUILDING_UI_CULTURE)
                                    {
                                        cToolTipUtil.showInGameToolTip(cToolTipUtil.DEMOLISH_BUILDING_string, "KnockDownDisabledCultureOnCooldown");
                                    }
                                    else
                                    {
                                        if (((_local_2.IsLastWarehouseInSector()) && (!(StringUtils.startsWith(_local_2.GetBuildingName_string(), defines.DESTROYABLE_MOUNTAIN_string)))))
                                        {
                                            cToolTipUtil.showInGameToolTip(cToolTipUtil.DEMOLISH_BUILDING_string, "KnockDownDisabledLastWarehouse");
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function ConvertScreenPosToMapPos(_arg_1:cPosInt):void
        {
            if (this.mGOCursor == null)
            {
                return;
            };
            if (!this.mGOCursor.mSprite.GetContainer().isLoaded(this.mGOCursor.mSprite.GetSubType(), int(this.mGOCursor.mSprite.GetAnimFrame())))
            {
                return;
            };
            this.mLastConvertedMousePosition.x = _arg_1.x;
            this.mLastConvertedMousePosition.y = _arg_1.y;
            this.mGeneralInterface.mZoom.InvCalculateScrollPos(this.mLastConvertedMousePosition);
            var _local_2:Number = this.mGOCursor.mSprite.GetContainer().mOriginalScaleFactor;
            if ((((this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_BUILDING) || (this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_FREEPOS)) || (this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_STREET)))
            {
                _arg_1.y = (_arg_1.y + this.mGeneralInterface.mZoom.InvScale((global.streetGridYHalf / _local_2), 1));
            }
            else
            {
                _arg_1.x = (_arg_1.x + this.mGeneralInterface.mZoom.InvScale(((cBackgroundRectangleDataMap.RECTANGLE_ELEMENT_WIDTH / 2) / _local_2), 1));
                _arg_1.y = (_arg_1.y + this.mGeneralInterface.mZoom.InvScale((cBackgroundRectangleDataMap.RECTANGLE_ELEMENT_HEIGHT / _local_2), 1));
            };
            this.mGeneralInterface.mZoom.InvCalculateScrollPos(_arg_1);
            if (this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_BUILDING)
            {
                gCalculations.RestrictPixelPosToStreetGrid(this.mGeneralInterface.mCurrentPlayerZone, _arg_1);
            }
            else
            {
                if (this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_STREET)
                {
                    gCalculations.RestrictPixelPosToStreetGrid(this.mGeneralInterface.mCurrentPlayerZone, _arg_1);
                };
            };
        }

        public function GetCursorYPixelPos():int
        {
            return (this.mCursorSpritePosition.y);
        }

        public function GetCursorGoObject():cGO
        {
            return (this.mGOCursor);
        }

        public function CheckUnclaimedIsland(_arg_1:int):int
        {
            var _local_2:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector);
            if (_local_2 > defines.MAIN_ISLAND_SECTORS)
            {
                return (CURSOR_VALID.OK);
            };
            return (CURSOR_VALID.SECTOR_DOES_NOT_BELONG_TO_PLAYER);
        }

        private function ConvertMouseToCursorPos():void
        {
            this.mCursorSpritePosition.x = this.mLastMousePosition.x;
            this.mCursorSpritePosition.y = this.mLastMousePosition.y;
            this.ConvertScreenPosToMapPos(this.mCursorSpritePosition);
            this.SetCursorPosition();
        }

        public function RenderCursorDebugInfo():void
        {
            this.mGeneralInterface.mCurrentPlayerZone.RenderText(cBackbuffer.mBackBuffer, ("g: " + this.mCursorGridPos), this.mCursorSpritePosition.x, this.mCursorSpritePosition.y);
        }

        public function IsInCursorInfoMode():Boolean
        {
            return ((((((((this.mCurrentEnumCursorEditMode == COMMAND.MOVE_GARISSON) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_GAME)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_BY_BUFF)) || (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_BUILDING)) || (this.mCurrentEnumCursorEditMode == COMMAND.ADD_BLOCKING_PATH_PREVIEW_START)) || (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START));
        }

        private function renderAreaBuff():void
        {
            var _local_4:Vector.<cBuilding>;
            var _local_5:cBuilding;
            var _local_6:Vector.<AreaGridVO>;
            var _local_7:cPosInt;
            var _local_8:AreaGridVO;
            if (((this.areaBuffToRender == null) || (this.areaBuffOriginToRender == null)))
            {
                return;
            };
            var _local_1:String = this.areaBuffToRender.GetBuffDefinition().GetName_string();
            var _local_2:int = this.areaBuffOriginToRender.GetGrid();
            var _local_3:Object = this.areaBuffOriginToRender;
            if (!this.areaBuffToRender.GetBuffDefinition().isIgnoreAreaOrigin())
            {
                _local_3 = this.areaBuffToRender.IsApplyable(this.mGeneralInterface.mCurrentPlayer, this.mGeneralInterface, _local_2);
            };
            if (((cBuff.getIsAreaBuff(_local_1)) && (_local_3 === this.areaBuffOriginToRender)))
            {
                _local_4 = this.mSuitableAreaBuildingsForGridCache[this.mCursorGridPos];
                if (_local_4 == null)
                {
                    _local_4 = this.areaBuffToRender.getSuitableAreaBuildingsForGrid(this.mGeneralInterface.mCurrentPlayer, this.mGeneralInterface, this.areaBuffOriginToRender.GetGrid());
                    this.mSuitableAreaBuildingsForGridCache[this.mCursorGridPos] = _local_4;
                };
                for each (_local_5 in _local_4)
                {
                    _local_5.mIsAreaBuffOver = true;
                };
                _local_6 = this.mSuitableAreaGridCache[this.mCursorGridPos];
                if (_local_6 == null)
                {
                    _local_6 = new Vector.<AreaGridVO>();
                    this.areaBuffToRender.getAreaGrids(this.areaBuffOriginToRender.GetGrid(), _local_6, this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                    this.mSuitableAreaGridCache[this.mCursorGridPos] = _local_6;
                };
                _local_7 = new cPosInt();
                for each (_local_8 in _local_6)
                {
                    gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _local_8.index, _local_7);
                    switch (_local_8.display)
                    {
                        case 1:
                            this.mGeneralInterface.mStreetCursorGrid.SetPosition(_local_7.x, _local_7.y);
                            this.mGeneralInterface.mStreetCursorGrid.Render();
                            break;
                        default:
                            this.mGeneralInterface.mStreetCursorGreen.SetPosition(_local_7.x, _local_7.y);
                            this.mGeneralInterface.mStreetCursorGreen.Render();
                    };
                };
            };
        }

        private function LightGoObject(_arg_1:Boolean, _arg_2:Boolean):void
        {
            var _local_3:cBuilding;
            var _local_4:cLandscape;
            if (this.mCursorValidReason != CURSOR_VALID.OK)
            {
                return;
            };
            if (_arg_1)
            {
                _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mCursorGridPos);
                if (_local_3 != null)
                {
                    if (_local_3.GetBuildingMode() >= cBuilding.BUILDING_MODE_BUILDING_IS_ACTIVE_MIN)
                    {
                        _local_3.RenderTransform(_local_3.GetXInt(), _local_3.GetYInt(), BlendMode.MULTIPLY, 1, 1, 0);
                        _local_3.RenderTransform(_local_3.GetXInt(), _local_3.GetYInt(), BlendMode.ADD, 1, 1, 0);
                    };
                };
            };
            if (_arg_2)
            {
                _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(this.mCursorGridPos);
                if (_local_4 != null)
                {
                    _local_4.RenderTransform(_local_4.GetXInt(), _local_4.GetYInt(), BlendMode.ADD, 1, 1, 0);
                };
            };
        }

        public function SetPosition(_arg_1:int, _arg_2:int):void
        {
            this.mCursorSpritePosition.x = _arg_1;
            this.mCursorSpritePosition.y = _arg_2;
            if (this.mGOCursor == null)
            {
                return;
            };
            var _local_3:int = this.mCursorGridPos;
            this.mCursorGridPos = defines.ILLEGAL_INT_POS;
            this.mCursorValidReason = CURSOR_VALID.OK;
            this.SetCursorPosition();
            if (((this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_STREET) || (this.mEnumCursorGridMode == CURSOR_GRID_MODE.SET_BUILDING)))
            {
                this.mCursorGridPos = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, this.mCursorSpritePosition.x, this.mCursorSpritePosition.y);
            };
            if (this.mCursorGridPos == defines.ILLEGAL_INT_POS)
            {
                this.mCursorValidReason = CURSOR_VALID.ILLEGAL_POS;
                return;
            };
            this.mCursorValidReason = this.CheckIfCursorIsPlacableInGame(this.mCursorGridPos);
            if (_local_3 != this.mCursorGridPos)
            {
                this.GridPosChanged();
            };
        }

        private function IsPlayerMapGridType():Boolean
        {
            return (!(this.mEnumCursorGridMode == CURSOR_GRID_MODE.UNDEFINED));
        }

        public function GetGridPosition():int
        {
            return (this.mCursorGridPos);
        }

        public function IsInSetBuildingMode():Boolean
        {
            return ((((((this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_GAME) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)) || (this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_BY_BUFF)) || (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_BUILDING)) || (this.mCurrentEnumCursorEditMode == COMMAND.MOVE_GARISSON));
        }

        public function SetCursorSpritePosition(_arg_1:int, _arg_2:int):void
        {
            this.mCursorSpritePosition.x = _arg_1;
            this.mCursorSpritePosition.y = _arg_2;
        }

        public function SetCursorGfxWithUpgradeLevel(_arg_1:int, _arg_2:String, _arg_3:int):void
        {
            var _local_5:cBuilding;
            var _local_4:cGO = cGO.CreateGoFromLevelObject(this.mGeneralInterface.mCurrentPlayer, _arg_1, _arg_2, this.mGeneralInterface);
            if (_arg_1 == OBJECTTYPE.BUILDING)
            {
                _local_5 = (_local_4 as cBuilding);
                _local_5.SetUpgradeLevel(_arg_3);
                if (_local_5.mSprite.GetContainer().mNofStreamUpgrades != 0)
                {
                    _local_5.SetSubType(gCalculations.CalculateGFXUpgradeLevel(_arg_3, (_local_5.mSprite.GetContainer().mNofStreamUpgrades - 1)));
                }
                else
                {
                    _local_5.SetSubType(gCalculations.CalculateGFXUpgradeLevel(_arg_3, (_local_5.GetNofSubTypes() - 1)));
                };
            };
            this.mGOCursor = _local_4;
        }

        public function SetGridPosition(_arg_1:int):void
        {
            this.mCursorGridPos = _arg_1;
        }

        public function IsInSetStreetMode():Boolean
        {
            return (((this.mCurrentEnumCursorEditMode == COMMAND.BUILD_WAY) || (this.mCurrentEnumCursorEditMode == COMMAND.BUILD_WAY_SECONDARY)) || (this.mCurrentEnumCursorEditMode == COMMAND.ERASE_WAY));
        }

        public function PostPathRender():void
        {
            if (this.mCurrentEnumCursorEditMode == COMMAND.APPLY_BUFF)
            {
                if (this.mCursorValidReason == CURSOR_VALID.OK)
                {
                    this.mGOCursor.RenderCursorTypeXY(int(this.mGOCursor.GetX()), int(this.mGOCursor.GetY()), CURSOR_RENDERMODE.PLACABLE);
                }
                else
                {
                    this.mGOCursor.RenderCursorTypeXY(int(this.mGOCursor.GetX()), int(this.mGOCursor.GetY()), CURSOR_RENDERMODE.UNPLACABLE);
                };
                if (this.mCurrentBuff != null)
                {
                    this.drawBuffAmount(this.mCurrentBuff.GetInstantAmount());
                };
            }
            else
            {
                if (((this.mCurrentEnumCursorEditMode == COMMAND.SET_BUILDING_BY_BUFF) && (!(this.mCurrentBuff == null))))
                {
                    this.drawBuffAmount(this.mCurrentBuff.GetInstantAmount());
                };
            };
        }

        public function PostRender():void
        {
            var _local_1:cBuilding;
            var _local_2:cArmy;
            var _local_3:cSpecialist;
            var _local_4:int;
            var _local_5:cArmy;
            var _local_6:dAdventureClientInfoVO;
            var _local_7:cAdventureDefinition;
            var _local_8:cCombatUIBase;
            var _local_9:cDeposit;
            var _local_10:Vector.<cCombatPreviewPath>;
            var _local_11:cCombatPreviewPath;
            var _local_12:int;
            var _local_13:String;
            var _local_14:String;
            var _local_15:String;
            var _local_16:Boolean;
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            var _local_20:String;
            var _local_21:dResourceCreationDefinition;
            this.ConvertMouseToCursorPos();
            this.SetPosition(this.mCursorSpritePosition.x, this.mCursorSpritePosition.y);
            this.RenderCursor();
            if (((((((!(this.mCursorValidReason)) == CURSOR_VALID.OK) && (!(this.mCurrentEnumCursorEditMode == COMMAND.COMBAT3_CHOOSE_UNIT))) && (!(this.mLastBuilding == null))) && (_local_1 == null)) && (this.mLastBuilding.GetGOContainer().mMaxUnits > 0)))
            {
                if (globalFlash.gui.mCombat30ToolTip.IsVisible())
                {
                    globalFlash.gui.mCombat30ToolTip.Hide();
                };
                if (globalFlash.gui.mCombatScenarioToolTip.IsVisible())
                {
                    globalFlash.gui.mCombatScenarioToolTip.Hide();
                };
                this.mLastBuilding = null;
            };
            if ((((((this.mCurrentEnumCursorEditMode == COMMAND.SELECT_BUILDING) || (this.mCurrentEnumCursorEditMode == COMMAND.APPLY_BUFF)) || (this.mCurrentEnumCursorEditMode == COMMAND.DELETE_BUILDING)) || (this.mCurrentEnumCursorEditMode == COMMAND.SELECT_BUILDING_TO_MOVE)) || (this.mCurrentEnumCursorEditMode == COMMAND.ATTACK_BUILDING)))
            {
                if (this.mCurrentBuff != null)
                {
                    this.setAreaBuffToRender(this.mCurrentBuff, null);
                };
                if (this.mCursorValidReason == CURSOR_VALID.OK)
                {
                    _local_1 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(this.mCursorGridPos);
                    if (_local_1 == null)
                    {
                        _local_1 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CheckIfBuildingIsSouthSouthEastAndSouthWest(this.mCursorGridPos);
                    };
                    if (_local_1 != null)
                    {
                        _local_1 = _local_1.getBuildingSelection();
                        if (((!(_local_1.getPlayerID() == 0)) && (_local_1.mIsSelectable)))
                        {
                            _local_1.mIsMouseOver = true;
                            if (((this.mCurrentEnumCursorEditMode == COMMAND.APPLY_BUFF) && (!(this.mCurrentBuff == null))))
                            {
                                this.setAreaBuffToRender(this.mCurrentBuff, _local_1);
                            };
                        };
                        if (_local_1.GetGOContainer().mMaxUnits > 0)
                        {
                            if (((_local_1.getPlayerID() > 0) && (!(this.mGeneralInterface.mIsDefenseMode))))
                            {
                                for each (_local_3 in this.mGeneralInterface.mCurrentPlayerZone.GetSpecialists_vector())
                                {
                                    if (_local_3.GetGarrisonGridIdx() == _local_1.GetGrid())
                                    {
                                        _local_2 = _local_3.GetArmy();
                                        break;
                                    };
                                };
                            }
                            else
                            {
                                _local_2 = _local_1.GetArmy();
                            };
                            if (_local_2 != null)
                            {
                                _local_6 = AdventureManager.getInstance().getAdventure(this.mGeneralInterface.mCurrentViewedZoneID);
                                if (_local_6 != null)
                                {
                                    _local_7 = cAdventureDefinition.FindAdventureDefinition(_local_6.adventureName);
                                };
                                if (((((_local_1.getPlayerID() < 0) && (!(_local_1.IsEngagedInCombat()))) && (!(_local_7 == null))) && ((_local_7.IsBuffAdventure()) || ((_local_7.IsMixedAdventure()) && (_local_1.GetArmy().HasInvincibleUnits())))))
                                {
                                    _local_8 = globalFlash.gui.mCombatScenarioToolTip;
                                }
                                else
                                {
                                    _local_8 = globalFlash.gui.mCombat30ToolTip;
                                };
                                if (this.mCurrentEnumCursorEditMode == COMMAND.ATTACK_BUILDING)
                                {
                                    _local_8 = globalFlash.gui.mCombat30ToolTip;
                                    _local_5 = this.mCurrentSpecialist.GetArmy();
                                    if (_local_8.mMode != cCombatUIBase.MODE_PRE_ATTACK)
                                    {
                                        _local_8.SetMode(cCombatUIBase.MODE_PRE_ATTACK);
                                    };
                                }
                                else
                                {
                                    if (_local_8.mMode != cCombatUIBase.MODE_NORMAL)
                                    {
                                        _local_8.SetMode(cCombatUIBase.MODE_NORMAL);
                                    };
                                };
                                if (!_local_8.IsVisible())
                                {
                                    if (((_local_8 == globalFlash.gui.mCombatScenarioToolTip) && (globalFlash.gui.mCombat30ToolTip.IsVisible())))
                                    {
                                        globalFlash.gui.mCombat30ToolTip.Hide();
                                    }
                                    else
                                    {
                                        if (((_local_8 == globalFlash.gui.mCombat30ToolTip) && (globalFlash.gui.mCombatScenarioToolTip.IsVisible())))
                                        {
                                            globalFlash.gui.mCombatScenarioToolTip.HideByClick();
                                        };
                                    };
                                    _local_8.SetData(_local_1, _local_3, _local_2, _local_5, _local_1.GetGrid(), this.mGeneralInterface.mZoom.GetScaleFactor());
                                    _local_8.Show();
                                }
                                else
                                {
                                    if (this.mLastBuilding != _local_1)
                                    {
                                        _local_8.SetData(_local_1, _local_3, _local_2, _local_5, _local_1.GetGrid(), this.mGeneralInterface.mZoom.GetScaleFactor());
                                    };
                                };
                            };
                            this.mLastBuilding = _local_1;
                        };
                    };
                };
                if (this.mCursorGridPos != defines.ILLEGAL_INT_POS)
                {
                    _local_9 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(this.mCursorGridPos);
                    if (!this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mPathsPreviewsContainer.isMoveContextMenuActive())
                    {
                        _local_10 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mPathsPreviewsContainer.getAllPaths(this.mCursorGridPos);
                        for each (_local_11 in _local_10)
                        {
                            _local_11.ShowPath();
                        };
                    };
                    if (_local_9 == null)
                    {
                        _local_12 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBlockingSourceData.get(this.mCursorGridPos, AdditionalDataTSO.BlockingSource);
                        if (-1 != _local_12)
                        {
                            _local_9 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_12);
                        };
                    };
                    if (((!(_local_9 == null)) && (!(_local_9.GetName_string() == null))))
                    {
                        if (!global.hideMouseOverDepositAmount_dictionary.Contains(_local_9.GetName_string()))
                        {
                            if (_local_1 != null)
                            {
                                _local_1.mIsDepositInfoShowing = true;
                            };
                            _local_13 = _local_9.GetContainerName_string();
                            _local_14 = gMisc.GetSubString_string(_local_13, 7, (_local_13.length - 7));
                            _local_15 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_14);
                            _local_16 = true;
                            _local_17 = -(global.streetGridY - 24);
                            _local_18 = int(_local_9.GetX());
                            _local_19 = int(_local_9.GetY());
                            _local_20 = gMisc.ConvertDoubleToString_string(_local_9.GetAmount());
                            _local_1 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_9.GetGrid());
                            if (((!(_local_1 == null)) && (!(_local_1.GetResourceCreation() == null))))
                            {
                                _local_21 = _local_1.GetResourceCreation().GetResourceCreationDefinition();
                                if ((((!(_local_21 == null)) && (_local_21.externalResource_string == _local_9.GetName_string())) && (_local_21.amountRemoved == 0)))
                                {
                                    _local_20 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "Unlimited");
                                };
                            };
                            if (_local_9.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE)
                            {
                                _local_9.RenderPos(_local_18, _local_19);
                                if (_local_16)
                                {
                                    this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, ((_local_20 + " ") + _local_15), _local_18, (_local_19 + _local_17));
                                };
                            }
                            else
                            {
                                _local_9.RenderTransform(_local_18, _local_19, BlendMode.DARKEN, 1, 1, 0);
                                if (_local_16)
                                {
                                    this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (((((("[" + _local_20) + " ") + _local_15) + " in Group: ") + _local_9.GetDepositGroupID()) + "]"), _local_18, (_local_19 + _local_17));
                                };
                            };
                        };
                    }
                    else
                    {
                        if (_local_1 != null)
                        {
                            _local_1.mIsDepositInfoShowing = false;
                        };
                    };
                };
            }
            else
            {
                if (((this.mCurrentEnumCursorEditMode == COMMAND.ATTACK_BUILDING) || (this.mCurrentEnumCursorEditMode == COMMAND.GET_COMBAT_PREVIEW)))
                {
                    if (this.mCursorValidReason == CURSOR_VALID.OK)
                    {
                        this.mGOCursor.RenderCursorTypeXY(this.mCursorSpritePosition.x, this.mCursorSpritePosition.y, CURSOR_RENDERMODE.PLACABLE);
                    }
                    else
                    {
                        this.mGOCursor.RenderCursorTypeXY(this.mCursorSpritePosition.x, this.mCursorSpritePosition.y, CURSOR_RENDERMODE.UNPLACABLE);
                    };
                };
            };
            this.renderAreaBuff();
        }


    }
}
