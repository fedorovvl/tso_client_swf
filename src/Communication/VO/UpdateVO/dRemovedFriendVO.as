package Communication.VO.UpdateVO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dRemovedFriendVO 
    {

        public var removedFriendID:int;
        public var friendRemoverID:int;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.friendRemoverID = _arg_1.readInt();
            this.removedFriendID = _arg_1.readInt();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.friendRemoverID);
            _arg_1.writeInt(this.removedFriendID);
        }

        public function toString():String
        {
            return (((("<dRemovedFriendVO friendRemoverID='" + this.friendRemoverID) + "' removedFriendID='") + this.removedFriendID) + "' />");
        }


    }
}
