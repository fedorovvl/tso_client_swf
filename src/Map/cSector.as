package Map
{
    import Model.Notifier;
    import __AS3__.vec.Vector;
    import Communication.VO.dSectorVO;
    import __AS3__.vec.*;

    public class cSector extends Notifier 
    {

        public static const ISLAND_DEED_TYPE_FREE:int = 1;
        public static const ISLAND_DEED_TYPE_PAY:int = 2;

        public const mAdjactedSectorIds_vector:Vector.<int> = new Vector.<int>();

        private var mCityLevelAtWhichSectorIsActivated:int;
        public var mIsExplored:Boolean;
        private var mSectorID:int;
        private var mOwnerPlayerID:int;
        public var mAmount:int;
        private var mExplorePriority:int;
        public var mIsIsland:Boolean;
        public var mIslandDeedType:int;

        public function cSector(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:int, _arg_7:Boolean)
        {
            super();
            this.mSectorID = _arg_1;
            this.mOwnerPlayerID = _arg_2;
            this.mExplorePriority = _arg_3;
            this.mCityLevelAtWhichSectorIsActivated = _arg_4;
            this.mIsIsland = _arg_5;
            this.mIslandDeedType = _arg_6;
            this.mIsExplored = _arg_7;
        }

        public static function getIslandDeedTypeString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case ISLAND_DEED_TYPE_FREE:
                    return ("FreeIsland");
                case ISLAND_DEED_TYPE_PAY:
                    return ("PayIsland");
                default:
                    return ("");
            };
        }


        public function GetExplorePriority():int
        {
            return (this.mExplorePriority);
        }

        public function GetSectorID():int
        {
            return (this.mSectorID);
        }

        override public function toString():String
        {
            return (((("<Sector sectorID='" + this.mSectorID) + "' mOwnerPlayerID='") + this.mOwnerPlayerID) + "' />");
        }

        public function GetCityLevelAtWhichSectorIsActivated():int
        {
            return (this.mCityLevelAtWhichSectorIsActivated);
        }

        public function SetCityLevelAtWhichSectorIsActivated(_arg_1:int):void
        {
            this.mCityLevelAtWhichSectorIsActivated = _arg_1;
        }

        public function setIsIsland(_arg_1:Boolean):void
        {
            this.mIsIsland = _arg_1;
        }

        public function CreateSectorVOFromSector():dSectorVO
        {
            var _local_1:dSectorVO = new dSectorVO();
            _local_1.playerID = this.mOwnerPlayerID;
            _local_1.sectorID = this.mSectorID;
            _local_1.explorePriority = this.mExplorePriority;
            _local_1.cityLevelAtWhichSectorIsActivated = this.mCityLevelAtWhichSectorIsActivated;
            _local_1.isIsland = this.mIsIsland;
            _local_1.islandDeedType = this.mIslandDeedType;
            _local_1.isExplored = this.mIsExplored;
            return (_local_1);
        }

        public function SetOwnerPlayerID(_arg_1:int):void
        {
            this.mOwnerPlayerID = _arg_1;
            notifyPropertyObserver("mOwnerPlayerID", _arg_1);
        }

        public function setIslandDeedType(_arg_1:int):void
        {
            this.mIslandDeedType = _arg_1;
        }

        public function getIslandDeedType():int
        {
            return (this.mIslandDeedType);
        }

        public function GetOwnerPlayerID():int
        {
            return (this.mOwnerPlayerID);
        }

        public function isExplored():Boolean
        {
            return (this.mIsExplored);
        }

        public function IsIsland():Boolean
        {
            return (this.mIsIsland);
        }


    }
}
