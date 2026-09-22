package Trigger.Triggers
{
    import Trigger.InstantTrigger;
    import Model.Observer;
    import Trigger.Triggerable;
    import Communication.VO.TriggerVO;
    import Interface.cGeneralInterface;
    import Model.Notifier;
    import ServerState.cBuildQueueData;
    import __AS3__.vec.Vector;
    import GO.cBuilding;

    public final class BuildingQueueTrigger extends InstantTrigger implements Observer 
    {

        public function BuildingQueueTrigger(_arg_1:Triggerable, _arg_2:TriggerVO, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3.mCurrentPlayer.mBuildQueue);
            if (_arg_2.min == 0)
            {
                _arg_2.min = 1;
            };
            if (_arg_2.max == 0)
            {
                _arg_2.max = 100100100;
            };
            _arg_3.mCurrentPlayer.mBuildQueue.addPropertyObserver("mQueue_vector", this);
        }

        override public function check():Boolean
        {
            updateCurrentAmount();
            var _local_1:Number = getCurrentAmount();
            if (((_local_1 >= definition.min) && (_local_1 <= definition.max)))
            {
                trigger();
                return (true);
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == "mQueue_vector")
            {
                this.check();
            };
        }

        override protected function computeCurrentAmount():Number
        {
            var _local_1:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:String;
            var _local_2:cBuildQueueData = (para as cBuildQueueData);
            var _local_3:Vector.<cBuilding> = _local_2.GetQueue_vector();
            if (definition.item_string == "")
            {
                _local_1 = _local_3.length;
            }
            else
            {
                _local_5 = _local_3.length;
                _local_1 = 0;
                _local_4 = 0;
                while (_local_4 < _local_5)
                {
                    _local_6 = _local_3[_local_4].GetBuildingName_string();
                    if (definition.item_string == _local_6)
                    {
                        _local_1++;
                    };
                    _local_4++;
                };
            };
            return (_local_1);
        }

        override public function dispose():void
        {
            (para as cBuildQueueData).removePropertyObserver("mQueue_vector", this);
            super.dispose();
        }


    }
}
