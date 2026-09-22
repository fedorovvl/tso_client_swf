package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import GUI.Components.SupportLockZone;
    import GUI.Loca.cLocaManager;
    import GUI.Components.CustomAlert;
    import Enums.LOCA_GROUP;
    import mx.controls.Alert;

    public class cSupportLockZone extends cGuiBaseElement 
    {

        protected var mPanel:SupportLockZone;
        private var lockTime:Number;


        override public function Hide():void
        {
            super.Hide();
        }

        public function Init(_arg_1:SupportLockZone):void
        {
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
        }

        public function setMilliseconds(_arg_1:Number):void
        {
            this.lockTime = _arg_1;
        }

        override public function Show():void
        {
            var _local_1:String = cLocaManager.GetInstance().FormatDuration(this.lockTime, cLocaManager.DURATION_FORMAT_NORMAL);
            if (!IsVisible())
            {
                CustomAlert.show(cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "SupportTempLockZone", [_local_1]), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "SupportTempLockZone"), Alert.OK, null, null, null, Alert.OK, false);
                super.Show();
            };
            this.mPanel.message.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, "SupportTempLockZone", [_local_1]);
        }


    }
}
