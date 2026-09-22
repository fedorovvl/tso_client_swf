package Collections
{
    import TimedProduction.cAbstractTimedProductionOrder;
    import Communication.VO.collectibles.CollectionVO;
    import Communication.VO.dTimedProductionVO;
    import Interface.cGeneralInterface;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Interface.cGameInterface;
    import BuffSystem.cBuff;
    import BuffSystem.cBuffDefinition;
    import Tracks.TrackManager;
    import ServerState.cPlayerData;

    public class CollectionsTimedProductionOrder extends cAbstractTimedProductionOrder 
    {

        private var collection:CollectionVO;

        public function CollectionsTimedProductionOrder(_arg_1:dTimedProductionVO, _arg_2:cGeneralInterface)
        {
            super(_arg_1, _arg_2);
            this.collection = CollectionsManager.getInstance().getCollection(_arg_1.type_string);
            definition = this.collection;
            ORDER_TYPE = "CollectionsTimedProduction";
            _arg_2.mCurrentPlayer.notifyPropertyObserver(PRODUCTION_START, this);
        }

        override public function GetOnFinishedAvatarMessageType():String
        {
            return (AVATAR_MESSAGE_TYPE.COLLECTION_BUFF_RECEIVED);
        }

        override public function GetTimeBonus():Number
        {
            return (1);
        }

        public function getCollectionVO():CollectionVO
        {
            return (this.collection);
        }

        override public function GetResourceName():String
        {
            return (this.collection.getName());
        }

        override public function IsProduceable(_arg_1:cGameInterface):Boolean
        {
            return (true);
        }

        override public function CreateItem(_arg_1:cPlayerData, _arg_2:cGeneralInterface, _arg_3:int):void
        {
            var _local_4:cBuffDefinition = cBuff.getBuffDefinitionByName(this.collection.getOutputBuffName());
            var _local_5:cBuff = BuffUtils.createBuff(this.collection.getOutputBuffName(), _local_4.GetAmount(), ((_local_4.IsProducible()) ? 1 : 0), _local_4.GetResourceName_string(), timedProductionVO.uniqueId);
            if (_local_5.GetAmount() == 0)
            {
                _local_5.SetAmount(1);
            };
            _arg_1.addBuff(_local_5);
            TrackManager.getInstance().trackCollectionsProduction(_arg_1, definition.GetType(), GetProductionVO().amount);
        }


    }
}
