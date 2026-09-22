package Communication.VO.Fulfilments
{
    import mx.collections.ArrayCollection;

    public class FulfilmentFinishedUpdateVO 
    {

        public var uniqueIDs:ArrayCollection = new ArrayCollection();
        public var identityId:int;


        public function init(_arg_1:int, _arg_2:ArrayCollection):FulfilmentFinishedUpdateVO
        {
            this.identityId = _arg_1;
            this.uniqueIDs = _arg_2;
            return (this);
        }


    }
}
