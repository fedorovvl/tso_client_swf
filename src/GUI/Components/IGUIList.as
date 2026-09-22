package GUI.Components
{
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;

    public interface IGUIList 
    {

        function getAllItems(_arg_1:String):Vector.<DisplayObject>;
        function getFirstItem(_arg_1:String):DisplayObject;

    }
}
