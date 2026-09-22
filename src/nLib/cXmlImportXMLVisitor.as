package nLib
{
    import flash.utils.Dictionary;
    import flash.xml.XMLNode;

    public class cXmlImportXMLVisitor implements cXmlVisitor 
    {

        private var parentLoadedXMLs:Dictionary;
        private var waiting:int = 0;
        private var finishHandler:Function;
        private var executedHandler:Boolean = false;

        public function cXmlImportXMLVisitor(_arg_1:Function, _arg_2:Dictionary)
        {
            super();
            this.finishHandler = _arg_1;
            this.parentLoadedXMLs = _arg_2;
        }

        public function fileLoaded(_arg_1:XMLNode, _arg_2:XMLNode, _arg_3:Boolean):void
        {
            var _local_5:XMLNode;
            var _local_4:XMLNode = _arg_1.parentNode;
            if (_arg_3)
            {
                for each (_local_5 in _arg_2.childNodes)
                {
                    _local_4.insertBefore(_local_5.cloneNode(true), _arg_1);
                };
            }
            else
            {
                _local_4.insertBefore(_arg_2, _arg_1);
            };
            _arg_1.removeNode();
            this.waiting--;
            this.done();
        }

        public function done():void
        {
            if (((!(this.executedHandler)) && (this.waiting == 0)))
            {
                this.executedHandler = true;
                this.finishHandler();
            };
        }

        public function visitChild(item:XMLNode):void
        {
            var onlyChildren:Boolean;
            this.waiting++;
            onlyChildren = (item.attributes["onlyChildren"] == "true");
            var filename:String = item.attributes["filename"];
            var xml:cXML = new cXML(this.parentLoadedXMLs);
            xml.LoadFile(filename, function (_arg_1:cXML):void
            {
                fileLoaded(item, _arg_1.getXML(), onlyChildren);
            }, definesMaster.LOAD_ENC);
        }


    }
}
