package Effects.Effects
{
    import Effects.Effect;
    import GO.cBuilding;
    import GO.buildings.cCollectibleBuilding;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ShuffleCollectibles extends Effect 
    {

        public static const XML_string:String = "shufflecollectibles";


        override protected function action():void
        {
            var _local_2:cBuilding;
            var _local_1:Vector.<cCollectibleBuilding> = new Vector.<cCollectibleBuilding>();
            for each (_local_2 in gi.mCurrentPlayerZone.mStreetDataMap.GetBuildings_vector())
            {
                if ((_local_2 is cCollectibleBuilding))
                {
                    _local_1.push((_local_2 as cCollectibleBuilding));
                };
            };
        }


    }
}
