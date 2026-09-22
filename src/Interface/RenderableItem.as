package Interface
{
    public interface RenderableItem 
    {

        function getResourceGFXName():String;
        function getRenderTooltipType():String;
        function getRenderAmount():int;
        function getBuffName():String;
        function getRenderGFXIcon():Object;
        function getRenderTooltip():String;
        function getRenderFrameType():String;
        function getRenderGFXBackgroundName():String;
        function isRequiresResourceIcon():Boolean;

    }
}
