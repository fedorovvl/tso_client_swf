package SettlerKI
{
    import Specialists.cSpecialistTask_WithSettler;
    import GO.cSettler;
    import Communication.VO.dPersistedBuffApplianceVO;
    import BuffSystem.cBuffDefinition;
    import Enums.TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT;
    import Enums.SPECIALIST_TASK_TYPES;
    import Enums.TASK_PHASES_ATTACK_BUILDING;
    import PathFinding.dPathObjectItem;
    import nLib.gMisc;

    public class cSettlerAI_WalkToTarget extends cSettlerKI 
    {

        private var generalTask:cSpecialistTask_WithSettler;

        public function cSettlerAI_WalkToTarget(_arg_1:cSettler)
        {
            super(_arg_1);
        }

        public function SetGeneralTask(_arg_1:cSpecialistTask_WithSettler):void
        {
            this.generalTask = _arg_1;
            mState = SETTLER_STATE_WALKING_ON_PATH;
        }

        private function WalkOnPath():void
        {
            var _local_1:int;
            var _local_5:dPersistedBuffApplianceVO;
            var _local_2:int = this.generalTask.GetPathPos();
            var _local_3:Number = (mSettler.mGeneralInterface.GetClientTime() - mSettler.mGeneralInterface.mLastGameTickRefreshClientTime);
            var _local_4:Number = this.generalTask.speed;
            for each (_local_5 in mSettler.mGeneralInterface.mZoneBuffManager.getBuffNameStartsWith_vector("GeneralSpeed"))
            {
                _local_4 = (_local_4 * ((100 + cBuffDefinition.GetById(_local_5.buffID).getUpgradeLevel()) / 100));
            };
            if (mSettler != null)
            {
                mSettler.currentGeneralSpeed = _local_4;
            };
            _local_2 = (_local_2 + (_local_3 * _local_4));
            var _local_6:Number = _local_2;
            _local_6 = (_local_6 / defines.INT_SCALE_FACTOR);
            var _local_7:Number = this.generalTask.GetDestinationPath().dest_vector.length;
            if (_local_7 <= 0)
            {
                return;
            };
            if ((((this.generalTask.GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING) && ((this.generalTask.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.ATTACK_TARGET) || (this.generalTask.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.WAIT_AT_TARGET))) || ((this.generalTask.GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT) && (((this.generalTask.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.ATTACK_TARGET) || (this.generalTask.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.BEGIN_ATTACK)) || (this.generalTask.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING_NEW_COMBAT.WAIT_AT_TARGET)))))
            {
                mVisible = false;
            };
            var _local_8:int = int(_local_6);
            if (_local_8 >= _local_7)
            {
                _local_8 = int((((_local_7 * 2) - 1) - _local_8));
                _local_1 = (_local_8 - 1);
                if (((((this.generalTask.GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING) || (this.generalTask.GetType() == SPECIALIST_TASK_TYPES.ATTACK_BUILDING_NEW_COMBAT)) && (this.generalTask.GetTaskPhase() == TASK_PHASES_ATTACK_BUILDING.GO_TO_TARGET)) || (this.generalTask.GetType() == SPECIALIST_TASK_TYPES.MOVE)))
                {
                    mVisible = false;
                };
            }
            else
            {
                _local_1 = (_local_8 + 1);
            };
            _local_6 = (_local_6 % 1);
            if (_local_1 < 0)
            {
                _local_1 = 0;
                mVisible = false;
            }
            else
            {
                if (_local_1 >= _local_7)
                {
                    _local_1 = int((_local_7 - 1));
                    mVisible = false;
                };
            };
            if (_local_8 < 0)
            {
                _local_8 = 0;
            }
            else
            {
                if (_local_8 >= _local_7)
                {
                    _local_8 = int((_local_7 - 1));
                };
            };
            var _local_9:dPathObjectItem = (this.generalTask.GetDestinationPath().dest_vector[_local_8] as dPathObjectItem);
            var _local_10:dPathObjectItem = (this.generalTask.GetDestinationPath().dest_vector[_local_1] as dPathObjectItem);
            mSettlerPos.x = ((_local_6 * (_local_10.x - _local_9.x)) + _local_9.x);
            mSettlerPos.y = ((_local_6 * (_local_10.y - _local_9.y)) + _local_9.y);
            mSettlerPos.y = (mSettlerPos.y - global.streetGridYHalf);
            var _local_11:int = Get4DirectionFromXY((_local_10.x - _local_9.x), (_local_10.y - _local_9.y));
            mSettler.SetSubType(_local_11);
            if (mAnimate)
            {
                mSettler.Animate();
            };
        }

        override public function Compute():void
        {
            mVisible = true;
            switch (mState)
            {
                case SETTLER_STATE_WALKING_ON_PATH:
                case SETTLER_STATE_ATTACKING:
                    mSettlerPos.x = mSettler.GetX();
                    mSettlerPos.y = mSettler.GetY();
                    this.WalkOnPath();
                    break;
                case SETTLER_STATE_REMOVE_SETTLER:
                    break;
                default:
                    gMisc.Assert(false, ("Could not interpret state " + mState));
            };
            mSettler.SetPosition(int(mSettlerPos.x), int(mSettlerPos.y));
        }

        public function getTask():cSpecialistTask_WithSettler
        {
            return (this.generalTask);
        }


    }
}
