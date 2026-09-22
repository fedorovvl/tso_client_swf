package Communication.VO
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;

    public class TriggerListVO extends TriggerVO 
    {

        public static const AND_LOGIC_OPERATOR:String = "all";
        public static const OR_LOGIC_OPERATOR:String = "any";
        private static const TRIGGER_LIST_LOGIC_OPERATOR:String = "operator";

        public var _doInstantChecks:Boolean;
        public var is_OR_operator:Boolean;
        public var list:ArrayCollection = null;


        public static function fromXML(_arg_1:cXML, _arg_2:String):TriggerListVO
        {
            var _local_6:cXML;
            if (_arg_1.isEmpty())
            {
                return (null);
            };
            var _local_3:TriggerListVO = new (TriggerListVO)();
            _local_3.is_OR_operator = (_arg_1.GetName_string().toLowerCase() == OR_LOGIC_OPERATOR);
            var _local_4:cXML = (("" == _arg_2) ? _arg_1 : _arg_1.MoveToSubNode(_arg_2));
            var _local_5:int;
            for each (_local_6 in _local_4.CreateChildrenArray())
            {
                if (_local_3.list == null)
                {
                    _local_3.initList();
                };
                _local_3.list.addItem(TriggerVO.createFromXML(_local_6, _local_5++));
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

        public function getTriggerCount():int
        {
            if (this.list == null)
            {
                return (0);
            };
            return (this.list.length);
        }

        override public function clone():TriggerVO
        {
            var _local_2:TriggerVO;
            var _local_1:TriggerListVO = new TriggerListVO();
            _local_1.is_OR_operator = this.is_OR_operator;
            _local_1._doInstantChecks = this._doInstantChecks;
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


    }
}
