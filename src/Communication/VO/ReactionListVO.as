package Communication.VO
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;

    public class ReactionListVO 
    {

        public var list:ArrayCollection = null;


        public static function fromXML(_arg_1:cXML, _arg_2:String):ReactionListVO
        {
            var _local_6:cXML;
            var _local_3:ReactionListVO = new (ReactionListVO)();
            var _local_4:int;
            var _local_5:cXML = (("" == _arg_2) ? _arg_1 : _arg_1.MoveToSubNode(_arg_2));
            for each (_local_6 in _local_5.CreateChildrenArray())
            {
                if (_local_3.list == null)
                {
                    _local_3.initList();
                };
                _local_3.list.addItem(ReactionVO.createFromXML(_local_6));
            };
            if (_local_3.list == null)
            {
                return (null);
            };
            return (_local_3);
        }


        public function clone():ReactionListVO
        {
            var _local_2:ReactionVO;
            var _local_1:ReactionListVO = new ReactionListVO();
            if (_local_1.list == null)
            {
                _local_1.initList();
            };
            for each (_local_2 in this.list)
            {
                _local_1.list.addItem(_local_2);
            };
            return (_local_1);
        }

        private function initList():void
        {
            this.list = new ArrayCollection();
        }

        public function dispose():void
        {
            if (this.list != null)
            {
                this.list.removeAll();
                this.list = null;
            };
        }


    }
}
