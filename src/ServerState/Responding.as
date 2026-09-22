package ServerState
{
    import Communication.VO.dServerActionResult;

    public interface Responding 
    {

        function onFault(_arg_1:int, _arg_2:dServerActionResult):void;
        function onResult(_arg_1:int, _arg_2:dServerActionResult):void;

    }
}
