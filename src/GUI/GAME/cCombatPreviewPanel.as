package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.CombatPreviewPanel;
    import GUI.Assets.gAssetManager;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import ServerState.cResourceCreation;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import Enums.COMMAND;

    public class cCombatPreviewPanel extends cBasicPanel 
    {

        private var mShowGeneralHint:Boolean;
        private var mGI:cGameInterface;
        protected var mPanel:CombatPreviewPanel;


        public function SetData(_arg_1:String, _arg_2:String="", _arg_3:int=1):void
        {
            this.mPanel.close.visible = true;
            switch (_arg_1)
            {
                case "CombatPreview_Fail":
                    this.mPanel.currentState = this.mPanel.stateFeedBack.name;
                    this.mPanel.header.styleName = "detailsHeaderRed";
                    this.mPanel.generalImage.source = gAssetManager.GetBitmap(_arg_1);
                    this.mPanel.perfectTitle.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _arg_1);
                    this.mPanel.perfectDescription.htmlText = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _arg_1);
                    this.mPanel.generalDistracted.visible = this.mShowGeneralHint;
                    return;
                case "CombatPreview_Bad":
                    this.mPanel.currentState = this.mPanel.stateFeedBack.name;
                    this.mPanel.header.styleName = "detailsHeaderOrange";
                    this.mPanel.generalImage.source = gAssetManager.GetBitmap(_arg_1);
                    this.mPanel.perfectTitle.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _arg_1);
                    this.mPanel.perfectDescription.htmlText = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _arg_1);
                    this.mPanel.generalDistracted.visible = this.mShowGeneralHint;
                    return;
                case "CombatPreview_Ok":
                    this.mPanel.currentState = this.mPanel.stateFeedBack.name;
                    this.mPanel.header.styleName = "detailsHeaderLightGreen";
                    this.mPanel.generalImage.source = gAssetManager.GetBitmap(_arg_1);
                    this.mPanel.perfectTitle.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _arg_1);
                    this.mPanel.perfectDescription.htmlText = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _arg_1);
                    this.mPanel.generalDistracted.visible = this.mShowGeneralHint;
                    return;
                case "CombatPreview_Perfect":
                    this.mPanel.currentState = this.mPanel.stateFeedBack.name;
                    this.mPanel.header.styleName = "detailsHeaderGreen";
                    this.mPanel.generalImage.source = gAssetManager.GetBitmap(_arg_1);
                    this.mPanel.perfectTitle.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _arg_1);
                    this.mPanel.perfectDescription.htmlText = cLocaManager.GetInstance().GetText(LOCA_GROUP.DESCRIPTIONS, _arg_1);
                    this.mPanel.generalDistracted.visible = this.mShowGeneralHint;
                    return;
                case "IdleState":
                    this.mPanel.currentState = this.mPanel.stateIdle.name;
                    this.mPanel.glassAnim.visible = true;
                    return;
                case "SpecialState":
                    this.mPanel.currentState = this.mPanel.stateSpecial.name;
                    this.mPanel.specialDescription.htmlText = cLocaManager.GetInstance().GetText(LOCA_GROUP.PRE_COMBAT_DESCRIPTIONS, _arg_2);
                    this.mPanel.generalDistractedSpecial.visible = this.mShowGeneralHint;
                    if (_arg_3 == cResourceCreation.DIFFICULT_BANDIT_STATE)
                    {
                        this.mPanel.specialFeedbackIcon.source = gAssetManager.GetBitmap("IconSkullWithBG");
                    }
                    else
                    {
                        if (_arg_3 == cResourceCreation.DIFFICULT_LEADER_BANDIT_STATE)
                        {
                            this.mPanel.specialFeedbackIcon.source = gAssetManager.GetBitmap("IconSkullWithCrown");
                        }
                        else
                        {
                            this.mPanel.specialFeedbackIcon.source = gAssetManager.GetBitmap("IconSkullWithBG");
                        };
                    };
                    return;
            };
        }

        public function SetGeneralInterception(_arg_1:Boolean):void
        {
            this.mShowGeneralHint = _arg_1;
        }

        public function Init(_arg_1:CombatPreviewPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.close.addEventListener(MouseEvent.CLICK, this.ClosePanel);
            this.mPanel.btnOK.addEventListener(MouseEvent.CLICK, this.ClosePanel);
        }

        private function ClosePanel(_arg_1:MouseEvent):void
        {
            this.Hide();
            if (this.mGI.mCurrentCursor.mCurrentSpecialist != null)
            {
                this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.GET_COMBAT_PREVIEW);
            };
        }


    }
}
