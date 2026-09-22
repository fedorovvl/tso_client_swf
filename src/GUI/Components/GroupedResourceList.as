package GUI.Components
{
    import GUI.Loca.cLocaManager;
    import mx.events.ItemClickEvent;
    import GUI.Components.ItemRenderer.ResourceListGroupItemRenderer;
    import GUI.Components.ItemRenderer.ResourceListItemRenderer;
    import flash.display.DisplayObject;
    import Enums.LOCA_GROUP;
    import ServerState.dResourceDefaultDefinition;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class GroupedResourceList extends GroupList implements IGUIList 
    {

        private var _dataProvider:Object;
        private var _selectedItem:Object;

        private var _groupRendererMap:Object = {};
        private var lm:cLocaManager = cLocaManager.GetInstance();

        public function GroupedResourceList()
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
            var _local_2:ResourceListGroupItemRenderer;
            var _local_3:ResourceListItemRenderer;
            for each (_local_2 in this.getChildren())
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2.btnTitle);
                };
                for each (_local_3 in _local_2.list.getChildren())
                {
                    if (_local_3.data.resourceName_string == _arg_1)
                    {
                        return (_local_3);
                    };
                };
            };
            if (hasOwnProperty(_arg_1))
            {
                return (this[_arg_1]);
            };
            return (null);
        }

        protected function updateList():void
        {
            var _local_2:Object;
            var _local_3:String;
            var _local_4:ResourceListGroupItemRenderer;
            var _local_1:Object = {};
            for each (_local_2 in this._dataProvider)
            {
                _local_1[_local_2.groupId] = _local_2;
                if (this._groupRendererMap[_local_2.groupId])
                {
                    _local_4 = this._groupRendererMap[_local_2.groupId];
                }
                else
                {
                    _local_4 = new ResourceListGroupItemRenderer();
                    _local_4.id = _local_2.groupId;
                    _local_4.title = this.lm.GetText(LOCA_GROUP.LABELS, _local_2.groupId);
                    _local_4.emptyText = this.lm.GetText(LOCA_GROUP.LABELS, (_local_2.groupId + "Empty"));
                    this._groupRendererMap[_local_2.groupId] = _local_4;
                    this.addChild(_local_4);
                };
                _local_4.data = _local_2.data;
            };
            for (_local_3 in this._groupRendererMap)
            {
                if (!_local_1[_local_3])
                {
                    this.removeChild(this._groupRendererMap[_local_3]);
                    delete this._groupRendererMap[_local_3];
                };
            };
            this.selectedItem = this._selectedItem;
        }

        private function compareItems(_arg_1:Object, _arg_2:Object):Boolean
        {
            var _local_3:String;
            var _local_4:String;
            if (!_arg_1)
            {
                return (false);
            };
            if (!_arg_2)
            {
                return (false);
            };
            if ((_arg_1 is dResourceDefaultDefinition))
            {
                _local_3 = _arg_1.resourceName_string;
            };
            if ((_arg_2 is dResourceDefaultDefinition))
            {
                _local_4 = _arg_2.resourceName_string;
            };
            return (_local_3 == _local_4);
        }

        public function get selectedItem():Object
        {
            return (this._selectedItem);
        }

        public function getAllItems(_arg_1:String):Vector.<DisplayObject>
        {
            var _local_3:ResourceListGroupItemRenderer;
            var _local_4:ResourceListItemRenderer;
            var _local_2:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            for each (_local_3 in this.getChildren())
            {
                if (_local_3.id == _arg_1)
                {
                    _local_2.push(_local_3.btnTitle);
                };
                for each (_local_4 in _local_3.list.getChildren())
                {
                    if (_local_4.data.resourceName_string == _arg_1)
                    {
                        _local_2.push(_local_4);
                    };
                };
            };
            if (hasOwnProperty(_arg_1))
            {
                _local_2.push(this[_arg_1]);
            };
            return (_local_2);
        }

        public function set dataProvider(_arg_1:Object):void
        {
            this._dataProvider = _arg_1;
            this.updateList();
        }

        public function removeItem(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_3:Array;
            var _local_4:int;
            for each (_local_2 in this._dataProvider)
            {
                _local_3 = (_local_2.data as Array);
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    if (this.compareItems(_arg_1, _local_3[_local_4]))
                    {
                        _local_3.splice(_local_4, 1);
                        this.updateList();
                        return;
                    };
                    _local_4++;
                };
            };
        }

        public function get dataProvider():Object
        {
            return (this._dataProvider);
        }

        public function set selectedItem(_arg_1:Object):void
        {
            var _local_3:ResourceListGroupItemRenderer;
            var _local_4:ResourceListItemRenderer;
            var _local_2:Boolean;
            for each (_local_3 in this.getChildren())
            {
                for each (_local_4 in _local_3.list.getChildren())
                {
                    _local_4.selected = this.compareItems(_arg_1, _local_4.data);
                    if (_local_4.selected)
                    {
                        _local_2 = true;
                    };
                };
            };
            if (((_local_2) || (_arg_1 == null)))
            {
                this._selectedItem = _arg_1;
            };
        }


    }
}
