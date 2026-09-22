package GUI.Components
{
    import mx.controls.TileList;
    import com.bluebyte.bluefire.puremvc.view.IBFList;
    import com.bluebyte.bluefire.api.model.vo.ChannelVO;
    import mx.collections.ArrayCollection;
    import mx.events.CollectionEvent;
    import flash.display.Sprite;
    import mx.controls.listClasses.IListItemRenderer;

    public class ChannelBar extends TileList implements IBFList 
    {


        private function filterFunction(_arg_1:Object):Boolean
        {
            return ((_arg_1 as ChannelVO).visible);
        }

        override public function set dataProvider(_arg_1:Object):void
        {
            if ((this.dataProvider is ArrayCollection))
            {
                (this.dataProvider as ArrayCollection).removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChanged);
            };
            super.dataProvider = _arg_1;
            if (_arg_1)
            {
                (_arg_1 as ArrayCollection).filterFunction = this.filterFunction;
                (_arg_1 as ArrayCollection).addEventListener(CollectionEvent.COLLECTION_CHANGE, this.collectionChanged);
            };
        }

        override protected function drawSelectionIndicator(_arg_1:Sprite, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:uint, _arg_7:IListItemRenderer):void
        {
        }

        private function collectionChanged(_arg_1:CollectionEvent):void
        {
            var _local_2:int = selectedIndex;
            super.dataProvider = dataProvider;
            selectedIndex = _local_2;
            callLater(this.updateList);
        }

        override protected function updateList():void
        {
            super.updateList();
            if ((dataProvider is ArrayCollection))
            {
                columnCount = (dataProvider as ArrayCollection).length;
            };
            invalidateDisplayList();
        }


    }
}
