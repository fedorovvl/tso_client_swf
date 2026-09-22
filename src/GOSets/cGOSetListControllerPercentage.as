package GOSets
{
    public class cGOSetListControllerPercentage extends cGOSetListController 
    {

        private var mMaximumAmount:Number;

        public function cGOSetListControllerPercentage(_arg_1:Number)
        {
            super();
            this.mMaximumAmount = _arg_1;
        }

        override protected function CalculateListItem():void
        {
            var _local_3:cGOSetListItem;
            var _local_1:Number = ((mValue / this.mMaximumAmount) * 100);
            var _local_2:cGOSetListItem;
            for each (_local_3 in mGOSetList.mGOSetListItem_vector)
            {
                if (_local_2 == null)
                {
                    _local_2 = _local_3;
                };
                if (_local_3.mValue > _local_1)
                {
                    mGOSetList.SetCurrentRenderedItem(_local_2);
                    return;
                };
                _local_2 = _local_3;
            };
            mGOSetList.SetCurrentRenderedItem(_local_2);
        }


    }
}
