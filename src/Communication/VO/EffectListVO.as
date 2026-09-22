package Communication.VO
{
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;
    import nLib.cXML;
    import Utils.StringUtils;

    public class EffectListVO 
    {

        public var list:ArrayCollection = null;


        public static function fromVector(_arg_1:Vector.<EffectVO>):EffectListVO
        {
            var _local_3:EffectVO;
            if (((_arg_1 == null) || (_arg_1.length == 0)))
            {
                return (null);
            };
            var _local_2:EffectListVO = new (EffectListVO)();
            for each (_local_3 in _arg_1)
            {
                _local_2.list.addItem(_local_3);
            };
            return (_local_2);
        }

        public static function fromXML(_arg_1:cXML, _arg_2:String):EffectListVO
        {
            var _local_4:cXML;
            var _local_3:EffectListVO = new (EffectListVO)();
            for each (_local_4 in _arg_1.MoveToSubNode(_arg_2).CreateChildrenArray())
            {
                if (_local_3.list == null)
                {
                    _local_3.initList();
                };
                _local_3.list.addItem(EffectVO.CreateFromXML(_local_4));
            };
            if (_local_3.list == null)
            {
                return (null);
            };
            return (_local_3);
        }


        public function getEffectByName(_arg_1:String):EffectVO
        {
            var _local_2:EffectVO;
            for each (_local_2 in this.list)
            {
                if (StringUtils.equalsIgnoreCase(_local_2.effect_string, _arg_1))
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function clone():EffectListVO
        {
            var _local_2:EffectVO;
            var _local_1:EffectListVO = new EffectListVO();
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

        private function initList():void
        {
            this.list = new ArrayCollection();
        }

        public function contains(_arg_1:String):Boolean
        {
            return (!(this.getEffectByName(_arg_1) == null));
        }


    }
}
