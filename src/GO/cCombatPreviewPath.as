package GO
{
    import __AS3__.vec.Vector;
    import Communication.VO.dUniqueID;
    import PathFinding.cPathObject;
    import Interface.cGeneralInterface;
    import Communication.VO.CombatPreviewPathVO;
    import PathFinding.PFAdditionalData;
    import Map.GridPosition;
    import PathFinding.dPathObjectItem;
    import nLib.cPosInt;
    import Enums.COMMAND;
    import Enums.OBJECTTYPE;
    import __AS3__.vec.*;

    public class cCombatPreviewPath extends cGO 
    {

        private var mGridFinish:int;
        private var mStartBloking:Vector.<int> = new Vector.<int>();
        private var mShowPath:Boolean = false;
        private var mCachedStreet:Boolean = false;
        private var mGridStart:int;
        public var mUniqueId:dUniqueID;
        private var mStreets_vector:Vector.<cStreet>;
        public var mPreviewPath:cPathObject;
        public var mShowPermPath:Boolean = false;

        public function cCombatPreviewPath(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int, _arg_4:dUniqueID)
        {
            super(_arg_1);
            this.mUniqueId = _arg_4;
            this.SetGridPath(_arg_2, _arg_3);
            if (!dUniqueID.isEmpty(this.mUniqueId))
            {
                mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mPathsPreviewsContainer.add(this);
            };
        }

        public static function CreateCombatPreviewPath(_arg_1:CombatPreviewPathVO):cCombatPreviewPath
        {
            var _local_2:cCombatPreviewPath = new cCombatPreviewPath(global.ui, _arg_1.gridStart, _arg_1.gridFinish, _arg_1.uniqueId);
            _local_2.RefreshPath();
            return (_local_2);
        }


        public function CreateVO():CombatPreviewPathVO
        {
            var _local_1:CombatPreviewPathVO = new CombatPreviewPathVO();
            _local_1.uniqueId = this.mUniqueId;
            _local_1.gridFinish = this.mGridFinish;
            _local_1.gridStart = this.mGridStart;
            return (_local_1);
        }

        public function RefreshPath():void
        {
            var _local_1:Vector.<PFAdditionalData> = new Vector.<PFAdditionalData>();
            var _local_2:PFAdditionalData = new PFAdditionalData(new GridPosition(this.mGridFinish, global.ui.mCurrentPlayerZone.mMapWidth), cBlockingData.BLOCK_TYPE_ALLOW_NOTHING);
            _local_1.push(_local_2);
            var _local_3:PFAdditionalData = new PFAdditionalData(new GridPosition(this.mGridStart, global.ui.mCurrentPlayerZone.mMapWidth), cBlockingData.BLOCK_TYPE_ALLOW_NOTHING);
            _local_1.push(_local_3);
            var _local_4:int = gCalculations.MoveStreetGridToDir8(global.ui.mCurrentPlayerZone, this.mGridFinish, defines.DIR8_SOUTH_EAST);
            var _local_5:int = gCalculations.MoveStreetGridToDir8(global.ui.mCurrentPlayerZone, this.mGridStart, defines.DIR8_SOUTH_EAST);
            this.mPreviewPath = mGeneralInterface.mPathFinder.CalculatePath(_local_4, _local_5, _local_1, true);
            this.mCachedStreet = false;
        }

        public function clone():cCombatPreviewPath
        {
            var _local_1:CombatPreviewPathVO = this.CreateVO();
            return (CreateCombatPreviewPath(_local_1));
        }

        public function ShowPath():void
        {
            this.mShowPath = true;
        }

        public function GetGridFinish():int
        {
            return (this.mGridFinish);
        }

        public function isGridInBlocking(_arg_1:int):Boolean
        {
            return (this.mStartBloking.indexOf(_arg_1) >= 0);
        }

        public function SetGridPath(_arg_1:int, _arg_2:int):void
        {
            if (_arg_1 != -1)
            {
                this.mGridStart = _arg_1;
                this.AddStartBlocking();
            };
            if (_arg_2 != -1)
            {
                this.mGridFinish = _arg_2;
            };
        }

        public function ShowPermPath():void
        {
            this.mShowPermPath = true;
        }

        public function GetGridStart():int
        {
            return (this.mGridStart);
        }

        override public function Render():void
        {
            var _local_2:Vector.<int>;
            var _local_3:int;
            var _local_4:cStreet;
            var _local_5:dPathObjectItem;
            var _local_6:cStreet;
            var _local_7:Vector.<int>;
            var _local_8:int;
            var _local_9:cBuilding;
            if (((this.mShowPath) || (this.mShowPermPath)))
            {
                if (!this.mCachedStreet)
                {
                    this.mCachedStreet = true;
                    this.mStreets_vector = new Vector.<cStreet>();
                    for each (_local_5 in this.mPreviewPath.dest_vector)
                    {
                        _local_6 = new cStreet(mGeneralInterface);
                        _local_6.SetGrid(_local_5.streetGridIdx);
                        _local_6.SetStreetType(cStreet.TYPE_ARMY);
                        this.mStreets_vector.push(_local_6);
                    };
                };
                _local_2 = new Vector.<int>();
                _local_3 = 1;
                for each (_local_4 in this.mStreets_vector)
                {
                    _local_4.Render();
                    _local_7 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetReadyTowerGridIdxs(_local_4.GetGrid());
                    for each (_local_8 in _local_7)
                    {
                        _local_8 = gCalculations.MoveStreetGridToDir8(global.ui.mCurrentPlayerZone, _local_8, defines.DIR8_NORTH_WEST);
                        if (_local_2.indexOf(_local_8) == -1)
                        {
                            _local_9 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.GetBuildingByGridPos(_local_8);
                            _local_9.SetInterceptIndex(_local_3);
                            mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.RenderWatchAreaOfSelectedBuilding(_local_9);
                            _local_3++;
                            _local_2.push(_local_8);
                        };
                    };
                };
            };
            var _local_1:cPosInt = new cPosInt();
            if (((!(this.mShowPath)) || ((!(mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START)) && (!(mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_BLOCKING_PATH_PREVIEW_START)))))
            {
                gCalculations.ConvertStreetGridToPixelPos(global.ui.mCurrentPlayerZone, this.mGridStart, _local_1);
                mGeneralInterface.mBlockingPathPreviewStart.mSprite.RenderPos(_local_1.x, _local_1.y);
            };
            if (((!(this.mShowPath)) || ((!(mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET)) && (!(mGeneralInterface.mCurrentCursor.GetEditMode() == COMMAND.ADD_BLOCKING_PATH_PREVIEW_TARGET)))))
            {
                gCalculations.ConvertStreetGridToPixelPos(global.ui.mCurrentPlayerZone, this.mGridFinish, _local_1);
                mGeneralInterface.mBlockingPathPreviewFinish.mSprite.RenderPos(_local_1.x, _local_1.y);
            };
            this.mShowPath = false;
        }

        public function HidePermPath():void
        {
            this.mShowPermPath = false;
        }

        public function AddStartBlocking():void
        {
            var _local_3:cBlockingData;
            var _local_4:int;
            var _local_5:int;
            var _local_1:Vector.<cBlockingData> = cGO.GetBlockingList(OBJECTTYPE.BUILDING, "GhostGarrison");
            var _local_2:cPosInt = new cPosInt();
            gCalculations.ConvertStreetGridToPixelPos(mGeneralInterface.mCurrentPlayerZone, this.mGridStart, _local_2);
            this.mStartBloking = new Vector.<int>();
            for each (_local_3 in _local_1)
            {
                _local_4 = int((_local_2.x + ((_local_3.getXPixelOffset() * global.streetGridX) / 100)));
                _local_5 = int((_local_2.y + ((_local_3.getYPixelOffset() * global.streetGridY) / 100)));
                this.mStartBloking.push(gCalculations.ConvertPixelPosToStreetGridPos(mGeneralInterface.mCurrentPlayerZone, _local_4, _local_5));
            };
        }


    }
}
