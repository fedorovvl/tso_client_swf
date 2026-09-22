package Modifier
{
    import LootTableSystem.cLootTable;
    import __AS3__.vec.Vector;
    import Communication.VO.Skill.SkillVO;

    public interface LootSkillHolder extends Modifieable 
    {

        function applyLootSkills(_arg_1:cLootTable):void;
        function getAppliedSkills_vector():Vector.<SkillVO>;

    }
}
