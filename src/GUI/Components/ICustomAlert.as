package GUI.Components
{
    public interface ICustomAlert 
    {

        function get isCloseable():Boolean;
        function confirmAction():void;
        function cancelAction():void;

    }
}
