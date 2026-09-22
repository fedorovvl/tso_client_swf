package com.bluebyte.bluefire.api.model.vo
{
    import mx.collections.ArrayCollection;

    public class RoomVO 
    {

        private var _occupants:ArrayCollection = new ArrayCollection();
        private var _name:String;


        public function removeOccupant(_arg_1:String):void
        {
            var _local_2:int;
            while (_local_2 < this._occupants.length)
            {
                if (this._occupants[_local_2].name == _arg_1)
                {
                    this._occupants.removeItemAt(_local_2);
                    return;
                };
                _local_2++;
            };
        }

        public function addOccupant(_arg_1:RoomOccupantVO):void
        {
            this._occupants.addItem(_arg_1);
        }

        public function set name(_arg_1:String):void
        {
            this._name = _arg_1;
        }

        public function get name():String
        {
            return (this._name);
        }


    }
}
