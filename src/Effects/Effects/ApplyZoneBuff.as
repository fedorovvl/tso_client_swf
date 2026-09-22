package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import BuffSystem.cBuffDefinition;
    import BuffSystem.cBuff;
    import Utils.StringUtils;
    import Enums.BUFF_APPLIANCE_MODE;
    import Effects.EffectList;

    public class ApplyZoneBuff extends Effect 
    {

        public static const XML_string:String = "applyzonebuff";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_1:cBuffDefinition = cBuffDefinition.GetByName(effect.name_string);
            var _local_2:cBuff = new cBuff(_local_1, gi.mHomePlayer.GetNewUniqueID(), 1);
            if (!StringUtils.isEmpty(effect.item_string))
            {
                _local_2.SetResourceName(effect.item_string);
            };
            var _local_3:int = BUFF_APPLIANCE_MODE.CULTURE_BUILDING;
            if (!StringUtils.isEmpty(effect.type_string))
            {
                _local_3 = BUFF_APPLIANCE_MODE.parseString(effect.type_string);
            };
            gi.mZoneBuffManager.addBuff(_local_2, _local_3);
            EffectList.apply(_local_1.GetApplyEffects(), gi);
        }


    }
}
