package Collections
{
    import flash.events.Event;

    public class CollectionEvent extends Event 
    {

        public static const COLLECTION_RESOURCE_CLICKED:String = "collectionResourceClicked";
        public static const CREATE_COLLECTION:String = "createCollection";
        public static const BUY_COLLECTION:String = "buyCollection";
        public static const INSTANT_FINISH_COLLECTION:String = "instantFinishCollection";
        public static const PICK_UP_COLLECTION:String = "pickUpCollection";

        private var data:Object;

        public function CollectionEvent(_arg_1:String, _arg_2:Object, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this.data = _arg_2;
            super(_arg_1, _arg_3, _arg_4);
        }

        public function getData():Object
        {
            return (this.data);
        }


    }
}
