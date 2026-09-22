package GO
{
    import Communication.VO.dLandingFieldVO;

    public class cLandingField 
    {

        protected var mGrid:int;
        public var mId:int;


        public function CreateVO():dLandingFieldVO
        {
            var _local_1:dLandingFieldVO = new dLandingFieldVO();
            _local_1.grid = this.mGrid;
            _local_1.id = this.mId;
            return (_local_1);
        }

        public function GetGrid():int
        {
            return (this.mGrid);
        }

        public function toString():String
        {
            return (("<LandingField mGrid='" + this.mGrid) + "' />");
        }

        public function SetGrid(_arg_1:int):void
        {
            this.mGrid = _arg_1;
        }


    }
}
