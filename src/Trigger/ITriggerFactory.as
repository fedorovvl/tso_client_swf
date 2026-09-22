package Trigger
{
    import Communication.VO.TriggerVO;

    public interface ITriggerFactory 
    {

        function createTrigger(_arg_1:TriggerVO, _arg_2:Triggerable):Trigger;

    }
}
