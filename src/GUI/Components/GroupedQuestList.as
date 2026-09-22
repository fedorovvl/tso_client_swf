package GUI.Components
{
    import flash.utils.Dictionary;
    import GUI.Loca.cLocaManager;
    import mx.events.ItemClickEvent;
    import Communication.VO.dQuestElementVO;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import com.bluebyte.tso.quests.view.ui.itemrenderer.QuestListGroupItemRenderer;
    import com.bluebyte.tso.quests.view.ui.itemrenderer.QuestListItemRenderer;
    import flash.display.DisplayObject;
    import Enums.LOCA_GROUP;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class GroupedQuestList extends GroupList implements IGUIList 
    {

        private var _dataProvider:Object;
        private var _selectedItem:Object;

        private var _groupRendererMap:Dictionary = new Dictionary();
        private var lm:cLocaManager = cLocaManager.GetInstance();

        public function GroupedQuestList()
        {
            super();
            this.addEventListener(ItemClickEvent.ITEM_CLICK, this.select);
        }

        protected function select(_arg_1:ItemClickEvent):void
        {
            this.selectedItem = _arg_1.item;
        }

        private function getItemId(_arg_1:Object):String
        {
            var _local_2:* = "";
            if ((_arg_1 is dQuestElementVO))
            {
                _local_2 = ((_arg_1.getQuestName_string() + _arg_1.mUniqueID) + global.ui.mCurrentViewedZoneID);
            }
            else
            {
                if ((_arg_1 is dAdventureClientInfoVO))
                {
                    _local_2 = (_arg_1.adventureName + _arg_1.zoneID);
                };
            };
            return (_local_2);
        }

        public function getFirstItem(_arg_1:String):DisplayObject
        {
            var _local_2:QuestListGroupItemRenderer;
            var _local_3:QuestListItemRenderer;
            for each (_local_2 in this.getChildren())
            {
                for each (_local_3 in _local_2.list.getChildren())
                {
                    if ((_local_3.data is dQuestElementVO))
                    {
                        if (_local_3.data.getQuestName_string() == _arg_1)
                        {
                            return (_local_3);
                        };
                    }
                    else
                    {
                        if ((_local_3.data is dAdventureClientInfoVO))
                        {
                            if (_local_3.data.adventureName == _arg_1)
                            {
                                return (_local_3);
                            };
                        };
                    };
                };
            };
            return (null);
        }

        protected function updateList(_arg_1:String=null):void
        {
            var _local_3:String;
            var _local_4:String;
            var _local_5:QuestListGroupItemRenderer;
            var _local_6:String;
            var _local_7:Object;
            var _local_2:Dictionary = new Dictionary();
            for (_local_3 in this._dataProvider)
            {
                _local_2[_local_3] = this._dataProvider[_local_3];
                if (this._groupRendererMap[_local_3])
                {
                    _local_5 = this._groupRendererMap[_local_3];
                }
                else
                {
                    _local_5 = new QuestListGroupItemRenderer();
                    _local_5.categoryId = _local_3;
                    this._groupRendererMap[_local_3] = _local_5;
                    this.addChild(_local_5);
                };
                _local_5.title = (((this.lm.GetText(LOCA_GROUP.LABELS, _local_3) + " (") + this._dataProvider[_local_3].length) + ")");
                _local_5.data = this._dataProvider[_local_3];
                if (_arg_1 == _local_3)
                {
                    _local_6 = this.getItemId(this._selectedItem);
                    for each (_local_7 in this._dataProvider[_local_3])
                    {
                        if (this.getItemId(_local_7) == _local_6)
                        {
                            this._selectedItem = _local_7;
                            break;
                        };
                    };
                };
            };
            for (_local_4 in this._groupRendererMap)
            {
                if (!_local_2[_local_4])
                {
                    this.removeChild(this._groupRendererMap[_local_4]);
                    delete this._groupRendererMap[_local_4];
                };
            };
            this.SortChildren();
            this.selectedItem = this._selectedItem;
        }

        private function compareItems(_arg_1:Object, _arg_2:Object):Boolean
        {
            var _local_5:String;
            var _local_6:Object;
            if (((!(_arg_1)) || (!(_arg_2))))
            {
                return (false);
            };
            var _local_3:* = "";
            var _local_4:* = "";
            for (_local_5 in this._dataProvider)
            {
                for each (_local_6 in this._dataProvider[_local_5])
                {
                    if (_local_6 == _arg_1)
                    {
                        _local_3 = _local_5;
                    };
                    if (_local_6 == _arg_2)
                    {
                        _local_4 = _local_5;
                    };
                };
            };
            if ((((!(_local_3 == "")) && (!(_local_4 == ""))) && (!(_local_3 == _local_4))))
            {
                return (false);
            };
            return (this.getItemId(_arg_1) == this.getItemId(_arg_2));
        }

        public function get selectedItem():Object
        {
            return (this._selectedItem);
        }

        public function getAllItems(_arg_1:String):Vector.<DisplayObject>
        {
            var _local_3:QuestListGroupItemRenderer;
            var _local_4:QuestListItemRenderer;
            var _local_2:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            for each (_local_3 in this.getChildren())
            {
                for each (_local_4 in _local_3.list.getChildren())
                {
                    if ((_local_4.data is dQuestElementVO))
                    {
                        if (_local_4.data.getQuestName_string() == _arg_1)
                        {
                            _local_2.push(_local_4);
                        };
                    }
                    else
                    {
                        if ((_local_4.data is dAdventureClientInfoVO))
                        {
                            if (_local_4.data.adventureName == _arg_1)
                            {
                                _local_2.push(_local_4);
                            };
                        };
                    };
                };
            };
            return (_local_2);
        }

        public function set dataProvider(_arg_1:Object):void
        {
            var _local_3:String;
            var _local_4:Object;
            var _local_2:String;
            if (this._selectedItem != null)
            {
                for (_local_3 in this._dataProvider)
                {
                    for each (_local_4 in this._dataProvider[_local_3])
                    {
                        if (this._selectedItem == _local_4)
                        {
                            _local_2 = _local_3;
                            break;
                        };
                    };
                    if (_local_2 != null) break;
                };
            };
            this._dataProvider = _arg_1;
            this.updateList(_local_2);
            invalidateDisplayList();
        }

        public function get dataProvider():Object
        {
            return (this._dataProvider);
        }

        public function set selectedItem(_arg_1:Object):void
        {
            var _local_2:QuestListGroupItemRenderer;
            var _local_3:QuestListItemRenderer;
            var _local_4:QuestListItemRenderer;
            this._selectedItem = null;
            if (_arg_1 == null)
            {
                return;
            };
            for each (_local_2 in this.getChildren())
            {
                for each (_local_3 in _local_2.list.getChildren())
                {
                    _local_3.btnItem.selected = this.compareItems(_arg_1, _local_3.data);
                    if (_local_3.btnItem.selected)
                    {
                        this._selectedItem = _local_3.data;
                    };
                    if (_local_3.mainQuest)
                    {
                        for each (_local_4 in _local_3.list.getChildren())
                        {
                            _local_4.btnItem.selected = this.compareItems(_arg_1, _local_4.data);
                            if (_local_4.btnItem.selected)
                            {
                                this._selectedItem = _local_4.data;
                            };
                        };
                    };
                };
            };
        }

        private function SortChildren():void
        {
            var _local_2:QuestListGroupItemRenderer;
            var _local_1:int = global.questCategoryOrder.length;
            while (_local_1 > 0)
            {
                _local_1--;
                for each (_local_2 in getChildren())
                {
                    if (_local_2.categoryId == global.questCategoryOrder[_local_1].name)
                    {
                        this.setChildIndex(_local_2, 0);
                        break;
                    };
                };
            };
        }


    }
}
