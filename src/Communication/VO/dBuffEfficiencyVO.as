package Communication.VO
{
    public class dBuffEfficiencyVO 
    {

        public var efficiency:int;
        public var buffName:String;

        public function dBuffEfficiencyVO(_arg_1:String, _arg_2:int)
        {
            super();
            this.buffName = _arg_1;
            this.efficiency = _arg_2;
        }

    }
}
