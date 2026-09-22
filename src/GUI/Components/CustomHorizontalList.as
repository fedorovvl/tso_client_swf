package GUI.Components
{
    import mx.controls.HorizontalList;
    import mx.events.ListEvent;
    import flash.display.Sprite;
    import mx.controls.listClasses.IListItemRenderer;

    public class CustomHorizontalList extends HorizontalList 
    {

        public var keyboardFocusEnabled:Boolean = false;


        override protected function updateList():void
        {
            super.updateList();
            dispatchEvent(new ListEvent(ListEvent.CHANGE));
        }

        override protected function drawSelectionIndicator(_arg_1:Sprite, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:uint, _arg_7:IListItemRenderer):void
        {
        }


    }
}
