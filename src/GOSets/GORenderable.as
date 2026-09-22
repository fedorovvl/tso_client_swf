package GOSets
{
    public interface GORenderable 
    {

        function Animate(_arg_1:Number):Boolean;
        function RenderFrameTransform(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:int):void;
        function Render(_arg_1:int, _arg_2:int):void;
        function RenderFrame(_arg_1:int, _arg_2:int, _arg_3:int):void;

    }
}
