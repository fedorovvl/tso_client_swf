package SettlerKI
{
    import __AS3__.vec.Vector;
    import GO.cSettler;
    import nLib.cPosInt;
    import Interface.cGeneralInterface;
    import nLib.gMisc;
    import Enums.OBJECTTYPE;
    import Enums.SETTLER_KI_TYP;
    import ServerState.cPlayerData;
    import ServerState.cResourceCreation;
    import GO.cGOGroup;
    import Interface.cGameInterface;
    import GO.cBuilding;
    import Enums.RENDER_LAYER;
    import Specialists.cSpecialistTask_WithSettler;
    import flash.display.Graphics;
    import __AS3__.vec.*;

    public class cSettlerManager 
    {

        public static const UNDISPLAYED_SETTLERPOS:int = 2147483647;
        private static var settlerNames:Array = [];

        public var ACTIVATE_SETTLER_DEBUG_INFO:Boolean = false;
        private var mAnimalsAvailable_vector:Vector.<int> = null;
        public var mSettlersList_vector:Vector.<cSettler> = new Vector.<cSettler>();
        private var mAnimalCount:int = 0;
        private var mTempPos:cPosInt = new cPosInt();
        private var mGeneralInterface:cGeneralInterface;

        public function cSettlerManager(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
        }

        public function SpawnSettlerOnResourcePath(_arg_1:cPlayerData, _arg_2:cResourceCreation, _arg_3:String):void
        {
            var _local_4:String;
            var _local_9:int;
            if (_arg_3 == null)
            {
                _local_9 = int(gMisc.GetRandomMinMax(0, (global.settlerGroup.mGOList_vector.length - 1)));
                _local_4 = global.settlerGroup.mGOList_vector[_local_9].mGfxResourceListName_string;
            }
            else
            {
                _local_4 = _arg_3;
            };
            var _local_5:Number = _arg_2.GetResourceCreationHouse().GetX();
            var _local_6:Number = _arg_2.GetResourceCreationHouse().GetY();
            if (_arg_2.GetPath() != null)
            {
                _local_5 = _arg_2.GetPath().dest_vector[0].x;
                _local_6 = _arg_2.GetPath().dest_vector[0].y;
            }
            else
            {
                _local_5 = UNDISPLAYED_SETTLERPOS;
                _local_6 = UNDISPLAYED_SETTLERPOS;
            };
            var _local_7:cSettler = this.SetSettlerAtPixelPosition(global.settlerGroup, OBJECTTYPE.SETTLER, _local_4, SETTLER_KI_TYP.WALK_TO_DESTINATION, int(_local_5), int(_local_6));
            var _local_8:cSettlerKIWalkToDestination = (_local_7.mSettlerKi as cSettlerKIWalkToDestination);
            _local_8.SetResourcePath(_arg_2);
            _arg_2.SetSettler(_local_7);
        }

        public function RenderCompute():void
        {
            var _local_1:cSettler;
            var _local_2:cSettlerKI;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:cSettlerKIWalkToDestination;
            var _local_3:int = (this.mGeneralInterface.mCurrentPlayerZone.mMapWidth * this.mGeneralInterface.mCurrentPlayerZone.mMapHeight);
            var _local_4:int = int(((global.maxAnimalsOnMap / this.mGeneralInterface.mCurrentPlayerZone.mSectorList_vector.length) * this.mGeneralInterface.mHomePlayer.GetSectorsDiscAmount()));
            if (this.mAnimalsAvailable_vector != null && this.mAnimalsAvailable_vector.length > 0 &&
                this.mAnimalCount < _local_4 && cSettingsManager.getInstance().showAnimals)
            {
                _local_6 = 0;
                while (_local_6 < 20)
                {
                    _local_7 = int((Math.random() * (this.mGeneralInterface.mCurrentPlayerZone.mMapWidth * this.mGeneralInterface.mCurrentPlayerZone.mMapHeight)));
                    _local_8 = (_local_7 % this.mGeneralInterface.mCurrentPlayerZone.mMapWidth);
                    _local_9 = int((_local_7 / this.mGeneralInterface.mCurrentPlayerZone.mMapWidth));
                    if (gCalculations.IsGridXYInsideMap(this.mGeneralInterface.mCurrentPlayerZone, _local_8, _local_9))
                    {
                        if (!this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsBlockedAllowedNothingOrFog(_local_7))
                        {
                            _local_10 = _local_7;
                            if (!this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.IsBlockedAllowedNothingOrFog(_local_10))
                            {
                                gCalculations.ConvertStreetGridToPixelPos(this.mGeneralInterface.mCurrentPlayerZone, _local_10, this.mTempPos);
                                this.SpawnAnimal(this.mTempPos.x, this.mTempPos.y);
                                this.mAnimalCount++;
                                break;
                            };
                        };
                    };
                    _local_6++;
                };
            };
            var _local_5:int;
            while (_local_5 < this.mSettlersList_vector.length)
            {
                _local_1 = this.mSettlersList_vector[_local_5];
                _local_1.Compute();
                if (_local_1.mSettlerKi.GetKIState() == cSettlerKI.SETTLER_STATE_REMOVE_SETTLER)
                {
                    if ((_local_1.mSettlerKi is cSettlerKIWalkToDestination))
                    {
                        _local_11 = (_local_1.mSettlerKi as cSettlerKIWalkToDestination);
                        if (_local_11.mResourceCreation != null)
                        {
                            _local_11.mResourceCreation.SetSettler(null);
                        };
                    };
                    this.mGeneralInterface.channels.RENDER.renderObjectRemoved(_local_1);
                    this.mSettlersList_vector.splice(_local_5, 1);
                    _local_5--;
                };
                _local_5++;
            };
        }

        private function SetSettlerAtPixelPosition(_arg_1:cGOGroup, _arg_2:int, _arg_3:String, _arg_4:int, _arg_5:int, _arg_6:int):cSettler
        {
            var _local_7:cSettler = cSettler.CreateFromString(_arg_1, _arg_3, _arg_2, this.mGeneralInterface);
            _local_7.SetPosition(_arg_5, _arg_6);
            _local_7.SetRandomFrame();
            _local_7.SetKI(_arg_4);
            this.mSettlersList_vector.push(_local_7);
            this.mGeneralInterface.channels.RENDER.renderObjectAdded(_local_7);
            _local_7.name = settlerNames[gMisc.GetRandomMinMaxInt(0, (settlerNames.length - 1))];
            var _local_8:cSettlerKI = (_local_7.mSettlerKi as cSettlerKI);
            _local_8.Init();
            return (_local_7);
        }

        public function Init():void
        {
            this.Clear();
        }

        public function clearAnimals(_arg_1:Boolean):void
        {
            var _local_2:int;
            var _local_9:int;
            var _local_10:Vector.<cSettler>;
            var _local_11:cSettler;
            var _local_12:int;
            var _local_13:String;
            var _local_14:String;
            if (_arg_1)
            {
                _local_10 = new Vector.<cSettler>();
                _local_2 = this.mSettlersList_vector.length;
                while (_local_12 < _local_2)
                {
                    _local_11 = this.mSettlersList_vector[_local_12];
                    if (_local_11.GetLevelEnumObjectType() != OBJECTTYPE.ANIMAL)
                    {
                        _local_10.push(_local_11);
                    }
                    else
                    {
                        this.mGeneralInterface.channels.RENDER.renderObjectRemoved(_local_11);
                    };
                    _local_12++;
                };
                this.mSettlersList_vector = _local_10;
                this.mAnimalCount = 0;
            };
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_5:Vector.<int> = new Vector.<int>();
            var _local_6:Vector.<int> = new Vector.<int>();
            var _local_7:Vector.<int> = new Vector.<int>();
            var _local_8:Vector.<int> = new Vector.<int>();
            while (_local_9 < global.animalGroup.mGOList_vector.length)
            {
                _local_13 = global.animalGroup.mGOList_vector[_local_9].requiresEvent;
                _local_14 = global.animalGroup.mGOList_vector[_local_9].requiresBuff;
                if ((((!(_local_13 == null)) && (!(_local_13 == ""))) || ((!(_local_14 == null)) && (!(_local_14 == "")))))
                {
                    if (((!(_local_13 == null)) && (!(_local_13 == ""))))
                    {
                        if (((this.mGeneralInterface is cGameInterface) && ((this.mGeneralInterface as cGameInterface).mEventManager.isEventStarted(_local_13))))
                        {
                            _local_7.push(_local_9);
                        };
                    };
                    if (((!(_local_14 == null)) && (!(_local_14 == ""))))
                    {
                        if (((global.ui.isOnHomzone()) && (global.ui.mZoneBuffManager.isBuffRunning(_local_14))))
                        {
                            _local_8.push(_local_9);
                        };
                    };
                }
                else
                {
                    _local_6.push(_local_9);
                };
                if (((!(global.defaultAnimals == null)) && (global.animalGroup.mGOList_vector[_local_9].mGfxResourceListName_string in global.defaultAnimals)))
                {
                    _local_5.push(_local_9);
                };
                _local_9++;
            };
            if (_local_8.length > 0)
            {
                this.mAnimalsAvailable_vector = _local_8;
            }
            else
            {
                if (_local_7.length > 0)
                {
                    this.mAnimalsAvailable_vector = _local_7;
                }
                else
                {
                    this.mAnimalsAvailable_vector = ((global.defaultAnimals != null) ? _local_5 : _local_6);
                };
            };
        }

        public function BuildingWasPlaced(_arg_1:cBuilding, _arg_2:int):void
        {
            var _local_3:cSettler;
            var _local_4:Vector.<cSettler> = this.mSettlersList_vector;
            for each (_local_3 in _local_4)
            {
                _local_3.mSettlerKi.BuildingWasPlaced(_arg_1, _arg_2);
            };
        }

        public function Clear():void
        {
            this.mAnimalCount = 0;
            this.mSettlersList_vector = new Vector.<cSettler>();
            this.mGeneralInterface.channels.RENDER.clearByClass(RENDER_LAYER.MOVING, cSettler);
            this.clearAnimals(false);
        }

        public function SpawnAnimal(_arg_1:int, _arg_2:int):void
        {
            // A zone can have no matching animals, including during zone refresh.
            if (this.mAnimalsAvailable_vector == null || this.mAnimalsAvailable_vector.length == 0)
            {
                return;
            }
            var _local_3:int = gMisc.GetRandomMinMaxInt(0, (this.mAnimalsAvailable_vector.length - 1));
            var _local_4:int = this.mAnimalsAvailable_vector[_local_3];
            var _local_5:String = global.animalGroup.mGOList_vector[_local_4].mGfxResourceListName_string;
            this.SetSettlerAtPixelPosition(global.animalGroup, OBJECTTYPE.ANIMAL, _local_5, SETTLER_KI_TYP.WALK_FROM_FIELD_TO_FIELD, _arg_1, _arg_2);
        }

        public function setNameList(_arg_1:Array):void
        {
            settlerNames = _arg_1;
            this.clearAnimals(true);
        }

        public function SpawnSettler(_arg_1:cSpecialistTask_WithSettler, _arg_2:int, _arg_3:int, _arg_4:String):cSettler
        {
            var _local_5:cSettler = this.SetSettlerAtPixelPosition(global.settlerGroup, OBJECTTYPE.SETTLER, _arg_4, SETTLER_KI_TYP.PERFORM_GENERAL_TASK, _arg_2, _arg_3);
            var _local_6:cSettlerAI_WalkToTarget = (_local_5.mSettlerKi as cSettlerAI_WalkToTarget);
            _local_6.SetGeneralTask(_arg_1);
            return (_local_5);
        }

        public function RenderSettlerDebugInfo(_arg_1:Graphics):void
        {
        }


    }
}
