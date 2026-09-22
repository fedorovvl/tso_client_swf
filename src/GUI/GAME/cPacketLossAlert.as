package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import GUI.Components.PacketLossAlert;
    import GUI.Components.CustomAlert;

    public class cPacketLossAlert extends cGuiBaseElement 
    {

        protected var mPanel:PacketLossAlert;
        private var mPopUp:CustomAlert;


        public function Init(_arg_1:PacketLossAlert):void
        {
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
        }

        override public function Hide():void
        {
            super.Hide();
            this.mPanel.busyAnim.visible = false;
        }

        override public function Show():void
        {
            super.Show();
            this.mPanel.busyAnim.visible = true;
        }


    }
}
