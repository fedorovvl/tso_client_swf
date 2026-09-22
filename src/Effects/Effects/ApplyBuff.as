package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import BuffSystem.cBuff;
    import Model.Notifiers.BuffAppliedNotification;
    import GO.cBuilding;
    import BuffSystem.cBuffDefinition;
    import Utils.StringUtils;

    public class ApplyBuff extends Effect 
    {

        public static const XML_string:String = "applybuff";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        private function applyBuffOnBuilding(_arg_1:cBuilding, _arg_2:cBuff):void
        {
            _arg_2.applyBuffResultToZone(gi.mHomePlayer, gi, _arg_1, effect.amount, 0);
            gi.channels.BUFF.send(cBuff.BUFF_APPLIED_string, new BuffAppliedNotification(_arg_2, _arg_1, effect.amount, gi.mHomePlayer.GetPlayerId()));
        }

        override protected function action():void
        {
            var _local_4:String;
            var _local_5:cBuilding;
            var _local_1:cBuffDefinition = cBuffDefinition.GetByName(effect.name_string);
            var _local_2:cBuff = new cBuff(_local_1, gi.mHomePlayer.GetNewUniqueID(), effect.amount);
            if (!StringUtils.isEmpty(effect.item_string))
            {
                _local_2.SetResourceName(effect.item_string);
            };
            var _local_3:cBuilding;
            if (effect.targetGridPos > -1)
            {
                this.applyBuffOnBuilding(gi.mCurrentPlayerZone.GetBuildingFromGridPosition(effect.targetGridPos), _local_2);
            }
            else
            {
                for each (_local_4 in StringUtils.split(effect.target_string, ","))
                {
                    for each (_local_5 in gi.mCurrentPlayerZone.mStreetDataMap.getBuildingsByName_vector(_local_4))
                    {
                        this.applyBuffOnBuilding(_local_5, _local_2);
                    };
                };
            };
        }


    }
}
