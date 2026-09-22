package Communication.VO
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;

    public class PropagatingBuffListVO 
    {

        public var list:ArrayCollection = null;


        public static function fromXML(_arg_1:cXML, _arg_2:String):PropagatingBuffListVO
        {
            var _local_4:cXML;
            var _local_3:PropagatingBuffListVO = new (PropagatingBuffListVO)();
            for each (_local_4 in _arg_1.MoveToSubNode(_arg_2).CreateChildrenArray())
            {
                if (_local_3.list == null)
                {
                    _local_3.initList();
                };
                _local_3.list.addItem(PropagatingBuffVO.CreateFromXML(_local_4));
            };
            if (_local_3.list == null)
            {
                return (null);
            };
            return (_local_3);
        }


        private function initList():void
        {
            this.list = new ArrayCollection();
        }

        public function clone():PropagatingBuffListVO
        {
            var _local_2:PropagatingBuffVO;
            var _local_1:PropagatingBuffListVO = new PropagatingBuffListVO();
            if (_local_1.list == null)
            {
                _local_1.initList();
            };
            for each (_local_2 in this.list)
            {
                _local_1.list.addItem(_local_2.clone());
            };
            return (_local_1);
        }


    }
}
