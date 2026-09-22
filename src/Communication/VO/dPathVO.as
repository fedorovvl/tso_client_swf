package Communication.VO
{
    import mx.collections.ArrayCollection;

    public class dPathVO 
    {

        public var mPath:ArrayCollection = new ArrayCollection();


        public function toString():String
        {
            return (gCalculations.createIntListString("dPathVO", this.mPath));
        }


    }
}
