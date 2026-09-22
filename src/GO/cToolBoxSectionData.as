package GO
{
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;

    public class cToolBoxSectionData 
    {

        private var _toolTip:String;
        private var _group:int;
        private var _icon:Class;
        private var _id:String;

        public function cToolBoxSectionData(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:String)
        {
            super();
            this._id = _arg_1;
            this._icon = gAssetManager.GetClass(_arg_2);
            this._group = _arg_3;
            this._toolTip = _arg_4;
        }

        public function get toolTip():String
        {
            return (cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, this._toolTip));
        }

        public function set icon(_arg_1:Class):void
        {
            this._icon = _arg_1;
        }

        public function get icon():Class
        {
            return (this._icon);
        }

        public function get id():String
        {
            return (this._id);
        }

        public function get group():int
        {
            return (this._group);
        }


    }
}
