package GO
{
    import Interface.cGeneralInterface;
    import Enums.OBJECTTYPE;

    public class cGuiIcon extends cGO 
    {

        public function cGuiIcon(_arg_1:cGeneralInterface)
        {
            super(_arg_1);
        }

        public static function CreateFromString(_arg_1:String, _arg_2:cGeneralInterface):cGuiIcon
        {
            var _local_3:int = global.guiIconGroup.GetNrFromName(_arg_1);
            var _local_4:cGuiIcon = new cGuiIcon(_arg_2);
            _local_4.InitFromNr(global.guiIconGroup, _local_3);
            _local_4.SetLevelEnumObjectType(OBJECTTYPE.GUIICON);
            return (_local_4);
        }


    }
}
