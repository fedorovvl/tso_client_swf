package Utils
{
    import __AS3__.vec.Vector;
    import GO.cCombatPreviewPath;
    import __AS3__.vec.*;

    public class PreviewPathsContainer 
    {

        private var mCombatPreviewContainer:Vector.<cCombatPreviewPath> = null;

        public function PreviewPathsContainer()
        {
            super();
            this.mCombatPreviewContainer = new Vector.<cCombatPreviewPath>();
        }

        public function add(_arg_1:cCombatPreviewPath):void
        {
            var _local_2:cCombatPreviewPath;
            for each (_local_2 in this.mCombatPreviewContainer)
            {
                if (_arg_1.mUniqueId.eq(_local_2.mUniqueId))
                {
                    this.remove(_local_2);
                };
            };
            this.mCombatPreviewContainer.push(_arg_1);
        }

        public function getAllPaths(_arg_1:int):Vector.<cCombatPreviewPath>
        {
            var _local_3:cCombatPreviewPath;
            var _local_2:Vector.<cCombatPreviewPath> = new Vector.<cCombatPreviewPath>();
            for each (_local_3 in this.mCombatPreviewContainer)
            {
                if ((((_local_3.GetGridStart() == _arg_1) || (_local_3.GetGridFinish() == _arg_1)) || (_local_3.isGridInBlocking(_arg_1))))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function getPaths(_arg_1:int):Vector.<cCombatPreviewPath>
        {
            var _local_3:cCombatPreviewPath;
            var _local_2:Vector.<cCombatPreviewPath> = new Vector.<cCombatPreviewPath>();
            for each (_local_3 in this.mCombatPreviewContainer)
            {
                if ((((_local_3.GetGridStart() == _arg_1) || (_local_3.GetGridFinish() == _arg_1)) || (_local_3.isGridInBlocking(_arg_1))))
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function isMoveContextMenuActive():Boolean
        {
            var _local_1:cCombatPreviewPath;
            for each (_local_1 in this.mCombatPreviewContainer)
            {
                if (_local_1.mShowPermPath)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function remove(_arg_1:cCombatPreviewPath):void
        {
            var _local_2:int = this.mCombatPreviewContainer.indexOf(_arg_1);
            if (_local_2 >= 0)
            {
                this.mCombatPreviewContainer.splice(_local_2, 1);
            };
        }


    }
}
