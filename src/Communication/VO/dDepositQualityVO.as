package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dDepositQualityVO 
    {

        public var depositBonus:int;
        public var diceThrow:int;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.depositBonus = _arg_1.readInt();
            this.diceThrow = _arg_1.readInt();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.depositBonus);
            _arg_1.writeInt(this.diceThrow);
        }

        public function toString():String
        {
            return (((("<dDepositQualityVO depositBonus='" + this.depositBonus) + "' diceThrow='") + this.diceThrow) + "' />");
        }


    }
}
