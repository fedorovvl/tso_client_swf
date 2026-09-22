package Tasks
{
    import Fulfilments.Identity;
    import Fulfilments.IdentityDefinition;
    import Interface.cGeneralInterface;
    import Enums.AVATAR_MESSAGE_TYPE;

    public class Task extends Identity 
    {

        public static const INITIALIZED:int = 0;
        public static const FINISHED:int = 1;
        public static const CLAIMED:int = 2;

        private var state:int;
        public var selected:Boolean = false;

        public function Task(_arg_1:IdentityDefinition, _arg_2:int, _arg_3:cGeneralInterface)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        override public function handleIdentityJustFinished():void
        {
            globalFlash.gui.mAvatarMessageList.AddMessage(AVATAR_MESSAGE_TYPE.TASK_FINISHED);
            this.setState(FINISHED);
            gi.channels.TASK_MANAGER.taskFinished(this.getId());
        }

        public function getState():int
        {
            return (this.state);
        }

        override public function reward():void
        {
        }

        public function setState(_arg_1:int):void
        {
            this.state = _arg_1;
        }


    }
}
