package GUI.Components.ItemRenderer
{
    import mx.containers.Box;
    import mx.core.IFactory;
    import mx.collections.ICollectionView;
    import mx.collections.IViewCursor;
    import mx.core.IDataRenderer;
    import flash.events.Event;
    import mx.collections.ArrayCollection;
    import mx.events.CollectionEvent;
    import mx.collections.IList;

    public class RendererPoolBox extends Box 
    {

        private var _itemRenderer:IFactory;
        private var _pool:Array;
        private var collection:ICollectionView = null;

        public function RendererPoolBox()
        {
            super();
            this._pool = new Array();
        }

        private function updateItemRenderers(_arg_1:Event=null):void
        {
            var _local_3:int;
            var _local_4:IViewCursor;
            var _local_2:int = ((this.collection) ? this.collection.length : 0);
            while (((this.itemRenderer) && (_local_2 > numChildren)))
            {
                if (this._pool.length > 0)
                {
                    addChild(this._pool.pop());
                }
                else
                {
                    addChild(this.itemRenderer.newInstance());
                };
            };
            while (_local_2 < numChildren)
            {
                this._pool.push(getChildAt(0));
                removeChildAt(0);
            };
            if (((this.itemRenderer) && (_local_2 > 0)))
            {
                _local_3 = 0;
                _local_4 = this.collection.createCursor();
                while (_local_4.current != null)
                {
                    (getChildAt(_local_3) as IDataRenderer).data = _local_4.current;
                    _local_3++;
                    _local_4.moveNext();
                };
            };
        }

        public function get dataProvider():Object
        {
            return (this.collection);
        }

        public function set itemRenderer(_arg_1:IFactory):void
        {
            this._itemRenderer = _arg_1;
            if (_arg_1)
            {
                this.updateItemRenderers();
            };
        }

        public function get itemRenderer():IFactory
        {
            return (this._itemRenderer);
        }

        public function set dataProvider(value:Object):void
        {
            var col:ArrayCollection;
            var col2:ArrayCollection;
            var item:Object;
            if (this.collection)
            {
                this.collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.updateItemRenderers);
            };
            if (!value)
            {
                this.collection = null;
            }
            else
            {
                if ((value is ICollectionView))
                {
                    this.collection = (value as ICollectionView);
                }
                else
                {
                    if ((value is Array))
                    {
                        this.collection = new ArrayCollection((value as Array));
                    }
                    else
                    {
                        if ((value is IList))
                        {
                            col = new ArrayCollection();
                            col.addAll((value as IList));
                            this.collection = col;
                        }
                        else
                        {
                            try
                            {
                                col2 = new ArrayCollection();
                                for each (item in value)
                                {
                                    col2.addItem(item);
                                };
                                this.collection = col2;
                            }
                            catch(e:Error)
                            {
                                collection = new ArrayCollection([value]);
                            };
                        };
                    };
                };
            };
            if (this.collection)
            {
                this.collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.updateItemRenderers);
            };
            this.updateItemRenderers();
        }


    }
}
