package GUI.GAME.avatarSelection.view
{
    import Utils.Disposable;
    import GUI.Components.AvatarSelectionViewComponent;
    import GUI.ApplicationFacade;
    import __AS3__.vec.Vector;
    import mx.controls.Image;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import consts.GameConstants;
    import mx.events.FlexEvent;
    import GUI.helpers.UIComponentHelpers;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import GUI.GAME.avatarSelection.AvatarSelectionPanel;
    import flash.text.TextLineMetrics;
    import flash.events.Event;
    import GUI.Assets.gAssetManager;
    import Enums.AVATAR_SIZE;
    import flash.display.InteractiveObject;
    import __AS3__.vec.*;

    public class AvatarSelectionView implements Disposable 
    {

        public static const VIEW_COMPONENT_WIDTH:int = 0x0200;
        public static const OFFSET_HEADER:int = 150;
        public static const OFFSET_AVATAR_NAME:int = 6;
        public static const OFFSET_FOOTER:int = 10;
        public static const OFFSET_ERROR_PANEL:int = 3;

        private var avatarNameInputEnabled:Boolean;
        private var viewComponent:AvatarSelectionViewComponent;
        private var facade:ApplicationFacade;
        private var avatarPictureEnabled:Boolean;
        private var defaultAvatarName:String;
        private var currentId:int;
        private var avatarImages:Vector.<Image>;

        public function AvatarSelectionView(_arg_1:AvatarSelectionViewComponent)
        {
            super();
            this.viewComponent = _arg_1;
            this.facade = ApplicationFacade.getInstance();
            this.defaultAvatarName = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, GameConstants.LABEL_AVATAR_NAME);
            this.tryInit();
        }

        private function handleCreationComplete(_arg_1:FlexEvent):void
        {
            this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete);
            this.avatarImages = new Vector.<Image>();
            this.avatarImages.push(this.viewComponent.mostLeftAvatar, this.viewComponent.leftAvatar, this.viewComponent.currentAvatar, this.viewComponent.rightAvatar, this.viewComponent.mostRightAvatar);
            this.viewComponent.headerLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, GameConstants.LABEL_YOUR_AVATAR);
            this.viewComponent.currentSelection.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, GameConstants.LABEL_AVATAR_CURRENT_SELECTION);
            this.viewComponent.nameWarningLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, GameConstants.LABEL_UNAVAILABLE);
            UIComponentHelpers.removeMouseInteraction(this.viewComponent);
        }

        public function hide():void
        {
            this.removeListeners();
            this.viewComponent.visible = false;
        }

        public function show():void
        {
            this.addListeners();
            this.viewComponent.visible = true;
            this.viewComponent.nameWarningCanvas.visible = false;
            this.viewComponent.leftArrowCanvas.visible = this.avatarPictureEnabled;
            this.viewComponent.rightArrowCanvas.visible = this.avatarPictureEnabled;
        }

        public function setAvatarName(_arg_1:String):void
        {
            this.viewComponent.avatarNameInput.text = _arg_1;
        }

        private function handleTextInputFocusIn(_arg_1:FocusEvent):void
        {
            if (this.viewComponent.avatarNameInput.text == this.defaultAvatarName)
            {
                this.viewComponent.avatarNameInput.text = "";
                this.viewComponent.avatarNameInput.removeEventListener(FocusEvent.FOCUS_IN, this.handleTextInputFocusIn);
            };
        }

        private function handleCloseWarning(_arg_1:MouseEvent):void
        {
            this.showNameWarning(false);
        }

        private function handleStartClick(_arg_1:MouseEvent):void
        {
            this.facade.sendNotification(((this.avatarNameInputEnabled) ? AvatarSelectionPanel.SEND_PLAYER_INFO_AND_USERNAME_SELECTED : AvatarSelectionPanel.SEND_PLAYER_INFO_SELECTED));
        }

        public function showNameWarning(_arg_1:Boolean, _arg_2:String=null):void
        {
            var _local_3:TextLineMetrics;
            var _local_4:String;
            var _local_5:int;
            this.viewComponent.nameWarningCanvas.visible = _arg_1;
            if (_arg_2 != null)
            {
                _local_4 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _arg_2);
                _local_3 = this.viewComponent.nameWarningLabel.measureText(_local_4);
                this.viewComponent.nameWarningLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, _arg_2);
            };
        }

        private function handleTextInput(_arg_1:Event):void
        {
            this.facade.sendNotification(AvatarSelectionPanel.REFRESH_NAME);
        }

        public function setAvatarList(_arg_1:Vector.<int>, _arg_2:int):void
        {
            this.currentId = _arg_2;
            this.renderList(_arg_1);
        }

        private function removeListeners():void
        {
            SWMMO(global.getApplication()).setTabEnabled(true);
            UIComponentHelpers.removeMouseInteraction(this.viewComponent);
            this.viewComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete);
            this.viewComponent.startButton.removeEventListener(MouseEvent.CLICK, this.handleStartClick);
            this.viewComponent.leftArrow.removeEventListener(MouseEvent.CLICK, this.handleLeftRightClick);
            this.viewComponent.rightArrow.removeEventListener(MouseEvent.CLICK, this.handleLeftRightClick);
            this.viewComponent.avatarNameInput.removeEventListener(Event.CHANGE, this.handleTextInput);
            this.viewComponent.avatarNameInput.removeEventListener(FocusEvent.FOCUS_IN, this.handleTextInputFocusIn);
            this.viewComponent.nameWarningCanvas.removeEventListener(MouseEvent.CLICK, this.handleCloseWarning);
        }

        private function handleLeftRightClick(_arg_1:MouseEvent):void
        {
            var _local_2:int = ((_arg_1.currentTarget == this.viewComponent.leftArrow) ? -1 : 1);
            this.facade.sendNotification(AvatarSelectionPanel.REFRESH_AVATAR_LIST, (this.currentId + _local_2));
        }

        public function setAvatarPictureEnabled(_arg_1:Boolean):void
        {
            this.avatarPictureEnabled = _arg_1;
        }

        public function dispose():void
        {
            this.removeListeners();
            this.viewComponent = null;
            this.avatarImages = null;
            this.facade = null;
        }

        private function renderList(_arg_1:Vector.<int>):void
        {
            var _local_2:int;
            var _local_3:int = _arg_1.length;
            while (_local_2 < _local_3)
            {
                this.avatarImages[_local_2].source = gAssetManager.GetAvatarUrl(_arg_1[_local_2], ((_arg_1[_local_2] == this.currentId) ? AVATAR_SIZE.LARGE : AVATAR_SIZE.SMALL));
                _local_2++;
            };
        }

        private function tryInit():void
        {
            if (!this.getIsInitialized())
            {
                this.viewComponent.addEventListener(FlexEvent.CREATION_COMPLETE, this.handleCreationComplete, false, 0, true);
            }
            else
            {
                this.handleCreationComplete(null);
            };
        }

        private function getIsInitialized():Boolean
        {
            var _local_2:String;
            var _local_1:Array = ["leftArrow", "leftAvatar", "currentAvatar", "rightAvatar", "rightArrow"];
            for each (_local_2 in _local_1)
            {
                if (this.viewComponent[_local_2] == null)
                {
                    return (false);
                };
            };
            return (true);
        }

        private function addListeners():void
        {
            var _local_2:InteractiveObject;
            var _local_1:Array = [this.viewComponent.startButton, this.viewComponent.leftArrow, this.viewComponent.rightArrow, this.viewComponent.avatarNameInput, this.viewComponent.nameWarningCanvas];
            SWMMO(global.getApplication()).setTabEnabled(false);
            for each (_local_2 in _local_1)
            {
                UIComponentHelpers.enableMouseInteraction(_local_2);
            };
            this.viewComponent.startButton.addEventListener(MouseEvent.CLICK, this.handleStartClick, false, 0, true);
            if (this.avatarPictureEnabled)
            {
                this.viewComponent.leftArrow.addEventListener(MouseEvent.CLICK, this.handleLeftRightClick, false, 0, true);
                this.viewComponent.rightArrow.addEventListener(MouseEvent.CLICK, this.handleLeftRightClick, false, 0, true);
            };
            if (this.avatarNameInputEnabled)
            {
                this.viewComponent.avatarNameInput.mouseEnabled = true;
                this.viewComponent.avatarNameInput.mouseChildren = true;
                this.viewComponent.avatarNameInput.addEventListener(Event.CHANGE, this.handleTextInput, false, 0, true);
                this.viewComponent.avatarNameInput.addEventListener(FocusEvent.FOCUS_IN, this.handleTextInputFocusIn, false, 0, true);
            }
            else
            {
                this.viewComponent.avatarNameInput.mouseEnabled = false;
            };
            this.viewComponent.nameWarningCanvas.addEventListener(MouseEvent.CLICK, this.handleCloseWarning, false, 0, true);
        }

        public function getDefaultAvatarName():String
        {
            return (this.defaultAvatarName);
        }

        public function enableStartButton(_arg_1:Boolean):void
        {
            this.viewComponent.startButton.enabled = _arg_1;
        }

        public function handleZoneReceived():void
        {
            this.viewComponent.genericInfoLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, GameConstants.LABEL_AVATAR_GENERIC_SERVER_INFO, [global.gameworld]);
        }

        public function getAvatarName():String
        {
            return (this.viewComponent.avatarNameInput.text);
        }

        public function setAvatarNameInputEnabled(_arg_1:Boolean):void
        {
            this.avatarNameInputEnabled = _arg_1;
        }


    }
}
