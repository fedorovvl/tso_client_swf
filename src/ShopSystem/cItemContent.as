package ShopSystem
{
    import Enums.ITEM_CONTENT_TYPE;
    import nLib.cXML;

    public class cItemContent 
    {

        protected var name_string:String;
        protected var count:int;
        protected var recurringChance:int;
        protected var resourceName_string:String;
        protected var type:int;

        public function cItemContent(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:int)
        {
            super();
            this.type = _arg_1;
            this.name_string = _arg_2;
            this.resourceName_string = _arg_3;
            this.count = _arg_4;
            this.recurringChance = _arg_5;
        }

        public static function CreateItemContentFromXml(_arg_1:cXML):cItemContent
        {
            var _local_2:int = ITEM_CONTENT_TYPE.parse(_arg_1.GetAttributeString_string("type"));
            var _local_3:String = _arg_1.GetAttributeString_string("name");
            var _local_4:String = _arg_1.GetAttributeString_string("resource");
            var _local_5:int = _arg_1.GetAttributeInt("count");
            var _local_6:int = _arg_1.GetAttributeInt("recurringChance");
            var _local_7:cItemContent = new cItemContent(_local_2, _local_3, _local_4, _local_5, _local_6);
            return (_local_7);
        }


        public function GetResourceName_string():String
        {
            return (this.resourceName_string);
        }

        public function SetName_string(_arg_1:String):void
        {
            this.name_string = _arg_1;
        }

        public function SetRecurringChance(_arg_1:int):void
        {
            this.recurringChance = _arg_1;
        }

        public function toString():String
        {
            return (((((((("<cItemContent type='" + ITEM_CONTENT_TYPE.toString(this.type)) + "' resourceName_string='") + this.resourceName_string) + "' name='") + this.name_string) + "' count='") + this.count) + "' />");
        }

        public function SetCount(_arg_1:int):void
        {
            this.count = _arg_1;
        }

        public function GetType():int
        {
            return (this.type);
        }

        public function SetResourceName_string(_arg_1:String):void
        {
            this.resourceName_string = _arg_1;
        }

        public function GetName_string():String
        {
            return (this.name_string);
        }

        public function GetCount():int
        {
            return (this.count);
        }

        public function GetRecurringChance():int
        {
            return (this.recurringChance);
        }

        public function SetType(_arg_1:int):void
        {
            this.type = _arg_1;
        }


    }
}
