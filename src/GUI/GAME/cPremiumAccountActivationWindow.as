package GUI.GAME
{
    import BuffSystem.cBuff;
    import Interface.cGameInterface;
    import GUI.Components.PremiumAccountActivationWindow;
    import Enums.COMMAND;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import Enums.BUFF_APPLIANCE_MODE;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import GUI.Assets.gAssetManager;

    public class cPremiumAccountActivationWindow extends cBasicPanel 
    {

        private var mPremiumBuff:cBuff;
        private var mGI:cGameInterface;
        protected var mPanel:PremiumAccountActivationWindow;


        public function AcceptPremiumAccount(_arg_1:MouseEvent):void
        {
            this.mGI.SendServerAction(COMMAND.APPLY_BUFF, 0, this.mGI.mCurrentPlayerZone.mStreetDataMap.GetMayorHouse().GetGrid(), 0, this.mPremiumBuff.GetUniqueId());
            this.mPremiumBuff.IncWaitingForServerCount(this.mGI);
            this.mGI.mCurrentCursor.mCurrentBuff = null;
            Hide();
        }

        public function SetPremiumBuff(_arg_1:cBuff):void
        {
            this.mPremiumBuff = _arg_1;
        }

        public function Init(_arg_1:PremiumAccountActivationWindow):void
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
            this.mPanel.btnAcceptPremium.addEventListener(MouseEvent.CLICK, this.AcceptPremiumAccount);
            this.mPanel.btnDeclinePremium.addEventListener(MouseEvent.CLICK, this.DeclinePremiumAccount);
        }

        public function DeclinePremiumAccount(_arg_1:MouseEvent):void
        {
            Hide();
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
        }

        override public function Show():void
        {
            this.mPanel.currentState = "collapsed";
            var _local_1:String = this.mPremiumBuff.GetBuffDefinition().getDuration(BUFF_APPLIANCE_MODE.PLAYER).toString();
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PremiumWindowTitle");
            this.mPanel.premiumDesc.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PremiumDesc");
            this.mPanel.premiumPackage.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PremiumPackageTime", [_local_1]);
            global.premiumAccount.GetLootBonus();
            this.mPanel.premiumBuffDesc.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PremiumBuffDesc", [global.premiumAccount.GetLootBonus().toString(), global.premiumAccount.GetXpBonus().toString(), global.premiumAccount.GetFriendZoneBuffTimeBonus().toString(), global.premiumAccount.GetPvpXpBonus().toString(), global.premiumAccount.GetVpBonus().toString()]);
            switch (_local_1)
            {
                case "1":
                    this.mPanel.duration.source = gAssetManager.PremiumAccountDays1;
                    break;
                case "3":
                    this.mPanel.duration.source = gAssetManager.PremiumAccountDays3;
                    break;
                case "7":
                    this.mPanel.duration.source = gAssetManager.PremiumAccountDays7;
                    break;
                case "30":
                    this.mPanel.duration.source = gAssetManager.PremiumAccountDays30;
                    break;
                case "180":
                    this.mPanel.duration.source = gAssetManager.PremiumAccountDays180;
                    break;
                case "360":
                    this.mPanel.duration.source = gAssetManager.PremiumAccountDays360;
                    break;
                default:
                    this.mPanel.duration.source = null;
            };
            super.Show();
            globalFlash.gui.windowController.setTop(this.mPanel, true);
        }


    }
}
