package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public final class ControlShopItem extends Effect 
    {

        public static const XML_string:String = "shopitem";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            if (effect.type_string.toLowerCase() == "enable")
            {
                if (!gi.mSpecificShopItems)
                {
                    gi.DisableAllShopItems();
                };
                if (effect.id > 0)
                {
                    gi.EnableShopItem(effect.id);
                };
            }
            else
            {
                gi.ReDisableShopItem(effect.id);
            };
        }


    }
}
