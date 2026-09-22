package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import GUI.Components.ActionBar;
    import flash.events.MouseEvent;
    import Tracks.TrackManager;
    import mx.events.FlexEvent;
    import Communication.VO.dRequirementVO;
    import Interface.cGameInterface;
    import Communication.VO.dRequirementsVO;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class cGameActionBar extends cGuiBaseElement 
    {

        private var mFriendsListVisible:Boolean = true;
        private var mActionBar:ActionBar;


        public function ShowStarAnim():void
        {
            this.mActionBar.actionBarCenter.animStar.visible = true;
        }

        private function ToggleFriendsListClickHandler(_arg_1:MouseEvent):void
        {
            cSettingsManager.getInstance().friendsListVisible = (!(cSettingsManager.getInstance().friendsListVisible));
            cSettingsManager.getInstance().saveToServer();
        }

        public function HideStarAnim():void
        {
            this.mActionBar.actionBarCenter.animStar.visible = false;
        }

        public function ToggleFriendsList():void
        {
            TrackManager.getInstance().trackUI(global.ui.mCurrentPlayer.GetPlayerId(), "Friend List", ((cSettingsManager.getInstance().friendsListVisible) ? "visible" : "hiden"), 0, false);
            this.mFriendsListVisible = cSettingsManager.getInstance().friendsListVisible;
            this.RefreshFriendsList();
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mActionBar.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mActionBar.actionBarLeft.btnActionBar01.addEventListener(MouseEvent.CLICK, globalFlash.gui.ToggleToolbox, false, 0, true);
            this.mActionBar.actionBarLeft.btnActionBar02.addEventListener(MouseEvent.CLICK, globalFlash.gui.ToggleEconomyWindow, false, 0, true);
            this.mActionBar.actionBarLeft.btnActionBar03.addEventListener(MouseEvent.CLICK, globalFlash.gui.ToggleTradeWindow, false, 0, true);
            this.mActionBar.actionBarLeft.btnActionBar09.addEventListener(MouseEvent.CLICK, this.rankingsClickHandler, false, 0, true);
            this.mActionBar.actionBarCenter.btnActionBar04.addEventListener(MouseEvent.CLICK, globalFlash.gui.ToggleStarMenu, false, 0, true);
            this.mActionBar.actionBarCenter.toggleFrindsList.addEventListener(MouseEvent.CLICK, this.ToggleFriendsListClickHandler, false, 0, true);
            this.mActionBar.actionBarRight.btnActionBar05.addEventListener(MouseEvent.CLICK, globalFlash.gui.ToggleGuildWindow, false, 0, true);
            this.mActionBar.actionBarRight.btnActionBar06.addEventListener(MouseEvent.CLICK, globalFlash.gui.ToggleMailWindow, false, 0, true);
            this.mActionBar.actionBarRight.btnActionBarColony.addEventListener(MouseEvent.CLICK, globalFlash.gui.ToggleColonyWindow, false, 0, true);
            this.mActionBar.actionBarRight.btnActionBar07.addEventListener(MouseEvent.CLICK, globalFlash.gui.ToggleShop, false, 0, true);
            this.RefreshFriendsList();
        }

        public function Init(_arg_1:ActionBar):void
        {
            AddBaseElement(_arg_1);
            this.mActionBar = _arg_1;
            this.mActionBar.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler, false, 0, true);
        }

        public function showFriendList():void
        {
            this.mFriendsListVisible = true;
            this.ToggleFriendsList();
        }

        private function RefreshFriendsList():void
        {
            if (!this.mFriendsListVisible)
            {
                global.getApplication().GAMESTATE_ID_ACTIONBAR.setConstraintValue("bottom", 0);
                global.getApplication().blueFireComponent.setConstraintValue("bottom", 0);
                globalFlash.mainHudBottomPos = 89;
            }
            else
            {
                global.getApplication().GAMESTATE_ID_ACTIONBAR.setConstraintValue("bottom", 91);
                global.getApplication().blueFireComponent.setConstraintValue("bottom", 91);
                globalFlash.mainHudBottomPos = 180;
            };
        }

        public function Refresh():void
        {
            var _local_2:dRequirementVO;
            var _local_1:dRequirementsVO = (global.ui as cGameInterface).mRequirements.miscRequirements_vector["ColonySlots"];
            for each (_local_2 in _local_1.requirements)
            {
                if (_local_2.fulfilled)
                {
                    this.mActionBar.actionBarRight.btnActionBarColony.enabled = true;
                    break;
                };
                this.mActionBar.actionBarRight.btnActionBarColony.enabled = false;
                break;
            };
        }

        public function hideFriendList():void
        {
            this.mFriendsListVisible = false;
            this.ToggleFriendsList();
        }

        private function rankingsClickHandler(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest((global.baseUri + defines.RANKINGS_URL)), "_blank");
            global.ui.mQuestClientCallbacks.InitiateWindowOpen("Rankings");
            global.getApplication().inputNotifier.notifyClick("Rankings");
        }


    }
}
