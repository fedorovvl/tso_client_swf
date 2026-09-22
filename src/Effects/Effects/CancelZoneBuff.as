package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import BuffSystem.cBuffDefinition;
    import BuffSystem.cBuff;
    import Communication.VO.dUniqueID;
    import Utils.StringUtils;
    import Communication.VO.dPersistedBuffApplianceVO;

    public class CancelZoneBuff extends Effect 
    {

        public static const XML_string:String = "cancelzonebuff";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:cBuffDefinition = cBuffDefinition.GetByName(effect.name_string);
            var _local_2:cBuff = new cBuff(_local_1, new dUniqueID(), 1);
            if (!StringUtils.isEmpty(effect.item_string))
            {
                _local_2.SetResourceName(effect.item_string);
            };
            var _local_3:String = (_local_2.GetType() + ((_local_2.GetResourceName_string().length > 0) ? ("_" + _local_2.GetResourceName_string()) : ""));
            var _local_4:dPersistedBuffApplianceVO = gi.mZoneBuffManager.getPersistedBuffApplianceVO(_local_3);
            if (_local_4 != null)
            {
                gi.mZoneBuffManager.removeBuff(_local_4.buffID, _local_4.sourceZoneId);
            };
        }


    }
}
