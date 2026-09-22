package GUI.Assets
{
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class BinFileMap 
    {

        protected var id2data:Dictionary;
        private var lastMaxId:Number = 0;
        protected var name2id:Dictionary;

        public function BinFileMap(_arg_1:BinDataHolderVO)
        {
            super();
            this.id2data = new Dictionary();
            this.name2id = new Dictionary();
            this.load(_arg_1);
        }

        public function getBytes(_arg_1:String):ByteArray
        {
            if (!(_arg_1 in this.name2id))
            {
                return (null);
            };
            return (this.id2data[this.name2id[_arg_1]]);
        }

        public function load(_arg_1:BinDataHolderVO):void
        {
            var _local_3:Number;
            var _local_4:NamedDataBinVO;
            var _local_5:NameToNamedDataVO;
            var _local_6:ByteArray;
            var _local_2:int = this.lastMaxId;
            if (_arg_1 != null)
            {
                for each (_local_4 in _arg_1.data)
                {
                    _local_3 = (_local_4.id + _local_2);
                    _local_6 = new ByteArray();
                    _local_6.writeBytes(_local_4.bytedata);
                    this.id2data[_local_3] = _local_6;
                    _local_4.bytedata.clear();
                    this.lastMaxId = Math.max(this.lastMaxId, _local_3);
                };
                for each (_local_5 in _arg_1.mapping)
                {
                    _local_3 = (_local_5.id + _local_2);
                    this.name2id[_local_5.name] = _local_3;
                    this.lastMaxId = Math.max(this.lastMaxId, _local_3);
                };
            };
        }

        public function getNames():Vector.<String>
        {
            var _local_2:String;
            var _local_1:Vector.<String> = new Vector.<String>();
            for (_local_2 in this.name2id)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }


    }
}
