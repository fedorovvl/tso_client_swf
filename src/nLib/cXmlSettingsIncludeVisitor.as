package nLib
{
    import flash.xml.XMLNode;

    public class cXmlSettingsIncludeVisitor implements cXmlVisitor 
    {

        private var setting:String = "";

        public function cXmlSettingsIncludeVisitor(_arg_1:String)
        {
            super();
            this.setting = _arg_1;
        }

        public function visitChild(_arg_1:XMLNode):void
        {
            var _local_2:XMLNode;
            var _local_3:XMLNode;
            if (_arg_1.attributes["value"] == this.setting)
            {
                _local_2 = _arg_1.parentNode;
                for each (_local_3 in _arg_1.childNodes)
                {
                    _local_2.appendChild(_local_3);
                };
            };
            _arg_1.removeNode();
        }

        public function done():void
        {
        }


    }
}
