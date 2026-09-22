package Utils
{
    public class Pair 
    {

        private var left:Object = null;
        private var right:Object = null;

        public function Pair(_arg_1:Object, _arg_2:Object)
        {
            super();
            this.left = _arg_1;
            this.right = _arg_2;
        }

        public function getRight():Object
        {
            return (this.right);
        }

        public function setLeft(_arg_1:Object):void
        {
            this.left = _arg_1;
        }

        public function setRight(_arg_1:Object):void
        {
            this.right = _arg_1;
        }

        public function setPair(_arg_1:Object, _arg_2:Object):void
        {
            this.left = _arg_1;
            this.right = _arg_2;
        }

        public function getLeft():Object
        {
            return (this.left);
        }


    }
}
