package GO
{
    import Interface.cGeneralInterface;
    import Enums.OBJECTTYPE;

    public class cBackground extends cGO 
    {

        public function cBackground(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
        }

        public static function CreateFromString(_arg_1:String, _arg_2:cGeneralInterface):cBackground
        {
            var _local_3:int = global.backgroundGroup.GetNrFromName(_arg_1);
            var _local_4:cBackground = new cBackground(_arg_2);
            _local_4.InitFromNr(global.backgroundGroup, _local_3);
            _local_4.SetLevelEnumObjectType(OBJECTTYPE.BACKGROUND);
            return (_local_4);
        }


    }
}
