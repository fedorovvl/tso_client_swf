package AdventureSystem
{
    import Model.Notifier;
    import Modifier.LootSkillHolder;
    import __AS3__.vec.Vector;
    import Communication.VO.Skill.SkillVO;
    import Enums.CHANNELS;
    import Interface.cGeneralInterface;
    import Modifier.ModifierVO;
    import Modifier.Modifier;
    import LootTableSystem.cLootTable;
    import __AS3__.vec.*;

    public class AdventureLootMediator extends Notifier implements LootSkillHolder 
    {

        private var appliedSkills_vector:Vector.<SkillVO> = new Vector.<SkillVO>();
        private var modified:Boolean = false;
        private var adventure:cAdventureDefinition;

        public function AdventureLootMediator(_arg_1:cGeneralInterface)
        {
            super();
            mapTo(_arg_1.channels.CHANNEL_MAP, CHANNELS.ADVENTURE);
        }

        public function isModified():Boolean
        {
            return (this.modified);
        }

        public function isModifierApplyable(_arg_1:ModifierVO):Boolean
        {
            if (_arg_1.type_string.length > 0)
            {
                return (this.adventure.GetName() == _arg_1.type_string);
            };
            return (false);
        }

        public function applyXPSkills(_arg_1:int):int
        {
            var _local_3:SkillVO;
            var _local_2:ModifiableXP = new ModifiableXP(_arg_1, this);
            notifyPropertyObserver(ModifiableXP.USE_LOOT_XP, _local_2);
            for each (_local_3 in _local_2.appliedSkills_vector)
            {
                this.appliedSkills_vector.push(_local_3);
            };
            this.setModified(null);
            return (_local_2.xp);
        }

        public function setModified(_arg_1:Modifier):void
        {
            if (_arg_1 != null)
            {
                this.appliedSkills_vector.push(_arg_1.ownerSkill.getVO());
            };
        }

        public function setAdventure(_arg_1:cAdventureDefinition):void
        {
            this.adventure = _arg_1;
        }

        public function applyLootSkills(_arg_1:cLootTable):void
        {
            var _local_2:SkillVO;
            _arg_1.temporaryOwner = this;
            notifyPropertyObserver(cLootTable.USE_LOOTTABLE, _arg_1);
            _arg_1.temporaryOwner = null;
            for each (_local_2 in _arg_1.appliedSkills_vector)
            {
                this.appliedSkills_vector.push(_local_2);
            };
            this.setModified(null);
        }

        public function getAppliedSkills_vector():Vector.<SkillVO>
        {
            return (this.appliedSkills_vector);
        }

        public function GetSortValue():Number
        {
            return (0);
        }

        override public function dispose():void
        {
            super.dispose();
            this.appliedSkills_vector = null;
            this.adventure = null;
        }


    }
}
