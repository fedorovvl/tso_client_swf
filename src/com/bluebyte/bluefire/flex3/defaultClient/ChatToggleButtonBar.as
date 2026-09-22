package com.bluebyte.bluefire.flex3.defaultClient
{
    import mx.controls.List;
    import com.bluebyte.bluefire.puremvc.view.IBFList;

    public class ChatToggleButtonBar extends List implements IBFList 
    {


        override public function set dataProvider(_arg_1:Object):void
        {
            if (super.dataProvider == _arg_1)
            {
                return;
            };
            super.dataProvider = _arg_1;
            if (_arg_1 == null)
            {
                return;
            };
            if (this.dataProvider.length > 0)
            {
                this.selectedIndex = 0;
            }
            else
            {
                this.selectedIndex = -1;
            };
        }


    }
}
