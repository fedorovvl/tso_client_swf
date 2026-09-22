package Model.Notifiers
{
    public final class RequirementsChannel extends Channel 
    {


        public function requirementFullfilled(_arg_1:String, _arg_2:String):void
        {
            send(_arg_1, _arg_2);
        }


    }
}
