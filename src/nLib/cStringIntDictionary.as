package nLib
{
    import flash.utils.Dictionary;

    public class cStringIntDictionary 
    {

        private var mDictionary:Dictionary = new Dictionary();

        public function cStringIntDictionary()
        {
            super();
            this.Reset();
        }

        public function Add(_arg_1:String, _arg_2:int):int
        {
            var _local_3:int;
            if (this.mDictionary[_arg_1] != null)
            {
                _local_3 = this.mDictionary[_arg_1];
                _local_3 = (_local_3 + _arg_2);
                this.mDictionary[_arg_1] = _local_3;
                return (_local_3);
            };
            return (defines.ILLEGAL_INT_POS);
        }

        public function Values():Object
        {
            return (this.mDictionary);
        }

        public function DeleteKeyNC(_arg_1:String):void
        {
            delete this.mDictionary[_arg_1];
        }

        public function GetNC(_arg_1:String, _arg_2:int):int
        {
            return (this.mDictionary[_arg_1]);
        }

        public function Reset():void
        {
            this.mDictionary = new Dictionary();
        }

        public function DeleteKey(_arg_1:String):Boolean
        {
            if (this.mDictionary[_arg_1] != null)
            {
                delete this.mDictionary[_arg_1];
                return (true);
            };
            return (false);
        }

        public function AddNC(_arg_1:String, _arg_2:int):int
        {
            var _local_3:int = this.mDictionary[_arg_1];
            _local_3 = (_local_3 + _arg_2);
            this.mDictionary[_arg_1] = _local_3;
            return (_local_3);
        }

        public function Get(_arg_1:String):int
        {
            if (this.mDictionary[_arg_1] != null)
            {
                return (this.mDictionary[_arg_1]);
            };
            return (defines.ILLEGAL_INT_POS);
        }

        public function Put(_arg_1:String, _arg_2:int):void
        {
            this.mDictionary[_arg_1] = _arg_2;
        }

        public function Contains(_arg_1:String):Boolean
        {
            return (!(this.mDictionary[_arg_1] == null));
        }


    }
}
