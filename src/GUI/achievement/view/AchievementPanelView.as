package GUI.achievement.view
{
    import GUI.achievement.interfaces.IAchievementView;
    import Utils.Disposable;
    import GUI.Components.AchievementPanelViewComponent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Achievements.AchievementConsts;
    import GUI.ApplicationFacade;
    import flash.events.MouseEvent;
    import GUI.helpers.UIComponentHelpers;

    public class AchievementPanelView implements IAchievementView, Disposable 
    {

        private var panel:AchievementPanelViewComponent;

        public function AchievementPanelView(_arg_1:AchievementPanelViewComponent)
        {
            super();
            this.panel = _arg_1;
            this.initPanelComponents();
        }

        public function hide():void
        {
            this.removeListeners();
        }

        public function dispose():void
        {
            this.removeListeners();
            this.panel = null;
        }

        private function initPanelComponents():void
        {
            this.panel.btnClosePanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, AchievementConsts.CLOSE_ACHIEVEMENT_PANEL_LABEL_ID);
            this.panel.headline.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, AchievementConsts.ACHIEVEMENT_LABEL_ID);
        }

        public function show():void
        {
            this.addListeners();
        }

        private function handleCloseClick(_arg_1:MouseEvent):void
        {
            ApplicationFacade.getInstance().sendNotification(AchievementConsts.SHOW_HIDE_ACHIEVEMENT_PANEL);
        }

        private function removeListeners():void
        {
            this.panel.btnClose.removeEventListener(MouseEvent.CLICK, this.handleCloseClick);
            this.panel.btnClosePanel.removeEventListener(MouseEvent.CLICK, this.handleCloseClick);
            UIComponentHelpers.removeMouseInteraction(this.panel);
        }

        private function addListeners():void
        {
            UIComponentHelpers.enableMouseInteractionForList(this.panel.btnClose, this.panel.btnClosePanel, this.panel.detailViewContentContainer);
            this.panel.btnClose.addEventListener(MouseEvent.CLICK, this.handleCloseClick, false, 0, true);
            this.panel.btnClosePanel.addEventListener(MouseEvent.CLICK, this.handleCloseClick, false, 0, true);
        }


    }
}
