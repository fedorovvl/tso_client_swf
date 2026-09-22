package com.bluebyte.tso.bootstrap
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class BootstrapSequentialStep extends BootstrapStep implements IBootstrap 
    {

        protected var steps:Vector.<BootstrapStep>;
        private var numSteps:int = 0;

        public function BootstrapSequentialStep():void
        {
            super();
            this.steps = new Vector.<BootstrapStep>();
        }

        override public function getProgress():Number
        {
            if (this.numSteps == 0)
            {
                return (1);
            };
            return (1 - ((1 / this.numSteps) * this.steps.length));
        }

        override public function next(_arg_1:BootstrapStep):void
        {
            if (this.steps.length > 0)
            {
                getBootstrap().dispatchEvent(new BootstrapEvent(BootstrapEvent.PROGRESS, _arg_1));
                this.steps.shift()._execute();
            }
            else
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
            this.numSteps = this.steps.length;
            this.steps.shift()._execute();
        }

        public function getRemainingSteps(_arg_1:BootstrapStep):Vector.<BootstrapStep>
        {
            return (this.steps.concat());
        }


    }
}
