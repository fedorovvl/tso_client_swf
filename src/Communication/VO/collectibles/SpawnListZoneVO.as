package Communication.VO.collectibles
{
    import __AS3__.vec.Vector;

    public class SpawnListZoneVO 
    {

        private var pickupCount:Vector.<int>;
        private var name:String;

        public function SpawnListZoneVO(_arg_1:String, _arg_2:Vector.<int>)
        {
            super();
            this.name = _arg_1;
            this.pickupCount = _arg_2;
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getPickupCount():Vector.<int>
        {
            return (this.pickupCount);
        }


    }
}
