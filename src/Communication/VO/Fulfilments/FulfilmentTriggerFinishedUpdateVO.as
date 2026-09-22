package Communication.VO.Fulfilments
{
    public class FulfilmentTriggerFinishedUpdateVO 
    {

        public var triggerId:int;
        public var identityId:int;


        public function init(_arg_1:int, _arg_2:int):FulfilmentTriggerFinishedUpdateVO
        {
            this.identityId = _arg_1;
            this.triggerId = _arg_2;
            return (this);
        }


    }
}
