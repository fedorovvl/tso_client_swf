package GOSets
{
    public class cGOSetListControllerStatic extends cGOSetListController 
    {


        override protected function CalculateListItem():void
        {
            var _local_1:cGOSetListItem;
            for each (_local_1 in mGOSetList.mGOSetListItem_vector)
            {
                if (_local_1.mValue == mValue)
                {
                    mGOSetList.SetCurrentRenderedItem(_local_1);
                    return;
                };
            };
            mGOSetList.SetCurrentRenderedItem(mGOSetList.mGOSetListItem_vector[0]);
        }


    }
}
