package GUI.Components.data
{
    public class dPvPLevelUnlockData 
    {

        public var enabled:Boolean;
        public var level:int;
        public var effectType:String;
        public var value:int;
        public var nextLevel:int;
        public var effectName:String;

        public function dPvPLevelUnlockData(_arg_1:String=null, _arg_2:String=null, _arg_3:int=0, _arg_4:int=0, _arg_5:int=0, _arg_6:Boolean=false)
        {
            super();
            this.effectName = _arg_1;
            this.effectType = _arg_2;
            this.level = _arg_3;
            this.nextLevel = _arg_4;
            this.value = _arg_5;
            this.enabled = _arg_6;
        }

    }
}
