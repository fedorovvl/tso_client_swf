package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Communication.VO.dRequirementVO;
    import Communication.VO.dRequirementsVO;

    public final class FulfillCondition extends Effect 
    {

        public static const XML_string:String = "condition";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            var _local_2:dRequirementVO;
            var _local_1:dRequirementsVO = gi.mRequirements.getRequirementsByName(effect.type_string)[effect.name_string];
            for each (_local_2 in _local_1.requirements)
            {
                if (((effect.id == _local_2.type) && (effect.item_string == _local_2.value)))
                {
                    _local_2.fulfilled = true;
                    gi.channels.REQUIREMENTS.requirementFullfilled(effect.type_string, effect.name_string);
                    break;
                };
            };
            if (_local_1.isFulfilled())
            {
                globalFlash.gui.mToolboxPanel.Refresh();
                globalFlash.gui.mAvatar.Refresh();
                globalFlash.gui.mChatPanel.Refresh();
            };
        }


    }
}
