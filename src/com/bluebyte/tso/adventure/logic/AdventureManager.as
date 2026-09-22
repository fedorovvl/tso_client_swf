package com.bluebyte.tso.adventure.logic
{
    import flash.utils.Timer;
    import __AS3__.vec.Vector;
    import Communication.VO.UpdateVO.dAdventureClientInfoVO;
    import flash.events.TimerEvent;
    import AdventureSystem.cAdventureDefinition;
    import Communication.VO.ColonyVO;
    import AdventureSystem.cAdventure;
    import com.bluebyte.tso.util.TimeUtil;
    import Colony.cColony;
    import Enums.COMMAND;
    import Communication.VO.dIntegerVO;
    import Enums.AVATAR_MESSAGE_TYPE;
    import BuffSystem.cBuff;
    import __AS3__.vec.*;

    public class AdventureManager 
    {

        private static var instance:AdventureManager;
        public static const ZONE_TICK_TIMER_DURATION:int = (1000 * 10);//10000

        private var joinedAdventures:int;
        private var isMyCoopAdventureRunning:Boolean = false;
        private var mIsScoutingForPvP:Boolean = false;
        private var isFriendsCoopAdventureRunning:Boolean = false;
        private var pendingJoinedAdventures:int = 0;
        private var startedAdventures:int;
        private var adventureTicker:Timer;
        private var adventure_vector:Vector.<dAdventureClientInfoVO> = new Vector.<dAdventureClientInfoVO>();
        private var mLastRemovedAdventure:dAdventureClientInfoVO = null;
        private var timedout_adventure_vector:Vector.<dAdventureClientInfoVO> = new Vector.<dAdventureClientInfoVO>();
        private var pendingStartedAdventures:int = 0;

        public function AdventureManager(_arg_1:SingletonEnforcer)
        {
            super();
            if (_arg_1 == null)
            {
                throw (new Error("Use getInstance to get an instance of AdventureManager!"));
            };
            this.adventureTicker = new Timer(ZONE_TICK_TIMER_DURATION);
            this.adventureTicker.addEventListener(TimerEvent.TIMER, this.tickAdventureZones);
            this.adventureTicker.start();
        }

        public static function getInstance():AdventureManager
        {
            if (instance == null)
            {
                instance = new AdventureManager(new SingletonEnforcer());
            };
            return (instance);
        }


        private function joinChatRoomIfCoop(_arg_1:String, _arg_2:int, _arg_3:int):void
        {
            if (cAdventureDefinition.FindAdventureDefinition(_arg_1).mMaxPlayers > 1)
            {
                if (_arg_3 == global.ui.mCurrentPlayer.getPlayerID())
                {
                    globalFlash.gui.mChatPanel.joinMyCoopAdventureChatroom(_arg_2);
                }
                else
                {
                    globalFlash.gui.mChatPanel.joinFriendsCoopAdventureChatrom(_arg_2);
                };
            };
        }

        public function increaseStartedAdventuresCount():void
        {
            this.pendingStartedAdventures++;
        }

        private function checkRunningCoopAdventures():void
        {
            var _local_1:dAdventureClientInfoVO;
            var _local_2:cAdventureDefinition;
            this.isMyCoopAdventureRunning = false;
            this.isFriendsCoopAdventureRunning = false;
            for each (_local_1 in this.adventure_vector)
            {
                _local_2 = cAdventureDefinition.FindAdventureDefinition(_local_1.adventureName);
                if (_local_2.mMaxPlayers > 1)
                {
                    if (_local_1.ownerPlayerID == global.ui.mCurrentPlayer.getPlayerID())
                    {
                        this.isMyCoopAdventureRunning = true;
                    }
                    else
                    {
                        this.isFriendsCoopAdventureRunning = true;
                    };
                };
            };
        }

        private function tickAdventureZones(_arg_1:TimerEvent):void
        {
            var _local_4:ColonyVO;
            var _local_5:dAdventureClientInfoVO;
            var _local_6:cAdventureDefinition;
            var _local_7:Number;
            var _local_8:dAdventureClientInfoVO;
            var _local_9:cAdventureDefinition;
            this.timedout_adventure_vector.length = 0;
            var _local_2:int = (this.adventure_vector.length - 1);
            while (_local_2 >= 0)
            {
                _local_5 = this.adventure_vector[_local_2];
                _local_6 = cAdventureDefinition.FindAdventureDefinition(_local_5.adventureName);
                _local_5.collectedTime = (_local_5.collectedTime + ZONE_TICK_TIMER_DURATION);
                _local_7 = (cAdventure.GetAdventureDuration(global.ui, _local_6, (TimeUtil.getServerTime() - _local_5.collectedTime), _local_5.totalDuration) - _local_5.collectedTime);
                if (((((_local_5.colonyStatus == cColony.STATUS_UNDER_PVP_ATTACK) || (_local_5.colonyID == 0)) && (_local_7 <= 0)) && (_local_5.status == cAdventure.STATUS_STARTED)))
                {
                    global.ui.mClientMessages.SendMessagetoServer(COMMAND.PING_ZONE, _local_5.zoneID, null);
                    _local_8 = this.adventure_vector.splice(_local_2, 1)[0];
                    this.timedout_adventure_vector.push(_local_8);
                    if (this.isMyAdventure(_local_8))
                    {
                        this.startedAdventures--;
                    }
                    else
                    {
                        this.joinedAdventures--;
                    };
                };
                this.joinChatRoomIfCoop(_local_5.adventureName, _local_5.zoneID, _local_5.ownerPlayerID);
                _local_2--;
            };
            var _local_3:Date = new Date();
            for each (_local_4 in global.ui.mCurrentPlayerZone.ColonyGetAll())
            {
                _local_9 = cAdventureDefinition.FindAdventureDefinition(_local_4.adventureName);
                if (((_local_4.state == cColony.STATUS_UNDER_PVP_ATTACK) && (_local_3.getTime() >= (_local_4.startTime + _local_9.GetDuration()))))
                {
                    global.ui.mClientMessages.SendMessagetoServer(COMMAND.PING_ZONE, _local_4.currentAdventureId, null);
                    _local_4.state = cColony.STATUS_ASSIGNED;
                    _local_4.defenseCount++;
                };
                if ((((_local_4.state == cColony.STATUS_READY_FOR_DEFENSE_MODE) && (_local_4.ownerPlayerId == global.ui.mCurrentPlayer.getPlayerID())) && (_local_4.ownerPlayerId == global.ui.mCurrentViewedZoneID)))
                {
                    global.ui.mClientMessages.SendMessagetoServer(COMMAND.COLONY_START_DEFENSE_MODE, global.ui.mCurrentViewedZoneID, new dIntegerVO(_local_4.colonyId));
                    globalFlash.gui.mColonyWindow.mPanel.busyOverlay.visible = true;
                    _local_4.state = cColony.STATUS_WAIT_FOR_ASSIGNMENT;
                };
            };
            globalFlash.gui.mTrackedMissionList.Refresh();
            globalFlash.gui.mColonyWindow.Refresh();
            this.checkRunningCoopAdventures();
            if (((!(this.isMyCoopAdventureRunning)) && (globalFlash.gui.mChatPanel.IsMyCoopChatroomOpen())))
            {
                globalFlash.gui.mChatPanel.leaveMyCoopAdventureChatroom();
            };
            if (((!(this.isFriendsCoopAdventureRunning)) && (globalFlash.gui.mChatPanel.IsFriendsCoopChatroomOpen())))
            {
                globalFlash.gui.mChatPanel.leaveFriendsCoopAdventureChatroom();
            };
        }

        public function getStartedAdventuresCount():int
        {
            return (this.startedAdventures + this.pendingStartedAdventures);
        }

        public function isAdventureActive(_arg_1:String):Boolean
        {
            var _local_2:dAdventureClientInfoVO;
            for each (_local_2 in this.adventure_vector)
            {
                if (_local_2.adventureName == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function getJoinedAdventuresCount():int
        {
            return (this.joinedAdventures + this.pendingJoinedAdventures);
        }

        public function SetScoutingForPvP(_arg_1:Boolean):void
        {
            this.mIsScoutingForPvP = _arg_1;
        }

        public function IsScoutingForPvP():Boolean
        {
            return (this.mIsScoutingForPvP);
        }

        public function isMyAdventure(_arg_1:dAdventureClientInfoVO):Boolean
        {
            if (_arg_1.IsColony())
            {
                return ((_arg_1.ownerPlayerID == global.ui.mCurrentPlayer.GetPlayerId()) || (_arg_1.colonyOwnerPlayerId == defines.PVP_USER_ID));
            };
            return (_arg_1.ownerPlayerID == global.ui.mCurrentPlayer.GetPlayerId());
        }

        public function getLastRemovedAdventure():dAdventureClientInfoVO
        {
            return (this.mLastRemovedAdventure);
        }

        public function recountAdventures():void
        {
            var _local_1:dAdventureClientInfoVO;
            this.startedAdventures = 0;
            this.joinedAdventures = 0;
            this.checkRunningCoopAdventures();
            for each (_local_1 in this.adventure_vector)
            {
                if (this.isMyAdventure(_local_1))
                {
                    this.startedAdventures++;
                }
                else
                {
                    this.joinedAdventures++;
                };
            };
        }

        public function increaseJoinedAdventuresCount():void
        {
            this.pendingJoinedAdventures++;
        }

        public function getAdventureZoneIdForColony(_arg_1:int):int
        {
            var _local_3:dAdventureClientInfoVO;
            var _local_2:int = (this.adventure_vector.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = this.adventure_vector[_local_2];
                if (_local_3.colonyID == _arg_1)
                {
                    return (_local_3.zoneID);
                };
                _local_2--;
            };
            return (defines.INVALID_USER_ID);
        }

        public function enoughColonySlots():Boolean
        {
            var _local_2:ColonyVO;
            var _local_1:Vector.<ColonyVO> = global.ui.mCurrentPlayerZone.ColonyGetAll();
            if (_local_1.length >= (defines.MAX_NUM_COLONY_SLOTS + 1))
            {
                return (false);
            };
            if (_local_1.length == defines.MAX_NUM_COLONY_SLOTS)
            {
                for each (_local_2 in _local_1)
                {
                    if (_local_2.state != cColony.STATUS_ASSIGNED)
                    {
                        return (true);
                    };
                };
            };
            return (true);
        }

        public function getWaitingColonies():ColonyVO
        {
            var _local_1:ColonyVO;
            for each (_local_1 in global.ui.mCurrentPlayerZone.ColonyGetAll())
            {
                if (cColony.IsAssignableState(_local_1.state))
                {
                    return (_local_1);
                };
            };
            return (null);
        }

        public function getAdventures():Vector.<dAdventureClientInfoVO>
        {
            return (this.adventure_vector);
        }

        public function getTimedoutAdventure(_arg_1:int):dAdventureClientInfoVO
        {
            var _local_2:dAdventureClientInfoVO;
            for each (_local_2 in this.timedout_adventure_vector)
            {
                if (_local_2.zoneID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function setAdventures(_arg_1:Vector.<dAdventureClientInfoVO>):void
        {
            if (_arg_1)
            {
                this.adventure_vector = _arg_1;
            }
            else
            {
                this.adventure_vector.length = 0;
            };
            this.recountAdventures();
        }

        public function decreaseStartedAdventuresCount():void
        {
            if (this.pendingStartedAdventures > 0)
            {
                this.pendingStartedAdventures--;
            };
        }

        public function setAdventureState(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:int;
            while (_local_3 < this.adventure_vector.length)
            {
                if (this.adventure_vector[_local_3].zoneID == _arg_1)
                {
                    this.adventure_vector[_local_3].status = _arg_2;
                    return (true);
                };
                _local_3++;
            };
            return (false);
        }

        public function removeAdventure(_arg_1:int):void
        {
            var _local_3:dAdventureClientInfoVO;
            var _local_4:cAdventureDefinition;
            var _local_2:int;
            while (_local_2 < this.adventure_vector.length)
            {
                if (this.adventure_vector[_local_2].zoneID == _arg_1)
                {
                    _local_3 = this.adventure_vector.splice(_local_2, 1)[0];
                    _local_4 = cAdventureDefinition.FindAdventureDefinition(_local_3.adventureName);
                    this.mLastRemovedAdventure = _local_3;
                    if (_local_4.IsUsingAdventureSpecificBuffs())
                    {
                        this.removeAdventureBuffs(_local_4);
                    };
                    if (this.isMyAdventure(_local_3))
                    {
                        this.startedAdventures--;
                    }
                    else
                    {
                        this.joinedAdventures--;
                    };
                    if (_local_4.mMaxPlayers > 1)
                    {
                        if (_local_3.ownerPlayerID != global.ui.mCurrentPlayer.getPlayerID())
                        {
                            globalFlash.gui.mChatPanel.leaveFriendsCoopAdventureChatroom();
                        }
                        else
                        {
                            globalFlash.gui.mChatPanel.leaveMyCoopAdventureChatroom();
                        };
                    };
                    return;
                };
                _local_2++;
            };
        }

        public function addAdventure(_arg_1:dAdventureClientInfoVO):void
        {
            if (this.getAdventure(_arg_1.zoneID) != null)
            {
                return;
            };
            var _local_2:cAdventureDefinition = cAdventureDefinition.FindAdventureDefinition(_arg_1.adventureName);
            var _local_3:String = (((((_local_2.IsExpedition()) || (_local_2.IsPvE())) || (_local_2.IsPvP())) || (_local_2.IsColony())) ? AVATAR_MESSAGE_TYPE.EXPEDITION_STARTED : AVATAR_MESSAGE_TYPE.ADVENTURE_STARTED);
            if (((!(_local_2.IsColony())) || (!(_arg_1.colonyStatus == cColony.STATUS_WAIT_FOR_ASSIGNMENT))))
            {
                globalFlash.gui.mAvatarMessageList.AddMessage(_local_3, _arg_1);
            };
            if (this.isMyAdventure(_arg_1))
            {
                if (this.pendingStartedAdventures > 0)
                {
                    this.pendingStartedAdventures--;
                    this.startedAdventures++;
                };
            }
            else
            {
                if (this.pendingJoinedAdventures > 0)
                {
                    this.pendingJoinedAdventures--;
                    if (_arg_1.status != cAdventure.STATUS_FINISHED_LOST)
                    {
                        this.joinedAdventures++;
                    };
                };
            };
            if (_arg_1.status != cAdventure.STATUS_FINISHED_LOST)
            {
                this.adventure_vector.push(_arg_1);
            };
            _arg_1.isTrackedMission = true;
            globalFlash.gui.mQuestBook.SendTrackedMissionList(true);
        }

        public function getAdventureForColony(_arg_1:int):dAdventureClientInfoVO
        {
            var _local_3:dAdventureClientInfoVO;
            var _local_2:int = (this.adventure_vector.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = this.adventure_vector[_local_2];
                if (_local_3.colonyID == _arg_1)
                {
                    return (_local_3);
                };
                _local_2--;
            };
            return (null);
        }

        public function getAdventure(_arg_1:int):dAdventureClientInfoVO
        {
            var _local_2:dAdventureClientInfoVO;
            for each (_local_2 in this.adventure_vector)
            {
                if (_local_2.zoneID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        private function removeAdventureBuffs(_arg_1:cAdventureDefinition):void
        {
            var _local_2:cBuff;
            var _local_3:int;
            while (_local_3 < global.ui.mCurrentPlayer.mAvailableBuffs_vector.length)
            {
                _local_2 = global.ui.mCurrentPlayer.mAvailableBuffs_vector[_local_3];
                if (_arg_1.GetConnectedBuffGroup() == _local_2.GetBuffDefinition().GetGroup_string())
                {
                    global.ui.mCurrentPlayer.removeBuffFromVector(_local_2.GetUniqueId());
                    _local_3--;
                };
                _local_3++;
            };
            globalFlash.gui.mTimedProductionInfoPanel.Hide();
        }

        public function getColony(_arg_1:int):ColonyVO
        {
            return (global.ui.mCurrentPlayerZone.ColonyGet(_arg_1));
        }

        public function getTravelableAdventures():Vector.<dAdventureClientInfoVO>
        {
            var _local_2:dAdventureClientInfoVO;
            var _local_1:Vector.<dAdventureClientInfoVO> = new Vector.<dAdventureClientInfoVO>();
            for each (_local_2 in this.adventure_vector)
            {
                if (!cAdventureDefinition.FindAdventureDefinition(_local_2.adventureName).IsPreventTravel())
                {
                    _local_1.push(_local_2);
                };
            };
            return (_local_1);
        }

        public function decreaseJoinedAdventuresCount():void
        {
            if (this.pendingJoinedAdventures > 0)
            {
                this.pendingJoinedAdventures--;
            };
        }


    }
}//package com.bluebyte.tso.adventure.logic

class SingletonEnforcer 
{

    public function SingletonEnforcer()
    {
        super();
    }

}


