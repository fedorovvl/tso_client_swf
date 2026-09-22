package Communication.VO
{
    public class dQuestDefinitionRewardVO 
    {

        public var type:int;
        public var name_string:String;
        public var amount:int;


        public function toString():String
        {
            return (((((("<dQuestDefinitionRewardVO type='" + this.type) + "' name_string='") + this.name_string) + "' amount='") + this.amount) + "/>\n");
        }

        public function Clone():dQuestDefinitionRewardVO
        {
            var _local_1:dQuestDefinitionRewardVO = new dQuestDefinitionRewardVO();
            _local_1.type = this.type;
            _local_1.name_string = this.name_string;
            _local_1.amount = this.amount;
            return (_local_1);
        }


    }
}
