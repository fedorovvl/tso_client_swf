package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.TrackedMissionList;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import mx.events.FlexEvent;
    import mx.events.ResizeEvent;
    import GUI.Components.ItemRenderer.TrackedQuestItemRenderer;
    import Communication.VO.dQuestElementVO;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import AdventureSystem.cAdventureDefinition;
    import Tasks.Task;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import Colony.cColony;
    import GUI.Components.ItemRenderer.TrackedExpeditionItemRenderer;
    import GUI.Components.ItemRenderer.TrackedMissionItemRenderer;

    public class cTrackedMissionList extends cGuiBaseElement 
    {

        private var clickOffsetY:int;
        private var _itemRendererMap:Object = {};
        private var mGI:cGameInterface;
        protected var mPanel:TrackedMissionList;
        private var clickOffsetX:int;


        private function MouseDownHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.setConstraintValue("right", null);
            this.mPanel.setConstraintValue("left", null);
            this.mPanel.setConstraintValue("top", null);
            this.clickOffsetX = (_arg_1.target.x + _arg_1.localX);
            this.clickOffsetY = (_arg_1.target.y + _arg_1.localY);
            global.getApplication().addEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
            global.getApplication().stage.addEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
            global.getApplication().addEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
        }

        private function MouseUpHandler(_arg_1:Event):void
        {
            global.getApplication().removeEventListener(MouseEvent.MOUSE_UP, this.MouseUpHandler);
            global.getApplication().stage.removeEventListener(Event.MOUSE_LEAVE, this.MouseUpHandler);
            global.getApplication().removeEventListener(MouseEvent.MOUSE_MOVE, this.MouseMoveHandler);
        }

        public function get trackedCount():int
        {
            return (this.mPanel.list.numChildren);
        }

        public function Init(_arg_1:TrackedMissionList):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mPanel.topOrnamental.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler);
            this.mPanel.bottomOrnamental.addEventListener(MouseEvent.MOUSE_DOWN, this.MouseDownHandler);
            this.mPanel.addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
            global.getApplication().addEventListener(ResizeEvent.RESIZE, this.ResizeHandler);
        }

        private function MouseMoveHandler(_arg_1:MouseEvent):void
        {
            this.mPanel.x = (_arg_1.stageX - this.clickOffsetX);
            this.mPanel.y = (_arg_1.stageY - this.clickOffsetY);
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 0)
            {
                this.mPanel.y = 0;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > (global.getApplication().stage.stageHeight - this.mPanel.height))
            {
                this.mPanel.y = (global.getApplication().stage.stageHeight - this.mPanel.height);
            };
        }

        private function ResizeHandler(_arg_1:ResizeEvent):void
        {
            if (this.mPanel.x < 0)
            {
                this.mPanel.x = 0;
            };
            if (this.mPanel.y < 0)
            {
                this.mPanel.y = 0;
            };
            if (this.mPanel.x > (global.getApplication().stage.stageWidth - this.mPanel.width))
            {
                this.mPanel.x = (global.getApplication().stage.stageWidth - this.mPanel.width);
            };
            if (this.mPanel.y > (global.getApplication().stage.stageHeight - this.mPanel.height))
            {
                this.mPanel.y = (global.getApplication().stage.stageHeight - this.mPanel.height);
            };
        }

        public function Refresh():void
        {
            var _local_1:Object;
            var _local_2:TrackedQuestItemRenderer;
            var _local_5:dQuestElementVO;
            var _local_6:dAdventureClientInfoVO;
            var _local_7:String;
            var _local_8:cAdventureDefinition;
            var _local_9:Task;
            if (!this.mGI.mQuestClientCallbacks.GetClientQuestPool())
            {
                return;
            };
            var _local_3:Object = {};
            var _local_4:int;
            for each (_local_5 in this.mGI.mQuestClientCallbacks.GetClientQuestPool().mQuestVO_vector)
            {
                if (((((!(_local_5.mQuestDefinition == null)) && (_local_5.IsQuestModeAllowedForQuestList(this.mGI))) && ((_local_5.mQuestDefinition.showQuestWindow) || (_local_5.mQuestDefinition.showRewardWindow))) && (_local_5.mIsTrackedMission)))
                {
                    if (this._itemRendererMap[_local_5.getQuestName_string()])
                    {
                        _local_2 = this._itemRendererMap[_local_5.getQuestName_string()];
                    }
                    else
                    {
                        _local_2 = new TrackedQuestItemRenderer();
                        this._itemRendererMap[_local_5.getQuestName_string()] = _local_2;
                        this.mPanel.list.addChild(_local_2);
                    };
                    _local_2.data = _local_5;
                    _local_3[_local_5.getQuestName_string()] = _local_5;
                    _local_4++;
                };
            };
            for each (_local_6 in AdventureManager.getInstance().getAdventures())
            {
                if (((_local_6.isTrackedMission) && (((!(_local_6.colonyStatus == cColony.STATUS_ASSIGNED)) || (_local_6.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK)) || (_local_6.colonyStatus == cColony.STATUS_NPC_OWNED))))
                {
                    _local_8 = cAdventureDefinition.FindAdventureDefinition(_local_6.adventureName);
                    if (this._itemRendererMap[(_local_6.adventureName + _local_6.zoneID)])
                    {
                        _local_1 = this._itemRendererMap[(_local_6.adventureName + _local_6.zoneID)];
                    }
                    else
                    {
                        if (((_local_8.IsExpedition()) || (_local_8.IsColony())))
                        {
                            _local_1 = new TrackedExpeditionItemRenderer();
                            this._itemRendererMap[(_local_6.adventureName + _local_6.zoneID)] = _local_1;
                            this.mPanel.list.addChild((_local_1 as TrackedExpeditionItemRenderer));
                        }
                        else
                        {
                            _local_1 = new TrackedMissionItemRenderer();
                            this._itemRendererMap[(_local_6.adventureName + _local_6.zoneID)] = _local_1;
                            this.mPanel.list.addChild((_local_1 as TrackedMissionItemRenderer));
                        };
                    };
                    if (((_local_8.IsExpedition()) || (_local_8.IsColony())))
                    {
                        _local_1.data = {
                            "adventureVO":_local_6,
                            "state":"active"
                        };
                    }
                    else
                    {
                        _local_1.data = _local_6;
                    };
                    _local_3[(_local_6.adventureName + _local_6.zoneID)] = _local_6;
                    _local_4++;
                };
            };
            if (this.mGI.getCurrentTaskManager() != null)
            {
                for each (_local_9 in this.mGI.getCurrentTaskManager().getIdentities().valueSet())
                {
                    if (_local_9.isTracked)
                    {
                        if (this._itemRendererMap[_local_9.getDefinition().getName()])
                        {
                            _local_2 = this._itemRendererMap[_local_9.getDefinition().getName()];
                        }
                        else
                        {
                            _local_2 = new TrackedQuestItemRenderer();
                            this._itemRendererMap[_local_9.getDefinition().getName()] = _local_2;
                            this.mPanel.list.addChild(_local_2);
                        };
                        _local_2.data = _local_9;
                        _local_3[_local_9.getDefinition().getName()] = _local_9;
                        _local_4++;
                    };
                };
            };
            for (_local_7 in this._itemRendererMap)
            {
                if (!_local_3[_local_7])
                {
                    this.mPanel.list.removeChild(this._itemRendererMap[_local_7]);
                    delete this._itemRendererMap[_local_7];
                };
            };
            if (this.mPanel.list.numChildren > 0)
            {
                Show();
            }
            else
            {
                Hide();
            };
        }


    }
}
