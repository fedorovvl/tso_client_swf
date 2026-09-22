package GUI.helpers
{
    import Utils.Disposable;

    public class ObjectPool implements Disposable 
    {

        public static const DEFAULT_INSTANCES:int = 5;

        private var cls:Class;
        private var availableInstances:Array;
        private var allocatedInstances:Array;

        public function ObjectPool(_arg_1:Class, _arg_2:int)
        {
            super();
            this.cls = _arg_1;
            this.availableInstances = [];
            this.allocatedInstances = [];
            this.createInstances(_arg_2);
        }

        public function dispose():void
        {
            var _local_1:Object;
            if (this.allocatedInstances)
            {
                while (this.allocatedInstances.length > 0)
                {
                    this.releaseObject(this.allocatedInstances[0]);
                };
                this.allocatedInstances = null;
            };
            if (this.availableInstances)
            {
                for each (_local_1 in this.availableInstances)
                {
                    if ((_local_1 is Disposable))
                    {
                        (_local_1 as Disposable).dispose();
                    };
                    _local_1 = null;
                };
                this.availableInstances = null;
            };
            this.cls = null;
        }

        private function createInstances(_arg_1:int):void
        {
            var _local_3:Object;
            var _local_2:int;
            while (_local_2 < _arg_1)
            {
                _local_3 = new this.cls();
                this.availableInstances.push(_local_3);
                _local_2++;
            };
        }

        public function releaseObject(_arg_1:Object):void
        {
            var _local_2:int = this.allocatedInstances.indexOf(_arg_1);
            if (_local_2 >= 0)
            {
                this.allocatedInstances.splice(_local_2, 1);
                this.availableInstances.push(_arg_1);
            };
        }

        private function checkAvailableInstance():void
        {
            if (this.availableInstances.length == 0)
            {
                this.createInstances(1);
            };
        }

        public function getObject():Object
        {
            this.checkAvailableInstance();
            var _local_1:Object = this.availableInstances.pop();
            this.allocatedInstances.push(_local_1);
            return (_local_1);
        }


    }
}
