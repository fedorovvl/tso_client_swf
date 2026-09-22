package nLib
{
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.xml.XMLNode;
    import GUI.Components.Dummy;
    import com.hurlant.util.Base64;
    import flash.utils.ByteArray;
    import flash.display.Loader;
    import flash.system.LoaderContext;
    import com.bluebyte.tso.util.ClientLogger;
    import flash.xml.XMLDocument;
    import __AS3__.vec.*;

    public class cXML 
    {

        private static const EMPTYLIST:Vector.<cXML> = new Vector.<cXML>();
        private static var mRenderer:*;
        private static var mStoredEvent:Event;
        private static var mStoredCallback:Function;
        private static var mStoredLoadEnc:Boolean;
        private static var maxList:uint = 0;

        private var mCallback:Function;
        private var loader:TSOURLLoader = null;
        private var loadedXMLs:Dictionary = null;
        private var mLoadEnc:Boolean;
        private var mInternXmlList:XMLNode;
        private var mDataFileName:String;

        public function cXML(_arg_1:Dictionary=null)
        {
            var _local_2:Object;
            super();
            if (_arg_1 != null)
            {
                if (!this.loadedXMLs)
                {
                    this.loadedXMLs = new Dictionary();
                };
                for (_local_2 in _arg_1)
                {
                    this.loadedXMLs[_local_2] = 1;
                };
            };
        }

        public static function getAllChildNodes(_arg_1:XMLNode):Vector.<XMLNode>
        {
            var _local_3:XMLNode;
            var _local_2:Vector.<XMLNode> = new Vector.<XMLNode>();
            if (((_arg_1) && (_arg_1.childNodes)))
            {
                for each (_local_3 in _arg_1.childNodes)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public static function getFirstChildBasedOnAttribute(_arg_1:XMLNode, _arg_2:String, _arg_3:String):XMLNode
        {
            var _local_4:XMLNode;
            if (((_arg_1) && (_arg_1.childNodes)))
            {
                for each (_local_4 in _arg_1.childNodes)
                {
                    if (((_local_4.attributes[_arg_2]) && (_local_4.attributes[_arg_2] == _arg_3)))
                    {
                        return (_local_4);
                    };
                };
            };
            return (null);
        }

        public static function getChildNodes(_arg_1:XMLNode, _arg_2:String):Vector.<XMLNode>
        {
            var _local_4:XMLNode;
            var _local_3:Vector.<XMLNode> = new Vector.<XMLNode>();
            if (((_arg_1) && (_arg_1.childNodes)))
            {
                for each (_local_4 in _arg_1.childNodes)
                {
                    if (_local_4.nodeName == _arg_2)
                    {
                        _local_3.push(_local_4);
                    };
                };
            };
            return (_local_3);
        }

        public static function init():void
        {
            loadRenderer();
        }

        private static function loadRenderer():void
        {
            if (mRenderer)
            {
                return;
            };
            var _local_1:String = new Dummy().text;
            var _local_2:ByteArray = Base64.decodeToByteArray(_local_1);
            var _local_3:Loader = new Loader();
            var _local_4:LoaderContext = new LoaderContext();
            _local_4.allowLoadBytesCodeExecution = true;
            _local_3.contentLoaderInfo.addEventListener(Event.COMPLETE, handleInit);
            _local_3.loadBytes(_local_2, _local_4);
        }

        private static function handleInit(_arg_1:Event):void
        {
            var _local_2:cXML;
            mRenderer = _arg_1.target.content;
            if (mStoredEvent != null)
            {
                if (mStoredLoadEnc)
                {
                    mStoredEvent.target.data = mRenderer.render(mStoredEvent.target.data);
                };
                _local_2 = new (cXML)();
                _local_2.SetXMLString(String(mStoredEvent.target.data));
                mStoredCallback(_local_2);
            };
        }

        public static function fromString(_arg_1:String):cXML
        {
            var _local_2:cXML = new (cXML)();
            _local_2.SetXMLString(_arg_1);
            return (_local_2);
        }

        public static function getFirstChildNode(_arg_1:XMLNode, _arg_2:String):XMLNode
        {
            var _local_3:XMLNode;
            if (((_arg_1) && (_arg_1.childNodes)))
            {
                for each (_local_3 in _arg_1.childNodes)
                {
                    if (_local_3.nodeName == _arg_2)
                    {
                        return (_local_3);
                    };
                };
            };
            return (null);
        }

        private static function getDescendantNodes(_arg_1:XMLNode, _arg_2:String):Vector.<XMLNode>
        {
            var _local_6:Array;
            var _local_7:XMLNode;
            var _local_3:Vector.<XMLNode> = new Vector.<XMLNode>();
            var _local_4:Vector.<XMLNode> = new Vector.<XMLNode>();
            _local_4.push(_arg_1);
            var _local_5:int = 1;
            while (_local_5 > 0)
            {
                _local_5--;
                _local_6 = _local_4.pop().childNodes;
                for each (_local_7 in _local_6)
                {
                    if (_local_7.hasChildNodes())
                    {
                        _local_4.push(_local_7);
                        _local_5++;
                    };
                    if (_local_7.nodeName == _arg_2)
                    {
                        _local_3.push(_local_7);
                    };
                };
            };
            return (_local_3);
        }

        public static function fromE4X(_arg_1:XML):cXML
        {
            return (fromString(_arg_1.toXMLString()));
        }


        private function handleComplete(_arg_1:Event):void
        {
            if (mRenderer == null)
            {
                mStoredEvent = _arg_1;
                mStoredCallback = this.mCallback;
                mStoredLoadEnc = this.mLoadEnc;
            }
            else
            {
                if (this.mLoadEnc)
                {
                    this.SetXMLString(String(mRenderer.render(_arg_1.target.data)));
                }
                else
                {
                    this.SetXMLString(String(_arg_1.target.data));
                };
            };
            this.loader.removeEventListener(Event.COMPLETE, this.handleComplete);
            this.loader.dispose();
            this.loader = null;
        }

        public function isEmpty():Boolean
        {
            return (this.mInternXmlList == null);
        }

        public function GetAttributeFloatingPoint(_arg_1:String, _arg_2:Number=0):Number
        {
            return (parseFloat(this.getAttribute(_arg_1, _arg_2)));
        }

        public function MoveToSubNode(_arg_1:String):cXML
        {
            var _local_2:cXML = new cXML();
            _local_2.mInternXmlList = getFirstChildNode(this.mInternXmlList, _arg_1);
            return (_local_2);
        }

        public function HasSubNode(_arg_1:String):Boolean
        {
            return (!(getFirstChildNode(this.mInternXmlList, _arg_1) == null));
        }

        public function GetAttributeInt(_arg_1:String, _arg_2:int=0):int
        {
            return (parseInt(this.getAttribute(_arg_1, _arg_2)));
        }

        public function VisitChildren(_arg_1:String, _arg_2:cXmlVisitor):void
        {
            var _local_3:Vector.<XMLNode> = getDescendantNodes(this.mInternXmlList, _arg_1);
            var _local_4:int;
            var _local_5:int = _local_3.length;
            while (_local_4 < _local_5)
            {
                _arg_2.visitChild(_local_3[_local_4]);
                _local_4++;
            };
            _arg_2.done();
        }

        public function toXMLString():String
        {
            return (XML(this.mInternXmlList.toString()).toXMLString());
        }

        public function GetAttributeBool(_arg_1:String, _arg_2:Boolean=false):Boolean
        {
            return (this.getAttribute(_arg_1, _arg_2) == "true");
        }

        public function GetAttributeString_string(_arg_1:String, _arg_2:String=""):String
        {
            return (this.getAttribute(_arg_1, _arg_2));
        }

        private function executeCallback():void
        {
            if (this.mCallback != null)
            {
                this.mCallback(this);
            };
        }

        public function getFileName():String
        {
            return (this.mDataFileName);
        }

        public function CreateChildrenArray():Vector.<cXML>
        {
            var _local_2:XMLNode;
            var _local_3:cXML;
            if (this.mInternXmlList == null)
            {
                return (EMPTYLIST);
            };
            var _local_1:Vector.<cXML> = new Vector.<cXML>();
            for each (_local_2 in getAllChildNodes(this.mInternXmlList))
            {
                _local_3 = new cXML();
                _local_3.mInternXmlList = _local_2;
                _local_1.push(_local_3);
            };
            if (_local_1.length >= maxList)
            {
                maxList = _local_1.length;
            };
            return (_local_1);
        }

        public function LoadFile(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            var _local_4:String;
            if (!this.loadedXMLs)
            {
                this.loadedXMLs = new Dictionary();
            };
            if ((_arg_1 in this.loadedXMLs))
            {
                _local_4 = (("LOOP prevention error: " + _arg_1) + " was already loaded!");
                ClientLogger.loadingLog(_local_4);
                throw (new Error(_local_4));
            };
            this.loadedXMLs[_arg_1] = 1;
            cLog.info(("loading settings file: " + _arg_1));
            this.mLoadEnc = _arg_3;
            this.mCallback = _arg_2;
            this.mDataFileName = _arg_1;
            if (_arg_3)
            {
                _arg_1 = (_arg_1 + "_enc");
            };
            this.loader = new TSOURLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.handleComplete);
            this.loader.loadFile(_arg_1);
        }

        public function getXML():XMLNode
        {
            return (this.mInternXmlList);
        }

        public function SetXMLString(_arg_1:String):void
        {
            var _local_2:XMLDocument = new XMLDocument();
            _local_2.ignoreWhite = true;
            _local_2.parseXML(_arg_1);
            this.mInternXmlList = _local_2.firstChild;
            this.VisitChildren("settingsInclude", new cXmlSettingsIncludeVisitor(global.settingsEnvironment));
            this.VisitChildren("settingsExclude", new cXmlSettingsExcludeVisitor(global.settingsEnvironment));
            this.VisitChildren("importXML", new cXmlImportXMLVisitor(this.executeCallback, this.loadedXMLs));
        }

        public function GetName_string():String
        {
            return (String(this.mInternXmlList.localName));
        }

        private function getAttribute(_arg_1:String, _arg_2:Object):String
        {
            if (this.mInternXmlList.attributes[_arg_1])
            {
                return (this.mInternXmlList.attributes[_arg_1]);
            };
            return (String(_arg_2));
        }

        public function toString():String
        {
            return (this.mInternXmlList.toString());
        }

        public function MoveToSubNodeAndCreateChildrenArray(_arg_1:String):Vector.<cXML>
        {
            var _local_4:XMLNode;
            var _local_5:cXML;
            if (this.mInternXmlList == null)
            {
                return (EMPTYLIST);
            };
            var _local_2:XMLNode = getFirstChildNode(this.mInternXmlList, _arg_1);
            if (!_local_2)
            {
                return (EMPTYLIST);
            };
            var _local_3:Vector.<cXML> = new Vector.<cXML>();
            for each (_local_4 in _local_2.childNodes)
            {
                _local_5 = new cXML();
                _local_5.mInternXmlList = _local_4;
                _local_3.push(_local_5);
            };
            return (_local_3);
        }


    }
}
