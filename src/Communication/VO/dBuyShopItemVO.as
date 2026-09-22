package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dBuyShopItemVO 
    {

        public var shopItemContent_vector:ArrayCollection = new ArrayCollection();
        public var transactionFrom:int;
        public var giftedPlayerID:int;
        public var itemID:int;


        public function toString():String
        {
            var _local_1:* = (((((("<dBuyShopItemVO giftedPlayerID='" + this.giftedPlayerID) + "' itemID='") + this.itemID) + "' transactionFrom='") + this.transactionFrom) + "' >");
            gCalculations.createListString("ShopItemContent", this.shopItemContent_vector);
            return (_local_1 + "</dBuyShopItemVO>");
        }


    }
}
