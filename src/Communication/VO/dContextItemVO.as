package Communication.VO
{
    public class dContextItemVO 
    {

        public var enabled:Boolean;
        public var callback:Function;
        public var tooltip_string:String;
        public var out:Function;
        public var key_string:String;
        public var labelParams:Array;
        public var over:Function;
        public var locaGroup:String;

        public function dContextItemVO(_arg_1:String, _arg_2:Function, _arg_3:Boolean=true, _arg_4:String="", _arg_5:Array=null, _arg_6:Function=null, _arg_7:Function=null, _arg_8:String="LAB")
        {
            super();
            this.key_string = _arg_1;
            this.enabled = _arg_3;
            this.callback = _arg_2;
            this.tooltip_string = _arg_4;
            this.labelParams = _arg_5;
            this.over = _arg_6;
            this.out = _arg_7;
            this.locaGroup = _arg_8;
        }

    }
}
