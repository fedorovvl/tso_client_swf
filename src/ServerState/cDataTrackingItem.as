package ServerState
{
    import Communication.VO.dDataIntStringVO;
    import Communication.VO.dDataTrackingVO;
    import Enums.DIRTY_INDICATOR;

    public class cDataTrackingItem 
    {

        private var dataTracking:Object = new Object();
        public var mDirtyIndicator:int;
        private var amount:int;
        private var type:int;

        public function cDataTrackingItem(_arg_1:int)
        {
            super();
            this.type = _arg_1;
        }

        public function IncTrackingDetail(_arg_1:String, _arg_2:int):void
        {
            if (isNaN(this.dataTracking[_arg_1]))
            {
                this.dataTracking[_arg_1] = _arg_2;
            }
            else
            {
                this.dataTracking[_arg_1] = (this.dataTracking[_arg_1] + _arg_2);
            };
        }

        public function toString():String
        {
            var _local_1:String;
            var _local_2:String;
            var _local_3:int;
            _local_1 = ((("<cDataTrackingItem type='" + this.type) + "' amount='") + this.amount);
            for (_local_2 in this.dataTracking)
            {
                _local_3 = this.dataTracking[_local_2];
                _local_1 = (_local_1 + ((("..." + _local_2) + "=") + _local_3));
            };
            return (_local_1 + "' />");
        }

        public function GetAmount():int
        {
            return (this.amount);
        }

        public function CreateVO():dDataTrackingVO
        {
            var _local_2:String;
            var _local_3:dDataIntStringVO;
            var _local_1:dDataTrackingVO = new dDataTrackingVO();
            _local_1.amount = this.amount;
            for (_local_2 in this.dataTracking)
            {
                _local_3 = new dDataIntStringVO();
                _local_3.string = _local_2;
                _local_3.value = this.dataTracking[_local_2];
                _local_1.dataTracking.addItem(_local_3);
            };
            return (_local_1);
        }

        public function IncAmount(_arg_1:int):void
        {
            if (this.amount == 0)
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.CREATED_BIT);
            }
            else
            {
                this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.MODIFIED_BIT);
            };
            this.amount = (this.amount + _arg_1);
        }

        public function GetType():int
        {
            return (this.type);
        }

        public function CreateFromVO(_arg_1:dDataTrackingVO):void
        {
            var _local_2:dDataIntStringVO;
            this.amount = _arg_1.amount;
            this.dataTracking = new Object();
            for each (_local_2 in _arg_1.dataTracking)
            {
                this.dataTracking[_local_2.string] = _local_2.value;
            };
        }


    }
}
