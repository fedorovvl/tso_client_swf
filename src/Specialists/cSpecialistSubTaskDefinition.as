package Specialists
{
    import __AS3__.vec.Vector;
    import ServerState.dResource;

    public class cSpecialistSubTaskDefinition 
    {

        public var subTaskID:int;
        public var speedUpCosts:int;
        public var costs:Vector.<dResource>;
        public var taskType_string:String;
        public var duration:int;
        public var speedUpFactor:int;
        public var lootTableGroupID:int;
        public var mainTask:cSpecialistTaskDefinition;

        public function cSpecialistSubTaskDefinition(_arg_1:cSpecialistTaskDefinition, _arg_2:int, _arg_3:String, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:Vector.<dResource>)
        {
            super();
            this.mainTask = _arg_1;
            this.subTaskID = _arg_2;
            this.taskType_string = _arg_3;
            this.duration = _arg_4;
            this.lootTableGroupID = _arg_5;
            this.speedUpCosts = _arg_6;
            this.speedUpFactor = _arg_7;
            this.costs = _arg_8;
        }

    }
}
