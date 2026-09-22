package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapParallelStep;
    import __AS3__.vec.Vector;
    import com.bluebyte.tso.util.ClientLogger;

    public class StepParseXMLMulti extends BootstrapParallelStep 
    {

        private var handler:Function;
        private var fileNames:Vector.<String>;

        public function StepParseXMLMulti(_arg_1:Vector.<String>, _arg_2:Function)
        {
            super();
            this.fileNames = _arg_1;
            this.handler = _arg_2;
        }

        override protected function execute():void
        {
            var _local_1:String;
            ClientLogger.log(("StepParseXMLMulti loading XML files: " + this.fileNames.join(", ")));
            for each (_local_1 in this.fileNames)
            {
                this.add(new StepParseXML(_local_1, this.handler));
            };
            super.execute();
        }


    }
}
