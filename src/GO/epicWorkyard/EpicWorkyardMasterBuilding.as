package GO.epicWorkyard
{
    import GO.cBuilding;
    import BuffSystem.cBuff;
    import __AS3__.vec.Vector;
    import Interface.cGeneralInterface;
    import EpicWorkyard.EpicWorkyardsManager;
    import Communication.VO.epicWorkyard.PositionVO;
    import Utils.Pair;
    import Communication.VO.dUniqueID;
    import Communication.VO.dBuildingVO;
    import Tracks.TrackManager;
    import nLib.gMisc;
    import __AS3__.vec.*;

    public class EpicWorkyardMasterBuilding extends cBuilding 
    {

        private var waitingForServerResponse:Boolean;
        private var subBuildingGridPositions:Array;
        private var buff:cBuff;
        private var subBuildings:Vector.<EpicWorkyardSubBuilding>;
        private var shouldRenderSmokeEffect:Boolean;

        public function EpicWorkyardMasterBuilding(_arg_1:cGeneralInterface, _arg_2:int)
        {
            super(_arg_1, _arg_2);
            this.subBuildings = new Vector.<EpicWorkyardSubBuilding>();
            this.updateProductionActive();
        }

        override public function SetProductionActive(_arg_1:Boolean):void
        {
            SetIsProductionActive(_arg_1);
            mDirtyIndicator.strongModified();
            SetIsWaitForCommand(false);
        }

        override public function IsMovable():Boolean
        {
            return ((!(this.waitingForServerResponse)) && (super.IsMovable()));
        }

        public function forceUpdateRenderSmoke():void
        {
            this.shouldRenderSmokeEffect = ((IsProductionActive()) && (cSettingsManager.getInstance().showSmoke));
        }

        private function calculateOffsetGrid(_arg_1:Number, _arg_2:Number):int
        {
            var _local_3:Number = (mXNotScaled + (_arg_1 * global.streetGridX));
            var _local_4:Number = (mYNotScaled + (_arg_2 * global.streetGridYHalf));
            return (gCalculations.ConvertPixelPosToStreetGridPos(mGeneralInterface.mCurrentPlayerZone, int(_local_3), int(_local_4)));
        }

        public function updateProductionActive():void
        {
            var _local_2:EpicWorkyardSubBuilding;
            var _local_1:Boolean;
            for each (_local_2 in this.subBuildings)
            {
                if (_local_2.IsProductionActive())
                {
                    _local_1 = true;
                    break;
                };
            };
            this.SetProductionActive(_local_1);
            this.forceUpdateRenderSmoke();
        }

        public function setWaitingForServerResponse(_arg_1:Boolean):void
        {
            this.waitingForServerResponse = _arg_1;
        }

        override public function GetResourceCreationBuildingName_string():String
        {
            return (EpicWorkyardsManager.getInstance().getResourceCreationBuildingNameForMasterBuilding(mBuildingName_string));
        }

        public function getSubBuildings():Vector.<EpicWorkyardSubBuilding>
        {
            return (this.subBuildings);
        }

        override public function IsBuffable():Boolean
        {
            return (false);
        }

        override protected function renderProductionActive(_arg_1:int, _arg_2:int):void
        {
            if (((IsProductionActive()) && (this.getShouldComputeSmokeEffect())))
            {
                renderSmokeEffect(_arg_1, _arg_2);
            };
        }

        public function invalidateSubBuildingGridPositions():void
        {
            this.subBuildingGridPositions = null;
        }

        private function createSubBuildingGridPositions():void
        {
            var _local_1:PositionVO;
            if (this.subBuildingGridPositions == null)
            {
                this.subBuildingGridPositions = [];
                for each (_local_1 in this.getSubBuildingPositions())
                {
                    this.subBuildingGridPositions.push(new Pair(this.calculateOffsetGrid(_local_1.getX(), _local_1.getY()), _local_1));
                };
            };
        }

        public function removeSubBuilding(_arg_1:EpicWorkyardSubBuilding):int
        {
            var _local_2:int = this.subBuildings.indexOf(_arg_1);
            if (_local_2 >= 0)
            {
                _arg_1.setMasterBuilding(null);
                this.subBuildings.splice(_local_2, 1);
                this.updateProductionActive();
                this.UpdatedProductionState();
                _arg_1.productionBuff = null;
            };
            return (_local_2);
        }

        override public function getShouldComputeSmokeEffect():Boolean
        {
            this.forceUpdateRenderSmoke();
            return (this.shouldRenderSmokeEffect);
        }

        override public function InitFromVO(_arg_1:dBuildingVO):void
        {
            super.InitFromVO(_arg_1);
            if (productionBuff != null)
            {
                this.buff = new cBuff(productionBuff.GetBuffDefinition(), new dUniqueID(), 1);
            };
        }

        override public function AddBuff(_arg_1:cBuff, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            var _local_5:EpicWorkyardSubBuilding;
            super.AddBuff(_arg_1, _arg_2, _arg_3, _arg_4);
            this.buff = _arg_1;
            for each (_local_5 in this.subBuildings)
            {
                _local_5.AddBuff(_arg_1, _arg_2, _local_5.GetGrid(), _arg_4);
            };
            TrackManager.getInstance().trackEpicWorkyardBuffed(mPlayerData, mBuildingName_string, _arg_1.GetBuffDefinition().GetName_string());
        }

        public function getWaitingForServerResponse():Boolean
        {
            return (this.waitingForServerResponse);
        }

        override public function handleBuildingDeconstructed():void
        {
            var _local_1:EpicWorkyardSubBuilding;
            super.handleBuildingDeconstructed();
            while (this.subBuildings.length > 0)
            {
                _local_1 = this.subBuildings[0];
                mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.DeconstructBuildingGridPos(_local_1.GetGrid());
                this.removeSubBuilding(_local_1);
                _local_1.removeBuilding(true);
            };
        }

        public function addSubBuilding(_arg_1:EpicWorkyardSubBuilding, _arg_2:int):int
        {
            var _local_3:int;
            if (_arg_2 < 0)
            {
                this.subBuildings.push(_arg_1);
                _local_3 = this.subBuildings.length;
            }
            else
            {
                this.subBuildings.splice(_arg_2, 0, _arg_1);
                _local_3 = (_arg_2 + 1);
            };
            _arg_1.setMasterBuilding(this);
            if (productionBuff != null)
            {
                _arg_1.AddBuff2(productionBuff, productionBuff.GetApplicanceMode(), _arg_1.GetGrid(), 0);
            };
            this.updateProductionActive();
            this.UpdatedProductionState();
            return (_local_3);
        }

        private function getSubBuildingPositions():Vector.<PositionVO>
        {
            return (EpicWorkyardsManager.getInstance().getSubBuildingPositions(mBuildingName_string));
        }

        public function bindSubBuildings():void
        {
            var _local_1:Pair;
            var _local_2:cBuilding;
            var _local_3:EpicWorkyardSubBuilding;
            this.createSubBuildingGridPositions();
            for each (_local_1 in this.subBuildingGridPositions)
            {
                _local_2 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get((_local_1.getLeft() as int));
                if (((!(_local_2 == null)) && (_local_2 is EpicWorkyardSubBuilding)))
                {
                    _local_3 = (_local_2 as EpicWorkyardSubBuilding);
                    this.addSubBuilding(_local_3, -1);
                    _local_3.setEpicWorkyardPosition((_local_1.getRight() as PositionVO));
                };
            };
        }

        override public function UpdatedProductionState():void
        {
        }

        public function getAvailableSubBuildingGridPosition():int
        {
            var _local_1:Pair;
            var _local_2:cBuilding;
            this.createSubBuildingGridPositions();
            for each (_local_1 in this.subBuildingGridPositions)
            {
                _local_2 = mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mBuildingContainer.get((_local_1.getLeft() as int));
                if (_local_2 == null)
                {
                    return (gMisc.ObjectToInt(_local_1.getLeft()));
                };
            };
            return (-1);
        }


    }
}
