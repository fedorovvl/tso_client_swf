package com.bluebyte.tso.chat
{
    import com.bluebyte.bluefire.api.model.vo.OccupantVO;

    public class CustomOccupantVO extends OccupantVO 
    {

        private var _tag:String;

        public function CustomOccupantVO(_arg_1:OccupantVO)
        {
            super();
            this.clickable = _arg_1.clickable;
            this.id = _arg_1.id;
            this.name = _arg_1.name;
        }

        public function get tag():String
        {
            return (this._tag);
        }

        public function set tag(_arg_1:String):void
        {
            this._tag = _arg_1;
        }


    }
}
