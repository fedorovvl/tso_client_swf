package converted.bluebyte.tso.contentgenerator.logic
{
    public class CollectionPart 
    {

        private var id:int = 0;
        private var amount:int = 0;
        private var name:String = "";

        public function CollectionPart(_arg_1:int, _arg_2:String, _arg_3:int)
        {
            super();
            this.id = _arg_1;
            this.name = _arg_2;
            this.amount = _arg_3;
        }

        public function GetId():int
        {
            return (this.id);
        }

        public function GetName():String
        {
            return (this.name);
        }

        public function GetAmount():int
        {
            return (this.amount);
        }

        public function AddAmount(_arg_1:int):void
        {
            this.amount = (this.amount + _arg_1);
        }


    }
}
