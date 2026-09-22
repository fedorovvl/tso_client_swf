package ServerState
{
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import Enums.DIRTY_INDICATOR;
    import mx.collections.*;
    import __AS3__.vec.*;
    import Communication.VO.*;
    import nLib.*;

    public class cDataTracking 
    {

        public static const DATA_TRACKING_BUILDING_BUILT:int = 0;
        public static const DATA_TRACKING_MINES_EMPTIED:int = 1;
        public static const DATA_TRACKING_PRODUCED_RESOURCES_OF_TYPE_X:int = 2;
        public static const DATA_TRACKING_GENERAL_DEFEATED_X_UNITS:int = 3;
        public static const DATA_TRACKING_GENERAL_X_UNITS_OF_TYPE_X_TRAINED:int = 4;
        public static const DATA_TRACKING_FOUGHT_X_BATTLES:int = 5;
        public static const DATA_TRACKING_BUFFED_A_FRIEND_X_TIMES:int = 6;
        public static const DATA_TRACKING_MILLISECONDS_OF_GAMEPLAY:int = 7;
        public static const DATA_TRACKING_MINUTES_OF_GAMEPLAY:int = 8;
        public static const DATA_TRACKING_X_EVENT_ZONES_COMPLETED:int = 9;
        public static const DATA_TRACKING_EVENT_ZONE_X_COMPLETED:int = 10;
        public static const DATA_TRACKING_NOF:int = 11;

        public var mDataTrackingItem_vector:Vector.<cDataTrackingItem> = new Vector.<cDataTrackingItem>();
        public var mDirtyIndicator:int;
        private var mGeneralInterface:cGeneralInterface = null;

        public function cDataTracking(_arg_1:cGeneralInterface)
        {
            super();
            this.mGeneralInterface = _arg_1;
            this.mDataTrackingItem_vector.length = 0;
            var _local_2:int;
            while (_local_2 < DATA_TRACKING_NOF)
            {
                this.mDataTrackingItem_vector.push(new cDataTrackingItem(_local_2));
                _local_2++;
            };
        }

        public function IncTrackingDetail(_arg_1:int, _arg_2:String, _arg_3:int):void
        {
            this.mDataTrackingItem_vector[_arg_1].IncTrackingDetail(_arg_2, _arg_3);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
        }

        public function AddTrackingValue(_arg_1:int, _arg_2:int):void
        {
            this.mDataTrackingItem_vector[_arg_1].IncAmount(_arg_2);
            this.mDirtyIndicator = (this.mDirtyIndicator | DIRTY_INDICATOR.WEAK_MODIFICATION_BIT);
        }

        public function CheckAchievements():void
        {
        }

        public function GetTrackingValues():Vector.<cDataTrackingItem>
        {
            return (this.mDataTrackingItem_vector);
        }


    }
}
