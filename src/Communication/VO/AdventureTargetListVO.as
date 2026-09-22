package Communication.VO
{
    import mx.collections.ArrayCollection;
    import nLib.cXML;
    import AdventureSystem.cAdventureDefinition;

    public class AdventureTargetListVO 
    {

        public var list:ArrayCollection = null;

        public function AdventureTargetListVO()
        {
            super();
            this.list = new ArrayCollection();
        }

        public static function fromXML(_arg_1:cXML, _arg_2:String):AdventureTargetListVO
        {
            var _local_5:cXML;
            var _local_3:AdventureTargetListVO;
            var _local_4:cXML = _arg_1.MoveToSubNode(_arg_2);
            if (_local_4 == null)
            {
                return (null);
            };
            for each (_local_5 in _local_4.CreateChildrenArray())
            {
                if (_local_3 == null)
                {
                    _local_3 = new (AdventureTargetListVO)();
                };
                _local_3.list.addItem(AdventureTargetVO.CreateFromXML(_local_5));
            };
            return (_local_3);
        }


        public function isTargetingAdventure(_arg_1:cAdventureDefinition):Boolean
        {
            var _local_2:AdventureTargetVO;
            for each (_local_2 in this.list)
            {
                if (_local_2.isTargetingAdventure(_arg_1))
                {
                    return (true);
                };
            };
            return (false);
        }


    }
}
