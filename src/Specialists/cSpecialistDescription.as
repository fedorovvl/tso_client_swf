package Specialists
{
    import __AS3__.vec.Vector;
    import Communication.VO.Skill.SkillVO;
    import Enums.SPECIALIST_TYPE;

    public class cSpecialistDescription 
    {

        private var mManaRescue:int;
        private var mSkillType_string:String;
        private var mBaseType:int;
        private var mAdventureMapLimitCount:int = 0;
        private var mTraits_vector:Vector.<SkillVO>;
        private var mType:int;
        private var mCanAttack:Boolean = true;
        private var mManaOnKill:int;
        private var mManaRescueCap:int;
        private var mTimeOverwriteRecover:int = -1;
        private var mTimeBonus:int = 0;
        private var mGarrisonName_string:String;
        private var mName_string:String;
        private var mMilitaryUnitType_string:String;
        private var mDiceBonus:int;
        private var mUseHomeZoneLandingFieldsOnly:Boolean;
        private var mSpeed:int = 3;
        private var mManaOnDeath:int;
        private var mSortIndex:int;
        private var mTimeOverwriteTravelFromZone:int = -1;
        private var mSpecialIconRequiresEvent_string:String;
        private var mRecruitable:Boolean;
        private var mTimeOverwriteTravelToZone:int = -1;
        private var mMaxUnits:int;


        public static function CompareBySortIndex(_arg_1:cSpecialist, _arg_2:cSpecialist):int
        {
            var _local_3:int = _arg_1.GetSortIndex();
            var _local_4:int = _arg_2.GetSortIndex();
            if (_local_3 > _local_4)
            {
                return (1);
            };
            if (_local_3 < _local_4)
            {
                return (-1);
            };
            return (0);
        }


        public function getManaRescueCap():int
        {
            return (this.mManaRescueCap);
        }

        public function setMilitaryUnitType_string(_arg_1:String):void
        {
            this.mMilitaryUnitType_string = _arg_1;
        }

        public function setSpeed(_arg_1:int):void
        {
            this.mSpeed = _arg_1;
        }

        public function setManaOnKill(_arg_1:int):void
        {
            this.mManaOnKill = _arg_1;
        }

        public function getName_string():String
        {
            return (this.mName_string);
        }

        public function setTimeBonus(_arg_1:int):void
        {
            this.mTimeBonus = _arg_1;
        }

        public function isRecoveryBuffApplicable():Boolean
        {
            return ((this.isGeneral()) || (this.isAdmiral()));
        }

        public function getTraits():Vector.<SkillVO>
        {
            return (this.mTraits_vector);
        }

        public function getBaseType():int
        {
            return (this.mBaseType);
        }

        public function GetDiceBonus():int
        {
            return (this.mDiceBonus);
        }

        public function setSkillType_string(_arg_1:String):void
        {
            this.mSkillType_string = _arg_1;
        }

        public function setuseHomeZoneLandingFieldsOnly(_arg_1:Boolean):void
        {
            this.mUseHomeZoneLandingFieldsOnly = _arg_1;
        }

        public function setBaseType(_arg_1:int):void
        {
            this.mBaseType = _arg_1;
        }

        public function isCanAttack():Boolean
        {
            return (this.mCanAttack);
        }

        public function isAdmiral():Boolean
        {
            return (this.mBaseType == SPECIALIST_TYPE.ADMIRAL);
        }

        public function GetAdventureMapLimitCount():int
        {
            return (this.mAdventureMapLimitCount);
        }

        public function GetSortIndex():int
        {
            return (this.mSortIndex);
        }

        public function SetAdventureMapLimitCount(_arg_1:int):void
        {
            this.mAdventureMapLimitCount = _arg_1;
        }

        public function isUsingHomeZoneLandingFieldsOnly():Boolean
        {
            return (this.mUseHomeZoneLandingFieldsOnly);
        }

        public function GetTimeOverwriteTravelToZone():int
        {
            return (this.mTimeOverwriteTravelToZone);
        }

        public function setSpecialIconRequiresEvent_string(_arg_1:String):void
        {
            if ("" != _arg_1)
            {
                this.mSpecialIconRequiresEvent_string = _arg_1;
            };
        }

        public function getManaOnDeath():int
        {
            return (this.mManaOnDeath);
        }

        public function setTraits_vector(_arg_1:Vector.<SkillVO>):void
        {
            this.mTraits_vector = _arg_1;
        }

        public function isGeneral():Boolean
        {
            switch (this.mBaseType)
            {
                case SPECIALIST_TYPE.GENERAL:
                case SPECIALIST_TYPE.TRANSPORTER_GENERAL:
                    return (true);
            };
            return (false);
        }

        public function toString():String
        {
            return (((("<SpecialistDescription type='" + this.mType) + "', name='") + this.mName_string) + "' />");
        }

        public function setManaRescueCap(_arg_1:int):void
        {
            this.mManaRescueCap = _arg_1;
        }

        public function GetTimeOverwriteTravelFromZone():int
        {
            return (this.mTimeOverwriteTravelFromZone);
        }

        public function setDiceBonus(_arg_1:int):void
        {
            this.mDiceBonus = _arg_1;
        }

        public function setgarrisonName_string(_arg_1:String):void
        {
            this.mGarrisonName_string = _arg_1;
        }

        public function setName_string(_arg_1:String):void
        {
            this.mName_string = _arg_1;
        }

        public function GetType():int
        {
            return (this.mType);
        }

        public function getSpeed():int
        {
            return (this.mSpeed);
        }

        public function setSortIndex(_arg_1:int):void
        {
            this.mSortIndex = _arg_1;
        }

        public function GetTimeOverwriteRecover():int
        {
            return (this.mTimeOverwriteRecover);
        }

        public function setTimeOverwriteTravelToZone(_arg_1:int):void
        {
            this.mTimeOverwriteTravelToZone = _arg_1;
        }

        public function GetMilitaryUnitType_string():String
        {
            return (this.mMilitaryUnitType_string);
        }

        public function getManaRescue():int
        {
            return (this.mManaRescue);
        }

        public function setType(_arg_1:int):void
        {
            this.mType = _arg_1;
        }

        public function GetMaxUnits():int
        {
            return (this.mMaxUnits);
        }

        public function GetTimeBonus():int
        {
            return (this.mTimeBonus);
        }

        public function setTimeOverwriteRecover(_arg_1:int):void
        {
            this.mTimeOverwriteRecover = _arg_1;
        }

        public function setManaOnDeath(_arg_1:int):void
        {
            this.mManaOnDeath = _arg_1;
        }

        public function SetMaxUnits(_arg_1:int):void
        {
            this.mMaxUnits = _arg_1;
        }

        public function isTransportGeneral():Boolean
        {
            return (this.mBaseType == SPECIALIST_TYPE.TRANSPORTER_GENERAL);
        }

        public function setTimeOverwriteTravelFromZone(_arg_1:int):void
        {
            this.mTimeOverwriteTravelFromZone = _arg_1;
        }

        public function setManaRescue(_arg_1:int):void
        {
            this.mManaRescue = _arg_1;
        }

        public function setRecruitable(_arg_1:Boolean):void
        {
            this.mRecruitable = _arg_1;
        }

        public function getSpecialIconRequiresEvent_string():String
        {
            return (this.mSpecialIconRequiresEvent_string);
        }

        public function isUsedFor10MilitaryAmountCalculation():Boolean
        {
            switch (this.mBaseType)
            {
                case SPECIALIST_TYPE.GENERAL:
                case SPECIALIST_TYPE.TRANSPORTER_GENERAL:
                case SPECIALIST_TYPE.TMP_ARMY_TRANSPORTER:
                    return (true);
            };
            return (false);
        }

        public function getGarrisonName_string():String
        {
            return (this.mGarrisonName_string);
        }

        public function IsRecruitable():Boolean
        {
            return (this.mRecruitable);
        }

        public function setCanAttack(_arg_1:Boolean):void
        {
            this.mCanAttack = _arg_1;
        }

        public function getManaOnKill():int
        {
            return (this.mManaOnKill);
        }

        public function GetSkillType_string():String
        {
            return (this.mSkillType_string);
        }


    }
}
