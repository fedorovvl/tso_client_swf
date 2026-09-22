package GUI.Loca
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class TriggerLoca 
    {

        public var locaParams:Array;
        public var name:String;
        public var exception:Boolean;
        public var locaExtensions:Vector.<LocaExtension> = new Vector.<LocaExtension>();
        public var altKey:Array;
        public var key:Array;

        public function TriggerLoca(_arg_1:String, _arg_2:Array, _arg_3:Array=null, _arg_4:Array=null, _arg_5:Boolean=false)
        {
            super();
            this.name = _arg_1;
            this.locaParams = _arg_2;
            this.key = _arg_3;
            this.altKey = _arg_4;
            this.exception = _arg_5;
        }

    }
}
