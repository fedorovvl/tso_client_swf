package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dClientDateVO 
    {

        public var mRefreshQuestList_vector:ArrayCollection = new ArrayCollection();
        public var hoursTilNextDailyLoginDay:int;
        public var orginalServerDate:Number;
        public var fakeServerDate:Number;
        public var currentTimeOffsetDailyLogin:int;


    }
}
