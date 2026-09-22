package XpConversion
{
    public class XpConversionCalculator 
    {


        public static function convertXp(_arg_1:int):ConvertedXp
        {
            return (convertXpFrom(defines.XP_CONVERSION_STAR_COIN_string, global.starCoinConversionRate, _arg_1));
        }

        public static function convertXpFrom(_arg_1:String, _arg_2:Number, _arg_3:int):ConvertedXp
        {
            if (((_arg_1 == null) || (_arg_1 == "")))
            {
                return (convertXp(_arg_3));
            };
            var _local_4:ConvertedXp = new ConvertedXp();
            _local_4.resourceName = _arg_1;
            _local_4.amount = (Math.ceil((_arg_2 * _arg_3)) as int);
            return (_local_4);
        }


    }
}
