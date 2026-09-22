package Modifier
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public final class ModifierListVO 
    {

        public var list:ArrayCollection = null;


        public static function fromXML(_arg_1:cXML, _arg_2:String):ModifierListVO
        {
            var _local_4:cXML;
            var _local_3:ModifierListVO = new (ModifierListVO)();
            for each (_local_4 in _arg_1.MoveToSubNode(_arg_2).CreateChildrenArray())
            {
                if (_local_3.list == null)
                {
                    _local_3.initList();
                };
                _local_3.list.addItem(ModifierVO.CreateFromXML(_local_4));
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

        public function asVector():Vector.<ModifierVO>
        {
            var _local_2:ModifierVO;
            if (this.list == null)
            {
                return (null);
            };
            var _local_1:Vector.<ModifierVO> = new Vector.<ModifierVO>();
            for each (_local_2 in this.list)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }


    }
}
