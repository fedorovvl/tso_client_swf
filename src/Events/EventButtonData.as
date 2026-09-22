package Events
{
    import nLib.cXML;

    public class EventButtonData 
    {

        public var enabled:Boolean;
        public var tooltip:String;
        public var name:String;
        public var url:String;
        public var item:String;
        public var icon:String;


        public static function CreateFromXML(_arg_1:cXML):EventButtonData
        {
            var _local_2:EventButtonData = new (EventButtonData)();
            _local_2.icon = _arg_1.GetAttributeString_string("icon");
            _local_2.name = _arg_1.GetAttributeString_string("name");
            _local_2.item = _arg_1.GetAttributeString_string("item");
            _local_2.tooltip = _arg_1.GetAttributeString_string("tooltip");
            _local_2.url = _arg_1.GetAttributeString_string("url");
            return (_local_2);
        }


    }
}
