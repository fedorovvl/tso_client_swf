package Communication.VO.UpdateVO
{
    public class dCasualty 
    {

        public var mAmount:int;
        public var mCasualtyID:int;
        public var mBuildingID:int;
        public var mCombatZoneID:int;


        public function init(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String):dCasualty
        {
            this.mAmount = _arg_1;
            this.mCasualtyID = _arg_2;
            this.mCombatZoneID = _arg_3;
            this.mBuildingID = _arg_4;
            return (this);
        }

        public function toString():String
        {
            return (((((((("<dCasualty amount=" + this.mAmount) + ", casualtyID=") + this.mCasualtyID) + ", mCombatZoneID") + this.mCombatZoneID) + ", mBuildingID") + this.mBuildingID) + " >");
        }


    }
}
