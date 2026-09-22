package Communication.VO
{
    import nLib.MD5;

    public class dZoneLoginVO 
    {

        public var versionHash:String = MD5.hash(defines.VERSION_NR);
        public var operatingSystem:String = "Windows 10";
        public var userAgent:String = "Chrome";


    }
}
