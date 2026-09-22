package GUI.GAME
{
    import GUI.Components.GuildBankTransactionHistory;
    import Interface.cGameInterface;
    import mx.events.FlexEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import mx.collections.ArrayCollection;

    public class cGuildBankTransactionHistory extends cBasicPanel 
    {

        protected var mPanel:GuildBankTransactionHistory;
        private var mGI:cGameInterface;


        public function Init(_arg_1:GuildBankTransactionHistory):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "GuildBankTransactionHistory");
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnCancel.addEventListener(MouseEvent.CLICK, this.Back);
        }

        private function ClosePanel(_arg_1:Event):void
        {
            this.Hide();
        }

        private function Back(_arg_1:Event):void
        {
            this.Hide();
            globalFlash.gui.mGuildBankWindow.Show();
        }

        public function SetData(_arg_1:ArrayCollection):void
        {
            this.mPanel.transactionList.dataProvider = _arg_1;
        }


    }
}
