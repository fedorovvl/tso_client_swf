package Communication.VO
{
    public class dPvpLevelDataVO 
    {

        public var icon:String;
        public var pvpXp:int;

        public function dPvpLevelDataVO(_arg_1:int, _arg_2:String)
        {
            super();
            this.pvpXp = _arg_1;
            this.icon = _arg_2;
        }

    }
}
