package Enums
{
    import nLib.cStringIntDictionary;
    import __AS3__.vec.Vector;
    import nLib.gMisc;
    import Specialists.cSpecialist;
    import __AS3__.vec.*;

    public class SPECIALIST_TYPE 
    {

        public static const GENERAL:int = 0;
        public static const EXPLORER:int = 1;
        public static const GEOLOGIST:int = 2;
        public static const MASTER_GENERAL:int = 3;
        public static const MASTER_EXPLORER:int = 4;
        public static const MASTER_GEOLOGIST:int = 5;
        public static const TMP_ARMY_TRANSPORTER:int = 6;
        public static const HALLOWEEN_GENERAL:int = 7;
        public static const RETAIL_GENERAL:int = 8;
        public static const EASTER_GENERAL:int = 9;
        public static const EASTER_EXPLORER:int = 10;
        public static const RETAIL_2_GENERAL:int = 11;
        public static const TRANSPORTER_GENERAL:int = 12;
        public static const MAJOR_GENERAL:int = 13;
        public static const STAR_1_GENERAL:int = 14;
        public static const STAR_2_GENERAL:int = 15;
        public static const STAR_3_GENERAL:int = 16;
        public static const LUCKY_EXPLORER:int = 17;
        public static const ADMIRAL:int = 18;
        public static const TRANSPORTER_ADMIRAL:int = 19;
        public static const EXPERT_ADMIRAL:int = 20;
        public static const EXPERT_TRANSPORTER_ADMIRAL:int = 21;
        public static const ADDITIONAL_ADMIRAL_SHOP:int = 22;
        public static const EASTER_2015_TRANSPORTER_ADMIRAL:int = 23;
        public static const BLACK_MARSHAL:int = 24;
        public static const LORD_DRACUL:int = 25;
        public static const SANTA_GENERAL:int = 27;
        public static const INTREPID_EXPLORER:int = 28;
        public static const GENERAL_VARGUS:int = 29;
        public static const GENERAL_ANSLEM:int = 30;
        public static const GENERAL_NUSALA:int = 31;
        public static const CORAGEOUS_EXPLORER:int = 32;
        public static const GENERAL_MARY:int = 33;
        private static var mSpecialistTypeDictionary:cStringIntDictionary = new cStringIntDictionary();
        private static var mSpecialistType_vector:Vector.<String> = new Vector.<String>();


        public static function toString(_arg_1:int):String
        {
            if (((_arg_1 >= 0) && (_arg_1 < mSpecialistType_vector.length)))
            {
                return (mSpecialistType_vector[_arg_1]);
            };
            return (("<unknown Type " + _arg_1) + ">");
        }

        public static function isNameValid(_arg_1:String):Boolean
        {
            var _local_2:int = mSpecialistTypeDictionary.Get(_arg_1);
            return (!(_local_2 == defines.ILLEGAL_INT_POS));
        }

        public static function parse(_arg_1:String):int
        {
            var _local_2:int = mSpecialistTypeDictionary.Get(_arg_1);
            gMisc.Assert((!(_local_2 == defines.ILLEGAL_INT_POS)), (("Could not interpret '" + _arg_1) + "' for a specialist string!"));
            return (_local_2);
        }

        public static function IsGeneral(_arg_1:int):Boolean
        {
            return (cSpecialist.GetSpecialistDescriptionForType(_arg_1).isGeneral());
        }

        public static function IsAdmiral(_arg_1:int):Boolean
        {
            return (cSpecialist.GetSpecialistDescriptionForType(_arg_1).isAdmiral());
        }

        public static function IsGeneralOrAdmiral(_arg_1:int):Boolean
        {
            return ((IsGeneral(_arg_1)) || (IsAdmiral(_arg_1)));
        }

        public static function AddToSpecialistTypeDictionary(_arg_1:String):void
        {
            mSpecialistTypeDictionary.Put(_arg_1, mSpecialistType_vector.length);
            mSpecialistType_vector.push(_arg_1);
        }


    }
}
