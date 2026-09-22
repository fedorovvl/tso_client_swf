package GUI.Effects
{
    import __AS3__.vec.Vector;
    import GUI.GAME.cHintPointer;
    import com.bluebyte.tso.quests.logic.QuestHint;
    import Enums.HINT_TYPE;
    import flash.display.DisplayObject;
    import Communication.VO.dQuestDefinitionHintVO;
    import mx.collections.ArrayCollection;
    import Communication.VO.dQuestElementVO;
    import GUI.Components.HintPointer;
    import __AS3__.vec.*;

    public class gHintManager 
    {

        private static var hintPointers:Vector.<cHintPointer> = new Vector.<cHintPointer>();
        private static var hintQueue:Vector.<QuestHint> = new Vector.<QuestHint>();


        public static function ShowPvPLevelUpNotification():void
        {
            var _local_1:QuestHint = new QuestHint();
            _local_1.mPointTo = "GAMESTATE_ID_AVATAR.pvpRankButton";
            _local_1.mType = HINT_TYPE.PVP_LEVEL_UP;
            _local_1.mOffsetX = 25;
            globalFlash.gui.mPvPLevelUpHintPointer.SetData(_local_1);
        }

        public static function HideHintsForParent(_arg_1:DisplayObject, _arg_2:Boolean):void
        {
            var _local_4:DisplayObject;
            var _local_3:int;
            while (_local_3 < hintPointers.length)
            {
                _local_4 = hintPointers[_local_3].GetTarget();
                while (((!(_local_4 == null)) && (!(_local_4 == _arg_1))))
                {
                    _local_4 = _local_4.parent;
                };
                if (_local_4 != null)
                {
                    if (_arg_2)
                    {
                        hintQueue.push(hintPointers[_local_3].GetHintData());
                    };
                    hintPointers[_local_3].Hide();
                    _local_3--;
                };
                _local_3++;
            };
        }

        public static function HideQuestNotification():void
        {
            if (globalFlash.gui.mQuestHintPointer.IsVisible())
            {
                globalFlash.gui.mQuestHintPointer.Hide();
            };
        }

        public static function ShowCalendarOpenableNotification():void
        {
            var _local_1:QuestHint = new QuestHint();
            _local_1.mPointTo = "GAMESTATE_ID_AVATAR.btnAdvent";
            _local_1.mType = HINT_TYPE.CALENDAR_OPENABLE;
            _local_1.mOffsetX = 25;
            globalFlash.gui.mCalendarHintPointer.SetData(_local_1);
        }

        public static function ShowHints(_arg_1:ArrayCollection):void
        {
            var _local_2:dQuestDefinitionHintVO;
            var _local_3:QuestHint;
            if (_arg_1.length == 0)
            {
                return;
            };
            for each (_local_2 in _arg_1)
            {
                _local_3 = new QuestHint();
                _local_3.mType = _local_2.type;
                _local_3.mName_string = _local_2.name_string;
                _local_3.mOffsetX = _local_2.offsetX;
                _local_3.mOffsetY = _local_2.offsetY;
                _local_3.mPointTo = _local_2.pointTo;
                if (global.getApplication().getGUIItem(_local_3.mPointTo) != null)
                {
                    ApplyHint(_local_3);
                }
                else
                {
                    hintQueue.push(_local_3);
                };
            };
        }

        public static function HideHint(_arg_1:cHintPointer):void
        {
            var _local_2:int = hintPointers.indexOf(_arg_1);
            if (_local_2 != -1)
            {
                hintPointers.splice(_local_2, 1);
                global.getApplication().isoengine.removeChild(_arg_1.GetGUIElement());
            };
        }

        public static function ShowNewQuestNotification(_arg_1:dQuestElementVO):void
        {
            if (global.ui.mIsDefenseMode)
            {
                return;
            };
            var _local_2:QuestHint = new QuestHint();
            _local_2.mPointTo = "GAMESTATE_ID_AVATAR.btnQuestBook";
            _local_2.mType = HINT_TYPE.NEW_QUEST;
            _local_2.mOffsetX = 25;
            globalFlash.gui.mQuestHintPointer.SetData(_local_2);
            globalFlash.gui.mQuestBook.SetNotificationQuest(_arg_1);
        }

        public static function HideCalendarNotification():void
        {
            if (globalFlash.gui.mCalendarHintPointer.IsVisible())
            {
                globalFlash.gui.mCalendarHintPointer.Hide();
            };
        }

        public static function ShowFailedQuestNotification(_arg_1:dQuestElementVO):void
        {
            var _local_2:QuestHint = new QuestHint();
            _local_2.mPointTo = "GAMESTATE_ID_AVATAR.btnQuestBook";
            _local_2.mType = HINT_TYPE.FAILED_QUEST;
            _local_2.mOffsetX = 25;
            globalFlash.gui.mQuestHintPointer.SetData(_local_2);
            globalFlash.gui.mQuestBook.SetNotificationQuest(_arg_1);
        }

        private static function ApplyHint(_arg_1:QuestHint):void
        {
            var _local_2:cHintPointer = new cHintPointer();
            var _local_3:HintPointer = new HintPointer();
            var refIdx:int = global.getApplication().isoengine.numChildren;
            try
            {
                refIdx = global.getApplication().isoengine.getChildIndex(global.getApplication().GAMESTATE_ID_QUEST_HINT_POINTER);
            }
            catch (e:Error)
            {
            };
            global.getApplication().isoengine.addChildAt(_local_3, refIdx);
            _local_2.Init(_local_3);
            _local_2.SetData(_arg_1);
            hintPointers.push(_local_2);
        }

        public static function TryRemainingHints():void
        {
            var _local_1:int;
            while (_local_1 < hintQueue.length)
            {
                if (global.getApplication().getGUIItem(hintQueue[_local_1].mPointTo) != null)
                {
                    ApplyHint(hintQueue[_local_1]);
                    hintQueue.splice(_local_1, 1);
                    _local_1--;
                };
                _local_1++;
            };
        }

        public static function HideHints():void
        {
            while (hintPointers.length > 0)
            {
                hintPointers[0].Hide();
            };
            hintQueue = new Vector.<QuestHint>();
            HideQuestNotification();
            HideCalendarNotification();
            HidePvPLevelUpNotification();
        }

        public static function HidePvPLevelUpNotification():void
        {
            if (globalFlash.gui.mPvPLevelUpHintPointer.IsVisible())
            {
                globalFlash.gui.mPvPLevelUpHintPointer.Hide();
            };
        }

        public static function ShowCompletedQuestNotification(_arg_1:dQuestElementVO):void
        {
            if (global.ui.mIsDefenseMode)
            {
                return;
            };
            var _local_2:QuestHint = new QuestHint();
            _local_2.mPointTo = "GAMESTATE_ID_AVATAR.btnQuestBook";
            _local_2.mType = HINT_TYPE.COMPLETED_QUEST;
            _local_2.mOffsetX = 25;
            globalFlash.gui.mQuestHintPointer.SetData(_local_2);
            globalFlash.gui.mQuestBook.SetNotificationQuest(_arg_1);
        }


    }
}
