package Communication.VO.ContentGenerator
{
    import mx.collections.ArrayCollection;

    public class ContentGeneratorContentVO 
    {

        public var playerLevel:int;
        public var partAmount:int;
        public var requiresEvent:String;
        public var name:String;
        public var sortIndex:int;
        public var icon:String;
        public var id:int;
        public var partName:String;

        public var loottableItems:ArrayCollection = new ArrayCollection();
        public var costs:ArrayCollection = new ArrayCollection();
        public var rewards:ArrayCollection = new ArrayCollection();


        public function Init(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:String, _arg_5:int, _arg_6:int, _arg_7:String, _arg_8:ArrayCollection, _arg_9:ArrayCollection, _arg_10:ArrayCollection, _arg_11:String):void
        {
            this.id = _arg_1;
            this.name = _arg_2;
            this.sortIndex = _arg_3;
            this.partName = _arg_4;
            this.partAmount = _arg_5;
            this.playerLevel = _arg_6;
            this.icon = _arg_7;
            this.loottableItems = _arg_8;
            this.costs = _arg_9;
            this.rewards = _arg_10;
            this.requiresEvent = _arg_11;
        }


    }
}
