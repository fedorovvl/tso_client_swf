package ZoneBuff
{
    import Interface.cGeneralInterface;
    import __AS3__.vec.Vector;
    import Communication.VO.dPersistedZoneSpecialistActivityVO;
    import Communication.VO.dUniqueID;
    import mx.collections.ArrayCollection;
    import __AS3__.vec.*;

    public class ZoneSpecialistActivity 
    {

        private var gi:cGeneralInterface;
        private var specialistActivity_vector:Vector.<dPersistedZoneSpecialistActivityVO>;

        public function ZoneSpecialistActivity(_arg_1:cGeneralInterface)
        {
            super();
            this.gi = _arg_1;
            this.specialistActivity_vector = new Vector.<dPersistedZoneSpecialistActivityVO>();
        }

        public function RegisterActivity(_arg_1:int, _arg_2:int, _arg_3:dUniqueID, _arg_4:int, _arg_5:int):void
        {
            var _local_7:dPersistedZoneSpecialistActivityVO;
            var _local_6:dPersistedZoneSpecialistActivityVO = this.GetActivity(_arg_1, _arg_2, _arg_3, _arg_4);
            if (_local_6 != null)
            {
                _local_6.count = (_local_6.count + _arg_5);
                _local_6.lastActivityTime = this.gi.GetClientTime();
                _local_6.dirtyIndicator.dataModified();
            }
            else
            {
                _local_7 = new dPersistedZoneSpecialistActivityVO();
                _local_7.zoneID = _arg_1;
                _local_7.playerID = _arg_2;
                _local_7.uniqueID = _arg_3;
                _local_7.activityType = _arg_4;
                _local_7.lastActivityTime = this.gi.GetClientTime();
                _local_7.count = _arg_5;
                this.specialistActivity_vector.push(_local_7);
            };
        }

        private function GetActivity(_arg_1:int, _arg_2:int, _arg_3:dUniqueID, _arg_4:int):dPersistedZoneSpecialistActivityVO
        {
            var _local_5:dPersistedZoneSpecialistActivityVO;
            for each (_local_5 in this.specialistActivity_vector)
            {
                if (((((_local_5.zoneID == _arg_1) && (_local_5.playerID == _arg_2)) && (_local_5.uniqueID.eq(_arg_3))) && (_local_5.activityType == _arg_4)))
                {
                    return (_local_5);
                };
            };
            return (null);
        }

        public function GetActivityForPersistence_vector():Vector.<dPersistedZoneSpecialistActivityVO>
        {
            return (this.specialistActivity_vector);
        }

        public function GetActivityCount(_arg_1:int, _arg_2:int, _arg_3:dUniqueID, _arg_4:int):int
        {
            var _local_5:dPersistedZoneSpecialistActivityVO;
            for each (_local_5 in this.specialistActivity_vector)
            {
                if (((((_local_5.zoneID == _arg_1) && (_local_5.playerID == _arg_2)) && (_local_5.uniqueID.eq(_arg_3))) && (_local_5.activityType == _arg_4)))
                {
                    return (_local_5.count);
                };
            };
            return (0);
        }

        public function loadActivity(_arg_1:ArrayCollection):void
        {
            var _local_2:dPersistedZoneSpecialistActivityVO;
            this.specialistActivity_vector = new Vector.<dPersistedZoneSpecialistActivityVO>();
            for each (_local_2 in _arg_1)
            {
                if (_local_2 != null)
                {
                    (_local_2 as dPersistedZoneSpecialistActivityVO).dirtyIndicator.clean();
                    this.specialistActivity_vector.push(_local_2);
                };
            };
        }


    }
}
