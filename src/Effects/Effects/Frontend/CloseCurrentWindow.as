package Effects.Effects.Frontend
{
    import Effects.Effect;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;
    import GUI.GAME.cBasicPanel;

    public final class CloseCurrentWindow extends Effect 
    {

        public static const XML_string:String = "closecurrentwindow";


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
            applyAsGameTick = false;
        }

        override protected function action():void
        {
            cBasicPanel.HideCurrentActivePanel();
        }


    }
}
