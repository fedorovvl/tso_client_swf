package Communication.VO.Skill
{
    public class SkillVO 
    {

        public var level:int;
        public var id:int;


        public function toString():String
        {
            return (((("<SkillVO id=" + this.id) + " level=") + this.level) + " >");
        }


    }
}
