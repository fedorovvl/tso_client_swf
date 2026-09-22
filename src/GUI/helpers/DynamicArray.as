package GUI.helpers
{
    import Utils.Disposable;

    public class DynamicArray 
    {

        private var innerArray:Array;
        private var length:int;
        private var cls:Class;
        private var realLength:int;

        public function DynamicArray(_arg_1:Class, _arg_2:int)
        {
            super();
            this.cls = _arg_1;
            this.innerArray = [];
            this.realLength = 0;
            this.setLength(_arg_2);
        }

        public function getArray():Array
        {
            return (this.innerArray.slice(0, this.length));
        }

        public function dispose():void
        {
            var _local_1:Disposable;
            var _local_2:Object;
            if (this.innerArray != null)
            {
                for each (_local_2 in _local_2)
                {
                    if ((_local_2 is Disposable))
                    {
                        _local_1 = (_local_2 as Disposable);
                        _local_1.dispose();
                    };
                };
                this.innerArray = null;
            };
            this.cls = null;
        }

        public function setLength(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            if (_arg_1 > this.realLength)
            {
                _local_2 = 0;
                _local_3 = (_arg_1 - this.realLength);
                while (_local_2 < _local_3)
                {
                    this.innerArray.push(new this.cls());
                    _local_2++;
                };
                this.realLength = _arg_1;
            };
            this.length = _arg_1;
        }


    }
}
