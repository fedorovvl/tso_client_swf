package Votes
{
    import Interface.cGeneralInterface;
    import Communication.VO.Votes.dPlayerVoteVO;
    import Utils.HashMapWrapper;
    import Enums.COMMAND;
    import Communication.VO.Votes.dVoteResultVO;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.Vector;
    import Enums.KILL_SWITCH;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;

    public class VotesManager 
    {

        public var gi:cGeneralInterface;
        private var votePlayer:dPlayerVoteVO;

        private var historyVotedShopItems:Object = {};
        private var historyItemPercentage:HashMapWrapper = new HashMapWrapper();
        private var currentShopItems:Object = {};

        public function VotesManager(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
        }

        public function SetVoteSeen():void
        {
            this.votePlayer.seen = true;
            global.ui.SendServerActionSimple(COMMAND.VOTES_SET_SEEN_BATCH_VOTE, null, null);
        }

        public function getVoteItemSortIndex(_arg_1:int):int
        {
            if (!this.historyItemPercentage.hasKey(_arg_1))
            {
                return (0);
            };
            var _local_2:dVoteResultVO = (this.historyItemPercentage.getItem(_arg_1) as dVoteResultVO);
            return ((100000 * _local_2.poolID) + _local_2.percentage);
        }

        public function GetCurrentShopItems():Object
        {
            return (this.currentShopItems);
        }

        public function SendVote():void
        {
            global.ui.SendServerActionSimple(COMMAND.VOTES_SEND_PLAYER_VOTE, this.votePlayer, null);
        }

        public function SetPlayerVote(_arg_1:dPlayerVoteVO):void
        {
            this.votePlayer = _arg_1;
        }

        public function GetHistoryVotedShopItems():Object
        {
            return (this.historyVotedShopItems);
        }

        public function SetHistoryVotedShopItems(_arg_1:Object):void
        {
            var _local_2:Object;
            var _local_3:dVoteResultVO;
            var _local_4:String;
            var _local_5:ArrayCollection;
            var _local_6:Vector.<dVoteResultVO>;
            var _local_7:Object;
            var _local_8:int;
            this.historyVotedShopItems = _arg_1;
            this.historyItemPercentage.clear();
            if (_arg_1 != null)
            {
                this.currentShopItems = new Object();
                _local_2 = new Object();
                for each (_local_3 in _arg_1)
                {
                    if (_local_3.poolID > 0)
                    {
                        if (_local_2[_local_3.poolID] == null)
                        {
                            _local_2[_local_3.poolID] = new ArrayCollection();
                        };
                        _local_2[_local_3.poolID].addItem(_local_3);
                        this.historyItemPercentage.putItem(_local_3.itemID, _local_3);
                    };
                };
                for (_local_4 in _local_2)
                {
                    _local_5 = _local_2[_local_4];
                    _local_6 = new Vector.<dVoteResultVO>();
                    for each (_local_7 in _local_5)
                    {
                        _local_6.push((_local_7 as dVoteResultVO));
                    };
                    _local_6.sort(dVoteResultVO.PercentageDescComparator);
                    if (((!(_local_6 == null)) && (_local_6.length > 0)))
                    {
                        _local_8 = Math.min(global.vote_pool_definitions.getItem(_local_4).votesAmount, _local_6.length);
                        this.currentShopItems[_local_4] = _local_6.slice(0, _local_8);
                    };
                };
            };
        }

        public function Init(_arg_1:dPlayerVoteVO):void
        {
            this.votePlayer = _arg_1;
        }

        public function IsVoteEnabled():Boolean
        {
            return ((this.gi.killswitch.isAccessible(KILL_SWITCH.VOTES_GUILD_MARKET)) && ((this.gi.killswitch.isAccessible(KILL_SWITCH.VOTES_GUILD_MARKET_NOCHEAT)) || (this.gi.mCurrentPlayer.getPlayerCanCheat())));
        }

        public function IsItemInCurrentShopItems(_arg_1:int):Boolean
        {
            var _local_2:Object;
            var _local_3:Object;
            if (this.GetCurrentShopItems() != null)
            {
                for each (_local_2 in this.GetCurrentShopItems())
                {
                    for each (_local_3 in _local_2)
                    {
                        if ((_local_3 as dVoteResultVO).itemID == _arg_1)
                        {
                            return (true);
                        };
                    };
                };
            };
            return (false);
        }

        public function GetPlayerVote():dPlayerVoteVO
        {
            return (this.votePlayer);
        }

        public function GetHistory(_arg_1:DisplayObject=null):Object
        {
            return (this.historyVotedShopItems);
        }

        public function DeleteVoteWithGems():void
        {
            global.ui.SendServerActionSimple(COMMAND.VOTES_DELETE_PLAYER_VOTE_WITH_GEMS, this.votePlayer, null);
        }


    }
}
