package ItemRegistry
{
    public class IRItem 
    {

        public var itemName_string:String;
        public var resourceName_string:String;
        public var amount:int;
        public var requiresEvent_string:String;
        public var itemType:int;

        public function IRItem(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:String)
        {
            super();
            this.itemType = _arg_1;
            this.itemName_string = _arg_2;
            this.resourceName_string = _arg_3;
            this.amount = _arg_4;
            this.requiresEvent_string = _arg_5;
        }

    }
}
