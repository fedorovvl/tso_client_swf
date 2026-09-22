package Trigger
{
    import Utils.Disposable;
    import Communication.VO.TriggerVO;

    public interface Trigger extends Disposable 
    {

        function setTriggerable(_arg_1:Triggerable):void;
        function isRunning():Boolean;
        function check():Boolean;
        function getDefinition():TriggerVO;
        function getCurrentAmount():Number;
        function getTriggerable():Triggerable;
        function isReversible():Boolean;

    }
}
