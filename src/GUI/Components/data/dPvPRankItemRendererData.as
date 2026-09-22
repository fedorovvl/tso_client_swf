package GUI.Components.data
{
    public class dPvPRankItemRendererData 
    {

        public var state:String;
        public var toolTip:String;
        public var iconName:String;
        public var rank:int;

        public function dPvPRankItemRendererData(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:String)
        {
            super();
            this.rank = _arg_1;
            this.iconName = _arg_2;
            this.toolTip = _arg_3;
            this.state = _arg_4;
        }

    }
}
