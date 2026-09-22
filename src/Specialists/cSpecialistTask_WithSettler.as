package Specialists
{
    import GO.cSettler;
    import PathFinding.cPathObject;
    import Interface.cGeneralInterface;
    import SettlerKI.cSettlerAI_WalkToTarget;
    import Communication.VO.dPersistedBuffApplianceVO;
    import BuffSystem.cBuffDefinition;

    public class cSpecialistTask_WithSettler extends cSpecialistTask 
    {

        public static const TASK_START_WITH_SETTLER:String = "taskstartwithsettler";

        private const defaultSkin:String = "General";

        public var speed:Number = 3;
        public var nonAttackSpeed:Number = speed;
        private var mDestinationPathPos:int = 0;
        protected var mSettler:cSettler = null;
        private var customSkin:String = "General";
        private var mDestinationPath:cPathObject;

        public function cSpecialistTask_WithSettler(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:cSpecialist, _arg_4:int, _arg_5:int)
        {
            super(_arg_1, _arg_2, 0, _arg_3, _arg_4, _arg_5);
            this.setAllSpeed(_arg_3.GetSpecialistDescription().getSpeed());
            _arg_3.notifyPropertyObserver(TASK_START, this);
            _arg_3.notifyPropertyObserver(TASK_START_WITH_SETTLER, this);
        }

        public function RemoveSettler():void
        {
            if (this.mSettler == null)
            {
                return;
            };
            (this.mSettler.mSettlerKi as cSettlerAI_WalkToTarget).DeactivateKI();
            this.mSettler = null;
        }

        public function SetPathPos(_arg_1:int):void
        {
            this.mDestinationPathPos = _arg_1;
        }

        public function setCustomSkin(_arg_1:String):void
        {
            this.customSkin = _arg_1;
        }

        public function IncPathPos(_arg_1:int):void
        {
            var _local_3:dPersistedBuffApplianceVO;
            var _local_2:Number = this.speed;
            for each (_local_3 in mGeneralInterface.mZoneBuffManager.getBuffNameStartsWith_vector("GeneralSpeed"))
            {
                _local_2 = (_local_2 * ((100 + cBuffDefinition.GetById(_local_3.buffID).getUpgradeLevel()) / 100));
            };
            if (this.mSettler != null)
            {
                this.mSettler.currentGeneralSpeed = _local_2;
            };
            this.mDestinationPathPos = (this.mDestinationPathPos + int((_arg_1 * _local_2)));
        }

        override protected function SetTaskPhase(_arg_1:int):void
        {
            super.SetTaskPhase(_arg_1);
            this.CheckSettler();
        }

        public function GetPathPos():int
        {
            return (this.mDestinationPathPos);
        }

        public function setAllSpeed(_arg_1:Number):void
        {
            this.speed = (this.nonAttackSpeed = _arg_1);
        }

        protected function SpawnSettler(_arg_1:int, _arg_2:int):void
        {
            this.mSettler = mGeneralInterface.mCurrentPlayerZone.mSettlerKIManager.SpawnSettler(this, _arg_1, _arg_2, this.customSkin);
        }

        override protected function NextPhase():void
        {
            super.NextPhase();
            this.CheckSettler();
        }

        protected function SetDestinationPath(_arg_1:cPathObject):void
        {
            this.mDestinationPath = _arg_1;
        }

        protected function GetSettler():cSettler
        {
            return (this.mSettler);
        }

        public function GetSettlerGridIndex():int
        {
            if (this.mSettler == null)
            {
                return (-1);
            };
            return (gCalculations.ConvertPixelPosToStreetGridPos(mGeneralInterface.mCurrentPlayerZone, this.mSettler.GetXInt(), this.mSettler.GetYInt()));
        }

        public function GetDestinationPath():cPathObject
        {
            return (this.mDestinationPath);
        }

        protected function CheckSettler():void
        {
        }


    }
}
