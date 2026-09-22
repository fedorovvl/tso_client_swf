package com.bluebyte.bluefire.flex3.defaultClient
{
    import mx.controls.List;
    import flash.utils.Timer;
    import flash.text.StyleSheet;
    import mx.collections.ArrayCollection;
    import flash.text.TextFormat;
    import mx.controls.VScrollBar;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import mx.events.PropertyChangeEvent;
    import mx.events.CollectionEvent;
    import mx.core.mx_internal; 

    use namespace mx_internal;

    public class ChatHistoryList extends List 
    {

        private static var MSG_MAX:int = 9999999;
        private static const SCROLL_PER_MOUSE_ROLL:int = 1;
        public static var CSSFile:Class;

        private var noautoscrollPosition:int = 0;
        private var scrollBarTwinkleTimer:Timer = new Timer(1000);
        private var scrolledToEnd:Boolean = false;
        private var _autoscroll:Boolean = true;
        private var ss:StyleSheet;
        private var oldScrolledToEnd:int = 0;
        private var provider:ArrayCollection;
        private var format:TextFormat;
        private var vScrollBarTwinkled:Boolean = false;
        private var vScrollBar:VScrollBar;

        public function ChatHistoryList()
        {
            super();
            ChatMessageItemRenderer.STYLESHEET = new StyleSheet();
            ChatMessageItemRenderer.STYLESHEET.parseCSS(new CSSFile().toString());
            this.addEventListener(MouseEvent.MOUSE_WHEEL, this.HandleMouseWheel);
            this.scrollBarTwinkleTimer.addEventListener(TimerEvent.TIMER, this.scrollBarTwinkle);
        }

        private function set _517768508autoscroll(_arg_1:Boolean):void
        {
            if (_arg_1 != this.autoscroll)
            {
                this._autoscroll = _arg_1;
                if (this._autoscroll)
                {
                    this.validateNow();
                    if (this.provider.length > 1)
                    {
                        this.setVerticalScrollPosition((this.provider.length - 1));
                    };
                };
            };
        }

        private function swapScrollBarTwinkle():void
        {
            if (this.vScrollBarTwinkled)
            {
                this.vScrollBarTwinkled = false;
            }
            else
            {
                this.vScrollBarTwinkled = true;
            };
        }

        private function disableScrollBarTwinkle():void
        {
        }

        private function HandleCollectionChanged(_arg_1:Event=null):void
        {
            if (this._autoscroll)
            {
                if (!this.provider)
                {
                    return;
                };
                while (this.provider.length > MSG_MAX)
                {
                    this.provider.removeItemAt(0);
                };
                if (this.provider.length > 1)
                {
                    this.setVerticalScrollPosition((this.provider.length - 1));
                };
            };
        }

        [Bindable(event="propertyChange")]
        public function set autoscroll(_arg_1:Boolean):void
        {
            var _local_2:Object = this.autoscroll;
            if (_local_2 !== _arg_1)
            {
                this._517768508autoscroll = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "autoscroll", _local_2, _arg_1));
            };
        }

        private function scrollBarTwinkle(_arg_1:Event):void
        {
            this.swapScrollBarTwinkle();
        }

        private function handleCreationComplete(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < this.numChildren)
            {
                if ((this.getChildAt(_local_2) is VScrollBar))
                {
                    this.vScrollBar = VScrollBar(this.getChildAt(_local_2));
                    return;
                };
                _local_2++;
            };
        }

        private function HandleMouseWheel(_arg_1:MouseEvent):void
        {
            if (_arg_1.delta > 0)
            {
                this.ScrollList(-(SCROLL_PER_MOUSE_ROLL));
            }
            else
            {
                this.ScrollList(SCROLL_PER_MOUSE_ROLL);
            };
        }

        public function ScrollList(_arg_1:int):void
        {
            var _local_2:int = (verticalScrollPosition + _arg_1);
            this.autoscroll = (_local_2 >= maxVerticalScrollPosition);
            if (!this._autoscroll)
            {
                if (_local_2 <= 0)
                {
                    _local_2 = 0;
                };
                this.setVerticalScrollPosition(_local_2);
            };
        }

        public function setVerticalScrollPosition(_arg_1:int):void
        {
            if (this.verticalScrollPosition != _arg_1)
            {
                this.verticalScrollPosition = _arg_1;
            };
        }

        public function get autoscroll():Boolean
        {
            return (this._autoscroll);
        }

        override public function set dataProvider(_arg_1:Object):void
        {
            if (_arg_1 != this.dataProvider)
            {
                super.dataProvider = _arg_1;
                this.provider = ArrayCollection(_arg_1);
                this.provider.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.HandleCollectionChanged);
                this._autoscroll = false;
                this.autoscroll = true;
            };
        }


    }
}
