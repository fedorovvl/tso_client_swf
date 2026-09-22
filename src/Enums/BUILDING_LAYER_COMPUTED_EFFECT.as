package Enums
{
    public class BUILDING_LAYER_COMPUTED_EFFECT 
    {

        public static const NONE:int = 0;
        public static const HOVER:int = 1;
        public static const HOVER_INV:int = 2;
        public static const BOUNCE:int = 3;
        public static const PRODUCTION:int = 4;


        public static function fromString(_arg_1:String):int
        {
            switch (_arg_1)
            {
                case "hover":
                    return (HOVER);
                case "hover-inverted":
                    return (HOVER_INV);
                case "bounce":
                    return (BOUNCE);
                case "production":
                    return (PRODUCTION);
            };
            return (NONE);
        }


    }
}
