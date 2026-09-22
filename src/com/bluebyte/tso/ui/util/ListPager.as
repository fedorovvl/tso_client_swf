package com.bluebyte.tso.ui.util
{
    import flash.events.EventDispatcher;
    import mx.collections.IList;
    import mx.collections.ArrayList;
    import flash.events.Event;
    import mx.events.CollectionEvent;

    [Bindable(event="collectionChange")]
    public class ListPager extends EventDispatcher 
    {

        public static const PAGE_CHANGED:String = "pageChanged";

        private var _view:IList;
        private var _itemsPerPage:int = 10;
        private var autoUpdate:Boolean = true;
        private var viewInvalidated:Boolean = true;
        private var _page:int = 0;
        private var _source:IList;

        public function ListPager(_arg_1:IList=null)
        {
            super();
            this._view = new ArrayList();
            this.source = _arg_1;
        }

        public function next():void
        {
            this.page++;
        }

        public function get page():int
        {
            return (this._page);
        }

        private function setPage(_arg_1:int):void
        {
            this._page = Math.max(0, Math.min((this.numPages - 1), _arg_1));
            dispatchEvent(new Event(PAGE_CHANGED));
        }

        private function sourceChanged(_arg_1:CollectionEvent):void
        {
            if (this.autoUpdate)
            {
                this.refresh();
            };
        }

        public function get currentFirstIndex():int
        {
            return (this._page * this._itemsPerPage);
        }

        public function get numPages():int
        {
            return (Math.ceil((this._source.length / this._itemsPerPage)));
        }

        public function set itemsPerPage(_arg_1:int):void
        {
            var _local_2:int = Math.max(1, _arg_1);
            var _local_3:* = (!(this._itemsPerPage == _local_2));
            this._itemsPerPage = _local_2;
            if (_local_3)
            {
                this.refresh();
            };
        }

        public function disableAutoUpdate():void
        {
            this.autoUpdate = false;
        }

        public function get source():IList
        {
            return (this._source);
        }

        public function get currentLastIndex():int
        {
            return (Math.max(-1, Math.min((this._source.length - 1), (((this._page + 1) * this._itemsPerPage) - 1))));
        }

        public function get view():IList
        {
            if (this.viewInvalidated)
            {
                this.validateView();
            };
            return (this._view);
        }

        public function refresh():void
        {
            this.viewInvalidated = true;
            dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
        }

        public function get itemsPerPage():int
        {
            return (this._itemsPerPage);
        }

        public function set page(_arg_1:int):void
        {
            this.setPage(_arg_1);
            this.refresh();
        }

        public function get currentPageLength():int
        {
            if (!this._source)
            {
                return (0);
            };
            return ((this.currentLastIndex - this.currentFirstIndex) + 1);
        }

        public function set source(_arg_1:IList):void
        {
            if (this._source)
            {
                this._source.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.sourceChanged);
            };
            this._source = _arg_1;
            this._view.removeAll();
            if (this._source)
            {
                this._source.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.sourceChanged);
                this.setPage(this._page);
            };
            this.refresh();
        }

        public function previous():void
        {
            this.page--;
        }

        public function enableAutoUpdate():void
        {
            this.autoUpdate = true;
        }

        private function validateView():void
        {
            this.viewInvalidated = false;
            var _local_1:Array = [];
            var _local_2:int = this.currentFirstIndex;
            while (((_local_2 <= this.currentLastIndex) && (_local_2 > -1)))
            {
                _local_1.push(this._source.getItemAt(_local_2));
                _local_2++;
            };
            (this._view as ArrayList).source = _local_1;
        }


    }
}
