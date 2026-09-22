package Model.Observers
{
    import Model.Observer;
    import Interface.cGameInterface;
    import Model.Notifier;

    public class LevelUpObserver implements Observer 
    {

        private var mGI:cGameInterface;

        public function LevelUpObserver(_arg_1:cGameInterface)
        {
            super();
            this.mGI = _arg_1;
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            globalFlash.gui.mLevelUpWindow.SetData((_arg_3 as int));
            globalFlash.gui.mActionBar.Refresh();
            globalFlash.gui.mLevelUpWindow.Show();
        }


    }
}
