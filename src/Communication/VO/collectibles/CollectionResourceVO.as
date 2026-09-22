package Communication.VO.collectibles
{
    import ServerState.dResource;

    public class CollectionResourceVO 
    {

        private var playerAmount:int;
        private var name:String;
        private var amount:int;
        private var storehouseCapacity:int;

        public function CollectionResourceVO(_arg_1:String, _arg_2:int)
        {
            super();
            this.name = _arg_1;
            this.amount = _arg_2;
        }

        public function setStorehouseCapacity(_arg_1:int):void
        {
            this.storehouseCapacity = _arg_1;
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getAsDResource():dResource
        {
            var _local_1:dResource = new dResource();
            _local_1.Init(this.getName(), this.getAmount());
            return (_local_1);
        }

        public function getHasNeededResources():Boolean
        {
            return (this.playerAmount >= this.amount);
        }

        public function getAmount():int
        {
            return (this.amount);
        }

        public function getPlayerAmount():int
        {
            return (this.playerAmount);
        }

        public function setPlayerAmount(_arg_1:int):void
        {
            this.playerAmount = _arg_1;
        }

        public function clone():CollectionResourceVO
        {
            var _local_1:CollectionResourceVO = new CollectionResourceVO(this.name, this.amount);
            _local_1.playerAmount = this.playerAmount;
            return (_local_1);
        }

        public function getStorehouseCapacity():int
        {
            return (this.storehouseCapacity);
        }


    }
}
