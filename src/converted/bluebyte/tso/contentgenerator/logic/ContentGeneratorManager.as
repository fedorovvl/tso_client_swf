package converted.bluebyte.tso.contentgenerator.logic
{
    import LootTableSystem.cLootTable;
    import Communication.VO.UpdateVO.dLootItemsVO;
    import __AS3__.vec.Vector;
    import Interface.cGameInterface;
    import Communication.VO.CollectionPartVO;
    import mx.collections.ArrayCollection;
    import Communication.VO.dContentGeneratorRollVO;
    import nLib.cLog;
    import Tracks.TrackManager;
    import Communication.VO.EffectVO;
    import ServerState.dResource;
    import Enums.ModifyReason;
    import Utils.StringUtils;
    import ServerState.cResources;
    import LootTableSystem.cLootTableItemContent;
    import Enums.COMMAND;
    import __AS3__.vec.*;

    public class ContentGeneratorManager 
    {

        private static const dummy1:cLootTable = null;
        private static const dummy2:dLootItemsVO = null;
        public static const COLLECTION_ROLLED:String = "COLLECTION_ROLLED";
        public static const COLLECTION_COMPLETED:String = "COLLECTION_COMPLETED";

        private var parts:Vector.<CollectionPart> = new Vector.<CollectionPart>();
        private var gi:cGameInterface;

        public function ContentGeneratorManager(_arg_1:cGameInterface)
        {
            super();
            this.gi = _arg_1;
        }

        public function SetPartsFromVO(_arg_1:ArrayCollection):void
        {
            var _local_2:CollectionPartVO;
            var _local_3:CollectionPart;
            this.parts.length = 0;
            for each (_local_2 in _arg_1)
            {
                _local_3 = new CollectionPart(_local_2.id, _local_2.name, _local_2.amount);
                this.parts.push(_local_3);
            };
        }

        public function ApplyCompleteCollection(_arg_1:Object):void
        {
            var _local_2:dContentGeneratorRollVO = (_arg_1 as dContentGeneratorRollVO);
            var _local_3:ContentGeneratorContent = this.GetCollectionById(_local_2.categoryId, _local_2.compilationId);
            var _local_4:Boolean = this.SubstractPartsWithId(_local_3.getId(), _local_3.getPartAmount());
            if (!_local_4)
            {
                cLog.warning(((((("Not enough CollectionParts to complete collection: " + _local_3.getName()) + ", required: ") + _local_3.getPartAmount()) + ", available: ") + this.GetPartAmountWithId(_local_3.getId())));
                return;
            };
            this.gi.effectFactory.applyAll(_local_2.rewards);
            globalFlash.gui.mContentGeneratorPanel.CompleteCollectionHandler(_local_2.rewards);
            this.gi.channels.CONTENT_GENERATOR.notifyPropertyObserver(COLLECTION_COMPLETED, _local_2);
            TrackManager.getInstance().trackContentGeneratorCompleteCollection(this.gi.mHomePlayer, _local_2);
        }

        public function GetCollectionById(_arg_1:int, _arg_2:int):ContentGeneratorContent
        {
            var _local_3:ContentGeneratorCategory;
            var _local_4:ContentGeneratorContent;
            for each (_local_3 in ContentGeneratorDefinitions.getInstance().getDefinitions())
            {
                if (_local_3.getId() == _arg_1)
                {
                    for each (_local_4 in _local_3.getCollections())
                    {
                        if (_local_4.getId() == _arg_2)
                        {
                            return (_local_4);
                        };
                    };
                };
            };
            return (null);
        }

        public function ApplyRollResult(_arg_1:Object):void
        {
            var _local_3:EffectVO;
            var _local_4:dResource;
            this.ApplyRollResultUI(_arg_1);
            var _local_2:dContentGeneratorRollVO = (_arg_1 as dContentGeneratorRollVO);
            this.gi.mCurrentPlayerZone.GetResources(this.gi.mHomePlayer).RemovePlayerResourcesFromResourcesInList(_local_2.getCostsAsResourceVector(), 1, ModifyReason.CONTENT_GENERATOR_ROLL);
            for each (_local_3 in _local_2.rewards)
            {
                if (_local_3.name_string == "Crystal")
                {
                    this.gi.mCurrentPlayerZone.GetResources(this.gi.mHomePlayer).AddResource("Crystal", _local_3.amount, ModifyReason.REWARD, null);
                }
                else
                {
                    this.gi.effectFactory.createEffect(_local_3).apply();
                };
            };
            this.gi.channels.CONTENT_GENERATOR.notifyPropertyObserver(COLLECTION_ROLLED, _local_2);
            TrackManager.getInstance().trackContentGeneratorRoll(this.gi.mHomePlayer, _local_2);
            for each (_local_4 in _local_2.costs)
            {
                if (_local_4.name_string == defines.HARD_CURRENCY_RESOURCE_NAME_string)
                {
                    TrackManager.getInstance().trackGemsContentGenerator(this.gi.mHomePlayer, _local_4.amount, this.gi.mCurrentPlayerZone.GetResources(this.gi.mHomePlayer).GetPlayerResource(defines.HARD_CURRENCY_RESOURCE_NAME_string).amount);
                };
            };
        }

        public function GetPartAmountWithId(_arg_1:int):int
        {
            var _local_3:CollectionPart;
            var _local_2:CollectionPart;
            for each (_local_3 in this.parts)
            {
                if (_local_3.GetId() == _arg_1)
                {
                    _local_2 = _local_3;
                    break;
                };
            };
            if (_local_2 == null)
            {
                return (0);
            };
            return (_local_2.GetAmount());
        }

        public function GetParts():Vector.<CollectionPart>
        {
            return (this.parts);
        }

        public function SubstractPartsWithId(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:CollectionPart;
            for each (_local_3 in this.parts)
            {
                if (_local_3.GetId() == _arg_1)
                {
                    if (_local_3.GetAmount() >= _arg_2)
                    {
                        _local_3.AddAmount((-1 * _arg_2));
                        return (true);
                    };
                    return (false);
                };
            };
            return (false);
        }

        public function AddPartsWithName(_arg_1:String, _arg_2:int):void
        {
            var _local_3:CollectionPart;
            var _local_4:CollectionPart;
            for each (_local_3 in this.parts)
            {
                if (StringUtils.equalsCase(_local_3.GetName(), _arg_1))
                {
                    _local_3.AddAmount(_arg_2);
                    return;
                };
            };
            _local_4 = new CollectionPart(ContentGeneratorDefinitions.getInstance().getCollectionIdFromPartName(_arg_1), _arg_1, _arg_2);
            this.parts.push(_local_4);
        }

        public function CalculateZoneCheckSum():int
        {
            var _local_3:CollectionPart;
            var _local_1:int;
            var _local_2:int;
            for each (_local_3 in this.parts)
            {
                if (_local_3.GetAmount() > 0)
                {
                    _local_1 = (((_local_1 + (_local_3.GetId() << 8)) + _local_3.GetAmount()) % 0xFFFF);
                    _local_2 = ((_local_2 + _local_1) % 0xFFFF);
                };
            };
            return ((_local_2 << 16) | _local_1);
        }

        public function CalculateRollCost(_arg_1:int, _arg_2:int, _arg_3:int):Vector.<dResource>
        {
            var _local_7:dResource;
            var _local_10:dResource;
            var _local_4:ContentGeneratorContent = this.GetCollectionById(_arg_1, _arg_2);
            var _local_5:cResources = this.gi.mCurrentPlayerZone.GetResources(this.gi.mHomePlayer);
            var _local_6:Vector.<dResource> = new Vector.<dResource>();
            if (_local_5 == null)
            {
                return (_local_6);
            };
            var _local_8:int;
            var _local_9:Number = 0;
            for each (_local_10 in _local_4.getCosts())
            {
                _local_8 = ((_local_10.amount * _arg_3) - _local_5.GetResourceAmount(_local_10.name_string));
                _local_8 = Math.max(_local_8, 0);
                if (_local_8 > 0)
                {
                    if (global.resourceHardcurrencyValues.hasOwnProperty(_local_10.name_string))
                    {
                        _local_9 = (_local_9 + (_local_8 * global.resourceHardcurrencyValues[_local_10.name_string]));
                    };
                };
                _local_7 = _local_10.clone();
                _local_7.amount = ((_local_10.amount * _arg_3) - _local_8);
                _local_6.push(_local_7);
            };
            if (_local_9 > 0)
            {
                _local_7 = new dResource();
                _local_7.name_string = defines.HARD_CURRENCY_RESOURCE_NAME_string;
                _local_7.amount = (Math.ceil(_local_9) as int);
                _local_6.push(_local_7);
            };
            return (_local_6);
        }

        public function GetPartWithName(_arg_1:String):CollectionPart
        {
            var _local_2:CollectionPart;
            for each (_local_2 in this.parts)
            {
                if (StringUtils.equalsCase(_local_2.GetName(), _arg_1))
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        private function markJackpotRewards(_arg_1:ArrayCollection):void
        {
            var _local_2:EffectVO;
            var _local_3:ContentGeneratorCategory;
            var _local_4:ContentGeneratorContent;
            var _local_5:cLootTableItemContent;
            var _local_6:EffectVO;
            for each (_local_2 in _arg_1)
            {
                for each (_local_3 in ContentGeneratorDefinitions.getInstance().getDefinitions())
                {
                    for each (_local_4 in _local_3.getCollections())
                    {
                        for each (_local_5 in _local_4.getContent().mItemContents_vector)
                        {
                            _local_6 = _local_5.GetEffectVOFromLootTableItemContent();
                            if ((((_local_2.item_string.toLowerCase().indexOf(_local_6.item_string.toLowerCase()) > -1) && (_local_2.type_string.toLowerCase().indexOf(_local_6.type_string.toLowerCase()) > -1)) && (_local_5.GetIsJackpot())))
                            {
                                _local_2.action_string = "isJackpot";
                                break;
                            };
                        };
                        if (_local_2.action_string == "isJackpot") break;
                    };
                    if (_local_2.action_string == "isJackpot") break;
                };
            };
        }

        public function ApplyRollResultUI(_arg_1:Object):void
        {
            var _local_2:dContentGeneratorRollVO = (_arg_1 as dContentGeneratorRollVO);
            this.markJackpotRewards(_local_2.rewards);
            globalFlash.gui.mContentGeneratorRewardPanel.SetRewards(_local_2.rewards);
            globalFlash.gui.mContentGeneratorPanel.RollCompleteHandler();
        }

        public function RollCollection(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            var _local_5:dContentGeneratorRollVO = new dContentGeneratorRollVO();
            _local_5.categoryId = _arg_1;
            _local_5.compilationId = _arg_2;
            _local_5.rollAmount = _arg_3;
            _local_5.useHardCurrency = _arg_4;
            this.gi.SendServerActionSimple(COMMAND.CONTENT_GENERATOR_ROLL, _local_5);
        }

        public function CompleteCollection(_arg_1:int, _arg_2:int):void
        {
            var _local_3:dContentGeneratorRollVO = new dContentGeneratorRollVO();
            _local_3.categoryId = _arg_1;
            _local_3.compilationId = _arg_2;
            this.gi.SendServerActionSimple(COMMAND.CONTENT_GENERATOR_COMPLETE_COLLECTION, _local_3);
        }


    }
}
