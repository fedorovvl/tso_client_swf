package com.bluebyte.tso.util
{
    import Interface.cGeneralInterface;
    import GO.cBuilding;
    import flash.display.Stage;
    import com.bluebyte.bluefire.flex3.defaultClient.CustomInput;
    import mx.core.UITextField;
    import flash.text.TextFieldType;
    import mx.controls.TextInput;
    import mx.controls.TextArea;
    import flash.ui.Keyboard;
    import nLib.gMisc;
    import nLib.cZoom;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import flash.events.KeyboardEvent;
    import flash.display.DisplayObject;
    import mx.managers.SystemManager;
    import mx.core.Application;
    import mx.core.UIComponent;
    import GUI.Components.ICustomAlert;
    import Interface.cGameInterface;
    import mx.managers.PopUpManager;
    import mx.core.IFlexDisplayObject;

    public class HotkeyManager 
    {

        private static var _instance:HotkeyManager;

        private var gi:cGeneralInterface;
        private var _cancelAction:Function;
        private var _blueFireComponent:BlueFireComponent;
        private var _confirmAction:Function;


        public static function getInstance():HotkeyManager
        {
            if (!_instance)
            {
                _instance = new (HotkeyManager)();
            };
            return (_instance);
        }


        public function keyDown(_arg_1:KeyboardEvent):void
        {
            var _local_3:cBuilding;
            var _local_4:Stage;
            var _local_5:int;
            var _local_2:CustomInput = this._blueFireComponent.chatInput;
            if (((((_arg_1.target.parent == _local_2) || ((_arg_1.target is TextArea) && ((_arg_1.target as TextArea).editable))) || (_arg_1.target is TextInput)) || ((_arg_1.target is UITextField) && ((_arg_1.target as UITextField).type == TextFieldType.INPUT))))
            {
                return;
            };
            if (this.gi.IsActiveAndInputActive())
            {
                if (_arg_1.keyCode == Keyboard.F11)
                {
                    if (gMisc.isEnabledFullScreenInteractive())
                    {
                        _local_4 = _arg_1.target.stage;
                        if (_local_4.displayState == "fullScreenInteractive")
                        {
                            _local_4.displayState = "normal";
                        }
                        else
                        {
                            _local_4.displayState = "fullScreenInteractive";
                        };
                    }
                    else
                    {
                        gMisc.CustomAlertFPUpgrade();
                    };
                };
                if (_arg_1.charCode == gMisc.AsciiKeyCode("+"))
                {
                    this.gi.mZoom.modifyScaleIndex(-1);
                };
                if (_arg_1.charCode == gMisc.AsciiKeyCode("-"))
                {
                    this.gi.mZoom.modifyScaleIndex(1);
                };
                if (_arg_1.charCode == gMisc.AsciiKeyCode("0"))
                {
                    this.gi.mZoom.setScaleIndexWithZoomFactor(cZoom.START_ZOOM_FACTOR);
                    this.gi.mCurrentPlayerZone.getMapStartingPos();
                };
            };
            if (((_arg_1.keyCode == Keyboard.LEFT) || (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "ScrollLeft")))))
            {
                this.gi.scroll = defines.SCROLL_LEFT;
            };
            if (((_arg_1.keyCode == Keyboard.RIGHT) || (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "ScrollRight")))))
            {
                this.gi.scroll = defines.SCROLL_RIGHT;
            };
            if (((_arg_1.keyCode == Keyboard.UP) || (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "ScrollUp")))))
            {
                this.gi.scroll = defines.SCROLL_UP;
            };
            if (((_arg_1.keyCode == Keyboard.DOWN) || (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "ScrollDown")))))
            {
                this.gi.scroll = defines.SCROLL_DOWN;
            };
            if (this.gi.mHomePlayer.GetHomeZoneId() > defines.ADVENTUREZONEID)
            {
                if (((_arg_1.charCode >= gMisc.AsciiKeyCode("1")) && (_arg_1.charCode <= gMisc.AsciiKeyCode("9"))))
                {
                    _local_5 = (_arg_1.charCode.valueOf() - 49);
                    if (!_arg_1.ctrlKey)
                    {
                        if (_local_5 <= 2)
                        {
                            _local_5 = (_local_5 + 6);
                        }
                        else
                        {
                            if (_local_5 >= 6)
                            {
                                _local_5 = (_local_5 - 6);
                            };
                        };
                    }
                    else
                    {
                        _local_5 = (_arg_1.charCode.valueOf() - 38);
                    };
                    this.gi.mZoom.SetScrollPosPlayerZoneSectorNr(this.gi.mCurrentPlayerZone, _local_5);
                    this.gi.mCurrentPlayerZone.SetBackgroundHasChanged(true);
                };
            };
            if (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, defines.BOOKBINDER_NAME_string)))
            {
                if (this.gi.mCurrentViewedZoneID == this.gi.mCurrentPlayer.GetPlayerId())
                {
                    _local_3 = globalFlash.gui.ShowBuilding(defines.BOOKBINDER_NAME_string);
                    if (_local_3 != null)
                    {
                        this.gi.mQuestClientCallbacks.CheckKeyPress(defines.BOOKBINDER_NAME_string);
                    };
                };
            };
            if (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, defines.BARRACKS_NAME_string)))
            {
                if (this.gi.mCurrentViewedZoneID == this.gi.mCurrentPlayer.GetPlayerId())
                {
                    _local_3 = globalFlash.gui.ShowBuilding(defines.BARRACKS_NAME_string);
                    if (_local_3 != null)
                    {
                        this.gi.mQuestClientCallbacks.CheckKeyPress(defines.BARRACKS_NAME_string);
                    };
                };
            };
            if (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, defines.PROVISIONHOUSE_NAME_string)))
            {
                if (this.gi.mCurrentViewedZoneID == this.gi.mCurrentPlayer.GetPlayerId())
                {
                    _local_3 = globalFlash.gui.ShowBuilding(defines.PROVISIONHOUSE_NAME_string);
                    if (_local_3 != null)
                    {
                        this.gi.mQuestClientCallbacks.CheckKeyPress(defines.PROVISIONHOUSE_NAME_string);
                    };
                };
            };
            if (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "MayorsHouse")))
            {
                if (this.gi.mCurrentViewedZoneID == this.gi.mCurrentPlayer.GetPlayerId())
                {
                    _local_3 = globalFlash.gui.ShowBuilding(defines.MAYORHOUSE_NAME_string);
                    if (_local_3 != null)
                    {
                        this.gi.mQuestClientCallbacks.CheckKeyPress("MayorsHouse");
                    };
                };
            };
        }

        private function GetTopMostUIComponent():UIComponent
        {
            var _local_3:DisplayObject;
            var _local_1:SystemManager = SystemManager(Application.application.systemManager);
            var _local_2:int = _local_1.rawChildren.numChildren;
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_3 = _local_1.rawChildren.getChildAt(_local_4);
                if ((((_local_3 is UIComponent) && (UIComponent(_local_3).isPopUp)) && (UIComponent(_local_3).visible)))
                {
                    return (_local_3 as UIComponent);
                };
                _local_4++;
            };
            return (null);
        }

        public function keyDownAlways(_arg_1:KeyboardEvent):void
        {
            var _local_2:CustomInput = this._blueFireComponent.chatInput;
            if ((((!(this.gi.IsActiveAndInputActive())) || (!(_arg_1.ctrlKey))) || (_arg_1.target.parent == _local_2)))
            {
                return;
            };
        }

        private function onKeyDown(_arg_1:KeyboardEvent):void
        {
            this.keyDownAlways(_arg_1);
            this.keyDown(_arg_1);
        }

        public function clearConfirmActions():void
        {
            this._confirmAction = null;
            this._cancelAction = null;
        }

        public function Init(_arg_1:cGeneralInterface, _arg_2:Stage, _arg_3:BlueFireComponent):void
        {
            this.gi = _arg_1;
            this._blueFireComponent = _arg_3;
            _arg_2.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            _arg_2.addEventListener(KeyboardEvent.KEY_UP, this.keyUp);
        }

        public function keyUp(_arg_1:KeyboardEvent):void
        {
            var _local_4:ICustomAlert;
            var _local_2:CustomInput = this._blueFireComponent.chatInput;
            if (_arg_1.target.parent == _local_2)
            {
                return;
            };
            if (((this.gi.IsActiveAndInputActive()) && ((((((((_arg_1.keyCode == Keyboard.LEFT) || (_arg_1.keyCode == Keyboard.RIGHT)) || (_arg_1.keyCode == Keyboard.UP)) || (_arg_1.keyCode == Keyboard.DOWN)) || (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "ScrollLeft")))) || (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "ScrollRight")))) || (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "ScrollUp")))) || (_arg_1.charCode == gMisc.AsciiKeyCode(cLocaManager.GetInstance().GetText(LOCA_GROUP.HOTKEYS, "ScrollDown"))))))
            {
                (this.gi as cGameInterface).ResetScrolling();
            };
            if (((!(_arg_1.keyCode == Keyboard.ENTER)) && (!(_arg_1.keyCode == Keyboard.ESCAPE))))
            {
                return;
            };
            var _local_3:UIComponent = this.GetTopMostUIComponent();
            if (_local_3 != null)
            {
                if ((_local_3 is ICustomAlert))
                {
                    _local_4 = (_local_3 as ICustomAlert);
                    if (_local_4.isCloseable)
                    {
                        if (_arg_1.keyCode == Keyboard.ENTER)
                        {
                            _local_4.confirmAction();
                        }
                        else
                        {
                            if (_arg_1.keyCode == Keyboard.ESCAPE)
                            {
                                _local_4.cancelAction();
                            };
                        };
                    };
                    return;
                };
                if (_local_3.isPopUp)
                {
                    if (_arg_1.keyCode == Keyboard.ESCAPE)
                    {
                        PopUpManager.removePopUp((_local_3 as IFlexDisplayObject));
                    };
                    return;
                };
            };
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                if (this._confirmAction != null)
                {
                    this._confirmAction();
                };
            }
            else
            {
                if (_arg_1.keyCode == Keyboard.ESCAPE)
                {
                    if (this._cancelAction != null)
                    {
                        this._cancelAction();
                    };
                };
            };
        }

        public function setConfirmActions(_arg_1:Function, _arg_2:Function):void
        {
            this._confirmAction = _arg_1;
            this._cancelAction = _arg_2;
        }


    }
}
