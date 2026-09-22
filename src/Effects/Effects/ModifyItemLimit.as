package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Enums.ITEM_CONTENT_TYPE;

    public class ModifyItemLimit extends Effect 
    {

        public static const XML_string:String = "modifyitemlimit";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            gi.mItemRegistry.RegisterItem(ITEM_CONTENT_TYPE.parse(effect.type_string), effect.name_string, effect.target_string, effect.value);
        }


    }
}
