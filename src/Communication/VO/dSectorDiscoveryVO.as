package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import Enums.SECTOR_DISCOVERY_TYPE;

    public class dSectorDiscoveryVO 
    {

        public var sectorID:int;
        public var discoveryType:int;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.sectorID = _arg_1.readInt();
            this.discoveryType = _arg_1.readInt();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.sectorID);
            _arg_1.writeInt(this.discoveryType);
        }

        public function toString():String
        {
            return (((("<SectorDiscoveryVO sectorID='" + this.sectorID) + "' discoveryType='") + SECTOR_DISCOVERY_TYPE.toString(this.discoveryType)) + "' />");
        }


    }
}
