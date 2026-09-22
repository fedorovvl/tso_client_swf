package Model.Notifiers
{
    public final class TaskManagerChannel extends Channel 
    {

        public static const UPDATED:String = "updated";
        public static const TASK_FINISHED:String = "taskFinished";


        public function updated():void
        {
            send(UPDATED, null);
        }

        public function taskFinished(_arg_1:int):void
        {
            send(TASK_FINISHED, _arg_1);
        }


    }
}
