package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public class AdjustGenericValue extends Effect 
    {

        public static const XML_string:String = "adjustgenericvalue";
        public static const ACTION_ADD:String = "add";
        public static const ACTION_SET:String = "set";
        public static const ACTION_RESET:String = "reset";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1.clone(), _arg_2);
        }

        override protected function action():void
        {
        }


    }
}
