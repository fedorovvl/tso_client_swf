package com.bluebyte.tso.util
{
    import ShopSystem.cShopItem;
    import Enums.MAIL_TYPE;
    import Interface.cGameInterface;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import Communication.VO.Mail.dMailVO;
    import Enums.MAIL_TYPE_GROUP;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;
    import flash.display.Bitmap;

    public class MailUtils 
    {


        public static function CanCollectMail(_arg_1:dMailVO):Boolean
        {
            var _local_3:cShopItem;
            if (!MAIL_TYPE.isCollectable(_arg_1.type))
            {
                return (false);
            };
            var _local_2:cGameInterface = global.getApplication().mGameInterface;
            if (((!(_local_2.mCurrentViewedZoneID == _local_2.mCurrentPlayer.GetPlayerId())) || (_local_2.IsAdventureZoneID(_local_2.mCurrentViewedZoneID))))
            {
                return (false);
            };
            if (_arg_1.type == MAIL_TYPE.GIFT)
            {
                _local_3 = cShopItem.GetShopItem((_arg_1.attachments as dLootItemsVO).shopItemId);
                if (_local_3 != null)
                {
                    if (((!(_local_3.GetTargetZone() == "Friend")) && (_local_2.mCurrentPlayer.GetPlayerLevel() < _local_3.GetPlayerLevel())))
                    {
                        return (false);
                    };
                    if (((!(_local_3.GetTargetZone() == "Friend")) && (_local_2.mCurrentPlayer.GetPlayerPvPLevel() < _local_3.GetPvPLevel())))
                    {
                        return (false);
                    };
                    if (_local_3.GetPerPlayer() > 0)
                    {
                        return (false);
                    };
                };
            };
            return (true);
        }

        public static function getLabelByMailGroup(_arg_1:int):String
        {
            var _local_2:* = "mailGroupUnkown";
            switch (_arg_1)
            {
                case MAIL_TYPE_GROUP.ADVENTURE:
                    _local_2 = "mailGroupAdventure";
                    break;
                case MAIL_TYPE_GROUP.MAIL_READ:
                    _local_2 = "mailGroupRead";
                    break;
                case MAIL_TYPE_GROUP.MAIL_UNREAD:
                    _local_2 = "mailGroupUnread";
                    break;
                case MAIL_TYPE_GROUP.BATTLE_REPORT:
                    _local_2 = "mailGroupBattleReport";
                    break;
                case MAIL_TYPE_GROUP.BUFF:
                    _local_2 = "mailGroupBuff";
                    break;
                case MAIL_TYPE_GROUP.FRIEND:
                    _local_2 = "mailGroupFriend";
                    break;
                case MAIL_TYPE_GROUP.GIFT:
                    _local_2 = "mailGroupGift";
                    break;
                case MAIL_TYPE_GROUP.GUILD:
                    _local_2 = "mailGroupGuild";
                    break;
                case MAIL_TYPE_GROUP.HARD_CURRENCY:
                    _local_2 = "mailGroupHardCurrency";
                    break;
                case MAIL_TYPE_GROUP.LOOT:
                    _local_2 = "mailGroupLoot";
                    break;
                case MAIL_TYPE_GROUP.NPC:
                    _local_2 = "mailGroupNPC";
                    break;
                case MAIL_TYPE_GROUP.TRADE:
                    _local_2 = "mailGroupTrade";
                    break;
            };
            return (cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _local_2));
        }

        public static function getIconByMailGroup(_arg_1:int):Bitmap
        {
            var _local_2:* = "";
            switch (_arg_1)
            {
                case MAIL_TYPE_GROUP.ADVENTURE:
                    _local_2 = "IconMailTypeAdventureLoot";
                    break;
                case MAIL_TYPE_GROUP.MAIL_READ:
                    _local_2 = "IconMailTypeMailRead";
                    break;
                case MAIL_TYPE_GROUP.MAIL_UNREAD:
                    _local_2 = "IconMailTypeMail";
                    break;
                case MAIL_TYPE_GROUP.BATTLE_REPORT:
                    _local_2 = "IconMailTypeBattleReport";
                    break;
                case MAIL_TYPE_GROUP.BUFF:
                    _local_2 = "IconMailTypeBuffed";
                    break;
                case MAIL_TYPE_GROUP.FRIEND:
                    _local_2 = "IconMailTypeFriend";
                    break;
                case MAIL_TYPE_GROUP.GIFT:
                    _local_2 = "IconMailTypeGift";
                    break;
                case MAIL_TYPE_GROUP.GUILD:
                    _local_2 = "IconMailTypeGuild";
                    break;
                case MAIL_TYPE_GROUP.HARD_CURRENCY:
                    _local_2 = "IconMailTypeHardCurrency";
                    break;
                case MAIL_TYPE_GROUP.LOOT:
                    _local_2 = "IconMailTypeLoot";
                    break;
                case MAIL_TYPE_GROUP.NPC:
                    _local_2 = "IconMailTypeNPC";
                    break;
                case MAIL_TYPE_GROUP.TRADE:
                    _local_2 = "IconMailTypeTrade";
                    break;
            };
            return (gAssetManager.GetBitmap(_local_2));
        }

        public static function getIconByMailType(_arg_1:int, _arg_2:Boolean):Bitmap
        {
            return (getIconByMailGroup(MAIL_TYPE_GROUP.getMailGroup(_arg_1, _arg_2)));
        }


    }
}
