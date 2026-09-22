package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dBuyOneClickShopItemVO 
    {

        public var buildingGridIdx:int;
        public var itemId:int;
        public var uniqueID:dUniqueID;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.itemId = _arg_1.readInt();
            this.buildingGridIdx = _arg_1.readInt();
        }

        public function InitWithUniqueID(_arg_1:int, _arg_2:dUniqueID):dBuyOneClickShopItemVO
        {
            this.itemId = _arg_1;
            this.uniqueID = _arg_2;
            return (this);
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.itemId);
            _arg_1.writeInt(this.buildingGridIdx);
        }

        public function toString():String
        {
            return (((((("<dBuyOneClickShopItemVO itemId='" + this.itemId) + "' buildingGridIdx='") + this.buildingGridIdx) + "' uniqueID='") + this.uniqueID) + "' />");
        }

        public function Init(_arg_1:int):dBuyOneClickShopItemVO
        {
            this.itemId = _arg_1;
            return (this);
        }

        public function InitWithBuildingGrid(_arg_1:int, _arg_2:int):dBuyOneClickShopItemVO
        {
            this.itemId = _arg_1;
            this.buildingGridIdx = _arg_2;
            return (this);
        }


    }
}
