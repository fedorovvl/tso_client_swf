package GUI.GAME.avatarSelection
{
    import GUI.GAME.cBasicPanel;
    import org.puremvc.as3.interfaces.IMediator;
    import Utils.Disposable;
    import GUI.Components.AvatarSelectionViewComponent;
    import GUI.ApplicationFacade;
    import GUI.GAME.avatarSelection.view.AvatarSelectionView;
    import Interface.cGeneralInterface;
    import Communication.VO.avatarSelection.CheckUsernameVO;
    import GUI.GAME.avatarSelection.vo.SendServerVO;
    import Communication.VO.avatarSelection.UpdateUsernameAndAvatarVO;
    import GUI.GAME.avatarSelection.command.SendUpdateUsernameAndAvatarCommand;
    import GUI.GAME.avatarSelection.command.SendUpdateAvatarCommand;
    import GUI.GAME.avatarSelection.command.SendCheckUsernameCommand;
    import GUI.GAME.avatarSelection.command.CheckAvatarNameCommand;
    import GUI.GAME.avatarSelection.command.CheckShowAvatarSelectionPanelCommand;
    import __AS3__.vec.Vector;
    import org.puremvc.as3.interfaces.INotification;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    import __AS3__.vec.*;

    public class AvatarSelectionPanel extends cBasicPanel implements IMediator, Disposable 
    {

        public static const NAME:String = "AvatarSelectionPanel";
        public static const REFRESH_AVATAR_LIST:String = (NAME + "_refreshAvatarList");
        public static const REFRESH_NAME:String = (NAME + "_refreshName");
        public static const SEND_PLAYER_INFO_SELECTED:String = (NAME + "_sendUserInfoSelected");
        public static const SEND_PLAYER_INFO_AND_USERNAME_SELECTED:String = (NAME + "_sendUserInfoAndUsernameSelected");
        public static const CHECK_NAME:String = (NAME + "_checkName");
        public static const SEND_UPDATE_USERNAME_AND_PLAYER_INFO_TO_SERVER:String = (NAME + "_sendUpdateUsernameAndUserInfoToServer");
        public static const SEND_UPDATE_PLAYER_INFO_TO_SERVER:String = (NAME + "_sendUpdateUserInfoToServer");
        public static const SEND_CHECK_USERNAME_TO_SERVER:String = (NAME + "_sendCheckUsernameToServer");
        public static const CHECK_SHOW:String = (NAME + "_checkShow");
        public static const ZONE_RECEIVED:String = (NAME + "_zoneReceived");

        private const NUM_AVATARS_IN_LIST:int = 5;
        private const DEFAULT_AVATAR_ID:int = 1;
        private const NUM_AVATARS:int = 60;
        private const CHECK_NAME_COOL_DOWN:int = 1000;

        private var panel:AvatarSelectionViewComponent;
        private var checkingName:Boolean;
        private var currentCheckedName:String;
        private var facade:ApplicationFacade;
        private var view:AvatarSelectionView;
        private var generalInterface:cGeneralInterface;
        private var updatingAvatar:Boolean;
        private var isUsernameUpdateOnly:Boolean;
        private var currentSelectedName:String;
        private var currentAvatarId:int;
        private var checkNameTimeoutId:int;


        public function serverCheckReceived(_arg_1:CheckUsernameVO):void
        {
            this.checkingName = false;
            this.view.showNameWarning((!(_arg_1.checkOK)), _arg_1.errorMessageId);
            this.view.enableStartButton(((_arg_1.checkOK) && (!(this.updatingAvatar))));
            if (_arg_1.checkOK)
            {
                this.currentCheckedName = _arg_1.username;
            };
        }

        public function localCheckSucceeded(_arg_1:String):void
        {
            this.currentSelectedName = _arg_1;
            this.view.showNameWarning(false);
            this.facade.sendNotification(SEND_CHECK_USERNAME_TO_SERVER, new SendServerVO(this.generalInterface, new CheckUsernameVO().init(this.currentSelectedName)));
        }

        public function init(_arg_1:cGeneralInterface, _arg_2:AvatarSelectionViewComponent):void
        {
            this.generalInterface = _arg_1;
            this.panel = _arg_2;
            globalFlash.gui.windowController.addWindow(_arg_2);
            AddBaseElement(_arg_2);
            this.facade = ApplicationFacade.getInstance();
            this.facade.registerMediator(this);
        }

        private function handleRefreshAvatarList(_arg_1:int):void
        {
            this.currentAvatarId = this.computeAvatarId(_arg_1);
            this.computeAvatarList();
        }

        private function handleSendAvatarSelected(_arg_1:String):void
        {
            this.updatingAvatar = true;
            this.view.enableStartButton(false);
            this.facade.sendNotification(_arg_1, new SendServerVO(this.generalInterface, new UpdateUsernameAndAvatarVO().init(this.currentCheckedName, this.currentAvatarId, global.localizedDomain, this.isUsernameUpdateOnly)));
        }

        public function getMediatorName():String
        {
            return (NAME);
        }

        public function setViewComponent(_arg_1:Object):void
        {
            this.panel = (_arg_1 as AvatarSelectionViewComponent);
        }

        override public function Show():void
        {
            this.checkNameTimeoutId = -1;
            this.checkingName = false;
            this.updatingAvatar = false;
            this.view.show();
            super.Show();
            globalFlash.gui.windowController.setTop(this.panel, true);
        }

        override public function dispose():void
        {
            this.facade.removeMediator(this.getMediatorName());
            this.removeTimeout();
            this.facade = null;
            this.generalInterface = null;
            this.panel = null;
            super.dispose();
        }

        public function onRegister():void
        {
            this.facade.registerCommand(SEND_UPDATE_USERNAME_AND_PLAYER_INFO_TO_SERVER, SendUpdateUsernameAndAvatarCommand);
            this.facade.registerCommand(SEND_UPDATE_PLAYER_INFO_TO_SERVER, SendUpdateAvatarCommand);
            this.facade.registerCommand(SEND_CHECK_USERNAME_TO_SERVER, SendCheckUsernameCommand);
            this.facade.registerCommand(CHECK_NAME, CheckAvatarNameCommand);
            this.facade.registerCommand(CHECK_SHOW, CheckShowAvatarSelectionPanelCommand);
            this.view = new AvatarSelectionView(this.panel);
        }

        private function computeAvatarId(_arg_1:int):int
        {
            if (_arg_1 > this.NUM_AVATARS)
            {
                return (_arg_1 - this.NUM_AVATARS);
            };
            if (_arg_1 <= 0)
            {
                return (this.NUM_AVATARS + _arg_1);
            };
            return (_arg_1);
        }

        private function checkAvatarName():void
        {
            this.checkingName = true;
            this.currentSelectedName = this.view.getAvatarName();
            this.removeTimeout();
            this.facade.sendNotification(CHECK_NAME, this.currentSelectedName);
        }

        private function computeAvatarList():void
        {
            var _local_1:int;
            var _local_2:int = int(Math.floor((this.NUM_AVATARS_IN_LIST / 2)));
            var _local_3:Vector.<int> = new Vector.<int>();
            while (_local_1 < this.NUM_AVATARS_IN_LIST)
            {
                _local_3.push(this.computeAvatarId(((this.currentAvatarId + _local_1) - _local_2)));
                _local_1++;
            };
            this.view.setAvatarList(_local_3, this.currentAvatarId);
        }

        public function handleNotification(_arg_1:INotification):void
        {
            var _local_2:String = _arg_1.getName();
            switch (_local_2)
            {
                case REFRESH_AVATAR_LIST:
                    this.handleRefreshAvatarList((_arg_1.getBody() as int));
                    return;
                case REFRESH_NAME:
                    this.handleRefreshName();
                    return;
                case SEND_PLAYER_INFO_SELECTED:
                    this.handleSendAvatarSelected(SEND_UPDATE_PLAYER_INFO_TO_SERVER);
                    return;
                case SEND_PLAYER_INFO_AND_USERNAME_SELECTED:
                    this.handleSendAvatarSelected(SEND_UPDATE_USERNAME_AND_PLAYER_INFO_TO_SERVER);
                    return;
                case ZONE_RECEIVED:
                    this.handleZoneReceived();
                    return;
            };
        }

        private function removeTimeout():void
        {
            if (this.checkNameTimeoutId >= 0)
            {
                clearTimeout(this.checkNameTimeoutId);
                this.checkNameTimeoutId = -1;
            };
        }

        public function onRemove():void
        {
            this.facade.removeCommand(SEND_UPDATE_USERNAME_AND_PLAYER_INFO_TO_SERVER);
            this.facade.removeCommand(SEND_UPDATE_PLAYER_INFO_TO_SERVER);
            this.facade.removeCommand(SEND_CHECK_USERNAME_TO_SERVER);
            this.facade.removeCommand(CHECK_NAME);
            this.facade.removeCommand(CHECK_SHOW);
            if (this.view)
            {
                this.view.dispose();
                this.view = null;
            };
        }

        public function getViewComponent():Object
        {
            return (this.panel);
        }

        private function handleRefreshName():void
        {
            this.removeTimeout();
            this.currentSelectedName = this.view.getAvatarName();
            this.view.enableStartButton((this.currentSelectedName == this.currentCheckedName));
            this.checkNameTimeoutId = setTimeout(this.checkAvatarName, this.CHECK_NAME_COOL_DOWN);
        }

        public function setInitialData(_arg_1:String, _arg_2:int):void
        {
            if (cGeneralInterface.isDefaultPlayerName(_arg_1))
            {
                this.currentSelectedName = "";
                this.view.setAvatarName(this.view.getDefaultAvatarName());
                this.view.setAvatarNameInputEnabled(true);
                this.view.enableStartButton(false);
            }
            else
            {
                this.currentSelectedName = ((cGeneralInterface.isDefaultPlayerName(_arg_1)) ? "" : _arg_1);
                this.view.setAvatarName(this.currentSelectedName);
                this.view.setAvatarNameInputEnabled(false);
                this.view.enableStartButton(true);
            };
            if (_arg_2 <= 0)
            {
                this.handleRefreshAvatarList(this.DEFAULT_AVATAR_ID);
                this.view.setAvatarPictureEnabled(true);
            }
            else
            {
                this.handleRefreshAvatarList(_arg_2);
                this.view.setAvatarPictureEnabled(false);
            };
            if (((_arg_2 > 0) && (cGeneralInterface.isDefaultPlayerName(_arg_1))))
            {
                this.isUsernameUpdateOnly = true;
            }
            else
            {
                this.isUsernameUpdateOnly = false;
            };
        }

        public function listNotificationInterests():Array
        {
            return ([REFRESH_AVATAR_LIST, REFRESH_NAME, SEND_PLAYER_INFO_SELECTED, SEND_PLAYER_INFO_AND_USERNAME_SELECTED, ZONE_RECEIVED]);
        }

        override public function Hide():void
        {
            this.checkingName = false;
            this.updatingAvatar = false;
            this.removeTimeout();
            super.Hide();
            this.view.hide();
        }

        private function handleZoneReceived():void
        {
            this.view.handleZoneReceived();
        }

        public function localCheckFailed(_arg_1:String):void
        {
            this.view.showNameWarning(true, _arg_1);
            this.checkingName = false;
        }

        public function serverUpdateReceived(_arg_1:UpdateUsernameAndAvatarVO):void
        {
            this.updatingAvatar = false;
            if (!_arg_1.changeSuccessful)
            {
                this.view.showNameWarning(true, _arg_1.errorMessageId);
                this.view.enableStartButton(false);
            }
            else
            {
                this.Hide();
                globalFlash.gui.mEventInfoPanel.Show();
            };
        }


    }
}
