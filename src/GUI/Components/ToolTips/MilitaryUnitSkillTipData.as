package GUI.Components.ToolTips
{
    import mx.collections.ArrayCollection;

    public class MilitaryUnitSkillTipData 
    {

        public var skills:ArrayCollection;
        public var modifiers:ArrayCollection;

        public function MilitaryUnitSkillTipData(_arg_1:ArrayCollection, _arg_2:ArrayCollection)
        {
            super();
            this.modifiers = _arg_1;
            this.skills = _arg_2;
        }

    }
}
