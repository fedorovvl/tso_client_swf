package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.Avatar;
    import Communication.VO.dPlayerListItemVO;
    import GO.cBuilding;
    import BuffSystem.BuffAppliance;
    import GUI.Loca.cLocaManager;
    import flash.events.MouseEvent;
    import mx.events.FlexEvent;
    import GUI.Effects.gHintManager;
    import flash.events.Event;
    import GUI.helpers.UIComponentHelpers;
    import GUI.ApplicationFacade;
    import Achievements.AchievementConsts;
    import GUI.Assets.gAssetManager;
    import ServerState.cPlayerData;
    import Interface.cGeneralInterface;
    import Enums.LOCA_GROUP;
    import consts.GameConstants;
    import Enums.AVATAR_MESSAGE_TYPE;
    import __AS3__.vec.Vector;
    import mx.core.Application;
    import Achievements.UserAchievementManager;
    import Communication.VO.dNumberVO;
    import nLib.gMisc;
    import Enums.COMMAND;

    public class cAvatar extends cGuiBaseElement 
    {

        private var mPreviousXP:int = 0;
        private var mProgressBarWidth:int;
        private var mGI:cGameInterface;
        private var avatarId:int = 0;
        private var mPreviousLevel:int = 0;
        private var mPreviousPvPXP:int = 0;
        protected var mAvatar:Avatar;
        private var mPreviousPremiumAccountDays:int = 0;
        private var mDisplayedPlayer:dPlayerListItemVO;
        private var mPreviousPvPLevel:int = 0;
        private var mayorHouse:cBuilding;


        public function Refresh():void
        {
            this.mAvatar.btnAdvent.visible = ((this.mGI.isOnHomzone()) && (this.mGI.mAdventCalendarManager.IsActive()));
            this.mAvatar.btnAdvent.enabled = this.mAvatar.btnAdvent.visible;
        }

        public function HideMailNotification():void
        {
            this.mAvatar.btnNewMail.visible = false;
        }

        public function GetDisplayedPlayerVO():dPlayerListItemVO
        {
            return (this.mDisplayedPlayer);
        }

        public function ShowMailNotification():void
        {
            this.mAvatar.btnNewMail.visible = true;
        }

        private function SetAvatarTooltip(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            var _local_3:BuffAppliance;
            this.mayorHouse = global.ui.mCurrentPlayerZone.mStreetDataMap.getBuildingByName(defines.MAYORHOUSE_NAME_string);
            if (((this.mayorHouse) && (this.mayorHouse.getPlayerID() == this.mGI.mCurrentPlayer.GetPlayerId())))
            {
                _local_2 = 0;
                while (_local_2 < this.mayorHouse.mBuffs_vector.length)
                {
                    _local_3 = this.mayorHouse.mBuffs_vector[_local_2];
                    if (_local_3.GetBuffDefinition().GetName_string().indexOf(defines.CHANGE_AVATAR_BUFF) != -1)
                    {
                        this.mAvatar.avatarImage.toolTip = cLocaManager.GetInstance().FormatDuration((_local_3.GetBuffDefinition().getDuration(_local_3.GetApplicanceMode()) - (this.mGI.GetClientTime() - _local_3.GetStartTime())));
                        return;
                    };
                    _local_2++;
                };
            };
            this.mAvatar.avatarImage.toolTip = "";
        }

        private function handleQuestButtonClick(_arg_1:MouseEvent):void
        {
            globalFlash.gui.mQuestBook.Show();
        }

        private function completeHandler(event:FlexEvent):void
        {
            this.mAvatar.removeEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
            this.mAvatar.btnNewMail.addEventListener(MouseEvent.CLICK, function ():void
            {
                gHintManager.HideHintsForParent(global.getApplication().GAMESTATE_ID_ACTIONBAR.actionBarRight.btnActionBar06, false);
                globalFlash.gui.mMailWindow.Show();
            });
            this.mAvatar.btnQuestBook.addEventListener(MouseEvent.CLICK, function (_arg_1:Event):void
            {
                globalFlash.gui.mQuestBook.Show();
            });
            if (defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
            {
                this.mAvatar.achievementImage.setStyle(UIComponentHelpers.LEFT, 58);
            }
            else
            {
                this.mAvatar.achievement.addEventListener(MouseEvent.CLICK, function (_arg_1:Event):void
                {
                    ApplicationFacade.sendNotification(AchievementConsts.SHOW_HIDE_ACHIEVEMENT_PANEL, null, AchievementConsts.NORMAL_MODE);
                });
            };
            this.mAvatar.btnAdvent.addEventListener(MouseEvent.CLICK, function ():void
            {
                globalFlash.gui.mAdventWindow.Show();
            });
            this.mAvatar.btnAdvent.source = gAssetManager.GetClass("AdventButtonStandard");
            this.mAvatar.btnAdvent.addEventListener(MouseEvent.MOUSE_OVER, function ():void
            {
                mAvatar.btnAdvent.source = gAssetManager.GetClass("AdventButtonPushed");
            });
            this.mAvatar.btnAdvent.addEventListener(MouseEvent.MOUSE_OUT, function ():void
            {
                mAvatar.btnAdvent.source = gAssetManager.GetClass("AdventButtonStandard");
            });
            this.mAvatar.pvpRankButton.addEventListener(MouseEvent.CLICK, function ():void
            {
                globalFlash.gui.mPvPProgressionPanel.Show();
            });
            this.mAvatar.avatarImage.addEventListener(MouseEvent.MOUSE_OVER, this.SetAvatarTooltip);
            this.mPreviousPremiumAccountDays = -1;
        }

        public function SetData(_arg_1:cPlayerData, _arg_2:Vector.<cPlayerData>):void
        {
            var _local_6:int;
            var _local_9:Array;
            var _local_10:cPlayerData;
            if ((((!(this.mDisplayedPlayer)) || ((this.mDisplayedPlayer) && (!(this.mDisplayedPlayer.username == _arg_1.GetPlayerListItem().username)))) && (!(globalFlash.gui.mChatPanel == null))))
            {
                globalFlash.gui.mChatPanel.setPlayerName(_arg_1.GetPlayerListItem().username);
            };
            this.mDisplayedPlayer = _arg_1.GetPlayerListItem();
            this.mDisplayedPlayer.onlineStatus = true;
            var _local_3:String = (((!(_arg_1.GetPlayerName_string())) || (_arg_1.GetPlayerName_string().length == 0)) ? "[Playername]" : _arg_1.GetPlayerName_string());
            if (cGeneralInterface.isDefaultPlayerName(_local_3))
            {
                _local_3 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, GameConstants.LABEL_AVATAR_NAME);
            };
            this.mAvatar.playerName.text = _local_3;
            var _local_4:int = Math.round((this.GetPvPProgressPercentage(_arg_1.GetPlayerPvPXp(), _arg_1.GetPlayerPvPLevel()) * 133));
            this.mAvatar.pvpProgressBar.width = (_local_4 + 9);
            var _local_5:int = Math.round((this.GetProgressPercentage(_arg_1.GetXP(), _arg_1.GetPlayerLevel()) * this.mProgressBarWidth));
            this.mAvatar.progressBar.width = ((_local_5 > this.mProgressBarWidth) ? this.mProgressBarWidth : _local_5);
            this.mAvatar.level.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "Level", [_arg_1.GetPlayerLevel().toString()]);
            this.SetPremiumAccountDuration(_arg_1);
            this.updateAchievementPoints();
            if (defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
            {
                this.EnableAchievementsButton(false);
            }
            else
            {
                this.mAvatar.achievement.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, AchievementConsts.ACHIEVEMENT_LABEL_ID);
            };
            if (_local_6 == (_arg_1.GetAvatarId() + 100))
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.RED_NOSE_AVATAR_REMOVE);
            }
            else
            {
                if (_local_6 == (_arg_1.GetAvatarId() - 100))
                {
                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.RED_NOSE_AVATAR_ADD);
                };
            };
            _local_6 = ((_arg_1.GetAvatarId() > 0) ? _arg_1.GetAvatarId() : 0);
            var _local_7:int = ((_arg_1.GetAvatarId() > 0) ? (this.mGI.mCurrentPlayerZone.GetPlayerColorIdx(_arg_1.GetPlayerId()) + 1) : 1);
            this.mAvatar.avatarBackground.source = gAssetManager.GetBitmap(("AvatarBackground0" + _local_7));
            this.mAvatar.avatarImage.source = gAssetManager.GetAvatarUrl(_local_6);
            var _local_8:String = new String();
            if (_arg_1.GetXP() >= _arg_1.GetMaxXP())
            {
                _local_8 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "XPLimitReached", [cLocaManager.GetInstance().FormatNumber(_arg_1.GetXP())]);
            }
            else
            {
                _local_8 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "XPNeeded", [_arg_1.GetXP().toString(), cLocaManager.GetInstance().FormatNumber(_arg_1.GetMissingXPForNextLevel())]);
            };
            if (_arg_1.GetPlayerPvPXp() >= _arg_1.GetMaxPvPXP())
            {
                _local_8 = (_local_8 + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PvPXPLimitReached", [cLocaManager.GetInstance().FormatNumber(_arg_1.GetPlayerPvPXp())])));
                this.mAvatar.pvpRankButton.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PvPXPLimitReached", [cLocaManager.GetInstance().FormatNumber(_arg_1.GetPlayerPvPXp())]);
            }
            else
            {
                _local_8 = (_local_8 + ("\n" + cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PvPXPNeeded", [cLocaManager.GetInstance().FormatNumber(_arg_1.GetPlayerPvPXp()), cLocaManager.GetInstance().FormatNumber(_arg_1.GetMissingPvPXPForNextLevel())])));
                this.mAvatar.pvpRankButton.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "PvPXPNeeded", [cLocaManager.GetInstance().FormatNumber(_arg_1.GetPlayerPvPXp()), cLocaManager.GetInstance().FormatNumber(_arg_1.GetMissingPvPXPForNextLevel())]);
            };
            this.mAvatar.xpTooltipMask.toolTip = _local_8;
            if (this.mPreviousPvPXP < _arg_1.GetPlayerPvPXp())
            {
                this.ShowPvPXPAnim();
            };
            if (this.mPreviousPvPLevel < _arg_1.GetPlayerPvPLevel())
            {
            };
            this.mPreviousPvPXP = _arg_1.GetPlayerPvPXp();
            this.mPreviousPvPLevel = _arg_1.GetPlayerPvPLevel();
            if (this.mPreviousXP < _arg_1.GetXP())
            {
                this.ShowXPAnim();
            };
            if (this.mPreviousLevel < _arg_1.GetPlayerLevel())
            {
                this.ShowLevelUpAnim();
                globalFlash.gui.mFriendsList.Refresh();
                this.Refresh();
            };
            this.mPreviousXP = _arg_1.GetXP();
            this.mPreviousLevel = _arg_1.GetPlayerLevel();
            if (_arg_2.length > 1)
            {
                _local_9 = [];
                for each (_local_10 in _arg_2)
                {
                    if (_arg_1.GetPlayerId() != _local_10.GetPlayerId())
                    {
                        _local_9.push(_local_10);
                    };
                };
                this.mAvatar.otherPlayers.visible = true;
                this.mAvatar.otherPlayers.dataProvider = _local_9;
            }
            else
            {
                this.mAvatar.otherPlayers.visible = false;
            };
            this.mAvatar.pvpRankButton.label = cLocaManager.GetInstance().getLabel("PvPLevel", [_arg_1.GetPlayerPvPLevel().toString()]);
        }

        private function ShowXPAnim():void
        {
            this.mAvatar.animXP.visible = true;
        }

        private function ShowPvPXPAnim():void
        {
            this.mAvatar.animPvPXP.visible = true;
        }

        private function handleMailButtonClick(_arg_1:MouseEvent):void
        {
            gHintManager.HideHintsForParent(Application.application.GAMESTATE_ID_ACTIONBAR.actionBarRight.btnActionBar06, false);
            globalFlash.gui.mMailWindow.Show();
        }

        public function updateAchievementPoints():void
        {
            var _local_1:UserAchievementManager;
            if (!defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
            {
                _local_1 = this.mGI.getCurrentUserAchievementManager();
                if (((!(_local_1 == null)) && (!(_local_1.getTree() == null))))
                {
                    this.mAvatar.achievement.label = this.mGI.getCurrentUserAchievementManager().getTree().getPoints().toString();
                }
                else
                {
                    this.mAvatar.achievement.label = "0";
                };
            };
        }

        private function ShowLevelUpAnim():void
        {
            this.mAvatar.animLevelUp.visible = true;
        }

        public function SetPremiumAccountDuration(_arg_1:cPlayerData):void
        {
            var _local_3:dNumberVO;
            var _local_2:Number = _arg_1.GetPremiumDuration();
            if (((_local_2 == 0) && (_arg_1.GetPremiumExpireNotified() == 0)))
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.PREMIUM_ACCOUNT_EXPIRED, this);
                globalFlash.gui.mZoneBuffPanel.Refresh();
                _arg_1.SetPremiumExpireNotified(gMisc.GetEpochMillis());
                _local_3 = new dNumberVO();
                _local_3.value = _arg_1.GetPremiumExpireNotified();
                this.mGI.SendServerAction(COMMAND.PREMIUM_EXPIRE_NOTIFIED, 0, 0, 0, _local_3);
            };
        }

        public function EnablePvPRanksButton(_arg_1:Boolean):void
        {
            if (((global.ui.mCurrentPlayer.GetPlayerLevel() >= 30) && (_arg_1)))
            {
                this.mAvatar.pvpRankButton.enabled = true;
            }
            else
            {
                this.mAvatar.pvpRankButton.enabled = false;
            };
        }

        public function Init(_arg_1:Avatar):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mAvatar = _arg_1;
            this.mProgressBarWidth = this.mAvatar.progressBar.width;
            this.mAvatar.addEventListener(FlexEvent.CREATION_COMPLETE, this.completeHandler);
        }

        public function EnableAchievementsButton(_arg_1:Boolean):void
        {
            if (defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
            {
                this.mAvatar.achievement.enabled = false;
                this.mAvatar.achievement.toolTip = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AchievementTeaser");
            }
            else
            {
                this.mAvatar.achievement.enabled = _arg_1;
                this.mAvatar.achievement.toolTip = ((_arg_1) ? "" : cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "AchOnlyOnHome"));
            };
        }

        private function GetPvPProgressPercentage(_arg_1:int, _arg_2:int):Number
        {
            var _local_3:int;
            var _local_4:int;
            if (_arg_2 > 0)
            {
                if (_arg_2 == global.playerPvPLevels_vector.length)
                {
                    _local_3 = 0;
                }
                else
                {
                    _local_3 = (global.playerPvPLevels_vector[_arg_2].pvpXp - global.playerPvPLevels_vector[(_arg_2 - 1)].pvpXp);
                };
                _local_4 = (_arg_1 - global.playerPvPLevels_vector[(_arg_2 - 1)].pvpXp);
            }
            else
            {
                _local_3 = global.playerPvPLevels_vector[_arg_2].pvpXp;
                _local_4 = _arg_1;
            };
            return (((_local_4 == _local_3) || (_local_4 < 0)) ? 0 : (_local_4 / _local_3));
        }

        private function GetProgressPercentage(_arg_1:int, _arg_2:int):Number
        {
            var _local_3:int;
            var _local_4:int;
            if (_arg_2 > 0)
            {
                if (_arg_2 == global.playerLevels_vector.length)
                {
                    _local_3 = 0;
                }
                else
                {
                    _local_3 = (global.playerLevels_vector[_arg_2] - global.playerLevels_vector[(_arg_2 - 1)]);
                };
                _local_4 = (_arg_1 - global.playerLevels_vector[(_arg_2 - 1)]);
            }
            else
            {
                _local_3 = global.playerLevels_vector[_arg_2];
                _local_4 = _arg_1;
            };
            return (((_local_4 == _local_3) || (_local_4 < 0)) ? 0 : (_local_4 / _local_3));
        }


    }
}
