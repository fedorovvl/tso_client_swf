package Map
{
    import converted.bluebyte.tso.rendering.IRenderListRenderable;
    import GOSets.cGOSetList;
    import Interface.cGameInterface;
    import nLib.cPosInt;
    import Enums.RENDER_ORDER;
    import Enums.RENDER_LAYER;

    public class cGoSetListAnimationItem implements IRenderListRenderable 
    {

        public var animGoSetListContainer:cGOSetList = null;
        public var mGI:cGameInterface;
        public var runningTime:Number;
        public var gridPos:int;
        public var pixelPos:cPosInt = new cPosInt();
        public var object:Object;


        public function getRenderSortSubGrid():int
        {
            return (RENDER_ORDER.ORDER_4);
        }

        public function getRenderX():int
        {
            return (this.pixelPos.x);
        }

        public function getRenderY():int
        {
            return (this.pixelPos.y);
        }

        public function render(_arg_1:uint):void
        {
            this.animGoSetListContainer.Animate(global.ui.mCalculateTicks.mDeltaTicksOne);
            this.animGoSetListContainer.Render(this.pixelPos.x, this.pixelPos.y);
        }

        public function getRenderSortGrid():int
        {
            return ((GridPosition.getY(this.gridPos, this.mGI.mCurrentPlayerZone.mMapWidth) * 1000) + (this.gridPos % this.mGI.mCurrentPlayerZone.mMapWidth));
        }

        public function checkRenderLayer(_arg_1:int):Boolean
        {
            return (_arg_1 == RENDER_LAYER.MOVING);
        }

        public function isVisibleForRender():Boolean
        {
            return (true);
        }


    }
}
