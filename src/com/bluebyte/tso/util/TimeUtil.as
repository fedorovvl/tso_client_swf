package com.bluebyte.tso.util
{
    public class TimeUtil 
    {

        private static var serverTime:Number = 0;
        private static var receivedAt:Number = 0;
        private static var realmTimeOffset:Number = 0;
        private static var guildQuestOffset:Number = 0;


        public static function getServerTime():Number
        {
            return (serverTime + (getClientTime() - receivedAt));
        }

        public static function _setRealmTimeOffset(_arg_1:Number):void
        {
            realmTimeOffset = _arg_1;
        }

        public static function getClientTime():Number
        {
            return (new Date().getTime());
        }

        public static function _setGuildQuestTimeOffset(_arg_1:Number):void
        {
            guildQuestOffset = _arg_1;
        }

        public static function _setServerTime(_arg_1:Number):void
        {
            receivedAt = getClientTime();
            var _local_2:Date = new Date(_arg_1);
            var _local_3:Date = new Date();
            _local_2.setUTCSeconds(_local_3.getUTCSeconds(), _local_3.getUTCMilliseconds());
            serverTime = _local_2.getTime();
        }

        public static function getServerTimeWithGuildQuestOffset():Number
        {
            return (getServerTime() + (guildQuestOffset * 3600000));
        }

        public static function getServerTimeWithOffset():Number
        {
            return (getServerTime() + (realmTimeOffset * 3600000));
        }


    }
}
