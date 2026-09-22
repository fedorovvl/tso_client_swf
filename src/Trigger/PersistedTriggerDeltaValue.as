package Trigger
{
    public interface PersistedTriggerDeltaValue extends TriggerDeltaValue 
    {

        function readPersistence():void;
        function persist():void;

    }
}
