package Communication.VO.UpdateVO
{
    import Communication.VO.dDepositVO;
    import Communication.VO.dUniqueID;
    import mx.collections.ArrayCollection;
    import Enums.EXPLORED_DEPOSIT_RESULT;

    public class dFoundDepositVO 
    {

        public var depositSearchedFor:String;
        public var exploredDepositResult:int;
        public var depositVO:dDepositVO;
        public var specialistID:dUniqueID;
        public var extraDeposits_vector:ArrayCollection = new ArrayCollection();


        public function toString():String
        {
            return (((((("<dFoundDepositVO specialistID=" + this.specialistID) + ", depositVO=") + this.depositVO) + ", exploredDepositResult=") + EXPLORED_DEPOSIT_RESULT.toString(this.exploredDepositResult)) + " >");
        }


    }
}
