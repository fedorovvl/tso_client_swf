package GUI.Components
{
    import mx.containers.Canvas;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;
    import mx.styles.CSSStyleDeclaration;
    import GUI.Components.data.dCombatUnitData;
    import mx.core.ClassFactory;
    import mx.events.ListEvent;
    import __AS3__.vec.Vector;
    import mx.events.PropertyChangeEvent;
    import Communication.VO.dSquadVO;
    import MilitarySystem.cMilitaryUnitData;
    import GUI.Components.ItemRenderer.Combat3DefenseModeUnitSelectionItemRenderer;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import mx.styles.*;
    import flash.text.*;
    import flash.media.*;
    import mx.binding.*;
    import __AS3__.vec.*;
    import flash.filters.*;
    import flash.utils.*;
    import flash.net.*;
    import flash.system.*;
    import flash.accessibility.*;
    import flash.xml.*;
    import flash.ui.*;
    import flash.external.*;
    import flash.desktop.*;
    import flash.data.*;
    import flash.debugger.*;
    import flash.errors.*;
    import flash.filesystem.*;
    import flash.html.*;
    import flash.html.script.*;
    import flash.printing.*;
    import flash.profiler.*;

    public class Combat3UnitSelection extends Canvas 
    {

        public static const MODE_ALLOCATION:int = 0;
        public static const MODE_SELECTION:int = 1;
        public static const UNIT_ALLOCATION_CHANGE_EVENT:String = "unitAllocationChangeEvent";
        public static const UNIT_MANAGER_REMOVE_ME_EVENT:String = "unitManagerRemoveMeEvent";

        private var mPreviousUnitsAmount:int = 0;
        private var numSelections:int = 0;
        private var _462897929selectArmyList:TabEnabledTileList;
        public var isSelectable:Boolean = false;
        public var maxSelections:int = 6;
        public var itemDisplayMode:int = 0;
        private var mData:Array;
        private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function ():Object
            {
                return ({"childDescriptors":[new UIComponentDescriptor({
                        "type":Canvas,
                        "propertiesFactory":function ():Object
                        {
                            return ({
                                "percentWidth":100,
                                "percentHeight":100,
                                "horizontalScrollPolicy":"off",
                                "verticalScrollPolicy":"off",
                                "childDescriptors":[new UIComponentDescriptor({
                                    "type":TabEnabledTileList,
                                    "id":"selectArmyList",
                                    "events":{"itemClick":"__selectArmyList_itemClick"},
                                    "stylesFactory":function ():void
                                    {
                                        this.backgroundAlpha = 0;
                                        this.borderThickness = 0;
                                        this.useRollOver = false;
                                    },
                                    "propertiesFactory":function ():Object
                                    {
                                        return ({
                                            "allowMultipleSelection":true,
                                            "horizontalScrollPolicy":"off",
                                            "verticalScrollPolicy":"off",
                                            "tabChildren":true,
                                            "tabEnabled":false,
                                            "itemRenderer":_Combat3UnitSelection_ClassFactory1_c(),
                                            "selectable":false
                                        });
                                    }
                                })]
                            });
                        }
                    })]});
            }
        });

        public function Combat3UnitSelection()
        {
            super();
            mx_internal::_document = this;
            if (!this.styleDeclaration)
            {
                this.styleDeclaration = new CSSStyleDeclaration();
            };
            this.styleDeclaration.defaultFactory = function ():void
            {
                this.backgroundAlpha = 0;
                this.borderThickness = 0;
            };
            this.horizontalScrollPolicy = "off";
            this.verticalScrollPolicy = "off";
        }

        public function SetData(_arg_1:Array, _arg_2:Class, _arg_3:int=3):void
        {
            var _local_4:int;
            var _local_5:dCombatUnitData;
            if (_arg_1 != null)
            {
                this.selectArmyList.itemRenderer = new ClassFactory(_arg_2);
                this.selectArmyList.columnCount = _arg_3;
                this.numSelections = 0;
                this.mData = _arg_1;
                _local_4 = 0;
                while (_local_4 < this.mData.length)
                {
                    this.mData[_local_4].tabIndex = (_local_4 + 1);
                    this.mData[_local_4].itemMode = this.itemDisplayMode;
                    this.mData[_local_4].isSelectable = this.isSelectable;
                    if (this.mData[_local_4].isSelected)
                    {
                        this.numSelections++;
                    };
                    _local_4++;
                };
            };
            if (this.itemDisplayMode == MODE_ALLOCATION)
            {
                if (this.mData.length < 6)
                {
                    _local_5 = new dCombatUnitData();
                    _local_5.isDummyAddIcon = true;
                    this.mData.push(_local_5);
                };
            };
            this.selectArmyList.dataProvider = this.mData;
        }

        override public function initialize():void
        {
            (mx_internal::setDocumentDescriptor(this._documentDescriptor_));
            super.initialize();
        }

        public function __selectArmyList_itemClick(_arg_1:ListEvent):void
        {
            this.itemClickHandler(_arg_1);
        }

        protected function itemClickHandler(_arg_1:ListEvent):void
        {
            var _local_2:dCombatUnitData = (_arg_1.itemRenderer.data as dCombatUnitData);
            if (_local_2.isSelectable)
            {
                if (((!(_local_2.isSelected)) && (this.numSelections < this.maxSelections)))
                {
                    _local_2.isSelected = true;
                    _arg_1.itemRenderer.data = _local_2;
                    this.numSelections++;
                }
                else
                {
                    if (_local_2.isSelected)
                    {
                        _local_2.isSelected = false;
                        this.numSelections--;
                        _arg_1.itemRenderer.data = _local_2;
                    };
                };
            };
        }

        public function GetAllocatedUnitsCost():int
        {
            var _local_2:int;
            var _local_1:int;
            if (this.selectArmyList.dataProvider != null)
            {
                _local_2 = 0;
                while (_local_2 < this.selectArmyList.dataProvider.length)
                {
                    _local_1 = (_local_1 + (this.selectArmyList.dataProvider[_local_2].current * this.selectArmyList.dataProvider[_local_2].cost_amount));
                    _local_2++;
                };
            };
            return (_local_1);
        }

        public function GetSelectedUnitTypes():Vector.<String>
        {
            var _local_2:int;
            var _local_1:Vector.<String> = new Vector.<String>();
            if (this.selectArmyList.dataProvider != null)
            {
                _local_2 = 0;
                while (_local_2 < this.selectArmyList.dataProvider.length)
                {
                    if (this.selectArmyList.dataProvider[_local_2].isSelected)
                    {
                        _local_1.push(this.selectArmyList.dataProvider[_local_2].name_string);
                    };
                    _local_2++;
                };
            };
            return (_local_1);
        }

        public function set selectArmyList(_arg_1:TabEnabledTileList):void
        {
            var _local_2:Object = this._462897929selectArmyList;
            if (_local_2 !== _arg_1)
            {
                this._462897929selectArmyList = _arg_1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectArmyList", _local_2, _arg_1));
            };
        }

        public function GetAllocatedUnitsAmount():int
        {
            var _local_2:int;
            var _local_1:int;
            if (this.selectArmyList.dataProvider != null)
            {
                _local_2 = 0;
                while (_local_2 < this.selectArmyList.dataProvider.length)
                {
                    if (!this.selectArmyList.dataProvider[_local_2].isDummyAddIcon)
                    {
                        _local_1 = (_local_1 + this.selectArmyList.dataProvider[_local_2].current);
                    };
                    _local_2++;
                };
            };
            return (_local_1);
        }

        public function getAllocatedSquads_vector():Vector.<dSquadVO>
        {
            var _local_2:Object;
            var _local_1:Vector.<dSquadVO> = new Vector.<dSquadVO>();
            for each (_local_2 in this.selectArmyList.dataProvider)
            {
                if (((_local_2.current > 0) && (!(_local_2.isDummyAddIcon))))
                {
                    _local_1.push(new dSquadVO().init(_local_2.name_string, _local_2.current, cMilitaryUnitData.GetUnitDataForType(_local_2.name_string).GetHitPoints()));
                };
            };
            return (_local_1);
        }

        private function _Combat3UnitSelection_ClassFactory1_c():ClassFactory
        {
            var _local_1:ClassFactory = new ClassFactory();
            _local_1.generator = Combat3DefenseModeUnitSelectionItemRenderer;
            return (_local_1);
        }

        [Bindable(event="propertyChange")]
        public function get selectArmyList():TabEnabledTileList
        {
            return (this._462897929selectArmyList);
        }


    }
}
