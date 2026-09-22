package com.bluebyte.tso.bootstrap
{
    import flash.events.EventDispatcher;
    import flash.utils.getQualifiedClassName;
    import com.bluebyte.tso.util.ClientLogger;

    public class BootstrapStep extends EventDispatcher 
    {

        protected var name:String;
        private var bootstrap:IBootstrap;

        public function BootstrapStep():void
        {
            super();
            this.name = getQualifiedClassName(this);
        }

        public function next(_arg_1:BootstrapStep):void
        {
            ClientLogger.log((("[BOOT] " + this.name) + " [DONE]"));
            ClientLogger.loadingLog((("[BOOT] " + this.name) + " [DONE]"));
            if (this.bootstrap)
            {
                global.getApplication().callLater(this.bootstrap.next, [this]);
            };
            this.bootstrap = null;
        }

        public function getProgressWeight():Number
        {
            return (1);
        }

        internal function setBootstrap(_arg_1:IBootstrap):void
        {
            this.bootstrap = _arg_1;
        }

        protected function execute():void
        {
        }

        internal function _execute():void
        {
            ClientLogger.log(("[BOOT] " + this.name));
            ClientLogger.loadingLog(("[BOOT] " + this.name));
            this.execute();
        }

        protected function getBootstrap():IBootstrap
        {
            return (this.bootstrap);
        }

        public function getProgress():Number
        {
            return (1);
        }


    }
}
