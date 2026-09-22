package com.bluebyte.tso.bootstrap.steps
{
    import com.bluebyte.tso.bootstrap.BootstrapStep;
    import nLib.cXML;
    import Utils.StringUtils;
    import com.bluebyte.tso.util.ClientLogger;

    public class StepParseXML extends BootstrapStep 
    {

        private var fileName:String;
        private var xml:cXML;
        private var handler:Function;

        public function StepParseXML(_arg_1:String, _arg_2:Function)
        {
            super();
            name = (name + (("(" + _arg_1) + ")"));
            this.fileName = _arg_1;
            this.handler = _arg_2;
        }

        override protected function execute():void
        {
            this.xml = new cXML();
            if (StringUtils.isEmpty(this.fileName))
            {
                throw (new Error("StepParseXML - no filename set!"));
            };
            if (this.handler == null)
            {
                throw (new Error(("StepParseXML - no handler set! filename: " + this.fileName)));
            };
            this.xml.LoadFile(this.fileName, this.loadedHandler, definesMaster.LOAD_ENC);
        }

        private function loadedHandler(xml:cXML):void
        {
            try
            {
                this.handler(xml);
            }
            catch(e:Error)
            {
                ClientLogger.log(("Error during StepParseXML.loadedHandler(cXML): " + fileName));
                ClientLogger.error(e);
            };
            this.handler = null;
            this.xml = null;
            next(this);
        }


    }
}
