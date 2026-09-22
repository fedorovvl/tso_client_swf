package Model.Observers
{
    import Model.Observer;
    import Interface.cGameInterface;
    import GUI.Effects.gHintManager;
    import Model.Notifier;

    public class PvPLevelObserver implements Observer 
    {

        private var mGI:cGameInterface;

        public function PvPLevelObserver(_arg_1:cGameInterface)
        {
            super();
            this.mGI = _arg_1;
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            globalFlash.gui.mAvatar.Refresh();
            globalFlash.gui.mPvPProgressionPanel.Update();
            gHintManager.ShowPvPLevelUpNotification();
        }


    }
}
