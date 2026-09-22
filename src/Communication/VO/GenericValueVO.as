package Communication.VO
{
    import nLib.cXML;

    public class GenericValueVO 
    {

        public var value:int;
        public var id:int;
        public var name:String;


        public static function CreateFromXML(_arg_1:cXML):GenericValueVO
        {
            var _local_2:GenericValueVO = new (GenericValueVO)();
            _local_2.id = _arg_1.GetAttributeInt("id");
            _local_2.name = _arg_1.GetAttributeString_string("name");
            _local_2.value = _arg_1.GetAttributeInt("default");
            return (_local_2);
        }


        public function clone():GenericValueVO
        {
            var _local_1:GenericValueVO = new GenericValueVO();
            _local_1.id = this.id;
            _local_1.name = this.name;
            _local_1.value = this.value;
            return (_local_1);
        }


    }
}
