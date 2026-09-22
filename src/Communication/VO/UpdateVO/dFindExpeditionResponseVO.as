package Communication.VO.UpdateVO
{
    import Communication.VO.dUniqueID;

    public class dFindExpeditionResponseVO 
    {

        public var foundExpeditions:dLootItemsVO;
        public var specialistUniqueId:dUniqueID;


        public function toString():String
        {
            return (((("<dFindExpeditionResponseVO specialistUniqueId='" + this.specialistUniqueId) + " adventureName='") + this.foundExpeditions.items) + " />");
        }


    }
}
