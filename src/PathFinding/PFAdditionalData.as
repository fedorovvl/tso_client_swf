package PathFinding
{
    import Map.GridPosition;

    public class PFAdditionalData 
    {

        public var right:int;
        public var left:GridPosition = null;

        public function PFAdditionalData(_arg_1:GridPosition, _arg_2:int)
        {
            super();
            this.left = _arg_1;
            this.right = _arg_2;
        }

    }
}
