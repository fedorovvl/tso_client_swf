package GUI.GAME
{
    import GUI.Components.SplashScreen;

    public class cSplashScreen extends cBasicPanel 
    {

        private var mPanel:SplashScreen;


        public function Init(_arg_1:SplashScreen):void
        {
            this.mPanel = _arg_1;
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
        }


    }
}
