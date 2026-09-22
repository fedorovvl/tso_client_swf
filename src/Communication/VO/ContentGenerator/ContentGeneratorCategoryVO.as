package Communication.VO.ContentGenerator
{
    import mx.collections.ArrayCollection;

    public class ContentGeneratorCategoryVO 
    {

        public var name:String;
        public var requiresEvent:String;
        public var backGround:String;
        public var sortIndex:int;
        public var collections:ArrayCollection = new ArrayCollection();
        public var id:int;
        public var partName:String;


        public function Init(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:String, _arg_5:String, _arg_6:ArrayCollection, _arg_7:String):void
        {
            this.id = _arg_1;
            this.name = _arg_2;
            this.sortIndex = _arg_3;
            this.backGround = _arg_4;
            this.requiresEvent = _arg_5;
            this.collections = _arg_6;
            this.partName = _arg_7;
        }


    }
}
