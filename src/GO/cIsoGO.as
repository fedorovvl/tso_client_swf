package GO
{
    import Model.Observer;
    import Model.Notifiers.ZoneChannel;
    import Map.AdditionalDataTSO;
    import Interface.cGeneralInterface;
    import Map.GridPosition;
    import Model.Notifier;

    public class cIsoGO extends cGO implements Observer 
    {

        private var visible:Boolean = true;
        protected var renderSortGrid:int;
        private var notFogged:Boolean = false;
        protected var mGridPosition:int = -1;

        public function cIsoGO(_generalInterface:cGeneralInterface)
        {
            super(_generalInterface);
            try
            {
                mGeneralInterface.channels.ZONE.addPropertyObserver(ZoneChannel.FOG_RECALCULATED, this);
                this.notFogged = (mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData2.get(this.GetGrid(), AdditionalDataTSO.Fog) < 3);
            }
            catch(e:Error)
            {
            };
        }

        public function GetGrid():int
        {
            return (GridPosition.getGridIndex(this.mGridPosition));
        }

        public function SetGrid(_arg_1:int):void
        {
            this.mGridPosition = _arg_1;
            this.renderSortGrid = ((GridPosition.getY(this.GetGrid(), mGeneralInterface.mCurrentPlayerZone.mMapWidth) * 1000) + (this.GetGrid() % mGeneralInterface.mCurrentPlayerZone.mMapWidth));
            updateRenderPosition();
        }

        public function update(_arg_1:Notifier, _arg_2:String, _arg_3:Object):void
        {
            if (_arg_2 == ZoneChannel.FOG_RECALCULATED)
            {
                this.notFogged = ((!(mGeneralInterface.showFogOfWar)) || (mGeneralInterface.mCurrentPlayerZone.mStreetDataMap.mAdditionalData2.get(this.GetGrid(), AdditionalDataTSO.Fog) < 3));
            };
        }

        public function GetGridRaw():int
        {
            return (this.mGridPosition);
        }

        override public function getRenderSortGrid():int
        {
            return (this.renderSortGrid);
        }

        public function setVisible(_arg_1:Boolean):void
        {
            this.visible = _arg_1;
        }

        override public function isVisibleForRender():Boolean
        {
            return ((this.notFogged) && (this.visible));
        }

        override public function dispose():void
        {
            super.dispose();
            mGeneralInterface.channels.ZONE.removePropertyObserver(ZoneChannel.FOG_RECALCULATED, this);
        }


    }
}
