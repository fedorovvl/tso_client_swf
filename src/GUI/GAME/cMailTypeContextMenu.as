package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Enums.MAIL_TYPE_GROUP;
    import GUI.Components.MailTypeContextMenu;
    import mx.collections.ArrayCollection;
    import GUI.Components.ItemRenderer.MailTypeFilterItemRendererData;
    import Communication.VO.Mail.dMailVO;
    import flash.utils.Dictionary;
    import com.bluebyte.tso.util.ViewUtils;
    import mx.events.ResizeEvent;
    import __AS3__.vec.Vector;
    import flash.events.MouseEvent;
    import com.bluebyte.tso.util.DisplayObjectUtils;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.events.Event;
    import GUI.Components.ItemRenderer.MailTypeFilterItemRenderer;
    import __AS3__.vec.*;

    public class cMailTypeContextMenu extends cGuiBaseElement 
    {

        private static const LIST_MAIL_GROUPS:Array = [MAIL_TYPE_GROUP.MAIL_READ, MAIL_TYPE_GROUP.BUFF, MAIL_TYPE_GROUP.BATTLE_REPORT, MAIL_TYPE_GROUP.LOOT, MAIL_TYPE_GROUP.ADVENTURE, MAIL_TYPE_GROUP.NPC, MAIL_TYPE_GROUP.FRIEND, MAIL_TYPE_GROUP.GIFT, MAIL_TYPE_GROUP.GUILD, MAIL_TYPE_GROUP.HARD_CURRENCY, MAIL_TYPE_GROUP.TRADE, MAIL_TYPE_GROUP.MAIL_UNREAD];

        private var mContextMenu:MailTypeContextMenu;
        private var dataProvider:ArrayCollection;


        public function updateAvailableTypes(_arg_1:ArrayCollection):void
        {
            var _local_3:MailTypeFilterItemRendererData;
            var _local_4:dMailVO;
            var _local_5:int;
            var _local_2:Dictionary = new Dictionary();
            for each (_local_3 in this.dataProvider)
            {
                _local_2[_local_3.mailGroup] = _local_3;
                _local_3.disabled = true;
                _local_3.selected = false;
            };
            for each (_local_4 in _arg_1)
            {
                _local_5 = MAIL_TYPE_GROUP.getMailGroup(_local_4.type, _local_4.read);
                if ((_local_5 in _local_2))
                {
                    _local_2[_local_5].disabled = false;
                };
            };
        }

        public function updateSelection(_arg_1:ArrayCollection, _arg_2:Dictionary):void
        {
            var _local_5:MailTypeFilterItemRendererData;
            var _local_6:dMailVO;
            var _local_7:int;
            var _local_3:Dictionary = new Dictionary();
            var _local_4:int;
            for each (_local_5 in this.dataProvider)
            {
                if (!_local_5.disabled)
                {
                    _local_3[_local_5.mailGroup] = _local_5;
                    _local_5.selected = true;
                    _local_4++;
                };
            };
            for each (_local_6 in _arg_1)
            {
                _local_7 = MAIL_TYPE_GROUP.getMailGroup(_local_6.type, _local_6.read);
                if ((((_local_7 in _local_3) && (_local_3[_local_7].selected)) && (!(_local_6.id in _arg_2))))
                {
                    _local_3[_local_7].selected = false;
                    delete _local_3[_local_7];
                    if (--_local_4 == 0) break;
                };
            };
        }

        private function createItems():void
        {
            var _local_1:int = LIST_MAIL_GROUPS.length;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this.dataProvider.addItem(new MailTypeFilterItemRendererData(false, false, LIST_MAIL_GROUPS[_local_2]));
                _local_2++;
            };
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            ViewUtils.keepInsideScreen(this.mContextMenu);
        }

        public function get selectedMailGroups():Vector.<int>
        {
            var _local_2:MailTypeFilterItemRendererData;
            var _local_1:Vector.<int> = new Vector.<int>();
            for each (_local_2 in this.dataProvider)
            {
                if (_local_2.selected)
                {
                    _local_1.push(_local_2.mailGroup);
                };
            };
            return (_local_1);
        }

        public function selectAll():void
        {
            var _local_1:MailTypeFilterItemRendererData;
            this.selectedMailGroups.length = 0;
            for each (_local_1 in this.dataProvider)
            {
                if (!_local_1.disabled)
                {
                    _local_1.selected = true;
                    this.selectedMailGroups.push(_local_1.mailGroup);
                };
            };
        }

        public function HideMenu():void
        {
            this.mContextMenu.stage.removeEventListener(MouseEvent.CLICK, this.onStageClick);
            this.Hide();
        }

        private function onStageClick(_arg_1:MouseEvent):void
        {
            if (DisplayObjectUtils.findAncestor((_arg_1.target as DisplayObject), this.mContextMenu) == this.mContextMenu)
            {
                return;
            };
            this.HideMenu();
        }

        override public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this.mContextMenu.removeEventListener(_arg_1, _arg_2, _arg_3);
        }

        public function deselectAll():void
        {
            var _local_1:MailTypeFilterItemRendererData;
            for each (_local_1 in this.dataProvider)
            {
                _local_1.selected = false;
            };
            this.selectedMailGroups.length = 0;
        }

        override public function Show():void
        {
            this.mContextMenu.stage.addEventListener(MouseEvent.CLICK, this.onStageClick);
            super.Show();
            this.ResizeHandler(null);
        }

        override public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            this.mContextMenu.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function Init(_arg_1:MailTypeContextMenu, _arg_2:DisplayObjectContainer, _arg_3:Point):void
        {
            this.dataProvider = new ArrayCollection();
            this.mContextMenu = _arg_1;
            this.mContextMenu.setVisible(false, true);
            this.mContextMenu.dataProvider = this.dataProvider;
            _arg_2.addChild(this.mContextMenu);
            this.mContextMenu.x = _arg_3.x;
            this.mContextMenu.y = _arg_3.y;
            AddBaseElement(_arg_1);
            this.mContextMenu.addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
            this.createItems();
        }

        public function Move(_arg_1:int, _arg_2:int):void
        {
            this.mContextMenu.x = _arg_1;
            this.mContextMenu.y = _arg_2;
        }

        public function selectOrDeselectAll(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.selectAll();
            }
            else
            {
                this.deselectAll();
            };
            this.mContextMenu.dispatchEvent(new Event(MailTypeFilterItemRenderer.CHANGED));
        }

        public function toggle():void
        {
            if (IsVisible())
            {
                this.HideMenu();
            }
            else
            {
                this.Show();
            };
        }


    }
}
