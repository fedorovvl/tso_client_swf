package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.CancelActionPanel;
    import com.bluebyte.tso.util.HotkeyManager;
    import mx.events.FlexEvent;
    import flash.events.MouseEvent;
    import Enums.COMMAND;

    public class cCancelActionPanel extends cGuiBaseElement 
    {

        private var mGI:cGameInterface;
        protected var mPanel:CancelActionPanel;


        override public function Hide():void
        {
            mUiElement.y = (global.getApplication().GAMESTATE_ID_ACTIONBAR.y + ((globalFlash.gui.mCancelActionPanel.IsVisible()) ? -35 : 85));
            HotkeyManager.getInstance().clearConfirmActions();
            super.Hide();
        }

        public function Init(_arg_1:CancelActionPanel):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.cancel.addEventListener(MouseEvent.CLICK, this.CancelAction);
        }

        override public function Show():void
        {
            mUiElement.y = (global.getApplication().GAMESTATE_ID_ACTIONBAR.y + ((globalFlash.gui.mCancelActionPanel.IsVisible()) ? -35 : 85));
            HotkeyManager.getInstance().setConfirmActions(null, this.CancelAction);
            super.Show();
        }

        public function CancelAction(_arg_1:MouseEvent=null):void
        {
            if (((!(this.mGI.mCurrentCursor.mCurrentBuilding == null)) && (!(this.mGI.mCurrentCursor.mCurrentBuilding.productionQueue == null))))
            {
                this.mGI.mCurrentPlayerZone.setProductionQueue(this.mGI.mCurrentCursor.mCurrentBuilding.productionQueue);
                this.mGI.mCurrentCursor.mCurrentBuilding.productionQueue.productionBuilding = this.mGI.mCurrentCursor.mCurrentBuilding;
            };
            this.mGI.mCurrentCursor.SetCursorEditMode(COMMAND.SELECT_BUILDING);
        }


    }
}
