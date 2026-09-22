package Communication.VO
{
    import ServerOnly.DirtyIndicator;

    public class CooldownVO 
    {

        public var duration:Number;
        public var id:int;
        public var dirtyIndicator:DirtyIndicator = new DirtyIndicator();
        public var starttime:Number;


    }
}
