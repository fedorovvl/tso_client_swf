package BuffSystem
{
    public final class BuffTargetGroup 
    {

        public var targets:Object;
        public var name_string:String;

        public function BuffTargetGroup(_arg_1:String, _arg_2:Object)
        {
            super();
            this.targets = _arg_2;
            this.name_string = _arg_1;
        }

        public function contains(_arg_1:String):Boolean
        {
            return (!(this.targets[_arg_1] == null));
        }


    }
}
