package Model.Notifiers
{
    import GO.cGO;
    import BuffSystem.cBuff;

    public class BuffAppliedNotification 
    {

        public var target:cGO;
        public var buff:cBuff;
        public var amount:int;
        public var buffTargetOwnerID:int;
        public var buffOwnerID:int;

        public function BuffAppliedNotification(_arg_1:cBuff, _arg_2:cGO, _arg_3:int, _arg_4:int)
        {
            super();
            this.buff = _arg_1;
            this.target = _arg_2;
            this.amount = ((_arg_3 > 0) ? _arg_3 : 1);
            this.buffOwnerID = _arg_4;
        }

    }
}
