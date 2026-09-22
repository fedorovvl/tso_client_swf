package converted.bluebyte.tso.rendering
{
    public interface IRenderListRenderable 
    {

        function getRenderSortGrid():int;
        function checkRenderLayer(_arg_1:int):Boolean;
        function render(_arg_1:uint):void;
        function isVisibleForRender():Boolean;
        function getRenderSortSubGrid():int;
        function getRenderX():int;
        function getRenderY():int;

    }
}
