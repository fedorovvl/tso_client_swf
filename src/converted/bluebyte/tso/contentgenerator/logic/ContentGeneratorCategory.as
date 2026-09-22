package converted.bluebyte.tso.contentgenerator.logic
{
    import __AS3__.vec.Vector;
    import nLib.cXML;
    import Communication.VO.ContentGenerator.ContentGeneratorContentVO;
    import Communication.VO.ContentGenerator.ContentGeneratorCategoryVO;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class ContentGeneratorCategory 
    {

        private var name:String;
        private var requiresEvent:String;
        private var backGround:String;
        private var collections:Vector.<ContentGeneratorContent>;
        public var selected:Boolean;
        private var id:int;
        private var sortIndex:int;
        private var partName:String;

        public function ContentGeneratorCategory(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:String, _arg_5:String, _arg_6:Vector.<ContentGeneratorContent>, _arg_7:String)
        {
            super();
            this.id = _arg_1;
            this.name = _arg_2;
            this.sortIndex = _arg_3;
            this.backGround = _arg_4;
            this.requiresEvent = _arg_5;
            this.collections = _arg_6;
            this.partName = _arg_7;
        }

        public static function parseXML(_arg_1:cXML):ContentGeneratorCategory
        {
            var _local_10:cXML;
            var _local_2:int = _arg_1.GetAttributeInt("id");
            var _local_3:String = _arg_1.GetAttributeString_string("name");
            var _local_4:int = _arg_1.GetAttributeInt("sortIndex");
            var _local_5:String = _arg_1.GetAttributeString_string("background");
            var _local_6:String = _arg_1.GetAttributeString_string("requiresEvent");
            var _local_7:String = _arg_1.GetAttributeString_string("partName");
            var _local_8:Vector.<ContentGeneratorContent> = new Vector.<ContentGeneratorContent>();
            var _local_9:Vector.<cXML> = _arg_1.CreateChildrenArray();
            for each (_local_10 in _local_9)
            {
                _local_8.push(ContentGeneratorContent.parseXML(_local_10));
            };
            return (new ContentGeneratorCategory(_local_2, _local_3, _local_4, _local_5, _local_6, _local_8, _local_7));
        }

        public static function createCategoryFromVO(_arg_1:ContentGeneratorCategoryVO):ContentGeneratorCategory
        {
            var _local_3:ContentGeneratorContentVO;
            var _local_2:Vector.<ContentGeneratorContent> = new Vector.<ContentGeneratorContent>();
            for each (_local_3 in _arg_1.collections)
            {
                _local_2.push(ContentGeneratorContent.createContentFromVO(_local_3));
            };
            return (new ContentGeneratorCategory(_arg_1.id, _arg_1.name, _arg_1.sortIndex, _arg_1.backGround, _arg_1.requiresEvent, _local_2, _arg_1.partName));
        }


        public function getName():String
        {
            return (this.name);
        }

        public function getBackGround():String
        {
            return (this.backGround);
        }

        public function CloneWithoutCollections():ContentGeneratorCategory
        {
            return (new ContentGeneratorCategory(this.id, this.name, this.sortIndex, this.backGround, this.requiresEvent, null, this.partName));
        }

        public function getId():int
        {
            return (this.id);
        }

        public function setCollections(_arg_1:Vector.<ContentGeneratorContent>):void
        {
            this.collections = _arg_1;
        }

        public function getPartName():String
        {
            return (this.partName);
        }

        public function getRequiresEvent():String
        {
            return (this.requiresEvent);
        }

        public function getSortIndex():int
        {
            return (this.sortIndex);
        }

        public function getCollections():Vector.<ContentGeneratorContent>
        {
            return (this.collections);
        }

        public function GetIsEnabled():Boolean
        {
            var _local_1:ContentGeneratorContent;
            for each (_local_1 in this.getCollections())
            {
                if (_local_1.GetIsEnabled())
                {
                    return (true);
                };
            };
            return (false);
        }

        public function toString():String
        {
            return (this.name);
        }

        public function getVOFromCategory():ContentGeneratorCategoryVO
        {
            var _local_2:ContentGeneratorContent;
            var _local_3:ContentGeneratorCategoryVO;
            var _local_1:ArrayCollection = new ArrayCollection();
            for each (_local_2 in this.collections)
            {
                _local_1.addItem(_local_2.getVOFromContent());
            };
            _local_3 = new ContentGeneratorCategoryVO();
            _local_3.Init(this.id, this.name, this.sortIndex, this.backGround, this.requiresEvent, _local_1, this.partName);
            return (_local_3);
        }


    }
}
