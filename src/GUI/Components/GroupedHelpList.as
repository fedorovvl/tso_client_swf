package GUI.Components
{
    import GUI.Loca.cLocaManager;
    import mx.events.ItemClickEvent;
    import GUI.Components.ItemRenderer.HelpListGroupItemRenderer;
    import GUI.Components.ItemRenderer.HelpListItemRenderer;
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    import Enums.LOCA_GROUP;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class GroupedHelpList extends GroupList implements IGUIList 
    {

        private var _dataProvider:Object;
        private var _selectedItem:Object;

        private var _groupRendererMap:Object = {};
        private var lm:cLocaManager = cLocaManager.GetInstance();

        public function GroupedHelpList()
        {
            super();
            this.addEventListener(ItemClickEvent.ITEM_CLICK, this.select);
        }

        protected function select(_arg_1:ItemClickEvent):void
        {
            this.selectedItem = _arg_1.item;
        }

        public function getFirstItem(_arg_1:String):DisplayObject
        {
            var _local_2:HelpListGroupItemRenderer;
            var _local_3:HelpListItemRenderer;
            for each (_local_2 in this.getChildren())
            {
                for each (_local_3 in _local_2.list.getChildren())
                {
                    if (_local_3.data.helpName_string == _arg_1)
                    {
                        return (_local_3);
                    };
                };
            };
            return (null);
        }

        protected function updateList(_arg_1:String=null):void
        {
            var _local_3:String;
            var _local_4:String;
            var _local_5:HelpListGroupItemRenderer;
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
                    _local_5 = new HelpListGroupItemRenderer();
                    _local_5.categoryId = _local_3;
                    this._groupRendererMap[_local_3] = _local_5;
                    this.addChild(_local_5);
                };
                _local_5.title = this.lm.GetText(LOCA_GROUP.LABELS, _local_3);
                _local_5.data = this._dataProvider[_local_3];
                if (_arg_1 == _local_3)
                {
                    _local_6 = this._selectedItem.helpName_string;
                    for each (_local_7 in this._dataProvider[_local_3])
                    {
                        if (_local_7.helpName_string == _local_6)
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
            if (((!(_arg_1)) || (!(_arg_2))))
            {
                return (false);
            };
            return (_arg_1.helpName_string == _arg_2.helpName_string);
        }

        public function get selectedItem():Object
        {
            return (this._selectedItem);
        }

        public function getAllItems(_arg_1:String):Vector.<DisplayObject>
        {
            var _local_3:HelpListGroupItemRenderer;
            var _local_4:HelpListItemRenderer;
            var _local_2:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            for each (_local_3 in this.getChildren())
            {
                for each (_local_4 in _local_3.list.getChildren())
                {
                    if (_local_4.data.helpName_string == _arg_1)
                    {
                        _local_2.push(_local_4);
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
        }

        public function get dataProvider():Object
        {
            return (this._dataProvider);
        }

        public function set selectedItem(_arg_1:Object):void
        {
            var _local_2:HelpListGroupItemRenderer;
            var _local_3:HelpListItemRenderer;
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
                        this._selectedItem = _arg_1;
                    };
                };
            };
        }

        private function SortChildren():void
        {
            var _local_2:HelpListGroupItemRenderer;
            var _local_1:int = global.helpCategoryOrder.length;
            while (_local_1 > 0)
            {
                _local_1--;
                for each (_local_2 in getChildren())
                {
                    if (_local_2.categoryId == global.helpCategoryOrder[_local_1])
                    {
                        this.setChildIndex(_local_2, 0);
                        break;
                    };
                };
            };
        }


    }
}
