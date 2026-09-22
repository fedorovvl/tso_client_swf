package Communication.VO
{
    import Utils.StringUtils;
    import nLib.cXML;
    import Utils.ArrayUtils;
    import AdventureSystem.cAdventureDefinition;

    public class AdventureTargetVO 
    {

        public var campaigns:Array;
        public var names:Array;
        public var themes:Array;
        public var maxTier:int;
        public var types:Array;
        public var minTier:int;


        public static function CreateFromXML(_arg_1:cXML):AdventureTargetVO
        {
            var _local_2:AdventureTargetVO = new (AdventureTargetVO)();
            _local_2.names = StringUtils.split(_arg_1.GetAttributeString_string("name"), ",");
            _local_2.types = StringUtils.split(_arg_1.GetAttributeString_string("type"), ",");
            _local_2.campaigns = StringUtils.split(_arg_1.GetAttributeString_string("campaign"), ",");
            _local_2.themes = StringUtils.split(_arg_1.GetAttributeString_string("theme"), ",");
            _local_2.minTier = _arg_1.GetAttributeInt("minTier", 0);
            _local_2.maxTier = _arg_1.GetAttributeInt("maxTier", int.MAX_VALUE);
            return (_local_2);
        }


        public function isTargetingAdventure(_arg_1:cAdventureDefinition):Boolean
        {
            if (((((((ArrayUtils.contains(this.names, _arg_1.GetName())) || (ArrayUtils.isEmpty(this.names))) && ((ArrayUtils.contains(this.types, _arg_1.GetType_string())) || (ArrayUtils.isEmpty(this.types)))) && ((ArrayUtils.contains(this.themes, _arg_1.GetTheme_string())) || (ArrayUtils.isEmpty(this.themes)))) && ((ArrayUtils.contains(this.campaigns, _arg_1.GetCampaign_string())) || (ArrayUtils.isEmpty(this.campaigns)))) && ((((!(_arg_1.UsesCombatThree())) && (this.minTier <= _arg_1.GetDifficulty())) && (this.maxTier >= _arg_1.GetDifficulty())) || (((_arg_1.UsesCombatThree()) && (this.minTier <= _arg_1.GetDifficultyTier())) && (this.maxTier >= _arg_1.GetDifficultyTier())))))
            {
                return (true);
            };
            return (false);
        }


    }
}
