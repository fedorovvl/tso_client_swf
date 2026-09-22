package Fulfilments
{
    import Utils.Disposable;

    public class CategoryDefinition implements Disposable 
    {

        private var parentID:int = 0;
        private var name:String;
        private var mainCategory:Boolean = false;
        private var id:int;

        public function CategoryDefinition(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:Boolean)
        {
            super();
            this.id = _arg_1;
            this.name = _arg_2;
            this.parentID = _arg_3;
            this.mainCategory = _arg_4;
        }

        public function getName():String
        {
            return (this.name);
        }

        public function getParentID():int
        {
            return (this.parentID);
        }

        public function isMainCategory():Boolean
        {
            return (this.mainCategory);
        }

        public function getId():int
        {
            return (this.id);
        }

        public function dispose():void
        {
            this.name = null;
        }


    }
}
