package Communication.VO
{
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;

    public class IntegerListVO 
    {

        public static const ONLY_ON_SERVER:int = -1;
        public static const ONLY_ON_CLIENT:int = -2;

        public var value:ArrayCollection;

        public function IntegerListVO()
        {
            super();
            this.value = new ArrayCollection();
        }

        public static function fromIntVector(_arg_1:Vector.<int>):IntegerListVO
        {
            var _local_2:IntegerListVO = new (IntegerListVO)();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.set(_local_3, _arg_1[_local_3]);
                _local_3++;
            };
            return (_local_2);
        }


        public function add(_arg_1:int):void
        {
            this.value.addItem(_arg_1);
        }

        public function get(_arg_1:int):Object
        {
            return ((this.value.length <= _arg_1) ? null : this.value.getItemAt(_arg_1));
        }

        public function set(_arg_1:int, _arg_2:int):void
        {
            while (this.value.length < (_arg_1 + 1))
            {
                this.value.addItem(null);
            };
            this.value.setItemAt(_arg_2, _arg_1);
        }

        public function toString():String
        {
            return (("<IntegerListVO value='" + this.value) + "' />");
        }


    }
}
