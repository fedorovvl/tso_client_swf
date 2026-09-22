package Specialists
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class cSpecialistTaskDefinition 
    {

        public var taskName_string:String;
        public var headstart:int;
        public var specialistType_string:String;
        public var subtasks_vector:Vector.<cSpecialistSubTaskDefinition>;

        public function cSpecialistTaskDefinition(_arg_1:String, _arg_2:String, _arg_3:int)
        {
            super();
            this.taskName_string = _arg_1;
            this.specialistType_string = _arg_2;
            this.headstart = _arg_3;
            this.subtasks_vector = new Vector.<cSpecialistSubTaskDefinition>();
        }

    }
}
