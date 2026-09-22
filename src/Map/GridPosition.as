package Map
{
    public class GridPosition 
    {

        private static const CODED_MINUS_ONE:int = 4194303;

        private var mGridIdx:int;

        public function GridPosition(_arg_1:int, _arg_2:int=64)
        {
            super();
            this.mGridIdx = getRawPosFromGrid(_arg_1, _arg_2);
        }

        public static function getMapWidth(_arg_1:int):int
        {
            var _local_2:* = (((_arg_1 >> 22) & 0x03FF) & 0xFF);
            if (0 == _local_2)
            {
                _local_2 = 64;
            };
            return (_local_2);
        }

        public static function getX(_arg_1:int, _arg_2:int):int
        {
            return ((_arg_1 & 0x3FFFFF) % _arg_2);
        }

        public static function getRawPosFromGrid(_arg_1:int, _arg_2:int):int
        {
            return (_arg_1 | (_arg_2 << 22));
        }

        public static function getY(_arg_1:int, _arg_2:int):int
        {
            return ((_arg_1 & 0x3FFFFF) / _arg_2);
        }

        public static function getGridIndex(_arg_1:int):int
        {
            var _local_2:* = (_arg_1 & 0x3FFFFF);
            if (CODED_MINUS_ONE == _local_2)
            {
                _local_2 = -1;
            };
            return (_local_2);
        }

        public static function convertIndex(_arg_1:int):int
        {
            return (0);
        }

        public static function getGridIndexFromXY(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            return ((_arg_2 * _arg_3) + _arg_1);
        }

        public static function getRawPosFromXY(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            return ((_arg_1 | (_arg_2 * _arg_3)) | (_arg_3 << 22));
        }


        public function convertPos(_arg_1:int):GridPosition
        {
            var _local_4:int;
            var _local_5:int;
            var _local_2:int = this.gridIndex();
            var _local_3:int = -1;
            if (-1 != _local_2)
            {
                _local_4 = this.X();
                _local_5 = this.Y();
                _local_3 = ((_local_5 * _arg_1) + Math.min(_local_4, (_arg_1 - 1)));
            };
            return (this.initWidth(_arg_1).setGridIndex(_local_3));
        }

        public function getRawPos():int
        {
            return (this.mGridIdx);
        }

        public function gridIndex():int
        {
            return (getGridIndex(this.mGridIdx));
        }

        public function MapWidth():int
        {
            var _local_1:* = (((this.mGridIdx >> 22) & 0x03FF) & 0xFF);
            if (0 == _local_1)
            {
                this.mGridIdx = (this.mGridIdx | (64 << 22));
                _local_1 = 64;
            };
            return (_local_1);
        }

        public function setRawPos(_arg_1:int):GridPosition
        {
            this.mGridIdx = _arg_1;
            return (this);
        }

        public function setGridIndex(_arg_1:int):GridPosition
        {
            this.mGridIdx = ((this.mGridIdx & 0xFFC00000) | (_arg_1 & 0x3FFFFF));
            return (this);
        }

        public function initWidth(_arg_1:int):GridPosition
        {
            this.mGridIdx = ((_arg_1 & 0x03FF) << 22);
            return (this);
        }

        public function X():int
        {
            return (this.mGridIdx % this.MapWidth());
        }

        public function Y():int
        {
            return (this.mGridIdx / this.MapWidth());
        }

        public function MaxX():int
        {
            return (this.MapWidth() - 1);
        }


    }
}
