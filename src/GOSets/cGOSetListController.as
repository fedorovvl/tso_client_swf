package GOSets
{
    import nLib.gMisc;

    public class cGOSetListController 
    {

        protected var mValue:Number;
        protected var mGOSetList:cGOSetList;


        public function GetValue():Number
        {
            return (this.mValue);
        }

        public function SetGOSetList(_arg_1:cGOSetList):void
        {
            this.mGOSetList = _arg_1;
        }

        protected function CalculateListItem():void
        {
            gMisc.Assert(false, "Not implemented!");
        }

        public function SetValue(_arg_1:Number):void
        {
            this.mValue = _arg_1;
            this.CalculateListItem();
        }


    }
}
