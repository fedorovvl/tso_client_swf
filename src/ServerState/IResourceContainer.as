package ServerState
{
    public interface IResourceContainer 
    {

        function HasPlayerResource(_arg_1:String, _arg_2:int):Boolean;
        function GetPlayerResource(_arg_1:String):dResource;

    }
}
