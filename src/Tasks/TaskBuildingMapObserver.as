package Tasks
{
    import Model.Observer;
    import Utils.Disposable;
    import Interface.cGeneralInterface;
    import Utils.HashSetWrapper;
    import Utils.TriggerUtils;
    import __AS3__.vec.Vector;
    import Enums.COMMAND;
    import Model.Notifier;

    public class TaskBuildingMapObserver implements Observer, Disposable 
    {

        private var gi:cGeneralInterface;
        private var buildings:HashSetWrapper = new HashSetWrapper();

        public function TaskBuildingMapObserver(_arg_1:cGeneralInterface, _arg_2:Vector.<String>)
        {
            var _local_3:String;
            super();
            this.gi = _arg_1;
            for each (_local_3 in _arg_2)
            {
                this.buildings.add(_local_3);
            };
            _arg_1.channels.ZONE.addPropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
        }

        public function dispose():void
        {
            this.gi.channels.ZONE.removePropertyObserver(TriggerUtils.ON_MAP_NOTIFICATION_PROPERTY_NAME, this);
            this.buildings.clear();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:Boolean;
            if (this.buildings.contains(_arg_3))
            {
                _local_4 = this.gi.mCurrentPlayerZone.mStreetDataMap.getTaskBuildings_vector().length;
                _local_5 = ((this.gi.getCurrentTaskManager() == null) ? 0 : this.gi.getCurrentTaskManager().getTaskBuildingsOnMap_vector().length);
                _local_6 = (((this.gi.getCurrentTaskManager() == null) && (_local_4 > 0)) || ((!(this.gi.getCurrentTaskManager() == null)) && (!(_local_5 == _local_4))));
                if (_local_6)
                {
                    this.gi.mClientMessages.SendMessagetoServer(COMMAND.GET_ZONE_ON_THE_FLY, this.gi.mCurrentViewedZoneID, null);
                };
            };
        }


    }
}
