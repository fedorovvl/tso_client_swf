package AdventureSystem
{
    import Modifier.Modifieable;
    import __AS3__.vec.Vector;
    import Communication.VO.Skill.SkillVO;
    import Modifier.ModifierVO;
    import Modifier.Modifier;
    import __AS3__.vec.*;

    public class ModifiableXP implements Modifieable 
    {

        public static var USE_LOOT_XP:String = "USE_LOOT_XP";

        public var appliedSkills_vector:Vector.<SkillVO>;
        public var xp:int;
        private var owner:Modifieable;

        public function ModifiableXP(_arg_1:int, _arg_2:Modifieable)
        {
            super();
            this.xp = _arg_1;
            this.owner = _arg_2;
            this.appliedSkills_vector = new Vector.<SkillVO>();
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            if (this.owner != null)
            {
                return (this.owner.isModifierApplyable(_arg_1));
            };
            return (true);
        }

        public function setModified(_arg_1:Modifier):void
        {
            if ((((!(_arg_1 == null)) && (!(_arg_1.ownerSkill == null))) && (!(_arg_1.ownerSkill.isTrait()))))
            {
                this.appliedSkills_vector.push(_arg_1.ownerSkill.getVO());
            };
        }

        public function isModified():Boolean
        {
            return (this.appliedSkills_vector.length > 0);
        }


    }
}
