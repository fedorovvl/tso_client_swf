package GOSets
{
    import nLib.cXML;
    import GO.cGOSpriteLibContainer;
    import GO.cGOGroup;
    import nLib.gMisc;
    import __AS3__.vec.Vector;
    import GO.cBlockingData;
    import __AS3__.vec.*;

    public class cGOSetManager 
    {

        private static var mGOSetNode:cXML = null;


        public static function CreateSingleGfxGOSetList(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:cGOGroup):cGOSetList
        {
            var _local_5:cGOSetListController = new cGOSetListControllerStatic();
            var _local_6:cGOSetItem = new cGOSetItem();
            _local_6.mOffsetX = _arg_2;
            _local_6.mOffsetY = _arg_3;
            _local_6.mSpriteLib = _arg_4.GetSpriteLibFromNameGOList(_arg_1);
            _local_6.mSpriteLib.SetSubType(0);
            _local_6.mSpriteLib.SetAnim((_local_6.mSpriteLib.GetContainer() as cGOSpriteLibContainer).mEffectDefaultAnimSpeed, true);
            _local_6.mSpriteLib.SetAnimFrame(0);
            var _local_7:cGOSet = new cGOSet();
            _local_7.mGOSetItem_vector.push(_local_6);
            var _local_8:cGOSetListItem = new cGOSetListItem();
            _local_8.mValue = 0;
            _local_8.mGOSet = _local_7;
            var _local_9:cGOSetList = new cGOSetList(_local_5);
            _local_9.mName_string = _arg_1;
            _local_9.mBlocking_vector = null;
            _local_9.mGOSetListItem_vector.push(_local_8);
            _local_5.SetValue(0);
            return (_local_9);
        }

        public static function setGOSetNode(_arg_1:cXML):void
        {
            mGOSetNode = _arg_1;
        }

        public static function CreateGOSetList(_arg_1:String, _arg_2:cGOSetListController):cGOSetList
        {
            var _local_5:cGOSetList;
            var _local_6:cGOSetListItem;
            var _local_7:cGOSetListItem;
            if (_arg_2 == null)
            {
                _arg_2 = new cGOSetListControllerStatic();
            };
            var _local_3:cGOSetList = new cGOSetList(_arg_2);
            var _local_4:String = gMisc.RemoveExtension(_arg_1);
            for each (_local_5 in global.goSetList_vector)
            {
                if (_local_5.mName_string == _local_4)
                {
                    _local_3.mName_string = _local_5.mName_string;
                    _local_3.mType_string = _local_5.mType_string;
                    _local_3.mBlocking_vector = _local_5.mBlocking_vector;
                    for each (_local_6 in _local_5.mGOSetListItem_vector)
                    {
                        _local_7 = new cGOSetListItem();
                        _local_7.mValue = _local_6.mValue;
                        _local_7.mName_string = _local_6.mName_string;
                        _local_7.mGOSet = CreateGOSet(_local_7.mName_string, _local_6.mLoop);
                        _local_3.mGOSetListItem_vector.push(_local_7);
                    };
                    _arg_2.SetValue(0);
                    return (_local_3);
                };
            };
            gMisc.Assert(false, ("Wrong GOSetList name: " + _local_4));
            return (null);
        }

        public static function CreateGOSet(_arg_1:String, _arg_2:Boolean):cGOSet
        {
            var _local_4:cGOSet;
            var _local_5:cGOSetItem;
            var _local_6:cGOSetItem;
            var _local_7:cGOGroup;
            var _local_3:cGOSet = new cGOSet();
            for each (_local_4 in global.goSet_vector)
            {
                if (_local_4.mName_string == _arg_1)
                {
                    for each (_local_5 in _local_4.mGOSetItem_vector)
                    {
                        _local_6 = new cGOSetItem();
                        _local_6.mOffsetX = _local_5.mOffsetX;
                        _local_6.mOffsetY = _local_5.mOffsetY;
                        _local_6.mName_string = _local_5.mName_string;
                        _local_6.mGroup_string = _local_5.mGroup_string;
                        _local_7 = new cGOGroup();
                        if (_local_6.mGroup_string == "Landscapes")
                        {
                            _local_7 = global.landscapeGroup;
                        }
                        else
                        {
                            if (_local_6.mGroup_string == "Effects")
                            {
                                _local_7 = global.effectGroup;
                            }
                            else
                            {
                                if (_local_6.mGroup_string == "Buildings")
                                {
                                    _local_7 = global.buildingGroup;
                                }
                                else
                                {
                                    if (_local_6.mGroup_string == "Settlers")
                                    {
                                        _local_7 = global.settlerGroup;
                                    }
                                    else
                                    {
                                        if (_local_6.mGroup_string == "GuiIcons")
                                        {
                                            _local_7 = global.guiIconGroup;
                                        };
                                    };
                                };
                            };
                        };
                        _local_6.mSpriteLib = _local_7.GetSpriteLibFromNameGOList(_local_6.mName_string);
                        _local_6.mSpriteLib.SetSubType(0);
                        _local_6.mSpriteLib.SetAnim((_local_6.mSpriteLib.GetContainer() as cGOSpriteLibContainer).mEffectDefaultAnimSpeed, _arg_2);
                        _local_6.mSpriteLib.SetAnimFrame(0);
                        _local_3.mGOSetItem_vector.push(_local_6);
                    };
                    return (_local_3);
                };
            };
            gMisc.Assert(false, (("GOSet name " + _arg_1) + " not found!"));
            return (null);
        }

        public static function LoadGOSetData():void
        {
            var xml:cXML;
            var goListGfxObjectsList:cXML;
            var xml3:cXML;
            var eset:cGOSet;
            var xml2:cXML;
            var eitem:cGOSetItem;
            var gosetlist:cGOSetList;
            var arr_vector:Vector.<cGOSetListItem>;
            var xml4:cXML;
            var i:cGOSetListItem;
            var childrenArray:Vector.<cXML>;
            var xml5:cXML;
            var gosetlistitem:cGOSetListItem;
            var blockList:cXML;
            var blockListArray:Vector.<cXML>;
            var blockingDataXml:cXML;
            var goGfxObjectsList:cXML = global.gfxSettingsGameObjectsXML.MoveToSubNode("GOSets");
            var gfxObjectsListArray:Vector.<cXML> = goGfxObjectsList.CreateChildrenArray();
            for each (xml in gfxObjectsListArray)
            {
                eset = new cGOSet();
                eset.mName_string = xml.GetAttributeString_string("name");
                eset.mID = xml.GetAttributeInt("id");
                for each (xml2 in xml.CreateChildrenArray())
                {
                    eitem = new cGOSetItem();
                    eitem.mOffsetX = xml2.GetAttributeInt("x");
                    eitem.mOffsetY = xml2.GetAttributeInt("y");
                    eitem.mName_string = xml2.GetAttributeString_string("name");
                    eitem.mGroup_string = xml2.GetAttributeString_string("group");
                    eset.mGOSetItem_vector.push(eitem);
                };
                global.goSet_vector.push(eset);
            };
            goListGfxObjectsList = global.gfxSettingsGameObjectsXML.MoveToSubNode("GOSetLists");
            gfxObjectsListArray = goListGfxObjectsList.CreateChildrenArray();
            for each (xml3 in gfxObjectsListArray)
            {
                gosetlist = new cGOSetList(null);
                gosetlist.mName_string = xml3.GetAttributeString_string("name");
                gosetlist.mType_string = xml3.GetAttributeString_string("type");
                arr_vector = new Vector.<cGOSetListItem>();
                for each (xml4 in xml3.CreateChildrenArray())
                {
                    gosetlistitem = new cGOSetListItem();
                    gosetlistitem.mName_string = xml4.GetAttributeString_string("name");
                    gosetlistitem.mValue = xml4.GetAttributeInt("value");
                    gosetlistitem.mLoop = xml4.GetAttributeBool("loop", true);
                    arr_vector.push(gosetlistitem);
                };
                arr_vector.sort(function compare (_arg_1:cGOSetListItem, _arg_2:cGOSetListItem):Number
                {
                    if (_arg_1.mValue < _arg_2.mValue)
                    {
                        return (-1);
                    };
                    return (1);
                });
                for each (i in arr_vector)
                {
                    gosetlist.mGOSetListItem_vector.push(i);
                };
                childrenArray = mGOSetNode.CreateChildrenArray();
                for each (xml5 in childrenArray)
                {
                    if (xml5.GetAttributeString_string("name") == xml3.GetAttributeString_string("blockingset"))
                    {
                        blockList = xml5.MoveToSubNode("Blocks");
                        blockListArray = blockList.CreateChildrenArray();
                        for each (blockingDataXml in blockListArray)
                        {
                            gosetlist.mBlocking_vector.push(new cBlockingData(blockingDataXml));
                        };
                    };
                };
                global.goSetList_vector.push(gosetlist);
            };
            mGOSetNode = null;
        }


    }
}
