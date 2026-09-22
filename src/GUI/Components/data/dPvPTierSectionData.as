package GUI.Components.data
{
    public class dPvPTierSectionData 
    {

        public var enabled:Boolean;
        public var section:int;
        public var endLevel:int;
        public var currentLevel:int;
        public var roundedEnd:int;
        public var startLevel:int;
        public var label:String;

        public function dPvPTierSectionData(_arg_1:int, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:String)
        {
            super();
            this.roundedEnd = _arg_1;
            this.enabled = _arg_2;
            this.section = _arg_3;
            this.startLevel = _arg_4;
            this.endLevel = _arg_5;
            this.currentLevel = _arg_6;
            this.label = _arg_7;
        }

    }
}
