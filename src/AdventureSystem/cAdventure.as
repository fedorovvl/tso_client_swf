package AdventureSystem
{
    import Model.Notifier;
    import __AS3__.vec.Vector;
    import Communication.VO.UpdateVO.dAdventurePlayerVO;
    import nLib.gMisc;
    import Communication.VO.dAdventureVO;
    import Interface.cGeneralInterface;
    import Utils.StringUtils;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import Communication.VO.dUniqueID;
    import Interface.cGameInterface;
    import Enums.COMMAND;
    import com.bluebyte.tso.adventure.logic.AdventureManager;
    import __AS3__.vec.*;

    public class cAdventure extends Notifier 
    {

        public static const STATUS_INITIALIZED:int = 0;
        public static const STATUS_STARTED:int = 1;
        public static const STATUS_FINISHED_WON:int = 2;
        public static const STATUS_FINISHED_LOST:int = 3;
        public static const TYPE_SCENARIO:String = "Scenario";

        private var mAdmiralCount:int;
        private var mIsDefenseMode:Boolean;
        private var mMapLevel:int;
        private var mDuration:Number;
        private var mOwnerPlayerID:int;
        private var mRandomSeed:int;
        private var mZoneId:int;
        private var mStatus:int = 0;
        private var mIsLookinForHelp:Boolean;
        private var mColonyId:int;
        private var mAdventureDefinition:cAdventureDefinition = null;
        private var mTroopLimit:int;
        private var mStartTime:Number;
        private var mAdventurePlayers_vector:Vector.<dAdventurePlayerVO> = new Vector.<dAdventurePlayerVO>();

        public function cAdventure(_arg_1:int, _arg_2:String, _arg_3:Number, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Boolean, _arg_8:int, _arg_9:int, _arg_10:int, _arg_11:int, _arg_12:int, _arg_13:Boolean)
        {
            super();
            this.mZoneId = _arg_1;
            var _local_14:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_2);
            gMisc.Assert((!(_local_14 == null)), (("Could not init adventure with name '" + _arg_2) + "'!"));
            this.mAdventureDefinition = _local_14;
            this.mStartTime = _arg_3;
            this.mOwnerPlayerID = _arg_6;
            this.mIsLookinForHelp = _arg_7;
            this.mRandomSeed = _arg_8;
            this.mTroopLimit = _arg_9;
            this.mAdmiralCount = _arg_10;
            this.mMapLevel = _arg_11;
            this.mColonyId = _arg_12;
            this.mIsDefenseMode = _arg_13;
            this.mDuration = (_arg_4 + _arg_5);
        }

        public static function IsActiveState(_arg_1:int):Boolean
        {
            return (_arg_1 == cAdventure.STATUS_STARTED);
        }

        public static function CreateFromAdventureVO(_arg_1:dAdventureVO):cAdventure
        {
            var _local_2:cAdventure = new cAdventure(_arg_1.adventureID, _arg_1.adventureDefinitionName, _arg_1.startTime, _arg_1.adventureDuration, _arg_1.serverDownDuration, _arg_1.ownerPlayerID, _arg_1.isLookingForHelp, _arg_1.randomSeed, _arg_1.troopLimit, _arg_1.admiralCount, _arg_1.mapLevel, _arg_1.colonyId, _arg_1.isDefenseMode);
            _local_2.mStatus = _arg_1.state;
            return (_local_2);
        }

        public static function IsWonState(_arg_1:int):Boolean
        {
            return (_arg_1 == cAdventure.STATUS_FINISHED_WON);
        }

        public static function IsLostState(_arg_1:int):Boolean
        {
            return (_arg_1 == cAdventure.STATUS_FINISHED_LOST);
        }

        public static function GetStatusString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case STATUS_INITIALIZED:
                    return ("Initialized");
                case STATUS_STARTED:
                    return ("Started");
                case STATUS_FINISHED_WON:
                    return ("Finished-Won");
                case STATUS_FINISHED_LOST:
                    return ("Finished-Lost");
                default:
                    return ("Unknown adventure status: " + _arg_1);
            };
        }

        public static function IsStartedState(_arg_1:int):Boolean
        {
            return (_arg_1 == STATUS_STARTED);
        }

        public static function IsFinishedState(_arg_1:int):Boolean
        {
            return ((_arg_1 == cAdventure.STATUS_FINISHED_LOST) || (_arg_1 == cAdventure.STATUS_FINISHED_WON));
        }

        public static function GetAdventureDuration(_arg_1:cGeneralInterface, _arg_2:cAdventureDefinition, _arg_3:Number, _arg_4:Number):Number
        {
            if (_arg_2.GetRequiresEvent() == "")
            {
                return (_arg_4);
            };
            return (Math.min(_arg_4, (_arg_1.mEventManager.GetEventStopDate(_arg_2.GetRequiresEvent()) - _arg_3)));
        }


        public function GetCurrentPlayersCount():int
        {
            return (this.mAdventurePlayers_vector.length);
        }

        public function ModifyTroopLimit(_arg_1:int):void
        {
            this.mTroopLimit = Math.max(0, (this.mTroopLimit + _arg_1));
        }

        public function GetOwnerPlayerID():int
        {
            return (this.mOwnerPlayerID);
        }

        public function GetColonyId():int
        {
            return (this.mColonyId);
        }

        public function IsLost():Boolean
        {
            return (IsLostState(this.mStatus));
        }

        public function GetAdventureID():int
        {
            return (this.mZoneId);
        }

        public function SetStartTime(_arg_1:Number):void
        {
            this.mStartTime = _arg_1;
        }

        public function GetName_string():String
        {
            return (this.mAdventureDefinition.mName_string);
        }

        public function IsLookingForHelp():Boolean
        {
            return (this.mIsLookinForHelp);
        }

        public function GetEndTime(_arg_1:cGeneralInterface):Number
        {
            return (this.GetEndTimeCheckingEvent(_arg_1, false));
        }

        public function InviteAdventurePlayer(_arg_1:dAdventurePlayerVO):void
        {
            this.AddAdventurePlayer(_arg_1);
        }

        public function GetStartTime():Number
        {
            return (this.mStartTime);
        }

        public function UpdatePlayerStatus(_arg_1:int, _arg_2:int):void
        {
            var _local_3:dAdventurePlayerVO;
            for each (_local_3 in this.mAdventurePlayers_vector)
            {
                if (_local_3.playerID == _arg_1)
                {
                    _local_3.status = _arg_2;
                    return;
                };
            };
        }

        public function GetZoneId():int
        {
            return (this.mZoneId);
        }

        public function GetAdmiralCount():int
        {
            return (this.mAdmiralCount);
        }

        public function GetStatus():int
        {
            return (this.mStatus);
        }

        public function RemoveAdventurePlayer(_arg_1:int):void
        {
            var _local_3:dAdventurePlayerVO;
            var _local_2:int;
            while (_local_2 < this.mAdventurePlayers_vector.length)
            {
                _local_3 = (this.mAdventurePlayers_vector[_local_2] as dAdventurePlayerVO);
                if (_local_3.playerID == _arg_1)
                {
                    this.mAdventurePlayers_vector.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function GetEndTimeCheckingEvent(_arg_1:cGeneralInterface, _arg_2:Boolean):Number
        {
            if (((StringUtils.isEmpty(this.mAdventureDefinition.GetRequiresEvent())) || (_arg_1.mEventManager.isEventStarted(this.mAdventureDefinition.GetRequiresEvent()))))
            {
                return (this.GetStartTime() + this.GetDuration());
            };
            if (_arg_2)
            {
            };
            return (_arg_1.mEventManager.GetEventStopDate(this.mAdventureDefinition.GetRequiresEvent()));
        }

        public function AddAdventurePlayer(_arg_1:dAdventurePlayerVO):void
        {
            this.mAdventurePlayers_vector.push(_arg_1);
        }

        public function GetRamdomSeed():int
        {
            return (this.mRandomSeed);
        }

        public function SetAdmiralCount(_arg_1:int):void
        {
            this.mAdmiralCount = _arg_1;
        }

        public function SetStatus(_arg_1:int, _arg_2:cGeneralInterface, _arg_3:Boolean):void
        {
            var _local_4:dAdventurePlayerVO;
            var _local_5:dAdventureClientInfoVO;
            if (_arg_1 != this.mStatus)
            {
                this.mStatus = _arg_1;
                if (!_arg_3)
                {
                    if (!this.IsActive())
                    {
                        for each (_local_4 in this.mAdventurePlayers_vector)
                        {
                            _arg_2.mCurrentPlayerZone.SendArmyBackToHomeZone(_local_4.playerID, dUniqueID.Create(-(this.GetZoneId()), -(this.GetZoneId())), false);
                        };
                        (_arg_2 as cGameInterface).forceZonePersistence(COMMAND.SET_ADVENTURE_STATUS);
                    }
                    else
                    {
                        if (this.mStatus == STATUS_STARTED)
                        {
                            _local_5 = AdventureManager.getInstance().getAdventure(_arg_2.mCurrentViewedZoneID);
                            if (this.GetOwnerPlayerID() == _arg_2.mCurrentPlayer.getPlayerID())
                            {
                                globalFlash.gui.mChatPanel.joinMyCoopAdventureChatroom(_arg_2.mCurrentViewedZoneID);
                            }
                            else
                            {
                                globalFlash.gui.mChatPanel.joinFriendsCoopAdventureChatrom(_arg_2.mCurrentViewedZoneID);
                            };
                        };
                    };
                };
            };
        }

        public function GetAdventurePlayers():Vector.<dAdventurePlayerVO>
        {
            return (this.mAdventurePlayers_vector);
        }

        public function IsDefenseMode():Boolean
        {
            return (this.mIsDefenseMode);
        }

        public function IsFinished():Boolean
        {
            return (IsFinishedState(this.GetStatus()));
        }

        public function GetMapLevel():int
        {
            return (this.mMapLevel);
        }

        public function GetTroopLimit():int
        {
            return (this.mTroopLimit);
        }

        public function SendArmyBackToHomeZone(_arg_1:int, _arg_2:int, _arg_3:cGeneralInterface):void
        {
        }

        public function IsColony():Boolean
        {
            return (this.mColonyId > 0);
        }

        public function GetDuration():Number
        {
            return (this.mDuration);
        }

        public function GetMaxPlayersCount():int
        {
            return (this.mAdventureDefinition.mMaxPlayers);
        }

        public function IsWon():Boolean
        {
            return (IsWonState(this.GetStatus()));
        }

        public function GetAdventureDefinition():cAdventureDefinition
        {
            return (this.mAdventureDefinition);
        }

        public function IsActive():Boolean
        {
            return (IsActiveState(this.GetStatus()));
        }

        public function SetTroopLimit(_arg_1:int):void
        {
            this.mTroopLimit = _arg_1;
        }

        public function HasPlayerInAdventure(_arg_1:int):Boolean
        {
            var _local_2:dAdventurePlayerVO;
            for each (_local_2 in this.mAdventurePlayers_vector)
            {
                if (_local_2.playerID == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function GetMode():int
        {
            return (this.GetAdventureDefinition().GetMode());
        }


    }
}
