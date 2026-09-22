package Map
{
    import Model.Notifier;
    import Communication.VO.dTrackedMissionListVO;
    import AdventureSystem.cAdventure;
    import Colony.cColony;
    import SettlerKI.cSettlerManager;
    import Map.SubMaps.cBackgroundRectangleDataMap;
    import Map.SubMaps.cStreetDataMap;
    import __AS3__.vec.Vector;
    import TimedProduction.cTimedProductionQueue;
    import Interface.cGameInterface;
    import Specialists.cSpecialist;
    import flash.utils.Dictionary;
    import Communication.VO.ColonyVO;
    import nLib.cPosInt;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import Interface.cGeneralInterface;
    import flash.display.BitmapData;
    import GO.cBuilding;
    import nLib.gMisc;
    import nLib.cLog;
    import Communication.VO.dUniqueID;
    import Enums.DIRTY_INDICATOR;
    import ServerState.cPlayerData;
    import GO.cSettler;
    import Sound.cSoundManager;
    import flash.events.MouseEvent;
    import MilitarySystem.cArmy;
    import Enums.ARMY_OWNER_TYPE;
    import GO.cDeposit;
    import GO.cBlockingData;
    import PathFinding.PFAdditionalData;
    import nLib.cBackbuffer;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import Communication.VO.dZoneVO;
    import GO.cGO;
    import Enums.OBJECTTYPE;
    import Enums.TIMED_PRODUCTION_TYPE;
    import TimedProduction.cTimedProductionUtl;
    import Enums.GCB_MODE_CLIPPING;
    import GO.cStreet;
    import Specialists.cSpecialistTask_Recover;
    import Specialists.cSpecialistTask_AttackBuilding;
    import Specialists.cSpecialistTask_AttackBuildingNewCombat;
    import Enums.SPECIALIST_TASK_TYPES;
    import Specialists.cSpecialistTaskDefinition;
    import Enums.TASK_PHASES_ATTACK_BUILDING;
    import Enums.TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT;
    import GO.cLandscape;
    import Enums.CURSOR_VALID;
    import ServerState.cResources;
    import MilitarySystem.cSquad;
    import GO.cCombatData;
    import flash.display.Graphics;
    import Model.Notifiers.SpecialistNotifier;
    import Communication.VO.dServerAction;
    import Enums.COMMAND;
    import Enums.ERROR_CODES;
    import Enums.SECTOR_DISCOVERY_TYPE;
    import PathFinding.cPathObject;
    import GO.cWatchData;
    import nLib.cZoom;
    import nLib.cSpriteLibContainer;
    import nLib.AdditionalData;
    import Model.Notifiers.ZoneChannel;
    import GO.cLandingField;
    import Enums.HOMEZONE_SECTOR_TYPE;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import GO.epicWorkyard.EpicWorkyardMasterBuilding;
    import GO.epicWorkyard.EpicWorkyardSubBuilding;
    import Communication.VO.dSpecialistVO;
    import Specialists.cSpecialistTask_TravelToZone;
    import Enums.SPECIALIST_TYPE;
    import Enums.TASK_PHASES_TRAVEL_TO_ZONE;
    import __AS3__.vec.*;

    public class cPlayerZoneScreen extends Notifier 
    {

        public static const HOME_ZONE_string:String = "Home";

        public var mTrackedMissionList:dTrackedMissionListVO = null;
        private var mAdventure:cAdventure = null;
        private var mRunningColony:cColony = null;
        public var mShowDeposit:Boolean;
        public var mStreetMapMinUsableY:int = 0;
        public var mStreetMapMinUsableX:int = 0;
        public var mSectorStartX:int = 0;
        public var mSectorStartY:int = 0;
        public var mClearBackGround:Boolean = false;
        public var mMouseMapScrolling:Boolean;
        public var mStreetMapFinalAnd:int = 0;
        public var mSettlerKIManager:cSettlerManager = null;
        public var mBackgroundDataMap:cBackgroundRectangleDataMap;
        public var mAdventureName:String = null;
        public var mMapWidth:int = 0;
        private var alternativeWater:Boolean = false;
        public var mZoneColorSchema:String = null;
        public var mStreetDataMap:cStreetDataMap;
        public var filter:int;
        public var mBackgoundMapWidth:int = 0;
        public var mShowDeposit_string:String = null;
        public var m8DirectionTableStreetGridDirection_vector:Vector.<cVectorListInt> = null;
        private var productionQueue_vector:Vector.<cTimedProductionQueue>;
        protected var mBackgroundHasChanged:Boolean;
        private var mErrorLastXMLElement:String;
        public var mSectorEndX:int = 0;
        public var CLEAR_COLOR:uint = 4151151;
        public var mMapHeight:int = 0;
        protected var mBackgroundHasChangedClear:Boolean;
        private var mGeneralInterface:cGameInterface;
        public var mSectorEndY:int = 0;
        private var mMouseDeltaScrollx:int = 0;
        private var mMouseDeltaScrolly:int = 0;
        public var mGoSetListAnimationManager:cGoSetListAnimationManager = null;
        public var mBackgoundMapHeight:int = 0;
        public var mStreetMapMaxUsableX:int = 0;
        public var mStreetMapMaxUsableY:int = 0;
        public var mMapScrolled:Boolean;

        public const mSectorList_vector:Vector.<cSector> = new Vector.<cSector>();
        public const map_PlayerID_Army:Object = new Object();
        private const map_PlayerID_Resources:Object = new Object();
        private const mSpecialists_vector:Vector.<cSpecialist> = new Vector.<cSpecialist>();
        public var mHiredTroopsPool:Dictionary = new Dictionary();
        private var mColoniesVO:Vector.<ColonyVO> = new Vector.<ColonyVO>();
        private var mTempPoint:cPosInt = new cPosInt();
        private var mTempRect:Rectangle = new Rectangle();
        private var mLastGOCursor:Point = new Point();

        public function cPlayerZoneScreen(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = (_arg_1 as cGameInterface);
        }

        public function RenderText(_arg_1:BitmapData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            this.mTempPoint.x = _arg_3;
            this.mTempPoint.y = _arg_4;
            this.mGeneralInterface.mZoom.CalculateScrollPos(this.mTempPoint);
            _arg_3 = this.mTempPoint.x;
            _arg_4 = this.mTempPoint.y;
            globalFlash.gui.WriteDebugText(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public function clearProductionQueue():void
        {
            if (null != this.productionQueue_vector)
            {
                this.productionQueue_vector.length = 0;
            };
        }

        public function DepositWasDepleted(_arg_1:cPlayerData, _arg_2:int, _arg_3:String):void
        {
            var _local_4:cBuilding = cBuilding.CreateFromString(_arg_1, global.buildingGroup, (defines.MINEDEPOSITDEPLETED_NAME_string + _arg_3), this.mGeneralInterface);
            gMisc.Assert((!(_local_4.IsMovable())), "Depleted deposits can't be movable");
            if (!this.mStreetDataMap.SetBuildingGridPos(_local_4, _arg_2, false))
            {
                cLog.error(((((("Z:" + this.mGeneralInterface.mCurrentViewedZoneID) + " P:") + _arg_1.getPlayerID()) + " could not place depleted deposit on grid position ") + _arg_2));
                return;
            };
            _local_4.SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
            var _local_5:GridPosition = new GridPosition(_arg_2, this.mMapWidth);
            _local_4.SetUniqueId(new dUniqueID().Init(_local_5.X(), _local_5.Y()));
            _local_4.mDirtyIndicator.created();
            if (_local_4.GetResourceCreation() != null)
            {
                _local_4.GetResourceCreation().mDirtyIndicator = (_local_4.GetResourceCreation().mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            };
            this.SetLandscapeObjectToDepositHidden(_arg_1, _arg_2, _arg_3);
        }

        public function isAdventure():Boolean
        {
            return (!(this.GetAdventure() == null));
        }

        public function MouseClick(_arg_1:MouseEvent):void
        {
            var _local_2:cSettler;
            if (this.mMapScrolled)
            {
                this.mMapScrolled = false;
                return;
            };
            this.mGeneralInterface.mSetStreets.MouseClickOnMap(this.mGeneralInterface.mCurrentPlayer, this);
            this.mGeneralInterface.mSetBuildings.MouseClickOnMap(this.mGeneralInterface.mCurrentPlayer, this);
            this.mGeneralInterface.mSetBlockingPathPreview.MouseClickOnMap(this.mGeneralInterface.mCurrentPlayer, this);
            if (this.mGeneralInterface.mCurrentCursor.mCurrentSettler != null)
            {
                _local_2 = this.mGeneralInterface.mCurrentCursor.mCurrentSettler;
                if (_local_2.GetGOContainer().mGfxResourceListName_string == "RAVING_RABBID")
                {
                    cSoundManager.getInstance().playEffect("SelectBuilding", "statueRabbid");
                };
            };
        }

        public function GetArmy(_arg_1:int):cArmy
        {
            var _local_2:cArmy = (this.map_PlayerID_Army[_arg_1] as cArmy);
            if (_local_2 == null)
            {
                _local_2 = new cArmy(this.mGeneralInterface.mCurrentViewedZoneID, _arg_1, ARMY_OWNER_TYPE.ZONE, this);
                this.map_PlayerID_Army[_arg_1] = _local_2;
            };
            return (_local_2);
        }

        public function AddDepositIcon(_arg_1:String, _arg_2:int):void
        {
            this.mGoSetListAnimationManager.AddSingleAnimation(_arg_2, _arg_1, 0, 0, (global.streetGridY / 2), global.guiIconGroup, null);
        }

        public function MouseUp(_arg_1:MouseEvent):void
        {
            this.mMouseMapScrolling = false;
        }

        public function GetRunningColony():cColony
        {
            return (this.mRunningColony);
        }

        public function LevelBackgroundHasChanged():void
        {
            this.mGeneralInterface.mCurrentPlayerZone.SetBackgroundHasChanged(true);
        }

        public function setProductionQueue(_arg_1:cTimedProductionQueue):void
        {
            var _local_2:int = (this.productionQueue_vector.length - 1);
            while (_local_2 >= 0)
            {
                if (this.productionQueue_vector[_local_2].mProductionType == _arg_1.mProductionType)
                {
                    this.productionQueue_vector.splice(_local_2, 1);
                };
                _local_2--;
            };
            this.productionQueue_vector.push(_arg_1);
        }

        public function LogicCompute():void
        {
            this.mStreetDataMap.LogicCompute();
            var _local_1:int;
            while (_local_1 < this.productionQueue_vector.length)
            {
                this.productionQueue_vector[_local_1].Perform(this.mGeneralInterface.mHomePlayer);
                _local_1++;
            };
            this.mGeneralInterface.mCheckTimedTriggerCount = ((this.mGeneralInterface.mCheckTimedTriggerCount + 1) % global.checkProductionValueTriggerInterval);
            if (this.mGeneralInterface.mCheckTimedTriggerCount == 0)
            {
                this.mGeneralInterface.getTimedTriggerManager().check();
                this.mGeneralInterface.channels.TICK.delayedCompute();
            };
        }

        public function SetPlayerForSector(_arg_1:int, _arg_2:int):void
        {
            var _local_3:cSector;
            var _local_4:int;
            var _local_5:int;
            var _local_6:cDeposit;
            for each (_local_3 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
            {
                if (_local_3.GetSectorID() == _arg_1)
                {
                    _local_3.SetOwnerPlayerID(_arg_2);
                };
            };
            _local_4 = 0;
            while (_local_4 < this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.size())
            {
                _local_5 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_4, AdditionalDataTSO.Sector);
                if (_local_5 == _arg_1)
                {
                    _local_6 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_4);
                    if (_local_6 != null)
                    {
                        _local_6.SetPlayerID(_arg_2);
                    };
                };
                _local_4++;
            };
        }

        public function CacheBackgroundScroll():void
        {
            this.CacheBackground(false);
        }

        public function BackgroundDataMap_GridCallBack(_arg_1:Function, _arg_2:int, _arg_3:Boolean):void
        {
            this.mBackgroundDataMap.GridCallBack(_arg_1, _arg_2, _arg_3);
        }

        private function checkGarissonGridPosition(_arg_1:cBuilding, _arg_2:int):Boolean
        {
            var _local_6:cBlockingData;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:cBuilding;
            var _local_12:int;
            var _local_13:PFAdditionalData;
            var _local_3:Vector.<cBlockingData> = _arg_1.GetGOContainer().mBlocking_vector;
            var _local_4:cPosInt = new cPosInt();
            gCalculations.ConvertStreetGridToPixelPos(this, _arg_2, _local_4);
            var _local_5:Vector.<PFAdditionalData> = new Vector.<PFAdditionalData>();
            for each (_local_6 in _local_3)
            {
                _local_7 = int((_local_4.x + ((_local_6.getXPixelOffset() * global.streetGridX) / 100)));
                _local_8 = int((_local_4.y + ((_local_6.getYPixelOffset() * global.streetGridY) / 100)));
                _local_9 = gCalculations.ConvertPixelPosToStreetGridPos(this, _local_7, _local_8);
                if (_local_9 != defines.ILLEGAL_INT_POS)
                {
                    _local_10 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBlocked(_local_9);
                    _local_11 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_9);
                    _local_12 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBlockingSourceData.get(_local_9, AdditionalDataTSO.BlockingSource);
                    if (((_local_10 == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING) && ((!(_local_11 == null)) || ((!(_local_12 == -1)) && (!(this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_12) == null))))))
                    {
                        return (false);
                    };
                    if (_local_6.getBlockingType() == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING)
                    {
                        _local_13 = new PFAdditionalData(new GridPosition(_local_9), cBlockingData.BLOCK_TYPE_ALLOW_NOTHING);
                        _local_5.push(_local_13);
                    };
                };
            };
            return (true);
        }

        public function getSpecialistByGarrison(_arg_1:int):cSpecialist
        {
            var _local_2:cSpecialist;
            for each (_local_2 in this.mSpecialists_vector)
            {
                if (_local_2.GetGarrisonGridIdx() == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function SendDestructBuildingCommandByGridIndex(_arg_1:int, _arg_2:String):Boolean
        {
            var _local_3:cBuilding = this.mStreetDataMap.mBuildingContainer.get(_arg_1);
            return (this.SendDestructBuildingCommand(_local_3, _arg_2));
        }

        public function Clear():void
        {
            if (null != this.mBackgroundDataMap)
            {
                this.mBackgroundDataMap.Clear();
            };
            this.ClearOnTheFly();
        }

        public function getSpecialist(_arg_1:int, _arg_2:dUniqueID):cSpecialist
        {
            var _local_3:cSpecialist;
            for each (_local_3 in this.mSpecialists_vector)
            {
                if (((_local_3.getPlayerID() == _arg_1) && (_local_3.GetUniqueID().eq(_arg_2))))
                {
                    return (_local_3);
                };
            };
            return (null);
        }

        public function Init(_arg_1:dZoneVO):void
        {
            if (this.mStreetDataMap != null)
            {
                this.mStreetDataMap.dispose();
            };
            this.mMapWidth = _arg_1.mapWidth;
            this.mMapHeight = _arg_1.mapHeight;
            this.mBackgoundMapWidth = _arg_1.backgoundMapWidth;
            this.mBackgoundMapHeight = _arg_1.backgoundMapHeight;
            this.mStreetMapMinUsableX = _arg_1.streetMapMinUsableX;
            this.mStreetMapMaxUsableX = _arg_1.streetMapMaxUsableX;
            this.mStreetMapMinUsableY = _arg_1.streetMapMinUsableY;
            this.mStreetMapMaxUsableY = _arg_1.streetMapMaxUsableY;
            gCalculations.InitWidthZone(this);
            this.mGeneralInterface.mZoom.setScrollRange(this.mStreetMapMaxUsableX, this.mStreetMapMaxUsableY);
            this.mBackgroundDataMap = new cBackgroundRectangleDataMap(this.mGeneralInterface, _arg_1.backgoundMapWidth, _arg_1.backgoundMapHeight);
            this.mStreetDataMap = new cStreetDataMap(this.mGeneralInterface, _arg_1);
            this.mSettlerKIManager = new cSettlerManager(this.mGeneralInterface);
            this.productionQueue_vector = new Vector.<cTimedProductionQueue>();
            this.mGoSetListAnimationManager = new cGoSetListAnimationManager(this.mGeneralInterface);
            this.mGeneralInterface.showIsoGrid = false;
            this.mGeneralInterface.showBuildingDebugGrid = false;
            this.mGeneralInterface.showIsoDebugGrid = false;
            this.mSectorStartX = (((this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX - 1) * global.streetGridX) - global.streetGridXHalf);
            this.mSectorStartY = ((this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY - 1) * global.streetGridYHalf);
            this.mSectorEndX = (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX * global.streetGridX);
            this.mSectorEndY = ((this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY * global.streetGridYHalf) + global.streetGridYHalf);
            this.mBackgroundDataMap.Init();
            this.mBackgroundDataMap.setAlternativeWater(this.alternativeWater);
            cBackbuffer.InitSegmentBuffer(false);
            cBackbuffer.SetRedirectToSegmentBuffer(true);
            cBackbuffer.Clear(this.CLEAR_COLOR);
            cBackbuffer.SetRedirectToSegmentBuffer(false);
            this.mStreetDataMap.Init();
            this.mSettlerKIManager.Init();
            this.mShowDeposit = false;
            this.mMouseMapScrolling = false;
            this.mMapScrolled = false;
            this.mMouseDeltaScrollx = 0;
            this.mMouseDeltaScrolly = 0;
            this.SetBackgroundHasChanged(true);
            var _local_2:dAdventureClientInfoVO = AdventureManager.getInstance().getAdventure(_arg_1.zoneOwnerPlayerID);
            if (_local_2 != null)
            {
                this.mAdventureName = _local_2.adventureName;
            }
            else
            {
                this.mAdventureName = HOME_ZONE_string;
            };
        }

        public function GetPlayerColorIdx(_arg_1:int):int
        {
            if (_arg_1 < 0)
            {
                return (13);
            };
            var _local_2:int = this.mGeneralInterface.GetPlayerListPositionFromId(_arg_1);
            return (_local_2 % 12);
        }

        public function setAlternativeWater(_arg_1:Boolean):void
        {
            this.alternativeWater = _arg_1;
        }

        public function RemoveAtGridPosition(_arg_1:cPlayerData, _arg_2:int, _arg_3:int):Boolean
        {
            var _local_6:cBuilding;
            var _local_7:cBuilding;
            var _local_4:cGO = this.IsAtGridPosition(_arg_2, _arg_3);
            if (_local_4 == null)
            {
                return (false);
            };
            var _local_5:Boolean;
            if (_arg_2 == OBJECTTYPE.BACKGROUND)
            {
                _local_5 = this.mBackgroundDataMap.RemoveGridPos(_arg_3);
                this.LevelBackgroundHasChanged();
            }
            else
            {
                if (_arg_2 == OBJECTTYPE.LANDSCAPE)
                {
                    _local_5 = this.mStreetDataMap.RemoveLandscapeGridPos(_arg_3);
                }
                else
                {
                    if (_arg_2 == OBJECTTYPE.DEPOSIT)
                    {
                        _local_5 = this.mStreetDataMap.RemoveDepositGridPos(_arg_3, true);
                    }
                    else
                    {
                        if (_arg_2 == OBJECTTYPE.STREET)
                        {
                            _local_5 = this.mStreetDataMap.RemoveStreetGridPos(_arg_3);
                            this.LevelBackgroundHasChanged();
                        }
                        else
                        {
                            if (_arg_2 == OBJECTTYPE.BUILDING)
                            {
                                _local_6 = (_local_4 as cBuilding);
                                this.mGeneralInterface.mCurrentPlayerZone.RemoveWatchArea(_arg_2, _local_6.GetBuildingName_string(), _local_6);
                                _local_6.SetBuildingMode(cBuilding.BUILDING_MODE_DESTRUCTED);
                                if (_arg_1 != null)
                                {
                                    this.SetHiddenDepositAtRemovingBuilding(_arg_1, _arg_3, _local_6);
                                };
                                _local_5 = this.mStreetDataMap.RemoveBuildingGridPos(_arg_3, true);
                                if (((!(_local_6.productionQueue == null)) && (0 == this.mGeneralInterface.mZoneBuffManager.getNumberOfExtraBuildingBuffs(_local_6.GetBuildingName_string()))))
                                {
                                    _local_6.productionQueue.cancelAll(_arg_1);
                                    if (TIMED_PRODUCTION_TYPE.isCultureBuilding(_local_6.productionQueue.mProductionType))
                                    {
                                        new cTimedProductionUtl(this.mGeneralInterface).cancelAllZoneBuffProductions(_local_6.productionQueue.mProductionType);
                                    };
                                };
                                this.mGeneralInterface.mPathFinder.InvalidateAll(_local_6.getPlayerID());
                                this.mGeneralInterface.mPathFinder.InvalidateAll(this.mGeneralInterface.mCurrentPlayer.GetPlayerId());
                                for each (_local_7 in this.mStreetDataMap.GetBuildings_vector())
                                {
                                    if (null != _local_7)
                                    {
                                        if (_local_7.GetResourceCreation() != null)
                                        {
                                            _local_7.GetResourceCreation().SetInvalidatePaths(true);
                                        };
                                    };
                                };
                                this.mStreetDataMap.UpdateObjectPositions();
                            };
                        };
                    };
                };
            };
            if (_local_5)
            {
                _local_4.dispose();
                this.mStreetDataMap.CalculateBlockingGrid();
                return (true);
            };
            return (false);
        }

        public function ColonyAdd(_arg_1:ColonyVO):void
        {
            this.mColoniesVO.push(_arg_1);
        }

        public function CacheBackground(_arg_1:Boolean):void
        {
            var _local_2:Number = this.mGeneralInterface.mZoom.GetScrollPosX();
            var _local_3:Number = this.mGeneralInterface.mZoom.GetScrollPosY();
            if (cBackbuffer.ACTIVATE_SEGMENTBUFFER)
            {
                this.mGeneralInterface.mZoom.SetScrollPos(0, 0, false);
                cBackbuffer.SetRedirectToSegmentBuffer(true);
                cBackbuffer.setScreenPosition(int(_local_2), int(_local_3));
                if (_arg_1)
                {
                    cBackbuffer.Clear(this.mGeneralInterface.mCurrentPlayerZone.CLEAR_COLOR);
                }
                else
                {
                    cBackbuffer.RemoveUnusedSegments(int(_local_2), int(_local_3), this.mGeneralInterface.mCurrentPlayerZone.CLEAR_COLOR);
                };
                this.mBackgroundDataMap.Render(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_BACKGROUND);
                cBackbuffer.SetRedirectToSegmentBuffer(false);
                if (((this.mGeneralInterface.showFogOfWar) && ((this.mStreetDataMap.useAnnoOnlineFog) || (this.mStreetDataMap.useContinentalFog))))
                {
                    cBackbuffer.preRenderFogCache();
                    this.mStreetDataMap.renderFogAnno(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_BACKGROUND);
                    this.mStreetDataMap.RenderFogBackground(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_BACKGROUND);
                    cBackbuffer.postRenderFogCache();
                };
            };
            this.mGeneralInterface.mZoom.SetScrollPos(_local_2, _local_3);
        }

        public function RenderTextCenter(_arg_1:BitmapData, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            this.mTempPoint.x = _arg_3;
            this.mTempPoint.y = _arg_4;
            this.mGeneralInterface.mZoom.CalculateScrollPos(this.mTempPoint);
            _arg_3 = this.mTempPoint.x;
            _arg_4 = this.mTempPoint.y;
            globalFlash.gui.WriteDebugTextCenter(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        private function CheckBlocking(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:String):Boolean
        {
            var _local_8:cBlockingData;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:cBlockingData;
            var _local_14:cBlockingData;
            var _local_15:cStreet;
            var _local_5:Vector.<cBlockingData> = cGO.GetBlockingList(OBJECTTYPE.BUILDING, _arg_1);
            var _local_6:Vector.<cBlockingData>;
            if (_arg_4 != null)
            {
                _local_6 = cGO.GetBlockingList(OBJECTTYPE.BUILDING, _arg_4);
            };
            var _local_7:int;
            for each (_local_8 in _local_5)
            {
                if (_arg_4 != null)
                {
                    _local_13 = null;
                    for each (_local_14 in _local_6)
                    {
                        if ((((((!(_local_8.getBlockingType() == cBlockingData.BLOCK_TYPE_ALLOW_WATERBUILD)) && (!(_local_8.getBlockingType() == cBlockingData.BLOCK_TYPE_ALLOW_SAFE))) && (_local_8.getXPixelOffset() == _local_14.getXPixelOffset())) && (_local_8.getYPixelOffset() == _local_14.getYPixelOffset())) && (_local_8.getBlockingType() == _local_14.getBlockingType())))
                        {
                            _local_13 = _local_14;
                            break;
                        };
                    };
                    if (_local_13 != null) continue;
                };
                _local_9 = int((_arg_2 + ((_local_8.getXPixelOffset() * global.streetGridX) / 100)));
                _local_10 = int((_arg_3 + ((_local_8.getYPixelOffset() * global.streetGridY) / 100)));
                _local_11 = gCalculations.ConvertPixelPosToStreetGridPos(this, _local_9, _local_10);
                _local_12 = this.mStreetDataMap.GetBlockType(_local_11);
                switch (_local_8.getBlockingType())
                {
                    case cBlockingData.BLOCK_TYPE_ALLOW_NOTHING:
                        _local_7++;
                        if ((((((!(_local_12 == cBlockingData.BLOCK_TYPE_ALLOW_ALL)) && (!(_local_12 == cBlockingData.BLOCK_TYPE_ALLOW_WATERBUILD))) && (!(_local_12 == cBlockingData.BLOCK_TYPE_ALLOW_SAFE))) || (_local_12 == cBlockingData.BLOCK_TYPE_ALLOW_MOVE)) || (!(this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_11) == null))))
                        {
                            if (cLog.isInfoEnabled())
                            {
                            };
                            return (false);
                        };
                        _local_15 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mStreetContainer.get(_local_11);
                        if (_local_15 != null)
                        {
                            if (cLog.isInfoEnabled())
                            {
                            };
                            return (false);
                        };
                        break;
                    case cBlockingData.BLOCK_TYPE_ALLOW_WATERBUILD:
                        _local_7++;
                        if (_local_12 != cBlockingData.BLOCK_TYPE_ALLOW_WATERBUILD)
                        {
                            if (cLog.isInfoEnabled())
                            {
                            };
                            return (false);
                        };
                        break;
                    case cBlockingData.BLOCK_TYPE_ALLOW_STREETS:
                        if (((((_local_12 == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING) || (_local_12 == cBlockingData.BLOCK_TYPE_ALLOW_WATERBUILD)) || (_local_12 == cBlockingData.BLOCK_TYPE_ALLOW_SAFE)) || (_local_12 == cBlockingData.BLOCK_TYPE_ALLOW_MOVE)))
                        {
                            if (cLog.isInfoEnabled())
                            {
                            };
                            return (false);
                        };
                        break;
                    case cBlockingData.BLOCK_TYPE_ALLOW_SAFE:
                        _local_7++;
                        if (_local_12 != cBlockingData.BLOCK_TYPE_ALLOW_SAFE)
                        {
                            if (cLog.isInfoEnabled())
                            {
                            };
                            return (false);
                        };
                        break;
                    case cBlockingData.BLOCK_TYPE_ALLOW_MOVE:
                        if (cLog.isInfoEnabled())
                        {
                        };
                        return (false);
                };
            };
            return (true);
        }

        public function Exit():void
        {
            this.Clear();
        }

        private function getRecoveryTimeFor(_arg_1:cSpecialist):int
        {
            var _local_3:cSpecialistTask_Recover;
            var _local_4:cSpecialistTask_AttackBuilding;
            var _local_5:cSpecialistTask_AttackBuildingNewCombat;
            var _local_2:cSpecialistTaskDefinition = global.specialistTaskDefinitions_vector[SPECIALIST_TASK_TYPES.RECOVER];
            if ((_arg_1.GetTask() is cSpecialistTask_Recover))
            {
                _local_3 = (_arg_1.GetTask() as cSpecialistTask_Recover);
                return (_local_3.GetNeededTime() - _local_3.GetCollectedTime());
            };
            if ((_arg_1.GetTask() is cSpecialistTask_AttackBuilding))
            {
                _local_4 = (_arg_1.GetTask() as cSpecialistTask_AttackBuilding);
                if (((_local_4.GetTaskPhase() >= TASK_PHASES_ATTACK_BUILDING.RETURN_TO_GARRISON) && (_local_4.hasLostBattle())))
                {
                    return (_local_2.subtasks_vector[0].duration);
                };
            }
            else
            {
                if ((_arg_1.GetTask() is cSpecialistTask_AttackBuildingNewCombat))
                {
                    _local_5 = (_arg_1.GetTask() as cSpecialistTask_AttackBuildingNewCombat);
                    if (((_local_5.GetTaskPhase() >= TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.RETURN_TO_GARRISON) && (_local_5.hasLostBattle())))
                    {
                        return (_local_2.subtasks_vector[0].duration);
                    };
                };
            };
            return (0);
        }

        public function GetSector(_arg_1:int):cSector
        {
            var _local_2:cSector;
            for each (_local_2 in this.mSectorList_vector)
            {
                if (_local_2.GetSectorID() == _arg_1)
                {
                    return (_local_2);
                };
            };
            gMisc.Assert(false, (("Sector with ID: " + _arg_1) + " not found!"));
            return (null);
        }

        public function SetAtGridPosition(_arg_1:cPlayerData, _arg_2:int, _arg_3:String, _arg_4:int):cGO
        {
            var _local_5:cGO;
            _local_5 = cGO.CreateGoFromLevelObject(_arg_1, _arg_2, _arg_3, this.mGeneralInterface);
            _local_5 = this.SetGoAtGridPosition(_arg_1, _local_5, _arg_2, _arg_4);
            return (_local_5);
        }

        public function ColonyRemove(_arg_1:int):void
        {
            var _local_2:int;
            while (_local_2 < this.mColoniesVO.length)
            {
                if (this.mColoniesVO[_local_2].colonyId == _arg_1)
                {
                    this.mColoniesVO.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function IsStreetPlacableAtGridPosition(_arg_1:cGO, _arg_2:int):int
        {
            var _local_5:int;
            var _local_6:cLandscape;
            if (this.mStreetDataMap.IsFogAtGridPosition(_arg_2))
            {
                cLog.info("FALSE: Fog of war is there!");
                return (CURSOR_VALID.SET_STREET_COVERED_WITH_FOG);
            };
            var _local_3:cStreet = (_arg_1 as cStreet);
            if (_local_3 != null)
            {
                _local_5 = this.mSectorList_vector[this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_2, AdditionalDataTSO.Sector)].GetOwnerPlayerID();
                if (_local_5 < 0)
                {
                    return (CURSOR_VALID.SET_STREET_SECTOR_IS_OWNED_BY_BANDITS);
                };
                if (this.mGeneralInterface.mCurrentPlayer.getPlayerID() != _local_5)
                {
                    return (CURSOR_VALID.SET_STREET_SECTOR_IS_NOT_OWNED_BY_PLAYER);
                };
                _local_6 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(_arg_2);
                if (_local_6 != null)
                {
                    if (this.IsDepositFoundType(_local_6.GetContainerName_string()))
                    {
                        return (CURSOR_VALID.SET_STREET_PLACE_IS_BLOCKED_BY_DEPOSIT);
                    };
                };
            };
            var _local_4:int = this.mStreetDataMap.GetBlockType(_arg_2);
            if (((_local_4 == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING) || (_local_4 == cBlockingData.BLOCK_TYPE_ALLOW_MOVE)))
            {
                return (CURSOR_VALID.SET_STREET_PLACE_IS_BLOCKED_BY_BLOCKING);
            };
            return (CURSOR_VALID.OK);
        }

        public function ScrollTo(_arg_1:int, _arg_2:int, _arg_3:Number):void
        {
            this.mGeneralInterface.mZoom.SetScrollPos(_arg_1, _arg_2);
            this.SetBackgroundHasChanged(true);
        }

        public function getResourcesFromCurrentZone():cResources
        {
            return (this.GetResourcesForPlayerID(this.mGeneralInterface.mCurrentPlayer.GetPlayerId()));
        }

        public function DestroyBuildingByAttack(_arg_1:cBuilding, _arg_2:cPlayerData):int
        {
            var _local_4:Vector.<cBuilding>;
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:cBuilding;
            var _local_8:int;
            var _local_9:cBuilding;
            var _local_10:int;
            var _local_11:cSquad;
            var _local_12:cCombatData;
            var _local_3:int;
            this.RemoveAtGridPosition(_arg_1.mPlayerData, OBJECTTYPE.BUILDING, _arg_1.GetGrid());
            if (_arg_1.IsWarehouseType())
            {
                _local_4 = new Vector.<cBuilding>();
                _local_5 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_1.GetGrid(), AdditionalDataTSO.Sector);
                _local_6 = false;
                for each (_local_7 in this.mStreetDataMap.GetBuildings_vector())
                {
                    if (null != _local_7)
                    {
                        _local_8 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_7.GetGrid(), AdditionalDataTSO.Sector);
                        if (_local_8 == _local_5)
                        {
                            if (_local_7.IsWarehouseType())
                            {
                                _local_6 = true;
                                break;
                            };
                            _local_4.push(_local_7);
                        };
                    };
                };
                if (!_local_6)
                {
                    for each (_local_9 in _local_4)
                    {
                        if (_local_9.shouldDestroyBuildingFromUnexploredSector())
                        {
                            if (_local_9.getPlayerID() < 0)
                            {
                                _local_3++;
                                if (cLog.isInfoEnabled())
                                {
                                    cLog.info(("DestroyBuildingByAttack(): Remove enemy building " + _local_9));
                                };
                                this.RemoveWatchArea(OBJECTTYPE.BUILDING, _local_9.GetBuildingName_string(), _local_9);
                                _local_9.SetBuildingMode(cBuilding.BUILDING_MODE_DESTRUCTED);
                                for each (_local_11 in _local_9.GetArmy().GetSquads_vector())
                                {
                                    _arg_2.AddXP((_local_11.GetUnitBase().GetXP() * _local_11.GetAmount()));
                                    _arg_2.AddPvPXp((_local_11.GetUnitBase().GetPvPXP() * _local_11.GetAmount()));
                                };
                                this.SetHiddenDepositAtRemovingBuilding(_local_9.mPlayerData, _arg_1.GetGrid(), _local_9);
                                this.mStreetDataMap.RemoveBuildingGridPos(_local_9.GetGrid(), true);
                                this.mStreetDataMap.RemoveBuildingFromGameLogic(_local_9);
                                _local_12 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.get(_local_9.GetGrid());
                                if (_local_12 != null)
                                {
                                    _local_12.dispose();
                                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mCombatContainer.remove(_local_9.GetGrid());
                                };
                            };
                        };
                    };
                    _local_10 = this.GetSectorOwnerPlayerID(_local_5);
                    this.SetPlayerForSector(_local_5, 0);
                    this.mGeneralInterface.channels.ZONE.sectorLiberated(_local_5, _arg_2.getPlayerID());
                    this.mGeneralInterface.mPathFinder.InvalidateAll(_local_10);
                    this.mStreetDataMap.CalculateBlockingGrid();
                    this.mStreetDataMap.CalculateBorders();
                    this.SetBackgroundHasChanged(true);
                };
            };
            if (_arg_1 != null)
            {
                _arg_1.executeOnDestroyEffects();
            };
            return (_local_3);
        }

        public function IsDepositFoundType(_arg_1:String):Boolean
        {
            var _local_3:String;
            var _local_2:int = defines.DEPOSITFOUND_NAME_string.length;
            if (_arg_1.length >= _local_2)
            {
                _local_3 = gMisc.GetSubString_string(_arg_1, 0, defines.DEPOSITFOUND_NAME_string.length);
                if (_local_3 == defines.DEPOSITFOUND_NAME_string)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function AddLandscape(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):cGO
        {
            var _local_4:cGO = this.mGeneralInterface.mCurrentPlayerZone.SetAtGridPosition(_arg_1, OBJECTTYPE.LANDSCAPE, _arg_2, _arg_3);
            (_local_4 as cLandscape).mDirtyIndicator = ((_local_4 as cLandscape).mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            return (_local_4);
        }

        public function IsGarrisonPlacableGridPosition(_arg_1:cGO, _arg_2:cPlayerData, _arg_3:int, _arg_4:Boolean):int
        {
            return (this.IsBuildingPlacableGridPositionWithExlusions(_arg_1, _arg_2, _arg_3, false, false, _arg_4, false));
        }

        public function ColonyClear():void
        {
            this.mColoniesVO.length = 0;
        }

        public function IsAtGridPosition(_arg_1:int, _arg_2:int):cGO
        {
            if (_arg_1 == OBJECTTYPE.BACKGROUND)
            {
                return (this.mBackgroundDataMap.mMap_list[_arg_2]);
            };
            if (_arg_1 == OBJECTTYPE.LANDSCAPE)
            {
                return (this.mStreetDataMap.mLandscapeContainer.get(_arg_2));
            };
            if (_arg_1 == OBJECTTYPE.DEPOSIT)
            {
                return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_2));
            };
            if (_arg_1 == OBJECTTYPE.STREET)
            {
                return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mStreetContainer.get(_arg_2));
            };
            if (_arg_1 == OBJECTTYPE.BUILDING)
            {
                return (this.mStreetDataMap.mBuildingContainer.get(_arg_2));
            };
            return (null);
        }

        public function SetBlockingByTypeAndPosition(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:GridPosition):void
        {
            var _local_7:cBlockingData;
            var _local_8:int;
            var _local_9:int;
            var _local_6:Vector.<cBlockingData> = cGO.GetBlockingList(_arg_1, _arg_2);
            for each (_local_7 in _local_6)
            {
                _local_8 = int((_arg_3 + ((_local_7.getXPixelOffset() * global.streetGridX) / 100)));
                _local_9 = int((_arg_4 + ((_local_7.getYPixelOffset() * global.streetGridY) / 100)));
                this.mStreetDataMap.SetBlockingPixelPos(_local_8, _local_9, _local_7.getBlockingType(), _arg_5);
            };
        }

        public function GetProductionQueue_vector():Vector.<cTimedProductionQueue>
        {
            return (this.productionQueue_vector);
        }

        public function GetAdventureName_string():String
        {
            if (this.mAdventure != null)
            {
                return (this.mAdventure.GetName_string());
            };
            return (null);
        }

        public function SaveZoneStartZoom():void
        {
            var _local_1:cMapPos = new cMapPos();
            _local_1.mScrollposX = this.mGeneralInterface.mZoom.GetScrollPosX();
            _local_1.mScrollposY = this.mGeneralInterface.mZoom.GetScrollPosY();
            _local_1.mZoomScaleFactor = this.mGeneralInterface.mZoom.GetScaleFactor();
            this.mGeneralInterface.mLastZoomPos[this.mGeneralInterface.mHomePlayer.GetHomeZoneId()] = _local_1;
        }

        public function SetRunningColony(_arg_1:cColony):void
        {
            this.mRunningColony = _arg_1;
        }

        public function SetHiddenDepositAtRemovingBuilding(_arg_1:cPlayerData, _arg_2:int, _arg_3:cBuilding):void
        {
            var _local_4:String = _arg_3.GetGOContainer().mHiddenLandscape;
            if (_local_4 != null)
            {
                this.SetLandscapeObjectToDepositHidden(_arg_1, _arg_2, _local_4);
            };
        }

        public function ClearOnTheFly():void
        {
            if (null != this.mStreetDataMap)
            {
                this.mStreetDataMap.Clear();
                this.mStreetDataMap.ClearDeposits();
            };
            if (null != this.mSettlerKIManager)
            {
                this.mSettlerKIManager.Clear();
            };
            this.SetBackgroundHasChanged(true);
            if (null != this.mGoSetListAnimationManager)
            {
                this.mGoSetListAnimationManager.Reset();
            };
        }

        public function RenderOverlayGraphics(_arg_1:Graphics):void
        {
            this.mSettlerKIManager.RenderSettlerDebugInfo(_arg_1);
            this.mStreetDataMap.BuildingRenderBuildingDebugInfo(_arg_1);
            this.mStreetDataMap.RenderIsoElementDebugInfo(_arg_1);
            this.mStreetDataMap.BuildingAndLandscapeDebugInfo(_arg_1);
        }

        public function IsBuildingOnMap(_arg_1:String):Boolean
        {
            var _local_3:cBuilding;
            var _local_2:Vector.<cBuilding> = this.mStreetDataMap.getBuildingsByName_vector(_arg_1);
            if (_local_2 != null)
            {
                for each (_local_3 in _local_2)
                {
                    if (((_local_3.IsBuildingActive()) && (!(_local_3.IsDestructionInitiated()))))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function UpdatePositions():void
        {
            if (null != this.mStreetDataMap)
            {
                this.mStreetDataMap.UpdateObjectPositions();
            };
            if (null != this.mBackgroundDataMap)
            {
                this.mBackgroundDataMap.UpdatePositions();
            };
        }

        public function GetAmountOfSpecialists(_arg_1:int, _arg_2:int):int
        {
            var _local_4:cSpecialist;
            var _local_3:int;
            for each (_local_4 in this.mSpecialists_vector)
            {
                if (((_local_4.getPlayerID() == _arg_1) && (_local_4.GetType() == _arg_2)))
                {
                    _local_3++;
                };
            };
            return (_local_3);
        }

        public function IsBuildingPlacableGridPosition(_arg_1:cGO, _arg_2:cPlayerData, _arg_3:int):int
        {
            return (this.IsBuildingPlacableGridPositionWithExlusions(_arg_1, _arg_2, _arg_3, false, false, false, false));
        }

        public function ColonyGetAll():Vector.<ColonyVO>
        {
            return (this.mColoniesVO);
        }

        public function GetAdventure():cAdventure
        {
            return (this.mAdventure);
        }

        public function RenderTextCenterBackground(_arg_1:BitmapData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            this.mTempPoint.x = _arg_3;
            this.mTempPoint.y = _arg_4;
            this.mGeneralInterface.mZoom.CalculateScrollPos(this.mTempPoint);
            _arg_3 = this.mTempPoint.x;
            _arg_4 = this.mTempPoint.y;
            globalFlash.gui.WriteDebugTextCenterBackground(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function GetAmountOfBaseSpecialists(_arg_1:int, _arg_2:int):int
        {
            var _local_4:cSpecialist;
            var _local_3:int;
            for each (_local_4 in this.mSpecialists_vector)
            {
                if (((_local_4.getPlayerID() == _arg_1) && (_local_4.GetBaseType() == _arg_2)))
                {
                    _local_3++;
                };
            };
            return (_local_3);
        }

        public function GetResources(_arg_1:cPlayerData):cResources
        {
            if (_arg_1 != null)
            {
                return (this.GetResourcesForPlayerID(_arg_1.GetPlayerId()));
            };
            return (null);
        }

        public function RenderScreenInfo():void
        {
        }

        public function GetBuildingFromGridPosition(_arg_1:int):cBuilding
        {
            return (this.mStreetDataMap.mBuildingContainer.get(_arg_1));
        }

        public function HasLandingPosition():Boolean
        {
            return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandingFields_vector.length > 0);
        }

        public function GetTotalUnitsOnMap(_arg_1:int):int
        {
            var _local_4:cSpecialist;
            var _local_2:int;
            var _local_3:cArmy = this.GetArmy(_arg_1);
            if (_local_3 != null)
            {
                _local_2 = (_local_2 + _local_3.GetUnitsCount());
            };
            for each (_local_4 in this.GetSpecialists_vector())
            {
                if (((_local_4.getPlayerID() == _arg_1) && (!(_local_4.isTravellingAway()))))
                {
                    _local_2 = (_local_2 + _local_4.GetArmy().GetUnitsCount());
                };
            };
            return (_local_2);
        }

        public function RenderCompute():void
        {
            this.mStreetDataMap.RenderCompute();
            this.mGoSetListAnimationManager.RenderCompute();
            if (this.mGeneralInterface.mCalculateEconomy)
            {
                this.mSettlerKIManager.RenderCompute();
            };
        }

        public function AddResources(_arg_1:cResources):void
        {
            if (this.map_PlayerID_Resources[_arg_1.GetPlayerID()] != null)
            {
                this.GetResourcesForPlayerID(_arg_1.GetPlayerID()).setResources(_arg_1);
            }
            else
            {
                this.map_PlayerID_Resources[_arg_1.GetPlayerID()] = _arg_1;
            };
        }

        public function GetSectorsClaimedAmount(_arg_1:int):int
        {
            var _local_3:cSector;
            var _local_2:int;
            for each (_local_3 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
            {
                if (_local_3.GetOwnerPlayerID() == _arg_1)
                {
                    _local_2++;
                };
            };
            return (_local_2);
        }

        public function isFreePlacableDepletedDeposit(_arg_1:String):Boolean
        {
            return (global.buildingGroup.IsReplaceable(_arg_1));
        }

        public function addSpecialist(_arg_1:cSpecialist):void
        {
            var _local_3:cSquad;
            var _local_2:cSpecialist = this.getSpecialist(_arg_1.getPlayerID(), _arg_1.GetUniqueID());
            if (_local_2 != null)
            {
                if (_local_2.GetArmy().GetUnitsCount() == 0)
                {
                    for each (_local_3 in _arg_1.GetArmy().GetSquads_vector())
                    {
                        _local_2.GetArmy().AddSquadVO(_local_3.CreateSquadVO(), true);
                    };
                };
                cLog.error(((("Duplicated specialist " + _arg_1.GetUniqueID()) + " for player ") + _arg_1.getPlayerID()));
                return;
            };
            this.mSpecialists_vector.push(_arg_1);
            notifyPropertyObserver("mSpecialists_vector", _arg_1);
            this.mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.SPECIALIST_OWNED_LIST_string, _arg_1);
        }

        public function BuildingDataMap_GridCallBack(_arg_1:Function, _arg_2:int, _arg_3:Boolean):void
        {
            this.mStreetDataMap.BuildingGridCallBack(_arg_1, _arg_2, _arg_3);
        }

        public function SendDestructBuildingCommand(_arg_1:cBuilding, _arg_2:String):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            if (_arg_1.IsWaitForCommand())
            {
                return (false);
            };
            _arg_1.SetIsDestructionInitiated(true);
            _arg_1.SetIsWaitForCommand(true);
            var _local_3:dServerAction = new dServerAction();
            _local_3.grid = _arg_1.GetGrid();
            _local_3.data = _arg_2;
            this.mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.DESTRUCT_BUILDING, this.mGeneralInterface.mCurrentViewedZoneID, _local_3);
            if (_arg_1.shouldPlayDestroyEffect())
            {
                cSoundManager.getInstance().playEffect("BuildingDestroy");
            };
            if (_arg_1.GetBuildingName_string() == defines.LOGISTICS_NAME_string)
            {
                globalFlash.gui.mTradeWindow.deleteAllPlacedTrades();
            };
            return (true);
        }

        public function GetSectorOwnerPlayerID(_arg_1:int):int
        {
            var _local_2:cSector;
            for each (_local_2 in this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector)
            {
                if (_local_2.GetSectorID() == _arg_1)
                {
                    return (_local_2.GetOwnerPlayerID());
                };
            };
            gMisc.Assert(false, (("Sector with ID: " + _arg_1) + " not found!"));
            return (-1);
        }

        public function IsSpecialWarehousePlacableGridPosition(_arg_1:int, _arg_2:cPlayerData, _arg_3:cPathObject):int
        {
            var _local_4:int = this.mStreetDataMap.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector);
            if (_local_4 <= defines.MAIN_ISLAND_SECTORS)
            {
                return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
            };
            if (_arg_3.dest_vector.length == 0)
            {
                if (_arg_2.GetSectorDiscovery(_local_4) != SECTOR_DISCOVERY_TYPE.ACTIVATED_BY_BUFF)
                {
                    return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
                };
            };
            return (0);
        }

        public function ScrollToGrid(_arg_1:int):void
        {
            var _local_2:cPosInt = new cPosInt();
            gCalculations.ConvertStreetGridToPixelPos(this, _arg_1, _local_2);
            this.ScrollTo(_local_2.x, _local_2.y, 0);
        }

        public function RemoveWatchArea(_arg_1:int, _arg_2:String, _arg_3:cBuilding):void
        {
            var _local_8:cWatchData;
            var _local_9:int;
            var _local_10:int;
            var _local_4:int = cGO.GetWatchAreaId(_arg_1, _arg_2);
            if (_local_4 <= 0)
            {
                return;
            };
            var _local_5:Vector.<cWatchData> = global.watchAreas_vector[_local_4];
            var _local_6:int = _arg_3.GetXInt();
            var _local_7:int = (_arg_3.GetYInt() - global.streetGridYHalf);
            for each (_local_8 in _local_5)
            {
                _local_9 = int((_local_6 + ((_local_8.getXPixelOffset() * global.streetGridX) / 100)));
                _local_10 = int((_local_7 + ((_local_8.getYPixelOffset() * global.streetGridY) / 100)));
                this.mStreetDataMap.RemoveWatchpoint(_local_9, _local_10, _arg_3);
            };
        }

        public function IsPositionInsideZone(_arg_1:int, _arg_2:int):Boolean
        {
            return ((((_arg_1 >= this.mSectorStartX) && (_arg_1 <= this.mSectorEndX)) && (_arg_2 >= this.mSectorStartY)) && (_arg_2 <= this.mSectorEndY));
        }

        public function GetResourcesForPlayerID(_arg_1:int):cResources
        {
            return (this.map_PlayerID_Resources[_arg_1]);
        }

        public function Render():void
        {
            var _local_2:int;
            var _local_3:cDeposit;
            if (cBackbuffer.ACTIVATE_SEGMENTBUFFER)
            {
                if (this.mBackgroundHasChanged)
                {
                    cBackbuffer.SetClippingXYWH(this.mGeneralInterface.mZoom.InvScale(this.mGeneralInterface.mZoom.GetScrollPosX(), cZoom.HUNDRED_PERCENT_ZOOM), this.mGeneralInterface.mZoom.InvScale(this.mGeneralInterface.mZoom.GetScrollPosY(), cZoom.HUNDRED_PERCENT_ZOOM), global.screenWidth, global.screenHeight);
                    this.CacheBackground(this.mBackgroundHasChangedClear);
                    cBackbuffer.SetDefaultClipping();
                    this.mBackgroundHasChanged = false;
                };
                this.mTempRect.x = this.mGeneralInterface.mZoom.InvScale(this.mGeneralInterface.mZoom.GetScrollPosX(), cZoom.HUNDRED_PERCENT_ZOOM);
                this.mTempRect.y = this.mGeneralInterface.mZoom.InvScale(this.mGeneralInterface.mZoom.GetScrollPosY(), cZoom.HUNDRED_PERCENT_ZOOM);
                this.mTempRect.width = cBackbuffer.GetWidth();
                this.mTempRect.height = cBackbuffer.GetHeight();
                cBackbuffer.CopyFromSegmentBuffer(this.mTempRect);
            }
            else
            {
                this.mBackgroundDataMap.Render(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND);
            };
            this.mStreetDataMap.RenderFreeBackgroundAnimated(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_BACKGROUND);
            if (!this.mClearBackGround)
            {
                this.mBackgroundDataMap.setAlternativeWater(this.alternativeWater);
                this.mBackgroundDataMap.RenderWaterBorder(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND);
            };
            var _local_1:cBuilding = this.mGeneralInterface.GetSelectedBuilding();
            if ((((((!(this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_GAME)) && (!(this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_BY_BUFF))) && (!(this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_DEFENSE_MODE))) && (!(this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF))) && (!(this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.APPLY_BUFF))))
            {
                this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit = false;
            };
            if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.BUILD_WAY)
            {
                this.mGeneralInterface.mSetStreets.ShowStreetsInRealTime(this.mGeneralInterface.mCurrentPlayer);
            };
            if (this.mGeneralInterface.showIsoGrid)
            {
                this.mStreetDataMap.RenderGrid();
            };
            if (((!(_local_1 == null)) && (_local_1.GetGOContainer().mWatchAreaId > 0)))
            {
                this.mStreetDataMap.RenderWatchAreaOfSelectedBuilding(_local_1);
            };
            if (((!(this.mMouseMapScrolling)) && ((this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ATTACK_BUILDING) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.GET_COMBAT_PREVIEW))))
            {
                this.mStreetDataMap.ShowWatchAreaPreview();
            };
            if (((this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_DEFENSE_MODE) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF)))
            {
                this.mStreetDataMap.ShowAllWatchAreaPreview();
            };
            this.mGeneralInterface.mCurrentCursor.RenderUnderBuildings();
            if (_local_1 != null)
            {
                if (_local_1.GetResourceCreation() != null)
                {
                    if ((((!(_local_1.GetResourceCreation().GetResourceCreationDefinition() == null)) && (!(_local_1.GetResourceCreation().GetResourceCreationDefinition().externalResource_string == null))) && (_local_1.GetResourceCreation().GetResourceCreationDefinition().externalResource_string.length > 0)))
                    {
                        this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit_string = _local_1.GetResourceCreation().GetResourceCreationDefinition().externalResource_string;
                        this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit = true;
                    };
                }
                else
                {
                    if (_local_1.GetGOContainer().mAddDepositAmount != -1)
                    {
                        _local_2 = _local_1.GetGrid();
                        _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_local_2);
                        if (_local_3 != null)
                        {
                            this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit_string = _local_3.GetName_string();
                            this.mGeneralInterface.mCurrentPlayerZone.mShowDeposit = true;
                        };
                    };
                };
            };
            cSpriteLibContainer.mActivateAntialiasing = true;
            this.mGeneralInterface.mCurrentCursor.mCurrentSettler = null;
            this.mStreetDataMap.RenderBuildingsWithSettlers(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND);
            this.mGoSetListAnimationManager.Render();
            if (this.mShowDeposit)
            {
                if (this.mShowDeposit_string.length > 0)
                {
                    this.mStreetDataMap.RenderDepositsGame(this.mShowDeposit_string);
                }
                else
                {
                    this.mStreetDataMap.RenderDepositsAll();
                };
            }
            else
            {
                if (this.mGeneralInterface.showDepositMap)
                {
                    this.mStreetDataMap.RenderDepositsAll();
                };
            };
            cSpriteLibContainer.mActivateAntialiasing = false;
            if (this.mGeneralInterface.mCurrentCursor.IsInCursorInfoMode())
            {
                this.mStreetDataMap.RenderCursorInfo();
            }
            else
            {
                this.mStreetDataMap.RenderSelectBuildingInfo();
            };
            this.mGeneralInterface.mSetBlockingPathPreview.ShowPreview();
            this.mGeneralInterface.mCombatPersitedPreview.RenderPreviewPaths();
            if (!this.mMouseMapScrolling)
            {
                this.mGeneralInterface.mCurrentCursor.PostRender();
                this.mGeneralInterface.mSetBuildings.ShowPreviewPath(this.mGeneralInterface.mCurrentPlayer.GetPlayerId(), (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_GARISSON));
                this.mGeneralInterface.mCurrentCursor.PostPathRender();
            };
            if (cBackbuffer.ACTIVATE_SEGMENTBUFFER)
            {
                this.mTempRect.x = (this.mGeneralInterface.mZoom.mCacheZoomInvScaleScrollPosXMinusHalfScreenWidth + global.screenWidthHalf);
                this.mTempRect.y = (this.mGeneralInterface.mZoom.mCacheZoomInvScaleScrollPosYMinusHalfScreenHeight + global.screenHeightHalf);
                this.mTempRect.width = cBackbuffer.GetWidth();
                this.mTempRect.height = cBackbuffer.GetHeight();
                cBackbuffer.CopyFogFromSegmentBuffer(this.mTempRect);
            };
            if (((this.mGeneralInterface.showFogOfWar) && (!((this.mStreetDataMap.useAnnoOnlineFog) || (this.mStreetDataMap.useContinentalFog)))))
            {
                this.mStreetDataMap.RenderFog();
            };
            if (((this.mGeneralInterface.showBlockingGrid) || (this.mGeneralInterface.showWatchAreas)))
            {
                this.mStreetDataMap.RenderBlockingGrid();
            };
            if (this.mGeneralInterface.debugCompareDiff != null)
            {
                this.mStreetDataMap.RenderGridDiff(this.mGeneralInterface.debugCompareDiff);
            };
            if (this.mGeneralInterface.showIsoBackgroundGrid)
            {
                this.mStreetDataMap.RenderBackgroundGrid();
            };
            if (this.mGeneralInterface.showSectorGrid)
            {
                this.mStreetDataMap.RenderSectorGrid();
            };
            if (this.mGeneralInterface.showLandingFields)
            {
                this.mStreetDataMap.RenderLandingFields();
            };
        }

        public function MouseDown(_arg_1:MouseEvent):void
        {
            this.mLastGOCursor.x = this.mGeneralInterface.mZoom.Scale(_arg_1.stageX, cZoom.HUNDRED_PERCENT_ZOOM);
            this.mLastGOCursor.y = this.mGeneralInterface.mZoom.Scale(_arg_1.stageY, cZoom.HUNDRED_PERCENT_ZOOM);
            this.mMapScrolled = false;
            this.mMouseMapScrolling = true;
        }

        public function GetProductionQueue(_arg_1:int):cTimedProductionQueue
        {
            var _local_2:int;
            while (_local_2 < this.productionQueue_vector.length)
            {
                if (this.productionQueue_vector[_local_2].mProductionType == _arg_1)
                {
                    return (this.productionQueue_vector[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function SendDestructMountainCommand(_arg_1:int):Boolean
        {
            var _local_2:cBuilding = this.mStreetDataMap.mBuildingContainer.get(_arg_1);
            if (_local_2 == null)
            {
                return (false);
            };
            if (_local_2.IsWaitForCommand())
            {
                return (false);
            };
            _local_2.SetIsDestructionInitiated(true);
            _local_2.SetIsWaitForCommand(true);
            var _local_3:dServerAction = new dServerAction();
            _local_3.grid = _arg_1;
            this.mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.DESTRUCT_MOUNTAIN, this.mGeneralInterface.mCurrentViewedZoneID, _local_3);
            return (true);
        }

        public function SetGoAtGridPosition(_arg_1:cPlayerData, _arg_2:cGO, _arg_3:int, _arg_4:int):cGO
        {
            if (_arg_3 == OBJECTTYPE.BACKGROUND)
            {
                if (!this.mBackgroundDataMap.SetGridPos(_arg_2, _arg_4))
                {
                    return (null);
                };
                this.LevelBackgroundHasChanged();
            }
            else
            {
                if (_arg_3 == OBJECTTYPE.LANDSCAPE)
                {
                    if (!this.mStreetDataMap.SetLandscapeGridPos(_arg_2, _arg_4))
                    {
                        return (null);
                    };
                }
                else
                {
                    if (_arg_3 == OBJECTTYPE.DEPOSIT)
                    {
                        if (!this.mStreetDataMap.SetDepositGridPos(_arg_1, _arg_2, _arg_4))
                        {
                            return (null);
                        };
                    }
                    else
                    {
                        if (_arg_3 == OBJECTTYPE.STREET)
                        {
                            if (!this.mStreetDataMap.SetStreetGridPos((_arg_2 as cStreet), _arg_4))
                            {
                                return (null);
                            };
                            this.LevelBackgroundHasChanged();
                        }
                        else
                        {
                            if (_arg_3 == OBJECTTYPE.BUILDING)
                            {
                                if (!this.mStreetDataMap.SetBuildingGridPos(_arg_2, _arg_4, (!(this.mStreetDataMap.GetLoadedFromMap()))))
                                {
                                    return (null);
                                };
                            }
                            else
                            {
                                gMisc.Assert(false, ("Error: SetGoAtGridPosition illegal object type " + _arg_3));
                            };
                        };
                    };
                };
            };
            return (_arg_2);
        }

        public function SetLandscapeObjectToDepositHidden(_arg_1:cPlayerData, _arg_2:int, _arg_3:String):void
        {
            if (global.landscapeGroup.IsSpriteInGroup(_arg_3))
            {
                this.AddLandscape(_arg_1, _arg_3, _arg_2);
            };
        }

        public function SetFogRendering(_set:Boolean):void
        {
            if (!_set)
            {
                this.mStreetDataMap.mAdditionalData2.forEach(function (_arg_1:uint, _arg_2:AdditionalData):void
                {
                    _arg_2.set(_arg_1, AdditionalDataTSO.Fog, 0);
                });
                this.mStreetDataMap.mAdditionalData2.forEach(function (_arg_1:uint, _arg_2:AdditionalData):void
                {
                    _arg_2.set(_arg_1, AdditionalDataTSO.FogFrame, 0);
                });
                this.mGeneralInterface.showFogOfWar = false;
                this.mGeneralInterface.channels.ZONE.send(ZoneChannel.FOG_RECALCULATED, null);
            }
            else
            {
                this.mStreetDataMap.CalculateFogBorders(this.mGeneralInterface.mCurrentPlayer);
                this.mGeneralInterface.showFogOfWar = true;
            };
            this.mStreetDataMap.CalculateBorders();
            this.SetBackgroundHasChanged(true);
        }

        public function isPlayerOwnerOfGridIdx(_arg_1:int, _arg_2:int):Boolean
        {
            return (this.mSectorList_vector[this.mStreetDataMap.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector)].GetOwnerPlayerID() == _arg_2);
        }

        public function exploreSector(_arg_1:cPlayerData, _arg_2:int):void
        {
            if (cLog.isInfoEnabled())
            {
                cLog.info(((_arg_1 + " explored sector ") + _arg_2));
            };
            _arg_1.SetSectorDiscovery(_arg_2, SECTOR_DISCOVERY_TYPE.EXPLORED);
            if (cLog.isInfoEnabled())
            {
                cLog.info(((("Setting visibility of sector " + _arg_2) + " to ") + _arg_1.GetSectorDiscovery(_arg_2)));
            };
            this.mGeneralInterface.mCurrentPlayerZone.SetFogForSector(_arg_2);
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CalculateBorders();
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.CalculateFogBorders(_arg_1);
            this.mGeneralInterface.mCurrentPlayerZone.SetBackgroundHasChanged(true);
        }

        public function SetWatchArea(_arg_1:int, _arg_2:String, _arg_3:cBuilding):void
        {
            var _local_9:cWatchData;
            var _local_10:int;
            var _local_11:int;
            var _local_4:int = cGO.GetWatchAreaId(_arg_1, _arg_2);
            if (_local_4 <= 0)
            {
            };
            var _local_5:Vector.<cWatchData> = global.watchAreas_vector[_local_4];
            var _local_6:int = _arg_3.GetXInt();
            var _local_7:int = (_arg_3.GetYInt() - global.streetGridYHalf);
            var _local_8:int = this.mStreetDataMap.mAdditionalData.get(_arg_3.GetGrid(), AdditionalDataTSO.Sector);
            for each (_local_9 in _local_5)
            {
                _local_10 = int((_local_6 + ((_local_9.getXPixelOffset() * global.streetGridX) / 100)));
                _local_11 = int((_local_7 + ((_local_9.getYPixelOffset() * global.streetGridY) / 100)));
                this.mStreetDataMap.SetWatchpoint(_local_10, _local_11, _arg_3, _local_8);
            };
        }

        public function GetFirstBuildingOnMap(_arg_1:String):cBuilding
        {
            var _local_3:cBuilding;
            var _local_2:Vector.<cBuilding> = this.mStreetDataMap.getBuildingsByName_vector(_arg_1);
            if (_local_2 != null)
            {
                for each (_local_3 in _local_2)
                {
                    if (_local_3.IsBuildingActive())
                    {
                        return (_local_3);
                    };
                };
            };
            return (null);
        }

        public function MouseWheel(_arg_1:MouseEvent):void
        {
            this.mGeneralInterface.mZoom.modifyScaleIndex(((_arg_1.delta > 0) ? -1 : 1));
            this.mGeneralInterface.mCurrentCursor.MouseMove(_arg_1);
        }

        public function IsBuildingPlacableGridPositionWithExlusions(_arg_1:cGO, _arg_2:cPlayerData, _arg_3:int, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean):int
        {
            var _local_9:int;
            var _local_10:int;
            var _local_11:String;
            var _local_12:String;
            var _local_13:cBuilding;
            var _local_14:int;
            var _local_15:cLandingField;
            var _local_16:cBuilding;
            var _local_17:cDeposit;
            var _local_18:cPathObject;
            var _local_19:cLandscape;
            var _local_20:Boolean;
            var _local_21:cPathObject;
            var _local_22:cPathObject;
            var _local_23:cPathObject;
            if ((((!(_arg_4)) && (this.mStreetDataMap.IsFogAtGridPosition(_arg_3))) && (!(this.mGeneralInterface.mIsDefenseMode))))
            {
                return (ERROR_CODES.BUILDING_IS_ON_FOG);
            };
            var _local_8:cBuilding = (_arg_1 as cBuilding);
            if (_local_8 != null)
            {
                _local_9 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_3, AdditionalDataTSO.Sector);
                _local_10 = this.mSectorList_vector[this.mStreetDataMap.mAdditionalData.get(_arg_3, AdditionalDataTSO.Sector)].GetOwnerPlayerID();
                if (_local_8.IsDefenseBuilding())
                {
                    if (!this.mStreetDataMap.mBuildingContainer.containsKey(_arg_3))
                    {
                        return (ERROR_CODES.INVALID_GRID_POS);
                    };
                    if (!this.mStreetDataMap.mBuildingContainer.get(_arg_3).IsDefenseModeGhostGarrison())
                    {
                        return (ERROR_CODES.INVALID_GRID_POS);
                    };
                    return (0);
                };
                if (!_arg_5)
                {
                    if ((((!(_local_8.IsWarehouseType())) && (!(this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_GARISSON))) && (!(_local_8.getPlayerID() == _local_10))))
                    {
                        return (ERROR_CODES.PLAYER_IS_NOT_SECTOR_OWNER);
                    };
                    if ((((this.mGeneralInterface.mCurrentPlayer.mIsAdventureZone) && (!(this.mGeneralInterface.mCurrentCursor.mCurrentSpecialist == null))) && (this.mGeneralInterface.mCurrentCursor.mCurrentSpecialist.GetGarrison() == null)))
                    {
                        _local_14 = this.mGeneralInterface.FindPlayerFromId(_arg_2.GetPlayerId()).mLandingZoneID;
                        for each (_local_15 in this.mStreetDataMap.mLandingFields_vector)
                        {
                            if (_local_15.GetGrid() == _arg_3)
                            {
                                if (_local_15.mId == _local_14)
                                {
                                    if (this.checkGarissonGridPosition(_local_8, _arg_3))
                                    {
                                        return (0);
                                    };
                                    return (ERROR_CODES.PLACE_IS_BLOCKED_BY_BUILDING_IN_LIST);
                                };
                                return (ERROR_CODES.PLAYER_IS_NOT_SECTOR_OWNER);
                            };
                        };
                        return (ERROR_CODES.PLACE_IS_BLOCKED_BY_BLOCKING_SYSTEM);
                    };
                    if (_local_10 < 0)
                    {
                        return (ERROR_CODES.SECTOR_IS_OWNED_BY_BANDITS);
                    };
                    if (_local_8.GetGOContainer().mHomezoneSectorTypes != HOMEZONE_SECTOR_TYPE.ALL)
                    {
                        if (((this.mSectorList_vector[_local_9].IsIsland()) && (_local_8.GetGOContainer().mHomezoneSectorTypes == HOMEZONE_SECTOR_TYPE.MAIN_ISLAND)))
                        {
                            return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
                        };
                        if (((!(this.mSectorList_vector[_local_9].IsIsland())) && (_local_8.GetGOContainer().mHomezoneSectorTypes == HOMEZONE_SECTOR_TYPE.NEW_ISLANDS)))
                        {
                            return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
                        };
                        if (((this.mSectorList_vector[_local_9].IsIsland()) && (!(_arg_2.GetSectorDiscovery(_local_9) == SECTOR_DISCOVERY_TYPE.ACTIVATED_BY_BUFF))))
                        {
                            return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
                        };
                    };
                };
                _local_11 = _local_8.GetGOContainer().mRestrictPlacingToDeposit;
                if (_local_11 != null)
                {
                    _local_16 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_3);
                    if (_local_16 != null)
                    {
                        if (!this.mStreetDataMap.IsADepletedDeposit(_local_16))
                        {
                            return (ERROR_CODES.MINE_TYPE_PLACE_IS_BLOCKED);
                        };
                    };
                    _local_17 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_3);
                    if (((!(_local_17 == null)) && (_local_17.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE)))
                    {
                        if (_local_17.GetName_string() != _local_11)
                        {
                            return (ERROR_CODES.MINE_TYPE_BUILDING_IS_NOT_PLACED_ON_DEPOSIT);
                        };
                        if (this.mGeneralInterface.mCurrentCursor.GetEditMode() != COMMAND.MOVE_GARISSON)
                        {
                            _local_18 = this.mGeneralInterface.mPathFinder.CalculatePathForWarehouse(gCalculations.MoveStreetGridToDir8(this, _arg_3, defines.DIR8_SOUTH_EAST), _arg_2.GetPlayerId());
                            if (_local_18.dest_vector.length == 0)
                            {
                                return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
                            };
                        };
                        return (ERROR_CODES.NO_ERROR);
                    };
                    return (ERROR_CODES.MINE_TYPE_BUILDING_IS_NOT_PLACED_ON_DEPOSIT);
                };
                _local_19 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(_arg_3);
                if (_local_19 != null)
                {
                    if (this.IsDepositFoundType(_local_19.GetContainerName_string()))
                    {
                        cLog.info((("FALSE: IsDepositFoundType(" + _local_19.GetContainerName_string()) + ") is TRUE!"));
                        return (ERROR_CODES.TRY_TO_BUILD_ON_DEPOSIT);
                    };
                    if (_local_19.GetContainerName_string().indexOf(defines.DEPOSIT_HIDDEN_string) == 0)
                    {
                        return (ERROR_CODES.TRY_TO_BUILD_ON_DEPOSIT);
                    };
                };
                if (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_3) != null)
                {
                    return (ERROR_CODES.TRY_TO_BUILD_ON_DEPOSIT);
                };
                _local_12 = null;
                _local_13 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_3);
                if (_local_13 != null)
                {
                    if (this.mStreetDataMap.IsADepletedDeposit(_local_13))
                    {
                        if (!this.isFreePlacableDepletedDeposit(_local_13.GetBuildingName_string()))
                        {
                            return (ERROR_CODES.PLACE_IS_BLOCKED_BY_BUILDING);
                        };
                        _local_12 = _local_13.GetBuildingName_string();
                    }
                    else
                    {
                        return (ERROR_CODES.PLACE_IS_BLOCKED_BY_BUILDING);
                    };
                };
                gCalculations.ConvertStreetGridToPixelPos(this, _arg_3, this.mTempPoint);
                if (((!(_arg_7)) && (!(this.CheckBlocking(_local_8.GetBuildingName_string(), this.mTempPoint.x, this.mTempPoint.y, _local_12)))))
                {
                    return (ERROR_CODES.PLACE_IS_BLOCKED_BY_BLOCKING_SYSTEM);
                };
                if (!_arg_6)
                {
                    _local_20 = ((!(_local_8 == null)) && ((_local_8.IgnoreWarehousePath()) || (_local_8.IsBuildOnWater())));
                    if (((!(this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_GARISSON)) && (!(_local_20))))
                    {
                        if (!((_local_8 is EpicWorkyardSubBuilding) || (_local_8 is EpicWorkyardMasterBuilding)))
                        {
                            _local_21 = this.mGeneralInterface.mPathFinder.CalculatePathForWarehouse(gCalculations.MoveStreetGridToDir8(this, _arg_3, defines.DIR8_SOUTH_EAST), _arg_2.GetPlayerId());
                            if (_local_8.GetBuildingName_string() == defines.SPECIAL_WAREHOUSES_NAME_string)
                            {
                                return (this.IsSpecialWarehousePlacableGridPosition(_arg_3, _arg_2, _local_21));
                            };
                            if (_local_21.dest_vector.length == 0)
                            {
                                cLog.info("FALSE: Building is not reachable from warehouse!");
                                return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
                            };
                        };
                    }
                    else
                    {
                        if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_GARISSON)
                        {
                            if (this.mGeneralInterface.mCurrentPlayer.mIsAdventureZone)
                            {
                                _local_22 = this.mGeneralInterface.mPathFinder.CalculatePath(this.mGeneralInterface.mSetBuildings.GetMilitaryPathStartingPositionGridIdx(), _arg_3, null, false);
                                if (_local_22.dest_vector.length == 0)
                                {
                                    return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
                                };
                            }
                            else
                            {
                                if (_local_9 > defines.MAIN_ISLAND_SECTORS)
                                {
                                    _local_23 = this.mGeneralInterface.mPathFinder.CalculatePathForWarehouse(gCalculations.MoveStreetGridToDir8(this, _arg_3, defines.DIR8_SOUTH_EAST), _arg_2.GetPlayerId());
                                    if (_local_23.dest_vector.length == 0)
                                    {
                                        return (ERROR_CODES.PLACE_IS_NOT_REACHABLE);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (0);
        }

        public function SendArmyBackToHomeZone(_arg_1:int, _arg_2:dUniqueID, _arg_3:Boolean):void
        {
            var _local_4:int;
            var _local_5:Vector.<cSpecialist>;
            var _local_6:cSpecialist;
            var _local_7:cArmy;
            var _local_8:dSpecialistVO;
            var _local_9:cSpecialist;
            var _local_10:cSpecialistTask_TravelToZone;
            for each (_local_4 in this.map_PlayerID_Army)
            {
                if (_local_4 == _arg_1)
                {
                    _local_7 = this.GetArmy(_local_4);
                    if (((_local_7.GetUnitsCount() > 0) && (_local_4 > defines.PVP_USER_ID)))
                    {
                        _local_8 = new dSpecialistVO();
                        _local_8.playerID = _local_4;
                        _local_8.specialistType = SPECIALIST_TYPE.TMP_ARMY_TRANSPORTER;
                        _local_8.garrisonBuildingGridPos = -1;
                        _local_8.uniqueID = dUniqueID.Create(_arg_2.uniqueID1, _arg_2.uniqueID2);
                        _local_8.armyVO = _local_7.CreateArmyVO();
                        _local_9 = cSpecialist.CreateSpecialistFromVO(this.mGeneralInterface, _local_8, true);
                        this.addSpecialist(_local_9);
                        _local_7.DisbandArmy(null);
                    };
                };
            };
            _local_5 = new Vector.<cSpecialist>();
            _local_5.concat(this.GetSpecialists_vector());
            for each (_local_6 in _local_5)
            {
                if (_local_6.getPlayerID() == _arg_1)
                {
                    this.mGeneralInterface.channels.SPECIALIST.notify(SpecialistNotifier.SPECIALIST_OWNED_LIST_string, _local_6);
                    _local_10 = new cSpecialistTask_TravelToZone(this.mGeneralInterface, _local_6, _local_6.getPlayerID(), 0, 0, TASK_PHASES_TRAVEL_TO_ZONE.STRIKE_GARRISON);
                    if (_arg_3)
                    {
                        _local_10.setRecoveryExtraTime(this.getRecoveryTimeFor(_local_6));
                    };
                    _local_6.SetTask(_local_10);
                    if (_local_6.GetTask() != null)
                    {
                        (_local_6.GetTask() as cSpecialistTask_TravelToZone).BeginTravel();
                        if (((!(_local_6.GetGarrison() == null)) && (_local_6.GetGarrison().GetBuildingMode() == cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES)))
                        {
                            this.mStreetDataMap.DeconstructBuildingGridPos(_local_6.GetGarrison().GetGrid());
                        };
                    };
                };
            };
        }

        public function SetFogForSector(_sectorId:int):void
        {
            this.mStreetDataMap.mAdditionalData2.forEach(function (_arg_1:uint, _arg_2:AdditionalData):void
            {
                if (mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector) == _sectorId)
                {
                    _arg_2.set(_arg_1, AdditionalDataTSO.Fog, 0);
                };
            });
            this.mStreetDataMap.mAdditionalData2.forEach(function (_arg_1:uint, _arg_2:AdditionalData):void
            {
                if (mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector) == _sectorId)
                {
                    _arg_2.set(_arg_1, AdditionalDataTSO.FogFrame, 0);
                };
            });
        }

        public function SetBackgroundHasChanged(_arg_1:Boolean):void
        {
            this.mBackgroundHasChanged = true;
            this.mBackgroundHasChangedClear = _arg_1;
            cBackbuffer.setSegmentBackgroundClear();
        }

        public function ColonyGet(_arg_1:int):ColonyVO
        {
            var _local_2:ColonyVO;
            for each (_local_2 in this.mColoniesVO)
            {
                if (_local_2.colonyId == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function CalculateDeltaScrolls():void
        {
            if (((!(this.mMouseDeltaScrollx == 0)) || (!(this.mMouseDeltaScrolly == 0))))
            {
                if (this.mMouseDeltaScrollx > 0)
                {
                    if (this.mMouseDeltaScrolly > 0)
                    {
                        this.Scroll(defines.SCROLL_RIGHT, this.mMouseDeltaScrollx);
                        this.Scroll(defines.SCROLL_DOWN, this.mMouseDeltaScrolly);
                    }
                    else
                    {
                        this.Scroll(defines.SCROLL_RIGHT, this.mMouseDeltaScrollx);
                        this.Scroll(defines.SCROLL_UP, -(this.mMouseDeltaScrolly));
                    };
                }
                else
                {
                    if (this.mMouseDeltaScrolly > 0)
                    {
                        this.Scroll(defines.SCROLL_LEFT, -(this.mMouseDeltaScrollx));
                        this.Scroll(defines.SCROLL_DOWN, this.mMouseDeltaScrolly);
                    }
                    else
                    {
                        this.Scroll(defines.SCROLL_LEFT, -(this.mMouseDeltaScrollx));
                        this.Scroll(defines.SCROLL_UP, -(this.mMouseDeltaScrolly));
                    };
                };
                this.mMouseDeltaScrollx = 0;
                this.mMouseDeltaScrolly = 0;
            }
            else
            {
                this.Scroll(this.mGeneralInterface.scroll, (global.scrollSpeed * this.mGeneralInterface.mCalculateTicks.mDeltaTicksOne));
            };
        }

        public function SetAllRescaleDirtyFlags():void
        {
            global.guiIconGroup.SetRescaleDirtyFlag();
            global.backgroundGroup.SetRescaleDirtyFlag();
            global.streetGroup.SetRescaleDirtyFlag();
            global.buildingGroup.SetRescaleDirtyFlag();
            global.landscapeGroup.SetRescaleDirtyFlag();
            global.settlerGroup.SetRescaleDirtyFlag();
            global.animalGroup.SetRescaleDirtyFlag();
            global.effectGroup.SetRescaleDirtyFlag();
        }

        public function getMapStartingPos():void
        {
            var _local_1:cBuilding;
            var _local_3:cBuilding;
            var _local_4:int;
            var _local_5:int;
            var _local_6:cGO;
            var _local_7:cBuilding;
            var _local_2:cPosInt = new cPosInt();
            _local_2.x = (_local_2.y = 0);
            if (this.mGeneralInterface.mHomePlayer.GetHomeZoneId() <= defines.ADVENTUREZONEID)
            {
                _local_3 = null;
                _local_4 = -1;
                for each (_local_1 in this.mStreetDataMap.GetBuildings_vector())
                {
                    if (null != _local_1)
                    {
                        if (_local_1.getPlayerID() == global.ui.mCurrentPlayer.getPlayerID())
                        {
                            if (_local_1.GetArmy().GetUnitsCount() > _local_4)
                            {
                                _local_3 = _local_1;
                                _local_4 = _local_1.GetArmy().GetUnitsCount();
                            };
                        };
                    };
                };
                if (_local_3 != null)
                {
                    gCalculations.ConvertStreetGridToPixelPos(this, _local_3.GetGrid(), _local_2);
                }
                else
                {
                    if (this.mStreetDataMap.startGrid == -1)
                    {
                        _local_5 = 0;
                        _local_2.x = 0;
                        _local_2.y = 0;
                        _local_5 = 0;
                        for each (_local_6 in this.mStreetDataMap.GetLandscapes_vector())
                        {
                            _local_2.x = (_local_2.x + _local_6.GetX());
                            _local_2.y = (_local_2.y + _local_6.GetY());
                            _local_5++;
                        };
                        if (_local_5 != 0)
                        {
                            _local_2.x = (_local_2.x / _local_5);
                            _local_2.y = (_local_2.y / _local_5);
                            this.mGeneralInterface.mZoom.setScaleIndex(cZoom.START_ZOOM_FACTOR);
                        };
                    }
                    else
                    {
                        gCalculations.ConvertStreetGridToPixelPos(this, this.mStreetDataMap.startGrid, _local_2);
                    };
                };
            }
            else
            {
                _local_7 = this.mStreetDataMap.getBuildingByName(defines.MAYORHOUSE_NAME_string);
                if (_local_7 != null)
                {
                    gCalculations.ConvertStreetGridToPixelPos(this, _local_7.GetGrid(), _local_2);
                };
            };
            this.mGeneralInterface.mZoom.SetScrollPos(_local_2.x, _local_2.y);
            this.SetBackgroundHasChanged(true);
        }

        public function GetStreetObjectFromGridPosition(_arg_1:int):cStreet
        {
            return (this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mStreetContainer.get(_arg_1));
        }

        public function RemoveDepositIcon(_arg_1:int):void
        {
            this.mGoSetListAnimationManager.RemoveSingleAnimation(_arg_1);
        }

        public function Scroll(_arg_1:int, _arg_2:Number):void
        {
            this.mGeneralInterface.mZoom.Scroll(_arg_1, _arg_2);
        }

        public function SetAdventure(_arg_1:cAdventure):void
        {
            this.mAdventure = _arg_1;
        }

        public function GetSpecialists_vector():Vector.<cSpecialist>
        {
            return (this.mSpecialists_vector);
        }

        public function IsPositionInsideZoneGridPos(_arg_1:int):Boolean
        {
            gCalculations.ConvertStreetGridToPixelPos(this, _arg_1, this.mTempPoint);
            return ((((this.mTempPoint.x >= this.mSectorStartX) && (this.mTempPoint.x <= this.mSectorEndX)) && (this.mTempPoint.y >= this.mSectorStartY)) && (this.mTempPoint.y <= this.mSectorEndY));
        }

        public function MouseMove(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:Number;
            var _local_5:Number;
            this.mGeneralInterface.mCurrentCursor.MouseMove(_arg_1);
            if (this.mGeneralInterface.mMousePressed)
            {
                if (this.mMouseMapScrolling)
                {
                    _local_2 = this.mGeneralInterface.mZoom.Scale(_arg_1.stageX, cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_3 = this.mGeneralInterface.mZoom.Scale(_arg_1.stageY, cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_4 = (this.mLastGOCursor.x - _local_2);
                    _local_5 = (this.mLastGOCursor.y - _local_3);
                    if (((Math.abs(_local_4) > defines.MAP_SCROLL_ACTIVATE_DELTA) || (Math.abs(_local_5) > defines.MAP_SCROLL_ACTIVATE_DELTA)))
                    {
                        this.mMapScrolled = true;
                    };
                    this.mMouseDeltaScrollx = (this.mMouseDeltaScrollx + _local_4);
                    this.mMouseDeltaScrolly = (this.mMouseDeltaScrolly + _local_5);
                    this.mLastGOCursor.x = _local_2;
                    this.mLastGOCursor.y = _local_3;
                    return;
                };
                if (!this.mMapScrolled)
                {
                    this.mGeneralInterface.mSetStreets.MouseMove(this);
                    this.mGeneralInterface.mSetBuildings.MouseMove(this);
                };
            };
        }

        public function UpgradeBuildingOnGridPosition(_arg_1:int):Boolean
        {
            var _local_2:cBuilding = this.mStreetDataMap.mBuildingContainer.get(_arg_1);
            if (_local_2 == null)
            {
                return (false);
            };
            if (_local_2.IsWaitForCommand())
            {
                return (false);
            };
            _local_2.SetIsWaitForCommand(true);
            var _local_3:dServerAction = new dServerAction();
            _local_3.grid = _arg_1;
            this.mGeneralInterface.mClientMessages.SendMessagetoServer(COMMAND.UPGRADE_BUILDING, this.mGeneralInterface.mCurrentViewedZoneID, _local_3);
            cSoundManager.getInstance().playEffect("BuildingUpgrade");
            return (true);
        }

        public function ZoneSetStartZoom():void
        {
            var _local_1:cMapPos = this.mGeneralInterface.mLastZoomPos[this.mGeneralInterface.mHomePlayer.GetHomeZoneId()];
            if (_local_1 == null)
            {
                this.getMapStartingPos();
                _local_1 = new cMapPos();
                _local_1.mScrollposX = this.mGeneralInterface.mZoom.GetScrollPosX();
                _local_1.mScrollposY = this.mGeneralInterface.mZoom.GetScrollPosY();
                _local_1.mZoomScaleFactor = this.mGeneralInterface.mZoom.GetScaleFactor();
                this.mGeneralInterface.mLastZoomPos[this.mGeneralInterface.mHomePlayer.GetHomeZoneId()] = _local_1;
            }
            else
            {
                this.mGeneralInterface.mZoom.SetScrollPos(_local_1.mScrollposX, _local_1.mScrollposY);
            };
        }


    }
}
