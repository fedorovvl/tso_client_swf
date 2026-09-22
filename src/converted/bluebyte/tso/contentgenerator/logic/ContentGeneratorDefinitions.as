package converted.bluebyte.tso.contentgenerator.logic
{
    import Communication.VO.ContentGenerator.ContentGeneratorCategoryVO;
    import Communication.VO.ContentGenerator.ContentGeneratorContentVO;
    import Communication.VO.EffectVO;
    import __AS3__.vec.Vector;
    import nLib.cXML;
    import Utils.StringUtils;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class ContentGeneratorDefinitions 
    {

        private static const dummy1:ContentGeneratorCategoryVO = null;
        private static const dummy2:ContentGeneratorContentVO = null;
        private static const dummy3:EffectVO = null;
        private static var singletonInstance:ContentGeneratorDefinitions;

        private var category_vector:Vector.<ContentGeneratorCategory>;

        public function ContentGeneratorDefinitions(_arg_1:Vector.<ContentGeneratorCategory>)
        {
            super();
            this.category_vector = _arg_1;
        }

        public static function getInstance():ContentGeneratorDefinitions
        {
            return (singletonInstance);
        }

        public static function parseXML(_arg_1:cXML):ContentGeneratorDefinitions
        {
            var _local_4:cXML;
            var _local_2:Vector.<cXML> = _arg_1.CreateChildrenArray();
            var _local_3:Vector.<ContentGeneratorCategory> = new Vector.<ContentGeneratorCategory>();
            for each (_local_4 in _local_2)
            {
                _local_3.push(ContentGeneratorCategory.parseXML(_local_4));
            };
            return (new ContentGeneratorDefinitions(_local_3));
        }

        public static function setInstance(_arg_1:ContentGeneratorDefinitions):void
        {
            singletonInstance = _arg_1;
        }


        public function getCategoryIdFromName(_arg_1:String):int
        {
            var _local_2:ContentGeneratorCategory;
            for each (_local_2 in this.category_vector)
            {
                if (StringUtils.equalsIgnoreCase(_arg_1, _local_2.getName()))
                {
                    return (_local_2.getId());
                };
            };
            return (-1);
        }

        public function getPartName(_arg_1:int):String
        {
            var _local_2:ContentGeneratorCategory;
            var _local_3:ContentGeneratorContent;
            for each (_local_2 in this.category_vector)
            {
                for each (_local_3 in _local_2.getCollections())
                {
                    if (_local_3.getId() == _arg_1)
                    {
                        return (_local_3.getPartName());
                    };
                };
            };
            return ("");
        }

        public function getCategoryNameFromId(_arg_1:int):String
        {
            var _local_2:ContentGeneratorCategory;
            for each (_local_2 in this.category_vector)
            {
                if (_local_2.getId() == _arg_1)
                {
                    return (_local_2.getName());
                };
            };
            return (null);
        }

        public function getCollectionIdFromPartName(_arg_1:String):int
        {
            var _local_2:ContentGeneratorCategory;
            var _local_3:ContentGeneratorContent;
            for each (_local_2 in this.category_vector)
            {
                for each (_local_3 in _local_2.getCollections())
                {
                    if (StringUtils.equalsIgnoreCase(_local_3.getPartName(), _arg_1))
                    {
                        return (_local_3.getId());
                    };
                };
            };
            return (-1);
        }

        public function getDefinitions():Vector.<ContentGeneratorCategory>
        {
            return (this.category_vector);
        }

        public function getActiveDefinitions():ArrayCollection
        {
            var _local_2:ContentGeneratorCategory;
            var _local_3:ContentGeneratorCategory;
            var _local_4:Boolean;
            var _local_5:Vector.<ContentGeneratorContent>;
            var _local_6:ContentGeneratorContent;
            var _local_1:ArrayCollection = new ArrayCollection();
            for each (_local_2 in this.category_vector)
            {
                _local_3 = _local_2.CloneWithoutCollections();
                _local_4 = false;
                _local_5 = new Vector.<ContentGeneratorContent>();
                for each (_local_6 in _local_2.getCollections())
                {
                    if ((((_local_6.getRequiresEvent() == null) || (_local_6.getRequiresEvent() == "")) || (global.ui.mEventManager.isEventStarted(_local_6.getRequiresEvent()))))
                    {
                        _local_4 = true;
                        _local_5.push(_local_6);
                    };
                };
                if (_local_4)
                {
                    _local_3.setCollections(_local_5);
                    _local_1.addItem(_local_3);
                };
            };
            return (_local_1);
        }

        public function getCollectionNameFromId(_arg_1:int):String
        {
            var _local_2:ContentGeneratorCategory;
            var _local_3:ContentGeneratorContent;
            for each (_local_2 in this.category_vector)
            {
                for each (_local_3 in _local_2.getCollections())
                {
                    if (_local_3.getId() == _arg_1)
                    {
                        return (_local_3.getName());
                    };
                };
            };
            return (null);
        }

        public function getCollectionIdFromName(_arg_1:String):int
        {
            var _local_2:ContentGeneratorCategory;
            var _local_3:ContentGeneratorContent;
            for each (_local_2 in this.category_vector)
            {
                for each (_local_3 in _local_2.getCollections())
                {
                    if (StringUtils.equalsIgnoreCase(_arg_1, _local_3.getName()))
                    {
                        return (_local_3.getId());
                    };
                };
            };
            return (-1);
        }


    }
}
