package GUI.Loca
{
    public class LocaExtension 
    {

        public static const LOCA_EXTENSION_TYPE_MISSING:String = "missing";
        public static const LOCA_EXTENSION_TYPE_EXISTING:String = "existing";

        public var locaExt:Array;
        public var params:Array;
        public var type:String;
        public var locaParams:Array;

        public function LocaExtension(_arg_1:String, _arg_2:Array, _arg_3:Array, _arg_4:Array=null)
        {
            super();
            this.type = _arg_1;
            this.params = _arg_2;
            this.locaExt = _arg_3;
            this.locaParams = _arg_4;
        }

    }
}
