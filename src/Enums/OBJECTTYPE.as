package Enums
{
    import nLib.gMisc;

    public final class OBJECTTYPE 
    {

        public static const GUIICON:int = 0;
        public static const BACKGROUND:int = 1;
        public static const LANDSCAPE:int = 2;
        public static const STREET:int = 3;
        public static const BUILDING:int = 4;
        public static const ANIMAL:int = 5;
        public static const SETTLER:int = 6;
        public static const DEPOSIT:int = 7;
        public static const UNUSED:int = 9;


        public static function toString(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case GUIICON:
                    return ("GuiIcon");
                case BACKGROUND:
                    return ("Background");
                case LANDSCAPE:
                    return ("Landscape");
                case STREET:
                    return ("Street");
                case BUILDING:
                    return ("Building");
                case ANIMAL:
                    return ("Animal");
                case SETTLER:
                    return ("Settler");
                case DEPOSIT:
                    return ("Deposit");
                default:
                    return ("Unknown: " + _arg_1);
            };
        }

        public static function parse(_arg_1:String):int
        {
            if (_arg_1 == toString(GUIICON))
            {
                return (GUIICON);
            };
            if (_arg_1 == toString(BACKGROUND))
            {
                return (BACKGROUND);
            };
            if (_arg_1 == toString(LANDSCAPE))
            {
                return (LANDSCAPE);
            };
            if (_arg_1 == toString(STREET))
            {
                return (STREET);
            };
            if (_arg_1 == toString(BUILDING))
            {
                return (BUILDING);
            };
            if (_arg_1 == toString(ANIMAL))
            {
                return (ANIMAL);
            };
            if (_arg_1 == toString(SETTLER))
            {
                return (SETTLER);
            };
            if (_arg_1 == toString(DEPOSIT))
            {
                return (DEPOSIT);
            };
            gMisc.Assert(false, (("Could not interpret string '" + _arg_1) + "' for an object type!"));
            return (GUIICON);
        }


    }
}
