package Trigger
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class TimedTriggerManager 
    {

        private var timedTriggers_vector:Vector.<TimedTrigger> = new Vector.<TimedTrigger>();


        public function check():void
        {
            var _local_2:int;
            var _local_1:int = this.timedTriggers_vector.length;
            _local_2 = 0;
            while (_local_2 < _local_1)
            {
                this.timedTriggers_vector[_local_2].check();
                _local_2++;
            };
        }

        public function unregisterTrigger(_arg_1:TimedTrigger):void
        {
            var _local_2:int = this.timedTriggers_vector.indexOf(_arg_1);
            if (_local_2 >= 0)
            {
                this.timedTriggers_vector.splice(_local_2, 1);
            };
        }

        public function registerTrigger(_arg_1:TimedTrigger):void
        {
            if (_arg_1 != null)
            {
                this.timedTriggers_vector.push(_arg_1);
            };
        }


    }
}
