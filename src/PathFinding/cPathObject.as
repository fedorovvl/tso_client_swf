package PathFinding
{
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import Communication.VO.IntegerListVO;
    import __AS3__.vec.*;

    public class cPathObject 
    {

        public var dest_vector:Vector.<dPathObjectItem>;
        public var pathLenX10000:int;
        public var pathLenX20000:int;

        public function cPathObject()
        {
            super();
            this.Reset();
        }

        public function RefreshLength():void
        {
            var _local_1:int = this.dest_vector.length;
            var _local_2:int = (2 * _local_1);
            this.pathLenX10000 = (_local_1 * defines.INT_SCALE_FACTOR);
            this.pathLenX20000 = (_local_2 * defines.INT_SCALE_FACTOR);
        }

        public function AddPathPoint(_arg_1:cGeneralInterface, _arg_2:int):void
        {
            var _local_3:dPathObjectItem = new dPathObjectItem();
            _local_3.streetGridIdx = _arg_2;
            gCalculations.ConvertStreetGridToPixelPos(_arg_1.mCurrentPlayerZone, _arg_2, _local_3);
            this.dest_vector.push(_local_3);
        }

        public function toString():String
        {
            var _local_3:dPathObjectItem;
            var _local_1:* = "PathObject[";
            var _local_2:Boolean;
            for each (_local_3 in this.dest_vector)
            {
                if (_local_2)
                {
                    _local_1.concat(", ");
                };
                _local_2 = true;
                _local_1.concat(_local_3.streetGridIdx);
            };
            _local_1.concat("]");
            return (_local_1);
        }

        public function Reset():void
        {
            this.dest_vector = new Vector.<dPathObjectItem>();
            this.pathLenX10000 = 0;
            this.pathLenX20000 = 0;
        }

        public function CalculateGridIdxForPathPos(_arg_1:int):int
        {
            var _local_2:int = int((_arg_1 / defines.INT_SCALE_FACTOR));
            if (_local_2 >= this.dest_vector.length)
            {
                _local_2 = (this.dest_vector.length - 1);
            };
            return (this.dest_vector[_local_2].streetGridIdx);
        }

        public function toVO():IntegerListVO
        {
            var _local_2:dPathObjectItem;
            var _local_1:IntegerListVO = new IntegerListVO();
            for each (_local_2 in this.dest_vector)
            {
                _local_1.add(_local_2.streetGridIdx);
            };
            return (_local_1);
        }


    }
}
