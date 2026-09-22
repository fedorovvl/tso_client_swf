package Communication.VO
{
    import Interface.IStreet;

    public class dStreetVO implements IStreet 
    {

        public var bits:int = 0;
        public var variation:int = 0;
        public var grid:int;
        public var skin:int = 0;


        public function getSkin():int
        {
            return (this.skin);
        }

        public function getVariation():int
        {
            return (this.variation);
        }

        public function setGrid(_arg_1:int):void
        {
            this.grid = _arg_1;
        }

        public function getBits():int
        {
            return (this.bits);
        }

        public function setSkin(_arg_1:int):void
        {
            this.skin = _arg_1;
        }

        public function setBits(_arg_1:int):void
        {
            this.bits = _arg_1;
        }

        public function setVariation(_arg_1:int):void
        {
            this.variation = _arg_1;
        }

        public function toString():String
        {
            return (((((((("<dDepositVO streetBits='" + this.bits) + "' skin='") + this.skin) + " streetVariation='") + this.variation) + "' grid='") + this.grid) + "' />");
        }

        public function getGrid():int
        {
            return (this.grid);
        }


    }
}
