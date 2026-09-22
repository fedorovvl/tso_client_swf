package nLib
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class IndexedContainer 
    {

        private static const INVALID_OFFSET:int = -1;

        private var mFreeOffsets:Vector.<int> = null;
        private var mCapacity:uint = 0;
        private var mIndices:Vector.<int> = null;
        public var mContainer:* = null;

        public function IndexedContainer(_arg_1:*, _arg_2:uint)
        {
            super();
            this.mCapacity = _arg_2;
            this.mContainer = _arg_1;
            this.mIndices = new Vector.<int>();
            this.mFreeOffsets = new Vector.<int>();
            this.mIndices.length = _arg_2;
            this.mIndices.fixed = true;
            this.clear();
        }

        public function containsKey(_arg_1:uint):Boolean
        {
            return (this.isSet(_arg_1));
        }

        public function setElement(_arg_1:uint, _arg_2:*):void
        {
            var _local_3:int;
            if (this.mIndices.length > _arg_1)
            {
                _local_3 = this.mIndices[_arg_1];
                if (INVALID_OFFSET == _local_3)
                {
                    if (this.mFreeOffsets.length > 0)
                    {
                        _local_3 = this.mFreeOffsets.pop();
                    }
                    else
                    {
                        _local_3 = this.mContainer.length;
                        this.mContainer.length = (this.mContainer.length + 1);
                    };
                };
                this.mIndices[_arg_1] = _local_3;
                this.mContainer[_local_3] = _arg_2;
            };
        }

        public function isEmpty():Boolean
        {
            return (0 == this.mContainer.length);
        }

        public function remove(_arg_1:uint):void
        {
            if (this.mIndices.length > _arg_1)
            {
                if (INVALID_OFFSET != this.mIndices[_arg_1])
                {
                    this.mFreeOffsets.push(this.mIndices[_arg_1]);
                    this.mContainer[this.mIndices[_arg_1]] = null;
                    this.mIndices[_arg_1] = INVALID_OFFSET;
                };
            };
        }

        public function forEach(functor:Function):void
        {
            this.mContainer.forEach(function (_arg_1:*, _arg_2:int, _arg_3:*):void
            {
                if (null != _arg_1)
                {
                    functor(_arg_1);
                };
            });
        }

        public function clear():void
        {
            this.mContainer.length = 0;
            this.mFreeOffsets.length = 0;
            this.mIndices.forEach(function (_arg_1:int, _arg_2:int, _arg_3:Vector.<int>):void
            {
                _arg_3[_arg_2] = INVALID_OFFSET;
            }, null);
        }

        public function put(_arg_1:uint, _arg_2:*):void
        {
            this.setElement(_arg_1, _arg_2);
        }

        public function compact():void
        {
            if (this.mFreeOffsets.length > 0)
            {
                this.mFreeOffsets.sort(Array.NUMERIC);
                this.mIndices.forEach(function (_arg_1:int, _arg_2:int, _arg_3:Vector.<int>):void
                {
                    var _local_4:uint;
                    var _local_5:uint;
                    if (INVALID_OFFSET != _arg_1)
                    {
                        _local_4 = 0;
                        _local_5 = 0;
                        while (_local_5 < mFreeOffsets.length)
                        {
                            if (mFreeOffsets[_local_5] < _arg_1)
                            {
                                _local_4++;
                            }
                            else
                            {
                                break;
                            };
                            _local_5++;
                        };
                        _arg_3[_arg_2] = (_arg_3[_arg_2] - _local_4);
                    };
                });
                this.mFreeOffsets.reverse();
                this.mFreeOffsets.forEach(function (_arg_1:int, _arg_2:int, _arg_3:Vector.<int>):void
                {
                    mContainer.splice(_arg_1, 1);
                });
                this.mFreeOffsets.length = 0;
            };
        }

        public function isSet(_arg_1:uint):Boolean
        {
            var _local_2:Boolean;
            if (_arg_1 < this.mCapacity)
            {
                _local_2 = (!(this.mIndices[_arg_1] == INVALID_OFFSET));
            };
            return (_local_2);
        }

        public function get(_arg_1:uint):*
        {
            if (((_arg_1 < this.mCapacity) && (!(INVALID_OFFSET == this.mIndices[_arg_1]))))
            {
                return (this.mContainer[this.mIndices[_arg_1]]);
            };
            return (null);
        }

        public function valueCollection():*
        {
            return (this.mContainer.concat());
        }


    }
}
