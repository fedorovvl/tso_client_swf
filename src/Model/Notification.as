package Model
{
    public class Notification 
    {

        public var newValue:Object;
        public var property:String;

        public function Notification(_arg_1:String, _arg_2:Object)
        {
            super();
            this.property = _arg_1;
            this.newValue = _arg_2;
        }

    }
}
