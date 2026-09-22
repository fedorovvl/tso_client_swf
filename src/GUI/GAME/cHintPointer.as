package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Effects.BounceMove;
    import flash.display.DisplayObject;
    import GUI.Components.HintPointer;
    import com.bluebyte.tso.quests.logic.QuestHint;
    import Enums.HINT_TYPE;
    import flash.events.Event;
    import flash.geom.Point;
    import GUI.Effects.gGlowManager;
    import mx.controls.buttonBarClasses.ButtonBarButton;
    import mx.events.ItemClickEvent;
    import flash.events.MouseEvent;
    import mx.effects.easing.Cubic;
    import mx.events.FlexEvent;
    import GUI.Effects.gHintManager;

    public class cHintPointer extends cGuiBaseElement 
    {

        private const BOUNCE_SIZE:int = 20;
        private const BOUNCE_DURATION:int = 300;

        private var mGI:cGameInterface;
        private var mBounce:BounceMove;
        private var mPointToX:int;
        private var mPointToY:int;
        private var mTarget:DisplayObject;
        private var mPanel:HintPointer;
        private var mActiveHint:QuestHint;


        private function SetPointerType(_arg_1:int):void
        {
            switch (_arg_1)
            {
                case HINT_TYPE.NORTH:
                    this.mPanel.currentState = "N";
                    break;
                case HINT_TYPE.NORTH_EAST:
                    this.mPanel.currentState = "NE";
                    break;
                case HINT_TYPE.EAST:
                    this.mPanel.currentState = "E";
                    break;
                case HINT_TYPE.SOUTH_EAST:
                    this.mPanel.currentState = "SE";
                    break;
                case HINT_TYPE.SOUTH:
                    this.mPanel.currentState = "S";
                    break;
                case HINT_TYPE.SOUTH_WEST:
                    this.mPanel.currentState = "SW";
                    break;
                case HINT_TYPE.WEST:
                    this.mPanel.currentState = "W";
                    break;
                case HINT_TYPE.NORTH_WEST:
                    this.mPanel.currentState = "NW";
                    break;
                case HINT_TYPE.NEW_QUEST:
                    this.mPanel.currentState = "NewQuest";
                    break;
                case HINT_TYPE.COMPLETED_QUEST:
                    this.mPanel.currentState = "CompletedQuest";
                    break;
                case HINT_TYPE.CALENDAR_OPENABLE:
                    this.mPanel.currentState = "CalendarOpenable";
                    break;
                case HINT_TYPE.FAILED_QUEST:
                    this.mPanel.currentState = "FailedQuest";
                    break;
                case HINT_TYPE.PVP_LEVEL_UP:
                    this.mPanel.currentState = "PvPLevelReached";
                    break;
            };
            this.mPanel.validateNow();
            switch (_arg_1)
            {
                case HINT_TYPE.NORTH:
                    this.mPanel.x = (this.mPointToX - (this.mPanel.width / 2));
                    this.mPanel.y = this.mPointToY;
                    this.BouncePointer(-1, 0, this.BOUNCE_SIZE);
                    return;
                case HINT_TYPE.NORTH_EAST:
                    this.mPanel.x = (this.mPointToX - this.mPanel.width);
                    this.mPanel.y = this.mPointToY;
                    this.BouncePointer(-1, -(this.BOUNCE_SIZE), this.BOUNCE_SIZE);
                    return;
                case HINT_TYPE.EAST:
                    this.mPanel.x = (this.mPointToX - this.mPanel.width);
                    this.mPanel.y = (this.mPointToY - (this.mPanel.measuredHeight / 2));
                    this.BouncePointer(-1, -(this.BOUNCE_SIZE), 0);
                    return;
                case HINT_TYPE.SOUTH_EAST:
                    this.mPanel.x = (this.mPointToX - this.mPanel.width);
                    this.mPanel.y = (this.mPointToY - this.mPanel.measuredHeight);
                    this.BouncePointer(-1, -(this.BOUNCE_SIZE), -(this.BOUNCE_SIZE));
                    return;
                case HINT_TYPE.SOUTH:
                    this.mPanel.x = (this.mPointToX - (this.mPanel.width / 2));
                    this.mPanel.y = (this.mPointToY - this.mPanel.measuredHeight);
                    this.BouncePointer(-1, 0, -(this.BOUNCE_SIZE));
                    return;
                case HINT_TYPE.SOUTH_WEST:
                    this.mPanel.x = this.mPointToX;
                    this.mPanel.y = (this.mPointToY - this.mPanel.measuredHeight);
                    this.BouncePointer(-1, this.BOUNCE_SIZE, -(this.BOUNCE_SIZE));
                    return;
                case HINT_TYPE.WEST:
                case HINT_TYPE.NEW_QUEST:
                case HINT_TYPE.COMPLETED_QUEST:
                case HINT_TYPE.FAILED_QUEST:
                case HINT_TYPE.CALENDAR_OPENABLE:
                    this.mPanel.x = this.mPointToX;
                    this.mPanel.y = (this.mPointToY - (this.mPanel.measuredHeight / 2));
                    this.BouncePointer(-1, this.BOUNCE_SIZE, 0);
                    return;
                case HINT_TYPE.PVP_LEVEL_UP:
                    this.mPanel.x = (this.mPointToX + 20);
                    this.mPanel.y = (this.mPointToY - (this.mPanel.measuredHeight / 2));
                    this.BouncePointer(-1, this.BOUNCE_SIZE, 0);
                    return;
                case HINT_TYPE.NORTH_WEST:
                    this.mPanel.x = this.mPointToX;
                    this.mPanel.y = this.mPointToY;
                    this.BouncePointer(-1, this.BOUNCE_SIZE, this.BOUNCE_SIZE);
                    return;
            };
        }

        public function StopBouncing():void
        {
            global.getApplication().stage.removeEventListener(Event.RESIZE, this.RepositionPointer);
            this.mBounce.end();
            this.mBounce = null;
        }

        private function PointTo(_arg_1:DisplayObject, _arg_2:int, _arg_3:int):void
        {
            var _local_4:Point;
            this.mTarget = _arg_1;
            if (this.mActiveHint.mType == HINT_TYPE.GLOW)
            {
                gGlowManager.addElement(_arg_1);
            }
            else
            {
                _local_4 = _arg_1.localToGlobal(new Point(_arg_2, _arg_3));
                this.mPointToX = (_local_4.x + (_arg_1.width / 2));
                this.mPointToY = (_local_4.y + (_arg_1.height / 2));
                Show();
            };
        }

        public function SetData(_arg_1:QuestHint):void
        {
            this.mActiveHint = _arg_1;
            if (_arg_1.mType != HINT_TYPE.GLOW)
            {
                global.getApplication().stage.addEventListener(Event.RESIZE, this.RepositionPointer);
            };
            this.PointTo(global.getApplication().getGUIItem(_arg_1.mPointTo), _arg_1.mOffsetX, _arg_1.mOffsetY);
            this.mPanel.currentState = "";
            this.SetPointerType(_arg_1.mType);
            if ((this.mTarget is ButtonBarButton))
            {
                this.mTarget.parent.addEventListener(ItemClickEvent.ITEM_CLICK, this.HintCompleted);
            }
            else
            {
                this.mTarget.addEventListener(MouseEvent.CLICK, this.HintCompleted);
            };
        }

        public function BouncePointer(_arg_1:int, _arg_2:Number, _arg_3:Number):void
        {
            if (this.mBounce == null)
            {
                this.mBounce = new BounceMove(this.mPanel.actualPointer);
                this.mBounce.easingFunction = Cubic.easeOut;
                this.mBounce.duration = this.BOUNCE_DURATION;
            };
            this.mBounce.xFrom = 0;
            this.mBounce.yFrom = 0;
            this.mBounce.xTo = _arg_2;
            this.mBounce.yTo = _arg_3;
            this.mBounce.bounceCount = _arg_1;
            if (this.mBounce.ended)
            {
                this.mBounce.play();
            };
        }

        private function completeHandler(_arg_1:FlexEvent):void
        {
            this.mPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        public function GetGUIElement():HintPointer
        {
            return (this.mPanel);
        }

        private function RepositionPointer(_arg_1:Event):void
        {
            this.mPanel.currentState = "";
            this.PointTo(this.mTarget, this.mActiveHint.mOffsetX, this.mActiveHint.mOffsetY);
            this.SetPointerType(this.mActiveHint.mType);
        }

        override public function Hide():void
        {
            if (this.mActiveHint.mType == HINT_TYPE.GLOW)
            {
                gGlowManager.removeElement(this.mTarget);
            }
            else
            {
                if (this.mBounce != null)
                {
                    this.StopBouncing();
                };
            };
            if ((this.mTarget is ButtonBarButton))
            {
                this.mTarget.parent.removeEventListener(ItemClickEvent.ITEM_CLICK, this.HintCompleted);
            }
            else
            {
                this.mTarget.removeEventListener(MouseEvent.CLICK, this.HintCompleted);
            };
            super.Hide();
            gHintManager.HideHint(this);
        }

        private function HintCompleted(_arg_1:Event):void
        {
            if ((this.mTarget is ButtonBarButton))
            {
                if ((_arg_1 as ItemClickEvent).relatedObject != this.mTarget)
                {
                    return;
                };
            };
            this.mGI.mQuestClientCallbacks.InitiateWindowOpen(this.mActiveHint.mPointTo);
            this.Hide();
        }

        public function GetTarget():DisplayObject
        {
            return (this.mTarget);
        }

        public function GetHintData():QuestHint
        {
            return (this.mActiveHint);
        }

        public function Init(_arg_1:HintPointer):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mPanel = _arg_1;
            this.mPanel.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }


    }
}
