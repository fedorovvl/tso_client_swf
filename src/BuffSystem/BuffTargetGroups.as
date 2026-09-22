package BuffSystem
{
    import nLib.cXML;

    public final class BuffTargetGroups 
    {

        private var groups:Object;

        public function BuffTargetGroups()
        {
            super();
            this.groups = {};
        }

        private static function readTargets(_arg_1:String, _arg_2:Object, _arg_3:Object):void
        {
            var _local_5:cXML;
            var _local_6:String;
            var _local_4:cXML = (_arg_3[_arg_1] as cXML);
            if (_local_4 == null)
            {
                return;
            };
            for each (_local_5 in _local_4.CreateChildrenArray())
            {
                _local_6 = _local_5.GetAttributeString_string("name", "");
                if ("Target" == _local_5.GetName_string())
                {
                    _arg_2[_local_6] = _local_6;
                }
                else
                {
                    readTargets(_local_6, _arg_2, _arg_3);
                };
            };
        }

        public static function fromXML(_arg_1:cXML):BuffTargetGroups
        {
            var _local_4:String;
            var _local_5:cXML;
            var _local_6:BuffTargetGroups;
            var _local_7:Object;
            var _local_8:BuffTargetGroup;
            var _local_2:Array = [];
            var _local_3:Object = {};
            for each (_local_5 in _arg_1.CreateChildrenArray())
            {
                _local_4 = _local_5.GetAttributeString_string("name", "");
                _local_3[_local_4] = _local_5;
                _local_2.push(_local_4);
            };
            _local_6 = new (BuffTargetGroups)();
            for each (_local_4 in _local_2)
            {
                _local_7 = {};
                readTargets(_local_4, _local_7, _local_3);
                _local_8 = new BuffTargetGroup(_local_4, _local_7);
                _local_6.groups[_local_4] = _local_8;
            };
            return (_local_6);
        }


        public function groupContains(_arg_1:String, _arg_2:String):Boolean
        {
            if (this.groups[_arg_1] == null)
            {
                return (false);
            };
            return ((this.groups[_arg_1] as BuffTargetGroup).contains(_arg_2));
        }


    }
}
