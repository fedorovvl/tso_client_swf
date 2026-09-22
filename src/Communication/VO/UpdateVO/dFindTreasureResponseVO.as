package Communication.VO.UpdateVO
{
    import Communication.VO.dUniqueID;

    public class dFindTreasureResponseVO 
    {

        public var lootItemsVO:dLootItemsVO = new dLootItemsVO();
        public var specialistPlayerID:int;
        public var specialistUniqueId:dUniqueID;


        public function toString():String
        {
            var _local_1:* = "";
            _local_1 = (_local_1 + (((("<dFindTreasureResponseVO specialistPlayerID='" + this.specialistPlayerID) + "' specialistUniqueId='") + this.specialistUniqueId) + "' >\n"));
            _local_1 = (_local_1 + this.lootItemsVO);
            return (_local_1 + "</dFindTreasureResponseVO>");
        }


    }
}
