package BuffSystem
{
    import Utils.HashMapWrapper;

    public class PremiumAccount 
    {

        public static const PREMIUM_LOOT_PREFIX:String = "_premiumloot_";

        private var mFriendZoneBuffTimeBonus:Number;
        private var mPvpXpBonus:Number;
        private var regularDailyQuestLists:HashMapWrapper = new HashMapWrapper();
        private var mVpBonus:Number;
        private var mXpBonus:Number;
        private var mRegularDailyQuests:int;
        private var mLootBonus:Number;
        private var mBuildingSlots:int;


        public function GetLootBonus():Number
        {
            return (this.mLootBonus);
        }

        public function AddVpBonus(_arg_1:Number):Number
        {
            return (_arg_1 + ((_arg_1 / 100) * this.mVpBonus));
        }

        public function AddXpBonus(_arg_1:Number):Number
        {
            return (_arg_1 + ((_arg_1 / 100) * this.mXpBonus));
        }

        public function GetBuildingSlots():int
        {
            return (this.mBuildingSlots);
        }

        public function GetPvpXpBonus():Number
        {
            return (this.mPvpXpBonus);
        }

        public function AddPvpXpBonus(_arg_1:Number):Number
        {
            return (_arg_1 + ((_arg_1 / 100) * this.mPvpXpBonus));
        }

        public function SetPvpXpBonus(_arg_1:Number):void
        {
            this.mPvpXpBonus = _arg_1;
        }

        public function SetFriendZoneBuffTimeBonus(_arg_1:Number):void
        {
            this.mFriendZoneBuffTimeBonus = _arg_1;
        }

        public function SetVpBonus(_arg_1:Number):void
        {
            this.mVpBonus = _arg_1;
        }

        public function GetRegularDailyQuests():int
        {
            return (this.mRegularDailyQuests);
        }

        public function SetXpBonus(_arg_1:Number):void
        {
            this.mXpBonus = _arg_1;
        }

        public function GetFriendZoneBuffTimeBonus():Number
        {
            return (this.mFriendZoneBuffTimeBonus);
        }

        public function addRegularDailyQuestList(_arg_1:String):void
        {
            this.regularDailyQuestLists.putItem(_arg_1, true);
        }

        public function GetVpBonus():Number
        {
            return (this.mVpBonus);
        }

        public function GetXpBonus():Number
        {
            return (this.mXpBonus);
        }

        public function SetLootBonus(_arg_1:Number):void
        {
            this.mLootBonus = _arg_1;
        }

        public function SetRegularDailyQuests(_arg_1:int):void
        {
            this.mRegularDailyQuests = _arg_1;
        }

        public function isRegularDailyQuestListApplicable(_arg_1:String):Boolean
        {
            return (this.regularDailyQuestLists.hasKey(_arg_1));
        }

        public function SetBuildingSlots(_arg_1:int):void
        {
            this.mBuildingSlots = _arg_1;
        }


    }
}
