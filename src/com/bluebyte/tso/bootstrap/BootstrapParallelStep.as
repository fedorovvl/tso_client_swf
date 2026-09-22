package com.bluebyte.tso.bootstrap
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class BootstrapParallelStep extends BootstrapStep implements IBootstrap 
    {

        protected var steps:Vector.<BootstrapStep>;
        private var numSteps:int;

        public function BootstrapParallelStep():void
        {
            super();
            this.steps = new Vector.<BootstrapStep>();
        }

        override public function getProgress():Number
        {
            if (this.numSteps == 0)
            {
                return (0);
            };
            return (1 - ((1 / this.numSteps) * this.steps.length));
        }

        override public function next(_arg_1:BootstrapStep):void
        {
            var _local_2:int = this.steps.indexOf(_arg_1);
            if (_local_2 > -1)
            {
                getBootstrap().dispatchEvent(new BootstrapEvent(BootstrapEvent.PROGRESS, _arg_1));
                this.steps.splice(_local_2, 1);
            };
            if (this.steps.length == 0)
            {
                super.next(this);
            };
        }

        public function add(_arg_1:BootstrapStep):IBootstrap
        {
            this.steps.push(_arg_1);
            _arg_1.setBootstrap(this);
            return (this);
        }

        public function start():void
        {
        }

        override protected function execute():void
        {
            var _local_1:BootstrapStep;
            this.numSteps = this.steps.length;
            for each (_local_1 in this.steps)
            {
                _local_1._execute();
            };
        }

        public function getRemainingSteps(_arg_1:BootstrapStep):Vector.<BootstrapStep>
        {
            return (this.steps.concat());
        }


    }
}
