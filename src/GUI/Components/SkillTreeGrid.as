package GUI.Components
{
    import mx.core.UIComponent;
    import flash.utils.Dictionary;
    import flash.display.DisplayObject;

    public class SkillTreeGrid extends UIComponent 
    {

        private var _numRows:int = 1;
        private var _rowHeight:Number = 40;
        private var _colWidth:Number = 80;
        private var _childGridPositions:Dictionary = new Dictionary();
        private var _colPadding:int;
        private var _rowPadding:int;
        private var _numCols:int = 1;


        private function _recalculateDimensions():void
        {
            this._colWidth = (width / this._numCols);
            this._rowHeight = (height / this._numRows);
        }

        public function addChildAtPosition(_arg_1:SkillTreeItemRenderer, _arg_2:int, _arg_3:int):DisplayObject
        {
            addChild(_arg_1);
            this._recalculateDimensions();
            _arg_1.x = Math.floor((this._getGridPosX(_arg_2) + ((this._colWidth * 0.5) - (_arg_1.width * 0.5))));
            _arg_1.y = Math.floor((this._getGridPosY(_arg_3) + ((this._rowHeight * 0.5) - (_arg_1.height * 0.5))));
            return (_arg_1);
        }

        private function _getGridPosX(_arg_1:int):Number
        {
            return (_arg_1 * (this._colWidth + this._colPadding));
        }

        public function set colPadding(_arg_1:int):void
        {
            this._colPadding = _arg_1;
        }

        public function clear():void
        {
            while (numChildren)
            {
                removeChildAt(0);
            };
        }

        private function _getGridPosY(_arg_1:int):Number
        {
            return (_arg_1 * (this._rowHeight + this._rowPadding));
        }

        public function set numCols(_arg_1:int):void
        {
            this._numCols = _arg_1;
            this._recalculateDimensions();
        }

        public function debugDraw():void
        {
            var _local_2:int;
            graphics.beginFill(0x666666);
            var _local_1:int = (this._numRows - 1);
            while (_local_1 >= 0)
            {
                _local_2 = 0;
                while (_local_2 < this._numCols)
                {
                    graphics.drawRect(this._getGridPosX(_local_2), this._getGridPosY(_local_1), this._colWidth, this._rowHeight);
                    _local_2++;
                };
                _local_1--;
            };
            graphics.endFill();
        }

        public function set rowPadding(_arg_1:int):void
        {
            this._rowPadding = _arg_1;
        }

        public function set numRows(_arg_1:int):void
        {
            this._numRows = _arg_1;
            this._recalculateDimensions();
        }


    }
}
