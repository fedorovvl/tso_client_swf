package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dBaseVO 
    {

        public var uniqueID:dUniqueID;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.uniqueID = (_arg_1.readObject() as dUniqueID);
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeObject(this.uniqueID);
        }


    }
}
