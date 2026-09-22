package Communication.VO.UpdateVO
{
    public class dHardCurrencyPurchased 
    {

        public var mAmount:int;
        public var mTransactionId:String;
        public var mResetUser:Boolean;
        public var mPurchaseComment:String;
        public var mHardCurrencyPurchasedID:int;


        public function init(_arg_1:int, _arg_2:int, _arg_3:Boolean, _arg_4:String, _arg_5:String):dHardCurrencyPurchased
        {
            this.mAmount = _arg_1;
            this.mHardCurrencyPurchasedID = _arg_2;
            this.mResetUser = _arg_3;
            this.mPurchaseComment = _arg_4;
            this.mTransactionId = _arg_5;
            return (this);
        }

        public function toString():String
        {
            return (((("<dHardCurrencyPurchased amount=" + this.mAmount) + ", hardCurrencyPurchasedID=") + this.mHardCurrencyPurchasedID) + " >");
        }


    }
}
