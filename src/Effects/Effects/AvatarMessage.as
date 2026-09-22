package Effects.Effects
{
    import Effects.Effect;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import Utils.StringUtils;
    import Enums.AVATAR_MESSAGE_TYPE;

    public final class AvatarMessage extends Effect 
    {

        public static const XML_string:String = "avatarmessage";

        private var timer:Timer = new Timer(1, 1);


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            this.timer.delay = (_arg_1.startDelay * 1000);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimer);
        }

        override protected function action():void
        {
            this.timer.start();
        }

        private function onTimer(_arg_1:TimerEvent):void
        {
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimer);
            if (StringUtils.isEmpty(effect.type_string))
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.EFFECT, [effect.action_string, effect.name_string, effect.item_string]);
            }
            else
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(effect.type_string);
            };
        }


    }
}
