package GO.buildings
{
    import Interface.cGeneralInterface;

    public class AirshipBuilding extends FloatingBuilding 
    {

        private var lastName_string:String = "";

        public function AirshipBuilding(_arg_1:cGeneralInterface, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:Number, _arg_7:Boolean)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        override public function setSkin(_arg_1:String):void
        {
            this.lastName_string = _arg_1;
            super.setSkin(_arg_1);
        }

        override public function Compute():void
        {
            var _local_1:String;
            super.Compute();
            if (((cSettingsManager.getInstance().airshipSkin > 0) && ((this.mGeneralInterface.IsAdventureZone()) || (this.mGeneralInterface.mCurrentViewedZoneID == this.mGeneralInterface.mCurrentPlayer.getPlayerID()))))
            {
                _local_1 = mGoGroup.GetNameFromNrGOList_string(cSettingsManager.getInstance().airshipSkin);
                if (this.lastName_string != _local_1)
                {
                    super.setSkin(_local_1);
                };
            };
        }


    }
}
