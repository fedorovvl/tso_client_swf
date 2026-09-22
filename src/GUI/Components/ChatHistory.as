package GUI.Components
{
    import mx.containers.VBox;
    import mx.core.IFactory;
    import mx.collections.ICollectionView;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import mx.core.ScrollPolicy;
    import mx.events.ScrollEvent;
    import flash.events.TimerEvent;
    import mx.controls.scrollClasses.ScrollThumb;
    import mx.collections.IViewCursor;
    import mx.core.IDataRenderer;
    import flash.events.Event;
    import mx.collections.ArrayCollection;
    import mx.events.CollectionEvent;
    import mx.collections.IList;

    public class ChatHistory extends VBox 
    {

        private var _itemRenderer:IFactory;
        private var _verticalScrollBarShrink:int = 0;
        private var _autoscroll:Boolean;
        private var collection:ICollectionView = null;
        private var handledItems:Dictionary;
        private var _maxEntries:int = 2147483647;
        private var scrollDownDelayTimer:Timer = new Timer(50, 2);

        public function ChatHistory()
        {
            super();
            this.handledItems = new Dictionary(true);
            minHeight = 0;
            minWidth = 0;
            direction = "vertical";
            horizontalScrollPolicy = ScrollPolicy.OFF;
            verticalScrollPolicy = ScrollPolicy.ON;
            addEventListener(ScrollEvent.SCROLL, this.autoScrollCheckHandler, false, 0, true);
            this.scrollDownDelayTimer.addEventListener(TimerEvent.TIMER, this.handleScrollDownDelayTimer);
        }

        override public function validateDisplayList():void
        {
            super.validateDisplayList();
            if (verticalScrollBar)
            {
                verticalScrollBar.setActualSize(verticalScrollBar.width, (verticalScrollBar.height - this._verticalScrollBarShrink));
                this.updateThumb();
            };
        }

        public function get maxEntries():int
        {
            return (this._maxEntries);
        }

        private function clear():void
        {
            this.handledItems = new Dictionary(true);
            removeAllChildren();
        }

        private function updateThumb():void
        {
            var _local_2:ScrollThumb;
            if (!verticalScrollBar)
            {
                return;
            };
            var _local_1:int;
            while (_local_1 < verticalScrollBar.numChildren)
            {
                _local_2 = (verticalScrollBar.getChildAt(_local_1) as ScrollThumb);
                if (_local_2)
                {
                    _local_2.minHeight = (_local_2.maxHeight = (_local_2.height = 50));
                    return;
                };
                _local_1++;
            };
        }

        public function set maxEntries(_arg_1:int):void
        {
            if (this._maxEntries != _arg_1)
            {
                this._maxEntries = _arg_1;
                this.updateItemRenderers();
            };
        }

        public function get verticalScrollBarShrink():int
        {
            return (this._verticalScrollBarShrink);
        }

        private function updateItemRenderers(_arg_1:Event=null):void
        {
            var _local_5:Number;
            var _local_6:int;
            var _local_7:IViewCursor;
            var _local_8:IDataRenderer;
            if (((!(this.collection)) || (!(this.itemRenderer))))
            {
                return;
            };
            var _local_2:int = Math.min(0, (this.collection.length - this.maxEntries));
            var _local_3:int = int(getStyle("verticalGap"));
            var _local_4:int = Math.min(this.collection.length, this.maxEntries);
            while (numChildren > _local_4)
            {
                _local_5 = removeChildAt(0).height;
                if (!this.autoscroll)
                {
                    verticalScrollPosition = (verticalScrollPosition - (_local_5 + _local_3));
                };
            };
            if (((this.itemRenderer) && (this.collection.length > 0)))
            {
                _local_6 = -1;
                _local_7 = this.collection.createCursor();
                while (_local_7.current != null)
                {
                    if (++_local_6 >= _local_2)
                    {
                        if (!(_local_7.current in this.handledItems))
                        {
                            _local_8 = (addChild(this.itemRenderer.newInstance()) as IDataRenderer);
                            _local_8.data = _local_7.current;
                            this.handledItems[_local_7.current] = 1;
                        };
                    };
                    _local_7.moveNext();
                };
            };
            invalidateDisplayList();
        }

        protected function autoScrollCheckHandler(_arg_1:Event):void
        {
            if (verticalScrollPosition < maxVerticalScrollPosition)
            {
                this._autoscroll = false;
            }
            else
            {
                this._autoscroll = true;
                invalidateDisplayList();
            };
            dispatchEvent(new Event("autoscrollChanged"));
        }

        public function set itemRenderer(_arg_1:IFactory):void
        {
            this._itemRenderer = _arg_1;
            this.clear();
            this.updateItemRenderers();
        }

        public function set verticalScrollBarShrink(_arg_1:int):void
        {
            this._verticalScrollBarShrink = _arg_1;
        }

        public function set dataProvider(value:Object):void
        {
            var col:ArrayCollection;
            var col2:ArrayCollection;
            var item:Object;
            var old:ICollectionView = this.collection;
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
            if (old != this.collection)
            {
                this.clear();
            };
            if (this.collection)
            {
                this.collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.updateItemRenderers);
            };
            this.updateItemRenderers();
            this.scrollDownDelayTimer.start();
            this.autoscroll = true;
        }

        override protected function updateDisplayList(_arg_1:Number, _arg_2:Number):void
        {
            super.updateDisplayList(_arg_1, _arg_2);
            if (((this._autoscroll) && (verticalScrollBar)))
            {
                verticalScrollPosition = (maxVerticalScrollPosition * 2);
            };
        }

        public function set autoscroll(_arg_1:Boolean):void
        {
            if (this._autoscroll != _arg_1)
            {
                this._autoscroll = _arg_1;
                invalidateDisplayList();
                dispatchEvent(new Event("autoscrollChanged"));
            };
        }

        private function handleScrollDownDelayTimer(_arg_1:TimerEvent):void
        {
            invalidateDisplayList();
        }

        public function get dataProvider():Object
        {
            return (this.collection);
        }

        [Bindable(event="autoscrollChanged")]
        public function get autoscroll():Boolean
        {
            return (this._autoscroll);
        }

        public function get itemRenderer():IFactory
        {
            return (this._itemRenderer);
        }


    }
}
