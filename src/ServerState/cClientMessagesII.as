package ServerState
{
    import Model.Observer;
    import nLib.cCustomDispatcher;
    import flash.utils.Timer;
    import Interface.cGameInterface;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import Interface.cGeneralInterface;
    import nLib.cLog;
    import flash.events.Event;
    import Enums.COMMAND;
    import flash.net.URLRequestMethod;
    import flash.net.URLLoaderDataFormat;
    import mx.controls.Alert;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import mx.events.CloseEvent;
    import mx.rpc.events.FaultEvent;
    import flash.events.IOErrorEvent;
    import Enums.ERROR_CODES;
    import GUI.Components.CustomAlert;
    import Communication.VO.dServerResponse;
    import Communication.VO.dServerActionResult;
    import flash.utils.getTimer;
    import flash.desktop.NativeApplication;
    import flash.events.TimerEvent;
    import Specialists.cSpecialist;
    import Communication.VO.Guild.dGuildVO;
    import Achievements.UserAchievementManager;
    import Communication.VO.DConsoleTextVO;
    import Communication.VO.UpdateVO.dQuestUpdateVO;
    import Communication.VO.dServerClientUpdateVO;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.UpdateVO.dAdventurePlayerVO;
    import Communication.VO.dAdventurePlayerListItemVO;
    import Communication.VO.dPlayerVO;
    import Communication.VO.dPlayerListItemVO;
    import Communication.VO.ColonyVO;
    import Communication.VO.UpdateVO.dTravellingSpecialistArivalVO;
    import Communication.VO.dZoneRefreshVO;
    import BuffSystem.cBuff;
    import Communication.VO.Mail.dNewMailCountVO;
    import Communication.VO.UpdateVO.dFindTreasureResponseVO;
    import Communication.VO.UpdateVO.dBattleResultVO;
    import Communication.VO.UpdateVO.dFindEventZoneResponseVO;
    import Communication.VO.UpdateVO.dFindExpeditionResponseVO;
    import Communication.VO.UpdateVO.dExploreSectorResponseVO;
    import Communication.VO.UpdateVO.dExploredSectorVO;
    import Map.cSector;
    import Specialists.cSpecialistTask_ExploreSector;
    import Communication.VO.UpdateVO.dAlertMessageVO;
    import GO.cBuilding;
    import Communication.VO.dAdventCalendarDoorVO;
    import Communication.VO.Votes.dVoteHistoryListVO;
    import Communication.VO.Votes.dPlayerVoteVO;
    import Communication.VO.dAdventureStateChangeVO;
    import Communication.VO.UpdateVO.MapItemUpdateVO;
    import Communication.VO.UpdateVO.dServerSettingVO;
    import Communication.VO.UpdateVO.BuffAmountDiffVO;
    import __AS3__.vec.Vector;
    import Achievements.UserAchievement;
    import GUI.Controller.dconsole.TsoConsole;
    import Communication.VO.UpdateVO.dAdventureExpiredVO;
    import GUI.GAME.cBasicPanel;
    import Enums.ADVENTURE_INVITATION_STATUS;
    import Enums.AVATAR_MESSAGE_TYPE;
    import Communication.VO.dGameTickCommandVO;
    import Colony.cColony;
    import Communication.VO.UpdateVO.dRemovedFriendVO;
    import GUI.ApplicationFacade;
    import GUI.GAME.avatarSelection.AvatarSelectionPanel;
    import Communication.VO.Mail.dMailVO;
    import Specialists.cSpecialistTask_FindTreasure;
    import Specialists.cSpecialistTask_AttackBuilding;
    import Specialists.cSpecialistTask_FindEventZone;
    import Specialists.cSpecialistTask_FindExpedition;
    import Enums.SPECIALIST_TASK_TYPES;
    import Communication.VO.Guild.dGuildUpdateVO;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Communication.VO.dClientDateVO;
    import Communication.VO.UpdateVO.dEnabledResourceDonationsVO;
    import Communication.VO.Achievements.UserAchievementTriggerValueUpdateVO;
    import Communication.VO.Achievements.UserAchievementTriggerFinishedUpdateVO;
    import Communication.VO.Achievements.UserAchievementFinishedUpdateVO;
    import Communication.VO.Guild.dGuildBankTransferVO;
    import Communication.VO.Guild.dGuildBankWithdrawVO;
    import Communication.VO.dBankDonationVO;
    import Communication.VO.dShowErrorVO;
    import Communication.VO.Guild.dGuildBankBuyTabVO;
    import Communication.VO.Guild.dGuildBankEnlargeVO;
    import Communication.VO.UpdateVO.dPickupListVO;
    import Communication.VO.UpdateVO.CooldownListVO;
    import Communication.VO.UpdateVO.GenericValueListVO;
    import Communication.VO.UpdateVO.dKillSwitchUpdateVO;
    import Communication.VO.ConditionFinishedVO;
    import Communication.VO.ConditionUpdatedVO;
    import Communication.VO.dSupportLockZone;
    import Communication.VO.Fulfilments.FulfilmentTriggerValueUpdateVO;
    import Communication.VO.Fulfilments.FulfilmentTriggerFinishedUpdateVO;
    import Communication.VO.Tasks.TaskDataVO;
    import Communication.VO.dContentGeneratorRollVO;
    import Achievements.AchievementsManager;
    import Utils.TriggerUtils;
    import mx.collections.ArrayCollection;
    import flash.events.HTTPStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IEventDispatcher;
    import Communication.VO.avatarSelection.UpdateUsernameAndAvatarVO;
    import GUI.GAME.Chat.TSOChatMediator;
    import Communication.VO.dGetFriendsVO;
    import Interface.gInitStaticForAllZones;
    import com.bluebyte.tso.util.ClientLogger;
    import Communication.VO.dClientTrackVO;
    import Model.Notifier;
    import mx.rpc.AsyncToken;
    import mx.rpc.remoting.RemoteObject;
    import Communication.VO.dServerCall;
    import nLib.gMisc;
    import mx.rpc.events.ResultEvent;
    import Communication.VO.dUniqueID;
    import flash.net.FileReference;
    import Communication.VO.Guild.dGuildEditValueVO;
    import Communication.VO.dUpdateVO;
    import Communication.VO.dResourceVO;
    import Communication.VO.dZoneVO;
    import Communication.VO.Guild.dGuildBankVO;
    import Communication.VO.dSettingsVO;
    import Communication.VO.dCombatPreviewResult;
    import Communication.VO.dServerAction;
    import Communication.VO.dStartSpecialistTaskVO;
    import GUI.share.ShareManager;
    import Communication.VO.UpdateVO.dAdventureResetVO;
    import flash.utils.Dictionary;
    import GUI.Effects.gHintManager;
    import Enums.ADVENTURE_TYPE;
    import Model.Notifiers.ZoneChannel;
    import Communication.VO.dZoneLoginVO;
    import Communication.VO.ColoniesListVO;
    import Communication.VO.dIntegerVO;
    import Communication.VO.avatarSelection.CheckUsernameVO;
    import Communication.VO.Mail.dMailHeaderResponseVO;
    import Communication.VO.TradeWindow.dTradeWindowResultVO;
    import Communication.VO.Guild.dGuildRankListItemVO;
    import Communication.VO.Guild.dGuildHeadersListVO;
    import GuildSystem.EDIT_TYPE;
    import flash.external.ExternalInterface;
    import mx.utils.StringUtil;
    import __AS3__.vec.*;

    public class cClientMessagesII implements Observer 
    {

        public static const RECEIVED_FROM_EXTERNAL_SERVER:Boolean = true;
        public static const RECEIVED_FROM_INTERNAL_SERVER:Boolean = true;
        public static const SHUTDOWN:int = 1;
        public static const AUTH_FAILED:int = 2;
        public static const OTHER_ERROR:int = 3;
        public static var mAuthToken:String;
        public static var mAuthUser:int = 0;
        public static var mAuthRandomClient:int = defines.CLIENT_AUTHRANDOM;
        private static var mSessionUserName:String;
        private static var mSessionID:String;
        private static var mInitialized:Boolean = false;
        private static var mDispatcher:cCustomDispatcher = new cCustomDispatcher();

        private var errorRetry:int = 0;
        private var mPacketLostUpdateTimer:Timer;
        public var mLastVisitedZoneID:int = 0;
        private var mNextKeepAlivePing:int;
        public var mLastResultServerName:String = "";
        private var mGetZoneData:Object;
        private var mGetZoneType:int = -1;
        private var mGetZoneID:int;
        private var mBigBrotherMessage:cBigBrotherMessage = null;
        private var mDebugZoneString:String = null;
        private var lockedAdventureId:int;
        private var mGameInterface:cGameInterface;

        private var mURLRequest:URLRequest = new URLRequest();
        private var mURLVariables:URLVariables = new URLVariables();
        private var mURLLoader:URLLoader = new URLLoader();

        public function cClientMessagesII(_arg_1:cGeneralInterface)
        {
            super();
            this.mGameInterface = (_arg_1 as cGameInterface);
        }

        private static function logMessageToBigBrotherFailed(_arg_1:Event):void
        {
            cLog.error("Cannot send disconnect log to BigBrother!");
        }

        public static function LogMessageToBigBrother(event:Event, token:Object=null):void
        {
            var classInfo:Object;
            var logMessage:String;
            var bbURLRequest:URLRequest;
            var bbURLVariables:URLVariables;
            var bbURLLoader:URLLoader;
        }


        public function InitializeServerCommunication():void
        {
            if (global.useExternalServer)
            {
                if (!global.useBigBrother)
                {
                    this.SendMessagetoServer(COMMAND.SESSION_AUTH, this.mGameInterface.mCurrentViewedZoneID, mAuthToken);
                    mInitialized = true;
                }
                else
                {
                    this.mURLRequest.url = (global.bigBrotherURL + "authenticate");
                    this.mURLRequest.method = URLRequestMethod.POST;
                    this.mURLVariables.DSOAUTHTOKEN = mAuthToken;
                    this.mURLVariables.DSOAUTHUSER = mAuthUser;
                    this.mURLRequest.data = this.mURLVariables;
                    this.mURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
                    this.ConfigureListeners(this.mURLLoader);
                    this.mURLLoader.load(this.mURLRequest);
                };
            }
            else
            {
                this.SendMessagetoServer(COMMAND.INIT_SERVER, this.mGameInterface.mCurrentViewedZoneID, null);
                mInitialized = true;
            };
        }

        private function handleCancelLockedAdventure(_arg_1:CloseEvent):void
        {
            if (_arg_1.detail == Alert.YES)
            {
                AdventureManager.getInstance().removeAdventure(this.lockedAdventureId);
                this.SendMessagetoServer(COMMAND.CANCEL_LOCKED_ADVENTURE, this.mGameInterface.mCurrentPlayer.getPlayerID(), this.lockedAdventureId);
            };
        }

        private function IoErrorHandler(_arg_1:IOErrorEvent):void
        {
            ClientLogger.log("[AUTH] " + _arg_1.text);
            if (this.errorRetry < cBigBrotherMessage.ERROR_RETRIES)
            {
                this.errorRetry++;
                this.mURLLoader.load(this.mURLRequest);
            }
            else
            {
                this.FaultHandler(new FaultEvent(((("IoError on BigBrother Authenticate : " + _arg_1.type) + " ") + _arg_1.text)));
            };
        }

        private function handleGuildErrorCodes(_arg_1:dServerResponse, _arg_2:dServerActionResult):void
        {
            var _local_4:String;
            var _local_3:* = "";
            if (_arg_2.data != null)
            {
                _local_3 = String(_arg_2.data);
            };
            LogMessageToBigBrother(new FaultEvent((((((("Guild ERROR CODE : " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
            switch (_arg_2.errorCode)
            {
                case ERROR_CODES.GUILD_TAB_NAME_INVALID:
                    this.mGameInterface.RefreshGuildBank();
                case ERROR_CODES.GUILD_HASGUILD:
                case ERROR_CODES.GUILD_FULL:
                case ERROR_CODES.GUILD_JOIN_COOLDOWN:
                case ERROR_CODES.GUILD_DISBANDED:
                case ERROR_CODES.GUILD_FOUND_NO_GUILDHOUSE:
                case ERROR_CODES.GUILD_SUCCESSION_ERROR:
                case ERROR_CODES.GUILD_ALREADY_APPLIED_ERROR:
                case ERROR_CODES.GUILD_ALREADY_IN_GUILD:
                case ERROR_CODES.GUILD_APPLICANTS_HAS_GUILD:
                case ERROR_CODES.GUILD_APPLICANT_COOLDOWN:
                    _local_4 = ERROR_CODES.toString(_arg_2.errorCode);
                    CustomAlert.show(_local_4, _local_4);
                    return;
                default:
                    CustomAlert.show(("Non handled Error: " + ERROR_CODES.toString(_arg_2.errorCode)), "Error", 4, null, null, null, 4, false);
            };
        }

        public function bigBrotherMessageCompleteHandler(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:String, _arg_5:Boolean, _arg_6:Responding):void
        {
            if (_arg_5)
            {
                this.mLastVisitedZoneID = _arg_2;
                this.mLastResultServerName = _arg_4;
                this.mBigBrotherMessage = null;
            };
            this.SendMessageDirectlyToServer(_arg_1, _arg_2, _arg_3, _arg_4, _arg_6);
        }

        public function SendGetZoneMessageToServer(_arg_1:int, _arg_2:int, _arg_3:Object):void
        {
            if (global.useBigBrother)
            {
                if (this.mBigBrotherMessage == null)
                {
                    this.mBigBrotherMessage = new cBigBrotherMessage(_arg_1, _arg_2, _arg_3, true);
                };
            }
            else
            {
                this.SendMessageDirectlyToServer(_arg_1, _arg_2, _arg_3, (global.bigBrotherURL + "/amf"));
            };
            if (this.mNextKeepAlivePing <= getTimer())
            {
                this.mNextKeepAlivePing = cConnectionManager.GetInstance().SendKeepAlivePing();
            };
        }

        public function handleKickHome(_arg_1:CloseEvent):void
        {
            (this.mGameInterface as cGameInterface).visitZone(this.mGameInterface.mCurrentPlayer.GetHomeZoneId());
        }

        private function handleRedirectClient(_arg_1:CloseEvent):void
        {
            NativeApplication.nativeApplication.exit(defines.EXIT_CODE_RESTART);
        }

        private function handlePacketLost():void
        {
            if (this.mGameInterface.mPacketLost)
            {
                if (new Date().time > (this.mGameInterface.mPacketLostTime + defines.CLIENT_PACKET_LOSS_TIMEOUT))
                {
                    this.handleConnectionLost();
                    return;
                };
            }
            else
            {
                this.mGameInterface.mPacketLost = true;
                this.mGameInterface.mPacketLostTime = new Date().time;
                globalFlash.gui.windowController.closeModal();
                globalFlash.gui.windowController.closeActiveWindows();
                globalFlash.gui.mPacketLostAlert.Show();
                globalFlash.gui.mOptionsPanel.ToggleEventWindowButton();
                if (this.mPacketLostUpdateTimer == null)
                {
                    this.mPacketLostUpdateTimer = new Timer(defines.PACKET_LOSS_MINIMUM_UPDATE_INTERVALL_MILLISECONDS);
                    this.mPacketLostUpdateTimer.addEventListener(TimerEvent.TIMER, this.sendUpdateCommandAfterPacketLoss);
                };
            };
            this.mPacketLostUpdateTimer.start();
        }

        private function handleGetUpdates(_updateVOs:ArrayCollection):void
        {
            var specialist:cSpecialist;
            var guildVO:dGuildVO;
            var userAchievementManager:UserAchievementManager;
            var updateVO:Object;
            var dConsoleTextVO:DConsoleTextVO;
            var questUpdateVO:dQuestUpdateVO;
            var serverClientUpdateVO:dServerClientUpdateVO;
            var serverTime:Number;
            var synchronizeTime:Number;
            var adventure:dAdventureClientInfoVO;
            var adventureDef:cAdventureDefinition;
            var msg:String;
            var tmpAdventure:dAdventureClientInfoVO;
            var adventurePlayerVO:dAdventurePlayerVO;
            var foundPlayer:Boolean;
            var changedPlayer:Boolean;
            var adventureDefinition:dAdventureClientInfoVO;
            var owner:dAdventurePlayerListItemVO;
            var adventurePlayer:dAdventurePlayerListItemVO;
            var playerIdx:int;
            var existingAdventurePlayerVO:dAdventurePlayerListItemVO;
            var newAdventurePlayerListItemVO:dAdventurePlayerListItemVO;
            var playerVO:dPlayerVO;
            var playerData:cPlayerData;
            var resources:cResources;
            var player:dPlayerListItemVO;
            var colony:ColonyVO;
            var zoneID:int;
            var travellingSpecialistArivalVO:dTravellingSpecialistArivalVO;
            var zoneRefreshVO:dZoneRefreshVO;
            var buff1:cBuff;
            var resultStringList:Array;
            var str:String;
            var newMailCountVO:dNewMailCountVO;
            var findTreasureResponseVO:dFindTreasureResponseVO;
            var battleResultVO:dBattleResultVO;
            var findEventZoneResponseVO:dFindEventZoneResponseVO;
            var findExpeditionResponseVO:dFindExpeditionResponseVO;
            var exploreSectorResponseVO:dExploreSectorResponseVO;
            var exploredSectorVO:dExploredSectorVO;
            var sector:cSector;
            var exploreSectorTask:cSpecialistTask_ExploreSector;
            var alertMessageVO:dAlertMessageVO;
            var motdChanged:Boolean;
            var guildBuilding:cBuilding;
            var upgradelevel:int;
            var k:* = undefined;
            var codename:String;
            var door:dAdventCalendarDoorVO;
            var updateDoor:dAdventCalendarDoorVO;
            var voteResult:dVoteHistoryListVO;
            var votePlayer:dPlayerVoteVO;
            var adventureStateChangeVO:dAdventureStateChangeVO;
            var adventureClientInfoVO:dAdventureClientInfoVO;
            var updateColonyVO:ColonyVO;
            var colonyVO:ColonyVO;
            var mapItemUpdateVO:MapItemUpdateVO;
            var buff:cBuff;
            var ssvo:dServerSettingVO;
            var buffAmountDiff:BuffAmountDiffVO;
            var getBuffByUniqueID:cBuff;
            var avatarMessages:Vector.<UserAchievement>;
            var ua:UserAchievement;
            var newPlayer:cPlayerData;
            var oldPlayer:cPlayerData;
            var found:Boolean;
            var i:int;
            var playerList:Vector.<cPlayerData> = new Vector.<cPlayerData>();
            var playerListUpdated:Boolean;
            var updateZoneID:int = -1;
            var userAchievementManagerUpdated:Boolean;
            for each (updateVO in _updateVOs)
            {
                if ((updateVO is DConsoleTextVO))
                {
                    dConsoleTextVO = (updateVO as DConsoleTextVO);
                    TsoConsole.print(dConsoleTextVO.text);
                }
                else
                {
                    if ((updateVO is dQuestUpdateVO))
                    {
                        questUpdateVO = (updateVO as dQuestUpdateVO);
                        this.mGameInterface.mQuestClientCallbacks.ReceivedMessagesFromServer(questUpdateVO);
                    }
                    else
                    {
                        if ((updateVO is dServerClientUpdateVO))
                        {
                            serverClientUpdateVO = (updateVO as dServerClientUpdateVO);
                            serverTime = serverClientUpdateVO.serverClientSynchronizationTime;
                            updateZoneID = serverClientUpdateVO.zoneId;
                            if (updateZoneID != this.mGameInterface.mHomePlayer.GetPlayerId())
                            {
                                this.mGameInterface.LocalLogMessage(((("UpdateVO is from different Zone Client: " + this.mGameInterface.mHomePlayer.GetPlayerId()) + " Server; ") + updateZoneID));
                                break;
                            };
                            synchronizeTime = (serverTime - this.mGameInterface.GetClientTime());
                            if (Math.abs(synchronizeTime) > 10)
                            {
                                if (Math.abs(synchronizeTime) > 50000)
                                {
                                    this.mGameInterface.mSynchronisationErrorBitField = (this.mGameInterface.mSynchronisationErrorBitField | cGeneralInterface.SYNCHRONISATION_ERROR_SERVER_CLIENT_TIME_MISMATCH);
                                    this.mGameInterface.LocalLogMessage(((("UpdateVO Time SynchronizationError Client: " + this.mGameInterface.GetClientTime()) + " Server; ") + serverTime));
                                }
                                else
                                {
                                    this.mGameInterface.mSynchronizetime = synchronizeTime;
                                };
                            };
                        }
                        else
                        {
                            if ((updateVO is dAdventureExpiredVO))
                            {
                                adventure = AdventureManager.getInstance().getAdventure(this.mGameInterface.mCurrentViewedZoneID);
                                msg = "AdventureZoneJustExpired";
                                if ((updateVO as dAdventureExpiredVO).cancelledByPlayer)
                                {
                                    cBasicPanel.HideCurrentActivePanel();
                                    if (AdventureManager.getInstance().getAdventure(this.mGameInterface.mCurrentViewedZoneID) != null)
                                    {
                                        if (AdventureManager.getInstance().getAdventure(this.mGameInterface.mCurrentViewedZoneID).ownerPlayerID != this.mGameInterface.mCurrentPlayer.getPlayerID())
                                        {
                                            CustomAlert.show("AdventureCanceled", "AdventureCanceled");
                                        };
                                        AdventureManager.getInstance().removeAdventure(this.mGameInterface.mCurrentViewedZoneID);
                                    };
                                    globalFlash.gui.mLoadingZonePanel.Show();
                                    global.ui.mClientMessages.SendGetZoneMessageToServer(COMMAND.GET_ZONE, this.mGameInterface.mCurrentPlayer.GetPlayerId(), false);
                                }
                                else
                                {
                                    if (adventure != null)
                                    {
                                        adventureDef = cAdventureDefinition.FindAdventureDefinition(adventure.adventureName);
                                        msg = ((adventureDef.IsExpedition()) ? "ExpeditionJustExpired" : "AdventureZoneJustExpired");
                                    }
                                    else
                                    {
                                        tmpAdventure = AdventureManager.getInstance().getLastRemovedAdventure();
                                        if (tmpAdventure != null)
                                        {
                                            adventureDef = cAdventureDefinition.FindAdventureDefinition(tmpAdventure.adventureName);
                                            msg = (((adventureDef.IsExpedition()) || (adventureDef.IsColony())) ? "ExpeditionJustExpired" : "AdventureZoneJustExpired");
                                        };
                                    };
                                    CustomAlert.show(msg, msg, Alert.OK, null, function ():void
                                    {
                                        cBasicPanel.HideCurrentActivePanel();
                                        if (AdventureManager.getInstance().getAdventure(mGameInterface.mCurrentViewedZoneID) != null)
                                        {
                                            AdventureManager.getInstance().removeAdventure(mGameInterface.mCurrentViewedZoneID);
                                        };
                                        globalFlash.gui.mLoadingZonePanel.Show();
                                        global.ui.mClientMessages.SendGetZoneMessageToServer(COMMAND.GET_ZONE, mGameInterface.mCurrentPlayer.GetPlayerId(), false);
                                    });
                                };
                            }
                            else
                            {
                                if ((updateVO is dAdventurePlayerVO))
                                {
                                    adventurePlayerVO = (updateVO as dAdventurePlayerVO);
                                    foundPlayer = false;
                                    changedPlayer = false;
                                    adventureDefinition = AdventureManager.getInstance().getAdventure(adventurePlayerVO.adventureID);
                                    if (adventureDefinition != null)
                                    {
                                        for each (adventurePlayer in adventureDefinition.players)
                                        {
                                            if (adventurePlayer.id == adventureDefinition.ownerPlayerID)
                                            {
                                                owner = adventurePlayer;
                                            };
                                        };
                                        playerIdx = 0;
                                        while (((playerIdx < adventureDefinition.players.length) && (!(foundPlayer))))
                                        {
                                            existingAdventurePlayerVO = adventureDefinition.players[playerIdx];
                                            if (existingAdventurePlayerVO.id == adventurePlayerVO.playerID)
                                            {
                                                foundPlayer = true;
                                                if (existingAdventurePlayerVO.status != adventurePlayerVO.status)
                                                {
                                                    switch (adventurePlayerVO.status)
                                                    {
                                                        case ADVENTURE_INVITATION_STATUS.PENDING:
                                                            break;
                                                        case ADVENTURE_INVITATION_STATUS.ACCEPTED:
                                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_ACCEPTED_INVITATION, {
                                                                "playerName":adventurePlayerVO.playerName,
                                                                "adventureName":adventureDefinition.adventureName
                                                            });
                                                            break;
                                                        case ADVENTURE_INVITATION_STATUS.DECLINED:
                                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_DECLINED_INVITATION, {
                                                                "playerName":adventurePlayerVO.playerName,
                                                                "adventureName":adventureDefinition.adventureName
                                                            });
                                                            break;
                                                        case ADVENTURE_INVITATION_STATUS.LEFT:
                                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_LEFT, {
                                                                "playerName":adventurePlayerVO.playerName,
                                                                "adventureName":adventureDefinition.adventureName
                                                            });
                                                            break;
                                                        case ADVENTURE_INVITATION_STATUS.CANCELLED:
                                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_INVITATION_CANCELLED, {
                                                                "playerName":adventurePlayerVO.playerName,
                                                                "adventureName":adventureDefinition.adventureName,
                                                                "owner":owner.username
                                                            });
                                                            break;
                                                    };
                                                };
                                                existingAdventurePlayerVO.status = adventurePlayerVO.status;
                                                if (!ADVENTURE_INVITATION_STATUS.IsActiveInvitation(existingAdventurePlayerVO.status))
                                                {
                                                    existingAdventurePlayerVO.status = adventurePlayerVO.status;
                                                    adventureDefinition.players.removeItemAt(playerIdx);
                                                };
                                                break;
                                            };
                                            playerIdx = (playerIdx + 1);
                                        };
                                        if (((!(foundPlayer)) && (adventurePlayerVO.status == ADVENTURE_INVITATION_STATUS.PENDING)))
                                        {
                                            newAdventurePlayerListItemVO = new dAdventurePlayerListItemVO().InitFromAdventurePlayerVO(adventurePlayerVO);
                                            adventureDefinition.players.addItem(newAdventurePlayerListItemVO);
                                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_WAS_INVITED, {
                                                "playerName":adventurePlayerVO.playerName,
                                                "adventureName":adventureDefinition.adventureName,
                                                "owner":owner.username
                                            });
                                            break;
                                        };
                                        if (globalFlash.gui.mAdventurePanel.IsVisible())
                                        {
                                            globalFlash.gui.mAdventurePanel.SetData(adventureDefinition);
                                        };
                                    };
                                }
                                else
                                {
                                    if ((updateVO is dPlayerVO))
                                    {
                                        if (!playerListUpdated)
                                        {
                                            playerListUpdated = true;
                                            playerList.push(this.mGameInterface.mCurrentPlayer);
                                        };
                                        playerVO = (updateVO as dPlayerVO);
                                        if (playerVO.userID != 0)
                                        {
                                            playerData = new cPlayerData(this.mGameInterface);
                                            resources = this.mGameInterface.mCurrentPlayerZone.GetResources(playerData);
                                            this.mGameInterface.mServer.CreatePlayerFromPlayerVO(playerData, playerVO, true);
                                            playerList.push(playerData);
                                        };
                                    }
                                    else
                                    {
                                        if ((updateVO is dGameTickCommandVO))
                                        {
                                            this.mGameInterface.AddGameTickCommand((updateVO as dGameTickCommandVO));
                                        }
                                        else
                                        {
                                            if ((updateVO is dPlayerListItemVO))
                                            {
                                                player = (updateVO as dPlayerListItemVO);
                                                if (player.id >= 0)
                                                {
                                                    globalFlash.gui.mFriendsList.AddConfirmedFriend(player);
                                                }
                                                else
                                                {
                                                    colony = this.mGameInterface.mCurrentPlayerZone.ColonyGet(player.adventureVO.colonyID);
                                                    if ((((!(player.adventureVO.IsColony())) || (colony == null)) || ((!(colony.state == cColony.STATUS_ASSIGNED)) && (!(colony.state == cColony.STATUS_WAIT_FOR_ASSIGNMENT)))))
                                                    {
                                                        if (((player.adventureVO.IsColony()) && (player.adventureVO.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK)))
                                                        {
                                                            player.adventureVO.ownerPlayerID = global.ui.mCurrentPlayer.GetPlayerId();
                                                        };
                                                        AdventureManager.getInstance().addAdventure(player.adventureVO);
                                                    };
                                                };
                                            }
                                            else
                                            {
                                                if ((updateVO is dRemovedFriendVO))
                                                {
                                                    zoneID = (updateVO as dRemovedFriendVO).removedFriendID;
                                                    if (zoneID >= 0)
                                                    {
                                                        globalFlash.gui.mFriendsList.RemoveFriendById(zoneID);
                                                    }
                                                    else
                                                    {
                                                        if (AdventureManager.getInstance().getAdventure(zoneID) != null)
                                                        {
                                                            AdventureManager.getInstance().removeAdventure(zoneID);
                                                        };
                                                    };
                                                }
                                                else
                                                {
                                                    if ((updateVO is dTravellingSpecialistArivalVO))
                                                    {
                                                        travellingSpecialistArivalVO = (updateVO as dTravellingSpecialistArivalVO);
                                                        specialist = cSpecialist.CreateSpecialistWithOutTasksFromVO(this.mGameInterface, travellingSpecialistArivalVO.specialistVO, false);
                                                        this.mGameInterface.mCurrentPlayerZone.addSpecialist(specialist);
                                                        cSpecialist.LoadSpecialistTasks(this.mGameInterface, travellingSpecialistArivalVO.specialistVO, false, specialist);
                                                    }
                                                    else
                                                    {
                                                        if ((updateVO is dZoneRefreshVO))
                                                        {
                                                            globalFlash.gui.mTradeWindow.allowHistoryUpdate = true;
                                                            globalFlash.gui.mTradeWindow.allowSellingUpdate = true;
                                                            zoneRefreshVO = (updateVO as dZoneRefreshVO);
                                                            if ((zoneRefreshVO.refreshReason & cGeneralInterface.SYNCHRONISATION_ERROR_PACKET_LOST) != 0)
                                                            {
                                                                for each (buff1 in this.mGameInterface.mCurrentPlayer.mAvailableBuffs_vector)
                                                                {
                                                                    buff1.SetWaitingForServerCount(0, this.mGameInterface);
                                                                };
                                                                this.mGameInterface.mQuestClientCallbacks.CleanQuestPool();
                                                                this.mGameInterface.mPacketLost = false;
                                                                this.mGameInterface.mPacketLostTime = 0;
                                                                globalFlash.gui.mOptionsPanel.ToggleEventWindowButton();
                                                                globalFlash.gui.mPacketLostAlert.Hide();
                                                                ApplicationFacade.getInstance().sendNotification(AvatarSelectionPanel.CHECK_SHOW, global.ui);
                                                            };
                                                            this.mGameInterface.mServer.RefreshZone(zoneRefreshVO.zoneVO, true, false, defines.STORE_ZONE_DELTA);
                                                            if ((zoneRefreshVO.refreshReason & cGeneralInterface.SYNCHRONISATION_ERROR_MISSED_GAMETICK) != 0)
                                                            {
                                                                cLog.info(((("Zone refresh: Gametick missed on client time " + this.mGameInterface.GetClientTime()) + ": set post process time to ") + zoneRefreshVO.gameTickPostProcessTime));
                                                                this.mGameInterface.GameTickSystemPostProcessTime = zoneRefreshVO.gameTickPostProcessTime;
                                                            }
                                                            else
                                                            {
                                                                if (cLog.isInfoEnabled())
                                                                {
                                                                    cLog.info(((("Zone Refresh: Synchronisation error on client time " + this.mGameInterface.GetClientTime()) + " with reason ") + zoneRefreshVO.refreshReason));
                                                                    if (zoneRefreshVO.resultString)
                                                                    {
                                                                        resultStringList = zoneRefreshVO.resultString.split("\n");
                                                                        for each (str in resultStringList)
                                                                        {
                                                                            cLog.info(str);
                                                                        };
                                                                    };
                                                                };
                                                            };
                                                        }
                                                        else
                                                        {
                                                            if ((updateVO is dNewMailCountVO))
                                                            {
                                                                newMailCountVO = (updateVO as dNewMailCountVO);
                                                                if (newMailCountVO.count > 0)
                                                                {
                                                                    globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.NEW_MAIL);
                                                                    globalFlash.gui.mAvatar.ShowMailNotification();
                                                                };
                                                            }
                                                            else
                                                            {
                                                                if ((updateVO is dMailVO))
                                                                {
                                                                    globalFlash.gui.mMailWindow.putMailInCache((updateVO as dMailVO));
                                                                }
                                                                else
                                                                {
                                                                    if ((updateVO is dFindTreasureResponseVO))
                                                                    {
                                                                        findTreasureResponseVO = (updateVO as dFindTreasureResponseVO);
                                                                        specialist = this.mGameInterface.mCurrentPlayerZone.getSpecialist(findTreasureResponseVO.specialistPlayerID, findTreasureResponseVO.specialistUniqueId);
                                                                        if ((((!(specialist == null)) && (!(specialist.GetTask() == null))) && (specialist.GetTask() is cSpecialistTask_FindTreasure)))
                                                                        {
                                                                            (specialist.GetTask() as cSpecialistTask_FindTreasure).SetFindTreasureResponseVO(findTreasureResponseVO);
                                                                        };
                                                                    }
                                                                    else
                                                                    {
                                                                        if ((updateVO is dBattleResultVO))
                                                                        {
                                                                            battleResultVO = (updateVO as dBattleResultVO);
                                                                            specialist = this.mGameInterface.mCurrentPlayerZone.getSpecialist(battleResultVO.specialistPlayerID, battleResultVO.specialistUniqueID);
                                                                            if ((((!(specialist == null)) && (!(specialist.GetTask() == null))) && (specialist.GetTask() is cSpecialistTask_AttackBuilding)))
                                                                            {
                                                                                (specialist.GetTask() as cSpecialistTask_AttackBuilding).SetBattleResultVO(battleResultVO);
                                                                            };
                                                                        }
                                                                        else
                                                                        {
                                                                            if ((updateVO is dFindEventZoneResponseVO))
                                                                            {
                                                                                findEventZoneResponseVO = (updateVO as dFindEventZoneResponseVO);
                                                                                specialist = this.mGameInterface.mCurrentPlayerZone.getSpecialist(this.mGameInterface.mHomePlayer.GetPlayerId(), findEventZoneResponseVO.specialistUniqueId);
                                                                                if (specialist != null)
                                                                                {
                                                                                    if (((!(specialist.GetTask() == null)) && (specialist.GetTask() is cSpecialistTask_FindEventZone)))
                                                                                    {
                                                                                        cLog.info(((("Applying " + findEventZoneResponseVO) + " to ") + specialist));
                                                                                        (specialist.GetTask() as cSpecialistTask_FindEventZone).SetFindEventZoneResponseVO(findEventZoneResponseVO);
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        cLog.warning((((("Could not apply " + updateVO) + " to ") + specialist) + " because he has no task or it is not a 'Find Event Zone' task!"));
                                                                                    };
                                                                                };
                                                                            }
                                                                            else
                                                                            {
                                                                                if ((updateVO is dFindExpeditionResponseVO))
                                                                                {
                                                                                    findExpeditionResponseVO = (updateVO as dFindExpeditionResponseVO);
                                                                                    specialist = this.mGameInterface.mCurrentPlayerZone.getSpecialist(this.mGameInterface.mHomePlayer.GetPlayerId(), findExpeditionResponseVO.specialistUniqueId);
                                                                                    if (specialist != null)
                                                                                    {
                                                                                        if (((!(specialist.GetTask() == null)) && (specialist.GetTask() is cSpecialistTask_FindExpedition)))
                                                                                        {
                                                                                            cLog.info(((("Applying " + findExpeditionResponseVO) + " to ") + specialist));
                                                                                            (specialist.GetTask() as cSpecialistTask_FindExpedition).SetFindExpeditionResponseVO(findExpeditionResponseVO);
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            cLog.warning((((("Could not apply " + updateVO) + " to ") + specialist) + " because he has no task or it is not a 'Find Expedition Zone' task!"));
                                                                                        };
                                                                                    };
                                                                                }
                                                                                else
                                                                                {
                                                                                    if ((updateVO is dExploreSectorResponseVO))
                                                                                    {
                                                                                        exploreSectorResponseVO = (updateVO as dExploreSectorResponseVO);
                                                                                        for each (exploredSectorVO in exploreSectorResponseVO.exploredSectors_vector)
                                                                                        {
                                                                                            specialist = this.mGameInterface.mCurrentPlayerZone.getSpecialist(this.mGameInterface.mHomePlayer.GetPlayerId(), exploredSectorVO.specialistID);
                                                                                            if (specialist != null)
                                                                                            {
                                                                                                cLog.info(((((("cClientMessagesII.ReceivedMessageFromServer: " + specialist) + " explored sector ") + sector) + ". His task is ") + specialist.GetTask()));
                                                                                                sector = this.mGameInterface.mCurrentPlayerZone.mSectorList_vector[exploredSectorVO.sectorID];
                                                                                                if (((!(specialist.GetTask() == null)) && (specialist.GetTask().GetType() == SPECIALIST_TASK_TYPES.EXPLORE)))
                                                                                                {
                                                                                                    exploreSectorTask = (specialist.GetTask() as cSpecialistTask_ExploreSector);
                                                                                                    exploreSectorTask.SetExploredSector(sector);
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    cLog.warning((specialist + " has no 'Explore Sector' task! Ignoring 'Explored Sector' message."));
                                                                                                };
                                                                                            };
                                                                                        };
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        if ((updateVO is dAlertMessageVO))
                                                                                        {
                                                                                            alertMessageVO = (updateVO as dAlertMessageVO);
                                                                                            CustomAlert.show(alertMessageVO.alertMessage, alertMessageVO.alertMessage, Alert.OK);
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            if ((updateVO is dGuildUpdateVO))
                                                                                            {
                                                                                                motdChanged = false;
                                                                                                guildVO = (updateVO as dGuildUpdateVO).guild;
                                                                                                if ((((guildVO) && (this.mGameInterface.GetCurrentPlayerGuild())) && (!(guildVO.motd == this.mGameInterface.GetCurrentPlayerGuild().motd))))
                                                                                                {
                                                                                                    motdChanged = true;
                                                                                                };
                                                                                                this.mGameInterface.SetCurrentPlayerGuild(guildVO);
                                                                                                globalFlash.gui.mGuildWindow.RefreshOwnGuild();
                                                                                                this.mGameInterface.mQuestClientCallbacks.RefreshLastQuestList(null);
                                                                                                if (guildVO != null)
                                                                                                {
                                                                                                    this.mGameInterface.joinGuildChannels();
                                                                                                    this.mGameInterface.mCurrentPlayerZone.mStreetDataMap.UpdateGuildHousesBuildingLevel();
                                                                                                    this.mGameInterface.mHomePlayer.updateGuild(guildVO);
                                                                                                    this.mGameInterface.mCurrentPlayer.updateGuild(guildVO);
                                                                                                    guildBuilding = this.mGameInterface.mCurrentPlayerZone.mStreetDataMap.GetGuildHouse();
                                                                                                    if (guildBuilding)
                                                                                                    {
                                                                                                        upgradelevel = 0;
                                                                                                        for (k in global.guildUpgradeLevels)
                                                                                                        {
                                                                                                            if (guildVO.maxSize >= global.guildUpgradeLevels[k])
                                                                                                            {
                                                                                                                upgradelevel = k;
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                break;
                                                                                                            };
                                                                                                        };
                                                                                                        guildBuilding.SetUpgradeLevel(upgradelevel);
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        guildBuilding = this.mGameInterface.mCurrentPlayerZone.mStreetDataMap.GetGuildHouse();
                                                                                                        if (guildBuilding)
                                                                                                        {
                                                                                                            guildBuilding.SetUpgradeLevel(1);
                                                                                                        };
                                                                                                    };
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    globalFlash.gui.mChatPanel.leaveGuildChannels();
                                                                                                };
                                                                                                if (motdChanged)
                                                                                                {
                                                                                                    globalFlash.gui.mChatPanel.PutMessageToChannelWithoutServer(("gc_" + guildVO.id), new Date(), cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "chatguild"), guildVO.motd, false, false);
                                                                                                };
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                if (!(updateVO is dClientDateVO))
                                                                                                {
                                                                                                    if ((updateVO is dEnabledResourceDonationsVO))
                                                                                                    {
                                                                                                        global.eventDonations.update((updateVO as dEnabledResourceDonationsVO));
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        if ((updateVO is UserAchievementTriggerValueUpdateVO))
                                                                                                        {
                                                                                                            userAchievementManager = this.mGameInterface.getCurrentUserAchievementManager();
                                                                                                            userAchievementManager.updateAchievementValue((updateVO as UserAchievementTriggerValueUpdateVO));
                                                                                                            userAchievementManagerUpdated = true;
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            if ((updateVO is UserAchievementTriggerFinishedUpdateVO))
                                                                                                            {
                                                                                                                userAchievementManager = this.mGameInterface.getCurrentUserAchievementManager();
                                                                                                                userAchievementManager.setTriggerAchievementFinished((updateVO as UserAchievementTriggerFinishedUpdateVO));
                                                                                                                userAchievementManagerUpdated = true;
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                if ((updateVO is UserAchievementFinishedUpdateVO))
                                                                                                                {
                                                                                                                    userAchievementManager = this.mGameInterface.getCurrentUserAchievementManager();
                                                                                                                    userAchievementManager.addAchievementFinishedVO((updateVO as UserAchievementFinishedUpdateVO));
                                                                                                                    userAchievementManagerUpdated = true;
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    if ((updateVO is dGuildBankTransferVO))
                                                                                                                    {
                                                                                                                        this.mGameInterface.CreateImmediateGameTickCommand(global.ui.mCurrentPlayer.GetPlayerId(), COMMAND.GUILD_BANK_TRANSFER, updateVO, 0);
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        if ((updateVO is dGuildBankWithdrawVO))
                                                                                                                        {
                                                                                                                            this.mGameInterface.CreateImmediateGameTickCommand(global.ui.mCurrentPlayer.GetPlayerId(), COMMAND.GUILD_BANK_WITHDRAW, updateVO, 0);
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            if ((updateVO is dBankDonationVO))
                                                                                                                            {
                                                                                                                                if ((updateVO as dBankDonationVO).tabId > 0)
                                                                                                                                {
                                                                                                                                    this.mGameInterface.CreateImmediateGameTickCommand(global.ui.mCurrentPlayer.GetPlayerId(), COMMAND.GUILD_DONATE_RESOURCE, updateVO, 0);
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    this.mGameInterface.CreateImmediateGameTickCommand(global.ui.mCurrentPlayer.GetPlayerId(), COMMAND.EVENT_DONATE_RESOURCE, updateVO, 0);
                                                                                                                                };
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                if ((updateVO is dShowErrorVO))
                                                                                                                                {
                                                                                                                                    codename = ERROR_CODES.toString((updateVO as dShowErrorVO).errorCode);
                                                                                                                                    CustomAlert.show(codename, codename);
                                                                                                                                    if ((updateVO as dShowErrorVO).errorCode <= ERROR_CODES.GUILD_BANK_ERROR)
                                                                                                                                    {
                                                                                                                                        globalFlash.gui.mGuildBankWindow.ResetAfterError();
                                                                                                                                    };
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    if ((updateVO is dGuildBankBuyTabVO))
                                                                                                                                    {
                                                                                                                                        this.mGameInterface.CreateImmediateGameTickCommand(global.ui.mCurrentPlayer.GetPlayerId(), COMMAND.GUILD_BANK_BUY_TAB, updateVO, 0);
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        if ((updateVO is dGuildBankEnlargeVO))
                                                                                                                                        {
                                                                                                                                            this.mGameInterface.CreateImmediateGameTickCommand(global.ui.mCurrentPlayer.GetPlayerId(), COMMAND.GUILD_BANK_ENLARGE, updateVO, 0);
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            if ((updateVO is dAdventCalendarDoorVO))
                                                                                                                                            {
                                                                                                                                                if (this.mGameInterface.mAdventCalendarManager.GetDoorById((updateVO as dAdventCalendarDoorVO).id) == null)
                                                                                                                                                {
                                                                                                                                                    door = (updateVO as dAdventCalendarDoorVO).Clone();
                                                                                                                                                    this.mGameInterface.mAdventCalendarManager.AddInitialDoor(door);
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                    updateDoor = (updateVO as dAdventCalendarDoorVO);
                                                                                                                                                    this.mGameInterface.mAdventCalendarManager.GetDoorById(updateDoor.id).status = updateDoor.status;
                                                                                                                                                    globalFlash.gui.mAdventWindow.UpdateGUI();
                                                                                                                                                };
                                                                                                                                                this.mGameInterface.mAdventCalendarManager.UpdateHintPointer();
                                                                                                                                                globalFlash.gui.mAvatar.Refresh();
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                                                                                                                                                if ((updateVO is dVoteHistoryListVO))
                                                                                                                                                {
                                                                                                                                                    voteResult = (updateVO as dVoteHistoryListVO);
                                                                                                                                                    this.mGameInterface.mVotesManager.SetHistoryVotedShopItems(voteResult.votesHistoryList);
                                                                                                                                                    globalFlash.gui.mGuildWindow.RefreshGuildMarket();
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                    if ((updateVO is dPlayerVoteVO))
                                                                                                                                                    {
                                                                                                                                                        votePlayer = (updateVO as dPlayerVoteVO);
                                                                                                                                                        this.mGameInterface.mVotesManager.SetPlayerVote(votePlayer);
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        if ((updateVO is dAdventureStateChangeVO))
                                                                                                                                                        {
                                                                                                                                                            adventureStateChangeVO = (updateVO as dAdventureStateChangeVO);
                                                                                                                                                            adventureClientInfoVO = AdventureManager.getInstance().getAdventure(adventureStateChangeVO.adventureId);
                                                                                                                                                            if (adventureClientInfoVO != null)
                                                                                                                                                            {
                                                                                                                                                                adventureClientInfoVO.status = adventureStateChangeVO.state;
                                                                                                                                                                adventureClientInfoVO.troopLimit = adventureStateChangeVO.troopLimit;
                                                                                                                                                                adventureClientInfoVO.admiralCount = adventureStateChangeVO.admiralCount;
                                                                                                                                                            };
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            if ((updateVO is ColonyVO))
                                                                                                                                                            {
                                                                                                                                                                updateColonyVO = (updateVO as ColonyVO);
                                                                                                                                                                colonyVO = this.mGameInterface.mCurrentPlayerZone.ColonyGet(updateColonyVO.colonyId);
                                                                                                                                                                if (colonyVO != null)
                                                                                                                                                                {
                                                                                                                                                                    if (updateColonyVO.ownerPlayerId != this.mGameInterface.mCurrentPlayer.GetPlayerId())
                                                                                                                                                                    {
                                                                                                                                                                        this.mGameInterface.mCurrentPlayerZone.ColonyRemove(colonyVO.colonyId);
                                                                                                                                                                    }
                                                                                                                                                                    else
                                                                                                                                                                    {
                                                                                                                                                                        colonyVO.state = updateColonyVO.state;
                                                                                                                                                                    };
                                                                                                                                                                }
                                                                                                                                                                else
                                                                                                                                                                {
                                                                                                                                                                    this.mGameInterface.mCurrentPlayerZone.ColonyAdd(updateColonyVO);
                                                                                                                                                                };
                                                                                                                                                                globalFlash.gui.mColonyWindow.Refresh();
                                                                                                                                                            }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                                if ((updateVO is MapItemUpdateVO))
                                                                                                                                                                {
                                                                                                                                                                    mapItemUpdateVO = (updateVO as MapItemUpdateVO);
                                                                                                                                                                    buff = this.mGameInterface.mCurrentPlayer.getBuffByUniqueID(mapItemUpdateVO.uniqueId);
                                                                                                                                                                    if (buff != null)
                                                                                                                                                                    {
                                                                                                                                                                        buff.SetMapLevel(mapItemUpdateVO.mapLevel);
                                                                                                                                                                    };
                                                                                                                                                                }
                                                                                                                                                                else
                                                                                                                                                                {
                                                                                                                                                                    if ((updateVO is dPickupListVO))
                                                                                                                                                                    {
                                                                                                                                                                        this.mGameInterface.pickupManager.updatePickups((updateVO as dPickupListVO).list);
                                                                                                                                                                    }
                                                                                                                                                                    else
                                                                                                                                                                    {
                                                                                                                                                                        if ((updateVO is CooldownListVO))
                                                                                                                                                                        {
                                                                                                                                                                            this.mGameInterface.cooldownManager.updateFromList((updateVO as CooldownListVO).list);
                                                                                                                                                                        }
                                                                                                                                                                        else
                                                                                                                                                                        {
                                                                                                                                                                            if ((updateVO is GenericValueListVO))
                                                                                                                                                                            {
                                                                                                                                                                                this.mGameInterface.genericValueManager.updateFrom((updateVO as GenericValueListVO).list);
                                                                                                                                                                            }
                                                                                                                                                                            else
                                                                                                                                                                            {
                                                                                                                                                                                if ((updateVO is dKillSwitchUpdateVO))
                                                                                                                                                                                {
                                                                                                                                                                                    this.mGameInterface.killswitch.update((updateVO as dKillSwitchUpdateVO));
                                                                                                                                                                                }
                                                                                                                                                                                else
                                                                                                                                                                                {
                                                                                                                                                                                    if ((updateVO is dServerSettingVO))
                                                                                                                                                                                    {
                                                                                                                                                                                        ssvo = (updateVO as dServerSettingVO);
                                                                                                                                                                                    }
                                                                                                                                                                                    else
                                                                                                                                                                                    {
                                                                                                                                                                                        if ((updateVO is ConditionFinishedVO))
                                                                                                                                                                                        {
                                                                                                                                                                                            this.mGameInterface.mConditionManager.setTriggerFinished((updateVO as ConditionFinishedVO));
                                                                                                                                                                                        }
                                                                                                                                                                                        else
                                                                                                                                                                                        {
                                                                                                                                                                                            if ((updateVO is ConditionUpdatedVO))
                                                                                                                                                                                            {
                                                                                                                                                                                                this.mGameInterface.mConditionManager.updateConditionValue((updateVO as ConditionUpdatedVO));
                                                                                                                                                                                            }
                                                                                                                                                                                            else
                                                                                                                                                                                            {
                                                                                                                                                                                                if ((updateVO is dSupportLockZone))
                                                                                                                                                                                                {
                                                                                                                                                                                                    globalFlash.gui.mSupportLockZone.setMilliseconds((updateVO as dSupportLockZone).lockTime);
                                                                                                                                                                                                    globalFlash.gui.mSupportLockZone.Show();
                                                                                                                                                                                                    cLog.info("Support locked zone");
                                                                                                                                                                                                }
                                                                                                                                                                                                else
                                                                                                                                                                                                {
                                                                                                                                                                                                    if ((updateVO is FulfilmentTriggerValueUpdateVO))
                                                                                                                                                                                                    {
                                                                                                                                                                                                        if (this.mGameInterface.getCurrentTaskManager() != null)
                                                                                                                                                                                                        {
                                                                                                                                                                                                            this.mGameInterface.getCurrentTaskManager().updateIdentityValue((updateVO as FulfilmentTriggerValueUpdateVO));
                                                                                                                                                                                                        };
                                                                                                                                                                                                    }
                                                                                                                                                                                                    else
                                                                                                                                                                                                    {
                                                                                                                                                                                                        if ((updateVO is FulfilmentTriggerFinishedUpdateVO))
                                                                                                                                                                                                        {
                                                                                                                                                                                                            if (this.mGameInterface.getCurrentTaskManager() != null)
                                                                                                                                                                                                            {
                                                                                                                                                                                                                this.mGameInterface.getCurrentTaskManager().setTriggerIdentityFinished((updateVO as FulfilmentTriggerFinishedUpdateVO));
                                                                                                                                                                                                            };
                                                                                                                                                                                                        }
                                                                                                                                                                                                        else
                                                                                                                                                                                                        {
                                                                                                                                                                                                            if ((updateVO is TaskDataVO))
                                                                                                                                                                                                            {
                                                                                                                                                                                                                this.mGameInterface.innerBuildTaskManager((updateVO as TaskDataVO), this.mGameInterface.mCurrentPlayerZone.mStreetDataMap.getTaskBuildings_vector());
                                                                                                                                                                                                            }
                                                                                                                                                                                                            else
                                                                                                                                                                                                            {
                                                                                                                                                                                                                if ((updateVO is dContentGeneratorRollVO))
                                                                                                                                                                                                                {
                                                                                                                                                                                                                    this.mGameInterface.mContentGeneratorManager.ApplyRollResult(updateVO);
                                                                                                                                                                                                                    this.mGameInterface.mContentGeneratorManager.ApplyRollResultUI(updateVO);
                                                                                                                                                                                                                }
                                                                                                                                                                                                                else
                                                                                                                                                                                                                {
                                                                                                                                                                                                                    if ((updateVO is BuffAmountDiffVO))
                                                                                                                                                                                                                    {
                                                                                                                                                                                                                        buffAmountDiff = (updateVO as BuffAmountDiffVO);
                                                                                                                                                                                                                        getBuffByUniqueID = this.mGameInterface.mCurrentPlayer.getBuffByUniqueID(buffAmountDiff.uniqueID);
                                                                                                                                                                                                                        if (getBuffByUniqueID != null)
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                            getBuffByUniqueID.SetAmount((getBuffByUniqueID.GetAmount() + buffAmountDiff.amountDiff));
                                                                                                                                                                                                                        };
                                                                                                                                                                                                                    };
                                                                                                                                                                                                                };
                                                                                                                                                                                                            };
                                                                                                                                                                                                        };
                                                                                                                                                                                                    };
                                                                                                                                                                                                };
                                                                                                                                                                                            };
                                                                                                                                                                                        };
                                                                                                                                                                                    };
                                                                                                                                                                                };
                                                                                                                                                                            };
                                                                                                                                                                        };
                                                                                                                                                                    };
                                                                                                                                                                };
                                                                                                                                                            };
                                                                                                                                                        };
                                                                                                                                                    };
                                                                                                                                                };
                                                                                                                                            };
                                                                                                                                        };
                                                                                                                                    };
                                                                                                                                };
                                                                                                                            };
                                                                                                                        };
                                                                                                                    };
                                                                                                                };
                                                                                                            };
                                                                                                        };
                                                                                                    };
                                                                                                };
                                                                                            };
                                                                                        };
                                                                                    };
                                                                                };
                                                                            };
                                                                        };
                                                                    };
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (userAchievementManagerUpdated)
            {
                avatarMessages = userAchievementManager.getFinishedAchievements();
                if (!defines.ACHIEVEMENT_THROTTLE_MODE_ACTIVE)
                {
                    if (avatarMessages.length > AchievementsManager.getMaxNumberOfAchievementAvatarPopupsToShow())
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.MORE_ACHIEVEMENTS_FINISHED, avatarMessages.length);
                    }
                    else
                    {
                        for each (ua in avatarMessages)
                        {
                            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.ACHIEVEMENT_FINISHED, ua);
                        };
                    };
                    userAchievementManager.consumeAchievementFinishedVOs();
                };
                globalFlash.gui.mAvatar.updateAchievementPoints();
                userAchievementManager.allUpdatesHandled();
            };
            if (playerListUpdated)
            {
                for each (newPlayer in playerList)
                {
                    found = false;
                    i = 0;
                    while (i < this.mGameInterface.GetPlayerList_vector().length)
                    {
                        oldPlayer = this.mGameInterface.GetPlayerList_vector()[i];
                        if (oldPlayer.GetPlayerId() == newPlayer.GetPlayerId())
                        {
                            this.mGameInterface.GetPlayerList_vector()[i] = newPlayer;
                            if (((!(this.mGameInterface.mCurrentPlayer == newPlayer)) && (this.mGameInterface.mCurrentPlayer.GetPlayerId() == newPlayer.GetPlayerId())))
                            {
                                this.mGameInterface.mCurrentPlayer.updateFrom(newPlayer);
                            };
                            if (((!(this.mGameInterface.mHomePlayer == this.mGameInterface.mCurrentPlayer)) && (this.mGameInterface.mHomePlayer.GetPlayerId() == newPlayer.GetPlayerId())))
                            {
                                this.mGameInterface.mHomePlayer.updateFrom(newPlayer);
                            };
                            found = true;
                            break;
                        };
                        i = (i + 1);
                    };
                    if (!found)
                    {
                        this.mGameInterface.GetPlayerList_vector().push(newPlayer);
                    };
                };
                i = 0;
                while (i < this.mGameInterface.GetPlayerList_vector().length)
                {
                    found = false;
                    oldPlayer = this.mGameInterface.GetPlayerList_vector()[i];
                    for each (newPlayer in playerList)
                    {
                        if (oldPlayer.GetPlayerId() == newPlayer.GetPlayerId())
                        {
                            found = true;
                            break;
                        };
                    };
                    if (!found)
                    {
                        this.mGameInterface.GetPlayerList_vector().splice(i, 1);
                        i = (i - 1);
                    };
                    i = (i + 1);
                };
            };
            if (this.mGameInterface.mCurrentPlayer == this.mGameInterface.mHomePlayer)
            {
                globalFlash.gui.mAvatar.SetData(this.mGameInterface.mCurrentPlayer, this.mGameInterface.GetPlayerList_vector());
            }
            else
            {
                globalFlash.gui.mAvatar.SetPremiumAccountDuration(this.mGameInterface.mCurrentPlayer);
            };
            this.mGameInterface.channels.QUEST.notifyPropertyObserver(TriggerUtils.ZONE_UPDATED, null);
        }

        private function ConfigureListeners(_arg_1:IEventDispatcher):void
        {
            _arg_1.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.HttpStatusHandler);
            _arg_1.addEventListener(Event.COMPLETE, this.CompleteHandler);
            _arg_1.addEventListener(IOErrorEvent.IO_ERROR, this.IoErrorHandler);
            _arg_1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.SecurityErrorHandler);
        }

        public function getClientSession():int
        {
            return (mAuthRandomClient);
        }

        private function SecurityErrorHandler(_arg_1:SecurityErrorEvent):void
        {
            ClientLogger.log("[AUTH] " + _arg_1.text);
            if (this.errorRetry < cBigBrotherMessage.ERROR_RETRIES)
            {
                this.errorRetry++;
                this.mURLLoader.load(this.mURLRequest);
            }
            else
            {
                this.FaultHandler(new FaultEvent(((("SecurityError on BigBrother Authenticate : " + _arg_1.type) + " ") + _arg_1.text)));
            };
        }

        private function handleUpdatePlayerInfoAndUsername(_arg_1:dServerActionResult):void
        {
            var _local_3:cPlayerData;
            var _local_2:UpdateUsernameAndAvatarVO = (_arg_1.data as UpdateUsernameAndAvatarVO);
            if (_local_2.changeSuccessful)
            {
                TSOChatMediator.setHandShakeObject(_local_2.handShakeVO);
                if (_local_2 != null)
                {
                    mSessionUserName = _local_2.username;
                };
                this.mGameInterface.mCurrentPlayer.SetAvatarId(_local_2.avatarId);
                this.mGameInterface.mCurrentPlayer.SetPlayerName(_local_2.username);
                this.mGameInterface.mCurrentPlayer.invalidatePlayerListItem();
                _local_3 = this.mGameInterface.FindPlayerFromId(this.mGameInterface.mCurrentPlayer.GetPlayerId());
                _local_3.SetAvatarId(_local_2.avatarId);
                _local_3.SetPlayerName(_local_2.username);
                _local_3.invalidatePlayerListItem();
                globalFlash.gui.mAvatar.SetData(this.mGameInterface.mCurrentPlayer, this.mGameInterface.GetPlayerList_vector());
                globalFlash.gui.mFriendsList.Refresh();
                this.mGameInterface.CreateGameTickCommand(this.mGameInterface.mCurrentPlayer.GetPlayerId(), COMMAND.INIT_CHAT, null, 1000);
            };
        }

        private function handleUpdatePlayerInfo(_arg_1:dServerActionResult):void
        {
            var _local_2:UpdateUsernameAndAvatarVO = (_arg_1.data as UpdateUsernameAndAvatarVO);
            this.mGameInterface.mCurrentPlayer.SetAvatarId(_local_2.avatarId);
            this.mGameInterface.mCurrentPlayer.invalidatePlayerListItem();
            var _local_3:cPlayerData = this.mGameInterface.FindPlayerFromId(this.mGameInterface.mCurrentPlayer.GetPlayerId());
            _local_3.SetAvatarId(_local_2.avatarId);
            _local_3.invalidatePlayerListItem();
            globalFlash.gui.mAvatar.SetData(this.mGameInterface.mCurrentPlayer, this.mGameInterface.GetPlayerList_vector());
            globalFlash.gui.mFriendsList.Refresh();
        }

        public function cancelLoadingZone():void
        {
            if (this.mBigBrotherMessage != null)
            {
                this.mBigBrotherMessage.cancelLoadingZone();
                this.mBigBrotherMessage = null;
            };
        }

        private function HttpStatusHandler(_arg_1:HTTPStatusEvent):void
        {
            ClientLogger.log("[AUTH] HTTP status: " + _arg_1.status);
            switch (_arg_1.status)
            {
                case 403:
                    this.FaultHandler(new FaultEvent((ERROR_CODES.BB_AUTH_FAILED + " BigBrother returned : 403 on AUTHENTICATE")));
                    return;
                case 404:
                    this.FaultHandler(new FaultEvent((ERROR_CODES.BB_SERVERS_FULL + " BigBrother returned : 404 on AUTHENTICATE")));
                    return;
                case 405:
                case 503:
                    this.FaultHandler(new FaultEvent((ERROR_CODES.BB_SERVICE_FAILED + " BigBrother returned : 503 on AUTHENTICATE")));
                    return;
            };
        }

        private function CompleteHandler(_arg_1:Event):void
        {
            ClientLogger.log("[AUTH] Request completed");
            mInitialized = true;
            var _local_2:dGetFriendsVO = new dGetFriendsVO();
            _local_2.version = defines.VERSION_NR;
            this.SendMessagetoServer(COMMAND.GET_FRIEND_LIST, this.mGameInterface.mCurrentViewedZoneID, _local_2);
        }

        public function fetchFromArguments():void
        {
            mAuthToken = gInitStaticForAllZones.getStringArgument("dsoAuthToken");
            ClientLogger.log(("mGI.mClientMessages.mAuthToken: " + mAuthToken));
            mAuthUser = gInitStaticForAllZones.getIntegerArgument("dsoAuthUser", mAuthUser);
            ClientLogger.log(("mGI.mClientMessages.mAuthUser: " + mAuthUser));
        }

        public function sendClientUITrack(_arg_1:String, _arg_2:String, _arg_3:int):void
        {
            var _local_4:dClientTrackVO = new dClientTrackVO();
            _local_4.action = _arg_1;
            _local_4.amount = _arg_3;
            _local_4.uiName = _arg_2;
            this.SendMessagetoServer(COMMAND.CLIENT_UI_TRACK, this.mGameInterface.mCurrentViewedZoneID, new ArrayCollection([_local_4]));
        }

        private function checkForLockedAdventure(_arg_1:dServerResponse, _arg_2:dServerActionResult):Boolean
        {
            var _local_3:dAdventureClientInfoVO;
            var _local_4:cAdventureDefinition;
            if (((_arg_1.zoneID < 0) && (!(_arg_1.zoneID == this.mGameInterface.mCurrentPlayer.getPlayerID()))))
            {
                _local_3 = AdventureManager.getInstance().getAdventure(_arg_1.zoneID);
                if (_local_3 == null)
                {
                    _local_3 = AdventureManager.getInstance().getTimedoutAdventure(_arg_1.zoneID);
                };
                _local_4 = cAdventureDefinition.FindAdventureDefinition(_local_3.adventureName);
                return (((_local_3.ownerPlayerID == this.mGameInterface.mCurrentPlayer.getPlayerID()) && (!(_local_4.UsesCombatThree()))) && (((_arg_1.type == COMMAND.GET_ZONE) || (_arg_1.type == COMMAND.CANCEL_ADVENTURE)) || (_arg_1.type == COMMAND.PING_ZONE)));
            };
            return (false);
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            var _local_4:int;
            var _local_5:String;
            if (((_arg_2 == cBuff.BUFF_TOTAL_WFSC) && (_arg_3 is int)))
            {
                _local_4 = (_arg_3 as int);
                if (_local_4 == 0)
                {
                    _local_5 = cLocaManager.GetInstance().GetText(LOCA_GROUP.LABELS, "LoadingZone");
                    globalFlash.gui.mLoadingZonePanel.SetLoadingMessage(_local_5);
                    this.mGameInterface.channels.BUFF.removePropertyObserver(cBuff.BUFF_TOTAL_WFSC, this);
                    this.SendGetZoneMessageToServer(this.mGetZoneType, this.mGetZoneID, this.mGetZoneData);
                    this.mGetZoneType = -1;
                };
            };
        }

        private function SendMessageDirectlyToServer(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:String, _arg_5:Responding=null):void
        {
            var _local_7:AsyncToken;
            var _local_8:RemoteObject;
            var _local_9:RemoteObject;
            var _local_10:RemoteObject;
            var _local_11:RemoteObject;
            var _local_12:RemoteObject;
            var _local_6:dServerCall = new dServerCall();
            _local_6.type = _arg_1;
            _local_6.data = _arg_3;
            _local_6.zoneID = _arg_2;
            _local_6.dsoAuthToken = mAuthToken;
            _local_6.dsoAuthUser = mAuthUser;
            _local_6.dsoAuthRandomClientID = mAuthRandomClient;
            if (_arg_1 != COMMAND.GET_UPDATES)
            {
                this.mGameInterface.mLastActivity = getTimer();
            };
            if (this.mGameInterface.mConnectionLost)
            {
                if (_arg_1 != COMMAND.LOGGER_SEND_CLIENT_LOG)
                {
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(((((("Connection Lost: Message is removed " + _local_6) + " Type: ") + _arg_1) + " Object: ") + _arg_3));
                    };
                    return;
                };
            };
            if (((this.mGameInterface.mPacketLost) && (!(_arg_1 == COMMAND.GET_UPDATES))))
            {
                return;
            };
                cConnectionManager.GetInstance().CreateServices(_arg_4);
                _local_8 = cConnectionManager.GetInstance().mRemoteService;
                _local_9 = cConnectionManager.GetInstance().mPlayerService;
                _local_10 = cConnectionManager.GetInstance().mMailService;
                _local_11 = cConnectionManager.GetInstance().mGuildService;
                _local_12 = cConnectionManager.GetInstance().mTradeWindowService;
                switch (_arg_1)
                {
                    case COMMAND.GET_FRIEND_LIST:
                        _local_7 = _local_9.GetFriends(_local_6);
                        break;
                    case COMMAND.ADD_FRIEND:
                        _local_7 = _local_9.AddFriend(_local_6);
                        break;
                    case COMMAND.ACCEPT_FRIEND_REQUEST:
                        _local_7 = _local_9.AcceptFriendRequest(_local_6);
                        break;
                    case COMMAND.DECLINE_FRIEND_REQUEST:
                        _local_7 = _local_9.DeclineFriendRequest(_local_6);
                        break;
                    case COMMAND.REMOVE_FRIEND:
                        _local_7 = _local_9.RemoveFriend(_local_6);
                        break;
                    case COMMAND.SEARCH_PLAYER_LIST:
                    case COMMAND.SEARCH_RECIEPIENT_LIST:
                        _local_7 = _local_9.SearchPlayerListByName(_local_6);
                        break;
                    case COMMAND.GET_BLOCK_LIST:
                        _local_7 = _local_9.GetPlayersBlockList(_local_6);
                        break;
                    case COMMAND.SESSION_AUTH:
                        _local_7 = _local_8.Authenticate(_local_6);
                        break;
                    case COMMAND.SAVE_PLAYER_SETTINGS:
                        _local_7 = _local_8.SavePlayerSettings(_local_6);
                        break;
                    case COMMAND.GET_INBOX_HEADERS:
                    case COMMAND.GET_OUTBOX_HEADERS:
                        _local_7 = _local_10.GetHeaders(_local_6);
                        break;
                    case COMMAND.GET_INBOX_BODY:
                    case COMMAND.GET_OUTBOX_BODY:
                        _local_7 = _local_10.GetMail(_local_6);
                        break;
                    case COMMAND.DELETE_INBOX_MAIL:
                    case COMMAND.DELETE_OUTBOX_MAIL:
                        _local_7 = _local_10.DeleteMail(_local_6);
                        break;
                    case COMMAND.SEND_MAIL:
                        _local_7 = _local_10.SendMail(_local_6);
                        break;
                    case COMMAND.MARK_MAIL_AS_READ:
                        _local_7 = _local_10.MarkMailAsRead(_local_6);
                        break;
                    case COMMAND.GUILD_GET:
                        _local_7 = _local_11.GetGuild(_local_6);
                        break;
                    case COMMAND.GUILD_GET_OWN:
                        _local_7 = _local_11.GetGuildOwn(_local_6);
                        break;
                    case COMMAND.GUILD_GET_HEADERS:
                        _local_7 = _local_11.GetGuildHeaders(_local_6);
                        break;
                    case COMMAND.GUILD_FOUND:
                        _local_7 = _local_11.FoundGuild(_local_6);
                        break;
                    case COMMAND.GUILD_FOUND_VALIDATE_NAME:
                        _local_7 = _local_11.Found_ValidateGuildName(_local_6);
                        break;
                    case COMMAND.GUILD_FOUND_VALIDATE_TAG:
                        _local_7 = _local_11.Found_ValidateGuildTag(_local_6);
                        break;
                    case COMMAND.GUILD_EDIT_VALUE:
                        _local_7 = _local_11.EditValue(_local_6);
                        break;
                    case COMMAND.GUILD_INVITE:
                        _local_7 = _local_11.InviteToGuild(_local_6);
                        break;
                    case COMMAND.GUILD_APPLY:
                        _local_7 = _local_11.ApplyToGuild(_local_6);
                        break;
                    case COMMAND.GUILD_JOIN_REQUEST:
                        _local_7 = _local_11.JoinRequest(_local_6);
                        break;
                    case COMMAND.GUILD_LEAVE:
                        _local_7 = _local_11.LeaveGuild(_local_6);
                        break;
                    case COMMAND.GUILD_INVITE_ACCEPT:
                        _local_7 = _local_11.InviteAccept(_local_6);
                        break;
                    case COMMAND.GUILD_INVITE_DECLINE:
                        _local_7 = _local_11.InviteDecline(_local_6);
                        break;
                    case COMMAND.GUILD_APPLY_ACCEPT:
                        _local_7 = _local_11.ApplyAccept(_local_6);
                        break;
                    case COMMAND.GUILD_APPLY_DECLINE:
                        _local_7 = _local_11.ApplyDecline(_local_6);
                        break;
                    case COMMAND.GUILD_KICK:
                        _local_7 = _local_11.KickMember(_local_6);
                        break;
                    case COMMAND.GUILD_SEND_MAIL:
                        _local_7 = _local_11.SendGuildMail(_local_6);
                        break;
                    case COMMAND.GUILD_STEP_DOWN:
                        _local_7 = _local_11.StepDown(_local_6);
                        break;
                    case COMMAND.GUILD_RANK_GET:
                        _local_7 = _local_11.GetRank(_local_6);
                        break;
                    case COMMAND.VISIT_FRIEND_ZONE:
                        _local_7 = _local_9.AddFriendVisit(_local_6);
                        break;
                    case COMMAND.TRADE_GET_UPDATES:
                        _local_7 = _local_12.GetAvailableOffers(_local_6);
                        break;
                    case COMMAND.REMOVE_TRADE:
                        _local_7 = _local_12.RemoveTrade(_local_6);
                        break;
                    case COMMAND.GET_TRADE_HISTORY:
                        _local_7 = _local_12.getUserTradesHistory(_local_6);
                        break;
                    case COMMAND.GUILD_SUCCESSION_ACCEPT:
                        _local_7 = _local_11.SuccessionAccept(_local_6);
                        break;
                    case COMMAND.GUILD_SUCCESSION_DECLINE:
                        _local_7 = _local_11.SuccessionDecline(_local_6);
                        break;
                    case COMMAND.MARK_MAILS:
                        _local_7 = _local_10.MarkMails(_local_6);
                        break;
                    case COMMAND.BLOCK_SENDER:
                        _local_7 = _local_10.BlockSender(_local_6);
                        break;
                    case COMMAND.UNBLOCK_SENDER:
                        _local_7 = _local_10.UnblockSender(_local_6);
                        break;
                    case COMMAND.GUILD_GET_BANK:
                        _local_7 = _local_11.GetGuildBank(_local_6);
                        break;
                    case COMMAND.GUILD_BANK_TAB_RENAME:
                        _local_7 = _local_11.RenameTab(_local_6);
                        break;
                    default:
                        _local_7 = _local_8.ExecuteServerCall(_local_6);
                };
                _local_7.addResponder(new TSOResponder(this.ResultHandler, this.FaultHandler, _arg_5));
        }

        public function ResultHandler(_arg_1:ResultEvent, _arg_2:Object=null):void
        {
            var _local_4:String;
            var _local_5:String;
            var _local_3:dServerResponse = (_arg_1.result as dServerResponse);
            if (_local_3 == null)
            {
                _local_4 = "Error";
                _local_5 = "Server Response is null!";
                CustomAlert.show(_local_5, _local_4, 4, null, null, null, 4, false);
            };
            if (_local_3.type == COMMAND.SESSION_AUTH)
            {
                this.ReceivedMessageFromServer(_local_3);
            }
            else
            {
                if (!this.mGameInterface.mLastServerResponseRead)
                {
                    this.mGameInterface.mLastServerResponse.push(_local_3);
                }
                else
                {
                    if (!this.mGameInterface.mLastServerResponseIIRead)
                    {
                        this.mGameInterface.mLastServerResponseII.push(_local_3);
                    }
                    else
                    {
                        gMisc.MessageBox("Server Response Error!");
                    };
                };
            };
        }

        private function IsUniqueIDEqualTo(_arg_1:dUniqueID, _arg_2:dUniqueID):Boolean
        {
            var _local_3:* = (_arg_1.uniqueID1 == _arg_2.uniqueID1);
            var _local_4:* = (_arg_1.uniqueID2 == _arg_2.uniqueID2);
            return ((_local_3) && (_local_4));
        }

        private function GetDebugZoneCloseHandler(_arg_1:Event):void
        {
            var _local_2:FileReference = new FileReference();
            _local_2.save(this.mDebugZoneString, "ServerZone.xml");
            this.mDebugZoneString = null;
        }

        public function SendMessagetoServer(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:Responding=null):void
        {
            if (global.useBigBrother)
            {
                if (((this.mLastVisitedZoneID == _arg_2) && (!(this.mLastResultServerName == ""))))
                {
                    this.SendMessageDirectlyToServer(_arg_1, _arg_2, _arg_3, this.mLastResultServerName, _arg_4);
                }
                else
                {
                    new cBigBrotherMessage(_arg_1, _arg_2, _arg_3, true, _arg_4);
                };
            }
            else
            {
                this.SendMessageDirectlyToServer(_arg_1, _arg_2, _arg_3, (global.bigBrotherURL + "/amf"), _arg_4);
            };
            if (this.mNextKeepAlivePing <= getTimer())
            {
                this.mNextKeepAlivePing = cConnectionManager.GetInstance().SendKeepAlivePing();
            };
        }

        private function handleGameErrorCodes(_arg_1:dServerResponse, _arg_2:dServerActionResult):void
        {
            var _local_3:dUniqueID;
            var _local_4:cBuff;
            if (((_arg_2.errorCode >= ERROR_CODES.COULD_NOT_FIND_TRADE_IN_DB) && (_arg_2.errorCode <= ERROR_CODES.OTHER_TRADE_ERROR)))
            {
                if (_arg_2.errorCode == ERROR_CODES.TRADE_ALREADY_ACCEPTED)
                {
                    globalFlash.gui.mTradeWindow.setTradeStatus("TradeAlreadyAccepted");
                }
                else
                {
                    globalFlash.gui.mTradeWindow.setTradeStatus("TradeFailed");
                };
            }
            else
            {
                if (_arg_2.errorCode == ERROR_CODES.TRADE_WITH_ILLEGAL_RESOURCES)
                {
                    globalFlash.gui.mTradeWindow.setWaitingForServer(false);
                };
            };
            if (_arg_2.errorCode == ERROR_CODES.ACCEPT_ADVENTURE_IS_NOT_ACTIVE)
            {
                CustomAlert.show("AdventureZoneExpired", "AdventureZoneExpired", Alert.OK);
                AdventureManager.getInstance().decreaseJoinedAdventuresCount();
            }
            else
            {
                if (((_arg_2.errorCode == ERROR_CODES.ADVENTURE_MAXIMUM_CONCURRENT_REACHED) || (_arg_2.errorCode == ERROR_CODES.ADVENTURE_PLAYER_LEVEL_IS_NOT_HIGH_ENOUGH)))
                {
                    if (_arg_1.type == COMMAND.APPLY_BUFF)
                    {
                        if (_arg_2.errorCode == ERROR_CODES.ADVENTURE_MAXIMUM_CONCURRENT_REACHED)
                        {
                            CustomAlert.show("AdventureZoneStillRunning", "AdventureZoneStillRunning", Alert.OK);
                        };
                        if ((_arg_2.data is dUniqueID))
                        {
                            _local_3 = (_arg_2.data as dUniqueID);
                            _local_4 = this.mGameInterface.mCurrentPlayer.getBuffByUniqueID(_local_3);
                            if (_local_4 != null)
                            {
                                AdventureManager.getInstance().decreaseStartedAdventuresCount();
                                _local_4.DecWaitingForServerCount(this.mGameInterface);
                                this.mGameInterface.mCurrentPlayer.resetLastFetchedBuff();
                            };
                        };
                    };
                }
                else
                {
                    if (_arg_2.errorCode == ERROR_CODES.SEND_MAIL_BLOCKED)
                    {
                        CustomAlert.show(ERROR_CODES.toString(ERROR_CODES.SEND_MAIL_BLOCKED), ERROR_CODES.toString(ERROR_CODES.SEND_MAIL_BLOCKED), Alert.OK);
                    }
                    else
                    {
                        if (_arg_2.errorCode == ERROR_CODES.ILLEGAL_CLASS)
                        {
                            globalFlash.gui.mGuildBankWindow.SetBusy(false);
                            this.mGameInterface.RefreshGuildBank();
                        }
                        else
                        {
                            if (_arg_2.errorCode == ERROR_CODES.COLONY_IS_UNDER_ATTACK)
                            {
                                AdventureManager.getInstance().decreaseStartedAdventuresCount();
                            };
                        };
                    };
                };
            };
            if (((_arg_1.type == COMMAND.GUILD_EDIT_VALUE) && (_arg_2.errorCode == ERROR_CODES.INAPPROPRIATE_LANGUAGE)))
            {
                CustomAlert.show(ERROR_CODES.toString(_arg_2.errorCode), ERROR_CODES.toString(_arg_2.errorCode));
                globalFlash.gui.mGuildWindow.ResetValue((_arg_2.data as dGuildEditValueVO));
                globalFlash.gui.mGuildWindow.ClearGuildRankDetails(true);
            };
            this.mGameInterface.LocalLogMessageDetail(((("IGNORED ERROR CODE " + COMMAND.GetString(_arg_1.type)) + "  Error: ") + ERROR_CODES.toString(_arg_2.errorCode)));
        }

        private function sendUpdateCommandAfterPacketLoss(_arg_1:TimerEvent):void
        {
            var _local_2:dUpdateVO = new dUpdateVO();
            _local_2.synchronisationClientTime = this.mGameInterface.GetClientTime();
            _local_2.synchronisationErrorBitField = cGeneralInterface.SYNCHRONISATION_ERROR_PACKET_LOST;
            this.SendMessagetoServer(COMMAND.GET_UPDATES, this.mGameInterface.mCurrentViewedZoneID, _local_2);
            (_arg_1.target as Timer).stop();
        }

        private function handleServerErrorCodes(_arg_1:dServerResponse, _arg_2:dServerActionResult):void
        {
            if (this.mGameInterface.mConnectionLost)
            {
                return;
            };
            this.mGameInterface.mConnectionLost = true;
            var _local_3:* = "";
            if (_arg_2.data != null)
            {
                _local_3 = String(_arg_2.data);
            };
            switch (_arg_2.errorCode)
            {
                case ERROR_CODES.SERVER_ZONE_INIT_FAILED:
                    LogMessageToBigBrother(new FaultEvent((((((("SERVER ERROR CODE: " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
                    CustomAlert.show("ServerZoneInitFailed", "ServerZoneInitFailed", Alert.OK, null, this.handleRedirectClient);
                    break;
                case ERROR_CODES.SERVER_ZONE_CRASHED:
                    if (this.checkForLockedAdventure(_arg_1, _arg_2))
                    {
                        this.mGameInterface.mConnectionLost = false;
                        this.lockedAdventureId = _arg_1.zoneID;
                        globalFlash.gui.mLoadingZonePanel.Hide();
                        CustomAlert.show("AdventureZoneCrashed", "AdventureZoneCrashed", (Alert.YES | Alert.NO), null, this.handleCancelLockedAdventure);
                    }
                    else
                    {
                        if (this.checkForLockedExpedition(_arg_1, _arg_2))
                        {
                            this.mGameInterface.mConnectionLost = false;
                            this.lockedAdventureId = _arg_1.zoneID;
                            globalFlash.gui.mLoadingZonePanel.Hide();
                            CustomAlert.show("ExpeditionZoneCrashed", "ExpeditionZoneCrashed", (Alert.YES | Alert.NO), null, this.handleCancelLockedAdventure);
                        }
                        else
                        {
                            LogMessageToBigBrother(new FaultEvent((((((("SERVER ERROR CODE: " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
                            CustomAlert.show("ServerZoneCrashed", "ServerZoneCrashed", Alert.OK, null, this.handleRedirectClient);
                        };
                    };
                    break;
                case ERROR_CODES.SERVER_ZONE_SUPPORT_LOCK:
                    LogMessageToBigBrother(new FaultEvent((((((("SERVER ERROR CODE: " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
                    CustomAlert.show("ServerZoneSupportLock", "ServerZoneSupportLock", Alert.OK, null, this.handleRedirectClient);
                    break;
                case ERROR_CODES.SERVER_ZONE_BANNED:
                    LogMessageToBigBrother(new FaultEvent((((((("SERVER ERROR CODE: " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
                    CustomAlert.show("ServerZoneBanned", "ServerZoneBanned", Alert.OK, null, this.handleRedirectClient);
                    break;
                case ERROR_CODES.SERVER_SHUTDOWN:
                    LogMessageToBigBrother(new FaultEvent((((((("SERVER ERROR CODE: " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
                    CustomAlert.show("ServerShutdown", "ServerShutdown", Alert.OK, null, this.handleRedirectClient);
                    return;
                case ERROR_CODES.SERVER_OVERSTRAINED:
                    LogMessageToBigBrother(new FaultEvent((((((("SERVER ERROR CODE: " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
                    CustomAlert.show("ServerOverstrained", "ServerOverstrained", Alert.OK, null, this.handleRedirectClient);
                    break;
                case ERROR_CODES.SERVER_NO_VALID_SESSION:
                    LogMessageToBigBrother(new FaultEvent((((((("SERVER ERROR CODE: " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
                    CustomAlert.show("ServerNoValidSession", "ServerNoValidSession", Alert.OK, null, this.handleRedirectClient);
                    break;
                case ERROR_CODES.SERVER_VALIDATOR_ERROR_NULL_VALUE_EXCEPTION:
                case ERROR_CODES.SERVER_VALIDATOR_ERROR_RANGE_EXCEPTION:
                case ERROR_CODES.SERVER_VALIDATOR_ERROR_WRONG_INSTANCE_EXCEPTION:
                case ERROR_CODES.ADVENTURE_PLAYER_LEVEL_IS_NOT_HIGH_ENOUGH:
                    LogMessageToBigBrother(new FaultEvent((((((("SERVER ERROR CODE : " + ERROR_CODES.toString(_arg_2.errorCode)) + "(") + String(_arg_2.errorCode)) + ")\n") + _local_3) + "\n")));
                    CustomAlert.show((((("Server Response Error Code E:" + _arg_2.errorCode) + " M:") + _arg_1.type) + " !"), "Error", Alert.OK, null, this.handleRedirectClient, null, 4, false);
                    break;
                case ERROR_CODES.NEWER_SESSION_DETECTED:
                    CustomAlert.show("ServerNoValidSession", "ServerNoValidSession", Alert.OK, null, this.handleRedirectClient);
                    break;
                case ERROR_CODES.SERVER_CLIENT_VERSION_MISMATCH:
                case ERROR_CODES.SERVER_CLIENT_SETTINGS_DEFINED_MISMATCH:
                    CustomAlert.show("ServerClientVersionMismatch", "ServerClientVersionMismatch", Alert.OK, null, this.handleRedirectClient);
                    break;
                case ERROR_CODES.SERVER_PLAYER_TRIES_TO_CHEAT:
                    cLog.error("Got ERROR_CODES.SERVER_PLAYER_TRIES_TO_CHEAT as response...");
                    break;
                case ERROR_CODES.SERVER_FRIEND_ZONE_CRASHED:
                    globalFlash.gui.mLoadingZonePanel.Hide();
                    this.mGameInterface.mConnectionLost = false;
                    if (_arg_1.type == COMMAND.GET_ZONE)
                    {
                        CustomAlert.show(ERROR_CODES.toString(ERROR_CODES.SERVER_FRIEND_ZONE_CRASHED), ERROR_CODES.toString(ERROR_CODES.SERVER_FRIEND_ZONE_CRASHED), Alert.OK);
                    };
                    break;
                default:
                    cLog.error(((("Got SERVER ERROR CODE: " + ERROR_CODES.toString(_arg_2.errorCode)) + " ") + _local_3));
            };
            cLog.sendLogMessagesToServer();
        }

        private function handleConnectionLost():void
        {
            this.mGameInterface.mConnectionLost = true;
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.SERVER_CALL_FAILED);
            CustomAlert.show("ConnectionLost", "ConnectionLost", Alert.OK, null, this.handleRedirectClient);
        }

        private function checkForLockedExpedition(_arg_1:dServerResponse, _arg_2:dServerActionResult):Boolean
        {
            var _local_3:dAdventureClientInfoVO;
            var _local_4:cAdventureDefinition;
            if (((_arg_1.zoneID < 0) && (!(_arg_1.zoneID == this.mGameInterface.mCurrentPlayer.getPlayerID()))))
            {
                _local_3 = AdventureManager.getInstance().getAdventure(_arg_1.zoneID);
                if (_local_3 == null)
                {
                    _local_3 = AdventureManager.getInstance().getTimedoutAdventure(_arg_1.zoneID);
                };
                _local_4 = cAdventureDefinition.FindAdventureDefinition(_local_3.adventureName);
                return (((_local_3.ownerPlayerID == this.mGameInterface.mCurrentPlayer.getPlayerID()) && (_local_4.UsesCombatThree())) && (((_arg_1.type == COMMAND.GET_ZONE) || (_arg_1.type == COMMAND.CANCEL_ADVENTURE)) || (_arg_1.type == COMMAND.PING_ZONE)));
            };
            return (false);
        }

        public function FaultHandler(_arg_1:FaultEvent, _arg_2:Object=null):void
        {
            ClientLogger.log("[NETWORK] " + _arg_1.toString());
            LogMessageToBigBrother(_arg_1, _arg_2);
            switch (_arg_1.type)
            {
                case ERROR_CODES.BB_AUTH_FAILED:
                    this.mGameInterface.mConnectionLost = true;
                    CustomAlert.show("BigBrotherAuthFailed", "BigBrotherAuthFailed", Alert.OK, null, this.handleRedirectClient);
                    return;
                case ERROR_CODES.BB_SERVICE_FAILED:
                    this.mGameInterface.mConnectionLost = true;
                    CustomAlert.show("BigBrotherServiceUnavailable", "BigBrotherServiceUnavailable", Alert.OK, null, this.handleRedirectClient);
                    return;
                case ERROR_CODES.BB_FILE_NOT_FOUND:
                    this.mGameInterface.mConnectionLost = true;
                    CustomAlert.show("BigBrotherFileNotFound", "BigBrotherFileNotFound", Alert.OK, null, this.handleRedirectClient);
                    return;
                case ERROR_CODES.BB_SERVERS_FULL:
                    this.mGameInterface.mConnectionLost = true;
                    CustomAlert.show("ServerFull", "ServerFull", Alert.OK, null, this.handleRedirectClient);
                    return;
                default:
                    if (global.gameState == "Editor") break;
                    if (this.mGameInterface.mCurrentViewedZoneID == 0)
                    {
                        this.handleConnectionLost();
                        return;
                    };
                    this.handlePacketLost();
                    return;
            };
        }

        public function ReceivedMessageFromServer(_arg_1:dServerResponse):void
        {
            var _local_2:dServerActionResult;
            var _local_3:dGameTickCommandVO;
            var _local_4:dResourceVO;
            var _local_5:cBuilding;
            var _local_6:cSpecialist;
            var _local_7:dZoneVO;
            var _local_8:dGuildBankVO;
            var _local_9:dSettingsVO;
            var _local_10:Boolean;
            var _local_11:cAdventureDefinition;
            var _local_12:dCombatPreviewResult;
            var _local_13:Array;
            var _local_14:Array;
            var _local_15:Vector.<dAdventureClientInfoVO>;
            var _local_16:Array;
            var _local_17:int;
            var _local_18:dPlayerListItemVO;
            var _local_19:dPlayerListItemVO;
            var _local_20:ArrayCollection;
            var _local_21:dGameTickCommandVO;
            var _local_22:dGameTickCommandVO;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:dGameTickCommandVO;
            var _local_27:dServerAction;
            var _local_28:dStartSpecialistTaskVO;
            var _local_29:cSpecialist;
            var _local_30:cBuilding;
            var _local_31:dZoneRefreshVO;
            var _local_32:dZoneVO;
            var _local_33:Array;
            var _local_34:dGetFriendsVO;
            var _local_35:dGuildVO;
            var _local_36:cBuilding;
            var _local_37:int;
            var _local_38:*;
            _local_2 = (_arg_1.data as dServerActionResult);
            if (((_arg_1.type == COMMAND.PING_ZONE) && (!(_local_2.errorCode == ERROR_CODES.SERVER_ZONE_CRASHED))))
            {
                return;
            };
            if (_local_2.errorCode >= ERROR_CODES.SERVER_ERROR_CODES)
            {
                this.handleServerErrorCodes(_arg_1, _local_2);
                return;
            };
            if (((((_local_2.errorCode < ERROR_CODES.NO_ERROR) && (!(_local_2.errorCode == ERROR_CODES.GUILD_FOUND_NAME_EXISTS))) && (!(_local_2.errorCode == ERROR_CODES.GUILD_FOUND_TAG_EXISTS))) && (!(_local_2.errorCode == ERROR_CODES.GUILD_RANK_TAB_NO_SELECTED))))
            {
                this.handleGuildErrorCodes(_arg_1, _local_2);
            }
            else
            {
                if (_local_2.errorCode > ERROR_CODES.NO_ERROR)
                {
                    this.handleGameErrorCodes(_arg_1, _local_2);
                    return;
                };
            };
            switch (_arg_1.type)
            {
                case COMMAND.GET_ZONE_ON_LOGIN:
                    gMisc.CheatWindowConsoleOut("COMMAND.GET_ZONE_ON_LOGIN");
                    _local_7 = (_local_2.data as dZoneVO);
                    (this.mGameInterface as cGameInterface).mRequirements = _local_7.requirements;
                    if (_local_7.settings != null)
                    {
                        _local_9 = _local_2.data.settings;
                        global.eventLadderURL_string = _local_9.eventLadderURL_string;
                        global.expeditionDifficultyVO = _local_9.expeditionDifficultyVO;
                        global.expeditionMapLevelGroupVO = _local_9.expeditionMapLevelGroupVO;
                        global.expeditionMapSizeVO = _local_9.expeditionMapSizeVO;
                        this.mGameInterface.killswitch.update(_local_9.killswitches);
                        if (((!(_local_9.handShakeVO == null)) && (!(_local_9.handShakeVO.chatPassword == null))))
                        {
                            TSOChatMediator.setHandShakeObject(_local_9.handShakeVO);
                        }
                        else
                        {
                            gMisc.CheatWindowConsoleOut("chat connection missing");
                        };
                    };
                    ShareManager.getInstance();
                    globalFlash.gui.mChatPanel.Refresh();
                case COMMAND.GET_ZONE:
                    if ((_local_2.data is dAdventureExpiredVO))
                    {
                        CustomAlert.show("AdventureZoneExpired", "AdventureZoneExpired", Alert.OK);
                        AdventureManager.getInstance().removeAdventure((_local_2.data as dAdventureExpiredVO).zoneID);
                        globalFlash.gui.mLoadingZonePanel.Hide();
                        return;
                    };
                    if ((_local_2.data is dAdventureResetVO))
                    {
                        CustomAlert.show("AdventureZoneReset", "AdventureZoneReset", Alert.OK);
                        globalFlash.gui.mLoadingZonePanel.Hide();
                        return;
                    };
                    global.maxAnimalsOnMap = _local_2.data.maxAnimalsOnMap;
                    global.defaultAnimals = ((_local_2.data.hasAltDefaultAnimals) ? _local_2.data.defaultAnimals : null);
                    this.mGameInterface.mCurrentPlayerZone.setAlternativeWater(_local_2.data.alternativeWater);
                    if (((this.mGameInterface.mCurrentPlayer.mIsAdventureZone) && (AdventureManager.getInstance().getAdventure(this.mGameInterface.mCurrentViewedZoneID) == null)))
                    {
                        this.mGameInterface.mCurrentPlayerZone.mHiredTroopsPool = new Dictionary();
                    };
                    _local_10 = false;
                    if (this.mGameInterface.mCurrentPlayer.GetPlayerId() == 0)
                    {
                        _local_10 = true;
                    };
                    if (((this.mGameInterface.mCurrentPlayer.mIsPlayerZone) && (!(this.mGameInterface.mCurrentPlayer.mIsAdventureZone))))
                    {
                        this.mGameInterface.mQuestClientCallbacks.SaveQuestPool();
                    };
                    globalFlash.gui.mQuestBook.SetNotificationQuest(null);
                    globalFlash.gui.mQuestBook.SetPreselectedQuest(null);
                    gHintManager.HideHints();
                    _local_7 = (_local_2.data as dZoneVO);
                    if (_local_7.zoneOwnerPlayerID == _local_7.zoneVisitorPlayerID)
                    {
                        this.mGameInterface.mQuestClientCallbacks.RestoreQuestPool();
                    }
                    else
                    {
                        this.mGameInterface.mQuestClientCallbacks.CleanQuestPool();
                    };
                    this.mGameInterface.mServer.RefreshZone(_local_7, false, _local_10, defines.STORE_ZONE_DELTA);
                    this.mGameInterface.mCurrentPlayerZone.ZoneSetStartZoom();
                    if (((!(this.mGameInterface.mCurrentPlayer.mIsPlayerZone)) || (this.mGameInterface.mCurrentPlayer.mIsAdventureZone)))
                    {
                        globalFlash.gui.mInfoBar.Hide();
                        globalFlash.gui.mExpeditionInfoBar.Show();
                        globalFlash.gui.mBuildQueue.Hide();
                        globalFlash.gui.mToolboxPanel.ClosePanel(null);
                        _local_11 = cAdventureDefinition.FindAdventureDefinition(_local_7.adventureName);
                        if (((!(_local_11 == null)) && (!(_local_11.GetType() == ADVENTURE_TYPE.SCENARIO))))
                        {
                            globalFlash.gui.mExpeditionInfoBar.Show();
                        };
                        globalFlash.gui.mAvatar.EnableAchievementsButton(false);
                        globalFlash.gui.mAvatar.EnablePvPRanksButton(false);
                    }
                    else
                    {
                        globalFlash.gui.mInfoBar.Show();
                        globalFlash.gui.mExpeditionInfoBar.Hide();
                        globalFlash.gui.mAvatar.EnableAchievementsButton(true);
                        globalFlash.gui.mAvatar.EnablePvPRanksButton(true);
                    };
                    globalFlash.gui.mFriendsListMenu.Hide();
                    this.mGameInterface.lastColonyYieldCalculationTime = _local_7.lastColonyYieldCalculationTime;
                    cSettingsManager.getInstance().playerOptions = _local_7.playerOptions;
                    TSOChatMediator.InitChat(true);
                    globalFlash.gui.mToolboxPanel.Refresh();
                    globalFlash.gui.mAvatar.Refresh();
                    global.ui.mSetBlockingPathPreview.CancelBlockingPreview();
                    globalFlash.gui.mSupportLockZone.Hide();
                    this.mGameInterface.mCurrentPlayerZone.mSettlerKIManager.clearAnimals(true);
                    this.mGameInterface.channels.ZONE.send(ZoneChannel.ZONE_REFRESHED_CLIENT, this.mGameInterface);
                    return;
                case COMMAND.GET_ZONE_ON_THE_FLY:
                    this.mGameInterface.mServer.RefreshZone((_local_2.data as dZoneVO), true, false, defines.STORE_ZONE_DELTA);
                    globalFlash.gui.mToolboxPanel.Refresh();
                    return;
                case COMMAND.GET_COMBAT_PREVIEW:
                    _local_12 = (_local_2.data as dCombatPreviewResult);
                    globalFlash.gui.mCombatPreviewPanel.SetData(_local_12.feedback_string);
                    globalFlash.gui.mCombatPreviewPanel.Show();
                    return;
                case COMMAND.SEARCH_PLAYER_LIST:
                    _local_13 = [];
                    if (_local_2.data)
                    {
                        _local_13 = _local_2.data.players.toArray().sortOn("username", Array.CASEINSENSITIVE);
                    };
                    globalFlash.gui.mAddFriendsPanel.SetData(_local_13);
                    return;
                case COMMAND.GET_BLOCK_LIST:
                    _local_14 = [];
                    if (_local_2.data)
                    {
                        _local_14 = _local_2.data.players.toArray().sortOn("username", Array.CASEINSENSITIVE);
                    };
                    globalFlash.gui.mBlockList.SetBlockList(_local_14);
                    return;
                case COMMAND.ADD_FRIEND:
                    if (_local_2.data)
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.FRIEND_REQUEST_SENT);
                    }
                    else
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.FRIEND_REQUEST_COOLDOWN);
                    };
                    return;
                case COMMAND.SEARCH_RECIEPIENT_LIST:
                    _local_13 = [];
                    if (_local_2.data)
                    {
                        _local_13 = _local_2.data.players.toArray().sortOn("username", Array.CASEINSENSITIVE);
                    };
                    globalFlash.gui.mMailWindow.setReciepientList(_local_13);
                    return;
                case COMMAND.GET_FRIEND_LIST:
                    _local_15 = new Vector.<dAdventureClientInfoVO>();
                    if (((_local_2.data == null) || (_local_2.data.players == null)))
                    {
                        globalFlash.gui.mFriendsList.SetData([]);
                    }
                    else
                    {
                        _local_16 = _local_2.data.players.toArray();
                        _local_17 = (_local_16.length - 1);
                        while (_local_17 >= 0)
                        {
                            _local_18 = _local_16[_local_17];
                            if (_local_18.id < 0)
                            {
                                _local_16.splice(_local_17, 1);
                                _local_15.push(_local_18.adventureVO);
                            };
                            _local_17--;
                        };
                        globalFlash.gui.mFriendsList.SetData(_local_16);
                    };
                    AdventureManager.getInstance().setAdventures(_local_15);
                    if (TSOChatMediator.received == 1)
                    {
                        return;
                    };
                    cSettingsManager.getInstance().playerOptions = _local_2.data.playerOptions;
                    TSOChatMediator.InitChat(true);
                    this.SendGetZoneMessageToServer(COMMAND.GET_ZONE_ON_LOGIN, this.mGameInterface.mCurrentViewedZoneID, new dZoneLoginVO());
                    return;
                case COMMAND.GET_UPDATES:
                    this.mGameInterface.mGetUpdatesSend = false;
                    this.handleGetUpdates((_local_2.data as ArrayCollection));
                    return;
                case COMMAND.GET_PVP_COLONIES:
                    globalFlash.gui.mPvPColoniesWindow.setColoniesListResponse((_local_2.data as ColoniesListVO));
                    return;
                case COMMAND.START_CONQUERING_PVP_COLONY:
                    globalFlash.gui.mPvPColoniesWindow.handleConquerSuccessful((_local_2.data as int));
                    return;
                case COMMAND.COLONY_START_DEFENSE_MODE:
                    _local_19 = (_local_2.data as dPlayerListItemVO);
                    if (this.mGameInterface.mCurrentPlayerZone.ColonyGet(_local_19.adventureVO.colonyID).state == cColony.STATUS_WAIT_FOR_ASSIGNMENT)
                    {
                        AdventureManager.getInstance().addAdventure(_local_19.adventureVO);
                    };
                    globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = false;
                    return;
                case COMMAND.CLAIM_PVP_LEVEL_REWARDS:
                    global.ui.mCurrentPlayer.SetClaimedPvPLevel(((_local_2.data as dIntegerVO).value as int));
                    return;
                case COMMAND.CHECK_AVATAR_NAME:
                    globalFlash.gui.mAvatarSelectionPanel.serverCheckReceived((_local_2.data as CheckUsernameVO));
                    return;
                case COMMAND.UPDATE_PLAYER_INFO_AND_USERNAME:
                    this.handleUpdatePlayerInfoAndUsername(_local_2);
                    globalFlash.gui.mAvatarSelectionPanel.serverUpdateReceived((_local_2.data as UpdateUsernameAndAvatarVO));
                    return;
                case COMMAND.UPDATE_PLAYER_INFO:
                    this.handleUpdatePlayerInfo(_local_2);
                    globalFlash.gui.mAvatarSelectionPanel.serverUpdateReceived((_local_2.data as UpdateUsernameAndAvatarVO));
                    return;
                case COMMAND.SPEEDMODE:
                case COMMAND.BUY_SHOP_ITEM:
                case COMMAND.BUY_SHOP_ITEM_MOBILE:
                case COMMAND.SET_BUILDING_IN_GAME:
                case COMMAND.SET_BUILDING_IN_DEFENSE_MODE:
                case COMMAND.SET_BUILDING_IN_DEFENSE_MODE_BY_BUFF:
                case COMMAND.SET_BUILDING_BY_BUFF:
                case COMMAND.SET_BUILDING_PICKUP:
                case COMMAND.MOVE_BUILDING:
                case COMMAND.BUILDQUEUE_MOVE_UP:
                case COMMAND.BUILDQUEUE_MOVE_DOWN:
                case COMMAND.BUILDQUEUE_REMOVE:
                case COMMAND.DESTRUCT_BUILDING:
                case COMMAND.DESTRUCT_MOUNTAIN:
                case COMMAND.UPGRADE_BUILDING:
                case COMMAND.STOP_PRODUCTION:
                case COMMAND.REVEAL_FRIEND_COLLECTIBLE_BUILDING_BUFF:
                case COMMAND.APPLY_BUFF:
                case COMMAND.APPLY_BUFF_LIST:
                case COMMAND.REMOVE_BUFF:
                case COMMAND.START_TIMED_PRODUCTION:
                case COMMAND.BUY_SPECIALIST:
                case COMMAND.DISMISS_MAILS:
                case COMMAND.ACCEPT_LOOT:
                case COMMAND.CLAIM_LOOT:
                case COMMAND.BUY_ONE_CLICK_SHOP_ITEM:
                case COMMAND.RESOURCES_CHEAT:
                case COMMAND.ARMY_CHEAT:
                case COMMAND.SET_CITY_LEVEL:
                case COMMAND.INVITE_TO_ADVENTURE:
                case COMMAND.RETREAT:
                case COMMAND.RAISE_ARMY:
                case COMMAND.APPLY_LOOTTABLE_BUFF:
                case COMMAND.INITIATE_TRADE:
                case COMMAND.ACCEPT_TRADE_MARKET:
                case COMMAND.ACCEPT_TRADE_MAIL:
                case COMMAND.COMPLETE_TRADE_MAIL:
                case COMMAND.DELETE_TRADE_BY_USER:
                case COMMAND.DELETE_TRADES_BY_DEMOLITION:
                case COMMAND.TRADE_GET_USER_TRADES:
                case COMMAND.SET_SKILLPOINTS:
                case COMMAND.RESET_SKILLPOINTS:
                case COMMAND.DELIVER_PRODUCTION:
                case COMMAND.PRODUCTION_REMOVE:
                case COMMAND.PRODUCTION_CANCEL_ALL_WAITING:
                case COMMAND.EVENT_DONATE_RESOURCE:
                case COMMAND.GUILD_DONATE_RESOURCE:
                case COMMAND.CREATE_COLLECTION:
                case COMMAND.GUILD_BANK_TRANSFER:
                case COMMAND.GUILD_BANK_WITHDRAW:
                case COMMAND.GUILD_BANK_BUY_TAB:
                case COMMAND.GUILD_BANK_ENLARGE:
                case COMMAND.OPEN_ADVENT_CALENDAR_DOOR:
                case COMMAND.OPEN_ADVENT_CALENDAR_DOOR_WITH_GEMS:
                case COMMAND.VOTES_SEND_PLAYER_VOTE:
                case COMMAND.VOTES_DELETE_PLAYER_VOTE_WITH_GEMS:
                case COMMAND.SELECT_ADVENT_CALENDAR_DOOR_REWARD:
                case COMMAND.EPIC_WORKYARD_CREATE_PRODUCTION_CHAIN:
                case COMMAND.EPIC_WORKYARD_DESTROY_PRODUCTION_CHAIN:
                case COMMAND.EPIC_WORKYARD_CHANGE_PRODUCTION_CHAIN:
                case COMMAND.COMBAT_UNIT_SWITCH:
                case COMMAND.COLONY_ASSIGN:
                case COMMAND.COLONY_REMOVE:
                case COMMAND.FORCE_COMPLETE_ACHIEVEMENT:
                case COMMAND.FORCE_COMPLETE_ACHIEVEMENT_TRIGGER:
                case COMMAND.GET_COMPARED_USER_ACHIEVEMENTS:
                case COMMAND.EXECUTE_PICKUP:
                case COMMAND.ADD_BLOCKING_PATH_PREVIEW:
                case COMMAND.DELETE_BLOCKING_PATH_PREVIEW:
                case COMMAND.MOVE_BLOCKING_PATH_PREVIEW_START:
                case COMMAND.MOVE_BLOCKING_PATH_PREVIEW_TARGET:
                case COMMAND.ADD_PVP_XP:
                case COMMAND.ZONE_BUFF_REMOVE:
                case COMMAND.COLONY_REQUEST_YIELD:
                case COMMAND.PRODUCTION_MOVE_UP:
                case COMMAND.PRODUCTION_MOVE_DOWN:
                case COMMAND.PRODUCTION_MOVE_BOTTOM:
                case COMMAND.PRODUCTION_MOVE_TOP:
                case COMMAND.CLAM_TASK_REWARD:
                case COMMAND.PAY_TO_FINISH:
                case COMMAND.CHEAT_FINISH_TASK:
                case COMMAND.CHEAT_RESET_TASKS:
                case COMMAND.RESET_CULTURE_BUILDING_COOLDOWN_WITH_GEMS:
                case COMMAND.CONTENT_GENERATOR_COMPLETE_COLLECTION:
                case COMMAND.CHEAT_CONTENT_GENERATOR_ROLL:
                case COMMAND.CHEAT_CONTENT_GENERATOR_COLLECTION_PART:
                case COMMAND.CONTENT_GENERATOR_ROLL:
                case COMMAND.CHEAT_APPLY_EFFECT:
                    if (((_arg_1.type == COMMAND.ACCEPT_LOOT) || (_arg_1.type == COMMAND.CLAIM_LOOT)))
                    {
                        globalFlash.gui.mMailWindow.outBoxEnabled = true;
                    };
                    if (_local_2.data != null)
                    {
                        this.mGameInterface.AddGameTickCommand((_local_2.data as dGameTickCommandVO));
                    };
                    return;
                case COMMAND.QUEST_TRIGGER:
                    this.handleGetUpdates((_local_2.data as ArrayCollection));
                    return;
                case COMMAND.GOD_MODE_CHEAT:
                    if (_local_2.data != null)
                    {
                        _local_20 = (_local_2.data as ArrayCollection);
                        if (_local_20 != null)
                        {
                            for each (_local_21 in _local_20)
                            {
                                this.mGameInterface.AddGameTickCommand(_local_21);
                            };
                        };
                    };
                    return;
                case COMMAND.TEST_LOOTTABLE:
                    if (_local_2.data != null)
                    {
                    };
                    return;
                case COMMAND.SET_TASK:
                    if (_local_2.data != null)
                    {
                        _local_22 = (_local_2.data as dGameTickCommandVO);
                        this.mGameInterface.AddGameTickCommand(_local_22);
                        _local_23 = this.mGameInterface.GetClientTime();
                        _local_24 = (_local_22.time - _local_23);
                        _local_25 = (_local_24 / this.mGameInterface.mGlobalTimeScale);
                        if (_local_25 > 2500)
                        {
                            _local_26 = (_local_2.data as dGameTickCommandVO);
                            _local_27 = (_local_26.data as dServerAction);
                            _local_28 = (_local_27.data as dStartSpecialistTaskVO);
                            if (_local_28 != null)
                            {
                                _local_29 = this.mGameInterface.mCurrentPlayerZone.getSpecialist(_local_22.playerID, _local_28.uniqueID);
                                if (_local_29 != null)
                                {
                                    _local_30 = _local_29.GetGarrison();
                                    if (_local_30 != null)
                                    {
                                        _local_30.SetIsGarrisonWaitForCommand(true);
                                    };
                                };
                            };
                        };
                    };
                    return;
                case COMMAND.SPOOLTIME:
                    if (_local_2.data != null)
                    {
                        _local_31 = (_local_2.data as dZoneRefreshVO);
                        this.mGameInterface.LocalLogMessage(_local_31.resultString);
                        this.mGameInterface.mServer.RefreshZone(_local_31.zoneVO, true, false, defines.STORE_ZONE_DELTA);
                    };
                    return;
                case COMMAND.GET_DEBUG_ZONE:
                    _local_32 = (_local_2.data as dZoneVO);
                    this.mDebugZoneString = _local_32.toDebugString();
                    Alert.show("Save Server Zone To File", "Info", 4, null, this.GetDebugZoneCloseHandler);
                    return;
                case COMMAND.SESSION_AUTH:
                    _local_33 = (_local_2.data as String).split("|");
                    mSessionID = _local_33[0];
                    mSessionUserName = _local_33[1];
                    _local_34 = new dGetFriendsVO();
                    _local_34.version = defines.VERSION_NR;
                    this.SendMessagetoServer(COMMAND.GET_FRIEND_LIST, this.mGameInterface.mCurrentViewedZoneID, _local_34);
                    return;
                case COMMAND.GET_INBOX_HEADERS:
                case COMMAND.GET_OUTBOX_HEADERS:
                    globalFlash.gui.mMailWindow.setMailHeaderResponse((_local_2.data as dMailHeaderResponseVO));
                    return;
                case COMMAND.GET_INBOX_BODY:
                case COMMAND.GET_OUTBOX_BODY:
                    globalFlash.gui.mMailWindow.setMail((_local_2.data as dMailVO));
                    return;
                case COMMAND.DELETE_INBOX_MAIL:
                case COMMAND.DELETE_OUTBOX_MAIL:
                    globalFlash.gui.mMailWindow.mailsDeletedFromServer();
                    return;
                case COMMAND.TRADE_GET_UPDATES:
                    globalFlash.gui.mTradeWindow.setData((_local_2.data as dTradeWindowResultVO));
                    return;
                case COMMAND.GET_TRADE_HISTORY:
                    this.mGameInterface.mHomePlayer.mTradeData.setTradeHistroyData((_local_2.data as ArrayCollection));
                    return;
                case COMMAND.GUILD_GET_OWN:
                    _local_35 = (_local_2.data as dGuildVO);
                    this.mGameInterface.joinGuildChannels();
                    this.mGameInterface.mHomePlayer.updateGuild(_local_35);
                    this.mGameInterface.mCurrentPlayer.updateGuild(_local_35);
                    this.mGameInterface.mCurrentPlayerZone.mStreetDataMap.UpdateGuildHousesBuildingLevel();
                    if (_local_35 != null)
                    {
                        this.mGameInterface.SetCurrentPlayerGuild(_local_35);
                        this.mGameInterface.joinGuildChannels();
                        _local_36 = this.mGameInterface.mCurrentPlayerZone.mStreetDataMap.GetGuildHouse();
                        if (_local_36)
                        {
                            _local_37 = 0;
                            for (_local_38 in global.guildUpgradeLevels)
                            {
                                if (_local_35.maxSize >= global.guildUpgradeLevels[_local_38])
                                {
                                    _local_37 = _local_38;
                                }
                                else
                                {
                                    break;
                                };
                            };
                            _local_36.SetUpgradeLevel(_local_37);
                        };
                    }
                    else
                    {
                        _local_36 = this.mGameInterface.mCurrentPlayerZone.mStreetDataMap.GetGuildHouse();
                        if (_local_36)
                        {
                            _local_36.SetUpgradeLevel(1);
                        };
                    };
                    return;
                case COMMAND.GUILD_GET:
                    _local_35 = (_local_2.data as dGuildVO);
                    globalFlash.gui.mGuildWindow.SetGuild(_local_35);
                    return;
                case COMMAND.GUILD_RANK_GET:
                    globalFlash.gui.mGuildWindow.SetRankDetail((_local_2.data as dGuildRankListItemVO));
                    return;
                case COMMAND.GUILD_GET_HEADERS:
                    globalFlash.gui.mGuildWindow.SetHeaders((_local_2.data as dGuildHeadersListVO));
                    return;
                case COMMAND.GUILD_FOUND_VALIDATE_NAME:
                    globalFlash.gui.mFoundGuildPanel.ValidateName((_local_2.data as String), _local_2.errorCode);
                    return;
                case COMMAND.GUILD_FOUND_VALIDATE_TAG:
                    globalFlash.gui.mFoundGuildPanel.ValidateTag((_local_2.data as String), _local_2.errorCode);
                    return;
                case COMMAND.GUILD_FOUND:
                    this.SendMessagetoServer(COMMAND.GUILD_GET_OWN, this.mGameInterface.mCurrentPlayer.GetHomeZoneId(), null);
                    return;
                case COMMAND.GUILD_EDIT_VALUE:
                    if (_local_2.errorCode == ERROR_CODES.GUILD_EDIT_NOT_ALLOWED)
                    {
                        CustomAlert.show(ERROR_CODES.toString(_local_2.errorCode), ERROR_CODES.toString(_local_2.errorCode));
                        globalFlash.gui.mGuildWindow.ResetValue((_local_2.data as dGuildEditValueVO));
                    };
                    if (_local_2.errorCode == ERROR_CODES.GUILD_RANK_TAB_NO_SELECTED)
                    {
                        CustomAlert.show(ERROR_CODES.toString(_local_2.errorCode), ERROR_CODES.toString(_local_2.errorCode));
                        globalFlash.gui.mGuildWindow.ClearGuildRankDetails(false);
                    };
                    if (((_local_2.data is dGuildEditValueVO) && ((_local_2.data as dGuildEditValueVO).type == EDIT_TYPE.RANK_NAME)))
                    {
                        if (_local_2.errorCode == ERROR_CODES.NO_ERROR)
                        {
                            globalFlash.gui.mGuildWindow.SavedRank((_local_2.data as dGuildEditValueVO));
                        }
                        else
                        {
                            globalFlash.gui.mGuildWindow.ClearGuildRankDetails(false);
                        };
                    };
                    return;
                case COMMAND.GUILD_KICK:
                    if (_local_2.errorCode == ERROR_CODES.NO_ERROR)
                    {
                        this.SendMessagetoServer(COMMAND.PING_ZONE, (_local_2.data as dIntegerVO).value, null);
                    };
                    return;
                case COMMAND.SET_FAKE_DATE:
                    this.mGameInterface.mServerDate = (_local_2.data as dClientDateVO);
                    return;
                case COMMAND.APPLY_EFFECT:
                    if (cLog.isInfoEnabled())
                    {
                        cLog.info(("Apply Effect from Gametick: " + _local_2.data));
                    };
                    return;
                case COMMAND.GUILD_GET_BANK:
                    _local_8 = (_local_2.data as dGuildBankVO);
                    if (_local_8)
                    {
                        this.mGameInterface.SetCurrentPlayerGuildBank(_local_8);
                    };
                    return;
                case COMMAND.GUILD_BANK_TAB_RENAME:
                    return;
                case COMMAND.GUILD_APPLY_ACCEPT:
                    this.SendMessagetoServer(COMMAND.GUILD_GET_OWN, this.mGameInterface.mCurrentPlayer.GetHomeZoneId(), null);
                    return;
                case COMMAND.SEND_MAIL:
                case COMMAND.GUILD_SEND_MAIL:
                case COMMAND.GUILD_APPLY:
                    if (_local_2.errorCode == ERROR_CODES.NO_ERROR)
                    {
                        globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.MAIL_SENT);
                    };
                    return;
                case COMMAND.COMBAT_GET_STATS:
                    globalFlash.gui.mAdventurePanel.setCombatStats(_local_2.data);
                    return;
                case COMMAND.COLONY_GET_DEFENSE_MODE_STATS:
                    globalFlash.gui.mAdventurePanel.setDefenseModeStats(_local_2.data);
                    return;
                case COMMAND.CHEAT_GET_GENERIC_VALUES:
                    return;
                case COMMAND.INIT_CLIENT_DONE:
                case COMMAND.INPUT_ACTION:
                case COMMAND.MARK_MAIL_AS_READ:
                case COMMAND.VISIT_FRIEND_ZONE:
                case COMMAND.LOGGER_SEND_CLIENT_LOG:
                case COMMAND.LOGGER_SEND_UNCAUGHT_EXCEPTION:
                case COMMAND.CHANGE_TRACKED_MISSION_LIST:
                case COMMAND.CANCEL_ADVENTURE:
                case COMMAND.CANCEL_PVP_COLONY:
                case COMMAND.SET_HIDE_HELP:
                case COMMAND.HELP_SHOWN:
                case COMMAND.RESET_HELP:
                case COMMAND.REMOVE_TRADE:
                case COMMAND.DELAY_EVENT_1:
                case COMMAND.DELAY_EVENT_2:
                case COMMAND.PENDING_DATABASE_INC:
                case COMMAND.PENDING_DATABASE_DEC:
                case COMMAND.CHANGE_SPECIALIST_NAME:
                case COMMAND.FORCE_GUILD_STEPDOWN_CHK:
                case COMMAND.GUILD_STEP_DOWN:
                case COMMAND.SPAWN_PICKUPS_CHEAT:
                case COMMAND.MARK_MAILS:
                case COMMAND.BLOCK_SENDER:
                case COMMAND.UNBLOCK_SENDER:
                case COMMAND.ADD_PICKUP:
                case COMMAND.CLIENT_UI_TRACK:
                case COMMAND.SAVE_PLAYER_SETTINGS:
                case COMMAND.CHEAT_SET_GENERIC_VALUE:
                    return;
                default:
                    cLog.warning(("cClientMessagesII.ReceivedMessageFromServer: Unknown ResponseType from server: " + _arg_1.type));
            };
        }

        public function loadUserCookies():void
        {
            var _local_1:Array;
            var _local_2:String;
            if (global.useExternalServer)
            {
                _local_1 = (ExternalInterface.call("function getCookie(){return document.cookie;}") as String).replace(" ", "").split(";");
                for each (_local_2 in _local_1)
                {
                    if (_local_2.indexOf("dsoAuthToken=") != -1)
                    {
                        mAuthToken = StringUtil.trim(_local_2).substr(13);
                    }
                    else
                    {
                        if (_local_2.indexOf("dsoAuthUser=") != -1)
                        {
                            mAuthUser = parseInt(StringUtil.trim(_local_2).substr(12));
                        };
                    };
                };
            };
        }


    }
}
