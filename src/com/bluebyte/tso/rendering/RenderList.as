package com.bluebyte.tso.rendering
{
    import Model.Observer;
    import flash.utils.Dictionary;
    import Model.Notifiers.RenderChannel;
    import Model.Notifiers.InputNotifier;
    import Model.Channels;
    import com.bluebyte.tso.util.InstancePool;
    import nLib.cClippingRectangle;
    import Model.Notifiers.RenderChannelClearNotification;
    import converted.bluebyte.tso.rendering.IRenderListRenderable;
    import Model.Notifier;

    public class RenderList implements Observer 
    {

        internal var first:FirstRenderListEntry = null;
        internal var layer:uint;
        private var obj2entry:Dictionary = new Dictionary(true);
        internal var renderFirst:RenderListEntry = null;
        private var channels:Channels;

        public function RenderList(_arg_1:Channels, _arg_2:uint)
        {
            super();
            this.channels = _arg_1;
            this.layer = _arg_2;
            this.first = new FirstRenderListEntry(this);
            _arg_1.RENDER.addPropertyObserver(RenderChannel.ADDED, this);
            _arg_1.RENDER.addPropertyObserver(RenderChannel.REMOVED, this);
            _arg_1.RENDER.addPropertyObserver(RenderChannel.CLEAR, this);
            _arg_1.INPUT.addPropertyObserver(InputNotifier.CAMERA_CHANGED_string, this);
        }

        public function dispose():void
        {
            if (this.channels != null)
            {
                this.channels.RENDER.removePropertyObserver(RenderChannel.ADDED, this);
                this.channels.RENDER.removePropertyObserver(RenderChannel.REMOVED, this);
                this.channels.RENDER.removePropertyObserver(RenderChannel.CLEAR, this);
                this.channels.INPUT.removePropertyObserver(InputNotifier.CAMERA_CHANGED_string, this);
                this.channels = null;
            };
            this.clear();
            this.first.renderNext = null;
        }

        public function add(_arg_1:RenderListEntry):void
        {
            var _local_2:RenderListEntry = this.first;
            while (_local_2)
            {
                if (_local_2 == _arg_1)
                {
                    this.sort(_arg_1);
                    break;
                };
                if (_arg_1.renderSort < _local_2.renderSort)
                {
                    this.link(_local_2.previous, _arg_1);
                    this.link(_arg_1, _local_2);
                    break;
                };
                if (_local_2.next == null)
                {
                    this.link(_local_2, _arg_1);
                    _arg_1.next = null;
                    break;
                };
                _local_2 = _local_2.next;
            };
            this.renderFirst = null;
        }

        public function remove(_arg_1:RenderListEntry):void
        {
            this.link(_arg_1.previous, _arg_1.next);
            _arg_1.previous = null;
            _arg_1.next = null;
            _arg_1.renderNext = null;
            this.renderFirst = null;
        }

        private function clear():void
        {
            var _local_2:RenderListEntry;
            var _local_1:RenderListEntry = this.first.next;
            while (_local_1 != null)
            {
                _local_2 = _local_1.next;
                InstancePool.freeInstance(RenderListEntry, _local_1);
                _local_1 = _local_2;
            };
            this.obj2entry = new Dictionary(true);
            this.first.next = null;
            this.renderFirst = null;
        }

        private function link(_arg_1:RenderListEntry, _arg_2:RenderListEntry):void
        {
            if (_arg_1)
            {
                _arg_1.next = _arg_2;
            };
            if (_arg_2)
            {
                _arg_2.previous = _arg_1;
            };
        }

        public function render(_arg_1:cClippingRectangle):void
        {
            var _local_3:RenderListEntry;
            var _local_2:RenderListEntry;
            if (this.renderFirst != null)
            {
                _local_2 = this.renderFirst;
                while (_local_2 != null)
                {
                    if (_local_2.renderableVisible())
                    {
                        _local_2.render(this.layer);
                    };
                    _local_2 = _local_2.renderNext;
                };
            }
            else
            {
                this.renderFirst = this.first;
                _local_3 = this.renderFirst;
                _local_2 = this.first.next;
                while (_local_2 != null)
                {
                    if (_local_2.visible(_arg_1))
                    {
                        _local_2.render(this.layer);
                        _local_3.renderNext = _local_2;
                        _local_3 = _local_2;
                        _local_2.renderNext = null;
                    };
                    _local_2 = _local_2.next;
                };
            };
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:RenderListEntry;
            var _local_5:RenderChannelClearNotification;
            var _local_6:Array;
            var _local_7:Object;
            var _local_8:IRenderListRenderable;
            if (_arg_2 == InputNotifier.CAMERA_CHANGED_string)
            {
                this.renderFirst = null;
            }
            else
            {
                if (_arg_2 == RenderChannel.CLEAR)
                {
                    _local_5 = (_arg_3 as RenderChannelClearNotification);
                    if (_local_5.layer == this.layer)
                    {
                        if (_local_5.renderableClass == null)
                        {
                            this.clear();
                        }
                        else
                        {
                            _local_6 = new Array();
                            for (_local_7 in this.obj2entry)
                            {
                                if (!(_local_7 is _local_5.renderableClass))
                                {
                                    _local_6.push(_local_7);
                                };
                            };
                            this.clear();
                            for each (_local_8 in _local_6)
                            {
                                _local_4 = (InstancePool.newInstance(RenderListEntry, {
                                    "renderable":_local_8,
                                    "renderList":this
                                }) as RenderListEntry);
                                this.obj2entry[_local_8] = _local_4;
                                this.add(_local_4);
                            };
                        };
                    };
                }
                else
                {
                    if ((_arg_3 as IRenderListRenderable).checkRenderLayer(this.layer))
                    {
                        _local_4 = (this.obj2entry[_arg_3] as RenderListEntry);
                        if (_arg_2 == RenderChannel.ADDED)
                        {
                            if (_local_4)
                            {
                                this.sort(_local_4);
                            }
                            else
                            {
                                _local_4 = (InstancePool.newInstance(RenderListEntry, {
                                    "renderable":_arg_3,
                                    "renderList":this
                                }) as RenderListEntry);
                                this.obj2entry[_arg_3] = _local_4;
                                this.add(_local_4);
                            };
                        }
                        else
                        {
                            if (((_local_4) && (_arg_2 == RenderChannel.REMOVED)))
                            {
                                this.remove(_local_4);
                                delete this.obj2entry[_arg_3];
                                InstancePool.freeInstance(RenderListEntry, _local_4);
                            };
                        };
                    };
                };
            };
        }

        public function print(_arg_1:Boolean):String
        {
            var _local_2:* = (("RenderList(" + this.layer) + ")\n");
            var _local_3:RenderListEntry = ((_arg_1) ? this.renderFirst : this.first);
            while (_local_3 != null)
            {
                if ((((!(_arg_1)) && (!(_local_3.previous == null))) && (_local_3.renderSort < _local_3.previous.renderSort)))
                {
                    _local_2 = (_local_2 + ".");
                };
                _local_2 = (_local_2 + (_local_3.toString() + "\n"));
                _local_3 = ((_arg_1) ? _local_3.renderNext : _local_3.next);
            };
            return (_local_2);
        }

        internal function sort(_arg_1:RenderListEntry):void
        {
            var _local_2:RenderListEntry;
            if (((_arg_1.next) && (_arg_1.renderSort > _arg_1.next.renderSort)))
            {
                _local_2 = _arg_1.next;
                this.remove(_arg_1);
                while (((_local_2.next) && (_arg_1.renderSort > _local_2.next.renderSort)))
                {
                    _local_2 = _local_2.next;
                };
                this.link(_arg_1, _local_2.next);
                this.link(_local_2, _arg_1);
            }
            else
            {
                if (((_arg_1.previous) && (_arg_1.renderSort < _arg_1.previous.renderSort)))
                {
                    _local_2 = _arg_1.previous;
                    this.remove(_arg_1);
                    while (((_local_2.previous) && (_arg_1.renderSort < _local_2.previous.renderSort)))
                    {
                        _local_2 = _local_2.previous;
                    };
                    this.link(_local_2.previous, _arg_1);
                    this.link(_arg_1, _local_2);
                };
            };
        }


    }
}
