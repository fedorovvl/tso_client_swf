package nLib
{
    import Communication.VO.IntegerListVO;

    public class AdditionalData 
    {

        private var mContainer:* = null;
        private var mCapacity:uint = 0;

        public function AdditionalData(_arg_1:*, _arg_2:uint)
        {
            super();
            this.mCapacity = _arg_2;
            this.mContainer = _arg_1;
            this.mContainer.length = _arg_2;
            this.mContainer.fixed = true;
        }

        public function size():uint
        {
            return (this.mContainer.length);
        }

        public function set(_arg_1:uint, _arg_2:AdditionalDataField, _arg_3:uint):void
        {
            if (_arg_1 < this.mContainer.length)
            {
                this.mContainer[_arg_1] = ((this.mContainer[_arg_1] & (~(_arg_2.mask()))) | ((_arg_3 << _arg_2.shift()) & _arg_2.mask()));
            };
        }

        public function get(_arg_1:uint, _arg_2:AdditionalDataField):int
        {
            if (_arg_1 < this.mContainer.length)
            {
                return ((this.mContainer[_arg_1] & _arg_2.mask()) >> _arg_2.shift());
            };
            return (0);
        }

        public function forEach(_arg_1:Function):void
        {
            var _local_2:uint;
            while (_local_2 < this.mContainer.length)
            {
                (_arg_1(_local_2, this));
                _local_2++;
            };
        }

        public function clear(clearValue:int=0):void
        {
            this.mContainer.forEach(function (_arg_1:int, _arg_2:int, _arg_3:*):void
            {
                _arg_3[_arg_2] = clearValue;
            });
        }

        public function getVO(_arg_1:AdditionalDataField):IntegerListVO
        {
            var _local_2:IntegerListVO = new IntegerListVO();
            var _local_3:uint;
            while (_local_3 < this.mContainer.length)
            {
                _local_2.set(_local_3, this.get(_local_3, _arg_1));
                _local_3++;
            };
            return (_local_2);
        }


    }
}
