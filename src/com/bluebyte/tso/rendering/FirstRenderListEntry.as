package com.bluebyte.tso.rendering
{
    import nLib.cClippingRectangle;
    import Model.Notifier;

    public class FirstRenderListEntry extends RenderListEntry 
    {

        public function FirstRenderListEntry(_arg_1:RenderList)
        {
            super();
            this.renderList = _arg_1;
            renderSort = Number.MIN_VALUE;
        }

        override public function init(_arg_1:Object=null):void
        {
        }

        override public function visible(_arg_1:cClippingRectangle):Boolean
        {
            return (false);
        }

        override public function render(_arg_1:uint):void
        {
        }

        override public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
        }

        override internal function renderableVisible():Boolean
        {
            return (false);
        }

        override public function toString():String
        {
            return ("root");
        }

        override public function reset():void
        {
        }


    }
}
