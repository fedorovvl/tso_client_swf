package GUI.Components
{
    import mx.containers.HBox;

    public class ReversableHBox extends HBox 
    {

        private var wasSwitched:Boolean = false;


        public function reverse(_arg_1:Boolean=true):void
        {
            if (((this.wasSwitched) && (_arg_1)))
            {
                return;
            };
            var _local_2:Array = getChildren();
            var _local_3:int = (numChildren - 1);
            while (_local_3 > 0)
            {
                setChildIndex(_local_2[_local_3], ((numChildren - 1) - _local_3));
                _local_3--;
            };
            this.wasSwitched = true;
        }


    }
}
