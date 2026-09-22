package Effects.Effects
{
    import Effects.Effect;
    import Communication.VO.dUniqueID;
    import Communication.VO.dGameTickCommandVO;
    import Communication.VO.EffectVO;
    import Interface.cGameInterface;

    public class ApplyLoottableBuff extends Effect 
    {

        public static const XML_string:String = "applyloottable";
        private static const dummy1:dUniqueID = null;
        private static const dummy2:dGameTickCommandVO = null;


        override public function init(_arg_1:EffectVO, _arg_2:cGameInterface):void
        {
            super.init(_arg_1, _arg_2);
        }

        override protected function action():void
        {
            globalFlash.gui.mMysteryBoxPanel.SetData(null);
            globalFlash.gui.mMysteryBoxPanel.Show();
        }


    }
}
