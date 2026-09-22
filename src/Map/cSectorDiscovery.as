package Map
{
    import Enums.SECTOR_DISCOVERY_TYPE;

    public class cSectorDiscovery 
    {

        public var mDirtyIndicator:int;
        private var mDiscoveryType:int = 0;
        private var mSectorID:int;

        public function cSectorDiscovery(_arg_1:int, _arg_2:int)
        {
            super();
            this.mSectorID = _arg_1;
            this.mDiscoveryType = _arg_2;
        }

        public function GetSectorID():int
        {
            return (this.mSectorID);
        }

        public function SetDiscoveryType(_arg_1:int):void
        {
            this.mDiscoveryType = _arg_1;
        }

        public function toString():String
        {
            return (((("<SectorDiscovery sectorId='" + this.mSectorID) + "' discoveryType='") + SECTOR_DISCOVERY_TYPE.toString(this.mDiscoveryType)) + "' />");
        }

        public function GetDiscoveryType():int
        {
            return (this.mDiscoveryType);
        }


    }
}
