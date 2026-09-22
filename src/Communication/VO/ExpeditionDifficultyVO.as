package Communication.VO
{
    import mx.collections.ArrayCollection;
    import Utils.StringUtils;

    public class ExpeditionDifficultyVO 
    {

        public var difficultyData:ArrayCollection = new ArrayCollection();
        public var bossBuildingName:ArrayCollection = new ArrayCollection();


        public static function Create():ExpeditionDifficultyVO
        {
            return (new (ExpeditionDifficultyVO)());
        }


        public function toString():String
        {
            return ("<ExpeditionDifficultyVO />");
        }

        public function GetDifficultyData(_arg_1:int):ExpeditionDifficultyDataVO
        {
            var _local_2:ExpeditionDifficultyDataVO;
            for each (_local_2 in this.difficultyData)
            {
                if (_local_2.difficulty == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function BossBuildingNameExists(_arg_1:String):Boolean
        {
            var _local_2:String;
            if (!StringUtils.isNullOrEmpty(_arg_1))
            {
                for each (_local_2 in this.bossBuildingName)
                {
                    if (StringUtils.equalsIgnoreCase(_arg_1, _local_2))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }


    }
}
