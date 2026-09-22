package converted.bluebyte.tso.cooldown
{
    import Interface.cGeneralInterface;
    import Communication.VO.dPersistedBuffApplianceVO;
    import BuffSystem.cBuffDefinition;

    public class CultureBuildingCooldownTimeBonusProvider implements CooldownTimeBonusProvider 
    {

        private var gi:cGeneralInterface;
        private var name_string:String;

        public function CultureBuildingCooldownTimeBonusProvider(_arg_1:cGeneralInterface, _arg_2:String)
        {
            super();
            this.gi = _arg_1;
            this.name_string = _arg_2;
        }

        public function getCooldownTimeBonus():Number
        {
            var _local_2:dPersistedBuffApplianceVO;
            var _local_3:cBuffDefinition;
            var _local_1:Number = 100;
            for each (_local_2 in this.gi.mZoneBuffManager.getExtraBuildingBuffs_vector(this.name_string))
            {
                _local_3 = cBuffDefinition.GetById(_local_2.buffID);
                if (_local_3 != null)
                {
                    _local_1 = (_local_1 + (_local_3.getRecruitingTime() - 100));
                };
            };
            return (_local_1);
        }


    }
}
