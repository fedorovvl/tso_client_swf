package ShopSystem
{
    import __AS3__.vec.Vector;
    import Interface.cGameInterface;
    import __AS3__.vec.*;

    public class VoteShopItemGroup extends cShopItemGroup 
    {

        public function VoteShopItemGroup(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:Boolean)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        protected static function SortVoteItems(_arg_1:cShopItem, _arg_2:cShopItem):int
        {
            if (_arg_2.GetSortIdx() == _arg_1.GetSortIdx())
            {
                if (_arg_2.GetName_string() < _arg_1.GetName_string())
                {
                    return (1);
                };
                if (_arg_2.GetName_string() > _arg_1.GetName_string())
                {
                    return (-1);
                };
                return (_arg_1.GetId() - _arg_2.GetId());
            };
            return (_arg_2.GetSortIdx() - _arg_1.GetSortIdx());
        }


        override public function getSortedItems_vector(_arg_1:cGameInterface, _arg_2:Boolean):Vector.<cShopItem>
        {
            var _local_4:cShopItem;
            var _local_3:Vector.<cShopItem> = new Vector.<cShopItem>();
            for each (_local_4 in shopItems_vector)
            {
                if (!_local_4.hideInShop(_arg_1))
                {
                    if (_arg_2)
                    {
                        if (_local_4.giftable())
                        {
                            _local_4.enabled = (!(_arg_1.mSpecificShopItems));
                            _local_4.setSortIdx(_arg_1.mVotesManager.getVoteItemSortIndex(_local_4.GetId()));
                            _local_3.push(_local_4);
                        };
                    }
                    else
                    {
                        _local_4.enabled = ((_arg_1.mSpecificShopItems) ? _arg_1.mEnabledShopItems_vector.contains(_local_4.GetId()) : ((_local_4.GetTargetZone() == "Friend") ? false : true));
                        _local_4.setSortIdx(_arg_1.mVotesManager.getVoteItemSortIndex(_local_4.GetId()));
                        _local_3.push(_local_4);
                    };
                };
            };
            _local_3.sort(SortVoteItems);
            return (_local_3);
        }


    }
}
