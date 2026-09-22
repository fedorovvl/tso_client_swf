package com.bluebyte.tso.rendering
{
    import com.bluebyte.tso.util.IPoolable;
    import Model.Observer;
    import converted.bluebyte.tso.rendering.IRenderListRenderable;
    import Model.INotifier;
    import Model.Notifier;
    import flash.utils.getQualifiedClassName;
    import nLib.cClippingRectangle;

    public class RenderListEntry implements IPoolable, Observer 
    {

        private var grid:int = 0;
        internal var renderList:RenderList = null;
        internal var renderSort:Number = 0;
        internal var renderNext:RenderListEntry = null;
        private var renderable:IRenderListRenderable;
        internal var next:RenderListEntry = null;
        internal var previous:RenderListEntry = null;


        private function updateSort():void
        {
            var _local_1:uint;
            var _local_2:Number;
            if (this.renderable)
            {
                this.grid = this.renderable.getRenderSortGrid();
                _local_1 = this.renderable.getRenderSortSubGrid();
                _local_2 = ((this.grid * 100000) + _local_1);
                if (_local_2 != this.renderSort)
                {
                    this.renderSort = _local_2;
                    this.renderList.sort(this);
                };
            };
        }

        public function reset():void
        {
            if (this.renderable)
            {
                if ((this.renderable is INotifier))
                {
                    (this.renderable as INotifier).removePropertyObserver("renderPosition", this);
                };
                this.renderable = null;
            };
            this.next = null;
            this.previous = null;
            this.renderNext = null;
            this.renderList = null;
            this.renderSort = 0;
            this.grid = 0;
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            this.updateSort();
        }

        public function render(_arg_1:uint):void
        {
            this.renderable.render(_arg_1);
        }

        public function init(_arg_1:Object=null):void
        {
            this.renderList = (_arg_1["renderList"] as RenderList);
            this.renderable = (_arg_1["renderable"] as IRenderListRenderable);
            if (this.renderable)
            {
                if ((this.renderable is INotifier))
                {
                    (this.renderable as INotifier).addPropertyObserver("renderPosition", this);
                };
                this.updateSort();
            };
        }

        internal function renderableVisible():Boolean
        {
            return ((this.renderable) && (this.renderable.isVisibleForRender()));
        }

        public function toString():String
        {
            return ((this.renderSort.toString() + " ") + getQualifiedClassName(this.renderable));
        }

        public function visible(_arg_1:cClippingRectangle):Boolean
        {
            if (((this.renderable) && (this.renderable.isVisibleForRender())))
            {
                return (_arg_1.contains(this.renderable.getRenderX(), this.renderable.getRenderY()));
            };
            return (false);
        }


    }
}
