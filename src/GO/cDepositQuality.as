package GO
{
    import Communication.VO.dDepositQualityVO;

    public class cDepositQuality 
    {

        private var depositBonus:int;
        private var diceThrow:int;

        public function cDepositQuality(_arg_1:int, _arg_2:int)
        {
            super();
            this.depositBonus = _arg_1;
            this.diceThrow = _arg_2;
        }

        public function CreateVO():dDepositQualityVO
        {
            var _local_1:dDepositQualityVO = new dDepositQualityVO();
            _local_1.depositBonus = this.depositBonus;
            _local_1.diceThrow = this.diceThrow;
            return (_local_1);
        }

        public function GetDepositBonus():int
        {
            return (this.depositBonus);
        }

        public function GetDiceThrow():int
        {
            return (this.diceThrow);
        }


    }
}
