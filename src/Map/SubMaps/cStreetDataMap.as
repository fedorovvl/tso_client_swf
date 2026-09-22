package Map.SubMaps
{
    import Model.Notifier;
    import nLib.IndexedContainer;
    import nLib.AdditionalData;
    import GO.cBuilding;
    import Utils.PreviewPathsContainer;
    import com.bluebyte.tso.rendering.RenderListManager;
    import __AS3__.vec.Vector;
    import GO.cSettler;
    import GO.cGOGroup;
    import Interface.cGeneralInterface;
    import nLib.cPosInt;
    import GO.cLandingField;
    import GO.cFreeLandscape;
    import nLib.cClippingRectangle;
    import GO.cDeposit;
    import GO.cGO;
    import flash.utils.Dictionary;
    import Utils.HashMapWrapper;
    import GO.cStreet;
    import Communication.VO.dZoneVO;
    import Map.AdditionalDataTSO;
    import Enums.DEPOSIT_ACCESSIBLE_TYPES;
    import Enums.GCB_MODE_CLIPPING;
    import Map.cPlayerZoneScreen;
    import PathFinding.dPathObjectItem;
    import Utils.TriggerUtils;
    import ServerState.cPlayerData;
    import PathFinding.cPathObject;
    import Enums.SECTOR_DISCOVERY_TYPE;
    import nLib.cBackbuffer;
    import nLib.gMisc;
    import Enums.RENDER_LAYER;
    import Utils.DictionaryUtils;
    import ServerState.dResourceCreationDefinition;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.display.BlendMode;
    import Communication.VO.IntegerListVO;
    import GO.cLandscape;
    import ServerState.cResources;
    import Tracks.TrackManager;
    import Collections.CollectionsManager;
    import Collections.CollectionsConsts;
    import Enums.DIRTY_INDICATOR;
    import BuffSystem.BuffAppliance;
    import Map.cSector;
    import ShopSystem.cShopItemGroup;
    import ShopSystem.cShopItem;
    import Enums.COMMAND;
    import Communication.VO.Guild.dGuildVO;
    import GO.cBlockingData;
    import Enums.RESOURCE_TYPE;
    import GO.buildings.cCollectibleBuilding;
    import flash.display.Graphics;
    import Enums.TERRAIN_TYPE;
    import GO.cCombatData;
    import MilitarySystem.cCombat;
    import Utils.Random;
    import Model.Notifiers.ZoneChannel;
    import GOSets.cGOSetListController;
    import GOSets.cGOSetListControllerPercentage;
    import GOSets.cGOSetManager;
    import nLib.cZoom;
    import Enums.KILL_SWITCH;
    import nLib.cXML;
    import GO.cDepositGroup;
    import PathFinding.cPathFinder;
    import Enums.OBJECTTYPE;
    import GO.epicWorkyard.EpicWorkyardMasterBuilding;
    import Enums.CURSOR_VALID;
    import Map.cGoSetListAnimationItem;
    import Map.GridPosition;
    import GO.buildings.DestroyOnClickBuilding;
    import BuffSystem.cBuff;
    import nLib.NotifyingIndexedContainer;
    import PathFinding.cCreatePath;
    import Communication.VO.dUniqueID;
    import flash.display.*;
    import __AS3__.vec.*;
    import nLib.*;
    import Tracks.*;

    public class cStreetDataMap extends Notifier 
    {

        private static const ACTIVATE_RENDER_DEBUG_INFO_OVER_BUILDING:Boolean = true;
        private static const ACTIVATE_ISO_RENDER_DEBUG_INFO:Boolean = true;
        private static const FOG_SMOOTHING_INSIDE:int = 24;

        protected var mCachedZoomScale:Number = -1;
        public var mDepositContainer:IndexedContainer = null;
        public var useAnnoOnlineFog:Boolean = true;
        public var mWatchingContainer:IndexedContainer = null;
        private var mLoadedFromMap:Boolean = false;
        public var mAdditionalData:AdditionalData = null;
        protected var mCachedScrollPosX:Number = -1;
        protected var mCachedScrollPosY:Number = -1;
        private var mMayorHouse:cBuilding = null;
        public var mPathsPreviewsContainer:PreviewPathsContainer = null;
        private var mLogisticsHouse:cBuilding = null;
        public var renderLayers:RenderListManager;
        private var mPvpProgressionHouse:cBuilding = null;
        public var useContinentalFog:Boolean = true;
        public var startGrid:int = -1;
        protected var mElementName_string:String;
        public var mStreetVectorChanged:Boolean = false;
        private var mCheckFreeLandscapeCntr:int = 0;
        private var mGuildHouse:cBuilding = null;
        public var mLandmarkContainer:IndexedContainer = null;
        private var mSettlerYSortMap_list:Vector.<Vector.<cSettler>> = null;
        public var mBuildingContainer:IndexedContainer = null;
        protected var mGoGroup:cGOGroup;
        public var mLandscapeContainer:IndexedContainer = null;
        private var mGuildBankHouse:cBuilding = null;
        public var mStreetContainer:IndexedContainer = null;
        private var mSinTable_vector:Vector.<int>;
        public var mAdditionalData2:AdditionalData = null;
        protected var mGeneralInterface:cGeneralInterface;
        public var mCombatContainer:IndexedContainer = null;
        public var mBlockingSourceData:AdditionalData = null;
        private var mCosTable_vector:Vector.<int>;

        public var mStreetInDirectionResultPos:cPosInt = new cPosInt(0, 0);
        public var mLandingFields_vector:Vector.<cLandingField> = new Vector.<cLandingField>();
        public var mFreeLandscape_vector:Vector.<cFreeLandscape> = new Vector.<cFreeLandscape>();
        public var mOverFogLandscape_vector:Vector.<cFreeLandscape> = new Vector.<cFreeLandscape>();
        protected var mTempPosInt:cPosInt = new cPosInt();
        protected var mTempClippingRectangle:cClippingRectangle = new cClippingRectangle();
        protected var mConvertPixelPosToGridPosRes:cPosInt = new cPosInt();
        private var mDeposits_vector:Vector.<cDeposit> = new Vector.<cDeposit>();
        private var mBuildingsAndTrees_vector:Vector.<cGO> = new Vector.<cGO>();
        private var pickups:Dictionary = new Dictionary();
        private var initialNumberOfPickupsMap:Dictionary = new Dictionary();
        private var mBuildingsLookupByName_map:Dictionary = new Dictionary();
        private var mTaskBuildings_map:HashMapWrapper = new HashMapWrapper();
        private var mTempPos:cPosInt = new cPosInt();
        private var mStreetCreationPreview_vector:Vector.<cStreet> = new Vector.<cStreet>();
        private var rect:cClippingRectangle = new cClippingRectangle();

        public function cStreetDataMap(_arg_1:cGeneralInterface, _arg_2:dZoneVO)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.InitializeMap(_arg_2);
        }

        public static function GetStreetDirection(_arg_1:cPosInt, _arg_2:cPosInt):int
        {
            if (_arg_2.x > _arg_1.x)
            {
                if (_arg_2.y > _arg_1.y)
                {
                    return (1);
                };
                return (0);
            };
            if (_arg_2.y > _arg_1.y)
            {
                return (2);
            };
            return (3);
        }


        public function SetWatchpoint(_arg_1:int, _arg_2:int, _arg_3:cBuilding, _arg_4:int):void
        {
            var _local_5:int = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _arg_2);
            if (_local_5 == defines.ILLEGAL_INT_POS)
            {
                return;
            };
            var _local_6:int = this.mAdditionalData.get(_local_5, AdditionalDataTSO.Sector);
            if ((((_arg_3.getPlayerID() == this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_6].GetOwnerPlayerID()) || ((_arg_3.getPlayerID() < 0) && (this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_6].GetOwnerPlayerID() == 0))) || ((_arg_3.IsDefenseBuilding()) && (this.mGeneralInterface.mIsDefenseMode))))
            {
                this.AddWatchingBuilding(_local_5, _arg_3, _arg_4);
            };
        }

        public function IsLandingfieldAtPosition(_arg_1:int):cLandingField
        {
            var _local_2:cLandingField;
            for each (_local_2 in this.mLandingFields_vector)
            {
                if (_local_2.GetGrid() == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function IsDepositIn8DirectionsAroundGridPos(_arg_1:int):Boolean
        {
            var _local_3:int;
            if (null != this.mDepositContainer.get(_arg_1))
            {
                return (true);
            };
            var _local_2:int;
            while (_local_2 < defines.DIR8_MAX)
            {
                _local_3 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _local_2);
                if (this.mDepositContainer.get(_local_3) != null)
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        public function getDeposits_vectorByType(_arg_1:String):Vector.<cDeposit>
        {
            var _local_3:cDeposit;
            if (((_arg_1 == null) || (_arg_1 == "")))
            {
                return (this.mDeposits_vector);
            };
            var _local_2:Vector.<cDeposit> = new Vector.<cDeposit>();
            for each (_local_3 in this.mDeposits_vector)
            {
                if (((_local_3.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE) && (_local_3.GetName_string() == _arg_1)))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function RemoveDepletedDepositBuildingIfOneIsThere(_arg_1:int):Boolean
        {
            var _local_2:cBuilding = this.mBuildingContainer.get(_arg_1);
            if (_local_2 != null)
            {
                if (((this.IsADepletedDeposit(_local_2)) || (this.IsAGhostGarrison(_local_2))))
                {
                    this.RemoveBuildingGridPos(_arg_1, true);
                    this.RemoveBuildingFromGameLogic(_local_2);
                    return (true);
                };
                return (false);
            };
            return (true);
        }

        public function IsWatchAreaInterfering(_arg_1:int):Boolean
        {
            var _local_2:cStreet;
            var _local_3:Vector.<int>;
            var _local_4:int;
            var _local_5:int;
            var _local_6:String;
            for each (_local_2 in this.mStreetCreationPreview_vector)
            {
                if (_local_2.GetStreetType() == cStreet.TYPE_ARMY)
                {
                    _local_3 = this.GetReadyTowerGridIdxs(_local_2.GetGrid());
                    if (_local_3.indexOf(_arg_1) == -1)
                    {
                        for each (_local_4 in _local_3)
                        {
                            _local_5 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _local_4, defines.DIR8_NORTH_WEST);
                            _local_6 = this.mBuildingContainer.get(_local_5).GetBuildingName_string();
                            if (!global.hiddenBanditCamps_dictionary.Contains(_local_6))
                            {
                                return (true);
                            };
                        };
                    };
                };
            };
            return (false);
        }

        public function UpdateGuildHouseBuildingLevel(_arg_1:cBuilding):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:*;
            if (_arg_1 != null)
            {
                _local_2 = this.mGeneralInterface.mHomePlayer.getGuildMaxSize();
                if (_local_2 > 0)
                {
                    _local_3 = 0;
                    for (_local_4 in global.guildUpgradeLevels)
                    {
                        if (_local_2 >= global.guildUpgradeLevels[_local_4])
                        {
                            _local_3 = _local_4;
                        }
                        else
                        {
                            break;
                        };
                    };
                    _arg_1.SetUpgradeLevel(_local_3);
                }
                else
                {
                    _arg_1.SetUpgradeLevel(1);
                };
            };
        }

        public function RecalculateBlockingGridAndPathFinding(_arg_1:int):void
        {
            var _local_2:cBuilding;
            if (!this.mGeneralInterface.mRefreshZoneIsActive)
            {
                this.CalculateBlockingGrid();
                this.mGeneralInterface.mPathFinder.InvalidateAll(_arg_1);
                for each (_local_2 in this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
                {
                    if (((!(null == _local_2)) && (!(_local_2.GetResourceCreation() == null))))
                    {
                        _local_2.GetResourceCreation().SetInvalidatePaths(true);
                    };
                };
            };
        }

        public function RenderGrid():void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_1:cClippingRectangle = new cClippingRectangle();
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_1);
            var _local_2:int;
            var _local_3:int;
            var _local_4:int = (global.streetGridX * _local_1.minX);
            _local_3 = (_local_3 + (global.streetGridYHalf * _local_1.minY));
            var _local_5:int = _local_1.minY;
            while (_local_5 <= _local_1.maxY)
            {
                if ((_local_5 & 0x01) == 0)
                {
                    _local_2 = (-(global.streetGridXHalf) + _local_4);
                }
                else
                {
                    _local_2 = _local_4;
                };
                _local_6 = ((_local_5 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1.minX);
                _local_7 = _local_1.minX;
                while (_local_7 <= _local_1.maxX)
                {
                    if ((_local_5 & 0x01) == 0)
                    {
                        this.mGeneralInterface.mStreetCursorGrid.SetPosition(_local_2, _local_3);
                        this.mGeneralInterface.mStreetCursorGrid.Render();
                    };
                    _local_2 = (_local_2 + global.streetGridX);
                    _local_6++;
                    _local_7++;
                };
                _local_3 = (_local_3 + global.streetGridYHalf);
                _local_5++;
            };
        }

        public function renderFogAnno(_arg_1:int):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_2:cClippingRectangle = new cClippingRectangle();
            this.CalculateMapClipping(_arg_1, _local_2);
            _local_3 = 0;
            _local_4 = 0;
            _local_5 = (global.streetGridX * _local_2.minX);
            _local_4 = (_local_4 + (global.streetGridYHalf * _local_2.minY));
            _local_7 = 4;
            _local_8 = 10;
            _local_10 = (_local_2.minX % _local_7);
            _local_5 = (_local_5 - (_local_10 * global.streetGridX));
            _local_2.minX = (_local_2.minX - _local_10);
            _local_2.maxX = (_local_2.maxX + (_local_7 - _local_10));
            _local_11 = (_local_2.minY % _local_8);
            _local_4 = (_local_4 - (_local_11 * global.streetGridYHalf));
            _local_2.minY = (_local_2.minY - _local_11);
            _local_13 = _local_2.minY;
            while (_local_13 <= _local_2.maxY)
            {
                if ((_local_13 & 0x01) == 0)
                {
                    _local_3 = (global.streetGridXHalf + _local_5);
                }
                else
                {
                    _local_3 = _local_5;
                };
                _local_16 = (((_local_13 / _local_8) & 0x01) << 1);
                _local_14 = ((_local_13 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_2.minX);
                _local_12 = _local_2.minX;
                while (_local_12 < (_local_2.maxX + 2))
                {
                    if (this.mAdditionalData2.get(_local_14, AdditionalDataTSO.Fog) >= 5)
                    {
                        _local_15 = ((_local_12 / _local_7) & 0x01);
                        _local_17 = (_local_15 + _local_16);
                        this.mGeneralInterface.mPatternFog.mSprite.RenderSubTypeAndFrame(_local_3, _local_4, 0, _local_17);
                    };
                    _local_3 = (_local_3 + (global.streetGridX * _local_7));
                    _local_14 = (_local_14 + _local_7);
                    _local_12 = (_local_12 + _local_7);
                };
                _local_4 = (_local_4 + (global.streetGridYHalf * _local_8));
                _local_13 = (_local_13 + _local_8);
            };
            this.CalculateMapClipping(_arg_1, _local_2);
            this.renderFogBorders(_local_2, 2, 3, 1, 8);
        }

        private function RenderFreeBackground(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:cFreeLandscape;
            for each (_local_3 in this.mFreeLandscape_vector)
            {
                if (_arg_2 == _local_3.mIsAnimated)
                {
                    _local_3.RenderPos(_local_3.GetX(), _local_3.GetY());
                };
            };
        }

        public function CreateStreetWayFromPathStreet(_arg_1:cPlayerData, _arg_2:cPathObject, _arg_3:Boolean):void
        {
            var _local_4:cPlayerZoneScreen;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_12:String;
            var _local_13:int;
            var _local_5:int = _arg_2.dest_vector.length;
            if (_arg_3)
            {
                this.ResetStreetPreview();
            };
            if (_local_5 < 2)
            {
                return;
            };
            var _local_9:dPathObjectItem = new dPathObjectItem();
            var _local_10:dPathObjectItem = new dPathObjectItem();
            var _local_11:dPathObjectItem = new dPathObjectItem();
            _local_6 = 0;
            while (_local_6 < _local_5)
            {
                if (_local_6 > 0)
                {
                    _local_9 = (_arg_2.dest_vector[(_local_6 - 1)] as dPathObjectItem);
                };
                _local_10 = (_arg_2.dest_vector[_local_6] as dPathObjectItem);
                if (_local_6 < (_local_5 - 1))
                {
                    _local_11 = (_arg_2.dest_vector[(_local_6 + 1)] as dPathObjectItem);
                };
                _local_7 = GetStreetDirection(_local_10, _local_9);
                _local_8 = GetStreetDirection(_local_10, _local_11);
                _local_12 = "";
                if (_local_6 == 0)
                {
                    _local_12 = ("" + _local_8);
                }
                else
                {
                    if (_local_6 == (_local_5 - 1))
                    {
                        _local_12 = ("" + _local_7);
                    }
                    else
                    {
                        if (_local_7 > _local_8)
                        {
                            _local_13 = _local_7;
                            _local_7 = _local_8;
                            _local_8 = _local_13;
                        };
                        if (_local_7 == 0)
                        {
                            if (_local_8 == 1)
                            {
                                _local_12 = "01";
                            }
                            else
                            {
                                if (_local_8 == 2)
                                {
                                    _local_12 = "02";
                                }
                                else
                                {
                                    if (_local_8 == 3)
                                    {
                                        _local_12 = "03";
                                    };
                                };
                            };
                        }
                        else
                        {
                            if (_local_7 == 1)
                            {
                                if (_local_8 == 2)
                                {
                                    _local_12 = "12";
                                }
                                else
                                {
                                    if (_local_8 == 3)
                                    {
                                        _local_12 = "13";
                                    };
                                };
                            }
                            else
                            {
                                if (_local_7 == 2)
                                {
                                    if (_local_8 == 3)
                                    {
                                        _local_12 = "23";
                                    };
                                };
                            };
                        };
                    };
                };
                if (_local_12 != "")
                {
                    _local_4 = this.mGeneralInterface.mCurrentPlayerZone;
                    if (((((_local_10.x >= _local_4.mSectorStartX) && (_local_10.x <= _local_4.mSectorEndX)) && (_local_10.y >= _local_4.mSectorStartY)) && (_local_10.y <= _local_4.mSectorEndY)))
                    {
                        _local_4.mStreetDataMap.SetStreet(_arg_1, _local_12, _local_10.streetGridIdx, _arg_3, false);
                    };
                };
                _local_6++;
            };
            _arg_1.notifyPropertyObserver(TriggerUtils.STREETS_UPDATED_PROPERTY_NAME, null);
        }

        public function RenderSectorGrid():void
        {
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:String;
            var _local_1:cClippingRectangle = new cClippingRectangle();
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_1);
            var _local_2:int;
            var _local_3:int = -(global.streetGridYHalf);
            var _local_4:int;
            var _local_5:int = 0;
            var _local_6:int = (global.streetGridX * _local_1.minX);
            _local_5 = (_local_5 + (global.streetGridYHalf * _local_1.minY));
            var _local_7:int = _local_1.minY;
            while (_local_7 <= _local_1.maxY)
            {
                if ((_local_7 & 0x01) == 0)
                {
                    _local_4 = (-(global.streetGridXHalf) + _local_6);
                }
                else
                {
                    _local_4 = _local_6;
                };
                _local_8 = ((_local_7 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1.minX);
                _local_9 = _local_1.minX;
                while (_local_9 <= _local_1.maxX)
                {
                    _local_10 = this.mAdditionalData.get(_local_8, AdditionalDataTSO.Sector);
                    _local_11 = (_local_10 & 0x07);
                    this.RenderStreetCursorColor(_local_11, _local_4, _local_5);
                    _local_12 = "";
                    if (SECTOR_DISCOVERY_TYPE.isExplored(this.mGeneralInterface.mCurrentPlayer.GetSectorDiscovery(_local_10)))
                    {
                        _local_12 = "-d";
                    };
                    this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (gMisc.ConvertDoubleToString_string(_local_10) + _local_12), (_local_4 + _local_2), (_local_5 + _local_3));
                    _local_4 = (_local_4 + global.streetGridX);
                    _local_8++;
                    _local_9++;
                };
                _local_5 = (_local_5 + global.streetGridYHalf);
                _local_7++;
            };
        }

        public function RefreshGuildHouse():void
        {
            this.UpdateGuildHousesBuildingLevel();
            this.SetGuildHouse(null);
            var _local_1:cBuilding = this.getBuildingByName(defines.GUILDHOUSE_NAME_string);
            if (((!(_local_1 == null)) && (_local_1.IsBuildingActive())))
            {
                this.SetGuildHouse(_local_1);
            };
        }

        override public function dispose():void
        {
            if (this.renderLayers != null)
            {
                this.renderLayers.dispose();
                this.renderLayers = null;
            };
            super.dispose();
        }

        public function Clear():void
        {
            var _local_1:int;
            var _local_2:Dictionary;
            this.mFreeLandscape_vector.length = 0;
            this.mOverFogLandscape_vector.length = 0;
            this.mLandingFields_vector.length = 0;
            this.mBuildingContainer.clear();
            this.mDepositContainer.clear();
            this.mStreetContainer.clear();
            this.mLandscapeContainer.clear();
            this.mWatchingContainer.clear();
            this.mLandmarkContainer.clear();
            this.mGeneralInterface.channels.RENDER.clearLayer(RENDER_LAYER.STATIC);
            this.mGeneralInterface.channels.RENDER.clearLayer(RENDER_LAYER.LABELS);
            this.mAdditionalData.clear();
            this.mAdditionalData2.clear();
            for each (_local_2 in this.pickups)
            {
                DictionaryUtils.clearDictionary(_local_2);
            };
            DictionaryUtils.clearDictionary(this.pickups);
            DictionaryUtils.clearDictionary(this.initialNumberOfPickupsMap);
            this.ResetListsAndScrolling();
        }

        public function ShowStreetPreview():void
        {
            var _local_1:cStreet;
            for each (_local_1 in this.mStreetCreationPreview_vector)
            {
                _local_1.Render();
            };
        }

        public function RenderDepositsAll():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_6:cDeposit;
            var _local_9:int;
            var _local_10:String;
            var _local_11:String;
            var _local_12:int;
            var _local_13:int;
            var _local_14:String;
            var _local_15:cBuilding;
            var _local_16:dResourceCreationDefinition;
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, this.mTempClippingRectangle);
            _local_1 = this.mTempClippingRectangle.minX;
            _local_2 = this.mTempClippingRectangle.minY;
            _local_3 = this.mTempClippingRectangle.maxX;
            _local_4 = this.mTempClippingRectangle.maxY;
            var _local_5:int = -(global.streetGridY - 24);
            var _local_7:int;
            var _local_8:int = (_local_2 - 1);
            while (_local_8 <= (_local_4 + 1))
            {
                _local_7 = ((_local_8 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1);
                _local_9 = _local_1;
                while (_local_9 <= _local_3)
                {
                    _local_6 = this.mDepositContainer.get(_local_7);
                    if (_local_6 != null)
                    {
                        _local_10 = _local_6.GetName_string();
                        _local_11 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_10);
                        _local_12 = int(_local_6.GetX());
                        _local_13 = int(_local_6.GetY());
                        _local_14 = gMisc.ConvertDoubleToString_string(_local_6.GetAmount());
                        _local_15 = this.mBuildingContainer.get(_local_7);
                        if (((!(_local_15 == null)) && (!(_local_15.GetResourceCreation() == null))))
                        {
                            _local_16 = _local_15.GetResourceCreation().GetResourceCreationDefinition();
                            if ((((!(_local_16 == null)) && (_local_16.externalResource_string == _local_6.GetName_string())) && (_local_16.amountRemoved == 0)))
                            {
                                _local_14 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "Unlimited");
                            };
                        };
                        if (_local_6.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE)
                        {
                            _local_6.RenderPos(_local_12, _local_13);
                            this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, ((_local_14 + " ") + _local_11), _local_12, (_local_13 + _local_5));
                        }
                        else
                        {
                            this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (((((("[" + _local_14) + " ") + _local_10) + " in Group: ") + _local_6.GetDepositGroupID()) + "]"), _local_12, (_local_13 + _local_5));
                            _local_6.RenderTransform(_local_12, _local_13, BlendMode.DARKEN, 1, 1, 0);
                        };
                    };
                    _local_7++;
                    _local_9++;
                };
                _local_8++;
            };
        }

        public function isSectorExploredAtGridPosition(_arg_1:int):Boolean
        {
            var _local_2:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector);
            return (SECTOR_DISCOVERY_TYPE.isExplored(this.mGeneralInterface.mHomePlayer.GetSectorDiscovery(_local_2)));
        }

        public function RenderGridDiff(_arg_1:IntegerListVO):void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:Object;
            var _local_10:cGO;
            var _local_2:cClippingRectangle = new cClippingRectangle();
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_2);
            var _local_3:int;
            var _local_4:int;
            var _local_5:int = (global.streetGridX * _local_2.minX);
            _local_4 = (_local_4 + (global.streetGridYHalf * _local_2.minY));
            var _local_6:int = _local_2.minY;
            while (_local_6 <= _local_2.maxY)
            {
                if ((_local_6 & 0x01) == 0)
                {
                    _local_3 = (-(global.streetGridXHalf) + _local_5);
                }
                else
                {
                    _local_3 = _local_5;
                };
                _local_7 = ((_local_6 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_2.minX);
                _local_8 = _local_2.minX;
                while (_local_8 <= _local_2.maxX)
                {
                    _local_9 = _arg_1.get(_local_7);
                    if (_local_9 != null)
                    {
                        _local_10 = this.mGeneralInterface.mStreetCursorRed;
                        if (_local_9 == IntegerListVO.ONLY_ON_CLIENT)
                        {
                            _local_10 = this.mGeneralInterface.mStreetCursorYellow;
                        }
                        else
                        {
                            if (_local_9 == IntegerListVO.ONLY_ON_SERVER)
                            {
                                _local_10 = this.mGeneralInterface.mStreetCursorOrange;
                            };
                        };
                        _local_10.SetPosition(_local_3, _local_4);
                        _local_10.Render();
                    };
                    _local_3 = (_local_3 + global.streetGridX);
                    _local_7++;
                    _local_8++;
                };
                _local_4 = (_local_4 + global.streetGridYHalf);
                _local_6++;
            };
        }

        public function SetPrePlaceBuildingGridPosWithLevel(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:int):Boolean
        {
            var _local_8:String;
            if (!this.RemoveDepletedDepositBuildingIfOneIsThere(_arg_3))
            {
                return (false);
            };
            var _local_6:cBuilding = cBuilding.CreateFromString(_arg_1, global.buildingGroup, _arg_2, this.mGeneralInterface);
            gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_3, this.mTempPos);
            _local_6.SetPosition(this.mTempPos.x, (this.mTempPos.y + global.streetGridYHalf));
            if (_arg_3 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            this.mBuildingContainer.put(_arg_3, _local_6);
            var _local_7:cLandscape = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(_arg_3);
            if (_local_7 != null)
            {
                _local_8 = _local_7.GetContainerName_string();
                if (!this.mGeneralInterface.mCurrentPlayerZone.IsDepositFoundType(_local_8))
                {
                    _local_7.setVisible(false);
                };
            };
            _arg_1.AddPrePlacesBuildingToList(_local_6);
            this.AddBuildingToList(_local_6);
            _local_6.mBuildingCreationTime = this.mGeneralInterface.GetClientTime();
            _local_6.SetGrid(_arg_3);
            _local_6.SetBuildingMode(cBuilding.BUILDING_MODE_NONE);
            _local_6.SetUpgradeLevel(_arg_4);
            _local_6.SetRecurringChance(_arg_5);
            _local_6.SetBuildingMode(cBuilding.BUILDING_MODE_PLACED);
            _local_6.mDirtyIndicator.clean();
            if (!this.mGeneralInterface.mRefreshZoneIsActive)
            {
                this.CalculateBlockingGrid();
            };
            return (true);
        }

        public function getBuildingByName(_arg_1:String):cBuilding
        {
            var _local_2:Vector.<cBuilding>;
            if ((_arg_1 in this.mBuildingsLookupByName_map))
            {
                _local_2 = this.mBuildingsLookupByName_map[_arg_1];
                if (((!(_local_2 == null)) && (_local_2.length > 0)))
                {
                    return (_local_2[0]);
                };
            };
            return (null);
        }

        public function UpgradeBuildingGridPos(_arg_1:cPlayerData, _arg_2:int):Boolean
        {
            var _local_4:cResources;
            var _local_3:cBuilding = this.mBuildingContainer.get(_arg_2);
            if (_local_3 != null)
            {
                if (!this.mGeneralInterface.mRefreshZoneIsActive)
                {
                    if (!_local_3.IsUpgradeInProgress())
                    {
                        _local_4 = this.mGeneralInterface.mCurrentPlayerZone.GetResources(_arg_1);
                        if (((_local_4.HasPlayerResourcesInListOne(_local_3.GetUpgradeCosts_vector())) && (this.mGeneralInterface.mConditionManager.triggersFinished(_local_3))))
                        {
                            _local_3.BuyUpgrade();
                            _local_3.StartBuildingUpgrade();
                            TrackManager.getInstance().trackBuildingUpdgrade(_arg_1, _local_3, false);
                        };
                    };
                    _local_3.SetIsUpgradeInitiated(false);
                    _local_3.SetIsWaitForCommand(false);
                };
            };
            this.UpdateObjectPositions();
            return (true);
        }

        public function GetStreetFromGridPosition(_arg_1:int):cStreet
        {
            return (this.mStreetContainer.get(_arg_1));
        }

        public function SetLandscapeGridPos(_arg_1:cGO, _arg_2:int):Boolean
        {
            var _local_5:int;
            var _local_3:cLandscape = (_arg_1 as cLandscape);
            var _local_4:cLandscape = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(_arg_2);
            if (_local_4 != null)
            {
                _local_5 = this.mBuildingsAndTrees_vector.indexOf(_local_4);
                if (_local_5 != -1)
                {
                    this.mBuildingsAndTrees_vector.splice(_local_5, 1);
                };
                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.remove(_arg_2);
            };
            gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_2, this.mTempPos);
            _local_3.SetPosition(this.mTempPos.x, (this.mTempPos.y + global.streetGridYHalf));
            _local_3.SetName_string(_arg_1.GetContainerName_string());
            _local_3.SetGrid(_arg_2);
            if (_arg_2 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.put(_arg_2, _local_3);
            if (((!(this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_arg_2) == null)) && (!(this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_2) == null))))
            {
                _local_3.setVisible(false);
            };
            this.AddLandscapeToList(_local_3);
            return (true);
        }

        public function ReAssignSectorID(_arg_1:int, _arg_2:int):void
        {
            var _local_3:int;
            while (_local_3 < this.mAdditionalData.size())
            {
                if (this.mAdditionalData.get(_local_3, AdditionalDataTSO.Sector) == _arg_1)
                {
                    this.mAdditionalData.set(_local_3, AdditionalDataTSO.Sector, _arg_2);
                };
                _local_3++;
            };
        }

        public function RenderStreets(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_9:int;
            var _local_10:int;
            var _local_26:cStreet;
            var _local_27:int;
            var _local_28:int;
            this.CalculateMapClipping(_arg_1, this.mTempClippingRectangle);
            _local_2 = this.mTempClippingRectangle.minX;
            _local_3 = this.mTempClippingRectangle.minY;
            _local_4 = this.mTempClippingRectangle.maxX;
            _local_5 = this.mTempClippingRectangle.maxY;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_11:int = (global.streetGridX * _local_2);
            _local_7 = (_local_7 + (global.streetGridYHalf * _local_3));
            var _local_12:cPosInt = new cPosInt();
            _local_12.x = (global.streetGridXHalf / 2);
            _local_12.y = (global.streetGridYHalf / 2);
            var _local_13:int = ((_local_12.x * _local_12.x) + (_local_12.y * _local_12.y));
            var _local_14:int = gMisc.FastIntegerSqrt(_local_13);
            var _local_15:cPosInt = new cPosInt();
            var _local_16:int = int(((75 * _local_14) / 100));
            _local_15.x = ((_local_12.x * _local_16) / _local_14);
            _local_15.y = ((_local_12.y * _local_16) / _local_14);
            _local_16 = int(((175 * _local_14) / 100));
            var _local_17:cPosInt = new cPosInt();
            _local_17.x = ((_local_12.x * _local_16) / _local_14);
            _local_17.y = ((_local_12.y * _local_16) / _local_14);
            var _local_18:int = _local_15.x;
            var _local_19:int = (-(global.streetGridYHalf) - _local_15.y);
            var _local_20:int = -(_local_15.x);
            var _local_21:int = (-(global.streetGridYHalf) - _local_15.y);
            var _local_22:int = _local_15.x;
            var _local_23:int = (-(global.streetGridYHalf) + _local_15.y);
            var _local_24:int = -(_local_15.x);
            var _local_25:int = (-(global.streetGridYHalf) + _local_15.y);
            _local_10 = _local_3;
            while (_local_10 <= _local_5)
            {
                if ((_local_10 & 0x01) == 0)
                {
                    _local_6 = (-(global.streetGridXHalf) + _local_11);
                }
                else
                {
                    _local_6 = _local_11;
                };
                _local_8 = ((_local_10 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_2);
                _local_9 = _local_2;
                while (_local_9 <= _local_4)
                {
                    if (this.mAdditionalData2.get(_local_8, AdditionalDataTSO.Fog) < 3)
                    {
                        _local_26 = this.mStreetContainer.get(_local_8);
                        if (_local_26 != null)
                        {
                            _local_26.SetPosition(_local_6, _local_7);
                            _local_26.Render();
                        };
                        _local_27 = this.mAdditionalData.get(_local_8, AdditionalDataTSO.Border);
                        if (((!(_local_27 == 0)) && (cSettingsManager.getInstance().showSectorMarkers)))
                        {
                            _local_28 = this.mAdditionalData.get(_local_8, AdditionalDataTSO.BorderColour);
                            this.mGeneralInterface.mBorder.SetSubType(_local_28);
                            if ((_local_27 & defines.DIR8_NORTH_EAST_BIT) > 0)
                            {
                                this.mGeneralInterface.mBorder.RenderPos((_local_6 + _local_18), (_local_7 + _local_19));
                            };
                            if ((_local_27 & defines.DIR8_NORTH_WEST_BIT) > 0)
                            {
                                this.mGeneralInterface.mBorder.RenderPos((_local_6 + _local_20), (_local_7 + _local_21));
                            };
                            if ((_local_27 & defines.DIR8_SOUTH_EAST_BIT) > 0)
                            {
                                this.mGeneralInterface.mBorder.RenderPos((_local_6 + _local_22), (_local_7 + _local_23));
                            };
                            if ((_local_27 & defines.DIR8_SOUTH_WEST_BIT) > 0)
                            {
                                this.mGeneralInterface.mBorder.RenderPos((_local_6 + _local_24), (_local_7 + _local_25));
                            };
                        };
                    };
                    _local_6 = (_local_6 + global.streetGridX);
                    _local_8++;
                    _local_9++;
                };
                _local_7 = (_local_7 + global.streetGridYHalf);
                _local_10++;
            };
        }

        public function getInitialNbOfPickups(_arg_1:int):int
        {
            return (this.initialNumberOfPickupsMap[_arg_1]);
        }

        public function GetGuildBankHouse():cBuilding
        {
            return (this.mGuildBankHouse);
        }

        public function GetStreets_vector():Vector.<cStreet>
        {
            return (this.mStreetContainer.valueCollection());
        }

        public function SetLoadedFromMap(_arg_1:Boolean):void
        {
            this.mLoadedFromMap = _arg_1;
        }

        public function AddBuildingToList(_arg_1:cBuilding):void
        {
            var _local_3:Vector.<cBuilding>;
            this.mBuildingsAndTrees_vector.push(_arg_1);
            if (CollectionsManager.getInstance().getBuildingIsNormalCollectible(_arg_1.GetBuildingName_string()))
            {
                this.addPickupToList(CollectionsConsts.COLLECTIBLE_BUILDING_NORMAL, _arg_1);
            }
            else
            {
                if (CollectionsManager.getInstance().getBuildingIsEventCollectible(_arg_1.GetBuildingName_string()))
                {
                    this.addPickupToList(CollectionsConsts.COLLECTIBLE_BUILDING_EVENT, _arg_1);
                };
            };
            var _local_2:String = _arg_1.GetBuildingName_string();
            if (_local_2 != null)
            {
                if (!(_local_2 in this.mBuildingsLookupByName_map))
                {
                    _local_3 = new Vector.<cBuilding>();
                    this.mBuildingsLookupByName_map[_local_2] = _local_3;
                };
                this.mBuildingsLookupByName_map[_local_2].push(_arg_1);
                if (defines.TASK_BUILDING_UI_NAME_string == _arg_1.ui)
                {
                    this.mTaskBuildings_map.putItem(_local_2, _arg_1);
                };
            };
            if (((_local_2 == defines.LOGISTICS_NAME_string) && (this.mGeneralInterface.mCurrentPlayer.mIsPlayerZone)))
            {
                this.mGeneralInterface.mHomePlayer.mTradeData.refreshUserPlacedOffers();
            };
            notifyPropertyObserver("mBuildings_vector#added", _arg_1);
            notifyPropertyObserver("mBuildings_vector", this.mBuildingContainer.valueCollection());
        }

        public function RefreshLogisticsHouse():void
        {
            var _local_1:Boolean;
            var _local_2:cBuilding = this.getBuildingByName(defines.LOGISTICS_NAME_string);
            if (((!(_local_2 == null)) && (_local_2.IsBuildingActive())))
            {
                this.SetLogisticsHouse(_local_2);
                _local_1 = true;
            };
            if (!_local_1)
            {
                this.SetLogisticsHouse(null);
            };
        }

        public function SetPreviewPath(_arg_1:int, _arg_2:int):void
        {
            var _local_4:cStreet;
            var _local_5:cStreet;
            var _local_3:Boolean;
            if (cStreet.TYPE_ARMY != _arg_2)
            {
                for each (_local_4 in this.mStreetCreationPreview_vector)
                {
                    if (_local_4.GetGrid() == _arg_1)
                    {
                        _local_4.SetStreetType(cStreet.TYPE_PRODUCTION_BOTH);
                        _local_3 = true;
                        break;
                    };
                };
            };
            if (!_local_3)
            {
                _local_5 = new cStreet(this.mGeneralInterface);
                _local_5.SetGrid(_arg_1);
                _local_5.SetStreetType(_arg_2);
                this.mStreetCreationPreview_vector.push(_local_5);
            };
        }

        public function SetGuildBankHouse(_arg_1:cBuilding):void
        {
            if (((_arg_1 == null) || (this.mGeneralInterface.mCurrentPlayer.mIsPlayerZone)))
            {
                this.mGuildBankHouse = _arg_1;
            };
        }

        public function ActivateCombatSlotAtGridPos(_arg_1:cGO, _arg_2:int):Boolean
        {
            gCalculations.ConvertStreetGridToPixelPos(global.ui.mCurrentPlayerZone, _arg_2, this.mTempPos);
            if (_arg_2 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            _arg_1.SetPosition(this.mTempPos.x, (this.mTempPos.y + global.streetGridYHalf));
            return (true);
        }

        public function IsLandscapeAtFreePosition(_arg_1:int, _arg_2:int, _arg_3:int):cGO
        {
            var _local_4:cFreeLandscape;
            var _local_5:int;
            var _local_6:int;
            for each (_local_4 in this.mFreeLandscape_vector)
            {
                _local_5 = Math.abs((_local_4.GetXInt() - _arg_1));
                if (_local_5 < _arg_3)
                {
                    _local_6 = Math.abs((_local_4.GetYInt() - _arg_2));
                    if (_local_6 < _arg_3)
                    {
                        return (_local_4);
                    };
                };
            };
            return (null);
        }

        public function SetPrePlaceBuildingGridPos(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:int):Boolean
        {
            return (this.SetPrePlaceBuildingGridPosWithLevel(_arg_1, _arg_2, _arg_3, 1, _arg_4));
        }

        public function RenderFogBackground(_arg_1:int):void
        {
            var _local_2:cFreeLandscape;
            for each (_local_2 in this.mOverFogLandscape_vector)
            {
                _local_2.RenderPos(_local_2.GetX(), _local_2.GetY());
            };
        }

        public function SetLandscapeAtFreePosition(_arg_1:String, _arg_2:int, _arg_3:int):cGO
        {
            var _local_4:cFreeLandscape;
            _local_4 = cFreeLandscape.CreateFromString(global.landscapeGroup, _arg_1, this.mGeneralInterface);
            if (!this.SetLandscapeFreePos(_local_4, _arg_2, _arg_3))
            {
                return (null);
            };
            return (_local_4);
        }

        public function ResetBuildingAndLandscapeList():void
        {
            this.mBuildingsAndTrees_vector.length = 0;
            this.mBuildingsLookupByName_map = new Dictionary();
            this.mTaskBuildings_map.clear();
            notifyPropertyObserver("mBuildings_vector", null);
        }

        public function SetStreetGridPos(_arg_1:cStreet, _arg_2:int):Boolean
        {
            var _local_3:cStreet;
            if (((!(_arg_2 == defines.ILLEGAL_INT_POS)) && (!(this.IsBlockedAllowedMoveOnly(_arg_2)))))
            {
                _local_3 = this.mStreetContainer.get(_arg_2);
                if (_local_3 != null)
                {
                    if (_local_3 == _arg_1)
                    {
                        return (true);
                    };
                    this.mStreetContainer.remove(_arg_2);
                };
                _arg_1.SetGrid(_arg_2);
                this.mStreetContainer.put(_arg_2, _arg_1);
                return (true);
            };
            return (false);
        }

        private function smoothFogBorder(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:cVectorListInt;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int = this.mGeneralInterface.mCurrentPlayerZone.mMapWidth;
            var _local_11:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
            var _local_12:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            var _local_13:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX;
            var _local_14:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY;
            _local_13 = (_local_13 + 2);
            if (this.useContinentalFog)
            {
                _local_11++;
                _local_12 = (_local_12 + 2);
                _local_13--;
                _local_14 = (_local_14 - 2);
            };
            _local_7 = _local_12;
            while (_local_7 <= _local_14)
            {
                _local_5 = ((_local_7 * _local_10) + _local_11);
                _local_6 = _local_11;
                while (_local_6 < _local_13)
                {
                    if (this.mAdditionalData2.get(_local_5, AdditionalDataTSO.Fog) == _arg_1)
                    {
                        _local_8 = 0;
                        while (_local_8 < defines.DIR8_MAX)
                        {
                            _local_9 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _local_5, _local_8);
                            if (this.mAdditionalData2.get(_local_9, AdditionalDataTSO.Fog) == _arg_2)
                            {
                                this.mAdditionalData2.set(_local_5, AdditionalDataTSO.Fog, _arg_3);
                                break;
                            };
                            _local_8++;
                        };
                    };
                    _local_5++;
                    _local_6++;
                };
                _local_7++;
            };
        }

        public function RemoveDepositGridPos(_arg_1:int, _arg_2:Boolean):Boolean
        {
            var _local_4:int;
            if (_arg_1 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            var _local_3:cDeposit = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_1);
            if (_local_3 != null)
            {
                _local_3.mDirtyIndicator = (_local_3.mDirtyIndicator | DIRTY_INDICATOR.DATA_DELETED_BIT);
                _local_4 = this.mDeposits_vector.indexOf(_local_3);
                if (_local_4 != -1)
                {
                    this.mDeposits_vector.splice(_local_4, 1);
                };
                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.remove(_arg_1);
            };
            return (true);
        }

        public function calculateSetStreetData(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:Boolean, _arg_5:Boolean):cStreet
        {
            var _local_6:cStreet = this.GetStreetFromGridPosition(_arg_3);
            var _local_7:int;
            if (_local_6 != null)
            {
                _local_7 = cStreet.ConvertStreetNameToBitField(_arg_2);
                if (!_arg_5)
                {
                    _local_7 = (_local_7 | _local_6.GetStreetBits());
                    _arg_2 = cStreet.CreateStringFromStreetBitField_string(_local_7);
                };
            };
            _arg_2 = (defines.STREET_ELEMENT_NAME_string + _arg_2);
            if (((_local_6 == null) || (_arg_4)))
            {
                _local_6 = cStreet.CreateFromString(global.streetGroup, _arg_2, this.mGeneralInterface);
                _local_6.mDirtyIndicator = DIRTY_INDICATOR.CREATED_BIT;
            }
            else
            {
                _local_6.InitFromNr(global.streetGroup, global.streetGroup.GetNrFromName(_arg_2));
                _local_6.SetStreetBits(_local_7);
            };
            this.calculateStreetVariation(_local_6, _arg_1.GetCityLevel(), _arg_4);
            return (_local_6);
        }

        public function IsFogAtGridPosition(_arg_1:int):Boolean
        {
            if (_arg_1 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            return (!(this.mAdditionalData2.get(_arg_1, AdditionalDataTSO.Fog) == 0));
        }

        public function GetBuildings_vector():Vector.<cBuilding>
        {
            return (this.mBuildingContainer.valueCollection());
        }

        private function RenderStreetCursorColor(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            if (_arg_1 == 0)
            {
                this.mGeneralInterface.mStreetCursorWhite.SetPosition(_arg_2, _arg_3);
                this.mGeneralInterface.mStreetCursorWhite.Render();
            }
            else
            {
                if (_arg_1 == 1)
                {
                    this.mGeneralInterface.mStreetCursorYellow.SetPosition(_arg_2, _arg_3);
                    this.mGeneralInterface.mStreetCursorYellow.Render();
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        this.mGeneralInterface.mStreetCursorGreen.SetPosition(_arg_2, _arg_3);
                        this.mGeneralInterface.mStreetCursorGreen.Render();
                    }
                    else
                    {
                        if (_arg_1 == 3)
                        {
                            this.mGeneralInterface.mStreetCursorRed.SetPosition(_arg_2, _arg_3);
                            this.mGeneralInterface.mStreetCursorRed.Render();
                        }
                        else
                        {
                            if (_arg_1 == 4)
                            {
                                this.mGeneralInterface.mStreetCursorBlue.SetPosition(_arg_2, _arg_3);
                                this.mGeneralInterface.mStreetCursorBlue.Render();
                            }
                            else
                            {
                                if (_arg_1 == 5)
                                {
                                    this.mGeneralInterface.mStreetCursorMagenta.SetPosition(_arg_2, _arg_3);
                                    this.mGeneralInterface.mStreetCursorMagenta.Render();
                                }
                                else
                                {
                                    if (_arg_1 == 6)
                                    {
                                        this.mGeneralInterface.mStreetCursorGrid.SetPosition(_arg_2, _arg_3);
                                        this.mGeneralInterface.mStreetCursorGrid.Render();
                                    }
                                    else
                                    {
                                        this.mGeneralInterface.mStreetPathCursor.SetPosition(_arg_2, _arg_3);
                                        this.mGeneralInterface.mStreetPathCursor.Render();
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function RemoveBuildingGridPos(_arg_1:int, _arg_2:Boolean):Boolean
        {
            var _local_4:cPlayerData;
            var _local_5:BuffAppliance;
            var _local_3:cBuilding = this.mBuildingContainer.get(_arg_1);
            if (_local_3 != null)
            {
                _local_4 = this.mGeneralInterface.FindPlayerFromId(_local_3.getPlayerID());
                if (_local_4 != null)
                {
                    if (_arg_2)
                    {
                        if (((!(_local_3.GetBuildingMode() == cBuilding.BUILDING_MODE_CONSTRUCTION)) || (_local_3.mBuildingProgress >= (100 * defines.BUILDING_PROGRESS_SCALE_FACTOR))))
                        {
                            _local_4.DecBuildingCount(_local_3);
                        };
                        _local_4.DecBuildingAll(_local_3);
                        if (_local_3.IsRecurringBuilding())
                        {
                        };
                    };
                }
                else
                {
                    if (_local_3.getPlayerID() == -1)
                    {
                        this.mGeneralInterface.mHomePlayer.DecAnyBuildingCount(_local_3);
                    };
                };
            };
            this.mBuildingContainer.remove(_arg_1);
            if (_local_3 != null)
            {
                this.RemoveBuildingFromList(_local_3);
                if (_arg_2)
                {
                    for each (_local_5 in _local_3.mBuffs_vector)
                    {
                        _local_5.BuffRemoved(this.mGeneralInterface);
                    };
                    _local_3.productionBuff = null;
                };
            };
            if (null != this.mLandscapeContainer.get(_arg_1))
            {
                this.mLandscapeContainer.get(_arg_1).setVisible(true);
            };
            return (true);
        }

        public function RenderFreeBackgroundStatic(_arg_1:int):void
        {
            this.RenderFreeBackground(_arg_1, false);
        }

        public function SetDeposits_vector(_arg_1:Vector.<cDeposit>):void
        {
            this.mDeposits_vector = _arg_1;
        }

        public function ResetListsAndScrolling():void
        {
            this.ResetBuildingAndLandscapeList();
            this.ResetStreetList();
            this.mCachedScrollPosX = -1;
            this.mCachedScrollPosY = -1;
            this.mCachedZoomScale = -1;
        }

        public function IsFogAtPixelPosition(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:int = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _arg_2);
            return (this.IsFogAtGridPosition(_local_3));
        }

        public function InitRenderCursorInfo():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_6:int;
            var _local_7:int;
            if (this.mGeneralInterface.mCurrentCursor == null)
            {
                return;
            };
            _local_1 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
            _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX;
            _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY;
            var _local_5:int;
            _local_7 = _local_2;
            while (_local_7 <= _local_4)
            {
                _local_5 = ((_local_7 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1);
                _local_6 = _local_1;
                while (_local_6 <= _local_3)
                {
                    this.mAdditionalData.set(_local_5, AdditionalDataTSO.Cursor, uint(-1).valueOf());
                    _local_5++;
                    _local_6++;
                };
                _local_7++;
            };
        }

        public function addPickupToList(_arg_1:int, _arg_2:cBuilding):void
        {
            if (this.pickups[_arg_1] == null)
            {
                this.pickups[_arg_1] = new Dictionary();
            };
            this.pickups[_arg_1][_arg_2.GetGrid()] = _arg_2;
        }

        public function SetLandscapeFogPos(_arg_1:cGO, _arg_2:int, _arg_3:int):Boolean
        {
            var _local_4:cFreeLandscape = (_arg_1 as cFreeLandscape);
            _local_4.SetPosition(_arg_2, _arg_3);
            _local_4.SetName_string(_arg_1.GetContainerName_string());
            this.mOverFogLandscape_vector.push(_local_4);
            return (true);
        }

        public function GetStreetNameFromGridPos_string(_arg_1:int):String
        {
            var _local_2:cStreet = this.mStreetContainer.get(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2.GetContainerName_string());
            };
            return (null);
        }

        public function DeconstructMountainGridPos(_arg_1:int):Boolean
        {
            var _local_2:cBuilding;
            if (_arg_1 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            if (((this.mBuildingContainer.containsKey(_arg_1)) && (!(this.mBuildingContainer.get(_arg_1) == null))))
            {
                _local_2 = this.mBuildingContainer.get(_arg_1);
                _local_2.mBuildingDestructionTime = this.mGeneralInterface.GetClientTime();
                _local_2.SetBuildingMode(cBuilding.MOUNTAIN_DESTROYED);
                this.RemoveBuildingFromGameLogic(_local_2);
            };
            this.UpdateObjectPositions();
            return (true);
        }

        public function RemoveLandscapeGridPos(_arg_1:int):Boolean
        {
            if (_arg_1 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            var _local_2:cLandscape = this.mLandscapeContainer.get(_arg_1);
            this.mLandscapeContainer.remove(_arg_1);
            this.RemoveLandscapeFromList(_local_2);
            this.CalculateBlockingGrid();
            return (true);
        }

        public function MouseClickOnMap(_arg_1:cPlayerData, _arg_2:cPlayerZoneScreen):Boolean
        {
            var _local_4:int;
            var _local_5:cSector;
            var _local_6:cShopItemGroup;
            var _local_7:cShopItem;
            var _local_8:int;
            var _local_3:int = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
            switch (this.mGeneralInterface.mCurrentCursor.GetEditMode())
            {
                case COMMAND.SELECT_BUILDING:
                    if (!this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        if (gCalculations.IsGridInIslandArea(_arg_2, this.mGeneralInterface.mCurrentCursor.GetGridPosition()))
                        {
                            _local_4 = _arg_2.mStreetDataMap.mAdditionalData.get(this.mGeneralInterface.mCurrentCursor.GetGridPosition(), AdditionalDataTSO.Sector);
                            if (_local_4 <= defines.MAIN_ISLAND_SECTORS)
                            {
                                return (false);
                            };
                            _local_5 = this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_4];
                            if (!((!(this.mGeneralInterface.mCurrentPlayer.GetPlayerId() == _local_5.GetOwnerPlayerID())) && (SECTOR_DISCOVERY_TYPE.isExplored(this.mGeneralInterface.mCurrentPlayer.GetSectorDiscovery(_local_4)))))
                            {
                                return (false);
                            };
                            _local_6 = cShopItemGroup.GetShopItemGroup(3);
                            _local_8 = -1;
                            for each (_local_7 in _local_6.shopItems_vector)
                            {
                                if (("IslandDeedShopItem" + _local_4) == _local_7.GetName_string())
                                {
                                    _local_8 = _local_7.GetId();
                                    break;
                                };
                            };
                            if (_local_8 > -1)
                            {
                                globalFlash.gui.mShopWindow.ShowDeepLink("IslandSector", _local_8, 3);
                            };
                        };
                    };
            };
            return (false);
        }

        public function RenderComputeFreeBackground():void
        {
            var _local_1:cFreeLandscape;
            var _local_3:int;
            var _local_2:int = this.mFreeLandscape_vector.length;
            if (_local_2 > 0)
            {
                _local_3 = 0;
                while (_local_3 < 30)
                {
                    this.mCheckFreeLandscapeCntr++;
                    if (this.mCheckFreeLandscapeCntr >= _local_2)
                    {
                        this.mCheckFreeLandscapeCntr = 0;
                    };
                    _local_1 = this.mFreeLandscape_vector[this.mCheckFreeLandscapeCntr];
                    if (_local_1.GetGOContainer().mStreamingFinished)
                    {
                        if (!_local_1.mAnimationInitialized)
                        {
                            _local_1.SetAnimation();
                        };
                    };
                    _local_3++;
                };
                for each (_local_1 in this.mFreeLandscape_vector)
                {
                    if (_local_1.mIsAnimated)
                    {
                        _local_1.Animate();
                    };
                };
            };
        }

        public function GetGuildHouse():cBuilding
        {
            return (this.mGuildHouse);
        }

        public function AddBuildingToGameLogic(_arg_1:cBuilding):void
        {
            if (!this.mGeneralInterface.mRefreshZoneIsActive)
            {
                if (!_arg_1.IsBuildingActive())
                {
                    this.mGeneralInterface.mComputeResourceCreation.CreateResourceCreationForBuilding(_arg_1);
                };
                this.mGeneralInterface.mComputeResourceCreation.CalculateProductionPaths(_arg_1, false);
                this.mGeneralInterface.mCombatPersitedPreview.CalculatePreviewPaths();
            };
        }

        public function SetPvpProgressionHouse(_arg_1:cBuilding):void
        {
            if (this.mGeneralInterface.mCurrentPlayer.mIsPlayerZone)
            {
                this.mPvpProgressionHouse = _arg_1;
                if (this.mPvpProgressionHouse != null)
                {
                    this.mPvpProgressionHouse.SetUpgradeLevel(this.mGeneralInterface.mCurrentPlayer.GetPlayerPvPLevel());
                };
            };
        }

        public function BuildingGridCallBack(_arg_1:Function, _arg_2:int, _arg_3:Boolean):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:cBuilding;
            var _local_12:cBuilding;
            if (_arg_1 == null)
            {
                return;
            };
            this.CalculateMapClipping(_arg_2, this.mTempClippingRectangle);
            _local_4 = this.mTempClippingRectangle.minX;
            _local_5 = this.mTempClippingRectangle.minY;
            _local_6 = this.mTempClippingRectangle.maxX;
            _local_7 = this.mTempClippingRectangle.maxY;
            var _local_8:int;
            if (_arg_3)
            {
                _local_10 = _local_5;
                while (_local_10 <= _local_7)
                {
                    _local_8 = ((_local_10 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_4);
                    _local_9 = _local_4;
                    while (_local_9 <= _local_6)
                    {
                        _local_11 = this.mBuildingContainer.get(_local_8);
                        (_arg_1(_local_11, _local_8, _local_9, _local_10));
                        _local_8++;
                        _local_9++;
                    };
                    _local_10++;
                };
            }
            else
            {
                _local_10 = _local_5;
                while (_local_10 <= _local_7)
                {
                    _local_8 = ((_local_10 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_4);
                    _local_9 = _local_4;
                    while (_local_9 <= _local_6)
                    {
                        _local_12 = this.mBuildingContainer.get(_local_8);
                        if (_local_12 != null)
                        {
                            (_arg_1(_local_12, _local_8, _local_9, _local_10));
                        };
                        _local_8++;
                        _local_9++;
                    };
                    _local_10++;
                };
            };
        }

        public function SetGuildHouse(_arg_1:cBuilding):void
        {
            var _local_2:dGuildVO;
            var _local_3:int;
            var _local_4:*;
            if (((_arg_1 == null) || (this.mGeneralInterface.mCurrentPlayer.mIsPlayerZone)))
            {
                this.mGuildHouse = _arg_1;
                _local_2 = this.mGeneralInterface.GetCurrentPlayerGuild();
                if (((this.mGuildHouse) && (_local_2)))
                {
                    _local_3 = 0;
                    for (_local_4 in global.guildUpgradeLevels)
                    {
                        if (_local_2.maxSize >= global.guildUpgradeLevels[_local_4])
                        {
                            _local_3 = _local_4;
                        }
                        else
                        {
                            break;
                        };
                    };
                    this.mGuildHouse.SetUpgradeLevel(_local_3);
                };
            };
        }

        public function GetBlockType(_arg_1:int):int
        {
            if (_arg_1 == defines.ILLEGAL_INT_POS)
            {
                return (cBlockingData.BLOCK_TYPE_ALLOW_NOTHING);
            };
            return (this.GetBlocked(_arg_1));
        }

        public function GetReadyTowerGridIdxs(_arg_1:uint):Vector.<int>
        {
            var _local_4:int;
            var _local_5:cBuilding;
            var _local_2:Vector.<cBuilding> = this.mWatchingContainer.get(_arg_1);
            var _local_3:Vector.<int> = new Vector.<int>();
            if (_local_2 != null)
            {
                _local_4 = (_local_2.length - 1);
                while (_local_4 >= 0)
                {
                    _local_5 = _local_2[_local_4];
                    if (_local_5.IsReadyToIntercept())
                    {
                        _local_3.push(_local_5.GetStreetGridEntry());
                    };
                    _local_4--;
                };
            };
            return (_local_3);
        }

        public function RemoveAllWatchingTowers(_arg_1:uint):void
        {
            this.mWatchingContainer.remove(_arg_1);
        }

        public function IsAGhostGarrison(_arg_1:cBuilding):Boolean
        {
            return (_arg_1.GetBuildingName_string() == defines.DEFENSE_MODE_GHOST_GARRISON_string);
        }

        public function DeconstructBuildingGridPos(_arg_1:int):Boolean
        {
            var _local_3:dResourceCreationDefinition;
            if (_arg_1 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            var _local_2:cBuilding = this.mBuildingContainer.get(_arg_1);
            if (_local_2 != null)
            {
                _local_2.mBuildingDestructionTime = this.mGeneralInterface.GetClientTime();
                _local_2.SetBuildingMode(cBuilding.BUILDING_MODE_DESTRUCTION);
                _local_2.Refund();
                _local_2.RemoveSurplusResources();
                this.RemoveBuildingFromGameLogic(_local_2);
                this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.Remove(_arg_1);
                if (_local_2.GetResourceCreation() != null)
                {
                    if (_local_2.GetGOContainer().mDepositAnimName_string != null)
                    {
                        _local_3 = _local_2.GetResourceCreation().GetResourceCreationDefinition();
                        if (_local_3 != null)
                        {
                            if (_local_3.typeEnumResourceType == RESOURCE_TYPE.CREATED_BY_BUILDING)
                            {
                                if (_local_2.GetResourceCreation().GetDepositBuildingGridPos() != -1)
                                {
                                    this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.Remove(_local_2.GetResourceCreation().GetDepositBuildingGridPos());
                                };
                            };
                        };
                    };
                };
            };
            this.UpdateObjectPositions();
            return (true);
        }

        public function ClearDeposits():void
        {
            this.mDeposits_vector.length = 0;
        }

        public function BuildingRenderBuildingDebugInfo(_arg_1:Graphics):void
        {
            var _local_2:cBuilding;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:String;
            var _local_9:String;
            var _local_10:BuffAppliance;
            var _local_11:String;
            if (((this.mGeneralInterface.showBuildingDebugGrid) && (ACTIVATE_RENDER_DEBUG_INFO_OVER_BUILDING)))
            {
                for each (_local_2 in this.GetBuildings_vector())
                {
                    if (null != _local_2)
                    {
                        _local_7 = -(global.streetGridY - 20);
                        _local_8 = ((("P: " + _local_2.getPlayerID()) + " M:") + _local_2.GetBuildingMode());
                        _local_8 = (_local_8 + (((((("\r" + "G:") + _local_2.GetGrid()) + " x: ") + (_local_2.GetGrid() % global.ui.mCurrentPlayerZone.mMapWidth)) + " y: ") + int((_local_2.GetGrid() / global.ui.mCurrentPlayerZone.mMapWidth))));
                        if (_local_2.GetResourceCreation() != null)
                        {
                            _local_8 = (_local_8 + (" R:" + _local_2.GetResourceCreation().GetProductionState()));
                        };
                        _local_2.RenderTextAboveGo(_arg_1, _local_8, _local_7);
                        _local_9 = "";
                        _local_7 = (_local_7 + 30);
                        _local_9 = ((_local_2.GetCurrentHitPoints() + "/") + _local_2.GetMaxHitPoints());
                        _local_2.RenderTextAboveGo(_arg_1, _local_9, _local_7);
                        _local_7 = (_local_7 + 15);
                        for each (_local_10 in _local_2.GetBuffs())
                        {
                            _local_11 = cLocaManager.GetInstance().FormatDuration((_local_10.GetBuffDefinition().getDuration(_local_10.GetApplicanceMode()) - (global.getApplication().mGameInterface.GetClientTime() - _local_10.GetStartTime())), cLocaManager.DURATION_FORMAT_SHORT);
                            _local_2.RenderTextAboveGo(_arg_1, (((_local_10.GetBuffDefinition().GetName_string() + " (") + _local_11) + ")"), _local_7);
                            _local_7 = (_local_7 + 15);
                        };
                    };
                };
            };
            if (((this.mGeneralInterface.showCollectibleBuildingDebugGrid) && (ACTIVATE_RENDER_DEBUG_INFO_OVER_BUILDING)))
            {
                for each (_local_2 in this.GetBuildings_vector())
                {
                    if (null != _local_2)
                    {
                        if ((_local_2 is cCollectibleBuilding))
                        {
                            _local_8 = ((("P: " + _local_2.getPlayerID()) + " M:") + _local_2.GetBuildingMode());
                            _local_8 = (_local_8 + (((((("\r" + "G:") + _local_2.GetGrid()) + " x: ") + (_local_2.GetGrid() % global.ui.mCurrentPlayerZone.mMapWidth)) + " y: ") + int((_local_2.GetGrid() / global.ui.mCurrentPlayerZone.mMapWidth))));
                            if (_local_2.GetResourceCreation() != null)
                            {
                                _local_8 = (_local_8 + (" R:" + _local_2.GetResourceCreation().GetProductionState()));
                            };
                            _local_2.RenderTextAboveGo(_arg_1, _local_8, -(global.streetGridY));
                            _local_9 = "";
                            _local_9 = ((_local_2.GetCurrentHitPoints() + "/") + _local_2.GetMaxHitPoints());
                            _local_2.RenderTextAboveGo(_arg_1, _local_9, -(global.streetGridY + 30));
                        };
                    };
                };
            };
        }

        public function SetStreet(_arg_1:cPlayerData, _arg_2:String, _arg_3:int, _arg_4:Boolean, _arg_5:Boolean):void
        {
            var _local_6:cStreet = this.calculateSetStreetData(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            if (_arg_4)
            {
                gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_3, this.mTempPos);
                _local_6.SetSubType(_local_6.getSkin());
                _local_6.SetVariationNr(_local_6.GetVariationNr());
                _local_6.SetPosition(this.mTempPos.x, this.mTempPos.y);
                this.mStreetCreationPreview_vector.push(_local_6);
            }
            else
            {
                this.SetStreetGridPos(_local_6, _arg_3);
                this.mGeneralInterface.mCurrentPlayerZone.SetBackgroundHasChanged(true);
            };
        }

        public function IsBlockedAllowedNothing(_arg_1:int):Boolean
        {
            var _local_2:int = this.mAdditionalData.get(_arg_1, AdditionalDataTSO.Blocked);
            return (((_local_2 == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING) || (_local_2 == cBlockingData.BLOCK_TYPE_ALLOW_WATERBUILD)) || (_local_2 == cBlockingData.BLOCK_TYPE_ALLOW_SAFE));
        }

        public function BuildingAndLandscapeDebugInfo(_arg_1:Graphics):void
        {
            var _local_2:Array;
            var _local_3:String;
            var _local_4:cGO;
            if (((!(this.mGeneralInterface.showBuildingAndLandscapeDebug == "")) && (ACTIVATE_RENDER_DEBUG_INFO_OVER_BUILDING)))
            {
                _local_2 = this.mGeneralInterface.showBuildingAndLandscapeDebug.split(",");
                for each (_local_3 in _local_2)
                {
                    for each (_local_4 in this.mBuildingsAndTrees_vector)
                    {
                        if (_local_4.GetContainerName_string().toLowerCase().indexOf(_local_3) != -1)
                        {
                            _local_4.RenderTextAboveGo(_arg_1, _local_4.GetContainerName_string(), -(global.streetGridY));
                        };
                    };
                };
            };
        }

        public function RenderBackgroundGrid():void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_1:cClippingRectangle = new cClippingRectangle();
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_1);
            var _local_2:int;
            var _local_3:int;
            var _local_4:int = (global.streetGridX * _local_1.minX);
            _local_3 = (_local_3 + (global.streetGridYHalf * _local_1.minY));
            var _local_5:int = _local_1.minY;
            while (_local_5 <= _local_1.maxY)
            {
                if ((_local_5 & 0x01) == 0)
                {
                    _local_2 = (-(global.streetGridXHalf) + _local_4);
                }
                else
                {
                    _local_2 = _local_4;
                };
                _local_6 = ((_local_5 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1.minX);
                _local_7 = _local_1.minX;
                while (_local_7 <= _local_1.maxX)
                {
                    switch (this.mAdditionalData.get(_local_6, AdditionalDataTSO.BackgroundBlocking))
                    {
                        case TERRAIN_TYPE.WATER:
                            this.mGeneralInterface.mStreetCursorBlue.SetPosition(_local_2, _local_3);
                            this.mGeneralInterface.mStreetCursorBlue.Render();
                            break;
                        case TERRAIN_TYPE.GRASS:
                        case TERRAIN_TYPE.DESERT_LOW:
                            this.mGeneralInterface.mStreetCursorGreen.SetPosition(_local_2, _local_3);
                            this.mGeneralInterface.mStreetCursorGreen.Render();
                            break;
                        case TERRAIN_TYPE.MARKER:
                            this.mGeneralInterface.mStreetCursorWhite.SetPosition(_local_2, _local_3);
                            this.mGeneralInterface.mStreetCursorWhite.Render();
                            break;
                        case TERRAIN_TYPE.BORDER:
                            this.mGeneralInterface.mStreetCursorRed.SetPosition(_local_2, _local_3);
                            this.mGeneralInterface.mStreetCursorRed.Render();
                            break;
                        case TERRAIN_TYPE.MUD:
                        case TERRAIN_TYPE.DESERT_HIGH:
                            this.mGeneralInterface.mStreetCursorYellow.SetPosition(_local_2, _local_3);
                            this.mGeneralInterface.mStreetCursorYellow.Render();
                    };
                    _local_2 = (_local_2 + global.streetGridX);
                    _local_6++;
                    _local_7++;
                };
                _local_3 = (_local_3 + global.streetGridYHalf);
                _local_5++;
            };
        }

        public function RenderSelectBuildingInfo():void
        {
            this.RenderIslandHighlight();
        }

        public function IsBuildingWatching(_arg_1:uint, _arg_2:cBuilding):Boolean
        {
            var _local_4:int;
            var _local_3:Vector.<cBuilding> = this.mWatchingContainer.get(_arg_1);
            if (_local_3 != null)
            {
                _local_4 = _local_3.indexOf(_arg_2);
                if (_local_4 != -1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function CreateCombatData(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int, _arg_4:cCombat):void
        {
            if (!this.mCombatContainer.containsKey(_arg_3))
            {
                this.mCombatContainer.put(_arg_3, new cCombatData(_arg_1, _arg_2, _arg_3, _arg_4));
            };
        }

        private function AddDepositIcon(_arg_1:cDeposit):void
        {
            var _local_6:String;
            var _local_2:int = _arg_1.GetGrid();
            var _local_3:cLandscape = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(_local_2);
            if (_local_3 == null)
            {
                return;
            };
            var _local_4:cBuilding = this.mBuildingContainer.get(_local_2);
            if (((!(_local_4 == null)) && (!(this.IsADepletedDeposit(_local_4)))))
            {
                return;
            };
            var _local_5:String = _local_3.GetContainerName_string();
            if (this.mGeneralInterface.mCurrentPlayerZone.IsDepositFoundType(_local_5))
            {
                if (_arg_1.GetAmount() > 0)
                {
                    _local_6 = gMisc.GetSubString_string(_local_5, defines.DEPOSITFOUND_NAME_string.length, (_local_5.length - defines.DEPOSITFOUND_NAME_string.length));
                    this.mGeneralInterface.mCurrentPlayerZone.AddDepositIcon(_local_6, _local_2);
                };
            };
        }

        public function RemoveLandscapeFromList(_arg_1:cLandscape):void
        {
            var _local_2:int = this.mBuildingsAndTrees_vector.indexOf(_arg_1);
            if (_local_2 != -1)
            {
                this.mBuildingsAndTrees_vector.splice(_local_2, 1);
            };
        }

        public function RemoveBuildingFromList(_arg_1:cBuilding):void
        {
            var _local_2:int;
            var _local_5:cBuilding;
            var _local_6:Vector.<cBuilding>;
            var _local_3:int = _arg_1.GetGrid();
            _local_2 = 0;
            while (_local_2 < this.mBuildingsAndTrees_vector.length)
            {
                if ((this.mBuildingsAndTrees_vector[_local_2] is cBuilding))
                {
                    _local_5 = (this.mBuildingsAndTrees_vector[_local_2] as cBuilding);
                    if (_local_5.GetGrid() == _local_3)
                    {
                        this.mBuildingsAndTrees_vector.splice(_local_2, 1);
                        _local_2--;
                    };
                };
                _local_2++;
            };
            var _local_4:String = _arg_1.GetBuildingName_string();
            if (_local_4 != null)
            {
                if ((_local_4 in this.mBuildingsLookupByName_map))
                {
                    _local_6 = this.mBuildingsLookupByName_map[_local_4];
                    _local_2 = 0;
                    while (_local_2 < _local_6.length)
                    {
                        if (_local_6[_local_2] == _arg_1)
                        {
                            _local_6.splice(_local_2, 1);
                            _local_2--;
                        };
                        _local_2++;
                    };
                    this.mTaskBuildings_map.remove(_local_4);
                };
            };
            notifyPropertyObserver("mBuildings_vector#removed", _arg_1);
            notifyPropertyObserver("mBuildings_vector", this.mBuildingContainer.valueCollection());
        }

        public function getCurrentNbOfPickups(_arg_1:int):int
        {
            if (this.pickups[_arg_1] != null)
            {
                return (DictionaryUtils.countDictionaryKeys(this.pickups[_arg_1]));
            };
            return (0);
        }

        private function calculateStreetVariation(_arg_1:cStreet, _arg_2:int, _arg_3:Boolean):void
        {
            var _local_4:int = (_arg_2 - 1);
            if (((_local_4 < 0) || (this.mGeneralInterface.IsAdventureZoneID(this.mGeneralInterface.mHomePlayer.GetPlayerId()))))
            {
                _local_4 = 0;
            };
            _arg_1.setSkin(_local_4);
            _arg_1.SetVariationNr(((_arg_3) ? 0 : gMisc.GetRandomMinMaxInt(0, 99)));
        }

        public function CalculateFogBorders(_arg_1:cPlayerData):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:cSector;
            var _local_8:int;
            var _local_10:Random;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:cVectorListInt;
            var _local_19:int;
            var _local_9:int = _arg_1.GetPlayerId();
            if (!this.mGeneralInterface.showFogOfWar)
            {
                this.mGeneralInterface.mCurrentPlayerZone.SetFogRendering(false);
            }
            else
            {
                _local_10 = new Random(127);
                _local_11 = this.mGeneralInterface.mCurrentPlayerZone.mMapWidth;
                _local_12 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
                _local_13 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
                _local_14 = (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX + 2);
                _local_15 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY;
                if (this.useAnnoOnlineFog)
                {
                    _local_3 = _local_13;
                    while (_local_3 <= _local_15)
                    {
                        _local_4 = ((_local_3 * _local_11) + _local_12);
                        _local_2 = _local_12;
                        while (_local_2 < _local_14)
                        {
                            this.mAdditionalData2.set(_local_4, AdditionalDataTSO.Fog, 0);
                            _local_8 = this.mAdditionalData.get(_local_4, AdditionalDataTSO.Sector);
                            _local_7 = this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_8];
                            if (((_local_8 > 0) || (this.useContinentalFog)))
                            {
                                if ((((!(_local_7.GetOwnerPlayerID() == _local_9)) && ((this.useContinentalFog) || (!(this.mGeneralInterface.IsAdventureZoneID(_local_9))))) && (!(SECTOR_DISCOVERY_TYPE.isExplored(_arg_1.GetSectorDiscovery(_local_8))))))
                                {
                                    this.mAdditionalData2.set(_local_4, AdditionalDataTSO.Fog, FOG_SMOOTHING_INSIDE);
                                };
                            };
                            _local_4++;
                            _local_2++;
                        };
                        _local_3++;
                    };
                    _local_16 = 0;
                    while (_local_16 < FOG_SMOOTHING_INSIDE)
                    {
                        this.smoothFogBorder(FOG_SMOOTHING_INSIDE, _local_16, (_local_16 + 1));
                        _local_16++;
                    };
                    _local_3 = _local_13;
                    while (_local_3 <= _local_15)
                    {
                        _local_4 = ((_local_3 * _local_11) + _local_12);
                        _local_2 = _local_12;
                        while (_local_2 < _local_14)
                        {
                            if (this.mAdditionalData2.get(_local_4, AdditionalDataTSO.Fog) != 0)
                            {
                                if (this.mAdditionalData2.get(_local_4, AdditionalDataTSO.Fog) > 8)
                                {
                                    this.mAdditionalData2.set(_local_4, AdditionalDataTSO.FogFrame, 0);
                                }
                                else
                                {
                                    _local_17 = _local_10.NextMax(0xFF);
                                    if ((_local_3 & 0x03) == 0)
                                    {
                                        this.mAdditionalData2.set(_local_4, AdditionalDataTSO.FogFrame, (((_local_4 + _local_3) + _local_17) % 3));
                                    }
                                    else
                                    {
                                        this.mAdditionalData2.set(_local_4, AdditionalDataTSO.FogFrame, (((_local_4 + _local_2) + _local_17) % 3));
                                    };
                                };
                            };
                            _local_4++;
                            _local_2++;
                        };
                        _local_3++;
                    };
                }
                else
                {
                    _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
                    while (_local_3 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY)
                    {
                        _local_4 = ((_local_3 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX);
                        _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
                        while (_local_2 < (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX + 2))
                        {
                            this.mAdditionalData2.set(_local_4, AdditionalDataTSO.Fog, 0);
                            _local_8 = this.mAdditionalData.get(_local_4, AdditionalDataTSO.Sector);
                            _local_7 = this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_8];
                            if (_local_8 > 0)
                            {
                                if ((((!(_local_7.GetOwnerPlayerID() == _local_9)) && (!(this.mGeneralInterface.IsAdventureZoneID(_local_9)))) && (!(SECTOR_DISCOVERY_TYPE.isExplored(_arg_1.GetSectorDiscovery(_local_8))))))
                                {
                                    this.mAdditionalData2.set(_local_4, AdditionalDataTSO.Fog, 4);
                                };
                            };
                            _local_4++;
                            _local_2++;
                        };
                        _local_3++;
                    };
                    _local_3 = _local_13;
                    while (_local_3 <= _local_15)
                    {
                        _local_4 = ((_local_3 * _local_11) + _local_12);
                        _local_18 = this.mGeneralInterface.mCurrentPlayerZone.m8DirectionTableStreetGridDirection_vector[(_local_3 & 0x01)];
                        _local_2 = _local_12;
                        while (_local_2 < _local_14)
                        {
                            if (this.mAdditionalData2.get(_local_4, AdditionalDataTSO.Fog) == 4)
                            {
                                _local_19 = 0;
                                while (_local_19 < 8)
                                {
                                    _local_6 = (_local_4 + _local_18.mList_vector[_local_19]);
                                    if (this.mAdditionalData2.get(_local_6, AdditionalDataTSO.Fog) == 0)
                                    {
                                        this.mAdditionalData2.set(_local_4, AdditionalDataTSO.Fog, 1);
                                        break;
                                    };
                                    _local_19++;
                                };
                            };
                            _local_4++;
                            _local_2++;
                        };
                        _local_3++;
                    };
                    _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
                    while (_local_3 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY)
                    {
                        _local_4 = ((_local_3 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX);
                        _local_18 = this.mGeneralInterface.mCurrentPlayerZone.m8DirectionTableStreetGridDirection_vector[(_local_3 & 0x01)];
                        _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
                        while (_local_2 < (this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX + 2))
                        {
                            if (this.mAdditionalData2.get(_local_4, AdditionalDataTSO.Fog) == 4)
                            {
                                _local_5 = 0;
                                while (_local_5 < 8)
                                {
                                    _local_6 = (_local_4 + _local_18.mList_vector[_local_5]);
                                    if (this.mAdditionalData2.get(_local_6, AdditionalDataTSO.Fog) == 1)
                                    {
                                        this.mAdditionalData2.set(_local_4, AdditionalDataTSO.Fog, 2);
                                        break;
                                    };
                                    _local_5++;
                                };
                            };
                            _local_4++;
                            _local_2++;
                        };
                        _local_3++;
                    };
                    _local_3 = _local_13;
                    while (_local_3 <= _local_15)
                    {
                        _local_4 = ((_local_3 * _local_11) + _local_12);
                        _local_18 = this.mGeneralInterface.mCurrentPlayerZone.m8DirectionTableStreetGridDirection_vector[(_local_3 & 0x01)];
                        _local_2 = _local_12;
                        while (_local_2 < _local_14)
                        {
                            if (this.mAdditionalData2.get(_local_4, AdditionalDataTSO.Fog) == 4)
                            {
                                _local_5 = 0;
                                while (_local_5 < 8)
                                {
                                    _local_6 = (_local_4 + _local_18.mList_vector[_local_5]);
                                    if (this.mAdditionalData2.get(_local_6, AdditionalDataTSO.Fog) == 2)
                                    {
                                        this.mAdditionalData2.set(_local_4, AdditionalDataTSO.Fog, 3);
                                        break;
                                    };
                                    _local_5++;
                                };
                            };
                            _local_4++;
                            _local_2++;
                        };
                        _local_3++;
                    };
                };
            };
            this.mGeneralInterface.channels.ZONE.send(ZoneChannel.FOG_RECALCULATED, null);
            cBackbuffer.clearFogCache();
        }

        public function SetBackground(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:int = gCalculations.ConvertPixelPosToStreetGridPos(global.ui.mCurrentPlayerZone, _arg_1, _arg_2);
            if (_local_4 == defines.ILLEGAL_INT_POS)
            {
                return;
            };
            this.mBlockingSourceData.set(_local_4, AdditionalDataTSO.BlockingSource, _arg_3);
        }

        public function IsWatchedByTowers(_arg_1:uint, _arg_2:cGeneralInterface):Boolean
        {
            var _local_4:int;
            var _local_5:int;
            var _local_3:Vector.<cBuilding> = this.mWatchingContainer.get(_arg_1);
            if (((!(_local_3 == null)) && (_local_3.length > 0)))
            {
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    _local_5 = _arg_2.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_3[_local_4].GetGrid(), AdditionalDataTSO.Sector);
                    if (((SECTOR_DISCOVERY_TYPE.isExplored(_arg_2.mCurrentPlayer.GetSectorDiscovery(_local_5))) || (_arg_2.IsAdventureZone())))
                    {
                        return (true);
                    };
                    _local_4++;
                };
            };
            return (false);
        }

        public function hasTaskBuilding(_arg_1:String):Boolean
        {
            return (this.mTaskBuildings_map.hasKey(_arg_1));
        }

        public function RenderIsoElementDebugInfo(_arg_1:Graphics):void
        {
            var _local_2:cClippingRectangle;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            if (((this.mGeneralInterface.showIsoDebugGrid) && (ACTIVATE_ISO_RENDER_DEBUG_INFO)))
            {
                _local_2 = new cClippingRectangle();
                this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_2);
                _local_3 = 0;
                _local_4 = 0;
                _local_5 = (global.streetGridX * _local_2.minX);
                _local_4 = (_local_4 + (global.streetGridYHalf * _local_2.minY));
                _local_6 = _local_2.minY;
                while (_local_6 <= _local_2.maxY)
                {
                    if ((_local_6 & 0x01) == 0)
                    {
                        _local_3 = (-(global.streetGridXHalf) + _local_5);
                    }
                    else
                    {
                        _local_3 = _local_5;
                    };
                    _local_7 = ((_local_6 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_2.minX);
                    _local_8 = _local_2.minX;
                    while (_local_8 <= _local_2.maxX)
                    {
                        this.mGeneralInterface.mStreetCursorGrid.SetPosition(_local_3, _local_4);
                        this.mGeneralInterface.mStreetCursorGrid.Render();
                        if (this.mAdditionalData2.get(_local_7, AdditionalDataTSO.Fog) != 0)
                        {
                            this.mGeneralInterface.mCurrentPlayerZone.RenderText(cBackbuffer.mBackBuffer, ("F:" + this.mAdditionalData2.get(_local_7, AdditionalDataTSO.Fog)), (_local_3 - 8), (_local_4 + 8));
                        };
                        if (this.mAdditionalData2.get(_local_7, AdditionalDataTSO.FogFrame) != 0)
                        {
                            this.mGeneralInterface.mCurrentPlayerZone.RenderText(cBackbuffer.mBackBuffer, ("fr:" + this.mAdditionalData2.get(_local_7, AdditionalDataTSO.FogFrame)), (_local_3 - 8), (_local_4 + 24));
                        };
                        _local_3 = (_local_3 + global.streetGridX);
                        _local_7++;
                        _local_8++;
                    };
                    _local_4 = (_local_4 + global.streetGridYHalf);
                    _local_6++;
                };
            };
        }

        public function RefreshDepositGfx(_arg_1:int):void
        {
            var _local_3:cGOSetListController;
            var _local_2:cDeposit = this.mDepositContainer.get(_arg_1);
            if (_local_2 != null)
            {
                if (_local_2.GetGOSetListName_string() != null)
                {
                    _local_3 = new cGOSetListControllerPercentage(_local_2.GetMaxAmount());
                    _local_2.mDepositGfx = cGOSetManager.CreateGOSetList(_local_2.GetGOSetListName_string(), _local_3);
                    _local_2.mDepositGfx.SetValue(_local_2.GetAmount());
                }
                else
                {
                    _local_2.mDepositGfx = null;
                };
            };
        }

        public function isSectorOwnedAtGridPosition(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector);
            return (this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_3].GetOwnerPlayerID() == _arg_2);
        }

        public function CalculateMapClipping(_arg_1:int, _arg_2:cClippingRectangle):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Number;
            var _local_8:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
            var _local_9:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            var _local_10:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX;
            var _local_11:int = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY;
            if (_arg_1 == GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND)
            {
                _local_7 = this.mGeneralInterface.mZoom.Scale(-(global.screenWidthHalf), cZoom.HUNDRED_PERCENT_ZOOM);
                _local_3 = (_local_7 + this.mGeneralInterface.mZoom.GetScrollPosXInt());
                _local_7 = this.mGeneralInterface.mZoom.Scale(-(global.screenHeightHalf), cZoom.HUNDRED_PERCENT_ZOOM);
                _local_4 = (_local_7 + this.mGeneralInterface.mZoom.GetScrollPosYInt());
                _local_7 = this.mGeneralInterface.mZoom.Scale(global.screenWidthHalf, cZoom.HUNDRED_PERCENT_ZOOM);
                _local_5 = (_local_7 + this.mGeneralInterface.mZoom.GetScrollPosXInt());
                _local_7 = this.mGeneralInterface.mZoom.Scale(global.screenHeightHalf, cZoom.HUNDRED_PERCENT_ZOOM);
                _local_6 = (_local_7 + this.mGeneralInterface.mZoom.GetScrollPosYInt());
                _local_3 = int((_local_3 / global.streetGridX));
                _local_4 = int((_local_4 / global.streetGridYHalf));
                _local_5 = int((_local_5 / global.streetGridX));
                _local_6 = int((_local_6 / global.streetGridYHalf));
                _local_5 = (_local_5 + 2);
                _local_4 = (_local_4 + 1);
                _local_6 = (_local_6 + 8);
                if (_local_3 < _local_8)
                {
                    _local_3 = _local_8;
                };
                if (_local_4 < _local_9)
                {
                    _local_4 = _local_9;
                };
                if (_local_5 > _local_10)
                {
                    _local_5 = _local_10;
                };
                if (_local_6 > _local_11)
                {
                    _local_6 = _local_11;
                };
            }
            else
            {
                if (_arg_1 == GCB_MODE_CLIPPING.CLIP_TO_SCREEN_BACKGROUND)
                {
                    _local_3 = this.mGeneralInterface.mZoom.Scale(((cBackbuffer.mClipMinX - global.screenWidthHalf) - (cBackbuffer.mWidthSegment * 2)), cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_4 = this.mGeneralInterface.mZoom.Scale(((cBackbuffer.mClipMinY - global.screenHeightHalf) - (cBackbuffer.mHeightSegment * 2)), cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_5 = this.mGeneralInterface.mZoom.Scale(((cBackbuffer.mClipMaxX - global.screenWidthHalf) + (cBackbuffer.mWidthSegment * 2)), cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_6 = this.mGeneralInterface.mZoom.Scale(((cBackbuffer.mClipMaxY - global.screenHeightHalf) + (cBackbuffer.mHeightSegment * 2)), cZoom.HUNDRED_PERCENT_ZOOM);
                    _local_3 = int((_local_3 / global.streetGridX));
                    _local_4 = int((_local_4 / global.streetGridYHalf));
                    _local_5 = int((_local_5 / global.streetGridX));
                    _local_6 = int((_local_6 / global.streetGridYHalf));
                    _local_5 = (_local_5 + 1);
                    _local_6 = (_local_6 + 1);
                    if (_local_3 < _local_8)
                    {
                        _local_3 = _local_8;
                    };
                    if (_local_4 < _local_9)
                    {
                        _local_4 = _local_9;
                    };
                    if (_local_5 > _local_10)
                    {
                        _local_5 = _local_10;
                    };
                    if (_local_6 > _local_11)
                    {
                        _local_6 = _local_11;
                    };
                }
                else
                {
                    _local_3 = _local_8;
                    _local_4 = _local_9;
                    _local_5 = _local_10;
                    _local_6 = _local_11;
                };
            };
            _arg_2.minX = _local_3;
            _arg_2.minY = _local_4;
            _arg_2.maxX = _local_5;
            _arg_2.maxY = _local_6;
        }

        public function LogicCompute():void
        {
            var _local_3:cBuilding;
            var _local_4:int;
            if (this.useAnnoOnlineFog != this.mGeneralInterface.killswitch.isAccessible(KILL_SWITCH.ZONE_ANNOFOG))
            {
                this.useAnnoOnlineFog = this.mGeneralInterface.killswitch.isAccessible(KILL_SWITCH.ZONE_ANNOFOG);
                this.CalculateBorders();
                this.CalculateFogBorders(this.mGeneralInterface.mCurrentPlayer);
                this.mGeneralInterface.mCurrentPlayerZone.SetBackgroundHasChanged(true);
            };
            var _local_1:Vector.<cBuilding> = this.GetBuildings_vector();
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                _local_3 = _local_1[_local_2];
                if (null != _local_3)
                {
                    _local_4 = _local_1.length;
                    _local_3.Compute();
                    _local_2 = (_local_2 - (_local_4 - _local_1.length));
                };
                _local_2++;
            };
        }

        public function RefreshMayorHouse():void
        {
            this.mMayorHouse = this.getBuildingByName(defines.MAYORHOUSE_NAME_string);
            if (this.mMayorHouse == null)
            {
            };
        }

        public function GetDeposits_vector():Vector.<cDeposit>
        {
            return (this.mDeposits_vector);
        }

        public function GetBuildingNameFromGridPos_string(_arg_1:int):String
        {
            var _local_2:cGO = this.mBuildingContainer.get(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2.GetContainerName_string());
            };
            return (null);
        }

        public function CheckIfBuildingIsSouthSouthEastAndSouthWest(_arg_1:int):cBuilding
        {
            var _local_2:int;
            var _local_3:cBuilding;
            var _local_4:int;
            var _local_5:cBuilding;
            if (!defines.EXTENDED_BUILDING_SELECTION)
            {
                return (null);
            };
            _local_2 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, defines.DIR8_SOUTH);
            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_2);
            if ((((!(_local_3 == null)) && (_local_3.GetGoGroup() == global.buildingGroup)) && (!(global.hiddenBanditCamps_dictionary.Contains(_local_3.GetBuildingName_string())))))
            {
                return (_local_3);
            };
            _local_2 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, defines.DIR8_SOUTH_EAST);
            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_2);
            if ((((!(_local_3 == null)) && (_local_3.GetGoGroup() == global.buildingGroup)) && (!(global.hiddenBanditCamps_dictionary.Contains(_local_3.GetBuildingName_string())))))
            {
                return (_local_3);
            };
            _local_2 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, defines.DIR8_SOUTH_WEST);
            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_2);
            if ((((!(_local_3 == null)) && (_local_3.GetGoGroup() == global.buildingGroup)) && (!(global.hiddenBanditCamps_dictionary.Contains(_local_3.GetBuildingName_string())))))
            {
                return (_local_3);
            };
            _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBlockingSourceData.get(_arg_1, AdditionalDataTSO.BlockingSource);
            if (-1 != _local_4)
            {
                _local_5 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_4);
                if ((((!(_local_5 == null)) && (_local_5.GetGoGroup() == global.buildingGroup)) && (!(global.hiddenBanditCamps_dictionary.Contains(_local_5.GetBuildingName_string())))))
                {
                    return (_local_5);
                };
            };
            return (null);
        }

        public function RenderFog():void
        {
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_1:cClippingRectangle = new cClippingRectangle();
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_1);
            var _local_2:int;
            var _local_3:int;
            var _local_4:int = (global.streetGridX * _local_1.minX);
            _local_3 = (_local_3 + (global.streetGridYHalf * _local_1.minY));
            var _local_5:int;
            var _local_6:int = 3;
            var _local_7:int = 3;
            var _local_8:int = int((gMisc.GetTimeSinceStartup() / 120));
            var _local_9:int = (_local_1.minX % _local_6);
            _local_4 = (_local_4 - (_local_9 * global.streetGridX));
            _local_1.minX = (_local_1.minX - _local_9);
            _local_1.maxX = (_local_1.maxX + (_local_6 - _local_9));
            var _local_10:int = (_local_1.minY % _local_7);
            _local_3 = (_local_3 - (_local_10 * global.streetGridYHalf));
            _local_1.minY = (_local_1.minY - _local_10);
            this.mGeneralInterface.mFog.SetSubType(0);
            var _local_11:int = _local_1.minY;
            while (_local_11 <= _local_1.maxY)
            {
                if ((_local_11 & 0x01) == 0)
                {
                    _local_2 = (-(global.streetGridXHalf) + _local_4);
                }
                else
                {
                    _local_2 = _local_4;
                };
                _local_12 = ((_local_11 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1.minX);
                if (_local_12 >= 0)
                {
                    _local_13 = _local_1.minX;
                    while (_local_13 < (_local_1.maxX + 2))
                    {
                        if (this.mAdditionalData2.get(_local_12, AdditionalDataTSO.Fog) > 1)
                        {
                            _local_14 = 0;
                            if ((_local_11 & 0x03) == 0)
                            {
                                _local_5 = int(((_local_12 + (_local_11 / _local_6)) % 3));
                            }
                            else
                            {
                                _local_5 = int((((_local_12 + _local_13) / _local_6) % 3));
                            };
                            this.mGeneralInterface.mFog.SetAnimFrame(_local_5);
                            _local_15 = ((_local_8 + (_local_13 << 4)) & 0xFF);
                            _local_16 = ((_local_8 + (_local_11 << 3)) & 0xFF);
                            this.mGeneralInterface.mFog.RenderPos((_local_2 + this.mSinTable_vector[_local_15]), (_local_3 + this.mCosTable_vector[_local_16]));
                        };
                        _local_2 = (_local_2 + (global.streetGridX * _local_6));
                        _local_12 = (_local_12 + _local_6);
                        _local_13 = (_local_13 + _local_6);
                    };
                    _local_3 = (_local_3 + (global.streetGridYHalf * _local_7));
                };
                _local_11 = (_local_11 + _local_7);
            };
        }

        public function DepositGroupConvertXMLStringToMap(_arg_1:String, _arg_2:int):void
        {
            var _local_4:int;
            var _local_7:cXML;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:String;
            var _local_13:cDepositGroup;
            var _local_3:cXML = new cXML();
            _local_3.SetXMLString(_arg_1);
            var _local_5:cXML = _local_3.MoveToSubNode("DepositGroups");
            var _local_6:Vector.<cXML> = _local_5.CreateChildrenArray();
            this.mGeneralInterface.mServerOnly.mDepositGroups_vector.length = 0;
            for each (_local_7 in _local_6)
            {
                _local_8 = _local_7.GetAttributeInt("id");
                _local_9 = _local_7.GetAttributeInt("maxAccessible");
                _local_10 = _local_7.GetAttributeInt("accessibleFromStart");
                _local_11 = _local_7.GetAttributeInt("averageAmount");
                _local_12 = _local_7.GetAttributeString_string("depositName");
                _local_13 = new cDepositGroup(this.mGeneralInterface, _local_8, _local_9, _local_10, _local_11, _local_12);
                this.mGeneralInterface.mServerOnly.mDepositGroups_vector.push(_local_13);
            };
            this.mDepositContainer.clear();
            this.mDeposits_vector = new Vector.<cDeposit>();
            this.UpdateObjectPositions();
        }

        public function RefreshGuildBankHouse():void
        {
            var _local_1:cBuilding;
            this.SetGuildBankHouse(null);
            for each (_local_1 in this.GetBuildings_vector())
            {
                if (null != _local_1)
                {
                    if (((_local_1.GetBuildingName_string() == defines.GUILDBANK_NAME_string) && (_local_1.IsBuildingActive())))
                    {
                        this.SetGuildBankHouse(_local_1);
                        break;
                    };
                };
            };
        }

        public function AddWatchingBuilding(_arg_1:uint, _arg_2:cBuilding, _arg_3:int):void
        {
            var _local_4:Vector.<cBuilding> = this.mWatchingContainer.get(_arg_1);
            if (_local_4 == null)
            {
                _local_4 = new Vector.<cBuilding>();
                this.mWatchingContainer.put(_arg_1, _local_4);
            };
            if (_arg_3 == this.mAdditionalData.get(_arg_1, AdditionalDataTSO.Sector))
            {
                _local_4.push(_arg_2);
            };
        }

        public function Init():void
        {
        }

        public function getRandomDepositByType(_arg_1:String, _arg_2:int):cDeposit
        {
            var _local_4:int;
            var _local_3:Vector.<cDeposit> = this.getDeposits_vectorByType(_arg_1);
            if (_local_3.length > 0)
            {
                _local_4 = gMisc.getPseudoRandomMinMax(_arg_2, 0, (_local_3.length - 1));
                return (_local_3[_local_4]);
            };
            return (null);
        }

        public function SetBuildingGridPos(_arg_1:cGO, _arg_2:int, _arg_3:Boolean):Boolean
        {
            var _local_6:String;
            var _local_4:cBuilding = (_arg_1 as cBuilding);
            gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_2, this.mTempPos);
            _local_4.SetPosition(this.mTempPos.x, (this.mTempPos.y + global.streetGridYHalf));
            if (_arg_2 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            if (this.mBuildingContainer.containsKey(_arg_2))
            {
                return (false);
            };
            var _local_5:cLandscape = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mLandscapeContainer.get(_arg_2);
            if (_local_5 != null)
            {
                _local_6 = _local_5.GetContainerName_string();
                if (this.mGeneralInterface.mCurrentPlayerZone.IsDepositFoundType(_local_6))
                {
                    this.mGeneralInterface.mCurrentPlayerZone.RemoveDepositIcon(_arg_2);
                }
                else
                {
                    _local_5.setVisible(false);
                };
            };
            _local_4.mBuildingCreationTime = this.mGeneralInterface.GetClientTime();
            _local_4.SetGrid(_arg_2);
            _local_4.SetBuildingMode(cBuilding.BUILDING_MODE_NONE);
            _local_4.createStackingBuffs();
            this.mBuildingContainer.put(_arg_2, _local_4);
            this.AddBuildingToList(_local_4);
            if (!_arg_3)
            {
                _local_4.SetBuildingMode(cBuilding.BUILDING_MODE_PRODUCES_NO_RESOURCES);
            }
            else
            {
                _local_4.SetBuildingMode(cBuilding.BUILDING_MODE_QUEUED);
                this.AddBuildingToGameLogic(_local_4);
                _local_4.SetCollectibleMode();
            };
            this.mGeneralInterface.mCurrentPlayerZone.mSettlerKIManager.BuildingWasPlaced(_local_4, _arg_2);
            this.RecalculateBlockingGridAndPathFinding(_local_4.getPlayerID());
            if (this.mGeneralInterface.mCurrentViewedZoneID > defines.ADVENTUREZONEID)
            {
                this.mGeneralInterface.mConditionManager.createTriggers(_local_4, this.mGeneralInterface);
            };
            return (true);
        }

        public function IsBlockedAllowedNothingOrFog(_arg_1:int):Boolean
        {
            return ((this.IsBlockedAllowedNothing(_arg_1)) || (this.IsFogAtGridPosition(_arg_1)));
        }

        public function getPickups(_arg_1:int):Dictionary
        {
            return (this.pickups[_arg_1]);
        }

        public function RemoveBuildingFromGameLogicKeepResourceCreation(_arg_1:cBuilding):void
        {
            var _local_2:cDeposit;
            var _local_3:int;
            if (!this.IsADepletedDeposit(_arg_1))
            {
                _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.get(_arg_1.GetGrid());
                if (_local_2 != null)
                {
                    this.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(_arg_1.getPlayerID(), _local_2.GetName_string(), cPathFinder.AMOUNT_TYPE_ABOVE_ZERO);
                    if (_local_2.GetDepositGroupID() != -1)
                    {
                        _local_2.SetAccessibleType(DEPOSIT_ACCESSIBLE_TYPES.NOT_ACCESSIBLE);
                        this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.remove(_arg_1.GetGrid());
                    }
                    else
                    {
                        if (_arg_1.GetGOContainer().mAddDepositAmount != -1)
                        {
                            _local_3 = _local_2.GetGrid();
                            this.RemoveDepositGridPos(_local_3, true);
                        };
                    };
                };
            };
            if (_arg_1.IsWarehouseType())
            {
                this.mGeneralInterface.mPathFinder.InvalidateWarehouseMatrix(_arg_1.getPlayerID());
            };
            if (!this.mGeneralInterface.mRefreshZoneIsActive)
            {
                this.mGeneralInterface.mCurrentPlayerZone.RemoveWatchArea(OBJECTTYPE.BUILDING, _arg_1.GetBuildingName_string(), _arg_1);
            };
            if (_arg_1.GetBuildingName_string() == defines.LOGISTICS_NAME_string)
            {
                this.SetLogisticsHouse(null);
            };
            if (_arg_1.GetBuildingName_string() == defines.GUILDHOUSE_NAME_string)
            {
                this.SetGuildHouse(null);
            };
            if (_arg_1.GetBuildingName_string() == defines.GUILDBANK_NAME_string)
            {
                this.SetGuildBankHouse(null);
            };
            if (_arg_1 == this.mGeneralInterface.GetSelectedBuilding())
            {
                this.mGeneralInterface.UnselectBuilding();
            };
        }

        public function RemoveWatchingBuilding(_arg_1:uint, _arg_2:cBuilding):void
        {
            var _local_4:int;
            var _local_3:Vector.<cBuilding> = this.mWatchingContainer.get(_arg_1);
            if (_local_3 != null)
            {
                _local_4 = _local_3.indexOf(_arg_2);
                if (_local_4 != -1)
                {
                    _local_3.splice(_local_4, 1);
                };
                if (_local_3.length == 0)
                {
                    this.mWatchingContainer.remove(_arg_1);
                };
            };
        }

        public function bindEpicWorkyardSubBuildings():void
        {
            var _local_1:cBuilding;
            var _local_2:EpicWorkyardMasterBuilding;
            for each (_local_1 in this.mBuildingContainer.valueCollection())
            {
                if (null != _local_1)
                {
                    if ((_local_1 is EpicWorkyardMasterBuilding))
                    {
                        _local_2 = (_local_1 as EpicWorkyardMasterBuilding);
                        _local_2.bindSubBuildings();
                    };
                };
            };
        }

        public function CreatePreviewPath(_arg_1:cPathObject, _arg_2:int):void
        {
            var _local_3:cPlayerZoneScreen;
            var _local_5:int;
            var _local_4:int = _arg_1.dest_vector.length;
            var _local_6:dPathObjectItem = new dPathObjectItem();
            _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_6 = (_arg_1.dest_vector[_local_5] as dPathObjectItem);
                _local_3 = this.mGeneralInterface.mCurrentPlayerZone;
                if (((((_local_6.x >= _local_3.mSectorStartX) && (_local_6.x <= _local_3.mSectorEndX)) && (_local_6.y >= _local_3.mSectorStartY)) && (_local_6.y <= _local_3.mSectorEndY)))
                {
                    _local_3.mStreetDataMap.SetPreviewPath(_local_6.streetGridIdx, _arg_2);
                };
                _local_5++;
            };
        }

        public function IsBlockedAllowedMoveOnly(_arg_1:int):Boolean
        {
            return (this.mAdditionalData.get(_arg_1, AdditionalDataTSO.Blocked) == cBlockingData.BLOCK_TYPE_ALLOW_MOVE);
        }

        public function SetBlocked(_arg_1:int, _arg_2:int):void
        {
            this.mAdditionalData.set(_arg_1, AdditionalDataTSO.Blocked, _arg_2);
        }

        public function ResetStreetPreview():void
        {
            this.mStreetCreationPreview_vector = new Vector.<cStreet>();
        }

        private function renderFogBorders(_arg_1:cClippingRectangle, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            _arg_1.minY = (_arg_1.minY - (_arg_3 * 2));
            if (_arg_1.minY < this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY)
            {
                _arg_1.minY = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            };
            var _local_16:* = -138;
            var _local_17:int = -104;
            _local_8 = 0;
            _local_9 = _local_17;
            _local_10 = (_local_16 + (global.streetGridX * _arg_1.minX));
            _local_9 = (_local_9 + (global.streetGridYHalf * _arg_1.minY));
            _local_11 = 0;
            _local_12 = int((gMisc.GetTimeSinceStartup() / 120));
            _local_13 = (_arg_1.minX % _arg_2);
            _local_10 = (_local_10 - (_local_13 * global.streetGridX));
            _arg_1.minX = (_arg_1.minX - _local_13);
            _arg_1.maxX = (_arg_1.maxX + (_arg_2 - _local_13));
            _local_14 = (_arg_1.minY % _arg_3);
            _local_9 = (_local_9 - (_local_14 * global.streetGridYHalf));
            _arg_1.minY = (_arg_1.minY - _local_14);
            _local_7 = _arg_1.minY;
            while (_local_7 <= _arg_1.maxY)
            {
                if ((_local_7 & 0x01) == 0)
                {
                    _local_8 = (global.streetGridXHalf + _local_10);
                }
                else
                {
                    _local_8 = _local_10;
                };
                _local_15 = ((_local_7 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _arg_1.minX);
                _local_6 = _arg_1.minX;
                while (_local_6 < (_arg_1.maxX + 2))
                {
                    if (((this.mAdditionalData2.get(_local_15, AdditionalDataTSO.Fog) > _arg_4) && (this.mAdditionalData2.get(_local_15, AdditionalDataTSO.Fog) < _arg_5)))
                    {
                        this.mGeneralInterface.mPatternFog.mSprite.RenderSubTypeAndFrame(_local_8, _local_9, 1, this.mAdditionalData2.get(_local_15, AdditionalDataTSO.FogFrame));
                    };
                    _local_8 = (_local_8 + (global.streetGridX * _arg_2));
                    _local_15 = (_local_15 + _arg_2);
                    _local_6 = (_local_6 + _arg_2);
                };
                _local_9 = (_local_9 + (global.streetGridYHalf * _arg_3));
                _local_7 = (_local_7 + _arg_3);
            };
        }

        public function GetPvpProgressionHouse():cBuilding
        {
            return (this.mPvpProgressionHouse);
        }

        public function getTaskBuildings_vector():Vector.<String>
        {
            var _local_2:String;
            var _local_1:Vector.<String> = new Vector.<String>();
            for each (_local_2 in this.mTaskBuildings_map.keySet())
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }

        public function RemoveStreetGridPos(_arg_1:int):Boolean
        {
            var _local_2:cStreet = this.mStreetContainer.get(_arg_1);
            if (_local_2 != null)
            {
                this.mStreetContainer.remove(_arg_1);
                this.mStreetVectorChanged = true;
                return (true);
            };
            return (false);
        }

        public function ShowWatchAreaPreview():void
        {
            var _local_6:cStreet;
            var _local_7:Vector.<int>;
            var _local_8:int;
            var _local_9:int;
            var _local_1:Vector.<int> = new Vector.<int>();
            var _local_2:int = 1;
            var _local_3:Boolean;
            var _local_4:int = -1;
            var _local_5:int = -1;
            if (this.mStreetCreationPreview_vector.length > 0)
            {
                _local_5 = this.mStreetCreationPreview_vector[(this.mStreetCreationPreview_vector.length - 1)].GetGrid();
                _local_4 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _local_5, defines.DIR8_NORTH_WEST);
            };
            for each (_local_6 in this.mStreetCreationPreview_vector)
            {
                if (_local_6.GetStreetType() == cStreet.TYPE_ARMY)
                {
                    _local_7 = this.GetReadyTowerGridIdxs(_local_6.GetGrid());
                    if (_local_7.indexOf(_local_5) != -1)
                    {
                        _local_7.length = 0;
                        _local_7.push(_local_5);
                    };
                    _local_8 = (_local_7.length - 1);
                    while (_local_8 >= 0)
                    {
                        _local_9 = _local_7[_local_8];
                        _local_9 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _local_9, defines.DIR8_NORTH_WEST);
                        if (_local_1.indexOf(_local_9) == -1)
                        {
                            this.RenderWatchAreaOfSelectedBuilding(this.mBuildingContainer.get(_local_9));
                            if (!global.hiddenBanditCamps_dictionary.Contains(this.mBuildingContainer.get(_local_9).GetBuildingName_string()))
                            {
                                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildingByGridPos(_local_9).SetInterceptIndex(_local_2);
                                _local_2++;
                            };
                            _local_1.push(_local_9);
                            if (_local_9 == _local_4)
                            {
                                return;
                            };
                        };
                        _local_8--;
                    };
                };
            };
        }

        public function RemoveBuildingFromGameLogic(_arg_1:cBuilding):void
        {
            this.RemoveBuildingFromGameLogicKeepResourceCreation(_arg_1);
            if (_arg_1.GetResourceCreation() != null)
            {
                _arg_1.GetResourceCreation().SetRemove(true);
            };
        }

        public function SetBackgroundBlocking(_arg_1:int, _arg_2:int):void
        {
            this.mAdditionalData.set(_arg_1, AdditionalDataTSO.BackgroundBlocking, _arg_2);
        }

        public function SetLandscapeFreePos(_arg_1:cGO, _arg_2:int, _arg_3:int):Boolean
        {
            var _local_4:cFreeLandscape = (_arg_1 as cFreeLandscape);
            _local_4.SetPosition(_arg_2, _arg_3);
            _local_4.SetName_string(_arg_1.GetContainerName_string());
            this.mFreeLandscape_vector.push(_local_4);
            return (true);
        }

        public function GetBackgroundBlocking(_arg_1:int):int
        {
            return (this.mAdditionalData.get(_arg_1, AdditionalDataTSO.BackgroundBlocking));
        }

        public function setInitialNumberOfPickups(_arg_1:int, _arg_2:int):void
        {
            this.initialNumberOfPickupsMap[_arg_1] = _arg_2;
            this.mGeneralInterface.channels.ZONE.collectiblesUpdated(_arg_2);
        }

        public function RenderCursorInfo():void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_1:cClippingRectangle = new cClippingRectangle();
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_1);
            var _local_2:int = (global.streetGridX * _local_1.minX);
            var _local_3:int = (global.streetGridYHalf * _local_1.minY);
            var _local_4:* = 1000;
            var _local_5:Boolean;
            var _local_6:int = _local_1.minY;
            while (_local_6 <= _local_1.maxY)
            {
                _local_7 = _local_2;
                if ((_local_6 & 0x01) == 0)
                {
                    _local_7 = (_local_7 - global.streetGridXHalf);
                };
                _local_8 = ((_local_6 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1.minX);
                _local_9 = (_local_8 + this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                _local_10 = _local_1.minX;
                while (_local_10 <= _local_1.maxX)
                {
                    _local_11 = this.mAdditionalData.get(_local_8, AdditionalDataTSO.Cursor);
                    if (_local_11 <= -1)
                    {
                        if (_local_4 > 0)
                        {
                            _local_9 = (_local_8 - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                            _local_5 = ((this.mAdditionalData.get(_local_9, AdditionalDataTSO.Cursor) > 0) || (this.mAdditionalData.get((_local_9 - 1), AdditionalDataTSO.Cursor) > 0));
                            if (((this.mGeneralInterface.mCurrentCursor.CheckIfGarrisonIsPlacableInGame(_local_8, _local_5) == CURSOR_VALID.OK) || (_local_11 == -2)))
                            {
                                this.mAdditionalData.set(_local_8, AdditionalDataTSO.Cursor, 1);
                            }
                            else
                            {
                                this.mAdditionalData.set(_local_8, AdditionalDataTSO.Cursor, 0);
                            };
                            _local_4--;
                        };
                    };
                    if (this.mAdditionalData.get(_local_8, AdditionalDataTSO.Cursor) == 1)
                    {
                        this.mGeneralInterface.mStreetCursorMagenta.SetPosition(_local_7, _local_3);
                        this.mGeneralInterface.mStreetCursorMagenta.Render();
                    };
                    _local_7 = (_local_7 + global.streetGridX);
                    _local_8++;
                    _local_10++;
                };
                _local_3 = (_local_3 + global.streetGridYHalf);
                _local_6++;
            };
        }

        public function RenderBuildingsWithSettlers(_arg_1:int):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:cSettler;
            var _local_14:int;
            var _local_15:Vector.<cBuilding>;
            var _local_16:cBuilding;
            var _local_17:cLandscape;
            var _local_18:cBuilding;
            var _local_19:cDeposit;
            var _local_20:cGO;
            var _local_21:cGoSetListAnimationItem;
            var _local_22:cGoSetListAnimationItem;
            var _local_2:int = -1;
            this.CalculateMapClipping(_arg_1, this.mTempClippingRectangle);
            if (globalFlash.useNewRender)
            {
                this.rect.copy(this.mTempClippingRectangle).expandMinMax(-2, -2, 2, 14).toPixel();
                if ((((this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SELECT_BUILDING) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.DELETE_BUILDING)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SELECT_BUILDING_TO_MOVE)))
                {
                    if (this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        _local_2 = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
                        this.SelectBuilding(_local_2, true);
                    };
                };
                if (this.mGeneralInterface.GetSelectedBuilding() != null)
                {
                    this.SelectBuilding(this.mGeneralInterface.GetSelectedBuilding().GetGrid(), true);
                };
                this.renderLayers.render(this.rect);
            }
            else
            {
                _local_3 = this.mTempClippingRectangle.minX;
                _local_4 = this.mTempClippingRectangle.minY;
                _local_5 = this.mTempClippingRectangle.maxX;
                _local_6 = this.mTempClippingRectangle.maxY;
                _local_7 = (_local_4 - 1);
                _local_8 = (_local_6 + 1);
                _local_9 = (_local_3 - 1);
                _local_10 = (_local_5 + 1);
                _local_12 = _local_7;
                while (_local_12 <= _local_8)
                {
                    this.mSettlerYSortMap_list[_local_12] = null;
                    _local_12++;
                };
                for each (_local_13 in this.mGeneralInterface.mCurrentPlayerZone.mSettlerKIManager.mSettlersList_vector)
                {
                    if (((((cSettingsManager.getInstance().showSettlers) && (!(_local_13.GetLevelEnumObjectType() == OBJECTTYPE.ANIMAL))) && (!(_local_13.IsGeneral()))) || (_local_13.GetLevelEnumObjectType() == OBJECTTYPE.ANIMAL)))
                    {
                        _local_12 = int(((_local_13.GetYInt() + global.streetGridY) / global.streetGridYHalf));
                        if (((_local_12 >= _local_7) && (_local_12 <= _local_8)))
                        {
                            _local_11 = int((_local_13.GetXInt() / global.streetGridX));
                            if (((_local_11 >= _local_9) && (_local_11 <= _local_10)))
                            {
                                if (this.mSettlerYSortMap_list[_local_12] == null)
                                {
                                    this.mSettlerYSortMap_list[_local_12] = new Vector.<cSettler>();
                                };
                                this.mSettlerYSortMap_list[_local_12].push(_local_13);
                            };
                        };
                    };
                };
                if ((((this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SELECT_BUILDING) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.DELETE_BUILDING)) || (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.SELECT_BUILDING_TO_MOVE)))
                {
                    if (this.mGeneralInterface.mCurrentCursor.IsCursorValid())
                    {
                        _local_2 = this.mGeneralInterface.mCurrentCursor.GetGridPosition();
                        this.SelectBuilding(_local_2, true);
                    };
                };
                if (this.mGeneralInterface.GetSelectedBuilding() != null)
                {
                    this.SelectBuilding(this.mGeneralInterface.GetSelectedBuilding().GetGrid(), true);
                };
                _local_14 = 0;
                _local_15 = new Vector.<cBuilding>();
                _local_12 = _local_7;
                while (_local_12 <= _local_8)
                {
                    _local_14 = ((_local_12 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_3);
                    if (this.mSettlerYSortMap_list[_local_12] != null)
                    {
                        for each (_local_13 in this.mSettlerYSortMap_list[_local_12])
                        {
                            _local_13.Render();
                        };
                    };
                    if (((_local_12 >= _local_4) && (_local_12 <= _local_6)))
                    {
                        _local_11 = _local_3;
                        while (_local_11 <= _local_5)
                        {
                            if (this.mAdditionalData2.get(_local_14, AdditionalDataTSO.Fog) < 3)
                            {
                                _local_17 = this.mLandscapeContainer.get(_local_14);
                                if (_local_17 != null)
                                {
                                    _local_17.Render();
                                };
                                _local_18 = this.mBuildingContainer.get(_local_14);
                                if (_local_18 != null)
                                {
                                    _local_15.push(_local_18);
                                    _local_18.Render();
                                };
                                _local_19 = this.mDepositContainer.get(_local_14);
                                if (_local_19 != null)
                                {
                                    _local_19.Render();
                                };
                                _local_20 = this.mLandmarkContainer.get(_local_14);
                                if (_local_20 != null)
                                {
                                    _local_20.Render();
                                };
                                if (this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.IsAnimationAtGridPos(_local_14))
                                {
                                    _local_21 = this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.GetAnimAtPos(_local_14);
                                    _local_21.animGoSetListContainer.Animate(this.mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
                                    _local_21.animGoSetListContainer.Render(_local_21.pixelPos.x, _local_21.pixelPos.y);
                                };
                                if (this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.IsSingleAnimationAtGridPos((_local_14 - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth)))
                                {
                                    _local_22 = this.mGeneralInterface.mCurrentPlayerZone.mGoSetListAnimationManager.GetSingleAnimAtPos((_local_14 - this.mGeneralInterface.mCurrentPlayerZone.mMapWidth));
                                    _local_22.animGoSetListContainer.Render(_local_22.pixelPos.x, _local_22.pixelPos.y);
                                };
                            };
                            _local_14++;
                            _local_11++;
                        };
                    };
                    _local_12++;
                };
                for each (_local_16 in _local_15)
                {
                    _local_16.RenderBuildingLabels();
                };
            };
            if (_local_2 != -1)
            {
                this.SelectBuilding(this.mGeneralInterface.mCurrentCursor.GetGridPosition(), false);
            };
            if (this.mGeneralInterface.GetSelectedBuilding() != null)
            {
                this.SelectBuilding(this.mGeneralInterface.GetSelectedBuilding().GetGrid(), false);
            };
        }

        public function CalculateBlockingGrid():void
        {
            var _local_4:cBuilding;
            var _local_5:cLandscape;
            var _local_6:cDeposit;
            var _local_7:int;
            var _local_8:cBuilding;
            var _local_9:String;
            var _local_10:Boolean;
            var _local_11:cBlockingData;
            var _local_12:int;
            var _local_13:int;
            var _local_1:int = (this.mGeneralInterface.mCurrentPlayerZone.mMapWidth * this.mGeneralInterface.mCurrentPlayerZone.mMapHeight);
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this.SetBlocked(_local_2, this.GetBackgroundBlocking(_local_2));
                _local_2++;
            };
            var _local_3:int;
            while (_local_3 < _local_1)
            {
                _local_4 = this.mBuildingContainer.get(_local_3);
                if (_local_4 != null)
                {
                    this.mGeneralInterface.mCurrentPlayerZone.SetBlockingByTypeAndPosition(OBJECTTYPE.BUILDING, _local_4.GetBuildingName_string(), _local_4.GetXInt(), (_local_4.GetYInt() - global.streetGridYHalf), new GridPosition(_local_3));
                };
                _local_5 = this.mLandscapeContainer.get(_local_3);
                if (_local_5 != null)
                {
                    if (this.mAdditionalData.get(_local_3, AdditionalDataTSO.Blocked) == cBlockingData.BLOCK_TYPE_ALLOW_NOTHING)
                    {
                        _local_7 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBlockingSourceData.get(_local_3, AdditionalDataTSO.BlockingSource);
                        if (_local_7 > 0)
                        {
                            _local_8 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_7);
                            _local_9 = _local_5.GetContainerName_string();
                            _local_10 = ((!(_local_9 == null)) && (_local_9.toLowerCase().indexOf("mountain") > -1));
                            if (((((!(_local_8 == null)) && (!(_local_10))) && (!(_local_8.IsDestroyableMountain()))) && (!(this.mGeneralInterface.mCurrentPlayerZone.IsDepositFoundType(_local_9)))))
                            {
                                _local_5.setVisible(false);
                            };
                        };
                    };
                    this.mGeneralInterface.mCurrentPlayerZone.SetBlockingByTypeAndPosition(OBJECTTYPE.LANDSCAPE, _local_5.GetLandscapeName_string(), _local_5.GetXInt(), (_local_5.GetYInt() - global.streetGridYHalf), null);
                };
                _local_6 = this.mDepositContainer.get(_local_3);
                if (((!(_local_6 == null)) && (!(_local_6.mDepositGfx == null))))
                {
                    for each (_local_11 in _local_6.mDepositGfx.mBlocking_vector)
                    {
                        _local_12 = int((_local_6.GetXInt() + ((_local_11.getXPixelOffset() * global.streetGridX) / 100)));
                        _local_13 = int(((_local_6.GetYInt() - global.streetGridYHalf) + ((_local_11.getYPixelOffset() * global.streetGridY) / 100)));
                        this.SetBlockingPixelPos(_local_12, _local_13, _local_11.getBlockingType(), null);
                    };
                };
                _local_3++;
            };
        }

        public function PostProcessConvertMapToXMLString_string():void
        {
            this.UpdateObjectPositions();
            this.CalculateSectors(this.mGeneralInterface.mCurrentPlayer);
            this.CalculateBlockingGrid();
            this.CalculateWatchAreas();
            this.CalculateBorders();
        }

        public function SetSectorId(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:int = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _arg_2);
            if (_local_4 == defines.ILLEGAL_INT_POS)
            {
                return;
            };
            var _local_5:int = this.mAdditionalData.get(_local_4, AdditionalDataTSO.Sector);
            this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_5].mAmount--;
            this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_arg_3].mAmount++;
            this.mAdditionalData.set(_local_4, AdditionalDataTSO.Sector, _arg_3);
        }

        public function GetDestructionProgressInPercent(_arg_1:cBuilding):int
        {
            if (((_arg_1 is DestroyOnClickBuilding) || (_arg_1.GetGOContainer().mDestructionDuration == 0)))
            {
                return (100);
            };
            var _local_2:int = int((this.mGeneralInterface.GetClientTime() - _arg_1.mBuildingDestructionTime));
            var _local_3:int = int(((_local_2 / 10) / _arg_1.GetGOContainer().mDestructionDuration));
            if (_local_3 < 0)
            {
                _local_3 = 0;
            };
            if (_local_3 > 100)
            {
                _local_3 = 100;
            };
            return (_local_3);
        }

        public function RenderIslandHighlight():void
        {
            var _local_1:cBuff;
            var _local_2:cPosInt;
            var _local_3:int;
            var _local_4:int;
            var _local_5:cPosInt;
            var _local_6:int;
            var _local_7:cPosInt;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:cClippingRectangle;
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            var _local_20:int;
            var _local_21:int;
            var _local_22:int;
            var _local_23:int;
            var _local_24:int;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            if (this.mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.APPLY_BUFF)
            {
                _local_2 = new cPosInt();
                _local_2.x = (global.streetGridXHalf / 2);
                _local_2.y = (global.streetGridYHalf / 2);
                _local_3 = ((_local_2.x * _local_2.x) + (_local_2.y * _local_2.y));
                _local_4 = gMisc.FastIntegerSqrt(_local_3);
                _local_5 = new cPosInt();
                _local_6 = int(((75 * _local_4) / 100));
                _local_5.x = ((_local_2.x * _local_6) / _local_4);
                _local_5.y = ((_local_2.y * _local_6) / _local_4);
                _local_6 = int(((175 * _local_4) / 100));
                _local_7 = new cPosInt();
                _local_7.x = ((_local_2.x * _local_6) / _local_4);
                _local_7.y = ((_local_2.y * _local_6) / _local_4);
                _local_8 = _local_5.x;
                _local_9 = (-(global.streetGridYHalf) - _local_5.y);
                _local_10 = -(_local_5.x);
                _local_11 = (-(global.streetGridYHalf) - _local_5.y);
                _local_12 = _local_5.x;
                _local_13 = (-(global.streetGridYHalf) + _local_5.y);
                _local_14 = -(_local_5.x);
                _local_15 = (-(global.streetGridYHalf) + _local_5.y);
                _local_1 = this.mGeneralInterface.mCurrentCursor.mCurrentBuff;
                if (((_local_1 == null) || (!(_local_1.GetBuffDefinition().GetName_string().indexOf("IslandDeed") == 0))))
                {
                    return;
                };
                _local_16 = new cClippingRectangle();
                this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_16);
                if (((this.mGeneralInterface.mCurrentCursor.GetGridPosition() < 0) || (this.mGeneralInterface.mCurrentCursor.GetGridPosition() > this.mAdditionalData.size())))
                {
                    return;
                };
                _local_17 = (global.streetGridX * _local_16.minX);
                _local_18 = (global.streetGridYHalf * _local_16.minY);
                _local_19 = this.mGeneralInterface.mMouseCursor.GetGridPosition();
                _local_20 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_19, AdditionalDataTSO.Sector);
                _local_21 = _local_16.minY;
                while (_local_21 <= _local_16.maxY)
                {
                    _local_22 = _local_17;
                    if ((_local_21 & 0x01) == 0)
                    {
                        _local_22 = (_local_22 - global.streetGridXHalf);
                    };
                    _local_23 = ((_local_21 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_16.minX);
                    _local_24 = _local_16.minX;
                    while (_local_24 <= _local_16.maxX)
                    {
                        _local_25 = this.mAdditionalData.get(_local_23, AdditionalDataTSO.Cursor);
                        if (_local_1.isIslandDeedApplyable(this.mGeneralInterface, _local_23))
                        {
                            _local_26 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData.get(_local_23, AdditionalDataTSO.Sector);
                            if (_local_26 == _local_20)
                            {
                                this.mGeneralInterface.mStreetCursorSelected.SetPosition(_local_22, _local_18);
                                this.mGeneralInterface.mStreetCursorSelected.Render();
                            }
                            else
                            {
                                this.mGeneralInterface.mStreetCursorMagenta.SetPosition(_local_22, _local_18);
                                this.mGeneralInterface.mStreetCursorMagenta.Render();
                            };
                            _local_27 = this.mAdditionalData.get(_local_23, AdditionalDataTSO.Border);
                            if (_local_27 != 0)
                            {
                                _local_28 = this.mAdditionalData.get(_local_23, AdditionalDataTSO.BorderColour);
                                this.mGeneralInterface.mBorder.SetSubType(_local_28);
                                if ((_local_27 & defines.DIR8_NORTH_EAST_BIT) > 0)
                                {
                                    this.mGeneralInterface.mBorder.RenderPos((_local_22 + _local_8), (_local_18 + _local_9));
                                };
                                if ((_local_27 & defines.DIR8_NORTH_WEST_BIT) > 0)
                                {
                                    this.mGeneralInterface.mBorder.RenderPos((_local_22 + _local_10), (_local_18 + _local_11));
                                };
                                if ((_local_27 & defines.DIR8_SOUTH_EAST_BIT) > 0)
                                {
                                    this.mGeneralInterface.mBorder.RenderPos((_local_22 + _local_12), (_local_18 + _local_13));
                                };
                                if ((_local_27 & defines.DIR8_SOUTH_WEST_BIT) > 0)
                                {
                                    this.mGeneralInterface.mBorder.RenderPos((_local_22 + _local_14), (_local_18 + _local_15));
                                };
                            };
                        };
                        _local_22 = (_local_22 + global.streetGridX);
                        _local_23++;
                        _local_24++;
                    };
                    _local_18 = (_local_18 + global.streetGridYHalf);
                    _local_21++;
                };
            };
        }

        public function SetDepositGridPos(_arg_1:cPlayerData, _arg_2:cGO, _arg_3:int):Boolean
        {
            var _local_4:cDeposit = (_arg_2 as cDeposit);
            gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_3, this.mTempPos);
            if (_arg_3 == defines.ILLEGAL_INT_POS)
            {
                return (false);
            };
            var _local_5:cDeposit = this.mDepositContainer.get(_arg_3);
            if (_local_5 != null)
            {
                this.RemoveDepositGridPos(_arg_3, false);
            };
            _local_4.SetPosition(this.mTempPos.x, (this.mTempPos.y + global.streetGridYHalf));
            _local_4.SetGrid(_arg_3);
            this.mDeposits_vector.push(_local_4);
            this.mGeneralInterface.mPathFinder.InvalidateDepositMatrix(_arg_1.GetPlayerId(), _local_4.GetName_string(), cPathFinder.AMOUNT_TYPE_ABOVE_ZERO);
            this.SetDeposit(_arg_3, _local_4);
            return (true);
        }

        public function InitializeMap(_arg_1:dZoneVO):void
        {
            var _local_3:int;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_2:int = (_arg_1.mapWidth * _arg_1.mapHeight);
            this.useContinentalFog = _arg_1.useContinentalFog;
            this.startGrid = _arg_1.startGrid;
            if (this.renderLayers != null)
            {
                this.renderLayers.dispose();
            };
            this.renderLayers = new RenderListManager(this.mGeneralInterface.channels);
            this.mBuildingContainer = new NotifyingIndexedContainer(new Vector.<cBuilding>(), _local_2);
            this.mDepositContainer = new NotifyingIndexedContainer(new Vector.<cDeposit>(), _local_2);
            this.mLandscapeContainer = new NotifyingIndexedContainer(new Vector.<cLandscape>(), _local_2);
            this.mStreetContainer = new IndexedContainer(new Vector.<cStreet>(), _local_2);
            this.mWatchingContainer = new IndexedContainer(new Vector.<Vector.<cBuilding>>(), _local_2);
            this.mLandmarkContainer = new NotifyingIndexedContainer(new Vector.<cGO>(), _local_2);
            this.mCombatContainer = new IndexedContainer(new Vector.<cCombatData>(), _local_2);
            this.mAdditionalData = new AdditionalData(new Vector.<int>(), _local_2);
            this.mAdditionalData2 = new AdditionalData(new Vector.<int>(), _local_2);
            this.mBlockingSourceData = new AdditionalData(new Vector.<int>(), _local_2);
            this.mPathsPreviewsContainer = new PreviewPathsContainer();
            this.mBlockingSourceData.clear(-1);
            this.mSettlerYSortMap_list = new Vector.<Vector.<cSettler>>(_local_2);
            this.mSinTable_vector = new Vector.<int>();
            this.mCosTable_vector = new Vector.<int>();
            var _local_4:int;
            while (_local_4 < 0x0100)
            {
                _local_5 = _local_4;
                _local_6 = (Math.sin(((_local_5 * (Math.PI * 2)) / 0x0100)) * 10);
                _local_7 = (Math.cos(((_local_5 * (Math.PI * 2)) / 0x0100)) * 10);
                this.mSinTable_vector.push(_local_6);
                this.mCosTable_vector.push(_local_7);
                _local_4++;
            };
            this.ResetListsAndScrolling();
        }

        public function ShowAllWatchAreaPreview():void
        {
            var _local_1:cBuilding;
            for each (_local_1 in this.GetBuildings_vector())
            {
                if (_local_1.GetGOContainer().mWatchAreaId >= 0)
                {
                    this.RenderWatchAreaOfSelectedBuilding(_local_1);
                };
            };
        }

        public function AddLandscapeToList(_arg_1:cLandscape):void
        {
            this.mBuildingsAndTrees_vector.push(_arg_1);
        }

        public function getBuildingsByName_vector(_arg_1:String):Vector.<cBuilding>
        {
            if (_arg_1 == null)
            {
                return (this.GetBuildings_vector());
            };
            if ((_arg_1 in this.mBuildingsLookupByName_map))
            {
                return (this.mBuildingsLookupByName_map[_arg_1]);
            };
            return (null);
        }

        public function SetAdditionalParameter(_arg_1:cGOGroup, _arg_2:String):void
        {
            this.mGoGroup = _arg_1;
            this.mElementName_string = _arg_2;
        }

        public function RenderCompute():void
        {
            if (this.mGeneralInterface != null)
            {
                gGfxResource.mWaitForCommandIcon.mSprite.Animate(this.mGeneralInterface.mCalculateTicks.mDeltaTicksOne);
            };
            this.RenderComputeFreeBackground();
        }

        public function GetLogisticsHouse():cBuilding
        {
            return (this.mLogisticsHouse);
        }

        public function SetBlockingPixelPos(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:GridPosition):void
        {
            var _local_5:int = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _arg_2);
            if (_local_5 == defines.ILLEGAL_INT_POS)
            {
                return;
            };
            if (((this.IsBlockedAllowedAll(_local_5)) || (_arg_3 < this.GetBlocked(_local_5))))
            {
                this.SetBlocked(_local_5, _arg_3);
            };
            if (_arg_4 != null)
            {
                if (_arg_3 != cBlockingData.BLOCK_TYPE_ALLOW_ALL)
                {
                    this.mBlockingSourceData.set(_local_5, AdditionalDataTSO.BlockingSource, _arg_4.gridIndex());
                };
            };
        }

        public function CalculateSectors(_arg_1:cPlayerData):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:cBuilding;
            var _local_6:int;
            if (this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector.length == 0)
            {
                return;
            };
            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            while (_local_3 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY)
            {
                _local_4 = ((_local_3 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX);
                _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
                while (_local_2 <= this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX)
                {
                    _local_5 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_4);
                    if (((!(_local_5 == null)) && (_local_5.IsWarehouseType())))
                    {
                        _local_6 = this.mAdditionalData.get(_local_4, AdditionalDataTSO.Sector);
                        this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_6].SetOwnerPlayerID(_local_5.getPlayerID());
                    };
                    _local_4++;
                    _local_2++;
                };
                _local_3++;
            };
            this.CalculateFogBorders(_arg_1);
        }

        public function CalculateBorders():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:cVectorListInt;
            var _local_9:int;
            var _local_10:int;
            var _local_11:cSector;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            _local_1 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
            _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX;
            _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY;
            var _local_5:int;
            _local_7 = _local_2;
            while (_local_7 <= _local_4)
            {
                _local_5 = ((_local_7 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1);
                _local_8 = this.mGeneralInterface.mCurrentPlayerZone.m8DirectionTableStreetGridDirection_vector[(_local_7 & 0x01)];
                _local_6 = _local_1;
                while (_local_6 <= _local_3)
                {
                    _local_9 = 0;
                    _local_10 = this.mAdditionalData.get(_local_5, AdditionalDataTSO.Sector);
                    if (_local_10 < this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector.length)
                    {
                        _local_11 = this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_10];
                        _local_12 = (_local_5 + _local_8.mList_vector[defines.DIR8_NORTH_EAST]);
                        _local_13 = this.mAdditionalData.get(_local_12, AdditionalDataTSO.Sector);
                        if (_local_13 != _local_10)
                        {
                            if (_local_11.mAdjactedSectorIds_vector.indexOf(_local_13) == -1)
                            {
                                if ((((this.mGeneralInterface.mCurrentViewedZoneID < defines.ADVENTUREZONEID) || ((_local_11.IsIsland()) && (this.mGeneralInterface.mCurrentPlayerZone.GetSector(_local_13).IsIsland()))) || ((!(_local_11.IsIsland())) && (!(this.mGeneralInterface.mCurrentPlayerZone.GetSector(_local_13).IsIsland())))))
                                {
                                    _local_11.mAdjactedSectorIds_vector.push(_local_13);
                                };
                            };
                            _local_9 = (_local_9 | defines.DIR8_NORTH_EAST_BIT);
                        };
                        _local_12 = (_local_5 + _local_8.mList_vector[defines.DIR8_NORTH_WEST]);
                        _local_13 = this.mAdditionalData.get(_local_12, AdditionalDataTSO.Sector);
                        if (_local_13 != _local_10)
                        {
                            if (_local_11.mAdjactedSectorIds_vector.indexOf(_local_13) == -1)
                            {
                                if ((((this.mGeneralInterface.mCurrentViewedZoneID < defines.ADVENTUREZONEID) || ((_local_11.IsIsland()) && (this.mGeneralInterface.mCurrentPlayerZone.GetSector(_local_13).IsIsland()))) || ((!(_local_11.IsIsland())) && (!(this.mGeneralInterface.mCurrentPlayerZone.GetSector(_local_13).IsIsland())))))
                                {
                                    _local_11.mAdjactedSectorIds_vector.push(_local_13);
                                };
                            };
                            _local_9 = (_local_9 | defines.DIR8_NORTH_WEST_BIT);
                        };
                        _local_12 = (_local_5 + _local_8.mList_vector[defines.DIR8_SOUTH_EAST]);
                        _local_13 = this.mAdditionalData.get(_local_12, AdditionalDataTSO.Sector);
                        if (_local_13 != _local_10)
                        {
                            if (_local_11.mAdjactedSectorIds_vector.indexOf(_local_13) == -1)
                            {
                                if ((((this.mGeneralInterface.mCurrentViewedZoneID < defines.ADVENTUREZONEID) || ((_local_11.IsIsland()) && (this.mGeneralInterface.mCurrentPlayerZone.GetSector(_local_13).IsIsland()))) || ((!(_local_11.IsIsland())) && (!(this.mGeneralInterface.mCurrentPlayerZone.GetSector(_local_13).IsIsland())))))
                                {
                                    _local_11.mAdjactedSectorIds_vector.push(_local_13);
                                };
                            };
                            _local_9 = (_local_9 | defines.DIR8_SOUTH_EAST_BIT);
                        };
                        _local_12 = (_local_5 + _local_8.mList_vector[defines.DIR8_SOUTH_WEST]);
                        _local_13 = this.mAdditionalData.get(_local_12, AdditionalDataTSO.Sector);
                        if (_local_13 != _local_10)
                        {
                            if (_local_11.mAdjactedSectorIds_vector.indexOf(_local_13) == -1)
                            {
                                if ((((this.mGeneralInterface.mCurrentViewedZoneID < defines.ADVENTUREZONEID) || ((_local_11.IsIsland()) && (this.mGeneralInterface.mCurrentPlayerZone.GetSector(_local_13).IsIsland()))) || ((!(_local_11.IsIsland())) && (!(this.mGeneralInterface.mCurrentPlayerZone.GetSector(_local_13).IsIsland())))))
                                {
                                    _local_11.mAdjactedSectorIds_vector.push(_local_13);
                                };
                            };
                            _local_9 = (_local_9 | defines.DIR8_SOUTH_WEST_BIT);
                        };
                        this.mAdditionalData.set(_local_5, AdditionalDataTSO.Border, _local_9);
                        this.mAdditionalData.set(_local_5, AdditionalDataTSO.BorderColour, 13);
                        if (_local_10 >= 0)
                        {
                            _local_14 = this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_10].GetOwnerPlayerID();
                            if (_local_14 != -1)
                            {
                                _local_15 = this.mGeneralInterface.mCurrentPlayerZone.GetPlayerColorIdx(_local_14);
                                this.mAdditionalData.set(_local_5, AdditionalDataTSO.BorderColour, _local_15);
                            };
                        };
                    };
                    _local_5++;
                    _local_6++;
                };
                _local_7++;
            };
            if (!(this.mGeneralInterface.mCurrentViewedZoneID <= defines.ADVENTUREZONEID))
            {
                if (this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[10].mAdjactedSectorIds_vector.indexOf(1) == -1)
                {
                    this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[10].mAdjactedSectorIds_vector.push(1);
                };
                if (this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[1].mAdjactedSectorIds_vector.indexOf(10) == -1)
                {
                    this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[1].mAdjactedSectorIds_vector.push(10);
                };
            };
        }

        public function RenderLandingFields():void
        {
            var _local_2:cLandingField;
            var _local_1:cPosInt = new cPosInt();
            for each (_local_2 in this.mLandingFields_vector)
            {
                gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _local_2.GetGrid(), _local_1);
                this.RenderStreetCursorColor(_local_2.mId, _local_1.x, _local_1.y);
                this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, gMisc.ConvertIntToString_string(_local_2.mId), _local_1.x, (_local_1.y - global.streetGridYHalf));
            };
        }

        public function IsADepletedDeposit(_arg_1:cBuilding):Boolean
        {
            var _local_3:String;
            var _local_2:int = _arg_1.GetBuildingName_string().length;
            if (_local_2 >= defines.MINEDEPOSITDEPLETED_NAME_string.length)
            {
                _local_3 = gMisc.GetSubString_string(_arg_1.GetBuildingName_string(), 0, defines.MINEDEPOSITDEPLETED_NAME_string.length);
                if (_local_3 == defines.MINEDEPOSITDEPLETED_NAME_string)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function SetLogisticsHouse(_arg_1:cBuilding):void
        {
            if (((_arg_1 == null) || (this.mGeneralInterface.mCurrentPlayer.mIsPlayerZone)))
            {
                this.mLogisticsHouse = _arg_1;
                if (globalFlash.gui.mChatPanel != null)
                {
                    globalFlash.gui.mChatPanel.changeTradeChannelStatus();
                };
            };
        }

        public function UpdateGuildHousesBuildingLevel():void
        {
            var _local_2:int;
            var _local_3:cBuilding;
            var _local_1:Vector.<cBuilding> = this.getBuildingsByName_vector(defines.GUILDHOUSE_NAME_string);
            if (_local_1 != null)
            {
                _local_2 = 0;
                for each (_local_3 in _local_1)
                {
                    this.UpdateGuildHouseBuildingLevel(_local_3);
                };
            };
        }

        public function RecalculateStreetVariations(_arg_1:int):Boolean
        {
            var _local_3:cStreet;
            var _local_2:Boolean;
            for each (_local_3 in this.mStreetContainer.valueCollection())
            {
                if (_local_3 != null)
                {
                    this.calculateStreetVariation(_local_3, _arg_1, false);
                    _local_2 = true;
                };
            };
            return (_local_2);
        }

        public function removePickupFromList(_arg_1:int, _arg_2:int):void
        {
            if (this.pickups[_arg_1] != null)
            {
                delete this.pickups[_arg_1][_arg_2];
            };
        }

        public function CheckStreetConnectionAroundPoint(_arg_1:int):int
        {
            var _local_4:int;
            var _local_5:cStreet;
            var _local_2:int = 15;
            var _local_3:int;
            while (_local_3 < defines.STREET_DIR_NOF)
            {
                _local_4 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _local_3);
                _local_5 = this.mGeneralInterface.mCurrentPlayerZone.GetStreetObjectFromGridPosition(_local_4);
                if (_local_5 != null)
                {
                    _local_2 = (_local_2 & (~(1 << _local_3)));
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function SetLandscapeAtFogPosition(_arg_1:String, _arg_2:int, _arg_3:int):cGO
        {
            var _local_4:cFreeLandscape;
            _local_4 = cFreeLandscape.CreateFromString(global.landscapeGroup, _arg_1, this.mGeneralInterface);
            if (!this.SetLandscapeFogPos(_local_4, _arg_2, _arg_3))
            {
                return (null);
            };
            return (_local_4);
        }

        public function SetBackgroundBlockingFromPixelPos(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:int = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _arg_2);
            if (_local_4 == defines.ILLEGAL_INT_POS)
            {
                return;
            };
            this.SetBlocked(_local_4, _arg_3);
            this.SetBackgroundBlocking(_local_4, _arg_3);
        }

        public function RefreshExploredDeposits():void
        {
            this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mDepositContainer.forEach(this.AddDepositIcon);
        }

        public function UpdateObjectPositions():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_8:int;
            var _local_9:int;
            var _local_11:cBuilding;
            var _local_12:cLandscape;
            var _local_13:cDeposit;
            _local_1 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableX;
            _local_2 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMinUsableY;
            _local_3 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableX;
            _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mStreetMapMaxUsableY;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_10:int = (global.streetGridX * _local_1);
            _local_6 = (_local_6 + (global.streetGridYHalf * _local_2));
            _local_6 = (_local_6 + global.streetGridYHalf);
            _local_9 = _local_2;
            while (_local_9 <= _local_4)
            {
                if ((_local_9 & 0x01) == 0)
                {
                    _local_5 = (-(global.streetGridXHalf) + _local_10);
                }
                else
                {
                    _local_5 = _local_10;
                };
                _local_7 = ((_local_9 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1);
                _local_8 = _local_1;
                while (_local_8 <= _local_3)
                {
                    _local_11 = this.mBuildingContainer.get(_local_7);
                    if (_local_11 != null)
                    {
                        _local_11.SetPosition(_local_5, _local_6);
                    };
                    _local_12 = this.mLandscapeContainer.get(_local_7);
                    if (_local_12 != null)
                    {
                        _local_12.SetPosition(_local_5, _local_6);
                    };
                    _local_13 = this.mDepositContainer.get(_local_7);
                    if (_local_13 != null)
                    {
                        _local_13.SetPosition(_local_5, _local_6);
                    };
                    _local_5 = (_local_5 + global.streetGridX);
                    _local_7++;
                    _local_8++;
                };
                _local_6 = (_local_6 + global.streetGridYHalf);
                _local_9++;
            };
        }

        public function GetLandscapes_vector():Vector.<cLandscape>
        {
            return (this.mLandscapeContainer.valueCollection());
        }

        public function GetAllLandingFieldsPositions_vector():Vector.<int>
        {
            var _local_2:cLandingField;
            var _local_1:Vector.<int> = new Vector.<int>();
            for each (_local_2 in this.mLandingFields_vector)
            {
                _local_1.push(_local_2.GetGrid());
            };
            return (_local_1);
        }

        public function InitConvertMapToXMLString_string():void
        {
            var _local_1:int = (this.mGeneralInterface.mCurrentPlayerZone.mMapWidth * this.mGeneralInterface.mCurrentPlayerZone.mMapHeight);
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this.mBuildingContainer.remove(_local_2);
                this.mLandscapeContainer.remove(_local_2);
                _local_2++;
            };
            this.mBuildingsAndTrees_vector = new Vector.<cGO>();
            this.mBuildingsLookupByName_map = new Dictionary();
            this.mTaskBuildings_map.clear();
        }

        public function IsBlockedAllowedAll(_arg_1:int):Boolean
        {
            var _local_2:int = this.mAdditionalData.get(_arg_1, AdditionalDataTSO.Blocked);
            return (_local_2 == cBlockingData.BLOCK_TYPE_ALLOW_ALL);
        }

        public function SetSingleStreet(_arg_1:cPlayerData, _arg_2:String, _arg_3:int):void
        {
            var _local_5:int;
            var _local_4:* = "";
            var _local_6:int;
            _local_5 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_3, defines.DIR8_NORTH_EAST);
            _local_4 = this.GetStreetNameFromGridPos_string(_local_5);
            if (_local_4 != null)
            {
                if (cStreet.ConvertStreetNameToBitField(_local_4) != 0)
                {
                    this.SetStreet(_arg_1, "2", _local_5, false, false);
                    _local_6 = (_local_6 | (1 << 0));
                };
            };
            _local_5 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_3, defines.DIR8_SOUTH_EAST);
            _local_4 = this.GetStreetNameFromGridPos_string(_local_5);
            if (_local_4 != null)
            {
                if (cStreet.ConvertStreetNameToBitField(_local_4) != 0)
                {
                    this.SetStreet(_arg_1, "3", _local_5, false, false);
                    _local_6 = (_local_6 | (1 << 1));
                };
            };
            _local_5 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_3, defines.DIR8_NORTH_WEST);
            _local_4 = this.GetStreetNameFromGridPos_string(_local_5);
            if (_local_4 != null)
            {
                if (cStreet.ConvertStreetNameToBitField(_local_4) != 0)
                {
                    this.SetStreet(_arg_1, "0", _local_5, false, false);
                    _local_6 = (_local_6 | (1 << 2));
                };
            };
            _local_5 = gCalculations.MoveStreetGridToDir8(this.mGeneralInterface.mCurrentPlayerZone, _arg_3, defines.DIR8_SOUTH_WEST);
            _local_4 = this.GetStreetNameFromGridPos_string(_local_5);
            if (_local_4 != null)
            {
                if (cStreet.ConvertStreetNameToBitField(_local_4) != 0)
                {
                    this.SetStreet(_arg_1, "1", _local_5, false, false);
                    _local_6 = (_local_6 | (1 << 3));
                };
            };
            if (_arg_2 != null)
            {
                _local_6 = (_local_6 | cStreet.ConvertStreetNameToBitField(_arg_2));
            };
            if (_local_6 != 0)
            {
                this.SetStreet(_arg_1, cStreet.CreateStringFromStreetBitField_string(_local_6), _arg_3, false, false);
            };
        }

        public function ResetStreetList():void
        {
            this.mStreetContainer.clear();
        }

        public function RenderFreeBackgroundAnimated(_arg_1:int):void
        {
            this.RenderFreeBackground(_arg_1, true);
        }

        public function GetMayorHouse():cBuilding
        {
            return (this.mMayorHouse);
        }

        public function SetBuildingsAndTrees_vector(_arg_1:Vector.<cGO>):void
        {
            this.mBuildingsAndTrees_vector = _arg_1;
        }

        public function GetBuildingForProductionType(_arg_1:int):Vector.<cBuilding>
        {
            var _local_4:cBuilding;
            var _local_2:Vector.<cBuilding> = new Vector.<cBuilding>();
            var _local_3:Vector.<cBuilding> = this.mBuildingContainer.valueCollection();
            for each (_local_4 in _local_3)
            {
                if ((((!(_local_4 == null)) && (!(_local_4.GetGOContainer() == null))) && (_local_4.GetGOContainer().productionType == _arg_1)))
                {
                    _local_2.push(_local_4);
                };
            };
            return (_local_2);
        }

        public function CalculateWatchAreas():void
        {
            var _local_4:cBuilding;
            var _local_1:int = (this.mGeneralInterface.mCurrentPlayerZone.mMapWidth * this.mGeneralInterface.mCurrentPlayerZone.mMapHeight);
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this.RemoveAllWatchingTowers(_local_2);
                _local_2++;
            };
            var _local_3:int;
            while (_local_3 < _local_1)
            {
                _local_4 = this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get(_local_3);
                if (_local_4 != null)
                {
                    this.mGeneralInterface.mCurrentPlayerZone.SetWatchArea(_local_4.GetLevelEnumObjectType(), _local_4.GetBuildingName_string(), _local_4);
                };
                _local_3++;
            };
        }

        public function RemovePrePlaceBuildingGridPos(_arg_1:cPlayerData, _arg_2:int):Boolean
        {
            var _local_3:cBuilding = this.mBuildingContainer.get(_arg_2);
            this.mBuildingContainer.remove(_arg_2);
            _arg_1.RemovePrePlacesBuildingToList(_local_3);
            this.RemoveBuildingFromList(_local_3);
            this.CalculateBlockingGrid();
            return (true);
        }

        public function RemoveWatchpoint(_arg_1:int, _arg_2:int, _arg_3:cBuilding):void
        {
            var _local_4:int = gCalculations.ConvertPixelPosToStreetGridPos(this.mGeneralInterface.mCurrentPlayerZone, _arg_1, _arg_2);
            if (_local_4 == defines.ILLEGAL_INT_POS)
            {
                return;
            };
            this.RemoveWatchingBuilding(_local_4, _arg_3);
        }

        public function GetBuildingByGridPos(_arg_1:int):cBuilding
        {
            return (this.mBuildingContainer.get(_arg_1));
        }

        public function GetBlocked(_arg_1:int):int
        {
            return (this.mAdditionalData.get(_arg_1, AdditionalDataTSO.Blocked));
        }

        private function SelectBuilding(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:cBuilding = this.mBuildingContainer.get(_arg_1);
            if (_local_3 == null)
            {
                _local_3 = this.CheckIfBuildingIsSouthSouthEastAndSouthWest(_arg_1);
            };
            if (_local_3 != null)
            {
                _local_3 = _local_3.getBuildingSelection();
                _local_3.mCursorHighlight = _arg_2;
            };
        }

        public function RenderBlockingGrid():void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_1:cClippingRectangle = new cClippingRectangle();
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, _local_1);
            var _local_2:int;
            var _local_3:int;
            var _local_4:int = (global.streetGridX * _local_1.minX);
            _local_3 = (_local_3 + (global.streetGridYHalf * _local_1.minY));
            var _local_5:int = _local_1.minY;
            while (_local_5 <= _local_1.maxY)
            {
                if ((_local_5 & 0x01) == 0)
                {
                    _local_2 = (-(global.streetGridXHalf) + _local_4);
                }
                else
                {
                    _local_2 = _local_4;
                };
                _local_6 = ((_local_5 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_1.minX);
                _local_7 = _local_1.minX;
                while (_local_7 <= _local_1.maxX)
                {
                    if (this.mGeneralInterface.showCostMatrix)
                    {
                        _local_8 = this.mGeneralInterface.mCreatePath.costMatrix_list[_local_6];
                        if (_local_8 == cCreatePath.WAYPOINT_UNSET)
                        {
                            this.mGeneralInterface.mStreetCursorWhite.SetPosition(_local_2, _local_3);
                            this.mGeneralInterface.mStreetCursorWhite.Render();
                        }
                        else
                        {
                            if (_local_8 == cCreatePath.WAYPOINT_BLOCKED)
                            {
                                this.mGeneralInterface.mStreetCursorRed.SetPosition(_local_2, _local_3);
                                this.mGeneralInterface.mStreetCursorRed.Render();
                            }
                            else
                            {
                                if (_local_8 == cCreatePath.WAYPOINT_START)
                                {
                                    this.mGeneralInterface.mStreetCursorGreen.SetPosition(_local_2, _local_3);
                                    this.mGeneralInterface.mStreetCursorGreen.Render();
                                }
                                else
                                {
                                    if (_local_8 == cCreatePath.WAYPOINT_DEST)
                                    {
                                        this.mGeneralInterface.mStreetCursorBlue.SetPosition(_local_2, _local_3);
                                        this.mGeneralInterface.mStreetCursorBlue.Render();
                                    }
                                    else
                                    {
                                        this.mGeneralInterface.mCurrentPlayerZone.RenderText(cBackbuffer.mBackBuffer, ("" + _local_8), _local_2, (_local_3 - global.streetGridYHalf));
                                    };
                                };
                            };
                        };
                    }
                    else
                    {
                        if (this.mGeneralInterface.showBlockingGrid)
                        {
                            switch (this.GetBlocked(_local_6))
                            {
                                case cBlockingData.BLOCK_TYPE_ALLOW_NOTHING:
                                    this.mGeneralInterface.mStreetCursorRed.SetPosition(_local_2, _local_3);
                                    this.mGeneralInterface.mStreetCursorRed.Render();
                                    break;
                                case cBlockingData.BLOCK_TYPE_ALLOW_STREETS:
                                    this.mGeneralInterface.mStreetCursorYellow.SetPosition(_local_2, _local_3);
                                    this.mGeneralInterface.mStreetCursorYellow.Render();
                                    break;
                                case cBlockingData.BLOCK_TYPE_ALLOW_WATERBUILD:
                                    this.mGeneralInterface.mStreetCursorBlue.SetPosition(_local_2, _local_3);
                                    this.mGeneralInterface.mStreetCursorBlue.Render();
                                    break;
                                case cBlockingData.BLOCK_TYPE_ALLOW_SAFE:
                                    this.mGeneralInterface.mStreetCursorPink.SetPosition(_local_2, _local_3);
                                    this.mGeneralInterface.mStreetCursorPink.Render();
                                    break;
                                case cBlockingData.BLOCK_TYPE_ALLOW_MOVE:
                                    this.mGeneralInterface.mStreetCursorOrange.SetPosition(_local_2, _local_3);
                                    this.mGeneralInterface.mStreetCursorOrange.Render();
                                    break;
                            };
                        }
                        else
                        {
                            if (this.mGeneralInterface.showWatchAreas)
                            {
                                if (this.IsWatchedByTowers(_local_6, this.mGeneralInterface))
                                {
                                    this.mGeneralInterface.mStreetCursorYellow.SetPosition(_local_2, _local_3);
                                    this.mGeneralInterface.mStreetCursorYellow.Render();
                                };
                            };
                        };
                    };
                    _local_2 = (_local_2 + global.streetGridX);
                    _local_6++;
                    _local_7++;
                };
                _local_3 = (_local_3 + global.streetGridYHalf);
                _local_5++;
            };
        }

        public function RenderWatchAreaOfSelectedBuilding(_arg_1:cBuilding):void
        {
            var _local_2:cGO;
            if (!global.hiddenBanditCamps_dictionary.Contains(_arg_1.GetBuildingName_string()))
            {
                _local_2 = this.mGeneralInterface.mWatchAreas[_arg_1.GetGOContainer().mWatchAreaId];
                _local_2.SetPosition(_arg_1.GetXInt(), (_arg_1.GetYInt() - global.streetGridYHalf));
                _local_2.Render();
            };
        }

        public function GetBuildingByUniqueId(_arg_1:dUniqueID):cBuilding
        {
            var _local_2:cBuilding;
            for each (_local_2 in this.GetBuildings_vector())
            {
                if (((!(_local_2 == null)) && (_local_2.GetUniqueId().equals(_arg_1))))
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function GetLoadedFromMap():Boolean
        {
            return (this.mLoadedFromMap);
        }

        public function IsBlockedForStreetAtGridIdx(_arg_1:int):Boolean
        {
            if (((cBlockingData.isFullyBlocked(this.GetBlockType(_arg_1))) || (this.GetBlockType(_arg_1) == cBlockingData.BLOCK_TYPE_ALLOW_MOVE)))
            {
                return (true);
            };
            return (false);
        }

        public function SetDeposit(_arg_1:int, _arg_2:cDeposit):void
        {
            this.mDepositContainer.put(_arg_1, _arg_2);
            this.RefreshDepositGfx(_arg_1);
        }

        public function RenderDepositsGame(_arg_1:String):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_7:cDeposit;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:String;
            var _local_16:String;
            var _local_17:String;
            var _local_18:int;
            var _local_19:int;
            var _local_20:String;
            var _local_21:cBuilding;
            var _local_22:dResourceCreationDefinition;
            this.CalculateMapClipping(GCB_MODE_CLIPPING.CLIP_TO_SCREEN_FOREGROUND, this.mTempClippingRectangle);
            _local_2 = this.mTempClippingRectangle.minX;
            _local_3 = this.mTempClippingRectangle.minY;
            _local_4 = this.mTempClippingRectangle.maxX;
            _local_5 = this.mTempClippingRectangle.maxY;
            var _local_6:int = -(global.streetGridY - 24);
            var _local_8:Boolean = true;
            var _local_9:Number = this.mGeneralInterface.mZoom.GetScaleFactor();
            if (_local_9 < 600)
            {
                _local_8 = false;
            };
            var _local_10:int;
            var _local_11:int = (_local_3 - 1);
            while (_local_11 <= (_local_5 + 1))
            {
                _local_10 = ((_local_11 * this.mGeneralInterface.mCurrentPlayerZone.mMapWidth) + _local_2);
                _local_12 = _local_2;
                while (_local_12 <= _local_4)
                {
                    _local_7 = this.mDepositContainer.get(_local_10);
                    if (_local_7 != null)
                    {
                        _local_13 = this.mAdditionalData.get(_local_10, AdditionalDataTSO.Sector);
                        _local_14 = this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector[_local_13].GetOwnerPlayerID();
                        if (_local_14 != -1)
                        {
                            _local_15 = _local_7.GetContainerName_string();
                            _local_16 = gMisc.GetSubString_string(_local_15, 7, (_local_15.length - 7));
                            if (((_arg_1 == null) || (_arg_1 == _local_16)))
                            {
                                _local_17 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, _local_16);
                                _local_18 = int(_local_7.GetX());
                                _local_19 = int(_local_7.GetY());
                                _local_20 = gMisc.ConvertDoubleToString_string(_local_7.GetAmount());
                                _local_21 = this.mBuildingContainer.get(_local_10);
                                if (((!(_local_21 == null)) && (!(_local_21.GetResourceCreation() == null))))
                                {
                                    _local_22 = _local_21.GetResourceCreation().GetResourceCreationDefinition();
                                    if ((((!(_local_22 == null)) && (_local_22.externalResource_string == _local_7.GetName_string())) && (_local_22.amountRemoved == 0)))
                                    {
                                        _local_20 = cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, "Unlimited");
                                    };
                                };
                                if (_local_7.GetAccessibleType() == DEPOSIT_ACCESSIBLE_TYPES.ACCESSIBLE)
                                {
                                    _local_7.RenderPos(_local_18, _local_19);
                                    if (_local_8)
                                    {
                                        this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, ((_local_20 + " ") + _local_17), _local_18, (_local_19 + _local_6));
                                    };
                                }
                                else
                                {
                                    _local_7.RenderTransform(_local_18, _local_19, BlendMode.DARKEN, 1, 1, 0);
                                    if (_local_8)
                                    {
                                        this.mGeneralInterface.mCurrentPlayerZone.RenderTextCenter(cBackbuffer.mBackBuffer, (((((("[" + _local_20) + " ") + _local_17) + " in Group: ") + _local_7.GetDepositGroupID()) + "]"), _local_18, (_local_19 + _local_6));
                                    };
                                };
                            };
                        };
                    };
                    _local_10++;
                    _local_12++;
                };
                _local_11++;
            };
        }


    }
}
