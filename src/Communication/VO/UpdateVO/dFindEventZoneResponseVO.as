package Communication.VO.UpdateVO
{
    import Communication.VO.dUniqueID;

    public class dFindEventZoneResponseVO 
    {

        public var foundAdventures:dLootItemsVO;
        public var specialistUniqueId:dUniqueID;


        public function toString():String
        {
            return (((("<dFindEventZoneResponseVO specialistUniqueId='" + this.specialistUniqueId) + " adventureName='") + this.foundAdventures.items) + " />");
        }


    }
}
