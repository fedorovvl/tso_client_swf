package GO
{
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import Communication.VO.dDepositGroupVO;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class cDepositGroup 
    {

        private var mDepositType_string:String = "";
        private var mMaxAccessible:int;
        private var mAccessibleFromStart:int;
        private var mGeneralInterface:cGeneralInterface;
        private var mId:int;
        private var mAverageAmount:int;
        private var mDepositGridIdxs_vector:Vector.<int> = new Vector.<int>();

        public function cDepositGroup(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:String)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mId = _arg_2;
            this.mMaxAccessible = _arg_3;
            this.mAccessibleFromStart = _arg_4;
            this.mAverageAmount = _arg_5;
            this.mDepositType_string = _arg_6;
        }

        public function GetDepositType_string():String
        {
            return (this.mDepositType_string);
        }

        public function SetMaxAccessible(_arg_1:int):void
        {
            this.mMaxAccessible = _arg_1;
        }

        public function RemoveDeposit(_arg_1:cDeposit):void
        {
            var _local_2:int = this.mDepositGridIdxs_vector.indexOf(_arg_1.GetGrid());
            if (_local_2 != -1)
            {
                this.mDepositGridIdxs_vector.splice(_local_2, 1);
            };
        }

        public function CreateVO():dDepositGroupVO
        {
            var _local_2:int;
            var _local_1:dDepositGroupVO = new dDepositGroupVO();
            _local_1.mId = this.mId;
            _local_1.mDepositType_string = this.mDepositType_string;
            _local_1.mMaxAccessible = this.mMaxAccessible;
            _local_1.mAccessibleFromStart = this.mAccessibleFromStart;
            _local_1.mAverageAmount = this.mAverageAmount;
            _local_1.mAverageAmount = this.mAverageAmount;
            _local_1.mDepositsVector = new ArrayCollection();
            for each (_local_2 in this.mDepositGridIdxs_vector)
            {
                _local_1.mDepositsVector.addItem(_local_2);
            };
            return (_local_1);
        }

        public function SetAccessibleFromStart(_arg_1:int):void
        {
            this.mAccessibleFromStart = _arg_1;
        }

        public function GetMaxAccessible():int
        {
            return (this.mMaxAccessible);
        }

        public function SetDepositType_string(_arg_1:String):void
        {
            this.mDepositType_string = _arg_1;
        }

        public function GetAccessibleFromStart():int
        {
            return (this.mAccessibleFromStart);
        }

        public function GetId():int
        {
            return (this.mId);
        }

        public function SetAverageAmount(_arg_1:int):void
        {
            this.mAverageAmount = _arg_1;
        }

        public function AddDepositGridIdx(_arg_1:int):void
        {
            this.mDepositGridIdxs_vector.push(_arg_1);
        }

        public function toString():String
        {
            return (("<DepositGroup " + this.mDepositGridIdxs_vector) + " >");
        }

        public function GetDepositGridIdxs_vector():Vector.<int>
        {
            return (this.mDepositGridIdxs_vector);
        }

        public function GetAverageAmount():int
        {
            return (this.mAverageAmount);
        }


    }
}
