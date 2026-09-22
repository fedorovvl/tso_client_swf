package Communication.VO
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class dSpecialistTask_MoveVO extends dSpecialistTaskVO 
    {

        public var newGarrisonGridIdx:int;
        public var currentGarrisonGridIdx:int;
        public var pathPos:int;


        public function readExternal(_arg_1:IDataInput):void
        {
            this.currentGarrisonGridIdx = _arg_1.readInt();
            this.newGarrisonGridIdx = _arg_1.readInt();
            this.pathPos = _arg_1.readInt();
        }

        public function writeExternal(_arg_1:IDataOutput):void
        {
            _arg_1.writeInt(this.currentGarrisonGridIdx);
            _arg_1.writeInt(this.newGarrisonGridIdx);
            _arg_1.writeInt(this.pathPos);
        }

        override public function toString():String
        {
            return (((((((("<dSpecialistTask_MoveVO " + super.dataString()) + " currentGarrisonGridIdx='") + this.currentGarrisonGridIdx) + " newGarrisonGridIdx='") + this.newGarrisonGridIdx) + " pathPos='") + this.pathPos) + "' />");
        }


    }
}
