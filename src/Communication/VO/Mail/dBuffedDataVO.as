package Communication.VO.Mail
{
    import Communication.VO.dBuffVO;

    public class dBuffedDataVO 
    {

        public var buffedObjectGridIdx:int;
        public var buffVO:dBuffVO;


        public function toString():String
        {
            return (((("<dBuffedDataVO buffedObjectGridIdx='" + this.buffedObjectGridIdx) + "' buffVO='") + this.buffVO) + "' />");
        }


    }
}
