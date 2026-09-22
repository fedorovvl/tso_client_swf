package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dArmyVO 
    {

        public var squads:ArrayCollection = new ArrayCollection();


        public function toString():String
        {
            var _local_2:dSquadVO;
            var _local_1:* = "<dArmyVO>\n";
            for each (_local_2 in this.squads)
            {
                _local_1 = (_local_1 + (_local_2 + "\n"));
            };
            return (_local_1 + "</dArmyVO>\n");
        }

        public function AddArmyVO(_arg_1:dArmyVO):void
        {
            var _local_2:dSquadVO;
            var _local_3:Boolean;
            var _local_4:dSquadVO;
            for each (_local_2 in _arg_1.squads)
            {
                _local_3 = false;
                for each (_local_4 in this.squads)
                {
                    if (_local_4.name_string == _local_2.name_string)
                    {
                        _local_4.amount = (_local_4.amount + _local_2.amount);
                        _local_3 = true;
                    };
                };
                if (!_local_3)
                {
                    this.squads.addItem(_local_2);
                };
            };
        }


    }
}
