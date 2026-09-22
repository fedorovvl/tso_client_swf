package GUI.Components
{
    import Collections.ICollectionUpdate;
    import flash.events.MouseEvent;

    public class CollectionTileList extends CustomTileList implements ICollectionUpdate 
    {


        public function update(... _args):void
        {
            var _local_6:ICollectionUpdate;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int = this.rowCount;
            var _local_5:int = this.columnCount;
            while (_local_2 < _local_4)
            {
                _local_3 = 0;
                while (_local_3 < _local_5)
                {
                    if ((((listItems) && (listItems[_local_2])) && (listItems[_local_2][_local_3])))
                    {
                        _local_6 = listItems[_local_2][_local_3];
                        _local_6.update();
                    };
                    _local_3++;
                };
                _local_2++;
            };
        }

        override protected function mouseWheelHandler(_arg_1:MouseEvent):void
        {
            _arg_1.delta = ((_arg_1.delta > 0) ? 1 : -1);
            super.mouseWheelHandler(_arg_1);
        }


    }
}
