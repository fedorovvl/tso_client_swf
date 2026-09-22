package Communication.VO
{
    import nLib.cXML;

    public class PropagatingBuffVO 
    {

        public var name_string:String;


        public static function CreateFromXML(_arg_1:cXML):PropagatingBuffVO
        {
            var _local_2:PropagatingBuffVO = new (PropagatingBuffVO)();
            _local_2.name_string = _arg_1.GetAttributeString_string("name");
            return (_local_2);
        }


        public function toString():String
        {
            return (("<PropagatingBuffVO " + this.name_string) + "/>");
        }

        public function clone():PropagatingBuffVO
        {
            var _local_1:PropagatingBuffVO = new PropagatingBuffVO();
            _local_1.name_string = this.name_string;
            return (_local_1);
        }


    }
}
