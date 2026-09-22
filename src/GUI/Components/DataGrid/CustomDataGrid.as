package GUI.Components.DataGrid
{
    import mx.controls.DataGrid;
    import mx.collections.Sort;
    import mx.core.mx_internal;
    import mx.events.CollectionEvent;
    import mx.collections.ICollectionView;
    import mx.collections.ListCollectionView;
    import mx.collections.ArrayCollection;
    import mx.events.ScrollEvent;
    import mx.events.ScrollEventDirection;
    import flash.events.MouseEvent;
    import mx.events.CollectionEventKind;
    import GUI.Components.ItemRenderer.TradeGridPlayerItemRenderer;
    import mx.core.UIComponent;

    public class CustomDataGrid extends DataGrid 
    {

        private var _currentSort:Sort;
        public var keepScrollOnUpdate:Boolean = false;

        public function CustomDataGrid()
        {
            super();
            this.mx_internal::headerClass = CustomDataGridHeader;
            addEventListener(CollectionEvent.COLLECTION_CHANGE, this.onDataProviderChanged, false, 0, true);
        }

        private function onDataProviderChanged(_arg_1:CollectionEvent):void
        {
            var _local_2:ICollectionView = ICollectionView(dataProvider);
            _local_2.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.onSortingChanged, false, 0, true);
            if (this._currentSort != null)
            {
                _local_2.sort = this._currentSort;
                _local_2.refresh();
            };
        }

        override public function set dataProvider(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_3:int;
            var _local_4:int;
            if (this.keepScrollOnUpdate)
            {
                _local_2 = selectedItem;
                _local_3 = verticalScrollPosition;
                _local_4 = horizontalScrollPosition;
            };
            super.dataProvider = _arg_1;
            if (this.keepScrollOnUpdate)
            {
                if (_arg_1)
                {
                    this.setSelectedItem(_local_2);
                };
                verticalScrollPosition = _local_3;
                horizontalScrollPosition = _local_4;
            };
        }

        public function setSelectedItem(_arg_1:Object):void
        {
            var _local_2:int = -1;
            if (collection)
            {
                if ((collection is ListCollectionView))
                {
                    _local_2 = (collection as ListCollectionView).getItemIndex(_arg_1);
                }
                else
                {
                    if ((collection is ArrayCollection))
                    {
                        _local_2 = (collection as ArrayCollection).getItemIndex(_arg_1);
                    };
                };
            };
            if (_local_2 > -1)
            {
                selectedIndex = _local_2;
            }
            else
            {
                super.selectedItem = _arg_1;
            };
            if (((selectedIndex > -1) && (this.keepScrollOnUpdate)))
            {
                scrollToIndex(selectedIndex);
            };
        }

        override protected function mouseWheelHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Number;
            var _local_3:int;
            var _local_4:ScrollEvent;
            if (((verticalScrollBar) && (verticalScrollBar.visible)))
            {
                _arg_1.stopPropagation();
                _local_2 = verticalScrollPosition;
                _local_3 = verticalScrollPosition;
                _local_3 = int((_local_3 - ((_arg_1.delta / Math.abs(_arg_1.delta)) * 1)));
                _local_3 = Math.max(0, Math.min(_local_3, verticalScrollBar.maxScrollPosition));
                verticalScrollPosition = _local_3;
                if (_local_2 != verticalScrollPosition)
                {
                    _local_4 = new ScrollEvent(ScrollEvent.SCROLL);
                    _local_4.direction = ScrollEventDirection.VERTICAL;
                    _local_4.position = verticalScrollPosition;
                    _local_4.delta = (verticalScrollPosition - _local_2);
                    dispatchEvent(_local_4);
                };
            };
        }

        private function onSortingChanged(_arg_1:CollectionEvent):void
        {
            if (_arg_1.kind == CollectionEventKind.REFRESH)
            {
                this._currentSort = ICollectionView(_arg_1.currentTarget).sort;
            };
        }

        override protected function mouseClickHandler(_arg_1:MouseEvent):void
        {
            super.mouseClickHandler(_arg_1);
            if ((((_arg_1.target) && (_arg_1.target.parent)) && (_arg_1.target.parent is TradeGridPlayerItemRenderer)))
            {
                _arg_1.stopImmediatePropagation();
            };
        }

        override protected function drawHeaderBackground(_arg_1:UIComponent):void
        {
        }


    }
}
