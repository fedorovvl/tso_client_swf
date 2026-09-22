package Communication.VO
{
    import Enums.FILTER;
    import nLib.cXML;

    public class dFilterVO 
    {

        public var id:int;
        public var requiresEvent:String;


        public static function fromXML(_arg_1:cXML):dFilterVO
        {
            var _local_2:dFilterVO = new (dFilterVO)();
            _local_2.id = FILTER.toInt(_arg_1.GetAttributeString_string("name"));
            _local_2.requiresEvent = _arg_1.GetAttributeString_string("requiresEvent");
            return (_local_2);
        }


    }
}
