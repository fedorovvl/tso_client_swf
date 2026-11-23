package ServerState
{
    import __AS3__.vec.Vector;
    import GO.cCombatPreviewPath;
    import Interface.cGeneralInterface;
    import Communication.VO.CombatPreviewPathVO;
    import Communication.VO.dUniqueID;
    import __AS3__.vec.*;

    public class cCombatPersistedPreview 
    {

        private var mPathsWaitingForServer:int = 0;
        public var mCombatPreviewPaths:Vector.<cCombatPreviewPath> = new Vector.<cCombatPreviewPath>();
        private var mGeneralInterface:cGeneralInterface;

        public function cCombatPersistedPreview(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mPathsWaitingForServer = 0;
        }

        public function isLimitReached():Boolean
        {
            return ((this.mCombatPreviewPaths.length + this.mPathsWaitingForServer) >= 5);
        }

        public function addPathsWaitingForServer():void
        {
            this.mPathsWaitingForServer++;
        }

        public function removePathsWaitingForServer():void
        {
            this.mPathsWaitingForServer--;
        }

        public function MovePreviewPath(_arg_1:CombatPreviewPathVO):Boolean
        {
            var _local_2:cCombatPreviewPath;
            for each (_local_2 in this.mCombatPreviewPaths)
            {
                if (_local_2.mUniqueId.eq(_arg_1.uniqueId))
                {
                    _local_2.SetGridPath(_arg_1.gridStart, _arg_1.gridFinish);
                    _local_2.RefreshPath();
                    return (true);
                };
            };
            return (false);
        }

        public function CalculatePreviewPaths():void
        {
            var _local_1:cCombatPreviewPath;
            for each (_local_1 in this.mCombatPreviewPaths)
            {
                _local_1.RefreshPath();
            };
        }

        public function DeleteCombatPreviewPath(_arg_1:dUniqueID):void
        {
            var _local_3:cCombatPreviewPath;
            var _local_2:int;
            for each (_local_3 in this.mCombatPreviewPaths)
            {
                if (_local_3.mUniqueId.eq(_arg_1))
                {
                    this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mPathsPreviewsContainer.remove(_local_3);
                    this.mCombatPreviewPaths.splice(_local_2, 1);
                    // The path may still be the one being moved; its streets
                    // are rebuilt on the next Render() if so.
                    _local_3.disposeStreets();
                    break;
                };
                _local_2++;
            };
        }

        // Called when a zone refresh replaces this object: release the streets
        // of every path and take the paths out of the map's container, which an
        // on-the-fly refresh keeps.
        public function dispose():void
        {
            var _local_1:cCombatPreviewPath;
            for each (_local_1 in this.mCombatPreviewPaths)
            {
                this.mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mPathsPreviewsContainer.remove(_local_1);
                _local_1.disposeStreets();
            };
            this.mCombatPreviewPaths.length = 0;
        }

        public function AddPreviewPath(_arg_1:CombatPreviewPathVO):void
        {
            var _local_2:cCombatPreviewPath;
            if (!this.MovePreviewPath(_arg_1))
            {
                _local_2 = cCombatPreviewPath.CreateCombatPreviewPath(_arg_1);
                this.mCombatPreviewPaths.push(_local_2);
            };
        }

        public function RenderPreviewPaths():void
        {
            var _local_1:cCombatPreviewPath;
            for each (_local_1 in this.mCombatPreviewPaths)
            {
                _local_1.Render();
            };
        }


    }
}
