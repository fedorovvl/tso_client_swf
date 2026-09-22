package Communication.VO.grid
{
    public class GridOffsetVO 
    {

        public var columnOffset:int;
        public var rowOffset:int;

        public function GridOffsetVO(_arg_1:int, _arg_2:int)
        {
            super();
            this.rowOffset = _arg_1;
            this.columnOffset = _arg_2;
        }

    }
}
