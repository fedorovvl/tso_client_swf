package GUI.GAME
{
    import Interface.cGameInterface;
    import GUI.Components.BlockList;
    import mx.events.ListEvent;
    import Enums.COMMAND;
    import flash.events.MouseEvent;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Communication.VO.dContextItemVO;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class cBlockList extends cBasicPanel 
    {

        private var mContextMenu:cBlockListContextMenu;
        private var blockedList:Array;
        private var mGI:cGameInterface;
        protected var mPanel:BlockList;


        private function ShowContextMenu(_arg_1:ListEvent):void
        {
            this.mContextMenu.Move(this.mPanel.stage.mouseX, this.mPanel.stage.mouseY);
            _arg_1.stopPropagation();
            this.mContextMenu.Show();
        }

        public function SetBlockList(_arg_1:Array):void
        {
            this.blockedList = _arg_1;
            this.mPanel.blockListGrid.dataProvider = _arg_1;
        }

        private function UnblockSender(_arg_1:MouseEvent):void
        {
            var _local_2:String = this.mPanel.blockListGrid.selectedItem.username;
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.UNBLOCK_SENDER, this.mGI.mCurrentViewedZoneID, _local_2);
            this.mGI.mClientMessages.SendMessagetoServer(COMMAND.GET_BLOCK_LIST, 0, null);
            this.mContextMenu.Hide();
        }

        public function GetMPanel():BlockList
        {
            return (this.mPanel);
        }

        public function Init(_arg_1:BlockList):void
        {
            this.mGI = (global.ui as cGameInterface);
            globalFlash.gui.windowController.addWindow(_arg_1);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.label = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "BlockList");
            this.mPanel.btnClose.addEventListener(MouseEvent.CLICK, this.Close);
            this.mPanel.blockListGrid.addEventListener(ListEvent.ITEM_CLICK, this.ShowContextMenu, false, 1);
            this.mPanel.blockListGrid.addEventListener(MouseEvent.CLICK, this.MoveContextMenu, false, 2);
            this.mContextMenu = new cBlockListContextMenu();
            this.mContextMenu.Init(global.getApplication().GAMESTATE_ID_BLOCK_LIST_MENU);
            var _local_2:Vector.<dContextItemVO> = new Vector.<dContextItemVO>();
            _local_2.push(new dContextItemVO("UnblockSender", this.UnblockSender, true));
            this.mContextMenu.SetContextMenu(_local_2);
        }

        override public function Hide():void
        {
            this.mContextMenu.Hide();
            super.Hide();
        }

        public function GetBlockList():Array
        {
            return (this.blockedList);
        }

        public function Close(_arg_1:MouseEvent):void
        {
            this.Hide();
            globalFlash.gui.mMailWindow.Show();
        }

        private function MoveContextMenu(_arg_1:MouseEvent):void
        {
            this.mContextMenu.Hide();
        }


    }
}
