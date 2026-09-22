package Communication.VO.Skill
{
    import mx.collections.ArrayCollection;
    import Communication.VO.dUniqueID;

    public final class ChangeSkillsVO 
    {

        public var skills_vector:ArrayCollection = new ArrayCollection();
        public var owner:int;
        public var ownerID:dUniqueID;


        public function toString():String
        {
            return (((((("<ChangeSkillsVO owner=" + this.owner) + " uniqueID=") + this.ownerID.toString()) + " skills_vector=") + this.skills_vector.toString()) + " >");
        }


    }
}
