package com.bluebyte.tso.rendering
{
    import __AS3__.vec.Vector;
    import Enums.RENDER_LAYER;
    import Model.Channels;
    import nLib.cClippingRectangle;
    import __AS3__.vec.*;

    public class RenderListManager 
    {

        private var nextStatic:RenderListEntry = null;
        private var nextMoving:RenderListEntry = null;
        private var renderLayers:Vector.<Vector.<RenderList>> = new Vector.<Vector.<RenderList>>();
        private var lastStaticRendered:RenderListEntry = null;

        public function RenderListManager(_arg_1:Channels)
        {
            super();
            this.addLayer(new RenderList(_arg_1, RENDER_LAYER.STATIC), new RenderList(_arg_1, RENDER_LAYER.MOVING));
            this.addLayer(new RenderList(_arg_1, RENDER_LAYER.LABELS));
        }

        public function dispose():void
        {
            var _local_1:Vector.<RenderList>;
            var _local_2:RenderList;
            for each (_local_1 in this.renderLayers)
            {
                for each (_local_2 in _local_1)
                {
                    _local_2.dispose();
                };
            };
            this.renderLayers.length = 0;
            this.nextStatic = null;
            this.nextMoving = null;
            this.lastStaticRendered = null;
        }

        private function renderStatic(_arg_1:cClippingRectangle, _arg_2:RenderList, _arg_3:Boolean):void
        {
            if (_arg_3)
            {
                if (this.nextStatic.renderableVisible())
                {
                    this.nextStatic.render(_arg_2.layer);
                };
                this.nextStatic = this.nextStatic.renderNext;
            }
            else
            {
                if (this.nextStatic.visible(_arg_1))
                {
                    this.nextStatic.render(_arg_2.layer);
                    if (this.lastStaticRendered != null)
                    {
                        this.lastStaticRendered.renderNext = this.nextStatic;
                    }
                    else
                    {
                        if (_arg_2.renderFirst == null)
                        {
                            _arg_2.renderFirst = this.nextStatic;
                        };
                    };
                    this.lastStaticRendered = this.nextStatic;
                };
                this.nextStatic = this.nextStatic.next;
            };
        }

        public function print(_arg_1:Boolean):String
        {
            var _local_3:Vector.<RenderList>;
            var _local_4:RenderList;
            var _local_2:* = "";
            for each (_local_3 in this.renderLayers)
            {
                for each (_local_4 in _local_3)
                {
                    _local_2 = (_local_2 + _local_4.print(_arg_1));
                    _local_2 = (_local_2 + "\n\n-------------------------------------------\n");
                };
                _local_2 = (_local_2 + "\n#############################################\n#############################################\n\n");
            };
            return (_local_2);
        }

        private function getLowest(_arg_1:Vector.<RenderList>):RenderList
        {
            var _local_3:RenderList;
            var _local_2:RenderList;
            for each (_local_3 in _arg_1)
            {
                if (((!(_local_2)) || ((_local_3.first.next) && (_local_2.first.next.renderSort < _local_3.first.next.renderSort))))
                {
                    _local_2 = _local_3;
                };
            };
            return (_local_2);
        }

        private function addLayer(... _args):void
        {
            var _local_3:RenderList;
            var _local_2:Vector.<RenderList> = new Vector.<RenderList>();
            for each (_local_3 in _args)
            {
                _local_2.push(_local_3);
            };
            this.renderLayers.push(_local_2);
        }

        public function render(_arg_1:cClippingRectangle):void
        {
            var _local_2:Vector.<RenderList>;
            for each (_local_2 in this.renderLayers)
            {
                if (_local_2.length == 1)
                {
                    _local_2[0].render(_arg_1);
                }
                else
                {
                    this.parallelRender(_arg_1, _local_2[0], (!(_local_2[0].renderFirst == null)), _local_2[1]);
                };
            };
        }

        private function parallelRender(_arg_1:cClippingRectangle, _arg_2:RenderList, _arg_3:Boolean, _arg_4:RenderList):void
        {
            this.nextStatic = ((_arg_3) ? _arg_2.renderFirst : _arg_2.first);
            if (!_arg_3)
            {
                this.lastStaticRendered = null;
            };
            this.nextMoving = _arg_4.first;
            while (((!(this.nextMoving == null)) || (!(this.nextStatic == null))))
            {
                if (this.nextStatic == null)
                {
                    if (this.nextMoving.visible(_arg_1))
                    {
                        this.nextMoving.render(_arg_4.layer);
                    };
                    this.nextMoving = this.nextMoving.next;
                }
                else
                {
                    if (this.nextMoving == null)
                    {
                        this.renderStatic(_arg_1, _arg_2, _arg_3);
                    }
                    else
                    {
                        if (this.nextMoving.renderSort < this.nextStatic.renderSort)
                        {
                            if (this.nextMoving.visible(_arg_1))
                            {
                                this.nextMoving.render(_arg_4.layer);
                            };
                            this.nextMoving = this.nextMoving.next;
                        }
                        else
                        {
                            this.renderStatic(_arg_1, _arg_2, _arg_3);
                        };
                    };
                };
            };
        }


    }
}
