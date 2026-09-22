package GUI.GAME
{
    import GUI.cGuiBaseElement;
    import Interface.cGameInterface;
    import GUI.Components.ItemRenderer.AvatarMessageItemRenderer;
    import GUI.Components.AvatarMessageList;
    import Specialists.cSpecialist;
    import Specialists.cSpecialistTask_WithSettler;
    import Communication.VO.dBuffVO;
    import GO.cDeposit;
    import BuffSystem.cBuff;
    import GO.cBuilding;
    import Communication.VO.dResourceVO;
    import ServerState.dResource;
    import Specialists.cSpecialistTask;
    import Specialists.cSpecialistSubTaskDefinition;
    import GUI.Loca.cLocaManager;
    import Enums.LOCA_GROUP;
    import Enums.AVATAR_MESSAGE_TYPE;
    import flash.events.MouseEvent;
    import GUI.Assets.gAssetManager;
    import Enums.SPECIALIST_TYPE;
    import TimedProduction.cTimedProduction;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import GUI.achievement.view.detail.AchievementIconView;
    import Achievements.AchievementsManager;
    import Achievements.UserAchievement;
    import BuffSystem.cBuffDefinition;
    import Sound.cSoundManager;
    import Skill.cSkill;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import GUI.ApplicationFacade;
    import Achievements.AchievementConsts;
    import flash.events.Event;

    public class cAvatarMessageList extends cGuiBaseElement 
    {

        private var mGI:cGameInterface;
        protected var prevMessage:AvatarMessageItemRenderer;
        private var isActive:Boolean = false;
        protected var mMessageList:AvatarMessageList;
        private var preInitMessages:Array = new Array();
        public var mClientMessages:AvatarMessageList;


        public function ActivateMessages():void
        {
            var _local_1:int;
            if (!this.isActive)
            {
                this.isActive = true;
                while (_local_1 < this.preInitMessages.length)
                {
                    this.AddMessage(this.preInitMessages[_local_1][0], this.preInitMessages[_local_1][1]);
                    _local_1++;
                };
                this.preInitMessages = new Array();
            };
        }

        public function clearAllMessages():void
        {
            var _local_1:AvatarMessageItemRenderer;
            for each (_local_1 in this.mMessageList.getChildren())
            {
                if ((_local_1 is AvatarMessageItemRenderer))
                {
                    _local_1.forceHide();
                };
            };
        }

        public function AddMessage(_messageType:String, data:Object=null, ignore:Boolean=false):void
        {
            var general:cSpecialist;
            var task:cSpecialistTask_WithSettler;
            var bvo:dBuffVO;
            var geologist:cSpecialist;
            var deposit:cDeposit;
            var depositResourceName:String;
            var buff:cBuff;
            var amount:Number;
            var resName:String;
            var resAmount:int;
            var resourceName:String;
            var building:cBuilding;
            var msg:Array;
            var clickHandler:Function;
            var buff2:cBuff;
            var resource:dResourceVO;
            var s:String;
            var i:int;
            var icon:Array;
            var collectionResource:dResource;
            var achievementBuffVO:dBuffVO;
            var buffName:String;
            var dataArray:Array;
            var params:Array;
            var paramameters:Array;
            var explorerTask:cSpecialistTask;
            var explorerTaskDefinition:cSpecialistSubTaskDefinition;
            var explorerTask2:cSpecialistTask;
            var explorerTaskDefinition2:cSpecialistSubTaskDefinition;
            var geologistTask:cSpecialistTask;
            var geologistTaskDefinition:cSpecialistSubTaskDefinition;
            if (ignore)
            {
                return;
            };
            if (!this.isActive)
            {
                this.preInitMessages.push([_messageType, data]);
                return;
            };
            var sound:String = "";
            var soundExtension:String = "";
            var specialist:cSpecialist;
            var message:AvatarMessageItemRenderer = new AvatarMessageItemRenderer();
            this.mMessageList.addChild(message);
            message.headlineLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGE_LABELS, _messageType);
            message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
            switch (_messageType)
            {
                case AVATAR_MESSAGE_TYPE.GENERAL_FINISHED_POSITIVE:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_FINISHED_POSITIVE:
                case AVATAR_MESSAGE_TYPE.GENERAL_FINISHED_POSITIVE_VIEWER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_FINISHED_POSITIVE_VIEWER:
                case AVATAR_MESSAGE_TYPE.GENERAL_FINISHED_NEGATIVE:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_FINISHED_NEGATIVE:
                case AVATAR_MESSAGE_TYPE.GENERAL_FINISHED_NEGATIVE_VIEWER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_FINISHED_NEGATIVE_VIEWER:
                    sound = "Message";
                case AVATAR_MESSAGE_TYPE.GENERAL_STARTET_TRANSFER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_STARTET_TRANSFER:
                case AVATAR_MESSAGE_TYPE.GENERAL_STARTET_TRANSFER_VIEWER:
                case AVATAR_MESSAGE_TYPE.GENERAL_TRAVELS_TO_ZONE:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_TRAVELS_TO_ZONE:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_TRAVELS_TO_STAR_MENU:
                case AVATAR_MESSAGE_TYPE.GENERAL_TRAVELS_TO_STAR_MENU:
                case AVATAR_MESSAGE_TYPE.GENERAL_DISTRACTED:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_DISTRACTED:
                case AVATAR_MESSAGE_TYPE.GENERAL_DISTRACTED_VIEWER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_DISTRACTED_VIEWER:
                    if (sound == "")
                    {
                        sound = "GeneralMove";
                    };
                case AVATAR_MESSAGE_TYPE.GENERAL_RETREAT:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_RETREAT:
                case AVATAR_MESSAGE_TYPE.GENERAL_RETREAT_VIEWER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_RETREAT_VIEWER:
                    if (sound == "")
                    {
                        sound = "GeneralRetreat";
                    };
                case AVATAR_MESSAGE_TYPE.GENERAL_STARTET_ATTACK:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_STARTET_ATTACK:
                case AVATAR_MESSAGE_TYPE.GENERAL_STARTET_ATTACK_VIEWER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_STARTET_ATTACK_VIEWER:
                    if (sound == "")
                    {
                        sound = "GeneralBattleStart";
                    };
                case AVATAR_MESSAGE_TYPE.GENERAL_LOST:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_LOST:
                case AVATAR_MESSAGE_TYPE.GENERAL_LOST_VIEWER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_LOST_VIEWER:
                    if (sound == "")
                    {
                        sound = "GeneralLose";
                    };
                case AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_CONTINUES:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_WON_AND_CONTINUES:
                case AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_CONTINUES_VIEWER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_WON_AND_CONTINUES_VIEWER:
                case AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_RETURNS:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_WON_AND_RETURNS:
                case AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_RETURNS_VIEWER:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_WON_AND_RETURNS_VIEWER:
                case AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_BLOCKED:
                case AVATAR_MESSAGE_TYPE.GENERAL_WON_AND_BLOCKED_VIEWER:
                    general = (data as cSpecialist);
                    task = (general.GetTask() as cSpecialistTask_WithSettler);
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        if (task.GetSettlerGridIndex() != -1)
                        {
                            mGI.mCurrentPlayerZone.ScrollToGrid(task.GetSettlerGridIndex());
                        }
                        else
                        {
                            if (general.GetGarrison() != null)
                            {
                                mGI.mCurrentPlayerZone.ScrollToGrid(general.GetGarrison().GetGrid());
                            };
                        };
                    });
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = this.AddStarIfNeeded(general, gAssetManager.GetBitmap(general.getIconID()));
                    if (sound == "")
                    {
                        sound = "GeneralWin";
                    };
                    break;
                case AVATAR_MESSAGE_TYPE.GENERAL_INSTANT_RECOVER:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBitmap("1-Up.png");
                    break;
                case AVATAR_MESSAGE_TYPE.NEW_GENERAL:
                case AVATAR_MESSAGE_TYPE.NEW_ADMIRAL:
                case AVATAR_MESSAGE_TYPE.GENERAL_DID_NOT_FIND_LANDINGGRID:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_DID_NOT_FIND_LANDINGGRID:
                case AVATAR_MESSAGE_TYPE.GENERAL_CANNOT_REACH_TARGET:
                case AVATAR_MESSAGE_TYPE.GENERAL_RECOVERED:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_RECOVERED:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_CANNOT_REACH_TARGET:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mStarMenu.Show();
                    });
                    specialist = (data as cSpecialist);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = this.AddStarIfNeeded(specialist, gAssetManager.GetBitmap(specialist.getIconID()));
                    sound = "Message";
                    break;
                case AVATAR_MESSAGE_TYPE.HIRED_MILITARY_FROM_SKILL:
                    bvo = (data as dBuffVO);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [bvo.resourceName_string, bvo.amount]);
                    message.image.source = gAssetManager.GetMilitaryIcon(bvo.resourceName_string);
                    break;
                case AVATAR_MESSAGE_TYPE.NEW_EXPLORER:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mStarMenu.Show();
                    });
                    message.image.source = gAssetManager.GetBitmap((data as cSpecialist).getIconID());
                    sound = "Message";
                    break;
                case AVATAR_MESSAGE_TYPE.EXPLORER_FINISHED_NEGATIVE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_MAP_FRAGMENT:
                case AVATAR_MESSAGE_TYPE.EXPLORER_DID_NOT_FIND_EVENT_ZONE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_DID_NOT_FIND_EXPEDITION_ZONE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_DID_NOT_FIND_ADVENTURE_ZONE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_DID_NOT_FIND_TREASURE:
                    specialist = (data as cSpecialist);
                    if (sound == "")
                    {
                        sound = "ExplorerFail";
                        soundExtension = specialist.GetSpecialistDescription().getName_string();
                    };
                    message.image.source = this.AddStarIfNeeded(specialist, gAssetManager.GetBitmap(specialist.getIconID()));
                    break;
                case AVATAR_MESSAGE_TYPE.EXPLORER_FINISHED_POSITIVE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_EVENT_ZONE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_EXPEDITION_ZONE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_ADVENTURE_ZONE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_FOUND_TREASURE:
                    specialist = (data as cSpecialist);
                    if (sound == "")
                    {
                        sound = "ExplorerSuccess";
                        soundExtension = specialist.GetSpecialistDescription().getName_string();
                    };
                    message.image.source = this.AddStarIfNeeded(specialist, gAssetManager.GetBitmap(specialist.getIconID()));
                    break;
                case AVATAR_MESSAGE_TYPE.EXPLORER_STARTED_FIND_EVENT_ZONE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_STARTED_FIND_EXPEDITION_ZONE:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    specialist = (data as cSpecialist);
                    if (sound == "")
                    {
                        sound = "ExplorerStart";
                        soundExtension = specialist.GetSpecialistDescription().getName_string();
                    };
                    message.image.source = this.AddStarIfNeeded(specialist, gAssetManager.GetBitmap(specialist.getIconID()));
                    break;
                case AVATAR_MESSAGE_TYPE.EXPLORER_STARTED_FIND_TREASURE:
                case AVATAR_MESSAGE_TYPE.EXPLORER_STARTED_FIND_ADVENTURE_ZONE:
                    specialist = (data as cSpecialist);
                    message.image.source = this.AddStarIfNeeded(specialist, gAssetManager.GetBitmap(specialist.getIconID()));
                    if (sound == "")
                    {
                        explorerTask = specialist.GetTask();
                        explorerTaskDefinition = global.specialistTaskDefinitions_vector[explorerTask.GetType()].subtasks_vector[explorerTask.GetSubType()];
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, (_messageType + explorerTaskDefinition.taskType_string));
                        sound = "ExplorerStart";
                        soundExtension = specialist.GetSpecialistDescription().getName_string();
                    };
                    break;
                case AVATAR_MESSAGE_TYPE.EXPLORER_STARTED:
                    specialist = (data as cSpecialist);
                    message.image.source = this.AddStarIfNeeded(specialist, gAssetManager.GetBitmap(specialist.getIconID()));
                    if (sound == "")
                    {
                        explorerTask2 = specialist.GetTask();
                        explorerTaskDefinition2 = global.specialistTaskDefinitions_vector[explorerTask2.GetType()].subtasks_vector[explorerTask2.GetSubType()];
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, ((_messageType + explorerTaskDefinition2.mainTask.taskName_string) + explorerTaskDefinition2.taskType_string));
                        sound = "ExplorerStart";
                        soundExtension = specialist.GetSpecialistDescription().getName_string();
                    };
                    break;
                case AVATAR_MESSAGE_TYPE.NEW_GEOLOGIST:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mStarMenu.Show();
                    });
                    sound = "Message";
                case AVATAR_MESSAGE_TYPE.GEOLOGIST_STARTED_FIND_DEPOSIT:
                    geologist = (data as cSpecialist);
                    message.image.source = this.AddStarIfNeeded(geologist, gAssetManager.GetBitmap(geologist.getIconID()));
                    if (sound == "")
                    {
                        geologistTask = geologist.GetTask();
                        geologistTaskDefinition = global.specialistTaskDefinitions_vector[geologistTask.GetType()].subtasks_vector[geologistTask.GetSubType()];
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [geologistTaskDefinition.taskType_string]);
                        sound = "GeologistStart";
                        soundExtension = geologist.GetSpecialistDescription().getName_string();
                    }
                    else
                    {
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    };
                    break;
                case AVATAR_MESSAGE_TYPE.ADMIRAL_TRAVELS_TO_STAR_MENU:
                case AVATAR_MESSAGE_TYPE.GENERAL_TRAVELS_TO_STAR_MENU:
                case AVATAR_MESSAGE_TYPE.ADMIRAL_RETURNED_TO_STAR:
                case AVATAR_MESSAGE_TYPE.GENERAL_RETURNED_TO_STAR:
                    specialist = (data as cSpecialist);
                    message.image.source = this.AddStarIfNeeded(specialist, gAssetManager.GetBitmap(specialist.getIconID()));
                    break;
                case AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_POSITIVE:
                case AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_POSITIVE_SECOND:
                case AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_POSITIVE_FAILOVER:
                    deposit = (data[0] as cDeposit);
                    geologist = (data[1] as cSpecialist);
                    depositResourceName = deposit.GetName_string();
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        mGI.mCurrentPlayerZone.ScrollToGrid(deposit.GetGrid());
                    });
                    sound = "GeologistSuccess";
                    if (geologist != null)
                    {
                        soundExtension = geologist.GetSpecialistDescription().getName_string();
                    }
                    else
                    {
                        soundExtension = cSpecialist.GetSpecialistDescriptionForType(SPECIALIST_TYPE.GEOLOGIST).getName_string();
                    };
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [depositResourceName]);
                    message.image.source = gAssetManager.GetResourceIcon(depositResourceName);
                    break;
                case AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_NEGATIVE_ALL_ACCESSIBLE:
                case AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_NEGATIVE_NO_DEPOSIT:
                case AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_NEGATIVE_SECOND:
                case AVATAR_MESSAGE_TYPE.GEOLOGIST_FINISHED_NEGATIVE:
                    if (sound == "")
                    {
                        sound = "GeologistFail";
                    };
                    depositResourceName = (data[0] as String);
                    specialist = (data[1] as cSpecialist);
                    if (specialist != null)
                    {
                        soundExtension = specialist.GetSpecialistDescription().getName_string();
                    };
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [depositResourceName]);
                    message.image.source = gAssetManager.GetResourceIcon(depositResourceName);
                    break;
                case AVATAR_MESSAGE_TYPE.GENERAL_SKILL_STAR_COINS_PICKED_UP_FROM_ADVENTURE:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as int)]);
                    break;
                case AVATAR_MESSAGE_TYPE.DEPOSIT_DEPLETED:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as cDeposit).GetName_string()]);
                    message.image.source = gAssetManager.GetResourceIcon((data as cDeposit).GetName_string());
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        mGI.mCurrentPlayerZone.ScrollToGrid((data as cDeposit).GetGrid());
                    });
                    sound = "DepositDepleted";
                    break;
                case AVATAR_MESSAGE_TYPE.NEW_MAIL:
                    sound = "MessageMail";
                case AVATAR_MESSAGE_TYPE.MAIL_SENT:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBitmap("ButtonIconNewMail");
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mMailWindow.Show();
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.FRIEND_REQUEST_SENT:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBitmap("ButtonIconNewMail");
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mMailWindow.Show();
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.FRIEND_REQUEST_COOLDOWN:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBitmap("ButtonIconNewMail");
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mMailWindow.Show();
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.NEW_QUEST:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBitmap("IconQuest");
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        cBasicPanel.HideCurrentActivePanel();
                        globalFlash.gui.mQuestBook.Show();
                    });
                    sound = "QuestNew";
                    break;
                case AVATAR_MESSAGE_TYPE.NO_TOOLS:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetResourceIcon("Tool");
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        mGI.mCurrentPlayerZone.ScrollToGrid((data as cBuilding).GetGrid());
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.LAST_BUILDING_LICENSE_USED:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBuffIcon("IncreaseMaxBuildingCount");
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mShopWindow.ShowDeepLink("AvatarMessage", 5004, 5);
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.USED_DEPOSIT_BUFF:
                    buff = (data as cBuff);
                    amount = ((buff.getAmountAppliedOnLastUsage() > 0) ? buff.getAmountAppliedOnLastUsage() : buff.GetAmount());
                    if ((data as cBuff).GetResourceName_string() != "")
                    {
                        message.image.source = gAssetManager.GetResourceIcon(buff.GetResourceName_string());
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [amount.toString(), buff.GetResourceName_string()]);
                    }
                    else
                    {
                        message.image.source = gAssetManager.GetBuffIcon(buff.GetBuffDefinition().GetName_string());
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [amount.toString(), "Units"]);
                    };
                    break;
                case AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF:
                case AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF_LIMIT_REACHED:
                    resName = "";
                    resAmount = 0;
                    if ((data is cBuff))
                    {
                        resName = (data as cBuff).GetResourceName_string();
                        resAmount = (data as cBuff).getAmountAppliedOnLastUsage();
                    }
                    else
                    {
                        if ((data is Array))
                        {
                            resName = (data[0] as String);
                            resAmount = (data[1] as int);
                        };
                    };
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.ShowBuilding(defines.MAYORHOUSE_NAME_string);
                    });
                    message.image.source = gAssetManager.GetResourceIcon(resName);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [resAmount.toString(), resName]);
                    break;
                case AVATAR_MESSAGE_TYPE.USED_ZONE_BUFF:
                case AVATAR_MESSAGE_TYPE.FRIEND_USED_ZONE_BUFF:
                case AVATAR_MESSAGE_TYPE.USED_ZONE_BUFF_ON_FRIEND:
                    resourceName = (((data as cBuff).GetResourceName_string().length > 0) ? ("_" + (data as cBuff).GetResourceName_string()) : "");
                    message.image.source = gAssetManager.GetBuffIcon(((data as cBuff).GetType() + resourceName));
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [((data as cBuff).GetType() + resourceName)]);
                    break;
                case AVATAR_MESSAGE_TYPE.USED_HIRED_TROOP_BUFF:
                case AVATAR_MESSAGE_TYPE.USED_HIRED_TROOP_BUFF_TO_FRIEND:
                case AVATAR_MESSAGE_TYPE.USED_POPULATION_RESOURCE_BUFF:
                case AVATAR_MESSAGE_TYPE.USED_POPULATION_BUFF_LIMIT_REACHED:
                    message.image.source = gAssetManager.GetResourceIcon((data as cBuff).GetResourceName_string());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as cBuff).getAmountAppliedOnLastUsage().toString(), (data as cBuff).GetResourceName_string()]);
                    break;
                case AVATAR_MESSAGE_TYPE.QUEST_REWARD_LIMIT_REACHED:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.ShowBuilding(defines.MAYORHOUSE_NAME_string);
                    });
                    message.image.source = gAssetManager.GetResourceIcon((data as dResource).name_string);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as dResource).amount.toString(), (data as dResource).name_string]);
                    break;
                case AVATAR_MESSAGE_TYPE.PLACED_BUFF:
                case AVATAR_MESSAGE_TYPE.PLACED_BUFF_ON_FRIEND:
                case AVATAR_MESSAGE_TYPE.PLACED_BUFF_ON_FRIEND_NEGATIVE:
                case AVATAR_MESSAGE_TYPE.PLACED_BUFF_BY_FRIEND:
                case AVATAR_MESSAGE_TYPE.PLACED_BUFF_BY_FRIEND_NEGATIVE:
                case AVATAR_MESSAGE_TYPE.REMOVED_BUFF:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        mGI.mCurrentPlayerZone.ScrollToGrid((data as cBuilding).GetGrid());
                    });
                    message.image.source = gAssetManager.GetBuildingIcon((data as cBuilding).GetBuildingName_string());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.DESTROY_MOUNTAIN_READY:
                case AVATAR_MESSAGE_TYPE.PLACED_DESTROY_MOUNTAIN_BUFF:
                    if ((data is cBuilding))
                    {
                        building = (data as cBuilding);
                        msg = [cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, building.GetBuildingName_string())];
                    }
                    else
                    {
                        building = (data[0] as cBuilding);
                        msg = [cLocaManager.GetInstance().GetText(LOCA_GROUP.SHOP_ITEMS, (data[1] as cBuff).GetBuffDefinition().GetName_string()), cLocaManager.GetInstance().GetText(LOCA_GROUP.BUILDINGS, building.GetBuildingName_string())];
                    };
                    clickHandler = function (_arg_1:MouseEvent):void
                    {
                        mGI.mCurrentPlayerZone.ScrollToGrid(building.GetGrid());
                        _arg_1.target.removeEventListener(MouseEvent.CLICK, clickHandler);
                    };
                    message.addEventListener(MouseEvent.CLICK, clickHandler);
                    message.image.source = gAssetManager.GetBuildingIcon(building.GetBuildingName_string());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, msg);
                    break;
                case AVATAR_MESSAGE_TYPE.PRODUCTION_FINISHED:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mStarMenu.Show();
                    });
                    message.image.source = gAssetManager.GetBuildingIcon(cTimedProduction(data).GetProductionOrder().GetBuilding().GetBuildingName_string());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    sound = "BuffProduced";
                    break;
                case AVATAR_MESSAGE_TYPE.INCREASED_MAX_BUILDINGS:
                    buff2 = (data as cBuff);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [buff2.GetAmount()]);
                    message.image.source = gAssetManager.GetBuffIcon(buff2.GetType());
                    break;
                case AVATAR_MESSAGE_TYPE.INCREASED_PERMANENT_BUILDSLOT:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBuffIcon((data as cBuff).GetType());
                    break;
                case AVATAR_MESSAGE_TYPE.PURCHASE_SUCCESSFUL:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mStarMenu.Show();
                    });
                    globalFlash.gui.mActionBar.ShowStarAnim();
                case AVATAR_MESSAGE_TYPE.PURCHASE_HARD_CURRENCY_SUCCESSFUL:
                case AVATAR_MESSAGE_TYPE.PURCHASE_GIFT_SUCCESSFUL:
                    message.image.source = gAssetManager.GetResourceIcon("HardCurrency");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    sound = "PayitemPurchase";
                    break;
                case AVATAR_MESSAGE_TYPE.RECRUITMENT_FINISHED:
                    message.image.source = gAssetManager.GetBuildingIcon("Barracks");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    sound = "UnitProduced";
                    break;
                case AVATAR_MESSAGE_TYPE.RECRUITMENT_FINISHED_NEW_COMBAT:
                    message.image.source = gAssetManager.GetBuildingIcon("Barracks3");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    sound = "UnitProduced";
                    break;
                case AVATAR_MESSAGE_TYPE.SKILLPOINT_PICK_UP:
                    message.image.source = gAssetManager.GetBuildingIcon("Bookbinder");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.TRADE_INITIATED:
                case AVATAR_MESSAGE_TYPE.TRADE_ACCEPTED_WAREHOUSE:
                case AVATAR_MESSAGE_TYPE.TRADE_ACCEPTED_BUFF:
                case AVATAR_MESSAGE_TYPE.TRADE_SUCESSFULL:
                case AVATAR_MESSAGE_TYPE.TRADE_UNSUCESSFULL:
                case AVATAR_MESSAGE_TYPE.TRADE_EXPIRED:
                case AVATAR_MESSAGE_TYPE.TRADE_LOT_SOLD:
                    message.image.source = gAssetManager.GetBitmap("ButtonIconDiplomacy");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.TRADED_RESOURCE_LIMIT_REACHED:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.ShowBuilding(defines.MAYORHOUSE_NAME_string);
                    });
                    resource = (data as dResourceVO);
                    message.image.source = gAssetManager.GetResourceIcon(resource.name_string);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [resource.amount.toString(), resource.name_string]);
                    break;
                case AVATAR_MESSAGE_TYPE.CLAIMED_SECTOR:
                    message.image.source = gAssetManager.GetBuildingIcon(defines.WAREHOUSES_NAME_string);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.SERVER_CALL_FAILED:
                    sound = "ServerLost";
                    break;
                case AVATAR_MESSAGE_TYPE.GUILD_INCREASE_SIZE:
                    message.image.source = gAssetManager.GetResourceIcon((data as cBuff).GetBuffDefinition().GetName_string());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as cBuff).GetBuffDefinition().GetAmount().toString()]);
                    break;
                case AVATAR_MESSAGE_TYPE.GUILD_CHANGES_SAVED:
                case AVATAR_MESSAGE_TYPE.GUILD_INVITE_SENT:
                case AVATAR_MESSAGE_TYPE.GUILD_DISBANDED:
                case AVATAR_MESSAGE_TYPE.GUILD_LEFT:
                    message.image.source = gAssetManager.GetBitmap("IconMailTypeGuild");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.ADVENTURE_STARTED:
                case AVATAR_MESSAGE_TYPE.EXPEDITION_STARTED:
                    message.image.source = gAssetManager.GetBitmap("ButtonIconFindAdventure");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as dAdventureClientInfoVO).adventureName]);
                    break;
                case AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_WAS_INVITED:
                case AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_INVITATION_CANCELLED:
                    message.image.source = gAssetManager.GetBitmap("ButtonIconFindAdventure");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [data.playerName, data.adventureName, data.owner]);
                    break;
                case AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_ACCEPTED_INVITATION:
                case AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_DECLINED_INVITATION:
                case AVATAR_MESSAGE_TYPE.ADVENTURE_PLAYER_LEFT:
                    message.image.source = gAssetManager.GetBitmap("ButtonIconFindAdventure");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [data.playerName, data.adventureName]);
                    break;
                case AVATAR_MESSAGE_TYPE.EXPEDITION_STARTED:
                    message.image.source = gAssetManager.GetBitmap("ButtonIconFindAdventure");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.FILTER_ACTIVE:
                    message.image.source = gAssetManager.GetBuffIcon(("ChangeColorScheme_" + data));
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, ("ChangeColorScheme_" + data));
                    break;
                case AVATAR_MESSAGE_TYPE.RESOURCE_DONATION_SERVER_GOAL_REACHED:
                case AVATAR_MESSAGE_TYPE.RESOURCE_DONATION_REACTIVATED:
                    message.setDisplayDurationTicks(20000);
                case AVATAR_MESSAGE_TYPE.RESOURCE_DONATION_SUCCESSFUL:
                case AVATAR_MESSAGE_TYPE.RESOURCE_TRANSFER_SUCCESSFUL:
                case AVATAR_MESSAGE_TYPE.RESOURCE_WITHDRAW_SUCCESSFUL:
                    s = data[0];
                    i = data[1];
                    message.image.source = gAssetManager.GetResourceIcon(s);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, s), i]);
                    break;
                case AVATAR_MESSAGE_TYPE.BUFF_DONATION_SUCCESSFUL:
                case AVATAR_MESSAGE_TYPE.BUFF_WITHDRAW_SUCCESSFUL:
                case AVATAR_MESSAGE_TYPE.BUFF_TRANSFER_SUCCESSFUL:
                    icon = (data[0] as cBuff).GetBuffIconData();
                    message.image.source = gAssetManager.GetIcon(icon[1], icon[0]);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data[0] as cBuff).getLocalizedBuffName()]);
                    break;
                case AVATAR_MESSAGE_TYPE.PREMIUM_ACCOUNT_ACTIVATED:
                    message.image.source = gAssetManager.GetBuffIcon((data as cBuff).GetType());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.PREMIUM_ACCOUNT_EXPIRED:
                    message.image.source = this.getIcon("PremiumAccountGenericIcon");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mShopWindow.ShowDeepLink("AvatarMessage", -1, 19);
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.COLLECTION_RESOURCE_RECEIVED:
                case AVATAR_MESSAGE_TYPE.ACHIEVEMENT_RESOURCE_RECEIVED:
                    collectionResource = (data as dResource);
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.ShowBuilding(defines.MAYORHOUSE_NAME_string);
                    });
                    message.image.source = gAssetManager.GetResourceIcon(collectionResource.name_string);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [collectionResource.amount.toString(), collectionResource.name_string]);
                    break;
                case AVATAR_MESSAGE_TYPE.ACHIEVEMENT_BUFF_RECEIVED:
                    achievementBuffVO = (data as dBuffVO);
                    buffName = achievementBuffVO.getName();
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [achievementBuffVO.amount.toString(), buffName]);
                    message.image.source = gAssetManager.GetBuffIcon(achievementBuffVO.buffName_string);
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mStarMenu.Show();
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.COLLECTION_BUFF_RECEIVED:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBuildingIcon(defines.MAYORHOUSE_NAME_string);
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mStarMenu.Show();
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.COLLECTED_EVENT_PICKUP_IN_ADVENTURE:
                    dataArray = (data as Array);
                    message.image.source = gAssetManager.GetBuildingIcon(dataArray[0]);
                    if (dataArray[1] == "")
                    {
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    }
                    else
                    {
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, ((_messageType + "_") + dataArray[1]));
                    };
                    break;
                case AVATAR_MESSAGE_TYPE.COLLECTED_PICKUP_IN_ADVENTURE:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBitmap("ButtonIconNewMail");
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mMailWindow.Show();
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.COLLECTION_READY_FOR_PICKUP:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBuildingIcon(defines.MAYORHOUSE_NAME_string);
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.mMayorhouseInfoPanel.SetData(global.ui.mCurrentPlayerZone.mStreetDataMap.GetMayorHouse());
                        globalFlash.gui.mMayorhouseInfoPanel.showCollectiblesTab();
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.BUFF_REDEEMED:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBuildingIcon(defines.MAYORHOUSE_NAME_string);
                    break;
                case AVATAR_MESSAGE_TYPE.MONSTER_HIT:
                    message.headlineLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGE_LABELS, ((_messageType + "_") + data.monsterName));
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, ((_messageType + "_") + data.monsterName), [("" + (data.removedUnits as int))]);
                    message.image.source = gAssetManager.GetBuildingIcon(data.monsterName);
                    break;
                case AVATAR_MESSAGE_TYPE.MONSTER_HIT_BY_FRIEND:
                    message.headlineLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGE_LABELS, ((_messageType + "_") + data.monsterName));
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, ((_messageType + "_") + data.monsterName), [("" + (data.removedUnits as int))]);
                    message.image.source = gAssetManager.GetBuildingIcon(data.monsterName);
                    break;
                case AVATAR_MESSAGE_TYPE.HALLOWEEN_BRIGHT_LIGHT:
                    message.image.source = gAssetManager.GetBuffIcon((data as cBuff).GetType());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.REDEEM_LIMIT_REACHED:
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.ShowBuilding(defines.MAYORHOUSE_NAME_string);
                    });
                    message.image.source = gAssetManager.GetResourceIcon((data as dResource).name_string);
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as dResource).amount.toString(), (data as dResource).name_string]);
                    break;
                case AVATAR_MESSAGE_TYPE.REMOVED_RANDOM_BANDITS:
                case AVATAR_MESSAGE_TYPE.REMOVED_BANDIT_UNIT:
                case AVATAR_MESSAGE_TYPE.REMOVED_RANDOM_BANDIT_UNIT:
                case AVATAR_MESSAGE_TYPE.REMOVED_BANDIT_CAMP:
                case AVATAR_MESSAGE_TYPE.HEALED_MAYA_CAMP:
                    message.image.source = gAssetManager.GetBuffIcon((data as cBuff).GetBuffDefinition().GetName_string());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.RED_NOSE_AVATAR_ADD:
                case AVATAR_MESSAGE_TYPE.RED_NOSE_AVATAR_REMOVE:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBuffIcon("ChangeAvatar_RedNose");
                    break;
                case AVATAR_MESSAGE_TYPE.REVEAL_COLLECTIBLES:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = ((this.mGI.mHomePlayer.GetPlayerId() < 0) ? gAssetManager.GetBuffIcon("RevealCollectiblesBuff02") : gAssetManager.GetBuffIcon("RevealCollectiblesBuff01"));
                    break;
                case AVATAR_MESSAGE_TYPE.MORE_ACHIEVEMENTS_FINISHED:
                    message.AvatarMessageBackground = AvatarMessageItemRenderer.AvatarMessageBackgroundAchievement;
                    message.AvatarMessageBackgroundHighlight = AvatarMessageItemRenderer.AvatarMessageBackgroundAchievementHighlight;
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as int)]);
                    message.image.source = gAssetManager.GetGfx("AchievementsCompletedAvatarMessageIcon");
                    message.addEventListener(MouseEvent.CLICK, this.handleAchievementFinishedClickEventListener);
                    break;
                case AVATAR_MESSAGE_TYPE.ACHIEVEMENT_FINISHED:
                    message.AvatarMessageBackground = AvatarMessageItemRenderer.AvatarMessageBackgroundAchievement;
                    message.AvatarMessageBackgroundHighlight = AvatarMessageItemRenderer.AvatarMessageBackgroundAchievementHighlight;
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.visible = false;
                    message.iconView = new AchievementIconView(message.iconBox);
                    message.iconView.init(AchievementsManager.getInstance().getAchievementGUIDetailVO((data as UserAchievement).getAchievementVO().getAchievementID()), true);
                    message.setData(data);
                    message.addEventListener(MouseEvent.CLICK, this.handleMoreAchievementsFinishedClickEventListener);
                    message.iconView.updateAchievementFinished(true);
                    message.iconBox.visible = true;
                    break;
                case AVATAR_MESSAGE_TYPE.ACHIEVEMENT_FACEBOOK_SENT:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, "AchievementSent");
                    message.image.source = this.getIcon("AchievementsCompletedAvatarMessageIcon");
                    break;
                case AVATAR_MESSAGE_TYPE.UNLOCKED_ISLAND_BY_BUFF:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    message.image.source = gAssetManager.GetBuffIcon((data as cBuff).GetBuffDefinition().GetName_string());
                    break;
                case AVATAR_MESSAGE_TYPE.EFFECT:
                    params = (data as Array);
                    if (((!(params == null)) && (params.length > 0)))
                    {
                        message.headlineLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGE_LABELS, (params[0] as String));
                        if (params.length > 1)
                        {
                            message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, (params[1] as String));
                            if (params.length > 2)
                            {
                                message.image.source = this.getIcon((params[2] as String));
                            };
                        };
                    };
                    message.setDisplayDurationTicks(100000);
                    break;
                case AVATAR_MESSAGE_TYPE.COLLECTED_PICKUP_IN_ADVENTURE:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                case AVATAR_MESSAGE_TYPE.BUFF_ADVENTURE_APPLIED:
                    message.image.source = gAssetManager.GetBuffIcon((data as cBuffDefinition).GetType());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [cLocaManager.GetInstance().GetText(LOCA_GROUP.RESOURCES, (data as cBuffDefinition).GetName_string())]);
                    break;
                case AVATAR_MESSAGE_TYPE.EVENT_START:
                    paramameters = (data as Array);
                    if (((!(paramameters == null)) && (paramameters.length > 0)))
                    {
                        message.headlineLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGE_LABELS, (paramameters[0] as String));
                        message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, paramameters[0]);
                        if (((paramameters.length > 1) && (!(paramameters[1] == ""))))
                        {
                            message.image.source = this.getIcon(paramameters[1]);
                        };
                        if (((paramameters.length > 3) && (!(paramameters[2] == ""))))
                        {
                            message.addEventListener(MouseEvent.CLICK, function ():void
                            {
                                var _local_1:cGuiBaseElement = cGuiBaseElement.GetPanelController(paramameters[2]);
                                if ((_local_1 is cHelpWindow))
                                {
                                    (_local_1 as cHelpWindow).ForceNextHelpWindow();
                                };
                                _local_1.SetDataByString(paramameters[3]);
                                globalFlash.gui.TryShowPanel(_local_1);
                            });
                        };
                    };
                    break;
                case AVATAR_MESSAGE_TYPE.QUEST_ALREADY_ACTIVE:
                    message.image.source = gAssetManager.GetBitmap("IconQuest");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as String)]);
                    break;
                case AVATAR_MESSAGE_TYPE.CHANGE_SKIN_BUFF_APPLIED:
                    message.image.source = gAssetManager.GetBuildingIcon((data as cBuilding).GetBuildingName_string());
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType, [(data as cBuilding).GetBuildingName_string()]);
                    break;
                case AVATAR_MESSAGE_TYPE.TASK_FINISHED:
                    message.image.source = gAssetManager.GetBuildingIcon("TaskBuilding");
                    message.headlineLabel.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGE_LABELS, "TaskFinished");
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, "TaskFinished");
                    message.addEventListener(MouseEvent.CLICK, function ():void
                    {
                        globalFlash.gui.ShowBuilding(global.ui.mCurrentPlayerZone.mStreetDataMap.getTaskBuildings_vector()[0]);
                    });
                    break;
                case AVATAR_MESSAGE_TYPE.ADDED_RECIPE:
                    message.image.source = gAssetManager.GetBuffIcon((data as String));
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
                    break;
                default:
                    message.messageBody.text = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGES, _messageType);
            };
            if (sound == "")
            {
                sound = "Message";
            };
            cSoundManager.getInstance().playEffect(sound, soundExtension);
            if (message.headlineLabel.text == "[undefined text]")
            {
                message.headlineLabel.text = _messageType;
            };
            if (((globalFlash.gui.mChatPanel) && (globalFlash.gui.mChatPanel.IsConnectionEstablished())))
            {
                globalFlash.gui.mChatPanel.PutMessageToChannelWithoutServer("news", new Date(), "System", message.messageBody.text, false, false);
            };
        }

        public function IsMessageInList(_arg_1:String):Boolean
        {
            var _local_2:Array;
            var _local_3:String;
            var _local_4:AvatarMessageItemRenderer;
            for each (_local_2 in this.preInitMessages)
            {
                if (_local_2[0] == _arg_1)
                {
                    return (true);
                };
            };
            _local_3 = cLocaManager.GetInstance().GetText(LOCA_GROUP.MESSAGE_LABELS, _arg_1);
            for each (_local_4 in this.mMessageList.getChildren())
            {
                if (((_local_4.visible) && (_local_4.headlineLabel.text == _local_3)))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function Init(_arg_1:AvatarMessageList):void
        {
            this.mGI = (global.ui as cGameInterface);
            AddBaseElement(_arg_1);
            this.mMessageList = _arg_1;
            this.mClientMessages = this.mMessageList;
        }

        public function AddStarIfNeeded(_arg_1:cSpecialist, _arg_2:Bitmap):Bitmap
        {
            var _local_3:cSkill;
            var _local_4:Bitmap;
            var _local_5:Point;
            for each (_local_3 in _arg_1.skills.getItems_vector())
            {
                if (!_local_3.isTrait())
                {
                    _local_4 = gAssetManager.GetBitmap("SmallIconStar");
                    _local_5 = new Point(((_arg_2.bitmapData.width - _local_4.bitmapData.width) - 3), 6);
                    _arg_2 = gAssetManager.AddIconToImage(_arg_2, _local_4, _local_5);
                    break;
                };
            };
            return (_arg_2);
        }

        private function handleAchievementFinishedClickEventListener(_arg_1:Event):void
        {
            var _local_2:AvatarMessageItemRenderer = (_arg_1.currentTarget as AvatarMessageItemRenderer);
            _local_2.removeEventListener(MouseEvent.CLICK, this.handleAchievementFinishedClickEventListener);
            ApplicationFacade.sendNotification(AchievementConsts.SHOW_HIDE_ACHIEVEMENT_PANEL);
            ApplicationFacade.sendNotification(AchievementConsts.CATEGORY_CONTAINER_SELECTED, 0);
        }

        private function getIcon(_arg_1:String):Object
        {
            var _local_2:Object = gAssetManager.GetGfx(_arg_1);
            if (_local_2 == gAssetManager.dummy)
            {
                _local_2 = gAssetManager.GetGfx((_arg_1 + ".png"));
            };
            if (_local_2 == gAssetManager.dummy)
            {
                _local_2 = gAssetManager.GetClass(_arg_1);
            };
            return (_local_2);
        }

        private function handleMoreAchievementsFinishedClickEventListener(_arg_1:Event):void
        {
            var _local_2:AvatarMessageItemRenderer = (_arg_1.currentTarget as AvatarMessageItemRenderer);
            _local_2.removeEventListener(MouseEvent.CLICK, this.handleMoreAchievementsFinishedClickEventListener);
            var _local_3:UserAchievement = (_local_2.getData() as UserAchievement);
            if (((!(_local_3 == null)) && (!(_local_3.getAchievementVO() == null))))
            {
                ApplicationFacade.sendNotification(AchievementConsts.SHOW_ACHIEVEMENT, _local_3.getAchievementVO().getCategoryID(), _local_3.getAchievementVO().getAchievementID().toString());
            };
        }

        public function AddResourceMessage(_arg_1:String, _arg_2:String, _arg_3:Object=null, _arg_4:Boolean=false):void
        {
            if (_arg_4)
            {
                return;
            };
            if (_arg_1 != defines.POPULATION_RESOURCE_NAME_string)
            {
                this.AddMessage(_arg_2, _arg_3);
            }
            else
            {
                if (_arg_2 == AVATAR_MESSAGE_TYPE.USED_RESOURCE_BUFF_LIMIT_REACHED)
                {
                    this.AddMessage(AVATAR_MESSAGE_TYPE.USED_POPULATION_BUFF_LIMIT_REACHED, _arg_3);
                }
                else
                {
                    this.AddMessage(AVATAR_MESSAGE_TYPE.USED_POPULATION_RESOURCE_BUFF, _arg_3);
                };
            };
        }


    }
}
